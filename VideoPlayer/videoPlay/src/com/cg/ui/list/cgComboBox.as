package com.cg.ui.list 
{
	import com.cg.ui.button.cgCheckButton;
	import com.cg.ui.list.cgList;
	import com.cg.ui.txt.cgInput;
	import com.cg.ui.UI;
	import com.cg.utils.DisplayObjectUtil;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	/**
	 * ...
	 * @author CG
	 */
	public class cgComboBox extends UI 
	{
		public static var LIST_UP:String = "_list_up";
		public static var LIST_DOWN:String = "_list_down";
		public static var CHANGE:String = "cg_combo_box_change";
		
		private var _data:Array;
		private var _select_data:Object;
		private var _text:String;
		private var _list:cgList;
		private var _bg:Sprite;
		private var _input:cgInput;
		private var _button:cgCheckButton;
		private var _border:int = 2;
		private var _list_dir:String;
		private var _editable:Boolean=false;
		private var _label_name:String="label";
		private var _list_num:int=5;
		private var _show_highlight:Boolean;
		public function cgComboBox() 
		{
			_bg = getChildAt(0) as Sprite;
			_input = getChildAt(1) as  cgInput;
			_button = getChildAt(2) as cgCheckButton;
			_input.font_color = 0xFFFFFF;
			
		}
		override protected function onAdd2Stage(e:Event):void
		{
			super.onAdd2Stage(e);
			width = width;
			_input.editable = _editable;
			scaleX = 1;
			if (_list != null) {
				stage.addChild(_list);
			}
			if(_data!=null){
				data = _data;
			}else {
				initList();
			}
			this.addEventListener(MouseEvent.CLICK, onButtonClick);
		}
		
		private function onStageClick(e:MouseEvent):void 
		{
			var _remove:Boolean = false;
			if (DisplayObjectUtil.isChildren(e.target as DisplayObject, this)) {
				if (_editable && e.target !=_button) {
					_remove = true;
				}
			}else if(DisplayObjectUtil.isChildren(e.target as DisplayObject,_list)) {
				
			}else {
				_remove = true;
			}
			if (_remove) {
				if(_list_dir==LIST_DOWN){
					_list.scrollOut(_list.y);
				}else {
					_list.scrollOut(_list.y + _list.height);
				}
				_button.selected = false;
			}
		}
		
		private function onButtonClick(e:MouseEvent):void 
		{
			if ((_editable && e.target == _button) || !_editable) {
				_button.selected = !_button.selected;
				if (_button.selected) {
					_list.width = DisplayObjectUtil.getRenderedWidth(this);
					var p:Point = localToGlobal(new Point(0, 0));
					_list.x = p.x;
					if(p.y + height > stage.stageHeight - _list.height){
						_list.y =p.y - _list.height;
						_list.scrollIn(p.y);
						_list_dir = LIST_UP;
					}else {
						_list.y = p.y + height;
						_list.scrollIn(_list.y);
						_list_dir = LIST_DOWN;
					}
					DisplayObjectUtil.topChild(stage,_list);
					stage.addEventListener(MouseEvent.CLICK, onStageClick);
				}else {
					if(_list_dir==LIST_DOWN){
						_list.scrollOut(_list.y);
					}else {
						_list.scrollOut(_list.y + _list.height);
					}
					stage.removeEventListener(MouseEvent.CLICK, onStageClick);
				}
			}
		}
		override protected function destroy(e:Event):void
		{
			super.destroy(e);
			stage.removeEventListener(MouseEvent.CLICK, onStageClick);
			if (_list) {
				DisplayObjectUtil.removeChild(_list);
				_list.removeEventListener(Event.SELECT, onSelect);
			}
		}
		override public function set width(value:Number):void
		{
			_bg.width = value;
			_input.width = value-_border * 3 - _button.width;
			_input.x = _border;
			_button.x = value-_border - _button.width;
			if(_list){
				_list.width = width;
				_list.resize();
			}
			scrollRect = new Rectangle(0, 0, _bg.width, _bg.height);
		}
		private function initList():void
		{
			if (_list == null) {
				_list = new cgList();
				_list.width = width;
				_list.list_num = _list_num;
				if(stage!=null){
					stage.addChild(_list);
				}
				_list.hide();
				_list.addEventListener(Event.SELECT, onSelect);
			}
		}
		
		private function onSelect(e:Event):void 
		{
			if(text!=_list.selected_item.label){
				text = _list.selected_item.label;
				_select_data=_list.selected_data;
				dispatchEvent(new Event(CHANGE));
			}
			if(_list_dir==LIST_DOWN){
				_list.scrollOut(_list.y);
			}else {
				_list.scrollOut(_list.y + _list.height);
			}
			_button.selected = false;
			
		}
		public function get editable():Boolean 
		{
			return _editable;
		}
		
		public function set editable(value:Boolean):void 
		{
			_editable = value;
			_input.editable = _editable;
		}
		
		public function get data():Array 
		{
			return _data;
		}
		
		public function set data(value:Array):void 
		{
			_data = value;
			initList();
			_list.label_name = _label_name;
			_list.data = data;
		}
		
		public function get text():String 
		{
			_text=_input.text;
			return _text;
		}
		
		public function set text(value:String):void 
		{
			_text = value;
			_input.text = _text;
		}
		
		public function get select_data():Object 
		{
			return _select_data;
		}
		
		public function get label_name():String 
		{
			return _label_name;
		}
		
		public function set label_name(value:String):void 
		{
			_label_name = value;
			if (_list != null)
			_list.label_name = _label_name;
		}
		
		public function get input():cgInput 
		{
			return _input;
		}
		
		public function get list_num():int 
		{
			return _list_num;
		}
		
		public function set list_num(value:int):void 
		{
			_list_num = value;
			if (_list != null) {
				_list.list_num = _list_num;
			}
		}
		
		public function get show_highlight():Boolean 
		{
			return _show_highlight;
		}
		
		public function set show_highlight(value:Boolean):void 
		{
			_show_highlight = value;
			if (_list != null) {
				_list.show_highlight = _show_highlight;
			}
		}
	}

}