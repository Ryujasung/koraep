<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>증빙사진 조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

$(document).ready(function(){

	
	 //버튼 셋팅
	 fn_btnSetting('EPWH29839883');
	 
	 var parent_item = window.frames[$("#pagedata").val()].parent_item;
	
	
	/************************************
	 * 확인 버튼 클릭 이벤트
	 ***********************************/
	$("#btn_cfm").click(function(){
		 $('[layer="close"]').trigger('click');
	});
	
	fn_setData(parent_item);
});

function fn_cnl(){
	$('[layer="close"]').trigger('click');
}

//선택데이터 팝업화면에 셋팅
fn_setData = function(data) {
	var input = {};
		input["WRHS_DOC_NO"] = data.WRHS_DOC_NO;
		input["CTNR_CD"]  = data.CTNR_CD;
	var url = "/WH/EPWH29839883_19.do";
	var filePath = "";

	ajaxPost(url, input, function(rtnData){
		
		if(rtnData != null && rtnData != ""){
			$('#title_sub').text(rtnData.titleSub);
			
			if(rtnData.selList == null || rtnData.selList.length == 0){
				alertMsg("저장된 파일이 없습니다.",'fn_cnl');
				return;
			}
			
			$.each(rtnData.selList, function(i, v){
				filePath = v.FILE_PATH.substring(v.FILE_PATH.indexOf("/data_file"),v.FILE_PATH.length) ;
				filePath = filePath.replaceAll("\"","");
				$("#att_list").append("<dt>"+v.FILE_NM+"</dt>");
				$("#att_list").append("<dd class='fileImage'><img src='"+filePath+"/"+v.SAVE_FILE_NM+"' alt='"+v.FILE_NM+"' /></dd>");
			});
			
		} 
		else {
			alertMsg("error");
		}
	});
};
        

</script>
<style type="text/css">

.fileImage img{
width: 100%;
}

</style>

</head>
<body>
    	<div class="layer_popup" style="width:600px; margin-top: -317px" >
				<div class="layer_head">
					<h1 class="layer_title" id="title_sub"></h1>
					<button type="button" class="layer_close" layer="close"  >팝업닫기</button>
				</div>
			   	<div class="layer_body">
						<dl class="proof" id="att_list" style="margin:0 auto;"></dl>		
						<section class="btnwrap mt20"  >
								<div class="btn" style="float:right" id="BR"></div>
						</section>
						<input type="hidden" name ="pagedata"  id="pagedata"/> 
				</div>
		</div>
</body>
</html>