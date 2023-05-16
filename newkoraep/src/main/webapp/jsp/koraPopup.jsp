<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
 /**
  * @Class Name : koraPopup.jsp
  * @Description : kora popup
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
<title>빈용기보증금제도가 새롭게 바뀝니다</title>

<link rel="stylesheet" href="/css/basic.css" type="text/css">
<link rel="stylesheet" href="/css/common.css" type="text/css">
<link rel="stylesheet" href="/css/pop.css" type="text/css">

<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>
<script src="/js/common.js"></script>

<script type="text/javaScript" language="javascript" defer="defer">
window.focus();
function fn_closeLayer(tf){
	if(!tf) return;
	gfn_setCookie("koraPop", "done");
	this.close();
}
function fn_openKora(){
	//opener.location.href = "http://me.go.kr/issue/reuse/";
	var newWindow = window.open("about:blank");
	newWindow.location.href = "http://me.go.kr/issue/reuse/";
	this.close();
}
</script>

	
</head>
<body>
<div id="pop_wrap" >
	<div class="kora_pop">
		<p><button type="button" onclick="fn_openKora();"><img src="http://www.kora.or.kr/images/UPFileFolder/popup/2015111715706.gif" alt="" /></button></p>
		<p class="todayBox">
			<input type="checkbox" id="close_today" onclick="fn_closeLayer(this.checked);">
			<label for="close_today">오늘 하루 보지 않기</label>
		</p>
		<p class="close"><a href="javascript:self.close();">닫기</a></p>
	</div>
</div>

</body>
</html>