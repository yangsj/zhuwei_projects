package page4_fla
{
    import flash.display.*;

    dynamic public class Timeline_20 extends MovieClip
    {
        public var Mask1:MovieClip;
        public var pro4_1:MovieClip;

        public function Timeline_20()
        {
            addFrameScript(0, this.frame1);
            return;
        }// end function

        function frame1()
        {
            this.pro4_1.mask = this.Mask1;
            return;
        }// end function

    }
}
