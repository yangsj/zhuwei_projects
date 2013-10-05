package victor
{
	import com.adobe.images.PNGEncoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
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
			// 调用php页面，sharetosns2.php 参数为pic1、pic2，year同时传递2个参数
			// 1），上传的图片地址 pic1=/upload/1.jpg | Global.commitFirstPicUrl
			// 2），上传的图片地址 pic2=/upload/2.jpg | Global.commitSecondPicUrl
			// 3）.选择的年份 year=2012
			
		}
		
		private function completeEditCompFunc1():void
		{
			// 立刻发现面劲轮廓
			// 调用php页面，sharetosns1.php 参数为pic1、year同时传递2个参数，
			// 1），上传的图片地址 pic1=/upload/1.jpg  | Global.commitFirstPicUrl
			// 2）.选择的年份 year=2012
		}
		
		private function completeEditCompFunc2():void
		{
			// 上传近照，挑战新旧对比自己
			DisplayUtil.removeAll( _container );
			_container.addChild( _uploadNowPicComp );
			_uploadNowPicComp.loadImage( Global.commitFirstPicUrl );
			_uploadNowPicComp.setLabel( _editAreaComp.currentYear );
		}
		
		private function oepnCamera():void
		{
			// 开启摄像头
			DisplayUtil.removeAll( _container );
			_container.addChild( _mediaComp );
			_mediaComp.loadOldImage( Global.commitFirstPicUrl );
			_mediaComp.startMedia();
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
		}
		
		protected function selectedAgainHandler(event:Event):void
		{
			_selectdComp.selectedImage();
		}
		
		protected function selectedLoadCompleteHandler( event:AppEvent ):void
		{
			var loader:Loader = event.data as Loader;
			if ( _uploadNowPicComp.parent )
			{
				DisplayUtil.removeAll( _container );
				_container.addChild(_mediaComp);
				_mediaComp.loadOldImage( Global.commitFirstPicUrl );
				_mediaComp.setNewLoader( loader );
			}
			else if ( _mediaComp.parent )
			{
				_mediaComp.setNewLoader( loader );
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