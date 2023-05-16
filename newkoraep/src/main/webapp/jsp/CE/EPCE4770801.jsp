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
        fn_set_grid2();

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

        var row = new Array();

        var item = {};
        item.ETC_CD = "B"
        row.push(item);
 
        var input = INQ_PARAMS["SEL_PARAMS"];

        INQ_PARAMS["list"] = row;
        INQ_PARAMS["PARAMS"] = input;
        INQ_PARAMS["REPAY_AMT"] = "0";    
        INQ_PARAMS["PAY_AMT"] = "0";    
        INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
        INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE4770801.do";
        kora.common.goPage('/CE/EPCE4770831.do', INQ_PARAMS);
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

        var url = "/CE/EPCE4770801_19.do";

        kora.common.showLoadingBar(dataGrid2, gridRoot2);// 그리드 loading bar on
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

              gridApp2.setData(rtnData.searchList2); //입고정정
              
              //fn_calcFee(rtnData.searchList2);  //취급수수료 부가세 계산

            }
            else {
                alertMsg("error");
            }
            kora.common.hideLoadingBar(dataGrid2, gridRoot2);// 그리드 loading bar off
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
                <h4 class="tit"  id='wrhs_crct_txt'></h4> <!-- 입고정정 -->
            </div>
            <div class="boxarea">
                <div id="gridHolder2" style="height:300px;"></div>
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