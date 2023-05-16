<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="/jsp/include/common_page.jsp" %>
<!-- 
<link rel="stylesheet" href="/ckeditor/contents.css" type="text/css">
 -->

<script type="text/javaScript" language="javascript" defer="defer">

var notiInfo = ${notiInfo};
var preNoti = ${preNoti};
var nextNoti = ${nextNoti};
var fileList = ${fileList};
var jParams = {};

$(document).ready(function(){
	
	//버튼 셋팅
    fn_btnSetting();
	
	//언어관리
	$('#bf_doc').text(parent.fn_text('bf_doc'));
	$('#nx_doc').text(parent.fn_text('nx_doc'));
	$('#atch_file').text(parent.fn_text('atch_file'));
		
	//페이지이동 조회조건 파라메터 정보
	jParams = ${INQ_PARAMS};

	
	document.getElementById("sbj").innerHTML = notiInfo[0].SBJ;
	document.getElementById("dttm").innerHTML = notiInfo[0].REG_DTTM;
	document.getElementById("cntn").innerHTML = notiInfo[0].CNTN;
	
	if("" != preNoti){
		document.getElementById("pre_noti").innerHTML = "<a class='link' href='javascript:fn_dtl_sel_lk("+preNoti[0].NOTI_SEQ+")'>"+preNoti[0].SBJ+"</a>";
	}
	if("" != nextNoti){
		document.getElementById("next_noti").innerHTML = "<a class='link' href='javascript:fn_dtl_sel_lk("+nextNoti[0].NOTI_SEQ+")'>"+nextNoti[0].SBJ+"</a>";
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
	
	$('#title_sub').text('<c:out value="${titleSub}" />');
	
});

//수정
function fn_upd(){
	
	var sAction="/WH/EPWH8149094.do";
	
	//페이지이동
    var data = {"NOTI_SEQ": notiInfo[0].NOTI_SEQ};
    kora.common.goPageD(sAction, data, jParams);
	
}

//삭제
function fn_del(){
	
	confirm("공지사항을 삭제하시겠습니까?",'fn_del_exec')
}

function fn_del_exec(){
	
	var sData = {"NOTI_SEQ" : notiInfo[0].NOTI_SEQ};
	var row = new Array();
	var url = "/WH/EPWH8149093_04.do";
	
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
function fn_dtl_sel_lk(noti_seq){
	
	var sAction="/WH/EPWH8149093.do";
	
	//페이지이동
    var data = {"NOTI_SEQ": noti_seq};
    kora.common.goPageD(sAction, data, jParams);
	
};

//돌아가기
function fn_lst(){
	
	var sAction="/WH/EPWH8149001.do";
	
	//페이지이동
    kora.common.goPageD(sAction, "", jParams);
	
}

//파일다운로드
function fn_dwnd(fName, sName){ //fn_down
	frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
	frm.fileName.value = fName;
	frm.saveFileName.value = sName;
	frm.submit();
}

</script>

<div class="iframe_inner">
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
				<div class="tit" id="atch_file" style="width:87px"></div>
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
					<span class="txt" id="pre_noti">이전 글이 없습니다.</span>
				</div>
				<div class="next">
					<div class="tit" id="nx_doc"></div>
					<span class="txt" id="next_noti">다음 글이 없습니다.</span>
				</div>
			</div>
			
		</div>
		
		<div class="btnwrap mt20">
			<div class="fl_r" id="BR">
      		</div>
     	</div>
		
	</section>
	
	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="noti" /> <!-- 공지사항 첨부 다운일경우 noti, 업로드 폴더인경우 up 로 넣어준다-->
	</form>
	
</div>



