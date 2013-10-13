package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	import victor.ExternalManager;
	
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
			Security.allowDomain("*");
			if ( stage )
				initApp();
			else addEventListener( Event.ADDED_TO_STAGE, initApp );
		}
		
		private function initApp( event:Event = null ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, initApp );
			
			ExternalManager.addFuncForJs();
			
			mcLoaded = new ui_Skin_Loading();
			mcLoaded.x = stage.stageWidth >> 1;
			mcLoaded.y = stage.stageHeight >> 1;
			addChild( mcLoaded );
			
			mcLoaded.txt.embedFonts = true;
			mcLoaded.txt.text = "0";
			
			var url:String = getBaseUrl( stage.loaderInfo.url ) + "AppMain.swf?t=" + (new Date().time);
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
			mcLoaded.txt.embedFonts = true;
			mcLoaded.txt.text = int((event.bytesLoaded / event.bytesTotal ) * 100 ) + "";
		}
		
		public function getBaseUrl(preurl : String) : String {
			var swfUrl : String;
			preurl = preurl.replace(/\\/g, "/");
			var lastslash : int = preurl.lastIndexOf("/");
			swfUrl = preurl.substring(0, lastslash + 1);
			return swfUrl;
		}
	}
}