package mrwarp.player_status {

    import mrwarp.PlayerStatusValue;

    public class PlayerStatusRayDuration extends PlayerStatusValue {

        //------------------------------------------------------------
        protected override function _getMap():Array {
            return [
                 [   0, 0.50,  0] // default (level 0)
                ,[  10, 0.55,  0]
                ,[  40, 0.60,  0]
                ,[ 100, 0.65,  0]
                ,[ 200, 0.70,  0]
                ,[ 300, 0.75,  0]
                ,[ 500, 0.80,  0]
                ,[1000, 0.85,  0]
                ,[2000, 0.90,  0]
                ,[3000, 0.95,  0]
                ,[5000, 1.00,  0]
                ,[9999, 1.10,  0]
            ];
        }
    }
}
