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
	 * 纵向滚动条 vertical scroll bar
	 * @author cg
	 */
	public class cgScrollBarV extends UI 
	{
		public var tween:Boolean=true;
		public var tween_time:Number = .2;
		
		protected var tween_obj:Object = { per:0 };
		
		protected var _target_name:String="";
		protected var _target_mask_name:String="";
		
		protected var _def_bar_height:Number;
		
		protected var _target_width:Number;
		protected var _target_height:Number;
		protected var _target_x:Number;
		protected var _target_y:Number;
		protected var _mouse_wheel_height:Number = 0;
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
		
		public function cgScrollBarV() 
		{
			super();
			bg = this.getChildAt(0) as Sprite;
			bg.mouseChildren = false;
			
			bar = this.getChildAt(1) as cgButton;
			_def_bar_height = bar.height;
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
			
			scroll_rect = new Rectangle(0, 0, 0, bg.height - bar.height);
			bar.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			bg.addEventListener(MouseEvent.MOUSE_DOWN, onBgClick);
			height = height;
		}
		
		private function onBgClick(e:MouseEvent):void 
		{
			var _per:Number = (mouseY - bar.height * .5) / (bg.height - bar.height);
			if (_target != null) {
				if(_target.height > _target_height && step_size > 0) {
					var _step_per:Number = step_size / (_target_height - _target.height);
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
			_percent = bar.y / scroll_rect.height;
			_percent = Math.min(1, _percent);
			_percent = Math.max(0, _percent);
			setTargetY();
		}
		protected function setTargetY():void
		{
			if (_target != null) {
				var _y:Number = (_target_height - _target.height) * _percent + _target_y;
				if (_target.height < _target_height) {
					_y = _target_y;
				}
				if (tween) {
					TweenMax.to(_target, tween_time, {ease:Strong.easeOut, y: _y} );
				}else{
					_target.y = _y;
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
					_target_mask.x = _target.x;
					_target_mask.y = _target.y;
				}
				target_width = _target_width;
				target_height = _target_height;
				checkVisible();
				use_mask = _use_mask;
				mouse_wheel_height = _mouse_wheel_height;
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
				_target_mask.x = _target_x;
				_target_mask.y = _target_y;
				_target_mask.width = _target_width;
				_target_mask.height = _target_height;
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
			if (_target.height > _target_height && step_size > 0) {
				var _step_per:Number = step_size / (_target_height - _target.height);
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
		 * 当_target的y或者height被外部程序改变时，更新percent及滚动条
		 */
		public function updateByTarget():void
		{
			if (_target != null) {
				if (_bar_auto_size) {
					bar.height = Math.max(bg.height * .5,Math.min(1, _target_height / _target.height) * bg.height);
					scroll_rect.height = bg.height - bar.height;
				}
				if ( _target.height <= _target_height) {
					percent = 0;
				}else{
					percent = (_target_y - _target.y) / (_target.height-_target_height);
				}
			}
			checkVisible();
		}
		/**
		 * 重置百分比及目标y值
		 */
		public function reset():void
		{
			if(_target!=null){
				_target.y = _target_y;
			}
			percent = 0;
			target_width = _target_width;
			target_height = _target_height;
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
				percent = _percent + n / (_target.height-_target_height);
				changeByStepSize();
			}
		}
		/**
		 * 鼠标滚轮移动的距离，如果为0，不移动
		 */
		public function set mouse_wheel_height(n:Number):void
		{	
			_mouse_wheel_height = n;
			if (_target != null) {
				if (_mouse_wheel_height == 0 && _target.parent != null) {
					_target.parent.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
				}else {
					_target.parent.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
				}
			}
		}
		public function get mouse_wheel_height():Number
		{
			return _mouse_wheel_height;
		}
		private function onWheel(evt:MouseEvent):void
		{
			offset(- evt.delta / Math.abs(evt.delta) * _mouse_wheel_height );
		}
		/**
		 * 设置bar本身的高度，bar的scaleY会重置为1
		 */
		override public function set height(n:Number):void
		{
			n = Math.max(20, n);
			scaleY = 1;
			bg.height = n;
			bar.height = Math.min(bg.height * .5, bar.height/bar.scaleY);
			scroll_rect.height = bg.height - bar.height;
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
			bar.y = scroll_rect.height * _percent;
			setTargetY();
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
			if (_target == null) {
				fadeOut();
				return;
			}
			if (_target.height <= _target_height) {
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
		public function get target_width():Number 
		{
			return _target_width;
		}
		
		public function set target_width(value:Number):void 
		{
			if (_target == null) {
				_target_width = value;
			}else{
				_target_width = value <= 0?_target.width:value;
			}
			_target_mask.width = _target_width;
		}
		/**
		 * 设置滚动区域的高度
		 */
		public function get target_height():Number 
		{
			return _target_height;
		}
		
		public function set target_height(value:Number):void 
		{
			if (_target != null) {
				_target_height = value <= 0?_target.height:value;
				if (_bar_auto_size) {
					bar.height = Math.max(bg.height * .5,Math.min(1, _target_height / _target.height) * bg.height);
					scroll_rect.height = bg.height - bar.height;
				}
				if (_target.height + _target.y < _target_y + _target_height && _target.height >= _target_height) {
					_target.y = _target_y + _target_height - _target.height;
				}
			}else {
				_target_height = value;
			}
			_target_mask.height = _target_height;
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
		 * 是否自动设置bar的高度
		 */
		public function get bar_auto_size():Boolean 
		{
			return _bar_auto_size;
		}
		
		public function set bar_auto_size(value:Boolean):void 
		{
			_bar_auto_size = value;
			target_height = _target_height;
			if (!_bar_auto_size) {
				bar.height = Math.min(bg.height * .5, _def_bar_height);
				scroll_rect.height = bg.height - bar.height;
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
			setTargetY();
		}
		
	}

}