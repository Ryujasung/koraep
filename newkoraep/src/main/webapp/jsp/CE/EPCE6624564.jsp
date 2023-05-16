<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
			
		var INQ_PARAMS; //파라미터 데이터   
		var searchList;
		  
		$(document).ready(function(){
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
			searchList = jsonObject($("#searchList").val());
			fn_btnSetting();
			$('#reg_dt2').text(parent.fn_text('reg_dt2'));
			$('#exch_dt').text(parent.fn_text('exch_dt'));
			$('#exch_reg_mfc').text(parent.fn_text('exch_reg_mfc'));
			$('#exch_cfm_mfc').text(parent.fn_text('exch_cfm_mfc'));
			
			$('#exch_cfm_dt').text(parent.fn_text('exch_cfm_dt'));
			$('#stat').text(parent.fn_text('stat'));
			
			$('#EXCH_REG_DT').text(INQ_PARAMS.PARAMS.EXCH_REG_DT);
			$('#EXCH_DT').text(INQ_PARAMS.PARAMS.EXCH_DT);
			$('#REQ_MFC').text(INQ_PARAMS.PARAMS.REQ_BIZRNM+" "+INQ_PARAMS.PARAMS.REQ_BRCH_NM);
			$('#CFM_MFC').text(INQ_PARAMS.PARAMS.CFM_BIZRNM+" "+INQ_PARAMS.PARAMS.CFM_BRCH_NM);
			
			$('#EXCH_CFM_DT').text(INQ_PARAMS.PARAMS.EXCH_CFM_DT);
			$('#EXCH_STAT_NM').text(INQ_PARAMS.PARAMS.EXCH_STAT_NM);
		
			fn_set_grid();
			

			$("#btn_page").click(function(){
				fn_page();
			});
			
			$("#btn_upd").click(function(){
				fn_upd();
			});
			
			$("#btn_upd2").click(function(){
				fn_upd2();
			});
			
			$("#btn_upd3").click(function(){
				fn_upd3();
			});
			
		});
		

		 function fn_upd2(){
			 
			if(INQ_PARAMS.PARAMS.EXCH_STAT_CD != 'CC'){
				alertMsg('교환확인 상태의 정보만 취소 가능합니다. 다시 한 번 확인하시기 바랍니다.');
				return;
			} 

			if((INQ_PARAMS.PARAMS.EXCH_REQ_CRCT_STAT_CD != undefined && INQ_PARAMS.PARAMS.EXCH_REQ_CRCT_STAT_CD != '')
					|| (INQ_PARAMS.PARAMS.EXCH_CFM_CRCT_STAT_CD != undefined && INQ_PARAMS.PARAMS.EXCH_CFM_CRCT_STAT_CD != '')){
				alertMsg('이미 처리된 문서입니다.');
				return;
			} 
			 
			confirm('해당 교환 확인 내역을 확인 취소 처리하시겠습니까?', 'fn_upd2_exec');
		 }
		 
		 function fn_upd2_exec(){
			 
			 	var input = {};
			 	input = INQ_PARAMS.PARAMS;
			 	
			 	var url = "/CE/EPCE6624564_21.do";
			 	ajaxPost(url, input, function(rtnData){
			 		if ("" != rtnData && null != rtnData) {
			 			alertMsg(rtnData.RSLT_MSG, 'fn_page');
	 				} else {
	 					alertMsg("error");
	 				}
			 	});
		 }
		 
		 function fn_upd3(){
			 
			if(INQ_PARAMS.PARAMS.EXCH_STAT_CD != 'RG'){
				alertMsg('교환등록 상태의 정보만 확인 가능합니다. 다시 한 번 확인하시기 바랍니다.');
				return;
			} 
			 
			confirm('해당 교환 등록 내역을 확인 처리하시겠습니까?', 'fn_upd3_exec');
		 }
		 
		 function fn_upd3_exec(){
			 
			 	var input = {};
			 	input = INQ_PARAMS.PARAMS;
			 	
			 	var url = "/CE/EPCE6624564_212.do";
			 	ajaxPost(url, input, function(rtnData){
			 		if ("" != rtnData && null != rtnData) {
			 			alertMsg(rtnData.RSLT_MSG, 'fn_page');
	 				} else {
	 					alertMsg("error");
	 				}
			 	});
		 }
	
		 function fn_upd(){
			 
			 if(INQ_PARAMS.PARAMS.EXCH_STAT_CD != 'RG'){
				alertMsg('교환등록 상태의 정보만 변경 가능합니다. 다시 한 번 확인하시기 바랍니다.');
				return;
			 } 

			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE6624564.do";
			kora.common.goPage('/CE/EPCE6624542.do', INQ_PARAMS);
		}

		function fn_page(){
			kora.common.goPageB('/CE/EPCE6624501.do', INQ_PARAMS);
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
			 layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			 layoutStr.push('<groupedColumns>');
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" width="50"/>');
			 layoutStr.push('	<DataGridColumn dataField="REQ_CTNR_NM"  headerText="'+parent.fn_text('reg_ctnr_nm')+'" width="250"/>');
			 layoutStr.push('	<DataGridColumn dataField="CFM_CTNR_NM"  headerText="'+parent.fn_text('exch_ctnr_nm')+'" width="250"/>');
			 layoutStr.push('	<DataGridColumn dataField="CPCT_NM"  headerText="'+parent.fn_text('cpct')+'" width="150"/>');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_QTY" id="exchQtyTot"  headerText="'+parent.fn_text('exch_qty')+'" width="100" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumnGroup headerText="'+parent.fn_text('cntr_dps2')+'">');
		 	 layoutStr.push('		<DataGridColumn dataField="EXCH_GTN_UTPC" headerText="'+parent.fn_text('utpc')+'" width="110" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('		<DataGridColumn dataField="EXCH_GTN" id="exchGtnTot" headerText="'+parent.fn_text('total')+'" width="110" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	</DataGridColumnGroup>'); 
			 layoutStr.push('	<DataGridColumn dataField="RMK"  headerText="'+parent.fn_text('rmk')+'" width="" textAlign="left"/>');
			 layoutStr.push('</groupedColumns>');
			 layoutStr.push('	<footers>');
			 layoutStr.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{exchQtyTot}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{exchGtnTot}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('		</DataGridFooter>');
			 layoutStr.push('	</footers>');
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
				 gridApp.setData(searchList);
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

	<style type="text/css">
		.row .tit{width: 67px;}
	</style>

</head>
<body>
	<div class="iframe_inner">
		
		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
		<input type="hidden" id="searchList" value="<c:out value='${searchList}' />" />
	
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
			<div class="btn_box">
				<div class="btn" id="UR">
				</div>
			</div>
		</div>
		<section class="secwrap">
			<div class="srcharea">
				<div class="write_area" style="border-top:0px">
					<div class="write_tbl">
						<table>
							<colgroup>
								<col style="width: 180px;">
								<col style="width: 280px;">
								<col style="width: 180px;">
								<col style="width: auto;">
							</colgroup>
							<tr>
								<th><span id='reg_dt2'></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="EXCH_REG_DT"></div>
									</div>
								</td>
								<th><span id='exch_dt'></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="EXCH_DT"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th><span id='exch_reg_mfc'></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="REQ_MFC"></div>
									</div>
								</td>
								<th><span id='exch_cfm_mfc'></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="CFM_MFC"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th><span id='exch_cfm_dt'></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="EXCH_CFM_DT"></div>
									</div>
								</td>
								<th><span id='stat'></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="EXCH_STAT_NM"></div>
									</div>
								</td>
							</tr>
						</table>
					</div>  
				</div>
			</div>
		</section>
		
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:350px;"></div>
			</div>
		</section>
	
		<section class="btnwrap mt20" style="">
			<div class="fl_l" id="BL">

			</div>
			<div class="fl_r" id="BR">
			</div>
		</section>
		
	</div>
	
</body>
</html>
