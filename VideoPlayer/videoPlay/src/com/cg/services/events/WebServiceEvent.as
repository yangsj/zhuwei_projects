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

package com.cg.services.events
{
	import flash.events.Event;
	
	public class WebServiceEvent extends Event
	{	
		public static var INITFAILED:String = "initfailed";
		public static var INITED:String = "inited";
		
		private var _data:Object;
		
		function WebServiceEvent(param_event:String, param_data:Object = null)
		{
			super(param_event);
			
			_data = param_data;
		}
		
		/**
		* Get data of WebServiceEvent
		* 
		* @return	Object with data
		*/			
		public function get data():Object
		{
			return _data;
		}
	}
}
