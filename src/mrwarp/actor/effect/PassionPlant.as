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
    public class PassionPlant extends TkActor {

        //------------------------------------------------------------
        public override function init():void {
            var image:Image = getImageFromAtlas(
                'atlas-effect', 'plant_' + (TkUtil.randInt(4) + 1)
            );
            addImage(image, 256, 256);

            if (TkUtil.rand(2) < 1) {
                image.blendMode = TkBlendMode.ADD;
                image.color = TkUtil.hsv2intWithRand(30, 140, 0.3, 0.5, 0.10, 0.16);
            } else {
                image.blendMode = TkBlendMode.SUB;
                image.color = TkUtil.hsv2intWithRand(140, 250, 0.3, 0.5, 0.25, 0.35);
            }

            x = 160 + TkUtil.randPlusOrMinus(50, 200);
            y = 240 + TkUtil.randPlusOrMinus(50, 200);
            rotation = TkUtil.rand(6.28);

            alpha = 0;
            scaleX = 4.0;
            scaleY = 4.0;
            act().alphaTo(0.5, 1).wait(0.5).alphaTo(1.0, 0).kill();
            act().scaleToEaseOut(2.0, 0.1, 0.1);

            listen(GameEvent.SCROLL_SCREEN, _onScrollScreen);
        }

        public function _onScrollScreen(args:Object):void {
            x += args.dx * 0.3 * scaleX;
            y += args.dy * 0.3 * scaleY;
        }
    }
}
