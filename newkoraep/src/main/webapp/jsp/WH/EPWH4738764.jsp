<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>입고정정 내역조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS;	//파라미터 데이터
	 var iniList;			//상세조회 반환내역서 공급 부분
	 var cfm_gridList;	//입고 그리드 데이터
	 var crct_gridList;	//입고정정 그리드 데이터

     $(function() {
    	 
   		INQ_PARAMS 	=  jsonObject($("#INQ_PARAMS").val());	
   		iniList			=  jsonObject($("#iniList").val());
   		cfm_gridList 	=  jsonObject($("#cfm_gridList").val());
   		crct_gridList 	=  jsonObject($("#crct_gridList").val());       

    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
    	 //그리드 셋팅
		 fnSetGrid1();
		
		//text 셋팅
		$('#title_sub').text('<c:out value="${titleSub}" />');				//타이틀
		$('#se').text(parent.fn_text('se'));											//구분
		$('#mtl_nm').text(parent.fn_text('mtl_nm'));								//상호명
		$('#mtl_nm2').text(parent.fn_text('mtl_nm'));							//상호명
		$('#bizrno').text(parent.fn_text('bizrno2'));								//사업자번호
		$('#bizrno2').text(parent.fn_text('bizrno2'));								//사업자번호	
		$('#user_nm').text(parent.fn_text('user_nm'));							//성명
		$('#user_nm2').text(parent.fn_text('user_nm'));						//성명
		$('#addr').text(parent.fn_text('addr'));									//주소
		$('#addr2').text(parent.fn_text('addr'));									//주소
		$('#tel_no').text(parent.fn_text('tel_no2'));								//주소
		$('#tel_no2').text(parent.fn_text('tel_no2'));								//주소
		$('#supplier').text(parent.fn_text('supplier'));							//공급자
		$('#receiver').text(parent.fn_text('receiver'));							//공급받는자
		$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm'));			//직매장									
		$('#car_no').text(parent.fn_text('car_no')); 								//차량번호
		$('#wrhs_cfm_dt').text(parent.fn_text('wrhs_cfm_dt')); 				//입고확인일자
		$('#wrhs_crct_reg_dt').text(parent.fn_text('wrhs_crct_reg_dt')); 	//입고정정등록일자  
        $('#crct_wrhs_cfm_dt').text(parent.fn_text('crct_wrhs_cfm_dt'));    //정정입고확인일자
        $('#crct_rtn_dt').text(parent.fn_text('crct_rtn_dt'));                    //정정반환일자
		$('#doc_no').text(parent.fn_text('doc_no')); 							//문서번호
		$('#wrhs_crct_doc_no').text(parent.fn_text('wrhs_crct_doc_no')); //입고정정문서번호	
		$('#wrhs_doc_no').text(parent.fn_text('wrhs_doc_no')); 				//입고문서번호
		$('#wrhs_crct_data').text('('+ parent.fn_text('wrhs_crct_data') +')'); 	//입고정정내역
		$('#wrhs_cfm_data').text('('+ parent.fn_text('wrhs_cfm_data') +')'); 	//입고확인내역
		
	
		/************************************
		 * 목록 클릭 이벤트
		 ***********************************/
		$("#btn_page").click(function(){
			fn_page();
		});
		
		/************************************
		 * 정정이력조회 클릭 이벤트
		 ***********************************/
		$("#btn_page2").click(function(){
			fn_page2();
		});
		
        /************************************
         * 인쇄 클릭 이벤트
         ***********************************/
        $("#btn_pnt").click(function(){
            kora.common.gfn_viewReport('prtForm', '');
        });
		
		fn_init();
	});
   
    function  fn_init(){
     	
     		$("#WRHS_CFM_DT").text(kora.common.formatter.datetime(iniList[0].WRHS_CFM_DT, "yyyy-mm-dd"));
     		$("#WRHS_CRCT_REG_DT").text(kora.common.formatter.datetime(iniList[0].WRHS_CRCT_REG_DT, "yyyy-mm-dd"));
 	        $("#CRCT_WRHS_CFM_DT").text(kora.common.formatter.datetime(iniList[0].CRCT_WRHS_CFM_DT, "yyyy-mm-dd"));
 	        $("#CRCT_RTN_DT")     .text(kora.common.formatter.datetime(iniList[0].CRCT_RTN_DT, "yyyy-mm-dd"));
     		$("#CAR_NO").text(iniList[0].CAR_NO);
     		$("#WRHS_CRCT_DOC_NO").text(iniList[0].WRHS_CRCT_DOC_NO);
     		$("#WRHS_DOC_NO").text(iniList[0].WRHS_DOC_NO);
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
     
 	        //form값 셋팅
 	        $("#prtForm").find("#MFC_BIZRNO").val(INQ_PARAMS.PARAMS.MFC_BIZRNO);
 	        $("#prtForm").find("#WHSDL_BIZRNO").val(INQ_PARAMS.PARAMS.WHSDL_BIZRNO_ORI);
 	        $("#prtForm").find("#BRCH_ID").val(INQ_PARAMS.PARAMS.MFC_BRCH_ID);
 	        $("#prtForm").find("#BRCH_NO").val(INQ_PARAMS.PARAMS.MFC_BRCH_NO);
 	        $("#prtForm").find("#WRHS_CRCT_DOC_NO").val(INQ_PARAMS.PARAMS.WRHS_CRCT_DOC_NO);
 	        $("#prtForm").find("#WRHS_DOC_NO").val(INQ_PARAMS.PARAMS.WRHS_DOC_NO);
     		
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

	var jsVars2 = "rMateOnLoadCallFunction=gridReadyHandler2";
	var gridApp2, gridRoot2, dataGrid2, layoutStr2, selectorColumn2;
	/**
	 * 그리드 셋팅
	 */
	 function fnSetGrid1(reDrawYn) {
			rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%");
			rMateGridH5.create("grid2", "gridHolder2", jsVars2, "100%", "100%");

			layoutStr = new Array();
			layoutStr2 = new Array();
			/* 입고확인내역 */
			layoutStr.push('<rMateGrid>');
			layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr.push('	<NumberFormatter id="numfmt1" precision="2" useThousandsSeparator="true"/>');
			layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" horizontalScrollPolicy="on"  headerHeight="35">');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridColumn dataField="index" 			 headerText="'+ parent.fn_text('sn')+ '"  		 		width="40"	 	 textAlign="center"	itemRenderer="IndexNoItem"  />');					//순번
			layoutStr.push('			<DataGridColumn dataField="PRPS_NM"  	 headerText="'+ parent.fn_text('prps_cd')+ '"			width="70" 	 textAlign="center"/>');																//용도(유흥용/가정용)
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM"  	 headerText="'+ parent.fn_text('ctnr_nm')+ '"		width="230" 	 textAlign="left"/>');																//빈용기명
			layoutStr.push('			<DataGridColumn dataField="CTNR_CD" 	 headerText="'+ parent.fn_text('cd')+ '" 				width="60" 	 textAlign="center" />');																//코드
			layoutStr.push('			<DataGridColumn dataField="CPCT_NM"  	 headerText="'+ parent.fn_text('cpct_cd')+'(ml)'+'" width="120" 	 textAlign="center"/>');																//용량(ml)]
			layoutStr.push('			<DataGridColumn dataField="RTN_QTY"  	 headerText="'+ parent.fn_text('rtn_qty')+'"			width="80"		 formatter="{numfmt}" textAlign="right" id="num0" />');																//반환량
			layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cfm_data')+ '">');																																									//확인내역
			layoutStr.push('				<DataGridColumn dataField="DMGB_QTY" 	headerText="'+ parent.fn_text('dmgb')+ '"		width="50" formatter="{numfmt}" textAlign="right"  id="num1"/>');						//결병
			layoutStr.push('				<DataGridColumn dataField="VRSB_QTY" 	headerText="'+ parent.fn_text('vrsb')+ '"			width="70" formatter="{numfmt}" textAlign="right"  id="num2"/>');						//잡병
			layoutStr.push('				<DataGridColumn dataField="CFM_QTY" 	headerText="'+ parent.fn_text('cfm_qty2')+ '" 	width="70" formatter="{numfmt}" textAlign="right"  id="num3"/>');						//입고확인수량
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('				<DataGridColumn dataField="CFM_GTN"  	headerText="'+ parent.fn_text('cntr_dps2')+ '" 	width="120" formatter="{numfmt}" textAlign="right"  id="num4"/>');						//빈용기보증금
		 	layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cntr')+' '+ parent.fn_text('std_fee')+'">');																																		//빈용기 취급수수료(원
			layoutStr.push('				<DataGridColumn dataField="CFM_WHSL_FEE"				headerText="'+ parent.fn_text('whsl_fee2')+ '" 	width="120" 	formatter="{numfmt1}" textAlign="right"  id="num5"/>'); 	//도매수수료
			layoutStr.push('				<DataGridColumn dataField="CFM_RTL_FEE" 				headerText="'+ parent.fn_text('rtl_fee2')+ '" 		width="120" 	formatter="{numfmt1}" textAlign="right"  id="num7"  />');//소매수수료
			layoutStr.push('				<DataGridColumn dataField="CFM_WHSL_FEE_STAX"	headerText="'+ parent.fn_text('stax')+ '"	width="120" 	formatter="{numfmt}" 	textAlign="right"  id="num6"  />');//도매부가세
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumn dataField="AMT_TOT" 						headerText="'+ parent.fn_text('amt_tot')+ '" 		width="70"  	formatter="{numfmt}" 	textAlign="right"  id="num9"  />');//금액합계(원)
			layoutStr.push('			<DataGridColumn dataField="RMK_C"		headerText="'+ parent.fn_text('rmk')+ '"		width="7%" textAlign="center"  />');														//비고
			layoutStr.push('		</groupedColumns>');
	 		layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="합계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num0}" formatter="{numfmt}" textAlign="right"/>');	//반환량
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	//결병
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	//잡병
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	//최종입고수량
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');	//빈용기 보증금
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt1}" textAlign="right"/>');	//도매수수료
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');	//도매부가세
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt1}" textAlign="right"/>');	//소매수수료
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num9}" formatter="{numfmt}" textAlign="right"/>');	//금액합계
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('			</DataGridFooter>');
			layoutStr.push('		</footers>'); 
			layoutStr.push('	</DataGrid>');
			layoutStr.push('</rMateGrid>');
			
			/* 입고확인내역 */
			layoutStr2.push('<rMateGrid>');
			layoutStr2.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr2.push('	<NumberFormatter id="numfmt1" precision="2" useThousandsSeparator="true"/>');
			layoutStr2.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr2.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" horizontalScrollPolicy="on"  headerHeight="35">');
			layoutStr2.push('		<groupedColumns>');
			layoutStr2.push('			<DataGridColumn dataField="index" 			 headerText="'+ parent.fn_text('sn')+ '"  		 	width="40"	 	 textAlign="center"	itemRenderer="IndexNoItem"  />');						//순번
			layoutStr2.push('			<DataGridColumn dataField="PRPS_NM"  	 headerText="'+ parent.fn_text('prps_cd')+ '"		width="70" 	 textAlign="center"/>');																	//용도(유흥용/가정용)
			layoutStr2.push('			<DataGridColumn dataField="CTNR_NM"  	 headerText="'+ parent.fn_text('ctnr_nm')+ '"	width="230" 	 textAlign="left"/>');																	//빈용기명
			layoutStr2.push('			<DataGridColumn dataField="CTNR_CD" 	 headerText="'+ parent.fn_text('cd')+ '" 			width="60" 	 textAlign="center" />');																	//코드
			layoutStr2.push('			<DataGridColumn dataField="CPCT_NM"  	 headerText="'+ parent.fn_text('cpct_cd')+'(ml)'+'" 	width="120" 	 textAlign="center"/>');															//용량(ml)]
			layoutStr2.push('			<DataGridColumn dataField="RTN_QTY"  	 headerText="'+ parent.fn_text('rtn_qty')+'"				width="80"		 textAlign="center"/>');															//반환량
			layoutStr2.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cfm_data')+ '">');																																									//확인내역
			layoutStr2.push('				<DataGridColumn dataField="CRCT_DMGB_QTY" 	headerText="'+ parent.fn_text('dmgb')+ '"		width="50" formatter="{numfmt}" textAlign="right"  id="num1"/>');				//결병
			layoutStr2.push('				<DataGridColumn dataField="CRCT_VRSB_QTY" 	headerText="'+ parent.fn_text('vrsb')+ '"			width="70" formatter="{numfmt}" textAlign="right"  id="num2"/>');				//잡병
			layoutStr2.push('				<DataGridColumn dataField="CRCT_QTY" 	  		headerText="'+ parent.fn_text('cfm_qty2')+ '" 	width="70" formatter="{numfmt}" textAlign="right"  id="num3"/>');				//입고확인수량
			layoutStr2.push('			</DataGridColumnGroup>');
			layoutStr2.push('				<DataGridColumn dataField="CRCT_GTN"  			headerText="'+ parent.fn_text('cntr_dps2')+ '" 	width="120" formatter="{numfmt}" textAlign="right"  id="num4"/>');				//빈용기보증금
		 	layoutStr2.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cntr')+' '+ parent.fn_text('std_fee')+'">');																																		//빈용기 취급수수료(원
			layoutStr2.push('				<DataGridColumn dataField="CRCT_WHSL_FEE"			headerText="'+ parent.fn_text('whsl_fee2')+ '" 	width="120" 	formatter="{numfmt1}" textAlign="right"  id="num5"/>'); 	//도매수수료
			layoutStr2.push('				<DataGridColumn dataField="CRCT_RTL_FEE" 				headerText="'+ parent.fn_text('rtl_fee2')+ '" 		width="120" 	formatter="{numfmt1}" textAlign="right"  id="num7"  />');//소매수수료
			layoutStr2.push('				<DataGridColumn dataField="CRCT_WHSL_FEE_STAX"	headerText="'+ parent.fn_text('stax')+ '"	width="120" 	formatter="{numfmt}" 	textAlign="right"  id="num6"  />');//도매부가세
			layoutStr2.push('			</DataGridColumnGroup>');
			layoutStr2.push('			<DataGridColumn dataField="AMT_TOT" 		 headerText="'+ parent.fn_text('amt_tot')+ '" 		width="70"  	formatter="{numfmt}" 	textAlign="right"  id="num9"  />');//금액합계(원)
			layoutStr2.push('			<DataGridColumn dataField="CRCT_WRHS_CFM_DT" headerText="'+ parent.fn_text('crct_wrhs_cfm_dt')+ '" 		width="120"  	formatter="{datefmt2}" 	textAlign="center"    />');//입고정정확인일자
			layoutStr2.push('			<DataGridColumn dataField="CRCT_RTN_DT"	 headerText="'+ parent.fn_text('crct_rtn_dt')+ '" 		width="100"  	formatter="{datefmt2}" 	textAlign="center"    />');//정정반환일자
			layoutStr2.push('			<DataGridColumn dataField="RMK_C"		headerText="'+ parent.fn_text('rmk')+ '"		width="7%" textAlign="center"  />');														//비고
			layoutStr2.push('		</groupedColumns>');
	 		layoutStr2.push('		<footers>');
			layoutStr2.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr2.push('				<DataGridFooterColumn label="합계" textAlign="center"/>');
			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	//결병
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	//잡병
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	//최종입고수량
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');	//빈용기 보증금
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt1}" textAlign="right"/>');	//도매수수료
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');	//도매부가세
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt1}" textAlign="right"/>');	//소매수수료
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num9}" formatter="{numfmt}" textAlign="right"/>');	//금액합계
			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('			</DataGridFooter>');
			layoutStr2.push('		</footers>'); 
			layoutStr2.push('	</DataGrid>');
			layoutStr2.push('</rMateGrid>');
		};

	/**
	 * 조회기준-생산자 그리드 이벤트 핸들러
	 */
	function gridReadyHandler(id) {
		gridApp = document.getElementById(id); // 그리드를 포함하는 div 객체
		gridRoot = gridApp.getRoot(); // 데이터와 그리드를 포함하는 객체
		gridApp.setLayout(layoutStr.join("").toString());
		gridApp.setData(cfm_gridList);
	
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
	
	/**
	 * 조회기준-생산자 그리드 이벤트 핸들러2
	 */
	function gridReadyHandler2(id) {
		gridApp2 = document.getElementById(id); // 그리드를 포함하는 div 객체
		gridRoot2 = gridApp2.getRoot(); // 데이터와 그리드를 포함하는 객체
		gridApp2.setLayout(layoutStr2.join("").toString());
		gridApp2.setData(crct_gridList);
		  
		
		var layoutCompleteHandler2 = function(event) {
			dataGrid2 = gridRoot2.getDataGrid(); // 그리드 객체
			dataGrid2.addEventListener("change", selectionChangeHandler2);
		}
		var dataCompleteHandler2 = function(event) {
			dataGrid2 = gridRoot2.getDataGrid(); // 그리드 객체
		}
		var selectionChangeHandler2 = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			selectorColumn2 = gridRoot2.getObjectById("selector");
		}
		gridRoot2.addEventListener("dataComplete", dataCompleteHandler2);
		gridRoot2.addEventListener("layoutComplete", layoutCompleteHandler2);
	}

	
/****************************************** 그리드 셋팅 끝***************************************** */


</script>

<style type="text/css">
</style>



</head>
<body>
    <div class="iframe_inner" id="testee" >
		    <input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="iniList" value="<c:out value='${iniList}' />" />
			<input type="hidden" id="cfm_gridList" value="<c:out value='${cfm_gridList}' />" />
			<input type="hidden" id="crct_gridList" value="<c:out value='${crct_gridList}' />" />
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
				<div class="btn" style="float:right" id="UR"><!--인쇄  -->
				</div>
			</div>
			   
			<section class="secwrap">
						<div class="write_area">
							<div class="write_tbl">
								<table>
									<colgroup>
										<col style="width: 10%;">
										<col style="width: 15%;">
										<col style="width: 20%;">
										<col style="width: 15%;">
										<col style="width: auto;">
									</colgroup>
									<tbody>
										<tr>
											<th colspan="1" id="doc_no"></th>					<!-- 문서번호-->
											<th class="bd_l"  id="wrhs_crct_doc_no"></th>			<!-- 입고정정문서번호 -->
											<td>
												<div class="row">
													<div class="txtbox" id="WRHS_CRCT_DOC_NO"></div>
												</div>
											</td>
											<th class="bd_l" id="wrhs_doc_no"></th> <!-- 입고문서 -->
											<td>
												<div class="row">
													<div class="txtbox" id="WRHS_DOC_NO"></div>
												</div>
											</td>
										</tr>
										<tr>
											<th rowspan="2" id="se"></th>                    <!-- 구분 -->
											<th class="bd_l"  id="wrhs_crct_reg_dt"></th>			<!-- 입고정정등록일자 -->
											<td>
												<div class="row">
													<div class="txtbox" id="WRHS_CRCT_REG_DT"></div>
												</div>
											</td>
											<th class="bd_l" id="wrhs_cfm_dt"></th> <!-- 입고확인일자 -->
											<td>
												<div class="row">
													<div class="txtbox" id="WRHS_CFM_DT"></div>
												</div>
											</td> 
										</tr>
                                        <tr>
                                            <th class="bd_l" id="crct_wrhs_cfm_dt"></th> <!-- 정정입고확인일자 -->
                                            <td>
                                                <div class="row">
                                                    <div class="txtbox" id="CRCT_WRHS_CFM_DT"></div>
                                                </div>
                                            </td> 
                                            <th class="bd_l"  id="crct_rtn_dt"></th>           <!-- 정정반환일자 -->
                                            <td>
                                                <div class="row">
                                                    <div class="txtbox" id="CRCT_RTN_DT"></div>
                                                </div>
                                            </td>
                                        </tr>
										<tr>
											<th rowspan="3"  id="supplier"></th>
											<th class="bd_l" id="mtl_nm"></th> <!-- 상호명 -->
											<td>
												<div class="row">
													<div class="txtbox" id="WHSDL_BIZRNM"></div>
												</div>
											</td>
											<th class="bd_l" id="bizrno"></th> <!-- 사업자번호-->
											<td>
												<div class="row">
													<div class="txtbox" id="WHSDL_BIZRNO"></div>
												</div>
											</td>
										</tr>
										<tr>
											<th class="bd_l"  id="addr"></th> <!-- 주소 -->
											<td colspan="3">
												<div class="row">
													<div class="txtbox" id="WHSDL_ADDR"></div>
												</div>
											</td>
										<!-- 	<th class="bd_l" style="background-color: white; border-left-color: white;"></th>
											<td>
												<div class="row">
													<div class="txtbox"></div>
												</div>
											</td> -->
										</tr>
										<tr>
											<th class="bd_l" id="tel_no"></th> <!-- 연락처 -->
											<td>
												<div class="row">
													<div class="txtbox" id="WHSDL_RPST_TEL_NO"></div>
												</div>
											</td>
											<th class="bd_l"  id="user_nm"></th><!-- 성명 -->
											<td>
												<div class="row">
													<div class="txtbox"  id=WHSDL_RPST_NM></div>
												</div>
											</td>
										</tr>
										<tr>
											<th rowspan="4" id="receiver"></th>
											<th class="bd_l" id="mtl_nm2"></th>
											<td>
												<div class="row">
													<div class="txtbox" id="MFC_BIZRNM"></div> <!-- 상호명 -->
												</div>
											</td>
											<th class="bd_l" id="bizrno2" ></th>
											<td>
												<div class="row">
													<div class="txtbox" id="MFC_BIZRNO"></div>	<!-- 사업자등록번호 -->
												</div>
											</td>
										</tr>
										<tr>
											<th class="bd_l"  id="addr2"></th><!-- 생산자 주소 -->
											<td colspan="3" >
												<div class="row" >
													<div class="txtbox"  id="MFC_ADDR"></div>
												</div>
											</td>
										</tr>
										<tr>
											<th class="bd_l" id="tel_no2"></th><!-- 전화번호 -->
											<td>
												<div class="row">
													<div class="txtbox"  id="MFC_RPST_TEL_NO"></div>
												</div>
											</td>
											<th class="bd_l"  id="user_nm2"></th><!-- 성명 -->
											<td>
												<div class="row">
													<div class="txtbox" id="MFC_RPST_NM"></div> 	
												</div>
											</td>
										</tr>
										<tr>
											<th class="bd_l"  id="mfc_brch_nm"></th><!-- 직매장 -->
											<td>
												<div class="row">
													<div class="txtbox" id="MFC_BRCH_NM"></div>
												</div>
											</td>
											<th class="bd_l" id="car_no"></th> <!-- 차량번호 -->
											<td>
												<div class="row">
													<div class="txtbox" id="CAR_NO"></div>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</section>

			<div class="boxarea mt10">
				<div class="h4group" >
					<h5 class="tit"  style="font-size: 16px;" id="wrhs_cfm_data"><h5>
				</div>
				<div id="gridHolder" style="height: 400px; background: #FFF;"></div>
			</div>	<!-- 그리드 셋팅 -->
			
			<div class="boxarea mt10">
				<div class="h4group" >
					<h5 class="tit"  style="font-size: 16px;" id="wrhs_crct_data"><h5>
				</div>
				<div id="gridHolder2" style="height: 400px; background: #FFF;"></div>
			</div>	<!-- 그리드 셋팅2 -->
			
		
		<section class="btnwrap mt10"  >
				<div class="btn"	 id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
		
	</div>

    <!--출력에 쓸 데이터 -->
    <form name="prtForm" id="prtForm">
        <input type="hidden" name="CRF_NAME" value="EPCMOROAt.crf" /> <!-- 필수 -->
        <input type="hidden" name="MFC_BIZRNO" id="MFC_BIZRNO"/>
        <input type="hidden" name="WHSDL_BIZRNO" id="WHSDL_BIZRNO"/>
        <input type="hidden" name="BRCH_ID" id="BRCH_ID"/>
        <input type="hidden" name="BRCH_NO" id="BRCH_NO"/>
        <input type="hidden" name="WRHS_CRCT_DOC_NO" id="WRHS_CRCT_DOC_NO"/>
        <input type="hidden" name="WRHS_DOC_NO" id="WRHS_DOC_NO"/>
        <input type="hidden" name="BSNM_NM" id="BSNM_NM" value="${ssBizrNm}"/>
        <input type="hidden" name="USER_NM" id="USER_NM" value="${ssUserNm}"/>
    </form>
</body>
</html>