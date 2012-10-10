package tatsuyakoyama.tkframework {

    import tatsuyakoyama.tkutility.TkSoundPlayer;

    //------------------------------------------------------------
    public class TkSharedObjects {

        private var _resourceManager:TkResourceManager;
        private var _layerManager:TkLayerManager;
        private var _notificationService:TkNotificationService;
        private var _collisionSystem:TkCollisionSystem;
        private var _soundPlayer:TkSoundPlayer;

        //------------------------------------------------------------
        public function get resourceManager():TkResourceManager {
            return _resourceManager;
        }

        public function get layerManager():TkLayerManager {
            return _layerManager;
        }

        public function get notificationService():TkNotificationService {
            return _notificationService;
        }

        public function get collisionSystem():TkCollisionSystem {
            return _collisionSystem;
        }

        public function get soundPlayer():TkSoundPlayer {
            return _soundPlayer;
        }

        //------------------------------------------------------------
        public function TkSharedObjects() {
            _resourceManager     = new TkResourceManager();
            _layerManager        = new TkLayerManager();
            _notificationService = new TkNotificationService();
            _collisionSystem     = new TkCollisionSystem();
            _soundPlayer         = new TkSoundPlayer();
        }
    }
}
