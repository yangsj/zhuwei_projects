package code
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	
	/**
	 * ……
	 	光采
		敏锐
		细腻
		执着
		水嫩
		活力
		平滑
		无瑕
		剔透
		强韧
		纯澈
		简单
		柔弹
		灵动
		透亮
		明媚
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
				<item id="0" labName0="光采" labName1="敏锐" />
				<item id="1" labName0="细腻" labName1="执着" />
				<item id="2" labName0="水嫩" labName1="活力" />
				<item id="3" labName0="平滑" labName1="无瑕" />
				<item id="4" labName0="剔透" labName1="强韧" />
				<item id="5" labName0="纯澈" labName1="简单" />
				<item id="6" labName0="柔弹" labName1="灵动" />
				<item id="7" labName0="透亮" labName1="明媚" />
			</data>;
		
	}
}