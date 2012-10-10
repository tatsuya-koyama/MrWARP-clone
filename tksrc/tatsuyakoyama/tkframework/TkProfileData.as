package tatsuyakoyama.tkframework {

    /**
     * Stashed values for running performace check.
     */
    public class TkProfileData {

        //------------------------------------------------------------
        // watch the number of actors by layer
        //------------------------------------------------------------
        private static var _numLayerActor:Object = {};

        public static function countActor(count:int, layerName:String):void {
            if (!_numLayerActor[layerName]) {
                _numLayerActor[layerName] = 0;
            }
            _numLayerActor[layerName] += count;
        }

        public static function traceNumActor():void {
            trace('vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');

            var total:int = 0;
            for (var layerName:String in _numLayerActor) {
                var num:int = _numLayerActor[layerName];
                if (num) {
                    trace(layerName + ': ' + num);
                }
                total += num;
            }
            trace('total: ' + total);

            trace('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
        }

    }
}
