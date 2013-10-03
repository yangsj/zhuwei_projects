package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import victor.Main;
	
	[SWF(width="1200", height="750", frameRate="60", backgroundColor="#FFFFFF")]
	public class BitmapWeb extends Sprite
	{
		public function BitmapWeb()
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
			
			addChild( new Main());
		}
	}
}