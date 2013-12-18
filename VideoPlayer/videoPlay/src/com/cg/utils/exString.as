package com.cg.utils
{
	import flash.text.TextField;
	public class exString
	{
	//xml保留字 顺序不可改变
	private static const xml_chars:Array = ["<", ">", "\'", "\"","“","”","&"];
	private static const xml_safe_chars:Array = ["&lt;", "&gt;", "&apos;", "&quot;","&ldquo;","&rdquo","&amp;"];
	
	//辅助函数  替换字符串
	public static function replace(s_str:String, f_str:String, r_str:String):String {
		return s_str.split(f_str).join(r_str);
	}
	//裁剪头尾的空格和回车
	public static function cutSpace(_str:String):String {
		var len:Number = _str.length;
		var n:Number = 0;
		while ((_str.charAt(n) == " " || _str.charAt(n) == String.fromCharCode(13)) && n<len) {
			n++;
		}
		var m:Number = len-1;
		while ((_str.charAt(m) == " " || _str.charAt(m) == String.fromCharCode(13)) && m>=0) {
			m--;
		}
		if (m>=n) {
			return _str.substring(n, m+1);
		}
		return "";
	}
	//安全的xml字符
	public static function safeForXML(_str:String):Boolean {
		for (var c in xml_chars) {
			if (_str.indexOf(xml_chars[c]) != -1) {
				return false;
			}
		}
		return true;
	}
	//转换成xml转义符
	public static function toXmlSafeStr(_str:String):String {
		var out_str = _str;
		for (var c in xml_chars) {
			out_str = replace(out_str, xml_chars[c], xml_safe_chars[c]);
		}
		return out_str;
	}
	//还原xml转义符
	public static function fromXmlSafeStr(_str:String):String {
		var out_str = _str;
		for (var c in xml_chars) {
			out_str = replace(out_str, xml_safe_chars[c], xml_chars[c]);
		}
		return out_str;
	}
	//使用inset_char将_str补齐到char_num指定的位数
	public static function format(_str:String,char_num:Number,inset_char:String):String {
		var len=_str.length
		if(len>=char_num){
			return _str
		}
		var head=""
		for(var i=0;i<char_num-len;i++){
			head+=inset_char
		}
		return head+_str
	}
	//秒转化为字符串  12:04
	public static function secToStr(_n:Number):String {
		var m:Number = Math.floor(_n/60);
		var s:Number = _n%60;
		var m_str = String(m);
		var s_str = String(s);
		if (m<10) {
			m_str = "0"+m_str;
		}
		if (s_str<10) {
			s_str = "0"+s_str;
		}
		return m_str+":"+s_str;
	}
	//缩略文本
	public static function getThumb(_str:String, n:Number):String {
		if (_str.length<=n) {
			return _str;
		}
		return _str.substr(0, n-3)+" ...";
	}
	//直接设置TextField的缩略文本
	public static function getTextThumb(_txt:TextField, _str:String, _width:Number):void {
		var _w:Number = _txt.width;
		var _autoSize = _txt.autoSize;
		_txt.text="";
		_txt.multiline=false;
		_txt.autoSize="left";
		_txt.width=0;
		var n=0;
		while(_txt.width<_width){
			_txt.appendText(_str.substr(n,1));
			if(n>=_str.length){
				break
			}
			n++
		}
		if(n<_str.length){
			_txt.text=_txt.text.substr(0,n-1)+"..."
		}
		_txt.autoSize = _autoSize;
		_txt.width = Math.max(_txt.width, _w);
	}
	/////////////////////////////////////////////////
	//正则表达式匹配
	/////////////////////////////////////////////////
	//email有效性
	public static const reg_email:RegExp= /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
	//美国电话号码 (415-555-1212)
	public static const reg_US_PhoneNumber:RegExp=  /^\d{3}-\d{3}-\d{4}$/;
	
	
	public static function validate(str:String,pattern:RegExp):Boolean {
        var result:Object = pattern.exec(str);
        if(result == null) {
            return false;
        }
        return true;
    }
}
}