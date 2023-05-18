<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>신구병 통계현황</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>

<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />
<style>
/* The Modal (background) */
.searchModal {
display: none; /* Hidden by default */
position: fixed; /* Stay in place */
z-index: 10; /* Sit on top */
left: 0;
top: 0;
width: 100%; /* Full width */
height: 100%; /* Full height */
overflow: auto; /* Enable scroll if needed */
background-color: rgb(0,0,0); /* Fallback color */
background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
}
/* Modal Content/Box */
.search-modal-content {
background-color: #fefefe;
text-align:center;
margin: 15% auto; /* 15% from the top and centered */
padding: 20px;
border: 1px solid #888;
width: 180px; /* Could be more or less, depending on screen size */
border-radius:10px; 
}
</style>
<script type="text/javaScript" language="javascript" defer="defer">

	/* 페이징 사용 등록 */
	gridRowsPerPage = 15;	// 1페이지에서 보여줄 행 수
	gridCurrentPage = 1;	// 현재 페이지
	gridTotalRowCount = 0; //전체 행 수
	
	var sumData;
	
	var INQ_PARAMS;	//파라미터 데이터

	var whsl_se_cdList;	//도매업자구분
	var mfc_bizrnmList;	//생산자
	var areaList;			//지역
	var brch_nmList;		//직매장/공장
	var ctnrUseYn;
	var ctnrSe;
	var prpsCd;
	var alkndCdList;   //주종

    $(function() {
    	 
    	INQ_PARAMS = jsonObject($("#INQ_PARAMS").val()); //파라미터 데이터
  	    whsl_se_cdList = jsonObject($("#whsl_se_cdList").val());	 //도매업자구분
  	    mfc_bizrnmList = jsonObject($("#mfc_bizrnmList").val());	 //생산자
  	    areaList = jsonObject($("#areaList").val()); //지역
  	  	brch_nmList = jsonObject($("#brch_nmList").val()); //직매장
  	    ctnrUseYn = jsonObject($("#ctnrUseYn").val());
  	  	ctnrSe = jsonObject($("#ctnrSe").val());
  	  	prpsCd = jsonObject($("#prpsCd").val());
  	  	alkndCdList = jsonObject($("#alkndCdList").val());
  	  	
		//버튼 셋팅
		fn_btnSetting();
		 	 
		//그리드 셋팅
		fnSetGrid1();
		
		//text셋팅
		$('.row > .col > .tit').each(function(){
			$(this).text(parent.fn_text($(this).attr('id')) );
		});
		
		kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'T'); //생산자
		//kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'T'); //직매장/공장
		kora.common.setEtcCmBx2(whsl_se_cdList, "","", $("#WHSL_SE_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T'); //도매업자구분 
	 	kora.common.setEtcCmBx2([], "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T'); //도매업자 업체명
		kora.common.setEtcCmBx2(areaList, "","", $("#AREA"), "ETC_CD", "ETC_CD_NM", "N" ,'T'); //지역
		kora.common.setEtcCmBx2(ctnrSe, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N", "T"); //빈용기구분
		kora.common.setEtcCmBx2(prpsCd, "!2|","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N", "T"); //빈용기구분
		kora.common.setEtcCmBx2(alkndCdList, "","", $("#ALKND_CD"), "ETC_CD", "ETC_CD_NM", "N", "T"); //빈용기구분
		kora.common.setEtcCmBx2(ctnrUseYn, "","", $("#CTNR_USE_YN"), "ETC_CD", "ETC_CD_NM", "N", "T");
		kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S'); //빈용기
		
  		$("#WHSDL_BIZRNM").select2();
  		fn_whsl_se_cd(); //도매업자 조회
		
  		//파라미터 조회조건으로 셋팅
		if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
			kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
			/* 화면이동 페이징 셋팅 */
			gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
			
			$("#WHSDL_BIZRNM").select2('val', INQ_PARAMS.SEL_PARAMS.WHSDL_BIZRNM);
		}
  		
		/************************************
		 * 생산자 구분 변경 이벤트
		 ***********************************/
		$("#MFC_BIZRNM").change(function(){
			fn_mfc_bizrnm();
		});
		
		/************************************
		 * 직매장/공장 구분 변경 이벤트
		 **********************************
		$("#MFC_BRCH_NM").change(function(){
			fn_mfc_brch_nm();
		});
		*/
		
		/************************************
		 * 도매업자 구분 변경 이벤트
		 ***********************************/
		$("#WHSL_SE_CD").change(function(){
			fn_whsl_se_cd();
		});
		
		/************************************
		 * 빈용기구분 구병 / 신병 변경시 
		 ***********************************/
		$("#CTNR_SE").change(function(){
			fn_prps_cd();
		});
		
		/************************************
		 * 빈용기 구분 변경 이벤트
		 ***********************************/
		$("#PRPS_CD").change(function(){
			fn_prps_cd();
		});
		
		/************************************
		 * 조회 클릭 이벤트
		 ***********************************/
		$("#btn_sel").click(function(){
			//조회버튼 클릭시 페이징 초기화
			gridCurrentPage = 1;
			fn_sel();
		});

		/************************************
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_excel").click(function() {
			fn_excel();
		 });

		$("#btn_page").click(function() {
			fn_page();
		 });
		
		$("#btn_page2").click(function() {
			fn_page2();
		 });
		
		$("#btn_pop").click(function() {
			fn_pop();
		 });
		
	});

	var parent_item;
	function fn_pop(){
		
		var idx = dataGrid.getSelectedIndices();

		if(idx.length < 1){
			alertMsg("선택된 행이 없습니다.");
			return;
		}
		
		parent_item = gridRoot.getItemAt(idx);

		var pagedata = window.frameElement.name;
		window.parent.NrvPub.AjaxPopup('/CE/EPCE6172488.do', pagedata);
	}
    
    function fn_page(){
    
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE6172401.do";
		kora.common.goPage('/CE/EPCE61724012.do', INQ_PARAMS);
    	
    }
    
    function fn_page2(){
        
    	var idx = dataGrid.getSelectedIndices();

		if(idx.length < 1){
			alertMsg("선택된 행이 없습니다.");
			return;
		}
		
		var idx = dataGrid.getSelectedIndices();
		var input = gridRoot.getItemAt(idx);

		//파라미터에 조회조건값 저장 
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE6172401.do";
		kora.common.goPage('/CE/EPCE6172442.do', INQ_PARAMS);
    	
    }
    
  	//빈용기 구분 선택시
	function fn_prps_cd(){

		var url = "/SELECT_CTNR_CD2.do" 
		var input ={};

		ctnr_nm=[];
		var arr	= $("#WHSDL_BIZRNM").val().split(";");
		var arr3	= $("#MFC_BIZRNM").val().split(";");
		//var arr4	= $("#MFC_BRCH_NM").val().split(";"); 
		input["CUST_BIZRID"] 		= arr[0];					//도매업자아이디
		input["CUST_BIZRNO"] 	= arr[1];					//도매업자사업자번호
		//input["CUST_BRCH_ID"] 	= arr2[0];					//도매업자 지점 아이디
		//input["CUST_BRCH_NO"] 	= arr2[1];					//도매업자 지점 번호
		input["MFC_BIZRID"] 		= arr3[0];					//생산자 아이디
		input["MFC_BIZRNO"] 		= arr3[1];					//생산자 사업자번호
		//input["MFC_BRCH_ID"] 	= arr4[0];					//생산자 직매장/공장 아이디
		//input["MFC_BRCH_NO"] 	= arr4[1];					//생산자 직매장/공장 번호
		input["CTNR_SE"] 			= $("#CTNR_SE").val();	//빈용기명 구분 구/신
		input["PRPS_CD"] 			= $("#PRPS_CD").val();	//빈용기명  유흥/가정/공병/직접 
		//input["RTN_DT"] 				= $("#RTN_DT").val(); //반환일자 

		ajaxPost(url, input, function(rtnData) {
 			if ("" != rtnData && null != rtnData) {   
				ctnr_nm = rtnData.ctnr_nm
				kora.common.setEtcCmBx2(rtnData.ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'T'); //빈용기	
 			}else{
			alertMsg("error");
 			}
    	},false);


   	}
    
  	 //도매업자구분 변경시 도매업자 조회, 생산자가 선택됐을경우 거래중인 도매업자만 조회
     function fn_whsl_se_cd(){
    	var url = "/SELECT_WHSDL_BIZR_LIST.do" 
		var input ={};
		   if($("#WHSL_SE_CD").val() !=""){
		  	 input["BIZR_TP_CD"] =$("#WHSL_SE_CD").val();
		   }
		   //생산자 선택시 선택된 생산자랑 거래중인 도매업자 조회
		   if( $("#MFC_BIZRNM").val() !="" ){
		   		var arr = $("#MFC_BIZRNM").val().split(";");
   				input["MFC_BIZRID"] = arr[0];
   				input["MFC_BIZRNO"] = arr[1];
   				//생산자 + 직매장 선택시 거래중이 도매업자 조회
   				//if($("#MFC_BRCH_NM").val() !="" ){
 				//	input["MFC_BRCH_ID"] = arr2[0];
 		    	//	input["MFC_BRCH_NO"] = arr2[1];
   				//}
		   }
		   
		   $("#WHSDL_BIZRNM").select2("val","");
		   
       	   ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {  
   					 kora.common.setEtcCmBx2(rtnData, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T'); //도매업자 업체명 
   				}else{
   					alertMsg("error");
   				}
    		}, false);
     }
 
   //생산자 변경시 생산자랑 거래중인 도매업자 조회 , 직매장/공장
   function fn_mfc_bizrnm(){
	  		var url = "/CE/EPCE2983901_19.do" 
			var input ={};
			var arr = $("#MFC_BIZRNM").val().split(";");
			input["MFC_BIZRID"]		= arr[0]; //직매장별거래처관리 테이블에서 생산자
			input["MFC_BIZRNO"]		= arr[1];
			input["BIZRID"]				= arr[0]; //지점관리 테이블에서 사업자
			input["BIZRNO"]				= arr[1];
			
		 	if($("#WHSL_SE_CD").val() !=""){
   			 	 input["BIZR_TP_CD"]		=$("#WHSL_SE_CD").val();
   			} 
		 	
	    	$("#WHSDL_BIZRNM").select2("val","");
       	    ajaxPost(url, input, function(rtnData) {
    				if ("" != rtnData && null != rtnData) {   
    					 //kora.common.setEtcCmBx2(rtnData.brch_nmList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');	//직매장/공장
    					 kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T'); //도매업자 업체명
    				}else{
    					 alertMsg("error");
    				}
    		},false);
   }
   
   //직매장/공장 변경시  생산자랑 거래 중인 도매업자 업체명 조회
   function fn_mfc_brch_nm(){

		var url = "/CE/EPCE2983901_192.do" 
		var input ={};
		var arr = $("#MFC_BIZRNM").val().split(";");
 	    //var arr2 = $("#MFC_BRCH_NM").val().split(";");
		input["MFC_BIZRID"]		= arr[0];  //직매장별거래처관리 테이블에서 생산자
		input["MFC_BIZRNO"]		= arr[1];
 	    //input["MFC_BRCH_ID"]	= arr2[0];
 		//input["MFC_BRCH_NO"]	= arr2[1];
 		
 		if($("#WHSL_SE_CD").val() !=""){
			input["BIZR_TP_CD"] =$("#WHSL_SE_CD").val();
 		} 
 		
   		$("#WHSDL_BIZRNM").select2("val","");
      	   ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {   
   					 kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');	//도매업자 업체명
   			 	}else{
   					 alertMsg("error");
   				}
   		},false);
   }
  
   //조회
    function fn_sel(){
		var input = {};
		var url = "/CE/EPCE6172401_19.do" 
		 
		var input = kora.common.gfn_formData("frmSel");
		
		/* 페이징  */
		input["ROWS_PER_PAGE"] = gridRowsPerPage;
		input["CURRENT_PAGE"] 	= gridCurrentPage;
			
		INQ_PARAMS["SEL_PARAMS"] = input;
		
// 		kora.common.showLoadingBar(dataGrid, gridRoot);
		$("#modal").show();
		ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {   
				gridApp.setData(rtnData.searchList);
				sumData = rtnData.totalList[0];                       
	
				/* 페이징 표시 */
				gridTotalRowCount = parseInt(sumData.CNT); //총 카운트
				drawGridPagingNavigation(gridCurrentPage);
			}else{
				alertMsg("error");
			}
// 			kora.common.hideLoadingBar(dataGrid, gridRoot);
			$("#modal").hide();
		});
		      	
    }
   
    /* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel(); //조회 펑션
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
		var fileName = $('#title').text().replace("/","_")  +"_" + today+hour+min+sec+".xlsx";
		
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
		input['excelYn'] = 'Y';	//엑셀 저장시 모든 검색이 필요해서
		input['fileName'] = fileName;
		input['columns'] = JSON.stringify(col);
		var url = "/CE/EPCE6172401_05.do";
		 kora.common.showLoadingBar(dataGrid, gridRoot);
		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
				alertMsg(rtnData.RSLT_MSG);
			}else{
				//파일다운로드
				frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
				frm.fileName.value = fileName;
				frm.submit();
			}
			kora.common.hideLoadingBar(dataGrid, gridRoot);
		}); 
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
			layoutStr.push('	<NumberMaskFormatter id="maskfmt1" formatString="###-##-#####"/>');
			layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" textAlign="center" id="dg1" draggableColumns="true" horizontalScrollPolicy="on"  sortableColumns="true" headerHeight="35">');
			layoutStr.push('		<groupedColumns>');   	
			layoutStr.push('			<DataGridSelectorColumn id="selector" width="40" headerText="'+ parent.fn_text('cho')+ '" allowMultipleSelection="false" draggable="false"   />');
			layoutStr.push('			<DataGridColumn dataField="PNO" headerText="'+ parent.fn_text('sn')+ '" width="50"/>');
			layoutStr.push('			<DataGridColumn dataField="BIZR_TP_NM" headerText="'+ parent.fn_text('se')+ '" width="100"/>');
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRNM" headerText="'+ parent.fn_text('whsdl')+ '" width="130"/>');
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRNO_DE" headerText="'+ parent.fn_text('whsdl_bizrno')+ '" width="150" formatter="{maskfmt1}" />');
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM" headerText="'+ parent.fn_text('mfc_bizrnm')+ '" width="130"/>');
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM" headerText="'+ parent.fn_text('ctnr_nm')+ '" width="130"/>');
			layoutStr.push('			<DataGridColumn dataField="PRPS_NM" headerText="'+ parent.fn_text('prps_cd')+ '" width="80"/>');
			layoutStr.push('            <DataGridColumn dataField="ALKND_NM" headerText="'+ parent.fn_text('alknd_cd')+ '" width="80"/>');
			layoutStr.push('			<DataGridColumn dataField="CPCT_NM" headerText="'+ parent.fn_text('cpct_cd')+ '" width="100"/>');
			layoutStr.push('			<DataGridColumn dataField="DLIVY_QTY" headerText="'+ parent.fn_text('dlivy_qty2')+ '" width="100" id="sum1" textAlign="right" formatter="{numfmt}" />');
			layoutStr.push('			<DataGridColumn dataField="CFM_QTY" headerText="'+ parent.fn_text('rtn_qty2')+ '" width="100" id="sum2" textAlign="right" formatter="{numfmt}" />');
			layoutStr.push('			<DataGridColumn dataField="RMN_QTY" headerText="'+ parent.fn_text('rmn_qty')+ '" width="100" id="sum3" textAlign="right" formatter="{numfmt}" />');
			layoutStr.push('			<DataGridColumn dataField="AREA_NM" headerText="'+ parent.fn_text('area')+ '" width="100" id="tmp1"/>');
			layoutStr.push('			<DataGridColumn dataField="CTNR_USE_YN" headerText="'+ parent.fn_text('aplc_yn')+ '" width="100" id="tmp2"/>');
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn label="소계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum3}" formatter="{numfmt}" textAlign="right"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp1}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp2}"/>');
			layoutStr.push('			</DataGridFooter>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn label="총합계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum1" formatter="{numfmt}" dataColumn="{sum1}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum2" formatter="{numfmt}" dataColumn="{sum2}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum3" formatter="{numfmt}" dataColumn="{sum3}" textAlign="right"/>');	
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp1}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp2}"/>');
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
			dataGrid.addEventListener("change", selectionChangeHandler);
			
		  	 //파라미터 call back function 실행
			 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
				 /* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
			 	 window[INQ_PARAMS.FN_CALLBACK]();
			 	//취약점점검 5938 기원우
			 }else{
				 gridApp.setData();
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
			selectorColumn = gridRoot.getObjectById("selector");
			
			selectorColumn.setSelectedIndex(-1);
			selectorColumn.setSelectedIndex(rowIndex);
	
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
			return sumData.CFM_QTY; 
		else 
			return 0;
	}
	function totalsum3(column, data) {
		if(sumData) 
			return sumData.RMN_QTY; 
		else 
			return 0;
	}
	/* 총합계 추가 */
	
	
/****************************************** 그리드 셋팅 끝***************************************** */



</script>

<style type="text/css">
	.row .tit{width: 87px;}
</style>

</head>
<body>

    <div class="iframe_inner" >
    
   		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
		<input type="hidden" id="mfc_bizrnmList" value="<c:out value='${mfc_bizrnmList}' />" />
		<input type="hidden" id="brch_nmList" value="<c:out value='${brch_nmList}' />" />
		<input type="hidden" id="whsl_se_cdList" value="<c:out value='${whsl_se_cdList}' />" />
		<input type="hidden" id="areaList" value="<c:out value='${areaList}' />" />
		<input type="hidden" id="ctnrUseYn" value="<c:out value='${ctnrUseYn}' />" />
		<input type="hidden" id="ctnrSe" value="<c:out value='${ctnrSe}' />" />
		<input type="hidden" id="prpsCd" value="<c:out value='${prpsCd}' />" />
        <input type="hidden" id="alkndCdList" value="<c:out value='${alkndCdList}' />" />
		
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn" style="float:right" id="UR">
			</div>
		</div>
		
		<section class="secwrap" id="sel_params">
			<div class="srcharea" > 
				<form name="frmSel" id="frmSel" method="post" >
				<div class="row">
					<div class="col">
						<div class="tit" id="mfc_bizrnm"></div>
						<div class="box">
							<select id="MFC_BIZRNM" name="MFC_BIZRNM" style="width:200px" ></select>
						</div>
					</div>
			
					<!-- 
				    <div class="col">
						<div class="tit" id="mfc_brch_nm"></div>
						<div class="box">
							<select id="MFC_BRCH_NM" name="MFC_BRCH_NM" style="width:200px" ></select>
						</div>
					</div>
					 -->
					 
				</div> <!-- end of row -->
				
				<div class="row">
					<div class="col">
						<div class="tit" id="whsl_se_cd"></div>
						<div class="box">
							<select id="WHSL_SE_CD" name="WHSL_SE_CD" style="width:294px" ></select>
						</div>
					</div>
					
					<div class="col" ">
						<div class="tit" id="enp_nm"></div>
						<div class="box"  >
							  <select id="WHSDL_BIZRNM" name="WHSDL_BIZRNM" style="width:294px"></select>
						</div>
					</div>
					
					<div class="col">
						<div class="tit" id="area"></div>
						<div class="box">
							<select id="AREA" name="AREA" style="width:200px" ></select>
						</div>
					</div>
					
				</div> <!-- end of row -->
					
				<div class="row">
				
					<div class="col">
						<div class="tit" id="ctnr_se"></div>  <!-- 빈용기구분 -->
						<div class="box">
                            <select id="CTNR_SE" name="CTNR_SE" style="width:80px" class="i_notnull" ></select>
                            <select id="PRPS_CD" name="PRPS_CD" style="width:95px" class="i_notnull" ></select>
                            <select id="ALKND_CD" name="ALKND_CD" style="width:110px" class="i_notnull" ></select>
						</div>
					</div>
					
					<div class="col" >
						<div class="tit" id="ctnr_nm"></div>  <!-- 빈용기명 -->
						<div class="box" >
							<select id="CTNR_CD" name="CTNR_CD" style="width:200px" class="i_notnull" ></select>
						</div>
					</div>
				
					<div class="col" >
						<div class="tit" id="aplc_yn"></div>
						<div class="box" >
							<select id="CTNR_USE_YN" name="CTNR_USE_YN" style="width:200px" class="i_notnull" ></select>
						</div>
					</div>
				
					<div class="btn"  id="CR" ></div> <!--조회  -->
				</div> <!-- end of row -->
				</form>	
			</div>  <!-- end of srcharea -->
		</section>
					
		<div class="boxarea mt10">
			<div id="gridHolder" style="height: 638px; background: #FFF;"></div>
		   	<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
		</div>	<!-- 그리드 셋팅 -->
			
		<section class="btnwrap" style="height:50px" >
				<div class="btn" id="BL">
				</div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
		
</div>

<form name="frm" action="/jsp/file_down.jsp" method="post">
	<input type="hidden" name="fileName" value="" />
	<input type="hidden" name="saveFileName" value="" />
	<input type="hidden" name="downDiv" value="excel" />
</form>
	<div id="modal" class="searchModal"  style="display: none;">
		<div class="search-modal-content" >
			<h5> <img alt="" src="../../images/main/loading.gif"></h5>
		</div>
	</div>
</body>
</html>