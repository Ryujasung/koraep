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
		var EXCA_STAT_CD;
		var STAT_CNT;
	
		$(document).ready(function(){
			var bizr_tp_cd_sel = jsonObject($('#bizr_tp_cd_sel').val());
			
			fn_btnSetting('EPCE0120602');
			
			parent_item = window.frames[$("#pagedata").val()].parent_item;

			$("#BIZRNM").text( parent_item.BIZRNM );
			$("#MFC_BRCH_NM").text( parent_item.MFC_BRCH_NM );
			$("#CUST_BIZRNM").text( parent_item.CUST_BIZRNM );
			$("#BIZRNO_DE").text( parent_item.BIZRNO_DE );
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			$('#mfc_bizrnm').text(parent.fn_text('mfc_bizrnm'));
			$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm'));
			$('#cust_bizrnm').text(parent.fn_text('cust_bizrnm'));
			$('#bizrno').text(parent.fn_text('bizrno'));
			$('#bizr_tp_cd').text(parent.fn_text('bizr_tp_cd'));
			
			kora.common.setEtcCmBx2(bizr_tp_cd_sel, "", parent_item.BIZR_TP_CD, $("#BIZR_TP_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "");
			
			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
		});
		
		function fn_reg(){
			confirm('거래구분을 변경 합니다. 계속 진행하시겠습니까?', 'fn_reg_exec');
		}
		
		function fn_reg_exec(){
			var data = {};
			data["MFC_BRCH_ID"] = parent_item.MFC_BRCH_ID;
			data["MFC_BRCH_NO"] = parent_item.MFC_BRCH_NO;
			data["MFC_BIZRID"] = parent_item.MFC_BIZRID;
			data["MFC_BIZRNO"] = parent_item.MFC_BIZRNO;
			data["CUST_BRCH_ID"] = parent_item.CUST_BRCH_ID;
			data["CUST_BRCH_NO"] = parent_item.CUST_BRCH_NO;
			data["CUST_BIZRID"] = parent_item.CUST_BIZRID;
			data["CUST_BIZRNO"] = parent_item.CUST_BIZRNO;
			data["BIZR_TP_CD"] = $("#BIZR_TP_CD_SEL").val();
			
			var url  = "/CE/EPCE0120602_21.do";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
				} else {
					alertMsg("error");
				}
			});
			
		}
		
		function fn_cnl(){
			window.frames[$("#pagedata").val()].fn_sel();
			$('[layer="close"]').trigger('click');
		}
		
	</script>

</head>
<body>
	<div class="layer_popup" style="width:650px;">
	
		<input type="hidden" id="pagedata"/> 
		<input type="hidden" id="bizr_tp_cd_sel" value="<c:out value='${bizr_tp_cd_sel}' />"/>
		
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
								<th><span id="mfc_bizrnm"></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="BIZRNM"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th><span id="mfc_brch_nm"></span></th>
								<td>
									<div class="row" >
										<div class="txtbox" id="MFC_BRCH_NM"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th><span id="cust_bizrnm"></span></th>
								<td>
									<div class="row" >
										<div class="txtbox" id="CUST_BIZRNM"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th><span id="bizrno"></span></th>
								<td>
									<div class="row" >
										<div class="txtbox" id="BIZRNO_DE"></div>&nbsp;
									</div>
								</td>
							</tr>
							<tr>
								<th><span id="bizr_tp_cd"></span></th>
								<td>
									<div class="box">
										<select id="BIZR_TP_CD_SEL" name="BIZR_TP_CD_SEL" style="width: 179px" class="i_notnull"></select>
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
