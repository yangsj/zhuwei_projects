package com.nova.core{
         public class readlrc {
         public function readlrcastime(mp3playtime:Number,gc:String):String {
                var qsd:int;//起始点
                var fhz:String;
				
                 for (var j:int=0; j < gc.length; j++) {
                              if (gc.charCodeAt(j) == 58) {
                                       if (int(gc.slice(j - 2,j)) * 60 + int(gc.slice(j + 1,j + 3)) == mp3playtime) {
                                                 var i:int=0;
                                                do {
                                                        i++;
                                                       if (gc.charCodeAt(j + i) == 93) {
                                                        qsd=j + i;
                                                           }
                                                        if (gc.charCodeAt(j + i) == 13) {
                                                                    fhz=gc.slice(qsd + 1,j + i);
                                                         }
                                               } while (gc.charCodeAt(j + i) != 13&&j+i<gc.length);
                                        }
                               }
                        }
                         return fhz;
                 }
           }
}