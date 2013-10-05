package victor
{
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;

	public class ExternalManager
	{
		public function ExternalManager()
		{
		}
		
		/**
		 * 提交第一张编辑好的图片到服务器保存
		 * @param bitmapDataByte 图片二进制数据
		 * @param year 年份
		 */
		public static function confirmFirstCommit( bitmapDataByte:ByteArray, year:int ):void
		{
			if ( ExternalInterface.available )
			{
				Global.commitFirstPicUrl = ExternalInterface.call( "confirmFirstCommit", year, bitmapDataByte );
			}
		}
		
		/**
		 * 提交第一张编辑好的图片到服务器保存
		 * @param bitmapDataByte 图片二进制数据
		 * @param year 年份
		 */
		public static function confirmSecondCommit( bitmapDataByte:ByteArray, year:int ):void
		{
			if ( ExternalInterface.available )
			{
				Global.commitSecondPicUrl = ExternalInterface.call( "confirmSecondCommit", year, bitmapDataByte );
			}
		}
		
	}
}