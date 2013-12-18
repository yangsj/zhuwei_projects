package com.nova.core
{
	import flash.events.*;
	import flash.display.Stage;
	public class AutoSetPostion extends EventDispatcher
	{
		public var orgX:Number;
		public var orgY:Number;
		public var alignMode:String="";
		public var obj:Object;
		public var _stage:Stage;
		public var tmpXOffset:Number=0;
		public var tmpYOffset:Number=0;
		private var scaleRate:Number=0;
		private var isScale:Boolean;
		private var minScaleNum:Number=0;
		private var maxScaleNum:Number=0;
		private var orgR:Number=0;
		private var stageWidth:Number = 1000;
		private var stageHeight:Number = 660;
		public function AutoSetPostion($obj:Object,$stage:Stage,$mode:String,$_stageWidth:Number,$_stageHeight:Number,$minScaleNum,$maxScaleNum,$tmpXOffset:Number=0,$tmpYOffset:Number=0)
		{
			super();			
			stageWidth=$_stageWidth
			stageHeight=$_stageHeight,
			minScaleNum=$minScaleNum;
			maxScaleNum=$maxScaleNum;
			tmpXOffset=$tmpXOffset;
			tmpYOffset=$tmpYOffset;
			obj=$obj;			
			alignMode=$mode;
			_stage=$stage;
			_stage.scaleMode="noScale";
			_stage.addEventListener(Event.RESIZE, resizeMe);			
			orgX=stageWidth/2;
			orgY=stageHeight/2;
			tmpXOffset=obj.x;
			tmpYOffset=obj.y;
			scaleRate=obj.width/obj.height;
			orgR=Math.sqrt(_stage.stageWidth*_stage.stageWidth+_stage.stageHeight*_stage.stageHeight);
			resizeMe(new Event(''));
			
			trace("对象["+obj.name+"]加入自适应屏幕");
		}
		public static function too($target:Object,$stage:Stage,$mode:String,$_stageWidth:Number,$_stageHeight:Number,$minScaleNum:Number=0,$maxScaleNum:Number=1,$tmpXOffset:Number=0,$tmpYOffset:Number=0):AutoSetPostion{
			
			return new AutoSetPostion($target,$stage,$mode,$_stageWidth,$_stageHeight,$minScaleNum,$maxScaleNum,$tmpXOffset,$tmpYOffset);
			//return new autoSetPostion($target,$mode);
		}
		public function resizeMe(e:Event){
/*			if(isScale){
				trace(int(Math.max(100,(_stage.stageWidth/(orgX*2)*1))));
				obj.scaleX=obj.scaleY=_stage.stageWidth/(orgX*2)*1.5;
			}*/
			switch (alignMode){
/*				case "FULLSCREEN_SHOW_ALL":
					stage.scaleMode = StageScaleMode.SHOW_ALL;
					stage.displayState=StageDisplayState.FULL_SCREEN;*/
				case "HScale" :				
					//保持对象现有位置按左上角对齐,按屏幕宽度缩放;

					obj.scaleX=obj.scaleY=Math.max(minScaleNum,(_stage.stageWidth/(orgX*2)))*maxScaleNum;
					break;
				case "TLWScale" :				
					//保持对象现有位置按左上角对齐,按屏幕宽度缩放;
					obj.x = -_stage.stageWidth/2+orgX+tmpXOffset;
					obj.y = -_stage.stageHeight/2+orgY+tmpYOffset;
					obj.scaleX=obj.scaleY=Math.max(minScaleNum,(_stage.stageWidth/(orgX*2)))*maxScaleNum;
					break;
				case "TLHScale" :				
					//保持对象现有位置按左上角对齐,按屏幕高度缩放;
					obj.x = -_stage.stageWidth/2+orgX+tmpXOffset;
					obj.y = -_stage.stageHeight/2+orgY+tmpYOffset;
					obj.scaleX=obj.scaleY=Math.max(minScaleNum,(_stage.stageHeight/(orgY*2)))*maxScaleNum;
					break;
				case "THScale" :				
					//保持对象现有位置按左上角对齐,按屏幕高度缩放;
					//obj.x = -_stage.stageWidth/2+orgX+tmpXOffset;
					obj.y = -_stage.stageHeight/2+orgY+tmpYOffset;
					obj.scaleX=obj.scaleY=Math.max(minScaleNum,(_stage.stageHeight/(orgY*2)))*maxScaleNum;
					break;
				case "BLHScale" :				
					//保持对象现有位置按左上角对齐,按屏幕高度缩放;
					obj.x = -_stage.stageWidth/2+orgX+tmpXOffset;
					obj.y=_stage.stageHeight/2-orgY+tmpYOffset;
					obj.scaleX=obj.scaleY=Math.max(minScaleNum,(_stage.stageHeight/(orgY*2)))*maxScaleNum;
					break;
				case "TRHScale" :				
					//保持对象现有位置按右上角对齐,按屏幕高度缩放;
					obj.x=_stage.stageWidth/2-orgX+tmpXOffset;
					obj.y=-_stage.stageHeight/2+orgY+tmpYOffset;
					obj.scaleX=obj.scaleY=Math.max(minScaleNum,(_stage.stageHeight/(orgY*2)))*maxScaleNum;
					break;
				case "BRHScale" :				
					//保持对象现有位置按右上角对齐,按屏幕高度缩放;					
					obj.y=_stage.stageHeight/2-orgY+tmpYOffset;
					obj.x=_stage.stageWidth/2-orgX+tmpXOffset;
					
					obj.scaleX=obj.scaleY=Math.max(minScaleNum,(_stage.stageHeight/(orgY*2)))*maxScaleNum;
					trace(orgY*2);
					break;
				case "TLWHScale" :				
					//保持对象现有位置按左上角对齐,按屏幕宽高缩放;
					obj.x = -_stage.stageWidth/2+orgX+tmpXOffset;
					obj.y = -_stage.stageHeight/2+orgY+tmpYOffset;					
					var newR=Math.sqrt(_stage.stageWidth*_stage.stageWidth+_stage.stageHeight*_stage.stageHeight);
					obj.scaleX=obj.scaleY=Math.max(minScaleNum,(newR/orgR))*maxScaleNum;
					break;
				
				case "M":
					//保持对象现有位置并按左上角对齐				
					obj.x=_stage.stageWidth/2;
					obj.y=_stage.stageHeight/2;
					break;
				case "TL":
					//保持对象现有位置并按左上角对齐				
					obj.x=-_stage.stageWidth/2+orgX+tmpXOffset;
					obj.y=-_stage.stageHeight/2+orgY+tmpYOffset;
					break;
				case "TR":
					//保持对象现有位置并按右上角对齐				
					obj.x=_stage.stageWidth/2-orgX+tmpXOffset;
					obj.y=-_stage.stageHeight/2+orgY+tmpYOffset;
					break;
				case "R":
					//保持对象现有位置并按右上角对齐				
					obj.x=_stage.stageWidth/2-orgX+tmpXOffset;
					
					break;
				case "BL":
					//保持对象现有位置并按左下角对齐				
					obj.x=-_stage.stageWidth/2+orgX+tmpXOffset;
					obj.y=_stage.stageHeight/2-orgY+tmpYOffset;				
					break;
				case "BR":
					//保持对象现有位置并按右下角对齐				
					obj.x=_stage.stageWidth/2-orgX+tmpXOffset;
					obj.y=_stage.stageHeight/2-orgY+tmpYOffset;
					break;		
				case "BScaleX":
					//按屏幕水平拉伸,底部对齐;				
					obj.x=-_stage.stageWidth/2+orgX;
					obj.y=_stage.stageHeight/2-orgY+tmpYOffset;
					obj.width=_stage.stageWidth;
					break;			
				case "TScaleX":
					//按屏幕水平拉伸,顶部对齐;				
					obj.x=-_stage.stageWidth/2+orgX;
					obj.y=-_stage.stageHeight/2+orgY+tmpYOffset;
					obj.width=_stage.stageWidth;
					break;
				case "ScaleX":
					//按屏幕水平拉伸,顶部对齐;				
					//obj.x=-_stage.stageWidth/2+orgX+tmpXOffset;
					obj.x=-_stage.stageWidth/2+orgX;
					obj.width=_stage.stageWidth+1500;
					break;
				case "AllScale":
					//按对象同比拉伸,左上对齐;				

					obj.width=_stage.stageWidth;
					obj.height=_stage.stageHeight;
					break;
				case "TAllScale":
					//按对象同比拉伸,左上对齐;				
					obj.x=-_stage.stageWidth/2+orgX+tmpXOffset;
					obj.y=-_stage.stageHeight/2+orgY+tmpYOffset;
					obj.width=_stage.stageWidth;
					obj.height=_stage.stageWidth/scaleRate;
					break;
				case "BAllScale":
					//按对象同比拉伸,左下对齐;				
					obj.x=-_stage.stageWidth/2+orgX+tmpXOffset;
					obj.y=_stage.stageHeight/2-orgY+tmpYOffset;	
					obj.width=_stage.stageWidth;
					obj.height=_stage.stageWidth/scaleRate;
					break;
				default:
        			trace("Not 0, 1, or 2");
			}

		}
	}
}