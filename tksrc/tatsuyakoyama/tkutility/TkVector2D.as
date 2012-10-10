package tatsuyakoyama.tkutility {

    /**
     * Yes, I know flash.geom.Point, but...
     */
    //------------------------------------------------------------
    public class TkVector2D {

        public var x:Number;
        public var y:Number;

        private var _originalX:Number;
        private var _originalY:Number;

        //------------------------------------------------------------
        public function get length():Number {
            return Math.sqrt(x*x + y*y);
        }

        //------------------------------------------------------------
        public function TkVector2D(x:Number=0, y:Number=0) {
            this.x = x;
            this.y = y;
            _originalX = x;
            _originalY = y;
        }

        public function setValue(x:Number, y:Number):void {
            this.x = x;
            this.y = y;
        }

        public function toString():String {
            var formattedX:Number = Math.floor(x * 10) / 10;
            var formattedY:Number = Math.floor(y * 10) / 10;
            return '(x: ' + formattedX + ', ' + formattedY + ')';
        }

        /**
         * rotate to specified angle from zero radian
         */
        public function rotateTo(angleRadians:Number):void {
            angleRadians = -angleRadians;
            x = (Math.cos(angleRadians) * _originalX)
              + (Math.sin(angleRadians) * _originalY);

            y = (Math.sin(angleRadians) * -_originalX)
              + (Math.cos(angleRadians) *  _originalY);
        }

        public function setScalarMultiple(vector2D:TkVector2D, scalar:Number):void {
            x = vector2D.x * scalar;
            y = vector2D.y * scalar;
        }

        public function dotProduct(other:TkVector2D):Number {
            return (x * other.x) + (y * other.y);
        }

        public function normalize():TkVector2D {
            var length:Number = this.length;
            if (length == 0) {
                TkUtil.log('[Warning] Vector length is zero.');
                return null;
            }

            var inverse:Number = 1 / length;
            return new TkVector2D(
                this.x * inverse,
                this.y * inverse
            );
        }
    }
}
