package com.cg.utils
{
	public class exDate
	{
		static public const minSec:int=60;
		static public const hourSec:int=3600;
		static public const daySec:int=86400;
		//一个月按30天算
		static public const monthSec:int=2592000;
		//一年按365天算
		static public const yearSec:int=31536000;
		
		
		//将xxx秒转化格式 autoSize：年补齐4位数，其它补齐两位数
		//不支持月份格式(因为每个月不等，会比较模糊)
		//适用于倒计时，等待时间查询等
		//sample:
		//trace(exDate.secToFmtString(10000*31536000 + 5*86400 + 10*3600 + 12*60 + 19 ,false,"y年d天h小时m分s秒"))
		static public function secToFmtString(sec:Number,autoSize:Boolean=true,fmt:String="y:d h:m:s",minNumber:Number=-1.79769313486231e+308,maxNumber:Number=1.79769313486231e+308):String
		{
			if(sec<minNumber){
				sec=minNumber;
			}else if(sec>maxNumber){
				sec=maxNumber;
			}
			
			var y:int
			var d:int
			var h:int
			var m:int
			var s:int;
			var	ys:String;
			var	ds:String;
			var	hs:String;
			var	ms:String;
			var	ss:String;
			if(fmt.indexOf("y")!=-1){
				y=Math.floor(sec/yearSec)
				sec-=y*yearSec
			}
			if(fmt.indexOf("d")!=-1){
				d=Math.floor(sec/daySec)
				sec-=d*daySec
			}
			if(fmt.indexOf("h")!=-1){
				h=Math.floor(sec/hourSec)
				sec-=h*hourSec
			}
			if(fmt.indexOf("m")!=-1){
				m=Math.floor(sec/minSec)
				sec-=m*minSec
			}
			if(fmt.indexOf("s")!=-1){
				s=Math.floor(sec);
			}
			if(autoSize){
				ys=autoSpace(y,4)
				ds=autoSpace(d,2)
				hs=autoSpace(h,2)
				ms=autoSpace(m,2)
				ss=autoSpace(s,2)
			}else{
				ys=String(y);
				ds=String(d);
				hs=String(h);
				ms=String(m);
				ss=String(s);
			}
			fmt=exString.replace(fmt,"y",ys);
			fmt=exString.replace(fmt,"d",ds);
			fmt=exString.replace(fmt,"h",hs);
			fmt=exString.replace(fmt,"m",ms);
			fmt=exString.replace(fmt,"s",ss);
			
			//trace(fmt+"\t\t"+ys,ds,hs,ms,ss)
			return fmt
		}
		
		
		//将字符串转化为秒，fmt为每个数字代表的含义，如1年2天35小时10分2秒 fmt为"YDhms"
		//如果ftm中包含"M",以30天计算，M会导致结果不准确
		//sample:
		//trace("秒数1:"+(200*31536000 + 5*86400 + 10*3600 + 12*60 + 19 ))
		//trace("秒数2:"+exDate.stringToSec("200年05天10小时0012分19秒","YDhms"))
		static public function stringToSec(str:String,fmt:String="YDhms"):Number
		{
			var arr:Array=stringToNumArray(str)
			if(arr.length!=fmt.length){
				throw(new Error("无效的格式定义，无法转化"));
				return 0;
			}
			var sec:Number=0;
			for(var i:int=0;i<arr.length;i++){
				sec+=arr[i]*str2Sec(fmt.substr(i,1))
			}
			return sec;
		}
		
		//将日期转化格式 autoSize：年补齐4位数，其它补齐两位数
		static public function dateToFmtString(date:Date,autoSize:Boolean=true,fmt:String="Y-M-D h:m:s"):String
		{
			var Y:int=date.getFullYear();
			var M:int=date.getMonth()+1;
			var D:int=date.getDate()
			var h:int=date.getHours();
			var m:int=date.getMinutes();
			var s:int=date.getSeconds();
			var	Ys:String;
			var Ms:String;
			var	Ds:String;
			var	hs:String;
			var	ms:String;
			var	ss:String;
			if(autoSize){
				Ys=autoSpace(Y,4);
				Ms=autoSpace(M,2);
				Ds=autoSpace(D,2);
				hs=autoSpace(h,2);
				ms=autoSpace(m,2);
				ss=autoSpace(s,2);
			}else{
				Ys=String(Y);
				Ms=String(M);
				Ds=String(D);
				hs=String(h);
				ms=String(m);
				ss=String(s);
			}
			fmt=exString.replace(fmt,"Y",Ys);
			fmt=exString.replace(fmt,"M",Ms);
			fmt=exString.replace(fmt,"D",Ds);
			fmt=exString.replace(fmt,"h",hs);
			fmt=exString.replace(fmt,"m",ms);
			fmt=exString.replace(fmt,"s",ss);
			//trace(fmt+"\t\t"+Ys,Ms,Ds,hs,ms,ss)
			return fmt
		}
		
		//将字符串转化为日期，fmt为每个数字代表的含义，如"08时40分07秒 2009年2月8日" fmt为"hmsYMD"
		//sample:
		//var date:Date=exDate.stringToDate(" 04 hours  23分1 sec 2-1   2010 ","hmsMDY")
		//trace(exDate.toChineseDate(date))
		static public function stringToDate(str:String,fmt:String="YMDhms"):Date
		{
			var arr:Array=stringToNumArray(str)
			trace(arr)
			if(arr.length!=fmt.length){
				throw(new Error("无效的格式定义，无法转化"));
				return 0;
			}
			var arr2:Array=[0,0,0,0,0,0];
			for(var i=0;i<fmt.length;i++){
				var char:String=fmt.substr(i,1);
				switch (char){
					case "Y":
						arr2[0]=arr[i];
						break;
					case "M":
						arr2[1]=arr[i]-1;
						break;
					case "D":
						arr2[2]=arr[i];
						break;
					case "h":
						arr2[3]=arr[i];
						break;
					case "m":
						arr2[4]=arr[i];
						break;
					case "s":
						arr2[5]=arr[i];
						break;
				}
			}
			//trace(new Date(arr2[0],arr2[1],arr2[2],arr2[3],arr2[4],arr2[5]));
			return new Date(arr2[0],arr2[1],arr2[2],arr2[3],arr2[4],arr2[5]);;
		}
		
		//将xxx秒转化为"xx分xx秒" 会自动忽略不够部分，例如不够1分钟，则只从秒开始显示
		//当不需要自动忽略时，建议使用secToFmtString，以指定特定格式
		static public function secToMString(n:Number,minNumber:Number=-1.79769313486231e+308,maxNumber:Number=1.79769313486231e+308):String
		{
			if(n<minNumber){
				n=minNumber;
			}else if(n>maxNumber){
				n=maxNumber;
			}
			var str:String=""
			if(n>60){
				str+=String(Math.floor(n/60))+"分"
			}
			str+=String(n%60)+"秒"
			return str
		}
		//将xxx秒转化为"xx小时xx分xx秒" 会自动忽略不够部分，例如不够1小时，则只从分开始显示
		//当不需要自动忽略时，建议使用secToFmtString，以指定特定格式
		static public function secToHString(n:Number,minNumber:Number=-1.79769313486231e+308,maxNumber:Number=1.79769313486231e+308):String
		{
			if(n<minNumber){
				n=minNumber;
			}else if(n>maxNumber){
				n=maxNumber;
			}
			var h:int=Math.floor(n/hourSec);
			var m:int=Math.floor((n-h*hourSec)/minSec);
			var s:int=Math.floor(n%minSec);
			var str:String="";
			if(h>0){
				str=String(h)+"小时"+String(m)+"分"+String(s)+"秒";
			}else if(m>0){
				str=String(m)+"分"+String(s)+"秒";
			}else{
				str=String(s)+"秒";
			}
			return str;
		}
		//将日期妆化为中国年 showDetail:是否显示时分秒
		static public function toChineseDate(d:Date,showDetail:Boolean=true):String
		{
			var fmt:String=showDetail? "Y年M月D日 h时m分s秒" : "Y年M月D日";
			return dateToFmtString(d,false,fmt)
		}
		//获取字符串中的数字数组
		static private function stringToNumArray(str:String):Array
		{
			//去掉空格
			//获取所有数字
			var arr:Array=new Array();
			var i:int;
			for(i=0;i<str.length;i++){
				var char:String=str.substr(i,1)
				var num:Number=Number(char);
				if(isNaN(num) || char==" "){
					continue;	
				}
				arr.push({n:num,id:i})
			}
			if(arr.length==0){
				return [];
			}
			//去掉以0开头的多余数字
			var arr2:Array=new Array();
			arr2.push(String(arr[0].n));
			for(i=1;i<arr.length;i++){
				if(arr[i-1].id+1!=arr[i].id){
					arr2.push(String(arr[i].n))
				}else{
					arr2[arr2.length-1]+=String(arr[i].n)
				}
			}
			for(i=0;i<arr2.length;i++){
				arr2[i]=Number(arr2[i])
			}
			//trace("get number array from str : "+arr2)
			return arr2;
		}
		//自动用0补齐空位
		static private function autoSpace(n:int,space:int=2):String
		{
			var str:String=String(n);
			while(str.length<space){
				str="0"+str;
			}
			return str;
		}
		//将字符转化为秒  YMDhms
		static private function str2Sec(str:String):Number
			{
				switch (str){
					case "Y":
						return  yearSec
					case "M":
						return	monthSec
					case "D":
						return	daySec
					case "h":
						return	hourSec
					case "m":
						return	minSec
					case "s":
						return 1
				}
				return 0
			}
	}
}