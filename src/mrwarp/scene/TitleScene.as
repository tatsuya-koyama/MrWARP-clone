package mrwarp.scene {

    import starling.display.Sprite;
    import starling.display.Image;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;
    import starling.text.TextField;
    import starling.utils.HAlign;
    import starling.utils.VAlign;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.animation.Tween;

    import mrwarp.GameRecord;
    import mrwarp.actor.TitleLogo;
    import mrwarp.actor.TitleSilhouette;
    import mrwarp.actor.effect.Arrow;
    import mrwarp.lib.Snippets;

    import tatsuyakoyama.tkframework.TkScene;
    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkAction;
    import tatsuyakoyama.tkframework.TkStateMachine;
    import tatsuyakoyama.tkframework.TkStateHook;
    import tatsuyakoyama.tkframework.utility.TkTextFactory;
    import tatsuyakoyama.tkactor.ScreenCurtain;
    import tatsuyakoyama.tkactor.TextButton;
    import tatsuyakoyama.tkutility.TkUtil;

    //------------------------------------------------------------
    public class TitleScene extends TkScene {

        private var _titleLogoTray:TkActor = new TkActor();
        private var _creditText:TextField;
        private var _highScoreText:TextField;
        private var _startButton:TextButton;

        private var _menuTray:TkActor = new TkActor();
        private var _menuButton_Tutorial:TextButton;
        private var _menuButton_Normal  :TextButton;
        private var _menuButton_Hard    :TextButton;

        private var _state:TkStateMachine = new TkStateMachine();

        //------------------------------------------------------------
        // Set up scene
        //------------------------------------------------------------
        public override function loadResources():void {
            sharedObj.resourceManager.useTextureAtlases(
                ['atlas-title', 'atlas-01']
            );
            sharedObj.resourceManager.useSounds(
                ['silent', 'title_select']
            );
        }

        public override function setUpLayers():void {
            sharedObj.layerManager.setUpLayers(
                this, ['l-back', 'l-ui']
            );
        }

        private function _initState():void {
            _state.initWithObj({
                push_start : null,
                select_menu: new TkStateHook(_onSelectMenuState),
                transition: {
                    goto_tutorial: new TkStateHook(_gotoNextScene),
                    goto_normal  : new TkStateHook(_gotoNextScene),
                    goto_crazy   : new TkStateHook(_gotoNextScene)
                }
            });
            _state.switchState('push_start');
            setUpActor('_system_', _state, false);
        }

        public override function init():void {
            _initState();

            // 音鳴らさないと Android でメディア音量変更できる状態にならないので、
            // 仕方なく無音を鳴らしておく
            playSe('silent');

            var background:ScreenCurtain = new ScreenCurtain(
                0x006622, 0x004411, 0x003300, 0x001100
            );
            setUpActor('l-back', background);

            var silhouette:TitleSilhouette = new TitleSilhouette();
            setUpActor('l-back', silhouette);

            setUpActor('l-ui', _titleLogoTray);
            var titleLogo:TitleLogo = new TitleLogo();
            _titleLogoTray.addActor(titleLogo);

            _highScoreText = _makeHighScoreLogo();
            addChildToLayer('l-ui', _highScoreText);

            _creditText = _makeCreditLogo();
            addChildToLayer('l-ui', _creditText);

            _startButton = _makeStartButton();
            setUpActor('l-ui', _startButton);

            _initMenuButtons();
            _initPeriodicTasks();

            blackIn(1.0);
        }

        private function _initMenuButtons():void {
            _menuTray.touchable = false;
            _menuTray.visible   = false;
            setUpActor('l-ui', _menuTray);

            _menuButton_Tutorial = _makeMenuButton(
                'Tutorial Mode', 160, 'transition.goto_tutorial'
            );
            _menuTray.addActor(_menuButton_Tutorial);

            _menuButton_Normal = _makeMenuButton(
                'Normal Mode', 230, 'transition.goto_normal'
            );
            _menuTray.addActor(_menuButton_Normal);

            _menuButton_Hard = _makeMenuButton(
                'Crazy Mode', 300, 'transition.goto_crazy'
            );
            _menuTray.addActor(_menuButton_Hard);
        }

        private function _initPeriodicTasks():void {
            addPeriodicTask(0.13, function():void {
                var arrow:Arrow = new Arrow();
                setUpActor('l-back', arrow);
            });
        }

        protected override function onDispose():void {
            _creditText.dispose();
            _highScoreText.dispose();
        }

        //------------------------------------------------------------
        // Text and TextButton
        //------------------------------------------------------------
        private function _makeStartButton():TextButton {
            var startButton:TextButton = Snippets.makeMenuButton(
                this, "Tap to Start", (320 - 300) / 2, 230, 300, 120,
                function():void { _state.switchState('select_menu'); }
            );

            var blinkSlowlyLoop:Function = function():void {
                act().blink(startButton.text, 1.0).doit(0, blinkSlowlyLoop);
            };
            act().doit(0, blinkSlowlyLoop);
            return startButton;
        }

        private function _makeMenuButton(text:String, y:Number, nextState:String):TextButton {
            return Snippets.makeMenuButton(
                this, text, (320 - 300) / 2, y, 300, 70,
                function():void { _state.switchState(nextState); },
                _menuTray
            );
        }

        private function _makeCreditLogo():TextField {
            return TkTextFactory.makeText(
                320, 50, "(c) 2012 Tatsuya Koyama", 16, "tk_courier_mini", 0xffffff,
                0, 420, "center", "top", false
            );
        }

        private function _makeHighScoreLogo():TextField {
            var highScore:uint = GameRecord.persistentData.highScore;
            return TkTextFactory.makeText(
                320, 50, "High Score: " + highScore, 16, "tk_courier_mini", 0xccff99,
                0, 400, "center", "top", false
            );
        }

        //------------------------------------------------------------
        // Update and Switch state
        //------------------------------------------------------------
        public override function onUpdate(passedTime:Number):void {}

        private function _onSelectMenuState():void {
            _startButton.act().moveEaseIn(0.3, -320, 0);

            _menuTray.visible = true;
            _menuTray.x = 320;
            _menuTray.act().moveEaseIn(0.3, -320, 0).justdoit(0, function():void {
                _menuTray.touchable = true;
            });

            _titleLogoTray.act().moveEaseIn(0.3, 0, -70);
        }

        private function _gotoNextScene():void {
            var fadeOut:Function = function():void {
                whiteOut(0.4);
            };
            act().doit(0.4, fadeOut).justdoit(0, exit);
        }

        public override function getNextScene():TkScene {
            // set play mode
            switch (_state.currentState) {
            case 'transition.goto_tutorial':
                GameRecord.playMode = 'tutorial';  break;
            case 'transition.goto_normal':
                GameRecord.playMode = 'normal';  break;
            case 'transition.goto_crazy':
                GameRecord.playMode = 'crazy';  break;
            default:
                GameRecord.playMode = 'normal';  break;
            }

            return new FieldScene();
        }
    }
}
