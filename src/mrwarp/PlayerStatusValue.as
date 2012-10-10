package mrwarp {

    public class PlayerStatusValue {

        //------------------------------------------------------------
        protected var _level:int = 0;

        public function PlayerStatusValue() {
            reset();
        }

        public function reset():void {
            _level = 0;
        }

        /**
         * override this so that returns upgrade map Array:
         *   [0]: cost (required number of energy particle item)
         *   [1]: actual value
         *   [2]: value that player sees
         */
        protected function _getMap():Array {
            // override this
            return [];
        }

        public function getCost(levelOffset:int=0):Number {
            var level:int = _level + levelOffset;
            var levelMap:Array = _getMap();
            if (level >= levelMap.length) { return NaN; }

            return levelMap[level][0];
        }

        public function getActualValue(levelOffset:int=0):Number {
            var level:int = _level + levelOffset;
            var levelMap:Array = _getMap();
            if (level >= levelMap.length) { return NaN; }

            return levelMap[level][1];
        }

        public function getAspectValue(levelOffset:int=0):Number {
            var level:int = _level + levelOffset;
            var levelMap:Array = _getMap();
            if (level >= levelMap.length) { return NaN; }

            return levelMap[level][2];
        }

        public function levelUp():void {
            var levelMap:Array = _getMap();
            if (_level + 1 >= levelMap.length) { return; }

            ++_level;
        }

        public function isMaxLevel():Boolean {
            var levelMap:Array = _getMap();
            if (_level + 1 >= levelMap.length) { return true; }
            return false;
        }
    }
}
