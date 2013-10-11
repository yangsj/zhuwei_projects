package victor.event
{
	import flash.events.Event;
	
	public class AppEvent extends Event
	{
		private var _data:Object;
		
		public function AppEvent(type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
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
		
		/**
		 * 重新选择
		 */
		public static const SELECTED_AGAIN:String = "selected_again";
		
		/**
		 *  确认提交
		 */
		public static const CONFIRM_COMMIT:String = "confirm_commit";
		
		/**
		 * 从页面选择图片后调用flash派发（url）
		 */
		public static const SELECTED_IMG_FROM_HTML:String = "selected_img_from_html";
		
		/**
		 * 选择描述
		 */
		public static const SELCTED_DES:String = "selcted_des";
		
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