package victor.comp
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import victor.DisplayUtil;
	import victor.Global;
	import victor.LoadImage;
	
	public class UploadNowPicComp extends Sprite
	{
		private var skin:ui_Skin_UploadNowPicComp;
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
			
			skin = new ui_Skin_UploadNowPicComp();
			addChild( skin );
			
			btnCamera = skin.btnCamera;
			btnLocal = skin.btnLocal;
			area = skin.area;
			txtLabel = skin.txt;
			
			addListener();
		}
		
		public function loadImage( url:String ):void
		{
			var pos:Point = area.localToGlobal( Global.loadingLocalPos2 );
			new LoadImage( url, setBitmap, pos );
		}
		
		public function setBitmap( bitmap:DisplayObject ):void
		{
			DisplayUtil.removeAll( area );
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