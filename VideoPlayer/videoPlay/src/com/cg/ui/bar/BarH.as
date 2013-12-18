package com.cg.ui.bar 
{
	import com.cg.ui.button.cgButton;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author cg
	 */
	public class BarH extends cgButton 
	{
		private var _block:Sprite;
		private var _dot:Sprite;
		public function BarH() 
		{
			_dot = getChildAt(numChildren - 1) as Sprite;
			_block = getChildAt(numChildren - 2) as Sprite;
		}
		override protected function init():void 
		{
			super.init();
			width = width;
			scaleY = 1;
		}
		
		override public function set width(n:Number):void
		{
			_block.width = n;
			_dot.x = int(_block.width * .5);
			if (_hit_area != null) {
				_hit_area.width = n;
			}
		}
	}

}