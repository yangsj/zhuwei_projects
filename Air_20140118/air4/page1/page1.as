package 
{
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;

    public class page1 extends MovieClip
    {
        public var question1:MovieClip;
        public var question:MovieClip;
        public var more_btn:MovieClip;
        private var btnArr1:Array;
        private var btnArr2:Array;
        private var timeline:TimelineMax;
        private var temp:int = 0;
        private var temp2:int = 0;
        private var tempi:int = -1;

        public function page1()
        {
            this.btnArr1 = [];
            this.btnArr2 = [];
            addFrameScript(0, this.frame1);
            this.btnArr1 = [this.question.btn1, this.question.btn2, this.question.btn3, this.question.btn4, this.question.btn5, this.question.btn6, this.question.btn7, this.question.btn8];
            this.btnArr2 = [this.question1.btn1, this.question1.btn2];
            var _loc_1:int = 0;
            while (_loc_1 < this.btnArr1.length)
            {
                
                this.btnArr1[_loc_1].addEventListener(MouseEvent.CLICK, this.onClick);
                this.btnArr1[_loc_1].buttonMode = true;
                _loc_1++;
            }
            var _loc_2:int = 0;
            while (_loc_2 < this.btnArr2.length)
            {
                
                this.btnArr2[_loc_2].addEventListener(MouseEvent.CLICK, this.onClick);
                this.btnArr2[_loc_2].buttonMode = true;
                _loc_2++;
            }
            this.question.nextBtn.addEventListener(MouseEvent.CLICK, this.onNextOrPre);
            this.question.nextBtn.buttonMode = true;
            this.question1.preBtn.addEventListener(MouseEvent.CLICK, this.onNextOrPre);
            this.question1.preBtn.buttonMode = true;
            this.question.btn1.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            return;
        }// end function

        private function onNextOrPre(event:MouseEvent) : void
        {
            var _loc_2:int = 0;
            while (_loc_2 < this.btnArr1.length)
            {
                
                this.btnArr1[_loc_2].addEventListener(MouseEvent.CLICK, this.onClick);
                this.btnArr1[_loc_2].buttonMode = true;
                _loc_2++;
            }
            var _loc_3:int = 0;
            while (_loc_3 < this.btnArr2.length)
            {
                
                this.btnArr2[_loc_3].addEventListener(MouseEvent.CLICK, this.onClick);
                this.btnArr2[_loc_3].buttonMode = true;
                _loc_3++;
            }
            switch(event.currentTarget)
            {
                case this.question.nextBtn:
                {
                    gotoAndStop(2);
                    this.question.visible = false;
                    this.question1.visible = true;
                    this.question1.btn1.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                    break;
                }
                case this.question1.preBtn:
                {
                    gotoAndStop(1);
                    this.question.visible = true;
                    this.question1.visible = false;
                    this.question.btn1.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onMore(event:MouseEvent) : void
        {
            ExternalInterface.call("showDiv", "3", "null");
            return;
        }// end function

        private function onClick(event:MouseEvent) : void
        {
            this.timeline = new TimelineMax();
            switch(event.currentTarget)
            {
                case this.btnArr1[0]:
                case this.btnArr1[1]:
                case this.btnArr1[5]:
                case this.btnArr1[6]:
                case this.btnArr1[7]:
                {
                    this.onTween(event.currentTarget, 0, 1);
                    break;
                }
                case this.btnArr1[2]:
                {
                    this.onTween(event.currentTarget, 30, 1);
                    break;
                }
                case this.btnArr1[3]:
                {
                    this.onTween(event.currentTarget, 50, 1);
                    break;
                }
                case this.btnArr1[4]:
                {
                    this.onTween(event.currentTarget, 10, 1);
                    break;
                }
                case this.btnArr2[0]:
                {
                    this.onTween(event.currentTarget, 260, 2);
                    break;
                }
                case this.btnArr2[1]:
                {
                    this.onTween(event.currentTarget, 10, 2);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onTween(param1:Object, param2:int = 0, param3:int = 1) : void
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            switch(param3)
            {
                case 1:
                {
                    _loc_4 = 0;
                    while (_loc_4 < this.btnArr1.length)
                    {
                        
                        this.btnArr1[_loc_4].gotoAndStop(1);
                        this.btnArr1[_loc_4].line.alpha = 1;
                        this.btnArr1[_loc_4].buttonMode = false;
                        this.btnArr1[_loc_4].removeEventListener(MouseEvent.CLICK, this.onClick);
                        if (_loc_4 != this.btnArr1.length)
                        {
                            this.timeline.insert(TweenMax.to(this.btnArr1[_loc_4], 0.3, {y:_loc_4 * 26}));
                        }
                        else
                        {
                            this.timeline.insert(TweenMax.to(this.btnArr1[_loc_4], 0.3, {y:_loc_4 * 26 + 19}));
                        }
                        this.timeline.insert(TweenMax.to(this.btnArr1[_loc_4].info, 0.3, {height:1}));
                        if (this.btnArr1[_loc_4] == param1)
                        {
                            trace(123);
                            this.temp = _loc_4;
                            this.btnArr1[_loc_4].line.alpha = 0;
                        }
                        _loc_4++;
                    }
                    _loc_5 = this.temp + 1;
                    while (_loc_5 < this.btnArr1.length)
                    {
                        
                        if (_loc_5 != this.btnArr1.length)
                        {
                            this.timeline.insert(TweenMax.to(this.btnArr1[_loc_5], 0.3, {y:97 + param2 + _loc_5 * 26}));
                        }
                        else
                        {
                            this.timeline.insert(TweenMax.to(this.btnArr1[_loc_5], 0.3, {y:97 + param2 + _loc_5 * 26 + 19}));
                        }
                        _loc_5++;
                    }
                    this.timeline.insert(TweenMax.to(this.question.info_bgs, 0.3, {height:358 + param2}));
                    this.timeline.insert(TweenMax.to(this.question.nextBtn, 0.3, {y:325 + param2, onComplete:this.onOver}));
                    break;
                }
                case 2:
                {
                    _loc_6 = 0;
                    while (_loc_6 < this.btnArr2.length)
                    {
                        
                        this.btnArr2[_loc_6].gotoAndStop(1);
                        this.btnArr2[_loc_6].line.alpha = 1;
                        this.btnArr2[_loc_6].buttonMode = false;
                        this.btnArr2[_loc_6].removeEventListener(MouseEvent.CLICK, this.onClick);
                        this.timeline.insert(TweenMax.to(this.btnArr2[_loc_6], 0.3, {y:_loc_6 * 26}));
                        this.timeline.insert(TweenMax.to(this.btnArr2[_loc_6].info, 0.3, {height:1}));
                        if (this.btnArr2[_loc_6] == param1)
                        {
                            trace("========");
                            this.temp2 = _loc_6;
                            this.btnArr2[_loc_6].line.alpha = 0;
                        }
                        _loc_6++;
                    }
                    _loc_7 = this.temp2 + 1;
                    while (_loc_7 < this.btnArr2.length)
                    {
                        
                        this.timeline.insert(TweenMax.to(this.btnArr2[_loc_7], 0.3, {y:97 + param2 + _loc_7 * 26}));
                        _loc_7++;
                    }
                    this.timeline.insert(TweenMax.to(this.question1.info_bgs, 0.3, {height:183 + param2}));
                    this.timeline.insert(TweenMax.to(this.question1.preBtn, 0.3, {y:151 + param2, onComplete:this.onOver}));
                    break;
                }
                default:
                {
                    break;
                }
            }
            param1.gotoAndStop(2);
            this.timeline.insert(TweenMax.to(param1.info, 0.3, {height:100 + param2, onComplete:this.onOver}));
            return;
        }// end function

        private function onOver() : void
        {
            var _loc_1:int = 0;
            while (_loc_1 < this.btnArr1.length)
            {
                
                this.btnArr1[_loc_1].addEventListener(MouseEvent.CLICK, this.onClick);
                this.btnArr1[_loc_1].buttonMode = true;
                _loc_1++;
            }
            this.btnArr1[this.temp].removeEventListener(MouseEvent.CLICK, this.onClick);
            this.btnArr1[this.temp].buttonMode = false;
            var _loc_2:int = 0;
            while (_loc_2 < this.btnArr2.length)
            {
                
                this.btnArr2[_loc_2].addEventListener(MouseEvent.CLICK, this.onClick);
                this.btnArr2[_loc_2].buttonMode = true;
                _loc_2++;
            }
            this.btnArr2[this.temp2].removeEventListener(MouseEvent.CLICK, this.onClick);
            this.btnArr2[this.temp2].buttonMode = false;
            this.tempi = -1;
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

    }
}
