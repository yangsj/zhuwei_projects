package victor
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import victor.comp.EditAreaComp;
	import victor.comp.SelectedPictureComp;
	import victor.event.AppEvent;
	
	public class Main extends Sprite
	{
		private var _imgBg:Sprite;
		
		private var _selectdComp:SelectedPictureComp;
		private var _editAreaComp:EditAreaComp;
		
		public function Main()
		{
			_imgBg = new ui_Skin_Background();
			addChild( _imgBg );
			
			_selectdComp = new SelectedPictureComp();
			addChild( _selectdComp );
			
			_editAreaComp = new EditAreaComp();
			addChild( _editAreaComp );
			
			_selectdComp.visible = true;
			_editAreaComp.visible = false;
			
			addlistener();
		}
		
		private function addlistener():void
		{
			Global.eventDispatcher.addEventListener(AppEvent.SELECTED_LOAD_COMPLETE, selectedLoadCompleteHandler );
		}
		
		protected function selectedLoadCompleteHandler(event:Event):void
		{
			var loader:Loader = new Loader();
			_selectdComp.visible = false;
			_editAreaComp.visible = true;
			_editAreaComp.setLoader( loader );
		}
	}
}