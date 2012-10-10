package mrwarp.actor {

    import flash.display.Bitmap;
    import flash.geom.Point;

    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.display.Image;
    import starling.display.BlendMode;
    import starling.animation.Transitions;

    import starling.utils.Color;
    import starling.utils.deg2rad;

    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkEventType;
    import tatsuyakoyama.tkframework.collision.TkCollisionShape;
    import tatsuyakoyama.tkframework.collision.TkCollisionShapeSphere;
    import tatsuyakoyama.tkframework.collision.TkCollisionShapeAABB;
    import tatsuyakoyama.tkframework.collision.TkCollisionShapeOBB;
    import tatsuyakoyama.tkutility.TkUtil;

    import mrwarp.GameRecord;
    import mrwarp.GameEvent;
    import mrwarp.actor.EnergyParticle;

    //------------------------------------------------------------
    public class EnemyBullet extends TkActor {

        private var _vx:Number;
        private var _vy:Number;
        private var _size:Number;
        private var _color:uint;
        private var _dying:Boolean = false;

        //------------------------------------------------------------
        public function EnemyBullet(x:Number, y:Number, vx:Number, vy:Number,
                                    size:Number=20, color:uint=0xff2200) {
            this.x = x;
            this.y = y;
            _vx    = vx;
            _vy    = vy;
            _size  = size;
            _color = color;

            _checkDisplayArea = true;
            ++GameRecord.numShot;
        }

        /**
         * factory
         */
        public static function makeWithAngle(x:Number, y:Number,
                                             angleDegree:Number, speed:Number,
                                             size:Number=20, color:uint=0xff2200):EnemyBullet {
            var radian:Number = angleDegree / 180 * 3.14159;
            return new EnemyBullet(
                x, y,
                Math.cos(radian) * speed,
                Math.sin(radian) * speed,
                size, color
            );
        }

        public override function init():void {
            var image:Image = getImageFromAtlas('atlas-01', 'enemy_bullet_big');
            image.color     = _color;
            addImage(image, _size, _size);

            setCollision('c-bullet', new TkCollisionShapeSphere(this, _onCollide, _size * 0.3));
            listen(GameEvent.SCROLL_SCREEN, _onScrollScreen);
            listen(GameEvent.DEFEAT_BOSS, _onDefeatBoss);
        }

        protected override function onDispose():void {
            --GameRecord.numShot;
        }

        private function _onDefeatBoss(args:Object):void {
            _dying = true;
            passAway();

            var energyParticle:EnergyParticle = new EnergyParticle(x, y, 300, 300);
            createActor(energyParticle);
        }

        public function _onScrollScreen(args:Object):void {
            x += args.dx;
            y += args.dy;
        }

        public override function onUpdate(passedTime:Number):void {
            x += _vx * passedTime;
            y += _vy * passedTime;
            rotation += passedTime * 3;

            var margin:int = 250;
            if (x < 0 - margin  ||  x > 320 + margin) { passAway(); }
            if (y < 0 - margin  ||  y > 480 + margin) { passAway(); }
        }

        public function _onCollide(otherGroupName:String, otherShape:TkCollisionShape):void {}
    }
}
