<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>FAQ 상세조회</title>
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
var preAsk = ${preAsk};
var nextAsk = ${nextAsk};
var fileList = ${fileList};
var jParams = {};

$(document).ready(function(){

	$('#title_sub').text('<c:out value="${titleSub}" />');
	
	//버튼 셋팅
    fn_btnSetting();
	
  	//언어관리
	$('#atch_file').text(parent.fn_text('atch_file'));
	$('#bf_doc').text(parent.fn_text('bf_doc'));
	$('#nx_doc').text(parent.fn_text('nx_doc'));
	
	//페이지이동 조회조건 파라메터 정보
	jParams = ${INQ_PARAMS};
	
	document.getElementById("sbj").innerHTML = askInfo[0].SBJ;
	document.getElementById("dttm").innerHTML = askInfo[0].REG_DTTM;
	document.getElementById("cntn").innerHTML = askInfo[0].CNTN;

	/* if("" != preAsk){
		document.getElementById("pre_ask").innerHTML = "<a class='link' href='javascript:fn_dtl_sel_lk("+preAsk[0].FAQ_SEQ+")'>"+preAsk[0].SBJ+"</a>";
	}
	if("" != nextAsk){
		document.getElementById("next_ask").innerHTML = "<a class='link' href='javascript:fn_dtl_sel_lk("+nextAsk[0].FAQ_SEQ+")'>"+nextAsk[0].SBJ+"</a>";
	} */

	if(""==fileList){
		$("#fileChk").hide();
	} else {
		for(var i=0;i<fileList.length;i++){
			$("#files").append("<li><a href='javascript:fn_download(\"noti\", \""+fileList[i].SAVE_FILE_NM+"\", \""+fileList[i].FILE_NM+"\")'><span class='down_btn'></span>"+fileList[i].FILE_NM+"</a></li>");
		}
	}
	

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
function fn_upd(){
	var sAction="/WH/EPWH8169942.do";
	
	//페이지이동
	var data = {"FAQ_SEQ": askInfo[0].FAQ_SEQ};
  	kora.common.goPageD(sAction, data, jParams);
}

//삭제
function fn_del(){
	confirm("FAQ를 삭제하시겠습니까?",'fn_del_exec')
}

function fn_del_exec(){
	var sData = {"FAQ_SEQ" : askInfo[0].FAQ_SEQ};
	var row = new Array();
	var url = "/WH/EPWH8169997_04.do";
	
	if(""!=fileList){
		for(var i=0;i<fileList.length;i++){
			var sFile = {};
			sFile["fileNm"] = fileList[i].SAVE_FILE_NM;
			row.push(sFile);
		}
		sData["fileList"] = JSON.stringify(row);
	} else {
		var sFile = {};
		sFile["fileNm"] = "NONFILE";
		row.push(sFile);
		sData["fileList"] = JSON.stringify(row);
	}
	
	ajaxPost(url, sData, function(rtnData){
		if(rtnData != null && rtnData != ""){
			alert("삭제되었습니다.",'fn_lst');
		} else {
			alert("error");
		}
	});
}

//상세조회링크
function fn_dtl_sel_lk(faq_seq){
	var sAction="/WH/EPWH8169997.do";
	
	//페이지이동
  	var data = {"FAQ_SEQ": faq_seq};
  	kora.common.goPageD(sAction, data, jParams);
}

//목록으로
function fn_lst(){
	var sAction="/WH/EPWH8169901.do";
	
	//페이지이동
  	kora.common.goPageD(sAction, "", jParams);
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
					<div class="tit" id="sbj"></div>
					<div class="info_wrap">
						<div class="date" id="dttm"></div>
					</div>
				</div>
				<div class="board_attach" id="files">
					<!-- 
					<dl>
						<dt>첨부파일 :</dt>
						<dd><a href="#self">매뉴얼.PDF</a></dd>
					</dl>
					<dl>
						<dt>첨부파일 :</dt>
						<dd><a href="#self">참고자료.PDF</a></dd>
					</dl>
					 -->
				</div>
				<div class="board_body">
					<div class="editor_area" id="cntn">
					</div>
				</div>
				<div class="btn_wrap mt30">
					<div class="fl_c">
						<!-- <a href="#self" class="btn_prev" id="pre_noti">이전 글</a> -->
						<button class="btn70 c1 ml0" style="width: 220px;" id="btn_lst">목록</button>
						<!-- <a href="#self" class="btn_next" id="next_noti">다음 글</a> -->
					</div>
				</div>
			</div>
		</div><!-- id : contents -->

	</div><!-- id : container -->

	<%@include file="/jsp/include/footer_m.jsp" %>
</div><!-- id : wrap -->

</body>
</html>


