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
    public class EnemyView extends TkActor {

        protected var _enemy:Enemy;
        public var collisionRadius:Number = 18;

        //------------------------------------------------------------
        public function setOwner(enemy:Enemy):void {
            _enemy = enemy;
        }

        public function attachDamageEffect():void {
            // override this
        }

        public function attachDieEffect():void {
            _enemy.color = 0xff0000;
            _enemy.act()
                  .scaleToEaseIn (0.15, 1.0, 2.0)
                  .scaleToEaseOut(0.15, 3.0, 0.1).kill();
            _enemy.act().alphaTo(0.3, 0, Transitions.EASE_IN);
        }

        // Implement init() and onUpdate() at derived class.
    }
}
