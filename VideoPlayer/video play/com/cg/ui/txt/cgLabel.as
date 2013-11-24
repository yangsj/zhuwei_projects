package com.cg.ui.txt
{
	import com.cg.ui.UI;
	import com.greensock.*;
	import com.greensock.easing.Linear;
	import com.greensock.plugins.*;
	
	import com.cg.utils.exString;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.text.*;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class cgLabel extends UI
	{
		public var speed:Number=1;
		public var targetWin:String="_blank";
		public var auto_flip_time:Boolean=true;
		public var flip_time:Number=2;
		public var flip_back_time:Number=0.2;
		public var flip_wait_time:Number=1;
		protected var _url:String="";
		protected var _label:String="";
		protected var __txt:TextField;
		protected var __txt_width:Number;
		protected var _auto_flip:Boolean = false;
		protected var _mouse_flip:Boolean = false;
		protected var _font:String = "_sans";
		protected var _font_size:int = 12;
		protected var _font_color:int = 0;
		protected var fmt:TextFormat;
		protected var inited:Boolean = false;
		public function cgLabel(__label:String=null)
		{
			super();
			if (__label != null) _label = __label;
			if(numChildren>0){
				__txt = this.getChildAt(0)  as TextField;
			}
			if (__txt == null) {
				__txt = new TextField();
				__txt.height = 22;
				addChild(__txt);
			}
			mouseChildren=false;
			area = new Rectangle(0, 0, width, height);
			TweenPlugin.activate([AutoAlphaPlugin]);
			addEventListener(Event.ADDED_TO_STAGE, onAdd2Stage);
		}
		override protected function onAdd2Stage(e:Event):void 
		{
			super.onAdd2Stage(e);
			init();
		}
		override protected function destroy(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			TweenMax.killTweensOf(this);
			TweenMax.killTweensOf(__txt);
			
			removeEventListener(MouseEvent.ROLL_OVER,onOver);
			removeEventListener(MouseEvent.ROLL_OUT,onOut);
			removeEventListener(MouseEvent.CLICK, onClick);
		}
		protected function init():void
		{
			__txt.autoSize=TextFieldAutoSize.NONE;
			__txt.width = 
			__txt_width = width;
			scaleX=scaleY=1;
			fmt = new TextFormat(_font, _font_size, _font_color);
			__txt.defaultTextFormat = fmt;
			__txt.setTextFormat(fmt);
			__txt.text = _label;
			toThumb();
			if (_mouse_flip) {
				startMouseOnFlip();
			}else {
				removeMouseOnFlip();
				if(_auto_flip){
					startFlip();
				}else{
					stopFlip();
				}
			}
			if (_url == "" || _url == null) {
				buttonMode = false;
				removeEventListener(MouseEvent.CLICK, onClick);
			}else {
				buttonMode = true;
				addEventListener(MouseEvent.CLICK, onClick);
			}
			inited = true;
		}
		override public function set width(n:Number):void
		{
			__txt_width = n;
			area = new Rectangle(0, 0, n, height);
			scaleX = 1;
			//toThumb();
			updateFlipStatus();
		}
		public function set area(r:Rectangle):void
		{
			this.scrollRect = r;
			if(inited){
				toThumb();
			}
		}
		public function get area():Rectangle
		{
			return this.scrollRect;
		}
		public function set label(str:String):void
		{
			_label = str;
			if(inited){
				__txt.text = _label;
				updateFlipStatus();
			}
		} 
		
		public function get label():String
		{
			return _label;
		}
		public function set auto_flip(b:Boolean):void
		{
			_auto_flip = b;
			if(inited){
				if(_auto_flip){
					startFlip();
				}else{
					stopFlip();
				}
			}
		}
		public function get auto_flip():Boolean
		{
			return _auto_flip;
		}
		
		public function get mouse_flip():Boolean 
		{
			return _mouse_flip;
		}
		
		public function set mouse_flip(value:Boolean):void 
		{
			_mouse_flip = value;
			if(inited){
				if (_mouse_flip) {
					startMouseOnFlip();
				}else {
					removeMouseOnFlip();
				}
				toThumb();
			}
		}
		
		public function get font_color():int 
		{
			return _font_color;
		}
		
		public function set font_color(value:int):void 
		{
			_font_color = value;
			if(inited){
				fmt.color = _font_color;
				__txt.defaultTextFormat = fmt;
				__txt.setTextFormat(fmt);
			}
		}
		
		public function get font_size():int 
		{
			return _font_size;
		}
		
		public function set font_size(value:int):void 
		{
			_font_size = value;
			if(inited){
				fmt.size = _font_size;
				__txt.defaultTextFormat = fmt;
				__txt.setTextFormat(fmt);
				__txt.height = font_size+10;
				area = new Rectangle(0, 0, area.width, height);
				updateFlipStatus();
			}
		}
		
		public function get font():String 
		{
			return _font;
		}
		
		public function set font(value:String):void 
		{
			_font = exString.cutSpace(value) == ""?"_sans":value;
			if(inited){
				fmt.font = _font;
				__txt.defaultTextFormat = fmt;
				__txt.setTextFormat(fmt);
				toThumb();
			}
		}
		
		public function get url():String 
		{
			return _url;
		}
		
		public function set url(value:String):void 
		{
			_url = value;
			if (_url == "" || _url == null) {
				buttonMode = false;
				removeEventListener(MouseEvent.CLICK, onClick);
			}else {
				buttonMode = true;
				addEventListener(MouseEvent.CLICK, onClick);
			}
		}
		public function startMouseOnFlip():void
		{
			stopFlip();
			toFull();
			if(__txt.textWidth<area.width){
				__txt.text=_label;
				return
			}
			if(auto_flip_time){
				flip_time = (__txt.width - area.width) * .02 * speed;
			}
			toThumb();
			addEventListener(MouseEvent.ROLL_OVER,onOver);
			addEventListener(MouseEvent.ROLL_OUT,onOut);
		}
		public function removeMouseOnFlip():void
		{
			stopFlip();
			toThumb();
			removeEventListener(MouseEvent.ROLL_OVER,onOver);
			removeEventListener(MouseEvent.ROLL_OUT,onOut);
		}
		public function stopFlip():void
		{
			TweenMax.killTweensOf(__txt);
			resetPos();
		}
		public function resetPos():void
		{
			__txt.x=0;
		}
		public function startFlip(loop:Boolean=true):void
		{
			toFull();
			if (__txt.width < area.width) {
				return
			}
			stopFlip();
			__txt.x = 0;
			TweenMax.to(__txt,flip_time,{ease:Linear.easeIn,
										x:area.width - __txt.width,
										delay:_mouse_flip?0:flip_wait_time,
										onUpdate:onFlip,
										onComplete:loop?flipFinish:null})
		}
		protected function updateFlipStatus():void
		{
			mouse_flip = _mouse_flip;
			if(!_mouse_flip){
				auto_flip = _auto_flip;
			}
		}
		protected function onFlip():void
		{
		}
		protected function flipFinish():void
		{
			TweenMax.to(__txt,flip_back_time,{x:0,
									delay:flip_wait_time,
									onUpdate:onFlip,
									onComplete:startFlip})
		}
		protected function onOver(evt:MouseEvent):void
		{
			startFlip(false);
		}
		protected function onOut(evt:MouseEvent):void
		{
			toThumb();
			TweenMax.to(__txt,flip_back_time,{x:0,onUpdate:onFlip});
		}
		protected function onClick(evt:MouseEvent):void
		{
			navigateToURL(new URLRequest(url), targetWin);
		}
		protected function toThumb():void
		{
			if (_auto_flip) return;
			if(__txt.textWidth<area.width){
				__txt.text=_label;
			}else{
				exString.getTextThumb(__txt,label,area.width);
			}
			__txt.autoSize = TextFieldAutoSize.NONE;
			__txt.width = area.width;
		}
		protected function toFull():void
		{
			__txt.autoSize = TextFieldAutoSize.LEFT;
			__txt.text = label;
		}
	}
}