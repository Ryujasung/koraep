<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>문의답변 상세조회</title>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=1100, user-scalable=yes">
<meta name="description" content="사이트설명">
<meta name="keywords" content="사이트검색키워드">
<meta name="author" content="Newriver">
<meta property="og:title" content="공유제목">
<meta property="og:description" content="공유설명">
<meta property="og:image" content="공유이미지 800x400">

<%@include file="/jsp/include/common_page_m.jsp" %>


<script type="text/javaScript" language="javascript" defer="defer">

var askInfo = ${askInfo};
var ansrInfo = ${ansrInfo};
var jParams = {};
var userId = gfn_getCookie("USER_ID");
//var strMbrSeCd = gfn_getCookie("MBR_SE_CD");
//var strGrpCd   = gfn_getCookie("GRP_CD"); //메뉴권한그룹 추가

$(document).ready(function(){
	
	$('#title_sub').text('<c:out value="${titleSub}" />');
	
	//버튼 셋팅
    fn_btnSetting();
	
  	//언어관리
	$('#ask').text(parent.fn_text('ask'));
	$('#asnr').text(parent.fn_text('asnr'));
	$('#bf_doc').text(parent.fn_text('bf_doc'));
	$('#nx_doc').text(parent.fn_text('nx_doc'));
	
	
	//페이지이동 조회조건 파라메터 정보
	jParams = ${INQ_PARAMS};
	
	if("Q" == askInfo[0].CNTN_SE){
		document.getElementById("sbj").innerHTML = parent.fn_text('ask')+" : " + askInfo[0].SBJ;
		/* document.getElementById("cntnSe").innerHTML = parent.fn_text('ansr') + " : "; */
		if("" != ansrInfo){
			/* document.getElementById("ansCnt").innerHTML = ansrInfo[0].SBJ; */
			
			/* document.getElementById("ansSe").innerHTML = parent.fn_text('cnts') + " : "; */
			document.getElementById("ansCnt").innerHTML = ansrInfo[0].CNTN;
			
			$('#ansDiv').attr('style','');
			$('#ansr_status').html("답변완료");
            $("#ansr_status").addClass('done');
            $("#ansr_status").removeClass('yet');
		} else {
			document.getElementById("ansCnt").innerHTML = "등록된 답변이 없습니다.";
			$('#ansr_status').html("미등록");
            $("#ansr_status").addClass('yet');
            $("#ansr_status").removeClass('done');          
			
		}
	} else if("A" == askInfo[0].CNTN_SE){
		document.getElementById("sbj").innerHTML = parent.fn_text('ansr')+" : " + askInfo[0].SBJ;
		document.getElementById("cntnSe").innerHTML = parent.fn_text('ask');
		document.getElementById("ansCnt").innerHTML = ansrInfo[0].SBJ;
	}
	
	document.getElementById("dttm").innerHTML = askInfo[0].REG_DTTM;
	/* document.getElementById("regId").innerHTML = kora.common.null2void(askInfo[0].USER_NM); */
	document.getElementById("cntn").innerHTML = askInfo[0].CNTN;
	
	/* //센터 관리자, 담당자, 시스템관리자 만 버튼보이도록 수정
	if("A" == strMbrSeCd && (strGrpCd == "A01" || strGrpCd == "A02" || strGrpCd == "Z01" || strGrpCd == "A11" || strGrpCd == "A12")){
		$("#btnAnsr").show();
	} else {
		$("#btnAnsr").hide();
	}
	
	if(("A" == strMbrSeCd && (strGrpCd == "A01" || strGrpCd == "A02" || strGrpCd == "Z01" || strGrpCd == "A11" || strGrpCd == "A12")) || userId == askInfo[0].RGST_PRSN_ID){
		$("#btnDel").show();
		$("#btnMod").show();
	} else {
		$("#btnDel").hide();
		$("#btnMod").hide();
	} */
	
	$("#btn_ansr_reg").click(function(){
		fn_ansr_reg();
	});
	
	$("#btn_upd").click(function(){
		fn_upd();
	});
	
	$("#btn_del").click(function(){
		fn_del();
	});
	
	$("#btn_lst").click(function(){
		fn_lst();
	});
	
	
});

//수정
function fn_upd(){ //이전 mod
	
	var sAction="/WH/EPWH8126642.do";
	
	//페이지이동
    var data = {"ASK_SEQ": askInfo[0].ASK_SEQ, "CNTN_SE" : askInfo[0].CNTN_SE};
    kora.common.goPageD(sAction, data, jParams);
	
}

//삭제
function fn_del(){ //이전 del
	
	confirm("문의/답변을 삭제하시겠습니까?",'fn_del_exec')
	
}

function fn_del_exec(){
		
		var sData = {"ASK_SEQ" : askInfo[0].ASK_SEQ, "CNTN_SE" : askInfo[0].CNTN_SE};
		var url = "/WH/EPWH8126695_04.do";
		
		ajaxPost(url, sData, function(rtnData){
			
			if(rtnData != null && rtnData != ""){
				alert("삭제되었습니다.",'fn_lst');
			} else {
				alert("error");
			}
			
		});
		
}

	


//상세조회링크
function fn_dtl_sel_lk(ask_seq, cntnSe){ //이전 link
	
	var sAction="/WH/EPWH8126695.do";
	
	//페이지이동
    var data = {"ASK_SEQ": ask_seq, "CNTN_SE": cntnSe};
    kora.common.goPageD(sAction, data, jParams);
	
};

//목록
function fn_lst(){ //이전 rtnList
	
	var sAction="/WH/EPWH8126601.do";
	
	//페이지이동
    kora.common.goPageD(sAction, "", jParams);
	
}

//답변 등록
function fn_ansr_reg(){
	
	var sAction="/WH/EPWH8126696.do";
	
	//페이지이동
    var data = {"ASK_SEQ": askInfo[0].ASK_SEQ, "CNTN_SE" : "A"};
	
	kora.common.goPageD(sAction, data, jParams);
	
}

</script>
</head>
<body>

<div id="wrap">

	<%@include file="/jsp/include/header_m.jsp" %>
		
	<%@include file="/jsp/include/aside_m.jsp" %>

	<div id="container">

		<div id="subvisual">
			<h2 class="tit" id="title"></h2>
		</div><!-- id : subvisual -->

		<div id="contents">
				<div class="contbox pb55">
					<div class="board_head">
						<div class="tit"><p id="sbj"></p></div>
						<div class="info_wrap mt10">
							<div class="status"><div id="ansr_status"></div></div><div class="date"><p class="date" id="dttm"></div>
						</div>
					</div>
					<div class="board_qna">
						<div class="qbox">
							<p id="cntn"></p>
						</div>
						<div class="abox">
							<div id="ansCnt" class="txt_area"></div>
						</div>
					</div>
					<div class="btn_wrap mt30">
						<div class="fl_c">
							<!-- <a href="#self" class="btn_prev">이전 글</a> -->
							<a id="btn_lst" href="#self" class="btn70 c1 ml0" style="width: 220px;">목록</a>
							<!-- <a href="#self" class="btn_next">다음 글</a> -->
						</div>
					</div>
				</div>
			</div><!-- id : contents -->

	</div><!-- id : container -->

	<%@include file="/jsp/include/footer_m.jsp" %>
	
	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="noti" /> <!-- 공지사항 첨부 다운일경우 noti, 업로드 폴더인경우 up 로 넣어준다-->
	</form>
	
</div><!-- id : wrap -->

</body>
</html>