package victor
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
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
		
		private var _loading:LoadingEffect;
		
		public function LoadImage( url:String, loadCompleted, loadingPos:Point )
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
				loading.show( loadingPos );
				
				this.loadCompleted = loadCompleted;
				
				urlLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, loaderCompleteHandler2 );
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler );
				urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler );
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				urlLoader.load(new URLRequest( url ));
			}
		}
		
		protected function loaderCompleteHandler2(event:Event):void
		{
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler );
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler );
			urlLoader.removeEventListener(Event.COMPLETE, loaderCompleteHandler2 );
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageDataComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler );
			loader.loadBytes(urlLoader.data as ByteArray, new LoaderContext(false, ApplicationDomain.currentDomain));

		}
		
		protected function imageDataComplete(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageDataComplete);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler );
			dictData[ url ] = loader.content;
			if ( loadCompleted != null )
				loadCompleted( loader.content );
			
			loading.hide();
			
			loader = null;
			urlLoader = null;
			loadCompleted = null;
		}
		
		protected function errorHandler( event:* ):void
		{
			if ( urlLoader )
			{
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler );
				urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler );
				urlLoader.removeEventListener(Event.COMPLETE, loaderCompleteHandler2 );				
			}
			if ( loader )
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageDataComplete);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler );
			}
			ExternalManager.jsAlert( "图片加载错误" );
		}
		
		private function get loading():LoadingEffect
		{
			return _loading ||= new LoadingEffect();
		}
		
	}
}