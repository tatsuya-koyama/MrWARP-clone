package mrwarp.actor {

    import starling.display.Image;

    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkutility.TkUtil;

    //------------------------------------------------------------
    public class SceneBackground extends TkActor {

        //------------------------------------------------------------
        public function SceneBackground() {
            touchable = true;
        }

        public override function init():void {
            var image:Image = sharedObj.resourceManager.getImage('atlas-01', 'white');
            image.touchable = true;
            image.setVertexColor(0, 0xff0000);
            image.setVertexColor(1, 0x00ff00);
            image.setVertexColor(2, 0x0000ff);
            image.setVertexColor(3, 0xffffff);
            addImage(image, 320, 480);

            x = 320 / 2;
            y = 480 / 2;
            scaleX = 1.2;
            scaleY = 1.2;
        }
    }
}
