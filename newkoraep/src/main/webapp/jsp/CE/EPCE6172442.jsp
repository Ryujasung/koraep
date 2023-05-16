<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
			
		var INQ_PARAMS;
		
		$(document).ready(function(){

			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			var searchDtl = jsonObject($('#searchDtl').val());
			var ctnrUseYn = jsonObject($('#ctnrUseYn').val());
			
			kora.common.setEtcCmBx2(ctnrUseYn, "", searchDtl.CTNR_USE_YN, $("#CAP_USE_YN"), "ETC_CD", "ETC_CD_NM", "N");
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			//버튼 셋팅
			fn_btnSetting();
						
			$('.tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			
			$('#WHSDL_BIZRNM').text(searchDtl.WHSDL_BIZRNM);
			$('#CTNR_NM').text(searchDtl.CTNR_NM);
			$('#MFC_BIZRNM').text(searchDtl.MFC_BIZRNM);
			
			$('#DLIVY_QTY_2016').text(kora.common.format_comma(searchDtl.DLIVY_QTY_2016));
			$('#DLIVY_QTY_2017').text(kora.common.format_comma(searchDtl.DLIVY_QTY_2017));
			$('#CFM_QTY_2016').text(kora.common.format_comma(searchDtl.CFM_QTY_2016));
			$('#CFM_QTY_2017').text(kora.common.format_comma(searchDtl.CFM_QTY_2017));
			$('#RTN_QTY_2017').text(kora.common.format_comma(searchDtl.RTN_QTY_2017));
			$('#DLIVY_QTY_SUM').text(kora.common.format_comma(searchDtl.DLIVY_QTY_SUM));
			$('#CFM_QTY_SUM').text(kora.common.format_comma(searchDtl.CFM_QTY_SUM));
			$('#RMN_QTY').text(kora.common.format_comma(searchDtl.RMN_QTY));

			
			$("#btn_upd").click(function(){
				fn_upd();
			});
			

			$("#btn_lst").click(function(){
				fn_lst();
			});
			
		});
		
		function fn_lst(){
			kora.common.goPageB('', INQ_PARAMS);
		}
		
		function fn_upd(){
			confirm("저장 하시겠습니까?", "fn_upd_exec");
		}
		
		function fn_upd_exec(){
			
			document.body.style.cursor = "wait";
			
			var data = {};
			data['PARAMS'] = JSON.stringify(INQ_PARAMS.PARAMS);
			data['APLC_GBN'] = $(':radio[name="APLC_GBN"]:checked').val();
			data['CAP_USE_YN'] = $('#CAP_USE_YN').val();
			
			var url  = "/CE/EPCE6172442_21.do";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					if(rtnData.RSLT_CD =="0000"){
						alertMsg(rtnData.RSLT_MSG, 'fn_lst');
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
				} else {
					alertMsg("error");
				}
				document.body.style.cursor = "default";
			});
						
		}
		
	</script>

	<style type="text/css">
		.row .tit{width: 77px;}
	</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="searchDtl" value="<c:out value='${searchDtl}' />"/>
<input type="hidden" id="ctnrUseYn" value="<c:out value='${ctnrUseYn}' />"/>

	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
			<div class="singleRow">
				<div class="btn" id="UR"></div>
			</div>
		</div>

		<section class="secwrap">
			<div class="write_area">
				<div class="write_tbl">
					<table>
						<colgroup>
							<col style="width: 80px;">
							<col style="width: 160px;">
							<col style="width: 80px;">
							<col style="width: 160px;">
						</colgroup>
						<tr>
							<th><span class="tit" id="whsdl_txt"></span></th>
							<td>
								<div class="row" >
									<div class="txtbox" id="WHSDL_BIZRNM"></div>&nbsp;
								</div>
							</td>
							<th><span class="tit" id="ctnr_nm_txt"></span></th>
							<td>
								<div class="row" >
									<div class="txtbox" id="CTNR_NM" ></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th><span class="tit" id="mfc_bizrnm_txt"></span></th>
							<td colspan="3">
								<div class="row" >
									<div class="txtbox" id="MFC_BIZRNM" ></div>&nbsp;
								</div>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</section>
		
		<section class="secwrap mt10">
			<div class="write_area">
				<div class="write_tbl">
					<table>
						<colgroup>
							<col style="width: 80px;">
							<col style="width: 160px;">
							<col style="width: 80px;">
							<col style="width: 160px;">
						</colgroup>
						<tr>
							<th>2016년 <span class="tit" id="dlivy_qty2_txt"></span></th>
							<td>
								<div class="row" style="text-align:right;">
									<div class="txtbox" id="DLIVY_QTY_2016" style="float:none;"></div>
								</div>
							</td>
							<th>2016년 <span class="tit" id="whrs_cfm_qty_txt"></span></th>
							<td>
								<div class="row" style="text-align:right;">
									<div class="txtbox" id="CFM_QTY_2016" style="float:none;"></div>
								</div>
							</td>
						</tr>
						<tr>
							<th>2017년 <span class="tit" id="dlivy_qty2_txt"></span></th>
							<td>
								<div class="row" style="text-align:right;">
									<div class="txtbox" id="DLIVY_QTY_2017" style="float:none;"></div>
								</div>
							</td>
							<th>2017년 <span class="tit" id="whrs_cfm_qty_txt"></span></th>
							<td>
								<div class="row" style="text-align:right;">
									<div class="txtbox" id="CFM_QTY_2017" style="float:none;"></div>
								</div>
							</td>
						</tr>
						<tr>
							<th><span class="tit" id="dlivy_qty_sum_txt"></span></th>
							<td>
								<div class="row" style="text-align:right;">
									<div class="txtbox" id="DLIVY_QTY_SUM" style="float:none;"></div>
								</div>
							</td>
							<th>2017년 <span class="tit" id="reg_rtn_qty_txt"></span></th>
							<td>
								<div class="row" style="text-align:right;">
									<div class="txtbox" id="RTN_QTY_2017" style="float:none;"></div>
								</div>
							</td>
						</tr>
						<tr>
							<th><span class="tit" id="rnt_psbl_rmn_qty_txt"></span></th>
							<td>
								<div class="row" style="text-align:right;">
									<div class="txtbox" id="RMN_QTY" style="float:none;"></div>
								</div>
							</td>
							<th><span class="tit" id="rtn_qty_sum_txt"></span></th>
							<td>
								<div class="row" style="text-align:right;">
									<div class="txtbox" id="CFM_QTY_SUM" style="float:none;"></div>
								</div>
							</td>
						</tr>
						<tr>
							<th><span class="tit" id="cap_aplc_trgt_txt"></span></th>
							<td>
								<div class="row" >
									<label class="rdo"><input type="radio" id="APLC_GBN" name="APLC_GBN" value="C" checked="checked"/><span>빈용기</span></label>
									<label class="rdo"><input type="radio" id="APLC_GBN" name="APLC_GBN" value="M" /><span>생산자</span></label>
									<label class="rdo"><input type="radio" id="APLC_GBN" name="APLC_GBN" value="T" /><span>전체</span></label>
								</div>
							</td>
							<th><span class="tit" id="cap_aplc_yn_txt"></span></th>
							<td>
								<div class="row" >
									<select id="CAP_USE_YN" name="CAP_USE_YN" style="width:200px"></select>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</section>
				
		<section class="btnwrap mt20" >
			<div class="btn" id="BL">
			</div>
			<div class="btn" style="float:right" id="BR">
			</div>
		</section>
	</div>
		
</body>
</html>
