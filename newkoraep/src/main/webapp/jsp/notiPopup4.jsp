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
<title>이용문의 안내</title>

<link rel="stylesheet" href="/css/basic.css" type="text/css">
<link rel="stylesheet" href="/css/common.css" type="text/css">
<link rel="stylesheet" href="/css/pop.css" type="text/css">

<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>
<script src="/js/common.js"></script>

<script type="text/javaScript" language="javascript" defer="defer">
window.focus();
function fn_closeLayer(tf, day){
	if(!tf) return;
	gfn_setCookie("dpPopInfo", "done", day);
	this.close();
}


</script>

	
</head>
<body>

<div id="info_popup">
	<header>
		<h1>[알림]이용문의 안내</h1>
	</header>
	<div id="info_container">
		<div class="info_content">
			<p style="line-height:180%">
			<strong>
				지급관리시스템 오픈 첫날 사용문의 전화가 폭주하여 콜센터 및 담당팀의 연결이 <br/>원활하지 않습니다.<br />
				간단한 문의는<span style="color:#FF0000"> 로그인 후 정보관리 &#62; 게시판 &#62; 문의/답변</span>에 문의하실 내용과 <br/>
				연락처를 남겨주시면 답변 드리겠습니다. 
				</strong>
			</p>
			<br /><br />
			<p>안정적인 서비스 운영을 위해 최선을 다 하겠습니다.</p>
			
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