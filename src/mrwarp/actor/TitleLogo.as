package mrwarp.actor {

    import starling.display.Image;
    import starling.display.BlendMode;
    import starling.animation.Tween;
    import starling.animation.Transitions;
    import starling.text.TextField;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkAction;

    import tatsuyakoyama.tkutility.TkUtil;

    //------------------------------------------------------------
    public class TitleLogo extends TkActor {

        private var _shake:Number = 0;

        //------------------------------------------------------------
        public override function init():void {
            var image:Image = getImageFromAtlas('atlas-title', 'title_logo');
            addImage(image, 320, 100);
            x = 320 / 2;
            y = 140;

            addPeriodicTask(1/30, function():void {
                // scaling noise
                if (TkUtil.rand(100) < 2.5) {
                    scaleX = TkUtil.randArea(1.1, 1.4);
                    act().scaleTo(0.2, 1, 1, Transitions.EASE_OUT);
                }
                if (TkUtil.rand(100) < 2.5) {
                    scaleY = TkUtil.randArea(1.1, 1.6);
                    act().scaleTo(0.2, 1, 1, Transitions.EASE_OUT);
                }

                // shake
                if (TkUtil.rand(100) < 2.5) {
                    _shake = TkUtil.randArea(1, 4);
                }
            });
        }

        public override function onUpdate(passedTime:Number):void {
            // blink
            alpha = TkUtil.randArea(0.65, 1.0);

            if (Math.abs(_shake) > 1) {
                y = 140 + (_shake * _shake * _shake) / 3;
                _shake *= -0.9;
            }
        }
    }
}
