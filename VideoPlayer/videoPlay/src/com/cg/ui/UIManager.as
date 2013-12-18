package com.cg.ui 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author cg
	 */
	public class UIManager extends Sprite
	{
		/**
		 * 是否自动显示当前焦点
		 * 
		 */
		public static var showCurrentFocus:Boolean=false;
		private static var _focus:IFocus;
		
		private static var _instance:UIManager;
		private static var instanced:Boolean;
		public function UIManager(enforcer:Enforcer)
		{
			if(enforcer==null){
				throw new Error("单例类，无法用new新建，请使用 instance 获取它的唯一实例")
			}
		}
		public static function get instance():UIManager{
			if(UIManager._instance==null){
				UIManager._instance=new UIManager(new Enforcer());
				UIManager._instance.init();
				instanced=true;
			}
			return UIManager._instance
		}
		
		private function init():void 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdd2Stage);
		}
		
		private function onAdd2Stage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdd2Stage);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			stage.removeEventListener(MouseEvent.CLICK, onClick);
			
		}
		private function onClick(e:MouseEvent):void 
		{
			if (e.target is IFocus) {
				
			}else {
				UIManager.focus = null;
			}
		}
		/**
		 * 设置当前焦点
		 * 
		 */
		static public function get focus():IFocus 
		{
			return _focus;
		}
		
		static public function set focus(value:IFocus):void 
		{
			if (_focus == value) return;
			if (_focus) {
				_focus.killFocus();
			}
			_focus = value;
			if (_focus) {
				_focus.setFocus();
			}
		}
		
		
	}

}

//内部类
class Enforcer {}