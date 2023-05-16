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
	var searchList2;
	var searchList3;
	var searchList5;
	var searchList6;
	var searchList7;
	var searchList8;
	var searchList9;
	
	$(document).ready(function(){

		INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
		searchList = jsonObject($('#searchList').val());
		searchList2 = jsonObject($('#searchList2').val());
		searchList3 = jsonObject($('#searchList3').val());
		searchList5 = jsonObject($('#searchList5').val());
		searchList6 = jsonObject($('#searchList6').val());
		searchList7 = jsonObject($('#searchList7').val());
		searchList8 = jsonObject($('#searchList8').val());
		searchList9 = jsonObject($('#searchList9').val());
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
		if(searchList2.length > 0){ fn_set_grid2(); }else{ $('#gridDiv2').hide(); }
		if(searchList3.length > 0){ fn_set_grid3(); }else{ $('#gridDiv3').hide(); }
		if(searchList5.length > 0){ fn_set_grid5(); }else{ $('#gridDiv5').hide(); }
		if(searchList6.length > 0){ fn_set_grid6(); }else{ $('#gridDiv6').hide(); }
		if(searchList7.length > 0){ fn_set_grid7(); }else{ $('#gridDiv7').hide(); }
		if(searchList8.length > 0){ fn_set_grid8(); }else{ $('#gridDiv8').hide(); }
		if(searchList9.length > 0){ fn_set_grid9(); }else{ $('#gridDiv9').hide(); }

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
		
		confirm("정산서 발급 처리를 진행 하시겠습니까?", "fn_reg_exec");
	}
	
	function fn_reg_exec(){
		
		fn_reg_stat = '1';
		document.body.style.cursor = "wait";
		
		var data = {};
		data['PARAMS'] = JSON.stringify(INQ_PARAMS.PARAMS);
		data['list'] = JSON.stringify(INQ_PARAMS.list);
		
		var url  = "/CE/EPCE4770731_09.do";
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
	
	/**
	 * 메뉴관리 그리드 셋팅
	 */
	 function fn_set_grid() {
		 
		 rMateGridH5.create("grid", "gridHolder", jsVars, "100%", "100%");
		 
		 layoutStr.push('<rMateGrid>');
		 layoutStr.push('<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
		 layoutStr.push('<NumberMaskFormatter id="dateFmt" formatString="####-##-##"/>');
		 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true"  textAlign="center" draggableColumns="true" sortableColumns="true" > ');
		 layoutStr.push('<groupedColumns>');
		 layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
		 layoutStr.push('	<DataGridColumn dataField="DLIVY_DT"  headerText="'+parent.fn_text('dlivy_dt')+'" width="100" formatter="{dateFmt}" />');
		 layoutStr.push('	<DataGridColumn dataField="MFC_BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150"/>');
		 layoutStr.push('	<DataGridColumn dataField="MFC_BRCH_NM"  headerText="'+parent.fn_text('mfc_brch_nm')+'" width="150"/>');
		 layoutStr.push('	<DataGridColumn dataField="CUST_BIZRNM"  headerText="'+parent.fn_text('cust')+'" width="150"/>');
		 layoutStr.push('	<DataGridColumn dataField="CTNR_NM"  headerText="'+parent.fn_text('ctnr_nm')+'" width="150"/>');
		 layoutStr.push('	<DataGridColumn dataField="PRPS_NM"  headerText="'+parent.fn_text('prps_cd')+'" width="120"/>');
		 layoutStr.push('	<DataGridColumn dataField="CPCT_NM"  headerText="'+parent.fn_text('cpct_cd')+'" width="120"/>');
		 layoutStr.push('	<DataGridColumn dataField="DLIVY_QTY" id="num1" headerText="'+parent.fn_text('dlivy_qty2')+'" width="120" textAlign="right" />');
		 layoutStr.push('	<DataGridColumn dataField="DLIVY_GTN" id="num2" headerText="'+parent.fn_text('gtn')+'" width="120" textAlign="right" />');
		 layoutStr.push('	<DataGridColumn dataField="DLIVY_CRCT_STAT_NM"  headerText="'+parent.fn_text('stat')+'" width="100"/>');
		 layoutStr.push('</groupedColumns>');
		 layoutStr.push('<footers>');
		 layoutStr.push('	<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
		 layoutStr.push('		<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
		 layoutStr.push('		<DataGridFooterColumn/>');
		 layoutStr.push('		<DataGridFooterColumn/>');
		 layoutStr.push('		<DataGridFooterColumn/>');
		 layoutStr.push('		<DataGridFooterColumn/>');
		 layoutStr.push('		<DataGridFooterColumn/>');
		 layoutStr.push('		<DataGridFooterColumn/>');
		 layoutStr.push('		<DataGridFooterColumn/>');
		 layoutStr.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	
		 layoutStr.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	
		 layoutStr.push('		<DataGridFooterColumn/>');
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
	    	 gridApp.setData(searchList);
	    }
	    var dataCompleteHandler = function(event) {
	    }
	    
	    gridRoot.addEventListener("dataComplete", dataCompleteHandler);
	    gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	 }
	
	 /**
	 * 그리드 관련 변수 선언
	 */
    var jsVars2 = "rMateOnLoadCallFunction=gridReadyHandler2";
	var gridApp2, gridRoot2, dataGrid2, layoutStr2, selectorColumn2;
	var layoutStr2 = new Array();
	
	/**
	 * 메뉴관리 그리드 셋팅
	 */
	 function fn_set_grid2() {
		 
		 rMateGridH5.create("grid2", "gridHolder2", jsVars2, "100%", "100%");
		 
		 layoutStr2.push('<rMateGrid>');
		 layoutStr2.push('<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
		 layoutStr2.push('<NumberMaskFormatter id="dateFmt" formatString="####-##-##"/>');
		 layoutStr2.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg2" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true"  textAlign="center" draggableColumns="true" sortableColumns="true" > ');
		 layoutStr2.push('<groupedColumns>');
		 layoutStr2.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
		 layoutStr2.push('	<DataGridColumn dataField="WRHS_CFM_DT_ORI"  headerText="'+parent.fn_text('wrhs_cfm_dt')+'" width="100" formatter="{dateFmt}" />');
		 layoutStr2.push('	<DataGridColumn dataField="CUST_BIZRNM"  headerText="'+parent.fn_text('whsdl')+'" width="150"/>');
		 layoutStr2.push('	<DataGridColumn dataField="MFC_BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150"/>');
		 layoutStr2.push('	<DataGridColumn dataField="MFC_BRCH_NM"  headerText="'+parent.fn_text('mfc_brch_nm')+'" width="150"/>');
		 layoutStr2.push('		<DataGridColumnGroup headerText="'+ parent.fn_text('reg_info')+ '">');
		 layoutStr2.push('			<DataGridColumn dataField="CFM_QTY_TOT" id="num1" headerText="'+ parent.fn_text('wrhs_qty')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
		 layoutStr2.push('			<DataGridColumn dataField="CFM_GTN_TOT" id="num2" headerText="'+ parent.fn_text('gtn')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
		 layoutStr2.push('			<DataGridColumn dataField="CFM_FEE_TOT" id="num3" headerText="'+ parent.fn_text('fee')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
		 layoutStr2.push('			<DataGridColumn dataField="CFM_FEE_STAX_TOT" id="num4" headerText="'+ parent.fn_text('stax')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
		 layoutStr2.push('			<DataGridColumn dataField="CFM_AMT" id="num5" headerText="'+ parent.fn_text('amt')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
		 layoutStr2.push('		</DataGridColumnGroup>');
		 layoutStr2.push('		<DataGridColumnGroup headerText="'+ parent.fn_text('crct_reg')+ '" >');
		 layoutStr2.push('			<DataGridColumn dataField="CRCT_QTY_TOT" id="num6" headerText="'+ parent.fn_text('wrhs_qty')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
		 layoutStr2.push('			<DataGridColumn dataField="CRCT_GTN_TOT" id="num7" headerText="'+ parent.fn_text('gtn')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
		 layoutStr2.push('			<DataGridColumn dataField="CRCT_FEE_TOT" id="num8" headerText="'+ parent.fn_text('fee')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
		 layoutStr2.push('			<DataGridColumn dataField="CRCT_FEE_STAX_TOT" id="num9" headerText="'+ parent.fn_text('stax')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
		 layoutStr2.push('			<DataGridColumn dataField="CRCT_AMT" id="num10" headerText="'+ parent.fn_text('amt')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
		 layoutStr2.push('		</DataGridColumnGroup>');
		 layoutStr2.push('	<DataGridColumn dataField="WRHS_CRCT_STAT_CD_NM_ORI"  headerText="'+parent.fn_text('stat')+'" width="100"/>');
		 layoutStr2.push('</groupedColumns>');
		 layoutStr2.push('<footers>');
		 layoutStr2.push('	<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
		 layoutStr2.push('		<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
		 layoutStr2.push('		<DataGridFooterColumn/>');
		 layoutStr2.push('		<DataGridFooterColumn/>');
		 layoutStr2.push('		<DataGridFooterColumn/>');
		 layoutStr2.push('		<DataGridFooterColumn/>');
		 layoutStr2.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	
		 layoutStr2.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	
		 layoutStr2.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	
		 layoutStr2.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');	
		 layoutStr2.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');	
		 layoutStr2.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');	
		 layoutStr2.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');	
		 layoutStr2.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num8}" formatter="{numfmt}" textAlign="right"/>');	
		 layoutStr2.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num9}" formatter="{numfmt}" textAlign="right"/>');	
		 layoutStr2.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num10}" formatter="{numfmt}" textAlign="right"/>');	
		 layoutStr2.push('		<DataGridFooterColumn/>');
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
	    	 gridApp2.setData(searchList2);
	    }
	    var dataCompleteHandler = function(event) {
	    }
	    
	    gridRoot2.addEventListener("dataComplete", dataCompleteHandler);
	    gridRoot2.addEventListener("layoutComplete", layoutCompleteHandler);
	 }
	
	 /**
	 * 그리드 관련 변수 선언
	 */
    var jsVars3 = "rMateOnLoadCallFunction=gridReadyHandler3";
	var gridApp3, gridRoot3, dataGrid3, layoutStr3, selectorColumn3;
	var layoutStr3 = new Array();
	
	/**
	 * 메뉴관리 그리드 셋팅
	 */
	 function fn_set_grid3() {
		 
		 rMateGridH5.create("grid3", "gridHolder3", jsVars3, "100%", "100%");
		 
		 layoutStr3.push('<rMateGrid>');
		 layoutStr3.push('<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
		 layoutStr3.push('<NumberMaskFormatter id="dateFmt" formatString="####-##-##"/>');
		 layoutStr3.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg3" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true"  textAlign="center" draggableColumns="true" sortableColumns="true" > ');
		 layoutStr3.push('<groupedColumns>');
		 layoutStr3.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
		 layoutStr3.push('	<DataGridColumn dataField="DRCT_RTRVL_DT"  headerText="'+parent.fn_text('drct_rtrvl_dt')+'" width="100" formatter="{dateFmt}" />');
		 layoutStr3.push('	<DataGridColumn dataField="MFC_BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150"/>');
		 layoutStr3.push('	<DataGridColumn dataField="MFC_BRCH_NM"  headerText="'+parent.fn_text('mfc_brch_nm')+'" width="150"/>');
		 layoutStr3.push('	<DataGridColumn dataField="CUST_BIZRNM"  headerText="'+parent.fn_text('cust')+'" width="150"/>');
		 layoutStr3.push('	<DataGridColumn dataField="CTNR_NM"  headerText="'+parent.fn_text('ctnr_nm')+'" width="150"/>');
		 layoutStr3.push('	<DataGridColumn dataField="PRPS_NM"  headerText="'+parent.fn_text('prps_cd')+'" width="120"/>');
		 layoutStr3.push('	<DataGridColumn dataField="CPCT_NM"  headerText="'+parent.fn_text('cpct_cd')+'" width="120"/>');
		 layoutStr3.push('	<DataGridColumn dataField="DRCT_RTRVL_QTY" id="num1" headerText="'+parent.fn_text('drct_rtrvl_qty')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr3.push('	<DataGridColumn dataField="DRCT_PAY_GTN" id="num2" headerText="'+parent.fn_text('drct_rtrvl_gtn')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr3.push('	<DataGridColumn dataField="DRCT_PAY_FEE" id="num3" headerText="'+parent.fn_text('drct_rtrvl_fee')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr3.push('	<DataGridColumn dataField="DRCT_RTRVL_CRCT_STAT_NM"  headerText="'+parent.fn_text('stat')+'" width="100"/>');
		 layoutStr3.push('</groupedColumns>');
		 layoutStr3.push('<footers>');
		 layoutStr3.push('	<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
		 layoutStr3.push('		<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
		 layoutStr3.push('		<DataGridFooterColumn/>');
		 layoutStr3.push('		<DataGridFooterColumn/>');
		 layoutStr3.push('		<DataGridFooterColumn/>');
		 layoutStr3.push('		<DataGridFooterColumn/>');
		 layoutStr3.push('		<DataGridFooterColumn/>');
		 layoutStr3.push('		<DataGridFooterColumn/>');
		 layoutStr3.push('		<DataGridFooterColumn/>');
		 layoutStr3.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	
		 layoutStr3.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	
		 layoutStr3.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	
		 layoutStr3.push('		<DataGridFooterColumn/>');
		 layoutStr3.push('	</DataGridFooter>');
		 layoutStr3.push('</footers>');
		 layoutStr3.push('</DataGrid>');
		 layoutStr3.push('</rMateGrid>');
	}
	
	// 그리드 및 메뉴 리스트 세팅
	 function gridReadyHandler3(id) {
	 	 gridApp3 = document.getElementById(id);  // 그리드를 포함하는 div 객체
	     gridRoot3 = gridApp3.getRoot();   // 데이터와 그리드를 포함하는 객체
	     gridApp3.setLayout(layoutStr3.join("").toString());

	     var layoutCompleteHandler = function(event) {
	    	 dataGrid3 = gridRoot3.getDataGrid();  // 그리드 객체
	    	 gridApp3.setData(searchList3);
	    }
	    var dataCompleteHandler = function(event) {
	    }
	    
	    gridRoot3.addEventListener("dataComplete", dataCompleteHandler);
	    gridRoot3.addEventListener("layoutComplete", layoutCompleteHandler);
	 }
	
	 /**
	 * 그리드 관련 변수 선언
	 */
    var jsVars5 = "rMateOnLoadCallFunction=gridReadyHandler5";
	var gridApp5, gridRoot5, dataGrid5, layoutStr5, selectorColumn5;
	var layoutStr5 = new Array();
	
	/**
	 * 메뉴관리 그리드 셋팅
	 */
	 function fn_set_grid5() {
		 
		 rMateGridH5.create("grid5", "gridHolder5", jsVars5, "100%", "100%");
		 
		 layoutStr5.push('<rMateGrid>');
		 layoutStr5.push('<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
		 layoutStr5.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg5" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true"  textAlign="center" draggableColumns="true" sortableColumns="true" > ');
		 layoutStr5.push('<groupedColumns>');
		 layoutStr5.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
		 layoutStr5.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150"/>');
		 layoutStr5.push('	<DataGridColumn dataField="PRPS_NM"  headerText="'+parent.fn_text('prps_cd')+'" width="120"/>');
		 layoutStr5.push('	<DataGridColumn dataField="CTNR_NM"  headerText="'+parent.fn_text('ctnr_nm')+'" width="150"/>');
		 layoutStr5.push('	<DataGridColumn dataField="CPCT_NM"  headerText="'+parent.fn_text('cpct_cd')+'" width="120"/>');
		 layoutStr5.push('	<DataGridColumn dataField="FYER_QTY" id="num1" headerText="'+parent.fn_text('wrhs_qty')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr5.push('	<DataGridColumn dataField="ADJ_RT"  headerText="'+parent.fn_text('adj_rt')+'" width="120" textAlign="right"/>');
		 layoutStr5.push('	<DataGridColumn dataField="ADJ_QTY" id="num2" headerText="'+parent.fn_text('adj_wrhs_qty2')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr5.push('	<DataGridColumn dataField="ADJ_GTN" id="num3" headerText="'+parent.fn_text('adj_gtn')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr5.push('	<DataGridColumn dataField="ADJ_PROC_STAT_NM"  headerText="'+parent.fn_text('stat')+'" width="100"/>');
		 layoutStr5.push('</groupedColumns>');
		 layoutStr5.push('<footers>');
		 layoutStr5.push('	<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
		 layoutStr5.push('		<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
		 layoutStr5.push('		<DataGridFooterColumn/>');
		 layoutStr5.push('		<DataGridFooterColumn/>');
		 layoutStr5.push('		<DataGridFooterColumn/>');
		 layoutStr5.push('		<DataGridFooterColumn/>');
		 layoutStr5.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	
		 layoutStr5.push('		<DataGridFooterColumn/>');
		 layoutStr5.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	
		 layoutStr5.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	
		 layoutStr5.push('		<DataGridFooterColumn/>');
		 layoutStr5.push('	</DataGridFooter>');
		 layoutStr5.push('</footers>');
		 layoutStr5.push('</DataGrid>');
		 layoutStr5.push('</rMateGrid>');
	}
	
	// 그리드 및 메뉴 리스트 세팅
	 function gridReadyHandler5(id) {
	 	 gridApp5 = document.getElementById(id);  // 그리드를 포함하는 div 객체
	     gridRoot5 = gridApp5.getRoot();   // 데이터와 그리드를 포함하는 객체
	     gridApp5.setLayout(layoutStr5.join("").toString());

	     var layoutCompleteHandler = function(event) {
	    	 dataGrid5 = gridRoot5.getDataGrid();  // 그리드 객체
	    	 gridApp5.setData(searchList5);
	    }
	    var dataCompleteHandler = function(event) {
	    }
	    
	    gridRoot5.addEventListener("dataComplete", dataCompleteHandler);
	    gridRoot5.addEventListener("layoutComplete", layoutCompleteHandler);
	 }
	
	 /**
	 * 그리드 관련 변수 선언
	 */
    var jsVars6 = "rMateOnLoadCallFunction=gridReadyHandler6";
	var gridApp6, gridRoot6, dataGrid6, layoutStr6, selectorColumn6;
	var layoutStr6 = new Array();
	
	/**
	 * 메뉴관리 그리드 셋팅
	 */
	 function fn_set_grid6() {
		 
		 rMateGridH5.create("grid6", "gridHolder6", jsVars6, "100%", "100%");
		 
		 layoutStr6.push('<rMateGrid>');
		 layoutStr6.push('<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
		 layoutStr6.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg6" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true"  textAlign="center" draggableColumns="true" sortableColumns="true" > ');
		 layoutStr6.push('<groupedColumns>');
		 layoutStr6.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
		 layoutStr6.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150"/>');
		 layoutStr6.push('	<DataGridColumn dataField="PRPS_NM"  headerText="'+parent.fn_text('prps_cd')+'" width="120"/>');
		 layoutStr6.push('	<DataGridColumn dataField="CTNR_NM"  headerText="'+parent.fn_text('ctnr_nm')+'" width="150"/>');
		 layoutStr6.push('	<DataGridColumn dataField="CPCT_NM"  headerText="'+parent.fn_text('cpct_cd')+'" width="120"/>');
		 layoutStr6.push('	<DataGridColumn dataField="FYER_QTY" id="num1" headerText="'+parent.fn_text('dlivy_qty2')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr6.push('	<DataGridColumn dataField="ADJ_RT"  headerText="'+parent.fn_text('adj_qty')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr6.push('	<DataGridColumn dataField="ADJ_QTY" id="num2" headerText="'+parent.fn_text('adj_dlivy_qty')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr6.push('	<DataGridColumn dataField="ADJ_GTN" id="num3" headerText="'+parent.fn_text('adj_gtn')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr6.push('	<DataGridColumn dataField="ADJ_PROC_STAT_NM"  headerText="'+parent.fn_text('stat')+'" width="100"/>');
		 layoutStr6.push('</groupedColumns>');
		 layoutStr6.push('<footers>');
		 layoutStr6.push('	<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
		 layoutStr6.push('		<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
		 layoutStr6.push('		<DataGridFooterColumn/>');
		 layoutStr6.push('		<DataGridFooterColumn/>');
		 layoutStr6.push('		<DataGridFooterColumn/>');
		 layoutStr6.push('		<DataGridFooterColumn/>');
		 layoutStr6.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	
		 layoutStr6.push('		<DataGridFooterColumn/>');
		 layoutStr6.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	
		 layoutStr6.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	
		 layoutStr6.push('		<DataGridFooterColumn/>');
		 layoutStr6.push('	</DataGridFooter>');
		 layoutStr6.push('</footers>');
		 layoutStr6.push('</DataGrid>');
		 layoutStr6.push('</rMateGrid>');
	}
	
	// 그리드 및 메뉴 리스트 세팅
	 function gridReadyHandler6(id) {
	 	 gridApp6 = document.getElementById(id);  // 그리드를 포함하는 div 객체
	     gridRoot6 = gridApp6.getRoot();   // 데이터와 그리드를 포함하는 객체
	     gridApp6.setLayout(layoutStr6.join("").toString());

	     var layoutCompleteHandler = function(event) {
	    	 dataGrid6 = gridRoot6.getDataGrid();  // 그리드 객체
	    	 gridApp6.setData(searchList6);
	    }
	    var dataCompleteHandler = function(event) {
	    }
	    
	    gridRoot6.addEventListener("dataComplete", dataCompleteHandler);
	    gridRoot6.addEventListener("layoutComplete", layoutCompleteHandler);
	 }
	
	 /**
	 * 그리드 관련 변수 선언
	 */
    var jsVars7 = "rMateOnLoadCallFunction=gridReadyHandler7";
	var gridApp7, gridRoot7, dataGrid7, layoutStr7, selectorColumn7;
	var layoutStr7 = new Array();
	var rowIndex7;
	
	/**
	 * 메뉴관리 그리드 셋팅
	 */
	 function fn_set_grid7() {
		 
		 rMateGridH5.create("grid7", "gridHolder7", jsVars7, "100%", "100%");
		 
		 layoutStr7.push('<rMateGrid>');
		 layoutStr7.push('<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
		 layoutStr7.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg7" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true"  textAlign="center" draggableColumns="true" sortableColumns="true" > ');
		 layoutStr7.push('<groupedColumns>');
		 layoutStr7.push('	<DataGridColumn dataField="ETC_CD_NM"  headerText="'+parent.fn_text('se')+'" width="350"/>');
		 layoutStr7.push('	<DataGridColumn id="num1" dataField="PAY_PLAN_AMT"  headerText="'+parent.fn_text('pay_plan_amt')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr7.push('	<DataGridColumn id="num2" dataField="ACP_PLAN_AMT"  headerText="'+parent.fn_text('acp_plan_amt')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr7.push('	<DataGridColumn id="num3" dataField="OFF_SET_AMT"  headerText="'+parent.fn_text('exca_amt')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr7.push('</groupedColumns>');
         layoutStr7.push('<footers>');
         layoutStr7.push('  <DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
         layoutStr7.push('      <DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
         layoutStr7.push('      <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');
         layoutStr7.push('      <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');
         layoutStr7.push('      <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');
         layoutStr7.push('  </DataGridFooter>');
         layoutStr7.push('</footers>');
		 layoutStr7.push('</DataGrid>');
		 layoutStr7.push('</rMateGrid>');
	}
	
	// 그리드 및 메뉴 리스트 세팅
	 function gridReadyHandler7(id) {
	 	 gridApp7 = document.getElementById(id);  // 그리드를 포함하는 div 객체
	     gridRoot7 = gridApp7.getRoot();   // 데이터와 그리드를 포함하는 객체
	     gridApp7.setLayout(layoutStr7.join("").toString());

	     var layoutCompleteHandler = function(event) {
	    	 dataGrid7 = gridRoot7.getDataGrid();  // 그리드 객체
	    	 gridApp7.setData(searchList7);
	     }
	     var dataCompleteHandler = function(event) {
	     }
	    
	    gridRoot7.addEventListener("dataComplete", dataCompleteHandler);
	    gridRoot7.addEventListener("layoutComplete", layoutCompleteHandler);

	 }
	
    /**
     * 그리드 관련 변수 선언
     */
    var jsVars8 = "rMateOnLoadCallFunction=gridReadyHandler8";
    var gridApp8, gridRoot8, dataGrid8, layoutStr8, selectorColumn8;
    var layoutStr8 = new Array();


    function fn_set_grid8() {

        rMateGridH5.create("grid8", "gridHolder8", jsVars8, "100%", "100%");

        layoutStr8.push('<rMateGrid>');
        layoutStr8.push('<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
        layoutStr8.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg8" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true"  textAlign="center" draggableColumns="true" sortableColumns="true" > ');
        layoutStr8.push('<groupedColumns>');
        layoutStr8.push('  <DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
        layoutStr8.push('  <DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150"/>');
        layoutStr8.push('  <DataGridColumn dataField="PRPS_NM"  headerText="'+parent.fn_text('prps_cd')+'" width="120"/>');
        layoutStr8.push('  <DataGridColumn dataField="CTNR_NM"  headerText="'+parent.fn_text('ctnr_nm')+'" width="150"/>');
        layoutStr8.push('  <DataGridColumn dataField="CPCT_NM"  headerText="'+parent.fn_text('cpct_cd')+'" width="120"/>');
        layoutStr8.push('  <DataGridColumn dataField="FYER_QTY" id="num1" headerText="'+parent.fn_text('wrhs_qty')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
        layoutStr8.push('  <DataGridColumn dataField="ADJ_RT"  headerText="'+parent.fn_text('adj_qty')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
        layoutStr8.push('  <DataGridColumn dataField="ADJ_QTY" id="num2" headerText="'+parent.fn_text('adj_wrhs_qty2')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
        layoutStr8.push('  <DataGridColumn dataField="ADJ_GTN" id="num3" headerText="'+parent.fn_text('adj_gtn')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
        layoutStr8.push('  <DataGridColumn dataField="ADJ_PROC_STAT_NM"  headerText="'+parent.fn_text('stat')+'" width="100"/>');
        layoutStr8.push('</groupedColumns>');
        layoutStr8.push('<footers>');
        layoutStr8.push('  <DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
        layoutStr8.push('      <DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
        layoutStr8.push('      <DataGridFooterColumn/>');
        layoutStr8.push('      <DataGridFooterColumn/>');
        layoutStr8.push('      <DataGridFooterColumn/>');
        layoutStr8.push('      <DataGridFooterColumn/>');
        layoutStr8.push('      <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');
        layoutStr8.push('      <DataGridFooterColumn/>');
        layoutStr8.push('      <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');
        layoutStr8.push('      <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');
        layoutStr8.push('      <DataGridFooterColumn/>');
        layoutStr8.push('  </DataGridFooter>');
        layoutStr8.push('</footers>');
        layoutStr8.push('</DataGrid>');
        layoutStr8.push('</rMateGrid>');
    }
    
    // 그리드 및 메뉴 리스트 세팅
    function gridReadyHandler8(id) {
        gridApp8 = document.getElementById(id);  // 그리드를 포함하는 div 객체
        gridRoot8 = gridApp8.getRoot();   // 데이터와 그리드를 포함하는 객체
        gridApp8.setLayout(layoutStr8.join("").toString());

        var layoutCompleteHandler = function(event) {
            dataGrid8 = gridRoot8.getDataGrid();  // 그리드 객체
            gridApp8.setData(searchList8);
        }
        var dataCompleteHandler = function(event) {
        }
       
       gridRoot8.addEventListener("dataComplete", dataCompleteHandler);
       gridRoot8.addEventListener("layoutComplete", layoutCompleteHandler);

    }
    
    /**
     * 그리드 관련 변수 선언
     */
    var jsVars9 = "rMateOnLoadCallFunction=gridReadyHandler9";
    var gridApp9, gridRoot9, dataGrid9, layoutStr9, selectorColumn9;
    var layoutStr9 = new Array();
    var rowIndex9;

    /**
     * 메뉴관리 그리드 셋팅
     */
    function fn_set_grid9() {

        rMateGridH5.create("grid9", "gridHolder9", jsVars9, "100%", "100%");
        layoutStr9.push('<rMateGrid>');
        layoutStr9.push('    <NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
        layoutStr9.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
        layoutStr9.push('<groupedColumns>');
        layoutStr9.push('    <DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
        layoutStr9.push('    <DataGridColumn dataField="REQ_CTNR_NM" headerText="'+parent.fn_text('req_ctnr_nm')+'"    width="250" textAlign="left" />');
        layoutStr9.push('    <DataGridColumn dataField="REQ_BIZRNM"  headerText="'+parent.fn_text('req_mfc_bizrnm')+'" width="100" />');
        layoutStr9.push('    <DataGridColumn dataField="CFM_CTNR_NM" headerText="'+parent.fn_text('cfm_ctnr_nm')+'"    width="250" textAlign="left" />');
        layoutStr9.push('    <DataGridColumn dataField="CFM_BIZRNM"  headerText="'+parent.fn_text('cfm_mfc_bizrnm')+'" width="100" />');
        layoutStr9.push('    <DataGridColumn dataField="REQ_QTY"     headerText="'+parent.fn_text('req_exch_qty')+'"   width="130" textAlign="right" formatter="{numfmt}" id="req_exch_qty" />'); //요청교환량
        layoutStr9.push('    <DataGridColumn dataField="CFM_QTY"     headerText="'+parent.fn_text('cfm_exch_qty')+'"   width="130" textAlign="right" formatter="{numfmt}" id="cfm_exch_qty" />'); //확인교호나량
        layoutStr9.push('    <DataGridColumn dataField="RST_QTY"     headerText="'+parent.fn_text('rst_qty')+'"        width="130" textAlign="right" formatter="{numfmt}" id="rst_qty"/>');                                                        //보정수량
        layoutStr9.push('    <DataGridColumn dataField="ADJ_QTY"     headerText="'+parent.fn_text('revi_qty')+'"       width="130" textAlign="right" formatter="{numfmt}" id="revi_qty"/>');                                                        //보정수량
        layoutStr9.push('    <DataGridColumn dataField="ADJ_GTN"     headerText="'+parent.fn_text('adj_dps')+'"        width="130" textAlign="right" id="adj_dps"/>');                            //조정보증금
        layoutStr9.push('    <DataGridColumn dataField="ADJ_RST_QTY" headerText="'+parent.fn_text('adj_rst_qty')+'"    width="130" textAlign="right" formatter="{numfmt}" id="adj_rst_qty"/>');    //조정결과수량
        layoutStr9.push('    <DataGridColumn dataField="ADJ_PROC_STAT_NM" headerText="'+parent.fn_text('stat')+'"           width="70" id="tmp1"/>');
        layoutStr9.push('</groupedColumns>');
        layoutStr9.push('    <footers>');
        layoutStr9.push('        <DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
        layoutStr9.push('            <DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
        layoutStr9.push('            <DataGridFooterColumn/>');
        layoutStr9.push('            <DataGridFooterColumn/>');
        layoutStr9.push('            <DataGridFooterColumn/>');
        layoutStr9.push('            <DataGridFooterColumn summaryOperation="SUM" dataColumn="{req_exch_qty}" formatter="{numfmt}" textAlign="right" />');
        layoutStr9.push('            <DataGridFooterColumn summaryOperation="SUM" dataColumn="{cfm_exch_qty}" formatter="{numfmt}" textAlign="right" />');
        layoutStr9.push('            <DataGridFooterColumn summaryOperation="SUM" dataColumn="{rst_qty}"      formatter="{numfmt}" textAlign="right" />');
        layoutStr9.push('            <DataGridFooterColumn summaryOperation="SUM" dataColumn="{revi_qty}"     formatter="{numfmt}" textAlign="right" />');
        layoutStr9.push('            <DataGridFooterColumn summaryOperation="SUM" dataColumn="{adj_dps}"      formatter="{numfmt}" textAlign="right" />');        
        layoutStr9.push('            <DataGridFooterColumn summaryOperation="SUM" dataColumn="{adj_rst_qty}"  formatter="{numfmt}" textAlign="right" />');
        layoutStr9.push('            <DataGridFooterColumn id="tmp1"/>');
        layoutStr9.push('        </DataGridFooter>');
        layoutStr9.push('    </footers>');
        layoutStr9.push('</DataGrid>');
        layoutStr9.push('</rMateGrid>');
    }

    // 그리드 및 메뉴 리스트 세팅
    function gridReadyHandler9(id) {
        gridApp9 = document.getElementById(id);  // 그리드를 포함하는 div 객체
        gridRoot9 = gridApp9.getRoot();   // 데이터와 그리드를 포함하는 객체
        gridApp9.setLayout(layoutStr9.join("").toString());

        var layoutCompleteHandler = function(event) {
            dataGrid9 = gridRoot9.getDataGrid();  // 그리드 객체
            gridApp9.setData(searchList9);
        }
        var dataCompleteHandler = function(event) {
        }
       
       gridRoot9.addEventListener("dataComplete", dataCompleteHandler);
       gridRoot9.addEventListener("layoutComplete", layoutCompleteHandler);

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
<input type="hidden" id="searchList2" value="<c:out value='${searchList2}' />"/>
<input type="hidden" id="searchList3" value="<c:out value='${searchList3}' />"/>
<input type="hidden" id="searchList5" value="<c:out value='${searchList5}' />"/>
<input type="hidden" id="searchList6" value="<c:out value='${searchList6}' />"/>
<input type="hidden" id="searchList7" value="<c:out value='${searchList7}' />"/>
<input type="hidden" id="searchList8" value="<c:out value='${searchList8}' />"/>
<input type="hidden" id="searchList9" value="<c:out value='${searchList9}' />"/>

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
		
		<section class="secwrap mt10" id="gridDiv7">
			<div class="h4group">
				<h4 class="tit"  id='exca_noty_dtl_data_txt'></h4>
			</div>
			<div class="boxarea" style="width:900px">
				<div id="gridHolder7" style="height:225px;"></div>
			</div>
		</section>		
		
		<section class="secwrap mt10" id="gridDiv">
			<div class="h4group">
				<h4 class="tit"  id='dlivy_crct_dd_txt'></h4>
			</div>
			<div class="boxarea">
				<div id="gridHolder" style="height:200px;"></div>
			</div>
		</section>
		<section class="secwrap mt10" id="gridDiv2">
			<div class="h4group">
				<h4 class="tit"  id='wrhs_crct_dd_txt'></h4>
			</div>
			<div class="boxarea">
				<div id="gridHolder2" style="height:300px;"></div>
			</div>
		</section>
		<section class="secwrap mt10" id="gridDiv3">
			<div class="h4group">
				<h4 class="tit"  id='drct_rtrvl_crct_dd_txt'></h4>
			</div>
			<div class="boxarea">
				<div id="gridHolder3" style="height:200px;"></div>
			</div>
		</section>
		<!-- 
		<section class="secwrap mt10">
			<div class="h4group">
				<h4 class="tit"  id='exch_exca_txt'></h4>
			</div>
			<div class="boxarea">
				<div id="gridHolder4" style="height:200px;"></div>
			</div>
		</section>
		 -->
		<section class="secwrap mt10" id="gridDiv5">
			<div class="h4group">
				<h4 class="tit"  id='fyer_rt_adj_dd_txt'></h4>
			</div>
			<div class="boxarea">
				<div id="gridHolder5" style="height:200px;"></div>
			</div>
		</section>
		<section class="secwrap mt10" id="gridDiv6">
			<div class="h4group">
				<h4 class="tit"  id='fyer_dlivy_qty_adj_d_txt'></h4>
			</div>
			<div class="boxarea">
				<div id="gridHolder6" style="height:200px;"></div>
			</div>
		</section>
        
        <section class="secwrap mt10" id="gridDiv8">
            <div class="h4group">
                <h4 class="tit"  id='fyer_rtn_qty_adj_txt'></h4> <!-- 연간입고량조정 -->
            </div>
            <div class="boxarea">
                <div id="gridHolder8" style="height:200px;"></div>
            </div>
        </section>

        <section class="secwrap mt10" id="gridDiv9">
            <div class="h4group">
                <h4 class="tit"  id='fyer_exch_qty_adj_txt'></h4> <!-- 연간교환량조정 -->
            </div>
            <div class="boxarea">
                <div id="gridHolder9" style="height:200px;"></div>
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
