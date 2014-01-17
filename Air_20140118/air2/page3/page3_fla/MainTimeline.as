package page3_fla
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
        public var Mask:MovieClip;
        public var product:MovieClip;
        public var right:MovieClip;
        public var grayleft:MovieClip;
        public var grayright:MovieClip;
        public var proBtn:SimpleButton;
        public var proRight:MovieClip;
        public var ear:Number;
        public var aaa:Number;
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
            if (this.ear != 8)
            {
                trace("right");
                this.right.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
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

        public function pro5over(event:MouseEvent) : void
        {
            this.animation5();
            return;
        }// end function

        public function pro6over(event:MouseEvent) : void
        {
            this.animation6();
            return;
        }// end function

        public function pro7over(event:MouseEvent) : void
        {
            this.animation7();
            return;
        }// end function

        public function pro8over(event:MouseEvent) : void
        {
            this.animation8();
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

        public function leftButton(event:MouseEvent) : void
        {
            if (this.ear == 2 && this.product.x == 77.1)
            {
                this.animation1();
                TweenMax.to(this.product, 0.2, {x:77.1, ease:Quart.easeOut});
            }
            else if (this.ear == 2 && this.product.x == 2.2)
            {
                this.animation1();
                TweenMax.to(this.product, 0.2, {x:77.1, ease:Quart.easeOut});
            }
            else if (this.ear == 3 && this.product.x == 77.1)
            {
                this.animation2();
                TweenMax.to(this.product, 0.2, {x:77.1, ease:Quart.easeOut});
            }
            else if (this.ear == 3 && this.product.x == 2.2)
            {
                this.animation2();
                TweenMax.to(this.product, 0.2, {x:77.1, ease:Quart.easeOut});
            }
            else if (this.ear == 3 && this.product.x == -73.1)
            {
                this.animation2();
                TweenMax.to(this.product, 0.2, {x:2.2, ease:Quart.easeOut});
            }
            else if (this.ear == 4 && this.product.x == 77.1)
            {
                this.animation3();
                TweenMax.to(this.product, 0.2, {x:77.1, ease:Quart.easeOut});
            }
            else if (this.ear == 4 && this.product.x == 2.2)
            {
                this.animation3();
                TweenMax.to(this.product, 0.2, {x:77.1, ease:Quart.easeOut});
            }
            else if (this.ear == 4 && this.product.x == -73.1)
            {
                this.animation3();
                TweenMax.to(this.product, 0.2, {x:2.2, ease:Quart.easeOut});
            }
            else if (this.ear == 4 && this.product.x == -148.1)
            {
                this.animation3();
                TweenMax.to(this.product, 0.2, {x:-73.1, ease:Quart.easeOut});
            }
            else if (this.ear == 5 && this.product.x == 77.1)
            {
                this.animation4();
                TweenMax.to(this.product, 0.2, {x:77.1, ease:Quart.easeOut});
            }
            else if (this.ear == 5 && this.product.x == 2.2)
            {
                this.animation4();
                TweenMax.to(this.product, 0.2, {x:77.1, ease:Quart.easeOut});
            }
            else if (this.ear == 5 && this.product.x == -73.1)
            {
                this.animation4();
                TweenMax.to(this.product, 0.2, {x:2.2, ease:Quart.easeOut});
            }
            else if (this.ear == 5 && this.product.x == -148.1)
            {
                this.animation4();
                TweenMax.to(this.product, 0.2, {x:-73.1, ease:Quart.easeOut});
            }
            else if (this.ear == 6 && this.product.x == 2.2)
            {
                this.animation5();
                TweenMax.to(this.product, 0.2, {x:77.1, ease:Quart.easeOut});
            }
            else if (this.ear == 6 && this.product.x == -73.1)
            {
                this.animation5();
                TweenMax.to(this.product, 0.2, {x:2.2, ease:Quart.easeOut});
            }
            else if (this.ear == 6 && this.product.x == -148.1)
            {
                this.animation5();
                TweenMax.to(this.product, 0.2, {x:-73.1, ease:Quart.easeOut});
            }
            else if (this.ear == 7 && this.product.x == -73.1)
            {
                this.animation6();
                TweenMax.to(this.product, 0.2, {x:2.2, ease:Quart.easeOut});
            }
            else if (this.ear == 7 && this.product.x == 2.2)
            {
                this.animation6();
                TweenMax.to(this.product, 0.2, {x:77.1, ease:Quart.easeOut});
            }
            else if (this.ear == 7 && this.product.x == -148.1)
            {
                this.animation6();
                TweenMax.to(this.product, 0.2, {x:-73.1, ease:Quart.easeOut});
            }
            else if (this.ear == 8 && this.product.x == -148.1)
            {
                this.animation7();
                TweenMax.to(this.product, 0.2, {x:-73.1, ease:Quart.easeOut});
            }
            return;
        }// end function

        public function rightButton(event:MouseEvent) : void
        {
            if (this.ear == 1 && this.product.x == 77.1)
            {
                this.animation2();
                TweenMax.to(this.product, 0.2, {x:77.1, ease:Quart.easeOut});
            }
            else if (this.ear == 2 && this.product.x == 77.1)
            {
                this.animation3();
                TweenMax.to(this.product, 0.2, {x:77.1, ease:Quart.easeOut});
            }
            else if (this.ear == 2 && this.product.x == 2.2)
            {
                this.animation3();
                TweenMax.to(this.product, 0.2, {x:2.2, ease:Quart.easeOut});
            }
            else if (this.ear == 3 && this.product.x == 77.1)
            {
                this.animation4();
                TweenMax.to(this.product, 0.2, {x:77.1, ease:Quart.easeOut});
            }
            else if (this.ear == 3 && this.product.x == 2.2)
            {
                this.animation4();
                TweenMax.to(this.product, 0.2, {x:2.2, ease:Quart.easeOut});
            }
            else if (this.ear == 3 && this.product.x == -73.1)
            {
                this.animation4();
                TweenMax.to(this.product, 0.2, {x:-73.1, ease:Quart.easeOut});
            }
            else if (this.ear == 4 && this.product.x == 77.1)
            {
                this.animation5();
                TweenMax.to(this.product, 0.2, {x:77.1, ease:Quart.easeOut});
            }
            else if (this.ear == 4 && this.product.x == 2.2)
            {
                this.animation5();
                TweenMax.to(this.product, 0.2, {x:2.2, ease:Quart.easeOut});
            }
            else if (this.ear == 4 && this.product.x == -73.1)
            {
                this.animation5();
                TweenMax.to(this.product, 0.2, {x:-73.1, ease:Quart.easeOut});
            }
            else if (this.ear == 4 && this.product.x == -148.1)
            {
                this.animation5();
                TweenMax.to(this.product, 0.2, {x:-148.1, ease:Quart.easeOut});
            }
            else if (this.ear == 5 && this.product.x == 77.1)
            {
                this.animation6();
                TweenMax.to(this.product, 0.2, {x:2.2, ease:Quart.easeOut});
            }
            else if (this.ear == 5 && this.product.x == 2.2)
            {
                this.animation6();
                TweenMax.to(this.product, 0.2, {x:2.2, ease:Quart.easeOut});
            }
            else if (this.ear == 5 && this.product.x == -73.1)
            {
                this.animation6();
                TweenMax.to(this.product, 0.2, {x:-73.1, ease:Quart.easeOut});
            }
            else if (this.ear == 5 && this.product.x == -148.1)
            {
                this.animation6();
                TweenMax.to(this.product, 0.2, {x:-148.1, ease:Quart.easeOut});
            }
            else if (this.ear == 6 && this.product.x == 2.2)
            {
                this.animation7();
                TweenMax.to(this.product, 0.2, {x:-73.1, ease:Quart.easeOut});
            }
            else if (this.ear == 6 && this.product.x == -73.1)
            {
                this.animation7();
                TweenMax.to(this.product, 0.2, {x:-73.1, ease:Quart.easeOut});
            }
            else if (this.ear == 6 && this.product.x == -148.1)
            {
                this.animation7();
                TweenMax.to(this.product, 0.2, {x:-148.1, ease:Quart.easeOut});
            }
            else if (this.ear == 7 && this.product.x == -73.1)
            {
                this.animation8();
                TweenMax.to(this.product, 0.2, {x:-148.1, ease:Quart.easeOut});
            }
            else if (this.ear == 7 && this.product.x == -148.1)
            {
                this.animation8();
                TweenMax.to(this.product, 0.2, {x:-148.1, ease:Quart.easeOut});
            }
            return;
        }// end function

        public function animation1()
        {
            this.ear = 1;
            this.product.pro1.word.visible = true;
            this.product.pro2.word.visible = false;
            this.product.pro3.word.visible = false;
            this.product.pro4.word.visible = false;
            this.product.pro5.word.visible = false;
            this.product.pro6.word.visible = false;
            this.product.pro7.word.visible = false;
            this.product.pro8.word.visible = false;
            TweenMax.to(this.product.pro1, 0.5, {scaleX:1, scaleY:1, ease:Quart.easeOut});
            TweenMax.to(this.product.pro2, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro3, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro4, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro5, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro6, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro7, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro8, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro1, 0.5, {alpha:1, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro2, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro3, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro4, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro5, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro6, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro7, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro8, 0.5, {alpha:0, ease:Quart.easeOut});
            this.left.visible = false;
            this.right.visible = true;
            this.grayleft.visible = true;
            this.grayright.visible = false;
            return;
        }// end function

        public function animation2()
        {
            this.ear = 2;
            this.product.pro2.word.visible = true;
            this.product.pro1.word.visible = false;
            this.product.pro3.word.visible = false;
            this.product.pro4.word.visible = false;
            this.product.pro5.word.visible = false;
            this.product.pro6.word.visible = false;
            this.product.pro7.word.visible = false;
            this.product.pro8.word.visible = false;
            TweenMax.to(this.product.pro2, 0.5, {scaleX:1, scaleY:1, ease:Quart.easeOut});
            TweenMax.to(this.product.pro1, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro3, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro4, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro5, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro6, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro7, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro8, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro2, 0.5, {alpha:1, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro1, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro3, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro4, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro5, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro6, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro7, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro8, 0.5, {alpha:0, ease:Quart.easeOut});
            this.left.visible = true;
            this.right.visible = true;
            this.grayleft.visible = false;
            this.grayright.visible = false;
            return;
        }// end function

        public function animation3()
        {
            this.ear = 3;
            this.product.pro3.word.visible = true;
            this.product.pro1.word.visible = false;
            this.product.pro2.word.visible = false;
            this.product.pro4.word.visible = false;
            this.product.pro5.word.visible = false;
            this.product.pro6.word.visible = false;
            this.product.pro7.word.visible = false;
            this.product.pro8.word.visible = false;
            TweenMax.to(this.product.pro3, 0.5, {scaleX:1, scaleY:1, ease:Quart.easeOut});
            TweenMax.to(this.product.pro2, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro1, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro4, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro5, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro6, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro7, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro8, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro3, 0.5, {alpha:1, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro2, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro1, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro4, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro5, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro6, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro7, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro8, 0.5, {alpha:0, ease:Quart.easeOut});
            this.left.visible = true;
            this.right.visible = true;
            this.grayleft.visible = false;
            this.grayright.visible = false;
            return;
        }// end function

        public function animation4()
        {
            this.ear = 4;
            this.product.pro4.word.visible = true;
            this.product.pro2.word.visible = false;
            this.product.pro3.word.visible = false;
            this.product.pro1.word.visible = false;
            this.product.pro5.word.visible = false;
            this.product.pro6.word.visible = false;
            this.product.pro7.word.visible = false;
            this.product.pro8.word.visible = false;
            TweenMax.to(this.product.pro4, 0.5, {scaleX:1, scaleY:1, ease:Quart.easeOut});
            TweenMax.to(this.product.pro2, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro3, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro1, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro5, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro6, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro7, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro8, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro4, 0.5, {alpha:1, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro2, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro3, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro1, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro5, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro6, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro7, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro8, 0.5, {alpha:0, ease:Quart.easeOut});
            this.left.visible = true;
            this.right.visible = true;
            this.grayleft.visible = false;
            this.grayright.visible = false;
            return;
        }// end function

        public function animation5()
        {
            this.ear = 5;
            this.product.pro5.word.visible = true;
            this.product.pro2.word.visible = false;
            this.product.pro3.word.visible = false;
            this.product.pro4.word.visible = false;
            this.product.pro1.word.visible = false;
            this.product.pro6.word.visible = false;
            this.product.pro7.word.visible = false;
            this.product.pro8.word.visible = false;
            TweenMax.to(this.product.pro5, 0.5, {scaleX:1, scaleY:1, ease:Quart.easeOut});
            TweenMax.to(this.product.pro2, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro3, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro4, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro1, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro6, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro7, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro8, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro5, 0.5, {alpha:1, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro2, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro3, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro4, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro1, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro6, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro7, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro8, 0.5, {alpha:0, ease:Quart.easeOut});
            this.left.visible = true;
            this.right.visible = true;
            this.grayleft.visible = false;
            this.grayright.visible = false;
            return;
        }// end function

        public function animation6()
        {
            this.ear = 6;
            this.product.pro6.word.visible = true;
            this.product.pro2.word.visible = false;
            this.product.pro3.word.visible = false;
            this.product.pro4.word.visible = false;
            this.product.pro5.word.visible = false;
            this.product.pro1.word.visible = false;
            this.product.pro7.word.visible = false;
            this.product.pro8.word.visible = false;
            TweenMax.to(this.product.pro6, 0.5, {scaleX:1, scaleY:1, ease:Quart.easeOut});
            TweenMax.to(this.product.pro2, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro3, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro4, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro5, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro1, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro7, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro8, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro6, 0.5, {alpha:1, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro2, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro3, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro4, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro5, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro1, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro7, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro8, 0.5, {alpha:0, ease:Quart.easeOut});
            this.left.visible = true;
            this.right.visible = true;
            this.grayleft.visible = false;
            this.grayright.visible = false;
            return;
        }// end function

        public function animation7()
        {
            this.aaa = 3;
            this.ear = 7;
            this.product.pro7.word.visible = true;
            this.product.pro2.word.visible = false;
            this.product.pro3.word.visible = false;
            this.product.pro4.word.visible = false;
            this.product.pro5.word.visible = false;
            this.product.pro6.word.visible = false;
            this.product.pro1.word.visible = false;
            this.product.pro8.word.visible = false;
            TweenMax.to(this.product.pro7, 0.5, {scaleX:1, scaleY:1, ease:Quart.easeOut});
            TweenMax.to(this.product.pro2, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro3, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro4, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro5, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro6, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro1, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro8, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro7, 0.5, {alpha:1, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro2, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro3, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro4, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro5, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro6, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro1, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro8, 0.5, {alpha:0, ease:Quart.easeOut});
            this.left.visible = true;
            this.right.visible = true;
            this.grayleft.visible = false;
            this.grayright.visible = false;
            return;
        }// end function

        public function animation8()
        {
            this.aaa = 4;
            this.ear = 8;
            this.product.pro8.word.visible = true;
            this.product.pro2.word.visible = false;
            this.product.pro3.word.visible = false;
            this.product.pro4.word.visible = false;
            this.product.pro5.word.visible = false;
            this.product.pro6.word.visible = false;
            this.product.pro7.word.visible = false;
            this.product.pro1.word.visible = false;
            TweenMax.to(this.product.pro8, 0.5, {scaleX:1, scaleY:1, ease:Quart.easeOut});
            TweenMax.to(this.product.pro2, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro3, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro4, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro5, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro6, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro7, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.product.pro1, 0.5, {scaleX:0.52, scaleY:0.52, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro8, 0.5, {alpha:1, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro2, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro3, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro4, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro5, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro6, 0.5, {alpha:0, ease:Quart.easeOut});
            TweenMax.to(this.proRight.pro7, 0.5, {alpha:0, ease:Quart.easeOut});
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
            this.aaa = 0;
            this.left.buttonMode = true;
            this.right.buttonMode = true;
            this.product.pro1.word.visible = false;
            this.product.pro2.word.visible = false;
            this.product.pro3.word.visible = false;
            this.product.pro4.word.visible = false;
            this.product.pro5.word.visible = false;
            this.product.mask = this.Mask;
            this.timer = new Timer(4000, 0);
            this.timer.addEventListener(TimerEvent.TIMER, this.onTimer);
            this.animation1();
            this.proBtn.addEventListener(MouseEvent.CLICK, this.probtn);
            this.right.addEventListener(MouseEvent.CLICK, this.rightButton);
            this.left.addEventListener(MouseEvent.CLICK, this.leftButton);
            this.left.addEventListener(MouseEvent.ROLL_OVER, this.leftButtonOver);
            this.left.addEventListener(MouseEvent.ROLL_OUT, this.leftButtonOut);
            this.right.addEventListener(MouseEvent.ROLL_OVER, this.rightButtonOver);
            this.right.addEventListener(MouseEvent.ROLL_OUT, this.rightButtonOut);
            this.product.pro1.buttonMode = true;
            this.product.pro2.buttonMode = true;
            this.product.pro3.buttonMode = true;
            this.product.pro4.buttonMode = true;
            this.product.pro5.buttonMode = true;
            this.product.pro6.buttonMode = true;
            this.product.pro7.buttonMode = true;
            this.product.pro8.buttonMode = true;
            this.product.pro1.addEventListener(MouseEvent.ROLL_OVER, this.pro1over);
            this.product.pro2.addEventListener(MouseEvent.ROLL_OVER, this.pro2over);
            this.product.pro3.addEventListener(MouseEvent.ROLL_OVER, this.pro3over);
            this.product.pro4.addEventListener(MouseEvent.ROLL_OVER, this.pro4over);
            this.product.pro5.addEventListener(MouseEvent.ROLL_OVER, this.pro5over);
            this.product.pro6.addEventListener(MouseEvent.ROLL_OVER, this.pro6over);
            this.product.pro7.addEventListener(MouseEvent.ROLL_OVER, this.pro7over);
            this.product.pro8.addEventListener(MouseEvent.ROLL_OVER, this.pro8over);
            return;
        }// end function

    }
}
