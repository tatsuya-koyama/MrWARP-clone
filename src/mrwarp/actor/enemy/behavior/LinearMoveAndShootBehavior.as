package mrwarp.actor.enemy.behavior {

    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.display.Image;
    import starling.display.BlendMode;
    import starling.animation.Transitions;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkutility.TkUtil;

    import mrwarp.GameRecord;
    import mrwarp.actor.EnemyBullet;
    import mrwarp.actor.enemy.Enemy;
    import mrwarp.actor.enemy.EnemyBehavior;

    //------------------------------------------------------------
    public class LinearMoveAndShootBehavior extends EnemyBehavior {

        private var _vx:Number;  // speed (velocity vector element)
        private var _vy:Number;
        private var _ax:Number;  // acceleration
        private var _ay:Number;  // (not change ratio but increment per 1 second)
        private var _shotWay:int;

        private var _shootFrame:int = 0;;

        //------------------------------------------------------------
        public function setParam(initX:Number, initY:Number, vx:Number, vy:Number,
                                 ax:Number=0, ay:Number=0, shotWay:int=1):void {
            _initX = initX;
            _initY = initY;
            _vx = vx;
            _vy = vy;
            _ax = ax;
            _ay = ay;
            _shotWay = shotWay;

            addPeriodicTask(0.1, _onShoot);
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

            _enemy.rotation += TkUtil.deg2rad(90) * passedTime;

            super.onUpdate(passedTime);
        }

        private function _onShoot():void {
            ++_shootFrame;
            if (_shootFrame % 14 > 1) { return; }

            for (var i:int=0;  i < _shotWay;  ++i) {
                var speed:Number = 90 + (GameRecord.gameLevel / 2.0);
                speed = TkUtil.within(speed, 0, 150);
                var angle:Number = (360 / _shotWay) * i + _enemy.rotation;
                var bullet:EnemyBullet = new EnemyBullet(
                    _enemy.x, _enemy.y,
                    Math.sin(angle) * speed,
                    Math.cos(angle) * speed,
                    20, 0xff8800
                );
                createActor(bullet);
            }
        }
    }
}
