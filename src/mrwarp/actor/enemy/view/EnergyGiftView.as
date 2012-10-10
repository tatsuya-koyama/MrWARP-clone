package mrwarp.actor.enemy.view {

    import starling.display.Image;
    import tatsuyakoyama.tkutility.TkUtil;
    import mrwarp.actor.enemy.EnemyView;

    //------------------------------------------------------------
    public class EnergyGiftView extends EnemyView {

        //------------------------------------------------------------
        public override function init():void {
            var image:Image = getImageFromAtlas('atlas-01', 'energy_gift');
            _enemy.addImage(image, 50, 50);
        }
    }
}
