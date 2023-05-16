<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="_csrf" content="${_csrf}" />
<meta name="_csrf_header" content="X-CSRF-TOKEN" />
<title>본인인증 확인결과</title>


<link rel="stylesheet" href="/css/basic.css" type="text/css">
<link rel="stylesheet" href="/css/common.css" type="text/css">

<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>
<script src="/js/common.js" ></script>

<script type="text/javaScript" language="javascript" defer="defer">
$(document).ready(function(){
	$(".pop_wrap").hide();
	fn_result();	//최종결과처리
});

function fn_result(){
	
// 	var _csrf = "${_csrf}"
// 	alert('1 : '+_csrf);
	
	var msg = "${msg}";
	var result = "${result}";
	var flag = true;
	if(msg != null && msg != ""){
		flag = false;
		alert(msg);	//연동오류
	}else if(result != "Y"){	// ▪“Y” : 성공 ▪ “N” : 실패 ▪ “F” : 오류 )
		flag = false;
		var str = "본인확인에 실패하였습니다.";
		if(result == "F") str = "본인확인중 오류가 발생하였습니다.";
		alert(str);
	}
	alert("본인확인에 성공하였습니다.");
	fn_close(flag);
}


function fn_close(tf){
// 	var _csrf = "${_csrf}"
// 		alert("2 : "+_csrf);
	opener.fn_kmcisResult(tf, "${plusInfo}", "${name}", "${phoneNo}");
	window.open('', '_self', '');
	window.close();
}

</script>
</head>


<body>
<div id="pop_wrap" style="display:none">


	<header>
		<h1>본인인증 수신 결과</h1>
	</header>
		
	<div id="pop_container">
		<div class="pop contents">
		</div>
	</div>	<!-- //pop_container -->
	
	
</div>
</body>
</html>