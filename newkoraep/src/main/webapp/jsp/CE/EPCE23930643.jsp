<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>보증금(조정)고지서 상세조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS	; 	//파라미터 데이터
	 var searchList 		;	//출고보증금 그리드
	 var searchList2 		;	//지급예정보증금 그리드
	 var searchList3 		;	//직접회수보증금 그리드
	 var searchDtl			;
	 
     $(function() {
    	 
    	 INQ_PARAMS	= jsonObject($('#INQ_PARAMS').val());
    	 searchList 		= jsonObject($('#searchList').val());
    	 searchList2 	= jsonObject($('#searchList2').val());
    	 searchList3 	= jsonObject($('#searchList3').val());
    	 searchDtl		= jsonObject($('#searchDtl').val());

    	 $('#title_sub').text('<c:out value="${titleSub}" />');
    	 
    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
    	 //그리드 셋팅
		 fn_set_grid();
		 fn_set_grid2();
		 
		 if(searchList3.length > 0){
			 fn_set_grid3();
			 $('#DRCT_YN').val('Y');
		 }else{
			$('#DRCT_DIV').hide();
			$('#DRCT_TR1').hide();
			$('#DRCT_TR2').hide();
		 }
		
		 if(searchDtl.ADD_GTN_ACMT == 0 && searchDtl.ADD_GTN == 0 && searchDtl.ADD_GTN_BAL == 0){
			 $('#ADIT_TR').hide();
		 }else{
			 $('#ADIT_YN').val('Y');
		 }
		 
		//text 셋팅
		$('.write_area .write_tbl table tr th.bd_l').each(function(){
			if($(this).attr('id') != ''){
				var tt = parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt')));
				$(this).html(tt);
			}
		});
		
		$('.h4group > .tit').each(function(){
			$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
		});
		
	
		/************************************
		 * 목록 클릭 이벤트
		 ***********************************/
		$("#btn_page").click(function(){
			fn_page();
		});
		
		var data = searchDtl;
		$('.row > .txtbox').each(function(){
			if($(this).attr('data') == 'number'){
				if($(this).attr('id') != ''){
					$(this).text(kora.common.format_comma(eval('data.'+$(this).attr('id'))));
				}
			}else if($(this).attr('id') == 'NOTY_AMT' || $(this).attr('id') == 'ADD_AMT'){
				$(this).text(kora.common.format_comma(eval('data.'+$(this).attr('id'))) + ' 원');
			}else if($(this).attr('id') == 'BIZRNO'){
				$(this).text(kora.common.setDelim(eval('data.'+$(this).attr('id')), '999-99-99999') );
			}else if($(this).attr('id') == 'RISU_RSN' && data.RISU_RSN != undefined){
				$(this).html(eval('data.'+$(this).attr('id')).replaceAll('\\n', '<br>'));
			}else if($(this).attr('id') == 'RISU_DT' && data.RISU_DT != undefined){
				$(this).text(kora.common.setDelim(eval('data.'+$(this).attr('id')), '9999-99-99') );
			}else{
				$(this).text(eval('data.'+$(this).attr('id')));
			}
		});
		
		//가산금 존재시 보여줌
		if(data.ADD_AMT_SE != undefined){
			$('#risuSection').show();
		}

		$("#btn_upd").click(function(){
			fn_upd();
		});
		
		//취소요청사유
		$("#btn_pop2").click(function(){
			fn_pop2();
		});
		
		//취소요청취소
		$("#btn_upd2").click(function(){
			fn_upd2();
		});
		
		//재고지취소
		$("#btn_upd3").click(function(){
			fn_upd3();
		});
		
		/************************************
		 * 인쇄 클릭 이벤트
		 ***********************************/
		$("#btn_pnt").click(function(){
			fn_pnt();
		});
		
		/************************************
		 * 재고지 팝업
		 ***********************************/
		$("#btn_pop").click(function(){
			fn_pop();
		});
		
	});
     
    var parent_item; 
    
    //취소요청사유
 	function fn_pop2(){
      	if(searchDtl.ISSU_STAT_CD != 'C'){ alertMsg('취소요청 내역에 대해서만 조회 가능 합니다.'); return; }
      	
      	var pagedata = window.frameElement.name;
 		parent_item.CNL_REQ_SEQ = searchDtl.CNL_REQ_SEQ;
 		window.parent.NrvPub.AjaxPopup('/CE/EPCE23930882.do', pagedata);
 	}
    
 	//취소요청 취소
	function fn_upd2(){
		if(searchDtl.ISSU_STAT_CD != 'C'){
			alertMsg("취소요청 상태의 고지서만 취소요청취소 가능합니다.");
			return false;
		}
    	
		confirm("취소요청취소 처리 하시겠습니까?", 'fn_upd2_exec');
	}
	
	function fn_upd2_exec(){
		
		var data = {};
 		var url = "/CE/EPCE2393064_212.do";
 		
 		data["BILL_DOC_NO"] = searchDtl.BILL_DOC_NO;
 		data["CNL_REQ_SEQ"] = searchDtl.CNL_REQ_SEQ;
 				
		ajaxPost(url, data, function(rtnData){
			if(rtnData != null && rtnData != ""){
				if(rtnData.RSLT_CD =="0000"){
					alertMsg(rtnData.RSLT_MSG, 'fn_page');
				}else{
					alertMsg(rtnData.RSLT_MSG);
				}
			}else{
				alertMsg("error");
			}
		}, false);
				
	}
     
	//재고지 취소
   	function fn_upd3(){

    	if(searchDtl.ADD_AMT_SE == '' || searchDtl.ADD_AMT_SE == undefined){
    		alertMsg('재고지처리된 고지서가 아닙니다.');
     		return;
    	}
    	
   		if(INQ_PARAMS.PARAMS.ISSU_STAT_CD != 'I'){
     		alertMsg('발급상태의 고지서만 재고지취소 가능합니다.');
     		return;
     	}
       	
   		confirm("재고지취소 하시겠습니까?", 'fn_upd3_exec');
   	}
   	
   	function fn_upd3_exec(){
   		
   		var data = {};
   		var url = "/CE/EPCE2393064_213.do";
   		
   		data["BILL_DOC_NO"] = searchDtl.BILL_DOC_NO;
    				
   		ajaxPost(url, data, function(rtnData){
   			if(rtnData != null && rtnData != ""){
   				if(rtnData.RSLT_CD =="0000"){
   					alertMsg(rtnData.RSLT_MSG, 'fn_reload');
   				}else{
   					alertMsg(rtnData.RSLT_MSG);
   				}
   			}else{
   				alertMsg("error");
   			}
   		}, false);
   				
   	}
	
    //재고지
     function fn_pop(){

     	if(INQ_PARAMS.PARAMS.ISSU_STAT_CD != 'I'){
     		alertMsg('발급상태의 고지서만 재고지 가능합니다.');
     		return;
     	}
     	
 		parent_item = searchDtl;
 		var pagedata = window.frameElement.name;
 		window.parent.NrvPub.AjaxPopup('/CE/EPCE2393088.do', pagedata);
 	}
	 
   //인쇄
   	function fn_pnt(){
  		var bill_doc_no = searchDtl.BILL_DOC_NO;
		var day = bill_doc_no.substring(3,11);
		var number = parseInt(day);
		if(number > 20210609) {     // 21.6.10 일자이후 자원순환보증금관리센터
			$('form[name="prtForm"] input[name="BILL_DOC_NO"]').val(searchDtl.BILL_DOC_NO);
	   		$('form[name="prtForm"] input[name="MFC_BIZRNO"]').val(searchDtl.MFC_BIZRNO);
	   		kora.common.gfn_viewReport('prtForm', '');
		}else{
			$('form[name="prtForm3"] input[name="BILL_DOC_NO"]').val(searchDtl.BILL_DOC_NO);
	   		$('form[name="prtForm3"] input[name="MFC_BIZRNO"]').val(searchDtl.MFC_BIZRNO);
	   		kora.common.gfn_viewReport('prtForm3', '');
			}
    }
     
    //발급취소
	function fn_upd(){
		if(searchDtl.ISSU_STAT_CD == 'A'){
			alertMsg("수납확인 상태의 고지서는 발급취소할 수 없습니다.");
			return false;
		}
    	
		confirm("발급된 고지서를 취소하시겠습니까?", 'fn_upd_exec');
	}
	
	function fn_upd_exec(){
		
		var data = {};
		var row = new Array();
 		var url = "/CE/EPCE2393064_21.do";
 		
 		data["BILL_DOC_NO"] = searchDtl.BILL_DOC_NO;
 		data["CNL_REQ_SEQ"] = searchDtl.CNL_REQ_SEQ;
 				
		ajaxPost(url, data, function(rtnData){
			if(rtnData != null && rtnData != ""){
				if(rtnData.RSLT_CD =="0000"){
					alertMsg(rtnData.RSLT_MSG, 'fn_page');
				}else{
					alertMsg(rtnData.RSLT_MSG);
				}
			}else{
				alertMsg("error");
			}
		}, false);
				
	}
   
     //목록
  	function fn_page(){
  		kora.common.goPageB("", INQ_PARAMS);
    }
     
    //현재페이지 재조회
  	function fn_reload(){
  		kora.common.goPage("/CE/EPCE23930643.do", INQ_PARAMS, "R");
    }
    
  	//출고정보 상세화면 이동
	function fn_page2(){
		var idx = dataGrid.getSelectedIndices();
		var input = gridRoot.getItemAt(idx);
		
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE23930643.do";
		kora.common.goPage('/CE/EPCE66582642.do', INQ_PARAMS);
	}
  	
	//취급수수료고지서 상세화면 이동
	function fn_page3(){
		var idx = dataGrid2.getSelectedIndices();
		var input = gridRoot2.getItemAt(idx);
		
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE23930643.do";
		kora.common.goPage('/CE/EPCE23930642.do', INQ_PARAMS);
	}
	
	//직접회수 상세화면 이동
	function fn_page4(){
		var idx = dataGrid3.getSelectedIndices();
		var input = gridRoot3.getItemAt(idx);
		
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE23930643.do";
		kora.common.goPage('/CE/EPCE66452642.do', INQ_PARAMS);
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
		 layoutStr.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="200" />');
		 layoutStr.push('	<DataGridColumn dataField="BRCH_NM"  headerText="'+parent.fn_text('mfc_brch_nm')+'" width="200" />');
		 layoutStr.push('	<DataGridColumn dataField="DLIVY_REG_DT_PAGE"  headerText="'+parent.fn_text('reg_dt2')+'" width="150" itemRenderer="HtmlItem" />');
		 layoutStr.push('	<DataGridColumn dataField="DLIVY_QTY_TOT" id="sum1" headerText="'+parent.fn_text('qty')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr.push('	<DataGridColumn dataField="DLIVY_GTN_TOT" id="sum2" headerText="'+parent.fn_text('dps2')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr.push('	<DataGridColumn dataField="MAPP_SE_NM"  headerText="'+parent.fn_text('se')+'" width="150"/>');
		 layoutStr.push('</groupedColumns>');
		 layoutStr.push('	<footers>');
		 layoutStr.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
		 layoutStr.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
		 layoutStr.push('			<DataGridFooterColumn/>');
		 layoutStr.push('			<DataGridFooterColumn/>');
		 layoutStr.push('			<DataGridFooterColumn/>');
		 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right" />');
		 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right" />');
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
	     
	     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	 }
	
	 /**
	 * 그리드 관련 변수 선언
	 */
    var jsVars2 = "rMateOnLoadCallFunction=gridReadyHandler2";
	var gridApp2, gridRoot2, dataGrid2, layoutStr2, selectorColumn2;
	var layoutStr2 = new Array();
	var rowIndex2;
	
	/**
	 * 메뉴관리 그리드 셋팅
	 */
	 function fn_set_grid2() {
		 
		 rMateGridH5.create("grid2", "gridHolder2", jsVars2, "100%", "100%");
		 layoutStr2.push('<rMateGrid>');
		 layoutStr2.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
		 layoutStr2.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg2" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
		 layoutStr2.push('<groupedColumns>');
		 layoutStr2.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" width="50"/>');
		 layoutStr2.push('	<DataGridColumn dataField="BILL_ISSU_DT_PAGE"  headerText="'+parent.fn_text('fee_bill_issu_dt')+'" width="300" itemRenderer="HtmlItem" />');
		 layoutStr2.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="300" />');
		 layoutStr2.push('	<DataGridColumn dataField="WRHS_QTY" id="sum1" headerText="'+parent.fn_text('wrhs_qty')+'" width="200" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr2.push('	<DataGridColumn dataField="ADD_BILL_REFN_GTN" id="sum2" headerText="'+parent.fn_text('pay_plan_gtn')+'" width="200" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr2.push('</groupedColumns>');
		 layoutStr2.push('	<footers>');
		 layoutStr2.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
		 layoutStr2.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
		 layoutStr2.push('			<DataGridFooterColumn/>');
		 layoutStr2.push('			<DataGridFooterColumn/>');
		 layoutStr2.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right" />');
		 layoutStr2.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right" />');
		 layoutStr2.push('		</DataGridFooter>');
		 layoutStr2.push('	</footers>');
		 layoutStr2.push('</DataGrid>');
		 layoutStr2.push('</rMateGrid>');
	}

	// 그리드 및 메뉴 리스트 세팅
	 function gridReadyHandler2(id) {
	 	 gridApp2 = document.getElementById(id);  // 그리드를 포함하는 div 객체
	     gridRoot2 = gridApp2.getRoot();   // 데이터와 그리드를 포함하는 객체
	     gridApp2.setLayout(layoutStr2.join("").toString());

	     var layoutCompleteHandler = function(event) {
	         dataGrid2 = gridRoot2.getDataGrid();  // 그리드 객체
	         selectorColumn2 = gridRoot2.getObjectById("selector");
	         dataGrid2.addEventListener("change", selectionChangeHandler); //이벤트 등록
			 gridApp2.setData(searchList2);
	     }
	     var selectionChangeHandler = function(event) {
			rowIndex2 = event.rowIndex;
		 }
	     
	     gridRoot2.addEventListener("layoutComplete", layoutCompleteHandler);
	 }

	
	 /**
	 * 그리드 관련 변수 선언
	 */
    var jsVars3 = "rMateOnLoadCallFunction=gridReadyHandler3";
	var gridApp3, gridRoot3, dataGrid3, layoutStr3, selectorColumn3;
	var layoutStr3 = new Array();
	var rowIndex3;
	
	/**
	 * 메뉴관리 그리드 셋팅
	 */
	 function fn_set_grid3() {
		 
		 rMateGridH5.create("grid3", "gridHolder3", jsVars3, "100%", "100%");
		 layoutStr3.push('<rMateGrid>');
		 layoutStr3.push('<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
		 layoutStr3.push('<DateFormatter id="datefmt" formatString="YYYY-MM-DD"/>');
		 layoutStr3.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg3" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
		 layoutStr3.push('<groupedColumns>');
		 layoutStr3.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" width="50"/>');
		 layoutStr3.push('	<DataGridColumn dataField="DRCT_RTRVL_REG_DT"  headerText="'+parent.fn_text('reg_dt2')+'" width="150" formatter="{datefmt}" />');
		 layoutStr3.push('	<DataGridColumn dataField="DRCT_RTRVL_DT_PAGE"  headerText="'+parent.fn_text('drct_rtrvl_dt')+'" width="150" itemRenderer="HtmlItem" />');
		 layoutStr3.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="200" />');
		 layoutStr3.push('	<DataGridColumn dataField="BRCH_NM"  headerText="'+parent.fn_text('mfc_brch_nm')+'" width="200" />');
		 layoutStr3.push('	<DataGridColumn dataField="DRCT_RTRVL_QTY_TOT" id="sum1" headerText="'+parent.fn_text('drct_rtrvl_qty')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr3.push('	<DataGridColumn dataField="DRCT_PAY_GTN_TOT" id="sum2" headerText="'+parent.fn_text('drct_rtrvl_gtn')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr3.push('</groupedColumns>');
		 layoutStr3.push('	<footers>');
		 layoutStr3.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
		 layoutStr3.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
		 layoutStr3.push('			<DataGridFooterColumn/>');
		 layoutStr3.push('			<DataGridFooterColumn/>');
		 layoutStr3.push('			<DataGridFooterColumn/>');
		 layoutStr3.push('			<DataGridFooterColumn/>');
		 layoutStr3.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right" />');
		 layoutStr3.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right" />');
		 layoutStr3.push('		</DataGridFooter>');
		 layoutStr3.push('	</footers>');
		 layoutStr3.push('</DataGrid>');
		 layoutStr3.push('</rMateGrid>');
	}

	// 그리드 및 메뉴 리스트 세팅
	 function gridReadyHandler3(id) {
	 	 gridApp3 = document.getElementById(id);  // 그리드를 포함하는 div 객체
	     gridRoot3 = gridApp3.getRoot();   // 데이터와 그리드를 포함하는 객체
	     gridApp3.setLayout(layoutStr3.join("").toString());

	     var layoutCompleteHandler = function(event) {
	         dataGrid3 = gridRoot3.getDataGrid();  // 그리드 객체
	         selectorColumn3 = gridRoot3.getObjectById("selector");
	         dataGrid3.addEventListener("change", selectionChangeHandler); //이벤트 등록
			 gridApp3.setData(searchList3);
	     }
	     var selectionChangeHandler = function(event) {
			rowIndex3 = event.rowIndex;
		 }
	     
	     gridRoot3.addEventListener("layoutComplete", layoutCompleteHandler);
	 }
		
</script>

<style type="text/css">
</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="searchList" value="<c:out value='${searchList}' />"/>
<input type="hidden" id="searchList2" value="<c:out value='${searchList2}' />"/>
<input type="hidden" id="searchList3" value="<c:out value='${searchList3}' />"/>
<input type="hidden" id="searchDtl" value="<c:out value='${searchDtl}' />"/>

    <div class="iframe_inner" >
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
			<div class="btn_box" id="UR"></div>
		</div>
		   
		<section class="secwrap">
			<div class="write_area">
				<div class="write_tbl">
					<table>
						<colgroup>
							<col style="width: 15%;">
							<col style="width: 25%;">
							<col style="width: 15%;">
							<col style="width: 45%;">
						</colgroup>
						<tbody>
							<tr>
								<th class="bd_l"  id="mtl_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="BIZRNM"></div>
									</div>
								</td>
								<th class="bd_l" id="bizrno2_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="BIZRNO"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th class="bd_l"  id="rpst_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="RPST_NM"></div>
									</div>
								</td>
								<th class="bd_l" id="addr_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="ADDR"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th class="bd_l"  id="tel_no2_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="RPST_TEL_NO"></div>
									</div>
								</td>
								<th class="bd_l" id="noty_amt_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="NOTY_AMT"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th class="bd_l"  id="rcpt_bank_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="BANK_NM"></div>
									</div>
								</td>
								<th class="bd_l" id="rcpt_vacct_no_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="VACCT_NO"></div>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</section>
		
		<section class="secwrap mt10" id="risuSection" style="display:none">
			<div class="write_area">
				<div class="write_tbl">
					<table>
						<colgroup>
							<col style="width: 15%;">
							<col style="width: 25%;">
							<col style="width: 15%;">
							<col style="width: 45%;">
						</colgroup>
						<tbody>
							<tr>
								<th class="bd_l"  id="add_amt_se_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="ADD_AMT_SE_NM"></div>
									</div>
								</td>
								<th class="bd_l" id="add_amt_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="ADD_AMT"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th class="bd_l"  id="risu_dt_txt"></th>
								<td >
									<div class="row">
										<div class="txtbox" id="RISU_DT"></div>
									</div>
								</td>
								<th class="bd_l"  id="risu_rsn_txt"></th>
								<td >
									<div class="row">
										<div class="txtbox" id="RISU_RSN"></div>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</section>

		<div class="boxarea mt20">
			<div class="h4group" >
				<h5 class="tit" id="dlivy_gtn_dtl_data_txt"><h5>
			</div>
			<div id="gridHolder" style="height: 290px; background: #FFF;"></div>
		</div>
		
		<div class="boxarea mt20">
			<div class="h4group" >
				<h5 class="tit" id="pay_plan_gtn_data_txt"><h5>
			</div>
			<div id="gridHolder2" style="height: 290px; background: #FFF;"></div>
		</div>
		
		<div class="boxarea mt20" id="DRCT_DIV">
			<div class="h4group" >
				<h5 class="tit" id="drct_rtrvl_gtn_data_txt"><h5>
			</div>
			<div id="gridHolder3" style="height: 290px; background: #FFF;"></div>
		</div>
		
		<div class="boxarea mt20">
			<div class="h4group" >
				<h5 class="tit" id="gtn_adj_dtl_data_txt"><h5>
			</div>
			
			<section class="secwrap">
				<div class="write_area">
					<div class="write_tbl">
						<table>
							<colgroup>
								<col style="width: 10%;">
								<col style="width: 10%;">
								<col style="width: 10%;">
								<col style="width: 10%;">
								<col style="width: 10%;">
								<col style="width: 10%;">
							</colgroup>
							<tbody>
								<tr>
									<th class="bd_l"  id="gtn_plan_bal_txt"></th>
									<td>
										<div class="row">
											<div class="txtbox" id="PLAN_BAL" style="text-align:right;width:95%" data="number"></div>
										</div>
									</td>
									<th class="bd_l" id="dlivy_gtn_txt"></th>
									<td>
										<div class="row">
											<div class="txtbox" id="GTN_TOT" style="text-align:right;width:95%" data="number"></div>
										</div>
									</td>
									<th class="bd_l" id="pay_plan_gtn_txt"></th>
									<td>
										<div class="row">
											<div class="txtbox" id="FEE_PAY_GTN" style="text-align:right;width:95%" data="number"></div>
										</div>
									</td>
								</tr>
								<tr id="ADIT_TR">
									<th class="bd_l"  id="adit_gtn_acmt_txt"></th>
									<td>
										<div class="row">
											<div class="txtbox" id="ADD_GTN_ACMT" style="text-align:right;width:95%" data="number"></div>
										</div>
									</td>
									<th class="bd_l" id="adit_gtn2_txt"></th>
									<td>
										<div class="row">
											<div class="txtbox" id="ADD_GTN" style="text-align:right;width:95%" data="number"></div>
										</div>
									</td>
									<th class="bd_l" id="adit_gtn_bal_txt"></th>
									<td>
										<div class="row">
											<div class="txtbox" id="ADD_GTN_BAL" style="text-align:right;width:95%" data="number"></div>
										</div>
									</td>
								</tr>
								<tr id="DRCT_TR1">
									<th class="bd_l"  id="drct_rtrvl_gtn_txt"></th>
									<td>
										<div class="row">
											<div class="txtbox" id="DRCT_PAY_GTN" style="text-align:right;width:95%" data="number"></div>
										</div>
									</td>
									<th class="bd_l" id="drct_rtrvl_gtn_adj_txt"></th>
									<td>
										<div class="row">
											<div class="txtbox" id="DRCT_RTRVL_ADJ_AMT" style="text-align:right;width:95%" data="number"></div>
										</div>
									</td>
									<th class="bd_l" id=""></th>
									<td>
										<div class="row">
											<div class="txtbox" id="" style="text-align:right;width:95%" data="number"></div>
										</div>
									</td>
								</tr>
								<tr id="DRCT_TR2">
									<th class="bd_l"  id="drct_rtrvl_non_acmt_txt"></th>
									<td>
										<div class="row">
											<div class="txtbox" id="DRCT_PAY_GTN_ACMT" style="text-align:right;width:95%" data="number"></div>
										</div>
									</td>
									<th class="bd_l" id="drct_rtrvl_non2_txt"></th>
									<td>
										<div class="row">
											<div class="txtbox" id="DRCT_PAY_ADJ_AMT" style="text-align:right;width:95%" data="number"></div>
										</div>
									</td>
									<th class="bd_l" id="drct_rtrvl_non_bal_txt"></th>
									<td>
										<div class="row">
											<div class="txtbox" id="DRCT_PAY_GTN_BAL" style="text-align:right;width:95%" data="number"></div>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</section>
		</div>
		
		<div class="boxarea mt20">
			<div class="h4group" >
				<h5 class="tit" id="noty_dtl_data_txt"><h5>
			</div>
			
			<section class="secwrap">
				<div class="write_area">
					<div class="write_tbl">
						<table>
							<colgroup>
								<col style="width: 10%;">
								<col style="width: 10%;">
								<col style="width: 15%;">
								<col style="width: 10%;">
								<col style="width: 15%;">
								<col style="width: 10%;">
								<col style="width: 10%;">
								<col style="width: 10%;">
							</colgroup>
							<tbody>
								<tr>
									<th class="bd_l"  id="dlivy_gtn_a_txt"></th>
									<td>
										<div class="row">
											<div class="txtbox" id="GTN_TOT" style="text-align:right;width:95%" data="number"></div>
										</div>
									</td>
									<th class="bd_l" id="adit_gtn2_a_txt"></th>
									<td>
										<div class="row">
											<div class="txtbox" id="ADD_GTN" style="text-align:right;width:95%" data="number"></div>
										</div>
									</td>
									<th class="bd_l" id="rtrvl_gtn_adj_a_txt"></th>
									<td>
										<div class="row">
											<div class="txtbox" id="RTRVL_ADJ_AMT" style="text-align:right;width:95%" data="number"></div>
										</div>
									</td>
									<th class="bd_l" id="noty_amt_a_txt"></th>
									<td>
										<div class="row">
											<div class="txtbox" id="NOTY_AMT" style="text-align:right;width:95%" data="number"></div>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</section>

		</div>

		<section class="btnwrap mt20"  >
			<div class="btn"	 id="BL"></div>
			<div class="btn" style="float:right" id="BR"></div>
		</section>
		
	</div>

	<form name="prtForm" id="prtForm">
		<input type="hidden" name="CRF_NAME" value="EPCE23930643.crf" />
		<input type="hidden" name="BILL_DOC_NO" value="" />
        <input type="hidden" name="MFC_BIZRNO" value="" />
		<input type="hidden" name="DRCT_YN" id="DRCT_YN" value="" />
		<input type="hidden" name="ADIT_YN" id="ADIT_YN" value="" />
		<input type="hidden" name="S_USER_NM" id="S_USER_NM" value="${ssUserNm}"/>
		<input type="hidden" name="S_BIZR_NM" id="S_BIZR_NM" value="${ssBizrNm}"/>
	</form>
	
	<form name="prtForm3" id="prtForm3">
		<input type="hidden" name="CRF_NAME" value="EPCE23930643_2.crf" />
		<input type="hidden" name="BILL_DOC_NO" value="" />
        <input type="hidden" name="MFC_BIZRNO" value="" />
		<input type="hidden" name="DRCT_YN" id="DRCT_YN" value="" />
		<input type="hidden" name="ADIT_YN" id="ADIT_YN" value="" />
		<input type="hidden" name="S_USER_NM" id="S_USER_NM" value="${ssUserNm}"/>
		<input type="hidden" name="S_BIZR_NM" id="S_BIZR_NM" value="${ssBizrNm}"/>
	</form>

</body>
</html>