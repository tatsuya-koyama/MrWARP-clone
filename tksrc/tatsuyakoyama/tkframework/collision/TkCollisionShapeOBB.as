package tatsuyakoyama.tkframework.collision {

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkutility.TkVector2D;

    //------------------------------------------------------------
    public class TkCollisionShapeOBB extends TkCollisionShape {

        public var localBasisVectors:Vector.<TkVector2D> = new Vector.<TkVector2D>();
        public var sideVectors      :Vector.<TkVector2D> = new Vector.<TkVector2D>();

        public var orgHalfSideLengths:Vector.<Number> = new Vector.<Number>(); // half of side length at scale = 1
        public var halfSideLengths   :Vector.<Number> = new Vector.<Number>();

        private var _prevOwnerRotation:Number = 0;
        private var _prevOwnerScaleX  :Number = 1;
        private var _prevOwnerScaleY  :Number = 1;

        //------------------------------------------------------------
        public function TkCollisionShapeOBB(owner:TkActor, handler:Function,
                                            width:Number, height:Number,
                                            offsetX:Number=0, offsetY:Number=0) {
            super(owner, handler, offsetX, offsetY);
            _type = TkCollisionShape.SHAPE_OBB;

            localBasisVectors[0] = new TkVector2D(1, 0);
            localBasisVectors[1] = new TkVector2D(0, 1);
            sideVectors[0]       = new TkVector2D();
            sideVectors[1]       = new TkVector2D();

            orgHalfSideLengths[0] = width  / 2;
            orgHalfSideLengths[1] = height / 2;
            halfSideLengths[0]    = orgHalfSideLengths[0];
            halfSideLengths[1]    = orgHalfSideLengths[1];

            _updateVectors();
        }

        public function update():void {
            _updateScale();
            _updateLocalBasis();
        }

        /**
         * OBB に AABB をコピーするヘルパー
         */
        public static function copyFromAABB(srcAabb:TkCollisionShapeAABB,
                                            destObb:TkCollisionShapeOBB):void {
            destObb.localBasisVectors[0].setValue(1, 0);
            destObb.localBasisVectors[1].setValue(0, 1);
            destObb.halfSideLengths[0] = (srcAabb.maxX - srcAabb.minX) / 2;
            destObb.halfSideLengths[1] = (srcAabb.maxY - srcAabb.minY) / 2;
            destObb.offsetX  = srcAabb.offsetX;
            destObb.offsetY  = srcAabb.offsetY;
            destObb._owner   = srcAabb._owner;
            destObb._updateVectors();
        }

        private function _updateScale():void {
            if (owner.scaleX == _prevOwnerScaleX  &&
                owner.scaleY == _prevOwnerScaleY) {
                return;
            }

            _prevOwnerScaleX = owner.scaleX;
            _prevOwnerScaleY = owner.scaleY;
            halfSideLengths[0] = orgHalfSideLengths[0] * owner.scaleX;
            halfSideLengths[1] = orgHalfSideLengths[1] * owner.scaleY;
        }

        private function _updateLocalBasis():void {
            if (owner.rotation == _prevOwnerRotation) { return; }

            _prevOwnerRotation = owner.rotation;
            localBasisVectors[0].rotateTo(owner.rotation);
            localBasisVectors[1].rotateTo(owner.rotation);

            _updateVectors();
        }

        private function _updateVectors():void {
            sideVectors[0].setScalarMultiple(localBasisVectors[0], halfSideLengths[0]);
            sideVectors[1].setScalarMultiple(localBasisVectors[1], halfSideLengths[1]);
        }
    }
}
