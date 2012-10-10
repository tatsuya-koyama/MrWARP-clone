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
    public class Tile extends TkActor {

        private var _scale:Number;

        //------------------------------------------------------------
        public function Tile() {
            _checkDisplayArea = true;
        }

        public override function init():void {
            var image:Image = getImageFromAtlas('atlas-01', 'white');
            addImage(image, 100, 100);

            image.blendMode = (TkUtil.rand(2) < 1) ? TkBlendMode.ADD : TkBlendMode.SUB;

            if (TkUtil.rand(2) < 1) {
                _scale = 0.8;
                x = (TkUtil.randInt(10) - 3) * 90;
                y = (TkUtil.randInt(12) - 4) * 90;
                image.color = TkUtil.hsv2intWithRand(0, 360, 0.2, 0.5, 0.1, 0.16);
            } else {
                _scale = 0.4;
                x = (TkUtil.randInt(20) - 6) * 45;
                y = (TkUtil.randInt(24) - 8) * 45;
                image.color = TkUtil.hsv2intWithRand(0, 360, 0.2, 0.5, 0.1, 0.13);
            }

            scaleX = _scale;
            scaleY = _scale;

            alpha = 0;
            act().alphaTo(0.3, 1).wait(4.0).alphaTo(1.0, 0).kill();
            act().rotateTo(0.3, 90);

            listen(GameEvent.SCROLL_SCREEN, _onScrollScreen);
        }

        public function _onScrollScreen(args:Object):void {
            x += args.dx * _scale;
            y += args.dy * _scale;
        }
    }
}
