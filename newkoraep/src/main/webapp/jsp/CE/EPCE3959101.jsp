<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
			
		var INQ_PARAMS;//파라미터 데이터
		var athGrpList;
	
		$(document).ready(function(){
			
			INQ_PARAMS 	=  jsonObject($("#INQ_PARAMS").val());	
			athGrpList		=  jsonObject($("#athGrpList").val());       

			
			fn_btnSetting();

			fn_set_grid();
			fn_set_grid2();
			
			$("#btn_page").click(function(){
				fn_page();
			});
			
			$("#btn_page2").click(function(){
				fn_page2();
			});
			
			$("#btn_page3").click(function(){
				fn_page3();
			});
			
		});
		
		/**
		 * 지역권한설정 이동
		 */
		function fn_page(){
			
			var idx  = dataGrid.getSelectedIndices();
			var item = gridRoot.getItemAt(idx);
			
			if(idx == '' || idx == null || idx == undefined){
				alertMsg('선택된 행이 없습니다.');
				return;
			}
			
			var input = {};
			input["ATH_GRP_CD"] 	= item.ATH_GRP_CD;
			input["BIZRID"] 			= item.BIZRID;
			input["BIZRNO"] 			= item.BIZRNO;
			input["MENU_SET_NM"] 		= item.MENU_SET_NM;
			input["BIZR_TP_NM"] 			= item.BIZR_TP_NM;
			input["ATH_GRP_NM"] 			= item.ATH_GRP_NM;
			
			INQ_PARAMS["SEL_PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "getRowIndex";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE3959101.do";
			kora.common.goPage('/CE/EPCE3959131.do', INQ_PARAMS);
		}
		
		/**
		 * 소속단체권한설정 이동
		 */
		function fn_page2(){
			
			var idx  = dataGrid.getSelectedIndices();
			var item = gridRoot.getItemAt(idx);
			
			if(idx == '' || idx == null || idx == undefined){
				alertMsg('선택된 행이 없습니다.');
				return;
			}
			
			var input = {};
			input["ATH_GRP_CD"] 	= item.ATH_GRP_CD;
			input["BIZRID"] 			= item.BIZRID;
			input["BIZRNO"] 			= item.BIZRNO;
			input["MENU_SET_NM"] 		= item.MENU_SET_NM;
			input["BIZR_TP_NM"] 			= item.BIZR_TP_NM;
			input["ATH_GRP_NM"] 			= item.ATH_GRP_NM;
			
			INQ_PARAMS["SEL_PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "getRowIndex";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE3959101.do";
			kora.common.goPage('/CE/EPCE39591312.do', INQ_PARAMS);
		}
		
		/**
		 * 개별사업자권한설정 이동
		 */
		function fn_page3(){
			
			var idx  = dataGrid.getSelectedIndices();
			var item = gridRoot.getItemAt(idx);
			
			if(idx == '' || idx == null || idx == undefined){
				alertMsg('선택된 행이 없습니다.');
				return;
			}
			
			var input = {};
			input["ATH_GRP_CD"] 	= item.ATH_GRP_CD;
			input["BIZRID"] 			= item.BIZRID;
			input["BIZRNO"] 			= item.BIZRNO;
			INQ_PARAMS["SEL_PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "getRowIndex";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE3959101.do";
			kora.common.goPage('/CE/EPCE39591313.do', INQ_PARAMS);
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
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center">');
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" headerText="'+parent.fn_text('cho')+'" width="10%" allowMultipleSelection="false" />');
			 layoutStr.push('	<DataGridColumn dataField="ATH_GRP_CD"  headerText="'+parent.fn_text('ath_grp_cd')+'" width="20%"/>');
			 layoutStr.push('	<DataGridColumn dataField="MENU_SET_NM"  headerText="'+parent.fn_text('menu_set')+'" width="20%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZR_TP_NM"  headerText="'+parent.fn_text('bizr_tp')+'" width="20%"/>');
			 layoutStr.push('	<DataGridColumn dataField="ATH_GRP_NM"  headerText="'+parent.fn_text('ath_grp_nm')+'" width="30%"/>');
			 layoutStr.push('</columns>');
			
			 layoutStr.push('</DataGrid>');
			 layoutStr.push('</rMateGrid>');
		}
		
		// 그리드 및 메뉴 리스트 세팅
		 function gridReadyHandler(id) {
		 	 gridApp = document.getElementById(id);  // 그리드를 포함하는 div 객체
		     gridRoot = gridApp.getRoot();   // 데이터와 그리드를 포함하는 객체

		     gridApp.setLayout(layoutStr.join("").toString());
		     gridApp.setData(athGrpList);
		     
		     var layoutCompleteHandler = function(event) {
		         dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		         dataGrid.addEventListener("change", selectionChangeHandler); //이벤트 등록
		         selectorColumn = gridRoot.getObjectById("selector");
		     }
		     var selectionChangeHandler = function(event) {
				rowIndex = event.rowIndex;
				selectorColumn.setSelectedIndex(-1);
				selectorColumn.setSelectedIndex(rowIndex);
				fn_rowToSel();
			 }
		     var dataCompleteHandler = function(event) {
		    	 
		    	 //파라미터 call back function 실행
				 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
				 	eval(INQ_PARAMS.FN_CALLBACK+"()");
				 }
		 	 }
			     
			 gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);

		 }
		
		 //데이터에 해당하는 행 선택
		 function getRowIndex(){
			 
			var ATH_GRP_CD  	= INQ_PARAMS["SEL_PARAMS"].ATH_GRP_CD;
			var BIZRID 			= INQ_PARAMS["SEL_PARAMS"].BIZRID;
			var BIZRNO			= INQ_PARAMS["SEL_PARAMS"].BIZRNO;
			
			var collection = gridRoot.getCollection();
		    var src = collection.getSource();
		    for(var i = 0; i < src.length; i++){
		        if(src[i].ATH_GRP_CD == ATH_GRP_CD && src[i].BIZRID == BIZRID && src[i].BIZRNO == BIZRNO){
		        	selectorColumn.setSelectedIndex(i);
		        	dataGrid.setSelectedIndex(i);
		        	fn_rowToSel();
		        	break;
		        }
		    }
		 }
		
		//행선택시 조회
		function fn_rowToSel() {
			
			var item = gridRoot.getItemAt(selectorColumn.getSelectedIndex());
			var input = {};
			input["ATH_GRP_CD"] 	= item["ATH_GRP_CD"];
			input["BIZRID"] 			= item["BIZRID"];
			input["BIZRNO"] 			= item["BIZRNO"];
			
			var url = "/CE/EPCE3959101_19.do";
			
			kora.common.showLoadingBar(dataGrid2, gridRoot2);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp2.setData(rtnData.searchList);
				}else{
					alertMsg("error");
				}
			}, false);
			kora.common.hideLoadingBar(dataGrid2, gridRoot2);// 그리드 loading bar off
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
			 layoutStr2.push('	<NumberMaskFormatter id="maskfmt" formatString="###-##-#####"/>');
			 layoutStr2.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg2" headerHeight="35" horizontalGridLines="true" draggableColumns="false" sortableColumns="false" textAlign="center" doubleClickEnabled="false" >');
			 layoutStr2.push('<columns>');
			 layoutStr2.push('	<DataGridSelectorColumn id="selector" headerText="" width="3%" verticalAlign="middle"  />');
			 layoutStr2.push('	<DataGridColumn dataField="index"  headerText="'+parent.fn_text('sn')+'" width="5%" itemRenderer="IndexNoItem" />');
			 layoutStr2.push('	<DataGridColumn dataField="AREA_NM"  headerText="'+parent.fn_text('area')+'" width="9%"/>');
			 layoutStr2.push('	<DataGridColumn dataField="AFF_OGN_NM"  headerText="'+parent.fn_text('aff_ogn')+'" width="13%"/>');
			 layoutStr2.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('bizr_nm')+'" width="15%"/>');
			 layoutStr2.push('	<DataGridColumn dataField="BIZRNO"  headerText="'+parent.fn_text('bizrno')+'" width="15%" formatter="{maskfmt}"/>');
			 layoutStr2.push('	<DataGridColumn dataField="BIZR_TP_NM"  headerText="'+parent.fn_text('bizr_tp')+'" width="10%"/>');
			 layoutStr2.push('	<DataGridColumn dataField="BRCH_NM"  headerText="'+parent.fn_text('brch_nm')+'" width="15%"/>');
			 layoutStr2.push('	<DataGridColumn dataField="BRCH_NO"  headerText="'+parent.fn_text('brch_no')+'" width="15%"/>');
			 layoutStr2.push('</columns>');		 
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
		         selectorColumn2 = gridRoot2.getObjectById("selector");
		     }

		     gridRoot2.addEventListener("layoutComplete", layoutCompleteHandler);
		 }

	</script>

	<style type="text/css">
		.row .tit{width: 77px;}
	</style>
</head>
<body>
	<div class="iframe_inner">
	   <input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
		<input type="hidden" id="athGrpList" value="<c:out value='${athGrpList}' />" />
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
		</div>
		<section class="secwrap">
			<div class="boxarea" style="width:700px">
				<div id="gridHolder" style="height:230px;"></div>
			</div>
		</section>
		
		<section class="secwrap mt20">
			<div class="boxarea">
				<div id="gridHolder2" style="height:330px;"></div>
			</div>
		</section>
		
		<section class="btnwrap mt20" >
			<div class="btnwrap">
				<div class="fl_r" id="BR">
				</div>
			</div>
		</section>

	</div>

</body>
</html>
