<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>엑셀파일 업로드</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">
	$(document).ready(function(){
	var parent_item = window.frames[$("#pagedata").val()].parent_item;
	 if(parent_item == null){
		 cosole.log("error");
	 }else{
		var callBackFunc 		= parent_item.callBackFunc ;
	 }
	 
	 	/************************************
	 	 * 취소 버튼 클릭 이벤트
	 	 ***********************************/
	 	$("#btn_cnl").click(function(){
	 		fn_cnl();
	 	});

	 	/************************************
	 	 * 저장 버튼 클릭 이벤트
	 	 ***********************************/
	 	$("#btn_reg").click(function(){
	 		fn_reg();
	 	});
	 	
	 	$('#title_sub').text(parent.fn_text('excel_upload'));		
	 	$('#btn_reg').text(parent.fn_text('save'));		
	 	$('#btn_cnl').text(parent.fn_text('cnl'));		
	});
	
	//저장
	function fn_reg() {
		
		document.body.style.cursor = 'wait';

		var url ="/EXCEL_UPLOAD.do"
	    var input ="";
	  	 fileajaxPost(url, input, function(rtnData){
	  		 
	  			document.body.style.cursor = 'default';
	  		 
		 		if(rtnData != null && rtnData != ""){

			 		if(rtnData.RSLT_CD !=null){	
			 			alertMsg(rtnData.RSLT_MSG);
			 		}else if(rtnData.list == null|| rtnData.list.length == 0  || rtnData.list == ''){	//정상적으로 됐지만 데이터가 없을경우
			 			alertMsg("데이타가 존재하지 않습니다.");
			 		}else{
			 			window.frames[$("#pagedata").val()].fn_popExcel(rtnData.list); //전부 정상일경우 부모 function실행후 종료
			 			$('[layer="close"]').trigger('click');
			 		}
		 		} 
		 		else {
		 			
		 			alertMsg("error");
		 		}
		 });
	}
	
	//취소
	function fn_cnl(){
		$('[layer="close"]').trigger('click');
	}
	
</script>

<style type="text/css">

input[type='file']{
border: 1px solid #b4b4b4;
padding: 2px 2px;
margin: 0px 10px;
vertical-align: middle;
}

</style>

</head>
<body>
		<div class="layer_popup" style="width:800px; margin-top: -317px"" >
				<div class="layer_head">
					<h1 class="layer_title" id="title_sub"></h1>
					<button type="button" class="layer_close" layer="close"  >팝업닫기</button>
				</div>
			   	<div class="layer_body">
						<section class="secwrap">
								<div class="write_area" id="divInput">
										<form name="fileForm" id="fileForm" method="post" enctype="multipart/form-data">
												<div class="atch_box">
														<ul class="atch_list" id="fileList" style="font-weight: 700; font-size: 15px; line-height: 30px; color: #53565c;" >
																<li>지원되는 파일형식(확장자)은 Excel 파일 (xls, xlsx) 입니다.</li>
																<li><span style="vertical-align:middle;">파일찾기</span><input type="file"name="excel1" style="width:80%;border:0px"></li>
														</ul>
												</div>
												
												<input type="hidden" name ="pagedata"  id="pagedata"/> 
										</form>	
								</div>
								
								<div class="singleRow mt10">
									<div class="btn" id="BR">
										<button type="button" class="btn36 c4" style="width: 100px;" id="btn_cnl"></button>
										<button type="button" class="btn36 c2" style="width: 100px;" id="btn_reg"></button>
									</div>
								</div>
								
						</section>
				</div>
		</div>		
</body>
</html>

