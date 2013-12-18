package com.cg.ui 
{
	/**
	 * 内容单元接口
	 * @author cg
	 */
	public interface ICell
	{
		function set data(o:Object):void
		function get data():Object
		function clone():ICell
	}

}