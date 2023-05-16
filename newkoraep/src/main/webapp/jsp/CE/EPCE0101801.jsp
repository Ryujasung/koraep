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
			
			fn_btnSetting();
			
			$('#std_year').text(parent.fn_text('std_year'));
			$('#std_dt').text(parent.fn_text('std_dt'));
			
			//날짜 셋팅
		    $('#STD_DT_SEL').YJcalendar({  
				triggerBtn : true
				,dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
				
			});
			
		    var date = new Date();
		    var year = date.getFullYear();
		    var selected = "";
		    for(i=2016; i<=year; i++){
		    	if(i == year) selected = "selected";
		    	$('#STD_YEAR_SEL').append('<option value="'+i+'" '+selected+'>'+i+'</option>');
		    }
			
		    //그리드 셋팅
			fn_set_grid();
		    
			$("#btn_sel").click(function(){
				fn_sel();
			});
		    
			$("#btn_pop").click(function(){
				fn_pop();
			});
			
			$("#btn_excel").click(function(){
				fn_excel();
			});
			
			
			/************************************
			 * 날짜  클릭시 - 삭제  변경 이벤트
			 ***********************************/
			$("#STD_DT_SEL").click(function(){
			    var dt = $("#STD_DT_SEL").val();
			     dt   =  dt.replace(/-/gi, "");
			     $("#STD_DT_SEL").val(dt);
			});
			
			/************************************
			 * 날짜  클릭시 - 추가  변경 이벤트
			 ***********************************/
			$("#STD_DT_SEL").change(function(){
			    var dt = $("#STD_DT_SEL").val();
			    dt   =  dt.replace(/-/gi, "");
				if(dt.length == 8)  dt = kora.common.formatter.datetime(dt, "yyyy-mm-dd")
			     $("#STD_DT_SEL").val(dt) ;
				
				if($("#STD_DT_SEL").val() == ''){
					//$('#STD_YEAR_SEL').prop("disabled", false);
				}else{
					//$('#STD_YEAR_SEL').prop("disabled", true);
					//$('#STD_YEAR_SEL').val($("#STD_DT_SEL").val().substring(0,4));
				}
			});
			
			/************************************
			 * 라디오버튼  변경 이벤트
			 ***********************************/
			$(':radio[name="STD_RADIO"]').click(function(){

				if($(':radio[name="STD_RADIO"]:checked').val() == "YEAR"){
					$('#STD_YEAR_SEL').prop("disabled", false);
					$('#STD_DT_SEL').prop("disabled", true);
				}else if($(':radio[name="STD_RADIO"]:checked').val() == "DAY"){
					$('#STD_YEAR_SEL').prop("disabled", true);
					$('#STD_DT_SEL').prop("disabled", false);
				}
				
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
					
					item['dataField'] = columns[i].getDataField();
					
					item['textAlign'] = columns[i].getStyle('textAlign');
					item['id'] = kora.common.null2void(columns[i].id);

					col.push(item);
				}
			}
			
			var input = INQ_PARAMS["SEL_PARAMS"];
			input['excelYn'] = 'Y';
			input['fileName'] = fileName;
			input['columns'] = JSON.stringify(col);
			
			var url = "/CE/EPCE0101801_05.do";
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
		
		var parent_item;
		//조정금액관리 팝업
		function fn_pop(){
			
			var idx = dataGrid.getSelectedIndex();
			
			if(idx < 0){
				alertMsg('선택된 행이 없습니다');
				return;
			}
			
			parent_item = gridRoot.getItemAt(idx);
			var pagedata = window.frameElement.name;
			window.parent.NrvPub.AjaxPopup('/CE/EPCE0101888.do', pagedata);
		}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){

			var url = "/CE/EPCE0101801_19.do";
			var input = {};
			
			if($(':radio[name="STD_RADIO"]:checked').val() == "YEAR"){
				input['STD_YEAR_SEL'] = $("#STD_YEAR_SEL option:selected").val();
			}else if($(':radio[name="STD_RADIO"]:checked').val() == "DAY"){
				input['STD_DT_SEL'] = $("#STD_DT_SEL").val().replace(/\-/g,"");
			}
			
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
			 layoutStr.push('<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >'); 
			 layoutStr.push('<groupedColumns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="false" headerText="'+parent.fn_text('cho')+'" width="50" />');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="250" />');
			 layoutStr.push('	<DataGridColumn dataField="PLAN_GTN_BAL" id="planGtnBal" headerText="'+parent.fn_text('gtn_plan_bal')+'" width="130" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="ADIT_GTN_BAL" id="aditGtnBal" headerText="'+parent.fn_text('adit_gtn')+'" width="130" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="DRCT_PAY_GTN_BAL" id="drctPayGtnBal" headerText="'+parent.fn_text('non_pay_rtrvl_gtn')+'" width="150" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="PLAN_GTN_ADJ" id="planGtnAdj" headerText="'+parent.fn_text('plan_bal_adj')+'" width="150" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="ADIT_GTN_ADJ" id="aditGtnAdj" headerText="'+parent.fn_text('adit_gtn_adj')+'" width="150" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="DRCT_PAY_GTN_ADJ" id="drctPayGtnAdj" headerText="'+parent.fn_text('non_pay_rtrvl_adj')+'" width="180" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumnGroup  	headerText="일일">');
			 layoutStr.push('	<DataGridColumn dataField="NOTY_AMT" id="noty_amtAdj" headerText="미수금" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="GTN_TOT" id="gtn_totAdj" headerText="미지급금" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('</DataGridColumnGroup>');
			 
			 layoutStr.push('	<DataGridColumn dataField="GTN_BAL" id="gtnBal" headerText="보증금실제잔액" width="150" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('</groupedColumns>');
			 layoutStr.push('	<footers>');
			 layoutStr.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{planGtnBal}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{aditGtnBal}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{drctPayGtnBal}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{planGtnAdj}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{aditGtnAdj}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{drctPayGtnAdj}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{noty_amtAdj}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{gtn_totAdj}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{gtnBal}" formatter="{numfmt}" textAlign="right" />');
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
		         gridApp.setData([]);
		     }
		     		     
		     var selectionChangeHandler = function(event) {
				rowIndex = event.rowIndex;
				selectorColumn.setSelectedIndex(-1);
				selectorColumn.setSelectedIndex(rowIndex);
			 }
		     
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
		
	</script>

	<style type="text/css">
		.row .tit{width: 67px;}
	</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>

	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn_box">
				<div class="btn" id="UR">
				</div>
			</div>
		</div>
		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">
					<div class="col">
						<div style="float: left; position: relative; margin: 0 20px 0 0; padding: 0 0 0 10px; font-weight: 700; font-size: 14px; line-height: 36px; color: #222222;">
							<input type="radio" id="STD_RADIO1" name="STD_RADIO" value="YEAR" style="margin:10px; width: 19px; height: 19px;  background: url(../../images/util/rdo.png) 0 0 no-repeat;" checked /><span id="std_year"></span>
						</div>
						<div class="box">
							<select id="STD_YEAR_SEL" name="STD_YEAR_SEL" style="width: 179px;" >
							</select>
						</div>
					</div>
					<div class="col">
						<div style="float: left; position: relative; margin: 0 20px 0 0; padding: 0 0 0 10px; font-weight: 700; font-size: 14px; line-height: 36px; color: #222222;">
							<input type="radio" id="STD_RADIO2" name="STD_RADIO" value="DAY" style="margin:10px; width: 19px; height: 19px;  background: url(../../images/util/rdo.png) 0 0 no-repeat;" /><span id="std_dt"></span>
						</div>
						<div class="box">		
							<div class="calendar">
								<input type="text" id="STD_DT_SEL" name="STD_DT_SEL" style="width: 179px;" disabled>
							</div>
						</div>
					</div>
					<div class="btn" id="CR">
					</div>
				</div>
			</div>
		</section>
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:550px;"></div>
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
