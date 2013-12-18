package com.cg.ui.button 
{
	import com.cg.ui.UI;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.*;
	import com.greensock.*;
	import com.greensock.plugins.*;
	import flash.text.TextField;
	
	import com.cg.ui.IFocus;
	import com.cg.ui.UIManager;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author cg
	 */
	public class cgBaseButton extends UI implements IFocus, IcgButton
	{
		public var onOverHander:Function;
		public var onOutHander:Function;
		
		protected var _lock:Boolean;
		protected var _highLight:Boolean;
		
		protected var _label:String="";
		protected var _label_TF:TextField;
		protected var _hit_area:Sprite;
		
		public function cgBaseButton() 
		{
			super();
		}
		
		override protected function onAdd2Stage(e:Event):void
		{
			super.onAdd2Stage(e);
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			init();
		}
		
		
		override protected function destroy(e:Event):void 
		{
			super.destroy(e);
			removeEventListener(MouseEvent.CLICK, onClick);
			removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		protected function onOver(e:MouseEvent):void 
		{
			if (onOverHander!=null) {
				onOverHander();
			}
		}
		protected function onOut(e:MouseEvent):void 
		{
			if (onOutHander!=null) {
				onOutHander();
			}
		}
		protected function onClick(e:MouseEvent):void 
		{
			if(UIManager.showCurrentFocus){
				UIManager.focus = this;
			}
		}
		protected function init():void 
		{
			mouseChildren = false;
			buttonMode = true;
			_hit_area = this.getChildByName("area") as Sprite;
			if (_hit_area != null) {
				this.hitArea = _hit_area;
				_hit_area.visible = false;
			}
		}
		/**
		 * 按钮文字
		 * 
		 */
		public function get label():String 
		{
			return _label;
		}
		
		public function set label(value:String):void 
		{
			_label = value;
			if (_label_TF!=null) {
				_label_TF.text = _label;
			}
		}
		
		/**
		 * 锁定
		 * 
		 */
		public function get lock():Boolean 
		{
			return _lock;
		}
		
		public function set lock(value:Boolean):void 
		{
			_lock = value;
			if (_lock) {
				mouseEnabled=false;
				alpha=.4;
			}else {
				mouseEnabled=true;
				alpha=1;
			}
		}
		/**
		 * 高亮
		 * 
		 */
		public function get highLight():Boolean 
		{
			return _highLight;
		}
		
		public function set highLight(value:Boolean):void 
		{
			_highLight = value;
		}
	}

}