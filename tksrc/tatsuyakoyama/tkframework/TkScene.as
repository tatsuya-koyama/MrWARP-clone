package tatsuyakoyama.tkframework {

    import starling.display.DisplayObject;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;

    import tatsuyakoyama.tkframework.TkEventType;
    import tatsuyakoyama.tkutility.TkUtil;
    import tatsuyakoyama.tkutility.TkTimeKeeper;

    //------------------------------------------------------------
    public class TkScene extends TkGameObject {

        private var _newActorPool:Array = new Array();
        private var _servantActor:TkSceneServantActor;  // to use multi tasker and so on
        private var _isTimeToExit:Boolean = false;
        private var _hasDisposed:Boolean  = false;

        //------------------------------------------------------------
        public function TkScene() {
            touchable = true;
            addEventListener(Event.ENTER_FRAME, _onEnterFrame);
        }

        public override function dispose():void {
            if (_hasDisposed) { return; }
            _hasDisposed = true;

            removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
            sharedObj.layerManager.dispose();
            sharedObj.collisionSystem.removeAllGroups();
            _newActorPool = [];
            onDispose();
            super.dispose();
        }

        protected function exit():void {
            _isTimeToExit = true;
        }

        public function getNextScene():TkScene {
            // Override this.
            return null;
        }

        public function loadResources():void {
            // Override this.
        }

        public function setUpLayers():void {
            // Override this.
        }

        public function setUpCollisionGroups():void {
            // Override this.
        }

        //------------------------------------------------------------
        public function setUpServantActor():void {
            _servantActor = new TkSceneServantActor();
            setUpActor('_system_', _servantActor);
        }

        protected function act(action:TkAction=null):TkAction {
            return _servantActor.act(action);
        }

        protected function react():void {
            _servantActor.react();
        }

        public function addPeriodicTask(interval:Number, task:Function):void {
            _servantActor.addPeriodicTask(interval, task);
        }

        //------------------------------------------------------------
        /**
         * Entry point of game loop
         */
        private function _onEnterFrame(event:EnterFrameEvent):void {
            if (_hasDisposed) { return; }

            var passedTime:Number = TkTimeKeeper.getReasonablePassedTime(event);

            if (_servantActor.isSystemActivated) {
                // update actors
                onUpdate(passedTime);
                sharedObj.layerManager.onUpdate(passedTime);
                _recruitNewActors();

                // collision detection
                sharedObj.collisionSystem.hitTest();
            }

            // broadcast messages
            sharedObj.notificationService.broadcastMessage();

            if (_isTimeToExit) {
                dispatchEvent(new Event(TkEventType.EXIT_SCENE));
            }
        }

        protected function setUpActor(layerName:String, actor:TkActor,
                                      putOnDisplayList:Boolean=true):void {
            addActor(layerName, actor, putOnDisplayList);
        }

        public function addLayer(layer:TkLayer):void {
            layer.sharedObj = this.sharedObj;
            layer.applyForNewActor = this.applyForNewActor;
            addChild(layer);
        }

        protected function addActor(layerName:String, actor:TkActor,
                                    putOnDisplayList:Boolean=true):void {
            sharedObj.layerManager.addActor(layerName, actor, putOnDisplayList);
        }

        protected function addChildToLayer(layerName:String, displayObj:DisplayObject):void {
            sharedObj.layerManager.addChild(layerName, displayObj);
        }

        /**
         * 新しい Actor を足してもらうよう Scene に頼む
         * この関数は TkActor によって呼ばれる
         * 新しい Actor 達は既存の Actor 達の update の後に layer に足される
         */
        public function applyForNewActor(newActor:TkActor, layerName:String=null):void {
            _newActorPool.push({
                actor: newActor,
                layer: layerName
            });
        }

        private function _recruitNewActors():void {
            var count:int = 0;
            for each (var info:Object in _newActorPool) {
                ++count;
                setUpActor(info.layer, info.actor);
            }
            if (count > 0) {
                _newActorPool = [];
                //TkUtil.log(count + ' new actor joined');
            }
        }
    }
}
