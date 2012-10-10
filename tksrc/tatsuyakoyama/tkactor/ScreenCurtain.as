package tatsuyakoyama.tkactor {

    import starling.display.Quad;

    import tatsuyakoyama.TkConfig;
    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkEventType;
    import tatsuyakoyama.tkutility.TkUtil;

    //------------------------------------------------------------
    public class ScreenCurtain extends TkActor {

        private var _quad:Quad;

        public var _color1:int;
        public var _color2:int;
        public var _color3:int;
        public var _color4:int;
        public var vertexColors:Vector.<ColorActor> = new Vector.<ColorActor>();

        //------------------------------------------------------------
        /**
         * color index:
         *   1 - 2
         *   | / |
         *   3 - 4
         */
        public function ScreenCurtain(color1:int=0, color2:int=0,
                                      color3:int=0, color4:int=0) {
            touchable = true;

            _quad = new Quad(TkConfig.SCREEN_WIDTH, TkConfig.SCREEN_HEIGHT);
            _quad.touchable = true;
            _quad.setVertexColor(0, color1);
            _quad.setVertexColor(1, color2);
            _quad.setVertexColor(2, color3);
            _quad.setVertexColor(3, color4);
            addChild(_quad);

            _color1 = color1;
            _color2 = color2;
            _color3 = color3;
            _color4 = color4;
        }

        public override function init():void {
            listen(TkEventType.CHANGE_BG_COLOR, _onChangeBgColor);

            vertexColors.push(new ColorActor(_color1));
            vertexColors.push(new ColorActor(_color2));
            vertexColors.push(new ColorActor(_color3));
            vertexColors.push(new ColorActor(_color4));
            for each (var vertexColor:ColorActor in vertexColors) {
                addActor(vertexColor);
            }
        }

        private function _onChangeBgColor(args:Object):void {
            var fadeTime:Number = args.fadeTime;
            var color1:int      = args.color1;
            var color2:int      = args.color2;
            var color3:int      = args.color3;
            var color4:int      = args.color4;

            var fadeTime:Number = 1.0;
            vertexColors[0].fadeTo(color1, fadeTime);
            vertexColors[1].fadeTo(color2, fadeTime);
            vertexColors[2].fadeTo(color3, fadeTime);
            vertexColors[3].fadeTo(color4, fadeTime);
        }

        public override function setVertexColor(color1:int=0, color2:int=0,
                                                color3:int=0, color4:int=0):void {
            _quad.setVertexColor(0, color1);
            _quad.setVertexColor(1, color2);
            _quad.setVertexColor(2, color3);
            _quad.setVertexColor(3, color4);
        }

        public override function onUpdate(passedTime:Number):void {
            setVertexColor(
                vertexColors[0].colorInt,
                vertexColors[1].colorInt,
                vertexColors[2].colorInt,
                vertexColors[3].colorInt
            );
        }
    }
}
