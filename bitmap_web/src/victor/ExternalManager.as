package victor
{
	import flash.external.ExternalInterface;
	
	import victor.event.AppEvent;

	public class ExternalManager
	{
		public function ExternalManager()
		{
		}
		
		public static function callHtmlSelectedImage():void
		{
			if ( ExternalInterface.available )
			{
				addFuncForJs();
				ExternalInterface.call( "selectsns" );
//				Global.eventDispatcher.dispatchEvent( new AppEvent( AppEvent.SELECTED_IMG_FROM_HTML, "http://img.adbox.sina.com.cn/pic/21716.jpg" ));
			}
		}
		
		public static function addFuncForJs():void
		{
			if ( ExternalInterface.available )
			{
				ExternalInterface.addCallback( "selectimg", selectimgFromSns );
			}
		}
		
		private static function selectimgFromSns( imgUrl:String ):void
		{
			Global.eventDispatcher.dispatchEvent( new AppEvent( AppEvent.SELECTED_IMG_FROM_HTML, imgUrl ));
		}
		
	}
}