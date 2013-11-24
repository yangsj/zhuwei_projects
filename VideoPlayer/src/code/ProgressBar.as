package code
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	
	/**
	 * ……
	 * @author 	yangsj 
	 * 			2013-11-24
	 */
	public class ProgressBar extends Sprite
	{
		private var bg:DisplayObject;
		private var bar:DisplayObject;
		
		public function ProgressBar()
		{
			
		}
		
		public function setWidth( w:Number ):void
		{
			if ( bg && bg.parent )
				bg.parent.removeChild( bg );
			if ( bar && bar.parent )
				bar.parent.removeChild( bar );
			
			var shape:Shape = new Shape();
			shape.graphics.beginFill( 0xCCCCCC );
			shape.graphics.drawRect(0,-1,w,2);
			shape.graphics.endFill();
			bg = shape;
			
			shape.graphics.beginFill( 0x00FF00 );
			shape.graphics.drawRect(0,-1,w,2);
			shape.graphics.endFill();
			bar = shape;
			
			addChild( bg );
			addChild( bar );
		}
		
		public function setProgress( progress:Number ):void
		{
			if ( bar )
				bar.scaleX = progress;
		}
		
	}
}