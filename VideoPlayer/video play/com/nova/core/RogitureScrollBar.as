/**************************************************
 *          滚动条类
 *	  来源：http://www.rogiture.com
 *	  作者：Rogiture
 * 
 *  注:构造函数中，如果需要进行滚动的对象有多个滚动条，而为将第6个参数指定为true，会导致意外的结果
 *    (只能在多个滚动条其中的一个构造函数内将第6个参数指定为true)
 *	   另，滚动条滑槽、滑块、向上向下或向左向右按钮须在同一容器中
 **************************************************
----------------------------------------------------------------------------------------------------

* 构造函数
RogitureScrollBar(
				  Object: 显示区域，{width, height}
   				  MovieClip: 需要进行滚动的对象
				  MovieClip: 滚动条轨道
				  MovieClip: 滚动条滑块
				  String: 滚动条类型，默认为"vertical"垂直(水平:"horizontal", 垂直:"vertical")
				  Boolean: 需要进行滚动的对象是否已经有一个以上的滚动条(默认为false，没有)
				  Boolean: 当被滚动对象小于显示区域时，是否隐藏滚动条，默认为true隐藏
				  *: [滚动条向上滚动按钮，类型为所有显示对象(可选)]
				  *: [滚动条向下滚动按钮，类型为所有显示对象(可选)]
				 ) 
				 
----------------------------------------------------------------------------------------------------

* 方法 set px(i:int):void
  设置滑轮滚动一次以及按钮点击一次，被滚动对象移动的像素，参数为要滚动的像素值
  
----------------------------------------------------------------------------------------------------
* 方法 set setHide(b:Boolean):void
  设置当被滚动对象小于显示区域时，是否隐藏滚动条,true为隐藏
  
----------------------------------------------------------------------------------------------------

* 方法 update():void
  当被滚动对象更新时，而需要改变滚动条状态，请调用此方法
  
----------------------------------------------------------------------------------------------------

* 方法 get ed():EventDispatcher
  返回事件侦听对象

----------------------------------------------------------------------------------------------------

* 事件
  RogitureScrollBar.GREATERTHAN:String = "greaterThan"
  	被滚动对象面积大于显示对象事件
  RogitureScrollBar.LESSTHAN:String = "lessThan"
  	被滚动对象面积小于显示对象事件
  
----------------------------------------------------------------------------------------------------
  
*/
package com.nova.core
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Strong;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	public class RogitureScrollBar
	{
		private var _showArea:Object;		//显示区域{width, height}
		private var _mcMaskee:MovieClip;	//需要进行滚动的对象
		private var _mcScrollBg:MovieClip;	//滚动条轨道
		private var _mcScroll:MovieClip;	//滚动条滑块
		private var _type:Object;			//滚动条类型{type, attribute}
		private var _howMany:Boolean;		//需要进行滚动的对象是否已经有一个以上的滚动条
		private var _btnUp:*;				//滚动条向上滚动按钮
		private var _btnDown:*;				//滚动条向下滚动按钮
		private var _mcMask:Sprite;			//用于遮罩显示区域
		private var _px:Number;				//滑轮滚动一次以及按钮点击一次，被滚动对象移动的像素，默认为10像素
		private var _bHide:Boolean;			//当被滚动对象小于显示区域时，是否隐藏滚动条
		
		private var maskee_a:int;			//Maskee初始属性
		private var xOfy:int;				//算百分点时需要
		private var mouse:String;			//鼠标的属性，该取mouseX还是MouseY
		private var oRectangle:Rectangle;	//拖动范围
		private var scrollMoveTimer:Timer;	//用于移动Maskee
		private var btnMouseDownTimer:Timer;//鼠标在上或下按钮上按下而未释放未移开，500毫秒后不断进行滚动
		private var btnMoveTimer:Timer;		//鼠标在上或下按钮上按下而未释放未移开，移动滑块
		private var nowMoveType:String;		//当前需要向上还是向下滚动
		
		private var pScroll:*;				//滚动条容器
		private var aScrollTween:Tween;		//用于隐藏与显示滚动条
		
		private var _ed:EventDispatcher;	//事件侦听对象
		
		public static var GREATERTHAN:String = "greaterThan";//被滚动对象面积大于显示对象
		public static var LESSTHAN:String = "lessThan";//被滚动对象面积小于显示对象

		
		//构造函数
		public function RogitureScrollBar(showArea:Object, 
										  mcMaskee:MovieClip, 
										  mcScrollBg:MovieClip, 
										  mcScroll:MovieClip, 
										  type:String = "vertical", 
										  howMany:Boolean = false,
										  bHide:Boolean = true,
										  btnUp:* = null, 
										  btnDown:* = null)
		{
			//初始赋值
			_showArea	= showArea;
			_mcMaskee	= mcMaskee;
			_mcScrollBg = mcScrollBg;
			_mcScroll	= mcScroll;
			_howMany	= howMany
			_btnUp		= btnUp;
			_btnDown	= btnDown;
			_bHide		= bHide;
			pScroll		= _mcScroll.parent;
			
			_type = new Object();
			_type = (type == "vertical") ? {type:"height", attribute:"y"} : {type:"width", attribute:"x"};
			
			oRectangle = new Rectangle(Math.floor(_mcScroll.x), Math.floor(_mcScroll.y));
			oRectangle.width = (type == "vertical") ? 0 : _mcScrollBg[_type.type]-_mcScroll[_type.type];
			oRectangle.height = (type == "vertical") ? _mcScrollBg[_type.type]-_mcScroll[_type.type] : 0;
			
			maskee_a = (type == "vertical") ? Math.floor(_mcMaskee.y) : Math.floor(_mcMaskee.x);
			
			xOfy = (type == "vertical") ? oRectangle.y : oRectangle.x;
			
			mouse = (type == "vertical") ? "mouseY" : "mouseX";

			//如果需要进行遮罩
			if(!_howMany){
				//创建个Sprite，遮罩mcMaskee
				_mcMask = new Sprite();
				_mcMask.graphics.beginFill(0xFFFFFF);
				_mcMask.graphics.drawRect(_mcMaskee.x, _mcMaskee.y, _showArea.width, _showArea.height);
				_mcMask.graphics.endFill();
				_mcMaskee.parent.addChild(_mcMask);
				_mcMaskee.mask = _mcMask;
			}
			
			scrollMoveTimer = new Timer(30);
			scrollMoveTimer.addEventListener(TimerEvent.TIMER, scrollMoveTimerEvent);
			
			btnMouseDownTimer = new Timer(500);
			btnMouseDownTimer.addEventListener(TimerEvent.TIMER, btnMouseDownTimerEvent);
			
			btnMoveTimer = new Timer(100);
			btnMoveTimer.addEventListener(TimerEvent.TIMER, btnMoveTimerEvent);
			
			_ed = new EventDispatcher();
			
			px = 10;
			update();
			configureListeners();
		}
		
		
		//侦听事件
		private function configureListeners():void
		{
			_mcScroll.addEventListener(MouseEvent.MOUSE_DOWN, scrollMouseDown);
			_mcScroll.stage.addEventListener(MouseEvent.MOUSE_UP, scrollMouseUp);
			_mcScrollBg.addEventListener(MouseEvent.MOUSE_DOWN, scrollBgMouseDown);
			//_mcScrollBg.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			//_mcScroll.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			if(!_howMany){
				//_mcMaskee.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			}
			if(_btnUp != null){
				_btnUp.addEventListener(MouseEvent.MOUSE_DOWN, btnUpMouseDown);
				_btnUp.addEventListener(MouseEvent.MOUSE_OUT, btnMouseOutAndUp);
				_btnUp.addEventListener(MouseEvent.MOUSE_UP, btnMouseOutAndUp);
				//_btnUp.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			}
			if(_btnDown != null){
				_btnDown.addEventListener(MouseEvent.MOUSE_DOWN, btnDownMouseDown);
				_btnDown.addEventListener(MouseEvent.MOUSE_OUT, btnMouseOutAndUp);
				_btnDown.addEventListener(MouseEvent.MOUSE_UP, btnMouseOutAndUp);
				//_btnDown.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			}
		}
		//移除事件侦听
		private function removeListeners():void
		{
			_mcScroll.removeEventListener(MouseEvent.MOUSE_DOWN, scrollMouseDown);
			_mcScroll.stage.removeEventListener(MouseEvent.MOUSE_UP, scrollMouseUp);
			_mcScrollBg.removeEventListener(MouseEvent.MOUSE_DOWN, scrollBgMouseDown);
			//_mcScrollBg.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			//_mcScroll.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			if(!_howMany){
				//_mcMaskee.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			}
			if(_btnUp != null){
				_btnUp.removeEventListener(MouseEvent.MOUSE_DOWN, btnUpMouseDown);
				_btnUp.removeEventListener(MouseEvent.MOUSE_OUT, btnMouseOutAndUp);
				_btnUp.removeEventListener(MouseEvent.MOUSE_UP, btnMouseOutAndUp);
				//_btnUp.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			}
			if(_btnDown != null){
				_btnDown.removeEventListener(MouseEvent.MOUSE_DOWN, btnDownMouseDown);
				_btnDown.removeEventListener(MouseEvent.MOUSE_OUT, btnMouseOutAndUp);
				_btnDown.removeEventListener(MouseEvent.MOUSE_UP, btnMouseOutAndUp);
				//_btnDown.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			}
		}
		
		
		//滑块，鼠标按下事件
		private function scrollMouseDown(event:MouseEvent):void
		{
			_mcScroll.startDrag(false, oRectangle);
			scrollMoveTimer.start();
		}
		//滑块，鼠标释放事件
		private function scrollMouseUp(event:MouseEvent):void
		{
			_mcScroll[_type.attribute] = Math.floor(_mcScroll[_type.attribute]);
			_mcScroll.stopDrag();
			scrollMoveTimer.stop();
		}
		//滑块正在移动中...
		private function scrollMoveTimerEvent(event:TimerEvent):void
		{
			moveMaskee();
			event.updateAfterEvent();
		}
		
		
		//鼠标在滑槽上按下时
		private function scrollBgMouseDown(event:MouseEvent):void
		{
			moveScroll(_mcScroll.parent[mouse]);
			event.updateAfterEvent();
		}
		
		
		//鼠标点击向上按钮时
		private function btnUpMouseDown(event:MouseEvent):void
		{
			moveScroll(_mcScroll[_type.attribute] - _px);
			nowMoveType = "up";
			btnMouseDownTimer.start();
			event.updateAfterEvent();
		}
		
		
		//鼠标点击向下按钮时
		private function btnDownMouseDown(event:MouseEvent):void
		{
			moveScroll(_mcScroll[_type.attribute] + _mcScroll[_type.type] + _px);
			nowMoveType = "down";
			btnMouseDownTimer.start();
			event.updateAfterEvent();
		}
		
		
		//鼠标移开或释放按钮
		private function btnMouseOutAndUp(event:MouseEvent):void
		{
			btnMouseDownTimer.stop();
			btnMoveTimer.stop();
			event.updateAfterEvent();
		}
		
		
		//鼠标在上或下按钮上按下而未移开，1秒后不断进行滚动
		private function btnMouseDownTimerEvent(event:TimerEvent):void
		{
			btnMouseDownTimer.stop();
			btnMoveTimer.start();
			event.updateAfterEvent();
		}
		//开始滚动
		private function btnMoveTimerEvent(event:TimerEvent):void
		{
			//如果向上
			if(nowMoveType == "up"){
				moveScroll(_mcScroll[_type.attribute] - _px);
			//如果向下
			}else{
				moveScroll(_mcScroll[_type.attribute] + _mcScroll[_type.type] + _px);
			}
			event.updateAfterEvent();
		}
		
		
		
		//鼠标滑轮滚动
		private function mouseWheel(event:MouseEvent):void
		{
			//如果是向下滚动
			if(event.delta < 0){
				moveScroll(_mcScroll[_type.attribute] + _mcScroll[_type.type] + _px);
			
			//如果向上滚动
			}else{
				moveScroll(_mcScroll[_type.attribute] - _px);
			}
			event.updateAfterEvent();
		}
		
		
		//移动滑块
		private function moveScroll(iY:int):void
		{
			//如果向下移动
			if(iY > _mcScroll[_type.attribute]){
				iY = Math.floor(iY-_mcScroll[_type.type]);
				//5像素内，自动吸附到底端
				_mcScroll[_type.attribute] = ((iY+_mcScroll[_type.type]+5) > (_mcScrollBg[_type.attribute]+_mcScrollBg[_type.type])) ? Math.floor(_mcScrollBg[_type.attribute]+_mcScrollBg[_type.type]-_mcScroll[_type.type]) : iY;
			
			//如果是向上移动
			}else{
				//5像素内，自动吸附到顶端
				_mcScroll[_type.attribute] = (iY < (_mcScrollBg[_type.attribute]+5)) ? _mcScrollBg[_type.attribute] : iY;
			}
			
			moveMaskee();
		}
		
		
		//移动Maskee
		private function moveMaskee():void
		{
			//算出每个百分点移动的距离
			var percent:Number = (_mcMaskee[_type.type] - _showArea[_type.type])/100;
			//算出移动了多少个百分点
			var remove:Number = (_mcScroll[_type.attribute] - xOfy)/(_mcScrollBg[_type.type]-_mcScroll[_type.type]) * 100;
			//改变Maskee位置

			TweenLite.to(_mcMaskee,.5, {y: -(Math.floor(remove * percent - maskee_a))});
			//_mcMaskee[_type.attribute] = -(Math.floor(remove * percent - maskee_a));
		}
		
		
		//更新滚动条，是否需要隐藏滚动条
		public function update():void
		{
			if(_mcMaskee[_type.type] < _showArea[_type.type]){
				//触发被滚动对象面积小于显示对象 事件
				_ed.dispatchEvent(new Event(RogitureScrollBar.LESSTHAN));
				//移除事件侦听
				removeListeners();
				//位置还原
				_mcMaskee[_type.attribute] = maskee_a;
				_mcScroll[_type.attribute] = xOfy;
				
				hideScroll();
				
			}else{
				//触发被滚动对象面积大于显示对象 事件
				_ed.dispatchEvent(new Event(RogitureScrollBar.GREATERTHAN));
				//侦听事件
				configureListeners();
				
				showScroll();
			}
		}
		
		//隐藏滚动条
		private function hideScroll():void
		{
			//如果需要隐藏
			if(_bHide){
				aScrollTween = new Tween(pScroll, "alpha", Strong.easeOut, pScroll.alpha, 0, 1, true);
				aScrollTween.addEventListener(TweenEvent.MOTION_FINISH, hideMovieOver);
			}
		}
		//隐藏滚动条动画播放完成时
		private function hideMovieOver(event:TweenEvent):void
		{
			pScroll.visible = false;
		}
		
		//显示滚动条
		private function showScroll():void
		{
			//如果透明度小于100%
			if(pScroll.alpha < 1){
				pScroll.visible = true;
				aScrollTween.removeEventListener(TweenEvent.MOTION_FINISH, hideMovieOver);
				aScrollTween = new Tween(pScroll, "alpha", Strong.easeOut, pScroll.alpha, 1, 1, true);
			}
		}
		
		
		//设置滑轮滚动一次以及按钮点击一次，被滚动对象移动的像素
		public function set px(i:int):void
		{
			//算出所占面积的百分点
			var percent:Number = (i/(_mcMaskee[_type.type] - _showArea[_type.type] - i))*100;
			//得到滑块应该移动的距离
			_px = (_mcScrollBg[_type.type] - _mcScroll[_type.type]) * percent / 100;
		}
		
		//设置当被滚动对象小于显示区域时，是否隐藏滚动条,true为隐藏
		public function set setHide(b:Boolean):void
		{
			_bHide = b;
		}
		
		//返回事件侦听对象
		public function get ed():EventDispatcher
		{
			return _ed;
		}
	}
}