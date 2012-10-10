package tatsuyakoyama.tkframework {

    import flash.utils.Dictionary;

    import tatsuyakoyama.tkutility.TkUtil;

    //------------------------------------------------------------
    public class TkNotificationPublisher {

        private var _eventType:String;
        private var _listeners:Dictionary = new Dictionary();
        private var _listenerCount:int = 0;
        private var _numListener:int = 0;

        //------------------------------------------------------------
        public function get numListener():int {
            return _numListener;
        }

        //------------------------------------------------------------
        public function TkNotificationPublisher(eventType:String='anonymous') {
            _eventType = eventType;
        }

        public function addListener(listener:TkGameObject, callback:Function):void {
            _listeners[listener.id] = callback;
            ++_numListener;
            // TkUtil.log('+++ add listener: [id ' + listener.id + '] '
            //            + _eventType + ' (total ' + _numListener + ')');
        }

        public function removeListener(listener:TkGameObject):Boolean {
            if (!_listeners[listener.id]) {
                TkUtil.log('[Error] Listener is not listening: [id '
                           + listener.id + ']');
                return false;
            }

            delete _listeners[listener.id];
            --_numListener;
            // TkUtil.log('--- remove listener: [id ' + listener.id + '] '
            //            + _eventType + ' (total ' + _numListener + ')');
            return true;
        }

        public function publish(eventArgs:Object):void {
            for each (var callback:Function in _listeners) {
                callback(eventArgs);
            }
        }
    }
}
