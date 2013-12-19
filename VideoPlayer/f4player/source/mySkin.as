/*
╠═ f4.Skin ══════════════════════════════════════════════════════════════
  Software: f4.Skin - flash video player skin class
   Version: beta 1.0
   Support: http://f4player.org
    Author: goker.cebeci
   Contact: http://f4player.org
 -------------------------------------------------------------------------
   License: Distributed under the Lesser General Public License (LGPL)
            http://www.gnu.org/copyleft/lesser.html
 This program is distributed in the hope that it will be useful - WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.
═══════════════════════════════════════════════════════════════════════════ */
package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.external.ExternalInterface;
	
	import f4.PlayerInterface;

	public class mySkin extends MovieClip {
		var player:PlayerInterface;
		var info:Object;
		var fullscreen:Boolean=true;
		var progress:Boolean=false;
		var playing:Boolean=false;
		var proportion:Number=0;//
		var rectangle:Rectangle; // for seeker
		var padding:int=10;
		var barwidth:Number;

		var video:String;

		var seeking:Boolean=false;
		
		
		public var soundBar:MovieClip;
		public var soundBg:MovieClip;
		public var top:MovieClip;
		public var bottom:MovieClip;
		public var controlBg:MovieClip;

		public function mySkin() {
			trace("mySkin loaded!");
		}
		public function initialization(W:Number,H:Number,player:PlayerInterface,video:String,thumbnail:String,autoplay:Boolean=false,fullscreen:Boolean=true):void {
			//this.fullscreen = fullscreen;
			this.player = player;
			//var togglepause:Boolean = false;
			var callback:Function = function(i:Object){
				info = i;
				
				nav.progressBar.width = (info.progress * barwidth);
				nav.playingBar.width = (info.playing * barwidth);
				nav.seeker.x = nav.playingBar.x + (info.playing * barwidth);
				nav.barPoint.x = nav.seeker.x;
				nav.seeker.currentTime.text = formatTime(info.time);
				proportion = info.height / info.width;
				
				/*if(info.status == 'NetStream.Play.Start'){
					proportion = info.height / info.width;
					screen.width = overlay.width = W;
					screen.height = overlay.height = W * proportion;
					player.Log('size: '+info.height.toString()+' '+info.width.toString());
				}*/
				buffering.visible = false;
				if(info.status == 'NetStream.Buffer.Flush'){
				
				}
				if(info.status == 'NetStream.Play.Stop' || info.status == 'NetStream.Buffer.Empty' ){
				var clicker:Function = stopEvent;
				clicker(new MouseEvent(MouseEvent.CLICK));
				}
			};
			player.Callback(callback);
			
			var movie:Video=player.Movie(W,H);
			screen.addChildAt(movie,1);
			//thumbnail [
			if(thumbnail){
				var image:MovieClip = player.Thumbnail(thumbnail,W,H);
				screen.addChildAt(image,1);
			}
			// ] thumbnail
			
			nav.pauseButton.visible = false;
			nav.seeker.visible = false;
			pose(W,H);

			//═ PLAY ══════════════════════════════════════════════════════════════════════
			var playEvent:Function = function(e:Event):void {
				if(playing){
					player.Pause();
				} else {
					playing = player.Play(video);
					overButton.visible = false;
					nav.seeker.visible = true;
				}
				nav.playButton.visible = false;
				nav.pauseButton.visible = true;
			};
			overButton.addEventListener(MouseEvent.CLICK, playEvent);
			nav.playButton.addEventListener(MouseEvent.CLICK, playEvent);
			//═ PAUSE ══════════════════════════════════════════════════════════════════════
			var pauseEvent:Function = function(e:Event):void {
				var isPause:Boolean = player.Pause();
				nav.playButton.visible = isPause;
				nav.pauseButton.visible = !isPause;
			};
			overlay.addEventListener(MouseEvent.CLICK, pauseEvent);
			nav.pauseButton.addEventListener(MouseEvent.CLICK, pauseEvent);
			//═ STOP ══════════════════════════════════════════════════════════════════════
			var stopEvent:Function = function(e:Event):void {
				player.Stop();
				playing = false;
				overButton.visible = true;
				nav.playButton.visible = true;
				nav.pauseButton.visible = false;
				if ( ExternalInterface.available ) { 
					ExternalInterface.call( "onendjs" );
				}
			};
			//═ HIDE CONTROLS ═════════════════════════════════════════════════════════════
			var controlDisplayEvent:Function = function(e:Event):void {
				nav.visible = e.type == 'mouseOver';
			};
			overlay.addEventListener(MouseEvent.MOUSE_OVER, controlDisplayEvent);
			overlay.addEventListener(MouseEvent.MOUSE_OUT, controlDisplayEvent);
			nav.addEventListener(MouseEvent.MOUSE_OVER, controlDisplayEvent);
			//nav.addEventListener(MouseEvent.MOUSE_OUT, controlDisplayEvent);
			//═ SEEK ══════════════════════════════════════════════════════════════════════
			var playingBarEvent:Function = function(e:MouseEvent):void {
				var point:Number = e.localX * info.playing;
				var seekpoint:Number = (point / 100) * info.duration;
				player.Seek(seekpoint);
				};
				nav.playingBar.buttonMode=true;
				nav.playingBar.addEventListener(MouseEvent.CLICK, playingBarEvent);
				var progressBarEvent:Function = function(e:MouseEvent):void {
				var point:Number = e.localX * info.progress;
				var seekpoint:Number = (point / 100) * info.duration;
				player.Log(point.toString());
				player.Log(info.progress.toString());
				player.Log(barwidth.toString());
				player.Seek(seekpoint);
			};
			nav.progressBar.buttonMode=true;
			nav.progressBar.addEventListener(MouseEvent.CLICK, progressBarEvent);
			var stageMouseMoveEvent:Function = function(event:MouseEvent):void { // for seeker position
				if(info.duration > 0 && seeking) {
				var point:int = (((nav.seeker.x - nav.progressBar.x) / barwidth) * info.duration) >> 0;
				if(point <= 0 || point >= (info.duration >> 0)) nav.seeker.stopDrag();
				nav.seeker.currentTime.text = formatTime(point);
				player.Seek(point);
				player.Log('stageMouseMoveEvent: '+point);
			}
			};
			var stageMouseUpEvent:Function = function(event:MouseEvent):void { // for stop seeking
				if(seeking){
					seeking = false;
					nav.seeker.stopDrag();
					player.Pause();
					player.Log('stageMouseUpEvent');
				}
			};
			var seekerEvent:Function = function(event:MouseEvent):void {
				if(!seeking){
					seeking = true;
					nav.seeker.startDrag(false, rectangle);
					player.Pause();
				}
			};
			nav.seeker.buttonMode=true;
			nav.seeker.addEventListener(MouseEvent.MOUSE_DOWN, seekerEvent);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveEvent);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpEvent);
			
			soundBar = nav.volumeBar.bar;
			soundBar.buttonMode = true;
			soundBg = nav.volumeBar.bg;
			soundBg.buttonMode = true;
			
			soundBar.addEventListener(MouseEvent.MOUSE_DOWN, soundHandler );
			soundBg.addEventListener(MouseEvent.MOUSE_DOWN, soundHandler );
			function soundHandler(event:MouseEvent):void
			{
				var curTarget:MovieClip = event.currentTarget as MovieClip;
				if ( curTarget == soundBg ) {
					soundBar.x = event.localX + curTarget.x;
					setVolume( (soundBar.x - 13) / 30 );
//					SoundMixer.soundTransform = new SoundTransform( soundBar.x / 30 );
				} else {
					stage.addEventListener( MouseEvent.MOUSE_UP, soundMouseUpHandler );
					stage.addEventListener( MouseEvent.MOUSE_MOVE, soundMouseUpHandler );
					soundBar.startDrag( false, new Rectangle(13,8.3,30, 0 ));
				}
			}
			
			function soundMouseUpHandler(event:MouseEvent):void
			{
				if ( event.type == MouseEvent.MOUSE_UP ) {
					stage.removeEventListener( MouseEvent.MOUSE_UP, soundMouseUpHandler );
					stage.removeEventListener( MouseEvent.MOUSE_MOVE, soundMouseUpHandler );
					soundBar.stopDrag();
				} else {
					setVolume( (soundBar.x - 13) / 30 );
//					SoundMixer.soundTransform = new SoundTransform( soundBar.x / 30 );
				}
			}

			//═ VOLUME ══════════════════════════════════════════════════════════════════════
			var setVolume:Function = function(newVolume:Number):void{
			player.Volume(newVolume);
//			nav.volumeBar.mute.gotoAndStop((newVolume > 0)?1:2);
//			nav.volumeBar.volumeOne.gotoAndStop((newVolume >= 0.2)?1:2);
//			nav.volumeBar.volumeTwo.gotoAndStop((newVolume >= 0.4)?1:2);
//			nav.volumeBar.volumeThree.gotoAndStop((newVolume >= 0.6)?1:2);
//			nav.volumeBar.volumeFour.gotoAndStop((newVolume >= 0.8)?1:2);
//			nav.volumeBar.volumeFive.gotoAndStop((newVolume == 1)?1:2);
			};
			var volumeEvent:Function = function(e:MouseEvent):void {
			if(e.buttonDown || e.type == 'click')
			switch (e.currentTarget) {
			case nav.volumeBar.mute : setVolume(0);break;
//			case nav.volumeBar.volumeOne :   setVolume(.2);break;
//			case nav.volumeBar.volumeTwo :   setVolume(.4);break;
//			case nav.volumeBar.volumeThree : setVolume(.6);break;
//			case nav.volumeBar.volumeFour :  setVolume(.8);break;
//			case nav.volumeBar.volumeFive :  setVolume(1);break;
			}
			};
			nav.volumeBar.mute.addEventListener(MouseEvent.CLICK, volumeEvent);
			nav.volumeBar.mute.addEventListener(MouseEvent.ROLL_OVER, volumeEvent);
//			nav.volumeBar.volumeOne.addEventListener(MouseEvent.CLICK, volumeEvent);
//			nav.volumeBar.volumeOne.addEventListener(MouseEvent.ROLL_OVER, volumeEvent);
//			nav.volumeBar.volumeTwo.addEventListener(MouseEvent.CLICK, volumeEvent);
//			nav.volumeBar.volumeTwo.addEventListener(MouseEvent.ROLL_OVER, volumeEvent);
//			nav.volumeBar.volumeThree.addEventListener(MouseEvent.CLICK, volumeEvent);
//			nav.volumeBar.volumeThree.addEventListener(MouseEvent.ROLL_OVER, volumeEvent);
//			nav.volumeBar.volumeFour.addEventListener(MouseEvent.CLICK, volumeEvent);
//			nav.volumeBar.volumeFour.addEventListener(MouseEvent.ROLL_OVER, volumeEvent);
//			nav.volumeBar.volumeFive.addEventListener(MouseEvent.CLICK, volumeEvent);
//			nav.volumeBar.volumeFive.addEventListener(MouseEvent.ROLL_OVER, volumeEvent);
		
		
		
			//═ FULLSCREEN ══════════════════════════════════════════════════════════════════════
			var fullscreenEvent:Function = function(e:Event):void {
			player.Fullscreen(stage);
			};
			nav.fullscreen.addEventListener(MouseEvent.CLICK, fullscreenEvent);

			// 自动播放
			overButton.dispatchEvent( new MouseEvent( MouseEvent.CLICK ));
			
			top.visible = false;
			bottom.visible = false;
		}
		//═ POSE ══════════════════════════════════════════════════════════════════════
		public function pose(W:Number,H:Number):void {
			var defination=W/H>1;
			background.x=screen.x=overlay.x=0;
			background.y=screen.y=overlay.y=0;
			background.width = W;
			background.height = H;
			if (proportion) {
				player.Log('proportion: '+proportion)
				if(proportion <= (H / W)){
					screen.width = overlay.width = W;
					screen.height = overlay.height = W * proportion;
				} else {
					screen.width = overlay.width = H / proportion;
					screen.height = overlay.height = H;
				}
				screen.x = overlay.x = (W - screen.width)*.5;
				screen.y = overlay.y = (H - screen.height)*.5;
			} else {
				screen.width = overlay.width = W;
				screen.height = overlay.height = H;
			}
			//screen.alpha = 
			overlay.alpha=0;
			overButton.x = (W - overButton.width)*.5;
			overButton.y = (H - overButton.height)*.5;
			buffering.x = (W - buffering.width)*.5;
			buffering.y = (H - buffering.height)*.5;
			//NAVIGATOR
			nav.playButton.x=nav.pauseButton.x=padding;
			nav.pauseButton.y=nav.playButton.y;
			nav.bar.x=nav.playButton.width+padding*2;
			nav.container.x=nav.bar.x+padding;
			var barPadding = (nav.container.height - nav.playingBar.height)*.5;
			nav.progressBar.x=nav.playingBar.x=nav.container.x+barPadding;
			nav.progressBar.y=nav.playingBar.y=nav.container.y+barPadding;		
			if(!playing)
				nav.seeker.x = nav.container.x + barPadding;
			nav.seeker.y = nav.container.y - barPadding;
			rectangle = new Rectangle(nav.progressBar.x,nav.seeker.y,barwidth,0);			
			//nav.playingBar.width = 0;
			nav.y=H-nav.height-padding*.5;
			nav.bar.width=W-nav.bar.x-padding;
			var endPoint:int=nav.bar.x+nav.bar.width;
			if (fullscreen) {
				endPoint=nav.fullscreen.x=endPoint-nav.fullscreen.width-padding;
			} else {
				nav.fullscreen.visible=false;
			}
			endPoint=nav.volumeBar.x=endPoint-nav.volumeBar.width-padding;
			nav.container.width=endPoint-nav.container.x-padding;
			barwidth=nav.container.width-barPadding*2;
			nav.progressBar.width=nav.playingBar.width=barwidth;
			nav.controlBg.width = W;
			/*if(progress){ // progress bar size
			var newWidth:Number =((progress * barwidth *.01) >> 0);
			nav.progressBar.x = nav.seekBar.x + newWidth;
			nav.progressBar.width = barwidth - newWidth;
			}*/
/*
			var ww:int = 40;
			top.x = 0;
			top.y = 0;
			top.height = ww;
			top.width = W;
			
			bottom.x = 0;
			bottom.y = H - ww;
			bottom.height = ww;
			bottom.width = W;
			*/
		}

		private function formatTime(time:Number):String {
			if (time>0) {
				var integer:String = String((time/60)>>0);
				var decimal:String = String((time%60)>>0);
				return ((integer.length<2)?"0"+integer:integer)+":"+((decimal.length<2)?"0"+decimal:decimal);
			} else {
				return String("00:00");
			}

		}
	}
}