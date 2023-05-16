<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>실태조사표 조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

    var INQ_PARAMS;     //파라미터 데이터
    var rsrc_list;
    var rsrc_se;
    var rsrc_rst;
    var rsrcDocNo;
    var rsrcDocKnd;
    var rsrcRegDt;

    $(function() {
         
        INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
        rsrc_list  = jsonObject($("#rsrc_list").val());
        rsrc_se    = jsonObject($("#rsrc_se").val());
        rsrc_rst   = jsonObject($("#rsrc_rst").val());

        //버튼 셋팅
        fn_btnSetting();

        /************************************
         * 실태조사표 등록 클릭 이벤트
         ***********************************/
        $("#btn_upd").click(function(){
            fn_reg();
        });
        
        /************************************
         * 취소 클릭 이벤트
         ***********************************/
        $("#btn_page").click(function(){
            fn_cnl();
        });
        
        fn_init();
            
    });
     
    function  fn_init(){
        var subTitle = "";
        
        //text 셋팅
        $('#title_sub').text('<c:out value="${titleSub}" />'); //타이틀
        $('#rsrc_doc_no_txt').text(parent.fn_text('rsrc_doc_no')); //실태조사문서번호
        $('#reg_dt2').text(parent.fn_text('reg_dt2')); //등록일자
        $('#mtl').text(parent.fn_text('mtl')); //상호
        $('#tel_no').text(parent.fn_text('tel_no')); //전화번호
        $('#addr').text(parent.fn_text('addr')); //주소
        $('#rpst_name').text(parent.fn_text('rpst_name')); //대표자 성명
        $('#bizrno2').text(parent.fn_text('bizrno2')); //사업자등록번호
        $('#se').text(parent.fn_text('se')); //구분
        $('#cfm_cnts').text(parent.fn_text('cfm_cnts')); //확인내용
        $('#rst').text(parent.fn_text('rst')); //결과
        $('#rmk').text(parent.fn_text('rmk')); //비고
        
        rsrcDocKnd = rsrc_list[0].RSRC_DOC_KND; 
        rsrcDocNo  = rsrc_list[0].RSRC_DOC_NO;
        rsrcRegDt  = rsrc_list[0].RSCR_DOC_REG_DT

        $("#RSRC_DOC_NO"    ).text(rsrcDocNo                   ); //실태조사문서번호
        $("#RSCR_DOC_REG_DT").text(kora.common.formatter.datetime(rsrcRegDt, "yyyy-mm-dd")); //실태조사표등록일자
        $("#BIZRNM"         ).text(rsrc_list[0].BIZRNM         ); //상호
        $("#RPST_TEL_NO"    ).text(rsrc_list[0].RPST_TEL_NO    ); //전화번호
        $("#ADDR"           ).text(rsrc_list[0].ADDR           ); //주소
        $("#RPST_NM"        ).text(rsrc_list[0].RPST_NM        ); //대표자성명
        $("#BIZRNO"         ).text(kora.common.setDelim(rsrc_list[0].BIZRNO, "999-99-99999")); //사업자등록번호
        
        
        if("W" == rsrcDocKnd) {
            $("#m_table").hide();
            $("#w_table").show();

            kora.common.setEtcCmBx2(rsrc_rst, "","", $("#W_CFM_CNTN1_YN"), "ETC_CD", "ETC_CD_NM", "S"); //실태조사 확인사항 결과
            kora.common.setEtcCmBx2(rsrc_rst, "","", $("#W_CFM_CNTN2_YN"), "ETC_CD", "ETC_CD_NM", "S"); //실태조사 확인사항 결과
            kora.common.setEtcCmBx2(rsrc_rst, "","", $("#W_CFM_CNTN3_YN"), "ETC_CD", "ETC_CD_NM", "S"); //실태조사 확인사항 결과
            kora.common.setEtcCmBx2(rsrc_rst, "","", $("#W_CFM_CNTN4_YN"), "ETC_CD", "ETC_CD_NM", "S"); //실태조사 확인사항 결과
            kora.common.setEtcCmBx2(rsrc_rst, "","", $("#W_CFM_CNTN5_YN"), "ETC_CD", "ETC_CD_NM", "S"); //실태조사 확인사항 결과
            kora.common.setEtcCmBx2(rsrc_rst, "","", $("#W_CFM_CNTN6_YN"), "ETC_CD", "ETC_CD_NM", "S"); //실태조사 확인사항 결과
            kora.common.setEtcCmBx2(rsrc_rst, "","", $("#W_CFM_CNTN7_YN"), "ETC_CD", "ETC_CD_NM", "S"); //실태조사 확인사항 결과
            kora.common.setEtcCmBx2(rsrc_rst, "","", $("#W_CFM_CNTN8_YN"), "ETC_CD", "ETC_CD_NM", "S"); //실태조사 확인사항 결과

            //데이터 넣기
            $("#W_CFM_CNTN1_YN").val(rsrc_list[0].CFM_CNTN1_YN).prop("selected", true);
            $("#W_CFM_CNTN2_YN").val(rsrc_list[0].CFM_CNTN2_YN).prop("selected", true);
            $("#W_CFM_CNTN3_YN").val(rsrc_list[0].CFM_CNTN3_YN).prop("selected", true);
            $("#W_CFM_CNTN4_YN").val(rsrc_list[0].CFM_CNTN4_YN).prop("selected", true);
            $("#W_CFM_CNTN5_YN").val(rsrc_list[0].CFM_CNTN5_YN).prop("selected", true);
            $("#W_CFM_CNTN6_YN").val(rsrc_list[0].CFM_CNTN6_YN).prop("selected", true);
            $("#W_CFM_CNTN7_YN").val(rsrc_list[0].CFM_CNTN7_YN).prop("selected", true);
            $("#W_CFM_CNTN8_YN").val(rsrc_list[0].CFM_CNTN8_YN).prop("selected", true);
            
            $("#W_CFM_CNTN1_RMK").text(rsrc_list[0].CFM_CNTN1_RMK);
            $("#W_CFM_CNTN2_RMK").text(rsrc_list[0].CFM_CNTN2_RMK);
            $("#W_CFM_CNTN3_RMK").text(rsrc_list[0].CFM_CNTN3_RMK);
            $("#W_CFM_CNTN4_RMK").text(rsrc_list[0].CFM_CNTN4_RMK);
            $("#W_CFM_CNTN5_RMK").text(rsrc_list[0].CFM_CNTN5_RMK);
            $("#W_CFM_CNTN6_RMK").text(rsrc_list[0].CFM_CNTN6_RMK);
            $("#W_CFM_CNTN7_RMK").text(rsrc_list[0].CFM_CNTN7_RMK);
            $("#W_CFM_CNTN8_RMK").text(rsrc_list[0].CFM_CNTN8_RMK);

            $("#M_CFM_CNTN1_DTL").text(rsrc_list[0].CFM_CNTN1_DTL);
            $("#M_CFM_CNTN2_DTL").text(rsrc_list[0].CFM_CNTN2_DTL);
            $("#M_CFM_CNTN3_DTL").text(rsrc_list[0].CFM_CNTN3_DTL);
            $("#M_CFM_CNTN4_DTL").text(rsrc_list[0].CFM_CNTN4_DTL);
            $("#M_CFM_CNTN5_DTL").text(rsrc_list[0].CFM_CNTN5_DTL);
            $("#M_CFM_CNTN6_DTL").text(rsrc_list[0].CFM_CNTN6_DTL);
            $("#W_SUGGESTIONS"  ).text(rsrc_list[0].SUGGESTIONS);
            $("#W_DFCT_PRBL"    ).text(rsrc_list[0].DFCT_PRBL  );
            }
        else if("M" == rsrcDocKnd) {
            $("#m_table").show();
            $("#w_table").hide();

            kora.common.setEtcCmBx2(rsrc_rst, "","", $("#M_CFM_CNTN1_YN"), "ETC_CD", "ETC_CD_NM", "S"); //실태조사 확인사항 결과
            kora.common.setEtcCmBx2(rsrc_rst, "","", $("#M_CFM_CNTN2_YN"), "ETC_CD", "ETC_CD_NM", "S"); //실태조사 확인사항 결과
            kora.common.setEtcCmBx2(rsrc_rst, "","", $("#M_CFM_CNTN3_YN"), "ETC_CD", "ETC_CD_NM", "S"); //실태조사 확인사항 결과
            kora.common.setEtcCmBx2(rsrc_rst, "","", $("#M_CFM_CNTN4_YN"), "ETC_CD", "ETC_CD_NM", "S"); //실태조사 확인사항 결과
            kora.common.setEtcCmBx2(rsrc_rst, "","", $("#M_CFM_CNTN5_YN"), "ETC_CD", "ETC_CD_NM", "S"); //실태조사 확인사항 결과
            kora.common.setEtcCmBx2(rsrc_rst, "","", $("#M_CFM_CNTN6_YN"), "ETC_CD", "ETC_CD_NM", "S"); //실태조사 확인사항 결과

            //데이터 넣기
            $("#M_CFM_CNTN1_YN").val(rsrc_list[0].CFM_CNTN1_YN);
            $("#M_CFM_CNTN2_YN").val(rsrc_list[0].CFM_CNTN2_YN);
            $("#M_CFM_CNTN3_YN").val(rsrc_list[0].CFM_CNTN3_YN);
            $("#M_CFM_CNTN4_YN").val(rsrc_list[0].CFM_CNTN4_YN);
            $("#M_CFM_CNTN5_YN").val(rsrc_list[0].CFM_CNTN5_YN);
            $("#M_CFM_CNTN6_YN").val(rsrc_list[0].CFM_CNTN6_YN);

            $("#M_CFM_CNTN1_RMK").text(rsrc_list[0].CFM_CNTN1_RMK);
            $("#M_CFM_CNTN2_RMK").text(rsrc_list[0].CFM_CNTN2_RMK);
            $("#M_CFM_CNTN3_RMK").text(rsrc_list[0].CFM_CNTN3_RMK);
            $("#M_CFM_CNTN4_RMK").text(rsrc_list[0].CFM_CNTN4_RMK);
            $("#M_CFM_CNTN5_RMK").text(rsrc_list[0].CFM_CNTN5_RMK);
            $("#M_CFM_CNTN6_RMK").text(rsrc_list[0].CFM_CNTN6_RMK);

            $("#M_SUGGESTIONS"  ).text(rsrc_list[0].SUGGESTIONS);
            $("#M_DFCT_PRBL"    ).text(rsrc_list[0].DFCT_PRBL  );

            $("#M_CFM_CNTN1_DTL").text(rsrc_list[0].CFM_CNTN1_DTL);
            $("#M_CFM_CNTN2_DTL").text(rsrc_list[0].CFM_CNTN2_DTL);
            $("#M_CFM_CNTN3_DTL").text(rsrc_list[0].CFM_CNTN3_DTL);
            $("#M_CFM_CNTN4_DTL").text(rsrc_list[0].CFM_CNTN4_DTL);
            $("#M_CFM_CNTN5_DTL").text(rsrc_list[0].CFM_CNTN5_DTL);
            $("#M_CFM_CNTN6_DTL").text(rsrc_list[0].CFM_CNTN6_DTL);
        }
    }

    //등록
    function fn_reg(){
        
        confirm("실태조사표 등록하시겠습니까?", 'fn_reg_exec');
    }

    function fn_reg_exec(){
        var data = {};
        var row = new Array();
        var url = "/MF/EPMF29164313_21.do"; 

        data["RSRC_DOC_NO"]  = rsrcDocNo;
        data["RSRC_DOC_KND"] = rsrcDocKnd;

        ajaxPost(url, data, function(rtnData){
            if(rtnData != null && rtnData != ""){
                if(rtnData.RSLT_CD =="A021"){
                    alertMsg(rtnData.RSLT_MSG);
                }else if(rtnData.RSLT_CD =="0000"){
                    alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
                }else if(rtnData.RSLT_CD !="0000"){
                    alertMsg(rtnData.ERR_CTNR_NM);
                }
            }else{
                alertMsg("error");
            }
        });//end of ajaxPost
    }
    
    //목록
    function fn_cnl(){
        kora.common.goPageB('', INQ_PARAMS);
    }
</script>

</head>
<body>
    <div class="iframe_inner" id="testee" >
    <input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
    <input type="hidden" id="rsrc_list" value="<c:out value='${rsrc_list}' />" />
    <input type="hidden" id="rsrc_se" value="<c:out value='${rsrc_seList}' />" />
    <input type="hidden" id="rsrc_rst" value="<c:out value='${rsrc_rstList}' />" />
            
    <div class="h3group">
        <h3 class="tit" id="title_sub"></h3>
        <div class="btn" style="float:right" id="UR"><!--인쇄  -->
        </div>
    </div>
    <section class="secwrap pb10">
        <div class="write_area">
            <div class="write_tbl">
                <table>
                    <colgroup>
                        <col style="width: 12%;">
                        <col style="width: 30%;">
                        <col style="width: 12%;">
                        <col style="width: auto;">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th id="rsrc_doc_no_txt"></th><!-- 반환문서 -->
                            <td>
                                <div class="row">
                                    <div class="txtbox" id="RSRC_DOC_NO"></div>
                                </div>
                            </td>
                            <th id="reg_dt2"></th>              <!-- 반환문서 -->
                            <td>
                                <div class="row">
                                    <div class="txtbox" id="RSCR_DOC_REG_DT"></div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th id="mtl"></th> <!-- 상호 -->
                            <td>
                                <div class="row">
                                    <div class="txtbox" id="BIZRNM"></div>
                                </div>
                            </td>
                            <th id="tel_no"></th> <!-- 전화번호 -->
                            <td>
                                <div class="row">
                                    <div class="txtbox" id="RPST_TEL_NO"></div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th id="addr"></th> <!-- 주소 -->
                            <td>
                                <div class="row">
                                    <div class="txtbox" id="ADDR"></div>
                                </div>
                            </td>
                            <th>법인등록번호</th> <!-- 법인등록번호 -->
                            <td>
                                <div class="row">
                                    <div class="txtbox"></div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th id="rpst_name"></th> <!-- 대표자 성명 -->
                            <td>
                                <div class="row">
                                    <div class="txtbox" id="RPST_NM"></div>
                                </div>
                            </td>
                            <th id="bizrno2"></th> <!-- 사업자등록번호호 -->
                            <td>
                                <div class="row">
                                    <div class="txtbox" id="BIZRNO"></div>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>  
    <section class="secwrap">
        <div class="write_area">
            <div class="write_tbl">
                <table>
                    <colgroup>
                        <col style="width: 12%;">
                        <col style="width: 30%;">
                        <col style="width: 12%;">
                        <col style="width: auto;">
                    </colgroup>
                    <tbody>
                        <tr style="height:45px"> 
                            <th class="ta_c" id="se"></th> <!-- 구분 -->
                            <th class="ta_c" id="cfm_cnts"></th><!-- 확인내용 -->
                            <th class="ta_c" id="rst"></th> <!-- 결과 -->
                            <th class="ta_c" id="rmk"></th> <!-- 비고 -->
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="write_tbl" id="w_table">
                <table>
                    <colgroup>
                        <col style="width: 12%;">
                        <col style="width: 30%;">
                        <col style="width: 12%;">
                        <col style="width: auto;">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th rowspan="8">실태조사 확인사항</th>
                            <td>
                                <div class="row">
                                    <div class="txtbox">지급체계에 제출한 증빙자료 유무</div>
                                </div>
                            </td>
                            <td>
                                <div class="row">
                                    <select id="W_CFM_CNTN1_YN" style="width: 80%" class="i_notnull" disabled="disabled"></select> <!-- 결과 -->
                                </div>
                            </td>
                            <td>
                                <div class="row" id="W_CFM_CNTN1_RMK"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="row">
                                    <div class="txtbox">증빙자료와 제출자료의 일치성</div>
                                </div>
                            </td>
                            <td>
                                <div class="row">
                                    <select id="W_CFM_CNTN2_YN" style="width: 80%" class="i_notnull" disabled="disabled" ></select> <!-- 결과 -->
                                </div>
                            </td>
                            <td>
                                <div class="row" id="W_CFM_CNTN2_RMK"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="row">
                                    <div class="txtbox">수수료 적정지급</div>
                                </div>
                            </td>
                            <td>
                                <div class="row">
                                    <select id="W_CFM_CNTN3_YN" style="width: 80%" class="i_notnull" disabled="disabled" ></select> <!-- 결과 -->
                                </div>
                            </td>
                            <td>
                                <div class="row" id="W_CFM_CNTN3_RMK"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="row">
                                    <div class="txtbox">보증금 적정지급</div>
                                </div>
                            </td>
                            <td>
                                <div class="row">
                                    <select id="W_CFM_CNTN4_YN" style="width: 80%" class="i_notnull" disabled="disabled" ></select> <!-- 결과 -->
                                </div>
                            </td>
                            <td>
                                <div class="row" id="W_CFM_CNTN4_RMK"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="row">
                                    <div class="txtbox">회사별, 용량별, 용도별, 종류별 분류여부</div>
                                </div>
                            </td>
                            <td>
                                <div class="row">
                                    <select id="W_CFM_CNTN5_YN" style="width: 80%" class="i_notnull" disabled="disabled" ></select> <!-- 결과 -->
                                </div>
                            </td>
                            <td>
                                <div class="row" id="W_CFM_CNTN5_RMK"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="row">
                                    <div class="txtbox">빈용기 훼손방지를 위한 노력</div>
                                </div>
                            </td>
                            <td>
                                <div class="row">
                                    <select id="W_CFM_CNTN6_YN" style="width: 80%" class="i_notnull" disabled="disabled" ></select> <!-- 결과 -->
                                </div>
                            </td>
                            <td>
                                <div class="row" id="W_CFM_CNTN6_RMK"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="row">
                                    <div class="txtbox">반환되는 빈용기의 확인 여부</div>
                                </div>
                            </td>
                            <td>
                                <div class="row">
                                    <select id="W_CFM_CNTN7_YN" style="width: 80%" class="i_notnull" disabled="disabled" ></select> <!-- 결과 -->
                                </div>
                            </td>
                            <td>
                                <div class="row" id="W_CFM_CNTN7_RMK"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="row">
                                    <div class="txtbox">기타사항</div>
                                </div>
                            </td>
                            <td>
                                <div class="row">
                                    <select id="W_CFM_CNTN8_YN" style="width: 80%" class="i_notnull" disabled="disabled" ></select> <!-- 결과 -->
                                </div>
                            </td>
                            <td>
                                <div class="row" id="W_CFM_CNTN8_RMK" ></div>
                            </td>
                        </tr>
                        <tr>
                            <th>건의사항</th>
                            <td colspan="3">
                                <div class="row" id="W_SUGGESTIONS"></div>
                            </td>
                        </tr>
                        <tr>
                            <th>애로사항</th>
                            <td colspan="3">
                                <div class="row" id="W_DFCT_PRBL" ></div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="write_tbl" id="m_table">
                <table>
                    <colgroup>
                        <col style="width: 12%;">
                        <col style="width: 30%;">
                        <col style="width: 12%;">
                        <col style="width: auto;">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th rowspan="6">실태조사 확인사항</th>
                            <td>
                                <div class="row">
                                    <div class="txtbox">보증금 및 수수료 적정 납부여부</div>
                                </div>
                            </td>
                            <td>
                                <div class="row">
                                    <select id="M_CFM_CNTN1_YN" style="width: 80%" class="i_notnull" disabled="disabled" ></select> <!-- 결과 -->
                                </div>
                            </td>
                            <td>
                                <div class="row" id="M_CFM_CNTN1_RMK"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="row">
                                    <div class="txtbox">플라스틱박스를 통한 제품판매 및 빈용기 회수 여부</div>
                                </div>
                            </td>
                            <td>
                                <div class="row">
                                    <select id="M_CFM_CNTN2_YN" style="width: 80%" class="i_notnull" disabled="disabled" ></select> <!-- 결과 -->
                                </div>
                            </td>
                            <td>
                                <div class="row" id="M_CFM_CNTN2_RMK"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="row">
                                    <div class="txtbox">환불문구 및 재사용 표시 적정 여부</div>
                                </div>
                            </td>
                            <td>
                                <div class="row">
                                    <select id="M_CFM_CNTN3_YN" style="width: 80%" class="i_notnull" disabled="disabled" ></select> <!-- 결과 -->
                                </div>
                            </td>
                            <td>
                                <div class="row" id="M_CFM_CNTN3_RMK"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="row">
                                    <div class="txtbox">반환되는 빈용기의 확인 여부</div>
                                </div>
                            </td>
                            <td>
                                <div class="row">
                                    <select id="M_CFM_CNTN4_YN" style="width: 80%" class="i_notnull" disabled="disabled" ></select> <!-- 결과 -->
                                </div>
                            </td>
                            <td>
                                <div class="row" id="M_CFM_CNTN4_R"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="row">
                                    <div class="txtbox">타사병 상호 교환 여부</div>
                                </div>
                            </td>
                            <td>
                                <div class="row">
                                    <select id="M_CFM_CNTN5_YN" style="width: 80%" class="i_notnull" disabled="disabled" ></select> <!-- 결과 -->
                                </div>
                            </td>
                            <td>
                                <div class="row" id="M_CFM_CNTN5_RMK"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="row">
                                    <div class="txtbox">기타사항</div>
                                </div>
                            </td>
                            <td>
                                <div class="row">
                                    <select id="M_CFM_CNTN6_YN" style="width: 80%" class="i_notnull" disabled="disabled" ></select> <!-- 결과 -->
                                </div>
                            </td>
                            <td>
                                <div class="row" id="M_CFM_CNTN6_RMK"></div>
                            </td>
                        </tr>
                        <tr>
                            <th>건의사항</th>
                            <td colspan="3">
                                <div class="row" id="M_SUGGESTIONS"></div>
                            </td>
                        </tr>
                        <tr>
                            <th>애로사항</th>
                            <td colspan="3">
                                <div class="row" id="M_DFCT_PRBL"></div>
                            </td>
                        </tr>
                        
                    </tbody>
                </table>
                <table>
                    <colgroup>
                        <col style="width: 12%;">
                        <col style="width: 30%;">
                        <col style="width: auto;">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th rowspan="6">조사확인 세부사항</th>
                            <td>
                                <div class="row">
                                    <div class="txtbox">보증금 및 수수료 적정 납부여부</div>
                                </div>
                            </td>
                            <td>
                                <div class="row" id="M_CFM_CNTN1_DTL"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="row">
                                    <div class="txtbox">플라스틱박스를 통한 제품판매 및 빈용기 회수 여부</div>
                                </div>
                            </td>
                            <td>
                                <div class="row" id="M_CFM_CNTN2_DTL"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="row">
                                    <div class="txtbox">환불문구 및 재사용 표시 적정 여부</div>
                                </div>
                            </td>
                            <td>
                                <div class="row" id="M_CFM_CNTN3_DTL"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="row">
                                    <div class="txtbox">반환되는 빈용기의 확인 여부</div>
                                </div>
                            </td>
                            <td>
                                <div class="row" id="M_CFM_CNTN4_DTL"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="row">
                                    <div class="txtbox">타사병 상호 교환 여부</div>
                                </div>
                            </td>
                            <td>
                                <div class="row" id="M_CFM_CNTN5_DTL"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="row">
                                    <div class="txtbox">기타사항</div>
                                </div>
                            </td>
                            <td>
                                <div class="row" id="M_CFM_CNTN6_DTL"></div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="singleRow" style="float:right ">
            <div class="btn" id="CR"></div>
        </div>
            
    </section>  
    
    <section class="btnwrap" style="height: 50px; margin-top:10px" >
            <div class="btn" id="BL"></div>
            <div class="btn" style="float:right" id="BR"></div>
    </section>
</div>
</body>
</html>