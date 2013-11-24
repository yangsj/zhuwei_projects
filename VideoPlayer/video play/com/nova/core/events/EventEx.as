package com.nova.core.events
{
	import flash.events.Event;

	public class EventEx extends Event
	{

		public var data:*;
		public function EventEx(type:String,arg:*=null)
		{
			super(type);
			data=arg;
		}

	}
}