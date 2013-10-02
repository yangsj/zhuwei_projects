package victor.comp
{
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
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
		
		protected function onClickhandler(event:MouseEvent):void
		{
			_fileReference = new FileReference();
			_fileReference.addEventListener(Event.COMPLETE, completeHandler );
			_fileReference.addEventListener(Event.SELECT, selectedHandler );
			_fileReference.browse([getImageTypeFilter]);
		}
		
		protected function completeHandler(event:Event):void
		{
			var loader:Loader = new Loader();
			loader.loadBytes(event.target.data);
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