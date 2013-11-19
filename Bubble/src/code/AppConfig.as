package code
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	
	/**
	 * ……
	 * @author 	yangsj 
	 * 			2013-11-17
	 */
	public class AppConfig
	{
		public function AppConfig()
		{
		}
		
		public static var playerPicUrl:String;
		public static var playerName:String = "null";
		
		public static const eventDispatcher:IEventDispatcher = new Sprite();
		
		public static const configXML:XML = <data>
				<item id="0" labName0="澄净" labName1="乐天" />
				<item id="1" labName0="细腻" labName1="温润" />
				<item id="2" labName0="光采" labName1="自信" />
				<item id="3" labName0="健康" labName1="灵动" />
				<item id="4" labName0="匀滑" labName1="简单" />
				<item id="5" labName0="水嫩" labName1="纯真" />
				<item id="6" labName0="透澈" labName1="纯粹" />
				<item id="7" labName0="柔弹" labName1="坚强" />
			</data>;
		
	}
}