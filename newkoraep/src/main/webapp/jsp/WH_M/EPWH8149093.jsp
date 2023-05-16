<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>공지사항 상세조회</title>
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

var notiInfo = ${notiInfo};
var preNoti = ${preNoti};
var nextNoti = ${nextNoti};
var fileList = ${fileList};
var jParams = {};

$(document).ready(function(){

	//버튼 셋팅
    //fn_btnSetting();
	
	//언어관리
	$('#bf_doc').text(parent.fn_text('bf_doc'));
	$('#nx_doc').text(parent.fn_text('nx_doc'));
	$('#atch_file').text(parent.fn_text('atch_file'));
		
	//페이지이동 조회조건 파라메터 정보
	jParams = ${INQ_PARAMS};

	document.getElementById("sbj").innerHTML = notiInfo[0].SBJ;
	document.getElementById("dttm").innerHTML = notiInfo[0].REG_DTTM;
	document.getElementById("cntn").innerHTML = del_font(notiInfo[0].CNTN);
	
	if("" != preNoti){
		document.getElementById("pre_noti").href='javascript:fn_dtl_sel_lk("'+preNoti[0].NOTI_SEQ+'")';
		//document.getElementById("pre_noti").innerHTML = "<a class='link' href='javascript:fn_dtl_sel_lk("+preNoti[0].NOTI_SEQ+")'>"+preNoti[0].SBJ+"</a>";
	}
	if("" != nextNoti){
		document.getElementById("next_noti").href='javascript:fn_dtl_sel_lk("'+nextNoti[0].NOTI_SEQ+'")';
		//document.getElementById("next_noti").innerHTML = "<a class='link' href='javascript:fn_dtl_sel_lk("+nextNoti[0].NOTI_SEQ+")'>"+nextNoti[0].SBJ+"</a>";
	}
    
    
	if(""==fileList){
		$("#fileChk").hide();
	} else {
		for(var i=0;i<fileList.length;i++){
			if ($("#APP").val() == "Y") {
				$("#files").append("<li><a href='javascript:fn_download(\"noti\", \""+fileList[i].SAVE_FILE_NM+"\", \""+fileList[i].FILE_NM+"\")'><span class='down_btn'></span>"+fileList[i].FILE_NM+"</a></li>");
			} else {
				$("#files").append("<li><a href='javascript:fn_dwnd(\""+fileList[i].SAVE_FILE_NM+"\", \""+fileList[i].FILE_NM+"\")'><span class='down_btn'></span>"+fileList[i].FILE_NM+"</a></li>");
			}
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

//span font 삭제
function del_font(str) {
    
    var tmp = str.split("style=\"font-size:");
    var rtn_str = "";
    
    for(var i=0; i<tmp.length; i++) {
	    if(tmp[i].indexOf("px") < 0) {
	        rtn_str += tmp[i];
	    }
	    else {
	        rtn_str += tmp[i].substring(tmp[i].indexOf("px")+3, tmp[i].length);
	    }
    }
    
    return rtn_str;
}

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
			alert("삭제되었습니다.",'fn_lst');
		} else {
			alert("error");
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
</head>
<body>

<input type="hidden" id="APP" value="<c:out value='${APP}' />"/>

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
				<div class="board_attach">
					<ul id="files">
					
					</ul>
				</div>
				<div class="board_body">
					<div class="editor_area" id="cntn">
					</div>
                    <div class="editor_area" id="encrypt">
                    </div>
				</div>
            
				<div class="btn_wrap mt30">
					<div class="fl_c">
						<a href="#self" class="btn_prev" id="pre_noti">이전 글</a>
						<button class="btn70 c1 ml0" style="width: 220px;" id="btn_lst">목록</button>
						<a href="#self" class="btn_next" id="next_noti">다음 글</a>
					</div>
				</div>
			</div>
		</div><!-- id : contents -->

	</div><!-- id : container -->

	<%@include file="/jsp/include/footer_m.jsp" %>
</div><!-- id : wrap -->

	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="noti" /> <!-- 공지사항 첨부 다운일경우 noti, 업로드 폴더인경우 up 로 넣어준다-->
	</form>
	
</body>
</html>


