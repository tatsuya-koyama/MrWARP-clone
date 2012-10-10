package mrwarp.player_status {

    import mrwarp.PlayerStatusValue;

    public class PlayerStatusRayWidth extends PlayerStatusValue {

        //------------------------------------------------------------
        protected override function _getMap():Array {
            return [
                 [   0,  32, 100] // default (level 0)
                ,[  10,  38, 110]
                ,[  40,  44, 120]
                ,[  90,  50, 130]
                ,[ 150,  56, 140]
                ,[ 220,  64, 150]
                ,[ 300,  72, 160]
                ,[ 500,  80, 180]
                ,[ 700,  88, 200]
                ,[1000,  96, 220]
                ,[2000, 108, 250]
                ,[3000, 128, 300]
            ];
        }
    }
}
