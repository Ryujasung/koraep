<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
		
		var INQ_PARAMS; //파라미터 데이터
		var menuList;
		
		$(document).ready(function(){
			INQ_PARAMS 		=  jsonObject($("#INQ_PARAMS").val());      
			menuList 		=  jsonObject($("#menuList").val());       
			fn_btnSetting();
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			$('#menu_set_sel').text(parent.fn_text('menu_set'));
			$('#bizr_tp_sel').text(parent.fn_text('bizr_tp'));
			$('#ath_grp_sel').text(parent.fn_text('ath_grp'));
			$('#menu').text(parent.fn_text('menu'));
			$('#btn').text(parent.fn_text('btn'));
			
			$('#MENU_SET_NM').text(INQ_PARAMS['PARAMS'].MENU_SET_NM);
			$('#BIZR_TP_NM').text(INQ_PARAMS['PARAMS'].BIZR_TP_NM);
			$('#ATH_GRP_NM').text(INQ_PARAMS['PARAMS'].ATH_GRP_NM);
			
			fn_set_grid2();
			fn_set_grid3();
			
			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
		});
		
		function fn_cnl(){
			kora.common.goPageB('', INQ_PARAMS);
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
			 layoutStr2.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg2" headerHeight="35" horizontalGridLines="true" draggableColumns="false" sortableColumns="false" textAlign="center" doubleClickEnabled="false" >');
			 layoutStr2.push('<columns>');
			 layoutStr2.push('	<DataGridSelectorColumn id="selector" headerText="" width="7%" verticalAlign="middle" allowMultipleSelection="false" />');
			 layoutStr2.push('	<DataGridColumn dataField="MENU_GRP_NM"  headerText="'+parent.fn_text('menu_grp')+'" width="20%" itemRenderer="HtmlItem" />');
			 layoutStr2.push('	<DataGridColumn dataField="MENU_CD"  headerText="'+parent.fn_text('menu_cd')+'" width="18%" textAlign="left" styleJsFunction="fn_rowStyle" />');
			 layoutStr2.push('	<DataGridColumn dataField="MENU_NM"  headerText="'+parent.fn_text('menu_nm')+'" width="55%" textAlign="left" />');
			 layoutStr2.push('</columns>');
			 layoutStr2.push('<dataProvider>');
			 layoutStr2.push('	<SpanSummaryCollection source="{$gridData}">');
			 layoutStr2.push('		<mergingFields>');
			 layoutStr2.push('			<SpanMergingField name="MENU_GRP_NM" colNum="1"/>');
			 layoutStr2.push('		</mergingFields>');
			 layoutStr2.push('	</SpanSummaryCollection>');
			 layoutStr2.push('</dataProvider>');
			 
			 layoutStr2.push('</DataGrid>');
			 layoutStr2.push('</rMateGrid>');
		}
		
		// 그리드 및 메뉴 리스트 세팅
		 function gridReadyHandler2(id) {
		 	 gridApp2 = document.getElementById(id);  // 그리드를 포함하는 div 객체
		     gridRoot2 = gridApp2.getRoot();   // 데이터와 그리드를 포함하는 객체

		     gridApp2.setLayout(layoutStr2.join("").toString());
		     gridApp2.setData([]);
		     
		     var layoutCompleteHandler = function(event) {
		         dataGrid2 = gridRoot2.getDataGrid();  // 그리드 객체
		         gridApp2.setData(menuList);
		         dataGrid2.addEventListener("change", selectionChangeHandler); //이벤트 등록
		     }
		     var selectionChangeHandler = function(event) {
				var rowIndex2 = event.rowIndex;
				selectorColumn2.setSelectedIndex(-1);
				selectorColumn2.setSelectedIndex(rowIndex2);
				fn_rowToSel();
			 }
		     var dataCompleteHandler = function(event) {
		     	selectorColumn2 = gridRoot2.getObjectById("selector");
		 	 }
		     
		     gridRoot2.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot2.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
		
		//행선택시 조회
		function fn_rowToSel() {
			var item = gridRoot2.getItemAt(selectorColumn2.getSelectedIndex());
			
			var input = {};
			input["MENU_CD"] 		= item["MENU_CD"];
			input["LANG_SE_CD"] 	= item["LANG_SE_CD"];
			input["ATH_GRP_CD"] 	= item["ATH_GRP_CD"];
			input["BIZRID"] 			= item["BIZRID"];
			input["BIZRNO"] 			= item["BIZRNO"];
			
			var url = "/CE/EPCE3991801_19.do";
			
			kora.common.showLoadingBar(dataGrid3, gridRoot3);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp3.setData(rtnData.searchList);
				}else{
					alertMsg("error");
				}
				kora.common.hideLoadingBar(dataGrid3, gridRoot3);// 그리드 loading bar off

			});
		}
		
		//로우 스타일
		function fn_rowStyle(item, column){
			if(item.LEVEL == '1'){
				//return {"fontWeight":"bold" };
			}else if(item.LEVEL == '2'){
				return {"padding-left":"20px" };
			}else if(item.LEVEL == '3'){
				return {"padding-left":"20px" };
			}
			return null;
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
			 layoutStr3.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg3" headerHeight="35" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" doubleClickEnabled="false" >');
			 layoutStr3.push('<columns>');
			 layoutStr3.push('	<DataGridSelectorColumn id="selector" headerText="" width="7%" verticalAlign="middle" itemRenderer="checkBoxItem" rendererIsEditor="true" editorDataField="selected" />');
			 layoutStr3.push('	<DataGridColumn dataField="BTN_SE_NM"  headerText="'+parent.fn_text('btn_se')+'" width="20%" />');
			 layoutStr3.push('	<DataGridColumn dataField="BTN_LC_SE_NM"  headerText="'+parent.fn_text('lc_se')+'" width="15%"/>');
			 layoutStr3.push('	<DataGridColumn dataField="BTN_CD"  headerText="'+parent.fn_text('btn_cd')+'" width="20%"/>');
			 layoutStr3.push('	<DataGridColumn dataField="BTN_NM"  headerText="'+parent.fn_text('btn_nm')+'" width="20%"/>');
			 layoutStr3.push('	<DataGridColumn dataField="BTCH_APLC"  headerText="'+parent.fn_text('btch_aplc')+'" width="18%" itemRenderer="HtmlItem"/>');
			 layoutStr3.push('	<DataGridColumn dataField="MENU_CD" visible="false" />');
			 layoutStr3.push('	<DataGridColumn dataField="LANG_SE_CD" visible="false" />');
			 layoutStr3.push('</columns>');				 
			 layoutStr3.push('</DataGrid>');
			 layoutStr3.push('</rMateGrid>');

		}
		
		// 그리드 및 메뉴 리스트 세팅
		 function gridReadyHandler3(id) {
		 	 gridApp3 = document.getElementById(id);  // 그리드를 포함하는 div 객체
		     gridRoot3 = gridApp3.getRoot();   // 데이터와 그리드를 포함하는 객체

		     gridApp3.setLayout(layoutStr3.join("").toString());
		     gridApp3.setData([]);

		     var layoutCompleteHandler = function(event) {
		         dataGrid3 = gridRoot3.getDataGrid();  // 그리드 객체
		         dataGrid3.addEventListener("change", selectionChangeHandler); //이벤트 등록
		     }
		     var dataCompleteHandler = function(event) {
		     	selectorColumn3 = gridRoot3.getObjectById("selector");
		     	fn_setChkBox();
		 	 }
		     var selectionChangeHandler = function(event) {
		    	 rowIndex3 = event.rowIndex;
			 }
	
		     gridRoot3.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot3.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
		
		//체크박스 체크
		function fn_setChkBox(){
		 	var collection = gridRoot3.getCollection();
		 	var arrIdx = [];
		 	for(var i=0;i<collection.getLength(); i++){
		 		var tmpData = gridRoot3.getItemAt(i);
		 		if(tmpData.SELECTED == "Y") arrIdx.push(i);
		 	}
		 	selectorColumn3.setSelectedIndices(arrIdx);
		}
		
		//저장
		function fn_reg(){
			var selArr = selectorColumn3.getSelectedIndices();
			var collection = gridRoot3.getCollection();
			for(var i=0;i<collection.getLength(); i++){
				var tmpData = gridRoot3.getItemAt(i);
				if($.inArray(i, selArr) > -1){
					tmpData.SELECTED = 'Y';
				}else{
					tmpData.SELECTED = 'N';			
				}
				gridRoot3.setItemAt(tmpData, i);
			}
			
			var input = {};
			input["list"] = JSON.stringify(gridRoot3.getGridData());

			var item = gridRoot2.getItemAt(selectorColumn2.getSelectedIndex());
			input["ATH_GRP_CD"] 		= item["ATH_GRP_CD"];
			input["BIZRID"] 				= item["BIZRID"];
			input["BIZRNO"] 				= item["BIZRNO"];
			
			var url = "/CE/EPCE3991801_09.do";
			ajaxPost(url, input, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_rowToSel');
				} else {
					alertMsg("error");
				}
			});
		}
		
		var parent_item;
		//일괄적용
		function fn_btch_aplc(){

			parent_item = gridRoot3.getItemAt(rowIndex3);
			var pagedata = window.frameElement.name;

			window.parent.NrvPub.AjaxPopup('/CE/EPCE3991888.do', pagedata);
		}

	</script>

</head>
<body>

	<div class="iframe_inner">
		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
		<input type="hidden" id="menuList" value="<c:out value='${menuList}' />" />
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
		</div>
		<section class="secwrap">
			<div class="srcharea">
				<div class="row">
					<div class="col">
						<div class="tit" id="menu_set_sel"></div>
						<div class="boxView" id="MENU_SET_NM">
						</div>
					</div>
					<div class="col">
						<div class="tit" id="bizr_tp_sel"></div>
						<div class="boxView" id="BIZR_TP_NM">
						</div>
					</div>
					<div class="col">
						<div class="tit" id="ath_grp_sel"></div>
						<div class="boxView" id="ATH_GRP_NM">
						</div>
					</div>
				</div>
			</div>
		</section>
		
		<section class="secwrap mt30">
			<div class="halfarea" style="width: 49%; float: left;">
				<div class="h4group">
					<h4 class="tit"  id='menu'></h4>
				</div>
		        <div class="boxarea">
		            <div id="gridHolder2" class="w_382" style="height:560px;"></div>
		        </div> 
			</div>
			
		    <div class="halfarea" style="width: 49%; float: right;">
				<div class="h4group">
					<h4 class="tit" id='btn'></h4>
				</div>	
		      	<div class="boxarea">
		      	    <div id="gridHolder3" class="w_382" style="height:560px;">
		      	</div>
	      </div>
		</section>
		
		<section class="btnwrap mt20" >
			<div class="btn" id="BR" style="float:right">
			</div>
		</section>
	</div>
</body>
</html>
