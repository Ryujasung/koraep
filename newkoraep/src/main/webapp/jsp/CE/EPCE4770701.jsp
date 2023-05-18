<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">

var INQ_PARAMS;
var mfcBizrList;

$(document).ready(function(){

    INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
    mfcBizrList = jsonObject($('#mfcBizrList').val());

    //버튼 셋팅
    fn_btnSetting();

    $('.tit').each(function(){
        $(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
    });

    $('#EXCA_TERM').text(kora.common.setDelim(mfcBizrList[0].EXCA_ST_DT,'9999-99-99') +" ~ "+ kora.common.setDelim(mfcBizrList[0].EXCA_END_DT,'9999-99-99'));

    kora.common.setEtcCmBx2(mfcBizrList, "", "", $("#MFC_BIZR_SEL"), "BIZRID_NO", "BIZRNM", "N", "S");

    //파라미터 조회조건으로 셋팅
    if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
        kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
    }

    //그리드 셋팅
    fn_set_grid();
    fn_set_grid2();
    fn_set_grid3();
    fn_set_grid5();
    fn_set_grid6();
    fn_set_grid7();
    fn_set_grid8();
    fn_set_grid9();

    //조회 버튼
    $("#btn_sel").click(function(){
        fn_sel();
    });

    //정산금액확인 버튼
    $("#btn_reg").click(function(){
        fn_reg();
    });

});

function fn_reg(){

    var chkLst = selectorColumn9.getSelectedItems();
    if(chkLst.length < 1){
        alertMsg("선택된 내역이 없습니다.");
        return;
    }

    var row = new Array();
    for(var i=chkLst.length-1; i>=0; i--) {
        var item = {};
        
        item["ETC_CD"      ] = chkLst[i].ETC_CD;
        item["ETC_CD_NM"   ] = chkLst[i].ETC_CD_NM;
        item["PAY_PLAN_AMT"] = kora.common.null2void(chkLst[i].PAY_PLAN_AMT,"0");
        item["ACP_PLAN_AMT"] = kora.common.null2void(chkLst[i].ACP_PLAN_AMT,"0");
        item["OFF_SET_AMT" ] = Number(item.PAY_PLAN_AMT)-Number(item.ACP_PLAN_AMT);
        
        //추가보증금잔액, 직접회수미지급잔액
        if(chkLst[i].ETC_CD == "G" || chkLst[i].ETC_CD == "H"){
            var nPymtMdtAmt  = Number(kora.common.null2void(chkLst[i].PAY_MDT_AMT,"0"));
            item["PAY_PLAN_AMT"] = nPymtMdtAmt;
            item["OFF_SET_AMT" ] = nPymtMdtAmt;
        }
        
        row.push(item);
    }

    var input = INQ_PARAMS["SEL_PARAMS"];

    INQ_PARAMS["list"] = row;
    INQ_PARAMS["PARAMS"] = input;
    INQ_PARAMS["REPAY_AMT"] = $("#REPAY_AMT").val();    
    INQ_PARAMS["PAY_AMT"] = $("#PAY_AMT").val();    
    INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
    INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE4770701.do";
    kora.common.goPage('/CE/EPCE4770731.do', INQ_PARAMS);

}

/**
 * 목록조회
 */
function fn_sel(){

    if($('#MFC_BIZR_SEL').val() == '' ){
        alertMsg('생산자를 선택하세요.');
        return;
    }

    var input = {};
    input["MFC_BIZR_SEL"] = $("#MFC_BIZR_SEL").val();
    input["EXCA_SE_YEAR"] = mfcBizrList[0].EXCA_SE_YEAR; //정산기준년도
    input["EXCA_STD_CD"] = mfcBizrList[0].EXCA_STD_CD;

    INQ_PARAMS["SEL_PARAMS"] = input;

    var url = "/CE/EPCE4770701_19.do";

    kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
    ajaxPost(url, input, function(rtnData){
        if(rtnData != null && rtnData != ""){

            if(rtnData.searchMap != null){
                $('#PLAN_GTN_BAL').text(kora.common.format_comma(rtnData.searchMap.PLAN_GTN_BAL)+ ' 원');
                $('#ADIT_GTN_BAL').text(kora.common.format_comma(rtnData.searchMap.ADIT_GTN_BAL)+ ' 원');
                $('#DRCT_PAY_GTN_BAL').text(kora.common.format_comma(rtnData.searchMap.DRCT_PAY_GTN_BAL)+ ' 원');
            }else{
                $('#PLAN_GTN_BAL').text('0 원');
                $('#ADIT_GTN_BAL').text('0 원');
                $('#DRCT_PAY_GTN_BAL').text('0 원');
            }

          gridApp.setData(rtnData.searchList);   //출고정정
          gridApp2.setData(rtnData.searchList2); //입고정정
          gridApp3.setData(rtnData.searchList3); //직접회수정정
          gridApp5.setData(rtnData.searchList5); //연간혼비율정정
          gridApp6.setData(rtnData.searchList6); //연간출고량정정
          gridApp7.setData(rtnData.searchList8); //연간입고량조정
          gridApp8.setData(rtnData.searchList9); //연간교환량조정
          gridApp9.setData(rtnData.searchList7); //정산설정
          
          fn_calcFee(rtnData.searchList2);  //취급수수료 부가세 계산

        }
        else {
            alertMsg("error");
        }
        kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
    });
}

//입고정정 취급수수료 계산
function fn_calcFee(rtnData){
    var rTot = 0;
    var pTot = 0;
    for(var i=0; i<rtnData.length; i++){
        var map = rtnData[i];
        rTot = rTot + Number(map.CFM_FEE_TOT) + Number(map.CFM_FEE_STAX_TOT);
        pTot = pTot + Number(map.CRCT_FEE_TOT) + Number(map.CRCT_FEE_STAX_TOT);
    }
    var amt = Number(rTot) - Number(pTot); 
    
    if(amt >= 0){
        $("#repayAmt").text(kora.common.gfn_setComma(amt) + " 원");
        $("#payAmt").text("0 원");
        $("#REPAY_AMT").val(amt);
        $("#PAY_AMT").val("0");
    }else{
        $("#repayAmt").text("0 원");
        $("#payAmt").text(kora.common.gfn_setComma(Math.abs(amt)) + " 원");
        $("#REPAY_AMT").val("0");
        $("#PAY_AMT").val(Math.abs(amt));
    }
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
    layoutStr.push('    <DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
    layoutStr.push('    <DataGridColumn dataField="DLIVY_DT"  headerText="'+parent.fn_text('dlivy_dt')+'" width="100" formatter="{dateFmt}" />');
    layoutStr.push('    <DataGridColumn dataField="MFC_BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150"/>');
    layoutStr.push('    <DataGridColumn dataField="MFC_BRCH_NM"  headerText="'+parent.fn_text('mfc_brch_nm')+'" width="150"/>');
    layoutStr.push('    <DataGridColumn dataField="CUST_BIZRNM"  headerText="'+parent.fn_text('cust')+'" width="150"/>');
    layoutStr.push('    <DataGridColumn dataField="CTNR_NM"  headerText="'+parent.fn_text('ctnr_nm')+'" width="150"/>');
    layoutStr.push('    <DataGridColumn dataField="PRPS_NM"  headerText="'+parent.fn_text('prps_cd')+'" width="120"/>');
    layoutStr.push('    <DataGridColumn dataField="CPCT_NM"  headerText="'+parent.fn_text('cpct_cd')+'" width="120"/>');
    layoutStr.push('    <DataGridColumn dataField="DLIVY_QTY" id="num1" headerText="'+parent.fn_text('dlivy_qty2')+'" width="120" textAlign="right" />');
    layoutStr.push('    <DataGridColumn dataField="DLIVY_GTN" id="num2" headerText="'+parent.fn_text('gtn')+'" width="120" textAlign="right" />');
    layoutStr.push('    <DataGridColumn dataField="DLIVY_CRCT_STAT_NM"  headerText="'+parent.fn_text('stat')+'" width="100"/>');
    layoutStr.push('</groupedColumns>');
    layoutStr.push('<footers>');
    layoutStr.push('    <DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
    layoutStr.push('        <DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
    layoutStr.push('        <DataGridFooterColumn/>');
    layoutStr.push('        <DataGridFooterColumn/>');
    layoutStr.push('        <DataGridFooterColumn/>');
    layoutStr.push('        <DataGridFooterColumn/>');
    layoutStr.push('        <DataGridFooterColumn/>');
    layoutStr.push('        <DataGridFooterColumn/>');
    layoutStr.push('        <DataGridFooterColumn/>');
    layoutStr.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('        <DataGridFooterColumn/>');
    layoutStr.push('    </DataGridFooter>');
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
        gridApp.setData();
    }

    var dataCompleteHandler = function(event) {}

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
    layoutStr2.push('    <DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
    layoutStr2.push('    <DataGridColumn dataField="WRHS_CFM_DT_ORI"  headerText="'+parent.fn_text('wrhs_cfm_dt')+'" width="100" formatter="{dateFmt}" />');
    layoutStr2.push('    <DataGridColumn dataField="CUST_BIZRNM"  headerText="'+parent.fn_text('whsdl')+'" width="150"/>');
    layoutStr2.push('    <DataGridColumn dataField="MFC_BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150"/>');
    layoutStr2.push('    <DataGridColumn dataField="MFC_BRCH_NM"  headerText="'+parent.fn_text('mfc_brch_nm')+'" width="150"/>');
    layoutStr2.push('        <DataGridColumnGroup headerText="'+ parent.fn_text('reg_info')+ '">');
    layoutStr2.push('            <DataGridColumn dataField="CFM_QTY_TOT" id="num1" headerText="'+ parent.fn_text('wrhs_qty')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
    layoutStr2.push('            <DataGridColumn dataField="CFM_GTN_TOT" id="num2" headerText="'+ parent.fn_text('gtn')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
    layoutStr2.push('            <DataGridColumn dataField="CFM_FEE_TOT" id="num3" headerText="'+ parent.fn_text('fee')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
    layoutStr2.push('            <DataGridColumn dataField="CFM_FEE_STAX_TOT" id="num4" headerText="'+ parent.fn_text('stax')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
    layoutStr2.push('            <DataGridColumn dataField="CFM_AMT" id="num5" headerText="'+ parent.fn_text('amt')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
    layoutStr2.push('        </DataGridColumnGroup>');
    layoutStr2.push('        <DataGridColumnGroup headerText="'+ parent.fn_text('crct_reg')+ '" >');
    layoutStr2.push('            <DataGridColumn dataField="CRCT_QTY_TOT" id="num6" headerText="'+ parent.fn_text('wrhs_qty')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
    layoutStr2.push('            <DataGridColumn dataField="CRCT_GTN_TOT" id="num7" headerText="'+ parent.fn_text('gtn')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
    layoutStr2.push('            <DataGridColumn dataField="CRCT_FEE_TOT" id="num8" headerText="'+ parent.fn_text('fee')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
    layoutStr2.push('            <DataGridColumn dataField="CRCT_FEE_STAX_TOT" id="num9" headerText="'+ parent.fn_text('stax')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
    layoutStr2.push('            <DataGridColumn dataField="CRCT_AMT" id="num10" headerText="'+ parent.fn_text('amt')+ '" width="120" formatter="{numfmt}" textAlign="right" />');
    layoutStr2.push('        </DataGridColumnGroup>');
    layoutStr2.push('    <DataGridColumn dataField="WRHS_CRCT_STAT_CD_NM_ORI"  headerText="'+parent.fn_text('stat')+'" width="100"/>');
    layoutStr2.push('    <DataGridColumn dataField="MNUL_EXCA_SE_NM"  headerText="'+parent.fn_text('se')+'" width="100"/>');
    layoutStr2.push('</groupedColumns>');
    layoutStr2.push('<footers>');
    layoutStr2.push('    <DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
    layoutStr2.push('        <DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
    layoutStr2.push('        <DataGridFooterColumn/>');
    layoutStr2.push('        <DataGridFooterColumn/>');
    layoutStr2.push('        <DataGridFooterColumn/>');
    layoutStr2.push('        <DataGridFooterColumn/>');
    layoutStr2.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr2.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr2.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr2.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr2.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr2.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr2.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr2.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num8}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr2.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num9}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr2.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num10}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr2.push('        <DataGridFooterColumn/>');
    layoutStr2.push('        <DataGridFooterColumn/>');
    layoutStr2.push('    </DataGridFooter>');
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
        gridApp2.setData();
    }
    var dataCompleteHandler = function(event) {}

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
    layoutStr3.push('    <DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
    layoutStr3.push('    <DataGridColumn dataField="DRCT_RTRVL_DT"  headerText="'+parent.fn_text('drct_rtrvl_dt')+'" width="100" formatter="{dateFmt}" />');
    layoutStr3.push('    <DataGridColumn dataField="MFC_BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150"/>');
    layoutStr3.push('    <DataGridColumn dataField="MFC_BRCH_NM"  headerText="'+parent.fn_text('mfc_brch_nm')+'" width="150"/>');
    layoutStr3.push('    <DataGridColumn dataField="CUST_BIZRNM"  headerText="'+parent.fn_text('cust')+'" width="150"/>');
    layoutStr3.push('    <DataGridColumn dataField="CTNR_NM"  headerText="'+parent.fn_text('ctnr_nm')+'" width="150"/>');
    layoutStr3.push('    <DataGridColumn dataField="PRPS_NM"  headerText="'+parent.fn_text('prps_cd')+'" width="120"/>');
    layoutStr3.push('    <DataGridColumn dataField="CPCT_NM"  headerText="'+parent.fn_text('cpct_cd')+'" width="120"/>');
    layoutStr3.push('    <DataGridColumn dataField="DRCT_RTRVL_QTY" id="num1" headerText="'+parent.fn_text('drct_rtrvl_qty')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
    layoutStr3.push('    <DataGridColumn dataField="DRCT_PAY_GTN" id="num2" headerText="'+parent.fn_text('drct_rtrvl_gtn')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
    layoutStr3.push('    <DataGridColumn dataField="DRCT_PAY_FEE" id="num3" headerText="'+parent.fn_text('drct_rtrvl_fee')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
    layoutStr3.push('    <DataGridColumn dataField="DRCT_RTRVL_CRCT_STAT_NM"  headerText="'+parent.fn_text('stat')+'" width="100"/>');
    layoutStr3.push('</groupedColumns>');
    layoutStr3.push('<footers>');
    layoutStr3.push('    <DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
    layoutStr3.push('        <DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
    layoutStr3.push('        <DataGridFooterColumn/>');
    layoutStr3.push('        <DataGridFooterColumn/>');
    layoutStr3.push('        <DataGridFooterColumn/>');
    layoutStr3.push('        <DataGridFooterColumn/>');
    layoutStr3.push('        <DataGridFooterColumn/>');
    layoutStr3.push('        <DataGridFooterColumn/>');
    layoutStr3.push('        <DataGridFooterColumn/>');
    layoutStr3.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr3.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr3.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr3.push('        <DataGridFooterColumn/>');
    layoutStr3.push('    </DataGridFooter>');
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
        gridApp3.setData();
    }
    var dataCompleteHandler = function(event) {}

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
    layoutStr5.push('    <DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
    layoutStr5.push('    <DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150"/>');
    layoutStr5.push('    <DataGridColumn dataField="PRPS_NM"  headerText="'+parent.fn_text('prps_cd')+'" width="120"/>');
    layoutStr5.push('    <DataGridColumn dataField="CTNR_NM"  headerText="'+parent.fn_text('ctnr_nm')+'" width="150"/>');
    layoutStr5.push('    <DataGridColumn dataField="CPCT_NM"  headerText="'+parent.fn_text('cpct_cd')+'" width="120"/>');
    layoutStr5.push('    <DataGridColumn dataField="FYER_QTY" id="num1" headerText="'+parent.fn_text('wrhs_qty')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
    layoutStr5.push('    <DataGridColumn dataField="ADJ_RT"  headerText="'+parent.fn_text('adj_rt')+'" width="120" textAlign="right"/>');
    layoutStr5.push('    <DataGridColumn dataField="ADJ_QTY" id="num2" headerText="'+parent.fn_text('adj_wrhs_qty2')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
    layoutStr5.push('    <DataGridColumn dataField="ADJ_GTN" id="num3" headerText="'+parent.fn_text('adj_gtn')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
    layoutStr5.push('    <DataGridColumn dataField="ADJ_PROC_STAT_NM"  headerText="'+parent.fn_text('stat')+'" width="100"/>');
    layoutStr5.push('</groupedColumns>');
    layoutStr5.push('<footers>');
    layoutStr5.push('    <DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
    layoutStr5.push('        <DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
    layoutStr5.push('        <DataGridFooterColumn/>');
    layoutStr5.push('        <DataGridFooterColumn/>');
    layoutStr5.push('        <DataGridFooterColumn/>');
    layoutStr5.push('        <DataGridFooterColumn/>');
    layoutStr5.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr5.push('        <DataGridFooterColumn/>');
    layoutStr5.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr5.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr5.push('        <DataGridFooterColumn/>');
    layoutStr5.push('    </DataGridFooter>');
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
        gridApp5.setData();
    }

    var dataCompleteHandler = function(event) {}

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
    layoutStr6.push('    <DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
    layoutStr6.push('    <DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150"/>');
    layoutStr6.push('    <DataGridColumn dataField="PRPS_NM"  headerText="'+parent.fn_text('prps_cd')+'" width="120"/>');
    layoutStr6.push('    <DataGridColumn dataField="CTNR_NM"  headerText="'+parent.fn_text('ctnr_nm')+'" width="150"/>');
    layoutStr6.push('    <DataGridColumn dataField="CPCT_NM"  headerText="'+parent.fn_text('cpct_cd')+'" width="120"/>');
    layoutStr6.push('    <DataGridColumn dataField="FYER_QTY" id="num1" headerText="'+parent.fn_text('dlivy_qty2')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
    layoutStr6.push('    <DataGridColumn dataField="ADJ_RT"  headerText="'+parent.fn_text('adj_qty')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
    layoutStr6.push('    <DataGridColumn dataField="ADJ_QTY" id="num2" headerText="'+parent.fn_text('adj_dlivy_qty')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
    layoutStr6.push('    <DataGridColumn dataField="ADJ_GTN" id="num3" headerText="'+parent.fn_text('adj_gtn')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
    layoutStr6.push('    <DataGridColumn dataField="ADJ_PROC_STAT_NM"  headerText="'+parent.fn_text('stat')+'" width="100"/>');
    layoutStr6.push('</groupedColumns>');
    layoutStr6.push('<footers>');
    layoutStr6.push('    <DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
    layoutStr6.push('        <DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
    layoutStr6.push('        <DataGridFooterColumn/>');
    layoutStr6.push('        <DataGridFooterColumn/>');
    layoutStr6.push('        <DataGridFooterColumn/>');
    layoutStr6.push('        <DataGridFooterColumn/>');
    layoutStr6.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr6.push('        <DataGridFooterColumn/>');
    layoutStr6.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr6.push('        <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr6.push('        <DataGridFooterColumn/>');
    layoutStr6.push('    </DataGridFooter>');
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
        gridApp6.setData();
    }
    
    var dataCompleteHandler = function(event) {}

    gridRoot6.addEventListener("dataComplete", dataCompleteHandler);
    gridRoot6.addEventListener("layoutComplete", layoutCompleteHandler);
}

/**
 * 그리드 관련 변수 선언
 */
var jsVars7 = "rMateOnLoadCallFunction=gridReadyHandler7";
var gridApp7, gridRoot7, dataGrid7, layoutStr7, selectorColumn7;
var layoutStr7 = new Array();


function fn_set_grid7() {

    rMateGridH5.create("grid7", "gridHolder7", jsVars7, "100%", "100%");

    layoutStr7.push('<rMateGrid>');
    layoutStr7.push('<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
    layoutStr7.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg8" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true"  textAlign="center" draggableColumns="true" sortableColumns="true" > ');
    layoutStr7.push('<groupedColumns>');
    layoutStr7.push('  <DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
    layoutStr7.push('  <DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150"/>');
    layoutStr7.push('  <DataGridColumn dataField="PRPS_NM"  headerText="'+parent.fn_text('prps_cd')+'" width="120"/>');
    layoutStr7.push('  <DataGridColumn dataField="CTNR_NM"  headerText="'+parent.fn_text('ctnr_nm')+'" width="150"/>');
    layoutStr7.push('  <DataGridColumn dataField="CPCT_NM"  headerText="'+parent.fn_text('cpct_cd')+'" width="120"/>');
    layoutStr7.push('  <DataGridColumn dataField="FYER_QTY" id="num1" headerText="'+parent.fn_text('wrhs_qty')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
    layoutStr7.push('  <DataGridColumn dataField="ADJ_RT"  headerText="'+parent.fn_text('adj_qty')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
    layoutStr7.push('  <DataGridColumn dataField="ADJ_QTY" id="num2" headerText="'+parent.fn_text('adj_wrhs_qty2')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
    layoutStr7.push('  <DataGridColumn dataField="ADJ_GTN" id="num3" headerText="'+parent.fn_text('adj_gtn')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
    layoutStr7.push('  <DataGridColumn dataField="ADJ_PROC_STAT_NM"  headerText="'+parent.fn_text('stat')+'" width="100"/>');
    layoutStr7.push('</groupedColumns>');
    layoutStr7.push('<footers>');
    layoutStr7.push('  <DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
    layoutStr7.push('      <DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
    layoutStr7.push('      <DataGridFooterColumn/>');
    layoutStr7.push('      <DataGridFooterColumn/>');
    layoutStr7.push('      <DataGridFooterColumn/>');
    layoutStr7.push('      <DataGridFooterColumn/>');
    layoutStr7.push('      <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr7.push('      <DataGridFooterColumn/>');
    layoutStr7.push('      <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr7.push('      <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr7.push('      <DataGridFooterColumn/>');
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
        gridApp7.setData();
    }

    var dataCompleteHandler = function(event) {}

    gridRoot7.addEventListener("dataComplete", dataCompleteHandler);
    gridRoot7.addEventListener("layoutComplete", layoutCompleteHandler);
}

/**
 * 그리드 관련 변수 선언
 */
var jsVars8 = "rMateOnLoadCallFunction=gridReadyHandler8";
var gridApp8, gridRoot8, dataGrid8, layoutStr8, selectorColumn8;
var layoutStr8 = new Array();
var rowIndex8;

/**
 * 메뉴관리 그리드 셋팅
 */
function fn_set_grid8() {

    rMateGridH5.create("grid8", "gridHolder8", jsVars8, "100%", "100%");
    layoutStr8.push('<rMateGrid>');
    layoutStr8.push('    <NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
    layoutStr8.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
    layoutStr8.push('<groupedColumns>');
    layoutStr8.push('    <DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');        
    layoutStr8.push('    <DataGridColumn dataField="REQ_CTNR_NM" headerText="'+parent.fn_text('req_ctnr_nm')+'"    width="250" textAlign="left" />');
    layoutStr8.push('    <DataGridColumn dataField="REQ_BIZRNM"  headerText="'+parent.fn_text('req_mfc_bizrnm')+'" width="100" />');
    layoutStr8.push('    <DataGridColumn dataField="CFM_CTNR_NM" headerText="'+parent.fn_text('cfm_ctnr_nm')+'"    width="250" textAlign="left" />');
    layoutStr8.push('    <DataGridColumn dataField="CFM_BIZRNM"  headerText="'+parent.fn_text('cfm_mfc_bizrnm')+'" width="100" />');
    layoutStr8.push('    <DataGridColumn dataField="REQ_QTY"     headerText="'+parent.fn_text('req_exch_qty')+'"   width="130" textAlign="right" formatter="{numfmt}" id="req_exch_qty" />'); //요청교환량
    layoutStr8.push('    <DataGridColumn dataField="CFM_QTY"     headerText="'+parent.fn_text('cfm_exch_qty')+'"   width="130" textAlign="right" formatter="{numfmt}" id="cfm_exch_qty" />'); //확인교호나량
    layoutStr8.push('    <DataGridColumn dataField="RST_QTY"     headerText="'+parent.fn_text('rst_qty')+'"        width="130" textAlign="right" formatter="{numfmt}" id="rst_qty"/>');                                                        //보정수량
    layoutStr8.push('    <DataGridColumn dataField="ADJ_QTY"     headerText="'+parent.fn_text('revi_qty')+'"       width="130" textAlign="right" formatter="{numfmt}" id="revi_qty"/>');                                                        //보정수량
    layoutStr8.push('    <DataGridColumn dataField="ADJ_GTN"     headerText="'+parent.fn_text('adj_dps')+'"        width="130" textAlign="right" id="adj_dps"/>');                            //조정보증금
    layoutStr8.push('    <DataGridColumn dataField="ADJ_RST_QTY" headerText="'+parent.fn_text('adj_rst_qty')+'"    width="130" textAlign="right" formatter="{numfmt}" id="adj_rst_qty"/>');    //조정결과수량
    layoutStr8.push('    <DataGridColumn dataField="ADJ_PROC_STAT_NM" headerText="'+parent.fn_text('stat')+'"           width="70" id="tmp1"/>');
    layoutStr8.push('</groupedColumns>');
    layoutStr8.push('    <footers>');
    layoutStr8.push('        <DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
    layoutStr8.push('            <DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
    layoutStr8.push('            <DataGridFooterColumn/>');
    layoutStr8.push('            <DataGridFooterColumn/>');
    layoutStr8.push('            <DataGridFooterColumn/>');
    layoutStr8.push('            <DataGridFooterColumn summaryOperation="SUM" dataColumn="{req_exch_qty}" formatter="{numfmt}" textAlign="right" />');
    layoutStr8.push('            <DataGridFooterColumn summaryOperation="SUM" dataColumn="{cfm_exch_qty}" formatter="{numfmt}" textAlign="right" />');
    layoutStr8.push('            <DataGridFooterColumn summaryOperation="SUM" dataColumn="{rst_qty}"      formatter="{numfmt}" textAlign="right" />');
    layoutStr8.push('            <DataGridFooterColumn summaryOperation="SUM" dataColumn="{revi_qty}"     formatter="{numfmt}" textAlign="right" />');
    layoutStr8.push('            <DataGridFooterColumn summaryOperation="SUM" dataColumn="{adj_dps}"      formatter="{numfmt}" textAlign="right" />');        
    layoutStr8.push('            <DataGridFooterColumn summaryOperation="SUM" dataColumn="{adj_rst_qty}"  formatter="{numfmt}" textAlign="right" />');
    layoutStr8.push('            <DataGridFooterColumn id="tmp1"/>');
    layoutStr8.push('        </DataGridFooter>');
    layoutStr8.push('    </footers>');
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
        gridApp8.setData();
    }

    var dataCompleteHandler = function(event) {}

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
    layoutStr9.push('<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
    layoutStr9.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg7" editable="true" doubleClickEnabled="true" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true"  textAlign="center" draggableColumns="true" sortableColumns="true" itemEditBeginningJsFunction="fnItemEditBeginning"> ');
    layoutStr9.push('<columns>');
    layoutStr9.push('    <DataGridSelectorColumn id="selector" textAlign="center" allowMultipleSelection="true" width="50" verticalAlign="middle" />');
    layoutStr9.push('    <DataGridColumn dataField="ETC_CD_NM"  headerText="'+parent.fn_text('se')+'" width="150"/>');
    layoutStr9.push('    <DataGridColumn dataField="PAY_PLAN_AMT"  headerText="'+parent.fn_text('pay_plan_amt')+'" width="150" formatter="{numfmt}" textAlign="right" editable="false"/>');
    layoutStr9.push('    <DataGridColumn dataField="PAY_MDT_AMT"  headerText="'+parent.fn_text('pay_amt_adj')+'" width="180" formatter="{numfmt}" textAlign="right" maxChars="15" type="int"/>');
    layoutStr9.push('    <DataGridColumn dataField="ACP_PLAN_AMT"  headerText="'+parent.fn_text('acp_plan_amt')+'" width="150" formatter="{numfmt}" textAlign="right" editable="false"/>');
    layoutStr9.push('</columns>');
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
        selectorColumn9 = gridRoot9.getObjectById("selector");
        dataGrid9.addEventListener("change", selectionChangeHandler);
        gridApp9.setData();

        //파라미터 call back function 실행
        if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
        	/* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
		 	 window[INQ_PARAMS.FN_CALLBACK]();
		 	//취약점점검 5931 기원우

        }
    }

    var selectionChangeHandler = function(event) {
         rowIndex9 = event.rowIndex;
    }

    var dataCompleteHandler = function(event) {

        //체크박스 체크
        var collection = gridRoot9.getCollection();
        var arrIdx = [];

        for(var i=0;i<collection.getLength(); i++){
            arrIdx.push(i);
        }

        selectorColumn9.setSelectedIndices(arrIdx);
    }

    gridRoot9.addEventListener("dataComplete", dataCompleteHandler);
    gridRoot9.addEventListener("layoutComplete", layoutCompleteHandler);
}

/**
 * 그리드 편집 가능여부를 제어
 * false를 반환할 경우 에디팅 불가이며, true를 반환할 경우 에디팅이 가능
 */
function fnItemEditBeginning(rowIndex, columnIndex, item, dataField) {
    if(columnIndex <= 1) return false;
    
    if(item.ETC_CD != "G" && item.ETC_CD != "H") return false;
    
    return true;
}

</script>

<style type="text/css">
    .row .tit{width: 57px;}
</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="mfcBizrList" value="<c:out value='${mfcBizrList}' />"/>

    <div class="iframe_inner">
        <div class="h3group">
            <h3 class="tit" id="title"></h3>
            <div class="singleRow">
                <div class="btn" id="UR"></div>
            </div>
        </div>

        <section class="secwrap">
            <div class="srcharea" id="sel_params">
                <div class="row">
                    <div class="col">
                        <div class="tit" id="exca_term_txt"></div>
                        <div class="box" style="line-height:36px;" id="EXCA_TERM"></div>
                    </div>
                    <div class="col">
                        <div class="tit" id="mfc_bizrnm_txt"></div>
                        <div class="box">
                            <select id="MFC_BIZR_SEL" name="MFC_BIZR_SEL" style="width: 179px" class="i_notnull"></select>
                        </div>
                    </div>
                    <div class="btn" id="CR"></div>
                </div>
            </div>
        </section>

        <section class="secwrap mt10">
            <div class="h4group">
                <h4 class="tit"  id='bal_cnd_txt'></h4>
            </div>
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
                                        <div class="txtbox" id="PLAN_GTN_BAL" style="float:none;">&nbsp;</div>
                                    </div>
                                </td>
                                <th><span class="tit" id="adit_gtn_bal_txt"></span></th>
                                <td>
                                    <div class="row" style="text-align:right;">
                                        <div class="txtbox" id="ADIT_GTN_BAL" style="float:none;">&nbsp;</div>
                                    </div>
                                </td>
                                <th><span class="tit" id="drct_rtrvl_non_bal_txt"></span></th>
                                <td>
                                    <div class="row" style="text-align:right;">
                                        <div class="txtbox" id="DRCT_PAY_GTN_BAL" style="float:none;">&nbsp;</div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
        </section>

        <section class="secwrap mt10">
            <div class="h4group">
                <h4 class="tit"  id='dlivy_crct_txt'></h4> <!-- 출고정정 -->
            </div>
            <div class="boxarea">
                <div id="gridHolder" style="height:200px;"></div>
            </div>
        </section>
        <section class="secwrap mt10">
            <div class="h4group">
                <h4 class="tit"  id='wrhs_crct_txt'></h4> <!-- 입고정정 -->
            </div>
            <div class="boxarea">
                <div id="gridHolder2" style="height:300px;"></div>
            </div>
        </section>
        <section class="secwrap mt10">
            <div class="h4group">
                <h4 class="tit"  id='drct_rtrvl_crct_txt'></h4> <!-- 직접회수정정 -->
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
        <section class="secwrap mt10">
            <div class="h4group">
                <h4 class="tit"  id='fyer_rt_adj_txt'></h4> <!-- 연간혼비율조정 -->
            </div>
            <div class="boxarea">
                <div id="gridHolder5" style="height:200px;"></div>
            </div>
        </section>
        
        <section class="secwrap mt10">
            <div class="h4group">
                <h4 class="tit"  id='fyer_dlivy_qty_adj_txt'></h4> <!-- 연간출고량조정 -->
            </div>
            <div class="boxarea">
                <div id="gridHolder6" style="height:200px;"></div>
            </div>
        </section>

        <section class="secwrap mt10">
            <div class="h4group">
                <h4 class="tit"  id='fyer_rtn_qty_adj_txt'></h4> <!-- 연간입고량조정 -->
            </div>
            <div class="boxarea">
                <div id="gridHolder7" style="height:200px;"></div>
            </div>
        </section>

        <section class="secwrap mt10">
            <div class="h4group">
                <h4 class="tit"  id='fyer_exch_qty_adj_txt'></h4> <!-- 연간교환량조정 -->
            </div>
            <div class="boxarea">
                <div id="gridHolder8" style="height:200px;"></div>
            </div>
        </section>

        <section class="secwrap mt10">
            <div class="h4group">
                <h4 class="tit"  id='exca_set_txt'></h4> <!-- 정산설정 -->
            </div>
            <div class="boxarea" style="width:700px">
                <div id="gridHolder9" style="height:230px;"></div>
            </div>
        </section>

        <section class="secwrap mt10">
            <div class="h4group" >
                <h5 class="tit" id='tmp_txt' style="font-size: 16px;">
                    <span class="table_tit">취급수수료정보 </span>
                    <span style="padding-left:20px">환급예정금액 : <span id="repayAmt"></span></span>
                    <span style="padding-left:20px">납부예정금액 : <span id="payAmt"></span></span>
                    <input type="hidden" name="REPAY_AMT" id="REPAY_AMT" value="0" />
                    <input type="hidden" name="PAY_AMT" id="PAY_AMT" value="0" />
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
