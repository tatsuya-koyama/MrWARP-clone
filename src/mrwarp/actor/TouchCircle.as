package mrwarp.actor {

    import starling.display.Image;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkBlendMode;
    import tatsuyakoyama.tkutility.TkUtil;

    import mrwarp.GameRecord;
    import mrwarp.GameEvent;

    //------------------------------------------------------------
    public class TouchCircle extends TkActor {

        //------------------------------------------------------------
        public function TouchCircle(x:Number, y:Number) {
            this.x = x;
            this.y = y;
        }

        public override function init():void {
            var image:Image = getImageFromAtlas('atlas-01', 'touch_circle');
            image.blendMode = TkBlendMode.ADD;
            image.color = 0xbbaa88;
            addImage(image, 64, 64);

            act().alphaTo(0.5, 0).kill();
            act().scaleToEaseIn(0.5, 1.4, 1.4);

            listen(GameEvent.SCROLL_SCREEN, _onScrollScreen);
        }

        public function _onScrollScreen(args:Object):void {
            x += args.dx;
            y += args.dy;
        }
    }
}
