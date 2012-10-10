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

    import tatsuyakoyama.TkConfig; // debug

    //------------------------------------------------------------
    public class FieldSceneStatusDisplay extends TkActor {

        private var _scoreText:TextField;
        private var _playerLifeText:TextField;
        private var _starText:TextField;
        private var _performanceText:TextField;

        //------------------------------------------------------------
        public override function init():void {
            _addLogos();
        }

        private function _addLogos():void {
            _scoreText = TkTextFactory.makeText(
                100, 25, "0", 20, "tk_courier", 0xffffff,
                55, 6, "right", "top", false
            );
            addText(_scoreText);

            _playerLifeText = TkTextFactory.makeText(
                100, 25, "Life:0", 20, "tk_courier", 0xffffff,
                172, 6, "right", "top", false
            );
            addText(_playerLifeText);

            _starText = TkTextFactory.makeText(
                320, 25, "*", 16, "tk_courier", 0xaaccff,
                5, 460, "left", "top", false
            );
            addText(_starText);

            _performanceText = TkTextFactory.makeText(
                320, 25, "", 12, "tk_courier", 0x88ff88,
                3, 30, "left", "top", false
            );
            addText(_performanceText);
        }

        public override function onUpdate(passedTime:Number):void {
            _scoreText.text      = ''      + GameRecord.score;
            _playerLifeText.text = 'Life:' + GameRecord.playerLife;
            _starText.text       = '$:'    + GameRecord.star;

            // if (GameConst.SHOW_PERFORMANCE) {
            //     _performanceText.text =
            //             'E:' + GameRecord.numEnemy
            //         + '  S:' + GameRecord.numShot
            //         + '  I:' + GameRecord.numItem;
            // }
        }
    }
}
