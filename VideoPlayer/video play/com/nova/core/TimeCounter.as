package com.nova.core{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	public class TimeCounter extends BaseMovieClip {
		public var countNum:int=19;
		public var _timeBar:MovieClip;
		public var myTimer:Timer = new Timer(1000, 0);
		public var TimerCount=60;
		public function TimeCounter($target) {

			myTimer.addEventListener("timer", timerHandler);
			myTimer.start();
			//_eventDispatcherEx.addEventListener(rootEvent.ADD_TIME,addTime);
			//_eventDispatcherEx.addEventListener(rootEvent.DEC_TIME,decTime);
			trace($target.totalFrames);
			
			//$target.stop();
		}

		function timerHandler(event:TimerEvent) {		
/*			
				if (countNum>0) {
					countNum--;
				} else {
					trace("STOP");
					_timeBar.stop();
					event.target.stop();
					myTimer.removeEventListener("timer", timerHandler);
					MovieClip(root).monster.visible=false;
					MovieClip(root).monster.gotoAndStop(1);
					MovieClip(root).gameoverUI.visible=true;
					MovieClip(root).gameoverUI.s.gotoAndPlay(2);
				}*/

				
				
				if(event.target.currentCount==TimerCount){
					_eventDispatcherEx.dispatchEvent(new EventEx(EventEx.TimeCount_FINISHED));
				}
				//trace(event.target.currentCount);
			
		}
		private function playLine(){
			
		}
		public static function too($target:Object){
			return new TimeCounter($target);
		}
		public function addTime(event:EventEx) {
			myTimer.stop();
			if (countNum<=16) {
				countNum++;
			}
			myTimer.start();
		}
		public function decTime(event:EventEx) {
	
			//myTimer.stop();
			if (countNum>0) {
				countNum-=6;
			}
			_timeBar.gotoAndStop(countNum);
			//myTimer.start();
		}
	}
}