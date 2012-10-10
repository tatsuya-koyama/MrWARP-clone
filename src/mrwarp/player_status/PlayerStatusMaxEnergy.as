package mrwarp.player_status {

    import mrwarp.PlayerStatusValue;

    public class PlayerStatusMaxEnergy extends PlayerStatusValue {

        //------------------------------------------------------------
        protected override function _getMap():Array {
            return [
                 [   0,  70,  70] // default (level 0)
                ,[  10,  80,  80]
                ,[  40,  90,  90]
                ,[  90, 100, 100]
                ,[ 150, 110, 110]
                ,[ 220, 130, 130]
                ,[ 300, 150, 150]
                ,[ 400, 170, 170]
                ,[ 500, 200, 200]
                ,[ 700, 230, 230]
                ,[1000, 260, 260]
                ,[2000, 300, 300]
                ,[3000, 400, 400]
            ];
        }
    }
}
