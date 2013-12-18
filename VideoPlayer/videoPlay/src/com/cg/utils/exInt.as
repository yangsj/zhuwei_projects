package com.cg.utils
{
	public class exInt
	{
		//最小值
		public static function min(...args):int{
			var _min:int
			if(args.length==1){
				return args[0]
			}else{
				_min=args[0]
			}
			for(var i:int=1;i<args.length;i++){
				_min=Math.min(_min,args[i])
			}
			return _min
		}
		//最大值
		public static function max(...args):int{
			var _max:int
			if(args.length==1){
				return args[0]
			}else{
				_max=args[0]
			}
			for(var i:int=1;i<args.length;i++){
				_max=Math.max(_max,args[i])
			}
			return _max
		}
		//随机数
		public static function random(_min:int,_max:int,_step:int=1):int{
			var __min=_min/_step
			var __max=_max/_step
			return Math.round((__min + Math.random()*(__max-__min)))*_step
		}
		
		//限定在区间内
		public static function inArea(_n:int,_min:int,_max:int):int{
			if (_n < _min) {
				return _min;
			}else if (_n > _max) {
				return _max;
			}
			return _n;
		}

	}
}