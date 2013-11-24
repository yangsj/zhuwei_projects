package com.cg.ui.bar 
{
	import com.cg.ui.button.cgButton;
	import com.cg.ui.UI;
	import com.greensock.easing.Strong;
	import com.greensock.TweenMax;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * 横向滚动条 horizontal scroll bar
	 * @author cg
	 */
	public class cgScrollBarH extends UI 
	{
		public var tween:Boolean=true;
		public var tween_time:Number = .2;
		
		protected var tween_obj:Object = { per:0 };
		
		protected var _target_name:String="";
		protected var _target_mask_name:String="";
		
		protected var _def_bar_width:Number;
		
		protected var _target_height:Number;
		protected var _target_width:Number;
		protected var _target_y:Number;
		protected var _target_x:Number;
		protected var _mouse_wheel_width:Number = 0;
		protected var _step_size:Number = 0;
		protected var _bar_auto_size:Boolean = true;
		protected var _use_mask:Boolean = true;
		
		
		protected var _target:DisplayObject;
		protected var _target_mask:DisplayObject;
		protected var _target_mask_con:Sprite;
		
		protected var scroll_rect:Rectangle;
		protected var bg:Sprite;
		protected var bar:cgButton;
		
		protected var _percent:Number=0;
		protected var old_percent:Number=0;
		
		public function cgScrollBarH() 
		{
			super();
			bg = this.getChildAt(0) as Sprite;
			bg.mouseChildren = false;
			
			bar = this.getChildAt(1) as cgButton;
			_def_bar_width = bar.width;
		}
		override protected function onAdd2Stage(e:Event):void 
		{
			super.onAdd2Stage(e);
			
			visible = false;
			alpha = 0;
			init();
		}
		override protected function destroy(e:Event):void
		{
			super.destroy(e);
			bar.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			bg.removeEventListener(MouseEvent.MOUSE_DOWN, onBgClick);
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			if(_target!=null){
				_target.parent.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			}
		}
		private function init():void
		{	
			_target_mask_con = new Sprite();
			_target_mask_con.graphics.beginFill(0, 1);
			_target_mask_con.graphics.drawRect(0, 0, 100, 100);
			_target_mask_con.graphics.endFill();
			_target_mask_con.visible=false;
			parent.addChild(_target_mask_con);
			_target_mask = _target_mask_con as DisplayObject;
			
			setTarget();
			setTargetMask();
			
			scroll_rect = new Rectangle(0, 0, bg.width - bar.width, 0);
			bar.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			bg.addEventListener(MouseEvent.MOUSE_DOWN, onBgClick);
			width = width;
		}
		
		private function onBgClick(e:MouseEvent):void 
		{
			var _per:Number = (mouseX - bar.width * .5) / (bg.width - bar.width);
			if (_target != null) {
				if(_target.width > _target_width && step_size > 0) {
					var _step_per:Number = step_size / (_target_width - _target.width);
					if(_per>old_percent){
						_per=Math.floor(_per / _step_per) * _step_per;
					}else if(_per<old_percent){
						_per=Math.ceil(_per / _step_per) * _step_per;
					}else {
						_per=Math.floor(_per / _step_per) * _step_per;
					}
					if (_per < 0) {
						_per = 0;
					}else if (_per > 1) {
						_per = 1;
					}
				}
			}
			TweenMax.to(this,.2,{percent:_per});
			//_onMouseDown(null);
		}
		
		private function _onMouseDown(e:MouseEvent):void 
		{
			bar.startDrag(false, scroll_rect);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		}
		
		private function _onMouseUp(e:MouseEvent):void 
		{
			bar.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			changeByStepSize();
		}
		
		private function _onMouseMove(e:MouseEvent):void 
		{
			old_percent = _percent;
			_percent = bar.x / scroll_rect.width;
			_percent = Math.min(1, _percent);
			_percent = Math.max(0, _percent);
			setTargetX();
		}
		protected function setTargetX():void
		{
			if (_target != null) {
				var _x:Number = (_target_width - _target.width) * _percent + _target_x;
				if (_target.width < _target_width) {
					_x = _target_x;
				}
				if (tween) {
					TweenMax.to(_target, tween_time, {ease:Strong.easeOut, x: _x} );
				}else{
					_target.x = _x;
				}
			}
		}
		protected function setTarget():void
		{
			if (parent == null) return;
			_target = this.parent.getChildByName(_target_name) as DisplayObject;
			if (_target != null) {
				_target_x = _target.x;
				_target_y = _target.y;
				if(_target_mask!=null) {
					_target.mask = _target_mask;
					_target_mask.y = _target.y;
					_target_mask.x = _target.x;
				}
				target_height = _target_height;
				target_width = _target_width;
				checkVisible();
				use_mask = _use_mask;
				mouse_wheel_width = _mouse_wheel_width;
			}
		}
		protected function setTargetMask():void
		{
			if (parent == null) return;
			var __target_mask:DisplayObject= this.parent.getChildByName(_target_mask_name) as DisplayObject;
			if (__target_mask != null) {
				if (_target_mask_con != null) {
					_target_mask_con.graphics.clear();
					_target_mask_con.parent.removeChild(_target_mask_con);
					_target_mask_con = null;
				}
				_target_mask = __target_mask;
				_target_mask.y = _target_y;
				_target_mask.x = _target_x;
				_target_mask.height = _target_height;
				_target_mask.width = _target_width;
				_target_mask.visible = false;
				if (_target != null) {
					_target.mask = _target_mask;
				}
			}
		}
		/**
		 * 根据步进值调整percent
		 */
		public function changeByStepSize():void
		{
			if (_target == null) return;
			if (_target.width > _target_width && step_size > 0) {
				var _step_per:Number = step_size / (_target_width - _target.width);
				var _per:Number;
				if(_percent>old_percent){
					_per=Math.floor(_percent / _step_per) * _step_per;
				}else if(_percent<old_percent){
					_per=Math.ceil(_percent / _step_per) * _step_per;
				}else {
					_per=Math.floor(_percent / _step_per) * _step_per;
				}
				if (_per < 0) {
					_per = 0;
				}else if (_per > 1) {
					_per = 1;
				}
				if(_per!=_percent){
					TweenMax.to(this, 0.2, { ease:Strong.easeOut, percent: _per } );
				}
			}
		}
		/**
		 * 当_target的y或者width被外部程序改变时，更新percent及滚动条
		 */
		public function updateByTarget():void
		{
			if (_target != null) {
				if (_bar_auto_size) {
					bar.width = Math.max(bg.width * .5,Math.min(1, _target_width / _target.width) * bg.width);
					scroll_rect.width = bg.width - bar.width;
				}
				if ( _target.width <= _target_width) {
					percent = 0;
				}else{
					percent = (_target_x - _target.x) / (_target.width-_target_width);
				}
			}
		}
		/**
		 * 重置百分比及目标y值
		 */
		public function reset():void
		{
			if(_target!=null){
				_target.x = _target_x;
			}
			percent = 0;
			target_height = _target_height;
			target_width = _target_width;
			checkVisible();
			TweenMax.killTweensOf(this, true);
			TweenMax.killTweensOf(bg);
		}
		/**
		 * 做像素移动
		 */
		public function offset(n:Number):void
		{
			if (_target != null) {
				old_percent = percent;
				percent = _percent + n / (_target.width-_target_width);
				changeByStepSize();
			}
		}
		/**
		 * 鼠标滚轮移动的距离，如果为0，不移动
		 */
		public function set mouse_wheel_width(n:Number):void
		{	
			_mouse_wheel_width = n;
			if (_target != null) {
				if (_mouse_wheel_width == 0 && _target.parent != null) {
					_target.parent.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
				}else {
					_target.parent.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
				}
			}
		}
		public function get mouse_wheel_width():Number
		{
			return _mouse_wheel_width;
		}
		private function onWheel(evt:MouseEvent):void
		{
			offset(- evt.delta / Math.abs(evt.delta) * _mouse_wheel_width );
		}
		/**
		 * 设置bar本身的宽度，bar的scaleX会重置为1
		 */
		override public function set width(n:Number):void
		{
			n = Math.max(20, n);
			scaleX = 1;
			bg.width = n;
			bar.width = Math.min(bg.width * .5, bar.width/bar.scaleX);
			scroll_rect.width = bg.width - bar.width;
			percent = _percent;
		}
		/**
		 * 设置滚动条的百分比
		 */
		public function set percent(_per:Number):void 
		{
			//trace(_per)
			if (_per > 1) {
				_per = 1;
			}else if (_per < 0) {
				_per = 0;
			}
			old_percent = _percent;
			_percent = _per;
			bar.x = scroll_rect.width * _percent;
			setTargetX();
		}
		
		public function get percent():Number 
		{
			return _percent;
		}
		
		/**
		 * 检查是否需要显示
		 */
		public function checkVisible():void
		{
			if (_target == null) return;
			if (_target.width <= _target_width) {
				fadeOut();
			}else {
				fadeIn();
			}
		}
		/**
		 * 设置滚动目标的名称，滚动目标必须和滚动条位于同一个容器内
		 */
		public function get target_name():String 
		{
			return _target_name;
		}
		
		public function set target_name(value:String):void 
		{
			_target_name = value;
			setTarget();
		}
		/**
		 * 设置滚动区域mask的名称，mask必须和滚动条位于同一个容器内，如果不指定，自动创建一个矩形区域
		 */
		public function get target_mask_name():String 
		{
			return _target_mask_name;
		}
		
		public function set target_mask_name(value:String):void
		{
			_target_mask_name = value;
			setTargetMask();
		}
		
		/**
		 * 设置滚动区域的宽度
		 */
		public function get target_height():Number 
		{
			return _target_height;
		}
		
		public function set target_height(value:Number):void 
		{
			if (_target == null) {
				_target_height = value;
			}else{
				_target_height = value <= 0?_target.height:value;
			}
			_target_mask.height = _target_height;
		}
		/**
		 * 设置滚动区域的宽度
		 */
		public function get target_width():Number 
		{
			return _target_width;
		}
		
		public function set target_width(value:Number):void 
		{
			if (_target != null) {
				_target_width = value <= 0?_target.width:value;
				if (_bar_auto_size) {
					bar.width = Math.max(bg.width * .5,Math.min(1, _target_width / _target.width) * bg.width);
					scroll_rect.width = bg.width - bar.width;
				}
				if (_target.width + _target.x < _target_x + _target_width && _target.width >= _target_width) {
					_target.x = _target_x + _target_width - _target.width;
				}
			}else {
				_target_width = value;
			}
			_target_mask.width = _target_width;
			percent = _percent;
			changeByStepSize();
			checkVisible();
		}
		/**
		 * 目标x位置
		 */
		public function get target_x():Number 
		{
			return _target_x;
		}
		
		public function set target_x(value:Number):void 
		{
			_target_x = value;
			if (_target != null) {
				_target.x = 
				_target_mask.x = _target_x;
			}
		}
		/**
		 * 目标y位置
		 */
		public function get target_y():Number 
		{
			return _target_y;
		}
		
		public function set target_y(value:Number):void 
		{
			if (_target != null) {
				_target.y += value-_target_y; 
				_target_mask.y = value;
			}
			_target_y = value;
		}
		/**
		 * 是否自动设置bar的宽度
		 */
		public function get bar_auto_size():Boolean 
		{
			return _bar_auto_size;
		}
		
		public function set bar_auto_size(value:Boolean):void 
		{
			_bar_auto_size = value;
			target_width = _target_width;
			if (!_bar_auto_size) {
				bar.width = Math.min(bg.width * .5, _def_bar_width);
				scroll_rect.width = bg.width - bar.width;
			}
		}
		/**
		 * 是否使用mask
		 */
		public function get use_mask():Boolean 
		{
			return _use_mask;
		}
		
		public function set use_mask(value:Boolean):void 
		{
			_use_mask = value;
			if(_target){
				if (_use_mask) {
					_target.mask = _target_mask;
				}else {
					_target.mask = null;
					_target_mask.visible = false;
				}
			}
		}
		
		public function get target():DisplayObject 
		{
			return _target;
		}
		
		public function set target(value:DisplayObject):void 
		{
			if (_target != null && _target != value) {
				_target.mask = null;
				_target = null;
				_target_name = "";
			}
			if(value!=null){
				_target_name = value.name;
			}else {
				_target_name = "";
			}
			setTarget();
		}
		
		public function get step_size():Number 
		{
			return _step_size;
		}
		
		public function set step_size(value:Number):void 
		{
			_step_size = value;
			setTargetX();
		}
		
	}

}