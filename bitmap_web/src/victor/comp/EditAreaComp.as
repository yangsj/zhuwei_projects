package victor.comp
{
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class EditAreaComp extends Sprite
	{
		private var _skin:ui_Skin_EditPictureArea;
		private var _btnZoonIn:SimpleButton;
		private var _btnZoonOut:SimpleButton;
		private var _btnRotateLeft:SimpleButton;
		private var _btnRotateRight:SimpleButton;
		private var _area:Sprite;
		private var _container:Sprite;
		
		
		public function EditAreaComp()
		{
			x = 358;
			y = 120;
			
			_skin = new ui_Skin_EditPictureArea();
			addChild( _skin );
			
			_btnZoonIn = _skin.btnZoonIn;
			_btnZoonOut = _skin.btnZoonOut;
			_btnRotateLeft = _skin.btnRotateLeft;
			_btnRotateRight = _skin.btnRotateRight;
			_area = _skin.area;
			_container = _area.getChildByName("pic") as Sprite;
			
			addListenr();
		}
		
		public function setLoader( loader:Loader ):void
		{
			_container.scaleX = 1;
			_container.scaleY = 1;
			_container.rotation = 0;
			
			_container.graphics.clear();
			_container.removeChildren();
			
			loader.x = -( loader.width >> 1 );
			loader.y = -( loader.height >> 1 );
			_container.addChild( loader );
		}
		
		private function addListenr():void
		{
			_btnZoonIn.addEventListener(MouseEvent.CLICK, onZoonInHandler );
			_btnZoonOut.addEventListener(MouseEvent.CLICK, onZoonOutHandler );
			_btnRotateLeft.addEventListener(MouseEvent.CLICK, onRotateLeftHandler );
			_btnRotateRight.addEventListener(MouseEvent.CLICK, onRotateRightHandler );
		}
		
		protected function onZoonInHandler(event:MouseEvent):void
		{
			_container.scaleX += 0.1;
			_container.scaleY += 0.1;
		}
		
		protected function onZoonOutHandler(event:MouseEvent):void
		{
			_container.scaleX -= 0.1;
			_container.scaleY -= 0.1;
		}
		
		protected function onRotateLeftHandler(event:MouseEvent):void
		{
			_container.rotation -= 90;
		}
		
		protected function onRotateRightHandler(event:MouseEvent):void
		{
			_container.rotation += 90;
		}
	}
}