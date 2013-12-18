package com.nova.server.events
{
	import flash.events.Event;

	public class xmlGatewayEvent extends Event
	{
		public static const MESSAGE_RECEIVED:String = "messageReceived";
		public static const DATA_RECEIVED:String = "dataReceived";
		public var data:*;
		public function xmlGatewayEvent(type:String,theData:*=null)
		{
			super(type);
			this.data = theData;
		}
	}
}