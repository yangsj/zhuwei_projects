package victor
{
	import flash.events.Event;
	import flash.external.ExternalInterface;
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
			
			var url:String = Global.isTest ? "http://www.aqmtl.com/cam/saveimg.php" : "saveimg.php";
			var request:URLRequest = new URLRequest(url);//http://www.aqmtl.com/cam/
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
			var url:String = loader.data as String;
			if ( (url.length == 5 || (url == "error" || url == "Error" )))
			{
				if ( ExternalInterface.available )
				{
					ExternalInterface.call("uploaderror");
				}
			}
			else if ( loadedCompleted != null )
			{
				loadedCompleted( url );
			}
			
			loader = null;
			loadedCompleted = null;
		}
	}
}