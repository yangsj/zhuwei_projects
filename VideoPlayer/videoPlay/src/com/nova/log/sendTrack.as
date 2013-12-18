package com.nova.log
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.events.*;
	import flash.utils.Timer;
	public class sendTrack
	{	
		public var trackURL:String;
		public var varObj:URLVariables=new URLVariables();
		public var countTimer:Timer=new Timer(15000,3);
		public var src:String="";
		public var des:String="";
		public var mediaVar:String="";
		public var loader:URLLoader = new URLLoader();
		public function sendTrack(URL:String,str1:String="",str2:String="",$mediaVar:String="")
		{
			
			trackURL=URL;
			mediaVar=$mediaVar;
			src=str1;
			des=str2;
			src=des;
			sendMoniter(str1,str2);
			countTimer.start();
			countTimer.addEventListener(TimerEvent.TIMER,__timerCount);
		}
		public function sendMoniter(str1:String,str2:String){
			trace("sendMoniter("+src+","+des+")");		
/*			varObj.sourceSwf=str1;
			varObj.desSwf=str2;
			varObj.media=mediaVar;			*/
			var url:URLRequest = new URLRequest(trackURL+"?sourceSwf="+str1+"&desSwf="+str2+"&media="+mediaVar+"&r="+int(Math.random()*1000));
			//url.method = URLRequestMethod.POST;	
			loader.load(url);					
			
		}
		public function stopMoniter(){
			countTimer.stop();
		}
		private function __timerCount(e:TimerEvent){			
			sendMoniter(src,des);
		}
		public function startTrack(){
			sendMoniter(src,des);
			src=des;
			countTimer.reset();
			countTimer.repeatCount=3;
			countTimer.start();
		}
	}
}