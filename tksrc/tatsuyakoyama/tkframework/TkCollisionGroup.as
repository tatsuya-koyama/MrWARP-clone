package tatsuyakoyama.tkframework {

    import flash.utils.Dictionary;

    import tatsuyakoyama.tkframework.collision.TkCollisionShape;

    import tatsuyakoyama.tkutility.TkUtil;

    //------------------------------------------------------------
    public class TkCollisionGroup {

        private var _groupName:String;
        private var _collidableGroups:Vector.<TkCollisionGroup> = new Vector.<TkCollisionGroup>();
        private var _shapes:Vector.<TkCollisionShape> = new Vector.<TkCollisionShape>;

        //------------------------------------------------------------
        public function get collidableGroups():Vector.<TkCollisionGroup> {
            return _collidableGroups;
        }

        public function get shapes():Vector.<TkCollisionShape> {
            return _shapes;
        }

        public function get groupName():String {
            return _groupName;
        }

        //------------------------------------------------------------
        public function TkCollisionGroup(groupName:String) {
            _groupName = groupName;
        }

        public function dispose():void {}

        public function addCollidableGroup(collidableGroup:TkCollisionGroup):void {
            _collidableGroups.push(collidableGroup);
        }

        public function addShape(shape:TkCollisionShape):void {
            _shapes.push(shape);
        }

        public function removeShape(owner:TkActor):Boolean {
            for (var i:int=0;  i < _shapes.length;  ++i) {
                var shape:TkCollisionShape = _shapes[i];
                if (shape.owner.id == owner.id) {
                    _shapes.splice(i, 1);  // remove shape from Array
                    return true;
                }
            }

            TkUtil.log('Shape not registered. [owner id: ' + owner.id + ']');
            return false;
        }

        /**
         * Do hit test and call both collided shape's handlers
         * with arguments [otherGroupName:String, otherShape:TkCollisionShape]
         */
        public function hitTest(otherGroup:TkCollisionGroup):void {
            for each (var shape:TkCollisionShape in _shapes) {
                for each (var otherShape:TkCollisionShape in otherGroup.shapes) {
                    if (shape.hitTest(otherShape)) {
                        shape.handler(otherGroup.groupName, otherShape);
                        otherShape.handler(groupName, shape);
                    }
                }
            }
        }
    }
}
