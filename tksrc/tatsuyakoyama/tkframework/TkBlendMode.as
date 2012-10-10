package tatsuyakoyama.tkframework {

    import flash.display3D.Context3DBlendFactor;
    import starling.display.BlendMode;

    /**
     * Expand the blend modes of Starling framework.
     */
    //------------------------------------------------------------
    public class TkBlendMode {

        // Already exists in starling
        public static const AUTO     :String = "auto";
        public static const NONE     :String = "none";
        public static const NORMAL   :String = "normal";
        public static const ADD      :String = "add";
        public static const MULTIPLY :String = "multiply";
        public static const SCREEN   :String = "screen";
        public static const ERASE    :String = "erase";

        // My new blend mode
        public static const SUB:String = "sub";

        //------------------------------------------------------------
        public static function registerExtendedBlendModes():void {
            // ToDo: no premultiplied alpha のテクスチャのことも考える
            BlendMode.register(
                "sub",
                Context3DBlendFactor.ZERO,
                Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR,
                true
            );
        }
    }
}
