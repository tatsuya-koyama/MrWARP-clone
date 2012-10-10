package mrwarp.scene {

    import starling.display.Image;
    import starling.text.TextField;

    import mrwarp.GameRecord;
    import mrwarp.GamePersistentData;
    import mrwarp.actor.ResultDisplay;
    import mrwarp.actor.effect.Cloud;
    import mrwarp.lib.Snippets;

    import tatsuyakoyama.tkframework.TkScene;
    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkAction;
    import tatsuyakoyama.tkframework.TkBlendMode;
    import tatsuyakoyama.tkframework.utility.TkTextFactory;
    import tatsuyakoyama.tkactor.ScreenCurtain;
    import tatsuyakoyama.tkactor.TextButton;
    import tatsuyakoyama.tkutility.TkUtil;

    //------------------------------------------------------------
    public class ResultScene extends TkScene {

        private var _okButton:TkActor;

        public override function loadResources():void {
            sharedObj.resourceManager.useTextureAtlases(
                ['atlas-02', 'atlas-effect']
            );
            sharedObj.resourceManager.useSounds(
                ['title_select']
            );
        }

        public override function setUpLayers():void {
            sharedObj.layerManager.setUpLayers(
                this, ['l-back', 'l-ui']
            );
        }

        public override function init():void {
            _updateHighScore();

            var background:ScreenCurtain = new ScreenCurtain(
                0x003366, 0x002244, 0x001133, 0x000011
            );
            setUpActor('l-back', background);

            var resultDisplay:ResultDisplay = new ResultDisplay();
            setUpActor('l-ui', resultDisplay);

            _addOkButton();

            addPeriodicTask(0.13, _generateCloud);

            blackIn(1.0);
        }

        private function _generateCloud():void {
            setUpActor('l-back', new Cloud());
        }

        private function _updateHighScore():void {
            var pData:GamePersistentData = GameRecord.persistentData;
            if (GameRecord.score > pData.highScore) {
                pData.highScore = GameRecord.score;
                pData.save();
            }
        }

        private function _addOkButton():void {
            _okButton = Snippets.makeMenuButton(
                this, "OK", -80, 0, 160, 60,
                _onPressOk, _okButton, 20, 0xffffff
            );
            _okButton.x = 160;
            _okButton.y = 330;
            setUpActor('l-ui', _okButton);
            _addButtonFrame(_okButton, 0, 0);
        }

        private function _addButtonFrame(button:TkActor, x:Number, y:Number,
                                         width:Number=160, height:Number=60):void {
            var image:Image = getImageFromAtlas('atlas-02', 'button_frame_b');
            image.blendMode = TkBlendMode.ADD;
            button.addImage(image, width, height, x, y, 0.5, 0);
        }

        private function _onPressOk():void {
            var fadeOut:Function = function():void {
                blackOut(0.3);
            };
            act().doit(0.3, fadeOut).justdoit(0, exit);
        }

        public override function getNextScene():TkScene {
            return new TitleScene();
        }
    }
}
