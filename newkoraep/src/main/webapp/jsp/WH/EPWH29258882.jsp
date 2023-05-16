<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>회수증빙자료다운로드</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>  
<script type="text/javaScript" language="javascript" defer="defer">  

var initList;		//도매업자
$(document).ready(function(){
	 //버튼 셋팅
	 fn_btnSetting('EPWH29258882');
	 initList = jsonObject($('#initList').val());
	 //var parent_item = window.frames[$("#pagedata").val()].parent_item;
	
	 /************************************
	 * 취소 버튼 클릭 이벤트
	 ***********************************/
	$("#btn_cnl").click(function(){
		 $('[layer="close"]').trigger('click');
	});
	fn_init();
	

	
});


function fn_init(){
	//text 셋팅
	$('#title_sub').text('<c:out value="${titleSub}" />');		
	$('#prf_data').text(parent.fn_text('prf_data'));					  			
	$('#std_rtrvl_dt').text(parent.fn_text('std_rtrvl_dt'));				
	$("#RTRVL_DT").text(kora.common.formatter.datetime(initList[0].RTRVL_DT, "yyyy-mm-dd"));

	$.each(initList, function(i, v){
		v.FILE_PATH = v.FILE_PATH.replace(/\\/gi, "/");
		filePath = v.FILE_PATH.substring(v.FILE_PATH.lastIndexOf("/")+1,v.FILE_PATH.length);
		var fileObj =	"<li id=il_"+v.DTL_SN+"><label></lavbel><a href='javascript:fn_down(\""+filePath+"\", \""+v.SAVE_FILE_NM+"\", \""+v.FILE_NM_ORI+"\")' class='file'>"+v.FILE_NM_ORI+"</a></li>";
		$("#fileList").append(fileObj);
	});
	
}


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
.write_area .atch_box {
    padding: 0px 0px;
    border-bottom: 0px;
}

</style>

</head>
<body>
    	<div class="layer_popup" style="width:600px; margin-top: -300px" >
    	<input type="hidden" id="initList" value="<c:out value='${initList}' />"/>
				<div class="layer_head">
					<h1 class="layer_title" id="title_sub"></h1>
					<button type="button" class="layer_close" layer="close"  >팝업닫기</button>
				</div>
			   	<div class="layer_body">
					   	<section class="secwrap">
							   	<div class="write_area">
						   						<div class="write_tbl">
														<table>
															<colgroup>
																<col style="width: 30%">
																<col style="width: auto">
															</colgroup>
														<tbody>			
															 <tr>
																<th class="bd_l" id="std_rtrvl_dt"></th> <!-- 회수일자 -->		
																<td>
																	<div class="row">
																			<div class="txtbox" id="RTRVL_DT"></div>
																	</div>
																</td>
															</tr>
															<tr>
																<th class="bd_l" id="prf_data"></th> <!--증빙파일 -->		
																<td>
																	<div class="row">
																			<div class="atch_box">
																				<ul class="atch_list" id="fileList" ></ul>
																			</div>
																	</div>
																</td>
															</tr>
														</tbody>
													</table>
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