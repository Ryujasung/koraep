<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>입고내역서 상세조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=1100, user-scalable=yes">

<%@include file="/jsp/include/common_page_m.jsp" %>
<%@ page import="egovframework.common.util"%>

<%
    String mblYn = util.null2void((String)session.getAttribute("MBL_LOGIN"));
    String display = "Y".equals(mblYn)?"display:none;":"";
%>

<script type="text/javaScript" language="javascript" defer="defer">

    var INQ_PARAMS;//파라미터 데이터
    var iniList;//상세조회 반환내역서 공급 부분
    var rtn_gridList;//그리드 데이터
    var cfm_gridList;//그리드 데이터

     $(function() {
        INQ_PARAMS   = jsonObject($("#INQ_PARAMS").val());
        iniList      = jsonObject($("#iniList").val());
        rtn_gridList = jsonObject($("#rtn_gridList").val());
        cfm_gridList = jsonObject($("#cfm_gridList").val());

        //버튼 셋팅
        //fn_btnSetting();

        $('#rtn_doc_no'   ).text(fn_text('rtn_doc_no'));    //반환문서번호
        $('#wrhs_doc_no'  ).text(fn_text('wrhs_doc_no'));   //입고문서번호
        $('#wrhs_cfm_dt'  ).text(fn_text('wrhs_cfm_dt'));   //입고확인일자
        $('#supplier'     ).text(fn_text('supplier'));      //공급자      
        $('#receiver'     ).text(fn_text('receiver'));      //공급받는자  
        $('#mfc_brch_nm'  ).text(fn_text('mfc_brch_nm'));   //직매장/공장 
        $('#car_no'       ).text(fn_text('car_no'));        //차량번호
        $('#rtn_data'     ).text(fn_text('rtn_data'));      //반환내역
        $('#wrhs_cfm_data').text(fn_text('wrhs_cfm_data')); //입고확인내역
        

        /************************************
        * 조정확인 버튼 클릭 이벤트
        ***********************************/
        $("#btn_reg").click(function(){
            fn_reg_chk();
        });

        /************************************
        * 목록 클릭 이벤트
        ***********************************/
        $("#btn_page, #btn_lst2").click(function(){
            fn_page();
        });
        
        /************************************
         * 인쇄 클릭 이벤트
         ***********************************/
        $("#btn_pnt").click(function(){
            kora.common.gfn_viewReport('prtForm', "<%=mblYn%>");
        });
        
        fn_init();
        
        newriver.tabAction('.tab_area ul', '.tab_cont');
    });
    
    function  fn_init(){
    	
    	//상세
        $("#RTN_DOC_NO"  ).text(iniList[0].RTN_DOC_NO);
        $("#WRHS_DOC_NO" ).text(iniList[0].WRHS_DOC_NO);
    	$("#WRHS_CFM_DT" ).text(kora.common.formatter.datetime(iniList[0].WRHS_CFM_DT, "yyyy-mm-dd"));    //입고확인일자
        $("#MFC_BIZRNM"  ).text(iniList[0].WHSDL_BIZRNM);     //공급자
        $("#WHSDL_BIZRNM").text(iniList[0].MFC_BIZRNM);   //공급받는자
        $("#MFC_BRCH_NM" ).text(iniList[0].MFC_BRCH_NM);    //직매장/공장
        $("#CAR_NO"      ).text(iniList[0].CAR_NO);         //차량번호
        
        var fee = 0;
        var stax = 0;
        var cnt = 0;
        var row = '';

        console.log("3");
        //반환내역
        $.each(rtn_gridList, function(i, v){
        	
        	fee = v.RTN_WHSL_FEE + v.RTN_RTL_FEE;
        	stax = v.RTN_WHSL_FEE_STAX;
        	cnt = i + 1;

            row = '';

        	if(i > 0) {
        		row += '</br>'; 
        	}
        	
            row += '<div class="hgroup"><h3 class="tit">' +fn_text('rtn_data') + cnt + '</h3></div><div class="tbl">';
        	row += '<table>';
        	row += '<colgroup><col style="width: 155px;"><col style="width: 60px;"><col style="width: 60px;"><col style="width: 120px;"><col style="width: auto;"></colgroup>';
        	row += '<tbody>';
        	row += '<tr class="left"><th>'+fn_text('prps_cd')+'</th><td colspan="2">'+v.PRPS_CD+'</td><th>'+fn_text('cpct_cd')+'</th><td>'+v.CPCT_NM+'</td></tr>';
        	row += '<tr class="left"><th>'+fn_text('ctnr_nm')+'</th><td colspan="4">'+v.CTNR_NM+'</td></tr>';
        	row += '<tr class="left"><th>'+fn_text('box_qty')+'</th><td colspan="2">'+kora.common.format_comma(v.BOX_QTY)+'</td><th>'+kora.common.format_comma(fn_text('btl'))+'</th><td>'+v.RTN_QTY+'</td></tr>';
        	row += '<tr><td colspan="5"><div class="tit">'+fn_text('prf_file2')+'</div></td></tr>';
        	row += '<tr><th colspan="2">'+fn_text('dps2')+'</th><td colspan="3">'+kora.common.format_comma(v.RTN_GTN)+'</td></tr>';
        	row += '<tr><th colspan="2">'+fn_text('fee2')+'</th><td colspan="3">'+kora.common.format_comma(fee)+'</td></tr>';
        	row += '<tr><th colspan="2">'+fn_text('stax2')+'</th><td colspan="3">'+kora.common.format_comma(stax)+'</td></tr>';
        	row += '<tr><th colspan="2">'+fn_text('amt_tot')+'</th><td colspan="3">'+kora.common.format_comma(v.AMT_TOT)+'</td></tr>';
        	row += '</tbody>';
        	row += '</table>';
        	row += '</div>';
            
            $('#rtn_table').append(row);
        });

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
            row += '<colgroup><col style="width: 167px;"><col style="width: 48px;"><col style="width: 88px;"><col style="width: 93px;"><col style="width: 73px;"><col style="width: 74px;"><col style="width: 19px;"><col style="width: auto;"></colgroup>';
            row += '<tbody>';
            row += '<tr class="left"><th>'+fn_text('prps_cd')+'</th><td colspan="2">'+v.PRPS_NM+'</td><th>'+fn_text('cpct_cd')+'</th><td colspan="4">'+v.CPCT_NM+'</td></tr>';
            row += '<tr class="left"><th>'+fn_text('ctnr_nm')+'</th><td colspan="7">'+v.CTNR_NM+'</td></tr>';
            row += '<tr class="left"><th>'+fn_text('rtn_qty')+'</th><td colspan="2">'+kora.common.format_comma(v.RTN_QTY)+'</td><th>'+fn_text('dmgb')+'</th><td>'+kora.common.format_comma(v.DMGB_QTY)+'</td><th colspan="2">'+fn_text('vrsb')+'</th><td>'+kora.common.format_comma(v.VRSB_QTY)+'</td></tr>';
            row += '<tr><th colspan="2">'+fn_text('cfm_qty2')+'</th><td colspan="6">'+kora.common.format_comma(v.CFM_QTY)+'</td></tr>';
            row += '<tr><td colspan="8"><div class="tit">'+fn_text('prf_file2')+'</div></td></tr>';
            row += '<tr><th colspan="2">'+fn_text('dps2')+'</th><td colspan="6">'+kora.common.format_comma(v.CFM_GTN)+'</td></tr>';
            row += '<tr><th colspan="2">'+fn_text('fee2')+'</th><td colspan="6">'+kora.common.format_comma(fee)+'</td></tr>';
            row += '<tr><th colspan="2">'+fn_text('stax2')+'</th><td colspan="6">'+kora.common.format_comma(stax)+'</td></tr>';
            row += '<tr><th colspan="2">'+fn_text('amt_tot')+'</th><td colspan="6">'+kora.common.format_comma(v.AMT_TOT)+'</td></tr>';
            row += '</tbody>';
            row += '</table>';
            row += '</div>';
            
            $('#wrhs_table').append(row);
        });
        
        //form값 셋팅
        $("#prtForm").find("#RTN_DOC_NO").val(INQ_PARAMS.PARAMS.RTN_DOC_NO);
        $("#prtForm").find("#MFC_BIZRID").val(INQ_PARAMS.PARAMS.MFC_BIZRID);
        $("#prtForm").find("#MFC_BIZRNO").val(INQ_PARAMS.PARAMS.MFC_BIZRNO);
        $("#prtForm").find("#WHSDL_BIZRID").val(INQ_PARAMS.PARAMS.WHSDL_BIZRID);
        $("#prtForm").find("#WHSDL_BIZRNO").val(INQ_PARAMS.PARAMS.WHSDL_BIZRNO);
        $("#prtForm").find("#MFC_BRCH_ID").val(INQ_PARAMS.PARAMS.MFC_BRCH_ID);  
        $("#prtForm").find("#MFC_BRCH_NO").val(INQ_PARAMS.PARAMS.MFC_BRCH_NO);
        $("#prtForm").find("#WRHS_DOC_NO").val(INQ_PARAMS.PARAMS.WRHS_DOC_NO);
    }

    //조정확인
    function fn_reg_chk(){
        var rtn_stat_cd = iniList[0].RTN_STAT_CD;
        
        if(rtn_stat_cd !="WJ" ){
           alert("입고조정 상태의 자료만 조정 확인 처리 가능합니다.\n 다시 한 번 확인하시기 바랍니다");
            return
        }
        
        if(!confirm("조정 내역에 대한 확인 처리를 하시겠습니까?")) {
            return; 
        }
        
        fn_reg();
    }
    
    function fn_reg(){
        var url = "/WH/EPWH2983964_21.do"
        var input ={};
        input["WRHS_DOC_NO"]     = iniList[0].WRHS_DOC_NO;   //입고문서
        input["RTN_DOC_NO"]      = iniList[0].RTN_DOC_NO;        //반환문서
        input["STAT_CHK"]        = "T";      //상태체크 
        input["RTN_STAT_CD_CHK"] = "WJ"  //상태체크 where 절
        input["RTN_STAT_CD"]     = "WC"  //확인상태로 변경
        
        ajaxPost(url, input, function(rtnData){
            if(rtnData != null && rtnData != ""){
                alert(rtnData.RSLT_MSG);
            }
            else {
                alert("error");
            }
        }); 
    }
    
    //목록
    function fn_page(){
        kora.common.goPageB('', INQ_PARAMS);
    }

    var parent_item;
    
    //증빙사진 클릭시
    function link(){
        var idx = dataGrid2.getSelectedIndices();
        parent_item = gridRoot2.getItemAt(idx);
        var pagedata = window.frameElement.name;
        window.parent.NrvPub.AjaxPopup('/WH/EPWH29839883.do', pagedata);
    }
    
    
</script>
</head>
<body>
    <div id="wrap">
        <input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
        <input type="hidden" id="iniList" value="<c:out value='${iniList}' />" />
        <input type="hidden" id="rtn_gridList" value="<c:out value='${rtn_gridList}' />" />
        <input type="hidden" id="cfm_gridList" value="<c:out value='${cfm_gridList}' />" />
    
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
                                <col style="width: auto;">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th><span id="rtn_doc_no"></span></th>
                                    <td><span id="RTN_DOC_NO"></span></td>
                                </tr>
                                <tr>
                                    <th><span id="wrhs_doc_no"></span></th>
                                    <td><span id="WRHS_DOC_NO"></span></td>
                                </tr>
                            
                                <tr>
                                    <th><span id="wrhs_cfm_dt"></span></th>
                                    <td><span id="WRHS_CFM_DT"></span></td>
                                </tr>
                                <tr>
                                    <th><span id="supplier"></span></th>
                                    <td><span id="MFC_BIZRNM"></span></td>
                                </tr>
                                <tr>
                                    <th rowspan="2"><span id="receiver"></span></th>
                                    <td><span id="WHSDL_BIZRNM"></span></td>
                                </tr>
                                <tr>
                                    <td><span id="MFC_BRCH_NM"></span></td>
                                </tr>
                                <tr>
                                    <th><span id="car_no"></span></th>
                                    <td><span id="CAR_NO"></span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="contbox bdn pt30 pb50">
                    <div class="tab_area">
                        <ul>
                            <li class="on"><button type="button"><span id="rtn_data"></span></button></li>
                            <li><button type="button"><span id="wrhs_cfm_data"></span></button></li>
                        </ul>
                    </div>
                    <div class="tab_cont">
                        <div class="tab_box2 on" id="rtn_table">
                        </div>
                        <div class="tab_box2" id="wrhs_table">
                        </div>
                    </div>
                </div>
                <div class="btn_wrap mt35">
                    <div class="fl_c">
                        <a href="#self" class="btn70 c2" style="width: 220px;" id="btn_reg">조정확인</a>
                        <a href="#self" class="btn70 c1" style="width: 220px;" id="btn_page">목록</a>
                        <a href="#self" class="btn70 c3" style="width: 120px;  <%=display%>" id="btn_pnt">인쇄</a>
                    </div>
                </div>
            </div><!-- id : contents -->

        </div><!-- id : container -->
        
        <%@include file="/jsp/include/footer_m.jsp" %>

    </div><!-- id : wrap -->
    <!--출력에 쓸 데이터 -->
    <form name="prtForm" id="prtForm">
        <input type="hidden" name="CRF_NAME" value="EPCE2983964.crf" /> <!-- 필수 -->
        <input type="hidden" name="RTN_DOC_NO"   id="RTN_DOC_NO"  />
        <input type="hidden" name="MFC_BIZRID"  id="MFC_BIZRID" />
        <input type="hidden" name="MFC_BIZRNO"  id="MFC_BIZRNO"   />
        <input type="hidden" name="WHSDL_BIZRID" id="WHSDL_BIZRID"    />
        <input type="hidden" name="WHSDL_BIZRNO"  id="WHSDL_BIZRNO" />
        <input type="hidden" name="MFC_BRCH_ID" id="MFC_BRCH_ID"  />
        <input type="hidden" name="MFC_BRCH_NO"   id="MFC_BRCH_NO"  />
        <input type="hidden" name="WRHS_DOC_NO"   id="WRHS_DOC_NO"  />
    </form>
</body>
</html>