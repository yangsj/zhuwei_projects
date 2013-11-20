package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import code.AppConfig;
	import code.MainView;
	import code.TickManager;
	
	[SWF(width="1200", height="624", backgroundColor="0x000000", frameRate="30" )]
	/**
	 * ……
	 * @author 	yangsj 
	 * 			2013-11-17
	 */
	public class Main extends Sprite
	{
		public function Main()
		{
			if ( stage )
				initApp( null );
			else addEventListener(Event.ADDED_TO_STAGE, initApp );
		}
		
		protected function initApp(event:Event):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, initApp );
			
			appStage = stage;
			
			AppConfig.playerName = "超级无敌";
			AppConfig.playerPicUrl = "http://img.bimg.126.net/photo/xNCcQiMrr5cazwVy5plOsQ==/6597104951028273718.jpg";
			
			var params:Object = stage.loaderInfo.parameters;
			if ( params.hasOwnProperty( "picUrl" ))
				AppConfig.playerPicUrl = params["picUrl"];
			if ( params.hasOwnProperty( "playerName" ))
				AppConfig.playerName = params["playerName"];
			
			TickManager.instance.init( stage.frameRate );
			
			addChild( new MainView() );
		}
	}
}