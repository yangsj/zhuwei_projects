package com.cg.utils
{
	import flash.geom.Point;
	public class exNumber
	{
		private static const PI:Number = Math.PI;
		//最小值
		public static function min(...args):Number{
			var _min:Number
			if(args.length==1){
				return args[0]
			}else{
				_min=args[0]
			}
			for(var i:Number=1;i<args.length;i++){
				_min=Math.min(_min,args[i])
			}
			return _min
		}
		//最大值
		public static function max(...args):Number{
			var _max:Number
			if(args.length==1){
				return args[0]
			}else{
				_max=args[0]
			}
			for(var i:Number=1;i<args.length;i++){
				_max=Math.max(_max,args[i])
			}
			return _max
		}
		//随机数
		public static function random(_min:Number, _max:Number, _step:Number = 0):Number {
			if (_step != 0) {
				var __n:Number = (_max-_min) / _step;
				return Math.min(_max, _min +Math.round( Math.random() * __n) * _step);
			}
			return _min + Math.random() * (_max - _min);
		}
		//限定在区间内
		public static function inArea(_n:Number,_min:Number,_max:Number):Number{
			if (_n < _min) {
				return _min;
			}else if (_n > _max) {
				return _max;
			}
			return _n;
		}
		public static function getRadianFrom2Point(p1 : Point, p2 : Point) : Number
        {
        	var diff:Point = p2.subtract(p1);
            return Math.atan2(diff.y, diff.x);
        }
		public static function radiansToDegrees(radians:Number):Number 
        {
            return radians / PI * 180;
        }
		public static function degreesToRadians(degrees:Number):Number 
        {
            return degrees * PI / 180;
        }
		/**
		 * 将任意角度转化到 -180~180之间
		 * @param	degrees
		 * @return
		 */
		public static function normalizeDegrees(degrees:Number):Number
        {
            var d:Number = (degrees >= 360 || degrees <= -360) ? degrees % 360 : degrees;
            if (d > 180)
            {
                d = d - 360;
            }
            else if (d < -180)
            {
                d = d + 360;
            }
            else if (d == 180)
            {
                d = -180;
            }
            return d;
        }
		/**
		 * 求余数，代替flash默认的%
		 * trace(1.12345 % 1) //0.12345000000000006
		 * @param	num1
		 * @param	num2
		 * @param	fractionalPart 余数的精度
		 * @return
		 */
		public static function getRemainder(num1:Number, num2:Number, fractionalPart:Number):Number
        {
            var num:Number = num1 % num2;
			var _arr:Array = String(num).split(".");
			_arr[1] = String(_arr[1]).substr(0, fractionalPart);
            return Number(_arr[0]+"."+_arr[1]);
        }
		 /**
         * @private
         */
        private static function createZeroStr(num:Number):String
        {
            var zero:String = "";
            for (var i:int = 1;i < num; i++) 
            {
                zero += "0";
            }
            return zero;
        }
		 public static function hexToBinary(hex : String) : String 
        {
            var bin : String = "";
            for (var i : int = 0;i < hex.length;i++) 
            {
                var buff : String = hex.substr(i, 1);
                var temp : String = parseInt(buff, 16).toString(2);
                while(temp.length < 4)
                {
                    temp = "0" + temp;
                }
                bin += temp;
            }
            return bin;
        }

        public static function binToHex(bin : String) : String
        {
            var buff : String = "";
            var hex : String = "";
            for (var i : int = 1;i <= bin.length;i++) 
            {
                buff += bin.charAt(i - 1);
                if (i % 8 == 0)
                {
                    var temp : String = parseInt(buff, 2).toString(16);
                    if (temp.length == 1)
                     temp = "0" + temp;
                    hex += temp;

                    buff = "";
                } 
            }
            return hex;
        }
	}
}