<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">

		var parent_item;
	
		$(document).ready(function(){
			
			fn_btnSetting('EPCE6172588');
			
			parent_item = window.frames[$("#pagedata").val()].parent_item;
			
			$('#title_sub').text('<c:out value="${titleSub}" />');

			$('.write_tbl table tr th span').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			
			
			$('#WHSDL_BIZRNM').text(parent_item.WHSDL_BIZRNM);
			$('#CTNR_NM').text(parent_item.CTNR_NM);
			
			$('#RTN_QTY').text(kora.common.format_comma(parent_item.RTN_QTY));
			$('#RTRVL_REVI_QTY').val(kora.common.format_comma(parent_item.REVI_QTY));
			
			
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
		
		function fn_upd(){
			confirm('저장 하시겠습니까?', 'fn_upd_exec');
		}
		
		function fn_upd_exec(){
		
			var data = {};
			data['PARAMS'] = JSON.stringify(parent_item);
			data['RTRVL_REVI_QTY'] = $('#RTRVL_REVI_QTY').val().replace(/\,/g,"");
			
			var url  = "/CE/EPCE6172588_21.do";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					window.frames[$("#pagedata").val()].fn_sel();
					alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
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
		
		<div class="layer_head" >
			<h1 class="layer_title" id="title_sub"></h1>
			<button type="button" class="layer_close" layer="close"></button>
		</div>
		<div class="layer_body">
			<div class="secwrap" id="divInput_P">
				<div class="write_area">
					<div class="write_tbl">
						<table>
							<colgroup>
								<col style="width: 150px;">
								<col style="width: auto;">
							</colgroup>
							<tr>
								<th><span id="whsdl_txt"></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="WHSDL_BIZRNM"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th><span id="ctnr_nm_txt"></span></th>
								<td>
									<div class="row" >
										<div class="txtbox" id="CTNR_NM"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th><span id="rtn_qty2_txt"></span></th>
								<td>
									<div class="row" >
										<div class="txtbox" id="RTN_QTY"></div>&nbsp;
									</div>
								</td>
							</tr>
							<tr>
								<th><span id="rtn_revi_qty_txt"></span></th>
								<td>
									<div class="row" >
										<input type="text" id="RTRVL_REVI_QTY" style="width:179px" format="minus" />
										<div class="txtbox" ></div>&nbsp;
									</div>
								</td>
							</tr>
						</table>
	
					</div>
					
				</div>
				
				<div class="btnwrap mt20">
					<div class="fl_l" id="BL">
					</div>
					<div class="fl_r" id="BR">
					</div>
				</div>
				
			</div>
		</div>
	</div>
</body>
</html>
