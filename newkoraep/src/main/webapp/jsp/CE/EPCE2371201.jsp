<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
		
		var INQ_PARAMS ;
	
		$(document).ready(function(){
			
			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			
			fn_btnSetting();
			
			$('#sel_term').text(parent.fn_text('sel_term'));
			$('#se').text(parent.fn_text('se'));
			$('#mfc_bizrnm').text(parent.fn_text('mfc_bizrnm'));
			$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm'));
			
			//날짜 셋팅
		    $('#START_DT_SEL').YJcalendar({  
				toName : 'to',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -2, false).replaceAll('-','')
				
			});
			$('#END_DT_SEL').YJcalendar({
				fromName : 'from',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
			});
			
			var bizrList = jsonObject($('#bizrList').val());
			var brchList = jsonObject($('#brchList').val());
			var rtnStatList = jsonObject($('#rtnStatList').val());

			kora.common.setEtcCmBx2(bizrList, "", "", $("#MFC_BIZR_SEL"), "BIZRID_NO", "BIZRNM", "N", "T");
			kora.common.setEtcCmBx2(brchList, "", "", $("#MFC_BRCH_SEL"), "BRCH_ID_NO", "BRCH_NM", "N" ,"T");
			kora.common.setEtcCmBx2(rtnStatList, "", "", $("#RTN_STAT_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
	
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
			
			/************************************
			 * 생산자 변경 이벤트
			 ***********************************/
			 $("#MFC_BIZR_SEL").change(function(){
					fn_bizr();
			 });
			
			 /************************************
			 * 엑셀다운로드 버튼 클릭 이벤트
			 ***********************************/
			 $("#btn_excel").click(function() {
				 fn_excel();
			 });
			 
		});
		
		//엑셀저장
		function fn_excel(){

			var collection = gridRoot.getCollection();
			if(collection.getLength() < 1){
				alertMsg("데이터가 없습니다.");
				return;
			}
			
			if(INQ_PARAMS["SEL_PARAMS"] == undefined){
				alertMsg("먼저 데이터를 조회해야 합니다.");
				return;
			}
						
			var now  = new Date(); 				     // 현재시간 가져오기
			var hour = new String(now.getHours());   // 시간 가져오기
			var min  = new String(now.getMinutes()); // 분 가져오기
			var sec  = new String(now.getSeconds()); // 초 가져오기
			var today = kora.common.gfn_toDay();
			var fileName = $('#title').text() +"_" + today+hour+min+sec+".xlsx";
			
			//그리드 컬럼목록 저장
			var col = new Array();
			var columns = dataGrid.getColumns();
			for(i=0; i<columns.length; i++){
				if(columns[i].getDataField() != undefined && columns[i].getDataField() != 'index'){ //순번 제외
					var item = {};
					item['headerText'] = columns[i].getHeaderText();
					
					if(columns[i].getDataField() == 'WRHS_CFM_DT_PAGE'){// html 태크 사용중 컬럼은 대체
						item['dataField'] = 'WRHS_CFM_DT';
					}else{
						item['dataField'] = columns[i].getDataField();
					}
					
					item['textAlign'] = columns[i].getStyle('textAlign');
					item['id'] = kora.common.null2void(columns[i].id);
					
					col.push(item);
				}
			}
			
			var input = INQ_PARAMS["SEL_PARAMS"];
			input['fileName'] = fileName;
			input['columns'] = JSON.stringify(col);
			
			var url = "/CE/EPCE2371201_05.do";
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
					alertMsg(rtnData.RSLT_MSG);
				}else{
					//파일다운로드
					frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
					frm.fileName.value = fileName;
					frm.submit();
				}
			});
		}
		
		function fn_reg(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}
			
			confirm("선택된 내역에 대해 취급수수료 고지서를 발급하시겠습니까?", "fn_reg_exec");

		}
		
		function fn_reg_exec(){
			
			var data = {};
			var row = new Array();
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(item);
			}
			
			data["list"] = JSON.stringify(row);

			var url = "/CE/EPCE2371201_09.do";
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

			var url = "/CE/EPCE2371201_19.do";
			var input = {};
			
			input['START_DT_SEL'] = $("#START_DT_SEL").val();
			input['END_DT_SEL'] = $("#END_DT_SEL").val();
			input['RTN_STAT_CD_SEL'] = $("#RTN_STAT_CD_SEL option:selected").val();
			input['MFC_BIZR_SEL'] = $("#MFC_BIZR_SEL option:selected").val();
			input['MFC_BRCH_SEL'] = $("#MFC_BRCH_SEL option:selected").val();
			
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
		
		function fn_bizr(){
			
			var url = "/SELECT_BRCH_LIST.do" 
			var input ={};
		    input["BIZRID_NO"] =$("#MFC_BIZR_SEL").val();

       	    ajaxPost(url, input, function(rtnData) {
       	    	if (null != rtnData) {   
   					kora.common.setEtcCmBx2(rtnData, "","", $("#MFC_BRCH_SEL"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');
   				} else {
   					alertMsg("error");
   				}
    		});
	       	    
		}
		
		//상세화면 이동
		function fn_page(){

			var idx = dataGrid.getSelectedIndices();
			var input = gridRoot.getItemAt(idx);
			
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE2371201.do";
			kora.common.goPage('/CE/EPCE29164642.do', INQ_PARAMS);
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
			 layoutStr.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="true" headerText="" width="40" verticalAlign="middle" />');
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" width="50"/>');
			 layoutStr.push('	<DataGridColumn dataField="MFC_BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150" />');
			 layoutStr.push('	<DataGridColumn dataField="MFC_BRCH_NM"  headerText="'+parent.fn_text('mfc_brch_nm')+'" width="150" />');
			 layoutStr.push('	<DataGridColumn dataField="WHSDL_BIZRNM"  headerText="'+parent.fn_text('whsdl')+'" width="150" />');
			 layoutStr.push('	<DataGridColumn dataField="WRHS_CFM_DT_PAGE"  headerText="'+parent.fn_text('wrhs_cfm_dt')+'" width="100" itemRenderer="HtmlItem"/>');
			 layoutStr.push('	<DataGridColumn dataField="CFM_QTY_TOT"  id="sum1" headerText="'+parent.fn_text('wrhs_qty')+'" width="100" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="CFM_WHSL_FEE_TOT" id="sum2"  headerText="'+parent.fn_text('whsl_fee2')+'" width="100" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="CFM_RTL_FEE_TOT" id="sum4"  headerText="'+parent.fn_text('rtl_fee2')+'" width="100" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="CFM_WHSL_FEE_STAX_TOT" id="sum3"  headerText="'+parent.fn_text('stax')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="CFM_FEE_TOT" id="sum6"  headerText="'+parent.fn_text('amt')+'" width="100" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="RTN_STAT_NM"  headerText="'+parent.fn_text('se')+'" width="100"/>');
			 layoutStr.push('	<DataGridColumn dataField="CFM_GTN_TOT" id="sum7"  headerText="'+parent.fn_text('refn_gtn')+'" formatter="{numfmt}" textAlign="right" width="100"/>');
			 layoutStr.push('</groupedColumns>');
			 layoutStr.push('	<footers>');
			 layoutStr.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum4}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum3}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum6}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum7}" formatter="{numfmt}" textAlign="right" />');
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

		       	 //파라미터 call back function 실행
				 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
				 	eval(INQ_PARAMS.FN_CALLBACK+"()");
				 }else{
					gridApp.setData();
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
		.row .tit{width: 77px;}
	</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="bizrList" value="<c:out value='${bizrList}' />"/>
<input type="hidden" id="brchList" value="<c:out value='${brchList}' />"/>
<input type="hidden" id="rtnStatList" value="<c:out value='${rtnStatList}' />"/>

	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn" style="float:right" id="UR"></div>
		</div>
		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">
					<div class="col">
						<div class="tit" id="sel_term"></div>
						<div class="box">		
							<div class="calendar">
								<input type="text" id="START_DT_SEL" name="from" style="width: 140px;" class="i_notnull" ><!--시작날짜  -->
							</div>
							<div class="obj">~</div>
							<div class="calendar">
								<input type="text" id="END_DT_SEL" name="to" style="width: 140px;"	class="i_notnull" ><!-- 끝날짜 -->
							</div>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="se" style=""></div>
						<div class="box">
							<select id="RTN_STAT_CD_SEL" name="RTN_STAT_CD_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col">
						<div class="tit" id="mfc_bizrnm"></div>
						<div class="box">						
							<select id="MFC_BIZR_SEL" name="MFC_BIZR_SEL" style="width: 179px;">
							</select>
							<span style="width:116px"></span>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="mfc_brch_nm" style=""></div>
						<div class="box">
							<select id="MFC_BRCH_SEL" name="MFC_BRCH_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="btn" id="CR">
					</div>
				</div>
			</div>
		</section>
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:375px;"></div>
			</div>
		</section>
	
		<section class="btnwrap mt20" >
			<div class="fl_l" id="BL">
			</div>
			<div class="fl_r" id="BR">
			</div>
		</section>
		
	</div>
	
	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="excel" />
	</form>
	
</body>
</html>
