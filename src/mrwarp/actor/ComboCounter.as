package mrwarp.actor {

    import starling.text.TextField;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkBlendMode;
    import tatsuyakoyama.tkframework.utility.TkTextFactory;
    import tatsuyakoyama.tkutility.TkUtil;

    import mrwarp.GameRecord;
    import mrwarp.GameEvent;

    //------------------------------------------------------------
    public class ComboCounter extends TkActor {

        private var _comboCount:TextField;
        private var _comboScore:TextField;

        //------------------------------------------------------------
        public override function init():void {
            _comboCount = TkTextFactory.makeText(
                240, 80, "", 32, "tk_mincho", 0xffaa55,
                -120, -40, "center", "center", false
            );
            _comboScore = TkTextFactory.makeText(
                240, 40, "", 18, "tk_mincho", 0xffaa55,
                -75, 3, "center", "center", false
            );
            addText(_comboCount);
            addText(_comboScore);

            alpha = 0;

            listen(GameEvent.ENEMY_DEFEATED, _onEnemyDefeated);
            listen(GameEvent.SCROLL_SCREEN, _onScrollScreen);
        }

        public function _onScrollScreen(args:Object):void {
            x += args.dx;
            y += args.dy;
        }

        public override function onUpdate(passedTime:Number):void {
            if (GameRecord.comboTime <= 0) { return; }

            GameRecord.comboTime -= passedTime;
            if (GameRecord.comboTime <= 0) {
                GameRecord.combo = 0;
            }
        }

        private function _getComboScore():int {
            return (GameRecord.combo * 100);
        }

        private function _onEnemyDefeated(args:Object):void {
            // count score
            ++GameRecord.combo;
            GameRecord.comboTime = 1.0;

            // earn score
            if (GameRecord.playerLife > 0) {
                GameRecord.score += _getComboScore();
            }

            // text notice
            if (GameRecord.combo >= 2) {
                _showTextNotice(args.x, args.y);
            }
        }

        private function _showTextNotice(x:Number, y:Number):void {
            _comboCount.text = GameRecord.combo + " Combo";
            _comboScore.text = "+" + _getComboScore() + " pts.";

            this.x = TkUtil.within(x, 120, 320-120);
            this.y = TkUtil.within(y,  60, 480- 60);

            alpha = 0;
            scaleX = 2.0;
            scaleY = 2.0;

            removeTweens();
            react();
            act().scaleTo(0.2, 1, 1);
            act().alphaTo(0.2, 1).alphaTo(1.0, 0);
        }
    }
}
