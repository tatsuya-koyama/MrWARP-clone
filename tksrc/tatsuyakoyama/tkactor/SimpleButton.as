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
    public class SimpleButton extends TkActor {

        private var _onTouchEnd:Function;

        //------------------------------------------------------------
        public function SimpleButton(onTouchEnd:Function) {
            touchable = true;

            _onTouchEnd = onTouchEnd;
            addEventListener(TouchEvent.TOUCH, _onTouch);
        }

        private function _onTouch(event:TouchEvent):void {
            // ToDo: 外で指を離したときには作動させない
            var touchEnded:Touch = event.getTouch(this, TouchPhase.ENDED);
            if (touchEnded) {
                event.stopPropagation();
                touchable = false;
                _onTouchEnd();
            }
        }
    }
}
