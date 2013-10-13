package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import victor.Global;
	import victor.Main;
	
	[SWF(width="1200", height="700", frameRate="60", backgroundColor="0xffffff")]
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
			
			// test
//			Global.isFronSNS = true;
//			Global.snsUrl1 = "http://img.adbox.sina.com.cn/pic/21716.jpg";
//			Global.snsUrl2 = "http://sh.sinaimg.cn/iframe/489/2012/0627/U10201P18T489D1F14630DT20131011092708.jpg";
//			Global.step = 1;
			
			var parameters:Object = stage.loaderInfo.parameters;
			if ( parameters.hasOwnProperty( "step" ))
			{
				var step:int = int( parameters["step"] );
				Global.isFronSNS = step > 0;
				Global.step = step;
				if ( step == 1 || step == 2 )
				{
					Global.snsUrl1 = parameters["pic"]; 
				}
				else if ( step == 3 )
				{
					Global.snsUrl1 = parameters["pic1"]; 
					Global.snsUrl2 = parameters["pic2"]; 
				}
			}
			
			addChild( new Main());
		}
	}
}

/*
	1、图片编辑时需要笤俑JS讲方法将图片上传到服务器获取图片url然后传递给页面。
	
	2、
*/