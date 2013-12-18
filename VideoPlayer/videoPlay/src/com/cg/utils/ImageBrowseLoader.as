package com.cg.utils {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	public class ImageBrowseLoader extends EventDispatcher 
	{
		private var _fileRefre : FileReference;
		private var _loader:Loader;
		public function ImageBrowseLoader(target : IEventDispatcher = null) {
			super(target);
		}	

		public function destroy():void
		{
			if (_fileRefre != null) {	
				_fileRefre.removeEventListener(Event.SELECT, fileRefSelectHandler);
				_fileRefre.removeEventListener(Event.COMPLETE, fileRefCompletedHandle);
				_fileRefre.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, fileRefErrorHandle);
				_fileRefre.removeEventListener(IOErrorEvent.IO_ERROR, fileRefErrorHandle);
			}
			if (_loader != null) {
				_loader.unloadAndStop();
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadBitmapCompletedHandle);			
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadBitmapErrorHandle);
			}
		}
		public function browse() : void {
			_fileRefre = new FileReference();
			_fileRefre.addEventListener(Event.SELECT, fileRefSelectHandler);
			_fileRefre.addEventListener(Event.COMPLETE, fileRefCompletedHandle);
			_fileRefre.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fileRefErrorHandle);
			_fileRefre.addEventListener(IOErrorEvent.IO_ERROR, fileRefErrorHandle);
			
			var filesArr : Array = new Array();
			filesArr.push(new FileFilter("Images", "*.jpg;*.jpeg;*.gif;*.png"));
			_fileRefre.browse(filesArr);
		}

		private function fileRefSelectHandler(event : Event) : void {
			_fileRefre.load();
		}

		private function fileRefErrorHandle(event : SecurityErrorEvent) : void {
			trace('Error: load  Image File Error !!!! ');
		}

		private function fileRefCompletedHandle(event : Event) : void {			
			_fileRefre = event.currentTarget as FileReference;
			loadBitmap(_fileRefre.data);
		}		

		////////////////////////////////////////////////////////
		private function loadBitmap(data : ByteArray) : void {
			if (_loader == null) {
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadBitmapCompletedHandle);			
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadBitmapErrorHandle);
			}
			_loader.loadBytes(data);
		}

		private function loadBitmapErrorHandle(event : IOErrorEvent) : void {
			trace('Error: load  Bitmap Error !!!! ');
		}

		private var _bitmapData : BitmapData;

		private function loadBitmapCompletedHandle(event : Event) : void {
			try {
				var info : LoaderInfo = event.currentTarget as LoaderInfo;
				var l : Loader = info.loader as Loader;
				var bitmap : Bitmap = l.content as Bitmap;
				_bitmapData = bitmap.bitmapData;
				dispatchEvent(new Event(Event.COMPLETE));
			}catch(error : Error) {
				trace('Error: not Image format!!!! ');			
			}
		}

		public function get bitmapData() : BitmapData {
			return _bitmapData;
		}

		public function get imageSprite() : Sprite {
			var bitmap : Bitmap = new Bitmap(bitmapData);
			bitmap.smoothing = true;
			var sprite : Sprite = new Sprite();
			sprite.addChild(bitmap);
			return sprite; 
		}		
	}
}
