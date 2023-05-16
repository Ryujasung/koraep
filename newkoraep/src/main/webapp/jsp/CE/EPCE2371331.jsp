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
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			
			fn_btnSetting();

			//그리드 셋팅
			fn_set_grid();

			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
		});
		
		function fn_cnl(){
			
			if(fn_reg_stat == '1'){
				return;
			}	
			
			kora.common.goPageB('', INQ_PARAMS);
		}
				
		var fn_reg_stat = '0';
		//지급생성
		function fn_reg(){
				
			if(fn_reg_stat == '1'){
				return;
			}
			
			confirm('모든 정보에 대해 지급 연계 정보를 생성하시겠습니까?', "fn_reg_exec");
		}
		 
		
		function fn_reg_exec(){

			fn_reg_stat = '1';
			
			var data = {};

			data["list"] = JSON.stringify(INQ_PARAMS.PARAMS.list);

			document.body.style.cursor = "wait";
			kora.common.showLoadingBar(dataGrid, gridRoot)
			var url = "/CE/EPCE2371331_09.do";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					if(rtnData.RSLT_CD == '0000'){
						alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
	 				}else{
	 					alertMsg(rtnData.RSLT_MSG);
	 				}
				} else {
					alertMsg("error");
				}
				kora.common.hideLoadingBar(dataGrid, gridRoot);
				document.body.style.cursor = "default";
				fn_reg_stat = '0';
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
			 layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			 layoutStr.push(' <NumberMaskFormatter id="dateFmt" formatString="####-##-##"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			 layoutStr.push('<groupedColumns>');
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" width="50"/>');
			 layoutStr.push('	<DataGridColumn dataField="PAY_REG_DT" headerText="'+parent.fn_text('reg_dt2')+'" width="100" formatter="{dateFmt}" />');
			 layoutStr.push('	<DataGridColumn dataField="WHSDL_BIZRNM" headerText="'+parent.fn_text('whsdl')+'" width="170" />');
			 layoutStr.push('	<DataGridColumn dataField="GTN_TOT" id="sum1" headerText="'+parent.fn_text('dps2')+'" width="100" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="FEE_TOT" id="sum2" headerText="'+parent.fn_text('fee')+'" width="100" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="FEE_STAX_TOT" id="sum3" headerText="'+parent.fn_text('stax')+'" width="100" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="PAY_AMT" id="sum4" headerText="'+parent.fn_text('pay_amt')+'" width="100" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="ACP_BANK_NM" headerText="'+parent.fn_text('acp_bank_nm')+'" width="120" />');
			 layoutStr.push('	<DataGridColumn dataField="ACP_ACCT_NO" headerText="'+parent.fn_text('acp_acct_no')+'" width="120" />');
			 layoutStr.push('	<DataGridColumn dataField="ACP_ACCT_DPSTR_NM"  headerText="'+parent.fn_text('dpstr')+'" width="100"/>');
			 layoutStr.push('</groupedColumns>');
			 layoutStr.push('	<footers>');
			 layoutStr.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum3}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum4}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('		</DataGridFooter>');
			 layoutStr.push('	</footers>');
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
		         selectorColumn = gridRoot.getObjectById("selector");
		         dataGrid.addEventListener("change", selectionChangeHandler); //이벤트 등록
				 gridApp.setData(INQ_PARAMS.PARAMS.list);
		     }
		     var selectionChangeHandler = function(event) {
				rowIndex = event.rowIndex;
			 }
		     var dataCompleteHandler = function(event) {
		 	 }
		     
		     gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
		
	</script>

	<style type="text/css">
		.row .tit{width: 77px;}
	</style>

</head>
<body>

	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>

	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
			<div class="btn_box">
			</div>
		</div>
		<section class="secwrap">
			<div class="boxarea">
				<div id="gridHolder" style="height:330px;"></div>
			</div>
		</section>
	
		<section class="btnwrap mt20" >
			<div class="fl_l" id="BL">
			</div>
			<div class="fl_r" id="BR">
			</div>
		</section>
		
	</div>
	
</body>
</html>
