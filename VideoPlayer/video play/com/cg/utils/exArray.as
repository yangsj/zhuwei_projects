package com.cg.utils
{
	import flash.geom.Point;
	public class exArray
	{
		static public function toArray(o:*):Array
		{
			if (o is Array) {
				return o;
			}
			return [o];
		}
		static private function taxis(element1:*,element2:*):int
		{
			return Math.random()<0.5?-1:1;
		}
		static public function rndSort(arr:Array):void
		{
			arr.sort(taxis);
		}
		/**
		 * 交互两个数据的位置
		 * @param	arr 待操作的数据
		 * @param	i 第一个数据的位置
		 * @param	j 第二个数据的位置
		 */
		static public function swap(arr:Array, i:int, j:int):void
		{
			var oa:* = arr[i];
			arr[i] = arr[j];
			arr[j] = oa;
		}
		/**
		 * 插入数据
		 * @param	o
		 * @param	arr
		 * @param	i  要插入的位置
		 */
		static public function insert(o:*, arr:Array, i:int):void
		{
			arr.splice(i, 0, o);
		}
		/**
		 * 移动第i个数据到第j个
		 * @param	arr
		 * @param	i
		 * @param	j
		 */
		
		static public function move(arr:Array, i:int, j:int):void
		{
			var o:*= arr[i];
			arr.splice(i, 1);
			insert(o, arr, j);
		}
		/**
		 * 完全拷贝
		 */
		 public static function clone(arr:Array):Array
        {
            return exObj.clone(arr) as Array;
        }
		/**
		 * 两个数组是否相等
		 */
		 public static function equals(array1:Array, array2:Array):Boolean
        {
            if (array1.length != array2.length)
                return false;
                
            var n:int = array1.length;
            for (var i:int = 0;i < n; i++)
            {
                if (array1[i] !== array2[i])
                    return false;
            }
            return true;
        }
		/**
		 * 从数组中随机取n个元素组成新的数组
		 */
		public static function selectRandom(array:Array, n:int = 1):Array
        {
            if (array.length < n)
                throw new Error("n大于数组的长度.");
                
            var a:Array = array.concat();
            var result:Array = [];
            var idx:int;
            var b:*;
            for (var i:Number = 0;i < n; i++)
            {
                idx = Math.floor(Math.random() * a.length);
                b = a.splice(idx, 1);
                result.push(b[0]);
            }
            return result;
        }
		/**
		 * 用content填满数组
		 */
		public static function fill(array:Array, content:* = null):Array
        {
            return array.map(function(...param):Point
            {
                return content;
            });
            ;
        }
		/**
		 * array中是否包含element，useCast值为true时，不自动转换格式
		 */
		public static function contains(array:Array, element:*, useCast:Boolean = false):Boolean
        {
            return array.some(function(e:*, ...param):Boolean
            {
                if (useCast)
                    return e == element;
                else
                    return e === element;
            });
        }
		 /**
         * 两个数组相减
         * 
         */
        public static function substract(a1:Array, a2:Array):Array
        {
            return a1.filter(function(b:*, ...param):Boolean
            {
                return !a2.some(function(b2:*, ...param):Boolean
                {
                    return b == b2;
                });
            });;
        }
        
        /**
         * 从数组中删除指定元素
         */
        public static function remove(a:Array, item:*):Array
        {
        	return a.filter(function(i:*, ...param):Boolean
        	{
        	   return i != item;	
        	});
        }
		/**
		 * 根据元素查找下一个，如果loop为true，当元素在最后一个时，返回第一个元素
		 */
        public static function nextOne(array : Array, element : *, loop:Boolean = false) : *
        {
            var idx : int = -1;
            for (var i : int = 0; i < array.length; i++)
            {
                if (array[i] === element)
                {
                    idx = i;
                    break;
                }
            }
            if (idx == -1)
                return null;
            else if ( idx >= array.length -1)
                return (loop) ? array[0] : null; 
            else
                return array[i+1];    
        }
		/**
		 * 根据元素查找前一个，如果loop为true，当元素在第一个时，返回最后一个元素
		 */
        public static function prevOne(array : Array, element : *,  loop:Boolean = false) : *
        {
            var idx : int = -1;
            for (var i : int = 0; i < array.length; i++)
            {
                if (array[i] === element)
                {
                    idx = i;
                    break;
                }
            }
            
            if (idx == -1)
                return null;
            else if(idx == 0)
                return (loop) ? array[array.length-1] : null;
            else
                return array[i-1];    
        }

        /**
         * 根据元素的特定属性求和，支持数字和文字求和
         */
        public static function sum(array : Array, prop : String) : *
        {
        	var result:*;
            array.forEach(function(o : Object, ...param) : void
            {
                if (result == undefined)
                {
                if (o[prop] is Number) 
                    result = 0;
                else if (o[prop] is String)
                    result = "";
                else
                    throw new Error("无法求和：" + typeof o[prop]);
                }
                
                result += o[prop];
            });
            return result;
        }

        /**
         * 求特定属性的最大值
         */
        public static function max(array : Array, prop : String) : *
        {
            var result:*;
            array.forEach(function(o:Object, ...param) : void
            {
            	var n:* = o[prop];
                result = result > n ? result : n;
            });
            return result;
        }

        /**
         * 为每个元素的特定属性赋值
         */
        public static function setProperty(array : Array, prop : String, value : *) : void
        {
            array.forEach(function(o:Object, ...param) : void
            {
            	o[prop] = value;
            });
        }
	}
}