package victor
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class LoadImage
	{
		private static const dictData:Dictionary = new Dictionary();
		
		private var loader:Loader;
		private var loadCompleted:Function;
		
		private var urlLoader:URLLoader;
		private var url:String = "";
		
		public function LoadImage( url:String, loadCompleted )
		{
			this.url = url;
//			Security.allowDomain(url);
//			Security.loadPolicyFile(url);
			trace( url );
			if ( dictData[ url ] )
			{
				loadCompleted( dictData[ url ] );
			}
			else
			{
				this.loadCompleted = loadCompleted;
				
				urlLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, loaderCompleteHandler2 );
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				urlLoader.load(new URLRequest( url ));
			}
		}
		
		protected function loaderCompleteHandler2(event:Event):void
		{
			urlLoader.removeEventListener(Event.COMPLETE, loaderCompleteHandler2 );
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageDataComplete);
			loader.loadBytes(urlLoader.data as ByteArray, new LoaderContext(false, ApplicationDomain.currentDomain));

		}
		
		protected function imageDataComplete(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageDataComplete);
//			Security.allowDomain(loader.contentLoaderInfo.url);
			dictData[ url ] = loader.content;
			if ( loadCompleted )
				loadCompleted( loader.content );
			
			loader = null;
			urlLoader = null;
			loadCompleted = null;
		}
		
	}
}