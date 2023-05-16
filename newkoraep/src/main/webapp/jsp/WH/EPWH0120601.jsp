<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>

	<script type="text/javaScript" language="javascript" defer="defer">
		
		var INQ_PARAMS = ${INQ_PARAMS};//파라미터 데이터
		var flag = true;
		
		/* 페이징 사용 등록 */
		gridRowsPerPage = 15;//1페이지에서 보여줄 행 수
		gridCurrentPage = 1;//현재 페이지
		gridTotalRowCount = 0;//전체 행 수
		
		$(document).ready(function(){
			
			fn_btnSetting();
			
			$('#mfc_bizrnm').text(parent.fn_text('mfc_bizrnm'));
			$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm'));
			$('#bizr_tp_cd').text(parent.fn_text('bizr_tp_cd'));
			$('#cust_bizrnm').text(parent.fn_text('cust_bizrnm'));
			$('#brch_nm').text(parent.fn_text('brch_nm'));
			$('#cust_bizrno').text(parent.fn_text('cust_bizrno'));
			$('#stat_cd').text(parent.fn_text('deal_yn'));
			$('#std_fee_reg_yn').text(parent.fn_text('std_fee_reg_yn'));
			 
			//var searchList =${searchList};//초기 리스트 값
			var mfc_bizrnm_sel = ${mfc_bizrnm_sel};		//생산자명 ING
			var mfc_brch_nm_sel = ${mfc_brch_nm_sel};	//직매장/공장 ING
			var stat_cd_sel = ${stat_cd_sel};			//거래구분 ED
			var bizr_tp_cd_sel = ${bizr_tp_cd_sel};		//거래처구분 ED
			var std_fee_reg_yn = ${std_fee_reg_yn};	
			
			$("#mfc_bizrnm  option").remove();
			//콤보박스
			//진행중 #MFC_BIZRNM_SEL MFC_BRCH_NM_SEL stat_cd_SEL, BIZR_TP_CD_SEL
			kora.common.setEtcCmBx2(mfc_bizrnm_sel, "", "", $("#MFC_BIZRNM_SEL"), "BIZRID_NO", "BIZRNM", "N", "T");
			kora.common.setEtcCmBx2(mfc_brch_nm_sel, "", "", $("#MFC_BRCH_NM_SEL"), "BRCH_ID_NO", "BRCH_NM", "N", "T");
			kora.common.setEtcCmBx2(stat_cd_sel, "", "", $("#STAT_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(bizr_tp_cd_sel, "", "", $("#BIZR_TP_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			
			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
			}
			
			//그리드 셋팅
			fn_set_grid();
			
			//조회
			$("#btn_sel").click(function(){
				//조회버튼 클릭시 페이징 초기화
				gridCurrentPage = 1;
				fn_sel();
			});
			
			//등록 버튼
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			//변경
			$("#btn_upd").click(function(){
				fn_upd_chk();
			});
			
			//거래복원
			$("#btn_activity").click(function(){
				fn_activity();
			});
			
			//거래종료처리
			$("#btn_inactivity").click(function(){
				fn_inactivity();
			});
			
			/************************************
			 * 생산자명 변경 이벤트
			 ***********************************/
			 $("#MFC_BIZRNM_SEL").change(function(){
				fn_bizrTpCd();
			 });
			
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
			
			var url = "/WH/EPWH0120601_05.do";
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
			fn_sel(); //조회 펑션
		}
		
		//생산자명 변경시
		function fn_bizrTpCd(){
			
			var url = "/WH/EPWH0120601192.do" 
			var input ={};
		    input["BIZRID_NO"] =$("#MFC_BIZRNM_SEL").val();

       	    ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {   
   					kora.common.setEtcCmBx2(rtnData.searchList, "","", $("#MFC_BRCH_NM_SEL"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');
   				} else {
   					alertMsg("error");
   				}
    		});
		}
		
		//거래종료처리
		function fn_inactivity(){
			var selector = gridRoot.getObjectById("selector");
			var chkLst = selector.getSelectedItems();

			if(chkLst.length < 1){
				alertMsg("선택된 내역이 없습니다.");
				return;
			}
			
			var row  = new Array();
			var cnt = 0;

			for(var i=0; i<chkLst.length; i++){
				var item = {};
				item = chkLst[i];
				if("N" != chkLst[i].STAT_CD){
					row.push(item);
					cnt++;
				}
			}
			
			if(chkLst.length != cnt){
				alertMsg("거래 상태가 아닌 구분이 선택되었습니다.\n다시 한 번 확인하사기 바랍니다.");
				return;
			}
			
			confirm('거래종료 처리하시겠습니까?', 'fn_inactivity_exec');
			
		}
		
		//거래복원
		function fn_activity(){
			var selector = gridRoot.getObjectById("selector");
			var chkLst = selector.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("선택된 내역이 없습니다.");
				return;
			}
			
			var row  = new Array();
			var cnt = 0;

			for(var i=0; i<chkLst.length; i++){
				var item = {};
				item = chkLst[i];
				if("Y" != chkLst[i].STAT_CD){
					row.push(item);
					cnt++;
				}
			}
			
			if(chkLst.length != cnt){
				alertMsg("거래종료 상태가 아닌 구분이 선택되었습니다.\n다시 한 번 확인하사기 바랍니다.");
				return;
			}
			
			confirm('거래복원 처리하시겠습니까?', 'fn_activity_exec');
			
		}
		
		//거래복원 confirm 처리
		function fn_activity_exec(){
			var selector = gridRoot.getObjectById("selector");
			var chkLst = selector.getSelectedItems();
			var url  = "/WH/EPWH0120601_21.do";
			var data = {};
			var row  = new Array();
			var cnt = 0;

			for(var i=0; i<chkLst.length; i++){
				var item = {};
				item = chkLst[i];
				if("Y" != chkLst[i].STAT_CD){
					row.push(item);
					cnt++;
				}
			}
			data["list"] = JSON.stringify(row);
			data["exec_stat_cd"] = "Y";
			
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_sel');
				} else {
					alertMsg("error");
				}
			});
			
		}
				
		//거래종료처리 confirm 처리
		function fn_inactivity_exec(){
			var selector = gridRoot.getObjectById("selector");
			var chkLst = selector.getSelectedItems();
			var url  = "/WH/EPWH0120601_21.do";
			var data = {};
			var row  = new Array();
			var cnt = 0;
			
			for(var i=0; i<chkLst.length; i++){
				var item = {};
				item = chkLst[i];
				if("N" != chkLst[i].STAT_CD){
					row.push(item);
					cnt++;
				}
			}
			data["list"] = JSON.stringify(row);
			data["exec_stat_cd"] = "N";
			
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
			input["MFC_BIZRNM_SEL"] = $("#MFC_BIZRNM_SEL option:selected").val();
			input["MFC_BRCH_NM_SEL"] = $("#MFC_BRCH_NM_SEL option:selected").val();
			input["STAT_CD_SEL"] = $("#STAT_CD_SEL option:selected").val();
			input["BIZR_TP_CD_SEL"] = $("#BIZR_TP_CD_SEL option:selected").val();
			input["CUST_BIZRNM_SEL"] = $("#CUST_BIZRNM_SEL").val();
			input["CUST_BIZRNO_SEL"] = $("#CUST_BIZRNO_SEL").val();
			
			/* 페이징  */
			input["ROWS_PER_PAGE"] = gridRowsPerPage;
			input["CURRENT_PAGE"] 	= gridCurrentPage;
			
			//파라미터에 조회조건값 저장 
			INQ_PARAMS["SEL_PARAMS"] = input;

			var url = "/WH/EPWH012060119.do";
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.searchList);
					
					/* 페이징 표시 */
					gridTotalRowCount = rtnData.totalCnt; //총 카운트
					drawGridPagingNavigation(gridCurrentPage);
				} 
				else {
					alertMsg("error");
				}
			}, false);
			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
		}
		
		/**
		 * 등록화면 이동
		 */
		function fn_reg(){
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH0120601.do";
			kora.common.goPage('/WH/EPWH0120631.do', INQ_PARAMS);
		}
		
		//기준수수료생성 체크
		function fn_upd_chk(){
			
			var selectorColumn = gridRoot.getObjectById("selector");
			if(selectorColumn.getSelectedIndices() == "") {
				alertMsg("선택한 건이 없습니다.");
				return false;
			}
				confirm("선택된 내역의 기준수수료정보를 (재)생성 처리합니다. \n\n선택된 내역에 따라 많은 시간이 소요될 수 있습니다. 계속 진행하시겠습니까?","fn_upd");
			
		}
		
		//기준수수료생성
		function fn_upd(){
			var selectorColumn = gridRoot.getObjectById("selector");
			var url = "/WH/EPWH0120601_212.do";
			var input = {"list": ""};
			var row = new Array();
			
			 for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
					var item = {};
					item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
					row.push(item);
			 }
		     input["list"] = JSON.stringify(row);
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					alertMsg(rtnData.RSLT_MSG, 'fn_sel');
				} 
				else {
					alertMsg("error");
				}
			}, false);
			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off	
			
		}
		
		/**
		 * 그리드 관련 변수 선언
		 */
	    var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
		var gridApp, gridRoot, dataGrid, layoutStr, selectorColumn;
		var layoutStr = new Array();
		
		/**
		 * 메뉴관리 그리드 셋팅
		 */
		 function fn_set_grid() {
			 
			 rMateGridH5.create("grid", "gridHolder", jsVars, "100%", "100%");
			 
			 layoutStr.push('<rMateGrid>');
			 layoutStr.push('	<NumberMaskFormatter id="maskfmt" formatString="###-##-#####"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalGridLines="true" textAlign="center" 	draggableColumns="true" sortableColumns="true" > ');
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="순번" itemRenderer="IndexNoItem" textAlign="center" width="4%" />');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="15%" />');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNO_DE"  headerText="'+parent.fn_text('bizrno')+'" width="13%" formatter="{maskfmt}"/>');
			 layoutStr.push('	<DataGridColumn dataField="MFC_BRCH_NM"  headerText="'+parent.fn_text('mfc_brch_nm')+'" width="13%"/>');
			 layoutStr.push('   <DataGridColumn dataField="BRCH_BIZRNO"     headerText="'+ parent.fn_text('brch_bizrno')+ '" width="9%"  textAlign="center" />'); //직매장번호
			 layoutStr.push('	<DataGridColumn dataField="MFC_BRCH_NO"  headerText="'+parent.fn_text('mfc_brch_no')+'" width="9%"/>');
			 /* layoutStr.push('	<DataGridColumn dataField="BIZR_TP_CD_NM"  headerText="'+parent.fn_text('bizr_tp_cd')+'" width="10%"/>');
			 layoutStr.push('	<DataGridColumn dataField="CUST_BIZRNM"  headerText="'+parent.fn_text('cust_bizrnm')+'" width="13%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BRCH_NM"  headerText="'+parent.fn_text('brch_nm')+'" width="13%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNO_DE"  headerText="'+parent.fn_text('bizrno')+'" width="10%" formatter="{maskfmt}"/>'); */
			 layoutStr.push('	<DataGridColumn dataField="STAT_NM"  headerText="'+parent.fn_text('deal_yn')+'" width="7%"/>');
			 layoutStr.push('	<DataGridColumn dataField="STD_FEE_REG_YN_NM"  headerText="'+parent.fn_text('std_fee_reg_yn')+'" width="12%"/>');
			 layoutStr.push('</columns>');
			 layoutStr.push('</DataGrid>');
			 layoutStr.push('</rMateGrid>');
		}
		
		 var editYn = false;
		 var indexData = '';
		
		// 그리드 및 메뉴 리스트 세팅
		 function gridReadyHandler(id) {
		 	 gridApp = document.getElementById(id);//그리드를 포함하는 div 객체
		     gridRoot = gridApp.getRoot();//데이터와 그리드를 포함하는 객체

		     gridApp.setLayout(layoutStr.join("").toString());
		     //gridApp.setData(searchList);
		     
		     var layoutCompleteHandler = function(event) {
		    	 dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		    	 selectorColumn = gridRoot.getObjectById("selector");
		    	 drawGridPagingNavigation(gridCurrentPage);  //페이징 표시
		    }
		
		    var dataCompleteHandler = function(event) {
		        dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		        dataGrid.setEnabled(true);
		        gridRoot.removeLoadingBar();
		    }
		    
		    gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		    gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		     
			 //파라미터 call back function 실행
			 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
			 	eval(INQ_PARAMS.FN_CALLBACK+"()");
			 }
		 }
		

 
	</script>
	
	<style type="text/css">
		.row .tit{width: 105px;}
	</style>

</head>
<body>
	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn_box" id="UR"></div>
		</div>
		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">
					<!-- 생산자명 combo -->
					<div class="col">
						<div class="tit" id="mfc_bizrnm"></div>
						<div class="box">
							<select id="MFC_BIZRNM_SEL" name="MFC_BIZRNM_SEL" style="width: 179px" class="i_notnull"></select>
						</div>
					</div>
					<!-- 직매장/공장 combo -->
					<div class="col">
						<div class="tit" id="mfc_brch_nm"></div>
						<div class="box">
							<select id="MFC_BRCH_NM_SEL" name="MFC_BRCH_NM_SEL" style="width: 179px" class="i_notnull"></select>
						</div>
					</div>
					<!-- 거래구분 combo -->
					<div class="col">
						<div class="tit" id="stat_cd"></div>
						<div class="box">
							<select id="STAT_CD_SEL" style="width: 179px" class="i_notnull"></select>
						</div>
					</div>
					<div class="btn" id="CR">
				</div>
	
				<!-- <div class="row">
					거래처구분 combo
					<div class="col">
						<div class="tit" id="bizr_tp_cd"></div>
						<div class="box">
							<select id="BIZR_TP_CD_SEL" name="BIZR_TP_CD_SEL" style="width: 179px" class="i_notnull"></select>
						</div>
					</div> 
					거래처명 text
					<div class="col" >
						<div class="tit" id="cust_bizrnm"></div>
						<div class="box">
							<input type="text" id="CUST_BIZRNM_SEL" name="CUST_BIZRNM_SEL"  style="width: 179px; class="i_notnull">
						</div>
					</div>
					거래처사업자번호 text
					<div class="col" >
						<div class="tit" id="cust_bizrno"></div>
						<div class="box">
							<input type="text" id="CUST_BIZRNO_SEL" name="CUST_BIZRNO_SEL" maxlength="10" style="width: 179px; class="i_notnull" format="number">
						</div>
					</div>
					<div class="btn" id="UR">
					</div>
				</div> -->
			</div>
		</section>
		
		<div class="boxarea mt10">
			<div id="gridHolder" style="height:564px;background: #FFF;""></div>
			<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
		</div>
		
		<section class="btnwrap" style="" >
			<div class="btn" id="BL"></div>
			<div class="btn" style="float:right" id="BR"></div>
		</section>
	
	</div>
	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="excel" />
	</form>
</body>
</html>
