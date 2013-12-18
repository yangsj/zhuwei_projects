package com.cg.utils 
{

    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.StageDisplayState;
    import flash.events.FullScreenEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.system.Capabilities;
    import flash.text.TextField;

    
    public class DisplayObjectUtil 
    {
        public static const AUTO_SCALE_HOLD : String = "AUTO_INSIDE";
        public static const AUTO_SCALE_FILL : String = "AUTO_OUTSIDE";
    	public static const HORIZON : String = "HORIZON";
        public static const VERTICAL : String = "VERTICAL";
        public static const BOTH : String = "BOTH";
        

        /**
         * 返回从Stage到任意DisplayObject的容器名称序列.
         */
        public static function getDisplayListPath(displayObject:DisplayObject):String
        {
            return (function(displayObject : DisplayObject, path : String = ""):String
                    {
                        if (path.length > 0)
                           path = "." + path; 
                           
                        var name:String = 
                           (displayObject is Stage) ? "STAGE" : 
                           displayObject.name; 
                        path = name + path;
            
                        var parent:DisplayObjectContainer = displayObject.parent;
                           
                        if (parent)
                            return arguments.callee(parent, path);
            
                        return path;
                    }
                   )(displayObject);
        }

        /**
         * 返回容器childs名称包含name的对象序列
         */
        public static function getAllChildrenByName(container:DisplayObjectContainer, name:String):Array
        {
            return getAllChildren(container).filter(
                function(d:DisplayObject, ...param):Boolean
                {
                    return d && d.name.indexOf(name) > -1; 
                });
        }

        /**
         * 获取可视对象的全局位置
         */
        public static function getGlobalPosition(displayObject:DisplayObject):Point
        {
            if (!displayObject || !displayObject.parent)
                return new Point();
                
            var p:Point = new Point(displayObject.x, displayObject.y);
            
            if (isStageChild(displayObject))
                return p;
            
            return displayObject.parent.localToGlobal(p);
        }

        /**
         * 可视对象是否是stage的child
         */
        public static function isStageChild(displayObject:DisplayObject):Boolean
        {
            var pa:DisplayObjectContainer = displayObject.parent as DisplayObjectContainer;
            return (pa && (pa == displayObject.stage));
        }

        /**
         * 设置可视对象的全局位置
         */
        public static function setGlobalPosition(displayObject:DisplayObject, x:int, y:int, usePixelBounds:Boolean = false):Point
        {
            return new Point(setGlobalX(displayObject, x, usePixelBounds), setGlobalY(displayObject, y, usePixelBounds));
        }

        /**
         * 设置可视对象的全局x
         */
        public static function setGlobalX(
                                    displayObject:DisplayObject,
                                    globalX:Number,
                                    usePixelBounds:Boolean
                                ):Number
        {
            if (!displayObject)
                return 0;
            
            return execToSetGlobal(displayObject, "x", globalX, usePixelBounds);
        }

        /**
         * 设置可视对象的全局y
         */
        public static function setGlobalY(displayObject:DisplayObject, y:Number, usePixelBounds:Boolean):Number
        {
            if (!displayObject)
                return 0;
            
            return execToSetGlobal(displayObject, "y", y, usePixelBounds);
        }

        /**
         * @private
         */
        private static function execToSetGlobal(
                                    displayObject:DisplayObject,
                                    prop:String,
                                    globalValue:Number,
                                    usePixelBounds:Boolean
                                ):Number
        {
            var r:Rectangle = (usePixelBounds) ? getLocalPixelBounds(displayObject) : new Rectangle();
            
            if (isStageChild(displayObject))
                displayObject[prop] = globalValue - r[prop];
            else
                if (!containsInDisplayList(displayObject))
                {
                    throw new Error("指定的DisplayObject[" + displayObject + "]不在舞台上");
                    return;
                }
            else
            {
                var isPropX:Boolean = (prop == "x");
                var m:Matrix = displayObject.parent.transform.concatenatedMatrix;
                var s:Number = isPropX ? 1 / m.a : 1 / m.d;
                
                var gp:Point = isPropX ? new Point(globalValue, 0) : new Point(0, globalValue);
                var lp:Point = displayObject.parent.globalToLocal(gp);
                
                globalValue = lp[prop] ;
                displayObject[prop] = globalValue - r[prop] * s;
            }
                
            return displayObject[prop];
        }

        //displayObjectが配置されている座標系でみた、displayObjectのpixelBoundsを返す.
        private static function getLocalPixelBounds(displayObject:DisplayObject):Rectangle
        {
            var gb:Rectangle = displayObject.transform.pixelBounds;
            var p:Point = getGlobalPosition(displayObject);
            var d:Point = new Point(gb.x - p.x, gb.y - p.y);
            return new Rectangle(d.x, d.y, gb.width, gb.height);
        }

        private static function containsInDisplayList(displayObject:DisplayObject):Boolean
        {
            return displayObject && displayObject.stage; 
        }

        /**
         *渲染宽度
         */
        public static function getRenderedWidth(displayObject:DisplayObject):int
        {
            return displayObject.width * getRealScale(displayObject, "scaleX");
        }

        /**
         * 渲染高度
         */
        public static function getRenderedHeight(displayObject:DisplayObject):int
        {
            return displayObject.height * getRealScale(displayObject, "scaleY");
        }

        /**
         * @private 
         */
        private static function getRealScale(displayObject:DisplayObject, kind:String):Number
        {
            var p:DisplayObjectContainer = displayObject.parent;
            return (p) ? getMultipleParentScale(p, kind) : 1;
        }

        /**
         * @private 
         */
        private static function getMultipleParentScale(displayObject:DisplayObject, kind:String):Number
        {
            var s:Number = displayObject[kind]; 
            var p:DisplayObject = displayObject.parent;
            return (p) ? s * getMultipleParentScale(p, kind) : s;
        }

        /**
         *可视物体及其父对象是否被缩放
         */
        public static function isScaled(displayObject:DisplayObject):Boolean
        {
            var p:DisplayObject = displayObject.parent;
            var b:Boolean = (displayObject.scaleX != 1 || displayObject.scaleY != 1);
            return  (b) ? b : (p) ? (b || isScaled(p)) : b;
        }

        /**
         * 删除所有子物体
         */
        public static function removeAllChildren(displayObjectContainer:DisplayObjectContainer = null):void
        {
            if (!StageReference.isEnabled) 
            {
                if (displayObjectContainer == null)
                    throw new DisplayObjectUtilError(
                        DisplayObjectUtilError.FAILED_STAGE_REFERENCE_INIT, 
                        DisplayObjectUtilError.FAILED_STAGE_REFERENCE_INIT_ID
                    );
                else
                    StageReference.initialize(displayObjectContainer);
            }

            var c:DisplayObjectContainer = (displayObjectContainer == null) ? StageReference.stage : displayObjectContainer;
            var docClass:DisplayObjectContainer = StageReference.documentClass;
            
            DisplayObjectUtil.getAllChildren(c).forEach(function (a:DisplayObject, ...param):void
            {
                if (a != docClass)
                    c.removeChild(a);
            });
            
            if (c is Stage)
            {
                DisplayObjectUtil.getAllChildren(docClass).forEach(function (a:DisplayObject, ...param):void
                {
                    docClass.removeChild(a);
                });
            }
        }

        /**
         * 返回容器内child序列
         */
        public static function getAllChildren(container:DisplayObjectContainer):Array
        {
            if (!container)
               return [];
               
            var a:Array = [];
            for (var i:int = 0;i < container.numChildren; i++)
            {
                a.push(container.getChildAt(i));
            }
            return a;
        }

        /**
         * 输出child的name及制定属性
         */
        public static function dumpChildren(
                                    displayObjectContainer:DisplayObjectContainer,
                                    ...properties 
                               ):void
        {
//            var globalDepth:uint = 0;
            
            var traceChild : Function = 
                function(d:DisplayObject, depth:int, ...properties):void
                {
                    var tab:String = "";
                    for (var j : int = 0; j < depth; j++) {
                        tab += "\t";
                    }
                    
                    var props:String = "";
                    if (properties.length > 0)
                    {
                        properties.forEach(function(p:String, ...param):void
                        {
                            var r:* =
                                (function(o:*, a:Array, i:int=0) : *
                                {
                                    var v:* = a[i];
                                    if (o.hasOwnProperty(v))
                                    {
                                        if (i == a.length-1)
                                            return o[v];
                                        else
                                            return arguments.callee(o[v], a, ++i);
                                    }
                                    return null;
                                })(d, p.split("."));
                            props += p + ": " + r + " ";
                        });
                    }

                    try
                    {
                        trace(tab, d, d.name, props);
                    }
                    catch(e:Error)
                    {
                        trace(e);
                    }
                };
            
            var traceChildren:Function = 
                function (co:DisplayObjectContainer, depth:int):String
                {
                    traceChild.apply(this, [co, depth].concat(properties));
                    
                    if (co is MovieClip) MovieClip(co).gotoAndStop(MovieClip(co).currentFrame);
                    
                    var s:String = "";
                    for (var i:int = 0;i < co.numChildren; i++) 
                    {
                        var child:DisplayObject = co.getChildAt(i);
                        if (child is DisplayObjectContainer)
                            traceChildren(child as DisplayObjectContainer, depth + 1);
                        else
                            traceChild.apply(this, [child, depth + 1].concat(properties));
                    }
                    
                    return s;
                };
                
            traceChildren(displayObjectContainer, 0);
        }

        /**
         * 从父容器中删除自己
         */
        public static function removeChild(child:DisplayObject):DisplayObject
        {
            if (!child)
                return child;
                
            var container:DisplayObjectContainer = child.parent;
            if (!container)
                return child;
                
            if (container.contains(child))
                container.removeChild(child);
                
            return child;
        }

        /**
         * container中是否包含target，递归查询
         */
        public static function containsDeeply(container:DisplayObjectContainer, target:DisplayObject):Boolean
        {
            var f:Function = function(c:DisplayObjectContainer):Boolean
            {
                var child:DisplayObject = c.getChildAt(i); 
                for (var i:int = 0;i < c.numChildren; i++) 
                {
                    if (child is DisplayObjectContainer)
                        return f(child as DisplayObjectContainer);
                    else
                        return c.contains(target);
                }
                return false;
            };
            return f(container);
        }
		/**
		 * 查找a是否是con的子物体
		 */
		public static function isChildren(a:DisplayObject, con:DisplayObjectContainer):Boolean
		{
			var p:DisplayObjectContainer = a.parent as DisplayObjectContainer;
			while (p != null) {
				if (p == con)	return true;
				p = p.parent as DisplayObjectContainer;
			}
			return false;
		}
        /**
         * 对象DisplayObject，全球坐标系中的任何一点作为原点旋转。
         * 
         * @param target            对象DisplayObject
         * @param origin            旋转的核心全球坐标。
         *                          DisplayObject如果想指定配备坐标系,使用DisplayObjectUtil.rotateOnLocalPoint().                      
         * @param radians           新的角度，这是绝对值.
         */
        public static function rotateOnGlobalPoint(
                                    target:DisplayObject,
                                    origin:Point,
                                    radians:Number
                                ):void
        {
            var p:DisplayObjectContainer = target.parent;
            var l:Point = (p) ? p.globalToLocal(origin) : origin;
            var m:Matrix = target.transform.matrix;
            var x:Number = l.x;
            var y:Number = l.y;
            m.translate(-x, -y);
            m.rotate(radians - exNumber.degreesToRadians(target.rotation));
            m.translate(x, y);
            target.transform.matrix = m;
        }

        /**
         *DisplayObject被配置的坐标系中的任何一点作为原点旋转。.
         * @param target    对象DisplayObject
         * @param origin    旋转中心的坐标
         *                  这个坐标对象DisplayObject本地坐标系中的位置。
         * @param radians   新的角度，这是绝对值。
         */
        public static function rotateOnLocalPoint(
                                    target:DisplayObject,
                                    origin:Point, 
                                    radians:Number
                                ):void
        {
            rotateOnGlobalPoint(
                target,
                target.localToGlobal(origin),
                radians
            );
        }

        /**
         * 对象DisplayObject，全球坐标系中的任何一点作为原点缩放。
         * 
         * @param target    对象DisplayObject
         * @param origin    缩放中心的全局坐标
         * @param scaleX    绝对值
         * @param scaleY    绝对值
         */
        public static function scaleOnGlobalPoint(
                                    target:DisplayObject,
                                    origin:Point,
                                    scaleX:Number,
                                    scaleY:Number
                                ):void
        {
            var p:DisplayObjectContainer = target.parent;
            var l:Point = (p) ? p.globalToLocal(origin) : origin;
            var m:Matrix = target.transform.matrix;
            var x:Number = l.x;
            var y:Number = l.y;
            m.translate(-x, -y);
            m.scale(1 / target.scaleX, 1 / target.scaleY);
            m.scale(scaleX, scaleY);
            m.translate(x, y);
            target.transform.matrix = m;
        }
        
        /**
         * 根据全局指定原点缩放，对象DisplayObject，本地坐标系中的任何一点作为原点缩放。
         * 
         * @param target    对象DisplayObject
         * @param origin    缩放中心的本地坐标
         * @param scaleX    绝对值
         * @param scaleY    绝对值
         */
        public static function scaleOnLocalPoint(
                                    target:DisplayObject,
                                    origin:Point,
                                    scaleX:Number,
                                    scaleY:Number
                                ):void
        {
            scaleOnGlobalPoint(target, target.localToGlobal(origin), scaleX, scaleY);
        }
        
        /**
         * 根据全局指定原点平移
         * 
         * @param target        対象DisplayObject
         * @param origin        全局坐标原点
         * @param destination   移动方向，绝对值
         */
        public static function translateOnGlobalPoint(
                                    target:DisplayObject,
                                    origin:Point,
                                    destination : Point) : void
        {
              var diff:Point = destination.subtract(origin);
            target.x += diff.x;
            target.y += diff.y;
        }
        
        /**
         * 根据内部指定原点平移
         * 
         * @param target        対象DisplayObject
         * @param origin        内部坐标原点
         * @param destination   移动方向，绝对值
         */
        public static function translateOnLocalPoint(
                                    target:DisplayObject,
                                    origin:Point,
                                    destination : Point) : void
        {
            translateOnGlobalPoint(target, target.localToGlobal(origin), destination);
        }
        
        /**
         *根据全局指定原点transform
         */
        public static function transformOnGlobalPoint(
                                    target:DisplayObject,
                                    origin:Point,
                                    radians:Number,
                                    scaleX:Number,
                                    scaleY:Number,
                                    destination : Point
                                ):void
        {
            var p:DisplayObjectContainer = target.parent;
            var l:Point = (p) ? p.globalToLocal(origin) : origin;
            var m:Matrix = target.transform.matrix;
            var x:Number = l.x;
            var y:Number = l.y;
            m.translate(-x, -y);
            m.scale(1 / target.scaleX, 1 / target.scaleY);
            m.rotate(radians - exNumber.degreesToRadians(target.rotation));
            m.scale(scaleX, scaleY);
            m.translate(x, y);
            target.transform.matrix = m;
            
            translateOnGlobalPoint(target, origin, destination);
        }
        
        /**
         * 根据内部指定原点transform
         */
        public static function transformOnLocalPoint(
                                    target:DisplayObject,
                                    origin:Point,
                                    radians:Number,
                                    scaleX:Number,
                                    scaleY:Number,
                                    destination : Point
                                ):void
        {
            transformOnGlobalPoint(
                target,
                target.localToGlobal(origin), 
                radians, 
                scaleX, 
                scaleY, 
                destination
            );
        }

        /**
         * 返回DisplayObject在舞台上的深度
         */
        public static function getGlobalDepth(displayObject:DisplayObject):int
        {
            if (!displayObject.stage)
               return -1;
               
            var f:Function = 
                function(displayObject:DisplayObject, add:int):int
                {
                    var parent : DisplayObjectContainer = displayObject.parent;
                    if (!parent)
                        return add;
                        
                    var idx:int = parent.getChildIndex(displayObject);
                    
                    if (idx != 0)
                    {
                        for (var i:int = 0;i < idx; i++) 
                        {
                            var d:DisplayObjectContainer = parent.getChildAt(i) as DisplayObjectContainer;
                            if (d)
                                add += getRenderedDecendantNum(d);
                            else
                                add++;
                        }
                    }
                        
                    return f(parent, add);
                };
            
            return f(displayObject, 0);
        }

        /**
         * DisplayObject内部是否存在非原件类图案
         */
        public static function hasVectorShape(displayObject:DisplayObject):Boolean
        {
            if (displayObject is Sprite)
            {
                var spr:Sprite = Sprite(displayObject); 
                if (spr.numChildren == 0)
                {
                    if (rectangleHasSize(displayObject.getRect(displayObject)))
                        return true;
                }
                else
                {
                    var childBounce:Rectangle = new Rectangle();
                    for (var i:int = 0;i < spr.numChildren; i++) 
                    {
                        var child:DisplayObject = spr.getChildAt(i);
                        var b:Rectangle = child.getRect(spr); 
                        if (rectangleHasSize(b))
                          childBounce = childBounce.union(b);
                    }
                    return !spr.getBounds(spr).equals(childBounce);
                }
            }
            
            return false;
        }
		
        private static function rectangleHasSize(r:Rectangle):Boolean
        {
            if (r.width > 0 || r.height > 0)
                if(r.width != 6710886.4 && r.height != 6710886.4)
                    return true;
                    
            return false;
        }

        /**
         * 被渲染的可视化元素总数
		 * 注意：如果Child中包含MovieClip，MovieClip将被停止，否则计数不正确
         */
        public static function getRenderedDecendantNum(container:DisplayObjectContainer):int
        {
//            trace("\n");
            
            /**
             * for debug
             */
            var getIndent:Function = function(indent:int):String
            {
                var s:String = "";
                for (var k:int = 0;k < indent; k++) 
                {
                    s += "\t";
                }
                return s;
            };
            
            var f:Function = function(c:DisplayObject, indent:int = 0):int
            {
                if (!c.stage)
                    return 0;

                var cNum:int = 0;
                var co:DisplayObjectContainer = c as DisplayObjectContainer;
                
//                trace(getIndent(indent), "---", c.name, co, co is MovieClip);
                
                if (co)
                {
                    if (co is MovieClip)
                        MovieClip(co).gotoAndStop(MovieClip(co).currentFrame);
                    
                    for (var i:int = 0;i < co.numChildren; i++) 
                    {
                        var d:DisplayObject = co.getChildAt(i);
                        var a:int = f(d, indent + 1);
                        cNum += a;
//                        trace(getIndent(indent), d.name, a, "total:", cNum);
                    }
                    //ベクターシェイプが描画されている場合はカウントする
                    if (hasVectorShape(c))
                    {
                        cNum ++;
//                        trace(getIndent(indent), "has vectorShape", "total:", cNum);
                    }
                }
                else
                {
                    if (c.width > 0 || c.height > 0)
                        if (c is TextField)
                           if (TextField(c).text.length > 0)
                               return ++cNum;
                           else
                               return cNum;
                        else
                            return ++cNum;
                }
                
                return cNum;
            };
            
            return f(container, 0);
        }
        
        public function dumpParents(target : DisplayObject, s : String = "", indent : int = 0) : String
        {
            var t : String = "\n";
            for (var i : int = 0;i < indent; i++) 
            {
                t += "  ";
            }
            
            var a:String = "";
            if (target is Sprite)
                a = String(Sprite(target).mouseEnabled) + String(Sprite(target).mouseChildren);
            
            s += t + target.name + "("+ a + ")";
                
            if (target.parent)
                return dumpParents(target.parent, s, ++indent);
            else
                return s;
        }

        /**
         * 通过指定方式缩放DisplayObject
         */
        public static function fitToRectangle(
                                    target : DisplayObject, 
                                    width : Number, 
                                    height : Number, 
                                    fitType : String = AUTO_SCALE_FILL
                               ) : DisplayObject
        {
            target.scaleX = target.scaleY = 1;

            var targetWidth:Number  = target.width;
            var targetHeight:Number = target.height;
            var rateCon : Number    = width / height;
            var rateTar : Number    = targetWidth / targetHeight;
            var fitToGuideWidth : Boolean;
            switch(fitType)
            {
                case HORIZON:
                    fitToGuideWidth = true;
                    break;
                case VERTICAL:
                    fitToGuideWidth = false;
                    break;
                case BOTH:
                case AUTO_SCALE_HOLD:
                    fitToGuideWidth = (rateTar > 1) ? rateTar > rateCon : rateTar > rateCon;
                    break;
                case AUTO_SCALE_FILL:
                    fitToGuideWidth = rateCon > rateTar;
                    break;
                default :
                    throw new Error("未知defitType");
            }
            var scale : Number = fitToGuideWidth ? width / targetWidth : height / targetHeight;
            target.scaleX = target.scaleY = scale;
            return target;
        }
        
        /**
         * 将容器中的所有child alpha设为0，如果alsoVisible为true，所有child的visible设成false
         */
        public static function invisibleAllChildren(container : Sprite, alsoVisible:Boolean = true) : void
        {
            getAllChildren(container).forEach(
                function(img : DisplayObject, ...param):void
                {
                    img.alpha = 0;
                    img.visible = alsoVisible ? false : img.visible;
                });
        }

        /**
         * 获取相对PixelBounce
         */
        public static function getPixelBounce(target : DisplayObject, coordinate : DisplayObjectContainer = null) : Rectangle 
        {
            if (target && !target.parent)
               throw new Error("pixel bounce无法取得" + target + "不存在parent.");
               
            var parent:DisplayObjectContainer = target.parent;
            
            if (!coordinate)
                coordinate = parent;
                  
            var p1:Point = coordinate.globalToLocal(parent.localToGlobal(new Point(target.x, target.y)));
            try
            {
                var bitmap : BitmapData = new BitmapData(p1.x + target.width, p1.y + target.height, true, 0);
            }
            catch(e:ArgumentError)
            {
                return null;
            }
            
            var m:Matrix = target.transform.matrix;
            m.tx = p1.x;
            m.ty = p1.y;
            bitmap.draw(target, m);
            
            var bounce : Rectangle = bitmap.getColorBoundsRect(0xFF000000, 0x00000000, false);

            return bounce.equals(new Rectangle()) ? null : bounce;
        }

        /**
         * 根据xml生成sprite及内部可视对象
         * var xml:XML=<home>
		 * 	<child>
		 * 		<child1 />
		 * 	</child>
		 * </home>
         * var p:Sprite = DisplayObjectUtil.createHierarchy(xml);
         */
        public static function createHierarchy(xml : XML) : Sprite 
        {
            return (function(xml : XML):Sprite
            {
                var spr : Sprite = new Sprite();
                spr.name = xml.name();
                     
                if (xml.children().length() > 0)
                {
                    for each (var i : XML in xml.children()) 
                    {
                        spr.addChild(arguments.callee(i));
                    }
                }
                return spr;
            })(xml);
        }

        /**
         * 根据内部child的名字返回child，递归
         */
        public static function getChildByUniqueName(container : DisplayObjectContainer, name : String) : DisplayObject 
        {
            return (function(c:DisplayObjectContainer, name : String):DisplayObject
                    {
                        var child:DisplayObject = c.getChildByName(name); 
                        if (child)
                           return child;
                           
                        if (c is DisplayObjectContainer)
                            for (var i : int = 0; i < c.numChildren; i++) 
                            {
                                var child2:DisplayObjectContainer = c.getChildAt(i) as DisplayObjectContainer; 
                                if (child2)
                                {
                                    var c2:DisplayObject = arguments.callee(child2, name);
                                    if (c2)
                                       return c2;
                                }
                            }
                            
                        return null;
               
                    })(container, name);   
        }
		/**
		 * 添加一组可视对象
		 */
        public static function addChildren(timeline : Sprite, children : Array) : void
        {
            children.forEach(function(d:DisplayObject, ...param) : void
            {
            	timeline.addChild(d);
            });
        }

        /**
         * 根据path返回内部对象，例如 DisplayObjectUtil.retrieve(root,"child.decendant.hisDog");
         */
        public static function retrieve(container:DisplayObjectContainer, path : String) : DisplayObject
        {
            var a:Array = path.split("."),
                d:DisplayObject;
                
            a.forEach(function(s:String, ...param) : void
            {
                d = d || container;
                if (d is DisplayObjectContainer)
                    d = DisplayObjectContainer(d).getChildByName(s);
            });
            
            return d;
        }

        /**
         * 加到最底层
         */
        public static function prependChild(container : DisplayObjectContainer, child : DisplayObject) : void
        {
			if(child.parent==container){
				container.setChildIndex(child, 0);
			}else {
				container.addChildAt(child, 0);
			}
        }
		/**
         * 加到最上层
         */
		public static function topChild(container : DisplayObjectContainer, child : DisplayObject) : void
		{
			if (child.parent == container) {
				container.setChildIndex(child, container.numChildren - 1);	
			}else {
				container.addChild(child);
			}
		}
		/**
		 * 全屏
		 * @param	target
		 * @param	stage
		 * @param	onRevert 退出全屏时执行的函数
		 */
        public static function fullScreen(target : DisplayObject, stage:Stage, onRevert:Function = null) : void
        {
            if (stage.displayState == StageDisplayState.NORMAL)
            {
                const   tp : Sprite = target.parent as Sprite,
                        tx : Number = target.x,
                        ty : Number = target.y,
                        tw : Number = target.width,
                        th : Number = target.height;
                DisplayObjectUtil.fitToRectangle(target, Capabilities.screenResolutionX, Capabilities.screenResolutionY, DisplayObjectUtil.AUTO_SCALE_HOLD);

                target.x = 0;
                target.y = 0;
                stage.addChild(target);
                //stage.fullScreenSourceRect = new Rectangle(0, 0, target.width, target.height);
                stage.displayState = StageDisplayState.FULL_SCREEN;
                stage.addEventListener(FullScreenEvent.FULL_SCREEN, function() : void
                {
                    tp.addChild(target);
                    target.x = tx;
                    target.y = ty;
                    target.width = tw;
                    target.height = th;
                    if (onRevert != null) onRevert();
                    //LiquidLayout.layout();
                    stage.removeEventListener(FullScreenEvent.FULL_SCREEN, arguments.callee);
                });
            }
        }
    }
}
