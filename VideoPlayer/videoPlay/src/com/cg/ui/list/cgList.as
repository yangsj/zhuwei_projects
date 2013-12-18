package com.cg.ui.list 
{
	import com.cg.ui.bar.cgScrollBarV;
	import com.cg.ui.button.cgButtonGroup;
	import com.cg.ui.UI;
	import com.cg.utils.exCon;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.greensock.plugins.*;
	
	/**
	 * ...
	 * @author CG
	 */
	public class cgList extends UI 
	{
		private var _selected_data:Object;
		private var _selected_id:int;
		private var _data:Array;
		private var _items:Array=[];
		private var _item_con:Sprite;
		private var _scroll_bar:cgScrollBarV;
		private var _bg:Sprite;
		private var _list_num:int=5;
		private var _border:int=2;
		private var _item_height:int=22;
		private var _show_highlight:Boolean;
		private var _highlight_item:cgListItem;
		private var _rect:Rectangle;
		private var inited:Boolean;
		private var _selected_item:cgListItem;
		private var _label_name:String="label";
		public function cgList() 
		{
			super();
			_bg = this.getChildAt(0) as Sprite;
		}
		override protected function onAdd2Stage(e:Event):void 
		{
			super.onAdd2Stage(e);
			TweenPlugin.activate([ScrollRectPlugin]);
			fade_time = 0.1;
			init();
			addEventListener(MouseEvent.CLICK, onClick);
		}
		override protected function destroy(e:Event):void
		{
			super.destroy(e);
			removeEventListener(MouseEvent.CLICK, onClick);
		}
		private function init():void 
		{
			if(_rect==null){
				_rect = new Rectangle(0, 0, this.width, this.height);
			}
			scrollRect = _rect;
			_item_con = new Sprite();
			addChild(_item_con);
			_scroll_bar = new cgScrollBarV();
			_scroll_bar.mouse_wheel_height =
			_scroll_bar.step_size= _item_height + _border;
			addChild(_scroll_bar);
			resize();
			scaleX = scaleY = 1;
			inited = true;
			data = _data;
		}
		private function onClick(e:MouseEvent):void 
		{
			if (e.target is cgListItem) {
				_selected_item = e.target as cgListItem;
				_selected_data = data[_selected_item.id];
				_selected_id = _selected_item.id;
				//trace(_selected_data);
				if (_show_highlight) {
					highlight_item = _selected_item;
				}
				dispatchEvent(new Event(Event.SELECT));
			}
		}
		override public function set width(n:Number):void
		{
			if(_rect==null){
				_rect = new Rectangle(0, 0, this.width, this.height);
			}
			_rect.width = n;
			scaleX = 1;
			if (inited) {
				resize();
			}
		}
		public function resize():void
		{
			removeEventListener(Event.ENTER_FRAME, _resize);
			addEventListener(Event.ENTER_FRAME, _resize);
		}
		private function _resize(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, _resize);
			if (_list_num < _items.length) {
				_rect.height = _list_num * _item_height + (_list_num + 1) * _border;
			}else {
				_rect.height = _items.length * _item_height + (_items.length + 1) * _border;
			}
			_rect.height = Math.max(_item_height + _border * 2, _rect.height);
			scrollRect = _rect;
			//trace("_resize", scrollRect);	
			_bg.width = _rect.width;
			_bg.height = _rect.height;
			if (_item_con != null) {
				_item_con.x = _border;
				_item_con.y = _border;
			}
			if (_scroll_bar != null) {
				_scroll_bar.height = _rect.height - _border*2;
				_scroll_bar.x = _rect.width - _scroll_bar.width-_border;
				_scroll_bar.y = _border;
				if (_list_num < _items.length) {
					_scroll_bar.target = _item_con;
				}else {
					_scroll_bar.target = null;
				}
				_scroll_bar.target_width = _rect.width - _border * 3 - _scroll_bar.width;
				_scroll_bar.target_height = _rect.height - _border * 2;
			}
			updateItemsPosition();
		}
		private function updateItemsPosition():void
		{
			if (!inited) return;
			var _w:Number;
			var _len:int = _items.length;
			if (_list_num < _len) {
				_w = _scroll_bar.target_width;
			}else {
				_w = _rect.width - _border * 2;
			}
			for (var i:int = 0; i < _len; i++) {
				var _item:cgListItem = _items[i] as cgListItem;
				_item.width = _w;
				_item.y = (_item_height+_border)*i;
			}
			_scroll_bar.updateByTarget();
		}
		public function get data():Array 
		{
			return _data;
		}
		
		public function set data(value:Array):void 
		{
			_data = value;
			if (inited) {
				clear();
				if (_data == null) return;
				var len:int = _data.length;
				for (var i:int = 0; i < len; i++) {
					var _item:cgListItem = new cgListItem(i,_data[i],_label_name);
					_item_con.addChild(_item);
					_items.push(_item);
				}
				_scroll_bar.percent = 0;
				resize();
			}
		}
		
		public function get list_num():int 
		{
			return _list_num;
		}
		
		public function set list_num(value:int):void 
		{
			_list_num = value;
			if(inited) resize();
		}
		
		public function get highlight_item():cgListItem 
		{
			return _highlight_item;
		}
		
		public function set highlight_item(value:cgListItem):void 
		{
			if (_highlight_item) {
				_highlight_item.highLight = false;
			}
			_highlight_item = value;
			if (_highlight_item) {
				_highlight_item.highLight = true;
			}
		}
		
		public function get show_highlight():Boolean 
		{
			return _show_highlight;
		}
		
		public function set show_highlight(value:Boolean):void 
		{
			_show_highlight = value;
		}
		
		public function get selected_data():Object 
		{
			return _selected_data;
		}
		
		public function get selected_id():int 
		{
			return _selected_id;
		}
		
		public function get selected_item():cgListItem 
		{
			return _selected_item;
		}
		
		public function get label_name():String 
		{
			return _label_name;
		}
		
		public function set label_name(value:String):void 
		{
			_label_name = value;
			if (inited) {
				var len:int = _items.length;
				for (var i:int = 0; i < len; i++) {
					var _item:cgListItem = _items[i] as cgListItem;
					_item.label_name = _label_name;
				}
			}
		}
		public function clear():void
		{
			exCon.removeAllChild(_item_con);
			_items = new Array();
			_scroll_bar.percent = 0;
		}


		public function scrollIn(_y:Number,_delay:Number=0, handler:Function=null):void
		{
			TweenMax.killTweensOf(this);
			alpha = 1;
			visible = true;
			scrollRect = _rect;
			TweenMax.from(this, fade_time, { delay:_delay,y:_y,scrollRect:{bottom:0},onComplete:handler} );
		}
		public function scrollOut(_y:Number,_delay:Number=0, handler:Function=null):void
		{
			TweenMax.killTweensOf(this);
			TweenMax.to(this, fade_time, { delay:_delay, y:_y,scrollRect:{bottom:0}, onComplete:function() {
				visible = false;
				alpha = 0;
				scrollRect = _rect;
				if(handler!=null){
					handler()
				}
			}} );
		}
	}

}