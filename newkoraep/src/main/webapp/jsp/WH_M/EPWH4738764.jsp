<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>입고정정 내역조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=1100, user-scalable=yes">

<%@include file="/jsp/include/common_page_m.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

    var INQ_PARAMS;    //파라미터 데이터
    var iniList;       //상세조회 반환내역서 공급 부분
    var cfm_gridList;  //입고 그리드 데이터
    var crct_gridList; //입고정정 그리드 데이터

    $(function() {
         
        INQ_PARAMS    =  jsonObject($("#INQ_PARAMS").val());    
        iniList       =  jsonObject($("#iniList").val());
        cfm_gridList  =  jsonObject($("#cfm_gridList").val());
        crct_gridList =  jsonObject($("#crct_gridList").val());       

        //text 셋팅
        $('#wrhs_crct_doc_no').text(fn_text('wrhs_crct_doc_no')); //입고정정문서번호 
        $('#wrhs_doc_no'     ).text(fn_text('wrhs_doc_no'));      //입고문서번호
        $('#wrhs_crct_reg_dt').text(fn_text('wrhs_crct_reg_dt')); //입고정정등록일자  
        $('#wrhs_cfm_dt'     ).text(fn_text('wrhs_cfm_dt'));      //입고확인일자
        $('#supplier'        ).text(fn_text('supplier'));         //공급자
        $('#receiver'        ).text(fn_text('receiver'));         //공급받는자
        $('#car_no'          ).text(fn_text('car_no'));           //차량번호
        $('#wrhs_crct_data'  ).text(fn_text('wrhs_crct_data'));   //입고정정내역
        $('#wrhs_cfm_data'   ).text(fn_text('wrhs_cfm_data'));    //입고확인내역
        
        /************************************
         * 상호확인 클릭 이벤트
         ***********************************/
        $("#btn_upd").click(function(){
            fn_upd_chk();
        });

        /************************************
         * 목록 클릭 이벤트
         ***********************************/
        $("#btn_page, #btn_lst2").click(function(){
            fn_page();
        });
        
        fn_init();
        
        newriver.tabAction('.tab_area ul', '.tab_cont');
    });
    
    function  fn_init(){
         
        $("#WRHS_CRCT_DOC_NO").text(iniList[0].WRHS_CRCT_DOC_NO);
        $("#WRHS_DOC_NO"     ).text(iniList[0].WRHS_DOC_NO);
        $("#WRHS_CRCT_REG_DT").text(kora.common.formatter.datetime(iniList[0].WRHS_CRCT_REG_DT, "yyyy-mm-dd"));
        $("#WRHS_CFM_DT"     ).text(kora.common.formatter.datetime(iniList[0].WRHS_CFM_DT, "yyyy-mm-dd"));
        $("#MFC_BIZRNM"      ).text(iniList[0].MFC_BIZRNM);
        $("#WHSDL_BIZRNM"    ).text(iniList[0].WHSDL_BIZRNM);
        $("#MFC_BRCH_NM"     ).text(iniList[0].MFC_BRCH_NM);
        $("#CAR_NO"          ).text(iniList[0].CAR_NO);
        
        var fee = 0;
        var stax = 0;
        var cnt = 0;
        var row = '';
        
        //입고확인내역
        $.each(cfm_gridList, function(i, v){
            
            fee = v.CFM_WHSL_FEE + v.CFM_RTL_FEE;
            stax = v.CFM_WHSL_FEE_STAX;
            cnt = i + 1;

            row = '';

            if(i > 0) {
                row += '</br>'; 
            }
            
            row += '<div class="hgroup"><h3 class="tit">' +fn_text('wrhs_cfm_data') + cnt + '</h3></div><div class="tbl">';
            row += '<table>';
            row += '<colgroup><col style="width: 155px;"><col style="width: 60px;"><col style="width: 60px;"><col style="width: 120px;"><col style="width: auto;"></colgroup>';
            row += '<tbody>';
            row += '<tr class="left"><th>'+fn_text('prps_cd')+'</th><td colspan="2">'+v.PRPS_NM+'</td><th>'+fn_text('cpct_cd')+'</th><td>'+v.CPCT_NM+'</td></tr>';
            row += '<tr class="left"><th>'+fn_text('ctnr_nm')+'</th><td colspan="4">'+v.CTNR_NM+'</td></tr>';
            row += '<tr><th colspan="2">'+fn_text('cfm_qty2')+'</th><td colspan="3">'+kora.common.format_comma(v.CFM_QTY)+'</td></tr>';

            row += '<tr><th colspan="2">'+fn_text('dps2')+'</th><td colspan="3">'+kora.common.format_comma(v.CFM_GTN)+'</td></tr>';
            row += '<tr><th colspan="2">'+fn_text('fee2')+'</th><td colspan="3">'+kora.common.format_comma(fee)+'</td></tr>';
            row += '<tr><th colspan="2">'+fn_text('stax2')+'</th><td colspan="3">'+kora.common.format_comma(stax)+'</td></tr>';
            row += '<tr><th colspan="2">'+fn_text('amt_tot')+'</th><td colspan="3">'+kora.common.format_comma(v.AMT_TOT)+'</td></tr>';
            row += '</tbody>';
            row += '</table>';
            row += '</div>';
            
            $('#cfm_table').append(row);
        });

        //입고정정내역
        $.each(crct_gridList, function(i, v){

            fee = v.CRCT_WHSL_FEE + v.CRCT_RTL_FEE;
            stax = v.CRCT_WHSL_FEE_STAX;
            cnt = i + 1;

            row = '';

            if(i > 0) {
                row += '</br>'; 
            }
            
            row += '<div class="hgroup"><h3 class="tit">' +fn_text('wrhs_crct_data') + cnt + '</h3></div><div class="tbl">';
            row += '<table>';
            row += '<colgroup><col style="width: 155px;"><col style="width: 60px;"><col style="width: 60px;"><col style="width: 120px;"><col style="width: auto;"></colgroup>';
            row += '<tbody>';
            row += '<tr class="left"><th>'+fn_text('prps_cd')+'</th><td colspan="2">'+v.PRPS_NM+'</td><th>'+fn_text('cpct_cd')+'</th><td>'+v.CPCT_NM+'</td></tr>';
            row += '<tr class="left"><th>'+fn_text('ctnr_nm')+'</th><td colspan="4">'+v.CTNR_NM+'</td></tr>';
            row += '<tr><th colspan="2">'+fn_text('cfm_qty2')+'</th><td colspan="3">'+kora.common.format_comma(v.CRCT_QTY)+'</td></tr>';
            row += '<tr><th colspan="2">'+fn_text('dps2')+'</th><td colspan="3">'+kora.common.format_comma(v.CRCT_GTN)+'</td></tr>';
            row += '<tr><th colspan="2">'+fn_text('fee2')+'</th><td colspan="3">'+kora.common.format_comma(fee)+'</td></tr>';
            row += '<tr><th colspan="2">'+fn_text('stax2')+'</th><td colspan="3">'+kora.common.format_comma(stax)+'</td></tr>';
            row += '<tr><th colspan="2">'+fn_text('amt_tot')+'</th><td colspan="3">'+kora.common.format_comma(v.AMT_TOT)+'</td></tr>';
            row += '</tbody>';
            row += '</table>';
            row += '</div>';
            
            $('#crct_table').append(row);
        });
    }
   
    //상호확인 클릭 이벤트
    function fn_upd_chk() {
        //반환등록 ,입고조정 ,입고확인 상태만 가능
        if(iniList[0].WRHS_CRCT_STAT_CD !="R"){     
            alert("올바르지 않은 상태의 내역이 선택 되었습니다.\n\n다시 한 번 확인하시기 바랍니다.");
            return;
        }

        if(!confirm("선택하신 정정등록내역이 모두 상호확인 상태로 변경됩니다.\n\n계속 진행하시겠습니까?")) {
            return;
        }
        
        fn_upd();
    }

    //상호확인
    function fn_upd(){
        var input = {"list": ""};
        var row = new Array();
        var url ="/WH/EPWH4704201_21.do";

        var item = {};
        item = iniList[0];
        item.WRHS_CRCT_STAT_CD ="W"
        row.push(item);
        
        input["list"] = JSON.stringify(row);

        ajaxPost(url, input, function(rtnData){
            alert(rtnData.RSLT_MSG);
        },false);     
    }   
    
    //목록
    function fn_page(){
        kora.common.goPageB('', INQ_PARAMS);
    }
</script>
</head>
<body>
    <div id="wrap">
        <input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
        <input type="hidden" id="iniList" value="<c:out value='${iniList}' />" />
        <input type="hidden" id="cfm_gridList" value="<c:out value='${cfm_gridList}' />" />
        <input type="hidden" id="crct_gridList" value="<c:out value='${crct_gridList}' />" />
    
        <%@include file="/jsp/include/header_m.jsp" %>
        
        <%@include file="/jsp/include/aside_m.jsp" %>

        <div id="container">

            <div id="subvisual">
                <h2 class="tit" id="title"></h2>
                <button class="btn_back" id="btn_lst2"><span class="hide">뒤로가기</span></button>
            </div><!-- id : subvisual -->

            <div id="contents">
                <div class="contbox bdn pb40">
                    <div class="tbl">
                        <table>
                            <colgroup>
                                <col style="width: 207px;">
                                <col style="width: 53px;">
                                <col style="width: auto;">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th colspan="2"><span id="wrhs_crct_doc_no"></span></th>
                                    <td><span id="WRHS_CRCT_DOC_NO"></span></td>
                                </tr>
                                <tr>
                                    <th colspan="2"><span id="wrhs_doc_no"></span></th>
                                    <td><span id="WRHS_DOC_NO"></span></td>
                                </tr>
                                <tr>
                                    <th colspan="2"><span id="wrhs_crct_reg_dt"></span></th>
                                    <td><span id="WRHS_CRCT_REG_DT"></span></td>
                                </tr>
                                <tr>
                                    <th colspan="2"><span id="wrhs_cfm_dt"></span></th>
                                    <td><span id="WRHS_CFM_DT"></span></td>
                                </tr>
                                <tr>
                                    <th><span id="supplier"></span></th>
                                    <td colspan="2"><span id="MFC_BIZRNM"></span></td>
                                </tr>
                                <tr>
                                    <th rowspan="2"><span id="receiver"></span></th>
                                    <td colspan="2"><span id="WHSDL_BIZRNM"></span></td>
                                </tr>
                                <tr>
                                    <td colspan="2"><span id="MFC_BRCH_NM"></span></td>
                                </tr>
                                <tr>
                                    <th><span id="car_no"></span></th>
                                    <td colspan="2"><span id="CAR_NO"></span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="contbox bdn pt30 pb50">
                    <div class="tab_area">
                        <ul>
                            <li class="on"><button type="button"><span id="wrhs_cfm_data"></span></button></li>
                            <li><button type="button"><span id="wrhs_crct_data"></span></button></li>
                        </ul>
                    </div>
                    <div class="tab_cont">
                        <div class="tab_box2 on" id="cfm_table">
                        </div>
                        <div class="tab_box2" id="crct_table">
                        </div>
                    </div>
                </div>

                <div class="btn_wrap mt35">
                    <div class="fl_c">
                        <a href="#self" class="btn70 c2" style="width: 220px;" id="btn_upd">상호확인</a>
                        <a href="#self" class="btn70 c1 ml30" style="width: 220px;" id="btn_page">목록</a>
                    </div>
                </div>
            </div><!-- id : contents -->

        </div><!-- id : container -->
        
        <%@include file="/jsp/include/footer_m.jsp" %>

    </div><!-- id : wrap -->
</body>
</html>