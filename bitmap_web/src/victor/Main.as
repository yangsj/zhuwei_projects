package victor
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import victor.comp.CompleteEditComp;
	import victor.comp.EditAreaComp;
	import victor.comp.MediaComp;
	import victor.comp.SelectedPictureComp;
	import victor.comp.UploadNowPicComp;
	import victor.event.AppEvent;
	
	public class Main extends Sprite
	{
		
		private var _container:Sprite;
		
		private var _selectdComp:SelectedPictureComp;
		private var _editAreaComp:EditAreaComp;
		private var _mediaComp:MediaComp;
		private var _completeEditComp:CompleteEditComp;
		private var _uploadNowPicComp:UploadNowPicComp;
		
		public function Main()
		{
			_container = new Sprite();
			addChild( _container );
			
			_selectdComp = new SelectedPictureComp();
			_editAreaComp = new EditAreaComp();
			_mediaComp = new MediaComp( compareMediaCompFunc1, compareMediaCompFunc2 );
			_completeEditComp = new CompleteEditComp(completeEditCompFunc1, completeEditCompFunc2);
			_uploadNowPicComp = new UploadNowPicComp( oepnCamera, _selectdComp.selectedImage );
			
			addlistener();
			
			startApp();
		}
		
		private function startApp():void
		{
			if ( Global.isFronSNS )
			{
				DisplayUtil.removeAll( _container );
				_container.addChild(_editAreaComp);
				_editAreaComp.loadImageForSNS( Global.snsUrl );
			}
			else
			{
				_container.addChild( _selectdComp );
			}
		}
		
		
		private function compareMediaCompFunc1():void
		{
			completeEditCompFunc2();
		}
		
		private function compareMediaCompFunc2():void
		{
			// 查看对比
			// 调用php页面，http://www.aqmtl.com/cam/sharetosns2.php 参数为pic1、pic2，year同时传递2个参数
			// 1），上传的图片地址 pic1=/upload/1.jpg | Global.commitFirstPicUrl
			// 2），上传的图片地址 pic2=/upload/2.jpg | Global.commitSecondPicUrl
			// 3）.选择的年份 year=2012
			var url:String = "sharetosns2.php?pic1=" + Global.firstPicUrl + "&pic2=" + Global.secondPicUrl + "&year=" + Global.currentYear;
			navigateToURL(new URLRequest( url ),"_self");
//			var urlRequest:URLRequest = new URLRequest(url);
//			urlRequest.method = URLRequestMethod.POST;
//			var loader:URLLoader = new URLLoader();
//			loader.load( urlRequest );
		}
		
		private function completeEditCompFunc1():void
		{
			// 立刻发现面劲轮廓
			// 调用php页面，http://www.aqmtl.com/cam/sharetosns1.php 参数为pic1、year同时传递2个参数，
			// 1），上传的图片地址 pic1=/upload/1.jpg  | Global.commitFirstPicUrl
			// 2）.选择的年份 year=2012
			var url:String = "sharetosns1.php?pic1=" + Global.firstPicUrl + "&year=" + Global.currentYear;
			navigateToURL(new URLRequest( url ),"_self");
//			var urlRequest:URLRequest = new URLRequest(url);
//			urlRequest.method = URLRequestMethod.POST;
//			var loader:URLLoader = new URLLoader(); 
//			loader.load( urlRequest );
		}
		
		private function completeEditCompFunc2():void
		{
			// 上传近照，挑战新旧对比自己
			DisplayUtil.removeAll( _container );
			_container.addChild( _uploadNowPicComp );
			_uploadNowPicComp.loadImage( Global.commitFirstPicUrl );
			_uploadNowPicComp.setYear( Global.currentYear );
		}
		
		private function oepnCamera():void
		{
			// 开启摄像头
			DisplayUtil.removeAll( _container );
			_container.addChild( _mediaComp );
			_mediaComp.loadOldImage( Global.commitFirstPicUrl );
			_mediaComp.startMedia();
			_mediaComp.setYearInfo( Global.currentYear );
		}
		
		private function addlistener():void
		{
			Global.eventDispatcher.addEventListener(AppEvent.SELECTED_LOAD_COMPLETE, selectedLoadCompleteHandler );
			Global.eventDispatcher.addEventListener(AppEvent.SELECTED_AGAIN, selectedAgainHandler );
			Global.eventDispatcher.addEventListener(AppEvent.CONFIRM_COMMIT, confirmCommitHandler );
		}
		
		protected function confirmCommitHandler(event:Event):void
		{
			DisplayUtil.removeAll( _container );
			_container.addChild(_completeEditComp);
			_completeEditComp.loadImage( Global.commitFirstPicUrl );
			_completeEditComp.setYear( Global.currentYear );
		}
		
		protected function selectedAgainHandler(event:Event):void
		{
			_selectdComp.selectedImage();
		}
		
		protected function selectedLoadCompleteHandler( event:AppEvent ):void
		{
			var loader:DisplayObject = event.data as DisplayObject;
			if ( _uploadNowPicComp.parent )
			{
				DisplayUtil.removeAll( _container );
				_container.addChild(_mediaComp);
				_mediaComp.loadOldImage( Global.commitFirstPicUrl );
				_mediaComp.setNewBitmap( loader );
			}
			else if ( _mediaComp.parent )
			{
				_mediaComp.setNewBitmap( loader );
			}
			else
			{
				DisplayUtil.removeAll( _container );
				_container.addChild(_editAreaComp);
				_editAreaComp.setLoader( loader );
			}
		}
	}
}