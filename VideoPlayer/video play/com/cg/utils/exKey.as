/*
 * 
 实现as2中的isDown，用法：
 
 import com.cg.utils.exKey;


exKey.init(stage,keyTestHandler);
function keyTestHandler(e:Event) {
	if (exKey.isDown(Keyboard.LEFT)) {
		box.x-=5;
	}
	if (exKey.isDown(Keyboard.RIGHT)) {
		box.x+=5;
	}
	if (exKey.isDown(Keyboard.DOWN)) {
		box.y+=5;
	}
	if (exKey.isDown(Keyboard.UP)) {
		box.y-=5;
	}
}
 
 */
package com.cg.utils{
	import flash.display.InteractiveObject;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	public class exKey {
		private static  var keyObj:Object;
		private static  var io:InteractiveObject;
		private static  var keyTestHandler:Function;
		public static var inited:Boolean;
		public static function init(io:InteractiveObject,keyTestHandler:Function):void {
			exKey.inited=true;
			exKey.io=io;
			exKey.keyTestHandler=keyTestHandler;
			keyObj=new Object  ;
			io.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			io.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
		}
		public static function remove(){
			exKey.inited=false;
			io.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			io.removeEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
			exKey.io=null;
			keyObj=null;
			exKey.keyTestHandler=null;
		}
		public static function isDown(key:int):Boolean {
			if(inited){
				return ! ! keyObj[key];
			}
			return false
		}
		private static function keyDownHandler(e:KeyboardEvent):void {
			if(inited){
				keyObj[e.keyCode]=true;
				io.addEventListener(Event.ENTER_FRAME,keyTestHandler);
			}
		}
		private static function keyUpHandler(e:KeyboardEvent):void {
			if(inited){
				delete keyObj[e.keyCode];
				keyObjHasProperty()?removeKeyTestHandler():null;
			}
		}
		private static function keyObjHasProperty():Boolean {
			if(inited){
				for each (var j:Boolean in keyObj) {
					if (j) {
						return false;
					}
				}
			}
			return true;
		}
		
		private static function removeKeyTestHandler():void {
			if(inited){
				io.removeEventListener(Event.ENTER_FRAME,keyTestHandler);
			}
		}
		public static function get KeyObj():Object {
			if(inited){
				return exKey.keyObj;
			}
			return null;
		}
	}
}