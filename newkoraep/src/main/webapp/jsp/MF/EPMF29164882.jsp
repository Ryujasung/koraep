<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>증빙파일조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

$(document).ready(function(){

	
	 //버튼 셋팅
	 fn_btnSetting('EPMF29164882');
	 
	 var parent_item = window.frames[$("#pagedata").val()].parent_item;
	
	
	 /************************************
	 * 취소 버튼 클릭 이벤트
	 ***********************************/
	$("#btn_cnl").click(function(){
		 $('[layer="close"]').trigger('click');
	});
	
	fn_setData(parent_item);
});

//선택데이터 팝업화면에 셋팅
fn_setData = function(data) {
	var input = {};
	input["RSRC_DOC_NO"] 	= data.RSRC_DOC_NO;
 	input["RTN_DOC_NO"] 	  	= data.RTN_DOC_NO;
	var url = "/MF/EPMF29164882_19.do";
	var filePath = "";

	ajaxPost(url, input, function(rtnData){
		
		
		
		if(rtnData != null && rtnData != ""){
			$('#title_sub').text(rtnData.titleSub);
			$.each(rtnData.initList, function(i, v){
				var cnt = i+1
				v.FILE_PATH = v.FILE_PATH.replace(/\\/gi, "/");
				filePath = v.FILE_PATH.substring(v.FILE_PATH.lastIndexOf("/")+1,v.FILE_PATH.length);
				var fileObj =	"<li id=il_"+v.RSRC_DTL_SN+"><label>"+cnt+".  </lavbel><a href='javascript:fn_down(\""+filePath+"\", \""+v.SAVE_FILE_NM+"\", \""+v.FILE_NM+"\")' class='file'>"+v.FILE_NM+"</a></li>";
				$("#fileList").append(fileObj);
			});
			
		} 
		else {
			alertMsg("error");
		}
	});
};


//파일다운로드
function fn_down(path, fName, sName){
	frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
	frm.busiNo.value = path;
	frm.fileName.value = fName;
	frm.saveFileName.value = sName;
	frm.submit();
}



</script>
<style type="text/css">

</style>

</head>
<body>
    	<div class="layer_popup" style="width:600px; margin-top: -300px" >
				<div class="layer_head">
					<h1 class="layer_title" id="title_sub"></h1>
					<button type="button" class="layer_close" layer="close"  >팝업닫기</button>
				</div>
			   	<div class="layer_body">
					   	<section class="secwrap">
							   	<div class="write_area">
								   	<div class="atch_box">
											<ul class="atch_list" id="fileList" ></ul>
									</div>
								</div>
						</section>
						<section class="btnwrap mt20"  >
								<div class="btn" style="float:right" id="BR"></div>
						</section>
						<input type="hidden" name ="pagedata"  id="pagedata"/> 
				</div>
		</div>
		
<!-- 다운로드 추가. 20160222 DHC -->
<form name="frm" action="/jsp/file_down.jsp" method="post">
	<input type="hidden" name="fileName" value="" />
	<input type="hidden" name="saveFileName" value="" />
	<input type="hidden" name="busiNo" value="" />
	<input type="hidden" name="downDiv" value="up" /> <!-- 공지사항 첨부 다운일경우 noti, 업로드 폴더인경우 up 로 넣어준다-->
</form>
		
</body>
</html>