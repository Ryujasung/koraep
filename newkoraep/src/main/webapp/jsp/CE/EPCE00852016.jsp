<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="_csrf" content="<c:out value='${_csrf.token}' />" />
<meta name="_csrf_header" content="<c:out value='${_csrf.headerName}' />" />

<link rel="stylesheet" href="/common/css/common.css"/>

<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>
<script src="/js/jquery/jquery-ui.js"></script>
<script src="/js/jquery/jquery.ui.datepicker-ko.js"></script>

<script src="/common/js/jquery-1.11.1.min.js"></script>
<script src="/common/js/mobile-detect.min.js"></script>
<script src="/common/js/slick.js"></script>
<script src="/common/js/pub.plugin.js"></script>
<script src="/common/js/pub.common.js"></script>

<script src="/js/kora/kora_common.js"></script>

<script language="javascript" defer="defer">

	$(document).ready(function(){
		
		//반드시 실행..
		pub_ready();
		
	});

</script>

</head>
<body >
	<div id="wrap" style="padding:0 0 182px 40px">

		<div id="container" class="asideOpen">

			<div id="contents">
				<div class="conbody2">
					<div class="join_step">
						<ol>
							<li class="s1">약관동의</li>
							<li class="s2">사업자확인</li>
							<li class="s3">정보입력</li>
							<li class="s4 on">가입신청완료</li>
						</ol>
					</div>
					<div class="h3group">
						<h3 class="tit">가입신청완료</h3>
					</div>
					<div class="white_wrap">
						<div class="join_complete">
							<div class="inner">
								<p class="tit">감사합니다.<br><span class="c_01">회원가입이 완료</span>되었습니다.</p>
								<p class="txt">해당 사업자 <span class="c_01">관리자 승인 후</span> 사용하시기 바랍니다.</p>
								<a href="/login.do" class="btn36 c4" style="width: 166px;" >메인화면으로 이동</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div><!-- end : id : container -->

		<%@include file="/jsp/include/footer.jsp" %>
		
	</div>
</body>
</html>
