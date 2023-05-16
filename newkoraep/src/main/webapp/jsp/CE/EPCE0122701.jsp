<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>기준보증금관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">
     
    var INQ_PARAMS	;
    var initList;
    var toDay = kora.common.gfn_toDay();  // 현재 시간
	$(function() {

		INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
		initList = jsonObject($('#initList').val());
		
		//버튼 셋팅
		fn_btnSetting();
		
		fnSetGrid1();
		
		$("#title_sub").text('<c:out value="${titleSub}" />');

		/************************************
		 * 수정버튼 클릭 이벤트
		 ***********************************/
		$("#btn_upd").click(function(){
			fn_upd();
		});
		
		/************************************
		 * 추가버튼 클릭 이벤트
		 ***********************************/
		$("#btn_reg").click(function(){
			fn_reg();
		});
		
		/************************************
		 * 목록버튼 클릭 이벤트
		 ***********************************/
		$("#btn_lst").click(function(){
			fn_lst();
		});
		
		/************************************
		 * 삭제버튼 클릭 이벤트
		 ***********************************/
		$("#btn_del").click(function(){
			fn_del_chk();
		});
		
	});
	//삭제여부
	function fn_del_chk(){
		//선택 건이 없을 경우 
		 var selectorColumn = gridRoot.getObjectById("selector");
		 if(selectorColumn.getSelectedIndices() == "") {
			 alertMsg(parent.fn_text('sel_not'))
				return false;
			}
		var item = gridRoot.getItemAt(selectorColumn.getSelectedIndices());
		var arr  = new Array();
		var del = parent.fn_text('std_dps');
		arr = del.split("(");
		if(toDay >= item["APLC_ST_DT"]){
				if(toDay<=item["APLC_END_DT"]){
					alertMsg("적용기간 시작일이 익일 이후인 경우만 삭제 가능합니다");
					return;
				}
		}
		confirm(arr[0]+" " +  parent.fn_text('info_del'),"fn_del");
		return;
	}
	//삭제
	function fn_del() {
		
		var item = gridRoot.getItemAt(selectorColumn.getSelectedIndices());
        var url ="/CE/EPCE0122701_04.do";
		var input = {};
		
		input["CTNR_CD"]				= item["CTNR_CD"];
		input["CTNR_NM"]			= item["CTNR_NM"];
		input["STD_DPS"]				= item["STD_DPS"];
		input["LANG_SE_CD"]		= item["LANG_SE_CD"];
		input["REG_SN"]				= item["REG_SN"];
		input["PSBL_ST_DPS"]		= item["PSBL_ST_DPS"];
		input["PSBL_END_DPS"]		= item["PSBL_END_DPS"];
		input["START_DT"]			= item["APLC_ST_DT"];
		input["END_DT"]				= item["APLC_END_DT"];
		input["BTN_SE_CD"]			= "DL" //버튼 코드 저장
		
		
		showLoadingBar();
		ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {
				
				if(rtnData.RSLT_CD =="A006"){
					alertMsg(rtnData.RSLT_MSG);
				}else if(rtnData.RSLT_CD =="0000"){
				alertMsg(parent.fn_text("cd_del")); 
				gridApp.setData(rtnData.initList);
				}
			} else {
				alertMsg("error");
			}
		},false);
		hideLoadingBar();

	}

	//추가 
	function fn_reg() {

		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE0122701.do";
		kora.common.goPage('/CE/EPCE0122731.do', INQ_PARAMS);

	}

	//변경
	function fn_upd() {

		
		//선택 건이 없을 경우 
		var selectorColumn = gridRoot.getObjectById("selector");
		var input = gridRoot.getItemAt(selectorColumn.getSelectedIndices());
		
		 if(selectorColumn.getSelectedIndices() == "") {
			 alertMsg(parent.fn_text('sel_not'))
				return;
			}
		 
	   if (toDay > input["APLC_ST_DT"]) {
		   if (toDay > input["APLC_END_DT"]){
			   alertMsg("적용기간이 경과한 내역은 변경할 수 없습니다");
			   return;
		   }
		}

		//파라미터에 조회조건값 저장 
		INQ_PARAMS["PARAMS"] = {}
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE0122701.do";

		kora.common.goPage('/CE/EPCE0122742.do', INQ_PARAMS);

	}
	//목록
	function fn_lst() {
		kora.common.goPage('/CE/EPCE0105901.do', INQ_PARAMS);
	}

	/****************************************** 그리드 셋팅 시작***************************************** */
	/**
	 * 그리드 관련 변수 선언
	 */
	var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
	var gridApp, gridRoot, dataGrid, layoutStr, selectorColumn;

	/**
	 * 그리드 셋팅
	 */
	function fnSetGrid1(reDrawYn) {
		rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%");

		layoutStr = new Array();
		layoutStr.push('<rMateGrid>');
		layoutStr	.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
		layoutStr	.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" sortableColumns="true"   horizontalGridLines="true" headerHeight="35">');
		layoutStr.push('		<columns>');
		layoutStr	.push('			<DataGridSelectorColumn id="selector"	 headerText="'+ parent.fn_text('sel')+ '" 			width="50"		textAlign="center" allowMultipleSelection="false" />');
		layoutStr.push('			<DataGridColumn dataField="CTNR_CD"  headerText="'+ parent.fn_text('ctnr_cd')+ '"		width="100"	textAlign="center"/>');
		layoutStr.push('			<DataGridColumn dataField="CTNR_NM" headerText="'+ parent.fn_text('ctnr_nm')	+ '"	width="200"   textAlign="center"/>');
		layoutStr.push('			<DataGridColumn dataField="STD_DPS"	 headerText="'+ parent.fn_text('std_dps')	+ '"  	width="150"	textAlign="right" />');
		layoutStr.push('			<DataGridColumn dataField="PSBL_DPS"	 headerText="'+ parent.fn_text('psbl_dps')+ '"	width="150"	textAlign="right" />');
		layoutStr.push('			<DataGridColumn dataField="APLC_DT"	 headerText="'+ parent.fn_text('aplc_dt')	+ '"	width="200"	textAlign="center"/>');
		layoutStr	.push('			<DataGridColumn dataField="LANG_SE_CD"		width="10%" textAlign="center" visible="false"/>');
		layoutStr	.push('			<DataGridColumn dataField="REG_SN"			width="10%" textAlign="center" visible="false"/>');
		layoutStr	.push('			<DataGridColumn dataField="PSBL_ST_DPS"	width="10%" textAlign="center" visible="false"/>');
		layoutStr	.push('			<DataGridColumn dataField="PSBL_END_DPS"	width="10%" textAlign="center" visible="false"/>');
		layoutStr	.push('			<DataGridColumn dataField="APLC_ST_DT"		width="10%" textAlign="center" visible="false"/>');
		layoutStr	.push('			<DataGridColumn dataField="APLC_END_DT"	width="10%" textAlign="center" visible="false"/>');
		layoutStr.push('		</columns>');
		layoutStr.push('	</DataGrid>');
		layoutStr.push('</rMateGrid>');
	};

	/**
	 * 조회기준-생산자 그리드 이벤트 핸들러
	 */
	function gridReadyHandler(id) {
		gridApp = document.getElementById(id); // 그리드를 포함하는 div 객체
		gridRoot = gridApp.getRoot(); // 데이터와 그리드를 포함하는 객체
		gridApp.setLayout(layoutStr.join("").toString());
		gridApp.setData(initList);
		var layoutCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			dataGrid.addEventListener("change", selectionChangeHandler);
		}
		var dataCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
		}
		var selectionChangeHandler = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			selectorColumn = gridRoot.getObjectById("selector");
			selectorColumn.setSelectedIndex(-1);
			selectorColumn.setSelectedIndex(rowIndex);
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	}

	/**
	 * 그리드 loading bar on
	 */
	function showLoadingBar() {
		kora.common.showLoadingBar(dataGrid, gridRoot);
	}

	/**
	 * 그리드 loading bar off
	 */
	function hideLoadingBar() {
		kora.common.hideLoadingBar(dataGrid, gridRoot);
	}

	/****************************************** 그리드 셋팅 끝***************************************** */
</script>
<style type="text/css">

.row .tit{
width: 77px;
}

</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="initList" value="<c:out value='${initList}' />"/>

    <div class="iframe_inner">
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
			</div>
		<section class="secwrap mt30">
			<div class="boxarea mt10">
				<div id="gridHolder" style="height: 650px; background: #FFF;"></div>
			</div>	<!-- 그리드 셋팅 -->
		</section>	<!-- end of secwrap mt30  -->
       
		<section class="btnwrap mt20"  >
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
 
</div>

</body>
</html>