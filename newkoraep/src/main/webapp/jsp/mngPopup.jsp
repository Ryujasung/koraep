<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>팝업창</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />
 
 <%
 	String POP_SEQ = request.getParameter("POP_SEQ");
 	if(POP_SEQ == null){
 		POP_SEQ = "";
 	}else{
 		POP_SEQ = POP_SEQ.replaceAll("<", "").replaceAll("\0", "").replaceAll("\\\\r", "").replaceAll("\\\\n", "").replaceAll("\\\\t", "");
 	}
 %>
 
<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>
<script src="/js/jquery/jquery-ui.js"></script>
<script src="/js/jquery/jquery.ui.datepicker-ko.js"></script>

<link rel="stylesheet" href="/ckeditor/contents.css" type="text/css">

<script type="text/javaScript" language="javascript" defer="defer">
window.focus();
var mngNm = "";
$(document).ready(function(){

	var POP_SEQ = "<%=POP_SEQ%>";
	if(POP_SEQ != null && POP_SEQ != ""){
		mngNm = "mngPop" + POP_SEQ;
		var sData = {"POP_SEQ":POP_SEQ};
		var url = "/EP/EPCE8149301_POP.do";
		
		ajaxPost(url, sData, fn_setData);
		
	}else{
		var objEditor = window.opener.CKEDITOR.instances["CNTN"];
		document.title = $(opener.document).find("#SBJ").val();
		$("#header").html($(opener.document).find("#SBJ").val());
		$("#cntn").html(objEditor.getData());
	}
});

function fn_setData(data){
	 document.title = data.SBJ;
	 $("#header").html(data.SBJ);
	 $("#cntn").html(data.CNTN);
}


function fn_closeLayer(tf){
	if(!tf) return;
	gfn_setCookie(mngNm, "done");
	this.close();
}

/**
 * jquery ajax execute
 * url, dataBody, func(실행함수)
 * */
function ajaxPost(url,dataBody,func,pAsync){

	var async = true;
	if(pAsync != null && pAsync != "undefined") async = pAsync;
	
	var gtoken = $("meta[name='_csrf']").attr("content");
	var gheader = $("meta[name='_csrf_header']").attr("content");
	
	$.ajax({
		url : url,
		type : 'POST',
		data : dataBody,
		dataType : 'json',
		cache : false,
		async : async,
		traditional : true,
		beforeSend: function(request) {
		    request.setRequestHeader("AJAX", true);
		    request.setRequestHeader(gheader, $("meta[name='_csrf']").attr("content"));
		},
		success : function(data) {
			func(data);
		},
		error : function(c) {
			if(c.status == 401 || c.status == 403){
			}else if(c.responseText != null && c.responseText != ""){
			}
		}
	});
}

/**
 * 쿠키 세팅
 * @param cookieName
 * @param cookieValue
 */
function gfn_setCookie(cookieName, cookieValu){
	gfn_setCookie(cookieName, cookieValue, 1);
}

function gfn_setCookie(cookieName, cookieValue, term)
{
	var today = new Date();
	if(term == null || term == "") term = 1;
	today.setDate(today.getDate() + term);
	
	if(cookieValue == null || cookieValue == ""){
		var expireDate = new Date();
		expireDate.setDate( expireDate.getDate() - 1 );	//어제 날짜를 쿠키 소멸 날짜로 설정한다.
		document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString() + "; path=/";
	}else{
		document.cookie = cookieName + "=" + escape( cookieValue ) + "; path=/; expires=" + today.toGMTString() + ";";
	}
	return true;
}

</script>
<style>

/*메인 공지안내*/
#info_popup{position:relative; margin:0; padding:0}
#info_popup header{height:61px; padding:12px 0 0 19px; border:1px solid #999; border-bottom:1px solid #ddd; box-sizing:border-box}
#info_popup header h1{font-size:16px; color:#333; font-weight:bold}
#info_popup #info_container{padding:20px 20px 110px; line-height:18px; border:1px solid #999;  border-top:none; box-sizing:border-box; background:url(/images/img_main_pop.png) no-repeat 50% 90%}
.info_content .txt{margin-bottom:18px; line-height:20px;}
.info_content .bro_link .txt{margin-bottom:5px; font-weight:bold}
.info_content .bro_link dl{padding:10px; background:#eee}
.info_content .bro_link dd{margin-bottom:5px}
.info_content .bro_link dd a{color:#0060ff; text-decoration:underline}
.info_content .bro_link dd:last-child{margin:0}
.close_box{position:relative; padding:1px; background:#e5e5e5}

.close_box .today label{display:inline-block; padding:0 4px}
.close_box .close{position:absolute; bottom:4px; right:10px; padding-right:14px; background:url(/images/btn_close2.png) no-repeat right 1px}

</style>

</head>
<body style="margin:0px">

<div id="info_popup">
	<header>
		<h1 id="header"></h1>
	</header>
	<div id="info_container">
		<div class="info_content">
			<!-- 내용나오는곳 -->
			<p id="cntn"></p>
		</div>
	</div>
	<div class="close_box">
		<p class="today">
			<input type="checkbox" id="close_today" onclick="fn_closeLayer(this.checked);" />
            <label for="close_today">오늘 하루 보지 않기</label>
		</p>
		<p class="close"><a href="javascript:self.close();">닫기</a></p>
	</div>
</div>

</body>
</html>
