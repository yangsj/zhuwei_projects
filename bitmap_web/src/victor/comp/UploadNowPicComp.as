package victor.comp
{
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class UploadNowPicComp extends Sprite
	{
		private var skin:ui_Skin_StartCompareCom;
		private var btnCamera:SimpleButton;
		private var btnLocal:SimpleButton;
		private var area:Sprite;
		
		private var openCamera:Function, openLocal:Function;
		
		public function UploadNowPicComp(openCamera:Function, openLocal:Function)
		{
			this.openCamera =openCamera;
			this.openLocal = openLocal;
			
			skin = new ui_Skin_StartCompareCom();
			addChild( skin );
			
			btnCamera = skin.btnCamera;
			btnLocal = skin.btnLocal;
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