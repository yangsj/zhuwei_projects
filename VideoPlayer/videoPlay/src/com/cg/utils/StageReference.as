﻿
package com.cg.utils
{
    import flash.display.*;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    public class StageReference
    {
        private static var _stageReferer:DisplayObject = null;
        private static var _stage : Stage;
        private static var _width : uint;
        private static var _height : uint;
        private static var _rect : Rectangle;

        public static function get stage():Stage
        {
            checkInitialize();
            return _stage;
        }

        private static var _documentClass:DisplayObjectContainer = null;
        public static function get documentClass():DisplayObjectContainer
        {
            checkInitialize();
            var stageChildren:int = stage.numChildren;
            for (var i:Number = 0; i < stageChildren; i++) 
            {
                var child:DisplayObject = stage.getChildAt(i) as DisplayObject; 
                if (child.root == child)
                    return child as DisplayObjectContainer;
            }
            return null;
        }   
        public static function get isEnabled():Boolean
        {
            return (_stageReferer != null);
        }
        public static function get center():Point
        {
            return new Point(stage.stageWidth*.5, stage.stageHeight*.5);
        }
        public static function get width() : uint
        {
            return _width;
        }
        public static function get height() : uint
        {
            return _height;
        }
        public static function get rect() : Rectangle
        {
            return _rect;
        }

        /**
         * 初始化时，stageReferer必须在舞台上，或者stageReferer本身就是stage
         */
        public static function initialize(stageReferer:DisplayObject):void
        {
            if (!stageReferer)
                throw new StageReferenceError(1);
            if (!(stageReferer is Stage) && !stageReferer.stage)
                throw new StageReferenceError(2);
                
            _stageReferer = stageReferer;
            _stage = (stageReferer is Stage) ? Stage(_stageReferer) : _stageReferer.stage;
            _documentClass = DisplayObjectContainer(_stage.getChildAt(0));
            _width = _stage.stageWidth;
            _height = _stage.stageHeight;
            _rect = new Rectangle(0, 0, width, height);
        }
            
        
        /**
         * 根据name返回stage上的可视元素
         */
        public static function getDisplayObjectByName(name:String):DisplayObject
        {
            checkInitialize();
            return _documentClass.getChildByName(name);
        }
        public static function reset():void
        {
            _stageReferer = null;
            _documentClass = null;
        }
    
        /**
        * @private 
        */
        private static function checkInitialize():void
        {
            if (!_stageReferer)
                throw new StageReferenceError(0);
            if (!_documentClass)
                throw new StageReferenceError(0);
        }
    
        
        /**
         * 初期化是否完成
         */
        public static function isInitialized():Boolean
        {
            return (_stageReferer != null); 
        }
        
        static function clear():void
        {
        	_stageReferer = null;
        }
        static function repair(stageRef:Stage):void
        {
            _stageReferer = stageRef;
        }
        
        /**
         * 设定Stage是否发布Render事件
         */
        private static var _dispatchRenderEvent : Boolean;
        public static function set dispatchRenderEvent(value:Boolean) : void
        {
            _dispatchRenderEvent = value;

            _stage.removeEventListener(Event.ENTER_FRAME, onEnterframe);
            if (value)
                _stage.addEventListener(Event.ENTER_FRAME, onEnterframe);
        }
        static public function get dispatchRenderEvent() : Boolean
        {
            return _dispatchRenderEvent;
        }
        private static function onEnterframe(event : Event) : void
        {
            _stage.invalidate();
        }
    }
}