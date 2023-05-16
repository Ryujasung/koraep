<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>session error</title>

<link rel="stylesheet" type="text/css" href="/rMateGrid/rMateGridH5/Assets/rMateH5.css"/>
<script type="text/javascript" src="/rMateGrid/LicenseKey/rMateGridH5License.js"></script>	<!-- rMateGridH5 라이센스 -->
<script language="javascript" type="text/javascript" src="/rMateChart/LicenseKey/rMateChartH5License.js"></script>
<script type="text/javascript" src="/rMateGrid/rMateGridH5/JS/rMateGridH5.js"></script>		<!-- rMateGridH5 라이브러리 -->
<script type="text/javascript" src="/rMateGrid/rMateGridH5/JS/jszip.min.js"></script>
<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>
<script src="/js/jquery/jquery-ui.js"></script>
<script src="/js/jquery/jquery.ui.datepicker-ko.js"></script>

<script src="/js/kora/kora_common.js?v=<%=System.currentTimeMillis() %>"></script>
<script src="/common/js/pub.plugin.js?v=<%=System.currentTimeMillis() %>"></script>

<%
	String reqUrl = (request.getAttribute("javax.servlet.error.request_uri") == null) ? "" : request.getAttribute("javax.servlet.error.request_uri").toString();
	if(!reqUrl.equals("")) reqUrl = reqUrl.replaceAll("<", "");
%>

<script type="text/javaScript" language="javascript" defer="defer">
$(document).ready(function(){
 	alert('세션이 만료되었습니다. 다시 로그인 후 시도해 주세요.');
	window.open('', '_self', '');
	window.opener.location.href="/MAIN.do";
	window.close();
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
			<img src="/images/img_error.png" alt="세션이 만료되었습니다." />
		</div>	<!-- //contents -->
	</div>		<!-- //container -->
	
	<footer id="footer">
	</footer>
</div>
</body>
</html>