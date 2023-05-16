<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>조정수량관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

    var parent_item;
    var std_dps=0;
    $(document).ready(function(){
    
        //버튼 셋팅
        fn_btnSetting('EPCE4707888');
    
        parent_item = window.frames[$("#pagedata").val()].parent_item;
    
        /************************************
         * 취소 버튼 클릭 이벤트
         ***********************************/
        $("#btn_cnl").click(function(){
             $('[layer="close"]').trigger('click');
        });
    
        /************************************
         * 저장 버튼 클릭 이벤트
         ***********************************/
        $("#btn_reg").click(function(){
            fn_reg();
        });
    
        /************************************
         * 삭제 버튼 클릭 이벤트
         ***********************************/
        $("#btn_del").click(function(){
            fn_del_chk();
        });
    
        fn_init(parent_item);    //초기 데이터 셋팅
    
        //div text값
        $('#fyer_qty'  ).text(parent.fn_text('fyer_qty'));   //연간수량
        $('#std_year'  ).text(parent.fn_text('std_year'));   //기준년도
        $('#mfc_bizrnm').text(parent.fn_text('mfc_bizrnm')); //생산자
        $('#ctnr_cd'   ).text(parent.fn_text('ctnr_cd'));    //용기코드
        $('#ctnr_nm'   ).text(parent.fn_text('ctnr_nm'));    //용기명
        $('#dlivy_qty2').text(parent.fn_text('dlivy_qty2')); //출고량
        $('#wrhs_qty'  ).text(parent.fn_text('wrhs_qty'));   //입고량
        $('#adj_se'    ).text(parent.fn_text('adj_se'));     //조정구분
        $('#adj_rt'    ).text(parent.fn_text('adj_rt'));     //조정비율
        $('#revi_qty'  ).text(parent.fn_text('revi_qty'));   //보정수량
    });

    //초기값 셋팅
    function fn_init(data) {
        var input = {};
        var url = "/CE/EPCE4707888_19.do";
        input["CTNR_CD"]  = data.CTNR_CD;    //용기코드
        input["STD_YEAR"] = data.STD_YEAR;   //적용년도
        input["BIZRID"]   = data.MFC_BIZRID; //생산자아이디
        input["BIZRNO"]   = data.MFC_BIZRNO; //생산자사업자번호

        if(parent_item.FYER_CRCT_DOC_NO !=null){
            input["FYER_CRCT_DOC_NO"] = parent_item.FYER_CRCT_DOC_NO; //문서번호
            input["ADJ_SE"]           = parent_item.ADJ_SE;           //조정구분
        }

        ajaxPost(url, input, function(rtnData){

            if(rtnData != null && rtnData != ""){
                $('#title_sub').text(rtnData.titleSub);
                kora.common.setEtcCmBx2(rtnData.inde_se, "", "", $("#RT_INDE_SE"), "ETC_CD", "ETC_CD_NM", "N", "S"); //조정비율
                kora.common.setEtcCmBx2(rtnData.inde_se, "","", $("#QTY_INDE_SE"), "ETC_CD", "ETC_CD_NM", "N" ,'S'); //보정수량
                //데이터 값

                $('#ADJ_SE'    ).text(parent_item.ADJ_SE_NM);  //조정구분
                $('#STD_YEAR'  ).text(parent_item.STD_YEAR);   //기준년도
                $('#MFC_BIZRNM').text(parent_item.MFC_BIZRNM); //생산자
                $('#CTNR_CD'   ).text(parent_item.CTNR_CD);    //용기코드
                $('#CTNR_NM'   ).text(parent_item.CTNR_NM);    //용기명

                if(parent_item.ADJ_SE =='C'){
                    $('#WRHS_QTY').text(parent_item.FYER_QTY);   //입고량
                }
                else if(parent_item.ADJ_SE =='D'){
                    $('#DLIVY_QTY' ).text(parent_item.FYER_QTY); //출고량
                    $("#RT_INDE_SE").prop("disabled",true);      //출고량조정일경우 조정비율 disabled
                    $("#ADJ_RT"    ).prop("disabled",true);
                }
                else if(parent_item.ADJ_SE =='R'){
                    $('#WRHS_QTY'  ).text(parent_item.FYER_QTY); //입고량
                    $("#RT_INDE_SE").prop("disabled",true);      //출고량조정일경우 조정비율 disabled
                    $("#ADJ_RT"    ).prop("disabled",true);
                }

                if(rtnData.updList !=null){
                    var upd = rtnData.updList[0];
                    $("#RT_INDE_SE" ).val(upd.RT_INDE_SE).prop("selected", true);
                    $("#ADJ_RT"     ).val(upd.ADJ_RT);
                    $("#QTY_INDE_SE").val(upd.QTY_INDE_SE).prop("selected", true);
                    $("#ADJ_QTY"    ).val(upd.ADJ_QTY);
                }else{
                    $("#ADJ_RT" ).val('0.0000');
                    $("#ADJ_QTY").val(0);
                }

                std_dps =rtnData.initList[0].STD_DPS;    //빈용기보증금
            }
            else {
                alertMsg("error");
            }
        });
    }

    //저장
    function fn_reg(){
        var input       = {};
        var url         = "CE/EPCE4707888_21.do"
        var dlivy_qty   = Number($('#DLIVY_QTY').text()); //출고량
        var wrhs_qty    = Number($('#WRHS_QTY').text());  //입고량
        var adj_rt      = Number($("#ADJ_RT").val());     //조정비율
        var adj_qty     = Number($("#ADJ_QTY").val());    //보정수량
        var adj_rt_qty  = 0;                              //조정비율수량
        var adj_gtn     = 0;                              //조정보증금
        var adj_rst_qty = 0;                              //조정 결과수량
        adj_rt = adj_rt.toFixed(4);

        if(parent_item.ADJ_SE =="D"){                     //출고량조정 (연간출고량)
            if(adj_qty=="0.0000"){
                alertMsg("보정수량을 입력해주세요");
                return;
            }
            else if(adj_qty.length>13){
                alertMsg("13자리 이상은 등록 할수 없습니다.");
                return;
            }
            else if(adj_qty>dlivy_qty){
                alertMsg("출고량 보다 높게 입력할수 없습니다.");
                return;
            }

            adj_gtn = std_dps*adj_qty                     //조정보증금

            if($("#QTY_INDE_SE").val() =="I"){            //보정수량  I 증감 ,D 차감
                adj_rst_qty =dlivy_qty +  adj_qty;        //조정 결과수량 =출고량 +조정수량
            }
            else if($("#QTY_INDE_SE").val() =="D"){
                adj_rst_qty =dlivy_qty -  adj_qty;        //조정 결과수량 =출고량 -조정수량
            }
            else{
                alertMsg("보정수량을 입력하려면\n증가(+)나 차감(-)은 필수 선택입니다.");
                return;
            }
        }
        else if( parent_item.ADJ_SE =="C"){               //혼비율조정 (연간입고량)
            if(adj_rt=="0"){
                alertMsg("조정비율을 입력해주세요");
                return;
            }
            else if(Math.floor(adj_rt)=="100" ){
                alertMsg("100%이상은 등록 할수없습니다.");
                return;
            }

            adj_rt_qty = wrhs_qty / 100*adj_rt;  //조정비율수량 =입고량/100*조정비율
            adj_rt_qty = Math.floor(adj_rt_qty); //조정비율수량 소수점 버림
            adj_gtn    = std_dps*adj_rt_qty;     //조정보증금

            if($("#RT_INDE_SE").val() =="I"){      //조정비율 I 증감 ,D 차감
                adj_rst_qty = wrhs_qty+adj_rt_qty; //조정 결과수량 =입고량 + 조정비율수량
            }
            else if($("#RT_INDE_SE").val() =="D"){
                adj_rst_qty = wrhs_qty-adj_rt_qty; //조정 결과수량 =입고량 - 조정비율수량
            }
            else{
                alertMsg("조정비율을 입력하려면\n증가(+)나 차감(-)은 필수 선택입니다.");
                return;
            }

            if($("#QTY_INDE_SE").val() =="I"){    //보정수량  I 증감 ,D 차감
                if(adj_qty =='0'){
                    alertMsg("보정수량을 입력해주세요");
                    return;
                }

                adj_rst_qty = adj_rst_qty + adj_qty;        // 조정 결과수량+ 보정수량
                adj_gtn     = adj_gtn+(std_dps*adj_qty);    //조정보증금
            }
            else  if($("#QTY_INDE_SE").val() =="D"){
                if(adj_qty =='0'){
                    alertMsg("보정수량을 입력해주세요");
                    return;
                }

                adj_rst_qty = adj_rst_qty - adj_qty;        // 조정 결과수량- 보정수량
                adj_gtn     = Math.abs(adj_gtn-(std_dps*adj_qty));    //조정보증금 (차감 시 -금액이 나올 수 있어 절대값 처리)

            }
            else{
                if(adj_qty !='0'){
                    alertMsg("보정수량을 입력하려면\n증가(+)나 차감(-)은 필수 선택입니다.");
                    return;
                }
            }
            
            
        }
        else if( parent_item.ADJ_SE =="R"){               //입고량조정
            if(adj_qty == "0.0000"){
                alertMsg("보정수량을 입력해주세요");
                return;
            }
            else if(adj_qty.length > 13){
                alertMsg("13자리 이상은 등록 할수 없습니다.");
                return;
            }
            else if(adj_qty > wrhs_qty){
                alertMsg("입고고량 보다 높게 입력할수 없습니다.");
                return;
            }

            adj_gtn = std_dps*adj_qty                     //조정보증금

            if($("#QTY_INDE_SE").val() =="I"){            //보정수량  I 증감 ,D 차감
                adj_rst_qty =wrhs_qty +  adj_qty;         //조정 결과수량 =입고량 +조정수량
            }
            else if($("#QTY_INDE_SE").val() =="D"){
                adj_rst_qty =wrhs_qty -  adj_qty;         //조정 결과수량 =입고량 -조정수량
            }
            else{
                alertMsg("보정수량을 입력하려면\n증가(+)나 차감(-)은 필수 선택입니다.");
                return;
            }
            
        }

        if(parent_item.FYER_CRCT_DOC_NO !=null){
            input["FYER_CRCT_DOC_NO"] =parent_item.FYER_CRCT_DOC_NO;//문서번호
        }

        input["ADJ_SE"]        = parent_item.ADJ_SE;      //조정구분
        input["CTNR_CD"]       = parent_item.CTNR_CD;     //용기코드
        input["BIZRID"]        = parent_item.MFC_BIZRID;  //사업자ID
        input["BIZRNO"]        = parent_item.MFC_BIZRNO;  //사업자등록번호
        input["STD_YEAR"]      = parent_item.STD_YEAR;    //기준년도
        input["ADJ_PROC_STAT"] = "R";                     //조정처리상태
        input["FYER_QTY"]      = parent_item.FYER_QTY;    //연간수량
        input["RT_INDE_SE"]    = $("#RT_INDE_SE").val();  //비율증감구분
        input["ADJ_RT"]        = adj_rt;                  //조정비율
        input["ADJ_RT_QTY"]    = adj_rt_qty;              //조정비율수량
        input["QTY_INDE_SE"]   = $("#QTY_INDE_SE").val(); //수량증감구분
        input["ADJ_QTY"]       = adj_qty                  //조정수량
        input["ADJ_GTN"]       = adj_gtn                  //조정보증금
        input["ADJ_RST_QTY"]   = adj_rst_qty              //조정결과수량

        ajaxPost(url, input, function(rtnData){
            if(rtnData.RSLT_CD == "0000"){
                alertMsg(rtnData.RSLT_MSG);
                window.frames[$("#pagedata").val()].fn_sel();
                $('[layer="close"]').trigger('click');
            }
            else{
                alertMsg(rtnData.RSLT_MSG);
            }
        });
    }

    //삭제전 데이터 검색
    function fn_del_chk(){
        var input ={};
        var url ="CE/EPCE4707888_192.do"
        input["FYER_CRCT_DOC_NO"] = parent_item.FYER_CRCT_DOC_NO; //문서번호
        input["ADJ_SE"]           = parent_item.ADJ_SE;           //조정구분
        input["CTNR_CD"]          = parent_item.CTNR_CD;          //용기코드

        ajaxPost(url, input, function(rtnData){
            if(rtnData.rstCnt>0){
                confirm("등록된 연간조정 정보가 삭제됩니다. \n\n삭제된 연간조정 정보는 복원이 불가능합니다. 계속 진행하시겠습니까?" ,"fn_del")
            }
            else{
                alertMsg("삭제 대상 연간조정 정보가 없습니다");
                return;
            }
        },false);
    }

    //삭제
    function fn_del() {
        var input ={};
        var url ="CE/EPCE4707888_04.do"
        input["FYER_CRCT_DOC_NO"] = parent_item.FYER_CRCT_DOC_NO; //문서번호
        input["ADJ_SE"]           = parent_item.ADJ_SE;           //조정구분
        input["CTNR_CD"]          = parent_item.CTNR_CD;          //용기코드

        ajaxPost(url, input, function(rtnData){
            if(rtnData.RSLT_CD == "0000"){
                alertMsg(rtnData.RSLT_MSG);
                window.frames[$("#pagedata").val()].fn_sel();
                $('[layer="close"]').trigger('click');
            }
            else{
                alertMsg(rtnData.RSLT_MSG);
            }
        });
    }
</script>
<style type="text/css">
.srcharea .row .col .tit{
width: 80px;
}
#RT_INDE_SE ,#QTY_INDE_SE,#ADJ_SE{
width: 150px
}

#ADJ_RT ,#ADJ_QTY{
width: 200px
}
</style>

</head>
<body>
    <div class="layer_popup" style="width:600px; margin-top: -317px" >
        <div class="layer_head">
            <h1 class="layer_title" id="title_sub"></h1>
            <button type="button" class="layer_close" layer="close"  >팝업닫기</button>
        </div>
        <div class="layer_body">
            <div class="h4group" >
                <h5 class="tit"  style="font-size: 16px;" id="fyer_qty"></h5><!-- 연간수량 -->
            </div>
            <section class="secwrap">
                <div class="write_area">
                    <div class="write_tbl">
                        <table>
                            <colgroup>
                            <col style="width: 20%;">
                            <col style="width: 20%;">
                            <col style="width: 20%;">
                            <col style="width: auto;">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th class="bd_l" id="std_year"></th> <!-- 기준년도 -->
                                    <td>
                                        <div class="row">
                                            <div class="txtbox" id="STD_YEAR"></div>
                                        </div>
                                    </td>
                                    <th class="bd_l"  id="mfc_bizrnm"></th>            <!--생산자 -->
                                    <td>
                                        <div class="row">
                                            <div class="txtbox" id="MFC_BIZRNM"></div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="bd_l" id="ctnr_cd"></th> <!-- 용기코드 -->
                                    <td>
                                        <div class="row">
                                            <div class="txtbox" id="CTNR_CD"></div>
                                        </div>
                                    </td>
                                    <th class="bd_l"  id="ctnr_nm"></th>            <!-- 빈용기명 -->
                                    <td>
                                        <div class="row">
                                            <div class="txtbox" id="CTNR_NM"></div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="bd_l" id="dlivy_qty2"></th> <!-- 출고량 -->
                                    <td>
                                        <div class="row">
                                            <div class="txtbox" id="DLIVY_QTY"></div>
                                        </div>
                                    </td>
                                    <th class="bd_l"  id="wrhs_qty"></th>            <!-- 입고량 -->
                                    <td>
                                        <div class="row">
                                            <div class="txtbox" id="WRHS_QTY"></div>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
            <section class="secwrap" style="margin-top:20px;">
                <div class="srcharea"  id="divInput" >
                    <div class="row">
                        <div class="col">
                            <div class="tit" id="adj_se"></div>  <!--조정구분-->
                            <div class="boxView" id="ADJ_SE" ></div>
                        </div>
                    </div> <!-- end of row -->
                    <div class="row">
                        <div class="col">
                            <div class="tit" id="adj_rt"></div>  <!--조정비율-->
                            <div class="box">
                                <select id="RT_INDE_SE" class="i_notnull"></select>
                                <input type="text"  id="ADJ_RT"  class="i_notnull">
                            </div>
                        </div>
                    </div> <!-- end of row -->
                    <div class="row">
                        <div class="col">
                            <div class="tit" id="revi_qty"></div>  <!--보정수량-->
                            <div class="box">
                                <select id="QTY_INDE_SE"  class="i_notnull"></select>
                                <input type="text"    id="ADJ_QTY"  maxlength="13" format="number"  class="i_notnull">
                            </div>
                        </div>
                    </div> <!-- end of row -->
                </div>
            </section>
            <section class="btnwrap mt20"  >
                <div class="btn" style="float:right" id="BR"></div>
            </section>
            <input type="hidden" name ="pagedata"  id="pagedata"/>
        </div>
    </div>
</body>
</html>