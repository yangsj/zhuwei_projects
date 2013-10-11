package victor.comp
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import victor.AppMouse;
	import victor.DisplayUtil;
	import victor.Global;
	import victor.LoadImage;
	import victor.SaveImage;
	
	public class MediaComp extends Sprite
	{
		private const camera:Camera = Camera.getCamera();
		private const DISPLAY_AREA:Rectangle = new Rectangle( 0, 0, 440, 284 );
		
		private var skin:ui_Skin_OpenCamera;
		
		private var video:Video;
		private var _newPic:Sprite;
		private var _oldPic:Sprite;
		private var _btnPhoto:SimpleButton;
		private var _btnZoonIn:SimpleButton;
		private var _btnZoonOut:SimpleButton;
		private var _btnRotateLeft:SimpleButton;
		private var _btnRotateRight:SimpleButton;
		private var _btnAgainPhoto:SimpleButton;
		private var _btnAgainLoad:SimpleButton;
		private var _area:Sprite;
		private var _tempSprite:Sprite;
		private var _txtYear:TextField;
		private var _bitmapTarget:MovieClip;
		
		private var _btnBack:SimpleButton;
		private var _btnCompare:SimpleButton;
		
		
		private var _endRotation:Number = 0;
		private var _endScale:Number = 1;
		
		private var openLocal:Function;
		private var compareFunc:Function;
		
		public function MediaComp( openLocal:Function, compareFunc:Function )
		{
			x = 100;
			y = 100;
			
			this.openLocal = openLocal;
			this.compareFunc = compareFunc;
			
			skin = new ui_Skin_OpenCamera();
			addChild( skin );
			
			_oldPic = skin.oldPic;
			_bitmapTarget = skin.container;
			_area = _bitmapTarget.area;
			_area.scrollRect = DISPLAY_AREA;
			_newPic = _area.getChildByName("pic") as Sprite;
			_btnZoonIn = skin.btnZoonIn;
			_btnZoonOut = skin.btnZoonOut;
			_btnRotateLeft = skin.btnRotateLeft;
			_btnRotateRight = skin.btnRotateRight;
			_btnCompare = skin.btnCompare;
			_txtYear = skin.txt;
			
			DisplayUtil.removeAll( _newPic );
			_tempSprite = new Sprite();
			_newPic.addChild(_tempSprite);
			
//			_btnPhoto = skin.btnPhoto;
//			_btnAgainPhoto = skin.btnAgainPhoto;
//			_btnAgainLoad = skin.btnAgainLoad;
//			_btnPhoto.addEventListener(MouseEvent.CLICK, onClickHandler );
//			_btnAgainLoad.addEventListener(MouseEvent.CLICK, btnAgainLoadHandler );
//			_btnAgainPhoto.addEventListener(MouseEvent.CLICK, btnAgainPhotoHandler );
			
			_btnBack = skin.btnBack;
			_btnBack.addEventListener(MouseEvent.CLICK, onBackHandler );
			
			_btnZoonIn.addEventListener(MouseEvent.CLICK, onZoonInHandler );
			_btnZoonOut.addEventListener(MouseEvent.CLICK, onZoonOutHandler );
			_btnRotateLeft.addEventListener(MouseEvent.CLICK, onRotateLeftHandler );
			_btnRotateRight.addEventListener(MouseEvent.CLICK, onRotateRightHandler );
			_newPic.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler );
			_btnCompare.addEventListener(MouseEvent.CLICK, onCompareHandler );
			
			addEventListener( Event.ENTER_FRAME, enterFrameHandler );
		}
		
		protected function onBackHandler(event:MouseEvent):void
		{
			openLocal();
		}
		
		protected function onCompareHandler(event:MouseEvent):void
		{
			_btnCompare.mouseEnabled = false;
			AppMouse.show();
			new SaveImage( imgByte, callBack );
			function callBack( picUrl:String ):void
			{
				_btnCompare.mouseEnabled = true;
				AppMouse.hide();
				Global.commitSecondPicUrl = picUrl;
				if ( compareFunc )
					compareFunc();
			}
		}
		
		protected function mouseHandler(event:MouseEvent):void
		{
			if ( event.type == MouseEvent.MOUSE_DOWN )
			{
				appStage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler );
				var rect:Rectangle = new Rectangle();
				if (DISPLAY_AREA.width > _newPic.width )
				{
					rect.x = ( _newPic.width >> 1) + DISPLAY_AREA.x;
				}
				else
				{
					rect.x = (DISPLAY_AREA.width - ( _newPic.width >> 1)) + DISPLAY_AREA.x;
				}
				if ( DISPLAY_AREA.height > _newPic.height )
				{
					rect.y = (_newPic.height >> 1 ) + DISPLAY_AREA.y;
				}
				else
				{
					rect.y = (DISPLAY_AREA.height - (_newPic.height >> 1 )) + DISPLAY_AREA.y;
				}
				rect.width = Math.abs( _newPic.width - DISPLAY_AREA.width );
				rect.height = Math.abs( _newPic.height - DISPLAY_AREA.height );
				_newPic.startDrag( false, rect );
			}
			else if ( event.type == MouseEvent.MOUSE_UP )
			{
				appStage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler );
				_newPic.stopDrag();
			}
		}
		
		protected function enterFrameHandler(event:Event):void
		{
			if ( _tempSprite )
			{
				_tempSprite.x = -_tempSprite.width >> 1;
				_tempSprite.y = -_tempSprite.height >> 1;
			}
		}
		
		protected function btnAgainPhotoHandler(event:MouseEvent):void
		{
			startMedia();
		}
		
		protected function btnAgainLoadHandler(event:MouseEvent):void
		{
			closeCamera();
			openLocal();
		}
		
		protected function onClickHandler(event:MouseEvent):void
		{
			setNewBitmap(new Bitmap( bitmapData, "auto", true ) );
		}
		
		public function setYearInfo( year:int ):void
		{
			if ( _txtYear )
			{
				_txtYear.embedFonts = true;
				_txtYear.text = year + "年的我们";
			}
		}
		
		public function loadOldImage( url:String ):void
		{
			new LoadImage( url, setOldBitmap );
		}
		
		public function loadNewImage( url:String ):void
		{
			new LoadImage( url, setNewBitmap );
		}
		
		public function setOldBitmap( bitmap:DisplayObject ):void
		{
			DisplayUtil.removeAll( _oldPic );
			_oldPic.addChild( bitmap );
		}
		
		public function setNewBitmap( bitmap:DisplayObject ):void
		{
			DisplayUtil.removeAll( _tempSprite );
			_tempSprite.addChild( bitmap );
			
			_btnZoonIn.visible = true;
			_btnZoonOut.visible = true;
			_btnRotateLeft.visible = true;
			_btnRotateRight.visible = true;
			_btnCompare.visible = true;
			
//			_btnPhoto.visible = false;
//			_btnAgainLoad.visible = false;
//			_btnAgainPhoto.visible = true;
			
			_area.mouseChildren = true;
			_newPic.buttonMode = true;
			
			closeCamera();
			huanyuan();
			
			
		}
		
		public function startMedia():void
		{
			_btnZoonIn.visible = false;
			_btnZoonOut.visible = false;
			_btnRotateLeft.visible = false;
			_btnRotateRight.visible = false;
			_btnCompare.visible = false;
			
//			_btnPhoto.visible = true;
//			_area.mouseChildren = false;
//			_newPic.buttonMode = false;
			
			huanyuan();
			
			if (camera != null)
			{
				openCamera();
			}
			else 
			{
				trace("You need a camera.");
			}
		}
		
		private function openCamera():void
		{
			var scale:Number = 3.2;
			camera.addEventListener(ActivityEvent.ACTIVITY, activityHandler);
			if ( video == null )
			{
				camera.setMode( camera.width * scale, camera.height * scale, 60 );
				video ||= new Video( camera.width, camera.height );
			}
			video.attachCamera(camera);
			DisplayUtil.removeAll( _tempSprite );
			_tempSprite.scaleX = _tempSprite.scaleY = 1;
			_tempSprite.addChild(video);
		}
		
		private function closeCamera():void
		{
			
			if ( video )
			{
				video.attachCamera(null);
				video.clear();
			}
		}
		
		private function huanyuan():void
		{
			_endScale = 1;
			_endRotation = 0;
			_newPic.scaleX = 1;
			_newPic.scaleY = 1;
			_newPic.rotation = 0;
			_newPic.x = DISPLAY_AREA.x + (DISPLAY_AREA.width >> 1);
			_newPic.y = DISPLAY_AREA.y + (DISPLAY_AREA.height>> 1);
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
		
		private function activityHandler(event:ActivityEvent):void 
		{
			trace("activityHandler: " + event);
		}
		
		protected function onZoonInHandler(event:MouseEvent):void
		{
			_newPic.scaleX = _endScale;
			_newPic.scaleY = _endScale;
			_endScale += 0.1;
			_endScale = Math.min( 2, _endScale );
			TweenMax.killTweensOf( _newPic );
			TweenMax.to( _newPic, 0.2, {scaleX: _endScale, scaleY: _endScale });
		}
		
		protected function onZoonOutHandler(event:MouseEvent):void
		{
			_newPic.scaleX = _endScale;
			_newPic.scaleY = _endScale;
			_endScale -= 0.1;
			_endScale = Math.max( 0.3, _endScale );
			TweenMax.killTweensOf( _newPic );
			TweenMax.to( _newPic, 0.2, {scaleX: _endScale, scaleY: _endScale });
		}
		
		protected function onRotateLeftHandler(event:MouseEvent):void
		{
			_newPic.rotation = _endRotation;
			_endRotation -= 90;
			_endRotation = ( _endRotation % 360 );
			TweenMax.killTweensOf( _newPic );
			TweenMax.to( _newPic, 0.4, {rotation: _endRotation });
		}
		
		protected function onRotateRightHandler(event:MouseEvent):void
		{
			_newPic.rotation = _endRotation;
			_endRotation += 90;
			_endRotation = ( _endRotation % 360 );
			TweenMax.killTweensOf( _newPic );
			TweenMax.to( _newPic, 0.4, {rotation: _endRotation });
		}
		
	}
}