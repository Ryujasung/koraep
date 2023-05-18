<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
	
		var INQ_PARAMS;//파라미터 데이터
	
		$(document).ready(function(){
			
			INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
			var statList =jsonObject($("#statList").val());	
			var mfcBizrList =jsonObject($("#mfcBizrList").val());	
			
			$('#exca_trgt_year').text(parent.fn_text('exca_trgt_year'));
			fn_btnSetting();
			
			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});

			var date = new Date();
		    var year = date.getFullYear();
		    var selected = "";
		    for(i=2016; i<=year; i++){
		    	if(i == year) selected = "selected";
		    	$('#EXCA_YEAR_SEL').append('<option value="'+i+'" '+selected+'>'+i+'</option>');
		    }
			
			kora.common.setEtcCmBx2(statList, "", "", $("#STAT_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(mfcBizrList, "","", $("#MFC_BIZR_SEL"), "BIZRID_NO", "BIZRNM", "N");	
		    
			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
			}
			
			//그리드 셋팅
			fn_set_grid();
			
			$("#btn_sel").click(function(){
				fn_sel();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});
						
			//정산요청취소
			$("#btn_upd3").click(function(){
				fn_upd3();
			});

		});
		
		function fn_page(){
			var idx = dataGrid.getSelectedIndices();
			var input = gridRoot.getItemAt(idx);

			//파라미터에 조회조건값 저장 
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/MF/EPMF4792901.do";
			kora.common.goPage('/MF/EPMF4792964.do', INQ_PARAMS);
		}
		
		function fn_page3(){
			var idx = dataGrid.getSelectedIndices();
			var input = gridRoot.getItemAt(idx);

			var url = '/MF/EPMF47929643.do';
			
			if(input.STAC_DOC_NO.indexOf('BL') > -1){
				url = '/MF/EPMF4707264.do'; //과거 데이터 정산서 조회
			}
			
			//파라미터에 조회조건값 저장 
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/MF/EPMF4792901.do";
			kora.common.goPage(url, INQ_PARAMS);
		}
		
		//정산요청취소
		function fn_upd3(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				
				if(item.EXCH_EXCA_STAT_CD != 'R' ){
					alertMsg("정산요청 건만 처리 가능합니다.");
					return;
				}
			}
			
			confirm('선택하신 정산 요청 내역이 삭제됩니다. 계속 진행하시겠습니까?', "fn_upd3_exec");
		}
		
		function fn_upd3_exec(){
			
			var data = {};
			var row = new Array();
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(item);
			}
			
			data["list"] = JSON.stringify(row);

			var url = "/MF/EPMF4792901_212.do";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_sel');
				} else {
					alertMsg("error");
				}
			});
		}
		
		function fn_reg(){
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/MF/EPMF4792901.do";
			kora.common.goPage('/MF/EPMF4792931.do', INQ_PARAMS);
		}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){

			var url = "/MF/EPMF4792901_19.do";
			var input = {};
			input['MFC_BIZR_SEL'] = $("#MFC_BIZR_SEL option:selected").val();
			input['EXCA_YEAR_SEL'] = $("#EXCA_YEAR_SEL option:selected").val();
			input['STAT_CD_SEL'] = $("#STAT_CD_SEL option:selected").val();
			
			//파라미터에 조회조건값 저장 
			INQ_PARAMS["SEL_PARAMS"] = input;
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.searchList);
				} else {
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
		var rowIndex;
		
		/**
		 * 메뉴관리 그리드 셋팅
		 */
		 function fn_set_grid() {
			 
			 rMateGridH5.create("grid", "gridHolder", jsVars, "100%", "100%");
			 layoutStr.push('<rMateGrid>');
			 layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			 layoutStr.push('	<groupedColumns>');   
			 layoutStr.push('	<DataGridSelectorColumn id="selector" width="40" textAlign="center" allowMultipleSelection="true" vertical-align="middle"  draggable="false" />');			//선택
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
			 layoutStr.push('	<DataGridColumn dataField="MFC_BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="200" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_EXCA_REG_DT_PAGE" headerText="'+parent.fn_text('exca_req_dt')+'" width="120" itemRenderer="HtmlItem" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_DLIVY_QTY" id="sum1" headerText="'+parent.fn_text('exch_dlivy_qty')+'" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_DLIVY_GTN" id="sum2" headerText="'+parent.fn_text('exch_dlivy_gtn')+'" width="140" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_WRHS_QTY" id="sum3" headerText="'+parent.fn_text('exch_wrhs_qty')+'" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_WRHS_GTN" id="sum4" headerText="'+parent.fn_text('exch_wrhs_gtn')+'" width="140" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="SF_AMT" id="sum5" headerText="'+parent.fn_text('sf_amt')+'" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_EXCA_STAT_NM_PAGE"  headerText="'+parent.fn_text('stat')+'" width="100" itemRenderer="HtmlItem" />');
			 layoutStr.push('	</groupedColumns>');
			 layoutStr.push('		<footers>');
			 layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('				<DataGridFooterColumn/>');
			 layoutStr.push('				<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
			 layoutStr.push('				<DataGridFooterColumn/>');
			 layoutStr.push('				<DataGridFooterColumn/>');
			 layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum3}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum4}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum5}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('				<DataGridFooterColumn/>');
			 layoutStr.push('			</DataGridFooter>');
			 layoutStr.push('		</footers>');
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
		         
		       	//파라미터 call back function 실행
				 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
					 /* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
				 	 window[INQ_PARAMS.FN_CALLBACK]();
				 	//취약점점검 5992 기원우
				 }
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
		<input type="hidden" id="statList" value="<c:out value='${statList}' />" />
		<input type="hidden" id="mfcBizrList" value="<c:out value='${mfcBizrList}' />" />
		
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn_box">
			</div>
		</div>
		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">
					<div class="col">
						<div class="tit" id="exca_trgt_year" style="width: 100px;"></div>
						<div class="box">		
							<select id="EXCA_YEAR_SEL" name="EXCA_YEAR_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="mfc_bizrnm_txt"></div>
						<div class="box">						
							<select id="MFC_BIZR_SEL" name="MFC_BIZR_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="stat_txt"></div>
						<div class="box">						
							<select id="STAT_CD_SEL" name="STAT_CD_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="btn" id="CR">
					</div>
				</div>
			</div>
		</section>

			<div class="boxarea mt10">
				<div id="gridHolder" style="height:580px;"></div>
			</div>

	
		<section class="btnwrap mt20" >
			<div class="fl_l" id="BL">
			</div>
			<div class="fl_r" id="BR">
			</div>
		</section>
		
	</div>
	
</body>
</html>
