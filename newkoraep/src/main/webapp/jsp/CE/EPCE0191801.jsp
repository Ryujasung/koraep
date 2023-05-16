<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>기준취급수수료관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">
     
    var INQ_PARAMS	;
    var initList;
    var rowIndexValue	= "";						//선택한 항목 입력값
    var toDay = kora.common.gfn_toDay();  // 현재 시간

	$(function() {

		INQ_PARAMS	 = jsonObject($('#INQ_PARAMS').val());
	    initList			 = jsonObject($('#initList').val());
		
		//버튼 셋팅
		fn_btnSetting();
		//그리드 셋팅
		fnSetGrid1();
		
		$("#title_sub").text('<c:out value="${titleSub}" />');

		/************************************
		 * 추가버튼 클릭 이벤트
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
		 * 목록버튼 클릭 이벤트
		 ***********************************/
		$("#btn_del").click(function(){
			fn_del_chk();
		});
		
		
		//파라미터 조회조건으로 셋팅
		if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
			kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
		}
		
	});
	//삭제여부
	function fn_del_chk(){
		//선택 건이 없을 경우 
		 var selectorColumn = gridRoot.getObjectById("selector");
		 if(selectorColumn.getSelectedIndices() == "") {
			 alertMsg(parent.fn_text('sel_not'))
				return false;
			}
		var item = gridRoot.getItemAt(rowIndexValue);
		var arr  = new Array();
		var del = parent.fn_text('std_fee');
		arr = del.split("(");
		if(toDay>item["APLC_ST_DT"] && toDay>item["APLC_END_DT"]){
			alertMsg("적용기간 시작일이 익일 이후인 경우만 삭제 가능합니다");
			return;
		}
		confirm(arr[0]+" " +  parent.fn_text('info_del'),"fn_del");
		return;
	}

	//삭제
	function fn_del() {//선택 건이 없을 경우 

		var item = gridRoot.getItemAt(rowIndexValue);
		var url ="/CE/EPCE0191801_04.do";
		var input = {};
		
		input["CTNR_CD"]					= item["CTNR_CD"];           			//용기코드 
		input["CTNR_NM"]				= item["CTNR_NM"];              		//빈용기명     
		input["LANG_SE_CD"]			= item["LANG_SE_CD"];                //언어코드
		input["REG_SN"]					= item["REG_SN"];						//등록순번
		input["STD_FEE"]					= item["STD_FEE"];            			//기준취급수수료    
		input["PSBL_ST_FEE"]			= item["PSBL_ST_FEE"];            		//조정 가능 최저 기준취급수수료   
		input["PSBL_END_FEE"]			= item["PSBL_END_FEE"];           	//조정 가능 최고 기준취급수수료   
		input["STD_WHSL_FEE"]			= item["STD_WHSL_FEE"];           	//기준도매수수료                
		input["PSBL_ST_WHSL_FEE"]	= item["PSBL_ST_WHSL_FEE"];		//조정 가능 최저 기준도매수수료               
		input["PSBL_END_WHSL_FEE"]= item["PSBL_END_WHSL_FEE"];		//조정 가능 최고 기준도매수수료               
		input["STD_RTL_FEE"]			= item["STD_RTL_FEE"];                //기준소매수수             
		input["PSBL_ST_RTL_FEE"]		= item["PSBL_ST_RTL_FEE"];			//최저 기준소매수수료         
		input["PSBL_END_RTL_FEE"]	= item["PSBL_END_RTL_FEE"];        //최고 기준소매수수료                 
		input["START_DT"]				= item["APLC_ST_DT"];                 	//시작날짜 
		input["END_DT"]					= item["APLC_END_DT"];               //끝날짜  
		input["BTN_SE_CD"]				= "DL"										//버튼코드
	
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
		});
		hideLoadingBar();
	}

	//추가 
	function fn_reg() {

		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE0191801.do";
		kora.common.goPage('/CE/EPCE0191831.do', INQ_PARAMS);

	}

	//변경
	function fn_upd() {

		//선택 건이 없을 경우 
		var input = {};
		var selectorColumn = gridRoot.getObjectById("selector");
		var item = gridRoot.getItemAt(selectorColumn.getSelectedIndices());
		
		 if(selectorColumn.getSelectedIndices() == "") {
			 alertMsg(parent.fn_text('sel_not'))
				return;
			}

		 console.log(item["APLC_END_DT"])
		 if (toDay > item["APLC_ST_DT"]) {
		   if (toDay > item["APLC_END_DT"]){
			   alertMsg("적용기간이 경과한 내역은 변경할 수 없습니다");
			   return;
		   }
		}
		
		input["CTNR_CD"]					= item["CTNR_CD"];           			//용기코드 
		input["CTNR_NM"]				= item["CTNR_NM"];              		//빈용기명     
		input["LANG_SE_CD"]			= item["LANG_SE_CD"];                //언어코드
		input["REG_SN"]					= item["REG_SN"];						//등록순번
		input["STD_FEE"]					= item["STD_FEE"];            			//기준취급수수료    
		input["PSBL_ST_FEE"]			= item["PSBL_ST_FEE"];            		//조정 가능 최저 기준취급수수료   
		input["PSBL_END_FEE"]			= item["PSBL_END_FEE"];           	//조정 가능 최고 기준취급수수료   
		input["STD_WHSL_FEE"]			= item["STD_WHSL_FEE"];           	//기준도매수수료                
		input["PSBL_ST_WHSL_FEE"]	= item["PSBL_ST_WHSL_FEE"];		//조정 가능 최저 기준도매수수료               
		input["PSBL_END_WHSL_FEE"]= item["PSBL_END_WHSL_FEE"];		//조정 가능 최고 기준도매수수료               
		input["STD_RTL_FEE"]			= item["STD_RTL_FEE"];                //기준소매수수             
		input["PSBL_ST_RTL_FEE"]		= item["PSBL_ST_RTL_FEE"];			//최저 기준소매수수료         
		input["PSBL_END_RTL_FEE"]	= item["PSBL_END_RTL_FEE"];        //최고 기준소매수수료                 
		input["START_DT"]				= item["APLC_ST_DT"];                 	//시작날짜 
		input["END_DT"]					= item["APLC_END_DT"];               //끝날짜  

		//파라미터에 조회조건값 저장 
		INQ_PARAMS["PARAMS"] = {}
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE0191801.do";

		kora.common.goPage('/CE/EPCE0191842.do', INQ_PARAMS);

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
		layoutStr	.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" sortableColumns="true"   horizontalGridLines="true" headerHeight="60">');
		layoutStr.push('		<columns>');
		layoutStr	.push('			<DataGridSelectorColumn id="selector"	 headerText="'+ parent.fn_text('sel')+ '"			width="50"	textAlign="center" allowMultipleSelection="false" />');
		layoutStr.push('			<DataGridColumn dataField="CTNR_CD"  headerText="'+ parent.fn_text('ctnr_cd')	+ '"	width="70"	textAlign="center"/>');
		layoutStr.push('			<DataGridColumn dataField="CTNR_NM" headerText="'+ parent.fn_text('ctnr_nm')	+ '"	width="350"	textAlign="center"/>');
		layoutStr	.push('			<DataGridColumn dataField="STD_DPS"	 headerText="'+ parent.fn_text('std_dps')	+ '"   width="80"	itemRenderer="HtmlItem"  textAlign="center" />');//보증금원
		layoutStr.push('			<DataGridColumn dataField="STD_FEE"	 headerText="'+ parent.fn_text('std_fee')+ '"		width="80"	textAlign="center" />'); //기준취급수수료
		layoutStr.push('			<DataGridColumn dataField="STD_WHSL_FEE"	 headerText="'+ parent.fn_text('std_whsl_fee')	+ '"	width="80"	textAlign="center"/>');//기준도매수수료
		layoutStr	.push('			<DataGridColumn dataField="STD_RTL_FEE"		 headerText="'+ parent.fn_text('std_rtl_fee')	+ '"		width="80"	itemRenderer="HtmlItem"  textAlign="center" />');//기준소매수수료
		layoutStr.push('			<DataGridColumn dataField="PSBL_FEE"			 headerText="'+ parent.fn_text('psbl_fee')+ '"			width="100"	textAlign="center" />'); //취급수수료 조정 가능범위
		layoutStr.push('			<DataGridColumn dataField="PSBL_WHSL_FEE" headerText="'+ parent.fn_text('psbl_whsl_fee')+ '"	width="100"	textAlign="center" />');//도매수수료 조정 가능범위
		layoutStr.push('			<DataGridColumn dataField="PSBL_RTL_FEE"	 headerText="'+ parent.fn_text('psbl_rtl_fee')+ '"		width="100"	textAlign="center" />');//소매수수료 조정 가능범위
		layoutStr.push('			<DataGridColumn dataField="APLC_DT"			 headerText="'+ parent.fn_text('aplc_dt')	+ '"			width="210"	textAlign="center"/>');
	
		layoutStr	.push('			<DataGridColumn dataField="LANG_SE_CD"		 textAlign="center" visible="false"/>');
		layoutStr	.push('			<DataGridColumn dataField="REG_SN"			 textAlign="center" visible="false"/>');
		layoutStr	.push('			<DataGridColumn dataField="PSBL_ST_FEE"	     textAlign="center" visible="false"/>');
		layoutStr	.push('			<DataGridColumn dataField="PSBL_END_FEE"	 textAlign="center" visible="false"/>');
		layoutStr	.push('			<DataGridColumn dataField="PSBL_ST_WHSL_FEE"	 textAlign="center" visible="false"/>');
		layoutStr	.push('			<DataGridColumn dataField="PSBL_END_WHSL_FEE"	 textAlign="center" visible="false"/>');
		layoutStr	.push('			<DataGridColumn dataField="PSBL_ST_RTL_FEE"	     textAlign="center" visible="false"/>');
		layoutStr	.push('			<DataGridColumn dataField="PSBL_END_RTL_FEE"	 textAlign="center" visible="false"/>');
		layoutStr	.push('			<DataGridColumn dataField="APLC_ST_DT"		         textAlign="center" visible="false"/>');
		layoutStr	.push('			<DataGridColumn dataField="APLC_END_DT"			 textAlign="center" visible="false"/>');
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

			rowIndexValue = rowIndex;
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