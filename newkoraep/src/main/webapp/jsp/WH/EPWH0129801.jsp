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
		
		var INQ_PARAMS;
		var flag       = true;
		
		/* 페이징 사용 등록 */
		gridRowsPerPage = 15;	// 1페이지에서 보여줄 행 수
		gridCurrentPage = 1;		// 현재 페이지
		gridTotalRowCount = 0; 	//전체 행 수
		
		$(document).ready(function(){
			
			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			
			fn_btnSetting();
			
			$('#dept_se').text(parent.fn_text('dept_se'));
			$('#dept_nm').text(parent.fn_text('dept_nm'));
			$('#bizr_tp').text(parent.fn_text('bizr_tp'));
			$('#bizr_nm').text(parent.fn_text('bizr_nm'));
			
			//부서구분 콤보박스
			var dept_se_sel = jsonObject($('#dept_se_sel').val());
			//사업자유형 콤보박스
			var bizr_tp_cd_sel = jsonObject($('#bizr_tp_cd_sel').val());
			
			//콤보박스
			kora.common.setEtcCmBx2(dept_se_sel, "", "", $("#STD_YN_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(bizr_tp_cd_sel, "", "", $("#BIZR_TP_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			
			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
				/* 화면이동 페이징 셋팅 */
				gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
			}
			
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
				fn_upd();
			});
			
			//활동복원
			$("#btn_activity").click(function(){
				fn_activity();
			});
			//비활동처리
			$("#btn_inactivity").click(function(){
				fn_inactivity();
			});
			
		});
		
		/* 페이징 이동 스크립트 */
		function gridMovePage(goPage) {
			gridCurrentPage = goPage; //선택 페이지
			fn_sel(); //조회 펑션
		}
		
		//활동복원
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
				alertMsg("비활동 상태가 아닌 부서가 선택되었습니다.\n다시 한 번 확인하사기 바랍니다.");
				return;
			}
			
			confirm('활동 처리하시겠습니까?', 'fn_activity_exec');
			
		}
		//확동복원 confirm 처리
		function fn_activity_exec(){
			var selector = gridRoot.getObjectById("selector");
			var chkLst = selector.getSelectedItems();
			var url  = "/WH/EPWH0129801_21.do";
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
					alertMsg(rtnData.RSLT_MSG);

					fn_sel();
				} else {
					alertMsg("error");
				}
			});
			
		}
		
		//비활동처리
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
				alertMsg("활동 상태가 아닌 부서가 선택되었습니다.\n다시 한 번 확인하사기 바랍니다.");
				return;
			}
			confirm('비활동 처리하시겠습니까?', 'fn_inactivity_exec');
			
		}
		//비활동처리 confirm 처리
		function fn_inactivity_exec(){
			var selector = gridRoot.getObjectById("selector");
			var chkLst = selector.getSelectedItems();
			var url  = "/WH/EPWH0129801_21.do";
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
					alertMsg(rtnData.RSLT_MSG);

					fn_sel();
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
			input["STD_YN_SEL"] 			= $("#STD_YN_SEL option:selected").val();
			input["BIZR_TP_CD_SEL"] 	= $("#BIZR_TP_CD_SEL option:selected").val();
			input["DEPT_NM_SEL"] 		= $("#DEPT_NM_SEL").val();
			input["BIZRNM_SEL"] 			= $("#BIZRNM_SEL").val();
			
			/* 페이징  */
			input["ROWS_PER_PAGE"] = gridRowsPerPage;
			input["CURRENT_PAGE"] 	= gridCurrentPage;
			
			//파라미터에 조회조건값 저장 
			INQ_PARAMS["SEL_PARAMS"] = input;
			
			var url = "/WH/EPWH012980119.do";
			
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
				kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
				
			});
		}
		
		/**
		 * 등록화면 이동
		 */
		function fn_reg(){
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH0129801.do";
			kora.common.goPage('/WH/EPWH0129831.do', INQ_PARAMS);
		}
		
		/**
		 * 변경화면 이동
		 */
		function fn_upd(){
			
			var chkLst = selectorColumn.getSelectedItems();
			var item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[0]);
			
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}
			
			if(chkLst.length > 1){
				alertMsg("한건만 선택이 가능합니다.");
				return;
			}
			
			var input = {};
			//data값 변경해야함.
			input["DEPT_CD"] 	= item.DEPT_CD;
			input["BIZRID"] 		= item.BIZRID;
			input["BIZRNO"] 		= item.BIZRNO;
			input["DEPT_LVL"] 	= item.DEPT_LVL;
			
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH0129801.do";
			kora.common.goPage('/WH/EPWH0129842.do', INQ_PARAMS);
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
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" verticalGridLines="true" headerHeight="35" headerWordWrap="true" horizontalGridLines="true" textAlign="center"');
			 layoutStr.push(' 	draggableColumns="true" sortableColumns="true"  doubleClickEnabled="false" liveScrolling="false" showScrollTips="true">');
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" textAlign="center" allowMultipleSelection="true" width="3%" height="5%" verticalAlign="middle" />');
			 layoutStr.push('	<DataGridColumn dataField="PNO" headerText="'+ parent.fn_text('sn')+ '" textAlign="center" width="4%"   draggable="false"/>');
			 layoutStr.push('	<DataGridColumn dataField="DEPT_NM"  headerText="'+parent.fn_text('dept_nm')+'" width="25%" />');
			 layoutStr.push('	<DataGridColumn dataField="DEPT_CD"  headerText="'+parent.fn_text('dept_cd')+'" width="10%"/>');
			 layoutStr.push('	<DataGridColumn dataField="UP_DEPT_CD"  headerText="'+parent.fn_text('up_dept')+'" width="10%"/>');
			 layoutStr.push('	<DataGridColumn dataField="STD_YN"  headerText="'+parent.fn_text('dept_se')+'" width="10%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZR_TP_NM"  headerText="'+parent.fn_text('bizr_tp')+'" width="15%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('bizr_nm')+'" width="10%"/>');
			 layoutStr.push('	<DataGridColumn dataField="STAT_NM"  headerText="'+parent.fn_text('stat')+'" width="10%"/>');
			 layoutStr.push('</columns>');
			
			 layoutStr.push('</DataGrid>');
			 layoutStr.push('</rMateGrid>');
		}
		
		
		 var editYn = false;
		 var indexData = '';
		
		// 그리드 및 메뉴 리스트 세팅
		 function gridReadyHandler(id) {
		 	 gridApp = document.getElementById(id);  // 그리드를 포함하는 div 객체
		     gridRoot = gridApp.getRoot();   // 데이터와 그리드를 포함하는 객체

		     gridApp.setLayout(layoutStr.join("").toString());
		     //gridApp.setData([]);
		     
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
		     
			 //파아미터 call back function 실행
			 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
			 	eval(INQ_PARAMS.FN_CALLBACK+"()");
			 }
		 }
		

 
	</script>
	
	<style type="text/css">
		.row .tit{width: 65px;}
	</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="dept_se_sel" value="<c:out value='${dept_se_sel}' />"/>
<input type="hidden" id="bizr_tp_cd_sel" value="<c:out value='${bizr_tp_cd_sel}' />"/>

	<!-- 메뉴관리 -->
	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
		</div>
		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">
					<div class="col">
						<div class="tit" id="dept_se"></div>
						<div class="box">
							<select id="STD_YN_SEL" style="width: 179px" class="i_notnull"></select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="dept_nm"></div>
						<div class="box">
							<input type="text" id="DEPT_NM_SEL" maxlength="20" style="width: 179px; text-align: right;" class="i_notnull">
						</div>
					</div>
				</div>
	
				<div class="row">
					<div class="col">
						<div class="tit" id="bizr_tp"></div>
						<div class="box">
							<select id="BIZR_TP_CD_SEL" name="BIZR_TP_CD_SEL" style="width: 179px" class="i_notnull"></select>
						</div>
						
					</div>
					<div class="col" >
						<div class="tit" id="bizr_nm"></div>
						<div class="box">
							<input type="text" id="BIZRNM_SEL" name="BIZRNM_SEL" maxlength="30" style="width: 179px; text-align: right;" class="i_notnull">
						</div>
					</div>
					<div class="btn" id="UR">
					</div>
				</div>
			</div>
		</section>
		
		<div class="boxarea mt10">
			<div id="gridHolder" style="height:418px;"></div>
			<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
		</div>

		<section class="btnwrap" style="" >
				<div class="btn" id="BL">
				</div>
				
				<div class="btn" style="float:right" id="BR">
				</div>
		</section>
	
	</div>

</body>
</html>
