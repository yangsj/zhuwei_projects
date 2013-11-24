package com.cg.ui.grid 
{
	import com.cg.ui.button.cgButtonGroup;
	import com.cg.ui.UI;
	import com.cg.utils.exArray;
	import com.cg.utils.exCon;
	import com.cg.utils.exInt;
	import com.greensock.easing.Sine;
	import com.greensock.easing.Strong;
	import com.greensock.TweenMax;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author cg
	 */
	public class cgGridV extends UI 
	{
		public var tween:Boolean=true;
		protected var tweeing:Boolean = false;
		public var tween_time:Number = .5;
		public var tween_obj:Object = {t:0};
		//列数
		protected var _row:int = 1;
		//是否根据cell宽度自动调整列宽及间隔，如果为false，适合等大小的cell网格，如果为true，适合不等大小的网格
		protected var _auto_row:Boolean = true;
		protected var _old_row:int = 1;
		protected var _drow:int = 0;
		protected var _grid_width:int = 0;
		protected var _cell_width:Number=64;
		protected var _cell_height:Number = 64;
		protected var _auto_border:Boolean=true;
		protected var _border_equals:Boolean = true;
		protected var _border_x:Number=5;
		protected var _border_y:Number=5;
		protected var _border_def_x:Number=5;
		protected var _border_def_y:Number=5;
		
		public var child_con:cgButtonGroup;
		protected var cells:Array;
		protected var old_pos:Array;
		public function cgGridV() 
		{
			super();
			child_con = new cgButtonGroup();
			addChild(child_con);
			cells = new Array();
			old_pos = new Array();
		}
		override protected function onAdd2Stage(e:Event):void 
		{
			super.onAdd2Stage(e);
		}
		override protected function destroy(e:Event):void
		{
			super.destroy(e);
			TweenMax.killTweensOf(tween_obj);
		}
		public function initGrid(_arr:Array):void
		{
			clear();
			for (var i:int = 0; i < _arr.length; i++) {
				if ((_arr[i] as InteractiveObject) == null) {
					throw(new Error("无法完成Grid初始化，传入的节点不是InteractiveObject:" + i));
					return;
				}
				child_con.addChild(_arr[i]);
				cells.push(_arr[i]);
			}
			setPos();
		}
		public function update():void
		{
			if (tween && _auto_row) {
				setPos();
				for (var i:int = 0; i < cells.length; i++) {
					//trace(i, cells[i].x, cells[i].y, old_pos[i]);
					TweenMax.from(cells[i], tween_time, {x:old_pos[i].x, y:old_pos[i].y } );
				}
			}else if (tween && _drow != 0 && tweeing==false) {
				//trace("tween update")
				tween_obj.t = 0;
				tweeing = true;
				TweenMax.to(tween_obj, tween_time, { ease:Sine.easeIn, 
													t:1, 
													onUpdate:onTweenUpdate, 
													onComplete:onTweenComplete} );
			}else if (!tweeing) {
				setPos();
			}
		}
		protected function setPos():void
		{
			var i:int;
			if (_auto_row) {
				var __x:Number = 0;
				var __y:Number = 0;
				var _max_y:Number = 0;
				var _cells:Array = new Array();
				for (i = 0; i < cells.length; i++) {
					old_pos[i] = new Point(cells[i].x, cells[i].y);
					if (__x + cells[i].width > _grid_width) {
						//换行 
						__x = 0;
						__y += _max_y + _border_y;
						_max_y = 0;
						setAutoBorder(_cells);
						_cells = new Array();
					}
					cells[i].x = __x;
					cells[i].y = __y;
					_cells.push(cells[i]);
					__x += cells[i].width + _border_x;
					_max_y = Math.max(_max_y, cells[i].height);
				}
			}else{
				for (i = 0; i < cells.length; i++) {
					old_pos[i] = new Point(cells[i].x, cells[i].y);
					cells[i].x = i % _row * (_cell_width + _border_x);
					cells[i].y = Math.floor(i / _row) * (_cell_height + _border_y);
				}
			}
		}
		/**
		 * 根据grid设置的宽度对齐每一行的cell
		 * @param	rowCells
		 */
		protected function setAutoBorder(rowCells:Array):void
		{
			if (!_auto_border) return;
			var _size:Number = 0;
			var i:int;
			for (i = 0; i < rowCells.length; i++) {
				_size += rowCells[i].width;
			}
			var _bd:Number = (_grid_width-_size) / (rowCells.length - 1);
			var __x:Number = 0;
			for (i = 0; i < rowCells.length; i++) {
				rowCells[i].x = __x;
				__x += rowCells[i].width + _bd;
			}
		}
		protected function onTweenUpdate():void
		{
			//trace("update pos ", _old_row, _drow);
			for (var i:int = 0; i < cells.length; i++) {
				var __x:Number = i % (_old_row +_drow * tween_obj.t);
				var __y:Number = Math.floor(i / (_old_row +_drow * tween_obj.t));
				cells[i].x = __x * (_cell_width + _border_x);
				cells[i].y = __y * (_cell_height + _border_y);
			}
		}
		protected function onTweenComplete():void
		{
			tweeing = false;
			_old_row = row;
			_drow = 0;
			setPos();
		}
		public function clear():void
		{
			//trace("clear")
			TweenMax.killTweensOf(tween_obj, true);
			exCon.removeAllChild(child_con);
			cells = new Array();
			old_pos = new Array();
		}
		public function push(cell:InteractiveObject):void
		{
			cell.x = cells[cells.length-1].x;
			cell.y = cells[cells.length-1].y;
			cells.push(cell);
			child_con.addChild(cell);
			update();
		}
		public function unshift(cell:InteractiveObject):void
		{
			cell.x = cells[0].x;
			cell.y = cells[0].y;
			cells.unshift(cell);
			child_con.addChildAt(cell,0);
			update();
		}
		public function pop():InteractiveObject
		{
			if (cells.length == 0) return null;
			var _cell:InteractiveObject = cells[cells.length - 1] as InteractiveObject;
			child_con.removeChild(_cell);
			cells.pop();
			update();
			return _cell;
		}
		public function shift():InteractiveObject
		{
			if (cells.length == 0) return null;
			var _cell:InteractiveObject = cells[0] as InteractiveObject;
			child_con.removeChild(_cell);
			cells.shift();
			update();
			return _cell;
		}
		public function insert(cell:InteractiveObject,id:int):void
		{
			id = exInt.inArea(id, 0, cells.length-1);
			cell.x = cells[id].x;
			cell.y = cells[id].y;
			cells.splice(id, 0, cell);
			child_con.addChildAt(cell ,id);
			update();
		}
		public function move(i:int, j:int):void
		{
			exArray.move(cells, i, j);
			update();
		}
		public function get row():int 
		{
			return _row;
		}
		public function set row(value:int):void 
		{
			if (_row != value) {
				_old_row = _row;
				_row = value;
				_drow = _row - _old_row;
				update();
			}
		}
		
		public function get border_x():Number 
		{
			return _border_x;
		}
		
		public function set border_x(value:Number):void 
		{
			if(_border_x != value){
				_border_x = value;
				_border_def_x = _border_x;
				update();
			}
		}
		public function get border_y():Number 
		{
			return _border_y;
		}
		
		public function set border_y(value:Number):void 
		{
			if(_border_y != value){
				_border_y = value;
				_border_def_y = _border_y;
				update();
			}
		}
		
		public function get cell_width():Number 
		{
			return _cell_width;
		}
		
		public function set cell_width(value:Number):void 
		{
			if(_cell_width != value){
				_cell_width = value;
				update();
			}
		}
		
		public function get cell_height():Number 
		{
			return _cell_height;
		}
		
		public function set cell_height(value:Number):void 
		{
			if(_cell_height != value){
				_cell_height = value;
				update();
			}
		}
		
		public function get grid_width():int 
		{
			return _grid_width;
		}
		
		public function set grid_width(value:int):void 
		{
			_grid_width = value;
			if (_grid_width > 0) {
				var _num:int
				if(_auto_border && (_auto_row==false)){
					_num = Math.max(1, Math.floor(_grid_width / _cell_width));
					if (_num == 1) {
						_border_x = _border_def_x;
					}else {
						_border_x = (_grid_width - _cell_width * _num) / (_num - 1);
						_border_x = Math.max(0, _border_x);
					}
					if (_border_equals && _border_x>0) {
						_border_y = _border_x;
					}
					update();
				}else {
					_num = Math.max(1, Math.floor((_grid_width+_border_x) / (_cell_width+_border_x)));
				}
				if (_row != _num) {
					row = _num;
				}else if(_auto_row) {
					update();
				}
			}
		}
		
		public function get border_equals():Boolean 
		{
			return _border_equals;
		}
		
		public function set border_equals(value:Boolean):void 
		{
			if(_border_equals!=value){
				_border_equals = value;
				update();
			}
		}
		
		public function get auto_border():Boolean 
		{
			return _auto_border;
		}
		
		public function set auto_border(value:Boolean):void 
		{
			if(_auto_border!=value){
				_auto_border = value;
				update();
			}
		}
		
		public function get auto_row():Boolean 
		{
			return _auto_row;
		}
		
		public function set auto_row(value:Boolean):void 
		{
			if(_auto_row!=value){
				_auto_row = value;
				update();
			}
		}
		
	}

}