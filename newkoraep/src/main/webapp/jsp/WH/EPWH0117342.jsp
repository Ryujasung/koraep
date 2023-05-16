<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
			
		var INQ_PARAMS;

		$(document).ready(function(){

			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			
			//버튼 셋팅
			fn_btnSetting();
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			$('.tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			
			var bizrList = jsonObject($('#bizrList').val());
			var bizrTpList = jsonObject($('#bizrTpList').val());

			kora.common.setEtcCmBx2(bizrList, "", "", $("#WHSDL_BIZR"), "BIZRID_NO", "BIZRNM", "N");
			//kora.common.setEtcCmBx2([], "", "", $("#WHSDL_BRCH"), "BRCHID_NO", "BRCH_NM", "N", "T");
			fn_change();
			kora.common.setEtcCmBx2(bizrTpList, "", "", $("#BIZR_TP_CD"), "ETC_CD", "ETC_CD_NM", "N", "T");
			
			//$("#WHSDL_BIZR").select2();
			
			var rtrvlRegSeList = jsonObject($('#rtrvlRegSeList').val());
			var drctPaySeList = jsonObject($('#drctPaySeList').val());
			var btchAplcYnList = jsonObject($('#btchAplcYnList').val());
			kora.common.setEtcCmBx2(rtrvlRegSeList, "", "", $("#RTRVL_REG_SE"), "ETC_CD", "ETC_CD_NM", "N", "S");
			kora.common.setEtcCmBx2(drctPaySeList, "", "", $("#DRCT_PAY_SE"), "ETC_CD", "ETC_CD_NM", "N", "S");
			kora.common.setEtcCmBx2(btchAplcYnList, "", "", $("#BTCH_APLC_YN"), "ETC_CD", "ETC_CD_NM", "N", "");
			
			//그리드 셋팅
			fn_set_grid();

			/************************************
			 * 도매업자 변경 이벤트
			 ***********************************/
			$("#WHSDL_BIZR").change(function(){
				fn_change();
			});
			
			/************************************
			 * 일괄적용여부 변경 이벤트
			 ***********************************/
			$("#BTCH_APLC_YN").change(function(){
				
				var tt;
				if($("#BTCH_APLC_YN").val() == 'Y'){
					tt = true;
				}else{
					tt = false;
				}
				
				$('#WHSDL_BRCH').prop('disabled', tt);
				$('#BIZR_TP_CD').prop('disabled', tt);
			});
			
			//취소 버튼
			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			//적용 버튼
			$("#btn_upd").click(function(){
				fn_upd();
			});
			
			//조회 버튼
			$("#btn_sel").click(function(){
				fn_sel();
			});
						
		});
		
		/**
		 * 목록조회
		 */
		function fn_sel(){

			if($('#WHSDL_BIZR').val() == '' ){
				alertMsg('도매업자를 선택하세요.');
				return;
			}
			
			var input = {};
			input["WHSDL_BIZR"] 		= $("#WHSDL_BIZR").val();
			input["BTCH_APLC_YN"] 	= $("#BTCH_APLC_YN").val();
			input["RTRVL_REG_SE"] 	= $("#RTRVL_REG_SE").val();
			input["DRCT_PAY_SE"] 	= $("#DRCT_PAY_SE").val();
			
			input["WHSDL_BRCH"] 		= $("#WHSDL_BRCH").val();
			input["BIZR_TP_CD"] 		= $("#BIZR_TP_CD").val();

			var url = "/WH/EPWH0117342_192.do";
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.searchList);
				} 
				else {
					alertMsg("error");
				}
			}, false);
			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
		}
		
		function fn_upd(){
			
			if($('#WHSDL_BIZR').val() == '' ){
				alertMsg('도매업자를 선택하세요.');
				return;
			}
			
			if($('#BTCH_APLC_YN').val() == 'N'){ //개별적용 
			
				var chkLst = selectorColumn.getSelectedItems();
				
				if(chkLst.length < 1){
					alertMsg("선택된 행이 없습니다.");
					return;
				}
			}
			
			if($('#RTRVL_REG_SE').val() == '' && $('#DRCT_PAY_SE').val() == '' ){
				alertMsg('적용할 업무설정을 하나이상 선택해야 합니다.');
				return;
			}
			
			confirm('일괄적용 하시겠습니까?', 'fn_upd_exec');
		}
		
		function fn_upd_exec(){

			var data = {};
			var row = new Array();
			
			if($('#BTCH_APLC_YN').val() == 'N'){ //개별적용 

			 	for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
					var item = {};
					item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
					row.push(item);
				}
			 	
			 	data["list"] = JSON.stringify(row);
			}else{
				data["list"] = null;
			}
			
		 	data["BTCH_APLC_YN"] = $('#BTCH_APLC_YN').val(); //일괄적용여부
		 	data["WHSDL_BIZR"] = $('#WHSDL_BIZR').val();
		 	
		 	data["RTRVL_REG_SE"] = $('#RTRVL_REG_SE').val();
		 	data["DRCT_PAY_SE"] = $('#DRCT_PAY_SE').val();
		 				
			var url  = "/WH/EPWH0117342_21.do";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_sel');
				} else {
					alertMsg("error");
				}
			});
		}
		
		//취소
		function fn_cnl(){
			kora.common.goPageB('', INQ_PARAMS);
		}
				
		//도매업자 변경시 지점조회
		function fn_change(){

			var url = "/WH/EPWH0117342_19.do" 
			var input ={};
		    input["BIZRID_NO"] =$("#WHSDL_BIZR").val();

       	    ajaxPost(url, input, function(rtnData) {
   				if (null != rtnData) {   
   					kora.common.setEtcCmBx2(rtnData.selList, "","", $("#WHSDL_BRCH"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');

   					$('#WHSDL_BIZRNO').attr('style','')
   					$('#WHSDL_BIZRNO_DE').text(kora.common.setDelim(rtnData.bizrno, '999-99-99999'));
   				} else {
   					alertMsg("error");
   				}
    		}, false);
       	    
       	 	//gridApp.setData(); //그리드 초기화
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
			 layoutStr.push('<NumberMaskFormatter id="maskfmt" formatString="###-##-#####"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35"  horizontalGridLines="true"  textAlign="center" 	draggableColumns="true" sortableColumns="true" > ');
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" textAlign="center" allowMultipleSelection="true" width="3%" verticalAlign="middle" />');
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="순번" itemRenderer="IndexNoItem" textAlign="center" width="4%" />');
			 layoutStr.push('	<DataGridColumn dataField="WHSDL_BRCH_NM"  headerText="'+parent.fn_text('brch_nm')+'" width="15%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZR_TP_NM"  headerText="'+parent.fn_text('bizr_tp_cd')+'" width="10%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('cust_bizrnm')+'" width="15%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNO_DE"  headerText="'+parent.fn_text('bizrno')+'" width="13%" formatter="{maskfmt}"/>');
			 layoutStr.push('	<DataGridColumn dataField="RTRVL_REG_NM"  headerText="'+parent.fn_text('rtrvl_reg_se')+'" width="13%"/>');
			 layoutStr.push('	<DataGridColumn dataField="DRCT_PAY_NM"  headerText="'+parent.fn_text('drct_pay_se')+'" width="12%"/>');
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
		    	 dataGrid.addEventListener("change", selectionChangeHandler);
		    	 gridApp.setData();
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
		.row .tit{width: 77px;}
	</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="bizrList" value="<c:out value='${bizrList}' />"/>
<input type="hidden" id="bizrTpList" value="<c:out value='${bizrTpList}' />"/>
<input type="hidden" id="rtrvlRegSeList" value="<c:out value='${rtrvlRegSeList}' />"/>
<input type="hidden" id="drctPaySeList" value="<c:out value='${drctPaySeList}' />"/>
<input type="hidden" id="btchAplcYnList" value="<c:out value='${btchAplcYnList}' />"/>

	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
			<div class="singleRow">
				<div class="btn" id="UR"></div>
			</div>
		</div>

		<section class="secwrap">
			<div class="h4group">
				<h4 class="tit"  id='whsdl_info_txt'></h4>
			</div>
			<div class="srcharea" id="params">
				<div class="row">
					<div class="col">
						<div class="tit" id="whsdl_txt"></div>
						<div class="box">
							<select id="WHSDL_BIZR" name="WHSDL_BIZR" style="width: 179px" class="i_notnull"></select>
						</div>
					</div>
					<div class="col" style="display:none" id="WHSDL_BIZRNO">
						<div class="tit" id="whsdl_bizrno_txt" style="width:140px"></div>
						<div class="box" style="line-height: 36px;" id="WHSDL_BIZRNO_DE"></div>
					</div>
				</div>
			</div>
		</section>

		<section class="secwrap mt10">
			<div class="h4group">
				<h4 class="tit"  id='work_set_txt'></h4>
			</div>
				<div class="write_area">
					<div class="write_tbl">
	
						<table>
							<colgroup>
								<col style="width: 100px;">
								<col style="width: 120px;">
								<col style="width: auto;">
							</colgroup>
							<tr>
								<th colspan="2"><span class="tit" id="rtrvl_reg_se_txt"></span></th>
								<td>
									<div class="row">
										<select id="RTRVL_REG_SE" name="RTRVL_REG_SE" style="width: 179px;" class="i_notnull"></select>
									</div>
								</td>
							</tr>
							<tr>
								<th colspan="2"><span class="tit" id="drct_pay_se_txt"></span></th>
								<td>
									<div class="row">
										<select id="DRCT_PAY_SE" name="DRCT_PAY_SE" style="width: 179px;" class="i_notnull"></select>
									</div>
								</td>
							</tr>
						</table>
					</div>
				</div>
		</section>

		<section class="secwrap mt10">
			<div class="h4group">
				<h4 class="tit"  id='btch_aplc_trgt_set_txt'></h4>
			</div>
			<div class="srcharea" id="params">
				<div class="row">
					<div class="col">
						<div class="tit" id="btch_aplc_yn_txt"></div>
						<div class="box">
							<select id="BTCH_APLC_YN" name="BTCH_APLC_YN" style="width: 129px" class="i_notnull"></select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="cust_brch_txt"></div>
						<div class="box">
							<select id="WHSDL_BRCH" name="WHSDL_BRCH" style="width: 179px" class="i_notnull" disabled></select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="bizr_tp_txt"></div>
						<div class="box">
							<select id="BIZR_TP_CD" name="BIZR_TP_CD" style="width: 179px" class="i_notnull" disabled></select>
						</div>
					</div>
					
					<div class="btn" id="CR"></div>
				</div>
			</div>
			
				
		</section>
		
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:418px;"></div>
			</div>
		</section>
		<section class="btnwrap mt20" >
			<div class="btn" id="BL">
			</div>
			<div class="btn" style="float:right" id="BR">
			</div>
		</section>
	</div>
	
	<form name="downForm" id="downForm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="DLIVY_INFO_EXCEL_FORM.xlsx" />
		<input type="hidden" name="downDiv" value="" />
	</form>
	
</body>
</html>
