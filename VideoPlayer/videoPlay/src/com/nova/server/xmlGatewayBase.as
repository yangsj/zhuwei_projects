package com.nova.server
{
	import com.nova.server.events.xmlGatewayEvent;
	
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.events.*;
	////////////////////////////////////////////////////////////////////////////////
	// Compiler Meta
	////////////////////////////////////////////////////////////////////////////////
	/**
	*	@eventType com.nova.server.events.xmlGatewayEvent.MESSAGE_RECEIVED
	*/
	[Event(name="messageReceived", type="com.nova.server.events.xmlGatewayEvent")]
	
	public class xmlGatewayBase extends EventDispatcher
	{	
		public var httpURL:String;
		public var objectXML:XML;
		public var getIsRuning:Boolean;
		private var isNet:Boolean
		public function xmlGatewayBase(URL:String="",method:String="post",isN:Boolean=false,values:URLVariables=null,isDebug:Boolean=false)
		{
			super();
			httpURL=URL;
			isNet=isN;
			sendURL(httpURL,method,values,isDebug);	
					
		}
		public function sendURL(str:String,method:String="post",values:URLVariables=null,isDebug:Boolean=false):void{	
				var loader:URLLoader = new URLLoader();
				if(isNet){		
					var url:URLRequest = new URLRequest(str);
					if(method=="get") url.method = URLRequestMethod.GET;	
					else url.method = URLRequestMethod.POST;	
					url.data = values;
					loader.addEventListener(Event.COMPLETE,loaded);
					loader.addEventListener(IOErrorEvent.IO_ERROR,loadErr);
					loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,SECURITY_ERRORFun);
					
					if(isDebug) navigateToURL(url);
					else loader.load(url);		
				}else{
					url = new URLRequest(str);		
					loader.addEventListener(Event.COMPLETE,loaded);
					loader.addEventListener(IOErrorEvent.IO_ERROR,loadErr);
					loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,SECURITY_ERRORFun);

					loader.load(url);	
				}
				function loaded(e:Event){					
					
					dispatchEvent(new xmlGatewayEvent(xmlGatewayEvent.DATA_RECEIVED,loader.data));
				}			
				function loadErr(e:IOErrorEvent){
					trace("load error");
				}
				function SECURITY_ERRORFun(e:SecurityErrorEvent){
					trace("load SECURITY error");
				}
		}		
	}
}