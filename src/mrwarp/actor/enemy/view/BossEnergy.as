package mrwarp.actor.enemy.view {

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

    /**
     * オーソドックスにバーにしようかなとか悩んだものの
     * 最終的にプレイヤーのエネルギーと同じような表示になったから
     * ベースクラス抜き出そうかと思ったけど眠かったからやめた
     */
    //------------------------------------------------------------
    public class BossEnergy extends TkActor {

        // avoid instantiation cost
        private static var _cachedPoint:Point = new Point();

        private var _parentWidth:int  = 128;
        private var _parentHeight:int = 128;
        private var _energyImage:Image;

        //------------------------------------------------------------
        public function setParam(parentWidth:int, parentHeight:int):void {
            _parentWidth  = parentWidth;
            _parentHeight = parentHeight;
        }

        public override function init():void {
            _energyImage = getImageFromAtlas('atlas-01', 'boss');
            setNormalColor();
            addImage(
                _energyImage, _parentWidth, _parentHeight,
                0, _parentHeight / 2, 0.5, 1
            );
        }

        // @param energyRate Percentage of boss energy. [0, 1.0]
        public function resize(energyRate:Number):void {
            scaleY = energyRate;

            var height:Number = (1 - scaleY);

            _cachedPoint.setTo(0, height);
            _energyImage.setTexCoords(0, _cachedPoint);

            _cachedPoint.setTo(1, height);
            _energyImage.setTexCoords(1, _cachedPoint);

            y = (_parentHeight / 2) * height;
        }

        public function setNormalColor():void {
            _energyImage.color = 0xddeeff;
        }

        public function setDamagedColor():void {
            _energyImage.color = 0xff9999;
        }
    }
}
