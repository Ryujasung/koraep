<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
		
		var INQ_PARAMS;
	
		$(document).ready(function(){
			
			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			
			fn_btnSetting();
			
			$('#sel_term').text(parent.fn_text('sel_term'));
			$('#mfc_bizrnm').text(parent.fn_text('mfc_bizrnm'));
			$('#dlivy_info').text(parent.fn_text('dlivy_info'));
			$('#fee_bill_issu_data').text(parent.fn_text('fee_bill_issu_data'));
			$('#drct_rtrvl_data').text(parent.fn_text('drct_rtrvl_data'));
			
			//날짜 셋팅
		    $('#START_DT_SEL').YJcalendar({  
				toName : 'to',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -2, false).replaceAll('-','')
				
			});
			$('#END_DT_SEL').YJcalendar({
				fromName : 'from',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
			});
			
			var bizrList =jsonObject($('#bizrList').val());
			/*
			var brchList = {brchList};
			var rtnStatList = {rtnStatList};
			*/
			kora.common.setEtcCmBx2(bizrList, "", "", $("#MFC_BIZR_SEL"), "BIZRID_NO", "BIZRNM", "N", "T");
			/*
			kora.common.setEtcCmBx2(brchList, "", "", $("#MFC_BRCH_SEL"), "BRCH_ID_NO", "BRCH_NM", "N" ,"T");
			kora.common.setEtcCmBx2(rtnStatList, "", "", $("#DLIVY_STAT_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			*/
			
			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
			}
			
			//그리드 셋팅
			fn_set_grid();
			fn_set_grid2();
			fn_set_grid3();
			
			$("#btn_sel").click(function(){
				fn_sel();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			/************************************
			 * 생산자 변경 이벤트
			 ***********************************/
			 $("#MFC_BIZR_SEL").change(function(){
					//fn_bizr();
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
					
					if(columns[i].getDataField() == 'BIZRNM_PAGE'){// html 태크 사용중 컬럼은 대체
						item['dataField'] = 'BIZRNM';
					}else{
						item['dataField'] = columns[i].getDataField();
					}
					
					item['textAlign'] = columns[i].getStyle('textAlign');
					item['id'] = kora.common.null2void(columns[i].id);
					
					col.push(item);
				}
			}
			
			var input = INQ_PARAMS["SEL_PARAMS"];
			input['fileName'] = fileName;
			input['columns'] = JSON.stringify(col);
			
			var url = "/CE/EPCE2351901_05.do";
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
		
		function fn_reg(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}
			
			confirm("선택된 내역에 대해 보증금 고지서를 발급하시겠습니까?", "fn_reg_exec");

		}
		
		function fn_reg_exec(){
			
			var data = {};
			var row = new Array();
			var row2 = new Array();
			var row3 = new Array();
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(item);
			}
			for(var i=0; i<selectorColumn2.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot2.getItemAt(selectorColumn2.getSelectedIndices()[i]);
				row2.push(item);
			}
			for(var i=0; i<selectorColumn3.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot3.getItemAt(selectorColumn3.getSelectedIndices()[i]);
				row3.push(item);
			}
			
			data["list"] = JSON.stringify(row);
			data["list2"] = JSON.stringify(row2);
			data["list3"] = JSON.stringify(row3);

			document.body.style.cursor = "wait";
			
			var url = "/CE/EPCE2351901_09.do";
			ajaxPost(url, data, function(rtnData){
				
				document.body.style.cursor = "default";
				
				if ("" != rtnData && null != rtnData){
					if(rtnData.RSLT_CD == '0000'){
						alertMsg(rtnData.RSLT_MSG, 'fn_sel');
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
				} else {
					alertMsg("error");
				}
			});
		}
		
		/**  
		 * 목록조회
		 */
		function fn_sel(){

			//날짜 정합성 체크
			if(!kora.common.fn_validDate($("#START_DT_SEL").val()) || !kora.common.fn_validDate($("#END_DT_SEL").val())){ 
				alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
				return; 
			}

			if($("#START_DT_SEL").val().replace(/-/g,"") < "20160121"){
				alertMsg("오픈일 이전 자료는 조회할 수 없습니다.");
				$("#START_DT_SEL").focus();
				return;
			}
			
			var url = "/CE/EPCE2351901_19.do";
			var input = {};
			
			input['START_DT_SEL'] = $("#START_DT_SEL").val();
			input['END_DT_SEL'] = $("#END_DT_SEL").val();
			//input['DLIVY_STAT_CD_SEL'] = $("#DLIVY_STAT_CD_SEL option:selected").val();
			input['MFC_BIZR_SEL'] = $("#MFC_BIZR_SEL option:selected").val();
			//input['MFC_BRCH_SEL'] = $("#MFC_BRCH_SEL option:selected").val();
			
			//파라미터에 조회조건값 저장 
			INQ_PARAMS["SEL_PARAMS"] = input; 
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			kora.common.showLoadingBar(dataGrid2, gridRoot2);// 그리드 loading bar on
			kora.common.showLoadingBar(dataGrid3, gridRoot3);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.searchList);
					gridApp2.setData(rtnData.searchList2);
					gridApp3.setData(rtnData.searchList3);
				} else {
					alertMsg("error");
				}
			}, false);
			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
			kora.common.hideLoadingBar(dataGrid2, gridRoot2);// 그리드 loading bar off
			kora.common.hideLoadingBar(dataGrid3, gridRoot3);// 그리드 loading bar off
		}
		
		function fn_bizr(){
			
			var url = "/SELECT_BRCH_LIST.do" 
			var input ={};
		    input["BIZRID_NO"] =$("#MFC_BIZR_SEL").val();

       	    ajaxPost(url, input, function(rtnData) {
       	    	if (null != rtnData) {   
   					kora.common.setEtcCmBx2(rtnData, "","", $("#MFC_BRCH_SEL"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');
   				} else {
   					alertMsg("error");
   				}
    		});
	       	    
		}
		
		//출고정보 상세화면 이동
		function fn_page(){

			var idx = dataGrid.getSelectedIndices();
			var input = gridRoot.getItemAt(idx);
			
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE2351901.do"; 
			kora.common.goPage('/CE/EPCE66582642.do', INQ_PARAMS);
		}
		
		//취급수수료고지서 상세화면 이동
		function fn_page2(){

			var idx = dataGrid2.getSelectedIndices();
			var input = gridRoot2.getItemAt(idx);
			
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE2351901.do"; 
			kora.common.goPage('/CE/EPCE23930642.do', INQ_PARAMS);
		}
		
		//직접회수 상세화면 이동
		function fn_page3(){

			var idx = dataGrid3.getSelectedIndices();
			var input = gridRoot3.getItemAt(idx);
			
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE2351901.do"; 
			kora.common.goPage('/CE/EPCE66452642.do', INQ_PARAMS);
		}
		
		/**
		 * 그리드 관련 변수 선언
		 */
	    var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
		var gridApp, gridRoot, dataGrid, layoutStr, selectorColumn;
		var layoutStr = new Array();
		var rowIndex;
		
		/**
		 * 메뉴관리 그리드 셋팅
		 */
		 function fn_set_grid() {
			 
			 rMateGridH5.create("grid", "gridHolder", jsVars, "100%", "100%");
			 layoutStr.push('<rMateGrid>');
			 layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			 layoutStr.push('<groupedColumns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="true" headerText="" width="40" verticalAlign="middle" />');
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" width="50"/>');
			 layoutStr.push('	<DataGridColumn dataField="STD_YEAR"  headerText="'+parent.fn_text('std_year')+'" width="100" />');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNM_PAGE"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="200" itemRenderer="HtmlItem" />');
			 layoutStr.push('	<DataGridColumn dataField="DLIVY_QTY_TOT" id="sum1" headerText="'+parent.fn_text('qty')+'" width="150" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="DLIVY_GTN_TOT" id="sum2" headerText="'+parent.fn_text('gtn')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="DLIVY_STAT_NM" headerText="'+parent.fn_text('se')+'" width="150"/>');
			 layoutStr.push('</groupedColumns>');
			 layoutStr.push('	<footers>');
			 layoutStr.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('		</DataGridFooter>');
			 layoutStr.push('	</footers>');
			 layoutStr.push('</DataGrid>');
			 layoutStr.push('</rMateGrid>');
		}

		// 그리드 및 메뉴 리스트 세팅
		 function gridReadyHandler(id) {
		 	 gridApp = document.getElementById(id);  // 그리드를 포함하는 div 객체
		     gridRoot = gridApp.getRoot();   // 데이터와 그리드를 포함하는 객체
		     gridApp.setLayout(layoutStr.join("").toString());

		     var layoutCompleteHandler = function(event) {
		         dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		         selectorColumn = gridRoot.getObjectById("selector");
		         dataGrid.addEventListener("change", selectionChangeHandler); //이벤트 등록
				 gridApp.setData();
		     }
		     var selectionChangeHandler = function(event) {
				rowIndex = event.rowIndex;
			 }
		     var dataCompleteHandler = function(event) {
		 	 }
		     
		     gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
		
		 /**
		 * 그리드 관련 변수 선언
		 */
	    var jsVars2 = "rMateOnLoadCallFunction=gridReadyHandler2";
		var gridApp2, gridRoot2, dataGrid2, layoutStr2, selectorColumn2;
		var layoutStr2 = new Array();
		
		/**
		 * 그리드 셋팅
		 */
		 function fn_set_grid2() {
						 
			 rMateGridH5.create("grid2", "gridHolder2", jsVars2, "100%", "100%");
			 
			 layoutStr2.push('<rMateGrid>');
			 layoutStr2.push('<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			 layoutStr2.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg2" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			 layoutStr2.push('<groupedColumns>');
			 layoutStr2.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="true" headerText="" width="40" verticalAlign="middle" />');
			 layoutStr2.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" width="50"/>');
			 layoutStr2.push('	<DataGridColumn dataField="BILL_ISSU_DT_PAGE"  headerText="'+parent.fn_text('issu_dt')+'" width="100" itemRenderer="HtmlItem" />');
			 layoutStr2.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150" />');
			 layoutStr2.push('	<DataGridColumn dataField="WRHS_QTY" id="sum1" headerText="'+parent.fn_text('wrhs_qty')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr2.push('	<DataGridColumn dataField="WRHS_NOTY_AMT" id="sum2" headerText="'+parent.fn_text('noty_amt')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr2.push('	<DataGridColumn dataField="ADD_BILL_REFN_GTN" id="sum3" headerText="'+parent.fn_text('pay_plan_gtn')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr2.push('</groupedColumns>');
			 layoutStr2.push('	<footers>');
			 layoutStr2.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr2.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
			 layoutStr2.push('			<DataGridFooterColumn/>');
			 layoutStr2.push('			<DataGridFooterColumn/>');
			 layoutStr2.push('			<DataGridFooterColumn/>');
			 layoutStr2.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr2.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr2.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum3}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr2.push('		</DataGridFooter>');
			 layoutStr2.push('	</footers>');
			 layoutStr2.push('</DataGrid>');
			 layoutStr2.push('</rMateGrid>');
		}
		
		// 그리드 및 메뉴 리스트 세팅
		 function gridReadyHandler2(id) {
		 	 gridApp2 = document.getElementById(id);  // 그리드를 포함하는 div 객체
		     gridRoot2 = gridApp2.getRoot();   // 데이터와 그리드를 포함하는 객체
		     gridApp2.setLayout(layoutStr2.join("").toString());
		     
		     var layoutCompleteHandler = function(event) {
		         dataGrid2 = gridRoot2.getDataGrid();  // 그리드 객체
		         dataGrid2.addEventListener("change", selectionChangeHandler); //이벤트 등록
		         gridApp2.setData([]);
		     }
		     var selectionChangeHandler = function(event) {
				var rowIndex2 = event.rowIndex;
			 }
		     var dataCompleteHandler = function(event) {
		     	selectorColumn2 = gridRoot2.getObjectById("selector");
		 	 }
		     
		     gridRoot2.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot2.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
		
		 /**
		 * 그리드 관련 변수 선언
		 */
	    var jsVars3 = "rMateOnLoadCallFunction=gridReadyHandler3";
		var gridApp3, gridRoot3, dataGrid3, layoutStr3, selectorColumn3;
		var layoutStr3 = new Array();
		var rowIndex3;
		
		/**
		 * 그리드 셋팅
		 */
		 function fn_set_grid3() {
			 
			 rMateGridH5.create("grid3", "gridHolder3", jsVars3, "100%", "100%");
			 
			 layoutStr3.push('<rMateGrid>');
			 layoutStr3.push('<DateFormatter id="datefmt" formatString="YYYY-MM-DD"/>');
			 layoutStr3.push('<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			 layoutStr3.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg3" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			 layoutStr3.push('<groupedColumns>');
			 layoutStr3.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="true" headerText="" width="40" verticalAlign="middle" />');
			 layoutStr3.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" width="50"/>');
			 layoutStr3.push('	<DataGridColumn dataField="DRCT_RTRVL_REG_DT"  headerText="'+parent.fn_text('reg_dt2')+'" width="100" formatter="{datefmt}" />');
			 layoutStr3.push('	<DataGridColumn dataField="DRCT_RTRVL_DT_PAGE"  headerText="'+parent.fn_text('drct_rtrvl_dt')+'" width="100" itemRenderer="HtmlItem" />');
			 layoutStr3.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150"/>');
			 layoutStr3.push('	<DataGridColumn dataField="BRCH_NM"  headerText="'+parent.fn_text('mfc_brch_nm')+'" width="150"/>');
			 layoutStr3.push('	<DataGridColumn dataField="DRCT_RTRVL_QTY_TOT" id="sum1" headerText="'+parent.fn_text('drct_rtrvl_qty')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr3.push('	<DataGridColumn dataField="DRCT_PAY_GTN_TOT" id="sum2" headerText="'+parent.fn_text('drct_rtrvl_gtn')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr3.push('</groupedColumns>');				
			 layoutStr3.push('	<footers>');
			 layoutStr3.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr3.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
			 layoutStr3.push('			<DataGridFooterColumn/>');
			 layoutStr3.push('			<DataGridFooterColumn/>');
			 layoutStr3.push('			<DataGridFooterColumn/>');
			 layoutStr3.push('			<DataGridFooterColumn/>');
			 layoutStr3.push('			<DataGridFooterColumn/>');
			 layoutStr3.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr3.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr3.push('		</DataGridFooter>');
			 layoutStr3.push('	</footers>');
			 layoutStr3.push('</DataGrid>');
			 layoutStr3.push('</rMateGrid>');

		}
		
		// 그리드 및 메뉴 리스트 세팅
		 function gridReadyHandler3(id) {
		 	 gridApp3 = document.getElementById(id);  // 그리드를 포함하는 div 객체
		     gridRoot3 = gridApp3.getRoot();   // 데이터와 그리드를 포함하는 객체
		     gridApp3.setLayout(layoutStr3.join("").toString());
		     
		     var layoutCompleteHandler = function(event) {
		         dataGrid3 = gridRoot3.getDataGrid();  // 그리드 객체
		         dataGrid3.addEventListener("change", selectionChangeHandler); //이벤트 등록
		         gridApp3.setData([]);
		         
		       	//파라미터 call back function 실행
				 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
						/* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
				 	 window[INQ_PARAMS.FN_CALLBACK]();
				 	//취약점점검 5895 기원우

				 }
		         
		     }
		     var dataCompleteHandler = function(event) {
		     	selectorColumn3 = gridRoot3.getObjectById("selector");
		 	 }
		     var selectionChangeHandler = function(event) {
		    	 rowIndex3 = event.rowIndex;
			 }
	
		     gridRoot3.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot3.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
		
	</script>

	<style type="text/css">
		.row .tit{width: 77px;}
	</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="bizrList" value="<c:out value='${bizrList}' />"/>

	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn" style="float:right" id="UR"></div>
		</div>
		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">
					<div class="col">
						<div class="tit" id="sel_term"></div>
						<div class="box">		
							<div class="calendar">
								<input type="text" id="START_DT_SEL" name="from" style="width: 140px;" class="i_notnull" ><!--시작날짜  -->
							</div>
							<div class="obj">~</div>
							<div class="calendar">
								<input type="text" id="END_DT_SEL" name="to" style="width: 140px;"	class="i_notnull" ><!-- 끝날짜 -->
							</div>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="mfc_bizrnm"></div>
						<div class="box">						
							<select id="MFC_BIZR_SEL" name="MFC_BIZR_SEL" style="width: 179px;">
							</select>
							<span style="width:116px"></span>
						</div>
					</div>
					<div class="btn" id="CR">
					</div>
				</div>
			</div>
		</section>
		<section class="secwrap mt10">
			<div class="h4group">
				<h4 class="tit"  id='dlivy_info'></h4>
			</div>
			<div class="boxarea">
				<div id="gridHolder" style="height:223px;"></div>
			</div>
		</section>
		
		<section class="secwrap mt10">
			<div class="h4group">
				<h4 class="tit"  id='fee_bill_issu_data'></h4>
			</div>
			<div class="boxarea">
				<div id="gridHolder2" style="height:223px;"></div>
			</div>
		</section>
		
		<section class="secwrap mt10">
			<div class="h4group">
				<h4 class="tit"  id='drct_rtrvl_data'></h4>
			</div>
			<div class="boxarea">
				<div id="gridHolder3" style="height:223px;"></div>
			</div>
		</section>
	
		<section class="btnwrap mt20" >
			<div class="fl_l" id="BL">
			</div>
			<div class="fl_r" id="BR">
			</div>
		</section>
		
	</div>
	
	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="excel" />
	</form>
	
</body>
</html>
