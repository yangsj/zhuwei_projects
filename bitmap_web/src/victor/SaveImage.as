package victor
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;

	public class SaveImage
	{
		private var loader:URLLoader;
		private var loadedCompleted:Function;
		
		public function SaveImage(imgByte:ByteArray, loadedCompleted:Function )
		{
			this.loadedCompleted = loadedCompleted;
			
			var request:URLRequest = new URLRequest("http://www.aqmtl.com/cam/saveimg.php");
			request.method = URLRequestMethod.POST;
			request.data = imgByte;
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadCompleteHandler );
			loader.data = imgByte;
			loader.load( request );
		}
		
		protected function loadCompleteHandler(event:Event):void
		{
			loader.removeEventListener(Event.COMPLETE, loadCompleteHandler );
			if ( loadedCompleted )
				loadedCompleted( loader.data as String );
			
			loader = null;
			loadedCompleted = null;
		}
	}
}