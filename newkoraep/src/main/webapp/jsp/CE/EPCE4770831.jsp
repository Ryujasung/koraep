<%@ page language="java" contentType ="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">
		
	var INQ_PARAMS;
    var searchList2;
    var searchList2_2;
    var searchList7;
    var searchList7_2;
	
	$(document).ready(function(){

		INQ_PARAMS    = jsonObject($('#INQ_PARAMS').val());
		searchList2   = jsonObject($('#searchList2').val());
	    searchList2_2 = jsonObject($('#searchList2_2').val());
        searchList7   = jsonObject($('#searchList7').val());
        searchList7_2 = jsonObject($('#searchList7_2').val());

		var searchDtl   = jsonObject($('#searchDtl').val());
        var searchDtl2  = jsonObject($('#searchDtl2').val());
		var searchData  = jsonObject($('#searchData').val());
        var searchData2 = jsonObject($('#searchData2').val());

		$('#title_sub').text('<c:out value="${titleSub}" />');
		
		//버튼 셋팅
		fn_btnSetting();
					
		$('.tit').each(function(){
			$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
		});
		
		
		$('#year1').text("기준년도 : " + searchList7[0].WRHS_CFM_YEAR + "년");
		$('#year2').text("기준년도 : " + searchList7[0].CRCT_WRHS_CFM_YEAR + "년");
		
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
		$('#DRVL_BAL_MDT_AMT').text(kora.common.format_comma(searchData.DRVL_BAL_MDT_AMT) + " 원");
		$('#DRVL_BAL').text(kora.common.format_comma(searchData.DRVL_BAL) + " 원");

        $('#EXCA_TERM_2').text(kora.common.setDelim(searchDtl2.EXCA_ST_DT,'9999-99-99') +" ~ "+ kora.common.setDelim(searchDtl2.EXCA_END_DT,'9999-99-99'));
        $('#EXCA_ISSU_SE_NM_2').text(searchDtl2.EXCA_ISSU_SE_NM);
        $('#ACP_ACCT_NO_2').text(searchDtl2.ACP_ACCT_NO);
        $('#EXCA_SE_NM_2').text(searchDtl2.EXCA_SE_NM);
        $('#EXCA_AMT_2').text(kora.common.format_comma(searchDtl2.EXCA_AMT) + " 원");
        $('#BIZRNM_2').text(searchDtl2.BIZRNM);
        $('#BIZRNO_DE_2').text(kora.common.setDelim(searchDtl2.BIZRNO_DE, '999-99-99999'));
        $('#RPST_NM_2').text(searchDtl2.RPST_NM);
        $('#RPST_TEL_NO_2').text(searchDtl2.RPST_TEL_NO);
        $('#ADDR_2').text(searchDtl2.ADDR);
        
        $('#EXCA_PLAN_GTN_BAL_2').text(kora.common.format_comma(searchData2.EXCA_PLAN_GTN_BAL) + " 원");
        $('#GTN_BAL_INDE_AMT_2').text(kora.common.format_comma(searchData2.GTN_BAL_INDE_AMT) + " 원"); //GTN_INDE
        $('#EXCA_GTN_BAL_2').text(kora.common.format_comma(searchData2.EXCA_GTN_BAL) + " 원");
        $('#AGTN_BAL_PAY_AMT_2').text(kora.common.format_comma(searchData2.AGTN_BAL_PAY_AMT) + " 원");
        $('#AGTN_INDE_AMT_2').text(kora.common.format_comma(searchData2.AGTN_INDE_AMT) + " 원");
        $('#AGTN_BAL_2').text(kora.common.format_comma(searchData2.AGTN_BAL) + " 원");
        $('#DRVL_BAL_PAY_AMT_2').text(kora.common.format_comma(searchData2.DRVL_BAL_PAY_AMT) + " 원");
        $('#DRVL_BAL_MDT_AMT_2').text(kora.common.format_comma(searchData2.DRVL_BAL_MDT_AMT) + " 원");
        $('#DRVL_BAL_2').text(kora.common.format_comma(searchData2.DRVL_BAL) + " 원");

        //그리드 셋팅
        if(searchList2.length > 0){ fn_set_grid2(); }else{ $('#gridDiv2').hide(); }
        if(searchList7.length > 0){ fn_set_grid7(); }else{ $('#gridDiv7').hide(); }
        if(searchList2_2.length > 0){ fn_set_grid2_2(); }else{ $('#gridDiv2_2').hide(); }
        if(searchList7_2.length > 0){ fn_set_grid7_2(); }else{ $('#gridDiv7_2').hide(); }
		
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
		
		var url  = "/CE/EPCE4770831_09.do";
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
         layoutStr2.push('          <DataGridColumn dataField="CRCT_QTY_TOT" id="num6" headerText="'+ parent.fn_text('wrhs_qty')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
         layoutStr2.push('          <DataGridColumn dataField="CRCT_GTN_TOT" id="num7" headerText="'+ parent.fn_text('gtn')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
         layoutStr2.push('          <DataGridColumn dataField="CRCT_FEE_TOT" id="num8" headerText="'+ parent.fn_text('fee')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
         layoutStr2.push('          <DataGridColumn dataField="CRCT_FEE_STAX_TOT" id="num9" headerText="'+ parent.fn_text('stax')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
         layoutStr2.push('          <DataGridColumn dataField="CRCT_AMT" id="num10" headerText="'+ parent.fn_text('amt')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
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
         layoutStr7.push('  <DataGridColumn dataField="ETC_CD_NM"  headerText="'+parent.fn_text('se')+'" width="350"/>');
         layoutStr7.push('  <DataGridColumn id="num1" dataField="PAY_PLAN_AMT"  headerText="'+parent.fn_text('pay_plan_amt')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
         layoutStr7.push('  <DataGridColumn id="num2" dataField="ACP_PLAN_AMT"  headerText="'+parent.fn_text('acp_plan_amt')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
         layoutStr7.push('  <DataGridColumn id="num3" dataField="OFF_SET_AMT"  headerText="'+parent.fn_text('exca_amt')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
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
     var jsVars2_2 = "rMateOnLoadCallFunction=gridReadyHandler2_2";
     var gridApp2_2, gridRoot2_2, dataGrid2_2, layoutStr2_2, selectorColumn2_2;
     var layoutStr2_2 = new Array();
     
     /**
      * 메뉴관리 그리드 셋팅
      */
      function fn_set_grid2_2() {
          
          rMateGridH5.create("grid2_2", "gridHolder2_2", jsVars2_2, "100%", "100%");
          
          layoutStr2_2.push('<rMateGrid>');
          layoutStr2_2.push('<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
          layoutStr2_2.push('<NumberMaskFormatter id="dateFmt" formatString="####-##-##"/>');
          layoutStr2_2.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg2" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true"  textAlign="center" draggableColumns="true" sortableColumns="true" > ');
          layoutStr2_2.push('<groupedColumns>');
          layoutStr2_2.push('    <DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
          layoutStr2_2.push('    <DataGridColumn dataField="WRHS_CFM_DT_ORI"  headerText="'+parent.fn_text('wrhs_cfm_dt')+'" width="100" formatter="{dateFmt}" />');
          layoutStr2_2.push('    <DataGridColumn dataField="CUST_BIZRNM"  headerText="'+parent.fn_text('whsdl')+'" width="150"/>');
          layoutStr2_2.push('    <DataGridColumn dataField="MFC_BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150"/>');
          layoutStr2_2.push('    <DataGridColumn dataField="MFC_BRCH_NM"  headerText="'+parent.fn_text('mfc_brch_nm')+'" width="150"/>');
          layoutStr2_2.push('        <DataGridColumnGroup headerText="'+ parent.fn_text('reg_info')+ '">');
          layoutStr2_2.push('            <DataGridColumn dataField="CFM_QTY_TOT" id="num1" headerText="'+ parent.fn_text('wrhs_qty')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
          layoutStr2_2.push('            <DataGridColumn dataField="CFM_GTN_TOT" id="num2" headerText="'+ parent.fn_text('gtn')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
          layoutStr2_2.push('            <DataGridColumn dataField="CFM_FEE_TOT" id="num3" headerText="'+ parent.fn_text('fee')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
          layoutStr2_2.push('            <DataGridColumn dataField="CFM_FEE_STAX_TOT" id="num4" headerText="'+ parent.fn_text('stax')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
          layoutStr2_2.push('            <DataGridColumn dataField="CFM_AMT" id="num5" headerText="'+ parent.fn_text('amt')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
          layoutStr2_2.push('        </DataGridColumnGroup>');
          layoutStr2_2.push('        <DataGridColumnGroup headerText="'+ parent.fn_text('crct_reg')+ '" >');
          layoutStr2_2.push('            <DataGridColumn dataField="CRCT_QTY_TOT" id="num6" headerText="'+ parent.fn_text('wrhs_qty')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
          layoutStr2_2.push('            <DataGridColumn dataField="CRCT_GTN_TOT" id="num7" headerText="'+ parent.fn_text('gtn')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
          layoutStr2_2.push('            <DataGridColumn dataField="CRCT_FEE_TOT" id="num8" headerText="'+ parent.fn_text('fee')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
          layoutStr2_2.push('            <DataGridColumn dataField="CRCT_FEE_STAX_TOT" id="num9" headerText="'+ parent.fn_text('stax')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
          layoutStr2_2.push('            <DataGridColumn dataField="CRCT_AMT" id="num10" headerText="'+ parent.fn_text('amt')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
          layoutStr2_2.push('        </DataGridColumnGroup>');
          layoutStr2_2.push('    <DataGridColumn dataField="WRHS_CRCT_STAT_CD_NM_ORI"  headerText="'+parent.fn_text('stat')+'" width="100"/>');
          layoutStr2_2.push('</groupedColumns>');
          layoutStr2_2.push('<footers>');
          layoutStr2_2.push('    <DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
          layoutStr2_2.push('        <DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
          layoutStr2_2.push('        <DataGridFooterColumn/>');
          layoutStr2_2.push('        <DataGridFooterColumn/>');
          layoutStr2_2.push('        <DataGridFooterColumn/>');
          layoutStr2_2.push('        <DataGridFooterColumn/>');
          layoutStr2_2.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');    
          layoutStr2_2.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');    
          layoutStr2_2.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');    
          layoutStr2_2.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');    
          layoutStr2_2.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');    
          layoutStr2_2.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');    
          layoutStr2_2.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');    
          layoutStr2_2.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num8}" formatter="{numfmt}" textAlign="right"/>');    
          layoutStr2_2.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num9}" formatter="{numfmt}" textAlign="right"/>');    
          layoutStr2_2.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num10}" formatter="{numfmt}" textAlign="right"/>');   
          layoutStr2_2.push('        <DataGridFooterColumn/>');
          layoutStr2_2.push('    </DataGridFooter>');
          layoutStr2_2.push('</footers>');
          layoutStr2_2.push('</DataGrid>');
          layoutStr2_2.push('</rMateGrid>');
     }
     
     // 그리드 및 메뉴 리스트 세팅
      function gridReadyHandler2_2(id) {
          gridApp2_2 = document.getElementById(id);  // 그리드를 포함하는 div 객체
          gridRoot2_2 = gridApp2_2.getRoot();   // 데이터와 그리드를 포함하는 객체
          gridApp2_2.setLayout(layoutStr2_2.join("").toString());

          var layoutCompleteHandler = function(event) {
              dataGrid2_2 = gridRoot2_2.getDataGrid();  // 그리드 객체
              gridApp2_2.setData(searchList2_2);
         }
         var dataCompleteHandler = function(event) {
         }
         
         gridRoot2_2.addEventListener("dataComplete", dataCompleteHandler);
         gridRoot2_2.addEventListener("layoutComplete", layoutCompleteHandler);
      }

      /**
      * 그리드 관련 변수 선언
      */
     var jsVars7_2 = "rMateOnLoadCallFunction=gridReadyHandler7_2";
     var gridApp7_2, gridRoot7_2, dataGrid7_2, layoutStr7_2, selectorColumn7_2;
     var layoutStr7_2 = new Array();
     var rowIndex7_2;
     
     /**
      * 메뉴관리 그리드 셋팅
      */
      function fn_set_grid7_2() {
          
          rMateGridH5.create("grid7_2", "gridHolder7_2", jsVars7_2, "100%", "100%");
          
          layoutStr7_2.push('<rMateGrid>');
          layoutStr7_2.push('<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
          layoutStr7_2.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg7" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true"  textAlign="center" draggableColumns="true" sortableColumns="true" > ');
          layoutStr7_2.push('<groupedColumns>');
          layoutStr7_2.push('  <DataGridColumn dataField="ETC_CD_NM"  headerText="'+parent.fn_text('se')+'" width="350"/>');
          layoutStr7_2.push('  <DataGridColumn id="num1" dataField="PAY_PLAN_AMT"  headerText="'+parent.fn_text('pay_plan_amt')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
          layoutStr7_2.push('  <DataGridColumn id="num2" dataField="ACP_PLAN_AMT"  headerText="'+parent.fn_text('acp_plan_amt')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
          layoutStr7_2.push('  <DataGridColumn id="num3" dataField="OFF_SET_AMT"  headerText="'+parent.fn_text('exca_amt')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
          layoutStr7_2.push('</groupedColumns>');
          layoutStr7_2.push('</DataGrid>');
          layoutStr7_2.push('</rMateGrid>');
     }
     
     // 그리드 및 메뉴 리스트 세팅
      function gridReadyHandler7_2(id) {
          gridApp7_2 = document.getElementById(id);  // 그리드를 포함하는 div 객체
          gridRoot7_2 = gridApp7_2.getRoot();   // 데이터와 그리드를 포함하는 객체
          gridApp7_2.setLayout(layoutStr7_2.join("").toString());

          var layoutCompleteHandler = function(event) {
              dataGrid7_2 = gridRoot7_2.getDataGrid();  // 그리드 객체
              gridApp7_2.setData(searchList7_2);
          }
          var dataCompleteHandler = function(event) {
          }
         
         gridRoot7_2.addEventListener("dataComplete", dataCompleteHandler);
         gridRoot7_2.addEventListener("layoutComplete", layoutCompleteHandler);

      }    
</script>

<style type="text/css">
	.row .tit{width: 57px;}
</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="searchDtl" value="<c:out value='${searchDtl}' />"/>
<input type="hidden" id="searchDtl2" value="<c:out value='${searchDtl2}' />"/>
<input type="hidden" id="searchData" value="<c:out value='${searchData}' />"/>
<input type="hidden" id="searchData2" value="<c:out value='${searchData2}' />"/>
<input type="hidden" id="searchList" value="<c:out value='${searchList}' />"/>
<input type="hidden" id="searchList2" value="<c:out value='${searchList2}' />"/>
<input type="hidden" id="searchList2_2" value="<c:out value='${searchList2_2}' />"/>
<input type="hidden" id="searchList7" value="<c:out value='${searchList7}' />"/>
<input type="hidden" id="searchList7_2" value="<c:out value='${searchList7_2}' />"/>

	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
			<div class="singleRow">
				<div class="btn" id="UR"></div>
			</div>
		</div>

        <section class="secwrap">
            <div class="halfarea" style="float: left;">
                <div class="h4group">
                    <h4 class="tit" id="year1"></h4>
                </div>
            </div>
        </section>

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
				<div id="gridHolder7" style="height:75px;"></div>
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
        
        
        <section class="secwrap mt20">
            <div class="halfarea" style="float: left;">
                <div class="h4group">
                    <h4 class="tit" id="year2"></h4>
                </div>
            </div>
        </section>

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
                                    <div class="txtbox" id="EXCA_TERM_2"></div>&nbsp;
                                </div>
                            </td>
                            <th><span class="tit" id="stac_doc_no_txt"></span></th>
                            <td>
                                <div class="row" >
                                    <div class="txtbox" id="STAC_DOC_NO_2" ></div>&nbsp;
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="tit" id="exca_se_txt"></span></th>
                            <td>
                                <div class="row" >
                                    <div class="txtbox" id="EXCA_SE_NM_2" ></div>&nbsp;
                                </div>
                            </td>
                            <th><span class="tit" id="acp_acct_no_txt"></span></th>
                            <td>
                                <div class="row" >
                                    <div class="txtbox" id="ACP_ACCT_NO_2" ></div>&nbsp;
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="tit" id="exca_issu_se_txt"></span></th>
                            <td>
                                <div class="row" >
                                    <div class="txtbox" id="EXCA_ISSU_SE_NM_2" ></div>&nbsp;
                                </div>
                            </td>
                            <th><span class="tit" id="exca_amt_txt"></span></th>
                            <td>
                                <div class="row" >
                                    <div class="txtbox" id="EXCA_AMT_2" ></div>&nbsp;
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="tit" id="mtl_nm_txt"></span></th>
                            <td>
                                <div class="row" >
                                    <div class="txtbox" id="BIZRNM_2" ></div>&nbsp;
                                </div>
                            </td>
                            <th><span class="tit" id="bizrno2_txt"></span></th>
                            <td>
                                <div class="row" >
                                    <div class="txtbox" id="BIZRNO_DE_2" ></div>&nbsp;
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="tit" id="rpst_txt"></span></th>
                            <td>
                                <div class="row" >
                                    <div class="txtbox" id="RPST_NM_2" ></div>&nbsp;
                                </div>
                            </td>
                            <th><span class="tit" id="tel_no2_txt"></span></th>
                            <td>
                                <div class="row" >
                                    <div class="txtbox" id="RPST_TEL_NO_2" ></div>&nbsp;
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="tit" id="addr_txt"></span></th>
                            <td colspan="3">
                                <div class="row" >
                                    <div class="txtbox" id="ADDR_2" ></div>&nbsp;
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
                                    <div class="txtbox" id="EXCA_PLAN_GTN_BAL_2" style="float:none;">&nbsp;</div>
                                </div>
                            </td>
                            <th><span class="tit" id="gtn_adj_amt_txt"></span></th>
                            <td>
                                <div class="row" style="text-align:right;">
                                    <div class="txtbox" id="GTN_BAL_INDE_AMT_2" style="float:none;">&nbsp;</div>
                                </div>
                            </td>
                            <th><span class="tit" id="plan_gtn_bal_txt"></span></th>
                            <td>
                                <div class="row" style="text-align:right;">
                                    <div class="txtbox" id="EXCA_GTN_BAL_2" style="float:none;">&nbsp;</div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="tit" id="adit_gtn_acmt_txt"></span></th>
                            <td>
                                <div class="row" style="text-align:right;">
                                    <div class="txtbox" id="AGTN_BAL_PAY_AMT_2" style="float:none;">&nbsp;</div>
                                </div>
                            </td>
                            <th><span class="tit" id="adit_gtn_adj_txt"></span></th>
                            <td>
                                <div class="row" style="text-align:right;">
                                    <div class="txtbox" id="AGTN_INDE_AMT_2" style="float:none;">&nbsp;</div>
                                </div>
                            </td>
                            <th><span class="tit" id="adit_gtn_plan_bal_txt"></span></th>
                            <td>
                                <div class="row" style="text-align:right;">
                                    <div class="txtbox" id="AGTN_BAL_2" style="float:none;">&nbsp;</div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="tit" id="drct_rtrvl_non_acmt_txt"></span></th>
                            <td>
                                <div class="row" style="text-align:right;">
                                    <div class="txtbox" id="DRVL_BAL_PAY_AMT_2" style="float:none;">&nbsp;</div>
                                </div>
                            </td>
                            <th><span class="tit" id="drct_rtrvl_adj_amt_txt"></span></th>
                            <td>
                                <div class="row" style="text-align:right;">
                                    <div class="txtbox" id="DRVL_BAL_MDT_AMT_2" style="float:none;">&nbsp;</div>
                                </div>
                            </td>
                            <th><span class="tit" id="drct_rtrvl_non_bal2_txt"></span></th>
                            <td>
                                <div class="row" style="text-align:right;">
                                    <div class="txtbox" id="DRVL_BAL_2" style="float:none;">&nbsp;</div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </section>
        
        <section class="secwrap mt10" id="gridDiv7_2">
            <div class="h4group">
                <h4 class="tit"  id='exca_noty_dtl_data_txt'></h4>
            </div>
            <div class="boxarea" style="width:900px">
                <div id="gridHolder7_2" style="height:75px;"></div>
            </div>
        </section>      

        <section class="secwrap mt10" id="gridDiv2_2">
            <div class="h4group">
                <h4 class="tit"  id='wrhs_crct_dd_txt'></h4>
            </div>
            <div class="boxarea">
                <div id="gridHolder2_2" style="height:300px;"></div>
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
