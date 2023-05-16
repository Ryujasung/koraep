<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
 /**
  * @Class Name : closePopup.jsp
  * @Description : 팝업 세션 종료 처리
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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>연결종료</title>

<link rel="stylesheet" href="/css/basic.css" type="text/css">
<link rel="stylesheet" href="/css/common.css" type="text/css">
<link rel="stylesheet" href="/css/pop.css" type="text/css">

<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>
<script src="/js/common.js"></script>

<script type="text/javaScript" language="javascript" defer="defer">
$(document).ready(function(){
	alert("접속 시간이 종료 되었습니다.\n다시 로그인 후 사용하시기 바랍니다.");
	
	var url = "/MAIN.do";
	var tf = false;
    var uAgent = navigator.userAgent.toLowerCase();	// Mobile여부를 구분하기 위함  

    // 아래는 모바일 장치들의 모바일 페이지 접속을위한 스크립트
    var mobilePhones = new Array('iphone', 'ipod', 'ipad', 'android', 'blackberry', 'windows ce','nokia', 'webos', 'opera mini', 'sonyericsson', 'opera mobi', 'iemobile');
    for (var i = 0; i < mobilePhones.length; i++){
    	 if (uAgent.indexOf(mobilePhones[i]) != -1){
    		 tf = true;
    		 break;
    	 }
    }
    
    if(tf) url = "/MAIN_M.do";
	opener.location.href = url;
	self.close();
});
</script>

	
</head>
<body>
<div id="pop_wrap" >
	<header>
		<h1>거래 생산자 등록</h1>
	</header>
	<div id="pop_container">
		<div class="pop contents">
		접속종료
		</div>
	</div>
</div>

</body>
</html>