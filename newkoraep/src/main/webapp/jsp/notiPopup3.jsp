<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
 /**
  * @Class Name : notiPopup3.jsp
  * @Description : noti popup
  * @Modification Information
  * 
  * @author kwonsy
  * @since 2015.09.18
  * @version 1.0
  * @see
  */
 %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>설연휴 전산에러 긴급문의 안내</title>

<link rel="stylesheet" href="/css/basic.css" type="text/css">
<link rel="stylesheet" href="/css/common.css" type="text/css">
<link rel="stylesheet" href="/css/pop.css" type="text/css">

<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>
<script src="/js/common.js"></script>

<script type="text/javaScript" language="javascript" defer="defer">
window.focus();
function fn_closeLayer(tf, day){
	if(!tf) return;
	gfn_setCookie("dpPop3", "done", day);
	this.close();
}


</script>

	
</head>
<body>

<div id="info_popup">
	<header>
		<h1>[알림] 설연휴 전산오류 발생시 긴급문의 안내</h1>
	</header>
	<div id="info_container">
		<div class="info_content">
			<p class="txt">
				설연휴기간(2016년 2월 6일 ~ 2016년 2월 10일) 지급관리 시스템을 이용하시다가 </br> 
				전산오류가 발생하는 경우 긴급전화(02-768-1671, 1681, 1691)로 문의 주시기 바랍니다.
			</p>
		</div>	
	</div>
	<div class="close_box">
		
		<p class="today">
			<input type="checkbox" id="close_today" onclick="fn_closeLayer(this.checked, 1);">
			<label for="close_today">오늘 하루 보지 않기</label> 
		</p>
		
		<p class="close"><a href="javascript:self.close();">닫기</a></p>
	</div>
</div>


</body>
</html>