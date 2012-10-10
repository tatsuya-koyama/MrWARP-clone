package mrwarp.actor {

    import flash.display.Bitmap;
    import flash.geom.Point;

    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.display.Image;

    import starling.utils.Color;
    import starling.utils.deg2rad;

    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkAction;
    import tatsuyakoyama.tkframework.TkBlendMode;
    import tatsuyakoyama.tkframework.TkEventType;
    import tatsuyakoyama.tkframework.collision.TkCollisionShape;
    import tatsuyakoyama.tkframework.collision.TkCollisionShapeSphere;
    import tatsuyakoyama.tkframework.collision.TkCollisionShapeAABB;
    import tatsuyakoyama.tkframework.collision.TkCollisionShapeOBB;
    import tatsuyakoyama.tkutility.TkUtil;
    import tatsuyakoyama.tkutility.TkVector2D;

    import mrwarp.GameEvent;
    import mrwarp.GameRecord;
    import mrwarp.GameConst;
    import mrwarp.PlayerStatus;

    //------------------------------------------------------------
    public class Player extends TkActor {

        private var _energyActor:PlayerEnergy;

        private var _offsetScale:Number = 0;
        private var _targetX:Number;
        private var _targetY:Number;
        private var _invincibleTime:Number   = 0;
        private var _noRecoverTime:Number    = 0;
        private var _itemDisabledTime:Number = 0;

        //------------------------------------------------------------
        public function Player() {}

        public override function init():void {
            var image:Image = getImageFromAtlas('atlas-01', 'player_small');
            image.blendMode = TkBlendMode.ADD;
            addImage(image, 64, 64);

            x = 320 / 2;
            y = 480;
            _targetX = 320 / 2;
            _targetY = 480 / 2;

            _energyActor = new PlayerEnergy();
            addActor(_energyActor);

            addPeriodicTask(1/30, _approach);

            setCollision('c-player', new TkCollisionShapeSphere(this, _onCollide, 15));
            listen(TkEventType.SCREEN_TOUCHED, _onTouchScreen);
            listen(GameEvent.SCROLL_SCREEN, _onScrollScreen);
            listen(GameEvent.OPEN_UPGRADE_MENU, _onOpenUpgradeMenu);
        }

        protected override function onDispose():void {}

        public override function onUpdate(passedTime:Number):void {
            if (_invincibleTime > 0) {
                _invincibleTime -= passedTime;
            } else {
                color = 0x5566cc;
                _energyActor.setNormalColor();
            }

            if (_noRecoverTime    > 0) { _noRecoverTime    -= passedTime; }
            if (_itemDisabledTime > 0) { _itemDisabledTime -= passedTime; }

            _offsetScale -= 0.6 * passedTime;
            if (_offsetScale < 0) { _offsetScale = 0.1; }
            scaleX = 0.9 + _offsetScale * 2;
            scaleY = 0.9 + _offsetScale * 2;

            if (_noRecoverTime <= 0) {
                _recoverWarpEnergy(GameConst.ENERGY_RECOVERY_PER_SEC * passedTime);
            }
            _energyActor.updateScale(this, passedTime);

            // rotate when player is dead
            if (GameRecord.playerLife <= 0) {
                rotation += passedTime;
            }

            _scrollScreen(passedTime);
        }

        private function _scrollScreen(passedTime:Number):void {
            if (passedTime <= 0) { return; }

            var cameraFollowSpeed:Number = GameRecord.playerStatus.getValue(PlayerStatus.CAMERA_SPEED);
            sendMessage(GameEvent.SCROLL_SCREEN, {
                dx: (160 - x) * passedTime * cameraFollowSpeed,
                dy: (240 - y) * passedTime * cameraFollowSpeed
            });
        }

        public function _onScrollScreen(args:Object):void {
            x += args.dx;
            y += args.dy;
            _targetX += args.dx;
            _targetY += args.dy;
        }

        private function _recoverWarpEnergy(recovery:Number):void {
            GameRecord.playerEnergy += recovery;
            var maxEnergy:Number = GameRecord.playerStatus.getValue(PlayerStatus.MAX_ENERGY);
            GameRecord.playerEnergy = TkUtil.within(GameRecord.playerEnergy, 0, maxEnergy);
        }

        private function _approach():void {
            x += (_targetX - x) / 3;
            y += (_targetY - y) / 3;

            x = TkUtil.within(x, 0 + 32, 320 - 32);
            y = TkUtil.within(y, 0 + 32, 480 - 32);

            // 他の Actor から手軽に参照するため
            GameRecord.playerX = x;
            GameRecord.playerY = y;
        }

        public function _onOpenUpgradeMenu(eventArgs:Object):void {
            // to be invincible for a while after upgrade
            _invincibleTime = GameConst.INVINCIBLE_TIME_AFTER_UPGRADE;
        }

        public function _onTouchScreen(eventArgs:Object):void {
            if (GameRecord.playerLife <= 0) { return; }

            if (GameRecord.playerEnergy < GameConst.WARP_ENERGY_COST) {
                // cannot warp due to a lack of energy
                sendMessage(GameEvent.OUT_OF_ENERGY);
                return;
            }
            GameRecord.playerEnergy -= GameConst.WARP_ENERGY_COST;

            // warp
            _targetX = eventArgs.x;
            _targetY = eventArgs.y;

            createActor(new Ray(x, y, _targetX, _targetY), 'l-ray');
            playSe('move');

            // to be invincible for a short time after warp
            if (_invincibleTime < GameConst.INVINCIBLE_TIME_AFTER_WARP) {
                _invincibleTime = GameConst.INVINCIBLE_TIME_AFTER_WARP;
            }
            // 移動直後のわずかな間はエネルギーが自然回復しない
            // （アイテム回復も一瞬行わない）
            _noRecoverTime    = GameConst.NO_RECOVER_TIME_AFTER_WARP;
            _itemDisabledTime = GameConst.ITEM_DISABLED_TIME_AFTER_WARP;

            // show touch marker
            var touchCircle:TouchCircle = new TouchCircle(_targetX, _targetY);
            createActor(touchCircle);
        }

        public function _onCollide(otherGroupName:String, otherShape:TkCollisionShape):void {
            if (otherGroupName == 'c-enemy'  ||
                otherGroupName == 'c-bullet') {
                // damage
                if (_invincibleTime <= 0) {
                    _invincibleTime = GameConst.INVINCIBLE_TIME_AFTER_DAMAGE;
                    _damage();
                }
            }
            else if (otherGroupName == 'c-item') {
                if (_itemDisabledTime <= 0) {
                    var itemRecovery:Number = GameRecord.playerStatus.getValue(PlayerStatus.ENERGY_RECOVER);
                    _recoverWarpEnergy(itemRecovery);
                }
            }
        }

        private function _damage():void {
            playSe('player_damage');

            // reduce life
            GameRecord.playerLife -= 1;
            if (GameRecord.playerLife == 0) {
                sendMessage(GameEvent.GAME_OVER);
            }

            colorIn(0xff0000, 0.7, 0.6);

            color = 0xff2222;
            _energyActor.setDamagedColor();

            // blink while player is invincible
            var blinkMe:Function = function(action:TkAction):void {
                alpha = (action.frame % 2 == 0) ? 0.3 : 1;
            }
            var blinkTime:Number = GameConst.INVINCIBLE_TIME_AFTER_DAMAGE - 0.5;
            act().goon(blinkTime, blinkMe).alphaTo(0, 1);

            // stop other layer for a while
            var stopLayer:Function = function(action:TkAction):void {
                setTimeScale('l-back',  0.1);
                setTimeScale('l-enemy', 0.1);
            };
            var restartLayer:Function = function(action:TkAction):void {
                resetTimeScale('l-back');
                resetTimeScale('l-enemy');
            };
            act().doit(1.0, stopLayer).doit(0, restartLayer);
        }
    }
}
