package tatsuyakoyama.tkframework {

    import flash.utils.Dictionary;

    import starling.display.DisplayObject;

    import tatsuyakoyama.tkactor.ScreenFader;
    import tatsuyakoyama.tkutility.TkUtil;

    //------------------------------------------------------------
    public class TkLayerManager {

        private var _layers:Dictionary = new Dictionary;
        private var _displayOrder:Array;
        private var _screenFader:ScreenFader;

        //------------------------------------------------------------
        public function TkLayerManager() {}

        /**
         * displayOrder で指定したレイヤー名の順に奥から並ぶよ
         * 例えば ['back', 'middle', 'front'] を渡すと back レイヤーが一番奥になる
         * そして暗黙で最前面に '_system_' レイヤーが足されるので
         * _system_ という名前は使わないように注意
         */
        public function setUpLayers(scene:TkScene, displayOrder:Array):void {
            displayOrder.push('_system_');
            for each (var layerName:String in displayOrder) {
                _addLayer(scene, layerName);
            }
            _displayOrder = displayOrder;

            _setUpScreenFader();
        }

        //------------------------------------------------------------
        // Fade In/Out Helper
        //------------------------------------------------------------
        private function _setUpScreenFader():void {
            _screenFader = new ScreenFader();
            addActor('_system_', _screenFader);
        }

        public function blackIn (duration:Number=0.33, startAlpha:Number=1):void { _screenFader.blackIn (duration, startAlpha); }
        public function blackOut(duration:Number=0.33, startAlpha:Number=0):void { _screenFader.blackOut(duration, startAlpha); }
        public function whiteIn (duration:Number=0.33, startAlpha:Number=1):void { _screenFader.whiteIn (duration, startAlpha); }
        public function whiteOut(duration:Number=0.33, startAlpha:Number=0):void { _screenFader.whiteOut(duration, startAlpha); }
        public function colorIn (color:uint, duration:Number=0.33, startAlpha:Number=1):void { _screenFader.colorIn (color, duration, startAlpha); }
        public function colorOut(color:uint, duration:Number=0.33, startAlpha:Number=0):void { _screenFader.colorOut(color, duration, startAlpha); }
        //------------------------------------------------------------

        public function dispose():void {
            _removeAllLayers();
        }

        private function _addLayer(scene:TkScene, layerName:String):void {
            var layer:TkLayer = new TkLayer();
            _layers[layerName] = layer;

            layer.layer     = layer
            layer.layerName = layerName;
            scene.addLayer(layer);
            TkUtil.log('+++ addLayer: ' + layerName);
        }

        private function _removeAllLayers():void {
            for (var layerName:String in _layers) {
                _layers[layerName].dispose();
                delete _layers[layerName];
            }
            _displayOrder = new Array(); // clear array
            TkUtil.log('--- removeAllLayers');
        }

        public function addActor(layerName:String, actor:TkActor,
                                 putOnDisplayList:Boolean=true):Boolean {
            if (!_layers[layerName]) {
                TkUtil.log('[Error] layer not found: ' + layerName);
                return false;
            }

            _layers[layerName].addActor(actor, putOnDisplayList);
            return true;
        }

        public function addChild(layerName:String, displayObj:DisplayObject):Boolean {
            if (!_layers[layerName]) {
                TkUtil.log('[Error] layer not found: ' + layerName);
                return false;
            }

            _layers[layerName].addChild(displayObj);
            return true;
        }

        public function getLayer(layerName:String):TkLayer {
            if (!_layers[layerName]) {
                TkUtil.log('[Error] layer not found: ' + layerName);
                return null;
            }

            return _layers[layerName];
        }

        public function onUpdate(passedTime:Number):void {
            // update layers in display order
            for each (var layerName:String in _displayOrder) {
                _layers[layerName].onUpdate(passedTime);
            }
        }

        public function setTimeScale(layerName:String, timeScale:Number):Boolean {
            if (!_layers[layerName]) {
                TkUtil.log('[Error] layer not found: ' + layerName);
                return false;
            }

            _layers[layerName].timeScale = timeScale;
            return true;
        }

        public function resetTimeScale(layerName:String):void {
            setTimeScale(layerName, 1);
        }

        //------------------------------------------------------------
        // set enabled utilities
        //------------------------------------------------------------
        /**
         * layer の on/off を行う
         * off にすると時間が進まなくなり、タッチ不能になる。
         * ただし _system_ レイヤーには干渉できない
         */
        public function setEnabled(layerName:String, enabled:Boolean):Boolean {
            if (layerName == '_system_') { return false; }
            if (!_layers[layerName]) {
                TkUtil.log('[Error] layer not found: ' + layerName);
                return false;
            }

            var targetLayer:TkLayer = _layers[layerName];
            if (enabled) {
                targetLayer.timeScale = 1.0;
                targetLayer.touchable = true;
            } else {
                targetLayer.timeScale = 0;
                targetLayer.touchable = false;
            }
            return true;
        }

        public function setEnabledTogether(layerNameList:Array, enabled:Boolean):void {
            for each (var layerName:String in layerNameList) {
                setEnabled(layerName, enabled);
            }
        }

        public function setEnabledOtherThan(excludeLayerNameList:Array, enabled:Boolean):void {
            for each (var layerName:String in _displayOrder) {
                // if the existing layer name is not contained in given layer name list,
                // apply setEnabled.
                if (excludeLayerNameList.indexOf(layerName)) {
                    setEnabled(layerName, enabled);
                }
            }
        }

        public function setAllLayersEnabled(enabled:Boolean):void {
            for each (var layerName:String in _displayOrder) {
                setEnabled(layerName, enabled);
            }
        }
    }
}
