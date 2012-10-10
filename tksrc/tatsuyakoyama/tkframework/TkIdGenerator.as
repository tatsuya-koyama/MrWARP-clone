package tatsuyakoyama.tkframework {

    import starling.errors.AbstractClassError;

    public class TkIdGenerator {

        private static var _count:int = 0;

        //------------------------------------------------------------
        public function TkIdGenerator() {
            throw new AbstractClassError();
        }

        public static function generateId():int {
            ++_count;
            if (_count < 1) { _count = 1; }  // consider overflow
            return _count;
        }
    }
}
