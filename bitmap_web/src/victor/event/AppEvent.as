package victor.event
{
	import flash.events.Event;
	
	public class AppEvent extends Event
	{
		private var _data:Object;
		
		public function AppEvent(type:String, data:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		/**
		 * 本地选择图片加载完成
		 */
		public static const SELECTED_LOAD_COMPLETE:String = "selected_load_complete";
		
		/**
		 * 图片编辑完成
		 */
		public static const EDIT_COMPLETE:String = "edit_complete";
		
		
		
		
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

	}
}