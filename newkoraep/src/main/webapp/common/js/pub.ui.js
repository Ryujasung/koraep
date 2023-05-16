;(function($, window, undefined){

	'use strict';


	$(document).ready(function(){
		//
	});


	NrvPub.UI = {
		HeaderFixedScrollX : function(){
			var $header = $('#header');
			var x, y, supportPageOffset = window.pageXOffset !== undefined;

			$(window).on('load scroll', function(){
				x = supportPageOffset ? window.pageXOffset : isCSS1Compat ? document.documentElement.scrollLeft : document.body.scrollLeft;
				y = supportPageOffset ? window.pageYOffset : isCSS1Compat ? document.documentElement.scrollTOp : document.body.scrollTop;

				$header.css({'left':-x});
			});
		},

		GnbAction : function(){
			var $header = $('#header');
			var $gnb	= $('#gnb > ul');
			var $depth1 = $('#gnb > ul > li');

			$depth1.on('mouseover focusin', function(){
				$header.addClass('gnbOpen');
				$(this).addClass('on').siblings().removeClass('on');
			});

			$gnb.on('mouseleave focusout', function(){
				$header.removeClass('gnbOpen');
				$depth1.removeClass('on');
			});
		}
	}


	NrvPub.Slider = {
		MainVisual : function(){
			var $slider = $('#mainvisual .slick-wrap');

			$slider.slick({
				arrows : true,
				dots : true,
				infinite : true,
				slidesToShow : 1,
				slidesToScroll : 1
			});
		}
	}

})(jQuery, window);