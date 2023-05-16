<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>증빙파일등록</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">
var tmpI = 10000;
var delSeq = [];
	 $(document).ready(function(){
		 //버튼 셋팅
		 fn_btnSetting('EPMF2916488');
		var parent_item = window.frames[$("#pagedata").val()].parent_item;
		 
		 if(parent_item == null){
			 cosole.log("erer");
		 }
		 
		$('#atch_file').text(parent.fn_text('atch_file'));
		$('#file_atch').text(parent.fn_text('file_atch'));
		$('#btn_file_atch').text(parent.fn_text('file_atch'));
		 
	 	/************************************
	 	 * 파일첨부 버튼 클릭 이벤트
	 	 ***********************************/
	 	$("#btn_file_atch").click(function(){
	 		fileUpload();
	 	});

	 	/************************************
	 	 * 취소 버튼 클릭 이벤트
	 	 ***********************************/
	 	$("#btn_cnl").click(function(){
	 		fn_cnl_check();
	 	});
	 	
	 	/************************************
	 	 * 저장 버튼 클릭 이벤트
	 	 ***********************************/
	 	$("#btn_reg").click(function(){
	 		fn_reg_chk();
	 	});
	 	
	 	fn_setData(parent_item);
	 	
	 });
	//취소
	  function fn_cnl_check(){
			if($('#fileList').find('input').length > 0) {
		 		confirm("첨부한 파일이 등록되지 않았습니다.\n\n화면을 닫으시겠습니까?","fn_cnl")			
		 	}else{
		 		fn_cnl();
		 	}
	 }
	//취소
	 function fn_cnl() {
		 $('[layer="close"]').trigger('click');
	 }

	 //선택데이터 팝업화면에 셋팅
	  function fn_setData(data) {
	 	var input = {};
	 	var url = "/MF/EPMF2916488_19.do";
		input["RSRC_DOC_NO"] 	= data.RSRC_DOC_NO;
	 	input["RTN_DOC_NO"] 	  	= data.RTN_DOC_NO;
	 	$("#RSRC_DOC_NO").val(data.RSRC_DOC_NO);	//실태조사문서번호
	 	$("#RTN_DOC_NO").val(data.RTN_DOC_NO);		//반환문서번호
	 	ajaxPost(url, input, function(rtnData){
	 		if(rtnData != null && rtnData != ""){
	 			$('#title_sub').text(rtnData.titleSub);
	 			$.each(rtnData.initList, function(i, v){
	 				var fileObj =	"<li id=il_"+v.RSRC_DTL_SN+"><a href='#' class='file'>"+v.FILE_NM+"</a><a href='javascript:fn_atch_file_del("+v.RSRC_DTL_SN+")' class='delete'><img src='/images/util/flie_close.png' alt='삭제' style= 'margin-top: 6px; margin-left: 7px;'></a></li>";
	 				$("#fileList").append(fileObj);
	 			});
	 		} 
	 		else {
	 			alertMsg("error");
	 		}
	 	});
	 };

	 //저장 후 조회
	 function fn_sel(){
		 var input = {};
		 var url = "/MF/EPMF2916488_19.do"; 
			input["RSRC_DOC_NO"]  	  	= $("#RSRC_DOC_NO").val();
			input["RTN_DOC_NO"] 	 		= $("#RTN_DOC_NO").val();
		 
		 $("#fileList *").remove(); //자식 li삭제 
		 	
		 ajaxPost(url, input, function(rtnData){
		 		if(rtnData != null && rtnData != ""){
		 			$.each(rtnData.initList, function(i, v){
		 				var fileObj =	"<li id=il_"+v.RSRC_DTL_SN+"><a href='#' class='file'>"+v.FILE_NM+"</a><a href='javascript:fn_atch_file_del("+v.RSRC_DTL_SN+")' class='delete'><img src='/images/util/flie_close.png' alt='삭제' style= 'margin-top: 6px; margin-left: 7px;'></a></li>";
		 				$("#fileList").append(fileObj);
		 			});
		 		} 
		 		else {
		 			alertMsg("error");
		 		}
		 	},false);
		 
		 window.frames[$("#pagedata").val()].fn_sel();
		 
	 }
	 
	 function fn_reg_chk(){
		 if($('#fileList').find('li').length == 0 && delSeq.length == 0) {
		 		alertMsg("첨부한 파일이 없습니다.");
		 		return false;
		 	}
		 confirm("첨부된 증빙파일을 등록하시겠습니까?","fn_reg")
	 }
	 
	 //등록 이벤트
	 function fn_reg() {

	    var url ="/MF/EPMF2916488_09.do"
	    var input ="";
	    fileajaxPost(url, input, function(rtnData){
			 		if(rtnData != null && rtnData != ""){
				 		alertMsg(rtnData.RSLT_MSG)
				 		fn_sel();
				 		delSeq=[];
				 		$("#RSRC_DTL_SN").val("");
				 		fn_cnl();
			 		} 
			 		else {
			 			alertMsg("error");
			 		}
			 	});
	 }

	 fileUpload = function() {
	 	var inputs = $('#fileList').find('li').length;

	 	if(inputs > 9) {
	 		alertMsg("증빙파일은 최대 10개만 등록 가능합니다.");
	 		return;
	 	}

		var fileObj = '<li id="il_'+tmpI+'"><label for="fileUpload'+tmpI+'"></label><input id="fileName'+tmpI+'" class="upload-name" value="파일선택" disabled="disabled"><input type="file" id="fileUpload'+tmpI+'" name="fileUpload'+tmpI+'" value=" " onchange="fileNameOnChange(this)" class="upload-hidden"><a href="javascript:fn_atch_file_del('+tmpI+')" class="delete"><img src="/images/util/flie_close.png" alt="삭제"></a></li>';
	 	$("#fileList").append(fileObj);
	 	tmpI++;
	 };
	 

	 //업로드한 파일명 셋팅
	 fileNameOnChange = function(obj) {
	 	
	 	var tmpN = ($(obj).attr("id")).replace("fileUpload","");
	 	
	 	var filename = $("#fileUpload"+tmpN).val().split('/').pop().split('\\').pop();  // 파일명만 추출
	     
	 	var ext = filename.substring(filename.indexOf(".")+1, filename.length);
	 	
	 
	 	if(filename != '') {
	 		$("#fileName"+tmpN).val(filename);
	 	    tmpN++;
	 	}
	 };

	 //첨부파일 삭제 이벤트
	 fn_atch_file_del = function(row) {
	 	$("#fileForm").find("input[name='fileUpload_"+row+"']").remove();
	     $("#il_"+row).remove();
	     if(row < 10000) {
	     	delSeq.push(row);
	     }
	     $("#RSRC_DTL_SN").val(delSeq);
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
													<input type="hidden" name="RSRC_DOC_NO" id="RSRC_DOC_NO">
													<input type="hidden" name="RTN_DOC_NO" id="RTN_DOC_NO">
													<input type="hidden" name="RSRC_DTL_SN" id="RSRC_DTL_SN">
													<input type="hidden" name ="pagedata"  id="pagedata"/> 
										</form>	
								</div>
						</section>
						<section class="btnwrap mt10"  >
								<div class="btn" style="float:right" id="BR"></div>
						</section>
				</div>
		</div>
</body>
</html>