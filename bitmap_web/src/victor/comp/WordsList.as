package victor.comp
{
	import com.greensock.TweenMax;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import victor.Global;
	import victor.TabButtonControl;
	import victor.event.AppEvent;
	
	
	/**
	 * ……
	 * @author 	yangsj 
	 * 			2013-10-11
	 */
	public class WordsList extends Sprite
	{
		private const WORD_LIST:Array = ["的那天格外美好", "的那天心情杠杠", "的那天秋高气爽", "的那天阳光明媚"];
		
		private var vecList:Vector.<MovieClip> = new Vector.<MovieClip>();
		
		private var skin:ui_Skin_WordList;
		private var btn:SimpleButton;
		private var listArea:Sprite;
		private var itemContainer:Sprite;
		private var isOpen:Boolean = false;
		private var tabControl:TabButtonControl;
		private var selectedItem:MovieClip;
		
		public function WordsList()
		{
			x = 144;
			y = 344;
			
			skin = new ui_Skin_WordList();
			addChild( skin );
			listArea = new Sprite();
			listArea.y = skin.height;
			itemContainer = new Sprite();
			listArea.addChild( itemContainer );
			skin.addChild( listArea );
			
			btn = skin.btn;
			btn.addEventListener( MouseEvent.CLICK, onClickHandler );
			
			addEventListener( MouseEvent.CLICK, onThisHandler );
			
			intiList();
			
			filters = [new DropShadowFilter(4,45,0,0.8,20,20,0.3),new DropShadowFilter(4,135,0,0.8,20,20,0.3)];
		}
		
		private function intiList():void
		{
			var mc:MovieClip;
			tabControl = new TabButtonControl( tabControlHandler );
			for (var i:int = 0; i < WORD_LIST.length; i++ )
			{
				mc = new ui_Skin_WordItem();
				mc.y = mc.height * i;
				setYearForItem( mc, 2013, WORD_LIST[ i ] );
				itemContainer.addChild( mc );
				tabControl.addTarget( mc );
				vecList[ i ] = mc;
			}
			mc.line.visible = false;
			listArea.scrollRect = new Rectangle(0,0,itemContainer.width, itemContainer.height );
			hideCompleted();
			tabControl.setTargetByIndex( 0 );
			itemContainer.graphics.beginFill( 0xffffff );
			itemContainer.graphics.drawRoundRect(0,0,itemContainer.width,itemContainer.height,10);
			itemContainer.graphics.endFill();
		}
		
		private function tabControlHandler( clickTarget:MovieClip, data:* = null ):void
		{
			var boolean:Boolean = Boolean( selectedItem );
			selectedItem = clickTarget;
			if ( boolean ) draw();
		}
		
		private function draw():void
		{
			if ( selectedItem )
			{
				var txt:TextField = selectedItem.txtLabel2;
				var bitmapData:BitmapData = new BitmapData( txt.width, txt.height, true, 0 );
				bitmapData.draw( txt, new Matrix(1,0,0,1,10,-6) );
				Global.eventDispatcher.dispatchEvent( new AppEvent( AppEvent.SELCTED_DES, bitmapData ));
			}
		}
		
		protected function onThisHandler(event:MouseEvent):void
		{
			event.stopPropagation();
		}
		
		protected function onClickHandler( event:MouseEvent ):void
		{
			if ( isOpen )
				hide();
			else open();
		}
		
		protected function onStageHandler(event:MouseEvent):void
		{
			hide();
		}

		private function open():void
		{
			isOpen = true;
			TweenMax.killTweensOf( itemContainer );
			TweenMax.to( itemContainer, 0.2, { y: 0, onComplete: openCompleted });
		}

		private function hide():void
		{
			isOpen = false;
			TweenMax.killTweensOf( itemContainer );
			TweenMax.to( itemContainer, 0.2, { y: -itemContainer.height, onComplete: hideCompleted });
			appStage.removeEventListener( MouseEvent.CLICK, onStageHandler );
		}

		private function openCompleted():void
		{
			isOpen = true;
			TweenMax.killTweensOf( itemContainer );
			appStage.addEventListener( MouseEvent.CLICK, onStageHandler );
		}
		
		private function hideCompleted():void
		{
			isOpen = false;
			itemContainer.y = -itemContainer.height;
		}
		
		public function setYear( year:int ):void
		{
			var length:int = WORD_LIST.length;
			for ( var i:int = 0; i < length; i++ )
				setYearForItem( vecList[ i ], year, WORD_LIST[ i ] );
			draw();
		}
		
		private function setYearForItem( mc:MovieClip, year:int, des:String ):void
		{
			var txtYear:TextField = mc.getChildByName( "txtYear" ) as TextField;
			var txtLabel1:TextField = mc.getChildByName( "txtLabel1" ) as TextField;
			var txtLabel2:TextField = mc.getChildByName( "txtLabel2" ) as TextField;
			var text:String = "<font size=\"17\" face=\"" + txtYear.defaultTextFormat.font + "\">" + year + "</font>" + des;
			txtLabel1.embedFonts = true;
			txtLabel2.embedFonts = true;
			txtLabel1.htmlText = text;
			txtLabel2.htmlText = text;
		}
		
	}
}