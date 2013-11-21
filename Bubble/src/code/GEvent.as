package code
{
	import flash.events.Event;
	
	
	/**
	 * ……
	 * @author 	yangsj 
	 * 			2013-11-17
	 */
	public class GEvent extends Event
	{
		
		
		
		
		/**
		 * 拖拽成功
		 */
		public static const DRAG_SUCCESSED:String = "drag_successed";
		
		/**
		 * 开始拖拽
		 */
		public static const DRAG_START:String = "drag_start";
		
		/**
		 * 结束拖拽
		 */
		public static const DRAG_COMPLETE:String = "drag_complete";
		
		/**
		 * 鼠标移上
		 */
		public static const MOUSE_OVER:String = "mouse_over";
		
		/**
		 * 鼠标移开
		 */
		public static const MOUSE_OUT:String = "mouse_out";
		
		
		
		
		
		
		
		private var _data:Object;
		public function GEvent(type:String, data:Object=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}

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