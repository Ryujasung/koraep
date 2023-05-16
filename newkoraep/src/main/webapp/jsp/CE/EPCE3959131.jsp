<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
			
		var INQ_PARAMS; //파라미터 데이터
		var areaList;

		$(document).ready(function(){
			
			INQ_PARAMS 	=  jsonObject($("#INQ_PARAMS").val());	
			areaList			=  jsonObject($("#areaList").val());       
			
			fn_btnSetting();

			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			$('#menu_set').text(parent.fn_text('menu_set'));
			$('#bizr_tp').text(parent.fn_text('bizr_tp'));
			$('#ath_grp').text(parent.fn_text('ath_grp'));
			
			$('#MENU_SET_NM').text(INQ_PARAMS['SEL_PARAMS'].MENU_SET_NM);
			$('#BIZR_TP_NM').text(INQ_PARAMS['SEL_PARAMS'].BIZR_TP_NM);
			$('#ATH_GRP_NM').text(INQ_PARAMS['SEL_PARAMS'].ATH_GRP_NM);
			
			fn_set_grid();
			
			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
		});
		
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
			
			var url = "/CE/EPCE3959131_09.do";
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
			 layoutStr.push('	<DataGridSelectorColumn id="selector" headerText="" width="10%" verticalAlign="middle" />');
			 layoutStr.push('	<DataGridColumn dataField="index"  headerText="'+parent.fn_text('sn')+'" width="10%" itemRenderer="IndexNoItem" />');
			 layoutStr.push('	<DataGridColumn dataField="AREA_NM"  headerText="'+parent.fn_text('area')+'" width="80%"/>');
			 layoutStr.push('</columns>');
			
			 layoutStr.push('</DataGrid>');
			 layoutStr.push('</rMateGrid>');
		}
		
		// 그리드 및 메뉴 리스트 세팅
		 function gridReadyHandler(id) {
		 	 gridApp = document.getElementById(id);  // 그리드를 포함하는 div 객체
		     gridRoot = gridApp.getRoot();   // 데이터와 그리드를 포함하는 객체

		     gridApp.setLayout(layoutStr.join("").toString());
		     gridApp.setData(areaList);
		     
		     var layoutCompleteHandler = function(event) {
		         dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		         dataGrid.addEventListener("change", selectionChangeHandler); //이벤트 등록
		         selectorColumn = gridRoot.getObjectById("selector");
		         fn_setChkBox();
		     }

		     var selectionChangeHandler = function(event) {
				rowIndex = event.rowIndex;
			 }
		     
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);

		 }
		
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
		
	</script>
</head>
<body>
	<div class="iframe_inner">
	  	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
		<input type="hidden" id="areaList" value="<c:out value='${areaList}' />" />
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
		</div>
		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">
					<div class="col">
						<div class="tit" id="menu_set"></div>
						<div class="boxView" id="MENU_SET_NM"></div>
					</div>
					<div class="col">
						<div class="tit" id="bizr_tp"></div>
						<div class="boxView" id="BIZR_TP_NM"></div>
					</div>
					<div class="col">
						<div class="tit" id="ath_grp"></div>
						<div class="boxView" id="ATH_GRP_NM"></div>
					</div>
				</div>
			</div>
		</section>
		
		<section class="secwrap mt20">
			<div class="boxarea" style="width:500px">
				<div id="gridHolder" style="height:260px;"></div>
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
