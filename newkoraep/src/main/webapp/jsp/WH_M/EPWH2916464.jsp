<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>반환내역서상세조회(오직보는것만)</title>
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
%>

<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS;//파라미터 데이터
	 var iniList;//상세조회 반환내역서 공급 부분
	 var gridList;//그리드 데이터
	 
     $(function(){
    	INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());		
    	iniList = jsonObject($("#iniList").val());	
    	gridList = jsonObject($("#gridList").val());	

    	//버튼 셋팅
		fn_btnSetting();
    	 
    	//그리드 셋팅
		//fnSetGrid1();
		
		//text 셋팅
		$('#title_sub').text('<c:out value="${titleSub}" />');//타이틀
		$('#se').text(parent.fn_text('se'));//구분
		$('#mtl_nm').text(parent.fn_text('mtl_nm'));//상호명
		$('#mtl_nm2').text(parent.fn_text('mtl_nm'));//상호명
		$('#bizrno').text(parent.fn_text('bizrno2'));//사업자번호
		$('#bizrno2').text(parent.fn_text('bizrno2'));//사업자번호	
		$('#user_nm').text(parent.fn_text('user_nm'));//성명
		$('#user_nm2').text(parent.fn_text('user_nm'));//성명
		$('#addr').text(parent.fn_text('addr'));//주소
		$('#addr2').text(parent.fn_text('addr'));//주소
		$('#tel_no').text(parent.fn_text('tel_no2'));//주소
		$('#tel_no2').text(parent.fn_text('tel_no2'));//주소
		$('#supplier').text(parent.fn_text('supplier'));//공급자
		$('#receiver').text(parent.fn_text('receiver'));//공급받는자
		$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm'));//직매장									
		$('#car_no').text(parent.fn_text('car_no'));//차량번호
		$('#rtrvl_dt').text(parent.fn_text('rtrvl_dt'));//반환일자
		
		fn_init();
		
		gridListMake();
		/************************************
		 * 목록 클릭 이벤트
		 ***********************************/
		$("#btn_page, .btn_back").click(function(){
			fn_page();
		});
		
		/************************************
		 * 인쇄 클릭 이벤트
		 ***********************************/
		$("#btn_pnt").click(function(){
		    kora.common.gfn_viewReport('prtForm', "<%=mblYn%>");
		});
	});
   
    function  fn_init(){
   		$("#RTN_DT").text(kora.common.formatter.datetime(INQ_PARAMS.PARAMS.RTN_DT, "yyyy-mm-dd"));
   		$("#CAR_NO").text(iniList[0].CAR_NO);
   	
   		$("#MFC_BIZRNM").text(iniList[0].MFC_BIZRNM);
   		$("#MFC_BIZRNO").text(kora.common.setDelim(iniList[0].MFC_BIZRNO, "999-99-99999"));
   		$("#MFC_RPST_NM").text(iniList[0].MFC_RPST_NM);
   		$("#MFC_RPST_TEL_NO").text(iniList[0].MFC_RPST_TEL_NO);
   		$("#MFC_ADDR").text(iniList[0].MFC_ADDR);
   		$("#MFC_BRCH_NM").text(iniList[0].MFC_BRCH_NM);
   		
   		$("#WHSDL_BIZRNM").text(iniList[0].WHSDL_BIZRNM);
   		$("#WHSDL_BIZRNO").text(kora.common.setDelim(iniList[0].WHSDL_BIZRNO, "999-99-99999"));
   		$("#WHSDL_RPST_NM").text(iniList[0].WHSDL_RPST_NM);
   		$("#WHSDL_RPST_TEL_NO").text(iniList[0].WHSDL_RPST_TEL_NO);
   		$("#WHSDL_ADDR").text(iniList[0].WHSDL_ADDR);
   		//gridApp.setData(gridList);
   		
   		//form값 셋팅
   		$("#prtForm").find("#RTN_DOC_NO").val(INQ_PARAMS.PARAMS.RTN_DOC_NO);
   		$("#prtForm").find("#MFC_BIZRID").val(INQ_PARAMS.PARAMS.MFC_BIZRID);
   		$("#prtForm").find("#MFC_BIZRNO").val(INQ_PARAMS.PARAMS.MFC_BIZRNO);
   		$("#prtForm").find("#WHSDL_BIZRID").val(INQ_PARAMS.PARAMS.WHSDL_BIZRID);
   		$("#prtForm").find("#WHSDL_BIZRNO").val(INQ_PARAMS.PARAMS.WHSDL_BIZRNO);
   		$("#prtForm").find("#MFC_BRCH_ID").val(INQ_PARAMS.PARAMS.MFC_BRCH_ID);  
   		$("#prtForm").find("#MFC_BRCH_NO").val(INQ_PARAMS.PARAMS.MFC_BRCH_NO);
     }
     
     //목록
  	function fn_page(){
  		kora.common.goPageB('', INQ_PARAMS);
    }
    
     
	/****************************************** 그리드 셋팅 시작***************************************** */
	/**
	 * 그리드 관련 변수 선언
	 */
	var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
	var gridApp, gridRoot, dataGrid, layoutStr, selectorColumn;

	/**
	 * 그리드 셋팅
	 */
	 function fnSetGrid1(reDrawYn) {
			rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%");

			layoutStr = new Array();
			  
			layoutStr.push('<rMateGrid>');
			layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr.push('	<NumberFormatter id="numfmt1" precision="2" useThousandsSeparator="true"/>');
			layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true"  draggableColumns="true" sortableColumns="true"  headerHeight="35">');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridColumn dataField="index" headerText="'+ parent.fn_text('sn')+ '" width="4%" textAlign="center"  itemRenderer="IndexNoItem" />');//순번
			layoutStr.push('			<DataGridColumn dataField="PRPS_CD" headerText="'+ parent.fn_text('prps_cd')+ '" width="7%" textAlign="center"  />');//용도(유흥용/가정용)
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM" headerText="'+ parent.fn_text('ctnr_nm')+ '" width="15%" textAlign="left" />');//빈용기명
			layoutStr.push('			<DataGridColumn dataField="CTNR_CD" headerText="'+ parent.fn_text('cd')+ '" width="4%" textAlign="center" />');//코드
			layoutStr.push('			<DataGridColumn dataField="CPCT_NM" headerText="'+ parent.fn_text('cpct_cd')+'(ml)'+'" width="6%" textAlign="center"  />');//용량(ml)
			layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('qty')+ '">');//수량
			layoutStr.push('				<DataGridColumn dataField="BOX_QTY" headerText="'+ parent.fn_text('box_qty')+ '" width="4%" formatter="{numfmt}" textAlign="right"  id="num1"/>');//상자
			layoutStr.push('				<DataGridColumn dataField="RTN_QTY"	headerText="'+ parent.fn_text('btl')+ '" width="4%" formatter="{numfmt}" textAlign="right"  id="num2"/>');//병
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cntr')+ parent.fn_text('dps')+'">');//빈용기보증금(원)																		
			layoutStr.push('				<DataGridColumn dataField="RTN_GTN_UTPC" headerText="'+ parent.fn_text('utpc')+ '"	width="4%" formatter="{numfmt}" textAlign="right" />');//단가
			layoutStr.push('				<DataGridColumn dataField="RTN_GTN"	headerText="'+ parent.fn_text('amt')+ '" width="5%" formatter="{numfmt}" textAlign="right"  id="num3"  />');//금액
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cntr')+' '+ parent.fn_text('std_fee')+'">');//빈용기 취급수수료(원
			layoutStr.push('				<DataGridColumn dataField="RTN_WHSL_FEE_UTPC" headerText="'+ parent.fn_text('utpc')+ '" width="4%" 	formatter="{numfmt}" textAlign="right" />');//단가
			layoutStr.push('				<DataGridColumn dataField="RTN_WHSL_FEE" headerText="'+ parent.fn_text('whsl_fee2')+ '" width="6.5%" formatter="{numfmt1}" textAlign="right"   id="num4"  />');//도매수수료
			layoutStr.push('				<DataGridColumn dataField="RTN_WHSL_FEE_STAX" headerText="'+ parent.fn_text('whsl_stax2')+ '" width="6.5%" formatter="{numfmt}" textAlign="right"  id="num5"  />');//도매부가세
			layoutStr.push('				<DataGridColumn dataField="RTN_RTL_FEE_UTPC" headerText="'+ parent.fn_text('utpc')+ '" width="4%" formatter="{numfmt}" 	textAlign="right" />');//단가
			layoutStr.push('				<DataGridColumn dataField="RTN_RTL_FEE" headerText="'+ parent.fn_text('rtl_fee2')+ '" width="6.5%"	formatter="{numfmt1}" textAlign="right"  id="num6" />');//소매수수료
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumn dataField="AMT_TOT"	headerText="'+ parent.fn_text('amt_tot')+ '" width="6%" textAlign="right"  formatter="{numfmt}"  id="num8"   />');//금액합계(원)
			layoutStr.push('			<DataGridColumn dataField="RMK_C headerText="'+ parent.fn_text('rmk')+ '" width="7%" textAlign="center"  />');//비고
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="합계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	//상자
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	//병
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	//금액
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');	//도매수수료
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt1}" textAlign="right"/>');	//도매부가세
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');	//소매수수료
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num8}" formatter="{numfmt}" textAlign="right"/>');	//합계
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('			</DataGridFooter>');
			layoutStr.push('		</footers>');
			layoutStr.push('	</DataGrid>');
			layoutStr.push('</rMateGrid>');
	};

	/**
	 * 조회기준-생산자 그리드 이벤트 핸들러
	 */
	function gridReadyHandler(id) {
		gridApp = document.getElementById(id); // 그리드를 포함하는 div 객체
		gridRoot = gridApp.getRoot(); // 데이터와 그리드를 포함하는 객체
		gridApp.setLayout(layoutStr.join("").toString());
		gridApp.setData();
		fn_init();
		var layoutCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			dataGrid.addEventListener("change", selectionChangeHandler);
		}
		var dataCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
		}
		var selectionChangeHandler = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			selectorColumn = gridRoot.getObjectById("selector");
			rowIndexValue = rowIndex;
		
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	}
	
	function gridListMake(){
		
		var html = '';
		$.each(gridList, function(i,v){
			if(i > 0) {
				html += '</br>'; 
        	}
			html += '<div class="hgroup"><h3 class="tit">' + fn_text('rtn_data')+ (i+1) + '</h3></div>';
			html += '<div class="tbl">';
			html += '<table>';
			html += '	<colgroup>';
			html += '		<col style="width: 177px;">';
			html += '		<col style="width: 38px;">';
			html += '		<col style="width: 98px;">';
			html += '		<col style="width: 93px;">';
			html += '		<col style="width: 73px;">';
			html += '		<col style="width: 74px;">';
			html += '		<col style="width: 19px;">';
			html += '		<col style="width: auto;">';
			html += '	</colgroup>';
			html += '	<tbody>';
			html += '		<tr class="left">';
			html += '			<th>용도</th>';
			html += '			<td colspan="2">'+v.PRPS_CD+'</td>';
			html += '			<th>용량</th>';
			html += '			<td colspan="4">'+v.CPCT_NM+'</td>';
			html += '		</tr>';
			html += '		<tr class="left">';
			html += '			<th>빈용기명</th>';
			html += '			<td colspan="7">'+v.CTNR_NM+'</td>';
			html += '		</tr>';
			html += '		<tr>';
			html += '			<th colspan="2">반환량(개)</th>';
			html += '			<td colspan="6">'+kora.common.format_comma(v.RTN_QTY)+'</td>';
			html += '		</tr>';
			html += '		<tr>';
			html += '			<th colspan="2">보증금(원)</th>';
			html += '			<td colspan="6">'+kora.common.format_comma(v.RTN_GTN)+'</td>';
			html += '		</tr>';
			html += '		<tr>';
			html += '			<th colspan="2">취급수수료(원)</th>';
			html += '			<td colspan="6">'+kora.common.format_comma(Number(v.RTN_WHSL_FEE)+Number(v.RTN_RTL_FEE))+'</td>';
			html += '		</tr>';
			html += '		<tr>';
			html += '			<th colspan="2">부가세(원)</th>';
			html += '			<td colspan="6">'+kora.common.format_comma(Number(v.RTN_WHSL_FEE_STAX))+'</td>';
			html += '		</tr>';
			html += '		<tr>';
			html += '			<th colspan="2">금액 합계(원)</th>';
			html += '			<td colspan="6">'+kora.common.format_comma(v.AMT_TOT)+'</td>';
			html += '		</tr>';
			html += '	</tbody>';
			html += '</div>';
		});
		
		$('#div_01').append(html);
		
	}

/****************************************** 그리드 셋팅 끝***************************************** */


</script>

<style type="text/css">

.srcharea .row .col{
width: 31%;
} 
.srcharea .row .col .tit{
width: 120px;
}

</style>

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
				<h2 class="tit" id="title_sub"></h2>
				<a href="#self" class="btn_back"><span class="hide">뒤로가기</span></a>
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
									<th id="rtrvl_dt"></th><!-- 반환일자 -->
									<td id="RTN_DT"></td>
								</tr>
								<tr>
									<th id="supplier"></th>
									<td id="WHSDL_BIZRNM"></td>
								</tr>
								<tr>
									<th rowspan="2" id="receiver"></th><!-- 공급받는자 -->
									<td id="MFC_BIZRNM"></td>
								</tr>
								<tr>
									<!-- <th>직매장/공장</th> -->
									<td id="MFC_BRCH_NM"></td>
								</tr>
								<tr>
									<th id="car_no"></th><!-- 차량번호 -->
									<td id="CAR_NO"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				
				<div class="contbox bdn pt30" id="div_01">
				</div>
				<div class="btn_wrap mt35">
					<div class="fl_c">
						<a id="btn_page" href="#self" class="btn70 c1" style="width: 220px;">목록</a>
					</div>
				</div>
			</div><!-- id : contents -->

		</div><!-- id : container -->

		<%@include file="/jsp/include/footer_m.jsp" %>
		
	</div><!-- id : wrap -->

</body>
</html>