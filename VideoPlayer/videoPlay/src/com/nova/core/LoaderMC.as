package com.nova.core
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.net.URLRequest;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import flash.text.TextField;
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import com.nova.core.events.*;
	public class LoaderMC extends EventDispatcher implements ILoaderMC
	{
		public var loader:Loader = new Loader();
		public var loaderURL:String="";
		public var loaderName:String="";
		public var loaderNameTmp:String="";
		public var tmpMC:MovieClip=new MovieClip();
		public var curLoader:DisplayObject=null;
		public var loadTxtObj:Object;
		public var loadmc:MovieClip;
		public var loaderOnceMode:Boolean;
		private var loaderTmp:Loader=new Loader();
		public var loadNum:Number=100;
		public var loaderMC:MovieClip=new MovieClip();
		private var requestPic:URLRequest;
		public static var loaderArr:Array=new Array({name:"",loader:null});
		public function LoaderMC(URL:String="",loadOnce:Boolean=false)
		{
			super();	
			loaderOnceMode=loadOnce;
			
			//初始化判断是否一次加载
			//if(loaderOnceMode){				

			//}else{
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgress);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
				loader.contentLoaderInfo.addEventListener(Event.INIT, __LOAD_START);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			//}

			if(URL)loadMCswf(URL);
		}
		public function loadMCswf(str:String=""):void{	
			loaderURL=str;
			dispatchEvent(new LoaderMCEvent(LoaderMCEvent.LOADER_START));
			var strr=str.split(".");
			
			var isLoaded:Boolean;

			var request:URLRequest = new URLRequest(str);	
			requestPic=request;
									
			loaderName=strr[0];
			
			if(loaderOnceMode){	
				trace("loader"+curLoader);
				/*for(var i:int=0;i<EventEx.MAINMENU_NAME.length;i++){				
					if(strr[0]==EventEx.MAINMENU_NAME[i]) {
						isLoaded=true;
					}
				}	 */			
				//是否加载成功的判断,如果加载成功,则不再加载,直接显示存在于场景中的相应LOADER. 
				
/*				if(isLoaded){
					if(MovieClip(root).getChildByName(EventEx.MAINMENU_CUR_NAME)){
						Loader(MovieClip(root).getChildByName(EventEx.MAINMENU_CUR_NAME)).visible=false;
						MovieClip(Loader(MovieClip(root).getChildByName(EventEx.MAINMENU_CUR_NAME)).contentLoaderInfo.content).gotoAndStop(1);	
					}	
					EventEx.MAINMENU_CUR_NAME=strr[0];
				
					this.visible=false;
	
					if(MovieClip(root).getChildByName(strr[0]))Loader(MovieClip(root).getChildByName(strr[0])).visible=true;
					MovieClip(Loader(MovieClip(root).getChildByName(strr[0])).contentLoaderInfo.content).gotoAndPlay(2);
									
				}else{	
					loader = new Loader();	
					loaderNameTmp=strr[0];
					loader.name=strr[0];	
					loader.load(request);
				}*/
				
								/*if(!loaderArr){

					loaderArr=new Array();
					loaderArr.push({name:strr[0],loader:loaderTmp});
				}*/
/*				for(var i:uint=0;i<loaderArr.length-1;i++){
					trace("HHHHHHHHHHHH"+loaderArr[i].name); 
				}*/
				
				for each (var item in loaderArr) {					
					if(loaderName==item.name){
						curLoader=item.loader;
						break;
					}
				}
				
				if(!curLoader){
					var loaderTmp=new Loader();
					loaderTmp.load(request);
					loaderTmp.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgress);
					loaderTmp.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
				}else{
					trace("LOADER.........................");
					hideAll();
					loaderMC.addChild(curLoader);
					dispatchEvent(new LoaderMCEvent(LoaderMCEvent.LOADER_COMPLETE,loaderMC));
					curLoader=null;
				}
			}else{		
				
				
     			try {
						loader.unload();
						loader.load(request);
      			} catch (e:Error) {
						loader.unload();
						loader.load(request);
      			}				
			}
		}
		private function hideAll(){
			for each (var item in loaderArr) {	
				
				item.loader.visible=false;
			}
		}
		public function clear(){
			loader.unload();
			
		}
		
		private function __LOAD_START(e:Event):void {
			dispatchEvent(new LoaderMCEvent(LoaderMCEvent.LOADER_START));	
		}
		private function loadProgress(e:ProgressEvent):void {
			var loaded:uint = e.bytesLoaded;
			var total:uint = e.bytesTotal;
			var str:String=String(Math.floor((loaded/total)*loadNum));	
			dispatchEvent(new LoaderMCEvent(LoaderMCEvent.LOAD_VARS,str));		
		}
		public function ioErrorHandler(e:IOErrorEvent){
			trace("err");
			dispatchEvent(new LoaderMCEvent(LoaderMCEvent.LOADER_ERROR));		
		}
		public function loadComplete(e:Event):void {
			//loaderMC=new MovieClip();
			
			if(loaderOnceMode){					
				var mc:MovieClip=new MovieClip();
				trace(e.target);
				//if(!(e.target.content is Bitmap))mc.addChild(e.target.content);
				loaderArr.push({name:loaderName,loader:mc});				
				
				loaderMC.addChild(mc);
				dispatchEvent(new LoaderMCEvent(LoaderMCEvent.LOADER_COMPLETE,loaderMC));
				
			}else{
				
					//if(e.target.content is MovieClip)MovieClip(loader.content).play();
					//loader.name="loader";
					loaderMC.addChild(loader);
					dispatchEvent(new LoaderMCEvent(LoaderMCEvent.LOADER_COMPLETE,loaderMC));				
			}
		}
	}
}