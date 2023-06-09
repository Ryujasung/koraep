<%
	response.setHeader("Pragma","no-cache");			// HTTP1.0 캐쉬 방지
	response.setDateHeader("Expires",0);				// proxy 서버의 캐쉬 방지
	response.setHeader("Pragma", "no-store");			// HTTP1.1 캐쉬 방지
	if(request.getProtocol().equals("HTTP/1.1"))
			response.setHeader("Cache-Control", "no-cache"); // HTTP1.1 캐쉬 방지
%>
<%@ page contentType = "text/html;charset=ksc5601"%>
<%@ page import = "java.util.*" %>
<%

	String rec_cert      = "";  // 결과값(암호화)
	String certNum       = "";  // certNum
	
	//취약점점검 3081 류제성
	if(request.getParameter("rec_cert").trim() != null){
		rec_cert = request.getParameter("rec_cert").trim();	
	}
	if(request.getParameter("certNum").trim() != null){
		certNum  = request.getParameter("certNum").trim();
	}
	
%>
<html>
<head>
<script type="text/javascript">
	var move_page_url = "https://devreuse2.cosmo.or.kr/kmcis_web_sample_step04.jsp";
	

	function end() {
   		var UserAgent = navigator.userAgent;
   		
   		// 결과 페이지 경로 셋팅
    	document.kmcis_form.action = move_page_url;
	
    	/* 모바일 접근 체크*/
    	// 모바일일 경우 (변동사항 있을경우 추가 필요)
    	if (UserAgent.match(/iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson/i) != null || UserAgent.match(/LG|SAMSUNG|Samsung/) != null) {
		    document.kmcis_form.submit();
	  	} 
	  
	  	// 모바일이 아닐 경우
	  	else {
			document.kmcis_form.target = opener.window.name;
		  	document.kmcis_form.submit();
   		  	self.close();
	  	}
	}
</script>
</head>
<body onload="javascript:end()">
<form id="kmcis_form" name="kmcis_form" method="post">
	<input type="hidden"	name="rec_cert"		id="rec_cert"	value="<%=rec_cert%>"/>
	<input type="hidden"	name="certNum"		id="certNum"	value="<%=certNum%>"/>
</form>
</body>
</html>