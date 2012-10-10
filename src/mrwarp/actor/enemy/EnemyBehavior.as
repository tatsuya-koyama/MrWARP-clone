package mrwarp.actor.enemy {

    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.display.Image;
    import starling.display.BlendMode;
    import starling.animation.Transitions;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkutility.TkUtil;

    import mrwarp.GameRecord;

    //------------------------------------------------------------
    public class EnemyBehavior extends TkActor {

        protected var _enemy:Enemy;
        protected var _initX:Number;
        protected var _initY:Number;

        protected var _survivalTime:Number = 0;

        //------------------------------------------------------------
        public function setOwner(enemy:Enemy):void {
            _enemy = enemy;
        }

        public override function onUpdate(passedTime:Number):void {
            if (_enemy.dying) { return; }

            _survivalTime += passedTime;
            if (_survivalTime > 3.0  && _isOutside()) { _enemy.passAway(); }
            if (_survivalTime < 3.0) { _repeatCoordinate(); }
        }

        public function onDying():void {
            // override this if needed
        }

        protected function _isOutside():Boolean {
            if (_enemy.x < 0 - 200  ||  _enemy.x > 320 + 200) { return true; }
            if (_enemy.y < 0 - 200  ||  _enemy.y > 480 + 200) { return true; }
            return false;
        }

        protected function _repeatCoordinate():void {
                 if (_enemy.x <   0 - 200) { _enemy.x += (320 + 380); }
            else if (_enemy.x > 320 + 200) { _enemy.x -= (320 + 380); }

                 if (_enemy.y <   0 - 200) { _enemy.y += (480 + 380); }
            else if (_enemy.y > 480 + 200) { _enemy.y -= (480 + 380); }
        }
    }
}
