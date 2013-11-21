package code
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
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
			
			addChild( mainViewSkin ||= new ui_Skin_MainView() );
			mainViewSkin.addEventListener(Event.ENTER_FRAME, enterFrameHandler );
			
			initCenter();
			initData();
			initNames();
			addListeners();
		}
		
		protected function enterFrameHandler(event:Event):void
		{
			if ( mainViewSkin.currentFrame == mainViewSkin.totalFrames ) 
			{
				mainViewSkin.removeEventListener(Event.ENTER_FRAME, enterFrameHandler );
				initItems();
			}
		}
		
		private function initData():void
		{
			var xmlList:XMLList = AppConfig.configXML.children();
			var itemVo:ItemVo;
			for each ( var xml:XML in xmlList )
			{
				itemVo = new ItemVo();
				itemVo.id = xml.@id;
				itemVo.lab1 = xml.@labName0;
				itemVo.lab2 = xml.@labName1;
				vecItemsVo.push( itemVo );
			}
		}
		
		private function initNames():void
		{
			var arrow:MovieClip;
			var mcSkin:MovieClip;
			var item:BubbleItem;
			var itemVo:ItemVo;
			for ( var i:int = 0; i < 8; i++ )
			{
				itemVo = vecItemsVo[i];
				mcSkin = mainViewSkin.getChildByName( "item" + i ) as MovieClip;
				arrow = mainViewSkin.getChildByName( "arrow" + i ) as MovieClip;
				if ( mcSkin ) {
					mcSkin.gotoAndStop( 1 );
					mcSkin.txtName0.text = itemVo.lab1;
					mcSkin.txtName1.text = itemVo.lab2;
					mcSkin.hand.visible = false;
				}
				if ( arrow ) arrow.visible = false;
			}
		}
		
		private function initItems():void
		{
			var arrow:MovieClip;
			var mcSkin:MovieClip;
			var item:BubbleItem;
			var arr:Array = [ -1, 3.1, 6.2, 9.3, 12.4, 15.5, 18.6, 21.7 ];
			arr.sort( function abc():Number { return int(Math.random() * 3 - 1 ) } );
			for ( var i:int = 0; i < 8; i++ )
			{
				mcSkin = mainViewSkin.getChildByName( "item" + i ) as MovieClip;
				arrow = mainViewSkin.getChildByName( "arrow" + i ) as MovieClip;
				if ( mcSkin && arrow )
				{
					mcSkin.alpha = 1;
					item = new BubbleItem( mcSkin, arrow );
					item.setData( vecItemsVo[ i ] );
					item.initShowArrow( arr[ i ] );
					vecItems.push( item );
				}
			}
		}
		
		private function initCenter():void
		{
			var skinCenter:MovieClip = mainViewSkin.getChildByName("skinCenter") as MovieClip;
			bubbleCenter = new BubbleCenter( skinCenter );
		}
		
		private function addListeners():void
		{
			addEventListener( GEvent.DRAG_START, dragStartHandler );
			addEventListener( GEvent.DRAG_COMPLETE, dragSuccessedHandler ); 
			addEventListener( GEvent.MOUSE_OVER, itemMouseHandler ); 
			addEventListener( GEvent.MOUSE_OUT,  itemMouseHandler );
		}
		
		protected function itemMouseHandler( event:GEvent ):void
		{
			var item:BubbleItem = event.data as BubbleItem;
			if ( item ) {
				if ( event.type == GEvent.MOUSE_OVER ) {
					for each ( var temp:BubbleItem in vecItems ) {
						temp.initShowArrow();
					}
				}
			}
		}
		
		private function setItemEnabled( enbled:Boolean, isSelected:Boolean = false, step:int = 1 ):void
		{
			for each ( var item:BubbleItem in vecItems )
			{
				item.mouseEnabled = enbled;
				item.setArrow( false );
				if ( step == 2 ) item.selected = true;
			}
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
		
	}
}