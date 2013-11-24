package com.nova.core
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	public interface IDrawBitMap
	{	
		function copyScreen(obj:DisplayObject,tx:Number=0,ty:Number=0):Bitmap;
		function clearBitmap();
	}
}