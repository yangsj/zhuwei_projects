package com.nova.core
{
 
	public class emEach
	{
        public static function init(obj:*) : void {
			for each(var em in obj){
				em="";
			}
        }
	}
}