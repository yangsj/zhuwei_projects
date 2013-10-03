package victor.comp
{
	import com.greensock.TweenMax;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import victor.Global;
	import victor.event.AppEvent;
	
	public class EditAreaComp extends Sprite
	{
		private var _skin:ui_Skin_EditPictureArea;
		private var _btnZoonIn:SimpleButton;
		private var _btnZoonOut:SimpleButton;
		private var _btnRotateLeft:SimpleButton;
		private var _btnRotateRight:SimpleButton;
		private var _btnAgain:SimpleButton;
		private var _btnCommit:SimpleButton;
		private var _area:Sprite;
		private var _container:Sprite;
		private var _loaderSprite:Sprite;
		private var _endRotation:Number = 0;
		private var _endScale:Number = 1;
		
		private const DISPLAY_AREA:Rectangle = new Rectangle( 0, 0, 515, 380 );
		
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
			_btnAgain = _skin.btnAgain;
			_btnCommit = _skin.btnCommit;
			_area = _skin.area;
			_container = _area.getChildByName("pic") as Sprite;
			
			addListenr();
		}
		
		public function setLoader( display:DisplayObject ):void
		{
			_loaderSprite ||= new Sprite();
			_loaderSprite.removeChildren();
			_loaderSprite.addChild( display );
			
			_endScale = 1;
			_endRotation = 0;
			_container.scaleX = 1;
			_container.scaleY = 1;
			_container.rotation = 0;
			_container.x = DISPLAY_AREA.x + (DISPLAY_AREA.width >> 1);
			_container.y = DISPLAY_AREA.y + (DISPLAY_AREA.height>> 1);
			
			_container.graphics.clear();
			_container.removeChildren();
			
			_container.addChild( _loaderSprite );
		}
		
		private function addListenr():void
		{
			_btnZoonIn.addEventListener(MouseEvent.CLICK, onZoonInHandler );
			_btnZoonOut.addEventListener(MouseEvent.CLICK, onZoonOutHandler );
			_btnRotateLeft.addEventListener(MouseEvent.CLICK, onRotateLeftHandler );
			_btnRotateRight.addEventListener(MouseEvent.CLICK, onRotateRightHandler );
			_btnAgain.addEventListener(MouseEvent.CLICK, onAgainHandler );
			_btnCommit.addEventListener(MouseEvent.CLICK, onCommitHandler );
			addEventListener( Event.ENTER_FRAME, enterFrameHandler );
			_container.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler );
		}
		
		protected function mouseHandler(event:MouseEvent):void
		{
			if ( event.type == MouseEvent.MOUSE_DOWN )
			{
				appStage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler );
				var rect:Rectangle = new Rectangle();
				if (DISPLAY_AREA.width > _container.width )
				{
					rect.x = ( _container.width >> 1) + DISPLAY_AREA.x;
				}
				else
				{
					rect.x = (DISPLAY_AREA.width - ( _container.width >> 1)) + DISPLAY_AREA.x;
				}
				if ( DISPLAY_AREA.height > _container.height )
				{
					rect.y = (_container.height >> 1 ) + DISPLAY_AREA.y;
				}
				else
				{
					rect.y = (DISPLAY_AREA.height - (_container.height >> 1 )) + DISPLAY_AREA.y;
				}
				rect.width = Math.abs( _container.width - DISPLAY_AREA.width );
				rect.height = Math.abs( _container.height - DISPLAY_AREA.height );
				_container.startDrag( false, rect );
			}
			else if ( event.type == MouseEvent.MOUSE_UP )
			{
				appStage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler );
				_container.stopDrag();
			}
		}
		
		protected function onAgainHandler(event:MouseEvent):void
		{
			Global.eventDispatcher.dispatchEvent(new AppEvent( AppEvent.SELECTED_AGAIN ));
		}
		
		protected function onCommitHandler(event:MouseEvent):void
		{
			Global.eventDispatcher.dispatchEvent( new AppEvent( AppEvent.CONFIRM_COMMIT ));
		}
		
		protected function enterFrameHandler(event:Event):void
		{
			if ( _loaderSprite )
			{
				_loaderSprite.x = -_loaderSprite.width >> 1;
				_loaderSprite.y = -_loaderSprite.height >> 1;
			}
		}
		
		protected function onZoonInHandler(event:MouseEvent):void
		{
			_container.scaleX = _endScale;
			_container.scaleY = _endScale;
			_endScale += 0.1;
			_endScale = Math.min( 2, _endScale );
			TweenMax.killTweensOf( _container );
			TweenMax.to( _container, 0.2, {scaleX: _endScale, scaleY: _endScale });
		}
		
		protected function onZoonOutHandler(event:MouseEvent):void
		{
			_container.scaleX = _endScale;
			_container.scaleY = _endScale;
			_endScale -= 0.1;
			_endScale = Math.max( 0.3, _endScale );
			TweenMax.killTweensOf( _container );
			TweenMax.to( _container, 0.2, {scaleX: _endScale, scaleY: _endScale });
		}
		
		protected function onRotateLeftHandler(event:MouseEvent):void
		{
			_container.rotation = _endRotation;
			_endRotation -= 90;
			_endRotation = ( _endRotation % 360 );
			TweenMax.killTweensOf( _container );
			TweenMax.to( _container, 0.4, {rotation: _endRotation });
		}
		
		protected function onRotateRightHandler(event:MouseEvent):void
		{
			_container.rotation = _endRotation;
			_endRotation += 90;
			_endRotation = ( _endRotation % 360 );
			TweenMax.killTweensOf( _container );
			TweenMax.to( _container, 0.4, {rotation: _endRotation });
		}
		
		
		
		public function get bitmapData():BitmapData
		{
			var bitmapData:BitmapData = new BitmapData( _area.width, _area.height, true, 0 );
			bitmapData.draw( _area );
			return bitmapData;
		}
		
		
	}
}