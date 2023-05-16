<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
 /**
  * @Class Name : notiPopup2.jsp
  * @Description : noti popup
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
<title>오픈브라우저 호환성 안내</title>

<link rel="stylesheet" href="/css/basic.css" type="text/css">
<link rel="stylesheet" href="/css/common.css" type="text/css">
<link rel="stylesheet" href="/css/pop.css" type="text/css">

<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>
<script src="/js/common.js"></script>

<script type="text/javaScript" language="javascript" defer="defer">
window.focus();
function fn_closeLayer(tf, day){
	if(!tf) return;
	gfn_setCookie("dpPop", "done", day);
	this.close();
}


function fn_moveFaq(){
	window.resizeTo("825", "720");
	location.href = "/EPMN/EPMNCNPF3_POP.do";
}
</script>

	
</head>
<body>

<div id="info_popup">
	<header>
		<h1>[알림 Tip] 오픈브라우저 호환성 안내</h1>
	</header>
	<div id="info_container">
		<div class="info_content">
			<p class="txt">
				빈용기보증금 및 취급수수료 지급관리시스템은<br> 
				<strong>HTML-5 표준 코드를 지원하는 인터넷 브라우저에 최적화</strong>되어 있습니다.<br> 
				<strong>인터넷 익스플로어(IE) 10버전 이하를 사용하시면 지원이 원활하지 못합니다.</strong>
			</p>
			<p class="txt">
				아래 인터넷 익스플로어(IE) 업데이트 경로를 이용하여 업데이트 하시거나<br>
				다른 브라우저(크롬, 파이어폭스, 오페라,사파리)를 설치하여 이용 부탁드립니다.<br>
				인터넷 익스플로어(IE) 버전문제로 아래 내용을 참고 하셔서 이용에 차질이 없으시길 바랍니다.
			</p>
			<div class="bro_link">
				<p class="txt">업데이트하기</p>
				<dl>
					<dt>인터넷 익스플로어(IE) - 버전 업데이트</dt>
					<dd>
						<a href="http://windows.microsoft.com/ko-kr/internet-explorer/download-ie" target="_blank">
						http://windows.microsoft.com/ko-kr/internet-explorer/download-ie</a>
					</dd>
					<dt>크롬 (Chrome) - 설치</dt>
					<dd><a href="http://www.google.com/chrome/?hl=ko" target="_blank">http://www.google.com/chrome/?hl=ko</a></dd>
					<dt>파이어 폭스(Fire Fox) - 설치</dt>
					<dd><a href="http://www.mozilla.or.kr/ko" target="_blank">http://www.mozilla.or.kr/ko</a></dd>
					<dt>오페라 (Opera) - 설치</dt>
					<dd><a href="http://www.opera.com/ko/computer" target="_blank">http://www.opera.com/ko/computer</a></dd>
					<dt></dt>
					<dd><a href="" target="_blank"></a></dd>
					<dt>사파리 (Safari) - 설치</dt>
					<dd><a href="http://www.apple.com/kr/safari" target="_blank">http://www.apple.com/kr/safari</a></dd>
				</dl>				
			</div>
		</div>
		<p class="mgT10 textR"><a href="javascript:fn_moveFaq();" class="btn_b y_green">기타 문의 FAQ바로가기</a></p>
	</div>
	<div class="close_box">
		<p class="today">
			<input type="checkbox" id="close_today" onclick="fn_closeLayer(this.checked, 1);">
			<label for="close_today">오늘 하루 보지 않기</label>
			
			<input type="checkbox" id="close_week" onclick="fn_closeLayer(this.checked, 7);">
			<label for="close_week">일주일간 보지 않기</label>
		</p>
		<p class="close"><a href="javascript:self.close();">닫기</a></p>
	</div>
</div>


</div>


</body>
</html>