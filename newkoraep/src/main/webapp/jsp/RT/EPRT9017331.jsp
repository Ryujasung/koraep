<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />

<script type="text/javaScript" language="javascript" defer="defer">   

var parent_item; 
var whsdlList;

$(document).ready(function(){
	
	whsdlList = jsonObject($('#whsdlList').val());

	 //버튼 셋팅
	fn_btnSetting('EPRT9017331');
	
	parent_item = window.frames[$("#pagedata").val()].parent_item;
	 
	/************************************
	 * 취소 버튼 클릭 이벤트
	 ***********************************/
	$("#btn_cnl").click(function(){
		$('[layer="close"]').trigger('click');
	});

	/************************************
	 * 거래처명 변경 이벤트
	 ***********************************/
	$("#WHSDL_BIZRNM").change(function(){
		fn_whsdl_bizrnm();
	});
	
	
	/************************************
	 * 저장 버튼 클릭 이벤트
	 ***********************************/
	$("#btn_reg").click(function(){
		fn_reg_chk();
	});
	
	fn_init();
	
	
});

	//선택데이터 팝업화면에 셋팅
	function fn_init() {  
		kora.common.setEtcCmBx2(whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');		//도매업자 업체명
		kora.common.setEtcCmBx2("", "","", $("#WHSDL_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');//지점
		$('#title_sub').text('<c:out value="${titleSub}" />');	//타이틀
		
		$("#WHSDL_BIZRNM").select2();

 	}
	
	//지점 조회
	function fn_whsdl_bizrnm(){
 		var url = "/RT/EPRT9017331_19.do" 
		var input ={};
 		//$("#WHSDL_BIZRNM").select2("val","");
 		if($("#WHSDL_BIZRNM").val() !=""){
 			var arr	 =[];
 			arr	 = $("#WHSDL_BIZRNM").val().split(";");
 			input["BIZRID"]				= arr[0];	
 			input["BIZRNO"]				= arr[1];
 			
 			for(var i=0;i<whsdlList.length;i++){
	 			if($("#WHSDL_BIZRNM").val() ==whsdlList[i].CUST_BIZRID_NO ){
	 				$("#WHSDL_BIZRNO").text(kora.common.setDelim(whsdlList[i].CUST_BIZRNO_DE, "999-99-99999"));
	 				break;
	 			}
 			}
 	      	ajaxPost(url, input, function(rtnData) {
 	   				if ("" != rtnData && null != rtnData) {   
 						kora.common.setEtcCmBx2(rtnData.brch_nmList, "","", $("#WHSDL_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');//지점
 					}else{
 	   					alertMsg("error");
 	   				}
 	   		},false);
 		}else{
 			kora.common.setEtcCmBx2("", "","", $("#WHSDL_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');//지점
 		}
	}
	
	//저장 확인
  	function fn_reg_chk(){
  		if($("#WHSDL_BIZRNM").val() ==""){	//거래처
  			alertMsg("거래처를 선택해주세요.");
			return;
  		}else if($("#WHSDL_BRCH_NM").val() ==""){//거래처 지점
  			alertMsg("거래처 지점을 선택해주세요.");
			return;
  		}
		  confirm("거래처를 추가 하시겠습니까?","fn_reg");
  	}
	
 	 //저장
 	 function fn_reg(){
		var url 		="/RT/EPRT9017331_09.do" 
		var input 	= {};
		
		if($("#WHSDL_BIZRNM").val() !=""){//거래처
	 			var arr	 =[];
	 			arr	 = $("#WHSDL_BIZRNM").val().split(";");
	 			input["WHSDL_BIZRID"]				= arr[0];	
	 			input["WHSDL_BIZRNO"]			= arr[1];
	 			input["WHSDL_BIZRNM"]			= $("#WHSDL_BIZRNM option:selected").text();
		}
		if($("#WHSDL_BRCH_NM").val() !=""){//거래처 지점
	 			var arr	 =[];
	 			arr	 = $("#WHSDL_BRCH_NM").val().split(";");
	 			input["WHSDL_BRCH_ID"]		= arr[0];	
	 			input["WHSDL_BRCH_NO"]	= arr[1];
	 			input["WHSDL_BRCH_NM"]	= $("#WHSDL_BRCH_NM option:selected").text();
		}
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
	.srcharea .row .col .tit{
	width: 90px;  
	}
	
	#WHSDL_BIZRNO{
	font-size: 15px;
	padding-top: 5px;
	padding-left: 5px;
	}
</style>

<input type="hidden" id="whsdlList" value="<c:out value='${whsdlList}' />"/>

   	<div class="layer_popup" style="width:500px; margin-top: -317px" >
		<div class="layer_head">  
			<h1 class="layer_title" id="title_sub"></h1>
			<button type="button" class="layer_close" layer="close"  >팝업닫기</button>
		</div>
	   	<div class="layer_body">		
				<section class="secwrap"   id="params">
						<div class="srcharea"  > 
							<div class="row">
								<div class="col" >
									<div class="tit" >거래처명</div> 
									<div class="box"  >
										  <select id="WHSDL_BIZRNM" name="WHSDL_BIZRNM" style="width: 210px"></select>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col" >
									<div class="tit" >지점</div>  		
									<div class="box"  >
										  <select id="WHSDL_BRCH_NM" style="width: 210px"></select>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col" >
									<div class="tit" >사업자등록번호</div> 
									<div class="box"  >
										  <div class="txtbox" id="WHSDL_BIZRNO"></div>
									</div>
								</div>
							</div>
						</div>
				</section>
				<section class="btnwrap mt20"  >
						<div class="btn" style="float:right" id="BR"></div>
				</section>
				<input type="hidden" name ="pagedata"  id="pagedata"/> 
		</div>
	</div>
