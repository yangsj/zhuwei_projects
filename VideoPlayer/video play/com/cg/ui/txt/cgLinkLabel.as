package com.cg.ui.txt
{
	import com.cg.ui.UI;
	import com.cg.utils.exString;
	import com.greensock.*;
	import com.greensock.easing.Linear;
	import com.greensock.plugins.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class cgLinkLabel extends UI
	{
		public var speed:Number=1;
		public var url:String="";
		public var targetWin:String="_blank";
		protected var _label:String="";
		protected var __txt:TextField;
		protected var line:MovieClip;
		protected var _font:String = "_sans";
		protected var _font_size:int = 12;
		protected var _font_color:int = 0;
		protected var fmt:TextFormat;
		public function cgLinkLabel()
		{
			super();
			__txt=this.getChildAt(1)  as TextField;
			__txt.autoSize="left";	
			
			line=this.getChildAt(0)  as MovieClip;
			line.stop();
			fmt = new TextFormat(_font, _font_size, _font_color);
			TweenPlugin.activate([AutoAlphaPlugin,FramePlugin]);
			
			addEventListener(Event.ADDED_TO_STAGE, onAdd2Stage);
		}
		override protected function onAdd2Stage(e:Event):void 
		{
			super.onAdd2Stage(e);
			init();
		}
		override protected function destroy(e:Event):void
		{
			TweenMax.killTweensOf(this);
			TweenMax.killTweensOf(line);
			removeEventListener(Event.REMOVED_FROM_STAGE,destroy);
			removeListener();
		}
		protected function init():void
		{
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			__txt.defaultTextFormat = fmt;
			__txt.setTextFormat(fmt);
			label = _label;
			addListener();
		}
		public function initData(__label:String,_url:String,_targetWin:String="_blank"):void
		{
			label=__label;
			url=_url;
			targetWin=_targetWin;
		}
		public function set label(str:String):void
		{
			_label=str;
			__txt.text=_label;
			line.width=__txt.width;
		}
		public function get label():String
		{
			return _label;
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
			__txt.height = __txt.textHeight + 4;
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
		}
		protected function addListener():void
		{
			mouseChildren=false;
			buttonMode=true;
			addEventListener(MouseEvent.ROLL_OVER,onOver);
			addEventListener(MouseEvent.ROLL_OUT,onOut);
			addEventListener(MouseEvent.CLICK,onClick);
		}
		protected function removeListener():void
		{
			buttonMode=false;
			removeEventListener(MouseEvent.ROLL_OVER,onOver);
			removeEventListener(MouseEvent.ROLL_OUT,onOut);
			removeEventListener(MouseEvent.CLICK,onClick);
		}
		protected function onOver(evt:MouseEvent):void
		{
			//trace(line,line.totalFrames)
			TweenMax.to(line,0.2,{frame:line.totalFrames});
		}
		protected function onOut(evt:MouseEvent):void
		{
			TweenMax.to(line,0.2,{frame:1});
		}
		protected function onClick(evt:MouseEvent):void
		{
			navigateToURL(new URLRequest(url),targetWin);
		}
	}
}