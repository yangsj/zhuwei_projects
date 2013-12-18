package com.cg.debug
{
	import com.cg.utils.RemotingTracer;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.*;

	public class Tracer extends Sprite
	{
		private static var _instance:Tracer;
		private static var instanced:Boolean;
		
		
		private static var __Flash_Tracer_DoNotBroadcast:Boolean = false;
		private static var __Flash_Tracer_DoNotTrace:Boolean = false;
		
		public  var msg:TextField;
		private var _width:Number;
		private var _height:Number;
		public function Tracer(enforcer:Enforcer)
		{
			if(enforcer==null){
				throw new Error("单例类，无法用new新建，请使用 instance 获取它的唯一实例")
			}
		}
		public static function get instance():Tracer{
			if(Tracer._instance==null){
				Tracer._instance=new Tracer(new Enforcer());
				Tracer._instance.init();
				instanced=true;
			}
			return Tracer._instance
		}
		
		override public function get width():Number 
		{
			return _width;
		}
		
		override public function set width(value:Number):void 
		{
			_width = value;
			msg.width = _width;
		}
		
		override public function get height():Number 
		{
			return _height;
		}
		
		override public function set height(value:Number):void 
		{
			_height = value;
			msg.height = _height;
		}
		
		static public function get DoNotBroadcast():Boolean 
		{
			return __Flash_Tracer_DoNotBroadcast;
		}
		
		static public function set DoNotBroadcast(value:Boolean):void 
		{
			__Flash_Tracer_DoNotBroadcast = value;
			RemotingTracer.DoNotBroadcast = __Flash_Tracer_DoNotBroadcast;
		}
		
		static public function get DoNotTrace():Boolean 
		{
			return __Flash_Tracer_DoNotTrace;
		}
		
		static public function set DoNotTrace(value:Boolean):void 
		{
			__Flash_Tracer_DoNotTrace = value;
			RemotingTracer.DoNotTrace = __Flash_Tracer_DoNotTrace;
		}
		public static function str(...arguments):void{
			var _str:String=RemotingTracer.str.apply(null, arguments);
			if(instanced){
				instance.msg.appendText(_str+"\n");
				instance.msg.scrollV = instance.msg.maxScrollV;
			}
		}
		public static function obj(...arguments):void
		{
			var _str:String = RemotingTracer.obj(arguments);
			if(instanced){
				instance.msg.appendText(_str+"\n");
				instance.msg.scrollV = instance.msg.maxScrollV;
			}
		}
		public static function printAllChilds(_obj:DisplayObjectContainer,level:int=0,printData:Boolean=false):void{
			if(level==0){
				str("START Print Container")
			}
			var headSpace:String=""
			var i:int;
			for(i=0;i<level;i++){
				headSpace+="|\t";
			}
			str(headSpace+"++\t"+_obj.name+":"+getQualifiedClassName(_obj))
			if(printData){
				obj(_obj, level + 1);
			}
			var cn:int=_obj.numChildren
			for(i=0;i<cn;i++){
				var child:DisplayObject=_obj.getChildAt(i) as DisplayObject;
				str(headSpace+((child is DisplayObjectContainer)?"++":"--")+"\t"+child.name+":\t"+getQualifiedClassName(child))
				if(child is DisplayObjectContainer){
					printAllChilds(child as DisplayObjectContainer,level+1,printData)
				}
			}
			if(level==0){
				str("END Print Container\n\n")
			}
		}
		//打印DisplayObject路径，final_class指终止容器
		public static function printDisplayPath(dis:DisplayObject,final_class:Class):void{
			var arr:Array=new Array()
			arr.push(dis.name)
			var p:DisplayObject=dis
			var n:int=0
			str("start print displayObject path")
			str(n+"\t:"+p+"\tname:"+p.name)
			while(!(p is final_class)){
        		p=p.parent
        		n++
        		str(n+"\t:"+p+"\tname:"+p.name)
        		arr.unshift(p.name)
        	}
        	str(arr.join("."))
        	arr=null
		}
		//////////////////////////////////////////////////////
        //private
        //////////////////////////////////////////////////////
        private function init():void{
			msg = new TextField();
			//msg.background=true;
			msg.wordWrap = true;
			msg.type="input";
			addChild(msg);
		}
		
	}
}
//内部类
class Enforcer {}