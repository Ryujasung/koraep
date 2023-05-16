<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>직접회수정정</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>

<script type="text/javaScript" language="javascript" defer="defer" >

	 	/* 페이징 사용 등록 */
		gridRowsPerPage = 2000;	// 1페이지에서 보여줄 행 수
		gridCurrentPage = 1;	// 현재 페이지
		gridTotalRowCount = 0; //전체 행 수
		
		var INQ_PARAMS; //파라미터 데이터
		var stdMgntList;
		
		var sumData; /* 총합계 추가 */
		
		$(document).ready(function(){
			
			INQ_PARAMS 	=  jsonObject($("#INQ_PARAMS").val());	
			stdMgntList	=  jsonObject($("#stdMgntList").val());       
			
			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			
			//버튼 셋팅
		    fn_btnSetting();
		    
			//그리드 셋팅
		    fnSetGrid1();  
			
			var statList = ${statList}; //
		    var mfcSeCdList 	= ${mfcSeCdList}; //
		    kora.common.setEtcCmBx2(stdMgntList, "","", $("#EXCA_STD_CD"), "EXCA_STD_CD", "EXCA_STD_NM", "N" ,'S');
		    for(var k=0; k<stdMgntList.length; k++){ 
		    	if(stdMgntList[k].EXCA_STAT_CD == 'S'){
		    		$('#EXCA_STD_CD').val(stdMgntList[k].EXCA_STD_CD);
		    		break;
		    	}
		    }
		    
		    kora.common.setEtcCmBx2(mfcSeCdList, "", "", $("#MFC_BIZR_SEL"), "BIZRID_NO", "BIZRNM", "N", "T");
		    kora.common.setEtcCmBx2(statList, "","", $("#DRCT_RTRVL_CRCT_STAT_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');
		    
		    var brchList = ${brchList};
			var ctnrList = ${ctnrList};
		    kora.common.setEtcCmBx2(brchList, "","", $("#MFC_BRCH_SEL"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');
		    kora.common.setEtcCmBx2(ctnrList, "","", $("#CTNR_CD_SEL"), "CTNR_CD", "CTNR_NM", "N" ,'T');

		    
			/************************************
			 * 조회버튼 클릭 이벤트
			 ***********************************/
			$("#btn_sel").click(function(){
				//조회버튼 클릭시 페이징 초기화
				gridCurrentPage = 1;
				fn_sel();
			});
			
			//등록
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			//수정
			$("#btn_upd").click(function(){
				fn_upd();
			});
			
			//삭제
			$("#btn_del").click(function(){
				fn_del();
			});
			
			//확인
			$("#btn_upd2").click(function(){
				fn_upd2();
			});
			
			//확인취소
			$("#btn_upd3").click(function(){
				fn_upd3();
			});
			
			//반려
			$("#btn_upd4").click(function(){
				fn_upd4();
			});
			
			/************************************
			 * 생산자명 변경 이벤트
			 ***********************************/
			 $("#MFC_BIZR_SEL").change(function(){
				fn_bizrTpCd();
			 });
									
			 /************************************
			 * 엑셀다운로드 버튼 클릭 이벤트
			 ***********************************/
			 $("#btn_excel").click(function() {
				 fn_excel();
			 });
			
			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
				/* 화면이동 페이징 셋팅 */
				gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
				
			}
			
		});
		
		var dlivyCrctStatCd = '';
		//확인
		function fn_upd2(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				
				if(item.DRCT_RTRVL_CRCT_STAT_CD != 'R' ){
					alertMsg("정정등록 건만 처리 가능합니다.");
					return;
				}
			}
			
			dlivyCrctStatCd = 'C';

			confirm('확인 처리하시겠습니까?', "fn_upd_exec");
		}
		
		//확인취소
		function fn_upd3(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				
				if(item.DRCT_RTRVL_CRCT_STAT_CD != 'C' ){
					alertMsg("정정확인 건만 처리 가능합니다.");
					return;
				}
			}
			
			dlivyCrctStatCd = 'R';

			confirm('확인취소 처리하시겠습니까?', "fn_upd_exec");
		}
		
		//반려
		function fn_upd4(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				
				if(item.DRCT_RTRVL_CRCT_STAT_CD != 'R' ){
					alertMsg("정정등록 건만 처리 가능합니다.");
					return;
				}
			}
			
			dlivyCrctStatCd = 'T';

			confirm('반려 처리하시겠습니까?', "fn_upd_exec");
		}
		
		function fn_upd_exec(){
			
			var data = {};
			var row = new Array();
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(item);
			}
			
			data["list"] = JSON.stringify(row);
			data["DRCT_RTRVL_CRCT_STAT_CD"] = dlivyCrctStatCd;

			var url = "/CE/EPCE4763601_21.do";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_sel');
				} else {
					alertMsg("error");
				}
			});
		}
		
		//삭제
		function fn_del(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				
				if(item.DRCT_RTRVL_CRCT_STAT_CD != 'R' && item.DRCT_RTRVL_CRCT_STAT_CD != 'T'){
					alertMsg("정정등록, 정정반려 건만 삭제 가능합니다.");
					return;
				}
			}

			confirm('삭제하시겠습니까?', "fn_del_exec");
		}
		
		function fn_del_exec(){
			
			var data = {};
			var row = new Array();
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(item);
			}
			
			data["list"] = JSON.stringify(row);

			var url = "/CE/EPCE4763601_04.do";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_sel');
				} else {
					alertMsg("error");
				}
			});
		}
		
		/**
		 * 변경화면 이동
		 */
		function fn_upd(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}
			
			if(chkLst.length > 1){
				alertMsg("한건만 선택이 가능합니다.");
				return;
			}
			
			var item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[0]);
			
			if(item.DRCT_RTRVL_CRCT_STAT_CD != 'R' && item.DRCT_RTRVL_CRCT_STAT_CD != 'T'){
				alertMsg("정정등록, 정정반려 건만 수정 가능합니다.");
				return;
			}
			
			INQ_PARAMS["PARAMS"] = item;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE4763601.do";
			kora.common.goPage('/CE/EPCE4763642.do', INQ_PARAMS);
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
			
			var url = "/CE/EPCE4763601_05.do";
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
		
		
	//생산자명 변경시
	function fn_bizrTpCd(){
		
		var url = "/CE/EPCE4763601_192.do" 
		var input ={};
		
	    input["BIZRID_NO"] = $("#MFC_BIZR_SEL").val();
	    //input["BRCH_ID_NO"] = $("#MFC_BRCH_SEL").val();

   	    ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {
				kora.common.setEtcCmBx2(rtnData.brchList, "","", $("#MFC_BRCH_SEL"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');
				kora.common.setEtcCmBx2(rtnData.ctnrList, "","", $("#CTNR_CD_SEL"), "CTNR_CD", "CTNR_NM", "N" ,'T');
			} else {
				alertMsg("error");
			}
   		}, false);

	}
			
	//조회
	function fn_sel(){

		var input ={}
		var url ="/CE/EPCE4763601_19.do";
		
		input["EXCA_STD_CD"] = $("#EXCA_STD_CD").val();
		input["DRCT_RTRVL_CRCT_STAT_CD"] = $("#DRCT_RTRVL_CRCT_STAT_CD").val();
		input["MFC_BIZR_SEL"] = $("#MFC_BIZR_SEL").val();
		input["MFC_BRCH_SEL"] = $("#MFC_BRCH_SEL").val();
		input["CTNR_CD_SEL"] = $("#CTNR_CD_SEL").val();
		
		/* 페이징  */
		input["ROWS_PER_PAGE"] = gridRowsPerPage;
		input["CURRENT_PAGE"] 	= gridCurrentPage;
		
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["SEL_PARAMS"] = input;
		
		kora.common.showLoadingBar(dataGrid, gridRoot);
		ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {   
				gridApp.setData(rtnData.searchList);
				
				/* 페이징 표시 */
				gridTotalRowCount = parseInt(rtnData.totalList[0].CNT); //총 카운트 	/* 총합계 추가 */
				drawGridPagingNavigation(gridCurrentPage);
				
				sumData = rtnData.totalList[0]; /* 총합계 추가 */
				
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
	
	//등록 화면으로 이동
	function fn_reg(){
		
		if($("#EXCA_STD_CD").val() == ''){
			alertMsg('정산기간 선택은 필수입니다. ');
			return;
		}
		
		for(var k=0; k<stdMgntList.length; k++){ 
	    	if(stdMgntList[k].EXCA_STD_CD ==  $("#EXCA_STD_CD option:selected").val()){
	    		if(stdMgntList[k].EXCA_YN == 'N'){
	    			alertMsg("진행중인 정산기간이 아닙니다.");
	    			return;
	    		}
	    	}
	    }
				
		var input = {};
		input['EXCA_STD_CD'] = $("#EXCA_STD_CD").val().split(';')[0];
		
		INQ_PARAMS["PARAMS" ] = input;
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE4763601.do";
		kora.common.goPage('/CE/EPCE4763631.do', INQ_PARAMS);
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
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" horizontalScrollPolicy="on"  draggableColumns="true" headerHeight="35" sortableColumns="true">');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridSelectorColumn id="selector" width="40" textAlign="center" allowMultipleSelection="true" vertical-align="middle"  draggable="false" />');
			layoutStr.push('			<DataGridColumn dataField="PNO" 				 				headerText="'+ parent.fn_text('sn')+ '" textAlign="center" width="50"   draggable="false"/>');
			layoutStr.push('			<DataGridColumn dataField="DRCT_RTRVL_DT"  headerText="'+ parent.fn_text('drct_rtrvl_dt') +'" textAlign="center" width="100" formatter="{datefmt2}"/>');
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM"  headerText="'+ parent.fn_text('mfc_bizrnm')+ '" textAlign="center" width="180"/>'); 
			layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_NM"  headerText="'+ parent.fn_text('mfc_brch_nm')+ '" textAlign="center" width="180"/>');
			layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNM"  headerText="'+ parent.fn_text('cust')+ '" textAlign="center" width="180"/>');
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM"  headerText="'+ parent.fn_text('ctnr_nm')+ '" textAlign="center" width="180"/>');
			layoutStr.push('			<DataGridColumn dataField="PRPS_NM"  headerText="'+ parent.fn_text('prps_cd')+ '" textAlign="center" width="100"/>');
			layoutStr.push('			<DataGridColumn dataField="CPCT_NM"  headerText="'+ parent.fn_text('cpct_cd')+ '" textAlign="center" width="100"/>');
			layoutStr.push('			<DataGridColumn dataField="DRCT_RTRVL_QTY" id="num1"  headerText="'+ parent.fn_text('drct_rtrvl_qty')+ '" textAlign="right" width="100" formatter="{numfmt}"/>');
			layoutStr.push('			<DataGridColumn dataField="DRCT_PAY_GTN" id="num2"  headerText="'+ parent.fn_text('drct_rtrvl_gtn')+ '" textAlign="right" width="110" formatter="{numfmt}"/>');
			layoutStr.push('			<DataGridColumn dataField="DRCT_PAY_FEE" id="num3"  headerText="'+ parent.fn_text('drct_rtrvl_fee')+ '" textAlign="right" width="110" formatter="{numfmt}"/>');
			layoutStr.push('			<DataGridColumn dataField="DRCT_RTRVL_CRCT_STAT_NM"  headerText="'+ parent.fn_text('stat')+ '" textAlign="center" width="100" id="tmp1"/>');
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn label="소계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp1}"/>');
			layoutStr.push('			</DataGridFooter>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">'); /* 총합계 추가 */
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn label="총합계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum1" formatter="{numfmt}" dataColumn="{num1}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum2" formatter="{numfmt}" dataColumn="{num2}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum3" formatter="{numfmt}" dataColumn="{num3}"  textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp1}"/>');
			layoutStr.push('			</DataGridFooter>'); /* 총합계 추가 */
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

		var layoutCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			selectorColumn = gridRoot.getObjectById("selector");
			dataGrid.addEventListener("change", selectionChangeHandler);

			 //파라미터 call back function 실행
			 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
			 	eval(INQ_PARAMS.FN_CALLBACK+"()");
			 }else{
				 gridApp.setData();
				 
				/* 페이징 표시 */
				drawGridPagingNavigation(gridCurrentPage);
				
			 }
		}
		var dataCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
		}
		var selectionChangeHandler = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		
	}

	/* 총합계 추가 */
	function totalsum1(column, data) {
		if(sumData) 
			return sumData.DRCT_RTRVL_QTY; 
		else 
			return 0;
	}
	
	function totalsum2(column, data) {
		if(sumData) 
			return sumData.DRCT_PAY_GTN; 
		else 
			return 0;
	}
	
	function totalsum3(column, data) {
		if(sumData) 
			return sumData.DRCT_PAY_FEE; 
		else 
			return 0;
	}
	/* 총합계 추가 */
	
   /****************************************** 그리드 셋팅 끝***************************************** */
	</script>
	
	<style type="text/css">

		.srcharea .row .col .tit{
		width: 82px;
		}

	</style>
	
	</head>
	<body>
  	<div class="iframe_inner"  id="testee" >
		    <input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="stdMgntList" value="<c:out value='${stdMgntList}' />" />
			<div class="h3group">
				<h3 class="tit" id="title"></h3>
				<div class="btn" style="float:right" id="UR">
			</div>
		</div>
		<section class="secwrap">
				<div class="srcharea" id="sel_params">
					<div class="row">
						<div class="col" >
							<div class="tit" id="exca_term_txt"></div>
							<div class="box">
								<select style="width: 180px;" id="EXCA_STD_CD"></select>
							</div>
						</div>
						<div class="col" >
							<div class="tit" id="stat_txt" ></div>
							<div class="box">
								<select style="width: 180px;" id="DRCT_RTRVL_CRCT_STAT_CD"></select>
							</div>
						</div>
						<div class="col">
							<div class="tit" id="ctnr_nm_txt" style="width:120px"></div>
							<div class="box">
								<select style="width: 180px;" id="CTNR_CD_SEL"></select>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col" >
							<div class="tit" id="mfc_bizrnm_txt" ></div>
							<div class="box">
								<select id="MFC_BIZR_SEL" style="width: 179px"></select>
							</div>
						</div>
						<div class="col">
							<div class="tit" id="mfc_brch_nm_txt"></div> 
							<select style="width: 180px;" id="MFC_BRCH_SEL"></select>
						</div>
						<div class="col">
							<div class="tit" id="cust_bizr_no_txt" style="width:120px"></div>
							<div class="box">
								<input type="text" id="CUST_BIZRNO_SEL" style="width: 180px;">
							</div>
						</div>
						<div class="btn" id="CR">
						</div>
					</div>		
				</div>		<!-- end of srcharea --> 
		</section>
		<section class="btnwrap mt10"  >
				<div class="btn" id="CL"></div>
		</section>
		<div class="boxarea mt10">
			<!-- 그리드 셋팅 -->
			<div id="gridHolder" style="height: 650px; background: #FFF;"></div>
			<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
		</div>

		<section class="btnwrap" >
			<div class="btn" style="float:left" id="BL"></div>
			<div class="btn" style="float:right" id="BR"></div>
		</section>

	</div> <!-- end of  iframe_inner -->
	
	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="excel" />
	</form>

</body>
</html>

		