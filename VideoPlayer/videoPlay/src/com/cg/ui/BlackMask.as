package com.cg.ui
{
	import com.cg.ui.UI;
	import com.cg.utils.cgTransform;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flash.display.StageScaleMode;
	import flash.display.StageAlign; 
	/**
	 * ...
	 * @author CG
	 */
	public class BlackMask extends UI
	{
		
		public function BlackMask() 
		{
			//this.graphics.beginFill(0x000000, .8);
			//this.graphics.drawRect(0, 0, 100, 100);
			
			
		}
		override protected function onAdd2Stage(e:Event):void 
		{
			super.onAdd2Stage(e);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize(null);
		}
		override protected function destroy(e:Event):void
		{
			super.destroy(e);
			stage.removeEventListener(Event.RESIZE, onResize);
		}
		private function onResize(e:Event):void 
		{
			cgTransform.alignTo(this, stage,"CC");
		}
	}

}