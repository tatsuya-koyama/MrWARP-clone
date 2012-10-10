package mrwarp.actor.effect {

    import starling.display.Image;
    import starling.animation.Tween;
    import starling.animation.Transitions;
    import starling.text.TextField;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkAction;
    import tatsuyakoyama.tkframework.TkBlendMode;

    import tatsuyakoyama.tkutility.TkUtil;

    import mrwarp.GameEvent;

    //------------------------------------------------------------
    public class PastelCircle extends TkActor {

        private var _scale:Number;

        //------------------------------------------------------------
        public function PastelCircle() {
            _checkDisplayArea = true;
        }

        public override function init():void {
            var image:Image = getImageFromAtlas('atlas-01', 'circle_blur');
            addImage(image, 128, 128);

            if (TkUtil.rand(2) < 1) {
                image.blendMode = TkBlendMode.ADD;
                image.color = TkUtil.hsv2intWithRand(180, 330, 0.3, 0.6, 0.1, 0.15);
            } else {
                image.blendMode = TkBlendMode.SUB;
                image.color = TkUtil.hsv2intWithRand(30, 180, 0.3, 0.6, 0.1, 0.18);
            }

            _scale = TkUtil.randArea(0.2, 1.0);
            scaleX = _scale;
            scaleY = _scale;

            x = TkUtil.randArea(-100, 440);
            y = TkUtil.randArea(-50, 530);

            alpha = 0;
            act().alphaTo(1.0, 1).wait(4.0).alphaTo(1.0, 0).kill();

            listen(GameEvent.SCROLL_SCREEN, _onScrollScreen);
        }

        public function _onScrollScreen(args:Object):void {
            x += args.dx * 0.4 * _scale;
            y += args.dy * 0.4 * _scale;
        }

        public override function onUpdate(passedTime:Number):void {
            x -= _scale * passedTime * 100;
            y -= _scale * passedTime * 50;
        }
    }
}
