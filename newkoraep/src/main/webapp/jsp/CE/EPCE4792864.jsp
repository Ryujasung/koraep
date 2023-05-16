<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
	
		var INQ_PARAMS;//파라미터 데이터
		var searchList;
	
		$(document).ready(function(){
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
			searchList = jsonObject($("#searchList").val());
			
			fn_btnSetting();
			
			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});

			//그리드 셋팅
			fn_set_grid();

			//목록
			$("#btn_lst").click(function(){
				fn_lst();
			});
			
		});
		
		function fn_lst(){
			kora.common.goPageB('', INQ_PARAMS);
		}
		
		//입고정정 링크
		function fn_page(){

			var idx = dataGrid.getSelectedIndices();
			var input = gridRoot.getItemAt(idx);
			
			var url = ''
			
			if(input.MNUL_EXCA_SE == 'M' || input.MNUL_EXCA_SE == 'R'){ //수기정산, 재정산등록
				url = '/CE/EPCE4705664.do';
				input["WRHS_CRCT_DOC_NO_RE"] = input.WRHS_CRCT_DOC_NO;
				input["WRHS_CRCT_DOC_NO"] = input.LK_WRHS_CRCT_DOC_NO;
			}else{
				url = '/CE/EPCE4738764.do';
			}
			
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE4792864.do"; 
			kora.common.goPage(url, INQ_PARAMS);
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
			 layoutStr.push('<NumberMaskFormatter id="dateFmt" formatString="####-##-##"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg2" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true"  textAlign="center" draggableColumns="true" sortableColumns="true" > ');
			 layoutStr.push('<groupedColumns>');
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
			 layoutStr.push('	<DataGridColumn dataField="WRHS_CFM_DT_PAGE"  headerText="'+parent.fn_text('wrhs_cfm_dt')+'" width="100" itemRenderer="HtmlItem" />');
			 layoutStr.push('	<DataGridColumn dataField="CUST_BIZRNM"  headerText="'+parent.fn_text('whsdl')+'" width="150"/>');
			 layoutStr.push('	<DataGridColumn dataField="MFC_BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150"/>');
			 layoutStr.push('	<DataGridColumn dataField="MFC_BRCH_NM"  headerText="'+parent.fn_text('mfc_brch_nm')+'" width="150"/>');
			 layoutStr.push('		<DataGridColumnGroup headerText="'+ parent.fn_text('reg_info')+ '">');
			 layoutStr.push('			<DataGridColumn dataField="CFM_QTY_TOT" id="num1" headerText="'+ parent.fn_text('wrhs_qty')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridColumn dataField="CFM_GTN_TOT" id="num2" headerText="'+ parent.fn_text('gtn')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridColumn dataField="CFM_FEE_TOT" id="num3" headerText="'+ parent.fn_text('fee')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridColumn dataField="CFM_FEE_STAX_TOT" id="num4" headerText="'+ parent.fn_text('stax')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridColumn dataField="CFM_AMT" id="num5" headerText="'+ parent.fn_text('amt')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('		</DataGridColumnGroup>');
			 layoutStr.push('		<DataGridColumnGroup headerText="'+ parent.fn_text('crct_reg')+ '" >');
			 layoutStr.push('			<DataGridColumn dataField="CRCT_QTY_TOT" id="num6" headerText="'+ parent.fn_text('wrhs_qty')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridColumn dataField="CRCT_GTN_TOT" id="num7" headerText="'+ parent.fn_text('gtn')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridColumn dataField="CRCT_FEE_TOT" id="num8" headerText="'+ parent.fn_text('fee')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridColumn dataField="CRCT_FEE_STAX_TOT" id="num9" headerText="'+ parent.fn_text('stax')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridColumn dataField="CRCT_AMT" id="num10" headerText="'+ parent.fn_text('amt')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('		</DataGridColumnGroup>');
			 layoutStr.push('</groupedColumns>');
			 layoutStr.push('<footers>');
			 layoutStr.push('	<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('		<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
			 layoutStr.push('		<DataGridFooterColumn/>');
			 layoutStr.push('		<DataGridFooterColumn/>');
			 layoutStr.push('		<DataGridFooterColumn/>');
			 layoutStr.push('		<DataGridFooterColumn/>');
			 layoutStr.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num8}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num9}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num10}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('	</DataGridFooter>');
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
		         selectorColumn = gridRoot.getObjectById("selector");
		         dataGrid.addEventListener("change", selectionChangeHandler); //이벤트 등록
				 gridApp.setData(searchList);
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
		.row .tit{width: 67px;}
	</style>
</head>
<body>
	<div class="iframe_inner">
		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
		<input type="hidden" id="searchList" value="<c:out value='${searchList}' />" />
		
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
			<div class="btn_box">
			</div>
		</div>
		
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:430px;"></div>
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
