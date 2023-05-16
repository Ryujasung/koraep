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
			
			parent_item = window.frames[$("#pagedata").val()].parent_item;
			
			$("#title_sub").text("<c:out value="${titleSub}" />");
			
			$('#whsdl_nm').text(parent.fn_text('whsdl_nm'));
			$('#brch_nm').text(parent.fn_text('brch_nm'));
			$('#bizr_tp_cd').text(parent.fn_text('bizr_tp_cd'));
			$('#bizrno').text(parent.fn_text('bizrno'));
			$('#brch_nm').text(parent.fn_text('brch_nm'));
			$('#cust_bizrnm').text(parent.fn_text('cust_bizrnm'));
            $('#bizr_se').text(parent.fn_text('bizr_se'));
			
			//작성체크용
			//$('#BIZR_TP_CD').attr('alt', parent.fn_text('bizr_tp'));
			$('#CUST_BIZRNM').attr('alt', parent.fn_text('cust_bizrnm'));
			
			$('#WHSDL_BIZRNM').text(parent_item.WHSDL_BIZRNM);
			$('#WHSDL_BRCH_NM').text(parent_item.WHSDL_BRCH_NM);
			$('#CUST_BIZRNO_DE').text(kora.common.setDelim(parent_item.CUST_BIZRNO_DE, "999-99-99999"));
			$('#BIZR_SE_NM').text(parent_item.BIZR_SE_NM);
			$('#CUST_BIZRNM').val(parent_item.CUST_BIZRNM);
			
			//var bizrTpList = {bizrTpList};
			//kora.common.setEtcCmBx2(bizrTpList, "", "", $("#BIZR_TP_CD"), "ETC_CD", "ETC_CD_NM", "N", "S");
			
			$('#BIZR_TP_CD_NM').text(parent_item.BIZR_TP_CD_NM);
			
			if(parent_item.BIZR_SE_CD == 'H'){// 사업자구분이 수기일때만 변경 가능
				fn_btnSetting('EPWH0121888');
			
				$("#btn_cnl").click(function(){
					fn_cnl();
				});
				
				$("#btn_reg").click(function(){
					fn_reg();
				});
			}else{
				//$('#BIZR_TP_CD').prop("disabled", true);
				$('#CUST_BIZRNM').prop("disabled", true);
			}

		});
		
		function fn_cnl(){
			window.frames[$("#pagedata").val()].fn_sel();
			$('[layer="close"]').trigger('click');
		}
		
		function fn_reg(){
			
			if(!kora.common.cfrmDivChkValid("params")) {
				return;
			}
						
			confirm("저장 하시겠습니까?","fn_reg_exec");
			
		}
		
		function fn_reg_exec(){
			
			var input = {};
			input  = parent_item;
			
			//input['BIZR_TP_CD_M'] = $('#BIZR_TP_CD option:selected').val();
			input['CUST_BIZRNM_M'] = $('#CUST_BIZRNM').val();
			
		 	var url = "/WH/EPWH0121888_21.do";
		 	ajaxPost(url, input, function(rtnData){
			 	if ("" != rtnData && null != rtnData) {
			 		if(rtnData.RSLT_CD == '0000'){
						alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
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
	<input type="hidden" id="pagedata"/>
	<div class="layer_popup" style="width:600px">
		<div class="layer_head">
			<h1 class="layer_title title"  id="title_sub"></h1>
			<button type="button" class="layer_close" layer="close"></button>
		</div>
		<div class="layer_body">
			<section class="secwrap">
				<div class="write_area">
					<div class="write_tbl" id="params">
						<table>
							<colgroup>
								<col style="width: 110px;">
								<col style="width: auto;">
							</colgroup>
							<tr>
								<th ><span id="whsdl_nm"></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="WHSDL_BIZRNM"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th ><span id="brch_nm"></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="WHSDL_BRCH_NM"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th ><span id="bizr_tp_cd"></span></th>
								<td>
									<div class="row">
										<!-- <select id="BIZR_TP_CD" name="BIZR_TP_CD" style="width: 179px;" class="i_notnull"></select>  -->
										<div class="txtbox" id="BIZR_TP_CD_NM"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th ><span id="bizrno"></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="CUST_BIZRNO_DE"></div>
									</div>
								</td>
							</tr> 
							<tr>
								<th ><span id="cust_bizrnm"></span><span class="red">*</span></th>
								<td>
									<div class="row">
										<input type="text" id="CUST_BIZRNM" name="CUST_BIZRNM" style="width: 390px;" class="i_notnull" maxByteLength="90">
									</div>
								</td>
							</tr>
                            <tr>
                                <th ><span id="bizr_se"></span></th>
                                <td>
                                    <div class="row">
                                        <div class="txtbox" id="BIZR_SE_NM"></div>
                                    </div>
                                </td>
                            </tr> 
						</table>
					</div>
				</div>
				<div class="h4group" >
					<h5 class="tit"  style="font-size: 16px;">
						※ 사업자구분이 '수기' 인 건만 변경이 가능합니다.
					</h5>
				</div>
			</section>
			<section class="btnwrap mt10">
				<div class="fl_r" id="BR">
				</div>
			</section>
		</div>
	</div>
</body>
</html>
