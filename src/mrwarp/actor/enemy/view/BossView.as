package mrwarp.actor.enemy.view {

    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.display.Image;
    import starling.animation.Transitions;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkBlendMode;
    import tatsuyakoyama.tkutility.TkUtil;

    import mrwarp.GameRecord;
    import mrwarp.actor.enemy.Enemy;
    import mrwarp.actor.enemy.EnemyView;

    //------------------------------------------------------------
    public class BossView extends EnemyView {

        private var _energyActor:BossEnergy;

        //------------------------------------------------------------
        public override function init():void {
            var image:Image = getImageFromAtlas('atlas-01', 'boss');
            _enemy.addImage(image, 128, 128);
            collisionRadius = 45;

            _energyActor = new BossEnergy();
            _energyActor.setParam(128, 128);
            _enemy.addActor(_energyActor);

            _setNormalColor();
        }

        private function _setNormalColor():void {
            _enemy.color = 0x77aaff;
            _energyActor.setNormalColor();
        }

        private function _setDamagedColor():void {
            _enemy.color = 0xee4444;
            _energyActor.setDamagedColor();
        }

        public override function onUpdate(passedTime:Number):void {
            _energyActor.resize(_enemy.life / _enemy.maxLife);
        }

        public override function attachDamageEffect():void {
            _setDamagedColor();
            _enemy.act().scaleTo(0, 1.4, 1.4).scaleToEaseOut(0.15, 1.0, 1.0);
            _enemy.act().wait(0.14).justdoit(0, function():void {
                if (_enemy.dying) { return; }
                _setNormalColor();
            });
        }
    }
}
