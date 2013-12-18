package com.cg.ui 
{
	import com.cg.ui.UI;
	import com.cg.utils.cgTransform;
	import com.greensock.easing.Back;
	import com.greensock.TweenMax;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.display.Sprite
	
	/**
	 * ...
	 * @author cg
	 */
	public class Panel extends UI 
	{
		public var closeHandler:Function;
		public var data:Object;
		//舞台居中偏移量
		public var alignDx:int;
		public var alignDy:int;
		public var bg:BlackMask;
		private var myBg:Sprite;
		private var contentBg:Sprite;
		public function Panel() 
		{
			fade_time = 1;
			myBg = this.getChildByName("_myBg") as Sprite;
			contentBg = this.getChildByName("_contentBg") as Sprite;
			bg = new BlackMask();
		}
		override protected function onAdd2Stage(e:Event):void 
		{
			super.onAdd2Stage(e);
			stage.addEventListener(Event.RESIZE, onResize);
			addEventListener(MouseEvent.CLICK, onClick);
			onResize(null);
		}
		
		override protected function destroy(e:Event):void
		{
			super.destroy(e);
			stage.removeEventListener(Event.RESIZE, onResize);
			addEventListener(MouseEvent.CLICK, onClick);
			closeHandler = null;
		}
		protected function onClick(e:MouseEvent):void 
		{
			switch(e.target.name) {
				case "closeBtn":
					this.fadeOutAndRemove();
					break;
			}
		}
		override public function fadeIn(_delay:Number=0, handler:Function=null):void
		{
			TweenMax.killTweensOf(this);
			//y += 200;
			//TweenMax.to(this, fade_time, { delay:_delay, autoAlpha:1, y:y - 200, ease:Back.easeOut, onComplete:handler } );
			TweenMax.to(this, fade_time, { delay:_delay, autoAlpha:1, ease:Back.easeOut, onComplete:handler } );
			bg.fadeIn();
			dispatchEvent(new Event("fadeIn"));
		}
		override public function fadeOut(_delay:Number=0, handler:Function=null):void
		{
			TweenMax.killTweensOf(this);
			//TweenMax.to(this, fade_time, { delay:_delay, autoAlpha:0, y:y - 100, ease:Back.easeIn, onComplete:handler } );
			TweenMax.to(this, 0, { delay:_delay, autoAlpha:0, y:y - 100, ease:Back.easeIn, onComplete:handler } );
			bg.fadeOut();
			dispatchEvent(new Event("fadeOut"));
		}
		override public function fadeOutAndRemove(_delay:Number=0, handler:Function=null):void
		{
			var _handler:Function = function():void
			{
				if (handler != null) {
					handler();
				}
				if (closeHandler != null) {
					closeHandler();
				}
				dispatchEvent(new Event("fadeOutAndRemove"));
				removeMe();
			}
			fadeOut(_delay, _handler);
			bg.fadeOutAndRemove();
		}
		protected function onResize(e:Event):void 
		{
			TweenMax.killTweensOf(this, true);
			cgTransform.alignTo(this, stage, "CC",contentBg);
			if (myBg != null) {
				cgTransform.scaleTo(myBg, stage.stageWidth, stage.stageHeight, "cut");
				cgTransform.alignTo(myBg, stage,"CC");
			}
		}
		
		
	}

}