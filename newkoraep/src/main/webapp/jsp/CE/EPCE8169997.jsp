<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">

var askInfo;
var preAsk;
var nextAsk;
var fileList;
var jParams;

$(document).ready(function(){

	$('#title_sub').text('<c:out value="${titleSub}" />');
		
	askInfo = jsonObject($("#askInfo").val());
	fileList = jsonObject($("#fileList").val());
	preAsk = jsonObject($("#preAsk").val());
	nextAsk = jsonObject($("#nextAsk").val());
	
	//버튼 셋팅
    fn_btnSetting();
	
  	//언어관리
	$('#atch_file').text(parent.fn_text('atch_file'));
	$('#bf_doc').text(parent.fn_text('bf_doc'));
	$('#nx_doc').text(parent.fn_text('nx_doc'));
	
	//페이지이동 조회조건 파라메터 정보
	jParams = jsonObject($("#INQ_PARAMS").val());
	
	document.getElementById("sbj").innerHTML = askInfo[0].SBJ;
	document.getElementById("dttm").innerHTML = askInfo[0].REG_DTTM;
	document.getElementById("cntn").innerHTML = askInfo[0].CNTN;

	if("" != preAsk){
		document.getElementById("pre_ask").innerHTML = "<a class='link' href='javascript:fn_dtl_sel_lk("+preAsk[0].FAQ_SEQ+")'>"+preAsk[0].SBJ+"</a>";
	}
	if("" != nextAsk){
		document.getElementById("next_ask").innerHTML = "<a class='link' href='javascript:fn_dtl_sel_lk("+nextAsk[0].FAQ_SEQ+")'>"+nextAsk[0].SBJ+"</a>";
	}

	if(""==fileList){
		$("#fileChk").hide();
	} else {
		for(var i=0;i<fileList.length;i++){
			$("#files").append("<li><a href='javascript:fn_dwnd(\""+fileList[i].SAVE_FILE_NM+"\", \""+fileList[i].FILE_NM+"\")'><span class='down_btn'></span>"+fileList[i].FILE_NM+"</a></li>");
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
	
	var sAction="/CE/EPCE8169942.do";
	
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
	var url = "/CE/EPCE8169997_04.do";
	
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
			alertMsg("삭제되었습니다.",'fn_lst');
		} else {
			alertMsg("error");
		}
		
	});
}

//상세조회링크
function fn_dtl_sel_lk(faq_seq){
	
	var sAction="/CE/EPCE8169997.do";
	
	//페이지이동
  var data = {"FAQ_SEQ": faq_seq};
  kora.common.goPageD(sAction, data, jParams);
	
}

//목록으로
function fn_lst(){
	
	var sAction="/CE/EPCE8169901.do";
	
	//페이지이동
  kora.common.goPageD(sAction, "", jParams);
	
}

//파일다운로드
function fn_dwnd(fName, sName){
	frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
	frm.fileName.value = fName;
	frm.saveFileName.value = sName;
	frm.submit();
}

</script>

<div class="iframe_inner">

<input type="hidden" id="askInfo" value="<c:out value='${askInfo}' />" />
<input type="hidden" id="fileList" value="<c:out value='${fileList}' />" />
<input type="hidden" id="preAsk" value="<c:out value='${preAsk}' />" />
<input type="hidden" id="nextAsk" value="<c:out value='${nextAsk}' />" />
<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />

	<div class="h3group">
		<h3 class="tit" id="title_sub"></h3>
	</div>
	<section class="secwrap">
		<div class="viewarea">
			<div class="view_head">
				<div class="tit"><p id="sbj"></p></div>
				<div class="day"><p class="date" id="dttm"></p></div>
			</div>
			<div class="atch_box" id="fileChk">
				<div class="tit" id="atch_file"></div>
				<ul class="filebox" >
					<li id="files"><a href="#self"></a></li>
				</ul>
			</div>
			<div class="view_body">
				<p id="cntn"></p>
			</div>
			<div class="view_navi">
				<div class="prev">
					<div class="tit" id="bf_doc"></div>
					<span class="txt" id="pre_ask">이전 글이 없습니다.</span>
				</div>
				<div class="next">
					<div class="tit" id="nx_doc"></div>
					<span class="txt" id="next_ask">다음 글이 없습니다.</span>
				</div>
			</div>
			
		</div>
		
		<div class="btnwrap mt20">
			<div class="btn" style="float:right">
			<c:if test="${userInfo.ATH_GRP_CD eq 'ATC002'or userInfo.ATH_GRP_CD eq 'ATH001' or userInfo.USER_ID eq askInfo[0].REG_ID}">
				<button type="button" class="btn36 c1" style="width: 100px;"
					id="btn_upd">수정</button>
				<button type="button" class="btn36 c4" style="width: 100px;"
					id="btn_del">삭제</button>
			</c:if>
				<button type="button" class="btn36 c5" style="width: 100px;"
					id="btn_lst">목록</button>
			</div>
		</div>
		
	</section>
	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="noti" /> <!-- 공지사항 첨부 다운일경우 noti, 업로드 폴더인경우 up 로 넣어준다-->
	</form>
</div>

