package code
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	/**
	 * ……
	 * @author 	yangsj 
	 * 			2013-11-17
	 */
	public class BubbleCenter 
	{
		private var _skin:MovieClip;
		private var _btnCommit:InteractiveObject;
		private var _txtName:TextField;
		private var _txtLab0:TextField;
		private var _txtLab1:TextField;
		private var _picContainer:Sprite;
		private var _mcArea:Sprite;
		
		private var _data:ItemVo;
		
		private const LAB_NOT:String = "lab1";/// 未选择前
		private const LAB_YES:String = "lab2";/// 选择后
		
		public function BubbleCenter( skin:MovieClip )
		{
			_skin = skin;
			
			DisplayUtil.stopAllMovieClips( skin );
			
			_txtName = _skin.getChildByName( "txtName" ) as TextField;
			_txtLab0 = _skin.getChildByName( "txtLab0" ) as TextField;
			_txtLab1 = _skin.getChildByName( "txtLab1" ) as TextField;
			_picContainer = _skin.getChildByName( "picContainer" ) as Sprite || new Sprite(); 
			_btnCommit = _skin.getChildByName( "btnCommit" ) as InteractiveObject;
			_mcArea = _skin.getChildByName( "mcArea" ) as Sprite || new Sprite(); 
			
			_btnCommit.addEventListener(MouseEvent.CLICK, btnCommitOnClickHandler ); 
			_mcArea.addEventListener(MouseEvent.MOUSE_UP, mouseHandler, false, int.MAX_VALUE );
			_btnCommit.addEventListener(MouseEvent.MOUSE_UP, mouseHandler, false, int.MAX_VALUE );
			
			_txtLab0.visible = false;
			_txtLab1.visible = false;
			_btnCommit.visible = false;
			_mcArea.mouseChildren = false;
			
			_skin.gotoAndStop( LAB_NOT );
			
			_picContainer.removeChildren();
			if ( AppConfig.playerPicUrl )
			{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler );
				loader.load( new URLRequest( AppConfig.playerPicUrl ));
			}
			_txtName.text = AppConfig.playerName + "的微修护：";
		}
		
		protected function loadCompleteHandler(event:Event):void
		{
			var loader:Loader = event.target.loader as Loader;
			var dis:DisplayObject = loader;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadCompleteHandler );
			_picContainer.addChild( dis );
			
			var scale:Number = 1;
			if ( dis.width > dis.height )
				scale = 100 / dis.width;
			else scale = 100 / dis.height;
			dis.scaleX = dis.scaleY = scale;
		}
		
		protected function btnCommitOnClickHandler(event:MouseEvent):void
		{
			trace("提交"); // step2.php?t=
			var reqUrl:String = "step3.php?t="+_data.id;
			navigateToURL(new URLRequest( reqUrl ),"_self");
		}
		
		protected function mouseHandler(event:MouseEvent):void
		{
			AppConfig.eventDispatcher.dispatchEvent( new GEvent( GEvent.DRAG_SUCCESSED ));
		}
		
		public function setData( data:ItemVo ):void
		{
			_data = data;
			_btnCommit.visible = true;
			_skin.gotoAndStop( LAB_YES );
//			DisplayUtil.stopAllMovieClips( _skin );
			
			_txtLab0.visible = true;
			_txtLab1.visible = true;
			
			_txtLab0.text = data.lab1;
			_txtLab1.text = data.lab2;
			
		}
		
		private function get desString():String
		{
			var string:String = "假使能回到如初之美，<br>我想要 " + HtmlText.format(_data.lab1, 0xcf9654, 19, "", false, false, true) + " 的肌肤<br>重现最初 "+ HtmlText.format( _data.lab2, 0xcf9654, 19, "", false, false, true ) + " 的那个自我";
			return string;
		}
		
		
		
		
	}
}