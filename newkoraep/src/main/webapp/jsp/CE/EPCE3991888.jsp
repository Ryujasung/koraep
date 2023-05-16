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
			
			fn_btnSetting('EPCE3991888');
			
			parent_item = window.frames[$("#pagedata").val()].parent_item;
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			$('#menu_grp_sel').text(parent.fn_text('menu_grp'));
			$('#menu_nm_sel').text(parent.fn_text('menu_nm'));
			$('#btn_nm_sel').text(parent.fn_text('btn_nm'));
			
			$('#MENU_GRP_NM_SEL').text(parent_item['MENU_GRP_NM']);
			$('#MENU_NM_SEL').text(parent_item['MENU_NM']);
			$('#BTN_NM_SEL').text(parent_item['BTN_NM']);
			
			$('#ath_set_sel').text(parent.fn_text('ath_set'));
			$('#btn_ath_btch_add').text(parent.fn_text('btn_ath_btch_add'));
			$('#btn_ath_btch_del').text(parent.fn_text('btn_ath_btch_del'));

			fn_set_grid();
			
			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});

		});
		
		function fn_cnl(){
			window.frames[$("#pagedata").val()].fn_rowToSel();
			$('[layer="close"]').trigger('click');
		}
		
		//저장
		function fn_reg(){
			var selArr = selectorColumn.getSelectedIndices();
			
			if(selArr == '' || selArr == null || selArr == undefined){
				alertMsg('선택된 행이 없습니다');
				return;
			}
			
			var collection = gridRoot.getCollection();
			for(var i=0;i<collection.getLength(); i++){
				var tmpData = gridRoot.getItemAt(i);
				if($.inArray(i, selArr) > -1){
					tmpData.SELECTED = 'Y';
				}else{
					tmpData.SELECTED = 'N';			
				}
				gridRoot.setItemAt(tmpData, i);
			}
			
			var input = {};
			input["list"] = JSON.stringify(gridRoot.getGridData());

			input["BTN_CD"] 			= parent_item["BTN_CD"];
			input["MENU_CD"] 		= parent_item["MENU_CD"];
			input["LANG_SE_CD"] 	= parent_item["LANG_SE_CD"];
			
			input["BTN_ATH_BTCH_SEL"] = $("input:radio[id='BTN_ATH_BTCH_SEL']:checked").val();

			var url = "/CE/EPCE3991888_09.do";
			ajaxPost(url, input, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
				} else {
					alertMsg("error");
				}
			});
		}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){
			
			var url = "/CE/EPCE3991888_19.do";
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, parent_item, function(rtnData){
				if(rtnData != null && rtnData != ""){
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
		 * 메뉴관리 그리드 셋팅
		 */
		 function fn_set_grid() {
			 
			 rMateGridH5.create("grid", "gridHolder", jsVars, "100%", "100%");
			 
			 layoutStr.push('<rMateGrid>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center">'); //liveScrolling="false" showScrollTips="false"
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="true" headerText="" width="7%" verticalAlign="middle" />');
			 layoutStr.push('	<DataGridColumn itemRenderer="IndexNoItem"  headerText="'+parent.fn_text('sn')+'" width="7%" />');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('reg_bizr')+'" width="18%"/>');
			 layoutStr.push('	<DataGridColumn dataField="STD_YN"  headerText="'+parent.fn_text('std_yn')+'" width="10%"/>');
			 layoutStr.push('	<DataGridColumn dataField="ATH_GRP_NM"  headerText="'+parent.fn_text('ath_grp_nm')+'" width="22%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZR_TP_NM"  headerText="'+parent.fn_text('bizr_tp')+'" width="18%"/>');
			 layoutStr.push('	<DataGridColumn dataField="MENU_SET_NM"  headerText="'+parent.fn_text('menu_set')+'" width="18%"/>');
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
		     gridApp.setData([]);
		     
		     var layoutCompleteHandler = function(event) {
		         dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		         selectorColumn = gridRoot.getObjectById("selector");
		         dataGrid.addEventListener("change", selectionChangeHandler); //이벤트 등록
		         fn_sel();
		     }
		     
		     var selectionChangeHandler = function(event) {
				var rowIndex = event.rowIndex;
				
			 }
		     
		     var dataCompleteHandler = function(event) {
		     	//fn_setChkBox();
		 	 }

			 gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);

		 }
		
		/*
		//체크박스 체크
		function fn_setChkBox(){
		 	var collection = gridRoot.getCollection();
		 	var arrIdx = [];
		 	for(var i=0;i<collection.getLength(); i++){
		 		var tmpData = gridRoot.getItemAt(i);
		 		if(tmpData.SELECTED == "Y") arrIdx.push(i);
		 	}
		 	selectorColumn.setSelectedIndices(arrIdx);
		}
		*/
		
	</script>

</head>
<body>
	<div class="layer_popup" style="width:800px;">
	
		<input type="hidden" id="pagedata"/> 
		
			<div class="layer_head">
				<h1 class="layer_title" id="title_sub"></h1>
				<button type="button" class="layer_close" layer="close"></button>
			</div>
			<div class="layer_body">
				<div class="secwrap" id="divInput_P">
					<div class="srcharea">
						<div class="row">
							<div class="col">
								<div class="tit" id="menu_grp_sel"></div>
								<div class="boxView" id="MENU_GRP_NM_SEL">
								</div>
							</div>
							<div class="col">
								<div class="tit" id="menu_nm_sel"></div>
								<div class="boxView" id="MENU_NM_SEL">
								</div>
							</div>
							<div class="col">
								<div class="tit" id="btn_nm_sel"></div>
								<div class="boxView" id="BTN_NM_SEL">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col">
								<div class="tit" id="ath_set_sel"></div>
								<div class="box">
									<label class="rdo"><input type="radio" id="BTN_ATH_BTCH_SEL" name="BTN_ATH_BTCH_SEL" value="ADD" checked="checked"/><span id="btn_ath_btch_add"></span></label>
									<label class="rdo"><input type="radio" id="BTN_ATH_BTCH_SEL" name="BTN_ATH_BTCH_SEL" value="DEL"/><span id="btn_ath_btch_del"></span></label>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="secwrap mt10">
					<div class="boxarea">
						<div id="gridHolder" style="height: 300px;">
						</div>
					</div>
				</div>
				
				<section class="btnwrap mt20" style="" >
					<div class="btn" id="BR" style="float:right">
					</div>
				</section>
				
			</div>
	
	</div>
</body>
</html>
