package com.cg.ui 
{
	/**
	 * 焦点接口，所有可以设置焦点的UI都需要有该接口
	 * @author cg
	 */
	public interface IFocus
	{
		function setFocus():void
		function killFocus():void
		function get isFocus():Boolean
	}

}