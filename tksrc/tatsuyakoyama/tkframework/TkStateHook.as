package tatsuyakoyama.tkframework {

    /**
     * state 切り替え時に何か実行したい時用
     */
    //------------------------------------------------------------
    public class TkStateHook {

        private var _beforeHooks:Vector.<Function> = new Vector.<Function>();
        private var _afterHooks :Vector.<Function> = new Vector.<Function>();

        //------------------------------------------------------------
        public function TkStateHook(beforeHook:Function=null) {
            if (beforeHook != null) {
                _beforeHooks.push(beforeHook);
            }
        }

        public function addHook(beforeHook:Function):void {
            _beforeHooks.push(beforeHook);
        }

        public function addAfterHook(afterHook:Function):void {
            _afterHooks.push(afterHook);
        }

        public function invokeBeforeHooks():void {
            for each (var hook:Function in _beforeHooks) {
                hook();
            }
        }

        public function invokeAfterHooks():void {
            for each (var hook:Function in _afterHooks) {
                hook();
            }
        }
    }
}
