package mrwarp.actor {

    import starling.display.Image;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkBlendMode;
    import tatsuyakoyama.tkframework.collision.TkCollisionShape;
    import tatsuyakoyama.tkframework.collision.TkCollisionShapeAABB;
    import tatsuyakoyama.tkutility.TkUtil;
    import tatsuyakoyama.tkutility.TkVector2D;

    import mrwarp.GameRecord;
    import mrwarp.GameConst;
    import mrwarp.GameEvent;

    //------------------------------------------------------------
    public class EnergyParticle extends TkActor {

        private var _vx1:Number;  // 出現時のスピード。だんだん減速
        private var _vy1:Number;
        private var _vx2:Number;  // プレイヤーに向かうベクトル
        private var _vy2:Number;
        private var _size:Number;
        private var _color:uint;
        private var _dying:Boolean = false;

        private var directionToPlayer:TkVector2D = new TkVector2D(0, 0);

        //------------------------------------------------------------
        public function EnergyParticle(x:Number, y:Number,
                                       minSpeed:Number=200, maxSpeed:Number=300) {
            this.x = x;
            this.y = y;

            var angle:Number = TkUtil.rand(3.14 * 2);
            _vx1   = Math.cos(angle) * TkUtil.randArea(minSpeed, maxSpeed);
            _vy1   = Math.sin(angle) * TkUtil.randArea(minSpeed, maxSpeed);
            _vx2   = 0;
            _vy2   = 0;
            _size  = TkUtil.randArea(10, 20);
            _color = TkUtil.hsv2int(
                TkUtil.randArea(130, 280),
                0.7,
                TkUtil.randArea(0.4, 0.6)
            );

            addPeriodicTask(1/30, _getCloseToPlayer);

            ++GameRecord.numItem;
        }

        public override function init():void {
            var image:Image = getImageFromAtlas('atlas-01', 'little_star');
            image.blendMode = TkBlendMode.ADD;
            image.color     = _color;
            addImage(image, _size, _size);

            var that:EnergyParticle = this;
            addScheduledTask(0.7, function():void {
                setCollision('c-item', new TkCollisionShapeAABB(that, _onCollide, _size, _size));
            });

            listen(GameEvent.SCROLL_SCREEN, _onScrollScreen);
        }

        protected override function onDispose():void {
            --GameRecord.numItem;
        }

        public function _onScrollScreen(args:Object):void {
            x += args.dx;
            y += args.dy;
        }

        public override function onUpdate(passedTime:Number):void {
            if (_dying) { return; }

            x += (_vx1 + _vx2) * passedTime;
            y += (_vy1 + _vy2) * passedTime;
            rotation += passedTime * 10;
        }

        private function _getCloseToPlayer():void {
            if (_dying) { return; }

            _vx1 *= 0.96;
            _vy1 *= 0.96;

            directionToPlayer.setValue(
                GameRecord.playerX - x,
                GameRecord.playerY - y
            );
            directionToPlayer = directionToPlayer.normalize();
            _vx2 += (directionToPlayer.x * 400 - _vx2) / 4;
            _vy2 += (directionToPlayer.y * 400 - _vy2) / 4;
        }

        /**
         * Player character earn the star and recover energy
         */
        public function _onCollide(otherGroupName:String, otherShape:TkCollisionShape):void {
            _dying = true;

            playSe('pickup_item');
            removeCollision();
            act().alphaTo(0.2, 0).kill();
            act().scaleTo(0.2, 2, 2);

            GameRecord.score += 10;
            GameRecord.star  += 1;
        }
    }
}
