<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>오류이력상세조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp"%>

<script type="text/javaScript" language="javascript" defer="defer">
	$(function() {
		fn_btnSetting("EPCE3961364");
		var parent_item = window.frames[$("#pagedata").val()].parent_item;
		$("#title_sub").text(parent_item.MENU_NM+" > "+ parent_item.BTN_NM);
		fn_sel(parent_item);
		/************************************
	 	 * 닫기 버튼 클릭 이벤트
	 	 ***********************************/
	 	$("#btn_cnl").click(function(){
		 $('[layer="close"]').trigger('click');
	 	});
	});
	function fn_sel(data) {
		var input = {};
		/* var PAGE_REG_DTTM = $('[name="' + $("#pagedata").val() + '"]')	.contents().find('#PAGE_REG_DTTM').val(); */
	
		var url = "/CE/EPCE3961301_194.do"
		input["REG_DTTM"] = data.REG_DTTM;
		ajaxPost(url, input, function(rtnData) {
			if (rtnData != null && rtnData != "") {
				$('#ERR_MSG').text(rtnData.ERR_MSG);
				$('#ERR_CD').text(rtnData.ERR_CD);
				$('#ACPT_ERR').text(rtnData.ACPT_ERR);
				$('#PRAM').text(rtnData.PRAM);
			} else {
				alertMsg("error");
			}
		});
	}
</script>
</head>
<body>
	<div class="layer_popup" style="width: 696px;">
		<div class="layer_head">
			<h1 class="layer_title" id="title_sub"></h1>
			<button type="button" class="layer_close" layer="close">팝업닫기</button>
		</div>
		<div class="layer_body">
			<div class="secwrap" id="divInput">
				<div>오류내역 &emsp;: &emsp;
					<sapn id="ERR_MSG"style="width:100% ; text-align: center;  word-break:break-all"></sapn>
				</div>
				<div>오류코드 &emsp;: &emsp;
					<sapn id="ERR_CD"style="width:100% ; text-align: center;  word-break:break-all"></sapn>
				</div>
				<div>수신오류 &emsp;: &emsp;
					<sapn id="ACPT_ERR"style="width:100% ; text-align: center;  word-break:break-all"></sapn>
				</div>
				<div>파라미터 &emsp;: &emsp;
					<div id="PRAM"style="width:550px; text-align: left;  word-break:break-all; float:right"></div>
				</div>
			</div>

			 <section class="btnwrap mt20"  >
					<div class="btn" id="BL"></div>
					<div class="btn" style="float:right" id="BR"></div>
		 	 </section>
			<input type="hidden" id="pagedata" />
		</div>
	</div>
</body>
</html>