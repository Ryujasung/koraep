<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
			
		var INQ_PARAMS = ${INQ_PARAMS}; //파라미터 데이터
		var flag       = true;
	
		$(document).ready(function(){

			//버튼 셋팅
			fn_btnSetting();
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			$('#mfc_bizrnm').text(parent.fn_text('mfc_bizrnm'));
			$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm'));
			$('#bizr_tp_cd').text(parent.fn_text('bizr_tp_cd'));
			$('#cust_bizrnm').text(parent.fn_text('cust_bizrnm'));
			$('#brch_nm').text(parent.fn_text('brch_nm'));
			$('#cust_bizrno').text(parent.fn_text('cust_bizrno'));
			$('#area').text(parent.fn_text('area'));
			$('#std_fee_reg_yn').text(parent.fn_text('std_fee_reg_yn'));
			
			var mfc_bizrnm_sel = ${mfc_bizrnm_sel};		//생산자명 ING
			var mfc_brch_nm_sel = ${mfc_brch_nm_sel};	//직매장/공장 ING
			var bizr_tp_cd_sel = ${bizr_tp_cd_sel};		//거래처구분 ED
			var area_cd_sel    = ${area_cd_sel};		//지역 ED
			
			$("#mfc_bizrnm  option").remove();
			
			kora.common.setEtcCmBx2(mfc_bizrnm_sel, "", "", $("#MFC_BIZRNM_SEL"), "BIZRID_NO", "BIZRNM", "N", "S");
			kora.common.setEtcCmBx2([], "", "", $("#MFC_BRCH_NM_SEL"), "ETC_CD", "ETC_CD_NM", "N", "S");
			kora.common.setEtcCmBx2(bizr_tp_cd_sel, "", "", $("#BIZR_TP_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(area_cd_sel, "", "", $("#AREA_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");

			//그리드 셋팅
			fn_set_grid();
			
			//조회
			$("#btn_sel").click(function(){
				fn_sel();
			});
		
			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			/************************************
			 * 생산자명 변경 이벤트
			 ***********************************/
			 $("#MFC_BIZRNM_SEL").change(function(){
					fn_bizrTpCd();
			 });
			
		});
		
		//생산자명 변경시
		function fn_bizrTpCd(){

			var url = "/WH/EPWH0120601193.do" 
			var input ={};
		    input["BIZRID_NO"] =$("#MFC_BIZRNM_SEL").val();

       	    ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {   
   					kora.common.setEtcCmBx2(rtnData.searchList, "","", $("#MFC_BRCH_NM_SEL"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S');
   				} else {
   					alertMsg("error");
   				}
    		});
		}
		
		//취소
		function fn_cnl(){
			kora.common.goPageB('', INQ_PARAMS);
		}
		
		var parent_items;
		function fn_reg(){
			
			if(selectorColumn.getSelectedIndices().length < 1){
				alertMsg("선택된 데이터가 없습니다.");
				return;
			}
			
			parent_items = selectorColumn.getSelectedItems();
			var pagedata = window.frameElement.name;
			window.parent.NrvPub.AjaxPopup('/WH/EPWH0120675.do', pagedata);
			
		}
		
		function fn_reg_exec(){

			var url  = "/WH/EPWH0120631_31.do";

			var data = {};
			var row = new Array();
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(item);
			}
			
			data["list"] = JSON.stringify(row);
			
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_sel');
				} else {
					alertMsg("error");
				}
			});
		}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){

			var input = {};
			input["MFC_BIZRNM_SEL"] 			= $("#MFC_BIZRNM_SEL option:selected").val();
			input["MFC_BRCH_NM_SEL"] 			= $("#MFC_BRCH_NM_SEL option:selected").val();
			input["MFC_BIZRNM"] 			= $("#MFC_BIZRNM_SEL option:selected").text();
			input["MFC_BRCH_NM"] 			= $("#MFC_BRCH_NM_SEL option:selected").text();
			input["BIZR_TP_CD_SEL"] 			= $("#BIZR_TP_CD_SEL option:selected").val();
			input["AREA_SEL"] 						= $("#AREA_SEL option:selected").val();
			
			input["CUST_BIZRNM_SEL"] 			= $("#CUST_BIZRNM_SEL").val();
			input["CUST_BIZRNO_SEL"] 			= $("#CUST_BIZRNO_SEL").val();
			
			if(input["MFC_BIZRNM_SEL"] == '' || input["MFC_BRCH_NM_SEL"] == ''){
				alertMsg("생산자, 직매장/공장 선택은 필수 입니다.");
				return;
			}
			
			//파라미터에 조회조건값 저장 
			//INQ_PARAMS["SEL_PARAMS"] = input;
			
			var url = "/WH/EPWH012063119.do";
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
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
			 layoutStr.push('	<NumberMaskFormatter id="maskfmt" formatString="###-##-#####"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1"  headerHeight="35" horizontalGridLines="true" textAlign="center" draggableColumns="true" sortableColumns="true" > ');
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" textAlign="center" allowMultipleSelection="true" width="3%" verticalAlign="middle" />');
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="순번" itemRenderer="IndexNoItem" textAlign="center" width="5%" />');
			 layoutStr.push('	<DataGridColumn dataField="CUST_BIZR_TP_NM"  headerText="'+parent.fn_text('bizr_tp_cd')+'" width="14%"/>');
			 layoutStr.push('	<DataGridColumn dataField="CUST_BIZRNM"  headerText="'+parent.fn_text('cust_bizrnm')+'" width="25%"/>');
			 layoutStr.push('	<DataGridColumn dataField="CUST_BRCH_NM"  headerText="'+parent.fn_text('brch_nm')+'" width="25%"/>');
			 layoutStr.push('	<DataGridColumn dataField="AREA_NM"  headerText="'+parent.fn_text('area')+'" width="14%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNO_DE"  headerText="'+parent.fn_text('bizrno')+'" width="14%" formatter="{maskfmt}"/>');
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
		    	 selectorColumn = gridRoot.getObjectById("selector");
		    }
		
		    var dataCompleteHandler = function(event) {
		        dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		    }
		    
		    gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		    gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);

		 }


	</script>
	<style type="text/css">
		.row .col .tit{width: 75px;}
	</style>

</head>
<body>
	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
		</div>
		
		<section class="secwrap" >
			<div class="srcharea" >
				<div class="row">
					<!-- 생산자명 combo -->
					<div class="col">
						<div class="tit" id="mfc_bizrnm"></div>
						<div class="box">
							<select id="MFC_BIZRNM_SEL" name="MFC_BIZRNM_SEL" style="width: 179px" class="i_notnull"></select>
						</div>
					</div>
					<!-- 직매장/공장 combo -->
					<div class="col">
						<div class="tit" id="mfc_brch_nm"></div>
						<div class="box">
							<select id="MFC_BRCH_NM_SEL" style="width: 179px" class="i_notnull"></select>
						</div>
					</div>
				</div>
			</div>
			<div class="srcharea mt10" >
				<div class="row">
					<!-- 거래처구분 combo -->
					<div class="col">
						<div class="tit" id="bizr_tp_cd" style="width:120px"></div>
						<div class="box">
							<select id="BIZR_TP_CD_SEL" name="BIZR_TP_CD_SEL" style="width: 179px" class="i_notnull"></select>
						</div>
					</div>
					<!-- 지역 combo -->
					<div class="col">
						<div class="tit" id="area"></div>
						<div class="box">
							<select id="AREA_SEL" name="AREA_SEL" style="width: 179px" class="i_notnull"></select>
						</div>
					</div>  
					<!-- 거래처명 text -->
					<div class="col" >
						<div class="tit" id="cust_bizrnm"></div>
						<div class="box">
							<input type="text" id="CUST_BIZRNM_SEL" name="CUST_BIZRNM_SEL"  style="width: 179px; class="i_notnull">
						</div>
					</div>
					<!-- 거래처사업자번호 text -->
					<div class="col" >
						<div class="tit" id="cust_bizrno" style="width:120px"></div>
						<div class="box">
							<input type="text" id="CUST_BIZRNO_SEL" name="CUST_BIZRNO_SEL" maxlength="10" style="width: 179px; class="i_notnull" format="number">
						</div>
					</div>
					<div class="btn" id="UR">
					</div>
				</div>
			</div>
		</section>
		
		
		
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:418px;"></div>
			</div>
		</section>
		<section class="btnwrap mt20" style="" >
				<div class="btn" id="BL">
				</div>
				<div class="btn" style="float:right" id="BR">
				</div>
		</section>

	</div>

</body>
</html>
