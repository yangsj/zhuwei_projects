package com.cg.services
{
	import com.cg.encoder.XMLEncoder;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	public class XmlService extends EventDispatcher
	{
		public static var NoCache:Boolean=true;
		//
		public var service:String;
		public var request:URLVariables;
		public var noCache:Boolean;
		private var url_request:URLRequest;
		private var loader:URLLoader;
		private var method:String;
		private var _response:String;
		private var _debug:Boolean;
		private var _name:String;
		private var dispather:EventDispatcher;
		private var loadedHandler:Function;
		public function XmlService(_service:String,_method:String="POST",userGlobalNoCache:Boolean=true,_noCache:Boolean=true)
		{
			service=_service;
			method=_method;
			if(userGlobalNoCache){
				noCache=XmlService.NoCache;
			}else{
				noCache=_noCache;
			}
			loader=new URLLoader(url_request);
			request=new URLVariables;
			_debug=false
			_name="["+service+"]"
		}
		//发送
		public function send(_service:String=null,_method:String="POST")
		{
			var url_request:URLRequest = new URLRequest();
			url_request.data=request
			url_request.url=_service?_service:service
			url_request.method=_method?_method:method
			if(noCache){
				request.rnd=Math.random();
			}
			if(debug){
				trace(_name + " request:")
				for(var o in request){
     	        	trace("\t" + o + ":\t" + request[o])
    			}
    			trace("\n\n\n")
             }
			//
			addListeners(loader)
			try {
                loader.load(url_request);
            } catch (error:Error) {
                trace("[" + _name + "]\t"+" Unable to load requested document[" + service + "].");
				if(loadedHandler!=null){
					loadedHandler(false)
				}
				dispatchEvent(new Event("onError"))
            }
		}
		//设置名字
		public function set name(_str:String):void
		{
			_name=_str
		}
		//取得名字
		public function get name():String
		{
			return _name
		}
		//是否调试
		public function set debug(_b:Boolean):void
		{
			_debug=_b
		}
		//是否调试
		public function get debug():Boolean
		{
			return _debug
		}
		//获取返回的String对象
		public function get response():String
		{
			return _response
		}
		//获取返回的xml对象
		public function get responseXML():XML{
			return new XML(_response)
		}
		//获取返回的Object对象
		public function get responseObject():Object
		{
			return XMLEncoder.xml2Obj(responseXML)
		}
		public function set onLoad(handler:Function):void{
			loadedHandler=handler
		}
		//加载侦听
		private function addListeners(dispatcher:IEventDispatcher):void 
		{
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }
        //卸载侦听
        private function removeListeners(dispatcher:IEventDispatcher):void {
            dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
            dispatcher.removeEventListener(Event.OPEN, openHandler);
            dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }

        private function openHandler(event:Event):void {
           //  trace(_name + "openHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
           //  trace(_name + "progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
           //  trace(_name + "httpStatusHandler: " + event);
        }
        
        private function completeHandler(event:Event):void {
            var loader:URLLoader = URLLoader(event.target);
			_response=loader.data;
           // trace(_name + "  completeHandler")
		   
            if(debug){
             	trace(loader.data);
				trace("\n\n\n")
            }
			
            removeListeners(loader)
           // trace("loadedHandler:"+loadedHandler)
            if(loadedHandler!=null){
				trace(_response)
				loadedHandler(true)
            }
            dispatchEvent(new Event("onLoad"))
			
        }
 		 private function securityErrorHandler(event:SecurityErrorEvent):void {
             trace(_name + "  securityErrorHandler: " + event);
             removeListeners(loader)
             if(loadedHandler!=null){
			 	loadedHandler(false)
             }
			 dispatchEvent(new Event("onError"))
			 
        }
        private function ioErrorHandler(event:IOErrorEvent):void {
             trace(_name + "  ioErrorHandler: " + event);
             removeListeners(loader)
             if(loadedHandler!=null){
			 	loadedHandler(false)
             }
			 dispatchEvent(new Event("onError"))
        }


	}
}