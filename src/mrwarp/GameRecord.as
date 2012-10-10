package mrwarp {

    import starling.errors.AbstractClassError;

    public class GameRecord {

        public function GameRecord() {
            // prohibit the instantiation of class
            throw new AbstractClassError();
        }

        //------------------------------------------------------------
        // 永続化データ
        public static var persistentData:GamePersistentData = new GamePersistentData();

        // ゲームの基本データ
        public static var score:int;
        public static var star:int;
        public static var combo:int;
        public static var comboTime:Number;     // [sec]
        public static var playMode:String;      // 'tutorial', 'normal', 'crazy'
        public static var gameLevel:int;

        // パフォーマンスチューニングとかのためにモニターしておきたい系
        public static var numEnemy:int;
        public static var numShot:int;
        public static var numItem:int;
        public static var isUpgrading:Boolean;

        //------------------------------------------------------------
        // プレイヤー関連
        //------------------------------------------------------------
        public static var playerLife:int;
        public static var playerEnergy:Number;  // [0, 100]

        // プレイヤーの座標はよく知りたくなるので
        // ここから参照できるようにしておく
        public static var playerX:Number;
        public static var playerY:Number;

        // Upgrade できるプレイヤーの能力値
        public static var playerStatus:PlayerStatus = new PlayerStatus();
        public static var cameraFollowSpeed:Number = 9;


        //------------------------------------------------------------
        public static function init():void {
            playMode = 'normal';
        }

        public static function reset():void {
            star = 10;
            if (playMode == 'crazy') { star = 500; }

            score     = 0;
            combo     = 0;
            comboTime = 0;
            gameLevel = 1;

            playerLife   = 3;
            playerEnergy = 100;
            playerX = 0;
            playerY = 0;

            numEnemy = 0;
            numShot  = 0;
            numItem  = 0;
            isUpgrading = false;

            playerStatus.reset();
        }

    }
}
