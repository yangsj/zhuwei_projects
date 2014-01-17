package page4_fla
{
    import com.greensock.*;
    import com.greensock.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.utils.*;

    dynamic public class MainTimeline extends MovieClip
    {
        public var left:MovieClip;
        public var right:MovieClip;
        public var grayleft:MovieClip;
        public var grayright:MovieClip;
        public var dot:MovieClip;
        public var proBtn:SimpleButton;
        public var pro1:MovieClip;
        public var pro2:MovieClip;
        public var pro3:MovieClip;
        public var pro4:MovieClip;
        public var lines:MovieClip;
        public var proRight:MovieClip;
        public var ear:Number;
        public var timer:Timer;

        public function MainTimeline()
        {
            addFrameScript(0, this.frame1);
            return;
        }// end function

        public function probtn(event:MouseEvent) : void
        {
            ExternalInterface.call("selectFliter", "AP_FILTERS_SU_CN_CONSUMER");
            return;
        }// end function

        public function onTimer(event:TimerEvent) : void
        {
            if (this.ear != 4)
            {
                trace("right");
                this.right.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            }
            else
            {
                this.animation1();
            }
            return;
        }// end function

        public function pro1over(event:MouseEvent) : void
        {
            this.animation1();
            return;
        }// end function

        public function pro2over(event:MouseEvent) : void
        {
            this.animation2();
            return;
        }// end function

        public function pro3over(event:MouseEvent) : void
        {
            this.animation3();
            return;
        }// end function

        public function pro4over(event:MouseEvent) : void
        {
            this.animation4();
            return;
        }// end function

        public function upButtonOver(event:MouseEvent) : void
        {
            this.proRight.up.gotoAndPlay(2);
            return;
        }// end function

        public function upButtonOut(event:MouseEvent) : void
        {
            this.proRight.up.gotoAndPlay(1);
            return;
        }// end function

        public function downButtonOver(event:MouseEvent) : void
        {
            this.proRight.down.gotoAndPlay(2);
            return;
        }// end function

        public function downButtonOut(event:MouseEvent) : void
        {
            this.proRight.down.gotoAndPlay(1);
            return;
        }// end function

        public function shang2(event:MouseEvent) : void
        {
            TweenMax.to(this.proRight.pro2.pro2_1, 0.5, {y:-3.05, ease:Quart.easeOut});
            this.proRight.grayup.visible = true;
            this.proRight.graydown.visible = false;
            this.proRight.up.visible = false;
            this.proRight.down.visible = true;
            this.dot.gotoAndStop(1);
            return;
        }// end function

        public function xia2(event:MouseEvent) : void
        {
            TweenMax.to(this.proRight.pro2.pro2_1, 0.5, {y:-104.05, ease:Quart.easeOut});
            this.dot.gotoAndStop(2);
            this.proRight.grayup.visible = false;
            this.proRight.graydown.visible = true;
            this.proRight.up.visible = true;
            this.proRight.down.visible = false;
            return;
        }// end function

        public function shang3(event:MouseEvent) : void
        {
            TweenMax.to(this.proRight.pro3.pro3_1, 0.5, {y:0, ease:Quart.easeOut});
            this.dot.gotoAndStop(1);
            this.proRight.grayup.visible = true;
            this.proRight.graydown.visible = false;
            this.proRight.up.visible = false;
            this.proRight.down.visible = true;
            return;
        }// end function

        public function xia3(event:MouseEvent) : void
        {
            TweenMax.to(this.proRight.pro3.pro3_1, 0.5, {y:-200, ease:Quart.easeOut});
            this.proRight.grayup.visible = false;
            this.proRight.graydown.visible = true;
            this.proRight.up.visible = true;
            this.proRight.down.visible = false;
            this.dot.gotoAndStop(2);
            return;
        }// end function

        public function shang4(event:MouseEvent) : void
        {
            TweenMax.to(this.proRight.pro4.pro4_1, 0.5, {y:0, ease:Quart.easeOut});
            this.proRight.grayup.visible = true;
            this.proRight.graydown.visible = false;
            this.proRight.up.visible = false;
            this.proRight.down.visible = true;
            this.dot.gotoAndStop(1);
            return;
        }// end function

        public function xia4(event:MouseEvent) : void
        {
            TweenMax.to(this.proRight.pro4.pro4_1, 0.5, {y:-200, ease:Quart.easeOut});
            this.dot.gotoAndStop(2);
            this.proRight.grayup.visible = false;
            this.proRight.graydown.visible = true;
            this.proRight.up.visible = true;
            this.proRight.down.visible = false;
            return;
        }// end function

        public function rightButtonOver(event:MouseEvent) : void
        {
            this.right.gotoAndPlay(2);
            return;
        }// end function

        public function rightButtonOut(event:MouseEvent) : void
        {
            this.right.gotoAndPlay(1);
            return;
        }// end function

        public function leftButtonOver(event:MouseEvent) : void
        {
            this.left.gotoAndPlay(2);
            return;
        }// end function

        public function leftButtonOut(event:MouseEvent) : void
        {
            this.left.gotoAndPlay(1);
            return;
        }// end function

        public function rightButton(event:MouseEvent) : void
        {
            if (this.ear == 1)
            {
                this.animation2();
            }
            else if (this.ear == 2)
            {
                this.animation3();
            }
            else if (this.ear == 3)
            {
                this.animation4();
            }
            else
            {
                this.animation1();
            }
            return;
        }// end function

        public function leftButton(event:MouseEvent) : void
        {
            if (this.ear == 1)
            {
                this.animation4();
            }
            else if (this.ear == 2)
            {
                this.animation1();
            }
            else if (this.ear == 3)
            {
                this.animation2();
            }
            else if (this.ear == 4)
            {
                this.animation3();
            }
            else
            {
                this.animation4();
            }
            return;
        }// end function

        public function animation1()
        {
            this.proRight.grayup.visible = false;
            this.proRight.graydown.visible = false;
            this.dot.visible = false;
            this.ear = 1;
            this.lines.visible = true;
            this.pro1.word.visible = true;
            this.pro2.word.visible = false;
            this.pro3.word.visible = false;
            this.pro4.word.visible = false;
            this.proRight.up.visible = false;
            this.proRight.down.visible = false;
            this.dot.dotup.removeEventListener(MouseEvent.CLICK, this.shang2);
            this.dot.dotdown.removeEventListener(MouseEvent.CLICK, this.xia2);
            this.dot.dotup.removeEventListener(MouseEvent.CLICK, this.shang3);
            this.dot.dotdown.removeEventListener(MouseEvent.CLICK, this.xia3);
            this.dot.dotup.removeEventListener(MouseEvent.CLICK, this.shang4);
            this.dot.dotdown.removeEventListener(MouseEvent.CLICK, this.xia4);
            this.proRight.up.removeEventListener(MouseEvent.CLICK, this.shang2);
            this.proRight.down.removeEventListener(MouseEvent.CLICK, this.xia2);
            this.proRight.up.removeEventListener(MouseEvent.CLICK, this.shang3);
            this.proRight.down.removeEventListener(MouseEvent.CLICK, this.xia3);
            this.proRight.up.removeEventListener(MouseEvent.CLICK, this.shang4);
            this.proRight.down.removeEventListener(MouseEvent.CLICK, this.xia4);
            TweenMax.to(this.pro1, 0.5, {scaleX:1, scaleY:1, ease:Quart.easeOut});
            TweenMax.to(this.pro2, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.pro3, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.pro4, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro1, 0.5, {alpha:1, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro2, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro3, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro4, 0.5, {alpha:0, ease:Quart.easeOut});
            this.left.visible = false;
            this.right.visible = true;
            this.grayleft.visible = true;
            this.grayright.visible = false;
            return;
        }// end function

        public function animation2()
        {
            this.proRight.grayup.visible = false;
            this.proRight.graydown.visible = false;
            this.dot.visible = true;
            this.ear = 2;
            this.lines.visible = false;
            this.pro2.word.visible = true;
            this.pro1.word.visible = false;
            this.pro3.word.visible = false;
            this.pro4.word.visible = false;
            this.proRight.up.visible = true;
            this.proRight.down.visible = true;
            this.dot.dotup.addEventListener(MouseEvent.CLICK, this.shang2);
            this.dot.dotdown.addEventListener(MouseEvent.CLICK, this.xia2);
            this.dot.dotup.removeEventListener(MouseEvent.CLICK, this.shang3);
            this.dot.dotdown.removeEventListener(MouseEvent.CLICK, this.xia3);
            this.dot.dotup.removeEventListener(MouseEvent.CLICK, this.shang4);
            this.dot.dotdown.removeEventListener(MouseEvent.CLICK, this.xia4);
            this.proRight.up.addEventListener(MouseEvent.CLICK, this.shang2);
            this.proRight.down.addEventListener(MouseEvent.CLICK, this.xia2);
            this.proRight.up.removeEventListener(MouseEvent.CLICK, this.shang3);
            this.proRight.down.removeEventListener(MouseEvent.CLICK, this.xia3);
            this.proRight.up.removeEventListener(MouseEvent.CLICK, this.shang4);
            this.proRight.down.removeEventListener(MouseEvent.CLICK, this.xia4);
            TweenMax.to(this.pro2, 0.5, {scaleX:1, scaleY:1, ease:Quart.easeOut});
            TweenMax.to(this.pro1, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.pro3, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.pro4, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro2, 0.5, {alpha:1, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro1, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro3, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro4, 0.5, {alpha:0, ease:Quart.easeOut});
            this.left.visible = true;
            this.right.visible = true;
            this.grayleft.visible = false;
            this.grayright.visible = false;
            return;
        }// end function

        public function animation3()
        {
            this.proRight.grayup.visible = false;
            this.proRight.graydown.visible = false;
            this.dot.visible = true;
            this.ear = 3;
            this.lines.visible = false;
            this.pro3.word.visible = true;
            this.pro2.word.visible = false;
            this.pro1.word.visible = false;
            this.pro4.word.visible = false;
            this.proRight.up.visible = true;
            this.proRight.down.visible = true;
            this.dot.dotup.removeEventListener(MouseEvent.CLICK, this.shang2);
            this.dot.dotdown.removeEventListener(MouseEvent.CLICK, this.xia2);
            this.dot.dotup.addEventListener(MouseEvent.CLICK, this.shang3);
            this.dot.dotdown.addEventListener(MouseEvent.CLICK, this.xia3);
            this.dot.dotup.removeEventListener(MouseEvent.CLICK, this.shang4);
            this.dot.dotdown.removeEventListener(MouseEvent.CLICK, this.xia4);
            this.proRight.up.removeEventListener(MouseEvent.CLICK, this.shang2);
            this.proRight.down.removeEventListener(MouseEvent.CLICK, this.xia2);
            this.proRight.up.addEventListener(MouseEvent.CLICK, this.shang3);
            this.proRight.down.addEventListener(MouseEvent.CLICK, this.xia3);
            this.proRight.up.removeEventListener(MouseEvent.CLICK, this.shang4);
            this.proRight.down.removeEventListener(MouseEvent.CLICK, this.xia4);
            TweenMax.to(this.pro3, 0.5, {scaleX:1, scaleY:1, ease:Quart.easeOut});
            TweenMax.to(this.pro2, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.pro1, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.pro4, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro3, 0.5, {alpha:1, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro2, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro1, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro4, 0.5, {alpha:0, ease:Quart.easeOut});
            this.left.visible = true;
            this.right.visible = true;
            this.grayleft.visible = false;
            this.grayright.visible = false;
            return;
        }// end function

        public function animation4()
        {
            this.proRight.grayup.visible = false;
            this.proRight.graydown.visible = false;
            this.dot.visible = true;
            this.ear = 4;
            this.lines.visible = false;
            this.pro4.word.visible = true;
            this.pro2.word.visible = false;
            this.pro3.word.visible = false;
            this.pro1.word.visible = false;
            this.proRight.up.visible = true;
            this.proRight.down.visible = true;
            this.dot.dotup.removeEventListener(MouseEvent.CLICK, this.shang2);
            this.dot.dotdown.removeEventListener(MouseEvent.CLICK, this.xia2);
            this.dot.dotup.removeEventListener(MouseEvent.CLICK, this.shang3);
            this.dot.dotdown.removeEventListener(MouseEvent.CLICK, this.xia3);
            this.dot.dotup.addEventListener(MouseEvent.CLICK, this.shang4);
            this.dot.dotdown.addEventListener(MouseEvent.CLICK, this.xia4);
            this.proRight.up.removeEventListener(MouseEvent.CLICK, this.shang2);
            this.proRight.down.removeEventListener(MouseEvent.CLICK, this.xia2);
            this.proRight.up.removeEventListener(MouseEvent.CLICK, this.shang3);
            this.proRight.down.removeEventListener(MouseEvent.CLICK, this.xia2);
            this.proRight.up.addEventListener(MouseEvent.CLICK, this.shang4);
            this.proRight.down.addEventListener(MouseEvent.CLICK, this.xia4);
            TweenMax.to(this.pro4, 0.5, {scaleX:1, scaleY:1, ease:Quart.easeOut});
            TweenMax.to(this.pro2, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.pro3, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.pro1, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro4, 0.5, {alpha:1, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro2, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro3, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro1, 0.5, {alpha:0, ease:Quart.easeOut});
            this.left.visible = true;
            this.right.visible = false;
            this.grayleft.visible = false;
            this.grayright.visible = true;
            return;
        }// end function

        function frame1()
        {
            this.ear = 0;
            this.proRight.grayup.visible = false;
            this.proRight.graydown.visible = false;
            this.grayleft.visible = false;
            this.grayright.visible = false;
            this.left.buttonMode = true;
            this.right.buttonMode = true;
            this.pro1.word.visible = false;
            this.pro2.word.visible = false;
            this.pro3.word.visible = false;
            this.pro4.word.visible = false;
            this.animation1();
            this.timer = new Timer(4000, 0);
            this.timer.addEventListener(TimerEvent.TIMER, this.onTimer);
            this.proBtn.addEventListener(MouseEvent.CLICK, this.probtn);
            this.right.addEventListener(MouseEvent.CLICK, this.rightButton);
            this.left.addEventListener(MouseEvent.CLICK, this.leftButton);
            this.left.addEventListener(MouseEvent.ROLL_OVER, this.leftButtonOver);
            this.left.addEventListener(MouseEvent.ROLL_OUT, this.leftButtonOut);
            this.right.addEventListener(MouseEvent.ROLL_OVER, this.rightButtonOver);
            this.right.addEventListener(MouseEvent.ROLL_OUT, this.rightButtonOut);
            this.proRight.up.buttonMode = true;
            this.proRight.down.buttonMode = true;
            this.proRight.up.addEventListener(MouseEvent.ROLL_OVER, this.upButtonOver);
            this.proRight.up.addEventListener(MouseEvent.ROLL_OUT, this.upButtonOut);
            this.proRight.down.addEventListener(MouseEvent.ROLL_OVER, this.downButtonOver);
            this.proRight.down.addEventListener(MouseEvent.ROLL_OUT, this.downButtonOut);
            this.pro1.buttonMode = true;
            this.pro2.buttonMode = true;
            this.pro3.buttonMode = true;
            this.pro4.buttonMode = true;
            this.pro1.addEventListener(MouseEvent.ROLL_OVER, this.pro1over);
            this.pro2.addEventListener(MouseEvent.ROLL_OVER, this.pro2over);
            this.pro3.addEventListener(MouseEvent.ROLL_OVER, this.pro3over);
            this.pro4.addEventListener(MouseEvent.ROLL_OVER, this.pro4over);
            return;
        }// end function

    }
}
