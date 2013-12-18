package com.cg.ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author cg
	 */
	public class Grid9Mask extends Sprite 
	{
		private var bg:Sprite;
		public function Grid9Mask() 
		{
			bg = this.getChildAt(0) as Sprite;
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			bg.width = width;
			bg.height = height;
			scaleX =
			scaleY = 1;
		}
		override public function set width(n:Number):void
		{
			bg.width = n;
		}
		override public function set height(n:Number):void
		{
			bg.height = n;
		}
		
	}

}