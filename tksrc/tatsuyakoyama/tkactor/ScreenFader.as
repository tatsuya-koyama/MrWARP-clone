package tatsuyakoyama.tkactor {

    import starling.display.Quad;
    import starling.animation.Tween;
    import starling.animation.Transitions;

    import tatsuyakoyama.tkutility.TkUtil;

    //------------------------------------------------------------
    public class ScreenFader extends ScreenCurtain {

        //------------------------------------------------------------
        public function ScreenFader(color1:int=0, color2:int=0,
                                    color3:int=0, color4:int=0) {
            super(color1, color2, color3, color4);
            alpha = 0;
            touchable = false;
        }

        public override function init():void {}

        public override function onUpdate(passedTime:Number):void {}

        public function fadeIn(duration:Number=0.33, startAlpha:Number=1):void {
            alpha = startAlpha;
            var tween:Tween = new Tween(this, duration, Transitions.LINEAR);
            tween.fadeTo(0);
            addTween(tween);
        }

        public function fadeOut(duration:Number=0.33, startAlpha:Number=0):void {
            alpha = startAlpha;
            var tween:Tween = new Tween(this, duration, Transitions.LINEAR);
            tween.fadeTo(1);
            addTween(tween);
        }

        // black -> transparent
        public override function blackIn(duration:Number=0.33, startAlpha:Number=1):void {
            setVertexColor(0x000000, 0x000000, 0x000000, 0x000000);
            fadeIn(duration, startAlpha);
        }

        // transparent -> black
        public override function blackOut(duration:Number=0.33, startAlpha:Number=0):void {
            setVertexColor(0x000000, 0x000000, 0x000000, 0x000000);
            fadeOut(duration, startAlpha);
        }

        // white -> transparent
        public override function whiteIn(duration:Number=0.33, startAlpha:Number=1):void {
            setVertexColor(0xffffff, 0xffffff, 0xffffff, 0xffffff);
            fadeIn(duration, startAlpha);
        }

        // transparent -> white
        public override function whiteOut(duration:Number=0.33, startAlpha:Number=0):void {
            setVertexColor(0xffffff, 0xffffff, 0xffffff, 0xffffff);
            fadeOut(duration, startAlpha);
        }

        // specified color -> transparent
        public override function colorIn(color:uint, duration:Number=0.33, startAlpha:Number=1):void {
            setVertexColor(color, color, color, color);
            fadeIn(duration, startAlpha);
        }

        // transparent -> specified color
        public override function colorOut(color:uint, duration:Number=0.33, startAlpha:Number=0):void {
            setVertexColor(color, color, color, color);
            fadeOut(duration, startAlpha);
        }
    }
}
