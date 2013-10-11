package victor
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
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
		private var _uploadNowPicComp:UploadNowPicComp;
		
		public function Main()
		{
			_container = new Sprite();
			addChild( _container );
			
			_selectdComp = new SelectedPictureComp();
			_editAreaComp = new EditAreaComp();
			_uploadNowPicComp = new UploadNowPicComp( oepnCamera, _selectdComp.selectedImage );
			_mediaComp = new MediaComp( compareMediaCompFunc1, compareMediaCompFunc2 );
			
			addlistener();
			
			startApp();
		}
		
		private function startApp():void
		{
			if ( Global.isFronSNS )
			{
				DisplayUtil.removeAll( _container );
				if ( Global.step == 1 )
				{
					_container.addChild(_editAreaComp);
					_editAreaComp.loadImageForSNS( Global.snsUrl );
				}
				else if ( Global.step == 2 )
				{
					Global.commitFirstPicUrl = Global.snsUrl;
					DisplayUtil.removeAll( _container );
					_container.addChild( _uploadNowPicComp );
					_uploadNowPicComp.loadImage( Global.snsUrl );
				}
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
		
		// 调用页面
		private function completeEditCompFunc1():void
		{
			/* 	立刻发现面劲轮廓
				调用php页面，http://www.aqmtl.com/cam/sharetosns1.php 参数为pic1、year同时传递2个参数，
				1），上传的图片地址 pic1=/upload/1.png  | Global.commitFirstPicUrl
				2）.选择的年份 year=2012
			*/
			var url:String = "sharetosns1.php?pic1=" + Global.firstPicUrl + "&year=" + Global.currentYear;
			navigateToURL(new URLRequest( url ),"_self");
		}
		
		private function completeEditCompFunc2():void
		{
			// 上传近照，挑战新旧对比自己
			DisplayUtil.removeAll( _container );
			_container.addChild( _uploadNowPicComp );
			_uploadNowPicComp.loadImage( Global.commitFirstPicUrl );
		}
		
		private function compareMediaCompFunc2():void
		{
			/* 	查看对比
				 调用php页面，http://www.aqmtl.com/cam/sharetosns2.php 参数为pic1、pic2，year同时传递2个参数
			 	1），上传的图片地址 pic1=/upload/1.png | Global.commitFirstPicUrl
			 	2），上传的图片地址 pic2=/upload/2.png | Global.commitSecondPicUrl
				3）.选择的年份 year=2012
			*/
			var url:String = "sharetosns2.php?pic1=" + Global.firstPicUrl + "&pic2=" + Global.secondPicUrl + "&year=" + Global.currentYear;
			navigateToURL(new URLRequest( url ),"_self");
		}
		
		private function oepnCamera():void
		{
			// 开启摄像头
			/*
			DisplayUtil.removeAll( _container );
			_container.addChild( _mediaComp );
			_mediaComp.loadOldImage( Global.commitFirstPicUrl );
			_mediaComp.startMedia();
			_mediaComp.setYearInfo( Global.currentYear );
			*/
			
			// 调用Js
			ExternalManager.callHtmlSelectedImage();
		}

		private function addlistener():void
		{
			Global.eventDispatcher.addEventListener( AppEvent.SELECTED_LOAD_COMPLETE, selectedLoadCompleteHandler );
			Global.eventDispatcher.addEventListener( AppEvent.SELECTED_AGAIN, selectedAgainHandler );
			Global.eventDispatcher.addEventListener( AppEvent.CONFIRM_COMMIT, confirmCommitHandler );
			Global.eventDispatcher.addEventListener( AppEvent.SELECTED_IMG_FROM_HTML, selectedImgFromHtml );
		}
		
		protected function selectedImgFromHtml( event:AppEvent ):void
		{
			DisplayUtil.removeAll( _container );
			_container.addChild(_mediaComp);
			_mediaComp.loadOldImage( Global.commitFirstPicUrl );
			_mediaComp.loadNewImage( event.data as String );
		}

		protected function confirmCommitHandler( event:AppEvent ):void
		{
			if ( Global.isTest )
				completeEditCompFunc2(); // 临时本地测试
			else
				completeEditCompFunc1(); // 正式
		}
			
		protected function selectedAgainHandler( event:AppEvent ):void
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