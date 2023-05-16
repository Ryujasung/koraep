<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>거래처 추가</title>
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

<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />

<style>
.select2-container .select2-choice {
	font-size: 27px;
    height: 60px;
}
.select2-results .select2-result-label {
	font-size:27px;
}
.select2-container  #select2-chosen-1{
 margin-top: 17px;
 margin-left: 19px;
}
.select2-container .select2-choice .select2-arrow {
 padding-top: 17px;
}
</style>

<script type="text/javaScript" language="javascript" defer="defer">   

var INQ_PARAMS;	//파라미터 데이터
var whsdlList;

$(document).ready(function(){
	
	whsdlList = jsonObject($('#whsdlList').val());
	INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());

	 //버튼 셋팅
	//fn_btnSetting('EPRT9017331');
	
	//parent_item = window.frames[$("#pagedata").val()].parent_item;
	 
	/************************************
	 * 취소 버튼 클릭 이벤트
	 ***********************************/
	$("#btn_cnl").click(function(){
		fn_cnl();
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
		
		$("#WHSDL_BIZRNM").select2();
		
 	}
	
	//취소버튼 이전화면으로
    function fn_cnl(){
   	 	kora.common.goPageB('', INQ_PARAMS);
    }
	
	//지점 조회
	function fn_whsdl_bizrnm(){
 		var url = "/RT/EPRT9017331_19.do" 
		var input ={};

 		if($("#WHSDL_BIZRNM").val() !=""){
 			var arr = [];
 			arr	 = $("#WHSDL_BIZRNM").val().split(";");
 			input["BIZRID"]				= arr[0];	
 			input["BIZRNO"]				= arr[1];

 			for(var i=0;i<whsdlList.length;i++){
	 			if($("#WHSDL_BIZRNM").val() == whsdlList[i].CUST_BIZRID_NO ){
	 				console.log(whsdlList[i].CUST_BIZRNO_DE);
	 				$("#WHSDL_BIZRNO").val(kora.common.setDelim(whsdlList[i].CUST_BIZRNO_DE, "999-99-99999"));
	 				console.log($("#WHSDL_BIZRNO").val());
	 				break;
	 			}
 			}
 	      	ajaxPost(url, input, function(rtnData) {
 	   				if ("" != rtnData && null != rtnData) {   
 						kora.common.setEtcCmBx2(rtnData.brch_nmList, "","", $("#WHSDL_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');//지점
 					}else{
 	   					alert("error");
 	   				}
 	   		},false);
 		}else{
 			kora.common.setEtcCmBx2("", "","", $("#WHSDL_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');//지점
 		}
	}
	
	//저장 확인
  	function fn_reg_chk(){
  		if($("#WHSDL_BIZRNM").val() ==""){	//거래처
  			alert("거래처를 선택해주세요.");
			return;
  		}else if($("#WHSDL_BRCH_NM").val() ==""){//거래처 지점
  			alert("거래처 지점을 선택해주세요.");
			return;
  		}
		if(confirm("거래처를 추가 하시겠습니까?")){
			fn_reg();
		}
  	}
	
 	 //저장
 	 function fn_reg(){
		var url 		="/RT/EPRT9017331_09.do" 
		var input 	= {};
		
		if($("#WHSDL_BIZRNM").val() !=""){//거래처
	 			var arr	 =[];
	 			arr	 = $("#WHSDL_BIZRNM").val().split(";");
	 			input["WHSDL_BIZRID"]			= arr[0];	
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
					alert(rtnData.RSLT_MSG);	
					fn_cnl();
				}else{
					alert(rtnData.RSLT_MSG);
				}
		});
 	 }
</script>

</head>
<body>

<input type="hidden" id="whsdlList" value="<c:out value='${whsdlList}' />"/>
<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>

   	<div id="wrap">
	
		<%@include file="/jsp/include/header_m.jsp" %>
		
		<%@include file="/jsp/include/aside_m.jsp" %>

		<div id="container">

			<div id="subvisual">
				<h2 class="tit" id="title"></h2>
				<a href="#self" class="btn_back" id="btn_cnl"><span class="hide">뒤로가기</span></a>
			</div><!-- id : subvisual -->

			<div id="contents">
			
				<div class="contbox pb50" id="divInput">
					<div class="box_wrap" style="margin: -20px 0 0">
						<div class="boxed v2 mt10">
							<div class="sort" id="">거래처명</div>
							<div class="cont">
								<select id="WHSDL_BIZRNM" style="width: 450px;" class="i_notnull"></select>
							</div>
						</div>
						<div class="boxed v2 mt10">
							<div class="sort" id="">지점</div>
							<div class="cont">
								<select id="WHSDL_BRCH_NM" style="width: 450px;" class="i_notnull"></select>
							</div>
						</div>
					</div>
					<div class="box_wrap">
						<div class="boxed v2">
							<div class="sort" id="" style="width:205px">사업자등록번호</div>
							<div class="cont" style="width:300px"><input type="text" id="WHSDL_BIZRNO" style="width:300px;border:0px;background:#ffffff !important;" disabled/></div>
						</div>
					</div>
				</div>

				<div class="btn_wrap mt15">
					<div class="fl_r">
						<button class="btnCircle c1" id="btn_reg">등록</button>
					</div>
				</div>

			</div><!-- id : contents -->

		</div><!-- id : container -->

		<%@include file="/jsp/include/footer_m.jsp" %>

	</div><!-- id : wrap -->

</body>	
</html>

