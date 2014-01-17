package page4_fla
{
    import flash.display.*;

    dynamic public class Timeline_15 extends MovieClip
    {
        public var pro2_1:MovieClip;
        public var Mask1:MovieClip;

        public function Timeline_15()
        {
            addFrameScript(0, this.frame1);
            return;
        }// end function

        function frame1()
        {
            this.pro2_1.mask = this.Mask1;
            return;
        }// end function

    }
}
