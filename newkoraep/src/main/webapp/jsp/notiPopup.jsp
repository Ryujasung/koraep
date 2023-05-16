<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
 /**
  * @Class Name : notiPopup.jsp
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
<title>빈용기보증금 및 취급수수료 지급 안내</title>

<link rel="stylesheet" href="/css/basic.css" type="text/css">
<link rel="stylesheet" href="/css/common.css" type="text/css">
<link rel="stylesheet" href="/css/pop.css" type="text/css">

<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>
<script src="/js/common.js"></script>

<script type="text/javaScript" language="javascript" defer="defer">
window.focus();
function fn_closeLayer(tf){
	if(!tf) return;
	gfn_setCookie("dpPop2", "done");
	this.close();
}

</script>

	
</head>
<body>

<div id="info_popup">
	<header>
		<h1>빈용기보증금 및 취급수수료 지급 안내</h1>
	</header>
	<div id="info_container">
		<div class="info_content">
			<p><strong>
				빈용기보증금과 취급수수료 지급은 생산자에게 빈용기를 반환하고 생산자가 확인한 <br/>날짜를 기준으로
				고지서가 생산자에게 발부되며, 수납이 되면 해당 보증금과 취급수수료가 지급됩니다. </strong>
			</p>
			<br/>
			<p>
				<strong>
				생산자의 수납이 늦어질 경우 보증금 또는 취급수수료 지급 등이 지연될 수 있음을 알려 드립니다.
				</strong>
			</p>
		</div>
	</div>
	<div class="close_box">
		<p class="today">
			<input type="checkbox" id="close_today" onclick="fn_closeLayer(this.checked);">
			<label for="close_today">오늘 하루 보지 않기</label>
		</p>
		<p class="close"><a href="javascript:self.close();">닫기</a></p>
	</div>
</div>


</body>
</html>