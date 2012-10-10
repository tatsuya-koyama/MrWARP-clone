package mrwarp {

    import flash.net.SharedObject;

    /**
     * ローカルに保存するデータ
     */
    public class GamePersistentData {

        public var highScore:uint;

        private var so:SharedObject;

        public function GamePersistentData() {
            so = SharedObject.getLocal("mrwarp_record");
            load();
        }

        public function init():void {
            highScore = 0;
        }

        public function save():void {
            so.data.highScore = highScore;
            so.flush();
        }

        public function load():void {
            if (so.data.highScore == null) {
                init();
                return;
            }

            highScore = so.data.highScore;
        }
    }
}
