package tatsuyakoyama.tkutility {

    import flash.utils.Dictionary;

    import starling.events.EnterFrameEvent;

    import tatsuyakoyama.TkConfig;

    //------------------------------------------------------------
    public class TkTimeKeeper {

        private var _tasks:Vector.<TkTimeKeeperTask> = new Vector.<TkTimeKeeperTask>();

        //------------------------------------------------------------
        public function addPeriodicTask(interval:Number, task:Function, times:int=-1):void {
            _tasks.push(
                new TkTimeKeeperTask(interval, task, times)
            );
        }

        public function update(passedTime:Number):void {
            for each (var task:TkTimeKeeperTask in _tasks) {
                task.update(passedTime);
            }
        }

        public function dispose():void {
            for each (var task:TkTimeKeeperTask in _tasks) {
                task.dispose();
            }
            _tasks = null;
        }

        /**
         * 基本的には経過時間なんだけど、それだとフレームレートスパイクしたときに
         * キャラがワープするみたいな悲惨なことになるので、一定以上は
         * 単純な処理落ちにするような、ゲーム的に妥当な経過時間 [秒] を返す
         */
        public static function getReasonablePassedTime(event:EnterFrameEvent):Number {
            var originalPassedTime:Number = event.passedTime;
            var acceptableTime:Number = 1.0 / TkConfig.ALLOW_DELAY_FPS;
            if (originalPassedTime > acceptableTime) {
                return acceptableTime;
            }

            // なんだか知らないが、Android でプレイし続けているとごくまれに
            // 経過時間がマイナスになったかのような謎の挙動をすることがあるんだ…
            if (originalPassedTime < 0) { return 0; }

            return originalPassedTime;
        }
    }
}
