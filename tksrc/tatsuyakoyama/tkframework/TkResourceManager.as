package tatsuyakoyama.tkframework {

    import flash.media.Sound;
    import flash.utils.Dictionary;

    import starling.display.Image;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;

    import tatsuyakoyama.tkutility.TkUtil;

    //------------------------------------------------------------
    public class TkResourceManager {

        private var _textureAtlasClassDict   :Dictionary = new Dictionary();
        private var _textureAtlasInstanceDict:Dictionary = new Dictionary();

        private var _soundClassDict   :Dictionary = new Dictionary();
        private var _soundInstanceDict:Dictionary = new Dictionary();

        //------------------------------------------------------------
        public function TkResourceManager() {}

        //------------------------------------------------------------
        // Textures
        //------------------------------------------------------------
        /**
         * @param atlasDataList Example:
         *     [
         *         [textureImg1, textureXml1, 'atlas_01'],
         *         [textureImg2, textureXml2, 'atlas_02'],
         *         ...
         *     ]
         */
        public function registerTextureAtlasList(atlasDataList:Array):void {
            for each (var atlasData:Array in atlasDataList) {
                registerTextureAtlas(atlasData[0], atlasData[1], atlasData[2]);
            }
            debugPrintForTexture();
        }

        public function registerTextureAtlas(atlasTextureClass:Class,
                                             atlasXmlClass:Class,
                                             keyName:String):void {
            if (_textureAtlasClassDict[keyName]) { return; }

            _textureAtlasClassDict[keyName] = {
                atlas_class: atlasTextureClass,
                atlas_xml  : atlasXmlClass
            };
        }

        /**
         * @param keyNameList Example:
         *     ['atlas_01', 'atlas_02', ...]
         */
        public function unregisterTextureAtlasList(keyNameList:Array):void {
            for each (var keyName:String in keyNameList) {
                unregisterTextureAtlas(keyName);
            }
            debugPrintForTexture();
        }

        public function unregisterTextureAtlas(keyName:String):void {
            delete _textureAtlasClassDict[keyName];
        }

        /**
         * @param keyNameList Example:
         *     ['atlas_01', 'atlas_02', ...]
         */
        public function useTextureAtlases(keyNameList:Array):void {
            // dispose texture atlases no longer needs
            for (var existingKeyName:String in _textureAtlasInstanceDict) {
                // If keyNameList does not contain the key,
                // dispose intance associated with the key.
                if (keyNameList.indexOf(existingKeyName)) {
                    _disposeTextureAtlas(existingKeyName);
                }
            }

            // load necessary texture atlases
            for each (var keyName:String in keyNameList) {
                _loadTextureAtlas(keyName);
            }
            debugPrintForTexture();
        }

        private function _loadTextureAtlas(keyName:String):void {
            if (_textureAtlasInstanceDict[keyName]) { return; }  // already loaded
            if (!_textureAtlasClassDict[keyName]) {
                TkUtil.log('[Error] texture atlas ID not found: ' + keyName);
                return;
            }

            var texture:Class = _textureAtlasClassDict[keyName].atlas_class;
            var xml:Class     = _textureAtlasClassDict[keyName].atlas_xml;
            var atlas:TextureAtlas = _makeAtlas(texture, xml);
            _textureAtlasInstanceDict[keyName] = atlas;

            TkUtil.log('+++ loaded atlas: ' + keyName);
        }

        private function _disposeTextureAtlas(keyName:String):void {
            if (!_textureAtlasInstanceDict[keyName]) { return; }  // already disposed

            _textureAtlasInstanceDict[keyName].dispose();
            delete _textureAtlasInstanceDict[keyName];

            TkUtil.log('--- disposed atlas: ' + keyName);
        }

        private function _makeAtlas(textureClass:Class, xmlClass:Class):TextureAtlas {
            // texture will be disposed by TextureAtlas instance
            var texture:Texture = Texture.fromBitmap(new textureClass);
            var xml:XML = XML(new xmlClass());
            var atlas:TextureAtlas = new TextureAtlas(texture, xml);
            return atlas;
        }

        public function getImage(atlasId:String, imageId:String):Image {
            if (!_textureAtlasInstanceDict[atlasId]) {
                TkUtil.log('[Error] texture atlas not found: ' + atlasId);
                return null;
            }

            var atlas:TextureAtlas = _textureAtlasInstanceDict[atlasId];
            var texture:Texture    = atlas.getTexture(imageId);
            var image:Image        = new Image(texture);
            image.touchable = false;
            return image;
        }

        public function debugPrintForTexture():void {
            TkUtil.log('-------------------------------------------', 2);
            TkUtil.log('texture class dictionary:', 2);
            var key:String;
            var elem:Object;
            for (key in _textureAtlasClassDict) {
                elem = _textureAtlasClassDict[key];
                TkUtil.log('    ' + key + ": ["
                           + elem.atlas_class + ", " + elem.atlas_xml + "]", 2);
            }
            TkUtil.log('texture instance dictionary:', 2);
            for (key in _textureAtlasInstanceDict) {
                elem = _textureAtlasInstanceDict[key];
                TkUtil.log('    ' + key + ": " + elem, 2);
            }
            TkUtil.log('-------------------------------------------', 2);
        }

        //------------------------------------------------------------
        // Sounds
        //------------------------------------------------------------
        /**
         * @param atlasDataList Example:
         *     [
         *         [seClass1,  'se_id1'],
         *         [bgmClass1, 'bgm_id1'],
         *         ...
         *     ]
         */
        public function registerSoundClassList(soundDataList:Array):void {
            for each (var soundData:Array in soundDataList) {
                registerSoundClass(soundData[0], soundData[1]);
            }
            debugPrintForSound();
        }

        public function registerSoundClass(soundClass:Class, keyName:String):void {
            if (_soundClassDict[keyName]) { return; }

            _soundClassDict[keyName] = soundClass;
        }

        /**
         * @param keyNameList Example:
         *     ['bgm_01', 'se_01', ...]
         */
        public function useSounds(keyNameList:Array):void {
            // dispose sound instance no longer needs
            for (var existingKeyName:String in _soundInstanceDict) {
                // If keyNameList does not contain the key,
                // dispose intance associated with the key.
                if (keyNameList.indexOf(existingKeyName)) {
                    _disposeSound(existingKeyName);
                }
            }

            // load necessary sounds
            for each (var keyName:String in keyNameList) {
                _loadSound(keyName);
            }
            debugPrintForSound();
        }

        private function _loadSound(keyName:String):void {
            if (_soundInstanceDict[keyName]) { return; }  // already loaded
            if (!_soundClassDict[keyName]) {
                TkUtil.log('[Error] sound ID not found: ' + keyName);
                return;
            }

            // To enable sound instace memory to be releasable,
            // it should be instantiated as a dynamic property. (Maybe)
            _soundInstanceDict[keyName] = new _soundClassDict[keyName];
            TkUtil.log('+++ loaded sound: ' + keyName);
        }

        private function _disposeSound(keyName:String):void {
            if (!_soundInstanceDict[keyName]) { return; }  // already disposed

            delete _soundInstanceDict[keyName];
            TkUtil.log('--- disposed sound: ' + keyName);
        }

        public function getSound(soundId:String):Sound {
            if (!_soundInstanceDict[soundId]) {
                TkUtil.log('[Error] sound not found: ' + soundId);
                return null;
            }

            return _soundInstanceDict[soundId];
        }

        public function debugPrintForSound():void {
            TkUtil.log('-------------------------------------------', 2);
            TkUtil.log('sound class dictionary:', 2);
            var key:String;
            var elem:Object;
            for (key in _soundClassDict) {
                elem = _soundClassDict[key];
                TkUtil.log('    ' + key + ": " + elem, 2);
            }
            TkUtil.log('sound instance dictionary:', 2);
            for (key in _soundInstanceDict) {
                elem = _soundInstanceDict[key];
                TkUtil.log('    ' + key + ": " + elem, 2);
            }
            TkUtil.log('-------------------------------------------', 2);
        }
    }
}
