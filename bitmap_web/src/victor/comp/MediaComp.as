package victor.comp
{
	import com.adobe.images.JPGEncoder;
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.ByteArray;
	
	import victor.DisplayUtil;
	import victor.Global;
	import victor.LoadImage;
	import victor.SaveImage;
	
	public class MediaComp extends Sprite
	{
		private const camera:Camera = Camera.getCamera();
		private const DISPLAY_AREA:Rectangle = new Rectangle( 0, 0, 465, 345 );
		
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
			_area = skin.area;
			_newPic = _area.getChildByName("pic") as Sprite;
			_btnPhoto = skin.btnPhoto;
			_btnZoonIn = skin.btnZoonIn;
			_btnZoonOut = skin.btnZoonOut;
			_btnRotateLeft = skin.btnRotateLeft;
			_btnRotateRight = skin.btnRotateRight;
			_btnAgainPhoto = skin.btnAgainPhoto;
			_btnAgainLoad = skin.btnAgainLoad;
			_btnCompare = skin.btnCompare;
			
			_newPic.buttonMode = true;
			
			DisplayUtil.removeAll( _newPic );
			_tempSprite = new Sprite();
			_newPic.addChild(_tempSprite);
			
			_btnPhoto.addEventListener(MouseEvent.CLICK, onClickHandler );
			_btnAgainLoad.addEventListener(MouseEvent.CLICK, btnAgainLoadHandler );
			_btnAgainPhoto.addEventListener(MouseEvent.CLICK, btnAgainPhotoHandler );
			
			_btnZoonIn.addEventListener(MouseEvent.CLICK, onZoonInHandler );
			_btnZoonOut.addEventListener(MouseEvent.CLICK, onZoonOutHandler );
			_btnRotateLeft.addEventListener(MouseEvent.CLICK, onRotateLeftHandler );
			_btnRotateRight.addEventListener(MouseEvent.CLICK, onRotateRightHandler );
			_newPic.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler );
			_btnCompare.addEventListener(MouseEvent.CLICK, onCompareHandler );
			
			addEventListener( Event.ENTER_FRAME, enterFrameHandler );
		}
		
		protected function onCompareHandler(event:MouseEvent):void
		{
			new SaveImage( imgByte, callBack );
			function callBack( picUrl:String ):void
			{
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
		
		public function loadOldImage( url:String ):void
		{
			new LoadImage( url, setOldBitmap );
		}
		
		public function setOldBitmap( bitmap:Bitmap ):void
		{
			DisplayUtil.removeAll( _oldPic );
			bitmap.width = bitmap.width > DISPLAY_AREA.width ? DISPLAY_AREA.width : bitmap.width;
			bitmap.height = bitmap.height > DISPLAY_AREA.height ? DISPLAY_AREA.height : bitmap.height;
			_oldPic.addChild( bitmap );
		}
		
		public function setNewLoader( loader:Loader ):void
		{
			DisplayUtil.removeAll( _tempSprite );
			_tempSprite.addChild( loader );
			
			_btnZoonIn.visible = true;
			_btnZoonOut.visible = true;
			_btnRotateLeft.visible = true;
			_btnRotateRight.visible = true;
			_btnAgainPhoto.visible = true;
			_btnAgainLoad.visible = true;
			_btnCompare.visible = true;
			
			_btnPhoto.visible = false;
			
			_btnAgainLoad.visible = true;
			_btnAgainPhoto.visible = false;
			
			closeCamera();
			huanyuan();
		}
		
		public function setNewBitmap( bitmap:Bitmap ):void
		{
			DisplayUtil.removeAll( _tempSprite );
			_tempSprite.addChild( bitmap );
			bitmap.scaleY = bitmap.scaleX = 1 / _area.scaleX;
			
			_btnZoonIn.visible = true;
			_btnZoonOut.visible = true;
			_btnRotateLeft.visible = true;
			_btnRotateRight.visible = true;
			_btnAgainPhoto.visible = true;
			_btnAgainLoad.visible = true;
			_btnCompare.visible = true;
			
			_btnPhoto.visible = false;
			
			_btnAgainLoad.visible = false;
			_btnAgainPhoto.visible = true;
			
			closeCamera();
			huanyuan();
		}
		
		public function startMedia():void
		{
			_btnZoonIn.visible = false;
			_btnZoonOut.visible = false;
			_btnRotateLeft.visible = false;
			_btnRotateRight.visible = false;
			_btnAgainPhoto.visible = false;
			_btnAgainLoad.visible = false;
			_btnCompare.visible = false;
			
			_btnPhoto.visible = true;
			
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
			camera.addEventListener(ActivityEvent.ACTIVITY, activityHandler);
			video ||= new Video( DISPLAY_AREA.width, DISPLAY_AREA.height );
			video.attachCamera(camera);
			DisplayUtil.removeAll( _tempSprite );
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
		
		private function get imgByte():ByteArray
		{
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