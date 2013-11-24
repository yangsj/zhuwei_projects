package com.cg.utils 
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.LoaderContext;
	/**
	 * ...
	 * @author cg
	 */
	public class exLoader 
	{
		
		private var loader:Loader;
		private var lc:LoaderContext = new LoaderContext(true);
		private var _source:String;
		private var onLoad:Function;
		private var content:*;
		
		public function exLoader() 
		{
			loader = new Loader();
			
		}
		//从外部加载图像  reload标志为true时，带上随机值清cache
		public function load(__source:String, _onLoad:Function, reload:Boolean = false) {
			_source = __source;
			onLoad = _onLoad;
			if (reload) {
				__source+="?"+(new Date()).getTime();
			}
			var request:URLRequest = new URLRequest(__source);
			addListeners(loader.contentLoaderInfo);
			loader.load(request,lc);
		}
		
		//加载过程侦听
		private function addListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			//dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			//dispatcher.addEventListener(Event.INIT, initHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			//dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			//dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);
		}
		//删除所有侦听
		private function removeListeners(dispatcher:IEventDispatcher):void {
			dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
			//dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			//dispatcher.removeEventListener(Event.INIT, initHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			//dispatcher.removeEventListener(Event.OPEN, openHandler);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			//dispatcher.removeEventListener(Event.UNLOAD, unLoadHandler);
		}

		private function completeHandler(event:Event):void {
			content = loader.content;
			removeListeners(loader.contentLoaderInfo);
			if (onLoad != null) {
				onLoad(content);
			}
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			removeListeners(loader.contentLoaderInfo);
			if (onLoad != null) {
				onLoad(null);
			}
			//Tracer.print("[ ImageLoader ]  ioErrorHandler: " + event);
		}
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			//Tracer.print("[ ImageLoader ] httpStatusHandler: " + event);
		}

		private function initHandler(event:Event):void {
			//Tracer.print("[ ImageLoader ] initHandler: " + event);
		}

		
		

		private function openHandler(event:Event):void {
			//Tracer.print("[ ImageLoader ] openHandler: " + event);
		}

		private function progressHandler(event:ProgressEvent):void {
			//Tracer.print("[ ImageLoader ] progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
			if(event.bytesTotal>0){
				//loading.percent=event.bytesLoaded/event.bytesTotal
			}
		}

		private function unLoadHandler(event:Event):void {
			//Tracer.print("[ ImageLoader ] unLoadHandler: " + event);
		}
	}

}