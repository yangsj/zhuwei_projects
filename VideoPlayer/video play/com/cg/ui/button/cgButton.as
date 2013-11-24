package com.cg.ui.button 
{
	import com.cg.ui.IFocus;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author cg
	 */
	public class cgButton extends cgBaseButton implements IFocus 
	{
		private var _lock_alpha:Number = .4;
		private var def_alpha:Number;
		/**
		 * 动画时间
		 * 
		 */
		public var motionTime:Number = .2;
		
		public function cgButton() 
		{
			_label_TF = this.getChildByName("_labelTxt") as TextField;
		}
		override protected function init():void 
		{
			super.init();
			label = _label;
			def_alpha = alpha;
		}
		override protected function onOver(e:MouseEvent):void 
		{
			super.onOver(e);
			if (lock) return;
			TweenMax.to(this, motionTime, { alpha:def_alpha, colorMatrixFilter: { brightness:1.5 }} );
		}
		override protected function onOut(e:MouseEvent):void 
		{
			super.onOut(e);
			if (_highLight) {
				TweenMax.to(this, motionTime, { alpha:def_alpha,colorMatrixFilter: { brightness:2 }} );
			}else {
				if (lock) return;
				TweenMax.to(this, motionTime, {  alpha:def_alpha, colorMatrixFilter: { brightness:1 }} );
			}
		}
		/**
		 * 锁定
		 * 
		 */
		override public function set lock(value:Boolean):void 
		{
			_lock = value;
			if (_lock) {
				mouseEnabled = false;
				if (!_highLight) {
					TweenMax.to(this, motionTime, { alpha:_lock_alpha, colorMatrixFilter: { brightness:1 }} );
				}
			}else {
				mouseEnabled=true;
				TweenMax.to(this,motionTime,{alpha:def_alpha, colorMatrixFilter: { brightness:1 }});
			}
		}
		public function get lock_alpha():Number 
		{
			return _lock_alpha;
		}
		
		public function set lock_alpha(value:Number):void 
		{
			_lock_alpha = value;
			if (!mouseEnabled) {
				lock = _lock;
			}
		}
		/**
		 * 高亮
		 * 
		 */
		override public function get highLight():Boolean 
		{
			return _highLight;
		}
		
		override public function set highLight(value:Boolean):void 
		{
			_highLight = value;
			lock = _highLight;
		}
		
	}

}