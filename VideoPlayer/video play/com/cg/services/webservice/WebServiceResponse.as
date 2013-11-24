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

package com.cg.services.webservice
{
	import com.cg.services.webservice.types.*;
	
	public class WebServiceResponse
	{
		private var _resp_xml:XML;
		private var _data:Object;
		
		private var _method_name:String;
		private var _response_name:String;
		
		private var _method_col:WebServiceMethodCollection;
		
		public function WebServiceResponse(param_xml:XML, param_method_col:WebServiceMethodCollection)
		{
			_method_col = param_method_col;
			_resp_xml = param_xml;
			
			createResponseObject();
		}
		
		private function createResponseObject():void
		{
			var soap_nms:Namespace = _resp_xml.namespace();
			var default_nms:Namespace = new Namespace(_method_col.targetNameSpace);
			var body_resp_xml:XMLList = _resp_xml.soap_nms::Body.children();
			
			_response_name = body_resp_xml[0].localName();
			
			if(_method_col.isPortType())
			{			
				_data = castType(body_resp_xml.result, _method_col.getResponseObject(_response_name)._args[0].type);	
			}
			else
			{
				_method_name = _response_name.split("Response")[0];
			
				var resp_obj:WebServiceMethodResponse = _method_col.getResponseObject(_response_name);
				var result_xmllst:XMLList = body_resp_xml.default_nms::[_method_name + "Result"].children();
			
				_data = parseXMLList(result_xmllst, resp_obj);			
			}
		}
		
		private function parseXMLList(result_xmllst:XMLList, resp_obj:*):*
		{	
			if(resp_obj._args.length == 1)
			{
				var resp_wsa:WebServiceArgument = resp_obj._args[0];
				
				// OR 1 ITEM OR REFERENCE
				if(resp_wsa.isReference())
				{
					// TNS
					if(resp_wsa.isArray())
					{
						// ARRAY OF TNS OBJECT
						resp_obj = _method_col.getComplexObject(resp_wsa.type);
						
						var tmp:Array = new Array();
						
						for(var i:int = 0; i < result_xmllst.length(); i++)
						{
							tmp.push(parseXMLList(result_xmllst[i].children(), resp_obj));
						}
						
						return tmp;
					}
					else
					{
						resp_obj = _method_col.getComplexObject(resp_wsa.type);
						
						return parseXMLList(result_xmllst, resp_obj);
					}
				}
				else
				{
					if(result_xmllst.children().length() == 0)
					{
						// 1 ITEM
						return castType(result_xmllst[0], resp_wsa.type);
					}
					else
					{
						resp_obj = _method_col.getComplexObject(resp_wsa.type);
						
						var tmp_a:Array = new Array();
						
						for(var k:int = 0; k < result_xmllst.children().length(); k++)
						{
							// tmp_a.push(parseXMLList(result_xmllst.children()[k].children(), resp_obj));
							tmp_a.push(result_xmllst.children()[k]);
						}
						
						return tmp_a;
					}
				}
			}
			else
			{
				var obj:Object = new Object();
				var arr:Array = new Array();
				
				// MEERDERE PROPS
				for(var j:int = 0; j < result_xmllst.length(); j++)
				{	
					var tmp_a_wsa:WebServiceArgument = _method_col.getComplexObjectArgument(resp_obj._args, result_xmllst[j].localName());
					
					if(tmp_a_wsa == null)
					{
						arr.push(parseXMLList(result_xmllst[j].children(), resp_obj));	
					}
					else if(result_xmllst[j].children().length() > 1 || tmp_a_wsa.isArray())
					{
						var tmp_a_resp_obj:WebServiceComplexType = _method_col.getComplexObject(tmp_a_wsa.type);
						
						obj[tmp_a_wsa.name] = new Array();
						obj[tmp_a_wsa.name] = parseXMLList(result_xmllst[j].children(), tmp_a_resp_obj);
					}
					else
					{
						obj[tmp_a_wsa.name] = castType(result_xmllst[j], tmp_a_wsa.type);
					}
				}
				
				return arr.length> 0 ? arr : obj;
			}
		}
		
		private function createResObject(param_xmllst:XMLList, param_wsa:WebServiceArgument):Object
		{
			if(param_wsa.isReference())
			{
				return parseXMLList(param_xmllst, _method_col.getComplexObject(param_wsa.type));	
			}
			else
			{
				return castType(param_xmllst[0], param_wsa.type);
			}
		}
		
		private function castType(param_o:Object, param_t:String):*
		{
			switch(param_t.toLowerCase())
			{
				case "any":
				
					return param_o;
				
					break;
					
				case "boolean":
					
					return param_o.toString().toLowerCase() == "true" ? true : false;
						
					break;	
								
				case "int":
					
					return int(param_o);
						
					break;
					
				case "decimal":
				case "float":
				case "double":
				case "long":
				
					return Number(param_o);
						
					break;					
				
				case "string":
				default:
				
					return String(param_o);
			}
		}		
	
		/**
		* Get data
		* 
		* @return	Result object
		*/
		public function get data():Object
		{
			return _data;
		}
	}
}
