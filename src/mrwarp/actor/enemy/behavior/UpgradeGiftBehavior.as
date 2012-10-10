package mrwarp.actor.enemy.behavior {

    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.display.Image;
    import starling.display.BlendMode;
    import starling.animation.Transitions;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkutility.TkUtil;

    import mrwarp.GameRecord;
    import mrwarp.GameEvent;
    import mrwarp.actor.enemy.Enemy;
    import mrwarp.actor.enemy.EnemyBehavior;

    /**
     * 倒すと能力のアップグレードができる画面が開くアイテム
     */
    //------------------------------------------------------------
    public class UpgradeGiftBehavior extends EnemyBehavior {

        private var _vx:Number;  // speed (velocity vector element)
        private var _vy:Number;

        //------------------------------------------------------------
        public function setParam(initX:Number, initY:Number, vx:Number, vy:Number):void {
            _initX = initX;
            _initY = initY;
            _vx = vx;
            _vy = vy;
        }

        public override function init():void {
            _enemy.x = _initX;
            _enemy.y = _initY;

            _enemy.numPlayerEnergy = 0;
        }

        public override function onDying():void {
            if (GameRecord.isUpgrading) { return; }
            GameRecord.isUpgrading = true;

            if (GameRecord.playerLife <= 0) { return; }

            // こいつ自身が UpgradeMenuWindow を createActor してもいいんだが
            // それだと「死んでから 0.2 秒に開く」みたいなことがやりづらい。
            // Action が発動できないんた、0.2 秒後にはこいつは死んでいるのだからね。
            // だからその仕事は FieldScene にやってもらおう
            sendMessage(GameEvent.OPEN_UPGRADE_MENU);
        }

        public override function onUpdate(passedTime:Number):void {
            _enemy.x += _vx * passedTime;
            _enemy.y += _vy * passedTime;

            super.onUpdate(passedTime);
        }
    }
}
