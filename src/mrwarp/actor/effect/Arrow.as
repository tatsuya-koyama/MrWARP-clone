package mrwarp.actor.effect {

    import starling.display.Image;
    import starling.animation.Tween;
    import starling.animation.Transitions;
    import starling.text.TextField;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkAction;
    import tatsuyakoyama.tkframework.TkBlendMode;

    import tatsuyakoyama.tkutility.TkUtil;

    //------------------------------------------------------------
    public class Arrow extends TkActor {

        //------------------------------------------------------------
        public function Arrow() {
            _checkDisplayArea = true;
        }

        public override function init():void {
            var image:Image = getImageFromAtlas('atlas-title', 'left_arrow');
            addImage(image, 256, 170);

            if (TkUtil.rand(2) < 1) {
                image.blendMode = TkBlendMode.ADD;
                image.color = 0x112200;
            } else {
                image.blendMode = TkBlendMode.SUB;
                image.color = 0x334400;
            }

            var scale:Number = TkUtil.randArea(0.3, 1.5);
            scaleX = scale;
            scaleY = scale;

            x     = TkUtil.randArea(600, 1000);
            y     = TkUtil.randArea(0, 480);
            alpha = TkUtil.randArea(0.5, 1.0);

            if (TkUtil.rand(2) < 1) {
                act().moveEaseOut(1.0, -600, 0).moveEaseIn(1.0, -600, 0).kill();
            } else {
                act().move(1.5, -1200, 0).kill();
            }
        }
    }
}
