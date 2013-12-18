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
	public class WebServiceArgument
	{	
		private var _name:String;
		private var _type:String;
		
		private var _isSimpleType:Boolean = false;
		
		public function WebServiceArgument(param_name:String, param_type:String = "", isSimpleType:Boolean = false)
		{
			_name = param_name
			_type = param_type
			
			_isSimpleType = isSimpleType;
		}	
		
		/**
		* Get name of WebServiceArgument
		* 
		* @return	Name of WebServiceArgument
		*/		
		public function get name():String
		{
			return _name;
		}
		
		/**
		* Get type of WebServiceArgument
		* 
		* @return	Type of WebServiceArgument
		*/
		public function get type():String
		{
			return _type.split(":")[1];
		}
		
		/**
		* Is SimpleType?
		* 
		* @return	True if SimpleType
		*/			
		public function isSimpleType():Boolean
		{
			return _isSimpleType;
		}
		
		/**
		* Is WebServiceArgument a reference type
		* 
		* @return	True if reference
		*/			
		public function isReference():Boolean
		{
			return _type.split(":")[0] == "tns";
		}
		
		/**
		* Is WebServiceArgument an Array type
		* 
		* @return	True if Array
		*/		
		public function isArray():Boolean
		{
			return isReference() && _type.split(":")[1].indexOf("Array") == 0;
		}		
	}
}
