/////////////////////////////
//cgXML for AS3.0  flash9
//author chenlangeer
//ver 1.0
/////////////////////////////
package com.cg.encoder
{
	import com.adobe.serialization.json.JSON;
    public class XMLEncoder extends Object {
		private static var _arrays:Array;
		public static function xml2Obj(_xml:XML):Object
		{
			return parse(_xml);
		}
		public static function obj2Xml(obj:Object):XML
		{
			return XML(obj2XmlStr(obj));
		}
		public static function xml2JsonStr(_xml:XML):String
		{
			return com.adobe.serialization.json.JSON.encode(xml2Obj(_xml));
		}
        public static function obj2XmlStr(obj:Object):String
		{
			return parseObj( { result:obj } );
		}
		public static function parseObj(obj:Object, labelName:String="", labelDepth:int=-1, key:int=0):String {
			var str:String = "";
			var attribString:String = "";
			var childString:String = "";
			// XML header
			if (labelName) {
				if (isNaN(labelDepth)) {
					str = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
					labelDepth = 0;
				}
			} else {
				str = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
				labelDepth = -1;
			}
			// Step 1, find prototype in currently object
			for (var prot:* in obj) {
				switch (typeof (obj[prot])) {
				case "movieclip" :
				case "object" :
					if (obj[prot] is Array) {
						// Find child
						for (var i:* in obj[prot]) {
							childString += parseObj(obj[prot][i], prot, labelDepth+1);
						}
						break;
					}
					childString += parseObj(obj[prot], prot, labelDepth+1);
					break;
				case "string" :
					if (prot == "_content") {
						childString += parseObj(obj[prot], prot, labelDepth+1);
						break;
					}
				case "number" :
				case "boolean" :
				case "function" :
				default :
					attribString += " "+prot+"=\""+obj[prot]+"\"";
					break;
				}
			}
			// Step 2, check currently object
			switch (typeof (obj)) {
			case "movieclip" :
				attribString += " FLASH_MOVIECLIP";
				attribString += " alpha=\""+obj.alpha+"\"";
				attribString += " height=\""+obj.height+"\"";
				attribString += " name=\""+obj.name+"\"";
				attribString += " rotation=\""+obj.rotation+"\"";
				attribString += " visible=\""+obj.visible+"\"";
				attribString += " width=\""+obj.width+"\"";
				attribString += " x=\""+obj.x;
				attribString += " y=\""+obj.y+"\"";
				attribString += " xscale=\""+obj.xscale+"\"";
				attribString += " yscale=\""+obj.yscale+"\"";
			case "object" :
				break;
			case "string" :
				childString += __indent(labelDepth+1)+"<![CDATA["+obj+"]]>\n";
				break;
			case "number" :
			case "boolean" :
				childString += __indent(labelDepth+1)+obj+"\n";
				break;
			default :
				break;
			}
			// Step 3, generate XML
			if (labelName == "_content") {
				str += __indent(labelDepth)+"<![CDATA["+obj+"]]>\n";
			} else if (labelName) {
				if (childString) {
					str += __indent(labelDepth)+"<"+labelName+attribString+">\n";
					str += childString;
					str += __indent(labelDepth)+"</"+labelName+">\n";
				} else {
					str += __indent(labelDepth)+"<"+labelName+attribString+"/>\n";
				}
			} else {
				str += childString;
			}
			return str;
		}
        private static function parse(node:*):Object {
            var obj:Object = {};
            var numOfChilds:int = node.children().length();
            for(var i:int = 0; i<numOfChilds; i++) {
                var childNode:* = node.children()[i];
                var childNodeName:String = childNode.name();
                var value:*;
                if(childNode.children().length() == 1 && childNode.children()[0].name() == null) {
                    if(childNode.attributes().length() > 0) {
                        value = {
                            _content: childNode.children()[0].toString()
                        };
                        var numOfAttributes:int = childNode.attributes().length();
                        for (var j:int = 0; j < numOfAttributes; j++) {
							value[childNode.attributes()[j].name().toString()] = childNode.attributes()[j].toString();
                        }
                    } else {
                        value = childNode.children()[0].toString();
                    }
                } else {
                    value = parse(childNode);
                }
                if(obj[childNodeName]) {
                    if(getTypeof(obj[childNodeName]) == "array") {
                        obj[childNodeName].push(value);
                    } else {
                        obj[childNodeName] = [obj[childNodeName], value];
                    }
                } else if(isArray(childNodeName)) {
                    obj[childNodeName] = [value];
                } else {
                    obj[childNodeName] = value;
                }
            }
            numOfAttributes = node.attributes().length();          
            for (i = 0; i < numOfAttributes; i++) {
				obj[node.attributes()[i].name().toString()] = node.attributes()[i].toString();
            }
            if(numOfChilds == 0) {
                if(numOfAttributes == 0) {
                    obj = "";
                } else {
                    obj._content = "";
                }
            }
            return obj;
        }
        public static function get arrays():Array {
            if(!_arrays) {
                _arrays = [];
            }
            return _arrays;
        }
        public static function set arrays(a:Array):void {
            _arrays = a;
        }
        private static function isArray(nodeName:String):Boolean {
            var numOfArrays:int = _arrays ? _arrays.length : 0;
            for(var i:int=0; i<numOfArrays; i++) {
                if(nodeName == _arrays[i]) {
                    return true;
                }
            }
            return false;
        }
        private static function getTypeof(o:*):String {
            if(typeof(o) == "object") {
                if(o.length == null) {
                    return "object";
                } else if(typeof(o.length) == "number") {
                    return "array";
                } else {
                    return "object";
                }
            } else {
                return typeof(o);
            }
        }
		
		/**
		 * This function is a string format function.
		 */
		private static function __indent(num:Number):String {
			var str:String = "";
			for (var i:Number = 0; i<num; i++) {
				str += "\t";
			}
			return str;
		}
	}
}
