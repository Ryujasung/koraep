<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>
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
			
		/* 페이징 사용 등록 */
		gridRowsPerPage = 15;// 1페이지에서 보여줄 행 수
		gridCurrentPage = 1;// 현재 페이지
		gridTotalRowCount = 0;//전체 행 수
	
		var INQ_PARAMS = ${INQ_PARAMS}; //파라미터 데이터
	    var grid_info = ${grid_info};//그리드 컬럼 정보
	    var sumData; //총합계
	    
		$(document).ready(function(){
			
			/*상세조회 바로이동*/
			var EXCH_REQ_DOC_NO = "<c:out value='${EXCH_REQ_DOC_NO}' />";
			if( EXCH_REQ_DOC_NO != ''){
				//파라미터에 조회조건값 저장 
	    		var input = {};
				input.EXCH_REQ_DOC_NO = EXCH_REQ_DOC_NO;
	    		INQ_PARAMS["PARAMS"] = input;
	    		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
				INQ_PARAMS["URL_CALLBACK"] = "/MF/EPMF6624501.do";
				kora.common.goPage('/MF/EPMF6624564.do', INQ_PARAMS);
			}
			/*상세조회 바로이동*/
			
			fn_btnSetting();
			
			$('#sel_term').text(parent.fn_text('sel_term'));
			$('#stat').text(parent.fn_text('stat'));
			$('#reg_mfc').text(parent.fn_text('reg_mfc'));
			$('#reg_mfc_brch').text(parent.fn_text('reg_mfc_brch'));
			$('#cfm_mfc').text(parent.fn_text('cfm_mfc'));
			$('#cfm_mfc_brch').text(parent.fn_text('cfm_mfc_brch'));
			
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
			
			var exchStatList = ${exchStatList};
			var dtList = ${dtList};
			var bizrNmList = ${bizrNmList};
			var bizrNmList_all = ${bizrNmList_all};
			var reqBrchList = ${reqBrchList};
			var cfmBrchList = ${cfmBrchList};

			kora.common.setEtcCmBx2(exchStatList, "", "", $("#EXCH_STAT_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(dtList, "", "", $("#DT_SEL"), "ETC_CD", "ETC_CD_NM", "N", "");
			kora.common.setEtcCmBx2(bizrNmList_all, "", "", $("#REQ_MFC_SEL"), "BIZRID_NO", "BIZRNM", "N", "T");
			kora.common.setEtcCmBx2(bizrNmList_all, "", "", $("#CFM_MFC_SEL"), "BIZRID_NO", "BIZRNM", "N", "T");
			kora.common.setEtcCmBx2(reqBrchList, "", "", $("#REQ_MFC_BRCH_SEL"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');
			kora.common.setEtcCmBx2(cfmBrchList, "", "", $("#CFM_MFC_BRCH_SEL"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');

			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				kora.common.jsonToTable("sel_params", INQ_PARAMS.SEL_PARAMS);
				
				/* 화면이동 페이징 셋팅 */
				gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
			}
			
			//그리드 셋팅
			fn_set_grid();
			
			/************************************
			 * 등록 생산자명 변경 이벤트
			 ***********************************/
			 $("#REQ_MFC_SEL").change(function(){
					fn_bizrTpCd($(this), $("#REQ_MFC_BRCH_SEL"));
			 });
			
			/************************************
			 * 확인 생산자명 변경 이벤트
			 ***********************************/
			 $("#CFM_MFC_SEL").change(function(){
					fn_bizrTpCd($(this), $("#CFM_MFC_BRCH_SEL"), 'Y');
			 });
			 
			/************************************
			 * 날짜  클릭시 - 삭제  변경 이벤트
			 ***********************************/
			$("#START_DT").click(function(){
				    var start_dt = $("#START_DT").val();
				     start_dt   =  start_dt.replace(/-/gi, "");
				     $("#START_DT").val(start_dt)
			});
			/************************************
			 * 날짜  클릭시 - 추가  변경 이벤트
			 ***********************************/
			$("#START_DT").change(function(){
			     var start_dt = $("#START_DT").val();
			     start_dt   =  start_dt.replace(/-/gi, "");
				if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
			     $("#START_DT").val(start_dt) 
			});
			/************************************
			 * 날짜  클릭시 - 삭제  변경 이벤트
			 ***********************************/
			$("#END_DT").click(function(){
				    var dt = $("#END_DT").val();
				     dt   =  dt.replace(/-/gi, "");
				     $("#END_DT").val(dt)
			});
			/************************************
			 * 날짜  클릭시 - 추가  변경 이벤트
			 ***********************************/
			$("#END_DT").change(function(){
			    var dt = $("#END_DT").val();
			    dt   =  dt.replace(/-/gi, "");
				if(dt.length == 8)  dt = kora.common.formatter.datetime(dt, "yyyy-mm-dd")
			     $("#END_DT").val(dt) 
			});
			
			 $("#btn_reg").click(function(){
				fn_reg();
			 });
			 
			 $("#btn_sel").click(function(){
				//조회버튼 클릭시 페이징 초기화
				gridCurrentPage = 1;
				
				fn_sel();
			 });
			 
			 $("#btn_del").click(function(){
				fn_del();
			 });
			 
			 //엑셀저장
			 $("#btn_excel").click(function(){
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
					
					if(columns[i].getDataField() == 'EXCH_DT_PAGE'){// html 태크 사용중 컬럼은 대체
						item['dataField'] = 'EXCH_DT';
					}else{
						item['dataField'] = columns[i].getDataField();
					}
					
					item['textAlign'] = columns[i].getStyle('textAlign');
					item['id'] = kora.common.null2void(columns[i].id);

					col.push(item);
				}
			}
			
			var input = INQ_PARAMS["SEL_PARAMS"];
			input['excelYn'] = 'Y';
			input['fileName'] = fileName;
			input['columns'] = JSON.stringify(col);
			
			var url = "/MF/EPMF6624501_05.do";
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
		
		
		function fn_del(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg('선택된 행이 없습니다');
				return;
			}
			
			for(var i=0; i<chkLst.length; i++){
				if(chkLst[i].EXCH_STAT_CD != "RG"){
					alertMsg("교환등록 상태의 정보만 삭제 가능합니다. \n다시 한 번 확인하시기 바랍니다.");
					return;
				}
				
				if(chkLst[i].DEL_YN != "Y"){
					alertMsg("등록생산자만 삭제할 수 있습니다.\n다시 한 번 확인하시기 바랍니다.");
					return;
				}
			}
			
			confirm("선택된 교환 내역이 모두 삭제됩니다. \n계속 진행하시겠습니까? \n삭제 처리된 내역은 복원되지 않으며 재등록 하셔야 합니다.", "fn_del_exec");
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

			var url = "/MF/EPMF6624501_04.do";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_sel');
				} else {
					alertMsg("error");
				}
			});
		}
			
		/**
		 * 목록조회
		 */
		function fn_sel(){

			var input = {};
			input["DT_SEL"] = $("#DT_SEL option:selected").val();
			input["START_DT"] = $("#START_DT").val().replace(/\-/g,"");;
			input["END_DT"] = $("#END_DT").val().replace(/\-/g,"");;
			input["REQ_MFC_SEL"] = $("#REQ_MFC_SEL option:selected").val();
			input["REQ_MFC_BRCH_SEL"] = $("#REQ_MFC_BRCH_SEL option:selected").val();
			input["CFM_MFC_SEL"] = $("#CFM_MFC_SEL option:selected").val();
			input["CFM_MFC_BRCH_SEL"] = $("#CFM_MFC_BRCH_SEL option:selected").val();
			input["EXCH_STAT_CD_SEL"] = $("#EXCH_STAT_CD_SEL option:selected").val();
			
			/* 페이징  */
			input["ROWS_PER_PAGE"] = gridRowsPerPage;
			input["CURRENT_PAGE"] = gridCurrentPage;
			
			//파라미터에 조회조건값 저장 
			INQ_PARAMS["SEL_PARAMS"] = input;
			
			var url = "/MF/EPMF6624501_192.do";
			
// 			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			$("#modal").show();
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.searchList);
					sumData = rtnData.totalList[0];

					/* 페이징 표시 */
					gridTotalRowCount = parseInt(sumData.CNT); //총 카운트
					drawGridPagingNavigation(gridCurrentPage);
					
				} else {
					alertMsg("error");
				}
				$("#modal").hide();
			});
// 			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
			
		}
		
		
		function fn_reg(){

			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/MF/EPMF6624501.do";
			kora.common.goPage('/MF/EPMF6624531.do', INQ_PARAMS);
		}
		
		//생산자명 변경시
		function fn_bizrTpCd(obj, tt, allYn){
			var url = "/SELECT_BRCH_LIST.do" 
			var input ={};
		    input["BIZRID_NO"] = obj.val();
		    input["ALL_YN"] = allYn;

       	    ajaxPost(url, input, function(rtnData) {
   				if (null != rtnData) {   
   					kora.common.setEtcCmBx2(rtnData, "","", tt, "BRCH_ID_NO", "BRCH_NM", "N" ,'T');
   				} else {
   					alertMsg("error");
   				}
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
			 layoutStr.push(' <NumberMaskFormatter id="dateFmt" formatString="####-##-##"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="on" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			 layoutStr.push('<groupedColumns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="true" headerText="" width="40" verticalAlign="middle" draggable="false" />');
			 //layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" width="50"/>');
			 layoutStr.push('	<DataGridColumn dataField="PNO" 				 				headerText="'+ parent.fn_text('sn')+ '" textAlign="center" width="50"   draggable="false"/>');							//순번
			 layoutStr.push('	<DataGridColumn dataField="EXCH_REG_DT"  headerText="'+parent.fn_text('reg_dt2')+'" width="100" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_DT_PAGE"  headerText="'+parent.fn_text('exch_dt')+'" width="100" itemRenderer="HtmlItem"/>');
			 layoutStr.push('	<DataGridColumn dataField="REQ_BIZRNM"  headerText="'+parent.fn_text('reg_mfc')+'" width="150"/>');
			 layoutStr.push('	<DataGridColumn dataField="REQ_BRCH_NM"  headerText="'+parent.fn_text('reg_mfc_brch')+'" width="150"/>');
			 layoutStr.push('	<DataGridColumn dataField="CFM_BIZRNM"  headerText="'+parent.fn_text('cfm_mfc')+'" width="150"/>');
			 layoutStr.push('	<DataGridColumn dataField="CFM_BRCH_NM"  headerText="'+parent.fn_text('cfm_mfc_brch')+'" width="150"/>');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_QTY_TOT" id="exchQtyTot"  headerText="'+parent.fn_text('exch_qty')+'" width="100" formatter="{numfmt}"  textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_GTN_TOT" id="exchGtnTot"  headerText="'+parent.fn_text('amt')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_CFM_DT" id="tmp1"  headerText="'+parent.fn_text('exch_cfm_dt')+'" width="100"/>');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_STAT_NM"  headerText="'+parent.fn_text('stat')+'" width="100" id="tmp2" />');
			 layoutStr.push('</groupedColumns>');
			 layoutStr.push('	<footers>');
			 layoutStr.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn label="'+parent.fn_text('total')+'"  textAlign="center"/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{exchQtyTot}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{exchGtnTot}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn dataColumn="{tmp1}"/>');
			 layoutStr.push('		</DataGridFooter>');
			 layoutStr.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn label="'+parent.fn_text('totalsum')+'" textAlign="center"  />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn labelJsFunction="totalsum1" dataColumn="{exchQtyTot}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn labelJsFunction="totalsum2" dataColumn="{exchGtnTot}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn dataColumn="{tmp1}"/>');
			 layoutStr.push('			<DataGridFooterColumn dataColumn="{tmp2}"/>');
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

		     	/* ---------------드레그 컬럼 셋팅---------------------------------------------------------- */
					var columnLayout = null;
				
					if(grid_info.length>0) {
						for(var g=0;g<grid_info.length;g++){
								if(grid_info[g].GRID_ID =='dataGrid'){
									
									columnLayout = JSON.parse(grid_info[g].PRAM)
								}
						}
					}
					function checkValue(colLay, cols) {
						if ( colLay.headerText == cols.getDataField() || colLay.headerText == cols.getHeaderText() || colLay.headerText == cols.getDataField() )
							return true;
						else
							return false;
					}
					// 숨김 정보를 삽입하고 순서를 재정의합니다.
					if ( columnLayout ) {
						var newCol = [];
						var columns =  dataGrid.getGroupedColumns();
			
						//그리드정보가 일치하지 않으면 리턴
						if(columnLayout.length != columns.length){
							
						}else{
						
							for ( var j = 0  ; j < columnLayout.length ; j ++ ){
								for ( var i = 0  ; i < columns.length ; i++ ){
									// 그룹 컬럼일 경우
									if ( columns[i].children ) {
										var gCol = [];
										if ( checkValue( columnLayout[j], columns[i] ) ) {
										for ( var k = 0 ; k < columnLayout[j].children.length ; k++ ) {
											for ( var m = 0 ; m < columns[i].children.length ; m++ ) {
													if ( checkValue( columnLayout[j].children[k], columns[i].children[m] ) )
														gCol.push(columns[i].children[m]);
												}
											}
											columns[i].children = gCol;
											newCol[j] = columns[i];
											break;
										}
									} else if ( checkValue( columnLayout[j], columns[i] ) ) {
										newCol[j] = columns[i];
										break;
									}
								}
							}
							dataGrid.setGroupedColumns(newCol);
						}
					}
				/* ---------------------------------------------------------------------------------------- */
				
					
		         
		       	 //파라미터 call back function 실행
				 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
				 	eval(INQ_PARAMS.FN_CALLBACK+"()");
				 }else{
					gridApp.setData();
					 
					/* 페이징 표시 */
					drawGridPagingNavigation(gridCurrentPage);
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
		
		 /* 페이징 이동 스크립트 */
		function gridMovePage(goPage) {
			gridCurrentPage = goPage; //선택 페이지
			fn_sel(); //조회 펑션
		}
		
		//교환량 합계
		function totalsum1(column, data) {
			if(sumData)
				return sumData.EXCH_QTY_TOT;
			else
				return 0;
		}

		//금액 합계
		function totalsum2(column, data) {
			if(sumData)
				return sumData.EXCH_GTN_TOT;
			else
				return 0;
		}
		 
		//상세화면 이동
		function fn_page(){

			var input = {};
			
			input["EXCH_REQ_DOC_NO"] = gridRoot.getItemAt(rowIndex)["EXCH_REQ_DOC_NO"];
			
			/*
			input["REQ_MFC_BIZRID"] = gridRoot.getItemAt(rowIndex)["REQ_MFC_BIZRID"];
			input["REQ_MFC_BIZRNO"] = gridRoot.getItemAt(rowIndex)["REQ_MFC_BIZRNO"];
			input["CFM_MFC_BIZRID"] = gridRoot.getItemAt(rowIndex)["CFM_MFC_BIZRID"];
			input["CFM_MFC_BIZRNO"] = gridRoot.getItemAt(rowIndex)["CFM_MFC_BIZRNO"];

			input["EXCH_REG_DT"] = gridRoot.getItemAt(rowIndex)["EXCH_REG_DT"];
			input["EXCH_DT"] = gridRoot.getItemAt(rowIndex)["EXCH_DT"];
			input["REQ_BIZRNM"] = gridRoot.getItemAt(rowIndex)["REQ_BIZRNM"];
			input["REQ_BRCH_NM"] = gridRoot.getItemAt(rowIndex)["REQ_BRCH_NM"];
			input["CFM_BIZRNM"] = gridRoot.getItemAt(rowIndex)["CFM_BIZRNM"];
			input["CFM_BRCH_NM"] = gridRoot.getItemAt(rowIndex)["CFM_BRCH_NM"];
			input["EXCH_STAT_CD"] = gridRoot.getItemAt(rowIndex)["EXCH_STAT_CD"];
			input["EXCH_REQ_CRCT_STAT_CD"] = gridRoot.getItemAt(rowIndex)["EXCH_REQ_CRCT_STAT_CD"];
			input["EXCH_CFM_CRCT_STAT_CD"] = gridRoot.getItemAt(rowIndex)["EXCH_CFM_CRCT_STAT_CD"];
			*/
			
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/MF/EPMF6624501.do";
			kora.common.goPage('/MF/EPMF6624564.do', INQ_PARAMS);
		}
		
	</script>

	<style type="text/css">
		.row .tit{width: 62px;}
	</style>

</head>
<body>
	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn_box">
				<div class="btn" id="UR">
				</div>
			</div>
		</div>
		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">
					<div class="col">
						<div class="tit" id="sel_term">
						</div>
						<div class="box">						
							<select id=DT_SEL name="DT_SEL" style="width: 130px;">
							</select>
							<div class="calendar">
								<input type="text" id="START_DT" name="from" style="width: 130px;" class="i_notnull" ><!--시작날짜  -->
							</div>
							<div class="obj">~</div>
							<div class="calendar">
								<input type="text" id="END_DT" name="to" style="width: 130px;"	class="i_notnull" ><!-- 끝날짜 -->
							</div>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="reg_mfc" style="width:90px"></div>
						<div class="box">
							<select id="REQ_MFC_SEL" name="REQ_MFC_SEL" style="width: 159px;">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="reg_mfc_brch" style="width:110px"></div>
						<div class="box">
							<select id="REQ_MFC_BRCH_SEL" name="REQ_MFC_BRCH_SEL" style="width: 169px;">
							</select>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col">
						<div class="tit" id="stat"></div>
						<div class="box">						
							<select id="EXCH_STAT_CD_SEL" name="EXCH_STAT_CD_SEL" style="width: 130px;">
							</select>
							<span style="width:280px"></span>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="cfm_mfc" style="width:90px"></div>
						<div class="box">
							<select id="CFM_MFC_SEL" name="CFM_MFC_SEL" style="width: 159px;">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="cfm_mfc_brch" style="width:110px"></div>
						<div class="box">
							<select id="CFM_MFC_BRCH_SEL" name="CFM_MFC_BRCH_SEL" style="width: 169px;">
							</select>
						</div>
					</div>
					<div class="btn" id="CR"></div>
				</div>
			</div>
		</section>
		<section class="btnwrap mt10" >
			<div class="btn" id="GL"></div>
			<div class="btn" style="float:right" id="GR"></div>
		</section>
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:648px;"></div>
			</div>
			<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
		</section>
	
		<section class="btnwrap" style="">
			<div class="fl_l" id="BL">
			</div>
			<div class="fl_r" id="BR">
			</div>
		</section>
		
		<section class="btnwrap mt10" style="">
			<div class="fl_l" >
				<div class="h4group" >
					<h5 class="tit"  style="font-size: 16px;text-align:left">
						※ 빈용기보증금포함제품을 교환 시 관련 비용(운임비, 수수료 등)은 생산자 상호간 협의에 따라 진행하시기 바라며,
		 	 					<br/>&nbsp;&nbsp;&nbsp;지급관리시스템에 등록하신 자료는 생산자별 회수실적자료 관리를 위해 사용됩니다. 
					</h5>
				</div>
			</div>
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
