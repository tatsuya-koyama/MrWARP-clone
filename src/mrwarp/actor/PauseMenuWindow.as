package mrwarp.actor {

    import flash.display.Bitmap;

    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.display.Image;
    import starling.display.Button;
    import starling.text.TextField;

    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkBlendMode;
    import tatsuyakoyama.tkframework.TkEventType;
    import tatsuyakoyama.tkframework.utility.TkTextFactory;
    import tatsuyakoyama.tkactor.TextButton;
    import tatsuyakoyama.tkactor.ScreenCurtain;
    import tatsuyakoyama.tkutility.TkUtil;

    import mrwarp.GameEvent;
    import mrwarp.GameRecord;
    import mrwarp.lib.Snippets;

    //------------------------------------------------------------
    public class PauseMenuWindow extends TkActor {

        private var _menuTray:TkActor = new TkActor();

        //------------------------------------------------------------
        public function PauseMenuWindow() {
            touchable = false;
        }

        public override function init():void {
            // うっかり押しちゃうの防止
            act().wait(0.4).justdoit(0, function():void {
                touchable = true;
            });

            var curtain:ScreenCurtain = new ScreenCurtain();
            curtain.x = -160;
            curtain.y = -240;
            curtain.alpha = 0.8;
            addActor(curtain);

            var image:Image = getImageFromAtlas('atlas-02', 'menu_frame');
            image.touchable = true;
            image.blendMode = TkBlendMode.ADD;
            addImage(image, 320, 480, 0, 0, 0.5, 0.5);

            addActor(_makeTitleLogo());

            _addButtons();

            // fade in animation
            x = 160;
            y = 240;
            scaleX = 1.5;
            scaleY = 1.5;
            alpha  = 0;
            act().scaleToEaseOut(0.25, 1, 1);
            act().alphaTo(0.25, 1);
        }

        private function _makeTitleLogo():TkActor {
            var logo:TkActor = new TkActor();
            var text:TextField = TkTextFactory.makeText(
                320, 80, "Pause", 30, "tk_mincho", 0xbbffbb,
                -160, -40, "center", "center", false
            );
            logo.addText(text);
            logo.x = 0;
            logo.y = -150;
            return logo;
        }

        private function _addButtons():void {
            _menuTray.touchable = true;
            addActor(_menuTray);

            var resumeButton:TextButton = Snippets.makeMenuButton(
                this, "Resume", -160, -80, 320, 70,
                _onResume, _menuTray, 22
            );
            _menuTray.addActor(resumeButton);
            _addButtonFrame(resumeButton, 0, -80);

            var returnButton:TextButton = Snippets.makeMenuButton(
                this, "Return to Title", -160, 40, 320, 70,
                _onReturnToTitle, _menuTray, 22
            );
            _menuTray.addActor(returnButton);
            _addButtonFrame(returnButton, 0, 40);
        }

        private function _addButtonFrame(button:TkActor, x:Number, y:Number):void {
            var image:Image = getImageFromAtlas('atlas-02', 'button_frame');
            image.blendMode = TkBlendMode.ADD;
            button.addImage(image, 260, 70, x, y, 0.5, 0);
        }

        private function _onResume():void {
            passAway();
        }

        private function _onReturnToTitle():void {
            act().justdoit(0.3, function():void { blackOut(0.3); })
                 .justdoit(0, function():void {
                     sendMessage(GameEvent.RETURN_TO_TITLE);
                 });
        }

        protected override function onDispose():void {
            setAllLayersEnabled(true);
        }
    }
}
