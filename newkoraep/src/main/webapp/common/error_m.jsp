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
<title>레이아웃</title>

<link rel="stylesheet" href="/css/m_basic.css" type="text/css">
<link rel="stylesheet" href="/css/m_common.css" type="text/css">


<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>
<script src="/js/kora/main_common.js" ></script>


<script type="text/javaScript" language="javascript" defer="defer">
//오류 페이지 처리
function fn_confirm(){
	/*
	var url = "/MAIN_M.do";
	var mbrSeCd = gfn_getCookie("MBR_SE_CD");
	if(mbrSeCd == "A"){//센터
		url = "/EPMO/EPMOCRDP.do";	//모바일 실태조사 페이지로
	}else if(mbrSeCd == "B"){	//생산자는 B 
		url = "/EPMO/EPMOSLDP.do";	//모바일 입고목록 페이지로
	}
	
	kora.common.gfn_MoveUrl(url);
	*/
}

</script>

</head>

<body class="sub_bg">
<div id="wrap"> 
	<header id="header">
		<h1>입고정보조회</h1>
		<p class="log"><a href="/USER_LOGOUT_M.do">로그아웃</a></p>
		<a href="javascript:fn_confirm();" class="back_btn">뒤로가기</a>
	</header>
	
	<div id="container">	
		<div id="content">
			<a href="javascript:fn_confirm();">
			<p class="error_txt">현재 페이지를 찾을 수 없습니다.</p>
			</a>
		</div><!--//content-->
	
	</div><!--//container-->
</div>
</body>
</html>
