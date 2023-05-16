<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">

		var parent_item;
		var EXCA_STD_CD;
	
		$(document).ready(function(){
			
			fn_btnSetting('EPCE47072883');
			parent_item = window.frames[$("#pagedata").val()].parent_item;
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			$('#mfc_bizrnm').text(parent.fn_text('mfc_bizrnm') );
			$('#exca_term').text(parent.fn_text('exca_term') );
			
			$('#EXCA_STD_NM').text(parent_item.EXCA_STD_NM);
			
			var input = {};
			input["EXCA_STD_CD"] = parent_item.EXCA_STD_CD_SEL;
			var url = "/CE/EPCE47072883_19.do";
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					kora.common.setEtcCmBx2(rtnData.searchList, "", "", $("#MFC_BIZR_SEL"), "BIZRID_NO", "BIZRNM", "N", "S");
				}else{
				}
			},false);
			
			
			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			$("#btn_upd").click(function(){
				fn_upd();
			});
			
		});
		
		function fn_cnl(){
			$('[layer="close"]').trigger('click');
		}
				
		//저장
		function fn_upd(){
			
			if($('#MFC_BIZR_SEL').val() == ''){
				alertMsg('생산자를 선택해 주세요.');
				return;
			}
			
			 window.frames[$("#pagedata").val()].parent_item["MFC_BIZR_SEL"] = $('#MFC_BIZR_SEL').val();
			
			confirm('해당하는 전체 정산서가 발급 취소됩니다.\n계속 진행하시겠습니까?', 'fn_upd_exec');
			
		}
		
		function fn_upd_exec(){
			
			window.frames[$("#pagedata").val()].fn_upd_exec();
			$('[layer="close"]').trigger('click');
			
		}
				
	</script>

</head>
<body>
	<div class="layer_popup" style="width:650px;">
	
		<input type="hidden" id="pagedata"/> 
		
			<div class="layer_head">
				<h1 class="layer_title" id="title_sub"></h1>
				<button type="button" class="layer_close" layer="close"></button>
			</div>
			<div class="layer_body" style="padding-top:10px">
				<div class="secwrap" id="divInput">
					<div class="write_area">
						<div class="write_tbl">
							<table>
								<colgroup>
									<col style="width: 150px;">
									<col style="width: auto;">
								</colgroup>
								<tr>
									<th ><span id="exca_term"></span></th>
									<td>
										<div class="row">
											<div class="txtbox" id="EXCA_STD_NM"></div>&nbsp;
										</div>
									</td>
								</tr>
								<tr>
									<th ><span id="mfc_bizrnm"></span></th>
									<td>
										<div class="row">
											<select id="MFC_BIZR_SEL" name="MFC_BIZR_SEL" style="width: 179px" class="i_notnull"></select>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<div class="btnwrap">
							<div class="fl_l" id="BL">
							</div>
							<div class="fl_r" id="BR">
							</div>
						</div>
					</div>
				</div>
			</div>
	</div>
</body>
</html>
