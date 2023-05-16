<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">

		var parent_items;
	
		$(document).ready(function(){

			
			parent_items = window.frames[$("#pagedata").val()].parent_items;
			
			
			//버튼 셋팅
			fn_btnSetting('EPWH0120675');
			
			$('#titleSub').text('<c:out value="${titleSub}" />');
						
			//그리드 셋팅
			fn_set_grid();
			
			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			$("#btn_cfm").click(function(){
				fn_cfm();
			});		
						
		});
		
		//취소
		function fn_cnl(){
			$('[layer="close"]').trigger('click');
		}
		
		//확인
		function fn_cfm(){
			window.frames[$("#pagedata").val()].fn_reg_exec();
			$('[layer="close"]').trigger('click');
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
			 layoutStr.push('	<NumberMaskFormatter id="maskfmt" formatString="###-##-#####"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" verticalGridLines="true" headerHeight="35" headerWordWrap="true" horizontalGridLines="true" ');
			 layoutStr.push('	textAlign="center" ');
			 layoutStr.push(' 	draggableColumns="true" sortableColumns="true"  doubleClickEnabled="false" liveScrolling="false" showScrollTips="true">');
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridColumn dataField="MFC_BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="17%"/>');
			 layoutStr.push('	<DataGridColumn dataField="MFC_BRCH_NM"  headerText="'+parent.fn_text('mfc_brch_nm')+'" width="17%"/>');
			 layoutStr.push('	<DataGridColumn dataField="CUST_BIZR_TP_NM"  headerText="'+parent.fn_text('bizr_tp_cd')+'" width="17%"/>');
			 layoutStr.push('	<DataGridColumn dataField="CUST_BIZRNM"  headerText="'+parent.fn_text('cust_bizrnm')+'" width="17%"/>');
			 layoutStr.push('	<DataGridColumn dataField="CUST_BRCH_NM"  headerText="'+parent.fn_text('brch_nm')+'" width="17%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNO_DE"  headerText="'+parent.fn_text('bizrno')+'" width="15%" formatter="{maskfmt}" />');
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
		     gridApp.setData(parent_items);
		     
		     var layoutCompleteHandler = function(event) {
		    	 dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		    	 selectorColumn = gridRoot.getObjectById("selector");
		    }
		
		    var dataCompleteHandler = function(event) {
		        dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		        dataGrid.setEnabled(true);
		        gridRoot.removeLoadingBar();
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
				<div class="h4group mt10" >
					<h5 class="tit"  style="font-size: 16px;">
						※ 기준수수료 등록 처리로 인해 등록되는 거래처 정보의 수에 따라 많은 시간이 소요될 수 있습니다.<br/>
						 &nbsp;&nbsp;&nbsp;선택된 직매장별 거래처 정보를 등록하시겠습니까?
					</h5>
				</div>
			</section>
			
			<section class="btnwrap mt10" style="">
				<div class="fl_r" id="BR">
				</div>
			</section>
		</div><!-- end of  layer_body-->
	</div>  <!-- end of layer_popup -->
</body>
</html>
