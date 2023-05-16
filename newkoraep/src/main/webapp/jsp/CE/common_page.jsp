<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />

<link rel="stylesheet" href="/common/css/slick.css?v=<%=System.currentTimeMillis() %>">
<link rel="stylesheet" href="/common/css/common.css?v=<%=System.currentTimeMillis() %>">
<link rel="stylesheet" href="/common/css/font.css?v=<%=System.currentTimeMillis() %>">
<link rel="stylesheet" href="/common/css/reset.css?v=<%=System.currentTimeMillis() %>">

<!-- 페이징 관련 스타일 -->
<style type="text/css">
	.gridPaging { text-align:center; font-family:verdana; font-size:12px; width:100%; padding:15px 0px 15px 0px; }
	.gridPaging a { color:#797674; text-decoration:none; border:1px solid #e0e0e0; background-color:#f6f4f4; padding:3px 5px 3px 5px;}
	.gridPaging a:link { color:#797674; text-decoration:none; }
	.gridPaging a:visited { color:#797674; text-decoration:none; }
	.gridPaging a:hover { text-decoration:none; border:1px solid #7a8ba2; text-decoration:none; }
	.gridPaging a:active { text-decoration:none; }
	.gridPagingMove { font-weight:bold; }
	.gridPagingDisable { font-weight:bold; color:#cccccc; border:1px solid #e0e0e0; background-color:#f6f4f4; padding:3px 5px 3px 5px;}
	.gridPagingCurrent { font-weight:bold; color:#ffffff; border:1px solid #2f3d64; background-color:#2f3d64; padding:3px 5px 3px 5px;}
</style>

<link rel="stylesheet" type="text/css" href="/rMateGrid/rMateGridH5/Assets/rMateH5.css"/>
<script type="text/javascript" src="/rMateGrid/LicenseKey/rMateGridH5License.js?v=20211130"></script>	<!-- rMateGridH5 라이센스 -->
<script language="javascript" type="text/javascript" src="/rMateChart/LicenseKey/rMateChartH5License.js?v=20211130"></script>
<script language="javascript" type="text/javascript" src="/rMateMapChart/LicenseKey/rMateMapChartH5License.js?v=20211130"></script>
<script type="text/javascript" src="/rMateGrid/rMateGridH5/JS/rMateGridH5.js"></script>		<!-- rMateGridH5 라이브러리 -->
<script type="text/javascript" src="/rMateGrid/rMateGridH5/JS/jszip.min.js"></script>
<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>
<script src="/js/jquery/jquery-ui.js"></script>
<script src="/js/jquery/jquery.ui.datepicker-ko.js"></script>

<script src="/js/kora/kora_common.js?v=<%=System.currentTimeMillis() %>"></script>
<script src="/common/js/pub.plugin.js?v=<%=System.currentTimeMillis() %>"></script>

<script>

	$(document).ready(function(){
	
		if(window.frameElement != null){
			var delta = 300;
			var timer = null;
			
			window.addEventListener( 'resize', function( ) {
			    clearTimeout( timer );
			    timer = setTimeout( resizeDone, delta );
			}, false );
		
			//페이지 로딩시 height 조정
			window.frameElement.style.height = $('.iframe_inner').height()+5+'px';
			
			//윈도우 resize 완료 후 height 조정
			function resizeDone( ) {
				//console.log($('.iframe_inner').height());
				window.frameElement.style.height = $('.iframe_inner').height()+5+'px';
			}
		}
		
	});
	
	//버튼셋팅
	function fn_btnSetting(val){
		
		var menuCd;
		if(val != '' && val != undefined){
			menuCd = val;
		}else{
			menuCd = gUrl;
		}
		
		ajaxPost("/SELECT_BTN_LIST.do", {"MENU_CD": menuCd}, function(data){
			if(data.length > 0){
				$.each(data, function(i, v){
					$("[id='"+v['BTN_LC_SE']+"']").append(v['EXEC_INFO']);
					
					if(v['BTN_CD'].indexOf('btn_excel_reg') > -1){
						$("[id='"+v['BTN_LC_SE']+"']").children(":last").append('<span class="excel_register"></span>').children(":last").text(v['BTN_NM']);
					}else if(v['BTN_CD'].indexOf('btn_excel') > -1){
						$("[id='"+v['BTN_LC_SE']+"']").children(":last").append('<span class="excel"></span>').children(":last").text(v['BTN_NM']);
					}else if(v['BTN_CD'].indexOf('btn_dwnd') > -1){
						$("[id='"+v['BTN_LC_SE']+"']").children(":last").append('<span class="form"></span>').children(":last").text(v['BTN_NM']);
					}else{
						$("[id='"+v['BTN_LC_SE']+"']").children(":last").text(v['BTN_NM']);
					}
					
					$("[id='"+v['BTN_LC_SE']+"']").children(":last").attr('id', v['BTN_CD']);
				});
			}else{
			}
		}, false);
	}

</script>
