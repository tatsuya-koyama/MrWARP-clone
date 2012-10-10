package mrwarp.actor {

    import starling.display.Image;
    import starling.display.BlendMode;
    import starling.animation.Tween;
    import starling.animation.Transitions;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkAction;

    import tatsuyakoyama.tkutility.TkUtil;

    //------------------------------------------------------------
    public class TitleSilhouette extends TkActor {

        //------------------------------------------------------------
        public override function init():void {
            var image:Image = getImageFromAtlas('atlas-title', 'player_big');
            image.blendMode = BlendMode.ADD;
            image.color = 0x112e22;
            addImage(image, 600, 700);
            x = 350;
            y = 270;
            rotation = TkUtil.deg2rad(-10);
        }

        public override function onUpdate(passedTime:Number):void {
            if (x > 120) { x -= 0.1; }
        }
    }
}
