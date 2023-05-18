<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
	
		var INQ_PARAMS; //파라미터 데이터
		var menuSetList;
		var bizrTpList;
		var athGrpList;
	
		$(document).ready(function(){
			
			INQ_PARAMS	=  jsonObject($("#INQ_PARAMS").val());       
			menuSetList 	=  jsonObject($("#menuSetList").val());
			bizrTpList 		=  jsonObject($("#bizrTpList").val());       
			athGrpList 		=  jsonObject($("#athGrpList").val());      

			
			fn_btnSetting();
			
			$('#menu_set_sel').text(parent.fn_text('menu_set'));
			$('#bizr_tp_sel').text(parent.fn_text('bizr_tp'));
			$('#ath_grp_sel').text(parent.fn_text('ath_grp'));
			
			$('#ath_grp').text(parent.fn_text('ath_grp'));
			$('#menu').text(parent.fn_text('menu'));
			
			kora.common.setEtcCmBx2(menuSetList, "", "", $("#MENU_SET_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(bizrTpList, "", "", $("#BIZR_TP_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(athGrpList, "", "", $("#ATH_GRP_CD_SEL"), "ATH_GRP_CD", "ATH_GRP_NM", "N", "T");
			
			fn_set_grid();
			fn_set_grid2();
			
			$('#MENU_SET_CD_SEL').change(function(){
				fn_athGrpCdSel();
			});
			$('#BIZR_TP_CD_SEL').change(function(){
				fn_athGrpCdSel();
			});
			
			$("#btn_sel").click(function(){
				fn_sel();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			$("#btn_page").click(function(){
				fn_page();
			});
			
		});
		
		/**
		 * 화면이동
		 */
		function fn_page(){
			
			var idx  = dataGrid.getSelectedIndices();
			
			if(idx == '' || idx == null || idx == undefined){
				alertMsg('선택된 권한그룹이 없습니다');
				return;
			}
			
			fn_page_mov();
			//confirm('이동하시겠습니까?', 'fn_page_mov');
		}
		
		function fn_page_mov(){
			
			var idx  = dataGrid.getSelectedIndices();
			var item = gridRoot.getItemAt(idx);
			
			var input = {};
			input["ATH_GRP_CD"] 	= item.ATH_GRP_CD;
			input["BIZRID"] 			= item.BIZRID;
			input["BIZRNO"] 			= item.BIZRNO;
			
			input["MENU_SET_NM"] = item.MENU_SET_NM;
			input["BIZR_TP_NM"] 	 = item.BIZR_TP_NM;
			input["ATH_GRP_NM"]   = item.ATH_GRP_NM;
			
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE3978301.do";
			kora.common.goPage('/CE/EPCE3991801.do', INQ_PARAMS);
		}
		
		function fn_athGrpCdSel(){
			
			var ms = $("#MENU_SET_CD_SEL option:selected").val();
			var bs = $("#BIZR_TP_CD_SEL option:selected").val();
			var as = $("#ATH_GRP_CD_SEL option:selected").val();
			var jArray  = new Array();
			
			$.each(athGrpList, function(key, value){
				
				var jData = athGrpList[key];
				var obj = new Object();
				
				if(ms != '' && ms != jData['MENU_SET_CD']){
					return true; //continue
				}
				if(bs != '' && bs != jData['BIZR_TP_CD']){
					return true; //continue
				}
				
				obj.ATH_GRP_CD = jData['ATH_GRP_CD'];
				obj.ATH_GRP_NM = jData['ATH_GRP_NM'];
				jArray.push(obj);
			});

			kora.common.setEtcCmBx2(jArray, "", as, $("#ATH_GRP_CD_SEL"), "ATH_GRP_CD", "ATH_GRP_NM", "N", "T");
		}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){

			var input = {};
			input["MENU_SET_CD_SEL"] 	= $("#MENU_SET_CD_SEL option:selected").val();
			input["BIZR_TP_CD_SEL"] 	= $("#BIZR_TP_CD_SEL option:selected").val();
			input["ATH_GRP_CD_SEL"] 	= $("#ATH_GRP_CD_SEL option:selected").val();
			
			var url = "/CE/EPCE3978301_19.do";

			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp2.setData([]);
					gridApp.setData(rtnData.searchList);
				} 
				else {
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
		
		/**
		 * 그리드 셋팅
		 */
		 function fn_set_grid() {
			 
			 rMateGridH5.create("grid", "gridHolder", jsVars, "100%", "100%");
			 
			 layoutStr.push('<rMateGrid>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center">');
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="false" headerText="'+parent.fn_text('cho')+'" width="8%" />');
			 layoutStr.push('	<DataGridColumn dataField="ATH_GRP_CD"  headerText="'+parent.fn_text('ath_grp_cd')+'" width="18%" />');
			 layoutStr.push('	<DataGridColumn dataField="MENU_SET_NM"  headerText="'+parent.fn_text('menu_set')+'" width="15%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZR_TP_NM"  headerText="'+parent.fn_text('bizr_tp')+'" width="15%"/>');
			 layoutStr.push('	<DataGridColumn dataField="ATH_GRP_NM"  headerText="'+parent.fn_text('ath_grp_nm')+'" width="44%"/>');
			 layoutStr.push('</columns>');
			 layoutStr.push('</DataGrid>');
			 layoutStr.push('</rMateGrid>');
		}
		
		// 그리드 및 메뉴 리스트 세팅
		 function gridReadyHandler(id) {
		 	 gridApp = document.getElementById(id);  // 그리드를 포함하는 div 객체
		     gridRoot = gridApp.getRoot();   // 데이터와 그리드를 포함하는 객체
		     gridApp.setLayout(layoutStr.join("").toString());
		     gridApp.setData([]);

		     var layoutCompleteHandler = function(event) {
		         dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		         dataGrid.addEventListener("change", selectionChangeHandler); //이벤트 등록
		     }
		     var selectionChangeHandler = function(event) {
				var rowIndex = event.rowIndex;
				selectorColumn.setSelectedIndex(-1);
				selectorColumn.setSelectedIndex(rowIndex);
				fn_rowToSel();
			 }
		     var dataCompleteHandler = function(event) {
		    	 selectorColumn = gridRoot.getObjectById("selector");
		 	 }
		     
		     gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		     
		     //파라미터 call back function 실행
			 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
				 /* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
			 	 window[INQ_PARAMS.FN_CALLBACK]();
			 	//취약점점검 5920 기원우
			 }
		 }
		
		//행선택시 조회
		function fn_rowToSel() {
			var item = gridRoot.getItemAt(selectorColumn.getSelectedIndex());
			
			var input = {};
			input["ATH_GRP_CD"] 		= item["ATH_GRP_CD"];
			input["MENU_SET_CD"] 	= item["MENU_SET_CD"];
			input["BIZRID"] 				= item["BIZRID"];
			input["BIZRNO"] 				= item["BIZRNO"];
			
			var url = "/CE/EPCE3978301_192.do";
			
			kora.common.showLoadingBar(dataGrid2, gridRoot2);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp2.setData(rtnData.searchList);
				}else{
					alertMsg("error");
				}
				kora.common.hideLoadingBar(dataGrid2, gridRoot2);// 그리드 loading bar off

			});
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
			 layoutStr2.push('	<DataGridSelectorColumn id="selector" headerText="" width="7%" verticalAlign="middle" itemRenderer="checkBoxItem" rendererIsEditor="true" editorDataField="selected" />');
			 layoutStr2.push('	<DataGridColumn dataField="MENU_GRP_NM"  headerText="'+parent.fn_text('menu_grp')+'" width="20%" itemRenderer="HtmlItem" />');
			 layoutStr2.push('	<DataGridColumn dataField="MENU_CD"  headerText="'+parent.fn_text('menu_cd')+'" width="13%"/>');
			 layoutStr2.push('	<DataGridColumn dataField="MENU_NM"  headerText="'+parent.fn_text('menu_nm')+'" width="60%"/>');
			 layoutStr2.push('	<DataGridColumn dataField="LANG_SE_CD" visible="false" />');
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
		     }
		     var dataCompleteHandler = function(event) {
		     	dataGrid2 = gridRoot2.getDataGrid();
		     	selectorColumn2 = gridRoot2.getObjectById("selector");
		     	fn_setChkBox();

		 	 }
		     
		     gridRoot2.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot2.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
		
		//체크박스 체크
		 function fn_setChkBox(){
		 	var collection = gridRoot2.getCollection();
		 	var arrIdx = [];
		 	for(var i=0;i<collection.getLength(); i++){
		 		var tmpData = gridRoot2.getItemAt(i);
		 		if(tmpData.SELECTED == "Y") arrIdx.push(i);
		 	}
		 	selectorColumn2.setSelectedIndices(arrIdx);
		}
		
		//저장
		function fn_reg(){
			var selArr = selectorColumn2.getSelectedIndices();
			var collection = gridRoot2.getCollection();
			for(var i=0;i<collection.getLength(); i++){
				var tmpData = gridRoot2.getItemAt(i);
				if($.inArray(i, selArr) > -1){
					tmpData.SELECTED = 'Y';
				}else{
					tmpData.SELECTED = 'N';			
				}
				gridRoot2.setItemAt(tmpData, i);
			}
			
			var input = {};
			input["list"] = JSON.stringify(gridRoot2.getGridData());

			var item = gridRoot.getItemAt(selectorColumn.getSelectedIndex());
			input["ATH_GRP_CD"] 		= item["ATH_GRP_CD"];
			input["BIZRID"] 				= item["BIZRID"];
			input["BIZRNO"] 				= item["BIZRNO"];
			
			var url = "/CE/EPCE3978301_09.do";
			ajaxPost(url, input, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_rowToSel');
				} else {
					alertMsg("error");
				}
			});
		}
		
	</script>

</head>
<body>
	<!-- 메뉴권한관리 -->
	<div class="iframe_inner">
	    <input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
		<input type="hidden" id="menuSetList" value="<c:out value='${menuSetList}' />" />
		<input type="hidden" id="bizrTpList" value="<c:out value='${bizrTpList}' />" />
		<input type="hidden" id="athGrpList" value="<c:out value='${athGrpList}' />" />
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
		</div>
		<section class="secwrap">
			<div class="srcharea">
				<div class="row">
					<div class="col">
						<div class="tit" id="menu_set_sel"></div>
						<div class="box">						
							<select id="MENU_SET_CD_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="bizr_tp_sel"></div>
						<div class="box">
							<select id="BIZR_TP_CD_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="ath_grp_sel"></div>
						<div class="box">
							<select id="ATH_GRP_CD_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="btn" id="UR">
					</div>
				</div>
			</div>
		</section>
		
		<section class="secwrap mt30">
			<div class="halfarea" style="width: 49%; float: left;">
				<div class="h4group">
					<h4 class="tit"  id='ath_grp'></h4>
				</div>
		        <div class="boxarea">
		            <div id="gridHolder" class="w_382" style="height:560px;"></div>
		        </div> 
			</div>
				
		    <div class="halfarea" style="width: 49%; float: right;">
				<div class="h4group">
					<h4 class="tit" id='menu'></h4>
				</div>	
		      	<div class="boxarea">
		      	    <div id="gridHolder2" class="w_382" style="height:560px;">  
		      	</div>
	      </div>
		</section>
		
		<section class="btnwrap mt20" >
			<div class="btn" id="BL">
			</div>
			<div class="btn" id="BR" style="float:right">
			</div>
		</section>
	</div>
</body>
</html>
