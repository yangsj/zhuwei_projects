package code
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/**
	 * ……
	 * @author 	yangsj 
	 * 			2013-11-17
	 */
	public class BubbleItem
	{
		private var _skin:MovieClip;
		private var _txtName0:TextField;
		private var _txtName1:TextField;
		private var _mcArrow:Sprite;
		private var _mcArea:Sprite;
		
		private var _selected:Boolean = false;
		private var _data:ItemVo;
		private var _isSuccessed:Boolean;
		private var _isMouseDown:Boolean;
		private var _isMouseMove:Boolean;
		private var _speedy:Number = 1;
		private var _moveId:int;
		private var _startX:Number;
		private var _startY:Number;
		private var _startMoveX:Number;
		private var _startMoveY:Number;
		private var _startEndX:Number;
		private var _startEndY:Number;
		private var _tweenMoveTime:Number = 4;
		private var _isToEnd:Boolean = true;
		
		private const LAB_MOUSE_OUT:String = "lab1"; // 选择前鼠标移开状态
		private const LAB_GRAY:String = "lab2";// 选择后变成灰态
		private const LAB_MOUSE_OVER:String = "lab1";// 选择前鼠标移上状态
		
		public function BubbleItem( skin:MovieClip, arrow:MovieClip )
		{
			_skin = skin;
			_skin.mouseEnabled = false;
			
			_startX = _skin.x;
			_startY = _skin.y;
			_startMoveX = _startX;
			_startMoveY = _startY - 7.5;
			_startEndX  = _startX;
			_startEndY  = _startY + 7.5;
			
			_txtName0 = _skin.getChildByName( "txtName0" ) as TextField;
			_txtName1 = _skin.getChildByName( "txtName1" ) as TextField;
			
			_mcArrow = arrow;
			_mcArrow.mouseChildren = false;
			_mcArrow.mouseEnabled = false;
			
			_mcArea = _skin.getChildByName( "mcArea" ) as Sprite;
			_mcArea.buttonMode = true;
			_mcArea.addEventListener(MouseEvent.MOUSE_OVER, mouseHandler );
			_mcArea.addEventListener( MouseEvent.MOUSE_OUT, mouseHandler );
			_mcArea.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler );
			
			setArrow( false );
			setFrame( LAB_MOUSE_OUT );
			
			_isToEnd = Math.random() < 0.5;
			startShake();
		}
		
		protected function mouseHandler(event:MouseEvent):void
		{
			var type:String = event.type;
			switch ( event.type )
			{
				case MouseEvent.MOUSE_DOWN:
					TweenMax.killTweensOf( _skin );
					AppConfig.eventDispatcher.addEventListener(GEvent.DRAG_SUCCESSED, dragSuccessedHandler );
					appStage.addEventListener(MouseEvent.MOUSE_UP,   mouseHandler );
					appStage.addEventListener(MouseEvent.MOUSE_MOVE, mouseHandler );
					_skin.dispatchEvent( new GEvent( GEvent.DRAG_START, this, true ));
					_skin.parent.setChildIndex( _skin, _skin.parent.numChildren - 9 );
					_skin.startDrag();
					_isSuccessed = false;
					_isMouseMove = false;
					_isMouseDown = true;
					stopShake();
					break;
				case MouseEvent.MOUSE_UP:
					mouseUpComplete();
					break;
				case MouseEvent.MOUSE_OVER:
					setFrame( LAB_MOUSE_OVER );
					break;
				case MouseEvent.MOUSE_OUT:
					if ( _isMouseDown == false ) {
						setFrame( LAB_MOUSE_OUT );
					}
					break;
				case MouseEvent.MOUSE_MOVE:
					_isMouseMove = true;
					break;
			}
		}
		
		private function mouseUpComplete():void
		{
			AppConfig.eventDispatcher.removeEventListener(GEvent.DRAG_SUCCESSED, dragSuccessedHandler );
		
			if ( _isMouseDown ) {
				if ( _isSuccessed == false ) moveToStart();
				
				_skin.dispatchEvent( new GEvent( GEvent.DRAG_COMPLETE, [_isSuccessed, this ], true ));
				
				appStage.removeEventListener( MouseEvent.MOUSE_UP,   mouseHandler );
				appStage.removeEventListener( MouseEvent.MOUSE_MOVE, mouseHandler );
			}
			_skin.stopDrag();
			_isMouseDown = false;
			_isMouseMove = false;
			_isSuccessed = false;
			
			startShake();
		}
		
		protected function dragSuccessedHandler(event:Event):void
		{
			if ( _isMouseMove )
			{
				_selected = true;
				_isSuccessed = true;
				mouseUpComplete();
				setArrow( false );
				TweenMax.to( _skin, 0.3, { 	scaleX:0.1, 
											scaleY:0.1, 
											ease:Back.easeIn, 
											onComplete: function abc():void {
											_skin.visible = false;} });
			}
		}
		
		private function setFrame(frame:String):void
		{
			frame = _selected ? LAB_GRAY : frame;
			_skin.gotoAndStop( frame );
		}
		
		private function isAtRange(value:Number, min:Number, max:Number ):Boolean
		{
			return value > min && value < max;
		}
		
		public function setArrow( visible:Boolean ):void
		{
			_mcArrow.visible = visible;
		}
		
		public function startShake():void
		{
			if ( _isToEnd )
			{
				TweenMax.to( _skin, _tweenMoveTime, { x:_startEndX, y:_startEndY, ease:Linear.easeNone, onComplete:startShake });
			}
			else
			{
				TweenMax.to( _skin, _tweenMoveTime, { x:_startX, y:_startY, ease:Linear.easeNone, onComplete:startShake });
			}
			_isToEnd = !_isToEnd;
		}
		
		public function stopShake():void
		{
			TweenMax.killTweensOf( _skin );
			_isToEnd = true;
			_skin.x = _startX;
			_skin.y = _startY;
		}
		
		public function moveToStart( visible:Boolean = true ):void
		{
			if ( visible == false )
			{
				_skin.visible = true;
				_skin.x = _startX;
				_skin.y = _startY;
				_skin.scaleX = 0.1;
				_skin.scaleY = 0.1;
				TweenMax.to( _skin, 0.5, { scaleX:1, scaleY:1, ease:Back.easeOut });
			}
			else
			{
				TweenMax.to( _skin, 0.3, { x:_startX, y:_startY });
			}
			setFrame( LAB_MOUSE_OUT );
		}
		
		private var nameBitmap1:Bitmap;
		private var nameBitmap2:Bitmap;
		public function setLabName():void
		{
//			DisplayUtil.removedFromParent( nameBitmap1 );
//			DisplayUtil.removedFromParent( nameBitmap2 );
			
//			_txtName0.visible = false;
//			_txtName1.visible = false;
			
//			_txtName0.text = data.lab1;
//			_txtName1.text = data.lab2;
			
//			nameBitmap1 = new Bitmap( new BitmapData( _txtName0.width, _txtName0.height, true, 0), "auto", true );
//			nameBitmap1.bitmapData.draw( _txtName0 );
//			nameBitmap1.x = _txtName0.x;
//			nameBitmap1.y = _txtName0.y;
//			_skin.addChild( nameBitmap1 );
//			
//			nameBitmap2 = new Bitmap( new BitmapData( _txtName1.width, _txtName1.height, true, 0), "auto", true );
//			nameBitmap2.bitmapData.draw( _txtName1 );
//			nameBitmap2.x = _txtName1.x;
//			nameBitmap2.y = _txtName1.y;
//			_skin.addChild( nameBitmap2 );
		}
		
		public function setData( data:ItemVo ):void
		{
			_data = data;
			setLabName();
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			if ( _selected == false ){
				_selected = value;
				stopShake();
				setFrame( LAB_GRAY );
			}
		}

		public function get data():ItemVo
		{
			return _data;
		}

		public function set data(value:ItemVo):void
		{
			_data = value;
		}

		public function get skin():MovieClip
		{
			return _skin;
		}
		
		public function set mouseEnabled( value:Boolean ):void
		{
//			_mcArea.mouseEnabled = value;
			_skin.mouseChildren = value;
		}
		
		public function set alpha( value:Number ):void
		{
			_skin.alpha = value;
		}


	}
}