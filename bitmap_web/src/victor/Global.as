package victor
{
	import flash.events.EventDispatcher;

	public class Global
	{
		public function Global()
		{
		}
		
		
		
		private static const _eventDispatcher:EventDispatcher = new EventDispatcher();
		
		public static function get eventDispatcher():EventDispatcher
		{
			return _eventDispatcher;
		}

	}
}