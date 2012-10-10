package mrwarp.lib {

    import starling.text.TextField;

    import tatsuyakoyama.tkframework.TkGameObject;
    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkframework.TkAction;
    import tatsuyakoyama.tkframework.utility.TkTextFactory;
    import tatsuyakoyama.tkactor.TextButton;

    /**
     * ゲーム中はシーンをまたいで使いたくなったりする、
     * 状態やクラス変数にはそんなに依存しない、
     * かといってあらゆるゲームでも使えるかというとそうでもない、
     * 置き場所に若干困るようなそんなコード片集
     */
    //------------------------------------------------------------
    public class Snippets {

        /**
         * 押したら音鳴らして点滅して次のアクションをとるような
         * テキストボタンを作って返す
         */
        public static function makeMenuButton(
            creator:TkGameObject,
            text:String,
            x:Number, y:Number, width:Number, height:Number,
            onInvoke:Function, buttonHolder:TkActor=null,
            fontSize:int=24, color:uint=0xffffff,
            hAlign:String="center",
            vAlign:String="center"):TextButton
        {
            var textField:TextField = TkTextFactory.makeText(
                width, height, text, fontSize, "tk_courier", color,
                x, y, hAlign, vAlign, true
            );
            var textButton:TextButton = new TextButton(textField, function():void {
                Snippets.onTouchMenuButton(creator, textButton, onInvoke, buttonHolder);
            });

            return textButton;
        }

        public static function onTouchMenuButton(creator:TkGameObject, textButton:TextButton,
                                                 onInvoke:Function, buttonHolder:TkActor=null):void {
            creator.playSe('title_select');
            if (buttonHolder == null) { buttonHolder = textButton; }
            buttonHolder.touchable = false;

            var blinkLogo:Function = function(action:TkAction):void {
                action.actor.alpha = (action.frame % 2 == 0) ? 0.3 : 1;
            };
            creator.whiteIn(0.3, 0.5);
            textButton.act().goon(0.5, blinkLogo).alphaTo(0, 1).justdoit(0, onInvoke);
        }

    }
}
