package victor.comp
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import victor.DisplayUtil;
	import victor.LoadImage;
	
	public class CompleteEditComp extends Sprite
	{
		
		private var skin:ui_Skin_CompleteOver;
		private var btnCompare:SimpleButton;
		private var btnUpload:SimpleButton;
		private var area:Sprite;
		private var txt:TextField;
		
		private var func1:Function, func2:Function;
		
		public function CompleteEditComp(func1:Function, func2:Function)
		{
			this.func1 = func1;
			this.func2 = func2;
			
			x = 325;
			y = 100;
			
			skin = new ui_Skin_CompleteOver();
			addChild( skin );
			
			btnCompare = skin.btnCompare;
			btnUpload = skin.btnUpload;
			area = skin.area;
			txt = skin.txt;
			
			addListener();
		}
		
		public function setYear( year:int = 2010 ):void
		{
//			txt.text = year + "";
			txt.embedFonts = true;
			txt.text = year + "年的我们";
		}
		
		public function loadImage(url:String):void
		{
			new LoadImage( url, setBitmap );
		}
		
		public function setBitmap( bitmap:DisplayObject ):void
		{
			DisplayUtil.removeAll( area );
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