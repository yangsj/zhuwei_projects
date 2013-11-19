var pop = {
	sw : ($(document).width()>$(window).width())?$(document).width():$(window).width(),
	sh : ($(document).height()>$(window).height())?$(document).height():$(window).height(),
	showpop : function(o){
		pop.showopobg(o);
		$(o).css({
			'left' : (pop.sw - $(o).width())/2,
			'top'  : (pop.sh - $(o).height())/2
		}).show();
	},
	hidepop : function(o){
		pop.hideopobg(o);
		$(o).hide();
	},
	showopobg : function(o){
		if($('.pop-bg').length){
			$('.pop-bg').css({
				'width' : pop.sw,
				'height': pop.sh
			}).show();
		}else{
			$('<div/>').addClass('pop-bg').css({
				'width' : pop.sw,
				'height': pop.sh
			}).insertBefore($(o));
		}
	},
	hideopobg : function(){
		$('.pop-bg').hide();
	},
	resize : function(o){
		$('.pop-bg').css({
			'width' : pop.sw,
			'height': pop.sh
		});
		$(o).css({
			'left' : (pop.sw - $(o).width())/2,
			'top'  : (pop.sh - $(o).height())/2
		});
	}
}