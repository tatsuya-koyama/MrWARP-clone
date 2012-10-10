package mrwarp.scene {

    import flash.geom.Point;

    import starling.display.Sprite;
    import starling.display.BlendMode;

    import starling.utils.HAlign;
    import starling.utils.VAlign;

    import starling.events.EnterFrameEvent;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    import tatsuyakoyama.tkframework.TkScene;
    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkEventType;
    import tatsuyakoyama.tkutility.TkUtil;
    import tatsuyakoyama.tkactor.ScreenCurtain;
    import tatsuyakoyama.tkframework.utility.TkTextFactory;

    import mrwarp.GameConst;
    import mrwarp.GameEvent;
    import mrwarp.GameRecord;
    import mrwarp.actor.Player;
    import mrwarp.actor.EnemyGenerator;
    import mrwarp.actor.GuideGenerator;
    import mrwarp.actor.OutOfEnergyNotice;
    import mrwarp.actor.LevelUpNotice;
    import mrwarp.actor.GameOverNotice;
    import mrwarp.actor.ComboCounter;
    import mrwarp.actor.enemy_generator.TutorialEnemyGenerator;
    import mrwarp.actor.enemy_generator.NormalEnemyGenerator;
    import mrwarp.actor.enemy_generator.CrazyEnemyGenerator;
    import mrwarp.actor.EffectGenerator;
    import mrwarp.actor.PauseButton;
    import mrwarp.actor.UpgradeMenuWindow;
    import mrwarp.actor.FieldSceneStatusDisplay;

    //------------------------------------------------------------
    public class FieldScene extends TkScene {

        private var _background:ScreenCurtain;
        private var _player:Player;

        //------------------------------------------------------------
        public function FieldScene() {}

        public override function loadResources():void {
            sharedObj.resourceManager.useTextureAtlases(
                ['atlas-title', 'atlas-01', 'atlas-02', 'atlas-effect']
            );
            sharedObj.resourceManager.useSounds(
                ['title_select', 'bgm-main', 'move',
                 'enemy_die', 'enemy_damage',
                 'player_damage', 'open_menu', 'pickup_item']
            );
        }

        public override function setUpLayers():void {
            sharedObj.layerManager.setUpLayers(
                this, ['l-back', 'l-enemy', 'l-player', 'l-ray', 'l-ui', 'l-menu']
            );
            getLayer('l-back').addEventListener(TouchEvent.TOUCH, _onTouchScreen);
        }

        public override function setUpCollisionGroups():void {
            sharedObj.collisionSystem.setUpGroups([
                 ['c-player', ['c-enemy', 'c-bullet', 'c-item']]
                ,['c-ray',    ['c-enemy']]
                ,['c-bullet', []]
                ,['c-enemy',  []]
                ,['c-item',   []]
            ]);
        }

        public override function init():void {
            playBgm('bgm-main');
            GameRecord.reset();

            _background = new ScreenCurtain(
                0x222222, 0x111111, 0x111111, 0x000000
            );
            setUpActor('l-back', _background);

            _player = new Player();
            setUpActor('l-player', _player);

            _initEnemyGenerator();

            var effectGenerator:EffectGenerator = new EffectGenerator();
            setUpActor('l-back', effectGenerator, false);

            var guideGenerator:GuideGenerator = new GuideGenerator();
            setUpActor('l-ui', guideGenerator, false);

            var outOfEnergyNotice:OutOfEnergyNotice = new OutOfEnergyNotice();
            setUpActor('l-ui', outOfEnergyNotice);

            var levelUpNotice:LevelUpNotice = new LevelUpNotice();
            setUpActor('l-ui', levelUpNotice, false);

            var gameOverNotice:GameOverNotice = new GameOverNotice();
            setUpActor('l-ui', gameOverNotice, false);

            var comboCounter:ComboCounter = new ComboCounter();
            setUpActor('l-ui', comboCounter);

            var pauseButton:PauseButton = new PauseButton();
            setUpActor('l-ui', pauseButton);

            var statusDisplay:FieldSceneStatusDisplay = new FieldSceneStatusDisplay();
            setUpActor('l-ui', statusDisplay);

            listen(GameEvent.GAME_OVER, _onGameOver);
            listen(GameEvent.RETURN_TO_TITLE, _onReturnToTitle);
            listen(GameEvent.OPEN_UPGRADE_MENU, _onOpenUpgradeMenu);
            whiteIn(0.5);
        }

        /**
         * TitleScene でセットしておいた GameRecord.playMode によって
         * EnemyGenerator を切り替える
         */
        private function _initEnemyGenerator():void {
            var enemyGenerator:EnemyGenerator;

            switch (GameRecord.playMode) {
            case 'tutorial': enemyGenerator = new TutorialEnemyGenerator();  break;
            case 'normal':   enemyGenerator = new NormalEnemyGenerator();    break;
            case 'crazy':    enemyGenerator = new CrazyEnemyGenerator();     break;
            default:         enemyGenerator = new NormalEnemyGenerator();    break;
            }

            setUpActor('l-enemy', enemyGenerator);
        }

        protected override function onDispose():void {
            stopSound();
        }

        public override function getNextScene():TkScene {
            if (GameRecord.playerLife <= 0) {
                return new ResultScene();
            }
            return new TitleScene();
        }

        public override function onUpdate(passedTime:Number):void {
            if (GameRecord.score > 99999999) {
                GameRecord.score = 99999999;
            }
        }

        public function _onGameOver(eventArgs:Object):void {
            colorIn(0xff3333, 0.33);
            sendMessage(TkEventType.CHANGE_BG_COLOR, {
                fadeTime: 0.01,
                color1: 0x552222,
                color2: 0x441111,
                color3: 0x441111,
                color4: 0x220000
            });

            var fadeOut:Function = function():void {
                blackOut(1.0);
            };
            act().wait(2.0).doit(1.0, fadeOut).justdoit(0, exit);
        }

        public function _onReturnToTitle(eventArgs:Object):void {
            exit();
        }

        public function _onOpenUpgradeMenu(eventArgs:Object):void {
            act().wait(0.2).justdoit(0, function():void {
                playSe('open_menu');
                var upgradeMenuWindow:UpgradeMenuWindow = new UpgradeMenuWindow();
                setUpActor('l-menu', upgradeMenuWindow);
                setLayerEnabledOtherThan(['l-menu'], false);
            });
        }

        private function _onTouchScreen(event:TouchEvent):void {
            var touchEnded:Touch = event.getTouch(this, TouchPhase.ENDED);
            if (touchEnded) {
                var localPos:Point = touchEnded.getLocation(this);
                sendMessage(TkEventType.SCREEN_TOUCHED, {x: localPos.x, y: localPos.y});
            }
        }
    }
}
