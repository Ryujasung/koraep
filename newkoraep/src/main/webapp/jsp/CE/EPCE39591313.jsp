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
			
		/* 페이징 사용 등록 */
		gridRowsPerPage = 15;	// 1페이지에서 보여줄 행 수
		gridCurrentPage = 1;		// 현재 페이지
		gridTotalRowCount = 0; 	//전체 행 수
	
		var INQ_PARAMS; //파라미터 데이터

		$(document).ready(function(){
			
		    INQ_PARAMS 	=  jsonObject($("#INQ_PARAMS").val());	
			var bizrTpList 	=jsonObject($("#bizrTpList").val());	
			var areaList 	= jsonObject($("#areaList").val());	
		    var affOgnList = jsonObject($("#affOgnList").val());	
		    
			fn_btnSetting();

			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			$('#bizr_tp').text(parent.fn_text('bizr_tp'));
			$('#area_se').text(parent.fn_text('area_se'));
			$('#aff_ogn').text(parent.fn_text('aff_ogn'));
			$('#bizr_nm').text(parent.fn_text('bizr_nm'));
			$('#bizrno').text(parent.fn_text('bizrno'));
			
			kora.common.setEtcCmBx2(bizrTpList, "", "", $("#BIZR_TP_CD"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(areaList, "", "", $("#AREA_CD"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(affOgnList, "", "", $("#AFF_OGN_CD"), "ETC_CD", "ETC_CD_NM", "N", "T");
			
			fn_set_grid();
			
			$("#btn_sel").click(function(){
				//조회버튼 클릭시 페이징 초기화
				gridCurrentPage = 1;
				fn_sel();
			});
			
			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
		});
		
		/* 페이징 이동 스크립트 */
		function gridMovePage(goPage) {
			gridCurrentPage = goPage; //선택 페이지
			fn_sel(); //조회 펑션
		}
		
		//저장
		function fn_reg(){
			
			if(selectorColumn.getSelectedIndices().length < 1){
				alertMsg('선택된 데이터가 없습니다.');
				return;
			}
			
			confirm('저장하시겠습니까?', 'fn_reg_exec');
		}
		
		//저장
		function fn_reg_exec(){
			
			var data = {};
			var row = new Array();
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(item);
			}
			data["list"] = JSON.stringify(row);
			
			var url = "/CE/EPCE39591313_09.do";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
				} else {
					alertMsg("error");
				}
			});
		}
		
		function fn_cnl(){
			kora.common.goPageB('', INQ_PARAMS);
		}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){
			
			var input = {};
			input["BIZR_TP_CD"] 	= $("#BIZR_TP_CD option:selected").val();
			input["AREA_CD"] 		= $("#AREA_CD option:selected").val();
			input["AFF_OGN_CD"] 	= $("#AFF_OGN_CD option:selected").val();
			input["BIZRNM"] 		= $("#BIZRNM").val();
			input["BIZRNO"] 		= $("#BIZRNO").val();
			
			input["ATH_GRP_CD"] 	= INQ_PARAMS["SEL_PARAMS"].ATH_GRP_CD;
			input["ATH_BIZRID"] 	= INQ_PARAMS["SEL_PARAMS"].BIZRID;
			input["ATH_BIZRNO"] 	= INQ_PARAMS["SEL_PARAMS"].BIZRNO;
			
			/* 페이징  */
			input["ROWS_PER_PAGE"] = gridRowsPerPage;
			input["CURRENT_PAGE"] 	= gridCurrentPage;
			
			var url = "/CE/EPCE39591313_19.do";
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.searchList);
					
					/* 페이징 표시 */
					gridTotalRowCount = rtnData.totalCnt; //총 카운트
					drawGridPagingNavigation(gridCurrentPage);
				}else{
					alertMsg("error");
				}
				kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
			});
			
		}
		
		/**
		 * 그리드 관련 변수 선언
		 */
	    var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
		var gridApp, gridRoot, dataGrid, layoutStr, selectorColumn, rowIndex;
		var layoutStr = new Array();
		
		/**
		 * 메뉴관리 그리드 셋팅
		 */
		 function fn_set_grid() {
			 
			 rMateGridH5.create("grid", "gridHolder", jsVars, "100%", "100%");
			 
			 layoutStr.push('<rMateGrid>');
			 layoutStr.push('	<NumberMaskFormatter id="maskfmt" formatString="###-##-#####"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center">');
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" headerText="" width="4%" allowMultipleSelection="true" verticalAlign="middle" />');
			 layoutStr.push('	<DataGridColumn dataField="index"  headerText="'+parent.fn_text('sn')+'" width="4%" itemRenderer="IndexNoItem" />');
			 layoutStr.push('	<DataGridColumn dataField="AREA_NM"  headerText="'+parent.fn_text('area')+'" width="7%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('bizr_nm')+'" width="15%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNO_DE"  headerText="'+parent.fn_text('bizrno')+'" width="15%" formatter="{maskfmt}"/>');
			 layoutStr.push('	<DataGridColumn dataField="AFF_OGN_NM"  headerText="'+parent.fn_text('aff_ogn')+'" width="15%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZR_TP_NM"  headerText="'+parent.fn_text('bizr_tp')+'" width="10%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BRCH_NM"  headerText="'+parent.fn_text('brch_nm')+'" width="15%"/>');
			 layoutStr.push('	<DataGridColumn dataField="ATH_BRCH_NO"  headerText="'+parent.fn_text('brch_no')+'" width="15%"/>');
			 layoutStr.push('</columns>');
			
			 layoutStr.push('</DataGrid>');
			 layoutStr.push('</rMateGrid>');
		}
				
		// 그리드 및 메뉴 리스트 세팅
		 function gridReadyHandler(id) {
		 	 gridApp = document.getElementById(id);  // 그리드를 포함하는 div 객체
		     gridRoot = gridApp.getRoot();   // 데이터와 그리드를 포함하는 객체

		     gridApp.setLayout(layoutStr.join("").toString());
		     //gridApp.setData();
		     
		     var layoutCompleteHandler = function(event) {
		         dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		         dataGrid.addEventListener("change", selectionChangeHandler); //이벤트 등록
		         selectorColumn = gridRoot.getObjectById("selector");
		         
		         drawGridPagingNavigation(gridCurrentPage);  //페이징 표시
		     }

		     var selectionChangeHandler = function(event) {
				rowIndex = event.rowIndex;
			 }
		     
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);

		 }
		
	</script>
	
	<style type="text/css">
		.row .tit{width: 77px;}
	</style>
</head>
<body>
	<div class="iframe_inner">
	   <input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
		<input type="hidden" id="bizrTpList" value="<c:out value='${bizrTpList}' />" />
		<input type="hidden" id="areaList" value="<c:out value='${areaList}' />" />
		<input type="hidden" id="affOgnList" value="<c:out value='${affOgnList}' />" />
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
		</div>
		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">
					<div class="col">
						<div class="tit"  style="" id="bizr_tp"></div>
						<div class="box">						
							<select id="BIZR_TP_CD" name="BIZR_TP_CD" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="area_se"></div>
						<div class="box">
							<select id="AREA_CD" name="AREA_CD" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="aff_ogn"></div>
						<div class="box">
							<select id="AFF_OGN_CD" name="AFF_OGN_CD" style="width: 179px;">
							</select>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col">
						<div class="tit"  style="" id="bizr_nm"></div>
						<div class="box">						
							<input id="BIZRNM" name="BIZRNM" type="text" style="width: 179px;" >
						</div>
					</div>
					<div class="col">
						<div class="tit" id="bizrno"></div>
						<div class="box">
							<input id="BIZRNO" name="BIZRNO" type="text" style="width: 179px;" >
						</div>
					</div>
					<div class="btn" id="UR">
					</div>
				</div>
			</div>
		</section>
		
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:400px;"></div>
			</div>
			<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
		</section>
		
		<section class="btnwrap" >
			<div class="btnwrap">
				<div class="fl_r" id="BR">
				</div>
			</div>
		</section>
	
	</div>

</body>
</html>
