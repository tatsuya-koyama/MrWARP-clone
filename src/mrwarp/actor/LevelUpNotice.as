package mrwarp.actor {

    import starling.text.TextField;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkBlendMode;
    import tatsuyakoyama.tkframework.utility.TkTextFactory;
    import tatsuyakoyama.tkutility.TkUtil;

    import mrwarp.GameEvent;

    //------------------------------------------------------------
    public class LevelUpNotice extends TkActor {

        //------------------------------------------------------------
        public override function init():void {
            listen(GameEvent.GAME_LEVEL_UP, _onGameLevelUp);
        }

        private function _onGameLevelUp(args:Object):void {
            var logo:TkActor = new TkActor();
            var text:TextField = TkTextFactory.makeText(
                320, 80, "Level  " + args.level, 50, "tk_mincho", 0xffffff,
                -160, -40, "center", "center", false
            );
            logo.addText(text);

            logo.x = 160;
            logo.y = 260;
            logo.alpha = 0;
            logo.scaleX = 4.0;
            logo.scaleY = 4.0;
            logo.act().scaleToEaseOut(0.4, 1, 1).wait(2.0).alphaTo(1.0, 0).kill();
            logo.act().alphaTo(0.4, 1);
            logo.act().moveEaseOut(0.4, 0, -100);

            createActor(logo);
        }
    }
}
