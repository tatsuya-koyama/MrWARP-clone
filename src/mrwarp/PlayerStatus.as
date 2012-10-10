package mrwarp {

    import mrwarp.player_status.*;

    public class PlayerStatus {

        //------------------------------------------------------------
        private var _values:Vector.<PlayerStatusValue> = new Vector.<PlayerStatusValue>();
        public static const MAX_ENERGY:int     = 0;
        public static const ENERGY_RECOVER:int = 1;
        public static const CAMERA_SPEED:int   = 2;
        public static const RAY_WIDTH:int      = 3;
        public static const RAY_DURATION:int   = 4;

        private var _maxEnergy         :PlayerStatusMaxEnergy         = new PlayerStatusMaxEnergy();
        private var _energyRecover     :PlayerStatusEnergyRecover     = new PlayerStatusEnergyRecover();
        private var _cameraFollowSpeed :PlayerStatusCameraFollowSpeed = new PlayerStatusCameraFollowSpeed();
        private var _rayWidth          :PlayerStatusRayWidth          = new PlayerStatusRayWidth();
        private var _rayDuration       :PlayerStatusRayDuration       = new PlayerStatusRayDuration();

        //------------------------------------------------------------
        public function PlayerStatus() {
            _values.push(_maxEnergy);
            _values.push(_energyRecover);
            _values.push(_cameraFollowSpeed);
            _values.push(_rayWidth);
            _values.push(_rayDuration);
        }

        public function reset():void {
            for each (var value:PlayerStatusValue in _values) {
                value.reset();
            }
        }

        public function getStatus(index:int):PlayerStatusValue {
            return _values[index];
        }

        public function getValue(index:int):Number {
            return _values[index].getActualValue();
        }
    }
}
