package com.cg.utils
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.display.Stage;
	import flash.geom.Matrix;
    import flash.display.BitmapDataChannel;
    import flash.display.BitmapData;
    import flash.geom.Point;
	import com.cg.encoder.GIFEncoder;
	import com.cg.encoder.JPEGEncoder;
	import com.cg.encoder.PNGEncoder;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	public class exBitmapData
	{
		public static function scaleTo(s_bmpd:BitmapData,width:int,height:int,lock_rate:Boolean=false):BitmapData
		{
			var bmpd:BitmapData=new BitmapData(width,height,true,0)
			var matrix:Matrix;
			if (lock_rate) {
				//锁定源图像的比例
				matrix = getScaleToFitRectangle(s_bmpd, width, height);
			}else {
				matrix = new Matrix();
				matrix.scale(width / s_bmpd.width, height / s_bmpd.height);
			}
			bmpd.draw(s_bmpd,matrix,null,null,null,true);
			return bmpd;
		}
		/**
         * 锁定比例情况下的缩放matrix
         */
        public static function getScaleToFitRectangle(target : BitmapData, containerWidth : Number, containerHeight : Number) : Matrix
        {
        	var rateCon : Number = containerWidth / containerHeight;
            var targetWidth:Number = target.width;
            var targetHeight:Number = target.height;
            var rateTar : Number = targetWidth / targetHeight;
            var isFitToWidth : Boolean = rateCon > rateTar;
            var s : Number = (isFitToWidth) ? containerWidth / targetWidth : containerHeight / targetHeight;
            
            var ax:Number = (isFitToWidth) ? 0 : (containerWidth - targetWidth * s) * .5;
            var ay:Number = (isFitToWidth) ? (containerHeight - targetHeight * s) * .5 : 0;
            return new Matrix(s, 0, 0, s, ax, ay);
        }
		/**
		 * 保存图片到本地
		 * @param	bmpd
		 * @param	fileName
		 * @param	fileType
		 */
		public static function saveImage(bmpd:BitmapData, fileName:String = "image", fileType:String = "jpg"):void
		{
			var fr:FileReference = new FileReference();
			switch(fileType) {
				case "png":
					fr.save(PNGEncoder.encode(bmpd), fileName+".png");
					break;
				case "gif":
					var gif:GIFEncoder = new GIFEncoder();    
					gif.setRepeat(0);                   //AUTO LOOP
					gif.setDelay(500);
					gif.start();                        //MUST HAVE!
					gif.addFrame(bmpd);
					gif.finish();
					fr.save(gif.stream, fileName+".gif");
					break;
				case "jpg":
				default:
					var jpg:JPEGEncoder = new JPEGEncoder(80);
					fr.save(jpg.encode(bmpd), fileName+".jpg");
					break;
			}
		}
		/**
		 * 创建可视对象的图片流，可创建mc的Gif序列
		 * @param	mc
		 * @param	fileType
		 * @param	gifFPS 只对gif格式有效，设定gif的播放速度
		 * @param	gifInterval 只对gif格式有效，设定mc每隔多少帧产生一张gif
		 * @return
		 */
		public static function getDisplayObjectBytes(mc:DisplayObject, fileType:String = "jpg",gifFPS:int=50,gifInterval:int=1):ByteArray
		{
			var bmpd:BitmapData = new BitmapData(mc.width, mc.height, true, 0x00000000);
			bmpd.draw(mc);
			var bytes:ByteArray;
			switch(fileType) {
				case "png":
					bytes=PNGEncoder.encode(bmpd);
					break;
				case "gif":
					var gif:GIFEncoder = new GIFEncoder();    
					gif.setRepeat(0);                   //AUTO LOOP
					gif.setDelay(gifFPS);

					gif.start();                        //MUST HAVE!
					if (mc is MovieClip) {
						var _mc:MovieClip = mc as MovieClip;
						var cf:int = _mc.currentFrame;
						   for (var i:int = 1; i <= _mc.totalFrames; i+=gifInterval) {
								_mc.gotoAndStop(i);
								var b:BitmapData=new BitmapData(_mc.width,_mc.height,true, 0x00000000);
								b.draw(_mc);
								gif.addFrame(b);
						   }
						   _mc.gotoAndPlay(cf);
					}else {
						gif.addFrame(bmpd);
					}
					gif.finish();
					bytes = gif.stream;
					break;
				case "jpg":
				default:
					var jpg:JPEGEncoder = new JPEGEncoder(80);
					bytes=jpg.encode(bmpd);
					break;
			}
			return bytes;
		}
        /**
         * 根据alpha图片取出图像
         * @param target	目标图像
         * @param pattern	外形图像，alpha区域为knockout的区域
         * @param point		knockout的起始位置
         */
        public static function knockout(target : BitmapData, pattern : BitmapData, destPoint : Point) : void
        {
            var pw : Number = pattern.width;
            var ph : Number = pattern.height;
            var x : int ;
            var y : int ;
            var col : int = 0;
            var row : int = 0;
            var val : uint;
            
            var aChannel : BitmapData = new BitmapData(pw, ph, true, 0);
            aChannel.copyChannel(pattern, pattern.rect, new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
            
            while(row < ph)
            {
                y = row + destPoint.y;
                while(col < pw)
                {
                    x = col + destPoint.x;
                    val = aChannel.getPixel32(col, row);
                    //反转
                    val = ~val;
                    val = uint(val & target.getPixel32(x, y));
                    target.setPixel32(x, y, val);
                    col++;
                }
                col = 0;
                row++;
            }
        }
		//裁剪透明区域
        public static function trimTransparent(bitmapData : BitmapData) : BitmapData
        {
        	try
        	{
                var r : Rectangle = bitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);
                var b : BitmapData = new BitmapData(r.width, r.height, true, 0);
                b.copyPixels(bitmapData, r, new Point());
        	}
        	catch(e:Error)
            {
                return bitmapData;
        	}
            return b;
        }
	}
}