package tatsuyakoyama.tkframework {

    public class TkActionInstructor {

        private var _actor:TkActor;
        private var _action:TkAction;
        private var _isAllActionFinished:Boolean = false;

        //------------------------------------------------------------
        public function get actor():TkActor {
            return _actor;
        }

        public function get action():TkAction {
            return _action;
        }

        public function get isAllActionFinished():Boolean {
            return _isAllActionFinished;
        }

        //------------------------------------------------------------
        public function TkActionInstructor(actor:TkActor, action:TkAction) {
            _actor  = actor;
            _action = (action) ? action : new TkAction();
            _action.instructor = this;
        }

        public function update(passedTime:Number):void {
            if (_isAllActionFinished) { return; }

            _action.update(passedTime);
            if (_action.isFinished()) {
                if (!_action.nextAction) {
                    _isAllActionFinished = true;
                    _action = null;
                    return;
                }
                _action = _action.nextAction;
            }
        }
    }
}
