package com.cg.utils
{
	import flash.display.*;
	
	public class exMovieClip
	{
		static public function getChildMovieClip(o:MovieClip):Array
		{
			var arr:Array=new Array()
			for(var i=0;i<o.numChildren;i++){
				if(o.getChildAt(i) is MovieClip){
					arr.push(o.getChildAt(i));
				}
			}
			return arr;
		}
		static public function findInArray(o:*,arr:Array):Boolean
		{
			for(var i=0;i<arr.length;i++){
				if(arr[i]==o){
					return true
				}
			}
			return false;
		}
		static public function stopChildMovieClip(o:MovieClip,invalidNames:Array=null,stopInvalidChild:Boolean=true):void
		{
			if(invalidNames==null){
				invalidNames=[]
			}
			for(var i=0;i<o.numChildren;i++){
				if(o.getChildAt(i) is MovieClip){
					var mc:MovieClip=o.getChildAt(i) as MovieClip;
					if(!findInArray(mc.name,invalidNames)){
						mc.stop();
						stopChildMovieClip(mc,invalidNames,stopInvalidChild);
					}else if (stopInvalidChild) {
						stopChildMovieClip(mc,invalidNames,stopInvalidChild);
					}
				}
			}
		}
		static public function playChildMovieClip(o:MovieClip,invalidNames:Array=null,playInvalidChild:Boolean=true):void
		{
			if(invalidNames==null){
				invalidNames=[]
			}
			for(var i=0;i<o.numChildren;i++){
				if(o.getChildAt(i) is MovieClip){
					var mc:MovieClip = o.getChildAt(i) as MovieClip;
					if (findInArray(mc.name, invalidNames)) {
						//trace("000000000000000000000000000000000000000000000000000000000000000000000000000000"+mc.name);
					}
					if(!findInArray(mc.name,invalidNames)){
						mc.play();
						playChildMovieClip(mc,invalidNames,playInvalidChild);
					}else if (playInvalidChild) {
						playChildMovieClip(mc,invalidNames,playInvalidChild);
					}
				}
			}
		}

	}
}