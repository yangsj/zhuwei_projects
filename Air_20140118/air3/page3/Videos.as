package 
{
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;

    public class Videos extends Sprite
    {
        private var sprite:Sprite;
        private var video:btnMc;
        private var close_btn:Cbtn;
        private var pics:pic;
        private var myvideo:Video;
        private var nc:NetConnection;
        private var ns:NetStream;
        private var zN:int;
        private var tempVolume:Number;
        private var video_sound:SoundTransform;
        private var temp_Volume:Number;
        private var _width:Number = 400;
        private var _height:Number = 300;
        private var videoURL:String;
        private var videoName:String;
        private var flag:Boolean = false;
        private var flags:Boolean = false;
        private var code_first:String = "mgexperience:";

        public function Videos(param1:String, param2:Number = 400, param3:Number = 300)
        {
            this.videoURL = param1;
            this.videoName = this.videoName;
            this._width = param2;
            this._height = param3;
            this.sprite = new Sprite();
            this.sprite.graphics.beginFill(16777215, 1);
            this.sprite.graphics.drawRect(0, 0, param2, param3);
            this.sprite.graphics.endFill();
            addChild(this.sprite);
            this.sprite.x = 0;
            this.sprite.y = 0;
            this.pics = new pic();
            this.pics.buttonMode = true;
            this.pics.x = (param2 - this.pics.width) / 2;
            this.pics.y = (param3 - this.pics.height) / 2;
            this.pics.addEventListener(MouseEvent.CLICK, this.onSwitchMovie);
            this.sprite.addChild(this.pics);
            this.video_sound = new SoundTransform();
            this.myvideo = new Video(param2, param3);
            this.sprite.addChild(this.myvideo);
            this.nc = new NetConnection();
            this.nc.connect(null);
            this.ns = new NetStream(this.nc);
            this.myvideo.attachNetStream(this.ns);
            this.ns.bufferTime = 1;
            var _loc_4:* = new Object();
            new Object().onCuePoint = this.cuePointHandler;
            _loc_4.onMetaData = this.metaDataHandler;
            this.ns.client = _loc_4;
            this.video = new btnMc();
            addChild(this.video);
            this.video.x = 0;
            this.video.y = param3;
            this.video.ps.addEventListener(MouseEvent.CLICK, this.onSwitchMovie);
            this.video.sounds.addEventListener(MouseEvent.CLICK, this.onSounds);
            this.ns.addEventListener(NetStatusEvent.NET_STATUS, this.onError);
            this.video.soundsLine.buttonMode = true;
            this.video.soundsLine.qq.x = 66;
            this.video.soundsLine.addEventListener(MouseEvent.CLICK, this.upOrDown);
            this.video_sound.volume = 1;
            SoundMixer.soundTransform = this.video_sound;
            return;
        }// end function

        private function onMarch(event:MouseEvent) : void
        {
            if (this.ns.time + 5 > this.zN)
            {
                this.ns.seek(this.zN - 0.5);
                this.video.sj.qq.x = 0;
                trace(123);
            }
            else
            {
                this.ns.seek(this.ns.time + 5);
            }
            return;
        }// end function

        private function onBack(event:MouseEvent) : void
        {
            if (this.ns.time - 5 <= 0)
            {
                this.ns.seek(0);
                this.video.sj.qq.x = 0;
            }
            else
            {
                this.ns.seek(this.ns.time - 5);
            }
            return;
        }// end function

        private function onShijian(event:MouseEvent) : void
        {
            trace(event.currentTarget.mouseX);
            this.ns.seek(event.currentTarget.mouseX / (this.video.sj.width / this.zN));
            return;
        }// end function

        private function upOrDown(event:MouseEvent) : void
        {
            this.video_sound.volume = event.currentTarget.mouseX / 66;
            SoundMixer.soundTransform = this.video_sound;
            if (event.currentTarget.mouseX <= 66)
            {
                this.video.soundsLine.qq.x = event.currentTarget.mouseX;
            }
            else
            {
                this.video.soundsLine.qq.x = 66;
            }
            this.video.sounds.gotoAndStop(1);
            return;
        }// end function

        public function onOut() : void
        {
            this.ns.close();
            return;
        }// end function

        private function onError(event:NetStatusEvent) : void
        {
            return;
        }// end function

        private function onSounds(event:MouseEvent) : void
        {
            if (event.currentTarget.currentFrame == 1)
            {
                event.currentTarget.gotoAndStop(2);
                this.temp_Volume = this.video_sound.volume;
                this.video_sound.volume = 0;
                this.video.soundsLine.qq.x = 0;
                SoundMixer.soundTransform = this.video_sound;
            }
            else
            {
                event.currentTarget.gotoAndStop(1);
                this.video_sound.volume = this.temp_Volume;
                this.video.soundsLine.qq.x = this.temp_Volume * 66;
                SoundMixer.soundTransform = this.video_sound;
            }
            return;
        }// end function

        private function cuePointHandler(param1:Object) : void
        {
            trace(param1.name);
            return;
        }// end function

        private function metaDataHandler(param1:Object) : void
        {
            trace(param1.duration, "--");
            this.zN = Math.floor(param1.duration);
            this.addEventListener(Event.ENTER_FRAME, this.onFrame);
            return;
        }// end function

        private function onSwitchMovie(event:MouseEvent) : void
        {
            trace(this.videoURL);
            this.flag = false;
            this.flags = false;
            this.ns.play(this.videoURL);
            this.video.ps.buttonMode = true;
            this.video.ps.gotoAndStop(2);
            this.video.ps.removeEventListener(MouseEvent.CLICK, this.onSwitchMovie);
            this.video.ps.addEventListener(MouseEvent.CLICK, this.onMovieStop);
            if (this.pics && this.pics.parent)
            {
                this.sprite.removeChild(this.pics);
            }
            var _loc_2:Boolean = true;
            this.video.fastBack.buttonMode = true;
            this.video.fastMarch.buttonMode = _loc_2;
            this.video.fastMarch.addEventListener(MouseEvent.CLICK, this.onMarch);
            this.video.fastBack.addEventListener(MouseEvent.CLICK, this.onBack);
            this.video.sj.buttonMode = true;
            this.video.sj.addEventListener(MouseEvent.CLICK, this.onShijian);
            this.pics = null;
            return;
        }// end function

        private function onMovieStop(event:MouseEvent) : void
        {
            if (event.currentTarget.currentFrame == 1)
            {
                event.currentTarget.gotoAndStop(2);
            }
            else
            {
                event.currentTarget.gotoAndStop(1);
            }
            this.ns.togglePause();
            return;
        }// end function

        private function onFrame(event:Event) : void
        {
            if (this.ns.time >= this.zN / 2 && this.flag == false)
            {
                this.flag = true;
            }
            if (this.ns.time >= this.zN - 0.5 && this.flags == false)
            {
                this.flags = true;
            }
            if (this.ns.time >= this.zN - 0.1)
            {
                this.ns.close();
                this.removeEventListener(Event.ENTER_FRAME, this.onFrame);
                this.video.ps.removeEventListener(MouseEvent.CLICK, this.onMovieStop);
                this.video.ps.addEventListener(MouseEvent.CLICK, this.onSwitchMovie);
                this.video.ps.gotoAndStop(1);
                this.video.fastMarch.removeEventListener(MouseEvent.CLICK, this.onMarch);
                this.video.fastBack.removeEventListener(MouseEvent.CLICK, this.onBack);
                var _loc_2:Boolean = false;
                this.video.fastBack.buttonMode = false;
                this.video.fastMarch.buttonMode = _loc_2;
                this.video.sj.qq.x = 0;
                this.video.sj.buttonMode = false;
                this.video.sj.removeEventListener(MouseEvent.CLICK, this.onShijian);
                if (this.pics == null)
                {
                    this.pics = new pic();
                    this.pics.buttonMode = true;
                    this.pics.x = (this._width - this.pics.width) / 2;
                    this.pics.y = (this._height - this.pics.height) / 2;
                    this.pics.addEventListener(MouseEvent.CLICK, this.onSwitchMovie);
                    this.sprite.addChild(this.pics);
                    trace(this.pics);
                    this.pics.visible = true;
                    this.sprite.visible = true;
                }
            }
            else
            {
                this.video.sj.qq.x = (this.video.sj.line.width - this.video.sj.qq.width + 1) / this.zN * this.ns.time;
            }
            return;
        }// end function

    }
}
