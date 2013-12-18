package com.cg.ui.txt 
{
	import com.adobe.utils.StringUtil;
	import com.cg.ui.UI;
	import com.cg.utils.exString;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.text.*;
	/**
	 * ...
	 * @author cg
	 */
	public class cgInput extends UI 
	{
		public static const EMAIL:String = "email";
		public static const PHONE_NUMBER:String = "phoneNumber";
		public static const NUMBER:String = "number";
		public static const DOUBLE:String = "double";
		public static const INTEGER:String = "integer";
		public static const ENGLISH:String = "english";
		public static const CHINESE:String = "chinese";
		public static const DOUBLE_CHAR:String = "doubleChar";
		public static const HAS_CHINESE_CHAR:String = "hasChineseChar";
		public static const URL:String = "url";
		public static const OTHER:String = "other";
		
		public static const WARNING_EMAIL:String = "Email地址格式不正确";
		public static const WARNING_PHONE_NUMBER:String = "电话号码格式不正确";
		public static const WARNING_NUMBER:String = "数字格式不正确";
		public static const WARNING_DOUBLE:String = "双精度浮点数格式不正确";
		public static const WARNING_INTEGER:String = "整数型格式不正确";
		public static const WARNING_ENGLISH:String = "只能输入英文字符";
		public static const WARNING_CHINESE:String = "只能输入中文字符";
		public static const WARNING_DOUBLE_CHAR:String = "只能输入双字节字符";
		public static const WARNING_HAS_CHINESE_CHAR:String = "必须至少输入一个中文字符";
		public static const WARNING_URL:String = "URL地址格式不正确";
		public static const WARNING_OTHER:String = "数据输入不正确";
		
		
		public var validFunction:Function;
		
		protected var _text:String="";
		protected var __txt:TextField;
		protected var __txt_width:Number;
		
		protected var _font:String = "_sans";
		protected var _font_size:int = 12;
		protected var _font_color:int = 0;
		protected var _align:String = TextFieldAutoSize.NONE;
		protected var _restrict:String;
		protected var _password:Boolean;
		protected var _warn_string:String;
		protected var _warning_color:int=0xFF0000;
		protected var _auto_warning:Boolean = false;
		//有效性提示文字，如果为空，waining会自动创建
		protected var _warning:String = "";
		protected var _valid_type:String;
		protected var _valid:Boolean;
		protected var _must:Boolean=false;
		protected var _editable:Boolean = true;
		//默认出现的文字为提示文字
		protected var _fristTips:Boolean = false;
		protected var fmt:TextFormat;
		public function cgInput(__text:String=null)
		{
			super();
			if (__text != null) _text = __text;
			if(numChildren>0){
				__txt = this.getChildAt(0)  as TextField;
			}
			if (__txt == null) {
				__txt = new TextField();
				__txt.height = 22;
				addChild(__txt);
			}
			__txt.wordWrap = true;
			__txt.autoSize = "left";
			fmt = new TextFormat(_font, _font_size, _font_color);
			addEventListener(Event.ADDED_TO_STAGE, onAdd2Stage);
		}
		override protected function onAdd2Stage(e:Event):void 
		{
			super.onAdd2Stage(e);
			init();
		}
		override protected function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,destroy);
			__txt.removeEventListener(FocusEvent.FOCUS_IN, onTxtFocusIn);
			__txt.removeEventListener(FocusEvent.FOCUS_OUT, onTxtFocusOut);
			fmt = null;
			clear();
		}
		protected function init():void
		{
			__txt.type = TextFieldType.INPUT;
			__txt.autoSize = align;
			__txt.width = 
			__txt_width = width;
			scaleX=scaleY=1;
			__txt.defaultTextFormat = fmt;
			__txt.setTextFormat(fmt);
			text = _text;
			__txt.addEventListener(FocusEvent.FOCUS_IN, onTxtFocusIn);
			__txt.addEventListener(FocusEvent.FOCUS_OUT, onTxtFocusOut);
		}
		
		private function onTxtFocusIn(e:FocusEvent):void 
		{
			if (_fristTips) {
				_fristTips = false;
				_text = "";
			}
			password = _password;
			text = _text;
			toFull();
			font_color = _font_color;
		}
		
		private function onTxtFocusOut(e:FocusEvent):void 
		{
			if (stage.focus != __txt) {
				_text = __txt.text;
				toThumb();
				if (_auto_warning) {
					showWarning();
				}
			}
		}
		public function showWarning():void
		{
			valid = checkValid();
			if (!valid) {
				fmt.color = _warning_color;
				__txt.defaultTextFormat = fmt;
				__txt.setTextFormat(fmt);
				updateWarning(_warning);
				__txt.displayAsPassword = false;
				toThumb(_warn_string);
			}else {
				_warn_string = null;
			}
		}
		public function showUserWarning(_str:String):void
		{
			valid = false;
			fmt.color = _warning_color;
			__txt.defaultTextFormat = fmt;
			__txt.setTextFormat(fmt);
			updateWarning(_str);
			__txt.displayAsPassword = false;
			toThumb(_warn_string);
		}
		public function clear():void
		{
			text = "";
			warning = "";
		}
		override public function set width(n:Number):void
		{
			__txt.width = 
			__txt_width = n;
			scaleX = 1;
			toThumb();
		}
		public function set text(str:String):void
		{
			_text = str;
			if(stage!=null){
				if (stage.focus == __txt) {
					toFull();
				}else {
					toThumb();
				}
			}
		} 
		
		public function get text():String
		{
			return _text;
		}
		public function get font_color():int 
		{
			return _font_color;
		}
		
		public function set font_color(value:int):void 
		{
			_font_color = value;
			fmt.color = _font_color;
			__txt.defaultTextFormat = fmt;
			__txt.setTextFormat(fmt);
		}
		
		public function get font_size():int 
		{
			return _font_size;
		}
		
		public function set font_size(value:int):void 
		{
			_font_size = value;
			fmt.size = _font_size;
			__txt.defaultTextFormat = fmt;
			__txt.setTextFormat(fmt);
			__txt.height = __txt.textHeight + 2;
			toThumb();
		}
		
		public function get font():String 
		{
			return _font;
		}
		
		public function set font(value:String):void 
		{
			_font = exString.cutSpace(value) == ""?"_sans":value;
			fmt.font = _font;
			__txt.defaultTextFormat = fmt;
			__txt.setTextFormat(fmt);
			toThumb();
		}
		
		public function get max_chars():int 
		{
			return __txt.maxChars;
		}
		
		public function set max_chars(value:int):void 
		{
			__txt.maxChars = value;
		}
		public function get password():Boolean 
		{
			return _password;
		}
		
		public function set password(value:Boolean):void 
		{
			_password = value;
			if (fristTips) {
				__txt.displayAsPassword = false;
			}else{
				__txt.displayAsPassword = _password;
			}
		}
		public function get restrict():String 
		{
			return _restrict;
		}
		
		public function set restrict(value:String):void 
		{
			_restrict = exString.cutSpace(value) == ""?null:value;
			__txt.restrict = _restrict;
		}
		
		protected function updateWarning(value:String):void 
		{
			if (must && text == ""){
				_warn_string = "该项为必填项";
				return;
			}
			_warn_string = value;
			if(_warn_string==""){
				switch(_valid_type) {
					case CHINESE:
						_warn_string = WARNING_CHINESE;
						break;
					case DOUBLE:
						_warn_string = WARNING_DOUBLE;
						break;
					case DOUBLE_CHAR:
						_warn_string = WARNING_DOUBLE_CHAR;
						break;
					case EMAIL:
						_warn_string = WARNING_EMAIL;
						break;
					case ENGLISH:
						_warn_string = WARNING_ENGLISH;
						break;
					case HAS_CHINESE_CHAR:
						_warn_string = WARNING_HAS_CHINESE_CHAR;
						break;
					case INTEGER:
						_warn_string = WARNING_INTEGER;
						break;
					case NUMBER:
						_warn_string = WARNING_NUMBER;
						break;
					case PHONE_NUMBER:
						_warn_string = WARNING_PHONE_NUMBER;
						break;
					case URL:
						_warn_string = WARNING_URL;
						break;
					case OTHER:
						_warn_string = WARNING_OTHER;
						break;
					default:
						_warn_string = "无效的数据格式";
						break;
				}
			}
		}
		
		public function get warning_color():int 
		{
			return _warning_color;
		}
		
		public function set warning_color(value:int):void 
		{
			_warning_color = value;
		}
		
		public function get auto_warning():Boolean 
		{
			return _auto_warning;
		}
		
		public function set auto_warning(value:Boolean):void 
		{
			_auto_warning = value;
		}
		public function get warning():String 
		{
			return _warning;
		}
		
		public function set warning(value:String):void 
		{
			_warning = value;
		}
		public function get valid_type():String 
		{
			return _valid_type;
		}
		
		public function set valid_type(value:String):void 
		{
			_valid_type = value;
		}
		
		public function checkValid():Boolean 
		{
			//如果不是必填，可以为空
			if (text == "") {
				return !must;
			}
			switch(_valid_type) {
				case CHINESE:
					return StringUtil.isChinese(text);
				case DOUBLE:
					return StringUtil.isDouble(text);
				case DOUBLE_CHAR:
					return StringUtil.isDoubleChar(text);
				case EMAIL:
					return StringUtil.isEmail(text);
				case ENGLISH:
					return StringUtil.isEnglish(text);
				case HAS_CHINESE_CHAR:
					return StringUtil.hasChineseChar(text);
				case INTEGER:
					return StringUtil.isInteger(text);
				case NUMBER:
					return StringUtil.isNumber(text);
				case PHONE_NUMBER:
					return StringUtil.isChinaPhoneNumber(text);
				case URL:
					return StringUtil.isURL(text);
				case OTHER:
					//trace("自定义检查逻辑")
					if (validFunction != null) {
						return validFunction(text);
					}else {
						throw(new Error("检查函数validFunction未定义"));
					}
			}
			return true;
		}
		
		public function get must():Boolean 
		{
			return _must;
		}
		
		public function set must(value:Boolean):void 
		{
			_must = value;
		}
		
		public function get valid():Boolean 
		{
			return _valid;
		}
		
		public function set valid(value:Boolean):void 
		{
			_valid = value;
		}
		
		public function get editable():Boolean 
		{
			return _editable;
		}
		
		public function set editable(value:Boolean):void 
		{
			_editable = value;
			__txt.selectable = _editable;
		}
		
		public function get fristTips():Boolean 
		{
			return _fristTips;
		}
		
		public function set fristTips(value:Boolean):void 
		{
			_fristTips = value;
		}
		
		public function get align():String 
		{
			return _align;
		}
		
		public function set align(value:String):void 
		{
			_align = value;
			__txt.autoSize = _align;
		}
		
		
		
		public function toThumb(value:String=null):void
		{
			if (value == null) value = text;
			exString.getTextThumb(__txt, value, __txt_width);
			__txt.scrollH = 0;
			//__txt.autoSize = TextFieldAutoSize.NONE;
			//__txt.width = __txt_width;
		}
		public function toFull(value:String=null):void
		{
			if (value == null) value = text;
			__txt.width = __txt_width;
			__txt.text = value;
			__txt.scrollH = 0;
		}
	}

}