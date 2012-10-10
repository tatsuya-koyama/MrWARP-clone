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
    import mrwarp.actor.EnemyBullet;
    import mrwarp.actor.enemy.Enemy;
    import mrwarp.actor.enemy.EnemyBehavior;

    //------------------------------------------------------------
    public class BossBehavior extends EnemyBehavior {

        private var _vx:Number = 0;
        private var _vy:Number = 0;

        private var _shootTime:Number     = 0;
        private var _shootInterval:Number = 3.0;
        private var _shootFrame:int       = 0;
        private var _shootHandler:Function = null;

        //------------------------------------------------------------
        public function setParam(initX:Number, initY:Number):void {
            _initX = initX;
            _initY = initY;
        }

        public override function init():void {
            _enemy.x = _initX;
            _enemy.y = _initY;

            _enemy.life    = 24;
            _enemy.maxLife = 24;
            _enemy.numPlayerEnergy = TkUtil.within(
                30 + GameRecord.gameLevel, 30, 80
            );

            addScheduledTask(1.0, function():void {
                addPeriodicTask(2.0, _changeDirection);
            });

            addPeriodicTask(0.1, _onShoot);

            // 1 分で倒せなかったら自然死
            addScheduledTask(60.0, _onNaturalDeath);
        }

        private function _onNaturalDeath():void {
            _enemy.act().alphaTo(2.0, 0).kill();
        }

        public override function onDying():void {
            whiteIn(0.4);
            sendMessage(GameEvent.DEFEAT_BOSS);
        }

        private function _changeDirection():void {
            _vx = TkUtil.randPlusOrMinus(0, 30);
            _vy = TkUtil.randPlusOrMinus(0, 30);

            // 画面の外にあまり行かないように考慮
            if (_enemy.x > 320 - 80  &&  _vx > 0) { _vx *= -2; }
            if (_enemy.x <   0 + 80  &&  _vx < 0) { _vx *= -2; }

            if (_enemy.y > 480 - 80  &&  _vy > 0) { _vy *= -2; }
            if (_enemy.y <   0 + 80  &&  _vy < 0) { _vy *= -2; }
        }

        public override function onUpdate(passedTime:Number):void {
            _survivalTime += passedTime;

            _enemy.x += _vx * passedTime;
            _enemy.y += _vy * passedTime;

            // appear
            if (_survivalTime < 2.0) {
                _enemy.y += 170 * passedTime;
            }

            _updateShootTimer(passedTime);
            //_repeatCoordinate();
        }

        private function _updateShootTimer(passedTime:Number):void {
            _shootTime -= passedTime;
            if (_shootTime <= 0) {
                if (_shootInterval > 0) {
                    _shootInterval -= passedTime;
                    return;
                }
                _changeShootPattern();
            }
        }

        //------------------------------------------------------------
        // Shoot Patterns
        //------------------------------------------------------------
        private function _changeShootPattern():void {
            // 0: shoot duration
            // 1: interval after shoot
            // 2: shoot function
            const patternList:Array = [
                 [2.0, 1.0, _shootWindmill]
                ,[3.0, 1.0, _shootCircle]
                ,[2.0, 2.0, _shootSlowCircle]
                ,[2.0, 1.0, _shootBig]
            ];
            var randomIndex:int = TkUtil.randInt(patternList.length);
            var pattern:Array = patternList[randomIndex];

            _shootTime     = pattern[0];
            _shootInterval = pattern[1];
            _shootHandler  = pattern[2];
        }

        private function _onShoot():void {
            if (_shootTime <= 0  &&  _shootInterval > 0) { return; }

            ++_shootFrame;
            if (_shootHandler != null) { _shootHandler(); }
        }

        /**
         * 風車状の放射弾
         */
        private function _shootWindmill():void {
            if (_shootFrame % 2 != 0) { return; }

            var numWay:int = TkUtil.selectValue(GameRecord.gameLevel, [
                [0, 4], [30, 6], [50, 8]
            ]);
            var shootDensity:int = TkUtil.selectValue(GameRecord.gameLevel, [
                [0, 3], [40, 5], [70, 7], [80, 10]
            ]);
            var speed:Number = TkUtil.selectValue(GameRecord.gameLevel, [
                [0, 100], [20, 120], [30, 140], [40, 160], [50, 180],
                [60, 200], [70, 220], [80, 240], [90, 260], [100, 300]
            ]);

            for (var i:int=0;  i < numWay;  ++i) {
                if ((_shootFrame / 2) % 10 > shootDensity) { continue; }
                var angle:Number = (360 / numWay * i) + (_shootFrame * 2);
                var bullet:EnemyBullet = EnemyBullet.makeWithAngle(
                    _enemy.x, _enemy.y, angle, speed, 20,
                    (i % 2 == 0) ? 0xff0088 : 0x8888ff
                );
                createActor(bullet);
            }
        }

        private function _shootCircle():void {
            if (_shootFrame % 15 != 0) { return; }

            var shootDensity:int = TkUtil.selectValue(GameRecord.gameLevel, [
                [0, 3], [20, 4], [30, 5], [40, 6], [50, 7], [60, 8], [70, 9], [80, 10]
            ]);
            var speed:Number = TkUtil.selectValue(GameRecord.gameLevel, [
                [0, 100], [20, 120], [30, 140], [40, 160], [50, 180],
                [60, 200], [70, 220], [80, 240], [90, 260], [100, 300]
            ]);

            for (var i:int=0;  i < 128;  ++i) {
                if ((i % 16) > shootDensity) { continue; }
                var angle:Number = (360 / 64 * i) + _shootFrame;
                var bullet:EnemyBullet = EnemyBullet.makeWithAngle(
                    _enemy.x, _enemy.y, angle, speed, 20, 0x99ff44
                );
                createActor(bullet);
            }
        }

        private function _shootSlowCircle():void {
            if (_shootFrame % 20 != 0) { return; }

            var shootDensity:int = TkUtil.selectValue(GameRecord.gameLevel, [
                [0, 6], [20, 7], [30, 8], [40, 9], [50, 10], [60, 11], [70, 12], [80, 15]
            ]);
            var speed:Number = 60;

            for (var i:int=0;  i < 128;  ++i) {
                if ((i % 16) > shootDensity) { continue; }
                var angle:Number = (360 / 64 * i) + _shootFrame;
                var bullet:EnemyBullet = EnemyBullet.makeWithAngle(
                    _enemy.x, _enemy.y, angle, speed, 20, 0xddff22
                );
                createActor(bullet);
            }
        }

        private function _shootBig():void {
            var shootCycle:int = TkUtil.selectValue(GameRecord.gameLevel, [
                [0, 10], [20, 9], [30, 8], [40, 7], [50, 6], [60, 5], [70, 4], [80, 3]
            ]);
            if (_shootFrame % shootCycle != 0) { return; }

            var shootSize:int = TkUtil.selectValue(GameRecord.gameLevel, [
                [0, 5], [40, 6], [50, 7], [60, 8], [70, 9], [80, 10]
            ]);

            var angle:Number = TkUtil.rand(360);
            for (var i:int=0;  i < shootSize;  ++i) {
                var bullet:EnemyBullet = EnemyBullet.makeWithAngle(
                    _enemy.x, _enemy.y, angle,
                    80 + (i * 6),
                    20 + (i * 4),
                    0xff2277
                );
                createActor(bullet);
            }
        }
    }
}
