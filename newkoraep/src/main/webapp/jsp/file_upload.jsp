<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>파일첨부</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

var title = "${TITLE}";
var upload_type = "${UPLOAD_TYPE}";
var max_upload_count = "${MAX_UPLOAD_COUNT}";
var tmpIdx = 10000;
$(document).ready(function(){
	
	if(title == null || title == "") title = "파일첨부";
	if(upload_type == null || upload_type == "") upload_type = "";
	if(max_upload_count == null || max_upload_count == "") max_upload_count = 10;
	
	$("#title_sub").text(title);
	
	$('#atch_file').text(parent.fn_text('atch_file'));
	$('#file_atch').text(parent.fn_text('file_atch'));
	$('#btn_file_atch').text(parent.fn_text('file_atch'));
	
	//파일 첨부
	$("#btn_file_atch").click(function(){
		fileUpload();
	});
	
	//취소
	$("#btn_file_cncl").click(function(){
		fn_cnl();
	});
	
	//등록
	$("#btn_file_reg").click(function(){
		fn_reg_check();
	});
	
 });
	
	
//취소
function fn_cnl() {
	$('[layer="close"]').trigger('click');
}


function fn_reg_check(){
	if($('#fileList').find('li').length == 0) {
		alertMsg("첨부한 파일이 없습니다.");
		return;
	}
	
	confirm("첨부된 파일을 등록하시겠습니까?", "fn_reg");
}

function fn_reg(){
	var url ="/POP_FILE_UPLOAD_PROC.do";
	fileajaxPost(url, {}, function(rtnData){
		window.frames[$("#pagedata").val()].fn_popResult(rtnData);
		fn_cnl();
	});
}

//파일첨부 인풋 추가
fileUpload = function() {
	var inputs = $('#fileList').find('li').length;
	if(Number(inputs) >= Number(max_upload_count)) {
		alertMsg("첨부파일은 " + max_upload_count + "개만 등록 가능합니다.");
		return;
	}
	var fileObj = '<li id="il_'+tmpIdx+'"><label for="fileUpload'+tmpIdx+'"></label><input id="fileName'+tmpIdx+'" class="upload-name" value="파일선택" disabled="disabled" /><input type="file" id="fileUpload'+tmpIdx+'" name="fileUpload'+tmpIdx+'" value=" " onchange="fileNameOnChange(this)" class="upload-hidden" /><a href="javascript:fn_atch_file_del('+tmpIdx+')" class="delete"><img src="/images/util/flie_close.png" alt="삭제"></a></li>';
	$("#fileList").append(fileObj);
	tmpIdx++;
};



//업로드한 파일명 셋팅
fileNameOnChange = function(obj) {
	var tmpN = ($(obj).attr("id")).replace("fileUpload","");
	var filename = $("#fileUpload"+tmpN).val().split('/').pop().split('\\').pop();  // 파일명만 추출
	var ext = filename.substring(filename.indexOf(".")+1, filename.length);
	
	if(ext == null || ext == "") return;		//값없애는 경우에 다시 이함수 타기 때문에 조심.
	if(!fn_extCheck(ext)){
		$(obj).val("");
		return;
	}
	
	$("#fileName"+tmpN).val(filename);
};


//확장자 체크
function fn_extCheck(ext){
	var exts = new Array();
	ext = ext.toLowerCase();
	
	if(upload_type == "IMG"){
		exts = ['jpeg', 'png', 'jpg', 'gif', 'tif', 'bmp'];
	}else{
		exts = ['hwp', 'doc', 'zip', 'jpeg', 'png', 'jpg', 'gif', 'tif', 'bmp', 'pdf'];
	}
	
	if($.inArray(ext, exts) == -1){
		alertMsg("허용되지 않는 형식의 파일입니다.");
		return false;
    }
	
	return true;
}

	
//첨부파일 삭제 이벤트
fn_atch_file_del = function(row) {
	$("#fileForm").find("input[name='fileUpload_"+row+"']").remove();
	$("#il_"+row).remove();
}

</script>
</head>
<body>
    	<div class="layer_popup" style="width:600px; margin-top: -317px" > 
				<div class="layer_head">
					<h1 class="layer_title" id="title_sub"></h1>
					<button type="button" class="layer_close" layer="close"  >팝업닫기</button>
				</div>
			   	<div class="layer_body">
						<section class="secwrap">
								<div class="write_area" id="divInput">
										<form name="fileForm" id="fileForm" method="post" enctype="multipart/form-data">
													<div class="atch_box">
															<div class="titbox">
																<div class="tit" id="atch_file"></div>
																<div class="btn_box">
																	<label class="btn36 c6" style="width: 92px;" id="btn_file_atch"></label>
																</div>							
															</div>
															<ul class="atch_list" id="fileList" ></ul>
													</div>
													<div class="singleRow">
															<div class="btn">
															<input type="hidden" id="pagedata" name="pagedata" />
															<button type="button" id="btn_file_reg" class="btn36 c2" style="width:100px;">등록</button>
															<button type="button" id="btn_file_cncl" class="btn36 c5" style="width:100px;">취소</button>
															
															</div>
													</div>
										</form>	
								</div>
						</section>
				</div>
		</div>
</body>
</html>