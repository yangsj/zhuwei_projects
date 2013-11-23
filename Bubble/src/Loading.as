package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	
	[SWF(width="1280", height="627", backgroundColor="0x000000", frameRate="30" )]
	/**
	 * ……
	 * @author 	yangsj 
	 * 			2013-11-20
	 */
	public class Loading extends Sprite
	{
		/*============================================================================*/
		/* private variables                                                          */
		/*============================================================================*/
		
		public var mcLoading:MovieClip;
		
		private var txtPercent:TextField;
		private var loader:Loader;
		
		private var version:String = "?t=9";
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		public function Loading()
		{
			if ( stage )
				initApp( null );
			else addEventListener(Event.ADDED_TO_STAGE, initApp );
		}
		
		protected function initApp(event:Event):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, initApp );
			txtPercent = mcLoading.mc.mc.loadingTxt;
			
			var url:String = getBaseUrl( stage.loaderInfo.url ) + "AppMain.swf" + version;
				
			addListener();
			loader.load( new URLRequest( url ));
			trace( mcLoading, txtPercent );
		}
		
		private function addListener():void
		{
			loader ||= new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler );
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler );
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler );
		}
		
		private function removeListener():void
		{
			if ( loader )
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadCompleteHandler );
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler );
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandler );
			}
			loader = null;
		}
		
		public function getBaseUrl(preurl : String) : String {
			var swfUrl : String;
			preurl = preurl.replace(/\\/g, "/");
			var lastslash : int = preurl.lastIndexOf("/");
			swfUrl = preurl.substring(0, lastslash + 1);
			return swfUrl;
		}
		
		protected function loadCompleteHandler(event:Event):void
		{
			trace( "loadCompleteHandler" );
			
			addChild( loader );
			
			if ( mcLoading.parent )
				mcLoading.parent.removeChild( mcLoading );
			
			removeListener();
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			trace( "ioError:" + event.text );
			
			txtPercent.text = "ioError";
			
			removeListener();
		}
		
		protected function loadProgressHandler(event:ProgressEvent):void
		{
			var perent:int = int((event.bytesLoaded / event.bytesTotal) * 100);
			txtPercent.text = perent + "%";
			trace( perent );
		}
		
	}
}