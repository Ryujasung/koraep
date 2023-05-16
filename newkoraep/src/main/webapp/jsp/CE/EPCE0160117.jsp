<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>도매업자 직매장/공장관리 지역일괄설정</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

var parent_item; 
var aff_ogn_cd_list;

$(document).ready(function(){

	 //버튼 셋팅
	fn_btnSetting('EPCE0160117');

	parent_item = window.frames[$("#pagedata").val()].parent_item;
	$('input:radio[name=PAY_YN]:input[value=' + parent_item.PAY_YN + ']').attr("checked", true);
	 
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
	
	fn_init();
});

	//선택데이터 팝업화면에 셋팅
	function fn_init() {
		$('#title_sub').text('<c:out value="${titleSub}" />');//타이틀
 	}
	//저장 확인
  	function fn_reg_chk(){
		confirm("지급제회설정이 저장 됩니다. 계속 진행하시겠습니까?","fn_reg");
  	}
 	 //저장
 	 function fn_reg(){
		var url ="/CE/EPCE0160117_21.do"
		var input = {"list": ""};
		
		input["BIZRID"] = parent_item.BIZRID;
		input["BIZRNO"] = parent_item.BIZRNO;
		input["PAY_YN"] = $(':radio[name="PAY_YN"]:checked').val();
		
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
</head>
<body>

<input type="hidden" id="aff_ogn_cd_list" value="<c:out value='${aff_ogn_cd_list}' />"/>

    	<div class="layer_popup" style="width:700px; margin-top: -317px" >
			<div class="layer_head">
				<h1 class="layer_title" id="title_sub"></h1>
				<button type="button" class="layer_close" layer="close"  >팝업닫기</button>
			</div>
		   	<div class="layer_body">
				<div class="h4group" >
					<h5 class="tit"  style="font-size: 16px;" id=""><h5>
				</div>
				
				<div class="row" style="padding-left: 250px;" >
					<label class="rdo"><input type="radio" id="PAY_YN" name="PAY_YN" value="Y" checked="checked"/><span>지급</span></label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<label class="rdo"><input type="radio" id="PAY_YN" name="PAY_YN" value="N" /><span>지급제외</span></label>
				</div>
				<section class="btnwrap mt20"  >
					<div class="btn" style="float:right" id="BR"></div>
				</section>
				<input type="hidden" name ="pagedata"  id="pagedata"/> 
			</div>
		</div>
</body>
</html>