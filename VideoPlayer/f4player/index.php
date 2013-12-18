<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>f4Player :: beta</title>
</head>
<body>
    <div id="player">
		<object width="620" height="360" id="f4Player" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"> 
		<param name="movie" value="player.swf?<?=rand(1111,9999)?>" /> 
		<param name="quality" value="high" /> 
		<param name="menu" value="false" /> 
		<param name="allowFullScreen" value="true" /> 
		<param name="scale" value="noscale" /> 
		<param name="allowScriptAccess" value="always" />
		<param name="swLiveConnect" value="true" />
		<param name="flashVars" value="skin=skins/mySkin.swf?<?=rand(1111,9999)?>
			&thumbnail=videos/video-thumbnail.jpg
			&video=videos/andrea.mp4
			"/>
		<!-- [if !IE] -->
		<object width="620" height="360" data="player.swf?<?=rand(1111,9999)?>" type="application/x-shockwave-flash" id="f4Player">
		<param name="quality" value="high" /> 
		<param name="menu" value="false" /> 
		<param name="allowFullScreen" value="true" /> 
		<param name="scale" value="noscale" />
		<param name="allowScriptAccess" value="always" />
		<param name="swLiveConnect" value="true" />
		<param name="flashVars" value="skin=skins/mySkin.swf?<?=rand(1111,9999)?>
			&thumbnail=videos/video-thumbnail.jpg
			&video=videos/andrea.mp4
			"/>
		</object> 
		<!-- [endif] --> 
		</object>
	</div>
	<a href="index.html">home</a> | 
	<a href="autoplay.html">autoplay</a> | 
	<a href="dimensions.html">dimensions</a>
</body>
</html>
