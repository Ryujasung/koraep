<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>첨부이미지 미리보기</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

$(document).ready(function(){
	var imgSrc = decodeURI("${imgSrc}");
	var imgNm = "${imgNm}";
	
	imgSrc = imgSrc.substring(imgSrc.indexOf("data_file")-1);
	
	$("#att_list").append('<dt>' + imgNm + '</dt>');
	$("#att_list").append('<dd class="fileImage"><img src="' + imgSrc + '" style="width:100%" alt="' + imgNm + '"/></dd>');
});

</script>

</head>
<body>
    	<div class="layer_popup" style="width:600px; margin-top: -317px" >
				<div class="layer_head">
					<h1 class="layer_title" id="title_sub">첨부 이미지</h1>
					<button type="button" class="layer_close" layer="close"  >팝업닫기</button>
				</div>
			   	<div class="layer_body">
						<dl class="proof" id="att_list" style="margin:0 auto;"></dl>		
				</div>
		</div>
</body>
</html>