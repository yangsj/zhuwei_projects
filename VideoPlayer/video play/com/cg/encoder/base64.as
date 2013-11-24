package com.cg.encoder
{
	 public class base64 extends Object
    {
 
   public static function encode(opString:String):String {
       var str:String=opString;
       var base64s:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
       var bits, dual, i:int = 0, 
	   var encOut:String = '';
       while (str.length>=i+3) {
           bits = (str.charCodeAt(i++) & 0xff) << 16 | (str.charCodeAt(i++) & 0xff) << 8 | str.charCodeAt(i++) & 0xff;
           encOut += base64s.charAt((bits & 0x00fc0000) >> 18)+base64s.charAt((bits & 0x0003f000) >> 12)+base64s.charAt((bits & 0x00000fc0) >> 6)+base64s.charAt((bits & 0x0000003f));
       }
       if (str.length-i>0 && str.length-i<3) {
           dual = Boolean(str.length-i-1);
           bits = ((str.charCodeAt(i++) & 0xff) << 16) | (dual ? (str.charCodeAt(i) & 0xff) << 8 : 0);
           encOut += base64s.charAt((bits & 0x00fc0000) >> 18)+base64s.charAt((bits & 0x0003f000) >> 12)+(dual ? base64s.charAt((bits & 0x00000fc0) >> 6) : '=')+'=';
       }
       return encOut;
   }
  
   public static function decode(opString:String):String {
       var str = opString;
       var base64s:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
       var bits, decOut :String= ''
	   var i:int = 0;
       for (i=0; i<str.length; i += 4) {
           bits = (base64s.indexOf(str.charAt(i)) & 0xff) << 18 | (base64s.indexOf(str.charAt(i+1)) & 0xff) << 12 | (base64s.indexOf(str.charAt(i+2)) & 0xff) << 6 | base64s.indexOf(str.charAt(i+3)) & 0xff;
           decOut += String.fromCharCode((bits & 0xff0000) >> 16, (bits & 0xff00) >> 8, bits & 0xff);
       }
       return decOut;
   }
	}
}