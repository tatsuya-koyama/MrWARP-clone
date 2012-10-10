package mrwarp.actor.enemy.view {

    import starling.display.Image;
    import tatsuyakoyama.tkutility.TkUtil;
    import mrwarp.actor.enemy.EnemyView;

    //------------------------------------------------------------
    public class UpgradeGiftView extends EnemyView {

        //------------------------------------------------------------
        public override function init():void {
            var image:Image = getImageFromAtlas('atlas-01', 'upgrade_gift');
            _enemy.addImage(image, 50, 50);
        }
    }
}
