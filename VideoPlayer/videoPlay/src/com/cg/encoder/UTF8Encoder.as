package com.cg.encoder
{

	import flash.utils.ByteArray;
    public class UTF8Encoder extends Object
    {
        static public function encode(str:String) : String
        {
            var out_str:String;
            var i:Number;
            var code:Number;
            out_str = new String();
            i = 0;
            while (i++ < str.length)
            {
                code = str.charCodeAt(i);
                if (code < 128)
                {
                    out_str = out_str + String.fromCharCode(code);
                    continue;
                }
                if (code > 127 && code < 2048)
                {
                    out_str = out_str + String.fromCharCode(code >> 6 | 192);
                    out_str = out_str + String.fromCharCode(code & 63 | 128);
                    continue;
                }
                out_str = out_str + String.fromCharCode(code >> 12 | 224);
                out_str = out_str + String.fromCharCode(code >> 6 & 63 | 128);
                out_str = out_str + String.fromCharCode(code & 63 | 128);
            }
            return out_str;
        }
        /*解决中文乱码问题
         	 	parseUtf8("你")//你
				parseUtf8("Áõ¼ÎÁÁ")//刘嘉亮
        */
        static public function parseUtf8(str:String):String
		{
		    if (str != null)
		    {
		     var oriByteArr:ByteArray=new ByteArray();
		     oriByteArr.writeUTFBytes(str);
		     var needEncode:Boolean=false;
		     for (var i:int=0; i<oriByteArr.length; i+= 2)
		     {
		
		      if (oriByteArr[i] == 195 || oriByteArr[i] == 194)
		      {
		       needEncode=true;
		       break;
		      }
		      if (oriByteArr[i] == 32)
		      {
		       i--;
		      }
		     }
		     if (needEncode)
		     {
		      var tempByteArr:ByteArray=new ByteArray;
		      for (i=0; i<oriByteArr.length; i++)
		      {
		       if (oriByteArr[i] == 194)
		       {
		        tempByteArr.writeByte(oriByteArr[i + 1]);
		        i++;
		       } else if (oriByteArr[i] == 195)
		       {
		        tempByteArr.writeByte(oriByteArr[i + 1] + 64);
		        i++;
		       } else
		       {
		        tempByteArr.writeByte(oriByteArr[i]);
		       }
		      }
		      tempByteArr.position=0;
		      return tempByteArr.readMultiByte(tempByteArr.bytesAvailable,"chinese");
		     } else
		     {
		      return str;
		     }
		    } else
		    {
		     return "";
		    }
		   }
    }
}
