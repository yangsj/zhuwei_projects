package com.cg.ui.button 
{
	/**
	 * ...
	 * @author cg
	 */
	public interface IcgButton
	{
		/**
		 * 命名
		 * 
		 */
		function get name():String
		/**
		 * 锁定
		 * 
		 */
		function set lock(b:Boolean):void
		function get lock():Boolean
		/**
		 * 高亮
		 * 
		 */
		function set highLight(b:Boolean):void
		function get highLight():Boolean
	}

}