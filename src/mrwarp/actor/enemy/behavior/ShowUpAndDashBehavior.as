package mrwarp.actor.enemy.behavior {

    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.display.Image;
    import starling.display.BlendMode;
    import starling.animation.Transitions;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkutility.TkUtil;

    import mrwarp.GameRecord;
    import mrwarp.actor.enemy.Enemy;
    import mrwarp.actor.enemy.EnemyBehavior;

    //------------------------------------------------------------
    public class ShowUpAndDashBehavior extends EnemyBehavior {

        private var _vx:Number;
        private var _vy:Number;
        private var _waitTime:Number;

        //------------------------------------------------------------
        public function setParam(initX:Number, initY:Number,
                                 vx:Number, vy:Number, waitTime:Number):void {
            _initX = initX;
            _initY = initY;
            _vx = vx;
            _vy = vy;
            _waitTime = waitTime;
        }

        public override function init():void {
            _enemy.x = _initX;
            _enemy.y = _initY;
        }

        public override function onUpdate(passedTime:Number):void {
            // 画面内に入ったら一定時間止まってからまた動き出す
            if (_waitTime > 0) {
                if (0 < _enemy.x - _enemy.cachedWidth /2.5  &&  _enemy.x + _enemy.cachedWidth /2.5 < 320  &&
                    0 < _enemy.y - _enemy.cachedHeight/2.5  &&  _enemy.y + _enemy.cachedHeight/2.5 < 480) {
                    _waitTime -= passedTime;
                    return;
                }
            }

            _enemy.x += _vx * passedTime;
            _enemy.y += _vy * passedTime;

            super.onUpdate(passedTime);
        }
    }
}
