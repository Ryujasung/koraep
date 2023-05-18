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
    
    var date = new Date();
    var year = date.getFullYear();
    var selected = "";
    for(i=2016; i<=year; i++){
        if(i == year) selected = "selected";
        $('#EXCA_SE_YEAR').append('<option value="'+i+'" '+selected+'>'+i+'</option>');
    }

    kora.common.setEtcCmBx2(mfcBizrList, "", "", $("#MFC_BIZR_SEL"), "BIZRID_NO", "BIZRNM", "N", "S");

    //파라미터 조회조건으로 셋팅
    if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
        kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
    }

    //그리드 셋팅
    fn_set_grid();

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

    var chkLst = selectorColumn.getSelectedItems();
    if(chkLst.length < 1){
        alertMsg("선택된 내역이 없습니다.");
        return;
    }

    var excaIssuSeCd = "G";
    var row = new Array();
    
    for(var i=0; i<chkLst.length; i++) {
        if(chkLst[i].ETC_CD == "L" || chkLst[i].ETC_CD == "M" ) {
            excaIssuSeCd = "F";
        }
	
	    var item = {};
        
        item["ETC_CD"      ] = chkLst[i].ETC_CD;
        item["ETC_CD_NM"   ] = chkLst[i].ETC_CD_NM;
        item["PAY_PLAN_AMT"] = kora.common.null2void(chkLst[i].PAY_MDT_AMT,"0");
        item["ACP_PLAN_AMT"] = kora.common.null2void(chkLst[i].ACP_PLAN_AMT,"0");
        item["OFF_SET_AMT" ] = Number(chkLst[i].PAY_MDT_AMT) - Number(chkLst[i].ACP_PLAN_AMT);
        
        row.push(item);
    }

    var input = INQ_PARAMS["SEL_PARAMS"];
    input["EXCA_ISSU_SE_CD"] = excaIssuSeCd;

    INQ_PARAMS["list"] = row;
    INQ_PARAMS["PARAMS"] = input;
    INQ_PARAMS["REPAY_AMT"] = 0;    
    INQ_PARAMS["PAY_AMT"] = 0;
    INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
    INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE4793901.do";
    kora.common.goPage('/CE/EPCE4793931.do', INQ_PARAMS);
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
    input["EXCA_SE_YEAR"] = $("#EXCA_SE_YEAR option:selected").val();

    INQ_PARAMS["SEL_PARAMS"] = input;

    var url = "/CE/EPCE4793901_19.do";

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

          gridApp.setData(rtnData.searchList); //정산설정
          
        }
        else {
            alertMsg("error");
        }
        kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
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
    layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg7" editable="true" doubleClickEnabled="false" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true"  textAlign="center"> ');
    layoutStr.push('<columns>');
    layoutStr.push('    <DataGridSelectorColumn id="selector" textAlign="center" allowMultipleSelection="true" width="50" verticalAlign="middle" />');
    layoutStr.push('    <DataGridColumn dataField="ETC_CD_NM"  headerText="'+parent.fn_text('se')+'" width="150"  editable="false"/>');
    layoutStr.push('    <DataGridColumn dataField="PAY_PLAN_AMT"  headerText="'+parent.fn_text('pay_plan_amt')+'" width="150" formatter="{numfmt}" textAlign="right" editable="false"/>');
    layoutStr.push('    <DataGridColumn dataField="PAY_MDT_AMT"  headerText="'+parent.fn_text('pay_amt_adj')+'" width="180" formatter="{numfmt}" textAlign="right" maxChars="15" type="int"/>');
    layoutStr.push('    <DataGridColumn dataField="ACP_PLAN_AMT"  headerText="'+parent.fn_text('acp_plan_amt')+'" width="150" formatter="{numfmt}" textAlign="right" maxChars="15" type="int"/>');
    layoutStr.push('</columns>');
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
        selectorColumn.addEventListener("change", selectorColumnChangeHandler);        
        //dataGrid.addEventListener("change", selectionChangeHandler);
        gridRoot.getObjectById("selector").addEventListener("change", selectionChangeHandler);
        gridApp.setData();

        //파라미터 call back function 실행
        if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
        	/* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
		 	 window[INQ_PARAMS.FN_CALLBACK]();
		 	//취약점점검 5935 기원우
        }
    }

    var selectorColumnChangeHandler = function(event) {
        if (event.rowIndex < 0)
            selectorColumn.setSelectedIndices([]);
    }    

    var selectionChangeHandler = function(event) {
        rowIndex = event.rowIndex;
        
        var dataRow = gridRoot.getItemAt(rowIndex); // 변경된 데이터 레코드
        var collection = gridRoot.getCollection();
        var etcCd = dataRow.ETC_CD;
        var selIdx = selectorColumn.getSelectedIndices();
        var arrIdx = [];
        var sel;
        
        if(etcCd == "L" || etcCd == "M") { //취급수수료
            for(var i=0;i<selIdx.length; i++){
                dataRow = gridRoot.getItemAt(selIdx[i]); // 변경된 데이터 레코드
                sel = dataRow.ETC_CD;

                if(sel == "L" || sel == "M") {
                    arrIdx.push(selIdx[i]);
                    console.log("push");
                }           
            }
        }
        else {
            for(var i=0;i<selIdx.length; i++){
                dataRow = gridRoot.getItemAt(selIdx[i]); // 변경된 데이터 레코드
                sel = dataRow.ETC_CD;

                if(sel != "L" && sel != "M") {
        		    arrIdx.push(selIdx[i]);
        		    console.log("push");
        	    }        	
            }
        }
        
        selectorColumn.setSelectedIndices(arrIdx);    
    }
    
    function itemDataChangeHandler(event) {
        var rowIndex = event.rowIndex;              // 변경된 행번호
        var columnIndex = event.columnIndex;        // 변경된 열번호
        var dataField = event.dataField;            // 변경된 열의 데이터 필드
        var dataRow = gridRoot.getItemAt(rowIndex); // 변경된 데이터 레코드
        var oldValue = event.value;                 // 변경전 값
        var newValue = event.newValue;              // 변경후 값

        if(dataField == "PAY_MDT_AMT") {
            gridRoot.setItemFieldAt(0, rowIndex, "ACP_PLAN_AMT");
        }
        
        if(dataField == "ACP_PLAN_AMT") {
            gridRoot.setItemFieldAt(0, rowIndex, "PAY_MDT_AMT");
        }
        
        console.log("event : " + event.dataField);
	}
    
    gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
    gridRoot.addEventListener("itemDataChanged", itemDataChangeHandler);
}

// 전체 선택을 설정하거나 해제합니다.
function toggleAllItemSelected() {
    return false;
}
</script>

<style type="text/css">
    .row .tit{width: 67px;}
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
                        <div class="tit" id="exca_trgt_year_txt" style="width: 100px;"></div>
                        <div class="box">
                            <select id="EXCA_SE_YEAR" name="EXCA_SE_YEAR" style="width: 179px" >
                            </select>
                        </div>
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
                <h4 class="tit"  id='exca_set_txt'></h4> <!-- 정산설정 -->
            </div>
            <div class="boxarea" style="width:700px">
                <div id="gridHolder" style="height:230px;"></div>
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
