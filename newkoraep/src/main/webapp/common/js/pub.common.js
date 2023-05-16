;(function($, window, undefined){
	'use strict';


	if('undefined' === typeof window.NrvPub){
		var NrvPub	= window.NrvPub = {
			Init : function(){
				/* 주요 변수 선언 */
				var NrvObj	= window.NrvObj = {
					html		:	$('html'),
					body		:	$('body'),
					wrap		:	$('#wrap'),
					header		:	$('#header'),
					gnb			:	$('#gnb'),
					sub_gnb		:	$('#sub_gnb'),
					containerMain:	$('#containerMain'),
					alarmDiv	:	$('#alarmDiv'),
					alarmDivTop :	$('#alarmDivTop'),
					submenu	:	$('#submenu'),
					container	:	$('#container'),
					main			:	$('#main'),
					contents		:	$('#contents'),
					footer		:	$('#footer'),
					pagenavi	:	$('#pagenavi .inner'),
					navicont		:	$('#navicont'),
					lnb			:	$('#lnb'),
					iframe_wrap	:	$('#iframe_wrap')
				};
			}
		};
		var NrvSbj	= window.NrvSbj = {
			chkdevice : (function(){
				/*
				* NrvSbj.chkdevice.device : 기종
				* NrvSbj.chkdevice.mobile : 모바일
				* NrvSbj.chkdevice.tablet : 태블릿
				* NrvSbj.chkdevice.desktop : 데스크탑
				*/
				var md = new MobileDetect(window.navigator.userAgent);
				return {
					device	: md.mobile(),
					mobile	: md.phone() ? true : false,
					tablet	: md.tablet() ? true : false,
					desktop : !md.mobile() ? true : false
				}
			})(),
			viewport :	$('meta[name=viewport]'),
			ajaxPopupIdx : 0
		};
	}

	/*
	$(document).on({
		'ready' : function(){
			NrvPub.Init();
			NrvPub.UI.GnbAction();
			NrvPub.Util.LoadMotion();
			NrvPub.AjaxPage();
		}
	});
	*/

	$(window).on({
		'load' : function(){
			NrvSbj.wsx = $(window).scrollLeft();
			NrvSbj.wsy = $(window).scrollTop();
			NrvSbj.wow = $(window).outerWidth();
			NrvSbj.woh = $(window).outerHeight();
		},
		'scroll' : function(){
			NrvSbj.wsx = $(window).scrollLeft();
			NrvSbj.wsy = $(window).scrollTop();
		},
		'resize' : function(){
			NrvSbj.wow = $(window).outerWidth();
			NrvSbj.woh = $(window).outerHeight();
		}
	});

	/*
	* Page Load Script
	* Iframe Type
	*/
	NrvPub.IframePage = function(){
		var flag = false;
		var flagIdx = false;
		var naviObj;
		NrvObj.lnb.link = NrvObj.lnb.find('a');
		NrvObj.gnb.link = NrvObj.gnb.find('a');
		NrvObj.sub_gnb.link = NrvObj.sub_gnb.find('a');
		NrvObj.containerMain.link = NrvObj.containerMain.find('a');
		NrvObj.alarmDiv.link = NrvObj.alarmDiv.find('a');
		NrvObj.alarmDivTop.link = NrvObj.alarmDivTop.find('a');
		NrvObj.submenu.link = NrvObj.submenu.find('a');
		
		function makeNaviNode(text, data, id){
			return '<a class="on" pagedata="'+data+'" id="'+id+'"><span class="tit">'+text+'</span><button type="button" class="dlt">페이지 닫기</button></a>';
		}

		function iframeLoad(href, title){
			var iCheck = true;
			NrvObj.iframe_wrap.children('iframe').each(function(i){
				if(href == $(this).attr('pagedata')){
					iCheck = false;
				}
			});

			if(iCheck){ //true
				NrvObj.iframe_wrap.append('<iframe src="" id="iframe" pagedata="'+href+'" scrolling="no" style="" name="'+href+'"></iframe>');
			}
			
			NrvObj.iframe_wrap.children('iframe').each(function(i){
				if(href == $(this).attr('pagedata')){
					$(this).attr('style', '').siblings().attr('style', 'visibility:hidden;display:none');

					if($(this).attr('src') == ''){
						$(this).attr('src', href).on('load', function(){
							$(this).height($(this).contents().outerHeight());
							$(this).contents().find('#title').text(title);
							
							//스크롤 최상단으로
							$(this).parents('body').scrollTop(0);
						});
					}else{
						$(this).height($(this).contents().outerHeight());
					}
				}
			});
			
			//NrvObj.iframe.attr('src', href).on('load', function(){
			//	$(this).height(NrvObj.iframe.contents().outerHeight());
			//	NrvObj.iframe.contents().find('#title').text(title);
			//});
		}

		/*
		NrvObj.lnb.link.on('click', function(e){
			e.preventDefault();
			e.stopPropagation();

			var $this = $(this);
			$this.href = $this.attr('href');
			$this.text = $this.text();
			NrvObj.pagenavi.flag = false;

			function naviAdd(node){
				$this.navi = NrvObj.pagenavi.append(node).children(':last-child');
				$this.navi.siblings().removeClass('on');
			}

			if(NrvObj.pagenavi.children('a').length){
				NrvObj.pagenavi.button = NrvObj.pagenavi.children('a');
				NrvObj.pagenavi.button.each(function(i){
					if($this.href == $(this).attr('pagedata')){
						NrvObj.pagenavi.flag = true;
						if(!$(this).hasClass('on')){
							$(this).addClass('on').siblings().removeClass('on');
							iframeLoad($this.href, $this.text);
						}
					}
				});
				if(!NrvObj.pagenavi.flag){
					naviAdd(makeNaviNode($this.text, $this.href));
					iframeLoad($this.href, $this.text);
				}
			}else{
				naviAdd(makeNaviNode($this.text, $this.href));
				iframeLoad($this.href, $this.text);
			}
		});
		*/
		
		NrvObj.gnb.link.on('click', function(e){
			
			if(NrvObj.iframe_wrap.children('iframe').length >= 10){
				alert('더이상 추가할 수 없습니다.');
				return false;
			}
			
			if($('#containerMain').css('display') == 'block'){
				$('#containerMain').css('display', 'none');
				$('#container').css('display', 'table');
			}
			
			e.preventDefault();
			e.stopPropagation();
	
			var $this = $(this);
			$this.href = $this.attr('href');
			$this.id = $this.attr('id');
			$this.text = $this.attr('pagetitle');
			NrvObj.pagenavi.flag = false;
			
			/***************** KWONSY ADD *************/
			var hrefTxt = $this.id.toUpperCase();
			if(hrefTxt == "main"){
				location.href = $this.href;
				return;
			}
			/*****************************************/
			
			function naviAdd(node){
				$this.navi = NrvObj.pagenavi.append(node).children(':last-child');
				$this.navi.siblings().removeClass('on');
			}

			if(NrvObj.pagenavi.children('a').length){
				NrvObj.pagenavi.button = NrvObj.pagenavi.children('a');
				NrvObj.pagenavi.button.each(function(i){
					if($this.href == $(this).attr('pagedata')){
						NrvObj.pagenavi.flag = true;
						if(!$(this).hasClass('on')){
							$(this).addClass('on').siblings().removeClass('on');
							iframeLoad($this.href, $this.text);
						}
					}
				});
				
				if(!NrvObj.pagenavi.flag){ 
					naviAdd(makeNaviNode($this.text, $this.href, $this.id));
					iframeLoad($this.href, $this.text);
				}
			}else{
				naviAdd(makeNaviNode($this.text, $this.href, $this.id));
				iframeLoad($this.href, $this.text);
			}
			
			//사이드 메뉴 변경
			$(".hgroup").html(smObjectT[$this.id]);
			$(".lnb").html('<ul>'+smObject[$this.id]+'</ul>');
			NrvPub.IframePage2();
			
			//var $header = $('#header');
			//var $depth1 = $('#gnb > ul > li');
			//$header.removeClass('gnbOpen');
			//$depth1.removeClass('on');
			
			NrvObj.header.removeClass('gnbOpen');
			NrvObj.gnb.navi.css({'height' : 0});
			NrvObj.gnb.flag = false;
			
		});
		
		NrvObj.sub_gnb.link.on('click', function(e){
			
			if(NrvObj.iframe_wrap.children('iframe').length >= 10){
				alert('더이상 추가할 수 없습니다.');
				return false;
			}
			
			if($('#containerMain').css('display') == 'block'){
				$('#containerMain').css('display', 'none');
				$('#container').css('display', 'table');
			}
			
			e.preventDefault();
			e.stopPropagation();
	
			var $this = $(this);
			$this.href = $this.attr('href');
			$this.id = $this.attr('id');
			$this.text = $this.attr('pagetitle');
			NrvObj.pagenavi.flag = false;
			
			/***************** KWONSY ADD *************/
			var hrefTxt = $this.id.toUpperCase();
			if(hrefTxt == "main"){
				location.href = $this.href;
				return;
			}
			/*****************************************/
			
			function naviAdd(node){
				$this.navi = NrvObj.pagenavi.append(node).children(':last-child');
				$this.navi.siblings().removeClass('on');
			}

			if(NrvObj.pagenavi.children('a').length){
				NrvObj.pagenavi.button = NrvObj.pagenavi.children('a');
				NrvObj.pagenavi.button.each(function(i){
					if($this.href == $(this).attr('pagedata')){
						NrvObj.pagenavi.flag = true;
						if(!$(this).hasClass('on')){
							$(this).addClass('on').siblings().removeClass('on');
							iframeLoad($this.href, $this.text);
						}
					}
				});
				
				if(!NrvObj.pagenavi.flag){ 
					naviAdd(makeNaviNode($this.text, $this.href, $this.id));
					iframeLoad($this.href, $this.text);
				}
			}else{
				naviAdd(makeNaviNode($this.text, $this.href, $this.id));
				iframeLoad($this.href, $this.text);
			}
			
			//사이드 메뉴 변경
			$(".hgroup").html(smObjectT[$this.id]);
			$(".lnb").html('<ul>'+smObject[$this.id]+'</ul>');
			NrvPub.IframePage2();
			
			//var $header = $('#header');
			//var $depth1 = $('#gnb > ul > li');
			//$header.removeClass('gnbOpen');
			//$depth1.removeClass('on');
			
			NrvObj.header.removeClass('gnbOpen');
			NrvObj.gnb.navi.css({'height' : 0});
			NrvObj.gnb.flag = false;
			
		});
		
	
		NrvObj.containerMain.link.on('click', function(e){
			
			if(NrvObj.iframe_wrap.children('iframe').length >= 10){
				alert('더이상 추가할 수 없습니다.');
				return false;
			}
			
			if($('#containerMain').css('display') == 'block'){
				$('#containerMain').css('display', 'none');
				$('#container').css('display', 'table');
			}
			
			e.preventDefault();
			e.stopPropagation();
	
			var $this = $(this);
			$this.href = $this.attr('href');
			$this.id = $this.attr('id');
			$this.text = $this.attr('pagetitle');
			NrvObj.pagenavi.flag = false;
			
			/***************** KWONSY ADD *************/
			var hrefTxt = $this.id.toUpperCase();
			if(hrefTxt == "main"){
				location.href = $this.href;
				return;
			}
			/*****************************************/
			
			function naviAdd(node){
				$this.navi = NrvObj.pagenavi.append(node).children(':last-child');
				$this.navi.siblings().removeClass('on');
			}

			if(NrvObj.pagenavi.children('a').length){
				NrvObj.pagenavi.button = NrvObj.pagenavi.children('a');
				NrvObj.pagenavi.button.each(function(i){
					if($this.href == $(this).attr('pagedata')){
						NrvObj.pagenavi.flag = true;
						if(!$(this).hasClass('on')){
							$(this).addClass('on').siblings().removeClass('on');
							iframeLoad($this.href, $this.text);
						}
					}
				});
				
				if(!NrvObj.pagenavi.flag){ 
					naviAdd(makeNaviNode($this.text, $this.href, $this.id));
					iframeLoad($this.href, $this.text);
				}
			}else{
				naviAdd(makeNaviNode($this.text, $this.href, $this.id));
				iframeLoad($this.href, $this.text);
			}
			
			//사이드 메뉴 변경
			$(".hgroup").html(smObjectT[$this.id]);
			$(".lnb").html('<ul>'+smObject[$this.id]+'</ul>');
			NrvPub.IframePage2();

			//var $header = $('#header');
			//var $depth1 = $('#gnb > ul > li');
			//$header.removeClass('gnbOpen');
			//$depth1.removeClass('on');
			
			NrvObj.header.removeClass('gnbOpen');
			NrvObj.gnb.navi.css({'height' : 0});
			NrvObj.gnb.flag = false;
			
		});
		
		NrvObj.alarmDiv.link.on('click', function(e){
			
			if(NrvObj.iframe_wrap.children('iframe').length >= 10){
				alert('더이상 추가할 수 없습니다.');
				return false;
			}
			
			if($('#containerMain').css('display') == 'block'){
				$('#containerMain').css('display', 'none');
				$('#container').css('display', 'table');
			}
			
			e.preventDefault();
			e.stopPropagation();
	
			var $this = $(this);
			$this.href = $this.attr('href');
			$this.id = $this.attr('id');
			$this.text = $this.attr('pagetitle');
			NrvObj.pagenavi.flag = false;
			
			/***************** KWONSY ADD *************/
			var hrefTxt = $this.id.toUpperCase();
			if(hrefTxt == "main"){
				location.href = $this.href;
				return;
			}
			/*****************************************/
			
			function naviAdd(node){
				$this.navi = NrvObj.pagenavi.append(node).children(':last-child');
				$this.navi.siblings().removeClass('on');
			}

			if(NrvObj.pagenavi.children('a').length){
				NrvObj.pagenavi.button = NrvObj.pagenavi.children('a');
				NrvObj.pagenavi.button.each(function(i){
					if($this.href == $(this).attr('pagedata')){
						NrvObj.pagenavi.flag = true;
						if(!$(this).hasClass('on')){
							$(this).addClass('on').siblings().removeClass('on');
							iframeLoad($this.href, $this.text);
						}
					}
				});
				
				if(!NrvObj.pagenavi.flag){ 
					naviAdd(makeNaviNode($this.text, $this.href, $this.id));
					iframeLoad($this.href, $this.text);
				}
			}else{
				naviAdd(makeNaviNode($this.text, $this.href, $this.id));
				iframeLoad($this.href, $this.text);
			}
			
			//알림창 닫기
			$(window).off('click.alarm');
			NrvObj.header.removeClass('alarmOpen');
			//해당알림 읽음처리
			anc_confirm($this.parent().attr('id'));
			
			//사이드 메뉴 변경
			$(".hgroup").html(smObjectT[$this.id]);
			$(".lnb").html('<ul>'+smObject[$this.id]+'</ul>');
			NrvPub.IframePage2();

			//var $header = $('#header');
			//var $depth1 = $('#gnb > ul > li');
			//$header.removeClass('gnbOpen');
			//$depth1.removeClass('on');
			
			NrvObj.header.removeClass('gnbOpen');
			NrvObj.gnb.navi.css({'height' : 0});
			NrvObj.gnb.flag = false;
			
		});
		
		
		NrvObj.alarmDivTop.link.on('click', function(e){
			
			if(NrvObj.iframe_wrap.children('iframe').length >= 10){
				alert('더이상 추가할 수 없습니다.');
				return false;
			}
			
			if($('#containerMain').css('display') == 'block'){
				$('#containerMain').css('display', 'none');
				$('#container').css('display', 'table');
			}
			
			e.preventDefault();
			e.stopPropagation();
	
			var $this = $(this);
			$this.href = $this.attr('href');
			$this.id = $this.attr('id');
			$this.text = $this.attr('pagetitle');
			NrvObj.pagenavi.flag = false;
			
			/***************** KWONSY ADD *************/
			var hrefTxt = $this.id.toUpperCase();
			if(hrefTxt == "main"){
				location.href = $this.href;
				return;
			}
			/*****************************************/
			
			function naviAdd(node){
				$this.navi = NrvObj.pagenavi.append(node).children(':last-child');
				$this.navi.siblings().removeClass('on');
			}

			if(NrvObj.pagenavi.children('a').length){
				NrvObj.pagenavi.button = NrvObj.pagenavi.children('a');
				NrvObj.pagenavi.button.each(function(i){
					if($this.href == $(this).attr('pagedata')){
						NrvObj.pagenavi.flag = true;
						if(!$(this).hasClass('on')){
							$(this).addClass('on').siblings().removeClass('on');
							iframeLoad($this.href, $this.text);
						}
					}
				});
				
				if(!NrvObj.pagenavi.flag){ 
					naviAdd(makeNaviNode($this.text, $this.href, $this.id));
					iframeLoad($this.href, $this.text);
				}
			}else{
				naviAdd(makeNaviNode($this.text, $this.href, $this.id));
				iframeLoad($this.href, $this.text);
			}
			
			//탑배너 닫기
			//$('#wrap').addClass('topbannerClose');
			//해당알림 읽음처리
			anc_confirm($this.parent().attr('id'));
			
			//사이드 메뉴 변경
			$(".hgroup").html(smObjectT[$this.id]);
			$(".lnb").html('<ul>'+smObject[$this.id]+'</ul>');
			NrvPub.IframePage2();

			//var $header = $('#header');
			//var $depth1 = $('#gnb > ul > li');
			//$header.removeClass('gnbOpen');
			//$depth1.removeClass('on');
			
			NrvObj.header.removeClass('gnbOpen');
			NrvObj.gnb.navi.css({'height' : 0});
			NrvObj.gnb.flag = false;
			
		});
		
		
		NrvObj.submenu.link.on('click', function(e){
			
			if($('#containerMain').css('display') == 'block'){
				$('#containerMain').css('display', 'none');
				$('#container').css('display', 'table');
			}
			
			e.preventDefault();
			e.stopPropagation();
	
			var $this = $(this);
			$this.href = $this.attr('href');
			$this.id = $this.attr('id');
			$this.text = $this.attr('pagetitle');
			NrvObj.pagenavi.flag = false;
			
			/***************** KWONSY ADD *************/
			var hrefTxt = ($this.href).toUpperCase();
			if(hrefTxt.indexOf("LOGOUT") > -1){
				location.href = $this.href;
				return;
			}
			/*****************************************/

			function naviAdd(node){
				$this.navi = NrvObj.pagenavi.append(node).children(':last-child');
				$this.navi.siblings().removeClass('on');
			}

			if(NrvObj.pagenavi.children('a').length){
				NrvObj.pagenavi.button = NrvObj.pagenavi.children('a');
				NrvObj.pagenavi.button.each(function(i){
					if($this.href == $(this).attr('pagedata')){
						NrvObj.pagenavi.flag = true;
						if(!$(this).hasClass('on')){
							$(this).addClass('on').siblings().removeClass('on');
							iframeLoad($this.href, $this.text);
						}
					}
				});
				
				if(!NrvObj.pagenavi.flag){ 
					naviAdd(makeNaviNode($this.text, $this.href, $this.id));
					iframeLoad($this.href, $this.text);
				}
			}else{
				naviAdd(makeNaviNode($this.text, $this.href, $this.id));
				iframeLoad($this.href, $this.text);
			}
			
			//사이드 메뉴 변경
			$(".hgroup").html(smObjectT[$this.id]);
			$(".lnb").html('<ul>'+smObject[$this.id]+'</ul>');
			NrvPub.IframePage2();
			
			//var $header = $('#header');
			//var $depth1 = $('#gnb > ul > li');
			//$header.removeClass('gnbOpen');
			//$depth1.removeClass('on');
			
			NrvObj.header.removeClass('gnbOpen');
			NrvObj.gnb.navi.css({'height' : 0});
			NrvObj.gnb.flag = false;
			
		});
		

		$(document).on('click.pagenavi', '#pagenavi a', function(e){
			e.stopPropagation();
			if(!$(this).hasClass('on')){
				$(this).addClass('on').siblings().removeClass('on');
				iframeLoad($(this).attr('pagedata'));
				
				//탭 클릭시 사이드 메뉴 변경
				$(".hgroup").html(smObjectT[$(this).attr('id')]);
				$(".lnb").html('<ul>'+smObject[$(this).attr('id')]+'</ul>');
				NrvPub.IframePage2();
			}
		});

		$(document).on('click.pagenavi', '#pagenavi .dlt', function(e){
			e.stopPropagation();
			
			//iframe 제거
			var cPagedata = $(this).parent().attr('pagedata');
			
			//탭 하나는 남겨둠..
			if(NrvObj.iframe_wrap.children('iframe').length == 1) return;
			
			NrvObj.iframe_wrap.children('iframe').each(function(i){
				if(cPagedata == $(this).attr('pagedata')){
					$(this).remove();
				}
			});
			
			if($(this).parent().hasClass('on')){
				$(this).parent().remove();
				if(NrvObj.pagenavi.children().length){
					NrvObj.pagenavi.children(':last-child').addClass('on');
					
					//탭 닫았을때 뷰페이지 메뉴보이도록 설정
					var tmpObj = NrvObj.pagenavi.children(':last-child');
					iframeLoad($(tmpObj).attr('pagedata'), $(tmpObj).text);
					
					$(".hgroup").html(smObjectT[$(tmpObj).attr('id')]);
					$(".lnb").html('<ul>'+smObject[$(tmpObj).attr('id')]+'</ul>');
					NrvPub.IframePage2();
					
				}else{
				}
			}else{
				$(this).parent().remove();
			}
		});
	}
	
	/*
	* Page Load Script
	* Iframe Type
	*/
	NrvPub.IframePage2 = function(){
		var flag = false;
		var flagIdx = false;
		var naviObj;
		NrvObj.lnb.link = NrvObj.lnb.find('a');
		
		function makeNaviNode(text, data, id){
			return '<a class="on" pagedata="'+data+'" id="'+id+'"><span class="tit">'+text+'</span><button type="button" class="dlt">페이지 닫기</button></a>';
		}

		function iframeLoad(href, title){
			var iCheck = true;
			
			NrvObj.iframe_wrap.children('iframe').each(function(i){
				if(href == $(this).attr('pagedata')){
					iCheck = false;
				}
			});

			if(iCheck){ //true
				NrvObj.iframe_wrap.append('<iframe src="" id="iframe" pagedata="'+href+'" scrolling="no" style="" name="'+href+'"></iframe>');
			}

			NrvObj.iframe_wrap.children('iframe').each(function(i){
				if(href == $(this).attr('pagedata')){

					$(this).attr('style', '').siblings().attr('style', 'visibility:hidden;display:none');
					
					if($(this).attr('src') == ''){
						$(this).attr('src', href).on('load', function(){
							$(this).height($(this).contents().outerHeight());
							$(this).contents().find('#title').text(title);
							
							//스크롤 최상단으로
							$(this).parents('body').scrollTop(0);
						});
					}else{
						$(this).height($(this).contents().outerHeight());
					}
					
				}
			});
			
			//NrvObj.iframe.attr('src', href).on('load', function(){
			//	$(this).height(NrvObj.iframe.contents().outerHeight());
			//	NrvObj.iframe.contents().find('#title').text(title);
			//});

		}

		NrvObj.lnb.link.on('click', function(e){
			
			if(NrvObj.iframe_wrap.children('iframe').length >= 10){
				alert('더이상 추가할 수 없습니다.');
				return false;
			}
			
			e.preventDefault();
			e.stopPropagation();

			var $this = $(this);
			$this.href = $this.attr('href');
			$this.text = $this.text(); // 타이틀명
			$this.id = $this.attr('id');
			NrvObj.pagenavi.flag = false;

			function naviAdd(node){
				$this.navi = NrvObj.pagenavi.append(node).children(':last-child');
				$this.navi.siblings().removeClass('on');
			}

			if(NrvObj.pagenavi.children('a').length){
				NrvObj.pagenavi.button = NrvObj.pagenavi.children('a');
				NrvObj.pagenavi.button.each(function(i){
					if($this.href == $(this).attr('pagedata')){
						NrvObj.pagenavi.flag = true;
						if(!$(this).hasClass('on')){
							$(this).addClass('on').siblings().removeClass('on');
							iframeLoad($this.href, $this.text);
						}
					}
				});
				if(!NrvObj.pagenavi.flag){
					naviAdd(makeNaviNode($this.text, $this.href, $this.id));
					iframeLoad($this.href, $this.text);
				}
			}else{
				naviAdd(makeNaviNode($this.text, $this.href, $this.id));
				iframeLoad($this.href, $this.text);
			}
			
		});
		
	}
	
	
	/* 알림창 링크 재설정용 */
	/*
	* Page Load Script
	* Iframe Type
	*/
	NrvPub.IframePageAlarm = function(){
		var flag = false;
		var flagIdx = false;
		var naviObj;
		NrvObj.alarmDiv.link = NrvObj.alarmDiv.find('a');
		
		function makeNaviNode(text, data, id){
			return '<a class="on" pagedata="'+data+'" id="'+id+'"><span class="tit">'+text+'</span><button type="button" class="dlt">페이지 닫기</button></a>';
		}

		function iframeLoad(href, title){
			var iCheck = true;
			NrvObj.iframe_wrap.children('iframe').each(function(i){
				if(href == $(this).attr('pagedata')){
					iCheck = false;
				}
			});

			if(iCheck){ //true
				NrvObj.iframe_wrap.append('<iframe src="" id="iframe" pagedata="'+href+'" scrolling="no" style="" name="'+href+'"></iframe>');
			}
			
			NrvObj.iframe_wrap.children('iframe').each(function(i){
				if(href == $(this).attr('pagedata')){
					$(this).attr('style', '').siblings().attr('style', 'visibility:hidden;display:none');

					if($(this).attr('src') == ''){
						$(this).attr('src', href).on('load', function(){
							$(this).height($(this).contents().outerHeight());
							$(this).contents().find('#title').text(title);
							
							//스크롤 최상단으로
							$(this).parents('body').scrollTop(0);
						});
					}else{
						$(this).height($(this).contents().outerHeight());
					}
				}
			});
			
			//NrvObj.iframe.attr('src', href).on('load', function(){
			//	$(this).height(NrvObj.iframe.contents().outerHeight());
			//	NrvObj.iframe.contents().find('#title').text(title);
			//});
		}

		NrvObj.alarmDiv.link.on('click', function(e){
			
			if(NrvObj.iframe_wrap.children('iframe').length >= 10){
				alert('더이상 추가할 수 없습니다.');
				return false;
			}
			
			if($('#containerMain').css('display') == 'block'){
				$('#containerMain').css('display', 'none');
				$('#container').css('display', 'table');
			}
			
			e.preventDefault();
			e.stopPropagation();
	
			var $this = $(this);
			$this.href = $this.attr('href');
			$this.id = $this.attr('id');
			$this.text = $this.attr('pagetitle');
			NrvObj.pagenavi.flag = false;
			
			/***************** KWONSY ADD *************/
			var hrefTxt = $this.id.toUpperCase();
			if(hrefTxt == "main"){
				location.href = $this.href;
				return;
			}
			/*****************************************/
			
			function naviAdd(node){
				$this.navi = NrvObj.pagenavi.append(node).children(':last-child');
				$this.navi.siblings().removeClass('on');
			}

			if(NrvObj.pagenavi.children('a').length){
				NrvObj.pagenavi.button = NrvObj.pagenavi.children('a');
				NrvObj.pagenavi.button.each(function(i){
					if($this.href == $(this).attr('pagedata')){
						NrvObj.pagenavi.flag = true;
						if(!$(this).hasClass('on')){
							$(this).addClass('on').siblings().removeClass('on');
							iframeLoad($this.href, $this.text);
						}
					}
				});
				
				if(!NrvObj.pagenavi.flag){ 
					naviAdd(makeNaviNode($this.text, $this.href, $this.id));
					iframeLoad($this.href, $this.text);
				}
			}else{
				naviAdd(makeNaviNode($this.text, $this.href, $this.id));
				iframeLoad($this.href, $this.text);
			}
			
			//알림창 닫기
			$(window).off('click.alarm');
			NrvObj.header.removeClass('alarmOpen');
			//해당알림 읽음처리
			anc_confirm($this.parent().attr('id'));
			
			//사이드 메뉴 변경
			$(".hgroup").html(smObjectT[$this.id]);
			$(".lnb").html('<ul>'+smObject[$this.id]+'</ul>');
			NrvPub.IframePage2();

			//var $header = $('#header');
			//var $depth1 = $('#gnb > ul > li');
			//$header.removeClass('gnbOpen');
			//$depth1.removeClass('on');
			
			NrvObj.header.removeClass('gnbOpen');
			NrvObj.gnb.navi.css({'height' : 0});
			NrvObj.gnb.flag = false;
			
		});

	}
	
	
	/* 
	* 비동기 레이어 팝업
	* 실행 : NrePub.AjaxPopup('url', {options})
	* 닫기버튼에 추가 : layer="close"
	*/
	NrvPub.AjaxPopup = function(url, pagedata, options){
				
		var defaults = {
			className : {
				wrap : 'layer-wrap',
				back : 'layer-back'
			},
			tiemout : 10000,
			datatype : 'html',
			background : true,
			appendData : '',
			openCall : function(target){},
			closeCall : function(target){}
		}

		var obj = {};
		var opt = $.extend({}, defaults, options);
		
		var makePopup = function(){
			NrvSbj.ajaxPopupIdx++;

			obj.resize = 'resize.AjaxPopup'+NrvSbj.ajaxPopupIdx;
			obj.wrap	 = NrvObj.body.append('<div class="'+opt.className.wrap+'">').children('.'+opt.className.wrap+':last-child');
			obj.back	 = obj.wrap.append('<div class="'+opt.className.back+'">').children('.'+opt.className.back).attr({'layer':'none'});

			if(!opt.background){obj.back.addClass('bg-none');}
			
			//if($("."+opt.className.back).length == 1 && pagedata != ''){ //팝업창이 이미 올라간 상태에서는 실행 안하도록,  프레임안에서 호출할때만 처리

			if($("."+opt.className.back).length == 1){
				//팝업창 아래 스크롤 없애기
				NrvObj.body.css({'overflow': 'hidden'});
			}
			
		}

		var closePopup = function(){
			obj.close = obj.wrap.find('[layer="close"]');
			
			obj.close.on('click', function(){
				
				//if($("."+opt.className.back).length == 1 && pagedata != ''){ //팝업창이 이미 올라간 상태에서는 실행 안하도록,  프레임안에서 호출할때만 처리
				
				if($("."+opt.className.back).length == 1){
					//팝업창 아래 스크롤 복구
					NrvObj.body.css({'overflow': 'auto'});
				}
				
				if(window.Select2 != undefined){
					//리셋이 필요함...
					window.Select2 = undefined;
				}
				
				opt.closeCall(obj.data);
				obj.wrap.remove();
				$(window).off(obj.resize);
				
			});
		}

		var popupSize = function(){
			obj.wrap.w = obj.wrap.outerWidth();
			obj.wrap.h = obj.wrap.outerHeight();
			obj.wrap.t = obj.wrap.h > NrvSbj.woh * 0.8 ? NrvSbj.wsy + NrvSbj.woh * 0.1 : NrvSbj.wsy + (NrvSbj.woh - obj.wrap.h) / 2;
			obj.wrap.l = (NrvSbj.wow - obj.wrap.w) / 2;
			obj.wrap.css({
				'top' : obj.wrap.t,
				'left' : obj.wrap.l,
				'padding-bottom' : NrvSbj.woh * 0.1
			}).addClass('open');

			$(window).on(obj.resize, function(){
				obj.wrap.l = (NrvSbj.wow - obj.wrap.w) / 2;
				obj.wrap.css({'left' : obj.wrap.l});
			});
		}
		
		var tmpPagedata = "";
		if(Object.prototype.toString.call(pagedata) === "[object Object]" 
			|| Object.prototype.toString.call(pagedata) === "[object JSON]"){
			tmpPagedata = pagedata["pagedata"];
		}else{
			tmpPagedata = pagedata;
		}
		
		$.ajax({
			url : url,
			timeout : opt.tiemout,
			data : pagedata,
			type : 'POST',
			dataType : opt.datatype,
		 	beforeSend: function(request) {
		 		var gtoken = $("meta[name='_csrf']").attr("content");
				var gheader = $("meta[name='_csrf_header']").attr("content");

				request.setRequestHeader("AJAX", true);
				request.setRequestHeader(gheader, gtoken);
			},
			success : function(data){
				
				data += opt.appendData;
				makePopup();
				obj.data = $(data);
				obj.wrap.append(obj.data).ImagesLoaded().then(function(){
					opt.openCall(obj.data);
					closePopup();

					if(tmpPagedata != '' && tmpPagedata != undefined){
						//팝업에서 부모창 접근시 사용
						$('#pagedata').val(tmpPagedata);
					}
				
					if(opt.alertText != '' && opt.alertText != undefined){
						//alert창 문구
						var tempText = $('#alertText').text(opt.alertText).text();
						$('#alertText').html(tempText.replace(/\n/g, '<br />'));
					}
					
					if(opt.func != '' && opt.func != undefined){
						//실행펑션
						$('#func').val(opt.func);
						
						if(opt.func == 'main_move'){ //왼쪽상단 클릭시만 적용
							$('#closeDiv').show();
						}
					}
					
					if(opt.alertPagedata != '' && opt.alertPagedata != undefined){
						//alert창 전용
						$('#alertPagedata').val(opt.alertPagedata);
					}
					//$("#testpage").text(input)
					
					if(opt.type !='' && opt.type == 'confirm'){
						$('#confirm').attr('style', '');
						$('#alert').attr('style', 'display:none');
					}
					
					
					popupSize();
					
					//엔터키 입력시 버튼 이벤트 처리되도록...
					$('#alertOk').focus();
					
										
					/*
					$('#element').on('scroll touchmove mousewheel', function(event) {
					  event.preventDefault();
					  event.stopPropagation();
				       return false;
					});
					*/
				});
			},
			error: function(c){
				if(c.status == 401 || c.status == 403){
					//alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
					location.href = "/login.do";
				}else if(c.responseText != null && c.responseText != ""){
					alert("처리중 오류가 발생하였습니다. \r\n다시 시도 하십시오.", '', 'Y');	
				}
				//alert('['+xhr.status+'] 서버전송오류가 발생했습니다.');
			}
		});
	};

	NrvPub.Util = {
		/*
		* 구글 맵
		* 키값은 고객사에 요청
		* API 호출 : <script src="http://maps.google.com/maps/api/js?key=키값넣는곳&sensor=false"></script>
		*/
		GoogleMapApi : function(lat, lng, name, target){
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
		
		/* 
		* 매치미디어
		* CSS의 미디어쿼리같은 역할
		* 함수 인자1 : media 기준보다 window width값이 같거나 넓을때 실행 (pc)
		* 함수 인자2 : media 기준보다 window width값이 좁을때 실행 (mobile)
		*/
		MatchMedia : function(function1, function2){
			var media = window.matchMedia('(max-width: 768px)');
			var ready = false;

			function matchesAction(paramse){
				if(!paramse.matches){
					function1();
				}else{
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
		},

		/*
		* 디바이스 별 viewport 변환
		* 별도 플러그인 필요 'mobile-detect.min.js'
		*/
		/*ChangeViewport : (function(){
			if(NrvSbj.chkdevice.desktop){
				NrvSbj.viewport.attr({'content':'width=1100, user-scalable=yes'});
			}
			if(NrvSbj.chkdevice.tablet){
				NrvSbj.viewport.attr({'content':'width=1100, user-scalable=yes'});
			}
			if(NrvSbj.chkdevice.mobile){
				NrvSbj.viewport.attr({'content':'width=750, user-scalable=yes'});
			}
		})(),*/

		/*
		* 로딩 또는 스크롤 했을 때 object 등장 모션
		* 모션을 원하는 object에 class : n-motion 추가
		*/
		LoadMotion : function(){
			var $motion = $('.n-motion');
			if(!$motion.length) return;
			$motion.each(function(i){
				var $this = $(this),
					thisT = $this.offset().top,
					thisH = $this.height() / 2,
					thisP = thisT + thisH,
					event = 'load.nmotion'+i+' scroll.nmotion'+i;

				$(window).on(event, function(){
					if(NrvSbj.wsy+NrvSbj.woh > thisP){
						$this.addClass('n-active');
						$(window).off(event);
					}
				});
			});
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

	NrvPub.UI = {
			
			AlarmLayer : function(){
				var $layer = NrvObj.header.find('.alarm_wrap .layer');
				var $open = NrvObj.header.find('.alarm_wrap .alarm');
				var $close = NrvObj.header.find('.alarm_wrap .close');

				function close(){
					$(window).off('click.alarm');
					NrvObj.header.removeClass('alarmOpen');
				}

				$open.on('click', function(e){
					
					//없으면 안띄움
					if(jQuery.trim($('#alarmDiv').html()) == ''){
						return false;
					}
					
					//열려있으면 닫음
					if(NrvObj.header.attr('class') == 'alarmOpen'){
						close();
						return false;
					}
					
					e.stopPropagation();
					NrvObj.header.addClass('alarmOpen');
					$(window).on('click.alarm', function(e){
						if(!$(e.target).closest($layer).length){
							close();
						}
					});
				});

				$close.on('click', function(){
					close();
				});
			},
			
			HeaderFixedScrollX : function(){
				$(window).on('load scroll', function(){
					NrvObj.header.css({'left':-NrvSbj.wsx});
				});
			},

			GnbAction : function(){
				NrvObj.gnb.flag = false;
				NrvObj.gnb.navi = NrvObj.gnb.find('> .navi');
				NrvObj.gnb.menu = NrvObj.gnb.navi.children();
				NrvObj.gnb.menu.height = NrvObj.gnb.menu.height();
				NrvObj.gnb.trigger = $('#gnb_trg');

				NrvObj.gnb.trigger.on('click', function(){
					if(NrvObj.gnb.flag){
						NrvObj.header.removeClass('gnbOpen');
						NrvObj.gnb.navi.css({'height' : 0});
						NrvObj.gnb.flag = false;
					}else{
						NrvObj.header.addClass('gnbOpen');
						NrvObj.gnb.navi.css({'height' : NrvObj.gnb.menu.height});
						NrvObj.gnb.flag = true;
					}
				});
				
				
				NrvObj.gnb.trigger.on('mouseenter', function(){
					NrvObj.header.addClass('gnbOpen');
					NrvObj.gnb.navi.css({'height' : NrvObj.gnb.menu.height});
					NrvObj.gnb.flag = true;
				});

				NrvObj.gnb.navi.on('mouseleave', function(){
					NrvObj.header.removeClass('gnbOpen');
					NrvObj.gnb.navi.css({'height' : 0});
					NrvObj.gnb.flag = false;
				});
				
				/*
				NrvObj.gnb.trigger.on('mouseover', function(){
					NrvObj.header.addClass('gnbOpen');
					NrvObj.gnb.navi.css({'height' : NrvObj.gnb.menu.height});
					NrvObj.gnb.flag = true;
				});
				=
				
				NrvObj.gnb.navi.on('mouseout', function(){
					NrvObj.header.removeClass('gnbOpen');
					NrvObj.gnb.navi.css({'height' : 0});
					NrvObj.gnb.flag = false;
				});
				*/
				
			},

			InputFile : function(target){
				var $target = $(target);
				var $input = $(target).parent().prev('input');

				$input.val($target.val());
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


function pub_ready(){
	NrvPub.Init();
	NrvPub.UI.GnbAction();
	NrvPub.Util.LoadMotion();
	NrvPub.IframePage();
	NrvPub.UI.AlarmLayer();
}
