<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
		
		var parent_item;
		$(document).ready(function(){
			
			fn_btnSetting('EPCE0140188');
			
			parent_item = window.frames[$("#pagedata").val()].searchDtl;
			
			$("#titleSub").text("<c:out value="${titleSub}" />");
			
			$('#bizr_nm').text(parent.fn_text('bizr_nm'));
			$('#brch').text(parent.fn_text('brch'));
			$('#user_nm').text(parent.fn_text('user_nm'));
			$('#ath_grp').text(parent.fn_text('ath_grp'));
			$('#menu').text(parent.fn_text('menu'));
			
			$('#BIZRNM').text(parent_item.BIZRNM);
			$('#USER_NM').text(parent_item.USER_NM);
			
			if(parent_item.BIZR_TP_CD == 'T1'){ //센터
				$("#BRCH_NM").text(kora.common.null2void(parent_item.CET_BRCH_NM));
			}else{
				$("#BRCH_NM").text(kora.common.null2void(parent_item.BRCH_NM));
			}
			
			fn_set_grid();
			fn_set_grid2();
			
			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
		});
		
		function fn_reg(){
			
			var idx  = dataGrid.getSelectedIndices();
			
			if(idx == '' || idx == null || idx == undefined){
				alertMsg('선택된 행이 없습니다.');
				return;
			}
			
			var idx  = dataGrid.getSelectedIndices();
			var item = gridRoot.getItemAt(idx);
			
			// 사용자구분이 관리자(D)인 경우 관리자권한(F)부여 가능
			if (parent_item.USER_SE_CD != 'D' && item.ATH_SE_CD == 'F') {
				alertMsg('관리자 권한은 관리자 변경을 통해 부여 가능합니다.');
				return
			}
			
			
			confirm("저장 하시겠습니까?","fn_reg_exec");
			
		}
		
		function fn_reg_exec(){
			
			var idx  = dataGrid.getSelectedIndices();
			var item = gridRoot.getItemAt(idx);
			
			var input = {};
			input["USER_ID"] = parent_item.USER_ID;
			
			input["ATH_GRP_CD"] = item.ATH_GRP_CD;
			input["BIZRID"] = item.BIZRID;
			input["BIZRNO"] = item.BIZRNO;
			
		 	var url = "/CE/EPCE0140188_21.do";
		 	ajaxPost(url, input, function(rtnData){
			 	if ("" != rtnData && null != rtnData) {
			 		if(rtnData.RSLT_CD == '0000'){
						alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
				} else {
					alertMsg("error");
				}
		 	});
		}
		
		function fn_cnl(){
			window.frames[$("#pagedata").val()].fn_sel();
			$('[layer="close"]').trigger('click');
		}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){
			
			var url = "/CE/EPCE0140188_19.do";
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, parent_item, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.searchList);
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
		var rowIndex;
		
		/**
		 * 메뉴관리 그리드 셋팅
		 */
		 function fn_set_grid() {
			 
			 rMateGridH5.create("grid", "gridHolder", jsVars, "100%", "100%");
			 layoutStr.push('<rMateGrid>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" headerWordWrap="true" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center">');
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" headerText="'+parent.fn_text('cho')+'" width="15%" verticalAlign="middle" allowMultipleSelection="false" itemRenderer="checkBoxItem" rendererIsEditor="true" editorDataField="selected" />');
			 layoutStr.push('	<DataGridColumn dataField="ATH_GRP_NM"  headerText="'+parent.fn_text('ath_grp_nm')+'" width="85%"/>');
			 layoutStr.push('</columns>');
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
		         fn_sel();
		     }
		     var selectionChangeHandler = function(event) {
				rowIndex = event.rowIndex;
				selectorColumn.setSelectedIndex(-1);
				selectorColumn.setSelectedIndex(rowIndex);
				fn_rowToSel();
			 }
		     var dataCompleteHandler = function(event) {
		 	 }
		     
		     gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
		
		//행선택시 조회
		function fn_rowToSel() {
			var item = gridRoot.getItemAt(selectorColumn.getSelectedIndex());
			
			var input = {};
			input["ATH_GRP_CD"] 	= item["ATH_GRP_CD"];
			input["BIZRID"] 			= item["BIZRID"];
			input["BIZRNO"] 			= item["BIZRNO"];
			
			var url = "/CE/EPCE0140188_192.do";
			
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
			var rowIndex2;
			
			/**
			 * 메뉴관리 그리드 셋팅
			 */
			 function fn_set_grid2() {
				 
				 rMateGridH5.create("grid2", "gridHolder2", jsVars2, "100%", "100%");
				 layoutStr2.push('<rMateGrid>');
				 layoutStr2.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg2" headerHeight="35" headerWordWrap="true" horizontalGridLines="true" textAlign="center">');
				 layoutStr2.push('<columns>');
				 layoutStr2.push('	<DataGridColumn dataField="MENU_GRP_NM"  headerText="'+parent.fn_text('menu_se')+'" width="35%"/>');
				 layoutStr2.push('	<DataGridColumn dataField="MENU_NM"  headerText="'+parent.fn_text('menu_nm')+'" width="65%"/>');
				 layoutStr2.push('</columns>');
				 layoutStr2.push('<dataProvider>');
				 layoutStr2.push('	<SpanSummaryCollection source="{$gridData}">');
				 layoutStr2.push('		<mergingFields>');
				 layoutStr2.push('			<SpanMergingField name="MENU_GRP_NM" colNum="0"/>');
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

			     var layoutCompleteHandler = function(event) {
			         dataGrid2 = gridRoot2.getDataGrid();  // 그리드 객체
			         selectorColumn2 = gridRoot2.getObjectById("selector");
			         dataGrid2.addEventListener("change", selectionChangeHandler); //이벤트 등록
			     }
			     var selectionChangeHandler = function(event) {
					rowIndex2 = event.rowIndex;
				 }
			     var dataCompleteHandler = function(event) {
			    	 dataGrid2 = gridRoot2.getDataGrid();  // 그리드 객체
			 	 }
			     
			     gridRoot2.addEventListener("dataComplete", dataCompleteHandler);
			     gridRoot2.addEventListener("layoutComplete", layoutCompleteHandler);
			 }
		
	</script>

</head>
<body>
	<input type="hidden" id="pagedata"/>
	<div class="layer_popup" style="width:1024px;">
		<div class="layer_head">
			<h1 class="layer_title title"  id="titleSub"></h1>
			<button type="button" class="layer_close" layer="close"></button>
		</div>
		<div class="layer_body">
			<div class="secwrap" id="divInput_P">
				<div class="srcharea">
					<div class="row">
						<div class="col">
							<div class="tit" id="bizr_nm"></div>
							<div class="boxView" id="BIZRNM"></div>
						</div>
						<div class="col">
							<div class="tit" id="brch"></div>
							<div class="boxView" id="BRCH_NM"></div>
						</div>
						<div class="col">
							<div class="tit" id="user_nm"></div>
							<div class="boxView" id="USER_NM"></div>
						</div>
					</div>
				</div>
			</div>
			<section class="secwrap mt10">
				<div class="halfarea" style="width: 49%; float: left;">
					<div class="h4group">
						<h4 class="tit"  id='ath_grp'></h4>
					</div>
			        <div class="boxarea">
			            <div id="gridHolder" class="w_382" style="height:300px;"></div>
			        </div> 
				</div>
				
			    <div class="halfarea" style="width: 49%; float: right;">
					<div class="h4group">
						<h4 class="tit" id='menu'></h4>
					</div>	
			      	<div class="boxarea">
			      	    <div id="gridHolder2" class="w_382" style="height:300px;">
			      	</div>
		      </div>
			</section>
			
			<section class="btnwrap mt20" style="">
				<div class="fl_r" id="BR">
				</div>
			</section>
		</div><!-- end of  layer_body-->
	</div>  <!-- end of layer_popup -->
</body>
</html>
