package com.cg.utils
{
	import flash.display.*;
	
	public class exCon
	{
		public static function removeAllChild(con:DisplayObjectContainer){
			var num:int=con.numChildren;
			for(var i=0;i<num;i++){
				con.removeChild(con.getChildAt(0))
			}
		}
		//根据容器的y轴设置深度
		public static function sortDepths(con:DisplayObjectContainer,para:String="y"){
			var sort=new Array()
			for(var i=0;i<con.numChildren;i++){
				sort.push(con.getChildAt(i))
			}
			sort.sortOn(para,16)
			for(var j=0;j<sort.length;j++){
				con.setChildIndex(sort[j],j)
			}
		}
		/**
		 * 返回displayObject的路径
		 */
		public static function getDisplayListPath(displayObject:DisplayObject):String
        {
            return (function(displayObject : DisplayObject, path : String = ""):String
                    {
                        if (path.length > 0)
                           path = "." + path; 
                           
                        var name:String = 
                           (displayObject is Stage) ? "STAGE" : 
                           //(displayObject === DocumentClass.container) ? "DOCUMENTCLASS" :
                           displayObject.name; 
                        path = name + path;
            
                        var parent:DisplayObjectContainer = displayObject.parent;
                           
                        if (parent)
                            return arguments.callee(parent, path);
            
                        return path;
                    }
                   )(displayObject);
        }
		//查找a是否是con的子物体
		public static function isChildren(a:DisplayObject, con:DisplayObjectContainer):Boolean
		{
			var p:DisplayObjectContainer = a.parent as DisplayObjectContainer;
			while (p != null) {
				if (p == con)	return true;
				p = p.parent as DisplayObjectContainer;
			}
			return false;
		}
		//查找对象以及它的父对象是否以str命名
		public static  function findNameInParent(o:DisplayObject,str:String):Boolean
		{
			//trace("find name in parent: "+str)
			//trace(o.name)
			if(o.name==str){
				return true
			}
			var p:DisplayObjectContainer=o.parent as DisplayObjectContainer
			while(p!=null){
				//trace(p.name)
				if(p.name==str){
					return true
				}
				p=p.parent
			}
			//trace("not find")
			return false;
		}
		//查找对象及父对象是否以名称数组中的字符串命名
		public static  function findNameInArray(o:DisplayObject,arr:Array):Boolean
		{
			for(var i:int=0;i<arr.length;i++){
				if(findNameInParent(o,arr[i]))
				{
					return true
				}
			}
			return false;
		}
	}
}