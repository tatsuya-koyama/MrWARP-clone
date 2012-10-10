package mrwarp.actor {

    import starling.display.Image;
    import starling.animation.Transitions;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkBlendMode;
    import tatsuyakoyama.tkframework.collision.TkCollisionShape;
    import tatsuyakoyama.tkframework.collision.TkCollisionShapeOBB;
    import tatsuyakoyama.tkutility.TkUtil;

    import mrwarp.GameEvent;
    import mrwarp.GameRecord;
    import mrwarp.PlayerStatus;

    //------------------------------------------------------------
    public class Ray extends TkActor {

        private var _x1:Number;
        private var _y1:Number;
        private var _x2:Number;
        private var _y2:Number;

        //------------------------------------------------------------
        public function Ray(x1:Number, y1:Number, x2:Number, y2:Number) {
            _x1 = x1;
            _y1 = y1;
            _x2 = x2;
            _y2 = y2;
        }

        public override function init():void {
            var image:Image = getImageFromAtlas('atlas-01', 'ray');
            image.blendMode = TkBlendMode.ADD;

            x = (_x1 + _x2) / 2;
            y = (_y1 + _y2) / 2;

            var dx:Number = _x2 - _x1;
            var dy:Number = _y2 - _y1;
            var theta:Number = Math.atan(dy / dx);
            rotation = theta;

            var distance:Number = Math.sqrt((dx * dx) + (dy * dy));

            var width:Number = GameRecord.playerStatus.getValue(PlayerStatus.RAY_WIDTH);
            addImage(image, distance * 1.2, width);

            var duration:Number = GameRecord.playerStatus.getValue(PlayerStatus.RAY_DURATION);
            act().scaleTo(duration, 1, 0.03, Transitions.EASE_IN).kill();

            setCollision('c-ray', new TkCollisionShapeOBB(this, _onCollide, distance * 1.3, width * 1.3));
            listen(GameEvent.SCROLL_SCREEN, _onScrollScreen);
        }

        public function _onScrollScreen(args:Object):void {
            x += args.dx;
            y += args.dy;
        }

        protected override function onDispose():void {}

        public override function onUpdate(passedTime:Number):void {
            alpha = TkUtil.randArea(0.2, 0.8);
            color = 0x44aaff;
        }

        public function _onCollide(otherGroupName:String, otherShape:TkCollisionShape):void {
            color = 0xff9999;
        }
    }
}
