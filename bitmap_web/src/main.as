package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	[SWF(width="1200", height="700", frameRate="60", backgroundColor="0")]
	/**
	 * ……
	 * @author 	yangsj 
	 * 			2013-10-9
	 */
	public class main extends Sprite
	{
		private var mcLoaded:ui_Skin_Loading;
		private var loader:Loader;
		
		public function main()
		{
			if ( stage )
				initApp();
			else addEventListener( Event.ADDED_TO_STAGE, initApp );
		}
		
		private function initApp( event:Event = null ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, initApp );
			
			mcLoaded = new ui_Skin_Loading();
			mcLoaded.x = stage.stageWidth >> 1;
			mcLoaded.y = stage.stageHeight >> 1;
			addChild( mcLoaded );
			
			var url:String = getBaseUrl( stage.loaderInfo.url ) + "AppMain.swf?t=" + (new Date().time);
			trace( url );
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler );
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler );
			loader.load( new URLRequest(url));
		}
		
		protected function onCompleteHandler(event:Event):void
		{
			while ( this.numChildren > 0 )
				this.removeChildAt( 0 );
			addChild( loader.content );
		}
		
		protected function progressHandler(event:ProgressEvent):void
		{
			mcLoaded.txt.text = int((event.bytesLoaded / event.bytesTotal ) * 100 ) + "";
		}
		
		public function getBaseUrl(preurl : String) : String {
			var swfUrl : String;
			// var preurl : String = contextView.stage.loaderInfo.url;
			preurl = preurl.replace(/\\/g, "/");
			var lastslash : int = preurl.lastIndexOf("/");
			swfUrl = preurl.substring(0, lastslash + 1);
			return swfUrl;
		}
	}
}