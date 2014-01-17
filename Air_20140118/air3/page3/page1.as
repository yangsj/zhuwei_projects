package 
{
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;

    public class page1 extends MovieClip
    {
        public var btn_more:MovieClip;
        public var btn_video:MovieClip;
        private var contentPath:String;
        private var video:Videos;
        private var sprite:Sprite;
        private var close_btn:Cbtn;

        public function page1()
        {
            var _loc_1:Boolean = true;
            this.btn_video.buttonMode = true;
            this.btn_more.buttonMode = _loc_1;
            this.btn_more.addEventListener(MouseEvent.CLICK, this.onClick);
            this.btn_video.addEventListener(MouseEvent.CLICK, this.onClick);
            return;
        }// end function

        private function getPath() : String
        {
            var _loc_1:* = this.loaderInfo.url;
            var _loc_2:* = _loc_1.lastIndexOf("/");
            _loc_1 = _loc_1.substring(0, _loc_2);
            _loc_2 = _loc_1.lastIndexOf("/") + 1;
            return _loc_1.substring(0, _loc_2);
        }// end function

        private function onClick(event:MouseEvent) : void
        {
            switch(event.currentTarget.name)
            {
                case "btn_more":
                {
                    ExternalInterface.call("selectFliter", "AIR_PURIFIER_SU_CN_CONSUMER");
                    break;
                }
                case "btn_video":
                {
                    this.playVideo("1.flv");
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        function playVideo(param1:String) : void
        {
            var _loc_2:* = this.getPath();
            this.contentPath = _loc_2 + "video-2/";
            trace(this.contentPath);
            if (this.video == null)
            {
                this.sprite = new Sprite();
                this.sprite.graphics.beginFill(14935011, 0.5);
                this.sprite.graphics.drawRect(0, 0, 958, 466);
                this.sprite.graphics.endFill();
                addChild(this.sprite);
                this.video = new Videos(this.contentPath + param1);
                addChild(this.video);
                this.video.x = (958 - this.video.width) / 2;
                this.video.y = (466 - this.video.height) / 2 - 30;
                this.close_btn = new Cbtn();
                addChild(this.close_btn);
                this.close_btn.x = this.video.x + this.video.width - this.close_btn.width - 2;
                this.close_btn.y = this.video.y + 2;
                this.close_btn.addEventListener(MouseEvent.CLICK, this.closeVideo);
                this.close_btn.buttonMode = true;
            }
            return;
        }// end function

        function closeVideo(event:MouseEvent) : void
        {
            if (this.video && this.video.parent)
            {
                removeChild(this.sprite);
                this.sprite = null;
                removeChild(this.video);
                this.video.onOut();
                this.video = null;
                this.close_btn.removeEventListener(MouseEvent.CLICK, this.closeVideo);
                removeChild(this.close_btn);
                this.close_btn = null;
            }
            return;
        }// end function

    }
}
