package code
{
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;


	/**
	 * ……
	 * @author 	yangsj
	 * 			2013-11-24
	 */
	public class VideoView extends Sprite
	{

		public var videoURL:String = "";
		
		private var connection:NetConnection;
		private var stream:NetStream;
		
		public function VideoView()
		{
			
		}
		
		public function play():void
		{
			connection ||= new NetConnection();
			connection.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
			connection.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
			connection.connect( null );
		}
		
		public function pause():void
		{
			
		}

		private function netStatusHandler( event:NetStatusEvent ):void
		{
			switch ( event.info.code )
			{
				case "NetConnection.Connect.Success":
					connectStream();
					break;
				case "NetStream.Play.StreamNotFound":
					trace( "Unable to locate video: " + videoURL );
					break;
			}
		}

		private function connectStream():void
		{
			var video:Video = new Video();
			stream = new NetStream( connection );
			stream.client = new CustomClient();
			stream.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
			stream.addEventListener( AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler );
			video.attachNetStream( stream );
			stream.play( videoURL );
			addChild( video );
		}

		private function securityErrorHandler( event:SecurityErrorEvent ):void
		{
			trace( "securityErrorHandler: " + event );
		}

		private function asyncErrorHandler( event:AsyncErrorEvent ):void
		{
			// ignore AsyncErrorEvent events.
		}
	}
}
