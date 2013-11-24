package com.cg.services
{
	import com.adobe.serialization.json.JSON;
	import com.cg.debug.Tracer;
	import com.cg.encoder.XMLEncoder;
	import com.cg.encoder.UTF8Encoder;
	
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	public class DataService extends EventDispatcher
	{
		public static const POST:String = "POST";
		public static const GET:String = "GET";
		public static const XML_MODE:String = "xml";
		public static const JSON_MODE:String = "json";
		public static const VAR_MODE:String = "var";
		public static const TXT_MODE:String = "txt";
		
		public static var NoCache:Boolean = true;
		public static var DEBUG:Boolean = true;
		public static var DATA_MODE:String = "xml";
		public static var SEND_METHOD:String = "post";
		//
		public var service:String;
		public var request:URLVariables;
		public var noCache:Boolean;
		public var dataMode:String;
		public var toUTF8:Boolean=true;
		
		private var url_request:URLRequest;
		private var loader:URLLoader;
		private var method:String;
		private var _response:String;
		private var _debug:Boolean;
		private var _name:String;
		private var dispather:EventDispatcher;
		private var loadedHandler:Function;
		public function DataService(_service:String,_method:String="post",_dataMode:String="xml",userGlobalNoCache:Boolean=true)
		{
			service = _service;
			method = _method;
			dataMode = _dataMode;
			
			if(userGlobalNoCache){
				noCache=DataService.NoCache;
			}
			loader=new URLLoader(url_request);
			request=new URLVariables;
			_debug = DataService.DEBUG;
			_name = "[" + service + "]";
		}
		//发送
		public function send(staticXML:Boolean = false):void
		{
			var url_request:URLRequest = new URLRequest();
			url_request.url = service;
			var fileType:String = service.toLowerCase().substr(service.length - 4, service.length);
			if (fileType == ".xml" || fileType == ".txt") {
				//用Get方法在静态文件后面加参数可能导致文件访问失败
			}else{
				url_request.data = request;
			}
			url_request.method = method;
			if(noCache){
				request.rnd=Math.random();
			}
			if(debug){
				Tracer.str("====send to server API: " + url_request.url + "====\n");
				if(method==DataService.POST){
					Tracer.obj(url_request.data);
				}else {
					Tracer.str(getFullURL(service, URLVariables(url_request.data)));
				}
             }
			//
			addListeners(loader);
			try {
                loader.load(url_request);
            } catch (error:Error) {
                Tracer.str("[" + _name + "]\t"+" Unable to load requested document[" + service + "].\n");
				if(loadedHandler!=null){
					loadedHandler(false);
				}
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
            }
		}
		public function sendBytes(bytes:ByteArray):void
		{
			if(noCache){
				request.rnd=Math.random();
			}
			var url_request:URLRequest = new URLRequest();			
			url_request.url = getFullURL(service, URLVariables(request));
			url_request.data = bytes;
			url_request.method = POST;
			url_request.contentType = "application/octet-stream";
			if(debug){
				Tracer.str("====send bytes to server API: " + url_request.url + "====\n");
             }
			//
			addListeners(loader);
			try {
                loader.load(url_request);
            } catch (error:Error) {
                Tracer.str("[" + _name + "]\t"+" Unable to load requested document[" + service + "].\n");
				if(loadedHandler!=null){
					loadedHandler(false);
				}
				dispatchEvent(new Event("onError"));
            }
		}
		import flash.net.navigateToURL
		//直接打开接口地址
		public function jumpTo(_target:String="_self"):void
		{
			var url_request:URLRequest = new URLRequest();
			url_request.url = service;
			var fileType:String = service.toLowerCase().substr(service.length - 4, service.length);
			if (fileType == ".xml" || fileType == ".txt") {
				//用Get方法在静态文件后面加参数可能导致文件访问失败
			}else{
				url_request.data = request;
			}
			url_request.method = method;
			if(noCache){
				request.rnd=Math.random();
			}
			if(debug){
				Tracer.str("====jumpTo to server API: " + url_request.url + "====\n");
				if(method==DataService.POST){
					Tracer.obj(url_request.data);
				}else {
					Tracer.str(getFullURL(service, URLVariables(url_request.data)));
				}
             }
			 navigateToURL(url_request, _target);
		}
		private function getFullURL(_str:String,_request:URLVariables):String
		{
			if (_request == null) {
				return _str;
			}
			var vars:String=_request.toString();
			if (vars.length == 0) {
				return _str;
			}else {
				return _str + "?" + vars;
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
		public function set response(data:String):void
		{
			_response=data;
		}
		//获取返回的xml对象
		public function get responseXML():XML{
			return new XML(_response)
		}
		//获取返回的Object对象
		public function get responseObject():Object
		{
			return XMLEncoder.xml2Obj(responseXML);
		}
		//获取返回的JSON对象
		public function get responseJSON():Object
		{
			return com.adobe.serialization.json.JSON.decode(response);
		}
		public function get responseVariables():URLVariables
		{
			var _res:String=response.indexOf("&")==0?response.substr(1):response;
			return new URLVariables(_res);
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
			//自动转码成UFT8
			if(toUTF8){
				_response=UTF8Encoder.parseUtf8(_response);
			}
            if (debug) {
				Tracer.str(_name + " loaded\n"+dataMode);
				switch(dataMode) {
					case XML_MODE:
						Tracer.str(responseXML);
						break;
					case JSON_MODE:
						Tracer.str(response);
						Tracer.obj(responseJSON);
						break;
					case VAR_MODE:
						Tracer.obj(responseVariables);
						break;
					case TXT_MODE:
					default:
						Tracer.str(response);
						break;
				}
             	
            }
            removeListeners(loader);
            if(loadedHandler!=null){
				loadedHandler(true)
            }
            dispatchEvent(new Event("onLoad"));
        }
 		 private function securityErrorHandler(event:SecurityErrorEvent):void {
             Tracer.str(_name + "  securityErrorHandler: " + event+"\n");
             removeListeners(loader)
             if(loadedHandler!=null){
			 	loadedHandler(false)
             }
			 dispatchEvent(new Event("onError"));
        }
        private function ioErrorHandler(event:IOErrorEvent):void {
             Tracer.str(_name + "  ioErrorHandler: " + event+"\n");
             removeListeners(loader)
             if(loadedHandler!=null){
			 	loadedHandler(false)
             }
			 dispatchEvent(new Event("onError"));
        }


	}
}