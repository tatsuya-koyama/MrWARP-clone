package mrwarp.actor {

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkutility.TkUtil;

    import mrwarp.GameConst;
    import mrwarp.GameRecord;
    import mrwarp.GameEvent;
    import mrwarp.actor.enemy.Enemy;
    import mrwarp.actor.enemy.EnemyFactory;
    import mrwarp.actor.enemy.EnemyUnitFactory;

    /**
     * Manage enemy level design of the game.
     *
     * このソースを読んでいる若者へ：
     *     ゲームの規模がでかくなったらここやこれの派生クラスに書いてあるようなことを
     *     外部データ（json とか xml とか任意の DSL）で書けるようにするとよい
     */
    //------------------------------------------------------------
    public class EnemyGenerator extends TkActor {

        protected var _totalPassedTime:Number = 0;
        protected var _generateFrameCount:int = 0;
        protected var _generateCycle:int      = 20;

        //------------------------------------------------------------
        /**
         * １秒に 30 回 _generateFrameCount をマイナス方向にカウントする
         * これが 0 を切ると onGenerateEnemy が呼ばれ、カウントに
         * _generateCycle の値が加算される。
         *
         * 敵１ユニットを 1 秒に ２回出したければ _generateCycle に 15 をセットする。
         * 特殊なユニットを出して次のユニットまでに時間を空けたい場合は
         * _generateFrameCount に任意の値を加算すればよい。
         */
        public override function init():void {
            addPeriodicTask(1/30, function():void {
                --_generateFrameCount;
                if (_generateFrameCount <= 0) {
                    _generateFrameCount += _generateCycle;
                    onGenerateEnemy();
                }
            });

            onGameLevelUp(GameRecord.gameLevel);
        }

        protected function _createEnemies(enemies:Vector.<Enemy>):void {
            for each (var enemy:Enemy in enemies) {
                createActor(enemy);
            }
        }

        public override function onUpdate(passedTime:Number):void {
            _totalPassedTime += passedTime;
        }

        protected function _increaseGameLevel():void {
            ++GameRecord.gameLevel;
            onGameLevelUp(GameRecord.gameLevel);
            sendMessage(GameEvent.GAME_LEVEL_UP, {level: GameRecord.gameLevel});
        }

        protected function _selectValue(targetThreshold:int, thresholds:Array):Number {
            return TkUtil.selectValue(targetThreshold, thresholds);
        }

        //------------------------------------------------------------
        // level design
        //------------------------------------------------------------
        // 必要に応じて override せよ
        protected function onGameLevelUp(level:int):void {
            /**
             * １レベル 15 秒
             * Lv. 4  で 1 分
             * Lv.40  で 10 分
             * Lv.240 で 1 時間
             * 開発者的にはうまくても Lv.100 程度で死んでほしい
             */

            /**
             * 最初 50 で始まって Lv.100 で 7 まで減る
             * （敵出現の頻度が 1.66 秒に１回 -> 0.23 秒に１回）
             */
            _generateCycle = TkUtil.selectValue(level, [
                [ 0, 50], [ 3, 46], [ 4, 42], [ 5, 38], [ 6, 35],
                [ 7, 32], [ 8, 30], [ 9, 28],
                [10, 27], [12, 26], [14, 25], [16, 24], [18, 23],
                [20, 22], [22, 21], [24, 20], [26, 19], [28, 18],
                [30, 17], [35, 16], [40, 15], [45, 14],
                [50, 13], [55, 12], [60, 11], [65, 10],
                [70, 10], [80,  9], [90,  8], [100, 7]
            ]);

            // boss
            if (level >= 10  && level % 5 == 0) {
                _generateBoss();
            }

            // upgrade item
            if (level >= 3) {
                _generateUpgradeGift();

                if (GameRecord.playMode == 'crazy'
                    && level == GameConst.CRAZY_START_LEVEL) {
                    _giveServiceForCrazyPlayer();
                }
            }
        }

        /**
         * Crazy を選んだプレイヤーには最初に +4 個の Upgrade を出してあげよう
         */
        private function _giveServiceForCrazyPlayer():void {
            for (var i:int=0;  i < 4;  ++i) {
                act().wait(i).justdoit(0, _generateUpgradeGift);
            }
        }

        protected function onGenerateEnemy():void {
            var factories:Array = [
                // ゆっくり隊列と弓なり配列
                 {weight: 10, func: _linearMoveHorizontalWall}
                ,{weight: 10, func: _linearMoveVerticalWall}
                ,{weight: 18, func: _linearMoveArrow}
                ,{weight:  5, func: _generateEnergyGift}
            ];

            if (GameRecord.gameLevel >= 3) {
                // 顔出しダッシュ系
                factories.push({weight: 10, func: _showUpAndDashHorizontalWall});
                factories.push({weight: 10, func: _showUpAndDashVerticalWall});
            }
            if (GameRecord.gameLevel >= 4) {
                // 回転ショット系
                factories.push({weight: 10, func: _linearMoveAndShoot});
            }
            if (GameRecord.gameLevel >= 5) {
                // 顔出しラインショット系
                factories.push({weight: 7, func: _showUpAndShootHorizontalLine});
                factories.push({weight: 7, func: _showUpAndShootVerticalLine});
            }
            if (GameRecord.gameLevel >= 9) {
                // 顔出しウォールショット系
                factories.push({weight: 7, func: _showUpAndShootHorizontalWall});
                factories.push({weight: 7, func: _showUpAndShootVerticalWall});
            }

            TkUtil.selectFunc(factories);
        }

        //------------------------------------------------------------
        // enemy factories
        //------------------------------------------------------------
        protected function _getMaxSpeedOffset(level:int=-1):Number {
            if (level == -1) { level = GameRecord.gameLevel; }
            var offset:Number = level * 1.0;
            offset = TkUtil.within(offset, 0, 100);
            return offset;
        }

        /**
         * ボス
         */
        protected function _generateBoss():void {
            createActor(EnemyFactory.boss());
        }

        /**
         * エネルギーいっぱい出るアイテム
         */
        protected function _generateEnergyGift():void {
            createActor(EnemyFactory.energyGift());
        }

        /**
         * アップグレードできるアイテム
         */
        protected function _generateUpgradeGift():void {
            createActor(EnemyFactory.upgradeGift());
        }

        /**
         * 縦並びの編隊が左か右から現れ直線運動で通過
         *    @ ->     <- @
         *    @ ->     <- @
         *    @ ->     <- @
         */
        protected function _linearMoveVerticalWall():void {
            var vOffset:Number = _getMaxSpeedOffset();
            var vx:Number = TkUtil.randPlusOrMinus(30, 50 + vOffset * 2);
            var vy:Number = 0;
            var offsetX:Number = 0;
            var offsetY:Number = TkUtil.randPlusOrMinus(0, 200);

            var num:int = _selectValue(GameRecord.gameLevel, [
                [0, 1], [3, 2], [5, 3], [7, 4], [10, 5]
            ]);
            _createEnemies(EnemyUnitFactory.linearMoveWall(
                num, vx, vy, offsetX, offsetY
            ));
        }

        /**
         * 横並びの編隊が上か下から現れ直線運動で通過
         *     @ @ @    ^ ^ ^
         *     | | |    | | |
         *     v v v    @ @ @
         */
        protected function _linearMoveHorizontalWall():void {
            var vOffset:Number = _getMaxSpeedOffset();
            var vx:Number = 0;
            var vy:Number = TkUtil.randPlusOrMinus(30, 50 + vOffset * 2);
            var offsetX:Number = TkUtil.randPlusOrMinus(0, 120);
            var offsetY:Number = 0;

            var num:int = _selectValue(GameRecord.gameLevel, [
                [0, 1], [3, 2], [5, 3], [7, 4], [10, 5]
            ]);
            _createEnemies(EnemyUnitFactory.linearMoveWall(
                num, vx, vy, offsetX, offsetY
            ));
        }

        /**
         * 弓なり編隊が 360 度方向から出現、画面中央付近を直線運動で通過
         *    @ ->
         *      @ ->
         *        @ ->
         *      @ ->
         *    @ ->
         */
        protected function _linearMoveArrow():void {
            var vOffset:Number = _getMaxSpeedOffset();
            var vx:Number = TkUtil.randPlusOrMinus(30, 50 + vOffset);
            var vy:Number = TkUtil.randPlusOrMinus(30, 50 + vOffset);
            var offsetX:Number = TkUtil.randPlusOrMinus(0, 90);
            var offsetY:Number = TkUtil.randPlusOrMinus(0, 90);

            var num:int = _selectValue(GameRecord.gameLevel, [
                [0, 3], [4, 4], [6, 5], [10, 6]
            ]);
            _createEnemies(EnemyUnitFactory.linearMoveArrow(
                num, vx, vy, offsetX, offsetY
            ));
        }

        /**
         * 縦並びの編隊が左か右から現れ直線運動で通過
         * ひょこっと顔出してから高速移動
         *    -> @ ... ==>
         *    -> @ ... ==>
         *    -> @ ... ==>
         */
        protected function _showUpAndDashVerticalWall():void {
            var vOffset:Number = _getMaxSpeedOffset();
            var vx:Number = TkUtil.randPlusOrMinus(150, 200 + vOffset);
            var vy:Number = 0;
            var offsetX:Number  = 0;
            var offsetY:Number  = TkUtil.randPlusOrMinus(0, 200);
            var waitTime:Number = 0.8;

            var num:int = _selectValue(GameRecord.gameLevel, [
                [0, 2], [5, 3], [10, 4], [15, 5]
            ]);
            _createEnemies(EnemyUnitFactory.showUpAndDashWall(
                num, vx, vy, offsetX, offsetY, waitTime
            ));
        }

        /**
         * 横並びの編隊が上か下から現れ直線運動で通過
         * ひょこっと顔出してから高速移動
         *      @  @  @
         *      :  :  :
         *      |  |  |
         *      V  V  V
         */
        protected function _showUpAndDashHorizontalWall():void {
            var vOffset:Number = _getMaxSpeedOffset();
            var vx:Number = 0;
            var vy:Number = TkUtil.randPlusOrMinus(150, 200 + vOffset);
            var offsetX:Number  = TkUtil.randPlusOrMinus(0, 120);
            var offsetY:Number  = 0;
            var waitTime:Number = 0.8;

            var num:int = _selectValue(GameRecord.gameLevel, [
                [0, 2], [5, 3], [10, 4], [15, 5], [20, 6]
            ]);
            _createEnemies(EnemyUnitFactory.showUpAndDashWall(
                num, vx, vy, offsetX, offsetY, waitTime
            ));
        }

        /**
         * 縦並びの編隊が左か右から現れ
         * ひょこっと顔出して一定時間弾撃って帰る
         *    -> @  ... x x x x x
         */
        protected function _showUpAndShootVerticalLine():void {
            var vOffset:Number = _getMaxSpeedOffset();
            var vx:Number = 150 + vOffset;
            var vy:Number = 0;
            if (GameRecord.gameLevel > 30) {
                vy = TkUtil.randPlusOrMinus(0, vOffset);
            }
            var offsetX:Number = 0;
            var offsetY:Number = TkUtil.randPlusOrMinus(0, 200);

            var shootTime:Number = _selectValue(GameRecord.gameLevel, [
                [0, 0.5], [7, 0.8], [9, 1.0], [12, 1.3],
                [15, 0.8], [17, 1.3], [20, 1.6], [25, 2.0]
            ]);
            var num:int = _selectValue(GameRecord.gameLevel, [
                [0, 1], [15, 2]
            ]);
            _createEnemies(EnemyUnitFactory.showUpAndShootWall(
                num, vx, vy, offsetX, offsetY, shootTime
            ));
        }

        /**
         * 横並びの編隊が上か下から
         * ひょこっと顔出して一定時間弾撃って帰る
         *      @
         *      :
         *      x
         *      x
         */
        protected function _showUpAndShootHorizontalLine():void {
            var vOffset:Number = _getMaxSpeedOffset();
            var vx:Number = 0;
            var vy:Number = 150 + vOffset;
            if (GameRecord.gameLevel > 30) {
                vx = TkUtil.randPlusOrMinus(0, vOffset);
            }
            var offsetX:Number = TkUtil.randPlusOrMinus(0, 120);
            var offsetY:Number = 0;

            var shootTime:Number = _selectValue(GameRecord.gameLevel, [
                [0, 0.5], [7, 0.8], [9, 1.0], [12, 1.3],
                [15, 0.8], [17, 1.3], [20, 1.6], [25, 2.0]
            ]);
            var num:int = _selectValue(GameRecord.gameLevel, [
                [0, 1], [15, 2]
            ]);
            _createEnemies(EnemyUnitFactory.showUpAndShootWall(
                1, vx, vy, offsetX, offsetY, shootTime
            ));
        }

        /**
         * 縦並びの編隊が左か右から現れ
         * ひょこっと顔出して壁となる弾を撃って帰る
         *    -> @  ... x
         *    -> @  ... x
         *    -> @  ... x
         */
        protected function _showUpAndShootVerticalWall():void {
            var vOffset:Number = _getMaxSpeedOffset();
            var vx:Number = 80 + vOffset;
            var vy:Number = 0;
            var offsetX:Number = 0;
            var offsetY:Number = TkUtil.randPlusOrMinus(0, 200);
            var shootTime:Number = 0.2;
            var waitTime:Number  = 1.0;

            var num:int = _selectValue(GameRecord.gameLevel, [
                [0, 3], [10, 4], [15, 5], [18, 6]
            ]);
            _createEnemies(EnemyUnitFactory.showUpAndShootWall(
                num, vx, vy, offsetX, offsetY, shootTime, waitTime
            ));
        }

        /**
         * 横並びの編隊が上か下から
         * ひょこっと顔出して壁となる弾を撃って帰る
         *      @  @  @
         *      :  :  :
         *      x  x  x
         */
        protected function _showUpAndShootHorizontalWall():void {
            var vOffset:Number = _getMaxSpeedOffset();
            var vx:Number = 0;
            var vy:Number = 80 + vOffset;
            var offsetX:Number = TkUtil.randPlusOrMinus(0, 120);
            var offsetY:Number = 0;
            var shootTime:Number = 0.3;
            var waitTime:Number  = 1.0;

            var num:int = _selectValue(GameRecord.gameLevel, [
                [0, 3], [10, 4], [15, 5], [18, 6]
            ]);
            _createEnemies(EnemyUnitFactory.showUpAndShootWall(
                num, vx, vy, offsetX, offsetY, shootTime, waitTime
            ));
        }

        /**
         * 360度方向から入ってきて回転しながら弾撃ちつつ通過
         *     x
         *      x   x x
         *    ->  @
         *        x
         *      x
         */
        protected function _linearMoveAndShoot():void {
            var vx:Number = TkUtil.randPlusOrMinus(40, 70);
            var vy:Number = TkUtil.randPlusOrMinus(40, 70);
            var offsetX:Number = TkUtil.randPlusOrMinus(0, 90);
            var offsetY:Number = TkUtil.randPlusOrMinus(0, 90);

            var shotWay:int = _selectValue(GameRecord.gameLevel, [
                [0, 1], [10, 2], [20, 3], [30, 4]
            ]);
            _createEnemies(EnemyUnitFactory.linearMoveAndShoot(
                shotWay, vx, vy, 0, 0, offsetX, offsetY
            ));
        }
    }
}
