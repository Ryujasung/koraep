<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>교환현황</title>
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
width: 240px; /* Could be more or less, depending on screen size */
border-radius:10px; 
}
</style>
<script type="text/javaScript" language="javascript" defer="defer">

	var sumData; /* 총합계 추가 */

	var INQ_PARAMS = []; //파라미터 데이터
    var ctnrSe;        //신구병
    var prpsCdList;    //용도
    var alkndCdList;   //주종

	/* 페이징 사용 등록 */
	gridRowsPerPage = 10;//1페이지에서 보여줄 행 수
	gridCurrentPage = 1;//현재 페이지
	gridTotalRowCount = 0;//전체 행 수
	var mfc_bizrnmList;//생산자
	var ctnrNmList
	
	//멀티select
	 var acSelected_M = new Array();//생산자
	 var acSelected_C = new Array();//용기코드
    $(function() {
    	var dtList = jsonObject($("#dtList").val());
        ctnrSe      = jsonObject($("#ctnrSe").val());
        prpsCdList  = jsonObject($("#prpsCdList").val());
        alkndCdList = jsonObject($("#alkndCdList").val());
    	
    	//버튼 셋팅
    	fn_btnSetting();
    	
    	kora.common.setEtcCmBx2(dtList, "","", $("#SEARCH_GBN"), "ETC_CD", "ETC_CD_NM", "N");//조회기간 선택
        kora.common.setEtcCmBx2(ctnrSe, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N", "T"); //빈용기구분
        kora.common.setEtcCmBx2(prpsCdList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');                                   //용도
        kora.common.setEtcCmBx2(alkndCdList, "","", $("#ALKND_CD"), "ETC_CD", "ETC_CD_NM", "N", "T"); //빈용기구분
    	
    	$('.row > .col > .tit').each(function(){
			$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
		});
    	
    	//그리드 셋팅
		fnSetGrid1();
		
		mfc_bizrnmList 	= jsonObject($("#mfcBizrList").val());
		ctnrNmList 		= jsonObject($("#ctnrNmList").val());
		kora.common.autoComplete(); //멀티 autoComplete
		
		//날짜 셋팅
	    $('#START_DT').YJcalendar({  
			toName : 'to',
			triggerBtn : true,
			dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
			
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
  		
	});
    
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
		input['fileName'] = fileName;
		input['columns'] = JSON.stringify(col);
		
		var url = "/CE/EPCE6109501_05.do";
		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
				alertMsg(rtnData.RSLT_MSG);
			}else{
				//파일다운로드
				frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
				frm.fileName.value = fileName;
				frm.submit();
			}
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
    	
		var url = "/CE/EPCE6109501_19.do";
		var input = {};
		 if(page !="P"){
			input['START_DT'] = $("#START_DT").val();
			input['END_DT'] = $("#END_DT").val();
			input["SEARCH_GBN"] = $("#SEARCH_GBN").val();
			input['CHART_YN'] = chartYn;
			input["MFC_LIST"] = JSON.stringify(acSelected_M);//생산자
			input["CTNR_LIST"] = JSON.stringify(acSelected_C);//빈용기
            input['CTNR_SE'] = $("#CTNR_SE option:selected").val();
            input['STANDARD_YN'] = $("#STANDARD_YN option:selected").val();
            input['PRPS_CD'] = $("#PRPS_CD option:selected").val();
            input['ALKND_CD'] = $("#ALKND_CD option:selected").val();
			//파라미터에 조회조건값 저장 
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
				
				if(chartYn == "Y"){ //조회버튼 클릭 시 챠트조회
					
					if(rtnData.searchList2 == undefined || rtnData.searchList2.length == 0){
						chartApp.setData(chartData);
					}else{
						chartApp.setData(rtnData.searchList2);
					}
					
					var reqExchQty = 0;
					var cfmExchQty = 0;
					var tot = 0;
					
					for(var i in rtnData.searchList2){
						reqExchQty += Number(rtnData.searchList2[i].REQ_EXCH_QTY);
						cfmExchQty += Number(rtnData.searchList2[i].CFM_EXCH_QTY);
					}
					
					$('#REQ_EXCH_QTY').text(kora.common.format_comma(reqExchQty));
					$('#CFM_EXCH_QTY').text(kora.common.format_comma(cfmExchQty));
					//$('#TOT').text(kora.common.format_comma(reqExchQty + cfmExchQty));
					
				}
				
				/* 페이징 표시 */
				gridTotalRowCount = parseInt(rtnData.totalList[0].CNT); //총 카운트 	/* 총합계 추가 */
				drawGridPagingNavigation(gridCurrentPage);
				
				sumData = rtnData.totalList[0]; /* 총합계 추가 */
				
			} else {
				alertMsg("error");
			}
// 			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
			$("#modal").hide();
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
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			layoutStr.push('		<groupedColumns>');   	
			layoutStr.push('			<DataGridColumn dataField="PNO" headerText="'+ parent.fn_text('sn')+ '" textAlign="center" width="50"   draggable="false"/>');							//순번
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM" headerText="'+ parent.fn_text('mfc_bizrnm')+ '" width="150" />');
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM" headerText="'+ parent.fn_text('ctnr_nm')+ '" width="200" />');
            layoutStr.push('            <DataGridColumn dataField="ALKND_NM" headerText="'+ parent.fn_text('alknd_cd')+ '" width="130" />');
            layoutStr.push('            <DataGridColumn dataField="STANDARD_NM"     headerText="용기구분"        width="100" textAlign="center"  />');
			layoutStr.push('			<DataGridColumn dataField="CPCT_NM" headerText="'+ parent.fn_text('cpct')+'"	width="200" />');
			layoutStr.push('			<DataGridColumn dataField="CFM_QTY" headerText="'+ parent.fn_text('wrhs_qty')+ '" width="130" textAlign="right" formatter="{numfmt}" id="sum1" />');
			layoutStr.push('			<DataGridColumn dataField="REQ_EXCH_QTY" headerText="'+ parent.fn_text('req_exch_qty')+ '" width="130" textAlign="right" formatter="{numfmt}" id="sum2" />');
			layoutStr.push('			<DataGridColumn dataField="CFM_EXCH_QTY" headerText="'+ parent.fn_text('cfm_exch_qty')+ '" width="130" textAlign="right" formatter="{numfmt}" id="sum3" />');
			layoutStr.push('			<DataGridColumn dataField="ADJ_WRHS_QTY" headerText="'+ parent.fn_text('adj_wrhs_qty')+'" width="130" textAlign="right" formatter="{numfmt}" id="sum4" />');
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="소계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum3}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum4}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('			</DataGridFooter>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="총합계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum1" formatter="{numfmt}" dataColumn="{sum1}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum2" formatter="{numfmt}" dataColumn="{sum2}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum3" formatter="{numfmt}" dataColumn="{sum3}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum4" formatter="{numfmt}" dataColumn="{sum4}" textAlign="right"/>');
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
			return sumData.CFM_QTY; 
		else 
			return 0;
	}
	function totalsum2(column, data) {
		if(sumData) 
			return sumData.REQ_EXCH_QTY; 
		else 
			return 0;
	}
	function totalsum3(column, data) {
		if(sumData) 
			return sumData.CFM_EXCH_QTY; 
		else 
			return 0;
	}
	function totalsum4(column, data) {
		if(sumData) 
			return sumData.ADJ_WRHS_QTY; 
		else 
			return 0;
	}
	/* 총합계 추가 */
	
	
	/****************************************** 그리드 셋팅 끝***************************************** */


	// -----------------------차트 설정 시작-----------------------
	 
	// rMate 차트 생성 준비가 완료된 상태 시 호출할 함수를 지정합니다.
	var chartVars = "rMateOnLoadCallFunction=chartReadyHandler";
	var layoutStrChart, chartApp;
	 
	// rMateChart 를 생성합니다.
	// 파라메터 (순서대로) 
	//  1. 차트의 id ( 임의로 지정하십시오. ) 
	//  2. 차트가 위치할 div 의 id (즉, 차트의 부모 div 의 id 입니다.)
	//  3. 차트 생성 시 필요한 환경 변수들의 묶음인 chartVars
	//  4. 차트의 가로 사이즈 (생략 가능, 생략 시 100%)
	//  5. 차트의 세로 사이즈 (생략 가능, 생략 시 100%)
	rMateChartH5.create("rChart", "chartHolder", chartVars, "100%", "100%"); 
	 
	// 차트의 속성인 rMateOnLoadCallFunction 으로 설정된 함수.
	// rMate 차트 준비가 완료된 경우 이 함수가 호출됩니다.
	// 이 함수를 통해 차트에 레이아웃과 데이터를 삽입합니다.
	// 파라메터 : id - rMateChartH5.create() 사용 시 사용자가 지정한 id 입니다.
	function chartReadyHandler(id) {
		chartApp = document.getElementById(id);
		chartApp.setLayout(layoutStrChart.join("").toString());
	}
	 
	// 스트링 형식으로 레이아웃 정의.
	
	layoutStrChart = new Array();
	layoutStrChart.push('<rMateChart backgroundColor="#FFFFFF"  borderStyle="none">');
	layoutStrChart.push('    <Options>');
	//layoutStrChart.push('        <Caption text=""/>');
	//layoutStrChart.push('         <SubCaption text="" textAlign="right" />');
	layoutStrChart.push('        <Legend defaultMouseOverAction="false" useVisibleCheck="false"/>');
	layoutStrChart.push('    </Options>');
	layoutStrChart.push('  <NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
	layoutStrChart.push('   <Column3DChart showDataTips="true" cubeAngleRatio="1" columnWidthRatio="0.7" >');
	layoutStrChart.push('       <horizontalAxis>');
	layoutStrChart.push('             <CategoryAxis categoryField="BIZRNM" id="hAxis"/>');
	layoutStrChart.push('       </horizontalAxis>');
	layoutStrChart.push('<horizontalAxisRenderers>');
	layoutStrChart.push('<Axis3DRenderer axis="{hAxis}" canDropLabels="false"   styleName="axisLabel"  />'); //hAxis의 ID적용 및 canDropLabels 설정
	layoutStrChart.push('</horizontalAxisRenderers>'); 
	layoutStrChart.push('        <verticalAxis>');
	layoutStrChart.push('           <LinearAxis formatter="{numfmt}" />');
	layoutStrChart.push('       </verticalAxis>');
	layoutStrChart.push('          <series>');
	layoutStrChart.push('             <Column3DSeries labelPosition="outside" yField="REQ_EXCH_QTY" displayName="요청교환량" outsideLabelYOffset="-10" showValueLabels="[]" showTotalLabel="true" halfWidthOffset="0" itemRenderer="CylinderItemRenderer">');
	layoutStrChart.push('                  <showDataEffect>');
	layoutStrChart.push('                     <SeriesInterpolate/>');
	layoutStrChart.push('                </showDataEffect>');
	layoutStrChart.push('            </Column3DSeries>');
	layoutStrChart.push('            <Column3DSeries labelPosition="outside" yField="CFM_EXCH_QTY" displayName="확인교환량" outsideLabelYOffset="-10" showValueLabels="[]"  showTotalLabel="true" halfWidthOffset="0" itemRenderer="CylinderItemRenderer">');
	layoutStrChart.push('                <showDataEffect>');
	layoutStrChart.push('                     <SeriesInterpolate/>');
	layoutStrChart.push('                </showDataEffect>');
	layoutStrChart.push('            </Column3DSeries>');
	layoutStrChart.push('        </series>');
	layoutStrChart.push('    </Column3DChart>');
	layoutStrChart.push('<Style>.axisLabel{fontSize:10px;colorFill:#ff0000;}');  
	layoutStrChart.push('</Style>');
	layoutStrChart.push(' </rMateChart>');
	 
	// 차트 데이터
	var chartData = [{BIZRNM:"", REQ_EXCH_QTY:0, CFM_EXCH_QTY:0}];
	 
	/**
	 * rMateChartH5 3.0이후 버전에서 제공하고 있는 테마기능을 사용하시려면 아래 내용을 설정하여 주십시오.
	 * 테마 기능을 사용하지 않으시려면 아래 내용은 삭제 혹은 주석처리 하셔도 됩니다.
	 *
	 * -- rMateChartH5.themes에 등록되어있는 테마 목록 --
	 * - simple
	 * - cyber
	 * - modern
	 * - lovely
	 * - pastel
	 * -------------------------------------------------
	 *
	 * rMateChartH5.themes 변수는 theme.js에서 정의하고 있습니다.
	 */
	rMateChartH5.registerTheme(rMateChartH5.themes);
	 
	/**
	 * 샘플 내의 테마 버튼 클릭 시 호출되는 함수입니다.
	 * 접근하는 차트 객체의 테마를 변경합니다.
	 * 파라메터로 넘어오는 값
	 * - simple
	 * - cyber
	 * - modern
	 * - lovely
	 * - pastel
	 * - default
	 *
	 * default : 테마를 적용하기 전 기본 형태를 출력합니다.
	 */
	function rMateChartH5ChangeTheme(theme){
		 chartApp.setTheme(theme);
	}
	 
	// -----------------------차트 설정 끝 -----------------------

</script>

<style type="text/css">
	.srcharea .row .col .tit{width: 84px;}
</style>

</head>
<body>
    <div class="iframe_inner" >
   			<input type="hidden" id="mfcBizrList" value="<c:out value='${mfcBizrList}' />" />
			<input type="hidden" id="ctnrNmList" value="<c:out value='${ctnrNmList}' />" />
			<input type="hidden" id="dtList" value="<c:out value='${dtList}' />" />
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
						<div class="col"  >
							<div class="tit" id="sel_term_txt"></div>
							<div class="box">
								<select id="SEARCH_GBN"  style="width: 158px; margin-right: 10px"></select>
								<div class="calendar">
									<input type="text" id="START_DT" name="from" style="width: 139px;" class="i_notnull"><!--시작날짜  -->
								</div>
								<div class="obj">~</div>
								<div class="calendar">
									<input type="text" id="END_DT" name="to" style="width: 139px;"	class="i_notnull"><!-- 끝날짜 -->
								</div>
							</div>
						</div>
						<div class="col">
							<div class="tit" id="mfc_bizrnm_txt" ></div> 
							<div class="box">
								<div data-ax5autocomplete="autocomplete" data-ax5autocomplete-config="{multiple: true}" style="max-width :500px; z-index: 0;"  id="data-ax5autocomplete_M" ></div>
							</div>
						</div>
					</div> <!-- end of row -->
					<div class="row" >
                        <div class="col" style="width: 50%;">
                            <div class="tit" id="ctnr_se_txt"></div>  <!-- 용도 -->
                            <div class="box">
                                <select id="CTNR_SE" name="CTNR_SE" style="width:80px" class="i_notnull" ></select>
                                <select id="STANDARD_YN" name="STANDARD_YN" style="width:80px" class="i_notnull" >
                                	<option value="">전체</option>
                                	<option class="generated" value="Y">표준용기</option>
                                	<option class="generated" value="N">비표준용기</option>
                                </select>
                                <select id="PRPS_CD" name="PRPS_CD" style="width:169px" class="i_notnull" ></select>
                                <select id="ALKND_CD" name="ALKND_CD" style="width:110px" class="i_notnull" ></select>
                            </div>
                        </div>
						<div class="col" >
							<div class="tit" id="ctnr_nm_txt""></div>
							<div class="box"  >
								<div data-ax5autocomplete="autocomplete" data-ax5autocomplete-config="{multiple: true}" style="max-width :500px; z-index: 0;"  id="data-ax5autocomplete_C" ></div> 
							</div>
						</div>
						<div class="btn" id="CR"></div>
					</div><!-- end of row -->
				</div>  <!-- end of srcharea -->
			</section>
			
			<section class="secwrap2 mt15">
				<div class="boxarea" style="width:25%;margin:0px;">
					<div class="info_tbl" style="">
						<table>
							<colgroup>
								<col style="width: 50%;">
								<col style="width: 50%;">
							</colgroup>
							<thead>
								<tr>
									<th colspan="2" class="b">교환량</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>요청교환량</td>
									<td>확인교환량</td>
								</tr>
								<tr>
									<td id="REQ_EXCH_QTY"></td>
									<td id="CFM_EXCH_QTY"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div style="width:75%;height:300px;float:right;padding:0 20px 0 15px;margin:0px">
					<!-- 차트가 삽입될 DIV -->
					<div id="chartHolder" style="height:300px"></div>
				</div>
			</section>
			
			<div class="boxarea mt15">
				<div id="gridHolder" style="height: 410px; background: #FFF;"></div>
			   	<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
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
		<div id="modal" class="searchModal"  style="display: none;">
		<div class="search-modal-content" >
			<h5> <img alt="" src="../../images/main/loading.gif"></h5>
		</div>
	</div>
</body>
</html>