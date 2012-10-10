package mrwarp {

    import starling.errors.AbstractClassError;

    public class GameConst {

        public function GameConst() {
            // prohibit the instantiation of class
            throw new AbstractClassError();
        }

        public static const SHOW_PERFORMANCE:Boolean = true;
        public static const DEBUG_MODE:Boolean       = false;
        public static const PROFILE_MODE:Boolean     = false;

        // game screen resolution
        public static const SCREEN_WIDTH:int  = 320;
        public static const SCREEN_HEIGHT:int = 480;

        public static const ASPECT_RATIO:Number = SCREEN_HEIGHT / SCREEN_WIDTH;

        // game specific parameters
        public static const NORMAL_START_LEVEL:int = 7;
        public static const CRAZY_START_LEVEL:int  = 42;
        public static const LEVEL_UP_CYCLE:Number  = 15.0;  // [sec]

        public static const NO_RECOVER_TIME_AFTER_WARP:Number    = 0.40;
        public static const ITEM_DISABLED_TIME_AFTER_WARP:Number = 0.20;
        public static const INVINCIBLE_TIME_AFTER_WARP:Number    = 0.5;
        public static const INVINCIBLE_TIME_AFTER_DAMAGE:Number  = 4.0;
        public static const INVINCIBLE_TIME_AFTER_UPGRADE:Number = 3.0;

        public static const WARP_ENERGY_COST:Number         = 5;
        public static const ENERGY_RECOVERY_PER_SEC:Number  = 17;
        public static const ENERGY_PARTICLE_RECOVERY:Number = 1.0;

        // max acceptable number of energy items
        public static const ALLOWED_ITEM_NUM:int = 100;
    }
}
