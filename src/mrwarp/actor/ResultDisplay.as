package mrwarp.actor {

    import starling.display.Image;
    import starling.text.TextField;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkBlendMode;
    import tatsuyakoyama.tkutility.TkUtil;
    import tatsuyakoyama.tkframework.utility.TkTextFactory;

    import mrwarp.GameConst;
    import mrwarp.GameRecord;
    import mrwarp.GameEvent;

    //------------------------------------------------------------
    public class ResultDisplay extends TkActor {

        //------------------------------------------------------------
        public override function init():void {
            _addLogos();
        }

        private function _addLogos():void {
            var scoreCaption:TextField = TkTextFactory.makeText(
                320, 50, "Your Score", 30, "tk_mincho", 0xaaccff,
                0, 80, "center", "center", false
            );
            addText(scoreCaption);

            var scoreNumber:TextField = TkTextFactory.makeText(
                320, 50, "" + GameRecord.score, 30, "tk_courier", 0xffffff,
                0, 122, "center", "center", false
            );
            addText(scoreNumber);

            var highScoreCaption:TextField = TkTextFactory.makeText(
                320, 50, "High Score", 30, "tk_mincho", 0xaaccff,
                0, 200, "center", "center", false
            );
            addText(highScoreCaption);

            var highScore:uint = GameRecord.persistentData.highScore;
            var highScoreNumber:TextField = TkTextFactory.makeText(
                320, 50, "" + highScore, 30, "tk_courier", 0xffffff,
                0, 242, "center", "center", false
            );
            addText(highScoreNumber);
        }
    }
}
