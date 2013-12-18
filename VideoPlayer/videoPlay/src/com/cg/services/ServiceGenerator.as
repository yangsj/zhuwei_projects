package com.cg.services 
{
	import com.cg.debug.Tracer;
	import com.adobe.utils.StringUtil;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.xml.XMLNode;
	/**
	 * ...
	 * @author cg
	 */
	public class ServiceGenerator extends EventDispatcher
	{
		
		public var config:XML;
		protected var config_path:String;
		
		public var serviceURL:String;
		public var method:String;
		public var responseType:String;
		
		public function ServiceGenerator(_config_path:String):void 
		{
			config_path = _config_path;
			var service:DataService = new DataService(_config_path, DataService.GET);
			service.onLoad = function(success:Boolean):void
			{
				if (success) {
					config = service.responseXML;
					_init();
					dispatchEvent(new Event(Event.INIT));
				}else {
					dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
				}
			}
			service.send();
		}
		
		protected function _init():void 
		{
			serviceURL = String(config.services.@url);
			method = String(config.services.@requestMethod).toUpperCase();
			switch(String(config.services.@responseType).toLowerCase()) {
				case "xml":
					responseType = DataService.XML_MODE;
					break;
				case "json":
					responseType = DataService.JSON_MODE;
					break;
				case "var":
					responseType = DataService.VAR_MODE;
					break;
				case "txt":
				default:
					responseType = DataService.TXT_MODE;
					break;
			}
			//trace("init::",config.services.@responseType+"|"+responseType)
		}
		/**
		 * 普通字符串类型的API
		 * @param	funcName 根据api的id值设置的接口ID
		 * @param	handler 回调函数，成功后回调handler(data:*)，失败时回调handler(null);
		 * @param	...arguments api接口参数，根据配置文件设置
		 */
		public function normalAPI(funcName:String, handler:Function, ...arguments):void
		{
			if (config.apis.api.(@id == funcName) == undefined) {
				throw(new Error("[normalAPI:" + funcName + "]未定义该API"));
			}
			arguments.unshift(funcName,handler);
			var ser:DataService = readyService.apply(null,arguments);
			ser.send();
		}
		/**
		 * 二进制数据提交接口
		 * @param	funcName 根据api的id值设置的接口ID
		 * @param	bytes 要提交的二进制流
		 * @param	handler 回调函数，成功后回调handler(data:*)，失败时回调handler(null);
		 * @param	...arguments api接口参数，根据配置文件设置
		 */
		public function bytesAPI(funcName:String, handler:Function, bytes:ByteArray, ...arguments):void
		{
			if (config.apis.api.(@id == funcName) == undefined) {
				throw(new Error("[bytesAPI:" + funcName + "]未定义该API"));
			}
			arguments.unshift(funcName, handler);
			var ser:DataService = readyService.apply(null,arguments);
			ser.sendBytes(bytes);
		}
		public function jumpToAPI(funcName:String, _target:String = "_self"):void
		{
			if (config.apis.api.(@id == funcName) == undefined) {
				throw(new Error("[bytesAPI:" + funcName + "]未定义该API"));
			}
			var ser:DataService = readyService(funcName,null);
			ser.jumpTo(_target);
		}
		private function readyService(funcName:String, handler:Function, ...arguments):DataService
		{			
			var api:XML = config.apis.api.(@id == funcName)[0] as XML;
			var n:int = api.request.length();
			var i:int;
			var _serviceURL:String = api.@service != undefined?api.@service.split("{servicesUrl}").join(serviceURL):serviceURL;
			var _method:String = (api.@requestMethod != undefined && StringUtil.trim(api.@requestMethod) != "")?String(api.@requestMethod).toUpperCase():method;
			var _responseType:String = (api.@responseType != undefined && StringUtil.trim(api.@responseType) != "")?String(api.@responseType).toLowerCase():responseType;
			//trace("readyService::",responseType)
			api.@responseType = _responseType;
			var ser:DataService = new DataService(_serviceURL, _method, _responseType);
			if (n>0) {
				for (i = 0; i < n; i++) {
					var req:XML = api.request[i];
					if (req.@type == "const") {
						ser.request[req.@id] = String(req.@data);
					}else {
						//使用输入的数据
						if (arguments[i] != null) {
							ser.request[req.@id] = arguments[i];
							//检查输入参数得类型
							if (typeof(arguments[i]) != String(req.@dataType)) {
								Tracer.str("[警告："+api.@name+"."+req.@id+"="+arguments[i]+"]输入参数与接口定义的参数类型不符合，尝试强制转换...");
							}
						}else {
							//使用默认数据
							ser.request[req.@id] = String(req.@data);
						}
					}
				}
			}
			
			//执行回调函数
			function doHandler():void
			{
				//trace("doHandler::", api.@responseType);
				switch(String(api.@responseType)) {
					case DataService.XML_MODE:
						handler(ser.responseXML);
						break;
					case DataService.JSON_MODE:
						handler(ser.responseJSON);
						break;
					case DataService.VAR_MODE:
						handler(ser.responseVariables);
						break;
					case DataService.TXT_MODE:
					default:
						handler(ser.response);
						break;
				}
			}			
			//返回模版数据
			function doTemplateHandler():void
			{
				if(api.responseTemplate!=undefined){
					//创建合适的数据对象
					ser.response=String(api.responseTemplate).split("<!{CDATA{").join("<![CDATA[").split("}}>").join("]]>");
					var n:int = api.request.length();
					if (n>0) {
						for (var i:int = 0; i < n; i++) {
							var req:XML = api.request[i];
							ser.response=ser.response.split("{"+req.@id+"}").join(ser.request[req.@id]);
						}
					}
					switch(String(api.@responseType)) {
						case DataService.XML_MODE:
							Tracer.str(ser.responseXML);
							break;
						case DataService.JSON_MODE:
							Tracer.obj(ser.responseJSON);
							break;
						case DataService.VAR_MODE:
							Tracer.obj(ser.responseVariables);
							break;
						case DataService.TXT_MODE:
						default:
							Tracer.str(ser.response);
							break;
					}
				}else{
					Tracer.str("["+api.@id+"]模拟数据未定义。");
				}
				doHandler();
			}
			
			ser.onLoad = function(b:Boolean):void
			{
				//Tracer.str("["+api.@id+"]"+api.@debugMode+"--");
				switch(String(api.@debugMode)){
					case "auto":
						if(b){
							doHandler();
						}else{
							Tracer.str("["+api.@id+"]无法加载，自动使用模拟数据:");
							doTemplateHandler();
						}
						break;
					case "template":
						Tracer.str("["+api.@id+"]强制使用模拟数据:");
						doTemplateHandler();
						break;
					case "service":
					default:
						if (b) {
							doHandler();
						}else{
							Tracer.str("["+api.@id+"]后台接口调用失败,未指定调试模式，如需使用模版数据，请指定api.@debugMode为'auto'或者'template'");
							handler(null)
						}
						break;
				}
			}
			return ser;
		}
	}

}