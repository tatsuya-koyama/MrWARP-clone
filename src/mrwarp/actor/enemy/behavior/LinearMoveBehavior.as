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

    //------------------------------------------------------------
    public class LinearMoveBehavior extends EnemyBehavior {

        private var _vx:Number;  // speed (velocity vector element)
        private var _vy:Number;
        private var _ax:Number;  // acceleration
        private var _ay:Number;  // (not change ratio but increment per 1 second)

        //------------------------------------------------------------
        public function setParam(initX:Number, initY:Number, vx:Number, vy:Number,
                                 ax:Number=0, ay:Number=0):void {
            _initX = initX;
            _initY = initY;
            _vx = vx;
            _vy = vy;
            _ax = ax;
            _ay = ay;
        }

        public override function init():void {
            _enemy.x = _initX;
            _enemy.y = _initY;
        }

        public override function onUpdate(passedTime:Number):void {
            _enemy.x += _vx * passedTime;
            _enemy.y += _vy * passedTime;
            _vx += (_ax * passedTime);
            _vy += (_ay * passedTime);

            super.onUpdate(passedTime);
        }
    }
}
