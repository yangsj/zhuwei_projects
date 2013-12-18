package com.nova.core
{
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import com.nova.core.*;
	import com.nova.core.events.*;
	import flash.display.Sprite;
	public class uploadPic extends Sprite
	{
		private var uploadURL:URLRequest;
		private var file:FileReference;
		private var filePath:String;
		public function uploadPic()
		{
			file = new FileReference();
			file.addEventListener(Event.SELECT, selectHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, completeHandler);
		}
		private function selectHandler(event:Event):void {
			trace("select a pic");
			uploadPicFun(filePath);
		}
		private function ioErrorHandler(e:IOErrorEvent){
			dispatchEvent(new Event("picUploadErr1"));
		}
		private function progressHandler(event:ProgressEvent):void {
			var file:FileReference = FileReference(event.target);
			dispatchEvent(new LoaderMCEvent("uploadPicLoadProgress",int((event.bytesLoaded/event.bytesTotal)*100)+"%"));
			
		}
		private function completeHandler(event:DataEvent):void {			
			dispatchEvent(new LoaderMCEvent("uploadPicLoadComplete",XML(event.data)));
		}
		public function selFileFun($filePath:String){
			filePath=$filePath;
			//var fileFilter:FileFilter = new FileFilter("Images", "*.jpg");
			
			var fileFilter1:FileFilter = new FileFilter("Images", "*.png;*.gif;*.jpg;*.jpeg;");
			
			file.browse([fileFilter1]);
		}
		public function uploadPicFun($filePath:String){
			
			trace("大小："+file.size);
			if (file.size>1024*500) {
				trace("文件太大");
				dispatchEvent(new Event("picUploadErr0"));
			} else {
				//savedName =escape(file.name);
				//parent.savedName=savedName;
				uploadURL = new URLRequest();
				var uploadName=2;
				uploadURL.url =$filePath;
				trace("{{{{{{{{{"+file.name);
				file.upload(uploadURL,"image");
			//	navigateToURL(uploadURL,"_blank");
		
			}
		}
	}
}