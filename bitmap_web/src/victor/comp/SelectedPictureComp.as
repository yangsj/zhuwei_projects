package victor.comp
{
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import victor.Global;
	import victor.event.AppEvent;
	
	public class SelectedPictureComp extends Sprite
	{
		
		private var _skin:ui_Skin_SelectedBitmapComp;
		private var _btnSlected:SimpleButton;
		private var _fileReference:FileReference;
		
		public function SelectedPictureComp()
		{
			x = 359;
			y = 145;
			
			_skin = new ui_Skin_SelectedBitmapComp();
			addChild( _skin );
			
			_btnSlected = _skin.btnSelectedPic;
			
			_btnSlected.addEventListener(MouseEvent.CLICK, onClickhandler );
		}
		
		public function selectedImage():void
		{
			_fileReference = new FileReference();
			_fileReference.addEventListener(Event.COMPLETE, completeHandler );
			_fileReference.addEventListener(Event.SELECT, selectedHandler );
			_fileReference.addEventListener(Event.CANCEL, cancelHandler );
			_fileReference.browse([getImageTypeFilter]);
		}
		
		protected function cancelHandler(event:Event):void
		{
			_fileReference.removeEventListener(Event.COMPLETE, completeHandler );
			_fileReference.removeEventListener(Event.SELECT, selectedHandler );
			_fileReference.removeEventListener(Event.CANCEL, cancelHandler );
		}
		
		protected function onClickhandler(event:MouseEvent):void
		{
			selectedImage();
		}
		
		protected function completeHandler(event:Event):void
		{
			cancelHandler( null );
			
			var loader:Loader = new Loader();
			loader.loadBytes(_fileReference.data);
			Global.eventDispatcher.dispatchEvent( new AppEvent( AppEvent.SELECTED_LOAD_COMPLETE, loader ));
		}
		
		protected function selectedHandler(event:Event):void
		{
			_fileReference.load();
		}
		
		private function get getImageTypeFilter():FileFilter {
			return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
		}
	}
}