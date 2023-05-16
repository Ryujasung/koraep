;(function($, window, undefined){

	'use strict';


	if('undefined' === typeof window.NrvPub){
		var NrvPub = window.NrvPub = {};
	}


	$(document).ready(function(){
		NrvPub.Util.LoadMotion();
	});


	NrvPub.AjaxPopup = function(url, options){
		var defaults = {
			background : true,
			openCall : function(){},
			closeCall : function(){}
		}

		var obj = {};
		var sbj = {};
		var opt = $.extend({}, defaults, options);

		$(document).off('click').on('click', '.layer-back', function(){
			opt.closeCall();
			$('.layer-wrap:last-child').remove();
			$('.layer-back:last-child').remove();
		});

		$.ajax({
			url : url,
			timeout : 10000,
			dataType : 'html',
			success : function(data){
				sbj.wW = $(window).outerWidth();
				sbj.wH = $(window).outerHeight();
				sbj.sT = $(window).scrollTop();

				obj.body = $('body');

				if(opt.background){
					obj.back = obj.body.append('<div class="layer-back" />').children('.layer-back:last-child');
				}

				obj.wrap = obj.body.append('<div class="layer-wrap" />').children('.layer-wrap:last-child');

				obj.wrap.append($(data));
				obj.close = obj.wrap.find('[layer="close"]');
				sbj.cW = obj.wrap.outerWidth();
				sbj.cH = obj.wrap.outerHeight();
				sbj.cT = sbj.cH > sbj.wH ? sbj.sT + sbj.wH * 0.1 : sbj.sT + (sbj.wH - sbj.cH) / 2;
				sbj.cL = (sbj.wW - sbj.cW) / 2;

				obj.wrap.css({
					'top' : sbj.cT,
					'left' : sbj.cL,
					'padding-bottom' : sbj.wH * 0.1
				});
				
				opt.openCall();

				obj.wrap.addClass('open');

				obj.close.on('click', function(){
					opt.closeCall();
					obj.wrap.remove();
					$('.layer-back:last-child').remove();
				});

				$(window).on('resize', function(){
					sbj.wW = $(window).outerWidth();
					sbj.cL = (sbj.wW - sbj.cW) / 2;
					obj.wrap.css({'left' : sbj.cL});
				});
			},
			error: function(xhr){
				alert('['+xhr.status+'] 서버전송오류가 발생했습니다.');
			}
		});
	};


	NrvPub.Util = {
		GoogleMapApi : function(lat, lng, name, target){
			// API 호출 : <script src="http://maps.google.com/maps/api/js?key=키값넣는곳&sensor=false"></script>
			var myOptions = {
				  center : new google.maps.LatLng(lat, lng),
				  mapTypeControl : false,
				  zoom : 17,
				  mapTypeId : google.maps.MapTypeId.ROADMAP
			};

			var map = new google.maps.Map(document.getElementById(target), myOptions);
			var myLatlng = new google.maps.LatLng(lat, lng);
			var marker = new google.maps.Marker({
				position : myLatlng,
				map : map,
				title : name
			});
		},

		MatchMedia : function(function1, function2, resize){
			var media = window.matchMedia('(max-width: 768px)');
			var ready = false;

			function matchesAction(paramse){
				if(!paramse.matches){
					if(!ready && resize){return;}
					function1();
				}else{
					if(!ready && resize){return;}
					function2();
				}
			}

			if(matchMedia){
				matchesAction(media);
				media.addListener(function(parameter){
					matchesAction(parameter);
				});
				ready = true;
			}


			/* 
			//실행문
			NrvPub.Util.MatchMedia(
				function(){
					console.log('pc');
				},	
				function(){
					console.log('mobile');
				}
			);

			NrvPub.Util.MatchMedia(
				function(){
					window.location.reload(true);
				},	
				function(){
					window.location.reload(true);
				}
			, true);
			
			*/
		},

		/*CheckDevice : (function(){
			var md = new MobileDetect(window.navigator.userAgent);
			var viewport = document.querySelector('meta[name=viewport]');

			if(md.tablet()){
				viewport.setAttribute('content', 'width=1200, user-scalable=yes');
			}else if(md.mobile()){
				viewport.setAttribute('content', 'width=750, user-scalable=yes');
			}else{
				viewport.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=yes');
			}
		})(),*/

		LoadMotion : function(){
			var $motion = $('.n-motion');
			var windowT;
			if($motion.length){
				$motion.each(function(){
					var $this = $(this);
					var thisF = false;
					var thisT = $(this).offset().top;
					var thisH = $(this).height() / 2;
					var thisP = thisT + thisH;

					$(window).on('load scroll', function(){
						if(!thisF){
							windowT = $(window).scrollTop() + $(window).height();
							if(windowT > thisP){
								$this.addClass('n-active');
								thisF = true;
							}
						}
					});
				});
			}
		},

		TabAction : function(tab, con){
			var $tab = $(tab).children(),
				$con = $(con).children();

			$tab.on('click', function(){
				$(this).addClass('on').siblings().removeClass('on');
				$con.eq($(this).index()).addClass('on').siblings().removeClass('on');
			});
		}
	}


	$.fn.YJtarget = function(options){
		/*$(target).YJtarget({
			target : false,
			action : function(target){}
		});*/

		if(!this.length) return this;

		if(this.length > 1){
			this.each(function(){
				$(this).YJtarget(options);
			});
			return this;
		}

		var defaults = {
			target : false,
			action : function(){}
		}

		var opt = $.extend({}, defaults, options);
		var p = this[0];
		var t;

		$(document).on('click', function(e){
			t = e.target;

			if(t === p && opt.target){
				opt.action(p);
				return;
			}else{
				while(t !== p){
					if(t === this){
						break;
					}else{
						t = t.parentNode;
					}
				}
				if(t === p){
					if(opt.target){
						opt.action(p);
					}
				}else{
					if(!opt.target){
						opt.action(p);
					}
				}
				return;
			}
		});
	}

})(jQuery, window);