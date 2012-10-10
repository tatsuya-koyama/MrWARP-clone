package tatsuyakoyama.tkactor {

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkutility.TkUtil;

    /**
     * Fade color represented by interger smoothly.
     */
    //------------------------------------------------------------
    public class ColorActor extends TkActor {

        public var red  :int;
        public var green:int;
        public var blue :int;

        //------------------------------------------------------------
        public function get colorInt():int {
            return TkUtil.rgb2int(red, green, blue);
        }

        //------------------------------------------------------------
        public function ColorActor(color:int) {
            red   = TkUtil.getRed  (color);
            green = TkUtil.getGreen(color);
            blue  = TkUtil.getBlue (color);
        }

        public function fadeTo(color:int, fadeTime:Number=1.0):void {
            enchant(fadeTime).animate('red'  , TkUtil.getRed  (color))
            enchant(fadeTime).animate('green', TkUtil.getGreen(color))
            enchant(fadeTime).animate('blue' , TkUtil.getBlue (color))
        }
    }
}
