package tatsuyakoyama.tkutility {

    //------------------------------------------------------------
    public class TkPoint2D {

        public var x:Number;
        public var y:Number;

        //------------------------------------------------------------
        public function TkPoint2D(x:Number=0, y:Number=0) {
            this.x = x;
            this.y = y;
        }

        public function addVectorWithScale(vector2D:TkVector2D, scale:Number=1):void {
            x += vector2D.x * scale;
            y += vector2D.y * scale;
        }
    }
}
