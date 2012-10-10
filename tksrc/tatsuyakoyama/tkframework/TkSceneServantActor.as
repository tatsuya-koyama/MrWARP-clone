package tatsuyakoyama.tkframework {

    import tatsuyakoyama.TkConfig;
    import tatsuyakoyama.tkframework.TkEventType;
    import tatsuyakoyama.tkutility.TkUtil;

    //------------------------------------------------------------
    public class TkSceneServantActor extends TkActor {

        private var _isSystemActivated:Boolean = true;

        //------------------------------------------------------------
        public function get isSystemActivated():Boolean {
            return _isSystemActivated;
        }

        //------------------------------------------------------------
        public override function init():void {
            listen(TkEventType.SYSTEM_ACTIVATE,   _onSystemActivate);
            listen(TkEventType.SYSTEM_DEACTIVATE, _onSystemDeactivate);

            // for debug: set profiling task
            if (TkConfig.WATCH_NUM_ACTOR) {
                addPeriodicTask(1.0, TkProfileData.traceNumActor);
            }
        }

        private function _onSystemActivate(args:Object):void {
            _isSystemActivated = true;
            resumeBgm();
        }

        private function _onSystemDeactivate(args:Object):void {
            _isSystemActivated = false;
            pauseBgm();
        }
    }
}
