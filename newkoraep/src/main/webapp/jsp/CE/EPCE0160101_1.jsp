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
		fn_btnSetting('EPCE0160101_1');
		
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
		
		var url = "/CE/EPCE0160101_2.do";
		
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
		 layoutStr.push('	<DataGridColumn itemRenderer="IndexNoItem" headerText="'+parent.fn_text('sn')+'" width="50" verticalAlign="middle" />');
		 layoutStr.push('	<DataGridColumn dataField="ALT_DTTM"  headerText="'+parent.fn_text('alt_dt')+'" width="100" formatter="{dateFmt}" />');
		 layoutStr.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('bizr_nm')+'" width="200"/>');
		 layoutStr.push('	<DataGridColumn dataField="BIZRNO"  headerText="'+parent.fn_text('bizrno')+'" width="100" formatter="{maskfmt}"/>');
		 layoutStr.push('	<DataGridColumn dataField="TOB_NM"  headerText="'+parent.fn_text('tob')+'" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="BCS_NM"  headerText="'+parent.fn_text('bcs')+'" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="RPST_NM"  headerText="'+parent.fn_text('rpst_nm')+'" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="USER_NM"  headerText="'+parent.fn_text('admin_nm')+'" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="ADMIN_ID"  headerText="'+parent.fn_text('admin_id')+'" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="ACP_BANK_NM"  headerText="'+parent.fn_text('acp_bank_nm')+'" width="150"/>');
		 layoutStr.push('	<DataGridColumn dataField="ACP_ACCT_NO"  headerText="'+parent.fn_text('acp_acct_no')+'" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="EMAIL"  headerText="'+parent.fn_text('email')+'" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="ASTN_EMAIL"  headerText="'+parent.fn_text('astn_email')+'" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="RPST_TEL_NO"  headerText="'+parent.fn_text('rpst_tel_no')+'" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="TEL_NO"  headerText="'+parent.fn_text('cg_tel_no')+'" width="110"/>');
		 layoutStr.push('	<DataGridColumn dataField="MBIL_PHON"  headerText="'+parent.fn_text('cg_mbil_no')+'" width="130"/>');
		 layoutStr.push('	<DataGridColumn dataField="FAX_NO"  headerText="'+parent.fn_text('fax_no')+'" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="ADDR"  headerText="'+parent.fn_text('addr')+'" width="100"/>');
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