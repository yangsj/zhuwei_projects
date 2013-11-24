package com.cg.utils{
	//基本画图方法
	//作者：chenlangeer
	//email/MSN:chenlangeer@hotmail.com
	//版本：3.0
	//发布时间:2008/8/12
	import com.cg.geom.*;
	
	import flash.display.Graphics;
	import flash.geom.*;
	public class exShape {
		//矩形
		public static function drawRect(graphic:Graphics, rect:Rectangle) {
			var ps = getRectPoints(rect);
			drawBeelines(graphic, ps);
		}
		//中心对齐的方形
		public static function drawSquare(graphic:Graphics, size:Number) {
			drawRect(graphic, new Rectangle(-size, -size, size*2, size*2));
		}
		//画柱形(中心点在底部中间的矩形)
		public static function drawHistogram(graphic:Graphics, size:Number, height:Number) {
			drawRect(graphic, new Rectangle(-size/2, -height, size, height));
		}
		//圆角矩形  
		//Shape.drawSmoothCurves(_root,new Rectangle(200,0,100,100))
		public static function drawRectAsCurves(graphic:Graphics, rect:Rectangle) {
			var ps = lineToCurveByLoop(getRectPoints(rect));
			drawCurves(graphic, ps);
		}
		//导角矩形
		public static function drawSmoothRect(graphic:Graphics, rect:Rectangle, r:Number) {
			var ps:Array = getRectPoints(rect);
			ps = lineToSmoothLine(ps, r);
			drawCurves(graphic, ps);
		}
		//
		//
		//
		//
		//直线
		public static function drawBeeline(graphic:Graphics, s_pos:Point, e_pos:Point) {
			graphic.moveTo(s_pos.x, s_pos.y);
			graphic.lineTo(e_pos.x, e_pos.y);
		}
		//折线
		public static function drawBeelines(graphic:Graphics, _arr:Array) {
			if (_arr.length != 0) {
				graphic.moveTo(_arr[0].x, _arr[0].y);
				if (_arr.length == 1) {
					graphic.lineTo(_arr[0].x, _arr[0].y+.5);
				} else {
					for (var i = 1; i<_arr.length; i++) {
						graphic.lineTo(_arr[i].x, _arr[i].y);
					}
				}
			}
		}
		//导角折线
		public static function drawSmoothBeelines(graphic:Graphics, _arr:Array, r:Number) {
			if (_arr.length != 0) {
				if (_arr.length == 1) {
					graphic.moveTo(_arr[0].x, _arr[0].y);
					graphic.lineTo(_arr[0].x, _arr[0].y+.5);
				} else {
					var ps:Array = lineToSmoothLine(_arr, r);
					drawCurves(graphic, ps);
				}
			}
		}
		//
		//
		//
		//
		//网格
		public static function drawGrid(graphic:Graphics, rect:Rectangle, y_num:Number, x_num:Number,no_border:Boolean) {
			var x_size:Number = rect.width/x_num;
			var y_size:Number = rect.height/y_num;
			if(no_border){
				x_num--
				y_num--
			}
			for (var i = 0; i<=x_num; i++) {
				drawBeeline(graphic, new Point(rect.left+x_size*i, rect.top), new Point(rect.left+x_size*i, rect.bottom));
			}
			for (var j = 0; j<=y_num; j++) {
				drawBeeline(graphic, new Point(rect.left, rect.top+y_size*j), new Point(rect.right, rect.top+y_size*j));
			}
		}
		//
		//
		//
		//
		//箭头
		//Shape.drawArrow(_root,new Point(400,350),new Point(400,200),2,4,16)
		public static function drawArrow(graphic:Graphics, s_pos:Point, e_pos:Point, width:Number, arrow_width:Number, arrow_length:Number) {
			var ps = getArrowPoints(s_pos, e_pos, width, arrow_width, arrow_length);
			drawBeelines(graphic, ps);
		}
		//
		//
		//
		//
		//画二次曲线
		public static function drawCurve(graphic:Graphics, s_pos:Point, c_pos:Point, e_pos:Point) {
			graphic.moveTo(s_pos.x, s_pos.y);
			graphic.curveTo(c_pos.x, c_pos.y, e_pos.x, e_pos.y);
		}
		//多点二次曲线
		public static function drawCurves(graphic:Graphics, _arr:Array) {
			if (_arr.length>2) {
				graphic.moveTo(_arr[0].x, _arr[0].y);
				for (var i = 1; i<_arr.length-1; i += 2) {
					//graphic.lineStyle(2, random(0xFFFFFF), 100);
					graphic.curveTo(_arr[i].x, _arr[i].y, _arr[i+1].x, _arr[i+1].y);
				}
			}
		}
		//
		//
		//
		//
		//画椭圆
		public static function drawOval(graphic:Graphics, c_pos:Point, rx:Number, ry:Number) {
			drawCurves(graphic, getOvalPoints(c_pos, rx, ry));
		}
		//画圆
		//Shape.drawCircle(_root,new Point(100,100),100)
		public static function drawCircle(graphic:Graphics, c_pos:Point, r:Number) {
			drawCurves(graphic, getOvalPoints(c_pos, r, r));
		}
		//
		//
		//
		//
		//多边形 side:边数, side type(0,1,2) sub_len(-10~10)
		//type=0 多边形  
		//Shape.drawPolygon(_root,new Point(400,50), new Point(400,0), {type:0,side:5}) 
		//type=1 星形
		//标准五角星：Shape.drawPolygon(_root,new Point(500,50), new Point(500,0), {type:1,side:5,sub_len:.383}
		//type=2 曲线星形
		//Shape.drawPolygon(_root,new Point(50,200), new Point(50,150), {type:2,side:5,sub_len:.383})
		public static function drawPolygon(graphic:Graphics, c_pos:Point, e_pos:Point, para:Object) {
			var ps = getPolygonPoints(c_pos.x, c_pos.y, e_pos.x, e_pos.y, para);
			if (para.type != 2) {
				drawBeelines(graphic, ps);
			} else {
				drawCurves(graphic, ps);
			}
		}
		//光滑星形，参数同上
		//Shape.drawPolygonAsCurves(_root,new Point(200,200), new Point(200,150), {type:1,side:7,sub_len:.2})
		public static function drawPolygonAsCurves(graphic:Graphics, c_pos:Point, e_pos:Point, para:Object) {
			var ps = getPolygonPoints(c_pos.x, c_pos.y, e_pos.x, e_pos.y, para);
			ps = lineToCurveByLoop(ps);
			drawCurves(graphic, ps);
		}
		//导角星形，参数同上,多一个导角半径
		//Shape.drawSmoothPolygon(_root,new Point(200,200), new Point(200,150), 10,{type:1,side:7,sub_len:.2})
		public static function drawSmoothPolygon(graphic:Graphics, c_pos:Point, e_pos:Point, r:Number, para:Object) {
			//trace("导角星形")
			var ps = getPolygonPoints(c_pos.x, c_pos.y, e_pos.x, e_pos.y, para);
			ps = lineToSmoothLine(ps, r);
			drawCurves(graphic, ps);
		}
		//
		//
		//
		//
		//画圆弧  graphic:Graphics, radius:半径, angle:起始角度, endAngle:终止角度,x:中心点x, y:中心点y,  is_radian:是否以弧度方式输入
		//not_move为辅助属性，如果圆弧为图形中的一段并且不需要移动到起始点，可将not_move设为true
		//is_reverse为辅助属性，反向画出弧度
		//默认情况下，x,y，is_radian可以省略，默认为0，0点位置，角度输入
		//例子：Shape.drawArc(_root, 50, 0, 60, 250, 350)
		public static function drawArc(graphic:Graphics, radius:Number, angle:Number, endAngle:Number, x:Number=0, y:Number=0, is_radian:Boolean=false, not_move:Boolean=false, is_reverse:Boolean=false) {
			if (!is_radian) {
				angle *= Math.PI/180;
				endAngle *= Math.PI/180;
			}
			var angleMid:Number;
			var arc:Number = endAngle-angle;
			if (!isNaN(arc)) {
				while (arc<0) {
					arc += Math.PI*2;
				}
				var segs:Number = Math.ceil(arc/(Math.PI/4));
				var segAngle:Number = -arc/segs;
				var theta:Number = -segAngle/2;
				var cosTheta:Number = Math.cos(theta);
				var ax:Number = Math.cos(angle)*radius;
				var ay:Number = Math.sin(angle)*radius;
				var bx:Number;
				var by:Number;
				var cx:Number;
				var cy:Number;
				if (!not_move) {
					graphic.moveTo(ax+x, ay+y);
				}
				if (!is_reverse) {
					for (var i:Number = 0; i<segs; i++) {
						angle += theta*2;
						angleMid = angle-theta;
						bx = x+Math.cos(angle)*radius;
						by = y+Math.sin(angle)*radius;
						cx = x+Math.cos(angleMid)*(radius/cosTheta);
						cy = y+Math.sin(angleMid)*(radius/cosTheta);
						graphic.curveTo(cx, cy, bx, by);
					}
				} else {
					for (var j:Number = segs-1; j>=0; j--) {
						endAngle -= theta*2;
						angleMid = endAngle+theta;
						bx = x+Math.cos(endAngle)*radius;
						by = y+Math.sin(endAngle)*radius;
						cx = x+Math.cos(angleMid)*(radius/cosTheta);
						cy = y+Math.sin(angleMid)*(radius/cosTheta);
						graphic.curveTo(cx, cy, bx, by);
					}
				}
			}
		}
		//画圆环 graphic:Graphics, radius:内圆半径,endRadius:外圆半径, angle:起始角度, endAngle:终止角度,x:中心点x, y:中心点y,  is_radian:是否以弧度方式输入
		//默认情况下，x,y，is_radian可以省略，默认为0，0点位置，角度输入
		//例子：Shape.drawRing(_root, 50, 100, -60, 20, 350,350)
		public static function drawRing(graphic:Graphics, radius:Number, endRadius:Number, angle:Number, endAngle:Number, x:Number=0, y:Number=0, is_radian:Boolean=false) {
			if (!is_radian) {
				angle *= Math.PI/180;
				endAngle *= Math.PI/180;
			}
			var p1 = new Point(x+Math.cos(angle)*radius, y+Math.sin(angle)*radius);
			var p2 = new Point(x+Math.cos(endAngle)*radius, y+Math.sin(endAngle)*radius);
			var p3 = new Point(x+Math.cos(angle)*endRadius, y+Math.sin(angle)*endRadius);
			var p4 = new Point(x+Math.cos(endAngle)*endRadius, y+Math.sin(endAngle)*endRadius);
			graphic.moveTo(p1.x, p1.y);
			graphic.lineTo(p3.x, p3.y);
			drawArc(graphic, endRadius, angle, endAngle, x, y, true, true);
			graphic.lineTo(p2.x, p2.y);
			drawArc(graphic, radius, angle, endAngle, x, y, true, true, true);
		}
		////////////////////////////////////////////////////////////////////////////////////////////////
		public static function getRectPoints(rect:Rectangle):Array {
			var ps:Array = new Array();
			ps.push(new Point(rect.left, rect.top));
			ps.push(new Point(rect.right, rect.top));
			ps.push(new Point(rect.right, rect.bottom));
			ps.push(new Point(rect.left, rect.bottom));
			ps.push(new Point(rect.left, rect.top));
			return ps;
		}
		public static function getOvalPoints(c_pos:Point, rx:Number, ry:Number):Array {
			var x = c_pos.x;
			var y = c_pos.y;
			var ps = new Array();
			ps.push(new Point(x+rx, y));
			ps.push(new Point(rx+x, 0.4142*ry+y));
			ps.push(new Point(0.7071*rx+x, 0.7071*ry+y));
			ps.push(new Point(0.4142*rx+x, ry+y));
			ps.push(new Point(x, ry+y));
			ps.push(new Point(-0.4142*rx+x, ry+y));
			ps.push(new Point(-0.7071*rx+x, 0.7071*ry+y));
			ps.push(new Point(-rx+x, 0.4142*ry+y));
			ps.push(new Point(-rx+x, y));
			ps.push(new Point(-rx+x, -0.4142*ry+y));
			ps.push(new Point(-0.7071*rx+x, -0.7071*ry+y));
			ps.push(new Point(-0.4142*rx+x, -ry+y));
			ps.push(new Point(x, -ry+y));
			ps.push(new Point(0.4142*rx+x, -ry+y));
			ps.push(new Point(0.7071*rx+x, -0.7071*ry+y));
			ps.push(new Point(rx+x, -0.4142*ry+y));
			ps.push(new Point(rx+x, y));
			return ps;
		}
		//para side:边数 type(0,1,2) sub_len(-10~10)
		public static function getPolygonPoints(cx:Number, cy:Number, x:Number, y:Number, para:Object):Array {
			var c_pos:Point = new Point(cx, cy);
			var e_pos:Point = new Point(x, y);
			var r:Number = Point.distance(e_pos, c_pos);
			var dr:Number = Math.atan2(y-cy, x-cx);
			var radians:Number = Math.PI*2/para.side;
			var ps:Array = new Array();
			if (para.type == 0) {
				//简单多边形
				for (var i = 0; i<=para.side; i++) {
					ps.push(new Point(r*Math.cos(radians*i+dr)+cx, r*Math.sin(radians*i+dr)+cy));
				}
				//ps = lineToCurve(ps);
			} else if (para.type == 1) {
				//星形
				radians /= 2;
				for (var j = 0; j<=para.side*2; j++) {
					if (j%2) {
						ps.push(new Point(r*para.sub_len*Math.cos(radians*j+dr)+cx, r*para.sub_len*Math.sin(radians*j+dr)+cy));
					} else {
						ps.push(new Point(r*Math.cos(radians*j+dr)+cx, r*Math.sin(radians*j+dr)+cy));
					}
				}
				//ps = lineToCurve(ps);
			} else if (para.type == 2) {
				//曲线多边形
				radians /= 2;
				for (var k = 0; k<para.side*2; k++) {
					if (k%2) {
						ps.push(new Point(r*para.sub_len*Math.cos(radians*k+dr)+cx, r*para.sub_len*Math.sin(radians*k+dr)+cy));
					} else {
						ps.push(new Point(r*Math.cos(radians*k+dr)+cx, r*Math.sin(radians*k+dr)+cy));
					}
				}
				ps.push(ps[0].clone());
			}
			return ps;
		}
		//获得箭头points
		public static function getArrowPoints(s_pos:Point, e_pos:Point, width:Number, arrow_width:Number, arrow_length:Number) {
			var d_p:Point = e_pos.subtract(s_pos);
			var length = d_p.length;
			var arrow_s_pos:Point = Point.interpolate(s_pos, e_pos, arrow_length/length);
			var arr = new Array();
			var angle = -Math.atan2(d_p.x, d_p.y);
			var dir_p:Point = Point.polar(width/2, angle);
			var dir_p_arrow:Point = Point.polar(arrow_width/2, angle);
			//trace(d_p+"  "+arrow_s_pos+"  "+angle+"  "+dir_p+"  "+dir_p_arrow);
			var _arr = new Array(s_pos.add(dir_p), arrow_s_pos.add(dir_p), arrow_s_pos.add(dir_p_arrow), e_pos, arrow_s_pos.subtract(dir_p_arrow), arrow_s_pos.subtract(dir_p), s_pos.subtract(dir_p), s_pos.add(dir_p));
			return _arr;
		}
		////////////////////////////////////////////////////////////////////////////////////////////////
		//将直线数组转化为曲线数组
		public static function lineToCurve(ps:Array):Array {
			var out_ps:Array = new Array();
			var mps:Array = new Array();
			for (var i = 0; i<ps.length-1; i++) {
				mps.push(Point.interpolate(ps[i], ps[i+1], .5));
			}
			for (var j = 0; j<ps.length; j++) {
				out_ps.push(ps[j]);
				out_ps.push(mps[j]);
			}
			out_ps.pop();
			return out_ps;
		}
		//将直线数组转化成导角直线数组，r为导角圆的半径
		/**/
		public static function lineToSmoothLine(ps:Array, r:Number):Array {
			//trace("---------- line to smooth line--------------");
			var out_ps:Array = new Array();
			var r_ps:Array = new Array();
			var A:Beeline;
			var B:Beeline;
			var angle:Number;
			var r2:Number;
			if (ps.length>2) {
				for (var i = 1; i<ps.length-1; i++) {
					A = new Beeline(ps[i], ps[i-1]);
					B = new Beeline(ps[i], ps[i+1]);
					//两条直线的夹角
					angle = Calculate.getBeelinesAngle(A, B);
					//
					r2 = Math.abs(r*Math.tan(angle/2));
					//trace(angle+"  "+r2);
					r_ps.push(Point.interpolate(ps[i-1], ps[i], Math.max(Math.min(1, r2/A.length), 0)));
					r_ps.push(Point.interpolate(ps[i+1], ps[i], Math.max(Math.min(1, r2/B.length), 0)));
				}
				for (var j = 0; j<ps.length-2; j++) {
					out_ps.push(r_ps[j*2]);
					out_ps.push(ps[j+1]);
					out_ps.push(r_ps[j*2+1]);
					out_ps.push(Point.interpolate(ps[j+1], ps[j+2], .5));
				}
				out_ps.pop();
				out_ps.push(Point.interpolate(out_ps[out_ps.length-1], ps[ps.length-1], .5));
				out_ps.push(ps[ps.length-1]);
				out_ps.unshift(Point.interpolate(out_ps[0], ps[0], .5));
				out_ps.unshift(ps[0]);
				if (ps[0].x == ps[ps.length-1].x && ps[0].y == ps[ps.length-1].y) {
					//是环形
					//trace("是环形");
					A = new Beeline(ps[0], ps[1]);
					B = new Beeline(ps[0], ps[ps.length-2]);
					//两条直线的夹角
					angle = Calculate.getBeelinesAngle(A, B);
					//
					r2 = Math.abs(r*Math.tan(angle/2));
					var A_p:Point = Point.interpolate(ps[1], ps[0], Math.max(Math.min(1, r2/A.length), 0));
					var B_p:Point = Point.interpolate(ps[ps.length-2], ps[0], Math.max(Math.min(1, r2/B.length), 0));
					var s_pos = out_ps[0].clone();
					out_ps.pop();
					out_ps.shift();
					out_ps.unshift(A_p);
					out_ps.push(B_p);
					out_ps.push(s_pos.clone());
					out_ps.push(A_p.clone());
				}
				//trace(out_ps)         
			}
			return out_ps;
		}
		//将环状直线数组转化为曲线数组
		public static function lineToCurveByLoop(ps:Array):Array {
			var out_ps:Array = new Array();
			var mps:Array = new Array();
			for (var i = 0; i<ps.length-1; i++) {
				mps.push(Point.interpolate(ps[i], ps[i+1], .5));
			}
			for (var j = 0; j<ps.length; j++) {
				out_ps.push(ps[j]);
				out_ps.push(mps[j]);
			}
			//
			out_ps.pop();
			out_ps.pop();
			out_ps.push(out_ps.shift());
			out_ps.push(out_ps[0].clone());
			//trace(out_ps);
			return out_ps;
		}
	}
}
