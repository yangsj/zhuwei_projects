package Air_fla
{
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;

    dynamic public class MainTimeline extends MovieClip
    {
        public var loading:MovieClip;
        public var data:XML;
        public var contentPath:String;
        public var dataPath:String;
        public var loader:Loader;
        public var urlRequest:URLRequest;
        public var content:DisplayObject;
        public var dateLoader:DateLoader;
        public var contentArr:Array;
        public var currentIndex:Number;

        public function MainTimeline()
        {
            addFrameScript(0, this.frame1);
            return;
        }// end function

        public function getPath() : String
        {
            var _loc_1:* = this.loaderInfo.url;
            var _loc_2:* = _loc_1.lastIndexOf("/") + 1;
            return _loc_1.substring(0, _loc_2);
        }// end function

        public function contentCompleteHandle(event:Event) : void
        {
            this.content = event.target.content as DisplayObject;
            this.addChild(this.content);
            if (this.contains(this.loading))
            {
                this.removeChild(this.loading);
            }
			if ( ExternalInterface.available )
			{
				ExternalInterface.call("kv_story1_slider_show");
				ExternalInterface.call("kv_story1_slider_resetX");
			}
            this.contentArr[this.currentIndex] = this.content;
            return;
        }// end function

        public function dataCompleteHandle(param1:String) : void
        {
            this.data = new XML(param1);
            this.selectedIndex(0);
            return;
        }// end function

        public function selectedIndex(param1:Number) : void
        {
            var value:* = param1;
            if (this.currentIndex == value)
            {
                return;
            }
            this.currentIndex = value;
            if (this.content && this.contains(this.content))
            {
                this.removeChild(this.content);
                try
                {
                    Object(this.content).stopPlay();
                }
                catch (e:Error)
                {
                }
            }
            if (this.contentArr[this.currentIndex])
            {
                this.content = this.contentArr[this.currentIndex];
                this.addChild(this.contentArr[this.currentIndex]);
            }
            else
            {
                var _loc_4:int = 0;
                var _loc_5:* = this.data.item;
                var _loc_3:* = new XMLList("");
                for each (_loc_6 in _loc_5)
                {
                    
                    var _loc_7:* = _loc_5[_loc_4];
                    with (_loc_5[_loc_4])
                    {
                        if (id == value)
                        {
                            _loc_3[_loc_4] = _loc_6;
                        }
                    }
                }
                this.urlRequest.url = this.contentPath + _loc_3[0].content;
                this.loader.load(this.urlRequest);
                this.addChild(this.loading);
            }
            return;
        }// end function

        function frame1()
        {
			if ( ExternalInterface.available )
			{
				this.contentPath = ExternalInterface.call("getPath");
			}
            if (!this.contentPath || this.contentPath == "")
            {
                this.contentPath = stage.loaderInfo.parameters.contentPath ? (stage.loaderInfo.parameters.contentPath) : ("");
            }
            if (!this.contentPath || this.contentPath == "")
            {
                this.contentPath = this.getPath();
            }
            this.dataPath = this.contentPath + "data/";
            this.loader = new Loader();
            this.urlRequest = new URLRequest();
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.contentCompleteHandle);
            this.dateLoader = new DateLoader(this.dataCompleteHandle);
            this.dateLoader.loadXml(this.dataPath + "content.xml");
            this.contentArr = [];
            this.currentIndex = -1;
			if ( ExternalInterface.available )
			{
				ExternalInterface.addCallback("selectedIndex", this.selectedIndex);
			}
            return;
        }// end function

    }
}
