package com.nova.core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	public class DrawBitMap extends Bitmap implements IDrawBitMap
	{	
		public var planeMCwidth:Number;
		public var planeMCheight:Number;
		public var data:*;
		private var myBitmapSource1:BitmapData= new BitmapData (1,1,true,0x00000000);
		public function DrawBitMap(bitmapData:DisplayObject=null,tx:Number=0,ty:Number=0)
		{			
			if(bitmapData)copyScreen(bitmapData,tx,ty);
		}
		public function copyScreen(obj:DisplayObject,tx:Number=0,ty:Number=0):Bitmap{
			
			myBitmapSource1.dispose();
			var orgW=obj.width;
			var orgH=obj.height;
			if(orgW>=2880) orgW=2879;
			if(orgW==0) orgW=1;
			
			if(orgH>=2880) orgH=2879;
			if(orgH==0) orgH=1;

			var myMatrix:Matrix= new Matrix(1,0,0,1,tx*-1,ty*-1);			
			var rect:Rectangle=new Rectangle(0,0,orgW,orgH);
			myBitmapSource1= new BitmapData (orgW,orgH,true,0x00000000);
			myBitmapSource1.draw(obj,myMatrix,null,null,rect,true);
			var mm1:Bitmap=new Bitmap(myBitmapSource1,"auto",true);
			data=mm1;
			return mm1;
			
		}
		public function clearBitmap(){
			myBitmapSource1.dispose();
		}
	}
}