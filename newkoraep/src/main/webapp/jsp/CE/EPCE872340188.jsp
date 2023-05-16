<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="/common/css/common.css"/>
<link rel="stylesheet" href="/common/css/slick.css">

</head>

<style type="text/css">

	.srcharea .row .col .tit{
	width: 117px;
	}

</style>

<script>

$(document).ready(function(){
	
});

//취소
function fn_cncl(){
	$('[layer="close"]').trigger('click');
	return false;
}

//휴대폰 인증구분 임의정의 - 대표자인증 : REPSNT, 관리자 인증 : ADMIN, 패스워드변경 : CNPC  추가정보에서 사용
function fn_memReg(){
    
	location.href = "/EP/EPCE0085201.do" + "?_csrf=" + '<c:out value='${_csrf.token}' />';
}


</script>

	<body>
		<!-- 휴대폰 인증구분 임의정의 - 대표자인증 : REPSNT, 관리자 인증 : ADMIN, 패스워드변경 : CNPC  추가정보에서 사용 -->
		<input type="hidden" name="CERT_DIV" id="CERT_DIV" value="CNPC" />
	
		<div class="layer_popup" style="width:700px;">
			<div class="layer_head">
				<h1 class="layer_title">회원가입 알림창</h1>
				<button type="button" class="layer_close" layer="close">팝업닫기</button>
			</div>
			<div class="layer_body">
				<div class="secwrap" id="divInput_P">
					<div class="srcharea" >
						<h3>회원가입 알림입니다.</h3>
					</div>
					
							
					<section class="btnwrap mt10">
						<div class="btn" style="float:right">
							<button type="button" class="btn36 c1" style="width: 100px;" onclick="fn_cncl()" >취소</button>
							<button type="button" class="btn36 c3" style="width: 100px;" onclick="fn_memReg()" >가입하기</button>
						</div>
					</section>
					
				</div>
			</div>
	</div>
</body>
</html>