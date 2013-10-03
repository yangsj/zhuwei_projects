package victor.comp
{
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class CompleteEditComp extends Sprite
	{
		
		private var skin:ui_Skin_CompleteOver;
		private var btnCompare:SimpleButton;
		private var btnUpload:SimpleButton;
		private var area:Sprite;
		
		private var func1:Function, func2:Function;
		
		public function CompleteEditComp(func1:Function, func2:Function)
		{
			this.func1 = func1;
			this.func2 = func2;
			
			x = 378;
			y = 128;
			
			skin = new ui_Skin_CompleteOver();
			addChild( skin );
			
			btnCompare = skin.btnCompare;
			btnUpload = skin.btnUpload;
			area = skin.area;
			
			addListener();
		}
		
		public function setBitmap( bitmap:Bitmap ):void
		{
			area.removeChildren();
			area.addChild( bitmap );
		}
		
		private function addListener():void
		{
			btnCompare.addEventListener(MouseEvent.CLICK, btnCompareHandler );
			btnUpload.addEventListener(MouseEvent.CLICK, btnUploadHandler );
		}
		
		protected function btnUploadHandler(event:MouseEvent):void
		{
			func1();
		}
		
		protected function btnCompareHandler(event:MouseEvent):void
		{
			func2();
		}
		
	}
}