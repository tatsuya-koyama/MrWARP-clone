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
    public class Cloud extends TkActor {

        private var _scale:Number;

        //------------------------------------------------------------
        public override function init():void {
            var image:Image = getImageFromAtlas(
                'atlas-effect', 'cloud_' + (TkUtil.randInt(3) + 1)
            );
            addImage(image, 230, 230);

            image.blendMode = TkBlendMode.ADD;
            image.color = TkUtil.hsv2intWithRand(180, 250, 0.2, 0.5, 0.15, 0.3);
            image.rotation = TkUtil.deg2rad(-25);

            _scale = TkUtil.randArea(0.5, 1.0);
            scaleX = _scale;
            scaleY = _scale;

            x = TkUtil.randArea(-180, 320);
            y = TkUtil.randArea(0, 580);

            alpha = 0;
            act().alphaTo(1.0, 1).wait(4.0).alphaTo(1.0, 0).kill();

            listen(GameEvent.SCROLL_SCREEN, _onScrollScreen);
        }

        public function _onScrollScreen(args:Object):void {
            x += args.dx * 0.5 * _scale;
            y += args.dy * 0.5 * _scale;
        }

        public override function onUpdate(passedTime:Number):void {
            x += _scale * passedTime * 50;
            y -= _scale * passedTime * 30;
        }
    }
}
