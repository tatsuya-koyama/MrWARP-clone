package mrwarp.actor {

    import flash.display.Bitmap;

    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.display.Image;
    import starling.display.BlendMode;
    import starling.display.Button;

    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkutility.TkUtil;
    import tatsuyakoyama.tkactor.SimpleButton;

    import mrwarp.GameEvent;
    import mrwarp.GameRecord;

    //------------------------------------------------------------
    public class PauseButton extends TkActor {

        private var _button:SimpleButton;

        //------------------------------------------------------------
        public function PauseButton() {
            touchable = true;
        }

        public override function init():void {
            _button = new SimpleButton(_onTouch);
            var image:Image = getImageFromAtlas('atlas-01', 'undo');
            image.touchable = true;
            _button.addImage(image, 30, 30, 320-30, 0, 0, 0);
            addActor(_button);
        }

        protected override function onDispose():void {}

        public override function onUpdate(passedTime:Number):void {}

        private function _onTouch():void {
            if (GameRecord.playerLife <= 0) { return; }

            playSe('open_menu');
            var pauseMenuWindow:PauseMenuWindow = new PauseMenuWindow();
            createActor(pauseMenuWindow, 'l-menu');
            setLayerEnabledOtherThan(['l-menu'], false);

            _button.touchable = true;
        }
    }
}
