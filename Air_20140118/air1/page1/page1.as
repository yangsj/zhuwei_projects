package 
{
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.utils.*;

    public class page1 extends MovieClip
    {
        public var point_btn_mc:MovieClip;
        public var img_mc:MovieClip;
        public var right_btn1:MovieClip;
        public var left_btn1:MovieClip;
        public var right_btn:MovieClip;
        public var btn_more:MovieClip;
        public var left_btn:MovieClip;
        private var btn:Point_Btn;
        private var moreNum:int = 0;
        private var imgArr:Array;
        private var btnArr:Array;
        private var timeline:TimelineMax;
        private var btn_mc:Sprite;
        private var timer:Timer;
        private var speed:Number = 0.3;

        public function page1()
        {
            this.imgArr = [];
            this.btnArr = [];
            this.imgArr = [this.img_mc.img1, this.img_mc.img2, this.img_mc.img3];
            TweenMax.to(this.imgArr[1], 0, {blurFilter:{blurX:3, blurY:3}});
            TweenMax.to(this.imgArr[2], 0, {blurFilter:{blurX:3, blurY:3}});
            var _loc_2:Boolean = true;
            this.left_btn.buttonMode = true;
            this.right_btn.buttonMode = _loc_2;
            this.btn_more.buttonMode = true;
            this.btn_mc = new Sprite();
            this.point_btn_mc.addChild(this.btn_mc);
            var _loc_1:int = 0;
            while (_loc_1 < this.imgArr.length)
            {
                
                this.btn = new Point_Btn();
                this.btn_mc.addChild(this.btn);
                this.btn.x = 17 * _loc_1;
                this.btnArr.push(this.btn);
                if (_loc_1 == 0)
                {
                    this.btn.gotoAndStop(2);
                }
                else
                {
                    this.btn.buttonMode = true;
                    this.btnArr[_loc_1].addEventListener(MouseEvent.CLICK, this.onBtnClick);
                }
                _loc_1++;
            }
            this.btn_mc.x = (this.point_btn_mc.width - this.btn_mc.width) / 2;
            this.right_btn.addEventListener(MouseEvent.CLICK, this.onClick);
            this.right_btn.addEventListener(MouseEvent.MOUSE_OVER, this.onOver);
            this.right_btn.addEventListener(MouseEvent.MOUSE_OUT, this.onOut);
            this.left_btn.addEventListener(MouseEvent.CLICK, this.onClick);
            this.left_btn.addEventListener(MouseEvent.MOUSE_OVER, this.onOver);
            this.left_btn.addEventListener(MouseEvent.MOUSE_OUT, this.onOut);
            this.btn_more.addEventListener(MouseEvent.CLICK, this.onMore);
            this.timer = new Timer(3000, 0);
            this.timer.addEventListener(TimerEvent.TIMER, this.onTimer);
            this.timer.start();
            this.right_btn1.addEventListener(MouseEvent.CLICK, this.onClick1);
            this.left_btn1.addEventListener(MouseEvent.CLICK, this.onClick1);
            var _loc_2:Boolean = true;
            this.left_btn1.buttonMode = true;
            this.right_btn1.buttonMode = _loc_2;
            return;
        }// end function

        private function onClick1(event:MouseEvent) : void
        {
            switch(event.currentTarget)
            {
                case this.right_btn1:
                {
                    this.right_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                    break;
                }
                case this.left_btn1:
                {
                    this.left_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onTimer(event:TimerEvent) : void
        {
            this.right_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            return;
        }// end function

        private function onOver(event:MouseEvent) : void
        {
            event.currentTarget.gotoAndStop(2);
            return;
        }// end function

        private function onOut(event:MouseEvent) : void
        {
            event.currentTarget.gotoAndStop(1);
            return;
        }// end function

        private function onBtnClick(event:MouseEvent) : void
        {
            this.timer.stop();
            this.right_btn.removeEventListener(MouseEvent.CLICK, this.onClick);
            this.left_btn.removeEventListener(MouseEvent.CLICK, this.onClick);
            var _loc_2:int = 0;
            while (_loc_2 < this.btnArr.length)
            {
                
                this.btnArr[_loc_2].gotoAndStop(1);
                this.btnArr[_loc_2].buttonMode = false;
                this.btnArr[_loc_2].removeEventListener(MouseEvent.CLICK, this.onBtnClick);
                _loc_2++;
            }
            this.timeline = new TimelineMax();
            switch(event.currentTarget)
            {
                case this.btnArr[1]:
                {
                    this.imgArr.push(this.imgArr[0]);
                    this.imgArr.shift();
                    this.img_mc.setChildIndex(this.imgArr[0], (this.img_mc.numChildren - 1));
                    this.btnArr.push(this.btnArr[0]);
                    this.btnArr.shift();
                    this.timeline.append(TweenMax.to(this.imgArr[0], this.speed, {x:67, y:-24, scaleX:1, scaleY:1, blurFilter:{blurX:0, blurY:0}}));
                    this.timeline.insert(TweenMax.to(this.imgArr[1], this.speed, {x:234, y:5, scaleX:0.7, scaleY:0.7, blurFilter:{blurX:3, blurY:3}}));
                    this.timeline.insert(TweenMax.to(this.imgArr[2], this.speed, {x:-5, y:5, scaleX:0.7, scaleY:0.7, blurFilter:{blurX:3, blurY:3}, onComplete:this.addEvent, onCompleteParams:[event.currentTarget]}));
                    var _loc_3:* = this;
                    var _loc_4:* = this.moreNum + 1;
                    _loc_3["moreNum"] = _loc_4;
                    if (this.moreNum > 2)
                    {
                        this.moreNum = 0;
                    }
                    break;
                }
                case this.btnArr[2]:
                {
                    this.imgArr.unshift(this.imgArr[(this.imgArr.length - 1)]);
                    this.imgArr.pop();
                    this.img_mc.setChildIndex(this.imgArr[0], (this.img_mc.numChildren - 1));
                    this.btnArr.unshift(this.btnArr[(this.imgArr.length - 1)]);
                    this.btnArr.pop();
                    this.timeline.append(TweenMax.to(this.imgArr[0], this.speed, {x:67, y:-24, scaleX:1, scaleY:1, blurFilter:{blurX:0, blurY:0}}));
                    this.timeline.insert(TweenMax.to(this.imgArr[2], this.speed, {x:-5, y:5, scaleX:0.7, scaleY:0.7, blurFilter:{blurX:3, blurY:3}}));
                    this.timeline.insert(TweenMax.to(this.imgArr[1], this.speed, {x:234, y:5, scaleX:0.7, scaleY:0.7, blurFilter:{blurX:3, blurY:3}, onComplete:this.addEvent, onCompleteParams:[event.currentTarget]}));
                    var _loc_3:* = this;
                    var _loc_4:* = this.moreNum - 1;
                    _loc_3.moreNum = _loc_4;
                    if (this.moreNum < 0)
                    {
                        this.moreNum = 2;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            event.currentTarget.gotoAndStop(2);
            event.currentTarget.buttonMode = false;
            return;
        }// end function

        private function onClick(event:MouseEvent) : void
        {
            this.timer.stop();
            this.right_btn.removeEventListener(MouseEvent.CLICK, this.onClick);
            this.left_btn.removeEventListener(MouseEvent.CLICK, this.onClick);
            var _loc_2:int = 0;
            while (_loc_2 < this.btnArr.length)
            {
                
                this.btnArr[_loc_2].gotoAndStop(1);
                this.btnArr[_loc_2].buttonMode = true;
                this.btnArr[_loc_2].removeEventListener(MouseEvent.CLICK, this.onBtnClick);
                _loc_2++;
            }
            this.timeline = new TimelineMax();
            switch(event.currentTarget)
            {
                case this.right_btn:
                {
                    this.imgArr.push(this.imgArr[0]);
                    this.imgArr.shift();
                    this.img_mc.setChildIndex(this.imgArr[0], (this.img_mc.numChildren - 1));
                    this.btnArr.push(this.btnArr[0]);
                    this.btnArr.shift();
                    this.timeline.append(TweenMax.to(this.imgArr[0], this.speed, {x:67, y:-24, scaleX:1, scaleY:1, blurFilter:{blurX:0, blurY:0}}));
                    this.timeline.insert(TweenMax.to(this.imgArr[1], this.speed, {x:234, y:5, scaleX:0.7, scaleY:0.7, blurFilter:{blurX:3, blurY:3}}));
                    this.timeline.insert(TweenMax.to(this.imgArr[2], this.speed, {x:-5, y:5, scaleX:0.7, scaleY:0.7, blurFilter:{blurX:3, blurY:3}, onComplete:this.addEvent, onCompleteParams:[event.currentTarget]}));
                    var _loc_3:* = this;
                    var _loc_4:* = this.moreNum + 1;
                    _loc_3.moreNum = _loc_4;
                    if (this.moreNum > 2)
                    {
                        this.moreNum = 0;
                    }
                    break;
                }
                case this.left_btn:
                {
                    this.imgArr.unshift(this.imgArr[(this.imgArr.length - 1)]);
                    this.imgArr.pop();
                    this.img_mc.setChildIndex(this.imgArr[0], (this.img_mc.numChildren - 1));
                    this.btnArr.unshift(this.btnArr[(this.imgArr.length - 1)]);
                    this.btnArr.pop();
                    this.timeline.append(TweenMax.to(this.imgArr[0], this.speed, {x:67, y:-24, scaleX:1, scaleY:1, blurFilter:{blurX:0, blurY:0}}));
                    this.timeline.insert(TweenMax.to(this.imgArr[2], this.speed, {x:-5, y:5, scaleX:0.7, scaleY:0.7, blurFilter:{blurX:3, blurY:3}}));
                    this.timeline.insert(TweenMax.to(this.imgArr[1], this.speed, {x:234, y:5, scaleX:0.7, scaleY:0.7, blurFilter:{blurX:3, blurY:3}, onComplete:this.addEvent, onCompleteParams:[event.currentTarget]}));
                    var _loc_3:* = this;
                    var _loc_4:* = this.moreNum - 1;
                    _loc_3.moreNum = _loc_4;
                    if (this.moreNum < 0)
                    {
                        this.moreNum = 2;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            this.btnArr[0].gotoAndStop(2);
            this.btnArr[0].buttonMode = false;
            return;
        }// end function

        private function onMore(event:MouseEvent) : void
        {
            switch(this.moreNum)
            {
                case 2:
                {
                    trace("常见问题");
                    ExternalInterface.call("showDiv", 3, null);
                    break;
                }
                case 0:
                {
                    trace("产品特点");
                    ExternalInterface.call("showDiv", 1, null);
                    break;
                }
                case 1:
                {
                    trace("滤网选择");
                    ExternalInterface.call("showDiv", 2, null);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function addEvent(param1:int) : void
        {
            var _loc_2:int = 0;
            while (_loc_2 < this.btnArr.length)
            {
                
                this.btnArr[_loc_2].buttonMode = true;
                this.btnArr[_loc_2].addEventListener(MouseEvent.CLICK, this.onBtnClick);
                _loc_2++;
            }
            this.btnArr[param1].buttonMode = false;
            this.btnArr[param1].removeEventListener(MouseEvent.CLICK, this.onBtnClick);
            this.right_btn.addEventListener(MouseEvent.CLICK, this.onClick);
            this.left_btn.addEventListener(MouseEvent.CLICK, this.onClick);
            this.timer.start();
            return;
        }// end function

    }
}
