// SoundBGM Class
// Control SOUND
// Copyright(C)2007 01media by Eric
package com.nova.core{
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.media.SoundTransform;
	import flash.events.MouseEvent;
	import flash.events.*;
	import flash.display.SimpleButton;
	import flash.events.EventDispatcher;
	import com.nova.core.events.EventEx;
	import gs.TweenMax;
	import flash.utils.Timer;
	import flash.text.TextField;
	import flash.media.SoundMixer;

	public class soundCtrl extends MovieClip{
		public var url:String = "music.mp3";
		public var song:SoundChannel;
		public var song2:SoundChannel;
		public var soundFactory:Sound;
		public var soundFactory2:Sound;
		public var request:URLRequest;
		public var bgs_switch:int = 1;
		public var _vol:Number = 0;
		public var _p:Number = 0;
		public var tmpSound:Object;
		public var isRepeart:Boolean;
		public var volume:Number=1;
		public var soundValValue:Number=50;
		private var tmpVolume:Number=0;
		public var countTimer:Timer=new Timer(1000);
		private var isMove:Boolean;
		private var soundCount:Number=0;
		private var tmpArr:Array;
		private var tmpNum:Number;
		public var soundMC:*;
		public var trans:SoundTransform;
		public var isStop:Boolean=true;
		//初始化

		public function soundCtrl($sound:Object=null,$url:String="",$isRepeart:Boolean=false,$volume:Number=1,$soundMC:*=null,$stage:*=null) {
			soundMC=$soundMC as MovieClip;
			volume=$volume;
			isRepeart=$isRepeart;
			trans = new SoundTransform(1, 0);

			if($url){
				url=$url;
				request = new URLRequest($url);
				soundFactory = new Sound();
				soundFactory.load(request);
				song = soundFactory.play(_p);
				song.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				setVolume(volume);
			}else if($sound){
				tmpSound=$sound;
				var soundClass:Class = tmpSound as Class;
            	soundFactory2 = new soundClass () as Sound;				
				song2 = soundFactory2.play(_p);
				song2.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler2);				
				setVolume(volume);
			}			
			tmpVolume=volume;
			//滚轮控制音量
			if(soundMC){
				$stage.addEventListener(MouseEvent.MOUSE_WHEEL,__wheel);
				soundMC.visible=false;
				TweenMax.to(soundMC.mc,1, {scaleY:volume,onUpdate:function(){
																			soundMC.txt.y=-soundMC.mc.height-soundMC.txt.height;   
																			   }});
				soundValValue=volume*100;
				setTxt();
				
				//setVolume(soundValValue/100);
			}
		}
		
		private function __timerCount(e:TimerEvent){			
			isMove=false;
			countTimer.removeEventListener(TimerEvent.TIMER,__timerCount);
			TweenMax.to(soundMC,1, {alpha:0,onComplete:function(){
															soundMC.visible=false;  
															  }});				
		}
		private function __wheel(e:MouseEvent):void {			
			if(e.delta>0){
				if(soundValValue<100)soundValValue+=5;				
			}else{
				if(soundValValue>0)soundValValue-=5;
			}
			TweenMax.killAllTweens();
			soundMC.visible=true;  
			soundMC.alpha=1;
			//txt.text=String(soundValValue)+"%";
			TweenMax.to(soundMC.mc,1, {scaleY:soundValValue/100,onUpdate:function(){
																		soundMC.txt.y=-soundMC.mc.height-soundMC.txt.height;   
																		   }});
			
			
			//super.setVolume(soundValValue/100);
			//MovieClip(root).addChild(this);
			trans.volume=soundValValue/100;
		
			SoundMixer.soundTransform=trans;
			countTimer.stop();
			countTimer.start();
			setTxt();
			if(!isMove){
				isMove=true;
				countTimer.addEventListener(TimerEvent.TIMER,__timerCount);
				
			}
		}
		public function setVolumes(num:Number){
			TweenMax.to(trans,1, {volume:num});
		}
		private function setTxt(){
			addEventListener(Event.ENTER_FRAME,setText);
		}
		private function setText(e:Event){
			tmpArr=String(soundMC.txt.text).split("%");
			tmpNum=Number(tmpArr[0]);

			if(tmpNum-soundValValue>1){				
				tmpNum-=2;
				soundMC.txt.text=String(tmpNum)+"%";
			}else if(tmpNum-soundValValue<-1){
				tmpNum+=2;
				soundMC.txt.text=String(tmpNum)+"%";
			}else{
				removeEventListener(Event.ENTER_FRAME,setText);
			}
		}
		protected function videoDurationEvent(e:Event){			
			//dispatchEvent(new EventEx("playerDuration",getTime()));
			//dispatchEvent(new EventEx("playerDurationTotal",getDuration()));	
			
		}
		public function reload($url:String=""){
				url=$url;
				if(song)song.stop();
				request = new URLRequest($url);
				if(soundFactory){
					soundFactory=null;				
				}
				soundFactory = new Sound();
				soundFactory.load(request);				
				song = soundFactory.play(0);
				setVolume(volume);
				song.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
		}
		public function playMusic(){
			song = soundFactory.play(0);
			song.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			addEventListener(Event.ENTER_FRAME,audioDurationEvent);	
		}
		public function stopMusic(){
			song.stop();			
			removeEventListener(Event.ENTER_FRAME,audioDurationEvent);	
			dispatchEvent(new EventEx("sndplayerComplete"));
		}
		private function audioDurationEvent(e:Event){
			
			dispatchEvent(new EventEx("sndplayerDuration",song.position));
			dispatchEvent(new EventEx("sndplayerDurationTotal",soundFactory.length));	
		}
		public function stopSound(){
			if(song)song.stop();
		}
		public function progressHandler(e:ProgressEvent){
			trace(e);
		}
		public static function too($sound:Object=null):soundCtrl{
			return new soundCtrl($sound);
		}
		public function playSnd(e:EventEx){
				setVolume(1);
				soundCompleteHandler(new Event(""));
		}
		public function stopSnd(e:EventEx){
				setVolume(0);
				song.stop();
		}
		private function soundCompleteHandler(event:Event):void {			
				if(isRepeart){
					song = soundFactory.play(0);	
					song.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);						
				}	
				trace("complete");
				dispatchEvent(new EventEx("sndplayerComplete"));
				removeEventListener(Event.ENTER_FRAME,audioDurationEvent);	
				setVolume(volume);
				
		}
		private function soundCompleteHandler2(event:Event):void {			
				var soundClass:Class = tmpSound as Class;				
				if(isRepeart){
					song2 = soundFactory2.play(0);
					song2.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler2);	
				}	
				setVolume(volume);
		}
		public function sndOff(){
			//tmpVolume=volume;
			volume=0;
			setVolume(0);
			isStop=false;
		}
		public function sndOn(){
			isStop=true;
			volume=tmpVolume;
			//tmpVolume=0;
			setVolume(volume);
		}
		public function returnSound(){		
				song = soundFactory.play(song.position+100);
				song.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);	
				setVolume(volume);
		}
		public function returnSound2(){			
				song = soundFactory.play(0);
				song.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);	
				setVolume(volume);
		}
		public function bt1(e:MouseEvent):void {
			
			if (bgs_switch==1) {
				//gotoAndStop(2);
				bgs_switch=0;
				setVolume(0);
				song.stop();
			} else {
				//fadeIn();
				//gotoAndStop(1);
				bgs_switch = 1;
				setVolume(1);
				soundCompleteHandler(new Event(""));
				
			}
		}


		public function setVolume(volume:Number):void {
			var transform:SoundTransform = song.soundTransform;
			transform.volume = volume;
			song.soundTransform = transform;
		}

		public function fadeIn():void {
			if (_vol == 0) {
				song = soundFactory.play(_p);				
			}
		}

		public function time3(e:Event):void {
			if (bgs_switch == 1) {
				if (_vol<1) {
					setVolume(_vol+=0.05);
				} else {
					_vol=1;
					//removeEventListener(Event.ENTER_FRAME,time3);
					setVolume(_vol);
				}
				//gotoAndStop(1);
				
			} else if (bgs_switch == 0) {
				if (_vol>0) {
					setVolume(_vol-=0.05);
				} else {
					_p = song.position;
					_vol=0;
					//removeEventListener(Event.ENTER_FRAME,time3);
					setVolume(_vol);					
					//gotoAndStop(2);
				}
		
			}
		}
	}
}