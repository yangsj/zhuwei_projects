package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;
	
	import victor.Main;
	
	[SWF(width="1200", height="750", frameRate="60", backgroundColor="0")]
	public class main extends Sprite
	{
		public function main()
		{
			if ( stage )
				initApp();
			else addEventListener( Event.ADDED_TO_STAGE, initApp );
			//355851957
		}
		
		private function initApp( event:Event = null ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, initApp );
			
			appStage = stage;
			//appStage.alpha = 0;
			
			addChild( new Main());
		}
	}
}