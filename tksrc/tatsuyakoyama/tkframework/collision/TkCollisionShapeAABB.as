package tatsuyakoyama.tkframework.collision {

    import tatsuyakoyama.tkframework.TkActor;

    //------------------------------------------------------------
    public class TkCollisionShapeAABB extends TkCollisionShape {

        private var _minX:Number;
        private var _minY:Number;
        private var _maxX:Number;
        private var _maxY:Number;

        private var _orgWidth :Number;
        private var _orgHeight:Number;
        private var _prevOwnerScaleX:Number = 1;
        private var _prevOwnerScaleY:Number = 1;

        //------------------------------------------------------------
        public function get minX():Number { return _minX + owner.x + offsetX; }
        public function get maxX():Number { return _maxX + owner.x + offsetX; }
        public function get minY():Number { return _minY + owner.y + offsetY; }
        public function get maxY():Number { return _maxY + owner.y + offsetY; }

        //------------------------------------------------------------
        public function TkCollisionShapeAABB(owner:TkActor, handler:Function,
                                             width:Number, height:Number,
                                             offsetX:Number=0, offsetY:Number=0) {
            super(owner, handler, offsetX, offsetY);
            _type = TkCollisionShape.SHAPE_AABB;

            _orgWidth  = width  / 2;
            _orgHeight = height / 2;
            _updateBox();
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
            _updateBox();
        }

        private function _updateBox():void {
            _minX = -_orgWidth  * owner.scaleX;
            _maxX =  _orgWidth  * owner.scaleX;
            _minY = -_orgHeight * owner.scaleY;
            _maxY =  _orgHeight * owner.scaleY;
        }
    }
}
