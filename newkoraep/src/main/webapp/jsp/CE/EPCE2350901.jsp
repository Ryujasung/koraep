<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />

	<script type="text/javaScript" language="javascript" defer="defer">
		
		var INQ_PARAMS;
	
		$(document).ready(function(){
			
			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			var bizrList = jsonObject($('#bizrList').val());
			var brchList = jsonObject($('#brchList').val());
			var whsdlSeCdList = jsonObject($('#whsdlSeCdList').val());
			var whsdlList = jsonObject($('#whsdlList').val());
			
			fn_btnSetting();

			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			
			//날짜 셋팅
		    $('#START_DT_SEL').YJcalendar({  
				toName : 'to',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
				
			});
			$('#END_DT_SEL').YJcalendar({
				fromName : 'from',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
			});
			
			
			kora.common.setEtcCmBx2(bizrList, "", "", $("#MFC_BIZR_SEL"), "BIZRID_NO", "BIZRNM", "N", "T");
			kora.common.setEtcCmBx2(brchList, "", "", $("#MFC_BRCH_SEL"), "BRCH_ID_NO", "BRCH_NM", "N" ,"T");
			kora.common.setEtcCmBx2(whsdlSeCdList, "","", $("#WHSDL_SE_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N" ,'T');
			kora.common.setEtcCmBx2(whsdlList, "", "", $("#WHSDL_BIZR_SEL"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N", "T");
			$("#WHSDL_BIZR_SEL").select2();
			
			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
				
				$("#WHSDL_BIZR_SEL").select2('val', INQ_PARAMS.SEL_PARAMS.WHSDL_BIZR_SEL);
			}
			
			//그리드 셋팅
			fn_set_grid();
			
			$("#btn_sel").click(function(){
				fn_sel();
			});
			
			/************************************
			 * 지급정보생성 버튼 클릭 이벤트
			 ***********************************/
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			/************************************
			 * 소매지급정보생성 버튼 클릭 이벤트
			 ***********************************/
			$("#btn_reg2").click(function(){
				fn_reg2();
			});
			
			/************************************
			 * 상계처리 버튼 클릭 이벤트
			 ***********************************/
			$("#btn_reg3").click(function(){
				fn_reg3();
			});
			
			 /************************************
			 * 엑셀다운로드 버튼 클릭 이벤트
			 ***********************************/
			 $("#btn_excel").click(function() {
				 fn_excel();
			 });
			
			//휴폐업조회
			$("#btn_upd").click(function(){
				fn_check();
			});
			
			/************************************
			 * 생산자명 변경 이벤트
			 ***********************************/
			 $("#MFC_BIZR_SEL").change(function(){
				fn_bizrTpCd();
			 });
			
			 /************************************
			 * 직매장 변경 이벤트
			 ***********************************/
			 $("#MFC_BRCH_SEL").change(function(){
				fn_brch();
			 });
			
			 /************************************
			 * 도매업자 구분 변경 이벤트
			 ***********************************/
			$("#WHSDL_SE_CD_SEL").change(function(){
				fn_whsl_se_cd();
			});
			
		});
		
		//생산자명 변경시
		function fn_bizrTpCd(){
			
			var url = "/CE/EPCE4759401_192.do" 
			var input ={};
			
		    input["BIZRID_NO"] = $("#MFC_BIZR_SEL").val();
		    //input["BRCH_ID_NO"] = $("#MFC_BRCH_SEL").val();

		    $("#WHSDL_BIZR_SEL").select2("val","");
	      	    ajaxPost(url, input, function(rtnData) {
	  				if ("" != rtnData && null != rtnData) {
	  					kora.common.setEtcCmBx2(rtnData.brchList, "","", $("#MFC_BRCH_SEL"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');
	  					kora.common.setEtcCmBx2(rtnData.ctnrList, "","", $("#CTNR_CD_SEL"), "CTNR_CD", "CTNR_NM", "N" ,'T');
	  					kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZR_SEL"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T'); //업체명
	  				} else {
	  					alertMsg("error");
	  				}
	   		}, false);
		}
		
		//직매장 변경시
		function fn_brch(){
			
			var url = "/CE/EPCE4759401_194.do" 
			var input ={};
			
		    input["BIZRID_NO"] = $("#MFC_BIZR_SEL").val();
		    input["BRCH_ID_NO"] = $("#MFC_BRCH_SEL").val();

		    if($("#WHSDL_SE_CD_SEL").val()  !=""){
		   		input["BIZR_TP_CD"] =$("#WHSDL_SE_CD_SEL").val();
		    }
		    
		    $("#WHSDL_BIZR_SEL").select2("val","");
	    	   ajaxPost(url, input, function(rtnData) {
					if ("" != rtnData && null != rtnData) {  
						kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZR_SEL"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T'); //업체명
					}else{
						alertMsg("error");
					}
	 		});

		}
		
		//도매업자구분 변경시 도매업자 조회 ,생산자가 선택됐을경우 거래중인 도매업자만 조회
	     function fn_whsl_se_cd(){
	    	var url = "/CE/EPCE4759401_193.do" 
			var input ={};
			   if($("#WHSDL_SE_CD_SEL").val()  !=""){
			   		input["BIZR_TP_CD"] =$("#WHSDL_SE_CD_SEL").val();
			   }
			   //생산자 선택시 선택된 생산자랑 거래중인 도매업자 조회
			   if( $("#MFC_BIZR_SEL").val() !="" ){
	   				input["MFC_BIZRID"]	= $("#MFC_BIZR_SEL").val().split(';')[0];
	   				input["MFC_BIZRNO"]	= $("#MFC_BIZR_SEL").val().split(';')[1];
	   				//생산자 + 직매장 선택시 거래중이 도매업자 조회
	   				if($("#MFC_BRCH_SEL").val() !="" ){
					 	input["MFC_BRCH_ID"]		= $("#MFC_BRCH_SEL").val().split(';')[0];
			    		input["MFC_BRCH_NO"]	= $("#MFC_BRCH_SEL").val().split(';')[1];
	   				}
			   }
	    	   $("#WHSDL_BIZR_SEL").select2("val","");
	       	   ajaxPost(url, input, function(rtnData) {
	   				if ("" != rtnData && null != rtnData) {  
	   					kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZR_SEL"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T'); //업체명
	   				}else{
	   					alertMsg("error");
	   				}
	    		});
	     }	
		
		function fn_check(){
			
			var data = {};
			var row = new Array();
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(item);
			}
			
			data["list"] = JSON.stringify(row);

			var url = "/CE/EPCE0160101422.do";
			document.body.style.cursor = "wait";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_sel');
				} else {
					alertMsg("error");
				}
				document.body.style.cursor = "default";
			});
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
					
					if(columns[i].getDataField() == 'WRHS_CFM_DT_PAGE'){// html 태크 사용중 컬럼은 대체
						item['dataField'] = 'WRHS_CFM_DT';
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
			
			var url = "/CE/EPCE2350901_05.do";
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
		
		//지급생성
		function fn_reg(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}
						
			confirm('선택된 내역에 대해 지급 예정 내역을 생성하시겠습니까?', "fn_reg_exec");
		}
		
		function fn_reg_exec(){
			
			var data = {};
			var row = new Array();
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(item);
			}
			
			data["list"] = JSON.stringify(row);

			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			var url = "/CE/EPCE2350901_09.do";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					if(rtnData.RSLT_CD == '0000'){
						alertMsg(rtnData.RSLT_MSG, 'fn_sel');
	 				}else{
	 					alertMsg(rtnData.RSLT_MSG);
	 				}
				} else {
					alertMsg("error");
				}
				kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
			});
		}
		
		//소매지급생성
		function fn_reg2(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}
						
			confirm('선택된 내역에 대해 지급 예정 내역을 생성하시겠습니까?', "fn_reg2_exec");
		}
		
		function fn_reg2_exec(){
			
			var data = {};
			var row = new Array();
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(item);
			}
			
			data["list"] = JSON.stringify(row);

			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			var url = "/CE/EPCE2350901_092.do";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					if(rtnData.RSLT_CD == '0000'){
						alertMsg(rtnData.RSLT_MSG, 'fn_sel');
	 				}else{
	 					alertMsg(rtnData.RSLT_MSG);
	 				}
				} else {
					alertMsg("error");
				}
				kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
			});
		}
		
		// 지급정보생성 상계처리
		function fn_reg3(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}
						
			confirm('선택된 내역에 대해 상계처리 하시겠습니까?', "fn_reg_exec3");
		}
		
		function fn_reg_exec3(){
			
			var data = {};
			var row = new Array();
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(item);
			}
			
			data["list"] = JSON.stringify(row);

			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			var url = "/CE/EPCE2350901_093.do";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					if(rtnData.RSLT_CD == '0000'){
						alertMsg(rtnData.RSLT_MSG, 'fn_sel');
	 				}else{
	 					alertMsg(rtnData.RSLT_MSG);
	 				}
				} else {
					alertMsg("error");
				}
				kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
			});
		}
		
		
		//입고 상세화면 이동
		function fn_page(){

			var idx = dataGrid.getSelectedIndices();
			var input = gridRoot.getItemAt(idx);
			
			//상세조회쪽 사용 값
			input["WHSDL_BIZRNO"] = input["BIZRNO_DE"];
			
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE2350901.do";
			kora.common.goPage('/CE/EPCE29164642.do', INQ_PARAMS);
		}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){

			var url = "/CE/EPCE2350901_19.do";
			var input = {};
			
			input['START_DT_SEL'] = $("#START_DT_SEL").val();
			input['END_DT_SEL'] = $("#END_DT_SEL").val();
			input['MFC_BIZR_SEL'] = $("#MFC_BIZR_SEL option:selected").val();
			input['MFC_BRCH_SEL'] = $("#MFC_BRCH_SEL option:selected").val();
			input['WHSDL_SE_CD_SEL'] = $("#WHSDL_SE_CD_SEL option:selected").val();
			input['WHSDL_BIZR_SEL'] = $("#WHSDL_BIZR_SEL option:selected").val();
	
			//파라미터에 조회조건값 저장 
			INQ_PARAMS["SEL_PARAMS"] = input; 
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.searchList);
				} else {
					alertMsg("error");
				}
				kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
			});
			
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
			 layoutStr.push('	<NumberMaskFormatter id="maskfmt" formatString="###-##-#####"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			 layoutStr.push('<groupedColumns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="true" headerText="" width="40" verticalAlign="middle" />');
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" width="50"/>');
			 layoutStr.push('	<DataGridColumn dataField="WRHS_CFM_DT_PAGE"  headerText="'+parent.fn_text('wrhs_cfm_dt')+'" width="100" itemRenderer="HtmlItem" />');
			 layoutStr.push('	<DataGridColumn dataField="WHSDL_BIZRNM"  headerText="'+parent.fn_text('whsdl')+'" width="170" />');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNO_DE"  headerText="'+parent.fn_text('bizrno')+'" width="170" formatter="{maskfmt}"/>');
			 layoutStr.push('	<DataGridColumn dataField="AREA_NM"  headerText="'+parent.fn_text('area_nm')+'" width="170" />');
			 layoutStr.push('	<DataGridColumn dataField="CFM_QTY_TOT" id="sum1" headerText="'+parent.fn_text('wrhs_qty')+'" width="100" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="CFM_GTN_TOT" id="sum2" headerText="'+parent.fn_text('dps2')+'" width="100" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="CFM_FEE_TOT" id="sum3" headerText="'+parent.fn_text('fee')+'" width="100" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="CFM_FEE_STAX_TOT" id="sum4" headerText="'+parent.fn_text('stax')+'" width="100" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="CFM_TOT" id="sum5" headerText="'+parent.fn_text('amt')+'" width="100" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="MFC_BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150"/>');
			 layoutStr.push('	<DataGridColumn dataField="MFC_BRCH_NM"  headerText="'+parent.fn_text('mfc_brch_nm')+'" width="150"/>');
			 layoutStr.push('	<DataGridColumn dataField="RUN_STAT_NM"  headerText="'+parent.fn_text('run_stat')+'" width="80"/>');
			 layoutStr.push('</groupedColumns>');
			 layoutStr.push('	<footers>');
			 layoutStr.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum3}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum4}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum5}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
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

				//파라미터 call back function 실행
				 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
						/* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
				 	 window[INQ_PARAMS.FN_CALLBACK]();
				 	//취약점점검 5894 기원우
				 }else{
					gridApp.setData();
				 }
		     }
		     var selectionChangeHandler = function(event) {
				rowIndex = event.rowIndex;
			 }
		     var dataCompleteHandler = function(event) {
		 	 }
		     
		     gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
		
	</script>

	<style type="text/css">
		.row .tit{width: 82px;}
	</style>

</head>
<body>

	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
	<input type="hidden" id="bizrList" value="<c:out value='${bizrList}' />"/>
	<input type="hidden" id="brchList" value="<c:out value='${brchList}' />"/>
	<input type="hidden" id="whsdlSeCdList" value="<c:out value='${whsdlSeCdList}' />"/>
	<input type="hidden" id="whsdlList" value="<c:out value='${whsdlList}' />"/>
	
	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn" style="float:right" id="UR"></div>
		</div>
		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">
					<div class="col">
						<div class="tit" id="sel_term_txt"></div>
						<div class="box">		
							<div class="calendar">
								<input type="text" id="START_DT_SEL" name="from" style="width: 140px;" ><!--시작날짜  -->
							</div>
							<div class="obj">~</div>
							<div class="calendar">
								<input type="text" id="END_DT_SEL" name="to" style="width: 140px;"	><!-- 끝날짜 -->
							</div>
						</div>
					</div>
					<div class="col" >
						<div class="tit" id="whsl_se_cd_txt" ></div>
						<div class="box">
							<select id="WHSDL_SE_CD_SEL" name="WHSDL_SE_CD_SEL" style="width: 179px"></select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="enp_nm_txt"></div> 
						<select id="WHSDL_BIZR_SEL" name="WHSDL_BIZR_SEL" style="width: 180px;"></select>
					</div>
				</div>
				<div class="row">
					<div class="col">
						<div class="tit" id="mfc_bizrnm_txt"></div>
						<div class="box">						
							<select id="MFC_BIZR_SEL" name="MFC_BIZR_SEL" style="width: 179px;">
							</select>
							<span style="width:116px"></span>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="mfc_brch_nm_txt" style=""></div>
						<div class="box">
							<select id="MFC_BRCH_SEL" name="MFC_BRCH_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="btn" id="CR">
					</div>
				</div>
			</div>
		</section>
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:330px;"></div>
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
