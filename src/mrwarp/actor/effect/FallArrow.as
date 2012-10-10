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
    public class FallArrow extends TkActor {

        private var _scale:Number;
        private var _vx:Number;

        //------------------------------------------------------------
        public function FallArrow() {
            _checkDisplayArea = true;
        }

        public override function init():void {
            var image:Image = getImageFromAtlas('atlas-title', 'left_arrow');
            image.rotation = TkUtil.deg2rad(-90);
            addImage(image, 170, 256);

            if (TkUtil.rand(2) < 1) {
                image.blendMode = TkBlendMode.ADD;
                image.color = 0x331800;
            } else {
                image.blendMode = TkBlendMode.SUB;
                image.color = 0x442200;
            }

            _scale = TkUtil.randArea(0.1, 0.9);
            scaleX = _scale;
            scaleY = _scale;

            x     = TkUtil.randArea(100, 220);
            y     = TkUtil.randArea(-700, -400);
            alpha = TkUtil.randArea(0.5, 1.0);

            _vx = (x - 160) * 1.0;

            listen(GameEvent.SCROLL_SCREEN, _onScrollScreen);
        }

        public function _onScrollScreen(args:Object):void {
            x += args.dx * 0.3;
            y += args.dy * 0.3;
        }

        public override function onUpdate(passedTime:Number):void {
            _scale += passedTime * 0.05;
            scaleX = _scale;
            scaleY = _scale;

            x += _scale * passedTime * _vx;
            y += _scale * passedTime * 500;
            if (y > 1000) { passAway(); }
        }
    }
}
