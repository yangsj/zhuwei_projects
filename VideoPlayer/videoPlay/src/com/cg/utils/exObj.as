package com.cg.utils 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author cg
	 */
	public class exObj 
	{
		
		static public function clone(source:Object): Object
		{
			var r:ByteArray = new ByteArray();
			r.writeObject(source);
			r.position = 0;
			return (r.readObject());
		}

		
	}

}