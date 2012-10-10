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
    import tatsuyakoyama.tkframework.TkEventType;
    import tatsuyakoyama.tkutility.TkUtil;

    import mrwarp.GameEvent;
    import mrwarp.actor.effect.*;

    //------------------------------------------------------------
    public class EffectGenerator extends TkActor {

        private var _effectMode:int    = 0;
        private var _generateFrame:int = 0;

        //------------------------------------------------------------
        public override function init():void {
            addPeriodicTask(0.13, _onGenerateEffect);
            listen(GameEvent.GAME_LEVEL_UP, _onGameLevelUp);
        }

        private function _onGenerateEffect():void {
            ++_generateFrame;

            switch (_effectMode) {
                case 0: _fallArrow();     break;
                case 1: _pastelCircle();  break;
                case 2: _passionPlant();  break;
                case 3: _cloud();         break;
                case 4: _snowFlake();     break;
                case 5: _tile();          break;
            }
        }

        private function _onGameLevelUp(args:Object):void {
            _changeBgColor();
            _effectMode = TkUtil.randInt(6);
        }

        private function _changeBgColor():void {
            var color1:uint = TkUtil.hsv2int(TkUtil.rand(360), 1, 0.4);
            sendMessage(TkEventType.CHANGE_BG_COLOR, {
                fadeTime: 1.0,
                color1: TkUtil.hsv2int(TkUtil.rand(360), TkUtil.randArea(0.3, 0.8), TkUtil.randArea(0.1, 0.3)),
                color2: TkUtil.hsv2int(TkUtil.rand(360), TkUtil.randArea(0.3, 0.8), TkUtil.randArea(0.1, 0.3)),
                color3: TkUtil.hsv2int(TkUtil.rand(360), TkUtil.randArea(0.3, 0.8), TkUtil.randArea(0.1, 0.3)),
                color4: TkUtil.hsv2int(TkUtil.rand(360), TkUtil.randArea(0.3, 0.8), TkUtil.randArea(0.1, 0.3))
            });
        }

        //------------------------------------------------------------
        private function _fallArrow():void {
            createActor(new FallArrow());
        }

        private function _pastelCircle():void {
            for (var i:int=0;  i < 2;  ++i) {
                createActor(new PastelCircle());
            }
        }

        private function _passionPlant():void {
            if (_generateFrame % 3 != 0) { return; }
            createActor(new PassionPlant());
        }

        private function _cloud():void {
            if (_generateFrame % 2 != 0) { return; }
            createActor(new Cloud());
        }

        private function _snowFlake():void {
            createActor(new SnowFlake());
        }

        private function _tile():void {
            for (var i:int=0;  i < 3;  ++i) {
                createActor(new Tile());
            }
        }
    }
}
