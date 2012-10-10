package tatsuyakoyama.tkframework {

    import flash.utils.Dictionary;

    import tatsuyakoyama.tkframework.collision.TkCollisionShape;

    import tatsuyakoyama.tkutility.TkUtil;

    //------------------------------------------------------------
    public class TkCollisionSystem {

        private var _collisionGroups:Dictionary = new Dictionary();
        private var _actorRegistry  :Dictionary = new Dictionary();

        //------------------------------------------------------------
        public function TkCollisionSystem() {

        }

        public function dispose():void {
            removeAllGroups();
        }

        /**
         * @param groupData Example:
         * [
         *      ['player', ['enemy', 'item']]
         *     ,['enemy',  []]
         *     ,['item',   ['item']]
         * ]
         */
        public function setUpGroups(groupData:Array):void {
            var data:Array;
            var groupName:String;

            // make collision group instances
            for each (data in groupData) {
                groupName = data[0];
                _collisionGroups[groupName] = new TkCollisionGroup(groupName);
            }

            // tell collision group what is collision target group
            for each (data in groupData) {
                groupName = data[0];
                var collidableGroupNames:Array = data[1];
                for each (var collGroupName:String in collidableGroupNames) {
                    var collGroup:TkCollisionGroup = _collisionGroups[collGroupName];
                    _collisionGroups[groupName].addCollidableGroup(collGroup);
                }
            }
        }

        public function removeAllGroups():void {
            for each (var collGroup:TkCollisionGroup in _collisionGroups) {
                collGroup.dispose();
            }
            _collisionGroups = new Dictionary();
            _actorRegistry   = new Dictionary();
        }

        public function addShape(groupName:String, shape:TkCollisionShape):void {
            _collisionGroups[groupName].addShape(shape);
            _registerActor(groupName, shape.owner);
        }

        private function _registerActor(groupName:String, actor:TkActor):void {
            if (!_actorRegistry[actor.id]) {
                _actorRegistry[actor.id] = [];
            }

            _actorRegistry[actor.id].push(groupName);
        }

        public function removeShapeWithActor(actor:TkActor):Boolean {
            if (!_actorRegistry[actor.id]) {
                return false;
            }

            for each (var groupName:String in _actorRegistry[actor.id]) {
                _collisionGroups[groupName].removeShape(actor);
            }
            delete _actorRegistry[actor.id];
            return true;
        }

        public function hitTest():void {
            for each (var collGroup:TkCollisionGroup in _collisionGroups) {
                for each (var otherGroup:TkCollisionGroup in collGroup.collidableGroups) {
                    collGroup.hitTest(otherGroup);
                }
            }
        }
    }
}
