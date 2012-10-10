package mrwarp.actor.enemy_generator {

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkutility.TkUtil;

    import mrwarp.GameRecord;
    import mrwarp.GameConst;
    import mrwarp.GameEvent;
    import mrwarp.actor.EnemyGenerator;
    import mrwarp.actor.enemy.Enemy;
    import mrwarp.actor.enemy.EnemyFactory;
    import mrwarp.actor.enemy.EnemyUnitFactory;

    //------------------------------------------------------------
    public class NormalEnemyGenerator extends EnemyGenerator {

        private var _hasStart:Boolean = false;

        //------------------------------------------------------------
        public override function init():void {
            GameRecord.gameLevel = GameConst.NORMAL_START_LEVEL;
            super.init();

            addScheduledTask(4.0, function():void {
                sendMessage(GameEvent.GAME_LEVEL_UP, {level: GameRecord.gameLevel});
            });

            addScheduledTask(2.0, function():void {
                _hasStart = true;
                addPeriodicTask(GameConst.LEVEL_UP_CYCLE, _increaseGameLevel);
            });

            // debug
            GameRecord.cameraFollowSpeed = 2;
        }

        protected override function onGenerateEnemy():void {
            if (!_hasStart) { return; }

            super.onGenerateEnemy();
        }
    }
}
