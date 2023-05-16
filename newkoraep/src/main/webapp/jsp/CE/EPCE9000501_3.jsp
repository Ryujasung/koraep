<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>사업자관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">
	
	var parent_item;
	
	$(document).ready(function(){
		fn_btnSetting('EPCE9000501_3');
		
		parent_item = window.frames[$("#pagedata").val()].parent_item;
		
		$("#titleSub").text("<c:out value="${titleSub}" />");
		
// 		$('#user_nm_sel').text(parent.fn_text('user_nm'));
// 		$('#user_id_sel').text(parent.fn_text('id'));
// 		$('#user_stat_sel').text(parent.fn_text('user_stat'));
// 		$('#pwd_alt_req_sel').text(parent.fn_text('pwd_alt_req'));
		
// 		$('#bizr_tp_cd_sel').text(parent.fn_text('bizr_tp'));
// 		$('#bizrnm_sel').text(parent.fn_text('bizr_nm'));
// 		$('#bizrno_sel').text(parent.fn_text('bizrno'));
// 		$('#area_cd_sel').text(parent.fn_text('area_se'));
		
// 		$('#user_se_cd_sel').text(parent.fn_text('user_se'));
	
		fn_set_grid();
	
		$("#btn_cnl").click(function(){
			fn_cnl();
		});
		
	});
	
	function fn_cnl(){
		$('[layer="close"]').trigger('click');
	}
	
	/**
	 * 목록조회
	 */
	function fn_sel(){
		
		var url = "/CE/EPCE9000501_4.do";
		
		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
		ajaxPost(url, parent_item, function(rtnData){
			if(rtnData != null && rtnData != ""){
				gridApp.setData(rtnData.searchList);
			} 
			else {
				alertMsg("error");
			}
			
		},false);
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
		 layoutStr.push(' <NumberMaskFormatter id="dateFmt" formatString="####-##-##"/>');
		 layoutStr.push('	<NumberMaskFormatter id="maskfmt" formatString="###-##-#####"/>');
		 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" headerWordWrap="true" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center">');
		 layoutStr.push('<columns>');
		 layoutStr.push('	<DataGridColumn itemRenderer="IndexNoItem" headerText="관리업체명" width="120" verticalAlign="middle" />');
		 layoutStr.push('	<DataGridColumn dataField="URM_UPD_DT"  headerText="교체일자" width="100" formatter="{dateFmt}" />');
		 layoutStr.push('	<DataGridColumn dataField="URM_NO"  headerText="소모품명" width="200"/>');
		 /* layoutStr.push('	<DataGridColumn dataField="URM_NM"  headerText="개수" width="200"/>');
		 layoutStr.push('	<DataGridColumn dataField="SERIAL_NO"  headerText="무인회수기시리얼번호" width="100" formatter="{maskfmt}"/>');
		 layoutStr.push('	<DataGridColumn dataField="AREA_NM"  headerText="지역" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="START_DT"  headerText="사용기간FROM" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="END_DT"  headerText="사용기간TO" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="PNO"  headerText="우편번호" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="ADDR"  headerText=" 주소" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="BRCH_NM"  headerText="지점명" width="100"/>'); */
		 /* layoutStr.push('	<DataGridColumn dataField="TOTAL_TOT"  headerText="개수" width="100"/>'); */
		 layoutStr.push('	<DataGridColumn dataField="USE_TOT"  headerText="개수" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="RMG_TOT"  headerText="가격" width="100"/>');
		 /* layoutStr.push('	<DataGridColumn dataField="USE_YN"  headerText="폐기여부" width="100"/>'); */
		 layoutStr.push('	<DataGridColumn dataField="UPD_PRSN_ID"  headerText="비고" width="110"/>');
		 /* layoutStr.push('	<DataGridColumn dataField="UPD_DTTM"  headerText="수정일시" width="130"/>'); */

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
		 }
	     var dataCompleteHandler = function(event) {
	 	 }
	     
	     gridRoot.addEventListener("dataComplete", dataCompleteHandler);
	     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
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
			<section class="secwrap">
				<div class="boxarea">
					<div id="gridHolder" style="height: 400px;"></div>
				</div>	<!-- 그리드 셋팅 -->
			</section>
			
			<section class="btnwrap mt20" style="">
				<div class="fl_r" id="BR">
				</div>
			</section>
		</div><!-- end of  layer_body-->
	</div>  <!-- end of layer_popup -->
</body>
</html>