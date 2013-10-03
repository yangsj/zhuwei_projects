package victor
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import victor.comp.CompleteEditComp;
	import victor.comp.EditAreaComp;
	import victor.comp.MediaComp;
	import victor.comp.SelectedPictureComp;
	import victor.comp.UploadNowPicComp;
	import victor.event.AppEvent;
	
	public class Main extends Sprite
	{
		private var _imgBg:Sprite;
		private var _container:Sprite;
		
		private var _selectdComp:SelectedPictureComp;
		private var _editAreaComp:EditAreaComp;
		private var _mediaComp:MediaComp;
		private var _completeEditComp:CompleteEditComp;
		private var _uploadNowPicComp:UploadNowPicComp;
		
		public function Main()
		{
			_imgBg = new ui_Skin_Background();
			addChild( _imgBg );
			
			_container = new Sprite();
			addChild( _container );
			
			_selectdComp = new SelectedPictureComp();
			_editAreaComp = new EditAreaComp();
			_mediaComp = new MediaComp( _selectdComp.selectedImage );
			_completeEditComp = new CompleteEditComp(completeEditCompFunc1, completeEditCompFunc2);
			_uploadNowPicComp = new UploadNowPicComp( oepnCamera, _selectdComp.selectedImage );
			
			_container.addChild( _selectdComp );
			
			addlistener();
		}
		
		private function completeEditCompFunc1():void
		{
			
		}
		
		private function completeEditCompFunc2():void
		{
			_container.removeChildren();
			_container.addChild( _uploadNowPicComp );
			_uploadNowPicComp.setBitmap( new Bitmap(_editAreaComp.bitmapData, "auto", true) );
		}
		
		private function oepnCamera():void
		{
			_container.removeChildren();
			_container.addChild( _mediaComp );
			_mediaComp.setOldBitmap( new Bitmap(_editAreaComp.bitmapData, "auto", true) );
			_mediaComp.startMedia();
		}
		
		private function addlistener():void
		{
			Global.eventDispatcher.addEventListener(AppEvent.SELECTED_LOAD_COMPLETE, selectedLoadCompleteHandler );
			Global.eventDispatcher.addEventListener(AppEvent.SELECTED_AGAIN, selectedAgainHandler );
			Global.eventDispatcher.addEventListener(AppEvent.CONFIRM_COMMIT, confirmCommitHandler );
			Global.eventDispatcher.addEventListener(AppEvent.TAKE_A_PHOTO, takeAPhotoHandler );
		}
		
		protected function takeAPhotoHandler(event:Event):void
		{
			_container.removeChildren();
			_container.addChild(_editAreaComp);
			_editAreaComp.setLoader( new Bitmap(_mediaComp.bitmapData, "auto", true ));
		}
		
		protected function confirmCommitHandler(event:Event):void
		{
			_container.removeChildren();
			_container.addChild(_completeEditComp);
			_completeEditComp.setBitmap( new Bitmap(_editAreaComp.bitmapData, "auto", true) );
		}
		
		protected function selectedAgainHandler(event:Event):void
		{
			_selectdComp.selectedImage();
		}
		
		protected function selectedLoadCompleteHandler( event:AppEvent ):void
		{
			var loader:Loader = event.data as Loader;
			if ( _uploadNowPicComp.parent )
			{
				_container.removeChildren();
				_container.addChild(_mediaComp);
				_mediaComp.setOldBitmap(new Bitmap(_editAreaComp.bitmapData, "auto", true) );
				_mediaComp.setNewLoader( loader );
			}
			else if ( _mediaComp.parent )
			{
				_mediaComp.setNewLoader( loader );
			}
			else
			{
				_container.removeChildren();
				_container.addChild(_editAreaComp);
				_editAreaComp.setLoader( loader );
			}
		}
	}
}