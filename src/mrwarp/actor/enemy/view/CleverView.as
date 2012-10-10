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
    public class CleverView extends EnemyView {

        //------------------------------------------------------------
        public override function init():void {
            var image:Image = getImageFromAtlas('atlas-01', 'enemy_03');
            image.blendMode = TkBlendMode.ADD;
            _enemy.addImage(image, 40, 40);
            _enemy.color = 0xddcc22;
        }
    }
}
