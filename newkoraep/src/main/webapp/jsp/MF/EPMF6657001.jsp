<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>연간출고회수현황확인서</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>

<!-- rMateChart -->
<link rel="stylesheet" type="text/css" href="/rMateChart/rMateChartH5/Assets/Css/rMateChartH5.css"/>
<script language="javascript" type="text/javascript" src="/rMateChart/LicenseKey/rMateChartH5License.js"></script>
<script language="javascript" type="text/javascript" src="/rMateChart/rMateChartH5/JS/rMateChartH5.js"></script>
<script type="text/javascript" src="/rMateChart/rMateChartH5/Assets/Theme/theme.js"></script>

<!-- 샘플 작동을 위한 css와 js -->
<script type="text/javascript" src="/rMateChart/Web/JS/common.js"></script>
<script type="text/javascript" src="/rMateChart/Web/JS/sample_util.js"></script>
<link rel="stylesheet" type="text/css" href="/rMateChart/Web/sample.css"/>

<!-- SyntaxHighlighter -->
<script type="text/javascript" src="/rMateChart/Web/syntax/shCore.js"></script>
<script type="text/javascript" src="/rMateChart/Web/syntax/shBrushJScript.js"></script>
<link type="text/css" rel="stylesheet" href="/rMateChart/Web/syntax/shCoreDefault.css"/>
<!-- rMateChart -->

 <!-- AUTOCOMPLETE /멀티SELECTBOX -->
<script type="text/javascript" src="https://cdn.rawgit.com/ax5ui/ax5core/master/dist/ax5core.min.js"></script>
<link rel="stylesheet" href="/js/ax5ui-autocomplete-master/dist/ax5autocomplete.css"/>
<script type="text/javascript" src="/js/ax5ui-autocomplete-master/dist/ax5autocomplete.js"></script> 
<style>
/* The Modal (background) */
.searchModal {
display: none; /* Hidden by default */
position: fixed; /* Stay in place */
z-index: 10; /* Sit on top */
left: 0;
top: 0;
width: 100%; /* Full width */
height: 100%; /* Full height */
overflow: auto; /* Enable scroll if needed */
background-color: rgb(0,0,0); /* Fallback color */
background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
}
/* Modal Content/Box */
.search-modal-content {
background-color: #fefefe;
text-align:center;
margin: 15% auto; /* 15% from the top and centered */
padding: 20px;
border: 1px solid #888;
width: 180px; /* Could be more or less, depending on screen size */
border-radius:10px; 
}
</style>
<script type="text/javaScript" language="javascript" defer="defer">

	var INQ_PARAMS = []; //파라미터 데이터

	var sumData; /* 총합계 추가 */
	
	/* 페이징 사용 등록 */
	gridRowsPerPage = 10;	// 1페이지에서 보여줄 행 수
	gridCurrentPage = 1;		// 현재 페이지
	gridTotalRowCount = 0; 	//전체 행 수
	
	var mfc_bizrnmList;	//생산자 
	var whsdlList_C;		//도매업자 원본
	
	var whsdlList;
	
	//멀티select
	var acSelected_M	= new Array();					//생산자
	var acSelected_C	= new Array();					//용기코드
	var acSelected_A	= new Array();					//지역
	 
    $(function() {
    	 
    	//버튼 셋팅
    	fn_btnSetting();
    	
    	$('.row > .col > .tit').each(function(){
			$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
		});
    	
    	//그리드 셋팅
		fnSetGrid1();
		
		var ctnrSe = jsonObject($("#ctnrSe").val());
		var prpsCdList 	= jsonObject($("#prpsCdList").val());
		var alkndCdList = jsonObject($("#alkndCdList").val());
		mfc_bizrnmList 	= jsonObject($("#mfcBizrList").val());		
		
		//kora.common.autoComplete(); //멀티 autoComplete
		kora.common.setEtcCmBx2(mfc_bizrnmList, "", "", $("#MFC_BIZRNM_SEL"), "BIZRID_NO", "BIZRNM", "N", "E");
		kora.common.setEtcCmBx2(ctnrSe, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N", "T"); //빈용기구분
		kora.common.setEtcCmBx2(prpsCdList, "!2|","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');
		kora.common.setEtcCmBx2(alkndCdList, "","", $("#ALKND_CD"), "ETC_CD", "ETC_CD_NM", "N", "T"); //빈용기구분
		
		//날짜 셋팅
	    $('#START_DT').YJcalendar({  
			toName : 'to',
			triggerBtn : true,
			dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -30, false).replaceAll('-','')
			
		});
		$('#END_DT').YJcalendar({
			fromName : 'from',
			triggerBtn : true,
			dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
		});
			
		/************************************
		 * 시작날짜  클릭시 - 삭제 변경 이벤트
		 ***********************************/
		$("#START_DT").click(function(){
			    var start_dt = $("#START_DT").val();
			     start_dt   =  start_dt.replace(/-/gi, "");
			     $("#START_DT").val(start_dt)
		});
		
		/************************************
		 * 시작날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		$("#START_DT").change(function(){
		     var start_dt = $("#START_DT").val();
		     start_dt   =  start_dt.replace(/-/gi, "");
			if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
		     $("#START_DT").val(start_dt) 
		});
		
		/************************************
		 * 끝날짜  클릭시 - 삭제  변경 이벤트
		 ***********************************/
		$("#END_DT").click(function(){
			    var end_dt = $("#END_DT").val();
			         end_dt  = end_dt.replace(/-/gi, "");
			     $("#END_DT").val(end_dt)
		});
		
		/************************************
		 * 끝날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		$("#END_DT").change(function(){
		     var end_dt  = $("#END_DT").val();
		           end_dt =  end_dt.replace(/-/gi, "");
			if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd")
		     $("#END_DT").val(end_dt) 
		});
		
	
		/************************************
		 * 용도 변경 이벤트
		 ***********************************/
		$("#PRPS_CD").change(function(){
			//fn_mfc_bizrnm();
		});
		
  		$("#btn_sel").click(function(){
  			//조회버튼 클릭시 페이징 초기화
			gridCurrentPage = 1;
			fn_sel("Y"); //조회버튼 클릭 시 챠트조회
		});
  		
  		/************************************
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ***********************************/
		 $("#btn_excel").click(function() {
			 fn_excel();
		 });
  		
		/************************************
		 * 인쇄 클릭 이벤트
		 ***********************************/
		$("#btn_pnt").click(function(){
			fn_pnt();
		});
  		
	});
	
    //인쇄
   	function fn_pnt(){
   		var end_dt  = $("#END_DT").val();
        end_dt =  end_dt.replaceAll('-', '');
		end_dt = parseInt(end_dt);
			
   		if ($("#MFC_BIZRNM_SEL option:selected").val() == "") {
   			alertMsg("생산자를 선택해 주세요.");
   			return;
   		}
   		$('form[name="prtForm"] input[name="START_DT"]').val($("#START_DT").val());
   		$('form[name="prtForm"] input[name="END_DT"]').val($("#END_DT").val());
   		$('form[name="prtForm"] input[name="CTNR_SE"]').val($("#CTNR_SE option:selected").val());
   		$('form[name="prtForm"] input[name="STANDARD_YN"]').val($("#STANDARD_YN option:selected").val());
   		$('form[name="prtForm"] input[name="PRPS_CD"]').val($("#PRPS_CD option:selected").val());
   		$('form[name="prtForm"] input[name="ALKND_CD"]').val($("#ALKND_CD option:selected").val());
   		$('form[name="prtForm"] input[name="MFC_BIZRID_NO"]').val($("#MFC_BIZRNM_SEL option:selected").val());
   		
   		$('form[name="prtForm3"] input[name="START_DT"]').val($("#START_DT").val());
   		$('form[name="prtForm3"] input[name="END_DT"]').val($("#END_DT").val());
   		$('form[name="prtForm3"] input[name="CTNR_SE"]').val($("#CTNR_SE option:selected").val());
   		$('form[name="prtForm3"] input[name="STANDARD_YN"]').val($("#STANDARD_YN option:selected").val());
   		$('form[name="prtForm3"] input[name="PRPS_CD"]').val($("#PRPS_CD option:selected").val());
   		$('form[name="prtForm3"] input[name="ALKND_CD"]').val($("#ALKND_CD option:selected").val());
   		$('form[name="prtForm3"] input[name="MFC_BIZRID_NO"]').val($("#MFC_BIZRNM_SEL option:selected").val());
   		
   		if(end_dt > 20210610) {     // 21.6.10 일자이후 자원순환보증금관리센터
	   		kora.common.gfn_viewReport('prtForm', '');
		}else{
	   		kora.common.gfn_viewReport('prtForm3', '');
			}
/*    		if ($("#MFC_BIZRNM_SEL option:selected").val() == "") {
   			alertMsg("생산자를 선택해 주세요.");
   			return;
   		}
   		$('form[name="prtForm"] input[name="START_DT"]').val($("#START_DT").val());
   		$('form[name="prtForm"] input[name="END_DT"]').val($("#END_DT").val());
   		$('form[name="prtForm"] input[name="CTNR_SE"]').val($("#CTNR_SE option:selected").val());
   		$('form[name="prtForm"] input[name="PRPS_CD"]').val($("#PRPS_CD option:selected").val());
   		$('form[name="prtForm"] input[name="ALKND_CD"]').val($("#ALKND_CD option:selected").val());
   		$('form[name="prtForm"] input[name="MFC_BIZRID_NO"]').val($("#MFC_BIZRNM_SEL option:selected").val());
   		
   		kora.common.gfn_viewReport('prtForm', ''); */
     }

	
  //엑셀저장
	function fn_excel(){
		var collection = gridRoot.getCollection();
		if(collection.getLength() < 1){
			alertMsg("데이터가 없습니다.");
			return;
		}
		
		if(INQ_PARAMS["SEL_PARAMS"] == undefined){ 
			alertMsg("먼저 데이터를 조회해야 합니다.");
			return;
		}
					
		var now  = new Date(); 				     // 현재시간 가져오기
		var hour = new String(now.getHours());   // 시간 가져오기
		var min  = new String(now.getMinutes()); // 분 가져오기
		var sec  = new String(now.getSeconds()); // 초 가져오기
		var today = kora.common.gfn_toDay();
		var fileName = $('#title').text() +"_" + today+hour+min+sec+".xlsx";
		
		//그룹헤더용
        var groupList = dataGrid.getGroupedColumns(); 
        var groupCntTot = 0;
        var groupCnt = 0;
		//그리드 컬럼목록 저장
		var col = new Array();
		var columns = dataGrid.getColumns();
		for(i=0; i<columns.length; i++){
			if(columns[i].getDataField() != undefined && columns[i].getDataField() != 'index'){ //순번 제외
				var item = {};
				item['headerText'] = columns[i].getHeaderText();
				item['dataField'] = columns[i].getDataField();
				item['textAlign'] = columns[i].getStyle('textAlign');
				item['id'] = kora.common.null2void(columns[i].id);
				
				col.push(item);
			}
		}
		var input = INQ_PARAMS["SEL_PARAMS"];
		input['excelYn'] = 'Y';
		input['fileName'] = fileName;
		input['columns'] = JSON.stringify(col);
		
		var url = "/MF/EPMF6657001_05.do";
		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
				alertMsg(rtnData.RSLT_MSG);
			}else{
				//파일다운로드
				frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
				frm.fileName.value = fileName;
				frm.submit();
			}
			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
		});
	}

    /* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel("F","P"); //조회 펑션
	}
    
    /**
	 * 목록조회
	 */
	function fn_sel(chartYn,page){
    	
		var url = "/MF/EPMF6657001_19.do";
		var input = {};
		if(page !="P"){
			input['START_DT'] = $("#START_DT").val();
			input['END_DT'] = $("#END_DT").val();
			input['CTNR_SE'] = $("#CTNR_SE option:selected").val();
			input['STANDARD_YN'] = $("#STANDARD_YN option:selected").val();
			input['PRPS_CD'] = $("#PRPS_CD option:selected").val();
			input['ALKND_CD'] = $("#ALKND_CD option:selected").val();
			input["MFC_LIST"]	= $("#MFC_BIZRNM_SEL option:selected").val();   //생산자

			INQ_PARAMS["SEL_PARAMS"] = input;
		}else{
			 input = INQ_PARAMS["SEL_PARAMS"];
		}

		/* 페이징  */
		input["ROWS_PER_PAGE"] = gridRowsPerPage;  
		input["CURRENT_PAGE"] 	= gridCurrentPage;
		
// 		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
$("#modal").show();
		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != ""){
				gridApp.setData(rtnData.searchList);
								
				/* 페이징 표시 */
				gridTotalRowCount = parseInt(rtnData.totalList[0].CNT); //총 카운트 	/* 총합계 추가 */
				drawGridPagingNavigation(gridCurrentPage);
				
				sumData = rtnData.totalList[0]; /* 총합계 추가 */
				
			} else {
				alertMsg("error");
			}
			$("#modal").hide();
// 			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
		});
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
			layoutStr.push('	<NumberMaskFormatter id="maskfmt" formatString="###-##-#####"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" draggableColumns="true" sortableColumns="true" >');
			layoutStr.push('		<groupedColumns>');   	
			layoutStr.push('			<DataGridColumn dataField="PNO" 		headerText="'+ parent.fn_text('sn')+ '" textAlign="center" width="50"   draggable="false"/>'); //순번
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM" 		headerText="'+ parent.fn_text('mfc_bizrnm')+ '"  width="150"  	textAlign="center" />');
			layoutStr.push('            <DataGridColumn dataField="ALKND_NM"     headerText="'+ parent.fn_text('alknd_cd')+ '"        width="100" textAlign="center"  />');
			layoutStr.push('            <DataGridColumn dataField="STANDARD_NM"     headerText="용기구분"        width="100" textAlign="center"  />');
			layoutStr.push('			<DataGridColumn dataField="CPCT_NM"  	headerText="'+ parent.fn_text('cpct')+'"				width="140" 	textAlign="center"  />');
			layoutStr.push('			<DataGridColumn dataField="PRPS_NM"  	headerText="'+ parent.fn_text('prps_cd')+ '"		width="100"	textAlign="center"  />');
			layoutStr.push('				<DataGridColumn dataField="DLIVY_GTN" 	headerText="'+ parent.fn_text('std_dps')+ '" 	width="100" 	textAlign="right"    formatter="{numfmt}" id="sum1" />');
			layoutStr.push('				<DataGridColumn dataField="DLIVY_QTY" 	headerText="'+ parent.fn_text('dlivy_qty')+ '" 	width="100" 	textAlign="right"    formatter="{numfmt}" id="sum2" />');
			layoutStr.push('			<DataGridColumnGroup headerText="'+parent.fn_text('rtrvl_qty')+'">');
			layoutStr.push('				<DataGridColumn dataField="CFM_QTY" 	headerText="'+ parent.fn_text('rtn_qty3')+ '" 	width="140" 	textAlign="right"    formatter="{numfmt}" id="sum3" />');
			layoutStr.push('				<DataGridColumnGroup headerText="'+parent.fn_text('exch_data')+'">');
			layoutStr.push('					<DataGridColumn dataField="REQ_EXCH_QTY" 	headerText="'+ parent.fn_text('exch_dlivy_qty2')+ '" width="140" 	textAlign="right"    formatter="{numfmt}" id="sum4" />');
			layoutStr.push('					<DataGridColumn dataField="CFM_EXCH_QTY" 	headerText="'+ parent.fn_text('exch_wrhs_qty2')+ '" width="140" 	textAlign="right"    formatter="{numfmt}" id="sum5" />');
			layoutStr.push('				</DataGridColumnGroup>');
			layoutStr.push('				<DataGridColumn dataField="CFM_QTY_TOT" 	headerText="'+ parent.fn_text('rtn_qty4')+ '" width="140" 	textAlign="right"    formatter="{numfmt}" id="sum6" />');
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="소계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum3}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum4}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum5}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum6}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('			</DataGridFooter>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="총합계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('                <DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');	
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum2" formatter="{numfmt}" dataColumn="{sum2}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum3" formatter="{numfmt}" dataColumn="{sum3}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum4" formatter="{numfmt}" dataColumn="{sum4}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum5" formatter="{numfmt}" dataColumn="{sum5}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum6" formatter="{numfmt}" dataColumn="{sum6}" textAlign="right"/>');	
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
		
		var layoutCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			dataGrid.addEventListener("change", selectionChangeHandler);
			gridApp.setData();
			drawGridPagingNavigation(gridCurrentPage);  //페이징 표시
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

	/* 총합계 추가 */
	function totalsum1(column, data) {
		if(sumData) 
			return sumData.DLIVY_GTN; 
		else 
			return 0;
	}
	function totalsum2(column, data) {
		if(sumData) 
			return sumData.DLIVY_QTY; 
		else 
			return 0;
	}
	function totalsum3(column, data) {
		if(sumData) 
			return sumData.CFM_QTY; 
		else 
			return 0;
	}
	function totalsum4(column, data) {
		if(sumData) 
			return sumData.REQ_EXCH_QTY; 
		else 
			return 0;
	}
	function totalsum5(column, data) {
		if(sumData) 
			return sumData.CFM_EXCH_QTY; 
		else 
			return 0;
	}
	function totalsum6(column, data) {
		if(sumData) 
			return sumData.CFM_QTY_TOT; 
		else 
			return 0;
	}
	/* 총합계 추가 */
	
	/****************************************** 그리드 셋팅 끝***************************************** */


	
</script>

<style type="text/css">
	.srcharea .row .col .tit{width: 87px;}
	
	
.fa-close:before, .fa-times:before {
   content: "X"; 
   font-weight: 550;
 }
 .ax5autocomplete-display-table >div>a>div{
  margin-top: 8px;
 }
</style>

</head>
<body>

    <div class="iframe_inner" >
    
    		<input type="hidden" id="ctnrNmList" value="<c:out value='${ctnrNmList}' />" />
			<input type="hidden" id="whsdlBizrList" value="<c:out value='${whsdlBizrList}' />" />
			<input type="hidden" id="mfcBizrList" value="<c:out value='${mfcBizrList}' />" />
			<input type="hidden" id="ctnrSe" value="<c:out value='${ctnrSe}' />" />
			<input type="hidden" id="prpsCdList" value="<c:out value='${prpsCdList}' />" />
			<input type="hidden" id="alkndCdList" value="<c:out value='${alkndCdList}' />" />
			
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn" style="float:right" id="UR">
			</div>
		</div>
		<section class="secwrap"  id="params">
				<div class="srcharea" > 
					<div class="row" >
						<div class="col">
							<div class="tit" id="sel_term_txt"></div>
							<div class="box" style="width:380px">
								<div class="calendar">
									<input type="text" id="START_DT" name="from" style="width: 180px;" class="i_notnull" >
								</div>
								
								<div class="obj">~</div>
								
								<div class="calendar">
									<input type="text" id="END_DT" name="to" style="width: 180px;" class="i_notnull" >
								</div>
								
							</div>
						</div>					
					</div> <!-- end of row -->
					<div class="row">
						<div class="col">
							<div class="tit" id="ctnr_se_txt""></div>  <!-- 용도 -->
							<div class="box" style="width:380px">
                            	<select id="CTNR_SE" name="CTNR_SE" style="width:80px" class="i_notnull" ></select>
                            	<select id="STANDARD_YN" name="STANDARD_YN" style="width:80px" class="i_notnull" >
                                	<option value="">전체</option>
                                	<option class="generated" value="Y">표준용기</option>
                                	<option class="generated" value="N">비표준용기</option>
                                </select>
								<select id="PRPS_CD" name="PRPS_CD" style="width: 95px" class="i_notnull" ></select>
                                <select id="ALKND_CD" name="ALKND_CD" style="width:110px" class="i_notnull" ></select>
							</div>
						</div>
						<div class="col" >  <!-- 생산자 선택 -->
							<div class="tit" id="mfc_bizrnm_txt"></div>
							<div class="box">
								<select id="MFC_BIZRNM_SEL" name="MFC_BIZRNM_SEL" style="width: 179px"></select>
							</div>
						</div>
						<div class="btn" id="CR"></div>						
					</div><!-- end of row -->
				</div>  <!-- end of srcharea -->
			</section>
			
			<div class="boxarea mt15">
				<div id="gridHolder" style="height: 480px; background: #FFF;"></div>
			   	<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
			</div>
			<div class="h4group" >
						<h5 class="tit"  style="font-size: 16px;">
							&nbsp;※ 조회기간의 기준은 출고일자, 입고확인일자, 직접회수일자 및 교환확인일자 입니다.<br/>
						</h5>
			</div>
			<section class="btnwrap" style="" >
				<div class="btn" id="BL">
				</div>
				<div class="btn" style="float:right" id="BR"></div>
			</section>
		
	</div>
	
	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="excel" />
	</form>
	
	<form name="prtForm" id="prtForm">
		<input type="hidden" name="CRF_NAME" value="EPCE6657001.crf" />
		<input type="hidden" name="BILL_DOC_NO" value="" />
        <input type="hidden" name="MFC_BIZRID_NO" id="MFC_BIZRID_NO_CRF" value="" />
        <input type="hidden" name="START_DT" id="START_DT_CRF" value="" />
        <input type="hidden" name="END_DT" id="END_DT_CRF" value="" />
        <input type="hidden" name="CTNR_SE" id="CTNR_SE_CRF" value="" />
        <input type="hidden" name="PRPS_CD" id="PRPS_CD_CRF" value="" />
        <input type="hidden" name="ALKND_CD" id="ALKND_CD_CRF" value="" />
        <input type="hidden" name="STANDARD_YN" id="STANDARD_YN_CRF" value="" />
		<input type="hidden" name="S_USER_NM" id="S_USER_NM" value="${ssUserNm}"/>
		<input type="hidden" name="S_BIZR_NM" id="S_BIZR_NM" value="${ssBizrNm}"/>
	</form>
	
	<form name="prtForm3" id="prtForm3">
		<input type="hidden" name="CRF_NAME" value="EPCE6657001_2.crf" />
		<input type="hidden" name="BILL_DOC_NO" value="" />
        <input type="hidden" name="MFC_BIZRID_NO" id="MFC_BIZRID_NO_CRF" value="" />
        <input type="hidden" name="START_DT" id="START_DT_CRF" value="" />
        <input type="hidden" name="END_DT" id="END_DT_CRF" value="" />
        <input type="hidden" name="CTNR_SE" id="CTNR_SE_CRF" value="" />
        <input type="hidden" name="PRPS_CD" id="PRPS_CD_CRF" value="" />
        <input type="hidden" name="ALKND_CD" id="ALKND_CD_CRF" value="" />
        <input type="hidden" name="STANDARD_YN" id="STANDARD_YN_CRF" value="" />
		<input type="hidden" name="S_USER_NM" id="S_USER_NM" value="${ssUserNm}"/>
		<input type="hidden" name="S_BIZR_NM" id="S_BIZR_NM" value="${ssBizrNm}"/>
	</form>
	
		<div id="modal" class="searchModal"  style="display: none;">
		<div class="search-modal-content" >
			<h5> <img alt="" src="../../images/main/loading.gif"></h5>
		</div>
	</div>
</body>
</html>