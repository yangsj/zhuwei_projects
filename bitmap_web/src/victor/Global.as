package victor
{
	import flash.events.EventDispatcher;

	public class Global
	{
		public function Global()
		{
		}
		
		private static var _snsUrl:String = "";
		public static function get snsUrl():String
		{
			return _snsUrl;
		}
		
		public static function set snsUrl(value:String):void
		{
			_snsUrl = value;
		}
		
		private static var _isFronSNS:Boolean = false;
		public static function get isFronSNS():Boolean
		{
			return _isFronSNS;
		}
		
		public static function set isFronSNS(value:Boolean):void
		{
			_isFronSNS = value;
		}
		
		
		private static const _eventDispatcher:EventDispatcher = new EventDispatcher();
		public static function get eventDispatcher():EventDispatcher
		{
			return _eventDispatcher;
		}
		
		private static var _commitFirstPicUrl:String = "";
		public static function get commitFirstPicUrl():String
		{
			return _commitFirstPicUrl;
		}
		
		public static function set commitFirstPicUrl(value:String):void
		{
			_commitFirstPicUrl = value;
		}
		
		private static var _commitSecondPicUrl:String = "";
		public static function get commitSecondPicUrl():String
		{
			return _commitSecondPicUrl;
		}
		
		public static function set commitSecondPicUrl(value:String):void
		{
			_commitSecondPicUrl = value;
		}

	}
}