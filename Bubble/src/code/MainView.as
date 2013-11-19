package code
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ……
	 * @author 	yangsj 
	 * 			2013-11-17
	 */
	public class MainView extends Sprite
	{
		private var mainViewSkin:ui_Skin_MainView;
		private var bubbleCenter:BubbleCenter;
		private var currentSelectedItem:BubbleItem;
		
		private var vecItems:Vector.<BubbleItem> = new Vector.<BubbleItem>();
		private var vecItemsVo:Vector.<ItemVo> = new Vector.<ItemVo>();
		
		public function MainView()
		{
			super();
//			addChild( new ui_Skin_Background() );
			addChild( mainViewSkin ||= new ui_Skin_MainView() );
			
			initData();
			initItems();
			initCenter();
			
			addEventListener( GEvent.DRAG_START, dragStartHandler );
			addEventListener( GEvent.DRAG_COMPLETE, dragSuccessedHandler ); 
		}
		
		protected function dragStartHandler(event:GEvent):void
		{
			setItemEnabled( false, false );
			( event.data as BubbleItem).setArrow( true );
		}
		
		protected function dragSuccessedHandler(event:GEvent):void
		{
			var eData:Array = event.data as Array;
			var isSuccessed:Boolean = eData[0];
			
			if ( isSuccessed ) {
				if ( currentSelectedItem ) {
					currentSelectedItem.moveToStart( false );
				}
				currentSelectedItem = eData[1] as BubbleItem;
			}
			
			if ( isSuccessed ) {
				bubbleCenter.setData( (eData[1] as BubbleItem).data );
			}
			
			setItemEnabled( true, isSuccessed, isSuccessed ? 2 : 1 );
		}
		
		private function setItemEnabled( enbled:Boolean, isSelected:Boolean = false, step:int = 1 ):void
		{
			for each ( var item:BubbleItem in vecItems )
			{
				item.mouseEnabled = enbled;
				item.setArrow( false );
				if ( step == 2 )item.selected = true;
			}
		}
		
		private function initCenter():void
		{
			bubbleCenter = new BubbleCenter( mainViewSkin.getChildByName("skinCenter") as MovieClip );
		}
		
		private function initItems():void
		{
			var arrow:MovieClip;
			var mcSkin:MovieClip;
			var item:BubbleItem;
			for ( var i:int = 0; i < 8; i++ )
			{
				mcSkin = mainViewSkin.getChildByName( "item" + i ) as MovieClip;
				arrow = mainViewSkin.getChildByName( "arrow" + i ) as MovieClip;
				if ( mcSkin && arrow )
				{
					item = new BubbleItem( mcSkin, arrow );
					item.setData( vecItemsVo[ i ] );
					vecItems.push( item );
				}
			}
		}
		
		private function initData():void
		{
			var xmlList:XMLList = AppConfig.configXML.children();
			for each ( var xml:XML in xmlList )
			{
				var itemVo:ItemVo = new ItemVo();
				itemVo.id = xml.@id;
				itemVo.lab1 = xml.@labName0;
				itemVo.lab2 = xml.@labName1;
				vecItemsVo.push( itemVo );
			}
		}
		
	}
}