package tatsuyakoyama.tkframework.utility {

    import starling.text.TextField;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    //------------------------------------------------------------
    public class TkTextFactory {

        //------------------------------------------------------------
        public static function makeText(
            width:int,
            height:int,
            text:String,
            fontSize:int,
            fontName:String = "tk_courier",
            color:uint = 0xffffff,
            x:Number = 0,
            y:Number = 0,
            hAlign:String = HAlign.LEFT,
            vAlign:String = VAlign.TOP,
            touchable:Boolean = false
        ):TextField {

            var textField:TextField = new TextField(width, height, text);
            textField.fontSize  = fontSize;
            textField.fontName  = fontName;
            textField.color     = color;
            textField.x         = x;
            textField.y         = y;
            textField.hAlign    = hAlign;
            textField.vAlign    = vAlign;
            textField.touchable = touchable;
            return textField;
        }
    }
}
