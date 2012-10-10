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
    public class RandomMoveBehavior extends EnemyBehavior {

        private var _vx:Number;
        private var _vy:Number;

        //------------------------------------------------------------
        public override function init():void {
            _enemy.x = TkUtil.rand(320);
            _vx = TkUtil.randPlusOrMinus(3, 30);

            if (TkUtil.rand(2) < 1) {
                // from upper side
                _enemy.y = TkUtil.randArea(-200, -100);
                _vy = TkUtil.randArea(10, 40);
            } else {
                // from lower side
                _enemy.y = TkUtil.randArea(580, 780);
                _vy = TkUtil.randArea(-10, -40);
            }
        }

        public override function onUpdate(passedTime:Number):void {
            _enemy.x += _vx * passedTime;
            _enemy.y += _vy * passedTime;
            _vx *= 1.001;
            _vy *= 1.001;

            if (_enemy.x < 0  ||  _enemy.x > 320) { _vx = -_vx; }

            if (_enemy.y < -200  ||  _enemy.y > 780) { _enemy.passAway(); }
        }
    }
}
