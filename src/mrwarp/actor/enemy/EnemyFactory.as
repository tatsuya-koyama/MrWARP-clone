package mrwarp.actor.enemy {

    import tatsuyakoyama.tkutility.TkUtil;
    import tatsuyakoyama.tkutility.TkVector2D;

    import mrwarp.actor.enemy.behavior.*;
    import mrwarp.actor.enemy.view.*;

    //------------------------------------------------------------
    public class EnemyFactory {

        //------------------------------------------------------------
        // select enemy view
        //------------------------------------------------------------
        public static var viewType:int = 0;

        public static const ViewType_Normal :int = 0;
        public static const ViewType_Anger  :int = 1;
        public static const ViewType_Fool   :int = 2;
        public static const ViewType_Clever :int = 3;
        public static const ViewType_Boss   :int = 4;
        public static const ViewType_Energy :int = 5;
        public static const ViewType_Upgrade:int = 6;

        private static function getView(_viewType:int=-1):EnemyView {
            if (_viewType == -1) { _viewType = EnemyFactory.viewType; }

            switch (_viewType) {
            case ViewType_Normal : return new NormalView();  break;
            case ViewType_Anger  : return new AngerView() ;  break;
            case ViewType_Fool   : return new FoolView()  ;  break;
            case ViewType_Clever : return new CleverView();  break;
            case ViewType_Boss   : return new BossView()  ;  break;
            case ViewType_Energy : return new EnergyGiftView() ;  break;
            case ViewType_Upgrade: return new UpgradeGiftView();  break;
            }

            return new NormalView();
        }

        //------------------------------------------------------------
        public static function linearMove(initX:Number=160, initY:Number=-80,
                                          vx:Number=0, vy:Number=25,
                                          ax:Number=0, ay:Number=0):Enemy {
            var behavior:LinearMoveBehavior = new LinearMoveBehavior();
            behavior.setParam(initX, initY, vx, vy, ax, ay);
            var view:EnemyView = getView();
            var enemy:Enemy = new Enemy(behavior, view);
            return enemy;
        }

        public static function showUpAndDash(initX:Number, initY:Number,
                                             vx:Number, vy:Number, waitTime:Number):Enemy {
            var behavior:ShowUpAndDashBehavior = new ShowUpAndDashBehavior();
            behavior.setParam(initX, initY, vx, vy, waitTime);
            var view:EnemyView = getView();
            var enemy:Enemy = new Enemy(behavior, view);
            return enemy;
        }

        public static function showUpAndShoot(initX:Number, initY:Number,
                                              vx:Number, vy:Number,
                                              shootTime:Number, waitTime:Number):Enemy {
            var behavior:ShowUpAndShootBehavior = new ShowUpAndShootBehavior();
            behavior.setParam(initX, initY, vx, vy, shootTime, waitTime);
            var view:EnemyView = getView();
            var enemy:Enemy = new Enemy(behavior, view);
            return enemy;
        }

        public static function linearMoveAndShoot(
            initX:Number=160, initY:Number=-80,
            vx:Number=0, vy:Number=25, ax:Number=0, ay:Number=0,
            shotWay:int=1):Enemy
        {
            var behavior:LinearMoveAndShootBehavior = new LinearMoveAndShootBehavior();
            behavior.setParam(initX, initY, vx, vy, ax, ay, shotWay);
            var view:EnemyView = getView();
            var enemy:Enemy = new Enemy(behavior, view);
            return enemy;
        }

        public static function boss():Enemy {
            var behavior:BossBehavior = new BossBehavior();
            behavior.setParam(160, -200);
            viewType = ViewType_Boss;
            var view:EnemyView = getView();
            var enemy:Enemy = new Enemy(behavior, view);
            return enemy;
        }

        public static function energyGift():Enemy {
            var angle:Number = TkUtil.rand(3.14 * 2);
            var vx   :Number = Math.cos(angle) * 100;
            var vy   :Number = Math.sin(angle) * 100;
            var initX:Number = 160 - (vx * 4) + TkUtil.randPlusOrMinus(0, 90);
            var initY:Number = 240 - (vy * 4) + TkUtil.randPlusOrMinus(0, 90);

            var behavior:EnergyGiftBehavior = new EnergyGiftBehavior();
            behavior.setParam(initX, initY, vx, vy);
            viewType = ViewType_Energy;
            var view:EnemyView = getView();
            var enemy:Enemy = new Enemy(behavior, view);
            return enemy;
        }

        public static function upgradeGift():Enemy {
            var angle:Number = TkUtil.rand(3.14 * 2);
            var vx   :Number = Math.cos(angle) * 100;
            var vy   :Number = Math.sin(angle) * 100;
            var initX:Number = 160 - (vx * 4) + TkUtil.randPlusOrMinus(0, 90);
            var initY:Number = 240 - (vy * 4) + TkUtil.randPlusOrMinus(0, 90);

            var behavior:UpgradeGiftBehavior = new UpgradeGiftBehavior();
            behavior.setParam(initX, initY, vx, vy);
            viewType = ViewType_Upgrade;
            var view:EnemyView = getView();
            var enemy:Enemy = new Enemy(behavior, view);
            return enemy;
        }
    }
}
