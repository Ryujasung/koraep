<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>출고정정</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>

<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />
<script type="text/javaScript" language="javascript" defer="defer" >

		var sumData; /* 총합계 추가 */

	 	/* 페이징 사용 등록 */
		gridRowsPerPage = 15;	// 1페이지에서 보여줄 행 수
		gridCurrentPage = 1;	// 현재 페이지
		gridTotalRowCount = 0; //전체 행 수
		
		var INQ_PARAMS; //파라미터 데이터
		var stdMgntList;
		
		$(document).ready(function(){
			
			INQ_PARAMS 		=  jsonObject($("#INQ_PARAMS").val());       
			stdMgntList 		=  jsonObject($("#stdMgntList").val());  
			
			var statList = jsonObject($("#statList").val());	
		    var mfcSeCdList = jsonObject($("#mfcSeCdList").val());	
		    var whsdlSeCdList = jsonObject($("#whsdlSeCdList").val());	
		    var brchList = jsonObject($("#brchList").val());	
			var ctnrList = jsonObject($("#ctnrList").val());	
	    	var whsdlList = jsonObject($("#whsdlList").val());	
	    	
			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			
			//버튼 셋팅
		    fn_btnSetting();
		    
			//그리드 셋팅
		    fnSetGrid1();  
		
		    kora.common.setEtcCmBx2(stdMgntList, "","", $("#EXCA_STD_CD"), "EXCA_STD_CD", "EXCA_STD_NM", "N" ,'S');
		    for(var k=0; k<stdMgntList.length; k++){ 
		    	if(stdMgntList[k].EXCA_STAT_CD == 'S'){
		    		$('#EXCA_STD_CD').val(stdMgntList[k].EXCA_STD_CD);
		    		break;
		    	}
		    }
		    
		    kora.common.setEtcCmBx2(mfcSeCdList, "", "", $("#MFC_BIZR_SEL"), "BIZRID_NO", "BIZRNM", "N");
		    fn_bizrTpCd();
		    //kora.common.setEtcCmBx2(brchList, "","", $("#MFC_BRCH_SEL"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');
		    //kora.common.setEtcCmBx2(ctnrList, "","", $("#CTNR_CD_SEL"), "CTNR_CD", "CTNR_NM", "N" ,'T');
		    //kora.common.setEtcCmBx2(whsdlList, "","", $("#CUST_BIZR_SEL"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');
		    
		    kora.common.setEtcCmBx2(statList, "","", $("#DLIVY_CRCT_STAT_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');
		    kora.common.setEtcCmBx2(whsdlSeCdList, "","", $("#WHSDL_SE_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N" ,'T');

		    
		    $("#CUST_BIZR_SEL").select2();
		    
			/************************************
			 * 조회버튼 클릭 이벤트
			 ***********************************/
			$("#btn_sel").click(function(){
				//조회버튼 클릭시 페이징 초기화
				gridCurrentPage = 1;
				fn_sel();
			});
			
			//등록
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			//수정
			$("#btn_upd").click(function(){
				fn_upd();
			});
			
			//삭제
			$("#btn_del").click(function(){
				fn_del();
			});
						
			/************************************
			 * 정산기간 변경 이벤트
			 ***********************************/
			$("#EXCA_STD_CD").change(function(){
				gridApp.setData([]);
			});
			
			/************************************
			 * 생산자명 변경 이벤트
			 ***********************************/
			 $("#MFC_BIZR_SEL").change(function(){
				fn_bizrTpCd();
			 });
			
			 /************************************
			 * 직매장 변경 이벤트
			 ***********************************/
			 $("#MFC_BRCH_SEL").change(function(){
				fn_brch();
			 });
			
			 /************************************
			 * 도매업자 구분 변경 이벤트
			 ***********************************/
			$("#WHSDL_SE_CD_SEL").change(function(){
				fn_whsl_se_cd();
			});
			
			 /************************************
			 * 엑셀다운로드 버튼 클릭 이벤트
			 ***********************************/
			 $("#btn_excel").click(function() {
				 fn_excel();
			 });
			
			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
				/* 화면이동 페이징 셋팅 */
				gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
				
				$("#CUST_BIZR_SEL").select2('val', INQ_PARAMS.SEL_PARAMS.CUST_BIZR_SEL);
			}
			
		});
		
		function  fn_data_chk(){
			var toDay = kora.common.gfn_toDay(); 	// 현재 시간
			arr4	 = [];										//정산기간
	 		arr4	 = $("#EXCA_STD_CD").val().split(";");
			var dt_check  =false;
			for(var i=0; i<stdMgntList.length;i++){
				 if(stdMgntList[i].EXCA_STD_CD == arr4[0]){							//정산기간코드에서
					 if(stdMgntList[i].EXCA_STAT_CD =="S"){							//처리상태가 진행인놈중
						 if(stdMgntList[i].CRCT_PSBL_ST_DT<= toDay ){     			//시작날짜가 오늘날짜보다 작거나 같고
							 if(stdMgntList[i].CRCT_PSBL_END_DT >= toDay ){ 		//끝날짜가 오늘날짜보다 크거나 같을경우에만
								 dt_check = true;						 							//가능
							 }
						 }
					 }
				 
					 if(stdMgntList[i].CET_FYER_EXCA_YN == 'Y'){
		    			alertMsg("등록 및 수정이 불가능한 정산기간 입니다.");
		    			return false;
		    		 }
				 
				  	break;
				 }
			}	
			
			if(!dt_check){
				alertMsg("정정가능기간이 아닙니다.");
				return false;
			}
		}
		
		//삭제
		function fn_del(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}
			
			if(fn_data_chk() == false){ //기간체크
				return; 
			}
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				
				if(item.CET_FYER_EXCA_YN == 'Y'){
	    			alertMsg("삭제 불가능한 정산기간 데이터 입니다.");
	    			return;
	    		}
				
				if(item.DLIVY_CRCT_STAT_CD != 'R' && item.DLIVY_CRCT_STAT_CD != 'T'){
					alertMsg("정정등록, 정정반려 건만 삭제 가능합니다.");
					return;
				}
			}

			confirm('삭제하시겠습니까?', "fn_del_exec");
		}
		
		function fn_del_exec(){
			
			var data = {};
			var row = new Array();
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(item);
			}
			
			data["list"] = JSON.stringify(row);

			var url = "/MF/EPMF4759401_04.do";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_sel');
				} else {
					alertMsg("error");
				}
			});
		}
		
		/**
		 * 변경화면 이동
		 */
		function fn_upd(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}
			
			if(chkLst.length > 1){
				alertMsg("한건만 선택이 가능합니다.");
				return;
			}
			
			if(fn_data_chk() == false){ //기간체크
				return; 
			}
			
			var item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[0]);
			
			if(item.CET_FYER_EXCA_YN == 'Y'){
    			alertMsg("수정 불가능한 정산기간 데이터 입니다.");
    			return;
    		}
			
			if(item.DLIVY_CRCT_STAT_CD != 'R' && item.DLIVY_CRCT_STAT_CD != 'T'){
				alertMsg("정정등록, 정정반려 건만 수정 가능합니다.");
				return;
			}
			
			INQ_PARAMS["PARAMS"] = item;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/MF/EPMF4759401.do";
			kora.common.goPage('/MF/EPMF4759442.do', INQ_PARAMS);
		}
		
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
			input['fileName'] = fileName;
			input['columns'] = JSON.stringify(col);
			
			var url = "/MF/EPMF4759401_05.do";
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
		
		
	//생산자명 변경시
	function fn_bizrTpCd(){
		
		var url = "/MF/EPMF4759401_192.do" 
		var input ={};
		
	    input["BIZRID_NO"] = $("#MFC_BIZR_SEL").val();
	    //input["BRCH_ID_NO"] = $("#MFC_BRCH_SEL").val();

	    $("#CUST_BIZR_SEL").select2("val","");
      	    ajaxPost(url, input, function(rtnData) {
  				if ("" != rtnData && null != rtnData) {
  					kora.common.setEtcCmBx2(rtnData.brchList, "","", $("#MFC_BRCH_SEL"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');
  					kora.common.setEtcCmBx2(rtnData.ctnrList, "","", $("#CTNR_CD_SEL"), "CTNR_CD", "CTNR_NM", "N" ,'T');
  					kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#CUST_BIZR_SEL"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T'); //업체명
  				} else {
  					alertMsg("error");
  				}
   		}, false);

	}
	
	//직매장 변경시
	function fn_brch(){
		
		var url = "/MF/EPMF4759401_194.do" 
		var input ={};
		
	    input["BIZRID_NO"] = $("#MFC_BIZR_SEL").val();
	    input["BRCH_ID_NO"] = $("#MFC_BRCH_SEL").val();

	    if($("#WHSDL_SE_CD_SEL").val()  !=""){
	   		input["BIZR_TP_CD"] =$("#WHSDL_SE_CD_SEL").val();
	    }
	    
	    $("#CUST_BIZR_SEL").select2("val","");
    	   ajaxPost(url, input, function(rtnData) {
				if ("" != rtnData && null != rtnData) {  
					kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#CUST_BIZR_SEL"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T'); //업체명
				}else{
					alertMsg("error");
				}
 		});

	}

	//도매업자구분 변경시 도매업자 조회 ,생산자가 선택됐을경우 거래중인 도매업자만 조회
     function fn_whsl_se_cd(){
    	var url = "/MF/EPMF4759401_193.do" 
		var input ={};
		   if($("#WHSDL_SE_CD_SEL").val()  !=""){
		   		input["BIZR_TP_CD"] =$("#WHSDL_SE_CD_SEL").val();
		   }
		   //생산자 선택시 선택된 생산자랑 거래중인 도매업자 조회
		   if( $("#MFC_BIZR_SEL").val() !="" ){
   				input["MFC_BIZRID"]	= $("#MFC_BIZR_SEL").val().split(';')[0];
   				input["MFC_BIZRNO"]	= $("#MFC_BIZR_SEL").val().split(';')[1];
   				//생산자 + 직매장 선택시 거래중이 도매업자 조회
   				if($("#MFC_BRCH_SEL").val() !="" ){
				 	input["MFC_BRCH_ID"]		= $("#MFC_BRCH_SEL").val().split(';')[0];
		    		input["MFC_BRCH_NO"]	= $("#MFC_BRCH_SEL").val().split(';')[1];
   				}
		   }
    	   $("#CUST_BIZR_SEL").select2("val","");
       	   ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {  
   					kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#CUST_BIZR_SEL"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T'); //업체명
   				}else{
   					alertMsg("error");
   				}
    		});
     }	
		
	//조회
	function fn_sel(){

		var input ={}
		var url ="/MF/EPMF4759401_19.do";
		
		input["EXCA_STD_CD"] = $("#EXCA_STD_CD").val();
		input["DLIVY_CRCT_STAT_CD"] = $("#DLIVY_CRCT_STAT_CD").val();
		input["MFC_BIZR_SEL"] = $("#MFC_BIZR_SEL").val();
		input["MFC_BRCH_SEL"] = $("#MFC_BRCH_SEL").val();
		input["CTNR_CD_SEL"] = $("#CTNR_CD_SEL").val();
		input["WHSDL_SE_CD_SEL"] = $("#WHSDL_SE_CD_SEL").val();
		input["CUST_BIZR_SEL"] = $("#CUST_BIZR_SEL").val();
		
		/* 페이징  */
		input["ROWS_PER_PAGE"] = gridRowsPerPage;
		input["CURRENT_PAGE"] 	= gridCurrentPage;
		
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["SEL_PARAMS"] = input;

		kora.common.showLoadingBar(dataGrid, gridRoot);

		ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {   
				gridApp.setData(rtnData.searchList);
				
				/* 페이징 표시 */
				gridTotalRowCount = parseInt(rtnData.totalList[0].CNT); //총 카운트 	/* 총합계 추가 */
				drawGridPagingNavigation(gridCurrentPage);
				
				sumData = rtnData.totalList[0]; /* 총합계 추가 */
				
			}else{
				alertMsg("error");
			}

			kora.common.hideLoadingBar(dataGrid, gridRoot);

		});

	}	
	
	/* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel(); //조회 펑션
	}
	
	//등록 화면으로 이동
	function fn_reg(){
		
		if($("#EXCA_STD_CD").val() == ''){
			alertMsg('정산기간 선택은 필수입니다. ');
			return;
		}
		
		for(var k=0; k<stdMgntList.length; k++){ 
	    	if(stdMgntList[k].EXCA_STD_CD ==  $("#EXCA_STD_CD option:selected").val()){
	    		if(stdMgntList[k].EXCA_YN == 'N'){
	    			alertMsg("진행중인 정산기간이 아닙니다.");
	    			return;
	    		}
	    		if(stdMgntList[k].CET_FYER_EXCA_YN == 'Y'){
	    			alertMsg("등록 불가능한 정산기간 입니다.");
	    			return;
	    		}
	    	}
	    }
				
		var input = {};
		input['EXCA_STD_CD'] = $("#EXCA_STD_CD").val().split(';')[0];
		
		INQ_PARAMS["PARAMS" ] = input;
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/MF/EPMF4759401.do";
		kora.common.goPage('/MF/EPMF4759431.do', INQ_PARAMS);
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
			layoutStr.push('	<NumberFormatter id="numfmt1" precision="2" useThousandsSeparator="true"/>');
			layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" horizontalScrollPolicy="on"  draggableColumns="true" headerHeight="35">');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridSelectorColumn id="selector" width="40" textAlign="center" allowMultipleSelection="true" vertical-align="middle"  draggable="false" />');
			layoutStr.push('			<DataGridColumn dataField="PNO" 				 				headerText="'+ parent.fn_text('sn')+ '" textAlign="center" width="50"   draggable="false"/>');
			layoutStr.push('			<DataGridColumn dataField="DLIVY_DT"  headerText="'+ parent.fn_text('dlivy_dt') +'" textAlign="center" width="100" formatter="{datefmt2}"/>');
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM"  headerText="'+ parent.fn_text('mfc_bizrnm')+ '" textAlign="center" width="180"/>'); 
			layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_NM"  headerText="'+ parent.fn_text('mfc_brch_nm')+ '" textAlign="center" width="180"/>');
			layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNM"  headerText="'+ parent.fn_text('cust')+ '" textAlign="center" width="180"/>');
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM"  headerText="'+ parent.fn_text('ctnr_nm')+ '" textAlign="center" width="180"/>');
			layoutStr.push('			<DataGridColumn dataField="PRPS_NM"  headerText="'+ parent.fn_text('prps_cd')+ '" textAlign="center" width="100"/>');
			layoutStr.push('			<DataGridColumn dataField="CPCT_NM"  headerText="'+ parent.fn_text('cpct_cd')+ '" textAlign="center" width="100"/>');
			layoutStr.push('			<DataGridColumn dataField="DLIVY_QTY" id="num1"  headerText="'+ parent.fn_text('dlivy_qty2')+ '" textAlign="right" width="100" formatter="{numfmt}"/>');
			layoutStr.push('			<DataGridColumn dataField="DLIVY_GTN" id="num2"  headerText="'+ parent.fn_text('dps2')+ '" textAlign="right" width="100" formatter="{numfmt}"/>');
			layoutStr.push('			<DataGridColumn dataField="DLIVY_CRCT_STAT_NM"  headerText="'+ parent.fn_text('stat')+ '" textAlign="center" width="100" id="tmp1" />');
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn label="소계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp1}" />');
			layoutStr.push('			</DataGridFooter>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn label="총합계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum1" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum2" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp1}" />');
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
					/* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
			 	 window[INQ_PARAMS.FN_CALLBACK]();
			 	//취약점점검 5990 기원우
			 }else{
				gridApp.setData([]);
				 
				/* 페이징 표시 */
				drawGridPagingNavigation(gridCurrentPage);
				
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

	/* 총합계 추가 */
	function totalsum1(column, data) {
		if(sumData) 
			return sumData.DLIVY_QTY; 
		else 
			return 0;
	}
	
	function totalsum2(column, data) {
		if(sumData) 
			return sumData.DLIVY_GTN; 
		else 
			return 0;
	}
	/* 총합계 추가 */
	
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
			<input type="hidden" id="statList" value="<c:out value='${statList}' />" />
			<input type="hidden" id="mfcSeCdList" value="<c:out value='${mfcSeCdList}' />" />
    		<input type="hidden" id="whsdlSeCdList" value="<c:out value='${whsdlSeCdList}' />" />
    		 <input type="hidden" id="brchList" value="<c:out value='${brchList}' />" />
			<input type="hidden" id="ctnrList" value="<c:out value='${ctnrList}' />" />
			<input type="hidden" id="whsdlList" value="<c:out value='${whsdlList}' />" />
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
								<select style="width: 180px;" id="EXCA_STD_CD"></select>
							</div>
						</div>
						<div class="col" >
							<div class="tit" id="stat_txt" ></div>
							<div class="box">
								<select style="width: 180px;" id="DLIVY_CRCT_STAT_CD"></select>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col" >
							<div class="tit" id="mfc_bizrnm_txt" ></div>
							<div class="box">
								<select id="MFC_BIZR_SEL" style="width: 179px"></select>
							</div>
						</div>
						<div class="col">
							<div class="tit" id="mfc_brch_nm_txt"></div> 
							<select style="width: 180px;" id="MFC_BRCH_SEL"></select>
						</div>
						<div class="col">
							<div class="tit" id="ctnr_nm_txt"></div>
							<div class="box">
								<select style="width: 180px;" id="CTNR_CD_SEL"></select>
							</div>
						</div>
					</div>		
					<div class="row">
						<div class="col" >
							<div class="tit" id="whsl_se_cd_txt" ></div>
							<div class="box">
								<select id="WHSDL_SE_CD_SEL" style="width: 179px"></select>
							</div>
						</div>
						<div class="col">
							<div class="tit" id="enp_nm_txt"></div> 
							<select style="width: 180px;" id="CUST_BIZR_SEL"  ></select>
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
			<div id="gridHolder" style="height: 580px; background: #FFF;"></div>
			<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
		</div>

		<section class="btnwrap" >
			<div class="btn" style="float:left" id="BL"></div>
			<div class="btn" style="float:right" id="BR"></div>
		</section>

	</div> <!-- end of  iframe_inner -->
	
	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="excel" />
	</form>

</body>
</html>

		