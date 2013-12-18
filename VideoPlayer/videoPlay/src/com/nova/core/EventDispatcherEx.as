package com.nova.core
{
	import flash.events.EventDispatcher;

	public class EventDispatcherEx
	{
		private static  var _dispatcher:EventDispatcher;		
		public static function get dispatcher():EventDispatcher{
		   _dispatcher=_dispatcher==null?new EventDispatcher:_dispatcher
		   return _dispatcher
		}
	}
}