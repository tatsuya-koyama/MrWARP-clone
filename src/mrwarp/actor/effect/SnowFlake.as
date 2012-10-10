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
    public class SnowFlake extends TkActor {

        private var _scale:Number;

        //------------------------------------------------------------
        public override function init():void {
            var image:Image = getImageFromAtlas(
                'atlas-effect', 'snow_' + (TkUtil.randInt(3) + 1)
            );
            addImage(image, 120, 120);

            image.blendMode = TkBlendMode.ADD;
            image.color = TkUtil.hsv2intWithRand(70, 220, 0.4, 0.6, 0.1, 0.23);
            image.rotation = TkUtil.rand(6.28);

            _scale = TkUtil.randArea(0.2, 1.0);
            scaleX = _scale;
            scaleY = _scale;

            x = TkUtil.randArea(-100, 420);
            y = TkUtil.randArea(-130, 530);

            alpha = 0;
            act().alphaTo(1.0, 1).wait(4.0).alphaTo(1.0, 0).kill();

            listen(GameEvent.SCROLL_SCREEN, _onScrollScreen);
        }

        public function _onScrollScreen(args:Object):void {
            x += args.dx * 0.5 * _scale;
            y += args.dy * 0.5 * _scale;
        }

        public override function onUpdate(passedTime:Number):void {
            y += _scale * passedTime * 70;
            rotation += passedTime;
        }
    }
}
