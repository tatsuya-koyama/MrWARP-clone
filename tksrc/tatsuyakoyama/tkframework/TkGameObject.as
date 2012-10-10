package tatsuyakoyama.tkframework {

    import flash.media.Sound;
    import flash.utils.Dictionary;

    import starling.display.Image;
    import starling.display.Sprite;

    import tatsuyakoyama.tkframework.collision.TkCollisionShape;
    import tatsuyakoyama.tkutility.TkUtil;

    //------------------------------------------------------------
    public class TkGameObject extends Sprite {

        private var _id:int = 0;
        private var _sharedObj:TkSharedObjects;
        private var _listeningEventTypes:Dictionary = new Dictionary();

        //------------------------------------------------------------
        public function get id():int {
            return _id;
        }

        public function get sharedObj():TkSharedObjects {
            return _sharedObj;
        }

        public function set sharedObj(sharedObj:TkSharedObjects):void {
            _sharedObj = sharedObj;
        }

        //------------------------------------------------------------
        public function TkGameObject() {
            _id = TkIdGenerator.generateId();
            touchable = false;
        }

        public override function dispose():void {
            stopAllListening();
            super.dispose();
        }

        /**
         * この時点で sharedObj がセットされているので
         * resourceManager にアクセスできる
         */
        public function init():void {
            // Override this.
        }

        protected function onDispose():void {
            // Override this.
        }

        public function onUpdate(passedTime:Number):void {
            // Override this.
        }

        //------------------------------------------------------------
        // Shortcut for SharedObj
        //------------------------------------------------------------
        public function getImageFromAtlas(atlasId:String, imageId:String):Image {
            return sharedObj.resourceManager.getImage(atlasId, imageId);
        }

        public function setCollision(groupName:String, shape:TkCollisionShape):void {
            sharedObj.collisionSystem.addShape(groupName, shape);
        }

        public function setTimeScale(layerName:String, timeScale:Number):void {
            sharedObj.layerManager.setTimeScale(layerName, timeScale);
        }

        public function resetTimeScale(layerName:String):void {
            sharedObj.layerManager.resetTimeScale(layerName);
        }

        public function setLayerEnabled(layerNameList:Array, enabled:Boolean):void {
            sharedObj.layerManager.setEnabledTogether(layerNameList, enabled);
        }

        public function setLayerEnabledOtherThan(excludeLayerNameList:Array, enabled:Boolean):void {
            sharedObj.layerManager.setEnabledOtherThan(excludeLayerNameList, enabled);
        }

        public function setAllLayersEnabled(enabled:Boolean):void {
            sharedObj.layerManager.setAllLayersEnabled(enabled);
        }

        public function getLayer(layerName:String):TkLayer {
            return sharedObj.layerManager.getLayer(layerName);
        }

        public function playBgm(bgmId:String):void {
            var bgm:Sound = sharedObj.resourceManager.getSound(bgmId);
            sharedObj.soundPlayer.playBgm(bgm);
        }

        public function pauseBgm():void {
            sharedObj.soundPlayer.pauseBgm();
        }

        public function resumeBgm():void {
            sharedObj.soundPlayer.resumeBgm();
        }

        public function playSe(seId:String):void {
            var se:Sound = sharedObj.resourceManager.getSound(seId);
            sharedObj.soundPlayer.playSe(se);
        }

        public function stopSound():void {
            sharedObj.soundPlayer.stop();
        }

        //------------------------------------------------------------
        // Fade In/Out Helper
        //------------------------------------------------------------
        public function blackIn (duration:Number=0.33, startAlpha:Number=1):void { sharedObj.layerManager.blackIn (duration, startAlpha); }
        public function blackOut(duration:Number=0.33, startAlpha:Number=0):void { sharedObj.layerManager.blackOut(duration, startAlpha); }
        public function whiteIn (duration:Number=0.33, startAlpha:Number=1):void { sharedObj.layerManager.whiteIn (duration, startAlpha); }
        public function whiteOut(duration:Number=0.33, startAlpha:Number=0):void { sharedObj.layerManager.whiteOut(duration, startAlpha); }
        public function colorIn (color:uint, duration:Number=0.33, startAlpha:Number=1):void { sharedObj.layerManager.colorIn (color, duration, startAlpha); }
        public function colorOut(color:uint, duration:Number=0.33, startAlpha:Number=0):void { sharedObj.layerManager.colorOut(color, duration, startAlpha); }

        //------------------------------------------------------------
        // Messaging
        //------------------------------------------------------------
        protected function listen(eventType:String, callback:Function):void {
            sharedObj.notificationService.addListener(
                this, eventType, callback
            );
            _listeningEventTypes[eventType] = true;
        }

        protected function stopListening(eventType:String):void {
            sharedObj.notificationService.removeListener(
                this, eventType
            );
            delete _listeningEventTypes[eventType];
        }

        protected function stopAllListening():void {
            for (var eventType:String in _listeningEventTypes) {
                stopListening(eventType);
            }
        }

        protected function sendMessage(eventType:String, eventArgs:Object=null):void {
            sharedObj.notificationService.postMessage(
                eventType, eventArgs
            );
        }
    }
}
