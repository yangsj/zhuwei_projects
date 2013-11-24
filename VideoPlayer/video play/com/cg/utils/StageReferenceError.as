package com.cg.utils 
{
    public class StageReferenceError extends Error 
    {
        public function StageReferenceError(id:int)
        {
            super(getMessage(id), id);
        }

        private function getMessage(id:int):String
        {
            var m:String = "不存在错误ID";
            switch(id)
            {
                case 0:
                {
                    m = "StageReference必须使用initialize(DisplayObject)初期化后才能使用";
                    break;
                }
                case 1:
                {
                    m = "初期化时DisplayObject不能为null";
                    break;
                }
                case 2:
                {
                    m = "初期化时DisplayObject必须存在在舞台上，或者DisplayObject本身就是stage";
                }
            }
            return m;
        }
    }
}
