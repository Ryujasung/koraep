<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>회수증빙자료등록</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">
	var tmpI = 10000;
	var whsdl_cd_list		
	var parent_item;
	var toDay = kora.common.gfn_toDay();  // 현재 시간
	var file_flag = false;
	 $(document).ready(function(){
		 //버튼 셋팅
		fn_btnSetting('EPCE2925888');
		 	
		fileUpload();
		parent_item 	= window.frames[$("#pagedata").val()].parent_item;
		 
		$('#title_sub').text('<c:out value="${titleSub}" />');		
		$('#file_atch').text(parent.fn_text('file_atch'));
		$('#rtrvl_dt2').text(parent.fn_text('rtrvl_dt2'));
		
		//날짜 셋팅
  	    $('#RTRVL_DT_C').YJcalendar({  
 			triggerBtn : true,
 			dateSetting: toDay.replaceAll('-','')
 		});
		
		/************************************
		 * 시작날짜  클릭시 - 삭제 변경 이벤트
		 ***********************************/
		$("#RTRVL_DT_C").click(function(){
			    var rtn_dt = $("#RTRVL_DT_C").val();
			    rtn_dt   =  rtn_dt.replace(/-/gi, "");
			    $("#RTRVL_DT_C").val(rtn_dt)
		});
		
		/************************************
		 * 시작날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		$("#RTRVL_DT_C").change(function(){
		     var dt = $("#RTRVL_DT_C").val();
		     dt   =  dt.replace(/-/gi, "");
			 if(dt.length == 8)  dt = kora.common.formatter.datetime(dt, "yyyy-mm-dd")
	     	 $("#RTRVL_DT_C").val(dt) 
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
		
	 });
	 
	//취소
	 function fn_cnl_check(){
			if(file_flag) {
		 		confirm("첨부한 파일이 등록되지 않았습니다.\n\n화면을 닫으시겠습니까?","fn_cnl")			
		 	}else{
		 		fn_cnl();
		 	}
	 }
	
	//취소
	 function fn_cnl() {
		 $('[layer="close"]').trigger('click');
	 }
	
	 function fn_reg_chk(){
		 if($('#fileList').find('li').length == 0) {
		 		alertMsg("첨부한 파일이 없습니다.");
		 		return false;
		 	}
		 confirm("첨부된 증빙파일을 등록하시겠습니까?","fn_reg");
	 }
	 
	 //등록 이벤트
	 function fn_reg() {
	    var url ="/CE/EPCE2925888_09.do"
	    var input ="";
	    
	    $("#WHSDL_BIZRID").val(parent_item.WHSDL_BIZRID);
	    $("#WHSDL_BIZRNO").val(parent_item.WHSDL_BIZRNO);
	    $("#RTRVL_DT").val($("#RTRVL_DT_C").val());
	    fileajaxPost(url, input, function(rtnData){
			 		if(rtnData != null && rtnData != ""){
				 		alertMsg(rtnData.RSLT_MSG);
				 		window.frames[$("#pagedata").val()].fn_sel();
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
		//var fileObj = '<li id="il_'+tmpI+'"><label for="fileUpload'+tmpI+'"></label><input id="fileName'+tmpI+'" class="upload-name" value="파일선택" disabled="disabled" style="width:200px;"><input type="file" id="fileUpload'+tmpI+'" name="fileUpload'+tmpI+'" value=" " onchange="fileNameOnChange(this)" class="upload-hidden"><a href="javascript:fn_atch_file_del('+tmpI+')" class="delete"><img src="/images/util/flie_close.png" alt="삭제" style="vertical-align: middle;"></a></li>';
		var fileObj =
		'<li id="il_'+tmpI+'" style="background:#ffffff"><label for="fileUpload'+tmpI+'"></label>'+
		//'<input id="fileName'+regSn+'" class="upload-name" value="파일선택" disabled="disabled">'+
		'<input type="file" id="fileUpload'+tmpI+'" name="fileUpload'+tmpI+'" value=" " onchange="fileNameOnChange(this)" style="height:34px;width:400px" >'+
		//'<a href="javascript:fn_atch_file_del('+tmpI+')" class="delete"><img src="/images/util/flie_close.png" alt="삭제" style="padding:11px"></a>'+
		'</li>';
		
		$("#fileList").append(fileObj);
	 	tmpI++;
	 };

	 //업로드한 파일명 셋팅
	 fileNameOnChange = function(obj) {
		file_flag = true;
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
		 file_flag = false;
	 	$("#fileForm").find("input[name='fileUpload_"+row+"']").remove();
	     $("#il_"+row).remove();
	     fileUpload();
	 }

</script>
</head>  
<body>
    	<div class="layer_popup" style="width:726px; margin-top: -317px" > 
				<div class="layer_head">
					<h1 class="layer_title" id="title_sub"></h1>
					<button type="button" class="layer_close" layer="close"  >팝업닫기</button>
				</div>
			   	<div class="layer_body">
	  					<section class="secwrap mt10"   id="params">
								<div class="srcharea" style="" > 
									<div class="row">
											<div class="col">
												<div class="tit" id="rtrvl_dt2"></div>  <!-- 회수일자 -->
												<div class="box">
													<div class="calendar">
														<input type="text" id="RTRVL_DT_C"  style="width: 180px;" class="i_notnull" /> <!--시작날짜  -->
													</div>
												</div>
											</div>
									</div><!-- end of row -->
								</div><!--end of srcharea  -->
						</section> <!--end of secwrap  -->
						<section class="secwrap mt10">
							<form name="fileForm" id="fileForm" method="post" enctype="multipart/form-data">
								<div class="srcharea" style="" > 
									<div class="row" id="divInput">
										<div class="col">
											<div class="tit" >파일선택</div>
											<div class="atch_box">
													<ul class="atch_list" id="fileList" ></ul>
											</div>
										</div>
									</div><!-- end of row -->
								</div>
								<input type="hidden" name="WHSDL_BIZRID" id="WHSDL_BIZRID">
								<input type="hidden" name="WHSDL_BIZRNO" id="WHSDL_BIZRNO">
								<input type="hidden" name="RTRVL_DT" id="RTRVL_DT">
								<input type="hidden" name ="pagedata"  id="pagedata"/> 
							</form>
						</section>
						<section class="btnwrap mt10" >
							<div class="btn" id="BL"></div>
							<div class="btn" style="float:right" id="BR"></div>
						</section>
				</div>
		</div>
</body>
</html>