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

package com.cg.services.webservice.types
{
	public class WebServiceBinding
	{
		public var _name:String;
		
		private var _input_nms:Namespace = null;
		private var _output_nms:Namespace = null;
		
		private var _input_use:String;
		private var _output_use:String;
		
		public function WebServiceBinding(param_name:String)
		{
			_name = param_name;
		}
			
		/**
		* Add input Namespace URI
		* 
		* @param	URI as String
		*/		
		public function addInputNamespace(param_uri:String):void
		{
			if(param_uri.length > 0)
			{
				_input_nms = new Namespace(param_uri);
			}
		}
		
		/**
		* Add output Namespace URI
		* 
		* @param	URI as String
		*/		
		public function addOutputNamespace(param_uri:String):void
		{
			if(param_uri.length > 0)
			{
				_output_nms = new Namespace(param_uri);
			}
		}	
		
		/**
		* Add input use
		* 
		* @param	use
		*/		
		public function addInputUse(param_use:String):void
		{
			_input_use = param_use;
		}
		
		/**
		* Add output use
		* 
		* @param	use
		*/		
		public function addOutputUse(param_use:String):void
		{
			_output_use = param_use;
		}
		
		/**
		* Get input Namespace URI
		*/		
		public function getInputNamespace():Namespace
		{
			return _input_nms;
		}
		
		/**
		* Get output Namespace URI
		*/		
		public function getOutputNamespace():Namespace
		{
			return _output_nms;
		}	
		
		/**
		* Get input use
		*/		
		public function getInputUse():String
		{
			return _input_use;
		}
		
		/**
		* Get output use
		*/		
		public function getOutputUse():String
		{
			return _output_use;
		}		
	}
}
