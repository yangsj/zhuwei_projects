package Air_fla
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;

    dynamic public class MainTimeline extends MovieClip
    {
        public var loading:MovieClip;
        public var contentPath:String;
        public var loader:Loader;
        public var urlRequest:URLRequest;
        public var content:DisplayObject;

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
            return;
        }// end function

        function frame1()
        {
            this.contentPath = stage.loaderInfo.parameters.contentPath ? (stage.loaderInfo.parameters.contentPath) : ("");
            this.contentPath = this.getPath();
            this.loader = new Loader();
            this.urlRequest = new URLRequest();
            this.urlRequest.url = this.contentPath + "air4/page1.swf";
            this.loader.load(this.urlRequest);
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.contentCompleteHandle);
            return;
        }// end function

    }
}
