<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
 /**
  * @Class Name : layout.jsp
  * @Description : jsp레이아웃
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
<title>data Access Fail Error</title>

<link rel="stylesheet" href="/css/basic.css" type="text/css">
<link rel="stylesheet" href="/css/common.css" type="text/css">


<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>
<script src="/js/common.js" ></script>

<%
	String reqUrl = (request.getAttribute("javax.servlet.error.request_uri") == null) ? "" : request.getAttribute("javax.servlet.error.request_uri").toString();
	if(!reqUrl.equals("")) reqUrl = reqUrl.replaceAll("<", "");
%>

<script type="text/javaScript" language="javascript" defer="defer">
$(document).ready(function(){
	var errUrl = "<%=reqUrl%>";
	if(gfn_mobileCheck() || errUrl.indexOf("EPMO")>-1) location.href = "/common/error_m.jsp";
});
</script>

	
</head>
<body>

<div id="skipNavi">
</div>

<div id="wrap">
	<header>
	</header>
	
	<div id="container">
		<div class="left_ct">
		</div>
		<div id="contents" style="text-align:center;padding:20px">
			<h3>dataAccess fail Error</h3>
			<p class="error_txt"><a href="javascript:kora.common.gfn_MoveUrl('/MAIN.do');"><img src="/images/img_error.png" alt="현재 페이지를 찾을 수 없습니다." /></a></p>
		</div>	<!-- //contents -->
	</div>		<!-- //container -->
	
	<footer id="footer">

	</footer>
</div>
</body>
</html>
	