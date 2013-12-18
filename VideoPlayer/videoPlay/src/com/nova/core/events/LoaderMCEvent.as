package com.nova.core.events
{
	import flash.events.Event;

	public class LoaderMCEvent extends Event
	{

		public static var LOADER_COMPLETE:String="LOADER_COMPLETE";
		public static var LOADER_TO_MC:String="LOADER_TO_MC";
		public static var LOADER_START:String="LOADER_START";
		public static var LOADER_ERROR:String="LOADER_ERROR";		
		public static const LOAD_VARS:String = "loadVars";
		public var data:*;
		public function LoaderMCEvent(type:String,arg:*=null)
		{
			super(type);
			data=arg;
		}

	}
}