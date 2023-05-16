<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>반환정보상세조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=1100, user-scalable=yes">

<%@include file="/jsp/include/common_page_m.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">
  
	var INQ_PARAMS;	                     //파라미터 데이터
    var toDay = kora.common.gfn_toDay(); // 현재 시간
    var initList;						 //도매업자
	
    $(function() {

    	INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());	
    	initList   = jsonObject($("#initList").val());		

    	//초기 셋팅
    	fn_init();
    	 
        /************************************
         * 확인버튼 클릭 이벤트
         ***********************************/
        $("#btn_cfm").click(function(){
            statChg_chk();
        });

        /************************************
         * 변경버튼 클릭 이벤트
         ***********************************/
        $("#btn_chg").click(function(){
            link();
        });
        
		/************************************
         * 목록 클릭 이벤트
         ***********************************/
        $("#btn_page, #btn_lst2").click(function(){
            fn_page();
        });
	});
     
    //초기화
    function fn_init(){
        $("#WHSDL_BIZRNM").text(initList[0].WHSDL_BIZRNM);
        $("#WHSDL_BIZRNO").text(kora.common.setDelim(initList[0].WHSDL_BIZRNO, "999-99-99999"));
        $("#RTRVL_STAT_NM").text(initList[0].RTRVL_STAT_NM);
        
        $('#whsdl'       ).text(fn_text('whsdl'));        //도매업자
        $('#whsdl_bizrno').text(fn_text('whsdl_bizrno')); //도매업자사업자번호
        $('#stat'        ).text(fn_text('stat'));         //상태
        
        var cnt;
        var row;
        
        $.each(initList, function(i, v){
            
            cnt = i + 1;

            row = '';

            if(i > 0) {
                row += '</br>'; 
            }

            row += '<div class="hgroup"><h3 class="tit">반환정보상세 '+ cnt + '</h3></div><div class="tbl">';
            row += '<table>';
            row += '<colgroup><col style="width: 240px;"><col style="width: auto;"></colgroup>';
            row += '<tbody>';
            row += '<tr><th>'+fn_text('rtrvl_dt2')+'</th><td>'+kora.common.formatter.datetime(v.RTRVL_DT,"yyyy-mm-dd")+'</td></tr>';
            row += '<tr><th>'+fn_text('prps_cd')+'</th><td>'+v.PRPS_NM+'</td></tr>';
            row += '<tr><th>'+fn_text('cpct')+'</th><td>'+v.CPCT_NM+'</td></tr>';
            row += '<tr><th>'+fn_text('rtrvl_qty')+'</th><td>'+kora.common.format_comma(v.RTRVL_QTY)+'</td></tr>';
            row += '<tr><th>'+fn_text('rtrvl_dps')+'</th><td>'+kora.common.format_comma(v.RTRVL_GTN)+'</td></tr>';
            row += '<tr><th>'+fn_text('rtrvl_fee')+'</th><td>'+kora.common.format_comma(v.REG_RTRVL_FEE)+'</td></tr>';
            row += '<tr><th>'+fn_text('total')+'</th><td>'+kora.common.format_comma(v.AMT_TOT)+'</td></tr>';
            row += '</tbody>';
            row += '</table>';
            row += '</div>';
            
            $('#init_table').append(row);
        });
    }
     
    //변경
    function link(){
    
        var statCd = initList[0].RTRVL_STAT_CD;
        var INQ_PARAMS2 = {};
        
        if("RG" != statCd && "WG" != statCd && "RJ" != statCd) {
            alert('상태가 "회수등록(소매업자)" 혹은 "회수등록(도매업자)" 혹은 "회수조정(소매업자)" 상태만 변경 할 수 있습니다.');
            return;
        }
	
        var input = initList[0];
        var url="/RT/EPRT9025842.do";

        //파라미터에 조회조건값 저장 
        //INQ_PARAMS["PARAMS"] = {};

        INQ_PARAMS2["PARAMS"] = input;
        INQ_PARAMS2["SEL_PARAMS"]   = INQ_PARAMS["SEL_PARAMS"];
        INQ_PARAMS2["FN_CALLBACK"]  = "fn_sel";
        INQ_PARAMS2["URL_CALLBACK"] = "/RT/EPRT9025801.do";
        
        
        console.log("dddd2 : " + JSON.stringify(INQ_PARAMS2));

        kora.common.goPageB(url, INQ_PARAMS2);
    }
    
    function statChg_chk(){
	    var statCd = initList[0].RTRVL_STAT_CD;
	    
	    if("WG" != statCd && "WJ" != statCd) {
		    alert('상태가 "회수등록(도매업자)" 혹은 "회수조정(도매업자)" 상태만 확인 할 수 있습니다.');
		    return;
		}
	
	    if(!confirm("선택하신 내역을 확인 처리 하시겠습니까?")) {
		    return;
		}
	   
	    statChg();
    }
    
    //확인상태변경
    function statChg(){
        var input = initList[0];
        var url   = "/RT/EPRT9025801_21.do"
        
        ajaxPost(url, input, function(rtnData) {
            if(rtnData.RSLT_CD == "0000"){
        	    fn_page();
                alert(rtnData.RSLT_MSG);
            }else{
                alert(rtnData.RSLT_MSG);
            }
        });
    }
    
	//목록
    function fn_page(){
	       kora.common.goPageB('', INQ_PARAMS);
    }
</script>
</head>
<body>
<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
<input type="hidden" id="initList" value="<c:out value='${initList}' />" />

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
                                <col style="width: 300px;">
                                <col style="width: auto;">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th><span id="whsdl"></span></th>
                                    <td><span id="WHSDL_BIZRNM"></span></td>
                                </tr>
                                <tr>
                                    <th><span id="whsdl_bizrno"></span></th>
                                    <td><span id="WHSDL_BIZRNO"></span></td>
                                </tr>
                                <tr>
                                    <th><span id="stat"></span></th>
                                    <td><span id="RTRVL_STAT_NM"></span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="contbox bdn pt30 pb50">
                    <div class="tab_box2 on" id="init_table"></div>
                </div>
                
                <div class="btn_wrap mt35">
                    <div class="fl_c">
                        <a href="#self" class="btn70 c3" style="width: 180px;" id="btn_cfm">확인</a>
                        <a href="#self" class="btn70 c2 ml30" style="width: 180px;" id="btn_chg">변경</a>
                        <a href="#self" class="btn70 c1 ml30" style="width: 180px;" id="btn_page">목록</a>
                    </div>
                </div>
            </div><!-- id : contents -->

        </div><!-- id : container -->
        
        <%@include file="/jsp/include/footer_m.jsp" %>

    </div><!-- id : wrap -->
</body>
</html>