package victor.comp
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import victor.DisplayUtil;
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
		private var _btnPrev:SimpleButton;
		private var _btnNext:SimpleButton;
		private var _txtYear:TextField;
		private var _area:Sprite;
		private var _container:Sprite;
		private var _loaderSprite:Sprite;
		private var _endRotation:Number = 0;
		private var _endScale:Number = 1;
		
		private const DISPLAY_AREA:Rectangle = new Rectangle( 0, 0, 500, 375 );
		private const MIN_YEAR:int = 1960;
		private const MAX_YEAR:int = 2013;
		
		public var currentYear:int = 2010;
		
		private var lastYearBitmap:Bitmap;
		private var lastYear:int = 0;
		private var tempYearCon:Sprite;
		
		public function EditAreaComp()
		{
			x = 325;
			y = 100;
			
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
			_btnPrev = _skin.btnPrev;
			_btnNext = _skin.btnNext;
			_txtYear = _skin.txtYear;
			
			tempYearCon = new Sprite();
			tempYearCon.x = _txtYear.x;
			tempYearCon.y = _txtYear.y + 3;
			_txtYear.parent.addChild( tempYearCon );
			tempYearCon.scrollRect = new Rectangle(0, 0, _txtYear.width, _txtYear.height );
			
			_container.buttonMode = true;
			_txtYear.mouseEnabled = false;
			
			DisplayUtil.removeSelf( _txtYear );
			
			setYear();
			
			addListenr();
		}
		
		public function setLoader( display:DisplayObject ):void
		{
			DisplayUtil.removeAll( _loaderSprite );
			_loaderSprite ||= new Sprite();
			_loaderSprite.addChild( display );
			
			_endScale = 1;
			_endRotation = 0;
			_container.scaleX = 1;
			_container.scaleY = 1;
			_container.rotation = 0;
			_container.x = DISPLAY_AREA.x + (DISPLAY_AREA.width >> 1);
			_container.y = DISPLAY_AREA.y + (DISPLAY_AREA.height>> 1);
			
			_container.graphics.clear();
			DisplayUtil.removeAll( _container );
			
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
			_btnPrev.addEventListener(MouseEvent.CLICK, btnPrevHandler );
			_btnNext.addEventListener(MouseEvent.CLICK, btnNextHandler );
		}
		
		protected function btnPrevHandler(event:MouseEvent):void
		{
			currentYear--;
			currentYear = Math.max( MIN_YEAR, currentYear );
			setYear();
		}
		
		protected function btnNextHandler(event:MouseEvent):void
		{
			currentYear++;
			currentYear = Math.min( MAX_YEAR, currentYear );
			setYear();
		}
		
		private function setYear():void
		{
			_txtYear.text = currentYear + "年";
			if ( lastYear == 0 || lastYear != currentYear )
			{
				var bitData:BitmapData = new BitmapData(_txtYear.width, _txtYear.height, true, 0 );
				bitData.draw( _txtYear );
				var bitmap:Bitmap = new Bitmap( bitData, "auto", true );
				tempYearCon.addChild( bitmap );
				var endx:Number = 0;
				if ( lastYear != 0 )
				{
					if ( lastYear > currentYear )
					{
						bitmap.x = -bitmap.width;
						if ( lastYearBitmap )
							endx = bitmap.width;
					}
					else 
					{
						bitmap.x = bitmap.width;
						if ( lastYearBitmap )
							endx = -bitmap.width;
					}
					TweenMax.to( bitmap, 0.3, {x:0, ease:Linear.easeNone });
					if ( lastYearBitmap )
						TweenMax.to( lastYearBitmap, 0.3, {x:endx, ease:Linear.easeNone, onComplete:DisplayUtil.removeSelf, onCompleteParams:[ lastYearBitmap ] });
				}
				lastYearBitmap = bitmap;
				lastYear = currentYear;
			}
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
			var bitmapdata:BitmapData = new BitmapData(DISPLAY_AREA.width, DISPLAY_AREA.height, true, 0 );
			try
			{
				bitmapdata.draw( _area );
			}
			catch( e: * )
			{
			}
			return bitmapdata;
		}
		
		
	}
}