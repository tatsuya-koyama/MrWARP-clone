package tatsuyakoyama.tkutility {

    import flash.utils.getQualifiedClassName;
    import mx.utils.StringUtil;

    //------------------------------------------------------------
    public class TkUtil {

        public static var debugMode:Boolean = false;

        //------------------------------------------------------------
        // Logging
        //------------------------------------------------------------
        public static function log(msg:String, traceLevel:int=1):void {
            if (!debugMode) { return; }

            var error:Error = new Error();
            var functionName:String = _getFunctionName(error, traceLevel);
            var lineNumber:String   = _getLineNumber(error, traceLevel);
            trace(functionName + ' ::: ' + lineNumber + ' >>> ' + msg);
        }

        private static function _getFunctionName(e:Error, traceBackLevel:int=0):String {
            var stackTrace:String = e.getStackTrace();
            var traceLines:Array  = stackTrace.split('\n');
            var targetLine:String = traceLines[traceBackLevel + 1];
            var startIndex:int = 0;
            var endIndex:int   = 0;
            startIndex = targetLine.indexOf('at ', 0);
            endIndex   = targetLine.indexOf('()',  startIndex);
            return targetLine.substring(startIndex + 3, endIndex);
        }

        private static function _getLineNumber(e:Error, traceBackLevel:int=0):String {
            var stackTrace:String = e.getStackTrace();
            var traceLines:Array  = stackTrace.split('\n');
            var targetLine:String = traceLines[traceBackLevel + 1];
            var startIndex:int = 0;
            var endIndex:int   = 0;
            startIndex = targetLine.indexOf('\.as:');
            endIndex   = targetLine.indexOf(']');
            return targetLine.substring(startIndex + 4, endIndex);
        }

        public static function logClassName(obj:Object, traceLevel:int=2):void {
            var className:String = getQualifiedClassName(obj);
            log('[ClassName] ' + className, traceLevel);
        }

        public static function dump(obj:Object):void {
            trace('');
            var printKeyAndValue:Function = function(key:String, value:*, depth:int):void {
                log(StringUtil.repeat('    ', depth) + key + ': ' + value, 4);
            };
            traverseSortedWithKey(obj, printKeyAndValue);
            trace('');
        }

        //------------------------------------------------------------
        // Data structure general utils
        //------------------------------------------------------------
        /**
         * Traverse Object and apply function for each key-values.
         * @param callback Function that accepts (key:String, value:*, depth:int) as its parameter.
         */
        public static function traverse(obj:Object, callback:Function, depth:int=0):void {
            for (var key:String in obj) {
                var value:* = obj[key];
                callback(key, value, depth);
                if (typeof value == 'object') {
                    traverse(value, callback, depth + 1);
                }
            }
        }

        public static function traverseSortedWithKey(obj:Object, callback:Function, depth:int=0):void {
            var keys:Array = [];
            var key:String;
            for (key in obj) { keys.push(key); }
            keys.sort();

            for each (key in keys) {
                var value:* = obj[key];
                callback(key, value, depth);
                if (typeof value == 'object') {
                    traverseSortedWithKey(value, callback, depth + 1);
                }
            }
        }

        /**
         * Traverse Object and apply function for each key-values.
         * The callback accepts absolute path to target key joined by dot.
         * For example, given the following object:
         *     {
         *         hoge: {
         *             fuga: {
         *                 piyo: 123
         *             }
         *         }
         *     }
         * then callback of 'piyo: 123' key-value accepts ('piyo', 123, 'hoge.fuga.piyo')
         * as its parameter.
         *
         * @param callback Function that accepts (key:String, value:*, path:String) as its parameter.
         */
        public static function traverseWithAbsPath(obj:Object, callback:Function, path:String=''):void {
            for (var key:String in obj) {
                var value:* = obj[key];
                if (getQualifiedClassName(value) == 'Object'  &&  value != null) {
                    traverseWithAbsPath(value, callback, path + key + '.');
                } else {
                    callback(key, value, path + key);
                }
            }
        }

        /**
         * Convert nested object into new flat object.
         * For example, following object:
         *     {
         *         hoge: 123,
         *         fuga: {
         *             piyo: 456
         *         }
         *     }
         * is converted into object as below:
         *     {
         *         'hoge'     : 123,
         *         'fuga.piyo': 456
         *     }
         * This method is non-destructive.
         */
        public static function flattenObject(obj:Object):Object {
            var flattenedObj:Object = new Object();
            var addToFlatObj:Function = function(key:String, value:*, path:String):void {
                flattenedObj[path] = value;
            };
            traverseWithAbsPath(obj, addToFlatObj);
            return flattenedObj;
        }

        /**
         * Select function randomly from weighted function list,
         * using Roulette Wheel Selection algorithm.
         *
         * @param candidates Array such as:
         *     [
         *         {func: Function1, weight: 30},
         *         {func: Function2, weight: 70}
         *     ]
         */
        public static function selectFunc(candidates:Array):void {
            var totalWeight:Number = 0;
            for each (var data:Object in candidates) {
                totalWeight += data.weight;
            }

            var selectArea:Number = rand(totalWeight);
            var weightCountUp:Number = 0;
            for each (var data:Object in candidates) {
                weightCountUp += data.weight;
                if (weightCountUp >= selectArea) {
                    data.func();
                    return;
                }
            }
        }

        /**
         * Return value depending on threshold list.
         *
         * @param thresholds Array of Array such as:
         *     [[threshold:int, value:int]], ...]
         *
         * Example:
         *     if thresholds is [[100, 2], [200, 4], [300, 6]]
         *     and targetThreshold is 250,
         *     then this function returns 4 because 250 is larger than 200
         *     but smaller than 300.
         *
         */
        public static function selectValue(targetThreshold:int, thresholds:Array):Number {
            var result:int = NaN;
            for each (var data:Object in thresholds) {
                if (targetThreshold >= data[0]) {
                    result = data[1];
                }
            }
            return result;
        }

        //------------------------------------------------------------
        // Color utils
        //------------------------------------------------------------
        public static function getAlpha(color:uint):int { return (color >> 24) & 0xff; }
        public static function getRed  (color:uint):int { return (color >> 16) & 0xff; }
        public static function getGreen(color:uint):int { return (color >>  8) & 0xff; }
        public static function getBlue (color:uint):int { return  color        & 0xff; }

        /**
         * convert 24bit interger to RGB array (0xffffff -> [256, 256, 256])
         */
        public static function int2rgb(color:uint):Array {
            return [getRed(color), getGreen(color), getBlue(color)];
        }

        public static function rgb2int(red:int, green:int, blue:int):uint {
            return (red << 16) | (green << 8) | blue;
        }

        /**
         * convert HSV to 24bit interger
         *
         * @param hue （色相） [0, 360]
         *     360, 0: red
         *         60: yellow
         *        120: green
         *        180: cyan
         *        240: blue
         *        300: magenta
         *
         * @param saturation（彩度） [0, 1]
         *     0: 無彩色（グレースケール）
         *     1: 純色（最も鮮やか）
         *
         * @param val Value of Brightness （明度） [0, 1]
         *     0: 黒（最も暗い）
         *     1: 最も明るい（彩度が 0 なら白）
         */
        public static function hsv2int(hue:Number, saturation:Number, val:Number):uint {
            if (saturation <= 0) {
                return rgb2int(val, val, val);
            }

            var h:int = (hue / 60) % 6;
            var f:Number = (hue / 60) - h;
            var p:Number = val * (1 - saturation);
            var q:Number = val * (1 - (f * saturation));
            var t:Number = val * (1 - ((1 - f) * saturation));

            val *= 255;
            p   *= 255;
            q   *= 255;
            t   *= 255;

            switch (h) {
            case 0: return rgb2int(val, t, p);  break;
            case 1: return rgb2int(q, val, p);  break;
            case 2: return rgb2int(p, val, t);  break;
            case 3: return rgb2int(p, q, val);  break;
            case 4: return rgb2int(t, p, val);  break;
            case 5: return rgb2int(val, p, q);  break;
            }
            return 0xffffff;
        }

        public static function hsv2intWithRand(hMin:Number, hMax:Number,
                                               sMin:Number, sMax:Number,
                                               vMin:Number, vMax:Number):uint {
            return hsv2int(
                randArea(hMin, hMax),
                randArea(sMin, sMax),
                randArea(vMin, vMax)
            );
        }

        //------------------------------------------------------------
        // Math utils
        //------------------------------------------------------------
        public static function rand(max:Number):Number {
            return Math.random() * max;
        }

        public static function randInt(max:int):int {
            return int(rand(max));
        }

        public static function randArea(min:Number, max:Number):Number {
            return min + rand(max - min);
        }

        public static function randPlusOrMinus(min:Number, max:Number):Number {
            var val:Number = min + rand(max - min);
            if (rand(100) < 50) { val = -val; }
            return val;
        }

        public static function rad2deg(rad:Number):Number {
            return rad / Math.PI * 180.0;
        }

        public static function deg2rad(deg:Number):Number {
            return deg / 180.0 * Math.PI;
        }

        public static function within(value:Number, min:Number, max:Number):Number {
            if (value < min) { return min; }
            if (value > max) { return max; }
            return value;
        }
    }
}
