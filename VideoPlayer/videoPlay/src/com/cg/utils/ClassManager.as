package com.cg.utils
{
	import flash.system.ApplicationDomain;
	public class ClassManager
	{
		static  public function getClass(p_name : String) : Class
		{
		    try
		    {
		        return ApplicationDomain.currentDomain.getDefinition(p_name) as Class;
		    } catch (p_e : ReferenceError)
		    {
		        trace("定义 " + p_name + " 不存在");
		        return null;
		    }
		    return null;
		}

	}
}