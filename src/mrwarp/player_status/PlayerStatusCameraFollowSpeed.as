package mrwarp.player_status {

    import mrwarp.PlayerStatusValue;

    public class PlayerStatusCameraFollowSpeed extends PlayerStatusValue {

        //------------------------------------------------------------
        protected override function _getMap():Array {
            return [
                 [   0,  0.0,   0] // default (level 0)
                ,[  10,  1.0,  10]
                ,[  20,  1.5,  20]
                ,[  50,  2.0,  30]
                ,[ 100,  2.8,  40]
                ,[ 150,  3.6,  50]
                ,[ 200,  4.6,  65]
                ,[ 300,  6.0,  80]
                ,[ 400,  9.0, 100]
                ,[ 700, 12.0, 130]
                ,[1300, 15.0, 160]
                ,[2000, 20.0, 200]
            ];
        }
    }
}
