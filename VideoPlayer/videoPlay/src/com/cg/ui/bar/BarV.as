package com.cg.ui.bar 
{
	import com.cg.ui.button.cgButton;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author cg
	 */
	public class BarV extends cgButton 
	{
		private var _block:Sprite;
		private var _dot:Sprite;
		public function BarV() 
		{
			_dot = getChildAt(numChildren - 1) as Sprite;
			_block = getChildAt(numChildren - 2) as Sprite;
		}
		override protected function init():void 
		{
			super.init();
			height = height;
			scaleY = 1;
		}
		
		override public function set height(n:Number):void
		{
			_block.height = n;
			_dot.y = int(_block.height * .5);
			if (_hit_area != null) {
				_hit_area.height = n;
			}
		}
	}

}