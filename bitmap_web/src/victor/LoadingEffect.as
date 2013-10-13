package victor
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	
	/**
	 * ……
	 * @author 	yangsj 
	 * 			2013-10-12
	 */
	public class LoadingEffect
	{
		private var _loading:ui_Skin_LoadingWait;
		
		public function LoadingEffect()
		{
		}
		
		public function show( pos:Point = null ):void
		{
			if ( pos )
			{
				loading.x = pos.x;
				loading.y = pos.y;
			}
			else
			{
				loading.x = appStage.stageWidth >> 1;
				loading.y = appStage.stageHeight >> 1;
			}
			appStage.mouseChildren = false;
			appStage.addChild( loading );
		}
		
		public function hide():void
		{
			appStage.mouseChildren = true;
			DisplayUtil.removeSelf( loading );
		}
		
		
		private function get loading():DisplayObject
		{
			return _loading ||= new ui_Skin_LoadingWait();
		}
		
		
	}
}