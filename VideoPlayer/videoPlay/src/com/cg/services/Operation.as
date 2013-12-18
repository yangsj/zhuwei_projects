/**
 * @author Pieter Michels / wellconsidered
 *
 * Open source under the GNU Lesser General Public License (http://www.opensource.org/licenses/lgpl-license.php)
 * Copyright © 2009 Pieter Michels / wellconsidered
 * 
 * This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License 
 * as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.
 * This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License along with this library; 
 * if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 
 */
 
package com.cg.services
{
	import com.cg.services.events.OperationEvent;
	import com.cg.services.webservice.*;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.*;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	/**
	 *  Dispatched when Webservice call is completed
	 *
	 *  @eventType com.cg.services.events.OperationEvent.COMPLETE
	 */
	[Event(name="complete", type="com.cg.services.events.OperationEvent")]
	
	/**
	 *  Dispatched when Webservice called generated an error on client-side but it will be most of the time a server-side issue
	 *
	 *  @eventType com.cg.services.events.OperationEvent.FAILED
	 */
	[Event(name="failed", type="com.cg.services.events.OperationEvent")]

	dynamic public class Operation extends Proxy
	{
		private var ws:WebService;
		private var eventDispatcher:EventDispatcher;

		private var method_name:String;
		private var method_args:Array;

		private var url_loader:URLLoader;
		private var url_request:URLRequest;
		
		public var data:XML;

		public function Operation(param_ws:WebService)
		{
			ws = param_ws;

			eventDispatcher = new EventDispatcher();

			// PREPARE METHOD CALLING
			url_request = new URLRequest(ws.url);
			url_request.contentType = "text/xml; charset=utf-8";
			url_request.method = URLRequestMethod.POST;

			url_loader = new URLLoader();
			url_loader.dataFormat = URLLoaderDataFormat.TEXT;
			url_loader.addEventListener(Event.COMPLETE, onServiceLoaded);
			url_loader.addEventListener(IOErrorEvent.IO_ERROR, onServiceFailed);
		}

		public function loadMethod():void
		{
			var new_call:WebServiceCall = new WebServiceCall(method_name, ws.getMethodCollection(), ws.getMethodCollection().targetNameSpace, method_args);

			// url_request.requestHeaders.push(new URLRequestHeader("Content-Type", "application/soap+xml"));
			url_request.requestHeaders.push(new URLRequestHeader("Content-Type", "text/xml; charset=utf-8"));
			url_request.requestHeaders.push(new URLRequestHeader("SOAPAction", createSoapAction(ws.getMethodCollection().targetNameSpace) + method_name));

			url_request.data = new_call.call;

			url_loader.load(url_request);
		}
		
		private function createSoapAction(sAction:String):String
		{
			var isSlash:Boolean = (sAction.lastIndexOf("/") == -1 || sAction.lastIndexOf("/") < sAction.length - 2);

			return sAction + (isSlash ? "/" : "");
		}

		private function onServiceLoaded(e:Event):void
		{
			var _data = new XML(url_loader.data);
			var soap_nms:Namespace = _data.namespace();
			data = _data.soap_nms::Body.children()[0];
			
			try
			{
				var response:WebServiceResponse = new WebServiceResponse(_data, ws.getMethodCollection());

				dispatchEvent(new OperationEvent(OperationEvent.COMPLETE, response.data));
			}
			catch (e:Error)
			{
				trace("ERROR: Webservice returned Faulty XML " + e.getStackTrace() );

				dispatchEvent(new OperationEvent(OperationEvent.FAILED, e));
			}

			url_loader.data = null;
		}

		private function onServiceFailed(e:IOErrorEvent):void
		{
			dispatchEvent(new OperationEvent(OperationEvent.FAILED, e));
		}

		flash_proxy override function getProperty(param_method:*):* { }

		flash_proxy override function callProperty(param_method:* , ... args):*
		{
			method_name = param_method;
			method_args = args;

			if(ws.loaded)
			{
				if(ws.getMethodCollection().methodExists(method_name))
					loadMethod();
			}
			else
				ws.addOperationToQeue(this);
		}

		/**
		* Get method name
		*
		* @return	Name of the method
		*/
		public function get method():String
		{
			return method_name;
		}

		/**
		* Get arguments of method
		*
		* @return	Array of arguments
		*/
		public function get args():Array
		{
			return method_args;
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0):void { eventDispatcher.addEventListener(type, listener, useCapture, priority); }
		public function dispatchEvent(event:Event):Boolean { return eventDispatcher.dispatchEvent(event); }
		public function hasEventListener(type:String):Boolean { return eventDispatcher.hasEventListener(type); }
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void { eventDispatcher.removeEventListener(type, listener, useCapture); }
		public function willTrigger(type:String):Boolean { return eventDispatcher.willTrigger(type); }
	}
}
