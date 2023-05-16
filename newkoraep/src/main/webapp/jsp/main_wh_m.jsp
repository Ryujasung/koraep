<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=1100, user-scalable=yes">
	<meta name="description" content="사이트설명">
	<meta name="keywords" content="사이트검색키워드">
	<meta name="author" content="Newriver">
	<meta property="og:title" content="공유제목">
	<meta property="og:description" content="공유설명">
	<meta property="og:image" content="공유이미지 800x400">
	<title>COSMO 자원순환보증금관리센터</title>

<%@include file="/jsp/include/common_page_m.jsp" %>
<script src="/js/kora/main_common_m.js"></script>
<script>
	
	var ttObject;
	var INQ_PARAMS;	//파라미터 데이터

	$(document).ready(function(){
		INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());		//파라미터 데이터
		
		// 바로가기 메뉴 클릭시 권한 체크후 이동
		$( ".mainguide a" ).click(function() {
			var menuCd = (($(this).attr("val") == "EPWH2910131") ? "EPWH2910101" : $(this).attr("val"));// 반환관리 권한이 있다면 반환내역서등록 권한도 있다고 판단
			var mmObject 	= jsonObject($("#mmObject").val());
			var menuUrl = "";
			
			$.each(mmObject, function(i, v){
	    		if( v.MENU_CD == menuCd ){ menuUrl = v.MENU_URL; return false; }
			});
			
			if( menuUrl ){
				if( $(this).attr("val") == "EPWH2910131" ){
					INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
					INQ_PARAMS["URL_CALLBACK"] = "/MAIN.do";
					kora.common.goPage('/WH/EPWH2910131.do', INQ_PARAMS);
				}else{
					location.href=menuUrl;
				}
			}else{
				alert("해당 페이지의 권한이 없습니다.");
			}
			
		});

	});
	
</script>
</head>
<body>
<input type="hidden" id="INQ_PARAMS" value="{}" />
	<div id="wrap">
	
		<%@include file="/jsp/include/header_m.jsp" %>
		
		<%@include file="/jsp/include/aside_m.jsp" %>

		<div id="container">
			<div id="main">
				<div class="mainstat">
					<div class="gree">
						<p class="txt">자원순환보증금관리센터</p>
						<p class="txt2">빈용기보증금 및 취급수수료<br>지급관리시스템</p>
					</div>
					<div class="stat">
						<dl class="stat1">
							<dt>생산자입고확인(전일)</dt>
							<dd>
								<div class="val"><spen id="RTRVL_CNT"></div>
								<div class="unit">합계(개)</div>
							</dd>
						</dl>
						<dl class="stat2">
							<dt>입금내역(전일)</dt>
							<dd>
								<div class="val"><spen id="PAY_AMT"></div>
								<div class="unit">합계(원)</div>
							</dd>
						</dl>
					</div>
				</div>
				<div class="mainguide">
					<ul>
						<li class="g1"><a href="#self" val="EPWH2925801">회수정보관리</a></li>
						<li class="g3"><a href="#self" val="EPWH2910101">반환관리</a></li>
						<li class="g4"><a href="#self" val="EPWH6110401">입고관리</a></li>
						<!-- <li class="g2"><a href="#self" val="EPWH2910131">반환내역서등록</a></li>						
						<li class="g5"><a href="#self" val="EPWH2371301">지급내역조회</a></li>
						<li class="g6"><a href="#self" val="">구병출고대비반환</a></li> -->
					</ul>
				</div>
				<!-- <div class="mainquick">
					<div class="main_hgroup">
						<h2 class="tit">빠른메뉴</h2>
						<a href="#self" class="more">more</a>
					</div>
					<div class="tab_type_01 mb40">
						<ul>
							<li class="on"><button type="button">지급확인</button></li>
							<li><button type="button">실태조사</button></li>
						</ul>
					</div>
					<div class="tbl_main">
						<div class="on">
							<table>
								<thead>
									<tr>
										<th>지급예정일</th>
										<th>이체일시</th>
										<th>지급금액(원)</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td class="pl25 ta_l">2017-10-07<br>(지급예정)</td>
										<td>2017-10-10</td>
										<td class="pr25 ta_r fw_700 col_01">10,652,946</td>
									</tr>
									<tr>
										<td class="pl25 ta_l">2017-10-07<br>(지급예정)</td>
										<td>2017-10-10</td>
										<td class="pr25 ta_r fw_700 col_01">10,652,946</td>
									</tr>
									<tr>
										<td class="pl25 ta_l">2017-10-07<br>(지급예정)</td>
										<td>2017-10-10</td>
										<td class="pr25 ta_r fw_700 col_01">10,652,946</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div>
							<table>
								<thead>
									<tr>
										<th>변환등록일자</th>
										<th>반환량(개)</th>
										<th>상태</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td class="pl25 ta_l">2017-10-07<br>((주)한라산)</td>
										<td class="pr25 ta_r">6,549,195,659</td>
										<td class="fw_700 col_01">지급예정</td>
									</tr>
									<tr>
										<td class="pl25 ta_l">2017-10-07<br>((주)한라산)</td>
										<td class="pr25 ta_r">6,549,195,659</td>
										<td class="fw_700 col_01">지급예정</td>
									</tr>
									<tr>
										<td class="pl25 ta_l">2017-10-07<br>((주)한라산)</td>
										<td class="pr25 ta_r">6,549,195,659</td>
										<td class="fw_700 col_01">지급예정</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<div class="maininfo">
					<div class="main_hgroup">
						<h2 class="tit">정보관리</h2>
					</div>
					<div class="content">
						<a href="#self">
							<div class="tit">소매거래처 관리</div>
							<div class="txt">관리거래처<br>정보를 수정하실 수 있습니다.</div>
						</a>
					</div>
				</div>
				<div class="mainnotice">
					<div class="main_hgroup">
						<h2 class="tit">공지사항</h2>
						<a href="/WH/EPWH8149001.do" class="more">more</a>
					</div>
					<ul id="NOTI_LIST">
						<li>
							<div class="tit">
								<a href="#self">지급관리시스템 시험 운영 일정 공지 드립니다. 시스템 관련 운영 테스트</a>
							</div>
							<div class="date">2018-04-30</div>
						</li>
						<li>
							<div class="tit">
								<a href="#self">KORA 웹 사이트 오픈</a>
							</div>
							<div class="date">2018-04-30</div>
						</li>
						<li>
							<div class="tit">
								<a href="#self">회원정보 수정관련 공지</a>
							</div>
							<div class="date">2018-04-30</div>
						</li>
					</ul>
				</div> -->
			</div><!-- id : main -->

		</div><!-- id : container -->

		<footer id="footer">
			<div class="ft_menu">
				<!-- <ul>
					<li><a href="#self">이용약관</a></li>
					<li><a href="#self">개인정보처리방침</a></li>
				</ul> -->
			</div>
			<div class="ft_cscenter"><strong>고객센터 1522-0082</strong> (운영시간  평일 09:00 ~ 18:00)</div>
			<address class="address">
				03149 서울특별시 종로구 인사동7길 12, 자원순환보증금관리센터(백상빌딩 10층)<br>
				TEL : 1522-0082&nbsp;&nbsp;&nbsp;&nbsp;FAX : 02-6455-1695
			</address>
			<p class="copyright">COPYRIGHT 2021 COSMO.OR.KR ALL RIGHT RESERVED.</p>
		</footer>
		
	</div><!-- id : wrap -->
</body>
</html>