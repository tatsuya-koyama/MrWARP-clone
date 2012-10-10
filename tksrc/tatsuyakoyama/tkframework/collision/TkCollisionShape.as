package tatsuyakoyama.tkframework.collision {

    import tatsuyakoyama.tkframework.TkActor;

    import tatsuyakoyama.tkutility.TkUtil;

    /**
     * Shape data for collision detection.
     * This class knows subclasses of itself
     * to choose collision detection algorithms.
     */
    //------------------------------------------------------------
    public class TkCollisionShape {

        public static const SHAPE_SPHERE:int = 1;
        public static const SHAPE_AABB  :int = 2;
        public static const SHAPE_OBB   :int = 3;

        public var _owner:TkActor;
        public var _handler:Function;
        public var _type:int = 0;

        public var offsetX:Number;
        public var offsetY:Number;

        //------------------------------------------------------------
        public function get owner():TkActor {
            return _owner;
        }

        public function get handler():Function {
            return _handler;
        }

        public function get type():int {
            return _type;
        }

        public function get x():Number {
            return owner.x + offsetX;
        }

        public function get y():Number {
            return owner.y + offsetY;
        }

        //------------------------------------------------------------
        public function TkCollisionShape(owner:TkActor, handler:Function,
                                         offsetX:Number=0, offsetY:Number=0)
        {
            _owner   = owner;
            _handler = handler;
            this.offsetX = offsetX;
            this.offsetY = offsetY;
        }

        public function hitTest(other:TkCollisionShape):Boolean {
            // ignore self-intersection
            if (this.owner.id == other.owner.id) { return false; }

            // I want to write collision detection with double dispatch pattern
            // but unfortunately ActionScript3.0 cannot use function overloading...

            // Sphere vs Sphere
            if (    this is TkCollisionShapeSphere
                && other is TkCollisionShapeSphere) {
                return TkHitTest.hitTestSphereVsSphere(this, other);
            }
            // AABB vs AABB
            else if (    this is TkCollisionShapeAABB
                     && other is TkCollisionShapeAABB) {
                return TkHitTest.hitTestAABBVsAABB(this, other);
            }
            // OBB vs OBB
            else if (    this is TkCollisionShapeOBB
                     && other is TkCollisionShapeOBB) {
                return TkHitTest.hitTestOBBVsOBB(this, other);
            }
            // Sphere vs AABB
            else if (    this is TkCollisionShapeSphere
                     && other is TkCollisionShapeAABB) {
                return TkHitTest.hitTestSphereVsAABB(this, other);
            }
            else if (    this is TkCollisionShapeAABB
                     && other is TkCollisionShapeSphere) {
                return TkHitTest.hitTestSphereVsAABB(other, this);
            }
            // Sphere vs OBB
            else if (    this is TkCollisionShapeSphere
                     && other is TkCollisionShapeOBB) {
                return TkHitTest.hitTestSphereVsOBB(this, other);
            }
            else if (    this is TkCollisionShapeOBB
                     && other is TkCollisionShapeSphere) {
                return TkHitTest.hitTestSphereVsOBB(other, this);
            }
            // AABB vs OBB
            else if (    this is TkCollisionShapeAABB
                     && other is TkCollisionShapeOBB) {
                return TkHitTest.hitTestAABBVsOBB(this, other);
            }
            else if (    this is TkCollisionShapeOBB
                     && other is TkCollisionShapeAABB) {
                return TkHitTest.hitTestAABBVsOBB(other, this);
            }

            TkUtil.log('[Error] This shape combination is not supported.');
            return false;
        }
    }
}
