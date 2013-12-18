package com.nova.math
{
	public class myMath
	{
		public function myMath()
		{
		}
		public static function rndPostion(orgpos:Number,num:Number=0,isF:Boolean=false):Number{
			var xnum:Number=0;		
			if(Math.random()*10>5&&!isF){
				xnum=(orgpos-num)+Math.random()*num;			
			}else{
				xnum=orgpos+Math.random()*num;
			}
			return xnum;
		}
		
	}
}