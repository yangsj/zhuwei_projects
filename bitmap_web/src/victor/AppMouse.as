package victor
{
	import flash.display.BitmapData;
	import flash.ui.Mouse;
	import flash.ui.MouseCursorData;
	
	import ui.*;

	public class AppMouse
	{
		public function AppMouse()
		{
		}
		
		public static function get mouseData():MouseCursorData
		{
			if ( _mouseData == null )
			{
				_mouseData = new MouseCursorData();
				
				_mouseData.frameRate = 10;
				
				_mouseData.data = new Vector.<BitmapData>();
				
				_mouseData.data.push( new Bitmap1());
				
				_mouseData.data.push( new Bitmap2());
				_mouseData.data.push( new Bitmap2());
				
				_mouseData.data.push( new Bitmap3());
				_mouseData.data.push( new Bitmap3());
				
				_mouseData.data.push( new Bitmap4());
				_mouseData.data.push( new Bitmap4());
				
				_mouseData.data.push( new Bitmap5());
				_mouseData.data.push( new Bitmap5());
				_mouseData.data.push( new Bitmap5());
				
				_mouseData.data.push( new Bitmap6());
				_mouseData.data.push( new Bitmap6());
				
				_mouseData.data.push( new Bitmap7());
				_mouseData.data.push( new Bitmap7());
				
				_mouseData.data.push( new Bitmap8());
				_mouseData.data.push( new Bitmap8());
				
				_mouseData.data.push( new Bitmap9());
				_mouseData.data.push( new Bitmap9());
				
				_mouseData.data.push( new Bitmap10());
				_mouseData.data.push( new Bitmap10());
				
				_mouseData.data.push( new Bitmap11());
				
				_mouseData.data.push( new Bitmap12());
				_mouseData.data.push( new Bitmap12());
				_mouseData.data.push( new Bitmap12());
				
				_mouseData.data.push( new Bitmap13());
				_mouseData.data.push( new Bitmap13());
				
				_mouseData.data.push( new Bitmap14());
				_mouseData.data.push( new Bitmap14());
				
				_mouseData.data.push( new Bitmap15());
				_mouseData.data.push( new Bitmap15());
				_mouseData.data.push( new Bitmap15());
				_mouseData.data.push( new Bitmap15());
				
				_mouseData.data.push( new Bitmap16());
				_mouseData.data.push( new Bitmap16());
				
				_mouseData.data.push( new Bitmap17());
				_mouseData.data.push( new Bitmap17());
				
				_mouseData.data.push( new Bitmap18());
			}
			return _mouseData;
		}

		public static function show():void
		{
			Mouse.registerCursor("loading", mouseData);
			Mouse.cursor = "loading";
		}
		
		public static function hide():void
		{
			Mouse.unregisterCursor("loading");
		}
		
		private static var _mouseData:MouseCursorData;
		
	}
}