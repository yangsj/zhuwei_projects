package com.cg.ui.button 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author cg
	 */
	public class cgButtonGroup extends Sprite 
	{
		/**
		 * 是否允许没有按钮呈现HighLight
		 * 
		 */
		public var noHighLightByStageClick:Boolean = false;
		private var _highLightBtn:IcgButton;
		
		public function cgButtonGroup() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdd2Stage);
		}
		
		private function onAdd2Stage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdd2Stage);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			stage.addEventListener(MouseEvent.CLICK, onClick);
			init();
		}
		
		private function init():void 
		{
			
		}
		
		private function onClick(e:MouseEvent):void
		{
			if (e.target.parent != this) {
				if (noHighLightByStageClick && highLightBtn!=null) {
					highLightBtn = null;
					dispatchEvent(new Event(Event.CANCEL));
				}
			}else if (e.target is IcgButton) {
				highLightBtn = e.target as IcgButton;
				dispatchEvent(new Event(Event.SELECT));
			}
			
		}
		
		private function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			removeEventListener(MouseEvent.CLICK, onClick);
			
		}
		
		public function get highLightBtn():IcgButton 
		{
			return _highLightBtn;
		}
		
		public function set highLightBtn(_button:IcgButton):void 
		{
			if (_highLightBtn == _button) return;
			if(_highLightBtn!=null){
				_highLightBtn.highLight = false;
			}
			_highLightBtn = _button;
			if(_highLightBtn!=null){
				_highLightBtn.highLight = true;
			}
		}
		
	}

}