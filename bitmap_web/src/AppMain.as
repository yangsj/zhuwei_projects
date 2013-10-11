package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import victor.Global;
	import victor.Main;
	
	[SWF(width="1200", height="700", frameRate="60", backgroundColor="0")]
	public class AppMain extends Sprite
	{
		public function AppMain()
		{
			if ( stage )
				initApp();
			else addEventListener( Event.ADDED_TO_STAGE, initApp );
			//355851957
		}
		
		private function initApp( event:Event = null ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, initApp );
			
//			Security.allowDomain("*");
			
			appStage = stage;
			//appStage.alpha = 0;
			
			var parameters:Object = stage.loaderInfo.parameters;
			if ( parameters.hasOwnProperty( "pic" ) && parameters["pic"] )
			{
				Global.isFronSNS = true;
				Global.snsUrl = parameters["pic"]; 
				Global.step = int( parameters[ "step" ] );
			}
			
			// test
//			Global.isFronSNS = true;
//			Global.snsUrl = "C:\\Users\\Administrator\\Desktop\\6862276_134908305332_2.jpg";
//			Global.snsUrl = "http://img.adbox.sina.com.cn/pic/21716.jpg";
//			Global.step = 2;
			
			addChild( new Main());
		}
	}
}

/*
	1、图片编辑时需要笤俑JS讲方法将图片上传到服务器获取图片url然后传递给页面。
	
	2、
*/