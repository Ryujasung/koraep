<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>common error</title>

<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>
<script src="/js/kora/main_common.js" ></script>

<%
	String reqUrl = (request.getAttribute("javax.servlet.error.request_uri") == null) ? "" : request.getAttribute("javax.servlet.error.request_uri").toString();
	if(!reqUrl.equals("")) reqUrl = reqUrl.replaceAll("<", "");
%>

<script type="text/javaScript" language="javascript" defer="defer">
$(document).ready(function(){
	var errUrl = "<%=reqUrl%>";
	//if(gfn_mobileCheck() || errUrl.indexOf("EPMO")>-1) location.href = "/common/error_m.jsp";	
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
		<div id="contents" style="text-align:center;padding:20px">
			<img src="/images/img_error.png" alt="현재 페이지를 찾을 수 없습니다." />
		</div>	<!-- //contents -->
	</div>		<!-- //container -->
	
	<footer id="footer">
	</footer>
</div>
</body>
</html>