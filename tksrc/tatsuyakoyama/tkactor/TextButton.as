package tatsuyakoyama.tkactor {

    import starling.display.Image;
    import starling.display.BlendMode;
    import starling.text.TextField;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    import tatsuyakoyama.tkframework.TkActor;
    import tatsuyakoyama.tkutility.TkUtil;

    //------------------------------------------------------------
    public class TextButton extends TkActor {

        private var _text:TextField;
        private var _onTouchEnd:Function;

        //------------------------------------------------------------
        public function get text():TextField {
            return _text;
        }

        //------------------------------------------------------------
        public function TextButton(text:TextField, onTouchEnd:Function) {
            touchable = true;

            _text = text;
            addText(_text);

            _onTouchEnd = onTouchEnd;
            _text.addEventListener(TouchEvent.TOUCH, _onTouch);
        }

        private function _onTouch(event:TouchEvent):void {
            // ToDo: 外で指を離したときには作動させない
            var touchEnded:Touch = event.getTouch(this, TouchPhase.ENDED);
            if (touchEnded) {
                touchable = false;
                _onTouchEnd();
            }
        }
    }
}
