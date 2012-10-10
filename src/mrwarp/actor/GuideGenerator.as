package mrwarp.actor {

    import flash.display.Bitmap;
    import flash.geom.Point;

    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.display.Image;
    import starling.display.BlendMode;

    import starling.utils.Color;
    import starling.utils.deg2rad;

    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkAction;
    import tatsuyakoyama.tkframework.TkEventType;
    import tatsuyakoyama.tkutility.TkUtil;

    import mrwarp.GameRecord;
    import mrwarp.actor.effect.FallArrow;

    /**
     * Generate guide text for tutorial.
     */
    //------------------------------------------------------------
    public class GuideGenerator extends TkActor {

        //------------------------------------------------------------
        public override function init():void {
            addScheduledTask(0.1, _showPlayerIndicator);
            addScheduledTask(1.2, _showHowToWarp);
            addScheduledTask(3.5, _lightUp);

            if (GameRecord.playMode == 'tutorial') {
                addScheduledTask( 5.2, _showAvoid);
                addScheduledTask(16.7, _showSmashThrough);
                addScheduledTask(24.7, _showGoodLuck);
            }
        }

        //------------------------------------------------------------
        // helper
        //------------------------------------------------------------
        private function _showGuide(image:Image, x:Number, y:Number, width:Number, height:Number):void {
            var guide:TkActor = new TkActor();
            image.blendMode = BlendMode.ADD;
            guide.addImage(image, width, height);
            guide.x = x;
            guide.y = y;

            _attachAppearEffect(guide);
            createActor(guide);
        }

        private function _attachAppearEffect(target:TkActor):void {
            target.alpha = 0;
            var blink:Function = function(action:TkAction):void {
                action.actor.alpha = (action.frame % 2 == 0) ? 0.3 : 1;
            };
            target.act().wait(0.3).goon(0.3, blink).alphaTo(0, 0).alphaTo(0.3, 1)
                .wait(1.5).alphaTo(0.8, 0).kill();
        }

        //------------------------------------------------------------
        private function _showPlayerIndicator():void {
            var image:Image = getImageFromAtlas('atlas-02', 'tutorial_text_01');
            _showGuide(image, 160, 150, 256, 110);
        }

        private function _showHowToWarp():void {
            var image:Image = getImageFromAtlas('atlas-02', 'tutorial_text_02');
            _showGuide(image, 160, 370, 256, 90);
        }

        private function _showAvoid():void {
            _lightDownTemporarily();
            var image:Image = getImageFromAtlas('atlas-02', 'tutorial_text_03');
            _showGuide(image, 160, 130, 160, 140);
        }

        private function _showSmashThrough():void {
            _lightDownTemporarily();
            var image:Image = getImageFromAtlas('atlas-02', 'tutorial_text_04');
            _showGuide(image, 160, 320, 320, 157);
        }

        private function _showGoodLuck():void {
            _lightDownTemporarily();
            var image:Image = getImageFromAtlas('atlas-02', 'tutorial_text_05');
            _showGuide(image, 160, 160, 240, 120);
        }

        private function _lightUp():void {
            sendMessage(TkEventType.CHANGE_BG_COLOR, {
                fadeTime: 2.0,
                color1: 0x494949,
                color2: 0x333333,
                color3: 0x333333,
                color4: 0x111111
            });
        }

        private function _lightDownTemporarily():void {
            sendMessage(TkEventType.CHANGE_BG_COLOR, {
                fadeTime: 0.5,
                color1: 0x000000,
                color2: 0x111111,
                color3: 0x111111,
                color4: 0x222222
            });
            addScheduledTask(2.2, _lightUp);
        }
    }
}
