<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
			
		var INQ_PARAMS;
		var searchList;
		var searchDtl;
		
		$(document).ready(function(){

			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			searchList = jsonObject($('#searchList').val());
			searchDtl = jsonObject($('#searchDtl').val());
			var searchData = jsonObject($('#searchData').val());
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			//버튼 셋팅
			fn_btnSetting();
						
			$('.tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			
			$('#STAC_DOC_NO').text(searchDtl.STAC_DOC_NO);
			//$('#EXCA_TERM').text(kora.common.setDelim(searchDtl.EXCA_ST_DT,'9999-99-99') +" ~ "+ kora.common.setDelim(searchDtl.EXCA_END_DT,'9999-99-99'));
			$('#EXCA_ISSU_SE_NM').text(searchDtl.EXCA_ISSU_SE_NM);
			$('#ACP_ACCT_NO').text(searchDtl.ACP_ACCT_NO);
			$('#EXCA_SE_NM').text(searchDtl.EXCA_SE_NM);
			$('#EXCA_AMT').text(kora.common.format_comma(searchDtl.EXCA_AMT) + " 원");
			$('#BIZRNM').text(searchDtl.BIZRNM);
			$('#BIZRNO_DE').text(kora.common.setDelim(searchDtl.BIZRNO_DE, '999-99-99999'));
			$('#RPST_NM').text(searchDtl.RPST_NM);
			$('#RPST_TEL_NO').text(searchDtl.RPST_TEL_NO);
			$('#ADDR').text(searchDtl.ADDR);
			
			if(INQ_PARAMS.PARAMS.EXCA_ISSU_SE_CD == 'G' || INQ_PARAMS.PARAMS.EXCA_ISSU_SE_CD == 'C'){
				$('#EXCA_PLAN_GTN_BAL').text(kora.common.format_comma(searchDtl.EXCA_PLAN_GTN_BAL) + " 원");
				$('#GTN_BAL_INDE_AMT').text(kora.common.format_comma(searchDtl.GTN_BAL_INDE_AMT) + " 원"); //GTN_INDE
				$('#EXCA_GTN_BAL').text(kora.common.format_comma(searchDtl.EXCA_GTN_BAL) + " 원");
				$('#AGTN_BAL_PAY_AMT').text(kora.common.format_comma(searchDtl.AGTN_BAL_PAY_AMT) + " 원");
				$('#AGTN_INDE_AMT').text(kora.common.format_comma(searchDtl.AGTN_INDE_AMT) + " 원");
				$('#AGTN_BAL').text(kora.common.format_comma(searchDtl.AGTN_BAL) + " 원");
				$('#DRVL_BAL_PAY_AMT').text(kora.common.format_comma(searchDtl.DRVL_BAL_PAY_AMT) + " 원");
				$('#DRVL_BAL_MDT_AMT').text("0 원"); //없음
				$('#DRVL_BAL').text(kora.common.format_comma(searchDtl.DRVL_BAL) + " 원");
				
				$('#EXCA_ISSU_SE_CD_G').show();
			}
			
			//그리드 셋팅
			if(searchList.length > 0){ fn_set_grid(); }else{ $('#gridDiv').hide(); }

			//목록
			$("#btn_lst").click(function(){
				fn_lst();
			});

			/************************************
			 * 인쇄 클릭 이벤트
			 ***********************************/
			$("#btn_pnt").click(function(){
				fn_pnt();
			});
			
		});
		
		 //인쇄
	   	function fn_pnt(){
	   		var stac_dc_no = searchDtl.STAC_DOC_NO;
			var day = stac_dc_no.substring(3,11);
			var number = parseInt(day);
			
			if(number > 20210609) {
		   		$('form[name="prtForm"] input[name="STAC_DOC_NO"]').val(INQ_PARAMS.PARAMS.STAC_DOC_NO);
		   		$('form[name="prtForm"] input[name="EXCA_ISSU_SE_CD"]').val('C');
	   			$('form[name="prtForm"] input[name="MFC_BIZRNO"]').val(INQ_PARAMS.PARAMS.MFC_BIZRNO);
	   			if(searchList.length > 0){ $('form[name="prtForm"] input[name="SEARCH_LIST4"]').val('Y'); }
	   			kora.common.gfn_viewReport('prtForm', '');
			}else{			
	   			$('form[name="prtForm3"] input[name="STAC_DOC_NO"]').val(INQ_PARAMS.PARAMS.STAC_DOC_NO);
	   			$('form[name="prtForm3"] input[name="EXCA_ISSU_SE_CD"]').val('C');
	   			$('form[name="prtForm3"] input[name="MFC_BIZRNO"]').val(INQ_PARAMS.PARAMS.MFC_BIZRNO);
	   			if(searchList.length > 0){ $('form[name="prtForm3"] input[name="SEARCH_LIST4"]').val('Y'); }
	   			kora.common.gfn_viewReport('prtForm3', '');
			}
	   		
	    }
		
		function fn_lst(){
			kora.common.goPageB('', INQ_PARAMS);
		}
		
		/**
		 * 그리드 관련 변수 선언
		 */
	    var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
		var gridApp, gridRoot, dataGrid, layoutStr, selectorColumn;
		var layoutStr = new Array();
		
		/**
		 * 메뉴관리 그리드 셋팅
		 */
		 function fn_set_grid() {
			 
			 rMateGridH5.create("grid", "gridHolder", jsVars, "100%", "100%");
			 layoutStr.push('<rMateGrid>');
			 layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			 layoutStr.push('<groupedColumns>');
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
			 layoutStr.push('	<DataGridColumn dataField="REQ_BIZRNM" headerText="'+parent.fn_text('exca_req_mfc')+'" width="200" />');
			 layoutStr.push('	<DataGridColumn dataField="TRGT_BIZRNM" headerText="'+parent.fn_text('exca_trgt_mfc')+'" width="200" itemRenderer="HtmlItem" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_DLIVY_QTY" id="sum1" headerText="'+parent.fn_text('exch_dlivy_qty')+'" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_DLIVY_GTN" id="sum2" headerText="'+parent.fn_text('exch_dlivy_gtn')+'" width="140" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_WRHS_QTY" id="sum3" headerText="'+parent.fn_text('exch_wrhs_qty')+'" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_WRHS_GTN" id="sum4" headerText="'+parent.fn_text('exch_wrhs_gtn')+'" width="140" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="SF_AMT" id="sum5" headerText="'+parent.fn_text('sf_amt')+'" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('</groupedColumns>');
			 layoutStr.push('		<footers>');
			 layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('				<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
			 layoutStr.push('				<DataGridFooterColumn/>');
			 layoutStr.push('				<DataGridFooterColumn/>');
			 layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum3}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum4}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum5}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('			</DataGridFooter>');
			 layoutStr.push('		</footers>');
			 layoutStr.push('</DataGrid>');
			 layoutStr.push('</rMateGrid>');
		}
		
		// 그리드 및 메뉴 리스트 세팅
		 function gridReadyHandler(id) {
		 	 gridApp = document.getElementById(id);  // 그리드를 포함하는 div 객체
		     gridRoot = gridApp.getRoot();   // 데이터와 그리드를 포함하는 객체
		     gridApp.setLayout(layoutStr.join("").toString());

		     var layoutCompleteHandler = function(event) {
		    	 dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		    	 gridApp.setData(searchList);
		    }
		    var dataCompleteHandler = function(event) {
		    }
		    
		    gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		    gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
		
	</script>

	<style type="text/css">
		.row .tit{width: 57px;}
	</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="searchDtl" value="<c:out value='${searchDtl}' />"/>
<input type="hidden" id="searchData" value="<c:out value='${searchData}' />"/>
<input type="hidden" id="searchList" value="<c:out value='${searchList}' />"/>

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
							<th><span class="tit" id="stac_doc_no_txt"></span></th>
							<td colspan="3">
								<div class="row" >
									<div class="txtbox" id="STAC_DOC_NO" ></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th><span class="tit" id="exca_se_txt"></span></th>
							<td>
								<div class="row" >
									<div class="txtbox" id="EXCA_SE_NM" ></div>&nbsp;
								</div>
							</td>
							<th><span class="tit" id="acp_acct_no_txt"></span></th>
							<td>
								<div class="row" >
									<div class="txtbox" id="ACP_ACCT_NO" ></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th><span class="tit" id="exca_issu_se_txt"></span></th>
							<td>
								<div class="row" >
									<div class="txtbox" id="EXCA_ISSU_SE_NM" ></div>&nbsp;
								</div>
							</td>
							<th><span class="tit" id="exca_amt_txt"></span></th>
							<td>
								<div class="row" >
									<div class="txtbox" id="EXCA_AMT" ></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th><span class="tit" id="mtl_nm_txt"></span></th>
							<td>
								<div class="row" >
									<div class="txtbox" id="BIZRNM" ></div>&nbsp;
								</div>
							</td>
							<th><span class="tit" id="bizrno2_txt"></span></th>
							<td>
								<div class="row" >
									<div class="txtbox" id="BIZRNO_DE" ></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th><span class="tit" id="rpst_txt"></span></th>
							<td>
								<div class="row" >
									<div class="txtbox" id="RPST_NM" ></div>&nbsp;
								</div>
							</td>
							<th><span class="tit" id="tel_no2_txt"></span></th>
							<td>
								<div class="row" >
									<div class="txtbox" id="RPST_TEL_NO" ></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th><span class="tit" id="addr_txt"></span></th>
							<td colspan="3">
								<div class="row" >
									<div class="txtbox" id="ADDR" ></div>&nbsp;
								</div>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</section>
		
		<section class="secwrap mt10" >
			<div class="write_area" id="EXCA_ISSU_SE_CD_G" style="display:none">
				<div class="write_tbl">
					<table>
						<colgroup>
							<col style="width: 80px;">
							<col style="width: 80px;">
							<col style="width: 80px;">
							<col style="width: 80px;">
							<col style="width: 80px;">
							<col style="width: 80px;">
						</colgroup>
						<tr>
							<th><span class="tit" id="gtn_bal_txt"></span></th>
							<td>
								<div class="row" style="text-align:right;">
									<div class="txtbox" id="EXCA_PLAN_GTN_BAL" style="float:none;">&nbsp;</div>
								</div>
							</td>
							<th><span class="tit" id="gtn_adj_amt_txt"></span></th>
							<td>
								<div class="row" style="text-align:right;">
									<div class="txtbox" id="GTN_BAL_INDE_AMT" style="float:none;">&nbsp;</div>
								</div>
							</td>
							<th><span class="tit" id="plan_gtn_bal_txt"></span></th>
							<td>
								<div class="row" style="text-align:right;">
									<div class="txtbox" id="EXCA_GTN_BAL" style="float:none;">&nbsp;</div>
								</div>
							</td>
						</tr>
						<tr>
							<th><span class="tit" id="adit_gtn_acmt_txt"></span></th>
							<td>
								<div class="row" style="text-align:right;">
									<div class="txtbox" id="AGTN_BAL_PAY_AMT" style="float:none;">&nbsp;</div>
								</div>
							</td>
							<th><span class="tit" id="adit_gtn_adj_txt"></span></th>
							<td>
								<div class="row" style="text-align:right;">
									<div class="txtbox" id="AGTN_INDE_AMT" style="float:none;">&nbsp;</div>
								</div>
							</td>
							<th><span class="tit" id="adit_gtn_plan_bal_txt"></span></th>
							<td>
								<div class="row" style="text-align:right;">
									<div class="txtbox" id="AGTN_BAL" style="float:none;">&nbsp;</div>
								</div>
							</td>
						</tr>
						<tr id="DRCT_RTRVL_TR">
							<th><span class="tit" id="drct_rtrvl_non_acmt_txt"></span></th>
							<td>
								<div class="row" style="text-align:right;">
									<div class="txtbox" id="DRVL_BAL_PAY_AMT" style="float:none;">&nbsp;</div>
								</div>
							</td>
							<th><span class="tit" id="drct_rtrvl_adj_amt_txt"></span></th>
							<td>
								<div class="row" style="text-align:right;">
									<div class="txtbox" id="DRVL_BAL_MDT_AMT" style="float:none;">&nbsp;</div>
								</div>
							</td>
							<th><span class="tit" id="drct_rtrvl_non_bal2_txt"></span></th>
							<td>
								<div class="row" style="text-align:right;">
									<div class="txtbox" id="DRVL_BAL" style="float:none;">&nbsp;</div>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</section>
		
		<section class="secwrap mt10" id="gridDiv">
			<div class="h4group">
				<h4 class="tit"  id='exch_exca_dd_txt'></h4>
			</div>
			<div class="boxarea">
				<div id="gridHolder" style="height:300px;"></div>
			</div>
		</section>
		
		<section class="btnwrap mt20" >
			<div class="btn" id="BL">
			</div>
			<div class="btn" style="float:right" id="BR">
			</div>
		</section>
	</div>
	
	<form name="prtForm" id="prtForm">
		<input type="hidden" name="CRF_NAME" value="EPCE4707264.crf" />
		<input type="hidden" name="STAC_DOC_NO" value="" />
		<input type="hidden" name="EXCA_ISSU_SE_CD" value="" />
        <input type="hidden" name="MFC_BIZRNO" value="" />
		<input type="hidden" name="SEARCH_LIST4" value="" />
		<input type="hidden" name="S_USER_NM" id="S_USER_NM" value="${ssUserNm}"/>
		<input type="hidden" name="S_BIZR_NM" id="S_BIZR_NM" value="${ssBizrNm}"/>
	</form>
	
	<form name="prtForm3" id="prtForm3">
		<input type="hidden" name="CRF_NAME" value="EPCE4707264_2.crf" />
		<input type="hidden" name="STAC_DOC_NO" value="" />
		<input type="hidden" name="EXCA_ISSU_SE_CD" value="" />
        <input type="hidden" name="MFC_BIZRNO" value="" />
		<input type="hidden" name="SEARCH_LIST4" value="" />
		<input type="hidden" name="S_USER_NM" id="S_USER_NM" value="${ssUserNm}"/>
		<input type="hidden" name="S_BIZR_NM" id="S_BIZR_NM" value="${ssBizrNm}"/>
	</form>
	
</body>
</html>
