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
			
			fn_btnSetting('EPCE2393088');
			parent_item = window.frames[$("#pagedata").val()].parent_item;
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			$('#risu_rsn').text(parent.fn_text('risu_rsn') );
			$('#add_amt').text(parent.fn_text('add_amt') );
			$('#add_amt_se').text(parent.fn_text('add_amt_se') );
			
			$('#RISU_RSN').attr('alt', parent.fn_text('risu_rsn') );
			$('#ADD_AMT').attr('alt', parent.fn_text('add_amt') );
			$('#ADD_AMT_SE').attr('alt', parent.fn_text('add_amt_se') );
			
			//가산금구분 옵션셋팅
			if(kora.common.null2void(parent_item.BILL_SE_CD) == 'G'){ //보증금
				$('#ADD_AMT_SE').append('<option value="G" selected>보증금</option>');
				$('#ADD_AMT_SE').append('<option value="E">기타</option>');
			}else if(kora.common.null2void(parent_item.BILL_SE_CD) == 'F'){ //취급수수료
				$('#ADD_AMT_SE').append('<option value="F" selected>수수료</option>');
				$('#ADD_AMT_SE').append('<option value="E">기타</option>');
			}else{
				$('#ADD_AMT_SE').append('<option value="G" selected>보증금</option>');
				$('#ADD_AMT_SE').append('<option value="F">수수료</option>');
				$('#ADD_AMT_SE').append('<option value="E">기타</option>');
			}
			
			$('#RISU_RSN').val(kora.common.null2void(parent_item.RISU_RSN));
			$('#ADD_AMT').val(kora.common.null2void(parent_item.ADD_AMT));
			
			if(kora.common.null2void(parent_item.ADD_AMT_SE) == ''){
				//$('#ADD_AMT_SE').val(parent_item.BILL_SE_CD);
			}else{
				$('#ADD_AMT_SE').val(kora.common.null2void(parent_item.ADD_AMT_SE));
			}
			
			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
		});
		
		function fn_cnl(){
			$('[layer="close"]').trigger('click');
		}
		
		function fn_cnl2(){
			window.frames[$("#pagedata").val()].fn_reload();
			$('[layer="close"]').trigger('click');
		}
		
		//저장
		function fn_reg(){
			
			if(!kora.common.cfrmDivChkValid("divInput")) {
				return;
			}
			
			confirm('저장하시겠습니까?', 'fn_reg_exec');
			
		}
		
		function fn_reg_exec(){
			
			var input = parent_item;

			input["ADD_AMT_SE"] = $('#ADD_AMT_SE').val();
			input["ADD_AMT"] = $('#ADD_AMT').val();
			input["RISU_RSN"] = $('#RISU_RSN').val();

			var url = "/CE/EPCE2393088_21.do";
			ajaxPost(url, input, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					if(rtnData.RSLT_CD = '0000'){
						alertMsg(rtnData.RSLT_MSG, 'fn_cnl2');
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
				} else {
					alertMsg("error");
				}
			});
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
									<th ><span id="add_amt_se"></span></th>
									<td>
										<div class="row">
											<select id="ADD_AMT_SE" style="width: 179px" class="i_notnull">
											</select>
										</div>
									</td>
								</tr>
								<tr>
									<th ><span id="add_amt"></span></th>
									<td>
										<div class="row">
											<input type="text" id="ADD_AMT" name="ADD_AMT" style="width: 179px;" class="i_notnull" maxLength="13" format="number">
										</div>
									</td>
								</tr>
								<tr>
									<th ><span id="risu_rsn"></span></th>
									<td>
										<div class="row" style="padding-top:5px;padding-bottom:5px">
											<textarea id="RISU_RSN" rows="10"  style="width:100%;" class="i_notnull"></textarea>
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
