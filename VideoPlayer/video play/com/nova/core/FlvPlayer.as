package com.nova.core{
	import flash.events.*;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import com.nova.core.events.EventEx;
	public class FlvPlayer extends BaseMovieClip {
		public var _root:Object;
		public var _parent:Object;
		public var connect:Boolean=false;
		private var videoURL:String;
		private var connection:NetConnection;
		public var stream:NetStream;
		private var _pause:Boolean=false;
		//private var _sound:Boolean=true;
		//private var sndVol:Number;
		/*private var curVideoId:Number = 0;
		private var xmlData:XML=new XML();
		private var request:URLRequest=new URLRequest("videoList.xml");
		private var requestLoader:URLLoader=new URLLoader();
		*/
		private var videoX:Number=0;
		private var videoY:Number=0;
		private var videoW:Number=0;
		private var videoH:Number=0;
		private var videoURLStr:String="";
		public var video:Video;
		private var sndTransform:SoundTransform;
		public var videoDuration:Number;

		public function FlvPlayer(str:String="",w:Number=640,h:Number=480,posx:Number=0,posy:Number=0):void {

			//loadData();
			//requestLoader.addEventListener(Event.COMPLETE,requestCompleteHandler);
			//requestLoader.addEventListener(IOErrorEvent.IO_ERROR,requestErrorHandler);
			videoX=posx;
			videoY=posy;
			videoW=w;
			videoH=h;
			videoURLStr=str;
			__init();
			//
			

		
		}
		public function clearAll(){
			stream.close();
			stream.client=null;
			connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);

			removeEventListener(Event.ENTER_FRAME,videoDurationEvent);	
			stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			
			video.clear();
			connection=null;
			stream=null;
			video=null;
			sndTransform=null;
			removeChild(video);
		}
		public function __init(){
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			connection.connect(null);
			if(videoURLStr)setVideoURL(videoURLStr);
		}
		public function setVideoURL(url:String):void {
			videoURL=url;
			stream.play(videoURL);
		}

		public function streamStop():void {
			stream.pause();
		}

		public function playHandler():void {
			if (_pause) {
				stream.pause();
			} else {
				//videoURL = getCurVideoUrl(videoID);
				stream.play(videoURL);
			}
			_pause = false;
		}
		public function videoToggle():void {
			_parent=parent;
			_pause=!_pause;
			stream.togglePause();
			//trace(_parent.name)
			if (_pause) {
				//_parent.parent.controller.btVideoBigToggle.showpic();
			} else {
				//_parent.parent.controller.btVideoBigToggle.hidepic();
			}
		}
		public function stopHandler():void {
			setVideoPos(0);
			stream.pause();
			_pause=true;
			removeEventListener(Event.ENTER_FRAME,videoDurationEvent);
		}
		public function setVideoPos(pos:Number):void {			
			stream.seek(pos);

		}
		/*public function sndToggle():void {
		_sound=!_sound;
		if (_sound) {
		setVolume(sndVol);
		} else {
		sndVol=getCurVol();
		//sndVol=sndTransform.volume;
		setVolume(0);
		}
		}
		private function getCurVol():Number {
		return sndTransform.volume;
		}
		*/
		public function setVolume(vol:Number):void {
			sndTransform.volume=vol;
			stream.soundTransform=sndTransform;
			//trace("sndVol:"+sndVol+"\nstream.soundTransform.volume:"+stream.soundTransform.volume);
			//trace("vol:"+vol);
		}
		/*
		public function videoPause() {
		_pause = true;
		stream.pause();
		}
		*/
		public function getLoaded():Number {
			return stream.bytesLoaded;
		}
		public function getTotal():Number {
			return stream.bytesTotal;
		}
		public function getTime():Number {
			return stream.time;
		}
		public function getDuration():Number {
			return videoDuration;
		}
  		public function playtime():String {
    		var streamminute:Number = Math.floor(stream.time / 60);
			var smin_str:String;
    		if (streamminute>=10) {
     			smin_str = String(streamminute);
   			} else {
     			smin_str = "0" + streamminute;
    		}
    		var streamsecond:Number = Math.round(stream.time % 60);
    		var ssec_str:String;
    		if (streamsecond>=10) {
     			ssec_str = String(streamsecond);
    		} else {
     			ssec_str = "0" + streamsecond;
    		}
    		var newtime:String = smin_str + ":" + ssec_str;
			
    		return newtime;
   		}
		public function onMetaData(infoObject:Object):void {
			videoDuration=infoObject.duration;
			trace("Total Time"+videoDuration);
			/*var key:String;
			for (key in infoObject) {
			trace(key + ": " + infoObject[key]);
			}
			*/
		}
		private function requestErrorHandler(event:IOErrorEvent):void {
			// ignore IOErrorEvent
		}
		private function loadData():void {
			//requestLoader.load(request);
		}
		private function requestCompleteHandler(event:Event):void {
			//xmlData=XML(requestLoader.data);
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			connection.connect(null);
		}
		private function getCurVideoUrl(videoID):void {
			/*var _l1 = videoList;
			if (++curVideoId>_l1.length) {
			curVideoId=1;
			}
			return _l1[curVideoId - 1];
			*/
		}
		private function netStatusHandler(event:NetStatusEvent):void {		
			switch (event.info.code) {				
				case "NetStream.Buffer.Empty" :
					dispatchEvent(new Event("bufferEmpty"));
					break;					
				case "NetStream.Buffer.Full" :
					dispatchEvent(new Event("bufferFull"));
					break;
				case "NetStream.Play.Start" :
					dispatchEvent(new Event("videoStart"));
					addEventListener(Event.ENTER_FRAME,videoDurationEvent);
					break;
				case "NetConnection.Connect.Success" :
					connectStream();
					break;
				case "NetStream.Play.StreamNotFound" :
					trace("Unable to locate video: " + videoURL);
					break;
				case "NetStream.Play.Stop" :
					//stream.play(videoURL);
					removeEventListener(Event.ENTER_FRAME,videoDurationEvent);
					dispatchEvent(new Event("videoStop"));
					trace("video-----stop");
					break;
			}
		}
		public function replay(){
			stream.play(videoURL);
			addEventListener(Event.ENTER_FRAME,videoDurationEvent);
		}
		private function connectStream():void {
			stream = new NetStream(connection);
			sndTransform=stream.soundTransform;
			stream.client=this;
			stream.bufferTime=3;
			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			if(!video){
				video = new Video(videoW,videoH);
			}
			//video.smoothing=true;
			video.attachNetStream(stream);
			connect=true;	
		}

		protected function videoDurationEvent(e:Event){			
			dispatchEvent(new EventEx("playerDuration",getTime()));
			
			
		}
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}
		private function asyncErrorHandler(event:AsyncErrorEvent):void {
			// ignore AsyncErrorEvent events.
		}
	}
}