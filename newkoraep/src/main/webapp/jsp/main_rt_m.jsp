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
	<title>KORA 자원순환보증금관리센터</title>

<%@include file="/jsp/include/common_page_m.jsp" %>

</head>
<body>
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
							<dt>회수현황</dt>
							<dd>
								<div class="val">69,846,210</div>
								<div class="unit">합계(개)</div>
							</dd>
						</dl>
						<dl class="stat2">
							<dt>회수현황</dt>
							<dd>
								<div class="val">69,846,218</div>
								<div class="unit">합계(개)</div>
							</dd>
						</dl>
					</div>
				</div>
				<div class="mainguide">
					<ul>
						<li class="g1"><a href="#self">회수정보관리</a></li>
						<li class="g2"><a href="#self">반환내역서등록</a></li>
						<li class="g3"><a href="#self">반환관리</a></li>
						<li class="g4"><a href="#self">입고관리</a></li>
						<li class="g5"><a href="#self">지급내역조회</a></li>
						<li class="g6"><a href="#self">구병출고대비반환</a></li>
					</ul>
				</div>
				<div class="mainquick">
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
						<a href="#self" class="more">more</a>
					</div>
					<ul>
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
				</div>
			</div><!-- id : main -->

		</div><!-- id : container -->

		<%@include file="/jsp/include/footer_m.jsp" %>
		
	</div><!-- id : wrap -->
</body>
</html>