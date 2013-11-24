package com.cg.utils 
{

    public class DisplayObjectUtilError extends Error 
    {
        public static const FAILED_STAGE_REFERENCE_INIT_ID : int = 0;
        public static const FAILED_STAGE_REFERENCE_INIT : String = "stage对象想要实现removeAllChildren()失败，StageReference未初期化";
        
        public function DisplayObjectUtilError(message:String, id:int)
        {
            super(message, id);
        }    
    }
}
