package app
{
	import com.nova.core.*;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	public class Global
	{
		//*///////
		//连接模块
		public static var loaderObj;
		public static var mainLoaderObj;
		public static var BaseURL="http://events.youku.com/rocher";		
		public static var baseURL="http://events.youku.com/rocher";
		public static var videoURL="http://events.youku.com/rocher";
		public static var videoURL1="http://v.youku.com/v_show/id_XMzM5ODgyODEy.html";
/*		public static var BaseURL="http://test.johnniewalker.com.cn/n_test";		
		public static var baseURL="http://test.johnniewalker.com.cn/n_test";
		public static var videoURL="http://test.johnniewalker.com.cn/n_test/";*/
		
		public static var shareTitle="#金色时刻 永不褪色#";
		public static var shareTitle1="讲述你的金色时刻，用@费列罗Rocher 的光芒耀出你的感动，成为金色微电影主角，更收获宝格丽玫瑰金项链大奖！";
										
		//public static var shareTitle="测试";

		public static var shareVideoPic="";
		public static var shareVideoPic1="http://g1.ykimg.com/0100641F464F056284CE3605CA0098D6364721-695C-2436-5604-0DF524F4A53F";
		public static var albumPicArr=[];
		public static var albumHomePic=[];
		public static var defaultPic;
		public static var curMenu;
		public static var _stage;
		public static var linkSwf=["main.swf","story.swf","upload.swf","rules.swf","winner.swf","success.swf","detail.swf","my_detail.swf"];
		public static var libObj;
		public static var album_des;
		//public static var API_URL="";
		//public static var API_URL="http://10.173.3.176";
		public static var linkArr=["6023","6022","",""];
		public static var coverID=0;
		public static var stateID=0;
		public static var album_tips;
		public static var album_pview;
		public static var album_dataLoader;
		public static var album_Login;
		public static var album_FinishObj;
		public static var album_cAlbum1MCRef;
		public static var menuObj;
		public static var album_mydesObj;
		public static var album_inviteObj;
		public static var srhObj=new Object();
		public static var curSwfID=0;
		public static var curObj;
		public static var isFirstLoad:Boolean;
		public static var isMainLoaded:Boolean;
		public static var pvObj;
		public static var curModle="";
		public static var countFinished:Boolean;
		public static var GAType:Boolean;
		public static var mainPicTimer=new Timer(1500);
		public static var curVideoID=1;
		public static var videoArr=new Array();
		public static var API_URL="http://events.youku.com/2011/rocher/api/";
		public static var curVideoURL="";
		public static var curVideoURL2="";
		public static var videoObj;
		public static var videoObj2;
		public static var videoObj3;
		public static var vFormat;
		public static var fontLib;
		public static var autoVideoPlay:Boolean=true;
		public static var curVideoNum=0;
		public static var v3Dlist;
		public static var mainStage;
		public static var nikeName="";
		public static var userMobile="";
		public static var user_id="";
		public static var detailObj=new Object();
		public static var userDesObj=new Object();
		public static var album_id="";
		public static var isSkip:Boolean;		
		public static var momo1Arr=["不断追逐成就时","深情一吻","听到“我爱你”三个字"];
		public static var momo2Arr=["把亲情拉近时","倾情一生","用心守护的一辈子"];
		public static var album_pviewMC;
		public static var video_test;

	}
}