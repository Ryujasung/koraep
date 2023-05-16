<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>정산서 상세조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=1100, user-scalable=yes">

<%@include file="/jsp/include/common_page_m.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">
		
	var INQ_PARAMS;
	var searchList2;
    var searchDtl;
    var searchData;
	
	$(document).ready(function(){

		INQ_PARAMS  = jsonObject($('#INQ_PARAMS').val());
		searchList2 = jsonObject($('#searchList2').val());
		searchDtl = jsonObject($('#searchDtl').val());
		searchData = jsonObject($('#searchData').val());
		
		$('.tit').each(function(){
			$(this).text(fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
		});
		
		
		//그리드 셋팅
		//if(searchList2.length > 0){ fn_set_grid2(); }else{ $('#gridDiv2').hide(); }

		//목록
		$("#btn_page, #btn_lst2").click(function(){
			fn_lst();
		});
		
		fn_init();
	});
	
	function  fn_init(){

	    //상세
	    $('#EXCA_TERM'      ).text(kora.common.setDelim(searchDtl.EXCA_ST_DT,'9999-99-99') +" ~ "+ kora.common.setDelim(searchDtl.EXCA_END_DT,'9999-99-99'));
        $('#STAC_DOC_NO'    ).text(searchDtl.STAC_DOC_NO);
        $('#EXCA_ISSU_SE_NM').text(searchDtl.EXCA_ISSU_SE_NM);
        $('#ACP_ACCT_NO'    ).text(searchDtl.ACP_ACCT_NO);
        $('#EXCA_SE_NM'     ).text(searchDtl.EXCA_SE_NM);
        $('#EXCA_AMT'       ).text(kora.common.format_comma(searchDtl.EXCA_AMT) + " 원");
        
        var row = "";
        $.each(searchList2, function(i, v){
            
            cnt = i + 1;

            row = '';

            if(i > 0) {
                row += '</br>'; 
            }

            row += '<div class="hgroup"><h3 class="tit">' +fn_text('wrhs_crct_dd') + cnt + '</h3></div><div class="tbl">';
            row += '<table>';
            row += '<colgroup><col style="width: 205px;"><col style="width: auto;"><col style="width: auto;"></colgroup>';
            row += '<tbody>';
            row += '<tr><th>'+fn_text('wrhs_cfm_dt')+'</th><td colspan="2">'+kora.common.formatter.datetime(v.WRHS_CFM_DT_ORI, "yyyy-mm-dd") + '</td></tr>';
            row += '<tr><th>'+fn_text('mfc_bizrnm')+'</th><td colspan="2">'+v.MFC_BIZRNM+'</td></tr>';
            row += '<tr><th>'+fn_text('mfc_brch_nm')+'</th><td colspan="2">'+v.MFC_BRCH_NM+'</td></tr>';
            row += '<tr><th>'+fn_text('stat')+'</th><td colspan="2">'+v.WRHS_CRCT_STAT_CD_NM_ORI+'</td></tr>';
            row += '<tr><th>'+fn_text('se')+'</th><td>'+fn_text('reg_info')+'</td><td>'+fn_text('crct_reg')+'</td></tr>';
            row += '<tr><th>'+fn_text('wrhs_qty')+'</th><td class="right">'+kora.common.format_comma(v.CFM_QTY_TOT)+'</td><td>'+kora.common.format_comma(v.CRCT_QTY_TOT)+'</td></tr>';
            row += '<tr><th>'+fn_text('gtn')+'</th><td class="right">'+kora.common.format_comma(v.CFM_GTN_TOT)+'</td><td>'+kora.common.format_comma(v.CRCT_GTN_TOT)+'</td></tr>';
            row += '<tr><th>'+fn_text('fee')+'</th><td class="right">'+kora.common.format_comma(v.CFM_FEE_TOT)+'</td><td>'+kora.common.format_comma(v.CRCT_FEE_TOT)+'</td></tr>';
            row += '<tr><th>'+fn_text('stax')+'</th><td class="right">'+kora.common.format_comma(v.CFM_FEE_STAX_TOT)+'</td><td>'+kora.common.format_comma(v.CRCT_FEE_STAX_TOT)+'</td></tr>';
            row += '<tr><th>'+fn_text('amt')+'</th><td class="right">'+kora.common.format_comma(v.CFM_AMT)+'</td><td>'+kora.common.format_comma(v.CRCT_AMT)+'</td></tr>';
            row += '</tbody>';
            row += '</table>';
            row += '</div>';
            
            $('#wrhs_table').append(row);
        });
        
	}
	
	function fn_lst(){
		kora.common.goPageB('', INQ_PARAMS);
	}

	</script>
</head>
<body>
<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="searchDtl" value="<c:out value='${searchDtl}' />"/>
<input type="hidden" id="searchData" value="<c:out value='${searchData}' />"/>
<input type="hidden" id="searchList2" value="<c:out value='${searchList2}' />"/>
    <div id="wrap">

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
                                    <th><span class="tit" id="exca_term_txt"></span></th>
                                    <td><span id="EXCA_TERM"></span></td>
                                </tr>
                                <tr>
                                    <th><span class="tit" id="stac_doc_no_txt"></span></th>
                                    <td><span id="STAC_DOC_NO"></span></td>
                                </tr>
                                <tr>
                                    <th><span class="tit" id="exca_se_txt"></span></th>
                                    <td><span id="EXCA_SE_NM"></span></td>
                                </tr>
                                <tr>
                                    <th><span class="tit" id="acp_acct_no_txt"></span></th>
                                    <td><span id="ACP_ACCT_NO"></span></td>
                                </tr>
                                <tr>
                                    <th><span class="tit" id="exca_issu_se_txt"></span></th>
                                    <td><span id="EXCA_ISSU_SE_NM"></span></td>
                                </tr>
                                <tr>
                                    <th><span class="tit" id="exca_amt_txt"></span></th>
                                    <td><span id="EXCA_AMT"></span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="contbox bdn pt30 pb50">
                    <div class="tab_box2 on" id="wrhs_table"></div>
                </div>
                <div class="btn_wrap mt35">
                    <div class="fl_c">
                        <a href="#" class="btn70 c1 ml30" style="width: 220px;" id="btn_page">목록</a>
                    </div>
                </div>
            </div><!-- id : contents -->

        </div><!-- id : container -->
        
        <%@include file="/jsp/include/footer_m.jsp" %>

    </div><!-- id : wrap -->
</body>
</html>
