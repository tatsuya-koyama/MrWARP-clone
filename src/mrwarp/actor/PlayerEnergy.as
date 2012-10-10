package mrwarp.actor {

    import flash.display.Bitmap;
    import flash.geom.Point;

    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.display.Image;

    import starling.utils.Color;
    import starling.utils.deg2rad;

    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkAction;
    import tatsuyakoyama.tkframework.TkBlendMode;
    import tatsuyakoyama.tkframework.TkEventType;
    import tatsuyakoyama.tkframework.collision.TkCollisionShape;
    import tatsuyakoyama.tkframework.collision.TkCollisionShapeSphere;
    import tatsuyakoyama.tkframework.collision.TkCollisionShapeAABB;
    import tatsuyakoyama.tkframework.collision.TkCollisionShapeOBB;
    import tatsuyakoyama.tkutility.TkUtil;

    import mrwarp.GameEvent;
    import mrwarp.GameRecord;
    import mrwarp.PlayerStatus;

    //------------------------------------------------------------
    public class PlayerEnergy extends TkActor {

        // avoid instantiation cost
        private static var _cachedPoint:Point = new Point();

        private var _energyImage:Image;

        //------------------------------------------------------------
        public override function init():void {
            _energyImage = getImageFromAtlas('atlas-01', 'player_noglow');
            _energyImage.blendMode = TkBlendMode.ADD;
            setNormalColor();
            addImage(_energyImage, 64, 64, 0, 32, 0.5, 1);
        }

        public function updateScale(player:TkActor, passedTime:Number):void {
            scaleX = player.scaleX;
            scaleY = player.scaleY;

            var maxEnergy:Number = GameRecord.playerStatus.getValue(PlayerStatus.MAX_ENERGY);
            _resize(GameRecord.playerEnergy / maxEnergy);
        }

        // @param energyRate Ratio of player energy. [0, 1.0]
        private function _resize(energyRate:Number):void {
            scaleY = energyRate;

            var height:Number = (1 - scaleY);

            _cachedPoint.setTo(0, height);
            _energyImage.setTexCoords(0, _cachedPoint);

            _cachedPoint.setTo(1, height);
            _energyImage.setTexCoords(1, _cachedPoint);

            y = 32 * height;
        }

        public function setNormalColor():void {
            //_energyImage.blendMode = TkBlendMode.ADD;
            _energyImage.color = 0xaa9933;
        }

        public function setDamagedColor():void {
            //_energyImage.blendMode = TkBlendMode.ADD;
            _energyImage.color = 0x336600;
        }
    }
}
