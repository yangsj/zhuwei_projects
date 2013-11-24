package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import code.VideoView;
	
	[SWF(width="100%", height="100%", backgroundColor="0x000000", frameRate="60" )]
	/**
	 * ……
	 * @author 	yangsj 
	 * 			2013-11-24
	 */
	public class VideoPlayer extends Sprite
	{
		private var view:VideoView;
		
		public function VideoPlayer()
		{
			if ( stage )
				initApp( null );
			else addEventListener( Event.ADDED_TO_STAGE, initApp );
		}
		
		protected function initApp(event:Event):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, initApp );
			
			view = new VideoView();
			view.videoURL = "example_video.flv";
			addChild( view );
			view.play();
		}
	}
}