package mrwarp.actor.enemy {

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
    import mrwarp.GameConst;
    import mrwarp.GameEvent;
    import mrwarp.actor.EnergyParticle;

    //------------------------------------------------------------
    public class Enemy extends TkActor {

        private var _behavior:EnemyBehavior;
        private var _view:EnemyView;
        private var _dying:Boolean = false;

        public var life:int    = 1;
        public var maxLife:int = 1;
        public var numPlayerEnergy:int = 1;
        private var _invincibleTime:Number = 0;

        //------------------------------------------------------------
        public function get dying():Boolean {
            return _dying;
        }

        //------------------------------------------------------------
        public function Enemy(behavior:EnemyBehavior, view:EnemyView) {
            _behavior = behavior;
            _view     = view;

            behavior.setOwner(this);
            view    .setOwner(this);

            _checkDisplayArea = true;
            ++GameRecord.numEnemy;
        }

        public override function init():void {
            addActor(_behavior, false);
            addActor(_view, true);

            setCollision('c-enemy', new TkCollisionShapeSphere(
                this, _onCollide, _view.collisionRadius
            ));
            listen(GameEvent.SCROLL_SCREEN, _onScrollScreen);
            listen(GameEvent.DEFEAT_BOSS, _onDefeatBoss);
        }

        protected override function onDispose():void {
            --GameRecord.numEnemy;
        }

        public function _onScrollScreen(args:Object):void {
            x += args.dx;
            y += args.dy;
        }

        public function _onCollide(otherGroupName:String, otherShape:TkCollisionShape):void {
            if (_dying) { return;}

            switch (otherGroupName) {
            case 'c-ray':
                damage();
                break;
            }
        }

        public function damage():void {
            if (_invincibleTime > 0) { return; }
            _invincibleTime = 0.18;

            --life;
            if (life <= 0) {
                _die();
                return;
            }

            playSe('enemy_damage');
            _view.attachDamageEffect();
            sendMessage(GameEvent.ENEMY_DAMAGED, {x: x, y: y});
            _generateEnergy();
        }

        public override function onUpdate(passedTime:Number):void {
            if (_invincibleTime > 0) {
                _invincibleTime -= passedTime;
            }
        }

        private function _die():void {
            if (_dying) { return;}

            _dying = true;
            playSe('enemy_die');
            removeCollision();

            _behavior.onDying();
            _view.attachDieEffect();

            sendMessage(GameEvent.ENEMY_DEFEATED, {x: x, y: y});

            _generateEnergy(numPlayerEnergy);
        }

        private function _onDefeatBoss(eventArgs:Object):void {
            _dying = true;
            passAway();

            var energyParticle:EnergyParticle = new EnergyParticle(x, y, 300, 300);
            createActor(energyParticle);
        }

        private function _generateEnergy(num:int=1):void {
            var speedOffset:Number = (num > 1) ? 300 : 0;
            for (var i:int=0;  i < num;  ++i) {
                // ゲーム内のアイテム数が許容量を超えていたら出さない
                if (GameRecord.numItem > GameConst.ALLOWED_ITEM_NUM) { return; }

                var energyParticle:EnergyParticle = new EnergyParticle(
                    x, y,
                    200 + speedOffset,
                    400 + speedOffset
                );
                createActor(energyParticle);
            }
        }
    }
}
