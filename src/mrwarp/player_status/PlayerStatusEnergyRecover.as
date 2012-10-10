package mrwarp.player_status {

    import mrwarp.PlayerStatusValue;

    public class PlayerStatusEnergyRecover extends PlayerStatusValue {

        //------------------------------------------------------------
        protected override function _getMap():Array {
            return [
                 [   0, 0.7, 0.7] // default (level 0)
                ,[  10, 0.8, 0.8]
                ,[  40, 0.9, 0.9]
                ,[  90, 1.0, 1.0]
                ,[ 150, 1.1, 1.1]
                ,[ 220, 1.2, 1.2]
                ,[ 300, 1.3, 1.3]
                ,[ 500, 1.5, 1.5]
                ,[ 700, 1.7, 1.7]
                ,[1000, 1.9, 1.9]
                ,[2000, 2.1, 2.1]
                ,[3000, 2.4, 2.4]
                ,[5000, 3.0, 3.0]
            ];
        }
    }
}
