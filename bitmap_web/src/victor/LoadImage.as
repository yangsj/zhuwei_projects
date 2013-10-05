package victor
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;

	public class LoadImage
	{
		private static const dictData:Dictionary = new Dictionary();
		
		private var loader:Loader;
		private var loadCompleted:Function;
		
		public function LoadImage( url:String, loadCompleted )
		{
			if ( dictData[ url ] )
			{
				loadCompleted( dictData[ url ] );
			}
			else
			{
				this.loadCompleted = loadCompleted;
				
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler );
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler );
				loader.load( new URLRequest( url ), new LoaderContext(true));
			}
		}
		
		private function removeListener():void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler );
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler );
		}
		
		protected function loaderCompleteHandler(event:Event):void
		{
			removeListener();
			
			var bitmap:Bitmap = loader.content as Bitmap;
			dictData[ loader.contentLoaderInfo.url ] = bitmap;
			if ( loadCompleted )
				loadCompleted( bitmap );
		}	
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			removeListener();
		}	
		
		
	}
}