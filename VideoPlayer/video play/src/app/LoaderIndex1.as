﻿package src.app {	import flash.events.*;	import flash.display.MovieClip;	import com.nova.core.*;	import com.nova.core.events.*;	import flash.display.Loader;	import com.nova.server.xmlGatewayBase;	import com.nova.server.events.xmlGatewayEvent;	import flash.net.URLVariables;	import com.nova.log.*;	import com.nova.core.AutoSetPostion;	import flash.utils.setTimeout;	import com.greensock.TweenLite;	import flash.text.TextField;	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.geom.Matrix;	import flash.geom.Point;	import flash.geom.Rectangle;	import flash.utils.ByteArray;	import flash.net.URLLoader;	import flash.net.URLRequest;	import flash.net.URLRequestMethod;	import com.adobe.images.*;	import flash.external.ExternalInterface;	import flash.events.Event;	import flash.utils.Timer;	public class LoaderIndex1 extends BaseMovieClip{						private var curNum=0;		public var loadMC;		private var loader:LoaderMC;		private var isFirst:Boolean;		private var desObj;		public var picID=0;		public var delayTime=0.5;		private var tmpL=60;		private var scaleRate=1.8;		public var mCount=0;		public function LoaderIndex1()		{			stage.scaleMode ="noScale";			stage.stageFocusRect = false;			Global._stage=stage;			loader=new LoaderMC("el.swf");			loader.addEventListener(LoaderMCEvent.LOADER_START,loadStart);			loader.addEventListener(LoaderMCEvent.LOAD_VARS,loadProgress);			loader.addEventListener(LoaderMCEvent.LOADER_COMPLETE ,loadComplete);			//Global.pvObj= new GATracker( this, "UA-31204653-1", "AS3", false);			loadingBar.loading.txt.varTxt.text="0";		}		private function loadStart(e:LoaderMCEvent){					}		private function loadComplete(e:LoaderMCEvent){			TweenLite.to(loadingBar,0.5,{alpha:0,onComplete:function(){						 loadingBar.visible=false;						 removeChild(loadingBar);						 }});			loadMC=e.data;			e.data.alpha=0;			TweenLite.to(e.data,1,{alpha:1});			loadMM.addChild(e.data);				}		private function loadProgress(e:LoaderMCEvent){						//TweenLite.to(loadingBar.mc,1,{x:stage.stageWidth-stage.stageWidth/e.data});			loadingBar.loading.txt.varTxt.text=e.data;					}			}}