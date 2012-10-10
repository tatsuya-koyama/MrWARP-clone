package tatsuyakoyama.tkframework {

    import starling.animation.Juggler;

    import tatsuyakoyama.tkutility.TkUtil;

    //------------------------------------------------------------
    public class TkLayer extends TkActor {

        private var _juggler:Juggler = new Juggler();
        private var _timeScale:Number = 1;

        //------------------------------------------------------------
        public function get juggler():Juggler {
            return _juggler;
        }

        public function set timeScale(value:Number):void {
            _timeScale = value;
        }

        //------------------------------------------------------------
        public function TkLayer() {
            touchable = true;
        }

        public override function dispose():void {
            _juggler.purge();
            super.dispose();
        }

        public override function onUpdate(passedTime:Number):void {
            var layerPassedTime:Number = passedTime * _timeScale;

            for (var i:int=0;  i < childActors.length;  ++i) {
                var actor:TkActor = childActors[i];
                if (actor.isDead) {
                    childActors.splice(i, 1);  // remove actor from Array
                    removeChild(actor);
                    actor.dispose();
                    --i;
                    continue;
                }
                actor.update(layerPassedTime);
            }

            _juggler.advanceTime(layerPassedTime);
        }
    }
}
