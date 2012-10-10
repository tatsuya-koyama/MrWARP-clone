package tatsuyakoyama.tkframework.collision {

    import tatsuyakoyama.tkframework.TkActor;

    //------------------------------------------------------------
    public class TkCollisionShapeSphere extends TkCollisionShape {

        public var radius:Number;

        private var _orgRadius:Number;
        private var _prevOwnerScaleX:Number = 1;
        private var _prevOwnerScaleY:Number = 1;

        //------------------------------------------------------------
        public function TkCollisionShapeSphere(owner:TkActor, handler:Function,
                                               radius:Number,
                                               offsetX:Number=0, offsetY:Number=0) {
            super(owner, handler, offsetX, offsetY);
            _type = TkCollisionShape.SHAPE_SPHERE;

            _orgRadius  = radius;
            this.radius = radius;
        }

        public function update():void {
            _updateScale();
        }

        private function _updateScale():void {
            if (owner.scaleX == _prevOwnerScaleX  &&
                owner.scaleY == _prevOwnerScaleY) {
                return;
            }

            _prevOwnerScaleX = owner.scaleX;
            _prevOwnerScaleY = owner.scaleY;
            _updateRadius();
        }

        private function _updateRadius():void {
            // 重いので楕円の判定はしない
            // 楕円の場合は間の scale をとる
            radius = _orgRadius * ((owner.scaleX + owner.scaleY) / 2);
        }
    }
}
