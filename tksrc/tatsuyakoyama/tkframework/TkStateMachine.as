package tatsuyakoyama.tkframework {

    import tatsuyakoyama.tkutility.TkUtil;

    //------------------------------------------------------------
    public class TkStateMachine extends TkActor {

        private var _states:Object = new Object();
        private var _currentState:String = null;

        //------------------------------------------------------------
        public function get currentState():String {
            return _currentState;
        }

        //------------------------------------------------------------
        public function TkStateMachine() {}

        /**
         * @param stateTree Example:
         *     {
         *         idle: stateHook1,
         *         attack: {
         *             shoot: {
         *                 rapid: null,
         *                 soft : null
         *             },
         *             tackle: null
         *         },
         *         defense: {
         *             guard: stateHook2,
         *             avoid: null
         *         }
         *     }
         *
         * This method converts given object into a flat dictionary as below:
         *     {
         *         'idle'              : stateHook1
         *         'attack.shoot.rapid': null
         *         'attack.shoot.soft' : null
         *         'attack.tackle'     : null
         *         'defense.guard'     : stateHook2
         *         'defense.avoid'     : null
         *     }
         */
        public function initWithObj(stateTree:Object):void {
            _states = TkUtil.flattenObject(stateTree);
        }

        public function switchState(state:String):void {
            if (!(state in _states)) {
                throw new Error('Undefined state: ' + state);
            }

            // after-hook
            var stateHook:*;
            stateHook = _states[_currentState];
            if (stateHook  &&  stateHook is TkStateHook) {
                stateHook.invokeAfterHooks();
            }

            // change state
            _currentState = state;

            // before-hook
            stateHook = _states[_currentState];
            if (stateHook  &&  stateHook is TkStateHook) {
                stateHook.invokeBeforeHooks();
            }
        }

        /**
         * Return true if given state is current state or belongs to current state group.
         * For example, isState('attack.shoot') returns true when the current state
         * is 'attack.shoot.rapid' or 'attack.shoot.soft'.
         */
        public function isState(state:String):Boolean {
            // _currentState.search(state) == 0 とどっちが速いかは分からん
            var pattern:RegExp = new RegExp('^' + state);
            if (_currentState.match(pattern)) {
                return true;
            }
            return false;
        }
    }
}
