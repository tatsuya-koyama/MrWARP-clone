package mrwarp.actor.enemy {

    import tatsuyakoyama.tkutility.TkUtil;
    import tatsuyakoyama.tkutility.TkVector2D;

    //------------------------------------------------------------
    public class EnemyUnitFactory {

        /**
         * n 体で並んで直線運動
         * 進行方向に対してまっすぐ並んだ隊列
         */
        public static function linearMoveLine(num:int, vx:Number, vy:Number,
                                              offsetX:Number=0, offsetY:Number=0,
                                              ax:Number=0, ay:Number=0):Vector.<Enemy> {
            var enemies:Vector.<Enemy> = new Vector.<Enemy>();
            var initX:Number;
            var initY:Number;
            var enemySize:Number = 40;
            var directionVector:TkVector2D = new TkVector2D(vx, vy);
            directionVector = directionVector.normalize();

            for (var i:int=0;  i < num;  ++i) {
                initX = (160 + offsetX) - directionVector.x * 300;
                initY = (240 + offsetY) - directionVector.y * 300;

                var enemyX:Number = initX - (directionVector.x * enemySize * i);
                var enemyY:Number = initY - (directionVector.y * enemySize * i);

                EnemyFactory.viewType = EnemyFactory.ViewType_Normal;
                enemies.push(
                    EnemyFactory.linearMove(enemyX, enemyY, vx, vy, ax, ay)
                );
            }
            return enemies;
        }

        /**
         * n 体で並んで直線運動
         * 進行方向に対して垂直な隊列
         */
        public static function linearMoveWall(num:int, vx:Number, vy:Number,
                                              offsetX:Number=0, offsetY:Number=0,
                                              ax:Number=0, ay:Number=0):Vector.<Enemy> {
            var enemies:Vector.<Enemy> = new Vector.<Enemy>();
            var initX:Number;
            var initY:Number;
            var enemySize:Number = 40;
            var directionVector:TkVector2D = new TkVector2D(vx, vy);
            var normalVector:TkVector2D    = new TkVector2D(vy, -vx);
            directionVector = directionVector.normalize();
            normalVector    = normalVector.normalize();

            for (var i:int=0;  i < num;  ++i) {
                initX = (160 + offsetX) - directionVector.x * 300;
                initY = (240 + offsetY) - directionVector.y * 300;

                var posUnitX:Number = (normalVector.x * enemySize);
                var posUnitY:Number = (normalVector.y * enemySize);
                var enemyX:Number = initX - (posUnitX * (num-1) / 2) + (posUnitX * i);
                var enemyY:Number = initY - (posUnitY * (num-1) / 2) + (posUnitY * i);

                EnemyFactory.viewType = EnemyFactory.ViewType_Normal;
                enemies.push(
                    EnemyFactory.linearMove(enemyX, enemyY, vx, vy, ax, ay)
                );
            }
            return enemies;
        }

        /**
         * n 体で並んで直線運動、画面中央付近を通過
         * 進行方向に対してちょっととがった並びになる
         * ぶっちゃけて言うと Every Extend 編隊
         */
        public static function linearMoveArrow(num:int, vx:Number, vy:Number,
                                               offsetX:Number=0, offsetY:Number=0):Vector.<Enemy> {
            var enemies:Vector.<Enemy> = new Vector.<Enemy>();
            var initX:Number;
            var initY:Number;
            var enemySize:Number = 35;
            var directionVector:TkVector2D = new TkVector2D(vx, vy);
            var normalVector:TkVector2D    = new TkVector2D(vy, -vx);
            directionVector = directionVector.normalize();
            normalVector    = normalVector.normalize();

            for (var i:int=0;  i < num;  ++i) {
                initX = (160 + offsetX) - directionVector.x * 400;
                initY = (240 + offsetY) - directionVector.y * 400;

                // 配置を弓なりにする
                var distFromCenter:int = Math.abs((num-1)/2 - i);
                initX -= directionVector.x * distFromCenter * 22;
                initY -= directionVector.y * distFromCenter * 22;

                var posUnitX:Number = (normalVector.x * enemySize);
                var posUnitY:Number = (normalVector.y * enemySize);
                var enemyX:Number = initX - (posUnitX * num / 2) + (posUnitX * i);
                var enemyY:Number = initY - (posUnitY * num / 2) + (posUnitY * i);

                EnemyFactory.viewType = EnemyFactory.ViewType_Fool;
                enemies.push(
                    EnemyFactory.linearMove(enemyX, enemyY, vx, vy)
                );
            }
            return enemies;
        }

        /**
         * n 体で並んで高速直線運動
         * 進行方向に対して垂直な隊列
         * ただしひょこっと顔出してちょっと止まった後に突進する
         */
        public static function showUpAndDashWall(num:int, vx:Number, vy:Number,
                                                 offsetX:Number=0, offsetY:Number=0,
                                                 waitTime:Number=1.0):Vector.<Enemy> {
            var enemies:Vector.<Enemy> = new Vector.<Enemy>();
            var initX:Number;
            var initY:Number;
            var enemySize:Number = 40;
            var directionVector:TkVector2D = new TkVector2D(vx, vy);
            var normalVector:TkVector2D    = new TkVector2D(vy, -vx);
            directionVector = directionVector.normalize();
            normalVector    = normalVector.normalize();

            for (var i:int=0;  i < num;  ++i) {
                initX = (160 + offsetX) - directionVector.x * 300;
                initY = (240 + offsetY) - directionVector.y * 300;

                var posUnitX:Number = (normalVector.x * enemySize);
                var posUnitY:Number = (normalVector.y * enemySize);
                var enemyX:Number = initX - (posUnitX * num / 2) + (posUnitX * i);
                var enemyY:Number = initY - (posUnitY * num / 2) + (posUnitY * i);

                // 移動中に画面外にはみ出てるようなやつは出さない
                if (vx == 0  &&  (enemyX - enemySize/2 < 0  ||  enemyX + enemySize/2 > 320)) { break; }
                if (vy == 0  &&  (enemyY - enemySize/2 < 0  ||  enemyY + enemySize/2 > 480)) { break; }

                EnemyFactory.viewType = EnemyFactory.ViewType_Anger;
                enemies.push(
                    EnemyFactory.showUpAndDash(enemyX, enemyY, vx, vy, waitTime)
                );
            }
            return enemies;
        }

        /**
         * n 体で並んで顔出して一定時間弾撃って出てきた方向へ帰っていく
         */
        public static function showUpAndShootWall(num:int, vx:Number, vy:Number,
                                                  offsetX:Number=0, offsetY:Number=0,
                                                  shootTime:Number=2.0, waitTime:Number=0.5):Vector.<Enemy> {
            var enemies:Vector.<Enemy> = new Vector.<Enemy>();
            var initX:Number;
            var initY:Number;
            var enemySize:Number = 40;
            var directionVector:TkVector2D = new TkVector2D(vx, vy);
            var normalVector:TkVector2D    = new TkVector2D(vy, -vx);
            directionVector = directionVector.normalize();
            normalVector    = normalVector.normalize();

            for (var i:int=0;  i < num;  ++i) {
                initX = (160 + offsetX) - directionVector.x * 300;
                initY = (240 + offsetY) - directionVector.y * 300;

                var posUnitX:Number = (normalVector.x * enemySize);
                var posUnitY:Number = (normalVector.y * enemySize);
                var enemyX:Number = initX - (posUnitX * num / 2) + (posUnitX * i);
                var enemyY:Number = initY - (posUnitY * num / 2) + (posUnitY * i);

                // 移動中に画面外にはみ出てるようなやつは出さない
                if (vx == 0  &&  (enemyX - enemySize/2 < 0  ||  enemyX + enemySize/2 > 320)) { break; }
                if (vy == 0  &&  (enemyY - enemySize/2 < 0  ||  enemyY + enemySize/2 > 480)) { break; }

                EnemyFactory.viewType = EnemyFactory.ViewType_Anger;
                enemies.push(
                    EnemyFactory.showUpAndShoot(
                        enemyX, enemyY, vx, vy, shootTime, waitTime
                    )
                );
            }
            return enemies;
        }

        /**
         * 弾を回転方向に撃ちながら画面中央付近を通過
         */
        public static function linearMoveAndShoot(
            shotWay:int, vx:Number, vy:Number, ax:Number, ay:Number,
            offsetX:Number=0, offsetY:Number=0):Vector.<Enemy>
        {
            var enemies:Vector.<Enemy> = new Vector.<Enemy>();
            var directionVector:TkVector2D = new TkVector2D(vx, vy);
            directionVector = directionVector.normalize();

            var initX:Number = (160 + offsetX) - directionVector.x * 400;
            var initY:Number = (240 + offsetY) - directionVector.y * 400;

            EnemyFactory.viewType = EnemyFactory.ViewType_Clever;
            enemies.push(
                EnemyFactory.linearMoveAndShoot(initX, initY, vx, vy, ax, ay, shotWay)
            );
            return enemies;
        }
    }
}
