package tatsuyakoyama.tkframework {

    import flash.display.Bitmap;
    import flash.geom.Rectangle;

    import starling.display.Image;
    import starling.text.TextField;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;
    import starling.animation.Juggler;
    import starling.animation.Tween;
    import starling.animation.Transitions;

    import tatsuyakoyama.TkConfig;
    import tatsuyakoyama.tkutility.TkUtil;
    import tatsuyakoyama.tkutility.TkTimeKeeper;

    //------------------------------------------------------------
    public class TkActor extends TkGameObject {

        private var _hasInitialized:Boolean = false;
        private var _hasDisposed:Boolean    = false;
        private var _markedForDeath:Boolean = false;  // 死亡フラグ

        protected var _checkDisplayArea:Boolean = false;
        protected var _cachedWidth :Number;
        protected var _cachedHeight:Number;

        private var _imageList  :Vector.<Image>     = new Vector.<Image>();
        private var _textList   :Vector.<TextField> = new Vector.<TextField>();
        private var _childActors:Vector.<TkActor>   = new Vector.<TkActor>();

        private var _color:uint = 0xffffff;
        public  var applyForNewActor:Function;
        public  var layer:TkLayer;  // reference of layer this actor belonged to
        public  var layerName:String;

        private var _actionInstructors:Vector.<TkActionInstructor> = new Vector.<TkActionInstructor>();
        private var _timeKeeper:TkTimeKeeper = new TkTimeKeeper();

        //------------------------------------------------------------
        // starling.display.DisplayObjectContainer の
        // width / height は重い行列計算走るので滅多なことでもない限り使うな
        public function get cachedWidth():Number {
            return _cachedWidth;
        }

        public function get cachedHeight():Number {
            return _cachedHeight;
        }

        public function get color():uint {
            return _color;
        }

        public function set color(color:uint):void {
            _color = color;
            for each (var image:Image in _imageList) {
                image.color = color;
            }
            for each (var text:TextField in _textList) {
                text.color = color;
            }
        }

        public function get childActors():Vector.<TkActor> {
            return _childActors;
        }

        public function get numActor():int {
            return _childActors.length;
        }

        //------------------------------------------------------------
        public function TkActor() {}

        public function setUp(sharedObj:TkSharedObjects, applyForNewActor:Function,
                              layer:TkLayer, layerName:String):void {
            if (_hasInitialized) {
                TkUtil.log('[Warning] TkActor has initialized twice.');
                return;
            }
            _hasInitialized = true;

            this.sharedObj = sharedObj;
            this.applyForNewActor = applyForNewActor;
            this.layer     = layer;
            this.layerName = layerName;
            init();

            TkProfileData.countActor(1, this.layerName);
        }

        public override function dispose():void {
            if (_hasDisposed) { return; }
            _hasDisposed = true;

            if (_hasInitialized) {
                _hasInitialized = false;
                TkProfileData.countActor(-1, this.layerName);
            }

            for each (var child:TkActor in _childActors) {
                child.dispose();
            }

            removeChildren(0, -1, true);
            removeCollision();
            removeTweens();
            _disposeImageTexture();
            _disposeText();
            _timeKeeper.dispose();

            _imageList         = null;
            _textList          = null;
            _childActors       = null;
            _actionInstructors = null;
            _timeKeeper        = null;

            onDispose();
            super.dispose();
        }

        protected function _disposeImageTexture():void {
            for (var i:uint=0;  i < _imageList.length;  ++i) {
                _imageList[i].texture.dispose();
                _imageList[i].dispose();
            }
        }

        protected function _disposeText():void {
            for each (var text:TextField in _textList) {
                text.dispose();
            }
        }

        protected function removeCollision():void {
            if (!sharedObj) { return; }
            sharedObj.collisionSystem.removeShapeWithActor(this);
        }

        public function update(passedTime:Number):void {
            if (_hasDisposed) { return; }

            for each (var child:TkActor in _childActors) {
                child.update(passedTime);
            }

            onUpdate(passedTime);
            _updateAction(passedTime);
            _timeKeeper.update(passedTime);
            disappearInOutside();
        }

        //------------------------------------------------------------
        /**
         * このメソッドは非推奨。
         * これは同じ画像でも texture が複製されてしまうので
         * メモリ効率がよくない。resourceManager から取得したものを
         * this.addImage の方に渡して使うことを推奨する
         */
        public function addImageByBitmap(bitmap:Bitmap):void {
            var image:Image = Image.fromBitmap(bitmap);
            addChild(image);
            _imageList.push(image);
        }

        public function addImage(image:Image,
                                 width:Number=NaN, height:Number=NaN,
                                 x:Number=0, y:Number=0,
                                 anchorX:Number=0.5, anchorY:Number=0.5):void
        {
            image.x = x;
            image.y = y;
            if (!isNaN(width )) { image.width  = width;  }
            if (!isNaN(height)) { image.height = height; }

            // pivotX, Y は回転の軸だけでなく座標指定にも影響する
            // そして何故かソースの画像の解像度に対する座標で指定してやらないといけないようだ
            var textureRect:Rectangle = image.texture.frame;
            image.pivotX = (textureRect.width  * anchorX);
            image.pivotY = (textureRect.height * anchorY);

            _cachedWidth  = width;
            _cachedHeight = height;

            addChild(image);
            _imageList.push(image);
        }

        public function addText(text:TextField, x:Number=NaN, y:Number=NaN):void {
            if (!isNaN(x)) { text.x = x; }
            if (!isNaN(y)) { text.y = y; }

            addChild(text);
            _textList.push(text);
        }

        public function addActor(actor:TkActor, putOnDisplayList:Boolean=true):void {
            _childActors.push(actor);
            if (putOnDisplayList) {
                addChild(actor);
            }

            actor.setUp(
                this.sharedObj, this.applyForNewActor,
                this.layer, this.layerName
            );
        }

        public function createActor(newActor:TkActor, layerName:String=null):void {
            // layerName 省略時は自分と同じ layer に出す
            if (layerName == null) {
                layerName = this.layerName;
            }
            applyForNewActor(newActor, layerName);
        }

        public function passAway():void {
            _markedForDeath = true;
        }

        public function get isDead():Boolean {
            return _markedForDeath;
        }

        public function setVertexColor(color1:int=0, color2:int=0,
                                       color3:int=0, color4:int=0):void {
            for each (var image:Image in _imageList) {
                image.setVertexColor(0, color1);
                image.setVertexColor(1, color2);
                image.setVertexColor(2, color3);
                image.setVertexColor(3, color4);
            }
        }

        //------------------------------------------------------------
        // Helpers for Tween
        //------------------------------------------------------------
        public function addTween(tween:Tween):void {
            if (!layer) {
                TkUtil.log('[Error] This actor does not belong to any layer.');
                return;
            }

            layer.juggler.add(tween);
        }

        public function removeTweens():void {
            if (!layer) {
                TkUtil.log('[Error] This actor does not belong to any layer.');
                return;
            }

            layer.juggler.removeTweens(this);
        }

        public function enchant(duration:Number, transition:String=Transitions.LINEAR):Tween {
            var tween:Tween = new Tween(this, duration, transition);
            addTween(tween);
            return tween;
        }

        //------------------------------------------------------------
        // Multi Tasker
        //------------------------------------------------------------
        public function act(action:TkAction=null):TkAction {
            var actionInstructor:TkActionInstructor = new TkActionInstructor(this, action);
            _actionInstructors.push(actionInstructor);
            return actionInstructor.action;
        }

        // purge actions
        public function react():void {
            _actionInstructors.length = 0;
        }

        private function _updateAction(passedTime:Number):void {
            for (var i:int=0;  i <_actionInstructors.length;  ++i) {
                var actionInstructor:TkActionInstructor = _actionInstructors[i];
                actionInstructor.update(passedTime);

                if (actionInstructor.isAllActionFinished) {
                    _actionInstructors.splice(i, 1);  // remove instructor from Array
                    --i;
                }
            }
        }

        // equivalent to setTimeout()
        public function addScheduledTask(timeout:Number, task:Function):void {
            _timeKeeper.addPeriodicTask(timeout, task, 1);
        }

        public function addPeriodicTask(interval:Number, task:Function, times:int=-1):void {
            _timeKeeper.addPeriodicTask(interval, task, times);
        }

        //------------------------------------------------------------
        /**
         * _checkDisplayArea = true の Actor は、画面外にいるときは表示を off にする
         * これをやってあげないと少なくとも Flash では
         * 画面外でも普通に描画コストがかかってしまうようだ。
         *
         * いずれにせよ visible false でなければ Starling は描画のための
         * 計算とかをしだすので、それを避けるにはこれをやった方がいい
         *
         * つまるところ、数が多く画像のアンカーが中央にあるような Actor を
         * _checkDisplayArea = true にすればよい
         */
        public function disappearInOutside():void {
            if (!_checkDisplayArea) { return; }

            // starling.display.DisplayObjectContainer の width / height は
            // getBounds という重い処理が走るのでうかつにさわってはいけない

            // オーバヘッドを抑えるため、ラフに計算。回転を考慮して大きめにとる。
            // 横長の画像などについては考えてないのでどうしようもないときは
            // _checkDisplayArea を false のままにしておくか、
            // _cachedWidth とかを書き換えるか、もしくは override してくれ

            var halfWidth :Number = (_cachedWidth  / 1.5) * scaleX;
            var halfHeight:Number = (_cachedHeight / 1.5) * scaleY;
            if (x + halfWidth  > 0  &&  x - halfWidth  < TkConfig.SCREEN_WIDTH  &&
                y + halfHeight > 0  &&  y - halfHeight < TkConfig.SCREEN_HEIGHT) {
                visible = true;
            } else {
                visible = false;
            }
        }
    }
}
