/***********
控制MC时间线动画正,倒放
AS3
用法:
MCPlayCtrl.too(this,false,"F");//正放
MCPlayCtrl.too(this,false,"R");//倒放

Copyright(C)2009 supernova.cn by noah
***********/
package com.nova.core
{
	import flash.events.*;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	public class ContrlPlay extends BaseMovieClip implements IContrlPlay{
		public var orgX:Number;
		public var orgY:Number;
		public var alignMode:String="";
		public var obj:MovieClip;
		private var _stage:MovieClip;
		public var tmpXOffset:Number=0;
		public var tmpYOffset:Number=0;
		private var scaleRate:Number=0;
		public static  var curMenuName:MovieClip;
		public static  var oldMenuName:MovieClip;
		public var subMC:MovieClip;
		public var runFrames:Number=0;
		public static  var menuIsRun:Boolean=false;
		public function ContrlPlay($obj:MovieClip=null,$num1:Number=0,$mode:String="",$isGroup:Boolean=false,$isNoGroup:Boolean=true,$num:Number=0) {
			//super();

			obj=$obj as MovieClip;
			obj.stop();
			if($num1>0){
				runFrames=$num1;
			}else{
				runFrames=obj.totalFrames;
			}
			if(!obj.num)obj.num=0;
				$obj.stop();
				if ($isGroup) {
					if (!ContrlPlay.curMenuName) {
						ContrlPlay.curMenuName=$obj;
						fplay();
					} else {
						if (MovieClip(ContrlPlay.curMenuName)!=$obj) {
							if (ContrlPlay.curMenuName.currentFrame>1) {
								ContrlPlay.too(ContrlPlay.curMenuName,runFrames,"R");
								ContrlPlay.oldMenuName=ContrlPlay.curMenuName;
								ContrlPlay.curMenuName=$obj;

								addEventListener(Event.ENTER_FRAME,tmpplay);
								function tmpplay(e:Event) {
									if (ContrlPlay.oldMenuName.currentFrame<2) {
										removeEventListener(Event.ENTER_FRAME,tmpplay);
									}
								}
							}
						}
					}
				} else {

					if (!$isNoGroup) {
						ContrlPlay.curMenuName=obj;
					}
					if ($mode=="F") {						
						fplay();
						obj.num=0;
					} else if ($mode=="R") {
						rplay();
					} else if ($mode=="FR") {
						obj.num=runFrames+1;
						rplay();
					}
				}
		}
		public static function too($target:MovieClip,$num1:Number=0,$mode:String="",$isGroup:Boolean=false,$isNoGroup:Boolean=false,$num:Number=0):ContrlPlay {

			return new ContrlPlay($target,$num1,$mode,$isGroup,$isNoGroup,$num);
		}
		public static function rndPostion(orgpos:Number,num:Number):Number {
			var xnum:Number=0;

			if (Math.random()*10>5) {
				xnum=(orgpos-num)+Math.random()*num;
			} else {
				xnum=orgpos+Math.random()*num;
			}
			return xnum;
		}
		public function resetplay():void {
			obj.num=0;
			removeEventListener(Event.ENTER_FRAME,replay);
			removeEventListener(Event.ENTER_FRAME,ffplay);
			fplay();

		}
		public  function fplay():void {
			
			removeEventListener(Event.ENTER_FRAME,replay);
			addEventListener(Event.ENTER_FRAME,ffplay);

		}
		private function ffplay(e:Event) {

			obj.num++;
			if (obj.num >= runFrames+1) {
				removeEventListener(Event.ENTER_FRAME,ffplay);
			} else {
				obj.gotoAndStop(obj.num);
			}
		}
		public function rplay():void {
			removeEventListener(Event.ENTER_FRAME,ffplay);
			addEventListener(Event.ENTER_FRAME,replay);
		}
		private function replay(e:Event) {
			obj.num--;
			if (obj.num<=0) {
				obj.num=0;
				removeEventListener(Event.ENTER_FRAME,replay);
			} else {
				obj.gotoAndStop(obj.num);
			}
		}
	}
}