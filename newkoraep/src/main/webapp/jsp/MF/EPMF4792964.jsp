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
			
			$('#title_sub').text('<c:out value="${titleSub}" />'); //타이틀
			
			INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
			searchList = jsonObject($('#searchList').val());
			
			fn_btnSetting();
			
			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});

			$('#EXCH_EXCA_REG_DT').text(kora.common.setDelim(INQ_PARAMS.PARAMS.EXCH_EXCA_REG_DT, '9999-99-99'));
			
			//그리드 셋팅
			fn_set_grid();

			$("#btn_page").click(function(){
				fn_page();
			})
			
		});
		
		function fn_page(){
			kora.common.goPageB('', INQ_PARAMS);
		}
				
		function fn_page2(){
			var idx = dataGrid.getSelectedIndices();
			var input = gridRoot.getItemAt(idx);

			//파라미터에 조회조건값 저장 
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/MF/EPMF4792964.do";
			kora.common.goPage('/MF/EPMF47929642.do', INQ_PARAMS);
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
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			 layoutStr.push('<groupedColumns>');
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
			 layoutStr.push('	<DataGridColumn dataField="REQ_BIZRNM" headerText="'+parent.fn_text('exca_req_mfc')+'" width="200" />');
			 layoutStr.push('	<DataGridColumn dataField="TRGT_BIZRNM_PAGE" headerText="'+parent.fn_text('exca_trgt_mfc')+'" width="200" itemRenderer="HtmlItem" />');
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
		.row .tit{width: 77px;}
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
		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">
					<div class="col">
						<div class="tit" id="exca_req_dt_txt"></div>
						<div class="box">						
							<div class="txtbox" style="line-height: 36px;" id="EXCH_EXCA_REG_DT"></div>
						</div>
					</div>
					<div class="btn" id="CR">
					</div>
				</div>
			</div>
		</section>
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
