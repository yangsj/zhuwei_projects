/***********
控制MC时间线动画正,倒放
AS3
用法:
MCPlayCtrl.too(this,false,"F");//正放
MCPlayCtrl.too(this,false,"R");//倒放

Copyright(C)2009 supernova.cn by noah
***********/
package 
{
	import flash.events.*;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import com.nova.core.ContrlPlay;
	public class MCPlayCtrl extends ContrlPlay{

		public function MCPlayCtrl() {
			super(this,"",true);
			addEventListener(MouseEvent.MOUSE_OVER,function(){
																
															fplay();
															
															 })
			addEventListener(MouseEvent.MOUSE_OUT,function(){
																
															rplay();
															 })


		}

	}
}