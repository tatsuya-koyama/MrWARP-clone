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
    import mrwarp.actor.EnemyBullet;
    import mrwarp.actor.enemy.EnemyBehavior;

    //------------------------------------------------------------
    public class ShowUpAndShootBehavior extends EnemyBehavior {

        private var _vx:Number;  // こいつがそのままショットのスピードになる
        private var _vy:Number;
        private var _shootTime:Number;
        private var _shootInterval:Number = 0;
        private var _waitTime:Number      = 0;

        //------------------------------------------------------------
        public function setParam(initX:Number, initY:Number,
                                 vx:Number, vy:Number,
                                 shootTime:Number, waitTime:Number=0.5):void {
            _initX = initX;
            _initY = initY;
            _vx = vx;
            _vy = vy;
            _shootTime = shootTime;
            _waitTime  = waitTime;
        }

        public override function init():void {
            _enemy.x = _initX;
            _enemy.y = _initY;
        }

        public override function onUpdate(passedTime:Number):void {
            // 画面内に入ったら一定時間弾を撃つ
            if (_shootTime > 0) {
                if (0 < _enemy.x - _enemy.cachedWidth /2.5  &&  _enemy.x + _enemy.cachedWidth /2.5 < 320  &&
                    0 < _enemy.y - _enemy.cachedHeight/2.5  &&  _enemy.y + _enemy.cachedHeight/2.5 < 480) {
                    _shootTime -= passedTime;
                    _shoot(passedTime);
                    return;
                }
            }

            // 撃った後にその場に少しとどまる
            if (_shootTime <= 0  &&  _waitTime > 0) {
                _waitTime -= passedTime;
                return;
            }

            var direction:int = (_shootTime > 0) ? 1 : -1;
            _enemy.x += _vx * passedTime * direction;
            _enemy.y += _vy * passedTime * direction;

            super.onUpdate(passedTime);
        }

        private function _shoot(passedTime:Number):void {
            _shootInterval -= passedTime;
            if (_shootInterval <= 0) {
                _shootInterval += 0.2;
            } else {
                return;
            }

            var bullet:EnemyBullet = new EnemyBullet(
                _enemy.x, _enemy.y, _vx, _vy, 20
            );
            createActor(bullet);
        }
    }
}
