package victor
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class DisplayUtil
	{
		public function DisplayUtil()
		{
		}
		
		public static function removeAll( displayContainer:DisplayObjectContainer ):Boolean
		{
			if ( displayContainer )
			{
				while ( displayContainer.numChildren > 0 )
				{
					displayContainer.removeChildAt( 0 );
				}
				return true;
			}
			return false;
		}
		
		public static function removeSelf( display:DisplayObject ):void
		{
			if ( display )
			{
				if ( display.parent )
					display.parent.removeChild( display );
				display = null;
			}
		}
		
	}
}