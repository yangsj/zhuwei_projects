package victor.comp
{
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import victor.DisplayUtil;
	
	public class UploadNowPicComp extends Sprite
	{
		private var skin:ui_Skin_StartCompareCom;
		private var btnCamera:SimpleButton;
		private var btnLocal:SimpleButton;
		private var area:Sprite;
		private var txtLabel:TextField;
		
		private var openCamera:Function, openLocal:Function;
		
		public function UploadNowPicComp(openCamera:Function, openLocal:Function)
		{
			x = 100;
			y = 100;
			
			this.openCamera =openCamera;
			this.openLocal = openLocal;
			
			skin = new ui_Skin_StartCompareCom();
			addChild( skin );
			
			btnCamera = skin.btnCamera;
			btnLocal = skin.btnLocal;
			area = skin.area;
			txtLabel = skin.txt;
			
			addListener();
		}
		
		public function setLabel( year:int ):void
		{
			txtLabel.text = year + "年的我们";
		}
		
		public function setBitmap( bitmap:Bitmap ):void
		{
			DisplayUtil.removeAll( area );
			bitmap.width = bitmap.width > 465 ? 465 : bitmap.width;
			bitmap.height = bitmap.height > 345 ? 345 : bitmap.height;
			area.addChild( bitmap );
		}
		
		private function addListener():void
		{
			btnCamera.addEventListener(MouseEvent.CLICK, btnCameraHandler );
			btnLocal.addEventListener(MouseEvent.CLICK, btnLocalHandler );
		}
		
		protected function btnLocalHandler(event:MouseEvent):void
		{
			openLocal();
		}
		
		protected function btnCameraHandler(event:MouseEvent):void
		{
			openCamera();
		}
	}
}