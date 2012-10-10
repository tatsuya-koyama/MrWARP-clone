package mrwarp {

    import starling.errors.AbstractClassError;

    public class GameEvent {

        public function GameEvent() {
            // prohibit the instantiation of class
            throw new AbstractClassError();
        }

        public static const GAME_OVER:String         = 'mr.gameover';
        public static const RETURN_TO_TITLE:String   = 'mr.returnToTitle';
        public static const OPEN_UPGRADE_MENU:String = 'mr.upgradeMenuOpen';
        public static const DEFEAT_BOSS:String       = 'mr.defeatBoss';

        // player try to warp when energy is in shortage
        public static const OUT_OF_ENERGY:String = 'mr.outOfEnergy';

        // expected args: {level:int}
        public static const GAME_LEVEL_UP:String = 'mr.gameLevelUp';

        // expected args: {x:Number, y:Number} (enemy dying position)
        public static const ENEMY_DAMAGED:String  = 'mr.enemyDamaged';
        public static const ENEMY_DEFEATED:String = 'mr.enemyDefeated';

        // expected args: {dx:Number, dy:Number}
        public static const SCROLL_SCREEN:String = 'mr.screenScroll';
    }
}
