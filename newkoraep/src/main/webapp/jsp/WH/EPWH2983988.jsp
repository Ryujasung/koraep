<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>조사확인요청사유서(도매업자)</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

var parent_item; 

$(document).ready(function(){

	 //버튼 셋팅
	 fn_btnSetting('EPWH2983988');
	
	parent_item = window.frames[$("#pagedata").val()].parent_item;
	 
	/************************************
	 * 취소 버튼 클릭 이벤트
	 ***********************************/
	$("#btn_cnl").click(function(){
		 $('[layer="close"]').trigger('click');
	});

	/************************************
	 * 저장 버튼 클릭 이벤트
	 ***********************************/
	$("#btn_reg").click(function(){
		fn_reg_chk();
	});
	
	fn_init(parent_item);
	$('#req_cnts').text(parent.fn_text('req')+parent.fn_text('cnts')); 	 //요청내용
	$('#proc_cnts').text(parent.fn_text('proc')+parent.fn_text('cnts')); //처리내용
	
});

	//선택데이터 팝업화면에 셋팅
	function fn_init(data) {
		var input = {};
		var url = "/WH/EPWH2983988_19.do";
	 	input["RTN_DOC_NO"] 	  	= data.RTN_DOC_NO;
	
		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != ""){
				$('#title_sub').text(rtnData.titleSub);
			} 
			else {
				alertMsg("error");
			}
		});
  }
  function fn_reg_chk(){
	  if(kora.common.null2void($.trim($("#REQ_RSN").val())) == ""){
			alertMsg("처리내용을 작성하지 않았습니다.");
			return;
		}
	  confirm("실태조사요청내용을 저장 하시겠습니까?","fn_reg");
  }
  //요청처리 저장
  function fn_reg(){
	  var input ={};
	  var url ="/WH/EPWH2983988_09.do"
	  input["REQ_RSN"]			 = $("#REQ_RSN").val();
	  input["RTN_DOC_NO"] 	 = parent_item.RTN_DOC_NO;
	  ajaxPost(url, input, function(rtnData){
			if(rtnData.RSLT_CD == "0000"){
				alertMsg(rtnData.RSLT_MSG);	
				window.frames[$("#pagedata").val()].fn_sel();
				$('[layer="close"]').trigger('click');
			}else{
				alertMsg(rtnData.RSLT_MSG);
			}
		});
  }


</script>
<style type="text/css">


</style>

</head>
<body>
    	<div class="layer_popup" style="width:600px; margin-top: -317px" >
				<div class="layer_head">
					<h1 class="layer_title" id="title_sub"></h1>
					<button type="button" class="layer_close" layer="close"  >팝업닫기</button>
				</div>
			   	<div class="layer_body">		
			   	
						<div class="h4group" >
							<h5 class="tit"  style="font-size: 16px;" id="req_cnts"><h5><!-- 요청내용 -->
						</div>
					   	<section class="secwrap">
							<div class="srcharea"> 
								<textarea id="REQ_RSN" rows="10"  style="width:100%;"></textarea>
							</div>
					   	</section>	
					   	
						<section class="btnwrap mt20"  >
								<div class="btn" style="float:right" id="BR"></div>
						</section>
						<input type="hidden" name ="pagedata"  id="pagedata"/> 
				</div>
		</div>
</body>
</html>