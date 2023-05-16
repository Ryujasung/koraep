(function($){
	'use strict';

	if(typeof window.newriver === 'undefined'){
		var newriver = window.newriver = {}
	}

	$.fn.imagesLoaded = function(){
		var $imgs = this.find('img[src!=""]'), dfds = [];

		if (!$imgs.length){
			return $.Deferred().resolve().promise();
		}

		$imgs.each(function(){
			var dfd = $.Deferred(), img = new Image();
			dfds.push(dfd);
			img.onload = function(){dfd.resolve();}
			img.onerror = function(){dfd.resolve();}
			img.src = this.src;
		});

		return $.when.apply($, dfds);
	}

	newriver.init = (function(_){
		(function deviceCheck(md){
			/* check device */
			_.isDevice   = md.mobile();		/* smart device	: newriver.isDevice */
			_.isMobile   = md.phone();		/* mobile		: newriver.isMobile */
			_.isTablet   = md.tablet();		/* tablet		: newriver.isTablet */
			_.isDesktop  = !md.mobile();	/* desktop		: newriver.isDesktop */
		})(new MobileDetect(window.navigator.userAgent));

		(function setViewport(viewport){
			if(_.isDesktop){
				/* set desktop viewport */
				viewport.attr({'content':'width=750, user-scalable=no'});
			}
			if(_.isTablet){
				/* set tablet viewport */
				viewport.attr({'content':'width=750, user-scalable=no'});
			}
			if(_.isMobile){
				/* set mobile viewport */
				viewport.attr({'content':'width=750, user-scalable=no'});
			}
		})($('meta[name=viewport]'));

		var getElements = function(){
			_.$html			=	$('html');
			_.$body			=	$('body');
			_.$wrap			=	$('#wrap');
			_.$header		=	$('#header');
			_.$gnb			=	$('#gnb');
			_.$container	=	$('#container');
			_.$main			=	$('#main');
			_.$contents		=	$('#contents');
			_.$footer		=	$('#footer');
			_.$motion		=	$('.n-motion');
		}

		var getWindowSize = function(){
			_.winsizeW = $(window).outerWidth();
			_.winsizeH = $(window).outerHeight();
		}

		var getWindowScrl = function(){
			_.winscrlT = $(window).scrollTop();
			_.winscrlL = $(window).scrollLeft();
		}

		return {
			onLoad : function(){
				getElements();
				getWindowSize();
				getWindowScrl();

				_.loadmotion.init();
				_.sideAction();
				_.btnAction();
			},
			onResize : function(){
				getWindowSize();
			},
			onScroll : function(){
				getWindowScrl();
			}
		}
	})(newriver);

	newriver.hasOwnProperty = function(org, src){
		for(var prop in src){
			if(!hasOwnProperty.call(src, prop)){
				continue;
			}
			if('object' === $.type(org[prop])){
				org[prop] = ($.isArray(org[prop]) ? src[prop].slice(0) : newriver.hasOwnProperty(org[prop], src[prop]));
			}else{
				org[prop] = src[prop];
			}
		}

		return org;
	}

	newriver.ajaxpopup = (function(_){
		var def = {
			defaults : {
				background : true,
				top : false,
				left : false,
				openCallback : function(data){},
				closeCallback : function(){}
			},
			idx : 0,
			setInit : function(popup, settings){
				popup.opt = $.extend({}, def.defaults, settings);
				popup.$wrap = _.$body.append('<div class="layer-wrap">').children('.layer-wrap:last-child');
				popup.$back = popup.opt.background ? popup.$wrap.append('<div class="layer-back" layer="close">').children('.layer-back') : false;
				popup.resizeEvent = 'resize.ajaxpopup'+def.idx++;
			},
			setPosition : function(popup){
				popup.$wrap.w = popup.$wrap.outerWidth();
				popup.$wrap.h = popup.$wrap.height();
				popup.$wrap.t = popup.$wrap.h > _.winsizeH * 0.8 ? _.winscrlT + _.winsizeH * 0.1 : _.winscrlT + (_.winsizeH - popup.$wrap.h) / 2;
				popup.$wrap.l = (_.winsizeW - popup.$wrap.w) / 2;
				popup.$wrap.css({
					'top' : popup.opt.top ? popup.opt.top : popup.$wrap.t,
					'left' : popup.opt.left ? popup.opt.left : popup.$wrap.l,
					'padding-bottom' : _.winsizeH * 0.1
				});

				return popup.$wrap;
			},
			setClose : function(popup){
				popup.$close = popup.$wrap.find('[layer="close"]');
				popup.$close.on('click', function(){
					popup.opt.closeCallback();
					popup.close();
				});
			},
			popupClose : function(popup){
				popup.$wrap.remove();
				$(window).off(popup.resizeEvent);
			}
		}

		return {
			open : function(url, settings){
				var init = function(){
					var popup = this;

					def.setInit(popup, settings);

					$.ajax({
						url : url,
						timeout : 10000,
						dataType : 'html',
						success : function(data){
							popup.$wrap.append(data).imagesLoaded().then(function(){
								popup.opt.openCallback(popup.$wrap);
								def.setPosition(popup).addClass('open');
								def.setClose(popup);
								$(window).on(popup.resizeEvent, function(){
									def.setPosition(popup);
								});
							});
						},
						error : function(xhr){
							alert('['+xhr.status+'] 서버전송오류가 발생했습니다.');
						}
					});

					return popup;
				}

				init.prototype.close = function(){
					var popup = this;

					def.popupClose(popup);
				}

				init.prototype.reinit = function(){
					var popup = this;

					def.setPosition(popup);
				}

				return new init();
			}
		}
	})(newriver);

	newriver.mainpopup = (function(_){
		var def = {
			defaults : {
				id : null,
				node : null,
				top : false,
				left : false,
				width : false,
				height : false
			}
		}

		return {
			open : function(settings){
				var init = function(){
					var popup = this;

					popup.opt = $.extend({}, def.defaults, settings);

					if($.cookie(popup.opt.id)){
						return false;
					}

					newriver.ajaxpopup.open('../@popup/main.html', {
						top : popup.opt.top,
						left : popup.opt.left,
						background : false,
						openCallback : function(target){
							var id = '#'+popup.opt.id;
							popup.$mainpopup = target.children('.main_popup');
							popup.$mainpopup.attr({'id' : popup.opt.id});

							if(popup.opt.width && popup.opt.height){
								popup.$mainpopup.addClass('sizeFixed');
							}
							new Vue({
								el : id,
								data : {
									width : popup.opt.height ? popup.opt.width : 'auto',
									height : popup.opt.width ? popup.opt.height : 'auto',
									node : popup.opt.node,
									name : popup.opt.id
								},
								computed : {
									style : function(){
										return 'width:'+this.width+'px; height:'+this.height+'px;'
									}
								}
							});
						},
						closeCallback : function(){
							if($('[name='+popup.opt.id+']').prop('checked')){
								$.cookie(popup.opt.id, true, {expires : 1, path : '/'});
							}
						}
					});

					return popup;
				}

				return new init();
			}
		}
	})(newriver);

	newriver.slider = (function(_){
		return {
			mainVisual : function(){
				this.$mainVisual = $('#main .main_visual .slick-wrap').slick({
					fade : true,
					arrows : true,
					dots : false,
					infinite : true,
					slidesToShow : 1,
					slidesToScroll : 1,
					accessibility : false
				});
			},
			tableVisual : function(){
				this.$tableVisual = $('#tableView .slick-wrap').slick({
					arrows : true,
					dots : true,
					infinite : true,
					slidesToShow : 1,
					slidesToScroll : 1,
					accessibility : false
				});
			},
			imgPreview : function(){
				this.$imgPreview = $('.imgPreview .slick-wrap').slick({
					arrows : false,
					dots : false,
					infinite : false,
					slidesToShow : 5,
					slidesToScroll : 4,
					accessibility : false
				});
			}
		}
	})(newriver);

	newriver.sliderHeight = function(){
		$('#tableView .slick-wrap').on('afterChange', function(event, slick, currentSlide, nextSlide){
			var $currSlide = $(slick.$slides[currentSlide]).find('.tbl_slide');
			var $slicktrack = $('#tableView .slick-track');

			$slicktrack.css('height', $currSlide.height());
		});
	}

	newriver.loadmotion = (function(_){
		return {
			init : function(){
				var f = this;
				_.$motion.each(function(idx, obj){
					obj.t = $(obj).offset().top;
					obj.h = $(obj).outerHeight() / 2;
					obj.p = obj.t + obj.h;
					obj.e = 'load.lmotion'+idx+' scroll.lmotion'+idx;

					$(window).on(obj.e, function(){
						f.scroll(obj);
					});
				});
			},
			scroll : function(obj){
				if(_.winscrlT + _.winsizeH > obj.p){
					$(obj).addClass('n-active');
					$(window).off(obj.e);
				}
			}
		}
	})(newriver);

	newriver.matchmedia = function(settings){
		var	defaults = {
			matchDesktop : function(){},
			matchMobile : function(){}
		};
		var opt = $.extend({}, defaults, settings);
		var media = window.matchMedia('(max-width: 750px)');

		function matchesAction(paramse){
			if(!paramse.matches){
				/* Desktop 실행 */
				opt.matchDesktop();
			}else{
				/* Mobile 실행 */
				opt.matchMobile();
			}
		}

		if(matchMedia){
			matchesAction(media);
			media.addListener(function(parameter){
				matchesAction(parameter);
			});
		}
	}

	newriver.tabAction = function(navi, cont){
		var _ = newriver;

		function action(tab, idx){
			tab.def.$navi.eq(idx).addClass('on').siblings().removeClass('on');
			tab.def.$cont.eq(idx).addClass('on').siblings().removeClass('on');
			tab.def.offsetTop = tab.def.$navi.offset().top;

			tab.def.idx = idx;
		}

		var tabAction = (function(){
			return {
				def : {
					idx : 0,
					$navi : $(navi).children(),
					$cont : $(cont).children()
				},
				init : function(){
					var _this = this;

					_this.def.$navi.on('click', function(){
						action(_this, $(this).index());
					});

					return _this;
				},
				setIndex : function(idx){
					action(this, idx);
					$('html, body').animate({scrollTop : this.def.offsetTop-_.$header.outerHeight()}, 300);
				}
			};
		})();

		return tabAction.init();
	}

	newriver.sideAction = function(){
		var _ = newriver;

		var $gnbDepth =	$('#gnb > ul > li > a');
		var $trgAside =	$('#btn_aside_open');
		var $aside = $('#aside');

		function close () {
			_.$html.removeClass('asideOpen');
			$(window).off('click.sidemenu touchstart.sidemenu');
		}

		$trgAside.on('click', function(e){
			e.stopPropagation();
			_.$html.toggleClass('asideOpen');
			$(window).on('click.sidemenu touchstart.sidemenu', function(e){
				if(!$(e.target).closest($aside).length && !$(e.target).closest('#header').length) {
					close();
				}
			});
		});

		$gnbDepth.on('click', function(e){
			e.preventDefault();
			e.stopPropagation();

			$(this).parent().toggleClass('on').siblings('li').removeClass('on');
		});
	}

	newriver.btnAction = function(){	
		$('.chooseBtn button').on('click', function(){
			if ($(this).parent().hasClass('tc')){
				$(this).parent().addClass('on').siblings().removeClass('on');
			} else {
				$(this).addClass('on').siblings().removeClass('on');
			}
		});
	}

	newriver.manageAction = function(){	
		$('.btn_manage button').on('click', function(){
			$(this).toggleClass('on');
			$('.manage_wrap').toggleClass('on').slideToggle();
		});
	}

	$(window).on({
		'load' : function(){
			//newriver.init.onLoad();
		},
		'resize' : function(){
			newriver.init.onResize();
		},
		'scroll' : function(){
			newriver.init.onScroll();
		}
	});
})(jQuery);