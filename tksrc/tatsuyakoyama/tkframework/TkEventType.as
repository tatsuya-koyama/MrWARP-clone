package tatsuyakoyama.tkframework {

    import starling.errors.AbstractClassError;

    public class TkEventType {

        public function TkEventType() {
            throw new AbstractClassError();
        }

        // dispatched when Flash / AIR is suspended / resumed
        public static const SYSTEM_ACTIVATE:String   = 'tk.systemActivate';
        public static const SYSTEM_DEACTIVATE:String = 'tk.systemDeactivate';

        // used by TkScene
        public static const EXIT_SCENE:String = 'tk.exitScene';

        // expected args: {x:Number, y:Number}
        public static const SCREEN_TOUCHED:String = 'tk.screenTouched';

        // expected args: {fadeTime:Number, color1:int, color2:int, color3:int, color4:int}
        public static const CHANGE_BG_COLOR:String = 'tk.changeBgColor';
    }
}
