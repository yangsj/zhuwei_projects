package com.cg.utils
{
	import flash.display.DisplayObject;
	import flash.geom.*;
	
	public class cgTransform
	{
		////////////////////////////////////////////////////////////////
		//将舞台坐标下的rect转换成某个容器坐标下的rect
		/////////////////////////////////////////////////////////////////
		public static function globalRectToLocal(o:DisplayObject,rect:Rectangle):Rectangle {
			var _ps:Array=[new Point(rect.left,rect.top),new Point(rect.right,rect.bottom)];
			_ps[0]=o.globalToLocal(_ps[0]);
			_ps[1]=o.globalToLocal(_ps[1]);
			return new Rectangle(_ps[0].x,_ps[0].y,_ps[1].x - _ps[0].x,_ps[1].y - _ps[0].y);
		}
		////////////////////////////////////////////////////////////////
		//将某个容器坐标下的rect转换成舞台坐标下的rect
		/////////////////////////////////////////////////////////////////
		public static function localRectToGlobal(o:DisplayObject,rect:Rectangle):Rectangle {
			var _ps:Array=[new Point(rect.left,rect.top),new Point(rect.right,rect.bottom)];
			_ps[0]=o.localToGlobal(_ps[0]);
			_ps[1]=o.localToGlobal(_ps[1]);
			return new Rectangle(_ps[0].x,_ps[0].y,_ps[1].x - _ps[0].x,_ps[1].y - _ps[0].y);
		}
		////////////////////////////////////////////////////////////////
		//对齐，与坐标点无关，当o的父对象有旋转时，会出现偏差
		//如果o==stage 不做改变
		//如果o==mainTimeline  对齐mainTimeline到舞台
		//如果target==null,target=stage
		//如果target=stage，与舞台对齐
		//例：Transform.alignTo
		//如果reference_o不为空，参考reference_o的rect进行对齐，一般reference_o是o内部的一个child
		/////////////////////////////////////////////////////////////////
		public static function alignTo(o:DisplayObject,target:DisplayObject=null,type:String="TL",reference_o:DisplayObject=null):void {
			if (o.stage==null  || o ==o.stage) {
				return;
			}
			var y_type=type.substr(0,1).toLocaleUpperCase();
			var x_type=type.substr(1,1).toLocaleUpperCase();
			var o_parent:DisplayObject=o.parent as DisplayObject;
			var t_r:Rectangle;
			if (target==null) {
				target=o.stage;
			}
			if (target==o.stage) {
				t_r=new Rectangle(0,0,target.stage.stageWidth,target.stage.stageHeight);
				t_r=globalRectToLocal(o_parent,t_r);
			} else {
				t_r=target.getRect(o_parent);
			}
			var o_r:Rectangle=reference_o ? reference_o.getRect(o_parent) : o.getRect(o_parent);
			switch (y_type) {
				case "T" :
					o.y+=t_r.top-o_r.top;
					break;
				case "B" :
					o.y+=t_r.bottom-o_r.bottom;
					break;
				case "C" :
					o.y+=(t_r.top+t_r.bottom-o_r.top-o_r.bottom)*.5;
					break;
				default :
		
			}
			switch (x_type) {
				case "L" :
					o.x+=t_r.left-o_r.left;
					break;
				case "R" :
					o.x+=t_r.right-o_r.right;
					break;
				case "C" :
					o.x+=(t_r.left+t_r.right-o_r.left-o_r.right)*.5;
				default :
			}
		}
		/*
		根据不同的模式进行缩放：
		"showAll":小于容器尺寸时，不缩放，大于容器尺寸时，等比变形
		"exactFit": 完全匹配
		"inBox": 在容器内部等比缩放 
		"noScale":。不变形，缩放到容器
		"cut":裁减
		任何其它值都会将 _scale_mode 属性设置为默认值 "exactFit"。
		*/
		public static function scaleTo(o:DisplayObject, w:Number, h:Number, _scale_mode:String="exactFit") {
			var temp_w:Number;
			var temp_h:Number
			function scaleInBox(){
				temp_w = 0;
				temp_h = 0;
				if (o.width/w>o.height/h) {
					temp_w = w;
					temp_h = Math.round(o.height*w/o.width);
				} else {
					temp_w = Math.round(o.width*h/o.height);
					temp_h = h;
				}
				o.width = temp_w;
				o.height = temp_h;
			}
			function cut():void
			{
				temp_w = 0;
				temp_h = 0;
				if (o.width/w<o.height/h) {
					temp_w = w;
					temp_h = Math.round(o.height*w/o.width);
				} else {
					temp_w = Math.round(o.width*h/o.height);
					temp_h = h;
				}
				o.width = temp_w;
				o.height = temp_h;
			}
			switch (_scale_mode) {
				case "exactFit" :
					o.width = w;
					o.height = h;
					break;
				case "noScale" :
					break;
				case "showAll":
					if(o.width>w || o.height>h){
						scaleInBox();
					}
					break;
				case "cut":
					cut();
					break;
				case "inBox":
				default :
					scaleInBox();
			}
		}
		/*
		 让mc始终在rect内移动
		 * */
		public static function lockInRect(mc:DisplayObject,rect:Rectangle):void
		{
			if (mc.width > rect.width) {
				if (mc.x > rect.left) {
					mc.x = rect.left;
				}else if (mc.x < rect.right - mc.width) {
					mc.x = rect.right - mc.width;
				}
			}else if (mc.width < rect.width) {
				if (mc.x < rect.left) {
					mc.x = rect.left;
				}else if (mc.x > rect.right - mc.width) {
					mc.x = rect.right - mc.width;
				}
			}else {
				mc.x = rect.left;
			}
			
			if (mc.height > rect.height) {
				if (mc.y > rect.top) {
					mc.y = rect.top;
				}else if (mc.y < rect.bottom - mc.height) {
					mc.y = rect.bottom - mc.height;
				}
			}else if (mc.height < rect.height) {
				if (mc.y < rect.top) {
					mc.y = rect.top;
				}else if (mc.y > rect.bottom - mc.height) {
					mc.y = rect.bottom - mc.height;
				}
			}else {
				mc.y = rect.top;
			}
		}
		/*
		 以外部设定点为中心点缩放矩阵，适合变形动画
		 * */
		public static function matrixZoomByXY(m:Matrix,cx:Number,cy:Number,zoom:Number,minScale:Number=-10000,maxScale:Number=10000):Matrix
		{
			m.translate(-cx, -cy);
			m.scale(zoom, zoom);
			if (m.a<minScale) {
				m.scale(minScale/m.a, minScale/m.d);
			} else if (m.a>maxScale) {
				m.scale(maxScale/m.a, maxScale/m.d);
			}
			m.translate(cx, cy);
			return m
		}
		
		/*
		 以内部设定点为中心点缩放矩阵，适合变形动画
		 * */
		public static function matrixZoomByInnerXY(m:Matrix,cx:Number,cy:Number,zoom:Number,minScale:Number=-10000,maxScale:Number=10000):Matrix
		{
			var p:Point=new Point(cx,cy);
			p=m.transformPoint(p);
			return matrixZoomByXY(m,p.x,p.y,zoom,minScale,maxScale);
		}
		/*
		 以外部设定点为中心点缩放
		 * */
		public static function zoomByXY(mc:DisplayObject,cx:Number,cy:Number,zoom:Number,minScale:Number=-10000,maxScale:Number=10000):void
		{
			var m:Matrix = mc.transform.matrix;
			mc.transform.matrix = matrixZoomByXY(m,cx,cy,zoom,minScale,maxScale);
		}
		/*
		 以内部部设定点为中心点缩放
		 * */
		public static function zoomByInnerXY(mc:DisplayObject,cx:Number,cy:Number,zoom:Number,minScale:Number=-10000,maxScale:Number=10000):void
		{
			var m:Matrix = mc.transform.matrix;
			mc.transform.matrix = matrixZoomByInnerXY(m,cx,cy,zoom,minScale,maxScale);
		}
		
	}
}