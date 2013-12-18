package com.nova.core
{
	import flash.display.MovieClip;
	import flash.events.*;

	public class BaseMovieClip extends MovieClip
	{
		public var eventDispatcherEx:EventDispatcher;
		public function BaseMovieClip()
		{
			super();
			eventDispatcherEx=EventDispatcherEx.dispatcher;
		
		}

	}
}