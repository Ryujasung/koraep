<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html style="overflow: auto">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=1100, user-scalable=no">
<meta name="description" content="사이트설명">
<meta name="keywords" content="사이트검색키워드">
<meta name="author" content="Newriver">
<meta property="og:title" content="공유제목">
<meta property="og:description" content="공유설명">
<meta property="og:image" content="공유이미지 800x400">
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />

<title>메인</title>
<link rel="stylesheet" href="/common/css/slick.css">
<link rel="stylesheet" href="/common/css/common.css">
<script src="/common/js/jquery-1.11.1.min.js"></script>
<script src="/common/js/mobile-detect.min.js"></script>
<script src="/common/js/slick.js"></script>
<script src="/common/js/pub.plugin.js"></script>
<script src="/common/js/pub.common.js"></script>
<script src="/js/kora/main_common.js"></script>

<script type="text/javaScript" language="javascript" defer="defer">

	var ttObject;
	var bizrTpCd = "<c:out value='${BIZR_TP_CD}' />";
	
    $(function() {
    	
    	ttObject = jsonObject($("#ttObject").val());
		
		var bizrnm = "<c:out value='${BIZRNM}' />";
		var user_nm = "<c:out value='${USER_NM}' />";
		var ath_grp_nm = "<c:out value='${ATH_GRP_NM}' />";

		$("#USER_NM_MAIN").text(user_nm+" 님 ("+ath_grp_nm+")"); 
		$("#BIZRNM_MAIN").text(bizrnm); 

   	 });
	
	function fn_text(str){
		return ttObject[str];
	} 
	
	function main_page(){
		if(gfn_getCookie("kora_mm") != "done"){
			var options = {
					alertText : "메인 화면으로 이동 시 실행된 모든 탭이 종료됩니다. 계속 진행하시겠습니까?",
					func : 'main_move',
					type : 'confirm'
				}
			
			NrvPub.AjaxPopup('/common/alert.html', '', options);
		}else{
			main_move();
		}
	}
	
	function main_move(){
		location.href="/MAIN.do";
	}
	
</script>

<style type="text/css">
 #USER_NM_MAIN , #BIZRNM_MAIN {
	display: block;
    padding: 0 0 0 20px;
    font-weight: 700;
    font-size: 14px;
    line-height: 30px;
    color: #444444;
 }
 
 /*
 #container {display: table; table-layout: fixed; position: relative; width: 100%; margin: 0 0 0 -180px; padding: 152px 180px 0 0; transition: all .3s;}
.main #container {padding: 66px 180px 0 0;}
*/

#contents:before {display: block; content: ''; position: absolute; top: 86px; right: 0; left: 0; height: 50px; background: #ffffff;}
.main #contents:before {top: 0;}

</style>

</head>

<input type="hidden" id="ttObject" value="<c:out value='${ttObject}' />" />

<body style="overflow: auto">
	<div id="wrap" class="topbannerClose" >
		<header id="header">
		<div id="topbanner">
			<div class="inner" id="alarmDivTop">
			</div>
		</div>
		<div class="hd_outer">
			<div class="hd_inner">
				<h1 class="logo">
					<a href="javascript:main_page()" id="main" style="width: 150px"><img src="../../images/common/logo.png" alt="KORA 한국순환자원유통지원센터"></a>
				</h1>
				<div class="util" style="right: 46px;">
					<ul class="menu" id="submenu">
						<li id='USER_NM_MAIN' ></li>
						<li id='BIZRNM_MAIN' ></li>
						<li class="logout"><a href="/USER_LOGOUT.do">로그아웃</a></li>
						<li class="mypage" id="myLnk"></li>
						<li class="admin" id="adminLnk"></li>
						<!-- <li class="cscenter"><a href="#self">고객지원</a></li> -->
					</ul>
					
					<div class="alarm_wrap">
						<a href="#self" class="alarm" id="alarmCnt"></a>
						<div class="layer" id="alarmDiv">
						</div>
					</div>
					
				</div>
			</div>
			<!-- <nav id="gnb" class="gnb">
				<button type="button" id="gnb_trg" class="gnb_trg"><span>전체메뉴</span></button>
				<div id="gnbNavi" class="navi">
				</div>
			</nav> -->
			<div id="sub_gnb" class="sub_gnb">
				<ul  style="width: 100%;">		
					<li class="i1"><a id="EPRT90" href="/RT/EPRT9025801.do" pagetitle="반환정보조회"><span class="cate">반환정보조회</span></a></li>
					<li class="i2"><a id="EPRT90" href="/RT/EPRT9025831.do" pagetitle="반환내역서등록"><span class="cate">반환내역서등록</span></a></li>
					<li class="i5"><a id="EPRT90" href="/RT/EPRT9071301.do" pagetitle="입금내역조회"><span class="cate">입금내역조회</span></a></li>
					<li class="i4"><a id="EPRT90" href="/RT/EPRT9017301.do" pagetitle="반환업무설정"><span class="cate">반환업무설정</span></a></li>
				</ul>
			</div>
			
		</div>
	</header>
	
		<div id="containerMain" style="margin: 0; padding: 86px 0 0 0; display:block">
			<div id="main">
				<div class="mainstat">
					<div class="gree">
						<p class="txt">자원순환보증금관리센터</p>
						<p class="txt2">빈용기보증금 및<br>취급수수료 지급관리시스템</p>
						<p class="txt3">KORA</p>
						<div class="btns">
							<a href="#self" class="btn1">소매거래처 관리</a>
							<a href="#self" class="btn2">거래 직매장/공장 관리</a>
						</div>
					</div>
					<div class="stat">
						<a id="EPCE29" href="/CE/EPCE2925801.do" pagetitle="회수정보관리">
						<dl class="stat1">
							<dt>회수현황</dt>
							<dd>
								<div class="val">69,846,210</div>
								<div class="unit">합계(개)</div>
							</dd>
						</dl>
						</a>
						<a id="EPCE23" href="/CE/EPCE2371301.do" pagetitle="지급내역조회">
						<dl class="stat2">
							<dt>회수현황</dt>
							<dd>
								<div class="val">69,846,218</div>
								<div class="unit">합계(개)</div>
							</dd>
						</dl>
						</a>
					</div>
				</div>
				<div class="mainsect">
					<div class="hgroup">
						<div class="tit">KORA<br><strong>빠른메뉴</strong></div>
						<div class="txt">현재 누적된 현황을<br>한눈에 알아보실 수 있습니다.</div>
					</div>
					<div class="content">
						<div class="main_tbl">
							<div class="title">지급확인<br><a href="#self" class="more">more</a></div>
							<table>
								<colgroup>
									<col style="width: 25%;">
									<col style="width: 25%;">
									<col style="width: 25%;">
									<col style="width: auto;">
								</colgroup>
								<thead>
									<tr>
										<th>지급예정일</th>
										<th>상태</th>
										<th>이체일시</th>
										<th>지급금액(원)</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>2017-10-07</td>
										<td>지급예정</td>
										<td>2017-12-12</td>
										<td class="ta_r pr30 em_01">10,652,946</td>
									</tr>
									<tr>
										<td>2017-10-07</td>
										<td>연계전송</td>
										<td>2017-12-12</td>
										<td class="ta_r pr30 em_01">46,953,264</td>
									</tr>
									<tr>
										<td>2017-10-07</td>
										<td>지급확인</td>
										<td>2017-12-12</td>
										<td class="ta_r pr30 em_01">65,975,155</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="main_tbl">
							<div class="title">지급확인<br><a href="#self" class="more">more</a></div>
							<table>
								<colgroup>
									<col style="width: 25%;">
									<col style="width: 25%;">
									<col style="width: 25%;">
									<col style="width: auto;">
								</colgroup>
								<thead>
									<tr>
										<th>반환등록일자</th>
										<th>생산자</th>
										<th>반환량(개)</th>
										<th>상태</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>2017-10-07</td>
										<td>(주)한라산</td>
										<td class="ta_r pr15">6,549,195,659</td>
										<td class="em_01">지급예정</td>
									</tr>
									<tr>
										<td>2017-10-07</td>
										<td>하이트진로(주)</td>
										<td class="ta_r pr15">126,549,874</td>
										<td class="em_01">연계전송</td>
									</tr>
									<tr>
										<td>2017-10-07</td>
										<td>오비맥주(주)</td>
										<td class="ta_r pr15">146,201,600</td>
										<td class="em_01">지급확인</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<div class="mainsect">
					<div class="hgroup">
						<div class="tit">반환 업무<br><strong>가이드</strong></div>
						<div class="txt">쉽게 등록하고 쉽게 관리하세요</div>
					</div>
					<div class="content">
						<div class="main_guide">
							<ul>
								<li class="g1">
									<a href="#self">
										<div class="tit">회수정보등록하기</div>
										<div class="btn"><span>메뉴얼보기</span></div>
									</a>
								</li>
								<li class="g2">
									<a href="#self">
										<div class="tit">회수정보관리하기</div>
										<div class="btn"><span>메뉴얼보기</span></div>
									</a>
								</li>
								<li class="g3">
									<a href="#self">
										<div class="tit">반환내역서등록하기</div>
										<div class="btn"><span>메뉴얼보기</span></div>
									</a>
								</li>
								<li class="g4">
									<a href="#self">
										<div class="tit">입고정보조회하기</div>
										<div class="btn"><span>메뉴얼보기</span></div>
									</a>
								</li>
								<li class="g5">
									<a href="#self">
										<div class="tit">실태조사하기</div>
										<div class="btn"><span>메뉴얼보기</span></div>
									</a>
								</li>
								<li class="g6">
									<a href="#self">
										<div class="tit">입고정정확인하기</div>
										<div class="btn"><span>메뉴얼보기</span></div>
									</a>
								</li>
							</ul>
						</div>
					</div>
				</div>
				<div class="mainsect">
					<div class="hgroup">
						<div class="tit">KORA<br><strong>정보관리</strong></div>
						<div class="txt">거래처관리와 직매장/공장조회<br>메뉴로 바로 이동 하실 수 있습니다.</div>
					</div>
					<div class="content">
						<div class="main_info">
							<ol>
								<li class="i1">
									<a href="#self">
										<div class="num">01</div>
										<div class="tit">소매거래처<br>관리</div>
										<div class="txt">관리거래처<br>정보를 수정하실 수 있습니다.</div>
									</a>
								</li>
								<li class="i2">
									<a href="#self">
										<div class="num">02</div>
										<div class="tit">거래 직매장<br>/공장 관리</div>
										<div class="txt">직매장/공장을 조회및<br>정보 수정을 하실 수 있습니다.</div>
									</a>
								</li>
							</ol>
						</div>
					</div>
				</div>
				<div class="mainsect">
					<div class="hgroup">
						<div class="tit">KORA<br><strong>공지사항</strong></div>
						<div class="txt">KORA의 소식을<br>전해드립니다.</div>
					</div>
					<div class="content">
						<div class="main_notice">
							<ul>
								<li>
									<a href="#self">
										<div class="cate">NOTICE</div>
										<div class="tit">지급관리시스템 시험운영 지급관리시스템 시험운영</div>
										<div class="txt">법 시행(`16.1.21) 이전까지 회원가입 및 API등 단위업무 테스트, 시스템 보완 등법 시행(`16.1.21) 이전까지 회원가입 및 API등 단위업무 테스트, 시스템 보완 등</div>
										<div class="date">2017-02-20</div>
									</a>
								</li>
								<li>
									<a href="#self">
										<div class="cate">NOTICE</div>
										<div class="tit">KORA 웹 사이트 오픈</div>
										<div class="txt">법 시행(`16.1.21) 이전까지 회원가입 및 API등 단위업무 테스트, 시스템 보완 등법 시행(`16.1.21) 이전까지 회원가입 및 API등 단위업무 테스트, 시스템 보완 등</div>
										<div class="date">2017-12-12</div>
									</a>
								</li>
								<li>
									<a href="#self">
										<div class="cate">MISSION BOARD</div>
										<div class="tit">회원정보 수정관련 공지</div>
										<div class="txt">법 시행(`16.1.21) 이전까지 회원가입 및 API등 단위업무 테스트, 시스템 보완 등법 시행(`16.1.21) 이전까지 회원가입 및 API등 단위업무 테스트, 시스템 보완 등</div>
										<div class="date">2017-12-12</div>
									</a>
								</li>
								<li>
									<a href="#self">
										<div class="cate">NOTICE</div>
										<div class="tit">출고/입고 비율조회방법</div>
										<div class="txt">법 시행(`16.1.21) 이전까지 회원가입 및 API등 단위업무 테스트, 시스템 보완 등법 시행(`16.1.21) 이전까지 회원가입 및 API등 단위업무 테스트, 시스템 보완 등</div>
										<div class="date">2017-12-12</div>
									</a>
								</li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div><!-- end : id : container -->
		
		<div id="container" class="asideOpen" style="display:none;padding-top:136px">
			<aside id="aside">
				<div class="inner">
					<button type="button" class="trigger" onclick="$('#container').toggleClass('asideOpen');">좌측메뉴	여닫이 버튼</button>
					<div class="hgroup"></div>	<!-- 메인메뉴 -->
					<nav id="lnb" class="lnb"></nav>
				</div>
			</aside>
			<div id="contents">
				<div class="conbody">
					<div id="pagenavi">
						<div class="inner"></div>
					</div>
					<div id="iframe_wrap"></div>
					<!-- <div id="navicont"></div> -->
				</div>	<!-- end of conbody -->
			</div><!-- end of contents -->
		</div><!-- end of  container --> 
		
		<%@include file="/jsp/include/footer.jsp" %>
		
	</div>	<!-- end of  wrap-->
	
</body>
</html>