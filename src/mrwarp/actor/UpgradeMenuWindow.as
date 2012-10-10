package mrwarp.actor {

    import flash.display.Bitmap;

    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.display.Image;
    import starling.display.Button;
    import starling.text.TextField;

    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkBlendMode;
    import tatsuyakoyama.tkframework.TkEventType;
    import tatsuyakoyama.tkframework.utility.TkTextFactory;
    import tatsuyakoyama.tkactor.TextButton;
    import tatsuyakoyama.tkactor.ScreenCurtain;
    import tatsuyakoyama.tkutility.TkUtil;

    import mrwarp.GameEvent;
    import mrwarp.GameRecord;
    import mrwarp.PlayerStatus;
    import mrwarp.PlayerStatusValue;
    import mrwarp.lib.Snippets;

    //------------------------------------------------------------
    public class UpgradeMenuWindow extends TkActor {

        private var _menuTray:TkActor = new TkActor();

        //------------------------------------------------------------
        public function UpgradeMenuWindow() {
            touchable = false;
        }

        public override function init():void {
            // うっかり押しちゃうの防止
            act().wait(0.4).justdoit(0, function():void {
                touchable = true;
            });

            var curtain:ScreenCurtain = new ScreenCurtain();
            curtain.x = -160;
            curtain.y = -240;
            curtain.alpha = 0.8;
            addActor(curtain);

            var image:Image = getImageFromAtlas('atlas-02', 'menu_frame_b');
            image.touchable = true;
            image.blendMode = TkBlendMode.ADD;
            addImage(image, 320, 480, 0, 0, 0.5, 0.5);

            addActor(_makeTitleLogo());

            _addButtons();

            // fade in animation
            x = 160;
            y = 240;
            scaleX = 1.5;
            scaleY = 1.5;
            alpha  = 0;
            act().scaleToEaseOut(0.25, 1, 1);
            act().alphaTo(0.25, 1);
        }

        private function _makeTitleLogo():TkActor {
            var logo:TkActor = new TkActor();
            var text:TextField = TkTextFactory.makeText(
                320, 80, "Upgrade", 30, "tk_mincho", 0xffccaa,
                -160, -60, "center", "center", false
            );
            logo.addText(text);
            logo.x = 0;
            logo.y = -150;
            return logo;
        }

        private function _addButtons():void {
            _menuTray.touchable = true;
            addActor(_menuTray);

            _addOneButton(0, "Max Energy",    _onLevelUpMaxEnergy,    PlayerStatus.MAX_ENERGY);
            _addOneButton(1, "Item Recovery", _onLevelUpItemRecovery, PlayerStatus.ENERGY_RECOVER);
            _addOneButton(2, "Camera Speed",  _onLevelUpCameraSpeed,  PlayerStatus.CAMERA_SPEED);
            _addOneButton(3, "Ray Width",     _onLevelUpMaxRayWidth,  PlayerStatus.RAY_WIDTH);

            _menuTray.addText(_makeCurrentMoneyText());
            _addCancelButton();
        }

        private function _addOneButton(index:int, caption:String,
                                       handler:Function, statusIndex:int):void
        {
            var fontSize:Number = 18;
            var yGap:Number     = 60;
            var textX:Number    = -55;
            var textY:Number    = -140 + (yGap * index)

            var button:TextButton = Snippets.makeMenuButton(
                this, caption, textX, textY + 16, 280, yGap,
                handler, _menuTray, 18, 0xffffff, 'left', 'top'
            );
            _menuTray.addActor(button);
            _addButtonFrame(button, 0, textY);
            _addUpgradeIcon(button, index, -85, textY + 36);

            // get target status object
            var status:PlayerStatusValue = GameRecord.playerStatus.getStatus(statusIndex);
            var isMax:Boolean = status.isMaxLevel();
            if (isMax) {
                button.touchable = false;
                button.alpha = 0.5;
            }

            // display required cost
            var cost:int = status.getCost(1);
            var isShortage:Boolean = (GameRecord.star < cost);
            if (isShortage) {
                button.touchable = false;
                button.alpha = 0.5;
            }

            var costText:TextField = TkTextFactory.makeText(
                180, 30,
                (isMax) ? "Max Lv."  :"$:" + cost,
                16, "tk_courier",
                (isShortage) ? 0xff9999 : 0xaaccff,
                textX, textY + 37
            );
            button.addText(costText);

            // display current and next parameter
            var currentParam:Number = status.getAspectValue(0);
            var nextParam:Number    = status.getAspectValue(1);
            var paramText:TextField = TkTextFactory.makeText(
                180, 30,
                (isMax) ? "" + currentParam : currentParam + " => " + nextParam,
                13, "tk_courier", 0xaaffaa, textX + 80, textY + 39
            );
            button.addText(paramText);
        }

        private function _addCancelButton():void {
            var button:TextButton = Snippets.makeMenuButton(
                this, "Cancel", -80, 145, 160, 60,
                _onResume, _menuTray, 20, 0xffffff
            );
            _menuTray.addActor(button);
            _addButtonFrame(button, 0, 145, 160, 60);
        }

        private function _makeCurrentMoneyText():TextField {
            return TkTextFactory.makeText(
                280, 30, "Your $: " + GameRecord.star,
                16, "tk_courier", 0xaaccff, -110, 115
            );
        }

        private function _addUpgradeIcon(button:TkActor, index:int, x:Number, y:Number):void {
            var image:Image = getImageFromAtlas('atlas-02', 'upgrade_icon_' + index);
            image.blendMode = TkBlendMode.ADD;
            button.addImage(image, 40, 40, x, y);
        }

        private function _addButtonFrame(button:TkActor, x:Number, y:Number,
                                         width:Number=260, height:Number=70):void {
            var image:Image = getImageFromAtlas('atlas-02', 'button_frame_b');
            image.blendMode = TkBlendMode.ADD;
            button.addImage(image, width, height, x, y, 0.5, 0);
        }

        private function _onLevelUpMaxEnergy():void {
            var status:PlayerStatusValue = GameRecord.playerStatus.getStatus(PlayerStatus.MAX_ENERGY);
            status.levelUp();
            GameRecord.star -= status.getCost();
            _resume();
        }

        private function _onLevelUpItemRecovery():void {
            var status:PlayerStatusValue = GameRecord.playerStatus.getStatus(PlayerStatus.ENERGY_RECOVER);
            status.levelUp();
            GameRecord.star -= status.getCost();
            _resume();
        }

        private function _onLevelUpCameraSpeed():void {
            var status:PlayerStatusValue = GameRecord.playerStatus.getStatus(PlayerStatus.CAMERA_SPEED);
            status.levelUp();
            GameRecord.star -= status.getCost();
            _resume();
        }

        private function _onLevelUpMaxRayWidth():void {
            var status:PlayerStatusValue = GameRecord.playerStatus.getStatus(PlayerStatus.RAY_WIDTH);
            status.levelUp();
            GameRecord.star -= status.getCost();

            // Ray width をレベルアップした時は
            // Ray Duration も連動してレベルアップさせる
            var status:PlayerStatusValue = GameRecord.playerStatus.getStatus(PlayerStatus.RAY_DURATION);
            status.levelUp();
            _resume();
        }

        private function _onResume():void {
            _resume();
        }

        private function _resume():void {
            passAway();
            GameRecord.isUpgrading = false;
        }

        private function _onReturnToTitle():void {
            act().justdoit(0.3, function():void { blackOut(0.3); })
                 .justdoit(0, function():void {
                     sendMessage(GameEvent.RETURN_TO_TITLE);
                 });
        }

        protected override function onDispose():void {
            setAllLayersEnabled(true);
        }
    }
}
