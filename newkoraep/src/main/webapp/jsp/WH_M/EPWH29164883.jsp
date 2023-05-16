<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>실태조사요청정보</title>
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

var parent_item; 
var jParams = {};
var INQ_PARAMS; //파라미터 데이터
$(document).ready(function(){

	 //버튼 셋팅
	 fn_btnSetting('EPWH29164883');
	
	//parent_item = window.frames[$("#pagedata").val()].parent_item;
	
	INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());//파라미터 데이터
	/************************************
	 * 닫기 
	 ***********************************/
	$("#btn_cnl, .btn_back").click(function(){
	    //페이지이동
	    kora.common.goPageB('/WH/EPWH2916401.do', INQ_PARAMS);

	    //kora.common.iWebAction('6001');
	});
	

	/************************************
	 * 저장 버튼 클릭 이벤트
	 ***********************************/
	$("#btn_reg").click(function(){
		fn_reg_chk();
	});
	
	fn_init();
	$('#req_cnts').text(parent.fn_text('req')+parent.fn_text('cnts')); 	 //요청내용
	$('#proc_cnts').text(parent.fn_text('proc')+parent.fn_text('cnts')); //처리내용
	
});

//선택데이터 팝업화면에 셋팅
	function fn_init() {
		var input = {};
		var url = "/WH/EPWH29164883_19.do";
		input["RSRC_DOC_NO"] = INQ_PARAMS.PARAMS.RSRC_DOC_NO;

		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != ""){
				$('#title_sub').text(rtnData.titleSub);
				if(rtnData.initList[0] !=null){    
					/* $("#REQ_RSN").val(rtnData.initList[0].REQ_RSN);
					$("#PROC_RST").val(rtnData.initList[0].PROC_RST); */
					$("#REQ_RSN").html(rtnData.initList[0].REQ_RSN);
					$("#PROC_RST").html(rtnData.initList[0].PROC_RST);
				}
			} 
			else {
				alertMsg("error");
			}
		});
  }
  function fn_reg_chk(){
	  if(kora.common.null2void($.trim($("#PROC_RST").val())) == ""){
			alertMsg("처리내용을 작성하지 않았습니다.");
			return;
		}
	  confirm("조사처리내용을 저장 하시겠습니까?","fn_reg");
  }
  //요청처리 저장
  function fn_reg(){
	  var input ={};
	  var url ="/WH/EPWH29164883_21.do"
	  input["PROC_RST"]			 = $("#PROC_RST").val();
	  input["RSRC_DOC_NO"] 	 = parent_item.RSRC_DOC_NO;
	  ajaxPost(url, input, function(rtnData){
			if(rtnData.RSLT_CD == "0000"){
				alertMsg(rtnData.RSLT_MSG);	
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
<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
<input type="hidden" id="cate" value="sbj">
	<div id="wrap">
	
		<%@include file="/jsp/include/header_m_pop.jsp" %>
		
		<%-- <%@include file="/jsp/include/aside_m.jsp" %> --%>
			
		<div id="container">

			<div id="subvisual">
				<h2 class="tit">조사요청정보</h2>
				<a href="#self" class="btn_back"><span class="hide">뒤로가기</span></a>
			</div><!-- id : subvisual -->

			<div id="contents">
				<div class="contbox bdn v3 pb55">
					<div class="tab_area">
						<ul>
							<li class="on"><button type="button">요청내용</button></li>
							<li><button type="button">처리내용</button></li>
						</ul>
					</div>
					<div class="tab_cont">
						<div id="REQ_RSN" class="tab_box on"></div>
						<div id="PROC_RST" class="tab_box"></div>
					</div>
					<div class="btn_wrap mt30">
						<div class="fl_c">
							<a id="btn_cnl" href="#self" class="btn70 c1" style="width: 220px;">닫기</a>
						</div>
					</div>
				</div>
				<script>newriver.tabAction('.tab_area ul', '.tab_cont');</script>
			</div><!-- id : contents -->

		</div><!-- id : container -->

		<%@include file="/jsp/include/footer_m.jsp" %>
		
	</div><!-- id : wrap -->

</body>
</html>