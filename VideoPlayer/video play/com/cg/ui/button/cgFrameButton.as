package com.cg.ui.button 
{
	
	import com.cg.ui.IFocus;
	import com.greensock.TweenMax;
	import com.greensock.plugins.*;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	
	/**
	 * com.cg.ui.button.cgFrameButton
	 * @author cg
	 */
	public class cgFrameButton extends cgBaseButton implements IFocus, IcgButton 
	{
		/**
		 * 动画时间
		 * 
		 */
		public var motionTime:Number = .2;
		public var autoTime:Boolean = true;
		protected var labelCon:MovieClip;
		protected var _frameLabel:String="1";
		public function cgFrameButton()
		{
			gotoAndStop("normal");
			labelCon = this.getChildByName("_labelCon") as MovieClip;
			if (labelCon != null) {
				labelCon.gotoAndStop(frameLabel);
				labelCon.addEventListener(Event.ENTER_FRAME, onLabelConEnter);
			}
		}
		override protected function init():void
		{
			super.init();
			TweenPlugin.activate([FrameLabelPlugin, FramePlugin]);
		}
		private function onLabelConEnter(e:Event):void 
		{
			var _con:MovieClip = e.target as MovieClip;
			_con.removeEventListener(Event.ENTER_FRAME, onLabelConEnter);
			_label_TF = _con.getChildByName("_labelTxt") as TextField;
			label = _label;
		}
		override protected function onOver(e:MouseEvent):void 
		{
			super.onOver(e);
			if (lock) return;
			TweenMax.to(this, autoTime?getMotionTime("over"):motionTime, { frameLabel:"over"} );
		}
		override protected function onOut(e:MouseEvent):void 
		{
			super.onOut(e);
			if (_highLight) {
				TweenMax.to(this, autoTime?getMotionTime("highLight"):motionTime, { frameLabel:"highLight" } );
			}else{
				if (lock) return;
				TweenMax.to(this, autoTime?getMotionTime("normal"):motionTime, { frameLabel:"normal" } );
			}
		}
		/**
		 * 锁定
		 * 
		 */
		override public function set lock(value:Boolean):void 
		{
			_lock = value;
			if (_lock) {
				mouseEnabled = false;
				if (_highLight) {
					TweenMax.to(this, autoTime?getMotionTime("highLight"):motionTime, { frameLabel:"highLight" } );
				}else{
					TweenMax.to(this, autoTime?getMotionTime("lock"):motionTime, { frameLabel:"lock" } );
				}
			}else {
				mouseEnabled=true;
				TweenMax.to(this,autoTime?getMotionTime("normal"):motionTime,{frameLabel:"normal"});
			}
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
			lock = _highLight;
		}
		
		public function get frameLabel():String 
		{
			return _frameLabel;
		}
		
		public function set frameLabel(value:String):void 
		{
			_frameLabel = value;
			if (labelCon != null) {
				labelCon.gotoAndStop(value);
			}
		}
		private function getMotionTime(_fl:String):Number
		{
			var _stepTime:Number = 1 / stage.frameRate;
			return Math.abs(getLabelFrame(_fl) - currentFrame) * _stepTime;
		}
		private function getLabelFrame(_fl:String):int
		{
			var labels:Array = currentLabels;
			var i:int = labels.length;
			while (i--) {
				if (labels[i].name == _fl) {
					return labels[i].frame;
				}
			}
			return currentFrame;
		}
	}

}