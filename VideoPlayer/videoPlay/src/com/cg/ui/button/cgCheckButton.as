package com.cg.ui.button 
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import com.greensock.plugins.*;
	/**
	 * ...
	 * @author CG
	 */
	public class cgCheckButton extends cgButton 
	{
		private var _selected:Boolean;
		private var _icon:MovieClip;
		public function cgCheckButton() 
		{
			super();
			_icon = this.getChildByName("icon") as MovieClip;
			_icon.stop();
			TweenPlugin.activate([FrameLabelPlugin, FramePlugin]);
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			TweenMax.to(_icon, .1, { frameLabel:_selected?"selected":"unselected" } );
		}
		
		
	}

}