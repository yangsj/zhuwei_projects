package com.cg.ui 
{
	import com.greensock.TweenMax;
	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author cg
	 */
	public class UI extends MovieClip implements IFocus
	{
		public var fade_time:Number=0.3;
		protected var focus_filter:GlowFilter;
		protected var _isFocus:Boolean = false;
		public function UI() 
		{
			focus_filter = new GlowFilter(0x00CCFF);
			addEventListener(Event.ADDED_TO_STAGE, onAdd2Stage);
		}
		
		protected function onAdd2Stage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdd2Stage);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		protected function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			TweenMax.killTweensOf(this);
		}
		public function hide():void
		{
			visible = false;
			alpha = 0;
		}
		public function show():void
		{
			visible = true;
		}
		public function fadeIn(_delay:Number=0, handler:Function=null):void
		{
			TweenMax.killTweensOf(this);
			TweenMax.to(this, fade_time, { delay:_delay,autoAlpha:1,onComplete:handler} );
		}
		public function fadeOut(_delay:Number=0, handler:Function=null):void
		{
			TweenMax.killTweensOf(this);
			TweenMax.to(this, fade_time, { delay:_delay,autoAlpha:0,onComplete:handler} );
		}
		public function fadeOutAndRemove(_delay:Number=0, handler:Function=null):void
		{
			var _handler:Function = function():void
			{
				removeMe();
				if (handler != null) {
					handler();
				}
			}
			fadeOut(_delay, _handler);
		}
		public function removeMe():void
		{
			if (parent) {
				parent.removeChild(this);
			}
		}
		/**
		 * 设置为焦点
		 * 
		 */
		public function setFocus():void
		{
			if (_isFocus) return;
			var _filters:Array = filters;
			_filters.unshift(focus_filter);
			filters = _filters;
			_isFocus = true;
		}
		/**
		 * 取消焦点
		 * 
		 */
		public function killFocus():void
		{
			if (!isFocus) return;
			var _filters:Array = filters;
			_filters.shift();
			filters = _filters;
			_isFocus = false;
		}
		/**
		 * 是否为当前焦点，只读
		 * 
		 */
		public function get isFocus():Boolean 
		{
			return _isFocus;
		}
	}

}