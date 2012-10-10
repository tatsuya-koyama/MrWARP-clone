package tatsuyakoyama.tkframework {

    import starling.display.Sprite;
    import starling.text.TextField;
    import starling.utils.HAlign;
    import starling.utils.VAlign;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;

    import tatsuyakoyama.TkNativeStageAccessor;

    import flash.events.Event;
    import flash.system.System;

    /**
     * Take responsibility for direction of game sequence.
     *   - Switch game scene.
     *   - Call GC on scene transition.
     *   - Pass shared objects to each scene.
     */
    //------------------------------------------------------------
    public class TkGameDirector extends Sprite {

        private var _currentScene:TkScene = null;
        private var _sharedObj:TkSharedObjects = new TkSharedObjects();

        //------------------------------------------------------------
        public function TkGameDirector() {
            addEventListener(starling.events.Event.ENTER_FRAME, onEnterFrame);
            onRegisterGameResources(_sharedObj.resourceManager);
            TkBlendMode.registerExtendedBlendModes();

            TkNativeStageAccessor.stage.addEventListener(flash.events.Event.ACTIVATE,   _onSystemActivate);
            TkNativeStageAccessor.stage.addEventListener(flash.events.Event.DEACTIVATE, _onSystemDeactivate);
        }

        private function _onSystemActivate(event:flash.events.Event=null):void {
            _sharedObj.notificationService.postMessage(
                TkEventType.SYSTEM_ACTIVATE, {}
            );
        }

        private function _onSystemDeactivate(event:flash.events.Event=null):void {
            _sharedObj.notificationService.postMessage(
                TkEventType.SYSTEM_DEACTIVATE, {}
            );
        }

        protected function onEnterFrame(event:EnterFrameEvent):void {
            // Override this.
        }

        protected function onRegisterGameResources(resourceManager:TkResourceManager):void {
            // Override this.
        }

        protected function startScene(scene:TkScene):void {
            _currentScene = scene;
            _initScene(scene);

            addChild(scene);
            _currentScene.addEventListener(TkEventType.EXIT_SCENE, _onExitScene);
        }

        private function _initScene(scene:TkScene):void {
            scene.sharedObj = _sharedObj;
            scene.loadResources();
            scene.setUpLayers();
            scene.setUpServantActor();
            scene.setUpCollisionGroups();
            scene.init();
        }

        private function _onExitScene(event:starling.events.Event):void {
            if (!_currentScene) { return; }

            // call dispose() of derived TkScene class and remove listeners
            _currentScene.dispose();
            removeChild(_currentScene);

            // go on to the next scene
            var nextScene:TkScene = _currentScene.getNextScene();
            startScene(nextScene);

            // call Garbage Collection manually
            System.gc();
        }
    }
}
