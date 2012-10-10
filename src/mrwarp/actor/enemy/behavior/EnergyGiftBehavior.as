package mrwarp.actor.enemy.behavior {

    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.display.Image;
    import starling.display.BlendMode;
    import starling.animation.Transitions;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkutility.TkUtil;

    import mrwarp.GameRecord;
    import mrwarp.actor.enemy.Enemy;
    import mrwarp.actor.enemy.EnemyBehavior;

    /**
     * 倒すといっぱいエネルギーが飛び出すごほうびアイテム
     */
    //------------------------------------------------------------
    public class EnergyGiftBehavior extends EnemyBehavior {

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

            _enemy.numPlayerEnergy = 20;
        }

        public override function onUpdate(passedTime:Number):void {
            _enemy.x += _vx * passedTime;
            _enemy.y += _vy * passedTime;

            super.onUpdate(passedTime);
        }
    }
}
