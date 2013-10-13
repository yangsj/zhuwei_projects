package victor
{
	import flash.external.ExternalInterface;
	
	import victor.event.AppEvent;

	public class ExternalManager
	{
		public function ExternalManager()
		{
		}
		
		public static function jsAlert( des:String ):void
		{
			if ( ExternalInterface.available )
			{
				ExternalInterface.call( "alert", des );
			}
		}
		
		public static function callHtmlSelectedImage():void
		{
			if ( ExternalInterface.available )
			{
//				addFuncForJs();
				ExternalInterface.call( "selectsns" );
//				Global.eventDispatcher.dispatchEvent( new AppEvent( AppEvent.SELECTED_IMG_FROM_HTML, "http://img.adbox.sina.com.cn/pic/21716.jpg" ));
			}
		}
		
		public static function addFuncForJs():void
		{
			try
			{
				if ( ExternalInterface.available )
				{
					ExternalInterface.addCallback( "selectimg", selectimgFromSns );
				}
			}
			catch ( e:* )
			{
				ExternalInterface.call( "alert", " flash注册方法错误" );
			}
		}
		
		private static function selectimgFromSns( imgUrl1:String, imgUrl2:String ):void
		{
//			ExternalInterface.call( "alert", "JS成功调用Flash" + imgUrl );
			Global.eventDispatcher.dispatchEvent( new AppEvent( AppEvent.SELECTED_IMG_FROM_HTML, [ imgUrl1, imgUrl2 ] ));
		}
		
	}
}