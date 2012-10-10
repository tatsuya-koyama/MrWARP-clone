package mrwarp.actor.enemy_generator {

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkutility.TkUtil;

    import mrwarp.GameRecord;
    import mrwarp.GameConst;
    import mrwarp.actor.EnemyGenerator;
    import mrwarp.actor.enemy.Enemy;
    import mrwarp.actor.enemy.EnemyFactory;
    import mrwarp.actor.enemy.EnemyUnitFactory;

    //------------------------------------------------------------
    public class TutorialEnemyGenerator extends EnemyGenerator {

        //------------------------------------------------------------
        public override function init():void {
            super.init();
            addScheduledTask(30 - GameConst.LEVEL_UP_CYCLE, function():void {
                addPeriodicTask(GameConst.LEVEL_UP_CYCLE, _increaseGameLevel);
            });

            addScheduledTask( 5.5, _onGenerateTutorialEnemy_1);
            addScheduledTask(10.0, _onGenerateTutorialEnemy_2);
            addScheduledTask(12.0, _onGenerateTutorialEnemy_3);
            addScheduledTask(17.0, _onGenerateTutorialEnemy_4);
            addScheduledTask(17.6, _onGenerateTutorialEnemy_4);

            // debug
            GameRecord.cameraFollowSpeed = 0;
        }

        protected override function onGenerateEnemy():void {
            if (GameRecord.gameLevel <= 1) { return; }  // during tutorial
            super.onGenerateEnemy();
        }

        //------------------------------------------------------------
        /**
         * チュートリアルの最初の敵
         * 上側中央から縦編隊がまっすぐ降りてくる
         */
        private function _onGenerateTutorialEnemy_1():void {
            _createEnemies(EnemyUnitFactory.linearMoveLine(
                5, 0, 30, 0, 0, 0, 20
            ));
        }

        /**
         * チュートリアルの敵
         * 上側左から横編隊がまっすぐ降りてくる
         */
        private function _onGenerateTutorialEnemy_2():void {
            _createEnemies(EnemyUnitFactory.linearMoveWall(
                5, 0, 30, -150, 0, 0, 20
            ));
        }

        // こちらは上側右から
        private function _onGenerateTutorialEnemy_3():void {
            _createEnemies(EnemyUnitFactory.linearMoveWall(
                5, 0, 30, 150, 0, 0, 20
            ));
        }

        // 下から上に列になって迫る  飛び越えて倒すしかない
        private function _onGenerateTutorialEnemy_4():void {
            _createEnemies(EnemyUnitFactory.linearMoveWall(
                15, 0, -30, 0, 0, 0, -10
            ));
        }
    }
}
