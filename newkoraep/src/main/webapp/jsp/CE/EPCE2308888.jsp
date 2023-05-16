<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>수납확인상세조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
	
	<script type="text/javaScript" language="javascript" defer="defer">

	var parent_item;
	
    $(function() {
    	
    	parent_item = window.frames[$("#pagedata").val()].parent_item;
		
    	 //그리드 셋팅
		 fn_set_grid();
		 fn_set_grid2();
		 
		 $("#title_sub").text("<c:out value="${titleSub}" />");
		
		 fn_btnSetting("EPCE2308888");
		 
		 $("#btn_cnl").click(function(){
			fn_cnl();
		});

	});

    function fn_cnl(){
    	$('[layer="close"]').trigger('click');
    }
    
	function fn_sel(){
		
		var url = "/CE/EPCE2308888_19.do";
		
		ajaxPost(url, parent_item, function(rtnData){
			if(rtnData != null && rtnData != ""){
				gridApp.setData(rtnData.searchList);
			} 
			else {
				alertMsg("error");
			}
			
		},false);
	}
    
	function fn_sel2(){
		
		var url = "/CE/EPCE2308888_192.do";
		
		ajaxPost(url, parent_item, function(rtnData){
			if(rtnData != null && rtnData != ""){
				gridApp2.setData(rtnData.searchList);
			} 
			else {
				alertMsg("error");
			}
			
		},false);
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
		 layoutStr.push('<DateFormatter id="datefmt" formatString="YYYY-MM-DD"/>');
		 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
		 layoutStr.push('<groupedColumns>');
		 layoutStr.push('	<DataGridColumn dataField="MFC_BIZRNM" headerText="'+parent.fn_text('mfc_bizrnm')+'" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="BILL_ISSU_DT" headerText="'+parent.fn_text('bill_issu_dt')+'" width="100" formatter="{datefmt}" />');
		 layoutStr.push('	<DataGridColumn dataField="BILL_SE_NM" headerText="'+parent.fn_text('bill_issu_se')+'" width="100" />');
		 layoutStr.push('	<DataGridColumn dataField="NOTY_AMT" id="sum" headerText="'+parent.fn_text('noty_amt')+'" width="100" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr.push('</groupedColumns>');
		 layoutStr.push('	<footers>');
		 layoutStr.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
		 layoutStr.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
		 layoutStr.push('			<DataGridFooterColumn/>');
		 layoutStr.push('			<DataGridFooterColumn/>');
		 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum}" formatter="{numfmt}" textAlign="right" />');
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
	         fn_sel();
	     }
	     
	     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	 }
	
	 /**
		 * 그리드 관련 변수 선언
		 */
	    var jsVars2 = "rMateOnLoadCallFunction=gridReadyHandler2";
		var gridApp2, gridRoot2, dataGrid2, layoutStr2, selectorColumn2;
		var layoutStr2 = new Array();
		
		/**
		 * 그리드 셋팅
		 */
		 function fn_set_grid2() {
			 
			 rMateGridH5.create("grid2", "gridHolder2", jsVars2, "100%", "100%");
			 
			 layoutStr2.push('<rMateGrid>');
			 layoutStr2.push('<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			 layoutStr2.push('<DateFormatter id="datefmt" formatString="YYYY-MM-DD"/>');
			 layoutStr2.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg2" headerHeight="35" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			 layoutStr2.push('<groupedColumns>');
			 layoutStr2.push('	<DataGridColumn dataField="VACCT_NO"  headerText="'+parent.fn_text('vr_vacct_no')+'" width="23%" />');
			 layoutStr2.push('	<DataGridColumn dataField="SEND_MAN"  headerText="'+parent.fn_text('rcpt_nm')+'" width="23%"/>');
			 layoutStr2.push('	<DataGridColumn dataField="TR_IL"  headerText="'+parent.fn_text('acp_dt')+'" width="23%" formatter="{datefmt}"/>');
			 layoutStr2.push('	<DataGridColumn dataField="SUM_AMT" id="sum1"  headerText="'+parent.fn_text('acp_amt')+'" width="23%" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr2.push('</groupedColumns>');
			 layoutStr2.push('<footers>');
			 layoutStr2.push('	<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr2.push('		<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
			 layoutStr2.push('		<DataGridFooterColumn/>');
			 layoutStr2.push('		<DataGridFooterColumn/>');
			 layoutStr2.push('		<DataGridFooterColumn/>');
			 layoutStr2.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr2.push('	</DataGridFooter>');
			 layoutStr2.push('</footers>');
			 layoutStr2.push('</DataGrid>');
			 layoutStr2.push('</rMateGrid>');
		}
		
		// 그리드 및 메뉴 리스트 세팅
		 function gridReadyHandler2(id) {
		 	 gridApp2 = document.getElementById(id);  // 그리드를 포함하는 div 객체
		     gridRoot2 = gridApp2.getRoot();   // 데이터와 그리드를 포함하는 객체
		     gridApp2.setLayout(layoutStr2.join("").toString());
		     
		     var layoutCompleteHandler = function(event) {
		         dataGrid2 = gridRoot2.getDataGrid();  // 그리드 객체
		         fn_sel2();
		     }

		     gridRoot2.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
	
</script>
</head>
<body>

	<input type="hidden" id="pagedata"/>

	<div class="layer_popup" style="width:1024px;">
		<div class="layer_head">
			<h1 class="layer_title title"  id="title_sub"></h1>
			<button type="button" class="layer_close" layer="close"></button>
		</div>
		<div class="layer_body">
			<section class="secwrap">
				<div class="halfarea" style="width: 49%; float: left;">
			        <div class="boxarea">
			            <div id="gridHolder" class="w_382" style="height:400px;"></div>
			        </div> 
				</div>
			    <div class="halfarea" style="width: 49%; float: right;">
			    	<div class="boxarea">
			            <div id="gridHolder2" class="w_382" style="height:400px;"></div>
			        </div> 
			    </div>
			</section>
			
			<section class="btnwrap mt20" style="">
				<div class="fl_r" id="BR">
				</div>
			</section>	
		</div>
	</div>
</body>
</html>

