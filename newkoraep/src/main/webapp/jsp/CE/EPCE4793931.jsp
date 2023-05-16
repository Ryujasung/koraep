<%@ page language="java" contentType ="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">
		
	var INQ_PARAMS;
	var searchList;
	
	$(document).ready(function(){

		INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
		searchList = jsonObject($('#searchList').val());
		var searchDtl = jsonObject($('#searchDtl').val());
		var searchData = jsonObject($('#searchData').val());

		$("#repayAmt").text(kora.common.gfn_setComma('<c:out value="${REPAY_AMT}" />') + " 원");
	    $("#payAmt").text(kora.common.gfn_setComma('<c:out value="${PAY_AMT}" />') + " 원");			
		
		$('#title_sub').text('<c:out value="${titleSub}" />');
		
		//버튼 셋팅
		fn_btnSetting();
					
		$('.tit').each(function(){
			$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
		});
		
		$('#EXCA_TERM').text(kora.common.setDelim(searchDtl.EXCA_ST_DT,'9999-99-99') +" ~ "+ kora.common.setDelim(searchDtl.EXCA_END_DT,'9999-99-99'));
		$('#EXCA_ISSU_SE_NM').text(searchDtl.EXCA_ISSU_SE_NM);
		$('#ACP_ACCT_NO').text(searchDtl.ACP_ACCT_NO);
		$('#EXCA_SE_NM').text(searchDtl.EXCA_SE_NM);
		$('#EXCA_AMT').text(kora.common.format_comma(searchDtl.EXCA_AMT) + " 원");
		$('#BIZRNM').text(searchDtl.BIZRNM);
		$('#BIZRNO_DE').text(kora.common.setDelim(searchDtl.BIZRNO_DE, '999-99-99999'));
		$('#RPST_NM').text(searchDtl.RPST_NM);
		$('#RPST_TEL_NO').text(searchDtl.RPST_TEL_NO);
		$('#ADDR').text(searchDtl.ADDR);
		
		$('#EXCA_PLAN_GTN_BAL').text(kora.common.format_comma(searchData.EXCA_PLAN_GTN_BAL) + " 원");
		$('#GTN_BAL_INDE_AMT').text(kora.common.format_comma(searchData.GTN_BAL_INDE_AMT) + " 원"); //GTN_INDE
		$('#EXCA_GTN_BAL').text(kora.common.format_comma(searchData.EXCA_GTN_BAL) + " 원");
		$('#AGTN_BAL_PAY_AMT').text(kora.common.format_comma(searchData.AGTN_BAL_PAY_AMT) + " 원");
		$('#AGTN_INDE_AMT').text(kora.common.format_comma(searchData.AGTN_INDE_AMT) + " 원");
		$('#AGTN_BAL').text(kora.common.format_comma(searchData.AGTN_BAL) + " 원");
		$('#DRVL_BAL_PAY_AMT').text(kora.common.format_comma(searchData.DRVL_BAL_PAY_AMT) + " 원");
		$('#DRVL_BAL_MDT_AMT').text(kora.common.format_comma(searchData.DRVL_BAL_MDT_AMT*-1) + " 원");
		$('#DRVL_BAL').text(kora.common.format_comma(searchData.DRVL_BAL) + " 원");

		//그리드 셋팅
		if(searchList.length > 0){ fn_set_grid(); }else{ $('#gridDiv').hide(); }

		//정산서발급
		$("#btn_reg").click(function(){
			fn_reg();
		});
		
		//취소
		$("#btn_cnl").click(function(){
			fn_cnl();
		});
								
	});
	
	function fn_cnl(){
		
		if(fn_reg_stat == '1'){
			return;
		}	
		
		kora.common.goPageB('', INQ_PARAMS);
	}
	
	var fn_reg_stat = '0';
	function fn_reg(){
		
		if(fn_reg_stat == '1'){
			return;
		}
		
	    if(!kora.common.cfrmDivChkValid("divInput")) {
	        return;
	    }
		
		confirm("정산서 발급 처리를 진행 하시겠습니까?", "fn_reg_exec");
	}
	
	function fn_reg_exec(){
		
		fn_reg_stat = '1';
		document.body.style.cursor = "wait";
		
		var data = {};
		data['PARAMS'] = JSON.stringify(INQ_PARAMS.PARAMS);
		data['list'] = JSON.stringify(INQ_PARAMS.list);
		data['MNUL_ISSU_RSN'] = kora.common.null2void($("#MNUL_ISSU_RSN").val());
		
		var url  = "/CE/EPCE4793931_09.do";
		ajaxPost(url, data, function(rtnData){
			if ("" != rtnData && null != rtnData) {
				if(rtnData.RSLT_CD =="0000"){
					alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
				}else{
					alertMsg(rtnData.RSLT_MSG);
				}
			} else {
				alertMsg("error");
			}
			
			fn_reg_stat = '0';
			document.body.style.cursor = "default";
		});
					
	}
	
	 /**
	 * 그리드 관련 변수 선언
	 */
    var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
	var gridApp, gridRoot, dataGrid, layoutStr, selectorColumn;
	var layoutStr = new Array();
	var rowIndex;
	
	/**
	 * 메뉴관리 그리드 셋팅
	 */
	 function fn_set_grid() {
		 
		 rMateGridH5.create("grid", "gridHolder", jsVars, "100%", "100%");
		 
		 layoutStr.push('<rMateGrid>');
		 layoutStr.push('<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
		 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg7" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true"  textAlign="center" draggableColumns="true" sortableColumns="true" > ');
		 layoutStr.push('<groupedColumns>');
		 layoutStr.push('	<DataGridColumn dataField="ETC_CD_NM"  headerText="'+parent.fn_text('se')+'" width="350"/>');
		 layoutStr.push('	<DataGridColumn id="num1" dataField="PAY_PLAN_AMT"  headerText="'+parent.fn_text('pay_plan_amt')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr.push('	<DataGridColumn id="num2" dataField="ACP_PLAN_AMT"  headerText="'+parent.fn_text('acp_plan_amt')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr.push('	<DataGridColumn id="num3" dataField="OFF_SET_AMT"  headerText="'+parent.fn_text('exca_amt')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr.push('</groupedColumns>');
         layoutStr.push('<footers>');
         layoutStr.push('  <DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
         layoutStr.push('      <DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
         layoutStr.push('      <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');
         layoutStr.push('      <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');
         layoutStr.push('      <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');
         layoutStr.push('  </DataGridFooter>');
         layoutStr.push('</footers>');
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
	        dataGrid = gridRoot.getDataGrid();  // 그리드 객체
	        columns = dataGrid.getColumns();
	        var acoll = gridRoot.getCollection();
	 
	        // 정렬할 컬럼 정보를 instance로 지정합니다.
	        var sortField = gridRoot.newClassInstance("SortField");
	        // 정렬 함수를 instance로 지정합니다.
	        var sot = gridRoot.newClassInstance("Sort");
	 
	        // Seoul 에 대한 정렬을 처리 합니다.
	        sortField.name = "ETC_CD";
	        // 내림 차순 설정 올림은 false
	        sortField.descending = false;
	        sot.setFields([sortField]);
	        acoll.setSort(sot);
	        // collection 정보를 새로고침합니다.
	        acoll.refresh();		 
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
							<th><span class="tit" id="exca_term_txt"></span></th>
							<td>
								<div class="row" >
									<div class="txtbox" id="EXCA_TERM"></div>&nbsp;
								</div>
							</td>
							<th><span class="tit" id="stac_doc_no_txt"></span></th>
							<td>
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
		
		<section class="secwrap mt10">
			<div class="write_area">
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
						<tr>
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

        <section class="secwrap mt10">
            <div class="write_area">
                <div class="write_tbl">
                    <table>
                        <colgroup>
                            <col style="width: 80px;">
                            <col style="width: 400px;">
                        </colgroup>
                        <tr>
                            <th><span class="tit" id="mnul_exca_rsn_txt"></span></th>
                            <td>
                                <div class="row" id="divInput">
                                    <input type="text" id="MNUL_ISSU_RSN" name="MNUL_ISSU_RSN" style="width: 100%;" maxByteLength="2000" class="i_notnull" alt="수기정산사유">
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </section>
		
		<section class="secwrap mt10" id="gridDiv">
			<div class="h4group">
				<h4 class="tit"  id='exca_noty_dtl_data_txt'></h4>
			</div>
			<div class="boxarea" style="width:900px">
				<div id="gridHolder" style="height:225px;"></div>
			</div>
		</section>		

        <section class="secwrap mt10">
            <div class="h4group" >
                <h5 class="tit" id='tmp_txt' style="font-size: 16px;">
                    <span class="table_tit">취급수수료정보 </span>
                    <span style="padding-left:20px">환급예정금액 : <span id="repayAmt"></span></span>
                    <span style="padding-left:20px">납부예정금액 : <span id="payAmt"></span></span>
                </h5>  
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
