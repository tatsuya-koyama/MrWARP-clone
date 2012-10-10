package mrwarp.actor {

    import starling.text.TextField;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkBlendMode;
    import tatsuyakoyama.tkframework.utility.TkTextFactory;
    import tatsuyakoyama.tkutility.TkUtil;

    import mrwarp.GameEvent;

    //------------------------------------------------------------
    public class OutOfEnergyNotice extends TkActor {

        //------------------------------------------------------------
        public override function init():void {
            blendMode = TkBlendMode.ADD;
            alpha = 0;
            x = 160;
            y = 180 + 25;

            var text:TextField = TkTextFactory.makeText(
                320, 50, "- OUT OF ENERGY -", 20, "tk_courier", 0xcc2222,
                -160, -25, "center", "top", false
            );
            addText(text);

            listen(GameEvent.OUT_OF_ENERGY, _onOutOfEnergy);
        }

        private function _onOutOfEnergy(args:Object):void {
            alpha = 1;
            scaleX = 1.3;
            scaleY = 1.3;

            removeTweens();
            act().alphaTo(0.8, 0);
            act().scaleToEaseOut(0.5, 1, 1);
        }
    }
}
