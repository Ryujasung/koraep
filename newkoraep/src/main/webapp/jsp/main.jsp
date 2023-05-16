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

<link href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js" ></script>

<script type="text/javascript" src="https://code.jquery.com/ui/1.12.1/jquery-ui.js" ></script>


<script type="text/javaScript" language="javascript" defer="defer">

	var ttObject;
	var bizrTpCd = "<c:out value='${BIZR_TP_CD}' />";

	$(function() {
	    $("#EPCE61").sortable();
	    $("#EPCE61").disableSelection();
	    $("#EPCE67").sortable();
	    $("#EPCE67").disableSelection();
	});

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
				<div class="util">
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
			<nav id="gnb" class="gnb">
				<button type="button" id="gnb_trg" class="gnb_trg"><span>전체메뉴</span></button>
				<div id="gnbNavi" class="navi">
				</div>
			</nav>
			
		</div>
	</header>
		<div id="containerMain" style="margin: 0; padding: 0; display:block">
			<div id="main">
				<div class="mainstat">
					<div class="gree">
						<p class="txt">자원순환보증금관리센터</p>
						<p class="txt2">빈용기보증금 및<br>취급수수료 지급관리시스템</p>
						</br></br></br></br></br></br></br>
						<div class="btns">
							<a id="EPCE23" href="/CE/EPCE2351901.do" pagetitle="보증금고지서발급" class="btn1">고지서발급</a>
							<a id="EPCE23" href="/CE/EPCE2346301.do" pagetitle="수납확인" class="btn2">수납확인</a>
						</div>
					</div>
					<div class="stat">
						<a id="EPCE61" href="/CE/EPCE6101501.do" pagetitle="출고현황">
						<dl class="stat1">
							<dt>출고현황</dt>
							<dd>
								<div class="val" id="DLIVY_CNT"></div>
								<div class="unit">합계(개)</div>
							</dd>
						</dl>
						</a>
						<a id="EPCE61" href="/CE/EPCE6110401.do" pagetitle="입고현황">
						<dl class="stat2">
							<dt>입고현황</dt>
							<dd>
								<div class="val" id="CFM_CNT"></div>
								<div class="unit">합계(개)</div>
							</dd>
						</dl>
						</a>
					</div>
				</div>
				<div class="mainsect">
					<div class="hgroup">
						<div class="tit">게시판</div>
					</div>
					<div class="content">
						<div class="main_tbl">
							<div class="title">공지사항<br><a id="EPCE81" href="/CE/EPCE8149001.do" pagetitle="공지사항" class="more">more</a></div>
							<table >
								<colgroup>
									<col style="width: 75%;">
									<col style="width: auto;">
								</colgroup>
								<thead>
									<tr>
										<th>제목</th>
										<th>일자</th>
									</tr>
								</thead>
								<tbody id="NOTI_LIST">
								</tbody>
							</table>
						</div>
						<div class="main_tbl">
							<div class="title">문의/답변<br><a id="EPCE81" href="/CE/EPCE8126601.do" pagetitle="문의/답변" class="more">more</a></div>
							<table>
								<colgroup>
									<col style="width: 75%;">
									<col style="width: auto;">
								</colgroup>
								<thead>
									<tr>
										<th>제목</th>
										<th>일자</th>
									</tr>
								</thead>
								<tbody id="ASK_LIST">
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<div class="mainsect">
					<div class="hgroup">
						<div class="tit">업무바로가기</div>
					</div>
					<div class="content">
						<div class="main_guide">
							<ul>
								<li class="g3">
									<a id="EPCE23" href="/CE/EPCE2371201.do" pagetitle="취급수수료고지서발급" >
										<div class="tit">취급수수료고지서발급</div>
										<div class="btn"><span>메뉴얼보기</span></div>
									</a>
								</li>
								<li class="g4">
									<a id="EPCE23" href="/CE/EPCE2346301.do" pagetitle="수납확인" >
										<div class="tit">수납확인</div>
										<div class="btn"><span>메뉴얼보기</span></div>
									</a>
								</li>
								<li class="g6">
									<a id="EPCE23" href="/CE/EPCE2350901.do" pagetitle="지급정보생성" >
										<div class="tit">지급정보생성</div>
										<div class="btn"><span>메뉴얼보기</span></div>
									</a>
								</li>
								<li class="g1">
									<a id="EPCE47" href="/CE/EPCE4792901.do" pagetitle="교환정산" >
										<div class="tit">교환정산</div>
										<div class="btn"><span>메뉴얼보기</span></div>
									</a>
								</li>
								<li class="g2">
									<a id="EPCE61" href="/CE/EPCE6198401.do" pagetitle="출고대비초과회수현황" >
										<div class="tit">출고대비초과회수현황</div>
										<div class="btn"><span>메뉴얼보기</span></div>
									</a>
								</li>
								<li class="g5">
									<a id="EPCE01" href="/CE/EPCE0160101.do" pagetitle="사업자관리" >
										<div class="tit">사업자관리</div>
										<div class="btn"><span>메뉴얼보기</span></div>
									</a>
								</li>
							</ul>
						</div>
					</div>
				</div>
				<div class="mainsect">
					<div class="hgroup">
						<div class="tit">정산관리</div>
					</div>
					<div class="content">
						<div class="main_info">
							<ol>
								<li class="i1">
									<a id="EPCE47" href="/CE/EPCE4759401.do" pagetitle="출고정정" >
										<div class="num">01</div>
										<div class="tit">출고정정</div>
									</a>
								</li>
								<li class="i2">
									<a id="EPCE47" href="/CE/EPCE4791401.do" pagetitle="정산기간관리" >
										<div class="num">02</div>
										<div class="tit">정산기간관리</div>
									</a>
								</li>
							</ol>
						</div>
					</div>
				</div>
			</div>
		</div><!-- end : id : container -->
		
		<div id="container" class="asideOpen" style="display:none">
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