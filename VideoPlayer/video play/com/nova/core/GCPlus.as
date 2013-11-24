package com.nova.core
{
    import flash.net.SharedObject;
    import flash.system.System;
    import flash.utils.clearInterval;
    import flash.utils.setInterval;   
	public class GCPlus
	{
        public static function clear(isTraceTM : Boolean = false) : void {

                var time : int = 2;

                var interval : int = setInterval(loop, 50);

                function loop() : void {

                        if(!(time--)) {

                                isTraceTM && trace(System.totalMemory);

                                clearInterval(interval);

                                return;

                        }

                        SharedObject.getLocal("cypl", "/");

                }

        }
	}
}