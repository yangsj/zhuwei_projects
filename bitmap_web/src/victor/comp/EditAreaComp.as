package victor.comp
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import victor.AppMouse;
	import victor.DisplayUtil;
	import victor.Global;
	import victor.LoadImage;
	import victor.SaveImage;
	import victor.event.AppEvent;
	
	public class EditAreaComp extends Sprite
	{
		private var _skin:ui_Skin_EditPictureArea;
		private var _mcYear:MovieClip;
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
		private var _bitmapTarget:MovieClip;
		
		private const DISPLAY_AREA:Rectangle = new Rectangle( 0, 0, 440, 284 );
		private const MIN_YEAR:int = 1960;
		private const MAX_YEAR:int = 2013;
		private const DIFF_YEAR:int = MAX_YEAR - MIN_YEAR;
		private const DEFAULT_YEAR:int = 2003;
		private const AREA_SCROLL:Rectangle = new Rectangle(346, 452, 102, 0);
		
		private var currentYear:int = 2010;
		
		private var lastYearBitmap:Bitmap;
		private var lastYear:int = 0;
		private var tempYearCon:Sprite;
		private var downMouseX:Number;
		
		private var desContainer:Sprite;
		private var wordsList:WordsList;
		private var _isLocal:Boolean = false;
		
		public function EditAreaComp()
		{
			x = 325;
			y = 100;
			
			_skin = new ui_Skin_EditPictureArea();
			addChild( _skin );
			
			_bitmapTarget = _skin.container;
			_mcYear = _skin.mcYear;
			_btnZoonIn = _skin.btnZoonIn;
			_btnZoonOut = _skin.btnZoonOut;
			_btnRotateLeft = _skin.btnRotateLeft;
			_btnRotateRight = _skin.btnRotateRight;
			_btnAgain = _skin.btnAgain;
			_btnCommit = _skin.btnCommit;
			_area = _bitmapTarget.area;
			_area.scrollRect = DISPLAY_AREA;
			_container = _area.getChildByName("pic") as Sprite;
			_btnPrev = _mcYear.btnPrev;
			_btnNext = _mcYear.btnNext;
			_txtYear = _mcYear.txtYear;
			_txtYear.embedFonts = true;
			
			tempYearCon = new Sprite();
			tempYearCon.x = _txtYear.x;
			tempYearCon.y = _txtYear.y + 3;
			tempYearCon.scrollRect = new Rectangle(0, 0, _txtYear.width, _txtYear.height );
			tempYearCon.buttonMode = true;
			tempYearCon.mouseChildren = false;
			
			_mcYear.mouseChildren = false;
			_mcYear.buttonMode = true;
			
			_container.buttonMode = true;
			_txtYear.mouseEnabled = false;
			
			setYear();
			
			// 默认年份
			_mcYear.x = Math.ceil(AREA_SCROLL.x + AREA_SCROLL.width * ((DEFAULT_YEAR - MIN_YEAR)/DIFF_YEAR));
			
			addListenr();
		}
		
		public function loadImageForSNS(url:String):void
		{
			var global:Point = _area.localToGlobal( Global.loadingLocalPos1 );
			new LoadImage( url, setLoader, global );
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
			
			tempYearCon.addEventListener(MouseEvent.MOUSE_DOWN, yearConMouseDownHandler );
			
			_mcYear.addEventListener(MouseEvent.MOUSE_DOWN, mcYearMouseHandler );
			
			Global.eventDispatcher.addEventListener( AppEvent.SELCTED_DES, selectedDesHandler );
			
			addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			
			wordsList = new WordsList();
			addChild( wordsList );
			
			desContainer = new Sprite();
			desContainer.x = wordsList.x;
			desContainer.y = wordsList.y;
			_bitmapTarget.addChild( desContainer );
			
			mcYearMouseHandler( new MouseEvent(MouseEvent.MOUSE_MOVE));
		}
		
		protected function selectedDesHandler( event:AppEvent ):void
		{
			if( stage )
			{
				DisplayUtil.removeAll( desContainer );
				var bitmap:Bitmap = new Bitmap( event.data as BitmapData, "auto", true );
				bitmap.y = 3;
				desContainer.addChild( bitmap );
			}
		}
		
		protected function mcYearMouseHandler(event:MouseEvent):void
		{
			var type:String = event.type;
			if ( type == MouseEvent.MOUSE_DOWN )
			{
				appStage.addEventListener(MouseEvent.MOUSE_UP, mcYearMouseHandler );
				appStage.addEventListener(MouseEvent.MOUSE_MOVE, mcYearMouseHandler );
				_mcYear.startDrag(false, AREA_SCROLL);
			}
			else if ( type == MouseEvent.MOUSE_UP )
			{
				appStage.removeEventListener(MouseEvent.MOUSE_UP, yearConMouseDownHandler );
				appStage.removeEventListener(MouseEvent.MOUSE_MOVE, mcYearMouseHandler );
				_mcYear.stopDrag();
			}
			else if ( type == MouseEvent.MOUSE_MOVE )
			{
				var year:int = int((( _mcYear.x - AREA_SCROLL.x ) / AREA_SCROLL.width) * DIFF_YEAR);
				Global.currentYear = currentYear = MIN_YEAR + year;
				_txtYear.htmlText = currentYear + "<font size=\"12\">年</font>";
				_txtYear.embedFonts = true;
				wordsList.setYear( currentYear );
			}
		}
		
		protected function yearConMouseDownHandler(event:MouseEvent):void
		{
			var type:String = event.type;
			if ( type == MouseEvent.MOUSE_DOWN )
			{
				appStage.addEventListener(MouseEvent.MOUSE_UP, yearConMouseDownHandler );
				downMouseX = appStage.mouseX;
			}
			else if ( type == MouseEvent.MOUSE_UP )
			{
				var dist:Number = appStage.mouseX - downMouseX;
				if ( dist > 0 )
					btnPrevHandler( null );
				else if ( dist < 0 )
					btnNextHandler( null );
				appStage.removeEventListener(MouseEvent.MOUSE_UP, yearConMouseDownHandler );
			}
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
			Global.currentYear =currentYear;
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
		
		protected function onCommitHandler(event:MouseEvent = null):void
		{
			mouseChildren = false;
			AppMouse.show();
			new SaveImage( imgByte, loadComplete );
		}
		
		protected function loadComplete( picUrl:String ):void
		{
			AppMouse.hide();
			mouseChildren = true;
			
			Global.commitFirstPicUrl = picUrl;
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
		
		private function get bitmapData():BitmapData
		{
			var bitmapdata:BitmapData = new BitmapData(_bitmapTarget.width, _bitmapTarget.height, true, 0 );
			bitmapdata.draw( _bitmapTarget );
			return bitmapdata;
		}
		
		private function get imgByte():ByteArray
		{
			return PNGEncoder.encode( bitmapData );
			var jpg:JPGEncoder = new JPGEncoder(80);
			return jpg.encode( bitmapData );
		}

		public function get isLocal():Boolean
		{
			return _isLocal;
		}

		public function set isLocal(value:Boolean):void
		{
			_isLocal = value;
		}

		
	}
}