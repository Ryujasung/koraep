<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>반환관리</title>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=1100, user-scalable=yes">
<meta name="description" content="사이트설명">
<meta name="keywords" content="사이트검색키워드">
<meta name="author" content="Newriver">
<meta property="og:title" content="공유제목">
<meta property="og:description" content="공유설명">
<meta property="og:image" content="공유이미지 800x400">

<%@include file="/jsp/include/common_page_m.jsp" %>
<%@ page import="egovframework.common.util"%>

<%
    String mblYn = util.null2void((String)session.getAttribute("MBL_LOGIN"));
    String display = "Y".equals(mblYn)?"display:none;":"";
%>

<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS;	///파라미터 데이터
	 var iniList; 			//상세조회 반환내역서 공급 부분
	 var gridList;			//그리드 데이터
	 
     $(function() {
	 
	 
    	
    	INQ_PARAMS 	=  jsonObject($("#INQ_PARAMS").val());	///파라미터 데이터                   
    	iniList 			=  jsonObject($("#iniList").val()); 				//상세조회 반환내역서 공급 부분    
    	gridList 			=  jsonObject($("#gridList").val());			//그리드 데이터                 

    	//text 셋팅
		$('.txtTable tr th').each(function(){
			if($(this).attr('id') != ''){
				$(this).html(fn_text($(this).attr('id')) );
			}
		});
    	
		$("#RTN_DOC_NO").text(INQ_PARAMS.PARAMS.RTN_DOC_NO);
		$("#RTN_DT").text(kora.common.formatter.datetime(INQ_PARAMS.PARAMS.RTN_DT_ORI, "yyyy-mm-dd"));
		$("#WHSDL_BIZRNM").text(iniList[0].WHSDL_BIZRNM);
 		$("#MFC_BIZRNM").text(iniList[0].MFC_BIZRNM);
 		$("#MFC_BRCH_NM").text(iniList[0].MFC_BRCH_NM);
 		$("#CAR_NO").text(iniList[0].CAR_NO);
		
		//상세정보 셋팅
    	$.each(gridList, function(i, v){
    		var row = '';
    		row += '<div class="contbox bdn pt30">';
    		row += '<div class="hgroup"><h3 class="tit">반환정보 '+(i+1)+'</h3></div>';
    		row += '<div class="tbl"><table>';
    		row += '<colgroup>';
    		row += '		<col style="width: 177px;">';
    		row += '		<col style="width: 87px;">';
    		row += '		<col style="width: 74px;">';
    		row += '		<col style="width: 93px;">';
    		row += '		<col style="width: auto;">';
    		row += '</colgroup>';
    		row += '<tbody>';
    		row += '<tr class="left"><th>'+fn_text('prps_cd')+'</th><td colspan="2">'+v.PRPS_CD+'</td><th>'+fn_text('cpct_cd')+'</th><td>'+v.CPCT_NM+'</td></tr>';
    		row += '<tr class="left"><th>'+fn_text('ctnr_nm')+'</th><td colspan="4">'+v.CTNR_NM+'</td></tr>';
    		row += '<tr ><th>'+fn_text('box_qty')+'</th><td colspan="2" class="pr5">'+kora.common.format_comma(v.BOX_QTY)+'</td><th>'+fn_text('btl')+'</th><td>'+kora.common.format_comma(v.RTN_QTY)+'</td></tr>';
    		row += '<tr ><th colspan="2">'+fn_text('cntr')+fn_text('dps')+'</th><td colspan="3">'+kora.common.format_comma(v.RTN_GTN)+'</td></tr>';
    		row += '<tr ><th colspan="2">'+fn_text('whsl')+fn_text('cntr')+'<br>'+fn_text('std_fee')+'</th><td colspan="3">'+kora.common.format_comma(v.RTN_WHSL_FEE)+'</td></tr>';
            row += '<tr ><th colspan="2">'+fn_text('rtl')+fn_text('cntr')+'<br>'+fn_text('std_fee')+'</th><td colspan="3">'+kora.common.format_comma(v.RTN_RTL_FEE)+'</td></tr>';
            row += '<tr ><th colspan="2">'+fn_text('stax2')+'</th><td colspan="3">'+kora.common.format_comma(v.RTN_WHSL_FEE_STAX)+'</td></tr>';
            row += '<tr ><th colspan="2" class="red">'+fn_text('amt_tot')+'</th><td colspan="3" class="red" style="">'+kora.common.format_comma(v.AMT_TOT)+'</td></tr>';
    		row += '<tr class="left"><th colspan="2">'+fn_text('rmk')+'</th><td colspan="3">'+kora.common.null2void(v.RMK_C)+'</td></tr>';
    		row += '</tbody></table></div></div>';
    		
    		$('#contentsBtm').before(row);

		});
		
    	/************************************
		 * 삭제버튼 클릭 이벤트
		 ***********************************/
		$("#btn_del").click(function(){
			fn_del();
		});
		
		/************************************
		 * 반환내역서 변경 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_upd").click(function(){
			fn_upd();
		});
	
		/************************************
		 * 목록 클릭 이벤트
		 ***********************************/
		$("#btn_lst").click(function(){
			fn_lst();
		});
		
        /************************************
         * 인쇄 클릭 이벤트
         ***********************************/
        $("#btn_pnt").click(function(){
            fn_init();
            kora.common.gfn_viewReport('prtForm', "<%=mblYn%>");
        });
	});
     
 	function fn_del(){
 		if(confirm("삭제하시겠습니까? 삭제 처리된 내역은 복원되지 않으며 재등록 하셔야 합니다.")){
 			var url ="/WH/EPWH2910142_04.do"; 
 			var input = INQ_PARAMS.PARAMS;
 	 		ajaxPost(url, input, function(rtnData){
 	 			if(rtnData.RSLT_CD == "0000"){
 	 				alert(rtnData.RSLT_MSG);
 	 				fn_lst();
 	 			}else{
 	 				alert(rtnData.RSLT_MSG);
 	 			}
 	 		},false);  
 		}
 	}
	 
     //반환내역서변경
     function fn_upd(){
    	  
    	 if(gridList[0].RTN_STAT_CD != 'RG'){
    		 alert("반환등록 상태의 반환정보만 변경 가능합니다. 다시 한 번 확인하시기 바랍니다.");
    		 return;
    	 }
    	 var input = INQ_PARAMS.PARAMS;
    	//파라미터에 조회조건값 저장 
 		INQ_PARAMS["PARAMS"] = {}
 		INQ_PARAMS["PARAMS"] = input;
 		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
 		INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH2910164.do";

 		kora.common.goPage('/WH/EPWH2910142.do', INQ_PARAMS);
     }
     
     //목록
  	function fn_lst(){
  		kora.common.goPageB('', INQ_PARAMS);
    }

    function fn_init(){
        //form값 셋팅
        $("#prtForm").find("#RTN_DOC_NO").val(INQ_PARAMS.PARAMS.RTN_DOC_NO);
        $("#prtForm").find("#MFC_BIZRID").val(INQ_PARAMS.PARAMS.MFC_BIZRID);
        $("#prtForm").find("#MFC_BIZRNO").val(INQ_PARAMS.PARAMS.MFC_BIZRNO);
        $("#prtForm").find("#WHSDL_BIZRID").val(INQ_PARAMS.PARAMS.WHSDL_BIZRID);
        $("#prtForm").find("#WHSDL_BIZRNO").val(INQ_PARAMS.PARAMS.WHSDL_BIZRNO);
        $("#prtForm").find("#MFC_BRCH_ID").val(INQ_PARAMS.PARAMS.MFC_BRCH_ID);  
        $("#prtForm").find("#MFC_BRCH_NO").val(INQ_PARAMS.PARAMS.MFC_BRCH_NO);
     }
     
</script>

</head>
<body>

  	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
	<input type="hidden" id="iniList" value="<c:out value='${iniList}' />" />
	<input type="hidden" id="gridList" value="<c:out value='${gridList}' />" />

	<div id="wrap">
	
	<%@include file="/jsp/include/header_m.jsp" %>
	
	<%@include file="/jsp/include/aside_m.jsp" %>

    	<div id="container">

			<div id="subvisual">
				<h2 class="tit" id="title"></h2>
				<button class="btn_back" id="btn_lst"><span class="hide">뒤로가기</span></button>
			</div><!-- id : subvisual -->

			<div id="contents">
			
				<div class="contbox bdn pb40">
					<div class="tbl">
						<table class="txtTable">
							<colgroup>
								<col style="width: 192px;">
								<col style="width: auto;">
							</colgroup>
							<tbody>
								<tr>
									<th id="rtn_doc_no"></th>
									<td id="RTN_DOC_NO"></td>
								</tr>
								<tr>
									<th id="rtrvl_dt"></th>
									<td id="RTN_DT"></td>
								</tr>
								<tr>
									<th id="supplier"></th>
									<td id="WHSDL_BIZRNM"></td>
								</tr>
								<tr>
									<th id="receiver" rowspan="2"></th>
									<td id="MFC_BIZRNM"></td>
								</tr>
								<tr>
									<td id="MFC_BRCH_NM"></td>
								</tr>
								<tr>
									<th id="car_no"></th>
									<td id="CAR_NO"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
								
				<div class="btn_wrap mt35" id="contentsBtm">
					<div class="fl_c">
						<button class="btn70 c2" style="width: 220px;" id="btn_upd">반환내역서 변경</button>
						<button class="btn70 c1" style="width: 220px;" id="btn_del">반환내역서 삭제</button>
                        <button class="btn70 c3" style="width: 120px; <%=display%>" id="btn_pnt">인쇄</button>
						<!-- <button class="btn70 c1 ml30" style="width: 220px;" id="btn_lst">목록</button> -->
					</div>
				</div>
				
			</div><!-- id : contents -->

		</div><!-- id : container -->
		
		<%@include file="/jsp/include/footer_m.jsp" %>

	</div><!-- id : wrap -->
<form name="prtForm" id="prtForm">
    <input type="hidden" name="CRF_NAME" value="EPCE2910164.crf" /> <!-- 필수 -->
    <input type="hidden" name="RTN_DOC_NO"   id="RTN_DOC_NO"  />
    <input type="hidden" name="MFC_BIZRID"  id="MFC_BIZRID" />
    <input type="hidden" name="MFC_BIZRNO"  id="MFC_BIZRNO"   />
    <input type="hidden" name="WHSDL_BIZRID" id="WHSDL_BIZRID"    />
    <input type="hidden" name="WHSDL_BIZRNO"  id="WHSDL_BIZRNO" />
    <input type="hidden" name="MFC_BRCH_ID" id="MFC_BRCH_ID"  />
    <input type="hidden" name="MFC_BRCH_NO"   id="MFC_BRCH_NO"  />
    <input type="hidden" name="S_USER_NM" id="S_USER_NM" value="${ssUserNm}"/>
    <input type="hidden" name="S_BIZR_NM" id="S_BIZR_NM" value="${ssBizrNm}"/>
</form>
</body>
</html>