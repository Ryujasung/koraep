<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>정산연간조정</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
		 var parent_item;		//팝업창 오픈시 필드값
		 
		$(document).ready(function(){
			var bizrList =jsonObject($("#bizrList").val());	
			var adj_se 	=jsonObject($("#adj_se_list").val());	
			
			
			fn_btnSetting();
			
			$('#std_year').text(parent.fn_text('std_year'));
			$('#mfc_bizrnm').text(parent.fn_text('mfc_bizrnm'));
			$('#adj_se').text(parent.fn_text('adj_se'));

			
			var date = new Date();
		    var year = date.getFullYear();
		    var selected = "";
		    
		    for(i=2016; i<=year; i++){
		    	if(i == year) selected = "selected";
		    	$('#STD_YEAR_SEL').append('<option value="'+i+'" '+selected+'>'+i+'</option>');
		    }
		    
			//그리드 셋팅
			fn_set_grid();
			
			/************************************
			 * 조회 버튼 클릭 이벤트
			 ***********************************/
			$("#btn_sel").click(function(){
				fn_sel();
			});
			
			/************************************
			 * 조정수량관리 버튼클릭 이벤트
			 ***********************************/
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			kora.common.setEtcCmBx2(bizrList, "", "", $("#MFC_BIZR_SEL"), "BIZRID_NO", "BIZRNM", "N", "S");
			kora.common.setEtcCmBx2(adj_se, "","", $("#ADJ_SE"), "ETC_CD", "ETC_CD_NM", "N" ,'S');						
			
		});
	
		/**
		 * 목록조회
		 */
		function fn_sel(){
			
			if($("#MFC_BIZR_SEL").val() =="" ||$("#ADJ_SE").val() ==""){
				alertMsg("생산자, 조정구분 선택은 필수 입니다");
				return;
			}
			
			var url = "/CE/EPCE4707801_19.do";
			var input = {};
			var arr = [];
			arr = $("#MFC_BIZR_SEL").val().split(";");
			input['STD_YEAR'] 		= $("#STD_YEAR_SEL").val();	//기준년도
			input['ADJ_SE'] 			= $("#ADJ_SE").val();				//조정구분
			input['MFC_BIZRID'] 		= arr[0];								//생산자ID
			input['MFC_BIZRNO'] 	= arr[1];								//생산자NO
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData.searchList != null && rtnData.searchList != ""){
					gridApp.setData(rtnData.searchList);
				} else {
					gridApp.setData();
				}
			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
			});
		}
		
		//조정수량관리 페이지 이동
		function fn_reg(){
			var selectorColumn = gridRoot.getObjectById("selector");
			var input = {};
			var url = "/CE/EPCE4707888.do";		//조정수량관리페이지
			if(selectorColumn.getSelectedIndices() == "") {
				alertMsg("선택한 건이 없습니다.");
				return false;
			}
			parent_item  = gridRoot.getItemAt(selectorColumn.getSelectedIndices());
			var pagedata = window.frameElement.name;
			window.parent.NrvPub.AjaxPopup(url, pagedata);
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
			 layoutStr.push('	<DataGridSelectorColumn id="selector" 			headerText="'+parent.fn_text('cho')+'" 			width="50" verticalAlign="middle" allowMultipleSelection="false"  />');
			 layoutStr.push('	<DataGridColumn dataField="CTNR_NM"  		headerText="'+parent.fn_text('ctnr_nm')+'" 		width="200" />');
			 layoutStr.push('	<DataGridColumn dataField="MFC_BIZRNM"  	headerText="'+parent.fn_text('mfc_bizrnm')+'" 	width="100" />');
			 layoutStr.push('	<DataGridColumn dataField="ADJ_SE_NM"   	headerText="'+parent.fn_text('adj_se')+'" 			width="150"  textAlign="center"/>');													//조정구분
			 layoutStr.push('	<DataGridColumn dataField="FYER_QTY"			headerText="'+parent.fn_text('fyer_qty')+'"		width="130"  textAlign="right" formatter="{numfmt}" id="fyer_qty" />');	//연간수량
			 layoutStr.push('	<DataGridColumn dataField="ADJ_RT"  			headerText="'+parent.fn_text('adj_rt')+'" 			width="130"  textAlign="right"/>');														//조정비율
			 layoutStr.push('	<DataGridColumn dataField="ADJ_QTY"			headerText="'+parent.fn_text('revi_qty')+'" 		width="130"  textAlign="right"/>');														//보정수량
			 layoutStr.push('	<DataGridColumn dataField="ADJ_GTN"  		headerText="'+parent.fn_text('adj_dps')+'" 		width="130"  textAlign="right" id="adj_dps"/>');									//조정보증금
			 layoutStr.push('	<DataGridColumn dataField="ADJ_RST_QTY"	headerText="'+parent.fn_text('adj_rst_qty')+'" 	width="130"  textAlign="right" formatter="{numfmt}"   id="adj_rst_qty"/>');	//조정결과수량
			 layoutStr.push('	<DataGridColumn dataField="ADJ_PROC_STAT_NM"  headerText="'+parent.fn_text('stat')+'" 	width="70"/>');													
			 layoutStr.push('</groupedColumns>');
			 layoutStr.push('	<footers>');
			 layoutStr.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{fyer_qty}" 		formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{adj_dps}" 		formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{adj_rst_qty}" 	formatter="{numfmt}" textAlign="right" />');
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
		     }
		     var selectionChangeHandler = function(event) {
				rowIndex = event.rowIndex;
				var columnIndex = event.columnIndex;
				selectorColumn = gridRoot.getObjectById("selector");
				selectorColumn.setSelectedIndex(-1);
				selectorColumn.setSelectedIndex(rowIndex);
			 }
		     var dataCompleteHandler = function(event) {
		    	 dataGrid = gridRoot.getDataGrid(); // 그리드 객체
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
	    <input type="hidden" id="bizrList" value="<c:out value='${bizrList}' />" />
		<input type="hidden" id="adj_se_list" value="<c:out value='${adj_se}' />" />
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn_box">
			</div>
		</div>
		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">
					<div class="col">
						<div class="tit" id="std_year"></div>		<!-- 기준년도 -->
						<div class="box">		
							<select id="STD_YEAR_SEL" name="STD_YEAR_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="mfc_bizrnm"></div> <!-- 생산자 -->
						<div class="box">						
							<select id="MFC_BIZR_SEL" name="MFC_BIZR_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="adj_se"></div>	<!--  조정 구분 -->
						<div class="box">						
							<select id="ADJ_SE" name="ADJ_SE" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="btn" id="UR">
					</div>
				</div>
			</div>
		</section>

		<div class="boxarea mt10">
			<div id="gridHolder" style="height:560px;"></div>
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
