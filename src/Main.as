package {

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.geom.Rectangle;
    import flash.events.Event;

    import starling.core.Starling;

    import mrwarp.GameConst;

    import tatsuyakoyama.TkConfig;
    import tatsuyakoyama.TkNativeStageAccessor;
    import tatsuyakoyama.tkutility.TkUtil;

    /**
     * The entry point of the game.
     */
    //------------------------------------------------------------
    public class Main extends Sprite {

        private var _starling:Starling;

        //------------------------------------------------------------
        public function Main() {
            _initTkFramework();
            _initStarling();
            stage.addEventListener(Event.RESIZE, _onResizeStage);
        }

        private function _initTkFramework():void {
            TkUtil.debugMode         = GameConst.DEBUG_MODE;
            TkConfig.WATCH_NUM_ACTOR = GameConst.PROFILE_MODE;
            TkConfig.FRAME_RATE      = stage.frameRate;
            TkConfig.SCREEN_WIDTH    = GameConst.SCREEN_WIDTH;
            TkConfig.SCREEN_HEIGHT   = GameConst.SCREEN_HEIGHT;
            TkNativeStageAccessor.stage = stage;
        }

        /**
         * Set viewport and start Starling framework.
         */
        private function _initStarling():void {
            // set general properties
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align     = StageAlign.TOP_LEFT;

            Starling.multitouchEnabled = true;  // useful on mobile devices
            Starling.handleLostContext = true;  // required on Android

            // set up Starling
            var viewPort:Rectangle = new Rectangle(
                0, 0, GameConst.SCREEN_WIDTH, GameConst.SCREEN_HEIGHT
            );
            _starling = new Starling(MrWarpGameDirector, stage, viewPort);
            _starling.start();
            _onResizeStage();

            if (GameConst.SHOW_PERFORMANCE) {
                _starling.showStats = true;
            }
        }

        /**
         * Create a suitable viewport for the screen size.
         */
        private function _getViewPort():Rectangle {
            var screenWidth:int    = stage.stageWidth;
            var screenHeight:int   = stage.stageHeight;
            var viewPort:Rectangle = new Rectangle();

            if (screenHeight / screenWidth < GameConst.ASPECT_RATIO) {
                viewPort.height = screenHeight;
                viewPort.width  = int(viewPort.height / GameConst.ASPECT_RATIO);
                viewPort.x = int((screenWidth - viewPort.width) / 2);
            } else {
                viewPort.width  = screenWidth;
                viewPort.height = int(viewPort.width * GameConst.ASPECT_RATIO);
                viewPort.y = int((screenHeight - viewPort.height) / 2);
            }

            trace("stageWidth : " + stage.stageWidth);
            trace("stageHeight: " + stage.stageHeight);
            trace(viewPort);

            return viewPort;
        }

        private function _onResizeStage(event:Event=null):void {
            trace("Resized stage.");
            _starling.viewPort = _getViewPort();
        }
    }

}
