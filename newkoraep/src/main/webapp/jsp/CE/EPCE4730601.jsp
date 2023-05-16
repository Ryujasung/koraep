<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>도매업자정산지급내역</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />


<script type="text/javaScript" language="javascript" defer="defer" >

	var INQ_PARAMS; //파라미터 데이터
	
	$(document).ready(function(){
		
		INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());       
		var stdMgntList = jsonObject($("#stdMgntList").val());     
	    var excaProcStatList = jsonObject($("#excaProcStatList").val());	
	    var txExecNmList = jsonObject($("#txExecNmList").val());	//이체실행상태
	    
		$('.row > .col > .tit').each(function(){
			$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
		});
		
		//버튼 셋팅
	    fn_btnSetting();
	    
		//그리드 셋팅
	    fnSetGrid1();  
	
	    kora.common.setEtcCmBx2(stdMgntList, "","", $("#EXCA_STD_CD_SEL"), "EXCA_STD_CD", "EXCA_STD_NM", "N" ,'S');
	    for(var k=0; k<stdMgntList.length; k++){ 
	    	if(stdMgntList[k].EXCA_STAT_CD == 'S'){
	    		$('#EXCA_STD_CD_SEL').val(stdMgntList[k].EXCA_STD_CD);
	    		break;
	    	}
	    }
	    
	    kora.common.setEtcCmBx2(excaProcStatList, "","", $("#EXCA_PROC_STAT_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N" ,'T');
	    
	    var whslSeCdList = jsonObject($('#whslSeCdList').val());
		var whsdlList = jsonObject($('#whsdlList').val());
		kora.common.setEtcCmBx2(whslSeCdList, "","", $("#WHSL_SE_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');
	 	kora.common.setEtcCmBx2(whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');
	 	kora.common.setEtcCmBx2(txExecNmList, "", "", $("#TX_EXEC_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
	    
	 	//도매업자  검색
  		$("#WHSDL_BIZRNM").select2();
	    
		/************************************
		 * 조회버튼 클릭 이벤트
		 ***********************************/
		$("#btn_sel").click(function(){
			fn_sel();
		});
		
		//연계전송
		$("#btn_upd").click(function(){
			fn_upd();
		});
		
		//오류건 재전송
		$("#btn_upd2").click(function(){
			fn_upd2();
		});
		
		//휴폐업조회
		$("#btn_upd3").click(function(){
			fn_check();
		});
		
		//예금주조회
		$("#btn_reg").click(function(){
			fn_reg();
		});
		
		//예금주조회결과
		$("#btn_pop").click(function(){
			fn_pop();
		});
		
		 /************************************
         * 인쇄 클릭 이벤트
         ***********************************/
         $("#btn_pnt").click(function(){
             fn_pnt();
         });
		 
		/************************************
		 * 도매업자 구분 변경 이벤트
		 ***********************************/
		$("#WHSL_SE_CD").change(function(){
			fn_whsl_se_cd();
		});
		
		//파라미터 조회조건으로 셋팅
		if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
			kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
		}
		
	});
	
	function fn_check(){
		
		var data = {};
		var row = new Array();
		
		var chkLst = selectorColumn.getSelectedItems();
		
		if(chkLst.length < 1){
			alertMsg("선택된 행이 없습니다.");
			return;
		}
		
		for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
			var item = {};
			item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			row.push(item);
		}
		
		data["list"] = JSON.stringify(row);

		var url = "/CE/EPCE0160101422.do";
		document.body.style.cursor = "wait";
		ajaxPost(url, data, function(rtnData){
			if ("" != rtnData && null != rtnData) {
				alertMsg(rtnData.RSLT_MSG, 'fn_sel');
			} else {
				alertMsg("error");
			}
			document.body.style.cursor = "default";
		});
	} 
	
	function fn_whsl_se_cd(){
    	var url = "/SELECT_WHSDL_BIZR_LIST.do" 
		var input ={};
		   if($("#WHSL_SE_CD").val()  !=""){
		 		input["BIZR_TP_CD"] = $("#WHSL_SE_CD").val();
		   }
		   /*
		   //생산자 선택시 선택된 생산자랑 거래중인 도매업자 조회
		   if( $("#MFC_BIZRNM").val() !="" ){
				input["MFC_BIZRID"]	= arr[0];
				input["MFC_BIZRNO"]	= arr[1];
				//생산자 + 직매장 선택시 거래중이 도매업자 조회
				if($("#MFC_BRCH_NM").val() !="" ){
				 	      input["MFC_BRCH_ID"]	= arr2[0];
		    			  input["MFC_BRCH_NO"]	= arr2[1];
				
		   }
		   */
    		$("#WHSDL_BIZRNM").select2("val","");
       	    ajaxPost(url, input, function(rtnData) {
				if ("" != rtnData && null != rtnData) {  
					kora.common.setEtcCmBx2(rtnData, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');		 //업체명
				}else{
					alertMsg("error");
				}
    		});
     }
	
	function fn_upd2(){
		
		var chkLst = selectorColumn.getSelectedItems();
		
		if(chkLst.length < 1){
			alertMsg("선택된 행이 없습니다.");
			return;
		}
		
		for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
			var item = {};
			item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			
			if(item.EXCA_PROC_STAT_CD != 'R' ){
				alertMsg("지급오류 상태인 항목만 오류건 재전송이 가능합니다.");
				return;
			}
		}
		
		confirm('선택된 정보에 대해 오류건 재전송을 실행하시겠습니까?', "fn_upd_exec2");
	}
	
	function fn_upd_exec2(){
		
		var data = {};
		var row = new Array();
		
		for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
			var item = {};
			item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			row.push(item);
		}
		
		data["list"] = JSON.stringify(row);

		var url = "/CE/EPCE4730601_212.do";
		ajaxPost(url, data, function(rtnData){
			if ("" != rtnData && null != rtnData) {
				alertMsg(rtnData.RSLT_MSG, 'fn_sel');
			} else {
				alertMsg("error");
			}
		});
	}
		   
	function fn_upd(){
		
		var chkLst = selectorColumn.getSelectedItems();
		
		if(chkLst.length < 1){
			alertMsg("선택된 행이 없습니다.");
			return;
		}
		
		for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
			var item = {};
			item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			
			if(item.EXCA_PROC_STAT_CD != 'I' ){
				alertMsg("발급 상태인 항목만 연계 정보 생성이 가능합니다.");
				return;
			}
			
			/* if(item.EXCA_PROC_STAT_CD != 'I'|| item.TX_EXEC_CD != 'TY'){
				alertMsg('발급 및 이체실행인 항목만 연계 정보 생성이 가능합니다.');
				return;
			} */
		}
		
		confirm('선택된 정보에 대해 지급 연계 정보를 생성하시겠습니까?', "fn_upd_exec");
	}
	
	function fn_upd_exec(){
		
		var data = {};
		var row = new Array();
		
		for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
			var item = {};
			item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			row.push(item);
		}
		
        data["list"] = JSON.stringify(row);
        
        INQ_PARAMS["PARAMS"] = data;
        INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
        INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE4730601.do";
        kora.common.goPage('/CE/EPCE4730631.do', INQ_PARAMS);
	}
	
	//상세화면 이동
	function fn_page(){

		var idx = dataGrid.getSelectedIndices();
		var input = gridRoot.getItemAt(idx);
		
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE4730601.do"; 
		kora.common.goPage('/CE/EPCE4707264.do', INQ_PARAMS);
	}
		
	//조회
	function fn_sel(){

		var EXCA_STD_CD = $("#EXCA_STD_CD_SEL option:selected").val();
		
		if(EXCA_STD_CD == ""){
			alertMsg("정산기간을 선택하세요.");
			return;
		}
		
		var input ={}
		var url ="/CE/EPCE4730601_19.do";
		
		input["EXCA_STD_CD_SEL"] = $("#EXCA_STD_CD_SEL").val();
		input["EXCA_PROC_STAT_CD_SEL"] = $("#EXCA_PROC_STAT_CD_SEL").val();
		input['WHSL_SE_CD'] = $("#WHSL_SE_CD option:selected").val();
		input['WHSDL_BIZRNM'] = $("#WHSDL_BIZRNM option:selected").val();
		input['TX_EXEC_CD_SEL'] = $("#TX_EXEC_CD_SEL option:selected").val();
		
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["SEL_PARAMS"] = input;
		
		kora.common.showLoadingBar(dataGrid, gridRoot);
		ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {   
				gridApp.setData(rtnData.searchList);
			}else{
				alertMsg("error");
			}
			kora.common.hideLoadingBar(dataGrid, gridRoot);
		});
		
	}	
	
	//예금주조회
	function fn_reg(){
		
		var chkLst = selectorColumn.getSelectedItems();
		
		if(chkLst.length < 1){
			alertMsg("선택된 행이 없습니다.");
			return;
		}
		
		for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
			var item = {};
			item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			
			if(item.EXCA_PROC_STAT_CD != 'I'){
				alertMsg('발급 상태인 항목만 예금주 조회가 가능합니다.');
				return;
			}
		}
		
		confirm('선택된 내역에 대해 예금주 조회를 하시겠습니까?', "fn_reg_exec");
	}
	
	function fn_reg_exec(){
		
		var data = {};
		var row = new Array();
		
		for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
			var item = {};
			var param = {};
			item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			
			param["ACCT_NO"] = item["ACCT_NO"];
			param["ACCT_DPSTR_NM"] = item["ACCT_DPSTR_NM"];
			param["BANK_CD"] = item["BANK_CD"];
			param["STAC_DOC_NO"] = item["STAC_DOC_NO"];
			param["EXCA_ISSU_SE_CD"] = item["EXCA_ISSU_SE_CD"];
			
			row.push(param);
		}
		
		data["list"] = JSON.stringify(row);
		data['PARAM_BTN_CD'] = kora.common.btn_id;	//버튼 아이디
		data['PARAM_MENU_CD'] = gUrl;				//메뉴CD

		var url = "/CMS/CMSCS002_02.do";
		
		var cnt = Math.round(row.length / 200);
		var min = cnt ? cnt : 1;
		alertMsg("약 " + min + "분 후에 예금주조회결과를 확인해주세요.");
		
		$.ajax({
			url : url,
			type : 'POST',
			data : data,
			dataType : 'json',
			cache : false,
			async : true,
			traditional : true,
			beforeSend: function(request) {
			    request.setRequestHeader("AJAX", true);
			    request.setRequestHeader(gheader, $("meta[name='_csrf']").attr("content"));
			},
			success : function(data) {},
			error : function(c) {
				console.log(c);
				if(c.status == 401 || c.status == 403){
					window.parent.location.href = "/login.do";
				}else if(c.responseText != null && c.responseText != ""){
					alert("처리중 오류가 발생하였습니다. \r\n다시 시도 하십시오.");	
				}
			}
		});
		
	}
	
	//예금주조회결과
	function fn_pop(){
		confirm('예금주조회결과 페이지로 이동하시겠습니까?', "fn_pop_exec");
	}
	
	function fn_pop_exec(){
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE4730601.do";
		kora.common.goPage('/CMS/CMSCS001.do', INQ_PARAMS);
	}
	
	 //인쇄
    function fn_pnt(){		
		var EXCA_STD_CD = $("#EXCA_STD_CD_SEL").val();
		
		if(EXCA_STD_CD == ""){
			alertMsg("정산기간을 선택하세요.");
			return;
		}
        
		var WHSDL_BIZRNM = $("#WHSDL_BIZRNM").val().split(";");
		var BIZRID = "";
		var BIZRNO = "";
		
		if(WHSDL_BIZRNM.length >= 2) {
			BIZRID = WHSDL_BIZRNM[0];
			BIZRNO = WHSDL_BIZRNM[1];
		}
		
        $('form[name="prtForm"] input[name="EXCA_STD_CD"]').val(EXCA_STD_CD);
        $('form[name="prtForm"] input[name="BIZR_TP_CD" ]').val($("#WHSL_SE_CD").val());
        $('form[name="prtForm"] input[name="BIZRID"]').val(BIZRID);
        $('form[name="prtForm"] input[name="BIZRNO"]').val(BIZRNO);
        $('form[name="prtForm"] input[name="EXCA_PROC_STAT_CD"]').val($("#EXCA_PROC_STAT_CD_SEL").val());
        $('form[name="prtForm"] input[name="TX_EXEC_CD"]').val($("#TX_EXEC_CD_SEL").val());
        
        kora.common.gfn_viewReport('prtForm', '');        
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
			layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" horizontalScrollPolicy="auto" draggableColumns="true" headerHeight="35" textAlign="center" >');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridSelectorColumn id="selector" width="40" textAlign="center" allowMultipleSelection="true" verticalAlign="middle" />');
			layoutStr.push('			<DataGridColumn dataField="index" headerText="'+ parent.fn_text('sn')+ '" itemRenderer="IndexNoItem" width="50"/>');
			layoutStr.push('			<DataGridColumn dataField="EXCA_REG_DT_PAGE"  headerText="'+ parent.fn_text('exca_issu_dt') +'" width="100" itemRenderer="HtmlItem"/>');
			layoutStr.push('			<DataGridColumn dataField="BIZRNM"  headerText="'+ parent.fn_text('whsdl')+ '"  width="180"/>'); 
			layoutStr.push('			<DataGridColumn dataField="EXCA_ISSU_SE_NM"  headerText="'+ parent.fn_text('exca_issu_se')+ '"  width="100"/>');
			layoutStr.push('			<DataGridColumn dataField="BANK_NM"  headerText="'+ parent.fn_text('acp_bank_nm')+ '"  width="110"/>');
			layoutStr.push('			<DataGridColumn dataField="ACCT_NO"  headerText="'+ parent.fn_text('acp_acct_no')+ '"  width="130"/>');
			layoutStr.push('			<DataGridColumn dataField="REAL_PAY_DT" headerText="'+parent.fn_text('real_pay_dt')+'" width="140" />');
			layoutStr.push('			<DataGridColumn dataField="GTN" id="num1"  headerText="'+ parent.fn_text('gtn')+ '"  width="100" textAlign="right" formatter="{numfmt}"/>');
			layoutStr.push('			<DataGridColumn dataField="FEE" id="num2"  headerText="'+ parent.fn_text('fee')+ '"  width="100" textAlign="right" formatter="{numfmt}"/>');
			layoutStr.push('			<DataGridColumn dataField="FEE_STAX" id="num3"  headerText="'+ parent.fn_text('stax')+ '" textAlign="right" width="100" formatter="{numfmt}"/>');
			layoutStr.push('			<DataGridColumn dataField="EXCA_AMT" id="num4"  headerText="'+ parent.fn_text('pay_amt')+ '" textAlign="right" width="100" formatter="{numfmt}"/>');
			layoutStr.push('			<DataGridColumn dataField="EXCA_PROC_STAT_NM"  headerText="'+ parent.fn_text('stat')+ '"  width="100"/>');
			layoutStr.push('			<DataGridColumn dataField="TX_EXEC_NM"  headerText="'+parent.fn_text('tx_exec_nm')+'" width="120"/>');
			layoutStr.push('			<DataGridColumn dataField="RUN_STAT_NM"  headerText="'+ parent.fn_text('run_stat')+ '"  width="100"/>');
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('			</DataGridFooter>');
			layoutStr.push('		</footers>');
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

		var layoutCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			selectorColumn = gridRoot.getObjectById("selector");
			dataGrid.addEventListener("change", selectionChangeHandler);

			 //파라미터 call back function 실행
			 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
			 	eval(INQ_PARAMS.FN_CALLBACK+"()");
			 }else{
				 gridApp.setData();
			 }
		}
		var dataCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
		}
		var selectionChangeHandler = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		
	}

   /****************************************** 그리드 셋팅 끝***************************************** */
	</script>
	
	<style type="text/css">

		.srcharea .row .col .tit{
		width: 82px;
		}

	</style>
	
	</head>
	<body>
  	<div class="iframe_inner"  id="testee" >
  	
 	 	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
		<input type="hidden" id="stdMgntList" value="<c:out value='${stdMgntList}' />" />
		<input type="hidden" id="excaProcStatList" value="<c:out value='${excaProcStatList}' />" />
		<input type="hidden" id="whslSeCdList" value="<c:out value='${whslSeCdList}' />"/>
		<input type="hidden" id="whsdlList" value="<c:out value='${whsdlList}' />"/>
		<input type="hidden" id="txExecNmList" value="<c:out value='${txExecNmList}' />"/>
		
			<div class="h3group">
				<h3 class="tit" id="title"></h3>
				<div class="btn" style="float:right" id="UR">
			</div>
		</div>
		<section class="secwrap">
				<div class="srcharea" id="sel_params">
					<div class="row">
						<div class="col" >
							<div class="tit" id="exca_term_txt"></div>
							<div class="box">
								<select style="width: 179px;" id="EXCA_STD_CD_SEL"></select>
							</div>
						</div>
						<div class="col" >
							<div class="tit" id="whsdl_txt" ></div>
							<div class="box">
								<select id="WHSL_SE_CD" name="WHSL_SE_CD" style="width: 109px" ></select>
					            <select id="WHSDL_BIZRNM" name="WHSDL_BIZRNM" style="width: 210px" ></select>
							</div>
						</div>
					</div>	
					<div class="row">
						<div class="col">
							<div class="tit" id="stat_txt"></div> 
							<select style="width: 179px;" id="EXCA_PROC_STAT_CD_SEL" ></select>
						</div>
						<div class="col">
							<div class="tit" id="tx_exec_nm_txt"></div>
							<div class="box">
								<select id="TX_EXEC_CD_SEL" style="width: 179px;"></select>
							</div>
						</div>
						
						<div class="btn" id="CR">
						</div>
						
					</div>
				</div>		<!-- end of srcharea --> 
		</section>
		<section class="btnwrap mt10"  >
				<div class="btn" id="CL"></div>
		</section>
		<div class="boxarea mt10">
			<!-- 그리드 셋팅 -->
			<div id="gridHolder" style="height: 560px; background: #FFF;"></div>
		</div>

		<section class="btnwrap mt10" >
			<div class="btn" style="float:left" id="BL"></div>
			<div class="btn" style="float:right" id="BR"></div>
		</section>

	</div> <!-- end of  iframe_inner -->

	<form name="prtForm" id="prtForm">
        <!-- 필수 -->
        <input type="hidden" id="CRF_NAME" name="CRF_NAME" value="도매업자이체결과조회_210503.crf" />
        <!-- 파라메타 -->
        <input type="hidden" id="EXCA_STD_CD" name="EXCA_STD_CD" value="" />
        <input type="hidden" id="BIZR_TP_CD" name="BIZR_TP_CD" value="" />
        <input type="hidden" id="BIZRID" name="BIZRID" value="" />
        <input type="hidden" id="BIZRNO" name="BIZRNO" value="" />
        <input type="hidden" id="EXCA_PROC_STAT_CD" name="EXCA_PROC_STAT_CD" value="" />
        <input type="hidden" id="TX_EXEC_CD" name="TX_EXEC_CD" value="" />
        <input type="hidden" name="USER_NM" id="USER_NM" value="${ssUserNm}"/>
        <input type="hidden" name="BSNM_NM" id="BSNM_NM" value="${ssBizrNm}"/>
    </form>
</body>
</html>

		