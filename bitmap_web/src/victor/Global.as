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
		
		public static function get firstPicUrl():String
		{
//			return _commitFirstPicUrl;
			var i1:int = _commitFirstPicUrl.lastIndexOf("/") + 1;
			return _commitFirstPicUrl.substr( i1 );
		}
		
		public static function get secondPicUrl():String
		{
//			return _commitSecondPicUrl;
			var i1:int = _commitSecondPicUrl.lastIndexOf("/") + 1;
			return _commitSecondPicUrl.substr( i1 );
		}
		
		private static var _currentYear:int;
		public static function get currentYear():int
		{
			return _currentYear;
		}
		
		public static function set currentYear(value:int):void
		{
			_currentYear = value;
		}

	}
}