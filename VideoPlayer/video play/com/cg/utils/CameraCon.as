package com.cg.utils
{
	import com.cg.utils.cgTransform;
	import flash.display.Sprite;
	import com.cg.utils.exBitmapData;
	import com.cg.utils.exCon;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
    import flash.events.*;
	import flash.geom.Rectangle;
    import flash.media.Camera;
    import flash.media.Video;
	/**
	 * ...
	 * @author cg
	 */
	public class CameraCon extends Sprite 
	{
		
		private var video:Video;
		private var videoCon:Sprite;
		private var bg:Sprite;
		private var camera:Camera;
		private var bmpd:BitmapData;
		private var bmp:Bitmap;
		private var w:int = 400;
		private var h:int = 300;
		public function CameraCon(_w:int,_h:int) 
		{
			w = _w;
			h = _h;
			this.scrollRect = new Rectangle(0, 0, w, h);
			bg = new Sprite();
			bg.graphics.beginFill(0, 1);
			bg.graphics.drawRect(0, 0, w, h);
			bg.visible = false;
			addChild(bg);
			videoCon = new Sprite();
			addChild(videoCon);
			this.addEventListener(Event.ADDED_TO_STAGE, onAdd2Stage);
        }
		
		private function onAdd2Stage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdd2Stage);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			camera= Camera.getCamera();
            
            if (camera!= null) {
                camera.addEventListener(ActivityEvent.ACTIVITY, activityHandler);
				camera.setMode(800, 600, 16);
                video = new Video(camera.width, camera.height);
                video.attachCamera(camera);
				video.scaleX = -1;
				video.x = w;
                videoCon.addChild(video);
				cgTransform.scaleTo(videoCon,w, h, "cut");
				cgTransform.alignTo(videoCon, bg, "CC");
            } else {
                trace("You need a Camera.");
            }
		}
		public function getPhoto():BitmapData
		{
			bmpd = new BitmapData(w, h, false, 0);
			bmpd.draw(this);
			//var bmp:Bitmap = new Bitmap(bmpd);
			//stage.addChild(bmp);
			return bmpd;
			//return exBitmapData.scaleTo(bmpd, 840, 525);
		}
		private function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			if (camera!= null) {
				camera.removeEventListener(ActivityEvent.ACTIVITY, activityHandler);
				camera = null;
			}
			if(video!=null){
				video = null;
			}
			if (bmpd != null) {
				bmpd.dispose();
			}
		}
        
        private function activityHandler(event:ActivityEvent):void {
           // trace("activityHandler: " + event);
        }
		
	}

}