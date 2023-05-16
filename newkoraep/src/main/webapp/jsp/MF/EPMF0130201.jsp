<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>입고관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>

<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />
<script type="text/javaScript" language="javascript" defer="defer">

	/* 페이징 사용 등록 */
	gridRowsPerPage = 15;// 1페이지에서 보여줄 행 수
	gridCurrentPage = 1;// 현재 페이지
	gridTotalRowCount = 0;//전체 행 수
	
	var INQ_PARAMS;//파라미터 데이터
	var grid_info;//그리드 컬럼 정보
	var sumData;//총합계
	 
    $(function() {
    	 
    	INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());//파라미터 데이터
  	    grid_info = jsonObject($("#grid_info").val());//그리드 컬럼 정보
    	
		//버튼 셋팅
		fn_btnSetting();
		
		//그리드 셋팅
		fnSetGrid1();
      
		gridCurrentPage = 1;
		fn_sel();
		
		/************************************
		 * 목록버튼 클릭 이벤트
		 ***********************************/
		$("#btn_lst").click(function(){
			fn_lst();
		});
		
		$("#btn_del").click(function(){
			fn_del();
		});
  		
	});
	
  	//삭제
	 function fn_del(){
		if(selectorColumn == undefined || selectorColumn == 'undefined' || selectorColumn == null || selectorColumn.getSelectedIndices() == "") {
			alertMsg("선택한 건이 없습니다.");
			return false;
		}

		var msg = '해당 생산자ERP입고정보가 삭제됩니다. \n삭제하시겠습니까?';
		confirm(msg, 'fn_del_exec');
	 }
  	
	function fn_del_exec(){
		var sData = gridRoot.getItemAt(dataGrid.getSelectedIndex());
		
	 	var url = "/MF/EPMF0130201_04.do";
	 	ajaxPost(url, sData, function(rtnData){
	 		if ("" != rtnData && null != rtnData) {
				alertMsg(rtnData.RSLT_MSG, 'fn_sel');
			} else {
				alertMsg("error");
			}
	 	});
	}
     
   //생산자ERP입고정보  조회
    function fn_sel(){
		 var input = {};
		 var url = "/MF/EPMF0130201_194.do" 
		 
		/* 페이징  */
		input["ROWS_PER_PAGE"] = gridRowsPerPage;
		input["CURRENT_PAGE"] = gridCurrentPage;
		
		input["START_DT"] = INQ_PARAMS.PARAMS.START_DT;
		input["END_DT"] = INQ_PARAMS.PARAMS.END_DT;
		input["MFC_BIZRID"] = INQ_PARAMS.PARAMS.MFC_BIZRID;
		input["MFC_BIZRNO"] = INQ_PARAMS.PARAMS.MFC_BIZRNO;
		
		 kora.common.showLoadingBar(dataGrid, gridRoot);
      	 ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {
   					gridApp.setData(rtnData.selList);
   					sumData = rtnData.totalList[0];

   					/* 페이징 표시 */
   					gridTotalRowCount = parseInt(sumData.CNT); //총 카운트
					drawGridPagingNavigation(gridCurrentPage);
   				}else{
   					alertMsg("error");
   				}
   			kora.common.hideLoadingBar(dataGrid, gridRoot);
   		});
      	
    }
   
    /* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel(); //조회 펑션
	}
   
	//입고내역서 등록 페이지 이동 
	function fn_lst() {
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/MF/EPMF0130201.do";
		kora.common.goPage('/MF/EPMF0130001.do', INQ_PARAMS); 
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
			layoutStr.push('	<NumberMaskFormatter id="maskfmt1" formatString="###-##-#####"/>');
			layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" horizontalScrollPolicy="on"  sortableColumns="true"   headerHeight="35">');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridSelectorColumn id="selector" textAlign="center" width="50" allowMultipleSelection="false" headerText="선택"/>');
			layoutStr.push('			<DataGridColumn dataField="PNO" headerText="'+ parent.fn_text('sn')+ '" textAlign="center" width="50"   draggable="false"  />');//순번
			layoutStr.push('			<DataGridColumn dataField="CFM_DT" headerText="'+ parent.fn_text('wrhs_cfm_dt')+ '" width="100"  textAlign="center"   formatter="{datefmt2}"/>');//입고확인일자
			layoutStr.push('			<DataGridColumn dataField="BIZR_TP_CD" headerText="'+ parent.fn_text('se')+ '"  textAlign="center" width="100"  />');//도매업자구분
			layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNM"	headerText="'+ parent.fn_text('whsdl')+ '"  textAlign="center" width="230"   />');//도매업자
			layoutStr.push('			<DataGridColumn dataField="CFM_QTY"	headerText="'+ parent.fn_text('rtn_qty2')+ '"  textAlign="right" width="100" formatter="{numfmt}"  id="num1"  />');//반환량
			layoutStr.push('			<DataGridColumn dataField="CFM_GTN"	headerText="'+ parent.fn_text('dps2')+ '" width="100" formatter="{numfmt}" id="num2" textAlign="right" />');//보증금
			layoutStr.push('			<DataGridColumn dataField="CFM_FEE"	headerText="'+ parent.fn_text('whsl_fee2')+ '" width="100" formatter="{numfmt}" id="num3"  textAlign="right" />');//도매수수료
			layoutStr.push('			<DataGridColumn dataField="CFM_FEE_STAX" headerText="'+ parent.fn_text('rtl_fee2')+ '" width="100" formatter="{numfmt}" id="num4"  textAlign="right" />');//소매수수료
			layoutStr.push('			<DataGridColumn dataField="AMT_TOT" headerText="'+ parent.fn_text('amt_tot')+ '" width="100" formatter="{numfmt}" id="num5"  textAlign="right" />');//도매수수료부가세
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM" headerText="'+ parent.fn_text('mfc_bizrnm')+ '"  width="230"  textAlign="center" id="tmp1" />');//생산자
			layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_NM"	headerText="'+ parent.fn_text('mfc_brch_nm')+ '" width="100"  textAlign="center" id="tmp2"  />');//직매장
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRNO" headerText="'+ parent.fn_text('whsdl_bizrno')+ '" formatter="{maskfmt1}" width="100" textAlign="center" id="tmp3" />');//도매업자 사업자 번호
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn label="'+parent.fn_text('total')+'" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp1}" />');
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp2}" />');
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp3}" />');
			layoutStr.push('			</DataGridFooter>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn label="'+parent.fn_text('totalsum')+'" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum1" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum2" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum3" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum4" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum5" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp1}" />');
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp2}" />');
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp3}" />');
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
			gridApp.setData([]);
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
				selectorColumn.setSelectedIndex(-1);
				selectorColumn.setSelectedIndex(rowIndex);
			}
			gridRoot.addEventListener("dataComplete", dataCompleteHandler);
			gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		}

	/**
	 * 그리드 loading bar on
	 */
	function showLoadingBar() {
		 kora.common.showLoadingBar(dataGrid, gridRoot);
	}

	/**
	 * 그리드 loading bar off
	 */
	function hideLoadingBar() {
		kora.common.hideLoadingBar(dataGrid, gridRoot);
	}
	
	//반환량 합계
	function totalsum1(column, data) {
		if(sumData) 
			return sumData.CFM_QTY_TOT; 
		else 
			return 0;
	}

	//입고량 가정용 합계
	function totalsum2(column, data) {
		if(sumData) 
			return sumData.CFM_GTN_TOT; 
		else 
			return 0;
	}

	//입고량 유흥용 합계
	function totalsum3(column, data) {
		if(sumData) 
			return sumData.CFM_FEE_TOT; 
		else 
			return 0;
	}

	//입고량 직접반환하는자 합계
	function totalsum4(column, data) {
		if(sumData) 
			return sumData.CFM_FEE_STAX_TOT; 
		else 
			return 0;
	}

	//입고량 합계
	function totalsum5(column, data) {
		if(sumData) 
			return sumData.AMT_TOT; 
		else 
			return 0;
	}
	
/****************************************** 그리드 셋팅 끝***************************************** */


</script>

<style type="text/css">

.srcharea .row .col{
width: 28%;
}  
.srcharea .row .col .tit{
width: 81px;
}
.srcharea .row .box {
    width: 60%
}
.srcharea .row .box  select, #s2id_WHSDL_BIZRNM{
    width: 100%
}

</style>

</head>
<body>

    <div class="iframe_inner" >
   		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn" style="float:right" id="UR">
			</div>
		</div>
		
		<section class="btnwrap mt10" >
			<div class="btn" id="GL"></div>
			<div class="btn" style="float:right" id="GR"></div>
		</section>
			
		<div class="boxarea mt10">  <!-- 668 -->
			<div id="gridHolder" style="height: 668px; background: #FFF;"></div>
		   	<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
		</div>	<!-- 그리드 셋팅 -->
			
		<section class="btnwrap" style="height:50px" >
			<div class="btn" id="BL"></div>
			<div class="btn" style="float:right" id="BR"></div>
		</section>
		
</div>

</body>
</html>