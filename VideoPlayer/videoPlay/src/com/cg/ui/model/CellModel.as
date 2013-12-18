package com.cg.ui.model 
{
	import com.cg.ui.button.cgButton;
	import com.cg.ui.ICell;
	
	/**
	 * ...
	 * @author cg
	 */
	public class CellModel extends cgButton implements ICell
	{
		protected var _data:Object;
		public var id:int;
		public function CellModel(_id:int = -1, o:Object = null) 
		{
			if (_id > -1) {
				id = _id;
			}
			if(o!=null){
				data = o;
			}
			cacheAsBitmap = true;
		}
		public function set data(o:Object):void
		{
			_data = o;
			label = _data.label;
		}
		public function get data():Object
		{
			return _data;
		}
		public function resize():void
		{
			bg.width = width;
			bg.height = height;
			_labelTxt.x = (bg.width - _labelTxt.width) * .5;
			_labelTxt.y = (bg.height - _labelTxt.height) * .5;
			scaleX =
			scaleY = 1;
		}
		public function clone():ICell
		{
			return new CellModel(id,data) as ICell;
		}
	}

}