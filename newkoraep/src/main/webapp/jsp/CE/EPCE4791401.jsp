<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
		
		$(document).ready(function(){
			var statList =jsonObject($("#statList").val());	
			
			fn_btnSetting();
			
			$('#std_year').text(parent.fn_text('std_year'));
			$('#stat').text(parent.fn_text('stat'));

			var date = new Date();
		    var year = date.getFullYear();
		    var selected = "";
		    for(i=2016; i<=year; i++){
		    	if(i == year) selected = "selected";
		    	$('#STD_YEAR_SEL').append('<option value="'+i+'" '+selected+'>'+i+'</option>');
		    }
			
		 
			kora.common.setEtcCmBx2(statList, "", "", $("#STAT_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
		    
			//그리드 셋팅
			fn_set_grid();
			
			$("#btn_sel").click(function(){
				fn_sel();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});

		});
		
		function fn_reg(){
			
			var idx = dataGrid.getSelectedIndex();
			parent_item = gridRoot.getItemAt(idx);
			var pagedata = window.frameElement.name;
			window.parent.NrvPub.AjaxPopup('/CE/EPCE4791431.do', pagedata);
			//window.parent.NrvPub.AjaxPopup('/CE/EPCE4791442.do', pagedata);
			//window.parent.NrvPub.AjaxPopup('/CE/EPCE4791464.do', pagedata);
			
		}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){

			var url = "/CE/EPCE4791401_19.do";
			var input = {};
			input['STD_YEAR_SEL'] = $("#STD_YEAR_SEL option:selected").val();
			input['STAT_CD_SEL'] = $("#STAT_CD_SEL option:selected").val();
			
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
		
		//상세조회
		var parent_item;
		function fn_pop(){
			
			var idx = dataGrid.getSelectedIndex();
			parent_item = gridRoot.getItemAt(idx);

			var pagedata = window.frameElement.name;
			window.parent.NrvPub.AjaxPopup('/CE/EPCE4791464.do', pagedata);
		}
		
		//변경화면
		var parent_item;
		function fn_pop2(){

			var idx = dataGrid.getSelectedIndex();
			parent_item = gridRoot.getItemAt(idx);

			var pagedata = window.frameElement.name;
			window.parent.NrvPub.AjaxPopup('/CE/EPCE4791442.do', pagedata);
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
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="순번" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCA_STD_NM_LINK"  headerText="'+parent.fn_text('exca_term_nm')+'" width="250" itemRenderer="HtmlItem" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCA_DT"  headerText="'+parent.fn_text('exca_term')+'" width="300"/>');
			 layoutStr.push('	<DataGridColumn dataField="CRCT_PSBL_DT"  headerText="'+parent.fn_text('crct_psbl_term')+'" width="300" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCA_STAT_NM"  headerText="'+parent.fn_text('stat')+'" width="100" />');
			 layoutStr.push('	<DataGridColumn dataField="CET_FYER_EXCA_YN"  headerText="'+parent.fn_text('cet_exca')+'" width="150" />');
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
		<input type="hidden" id="statList" value="<c:out value='${statList}' />" />
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn_box">
			</div>
		</div>
		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">
					<div class="col">
						<div class="tit" id="std_year"></div>
						<div class="box">		
							<select id="STD_YEAR_SEL" name="STD_YEAR_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="stat"></div>
						<div class="box">						
							<select id="STAT_CD_SEL" name="STAT_CD_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="btn" id="UR">
					</div>
				</div>
			</div>
		</section>
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:330px;"></div>
			</div>
		</section>
	
		<section class="btnwrap mt20" >
			<div class="fl_l" id="BL">
			</div>
			<div class="fl_r" id="BR">
			</div>
		</section>
		
	</div>
	
</body>
</html>
