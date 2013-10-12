package victor
{
	import flash.events.EventDispatcher;

	public class Global
	{
		public function Global()
		{
		}
		
		public static function get isTest():Boolean
		{
			return false;
		}
		
		private static var _snsUrl1:String = "";
		public static function get snsUrl1():String
		{
			return _snsUrl1;
		}
		
		public static function set snsUrl1(value:String):void
		{
			_snsUrl1 = value;
		}
		
		private static var _snsUrl2:String = "";
		public static function get snsUrl2():String
		{
			return _snsUrl2;
		}
		
		public static function set snsUrl2(value:String):void
		{
			_snsUrl2 = value;
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
			var i1:int = _commitFirstPicUrl.lastIndexOf("/") + 1;
			return _commitFirstPicUrl.substr( i1 );
		}
		
		public static function get secondPicUrl():String
		{
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

		private static var _step:int = 0;
		public static function get step():int
		{
			return _step;
		}
		
		public static function set step(value:int):void
		{
			_step = value;
		}
		

	}
}