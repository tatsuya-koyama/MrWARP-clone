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
    public class AngerView extends EnemyView {

        //------------------------------------------------------------
        public override function init():void {
            var image:Image = getImageFromAtlas('atlas-01', 'enemy_01');
            image.blendMode = TkBlendMode.ADD;
            _enemy.addImage(image, 40, 40);
            _enemy.color = 0xee8888;

            _initPeriodicTasks();
        }

        private function _initPeriodicTasks():void {
            // たまにぷにょぷにょする
            addPeriodicTask(0.15, function():void {
                if (TkUtil.rand(100) > 10) { return; }
                _enemy.act().scaleToEaseIn(0.1, 0.8, 1.3)
                      .scaleToEaseOut(0.3, 1, 1);
            });
        }
    }
}
