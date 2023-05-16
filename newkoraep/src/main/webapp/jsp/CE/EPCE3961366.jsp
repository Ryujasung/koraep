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
		fn_btnSetting("EPCE3961366");
		var parent_item = window.frames[$("#pagedata").val()].parent_item;
		$("#title_sub").text("API전송상세이력 > API전송상세이력상세");
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
		var url = "/CE/EPCE3961366_194.do"
		input["REG_SN"] = data.REG_SN;
		input["REG_DT"] = data.REG_DT;
		
		ajaxPost(url, input, function(rtnData) {
			if (rtnData != null && rtnData != "") {
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
				<div>전문내용 &emsp;: &emsp;
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