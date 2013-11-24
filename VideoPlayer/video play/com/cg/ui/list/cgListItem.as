package com.cg.ui.list 
{
	import com.cg.ui.IFocus;
	import com.cg.encoder.XMLEncoder;
	import com.cg.ui.button.cgBaseButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.TweenMax;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author CG
	 */
	public class cgListItem extends cgBaseButton implements IFocus 
	{
		public var id:int;
		protected var _data:Object;
		private var _label_name:String;
		private var bg:Sprite;
		/**
		 * 动画时间
		 * 
		 */
		public var motionTime:Number = .2;
		public function cgListItem(_id:int=0,__data:*=null,__label_name:String="label") 
		{
			super();
			id = _id;
			if (__data!=null) {
				_data=__data;
			}
			_label_name = __label_name;
			_label_TF = this.getChildAt(1) as TextField;
			bg = this.getChildAt(0) as Sprite;
		}
		override protected function onAdd2Stage(e:Event):void 
		{
			super.onAdd2Stage(e);
		}
		override protected function destroy(e:Event):void
		{
			super.destroy(e);
		}
		override protected function init():void 
		{
			super.init();
			if (data != null) {
				data = _data;
				if(data.label!=null){
					label = data.label;
				}else {
					label = "未定义label_name";
				}
			}
			cacheAsBitmap = true;
		}
		override protected function onOver(e:MouseEvent):void 
		{
			super.onOver(e);
			if (lock) return;
			TweenMax.to(this, motionTime, {colorMatrixFilter: { brightness:1.2 }} );
		}
		override protected function onOut(e:MouseEvent):void 
		{
			super.onOut(e);
			if (_highLight) {
				TweenMax.to(this, motionTime, {colorMatrixFilter: { brightness:1.5 }} );
			}else {
				TweenMax.to(this, motionTime, {colorMatrixFilter: { brightness:1 }} );
			}
		}
		override public function set width(value:Number):void
		{
			bg.width = value;
			_label_TF.width = bg.width - 4;
		}
		/**
		 * 高亮
		 * 
		 */
		override public function get highLight():Boolean 
		{
			return _highLight;
		}
		
		override public function set highLight(value:Boolean):void 
		{
			_highLight = value;
			TweenMax.to(this, motionTime, {colorMatrixFilter: { brightness:_highLight?1.5:1 }} );
		}
		public function get data():Object 
		{
			return _data;
		}
		/**
		 * 允许传入xml,object,number,string
		 * number和string会转换为{label:o,value:o}的格式
		 * 如果传入的xml或者object没有label值，将报错
		 */
		public function set data(o:Object):void 
		{
			switch(typeof(o)) {
				case "xml":
					_data = XMLEncoder.xml2Obj(o as XML);
					break;
				case "number":
					_data = { label:String(o) , value:o };
					break;
				case "string":
					_data = { label:o, value:o };
					break;
				default:
					_data = o;
			}
			//trace(_data, _data[_label_name]);
			if (_data[_label_name] != null) {
				_data.label = _data[_label_name];
			}
			/*
			if (_data.label == null) {
				throw(new Error("data中不存在label标签"));
			}
			*/
		}
		
		public function get label_name():String 
		{
			return _label_name;
		}
		
		public function set label_name(value:String):void 
		{
			_label_name = value;
			if (data != null) {
				if (_data[_label_name] != null) {
					_data.label = _data[_label_name];
					label = data.label;
				}
			}
		}
	}

}