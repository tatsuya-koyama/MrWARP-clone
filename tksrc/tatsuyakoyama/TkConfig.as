package tatsuyakoyama {

    public class TkConfig {

        // Please customize these values for your game
        // before the framework starts up.

        public static var FRAME_RATE   :int = 30;
        public static var SCREEN_WIDTH :int = 480;
        public static var SCREEN_HEIGHT:int = 320;

        // FPS がどこまで落ちるのを許すか。
        // これ以上の遅れは単純な処理落ちとして扱う
        public static var ALLOW_DELAY_FPS:int = 15;

        // true にすると１秒に１回各 layer の Actor 数をログに吐く
        public static var WATCH_NUM_ACTOR:Boolean = false;
    }
}
