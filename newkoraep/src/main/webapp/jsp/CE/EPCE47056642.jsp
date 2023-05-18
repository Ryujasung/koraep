<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>입고내역선택</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>

<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />
<script type="text/javaScript" language="javascript" defer="defer">

	/* 페이징 사용 등록 */
	gridRowsPerPage 	= 15;	// 1페이지에서 보여줄 행 수
	gridCurrentPage 		= 1;	// 현재 페이지
	gridTotalRowCount 	= 0; //전체 행 수
	
	 var INQ_PARAMS; 				//파라미터 데이터
     var whsl_se_cdList;			//도매업자구분
     var whsdlList;					//도매업자 업체명 조회
     var mfc_bizrnmList;			//생산자
	 var std_mgnt_list;				//정산기간
	 var brch_nmList;;

 	 var arr 	= new Array();									//생산자
	 var arr2 = new Array();									//직매장
	 var arr3 = new Array();									//도매업자
	 var arr4 = new Array();
	 var exca_st_dt="";											//정산가능기간
	 var exca_end_dt="";										//정산가능기간
	 var rowIndexValue ="";
	 
    $(function() {
    	 
		INQ_PARAMS 			=  jsonObject($("#INQ_PARAMS").val());	
		whsl_se_cdList		=  jsonObject($("#whsl_se_cdList").val());       
		whsdlList 				=  jsonObject($("#whsdlList").val());
		mfc_bizrnmList 		=  jsonObject($("#mfc_bizrnmList").val());       
		std_mgnt_list 		=  jsonObject($("#std_mgnt_list").val());      
		brch_nmList			=  jsonObject($("#brch_nmList").val());   
    	
    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
    	 //그리드 셋팅
		 fnSetGrid1();
    	 
		 fn_init();
		 
		 /************************************
		 * 취소 버튼 클릭  이벤트
		 ***********************************/
		$("#btn_cnl").click(function(){
			fn_cnl();
		});
    	 
		/************************************
		 * 정산기간 변경 이벤트
		 ***********************************/
		$("#EXCA_STD_CD_SE").change(function(){
			fn_exca_std_cd();
		}); 
		 
		/************************************
		 * 생산자 구분 변경 이벤트
		 ***********************************/
		$("#MFC_BIZRNM").change(function(){
			fn_mfc_bizrnm();
		});
		
		/************************************
		 * 직매장/공장 구분 변경 이벤트
		 ***********************************/
		$("#MFC_BRCH_NM").change(function(){
			fn_mfc_brch_nm();
		});
		
		/************************************
		 * 도매업자 구분 변경 이벤트
		 ***********************************/
		$("#BIZR_TP_CD").change(function(){
			fn_whsl_se_cd();
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
		 * 정정등록 클릭 이벤트
		 ***********************************/
		$("#btn_reg").click(function(){
			fn_reg();
		});
  		
	});
    
     function fn_init(){
    	 	var selectVal = INQ_PARAMS.EXCA_PARAM.EXCA_STD_CD+';'+INQ_PARAMS.EXCA_PARAM.EXCA_TRGT_SE;
    	 	kora.common.setEtcCmBx2(std_mgnt_list, "", selectVal, $("#EXCA_STD_CD_SE"), "EXCA_STD_CD_SE", "EXCA_STD_NM", "N"); //정산기간 선택
    	 
			kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'T');					//생산자
			kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'T');					//직매장/공장
			kora.common.setEtcCmBx2(whsl_se_cdList, "","", $("#BIZR_TP_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');					//도매업자구분 
		 	kora.common.setEtcCmBx2(whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');	//도매업자 업체명
		  	
			//text 셋팅
			$('#title_sub').text('<c:out value="${titleSub}" />');						  								//타이틀
			$('#exca_term').text(parent.fn_text('exca_term'));															//정산기간
			$('#mfc_bizrnm').text(parent.fn_text('mfc_bizrnm')); 														//반환대상생산자
			$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm')); 													//반환대상지점
			$('#whsl_se_cd').text(parent.fn_text('whsl_se_cd'));														//도매업자 구분
			$('#enp_nm').text(parent.fn_text('enp_nm'));																	//업체명
			
			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				if(brch_nmList !=null){
					 kora.common.setEtcCmBx2(brch_nmList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');	 //직매장/공장
				}
				kora.common.jsonToTable("params",INQ_PARAMS.SEL_PARAMS);
				/* 화면이동 페이징 셋팅 */
				gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
			}
			
	  		$("#WHSDL_BIZRNM").select2();	
	  		
     }
     
     //정산기간 변경시  생산자 조회
     function fn_exca_std_cd(){
  	 		var url = "/CE/EPCE4705601_194.do" 
  			var input ={};
  	 		if($("#EXCA_STD_CD_SE").val() !=""){
	  	 		arr4	 = [];
	  	 		arr4	 = $("#EXCA_STD_CD_SE").val().split(";");
	  			input["EXCA_STD_CD"]			=  arr4[0];
	  			input["EXCA_TRGT_SE"]		=  arr4[1];
	  			ajaxPost(url, input, function(rtnData) {
	  				if ("" != rtnData && null != rtnData) {   
	  					 mfc_bizrnm_return	=	rtnData.mfc_bizrnmList;
	  					 kora.common.setEtcCmBx2(rtnData.mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'T'); //생산자
	  				}else{
	  					 alertMsg("error");
	  				}
	  			},false);
  	 		}else{
	  	 		 kora.common.setEtcCmBx2([], "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'T');			//생산자
	  			 kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');							//직매장/공장
				 kora.common.setEtcCmBx2(whsl_se_cdList, "","", $("#BIZR_TP_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');				//도매업자 구분
				 kora.common.setEtcCmBx2(whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');	//도매업자 업체명
  	 		}
     }
     
   	 //도매업자구분 변경시 도매업자 조회 ,생산자가 선택됐을경우 거래중인 도매업자만 조회
     function fn_whsl_se_cd(){
    	   var url = "/CE/EPCE47056642_193.do" 
		   var input ={};
		   if($("#BIZR_TP_CD").val() !=""){
		  	 input["BIZR_TP_CD"] =$("#BIZR_TP_CD").val();
		   }
		   //생산자 선택시 선택된 생산자랑 거래중인 도매업자 조회
		   if( $("#MFC_BIZRNM").val() !="" ){
    				input["MFC_BIZRID"]	= arr[0];
    				input["MFC_BIZRNO"]	= arr[1];
    				//생산자 + 직매장 선택시 거래중이 도매업자 조회
    				if($("#MFC_BRCH_NM").val() !="" ){
    				 	input["MFC_BRCH_ID"]		= arr2[0];
    		    		input["MFC_BRCH_NO"]	= arr2[1];
    				}
		   }
       	   ajaxPost(url, input, function(rtnData) {
    				if ("" != rtnData && null != rtnData) {  
    					 	kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');		 //업체명
    				}else{
    						 alertMsg("error");
    				}
    		});
     }
 
   //생산자 변경시 생산자랑 거래중인 도매업자 조회 , 직매장/공장
   function fn_mfc_bizrnm(){
	  	 var url = "/CE/EPCE47056642_19.do" 
	 	 var input ={};
		 arr	 =[];
		 arr	 = $("#MFC_BIZRNM").val().split(";");
		 input["MFC_BIZRID"]		= arr[0]; //직매장별거래처관리 테이블에서 생산자
		 input["MFC_BIZRNO"]		= arr[1];
		 input["BIZRID"]				= arr[0]; //지점관리 테이블에서 사업자
		 input["BIZRNO"]				= arr[1];
	     if($("#BIZR_TP_CD").val() !=""){
 			  input["BIZR_TP_CD"]	= $("#BIZR_TP_CD").val();
 		 } 
	     
   		$("#WHSDL_BIZRNM").select2("val","");
      	    ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {   
   					 kora.common.setEtcCmBx2(rtnData.brch_nmList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');	 			//직매장/공장
   					 kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');	//도매업자 업체명
   					 }else{
   						 alertMsg("error");
   				}
   		},false);
   }
   
   //직매장/공장 변경시  생산자랑 거래 중인 도매업자 업체명 조회
   function fn_mfc_brch_nm(){
		 var url = "/CE/EPCE47056642_192.do" 
		 var input ={};
		 arr2	= [];
 	     arr2	= $("#MFC_BRCH_NM").val().split(";");
		 input["MFC_BIZRID"]		= arr[0];  //직매장별거래처관리 테이블에서 생산자
		 input["MFC_BIZRNO"]		= arr[1];
 	     input["MFC_BRCH_ID"]	= arr2[0];
	  	 input["MFC_BRCH_NO"]	= arr2[1];
 	  	 if($("#BIZR_TP_CD").val() !=""){
	 		 input["BIZR_TP_CD"]		=$("#BIZR_TP_CD").val();
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
  
   //입고내역선택 조회
    function fn_sel(){
		 
		 var input	= {};
		 var url = "/CE/EPCE47056642_194.do" 

		 var mfc_bizrnm	 	= $("#MFC_BIZRNM").val();	 
		 var mfc_brch_nm	= $("#MFC_BRCH_NM").val();		
		 var flag_dt			= false;

		 input["BIZR_TP_CD"] = $("#BIZR_TP_CD").val(); //도매업자 구분
		 
		 if($("#MFC_BIZRNM").val() !="" ){ //생산자
			 arr	 =[];
			 arr	 = $("#MFC_BIZRNM").val().split(";");
			 input["MFC_BIZRID"]   		= arr[0];
			 input["MFC_BIZRNO"]  	= arr[1];
		 }
		 if($("#MFC_BRCH_NM").val() !="" ){	//직매장/공장
			 arr2	 =[];
			 arr2	 = $("#MFC_BRCH_NM").val().split(";");
			 input["MFC_BRCH_ID"]   	= arr2[0];
			 input["MFC_BRCH_NO"]  	= arr2[1];
		 }
		if($("#WHSDL_BIZRNM").val() !="" ){	//도매업자
		 	 arr3	=[];
			 arr3	= $("#WHSDL_BIZRNM").val().split(";");
			 input["WHSDL_BIZRID"]   	= arr3[0];
			 input["WHSDL_BIZRNO"] 	= arr3[1]; 
		 }
		
		 var excaStdCdSe = $("#EXCA_STD_CD_SE").val().split(";");
		 input["EXCA_STD_CD"]		=  excaStdCdSe[0];
		 input["EXCA_TRGT_SE"]		=  excaStdCdSe[1];
		
		 //상세갔다가 올때 SELECT박스 값
		 input["MFC_BIZRNM"] 		= $("#MFC_BIZRNM").val(); 
		 input["MFC_BRCH_NM"] 	= $("#MFC_BRCH_NM").val();
		 input["WHSDL_BIZRNM"] 	= $("#WHSDL_BIZRNM").val();
		 
		 input["MFC_BIZRNM_RETURN"] = JSON.stringify(mfc_bizrnmList);	//생산자LIST
		 
		/* 페이징  */
		input["ROWS_PER_PAGE"] = gridRowsPerPage;
		input["CURRENT_PAGE"] 	= gridCurrentPage;
		
		INQ_PARAMS["SEL_PARAMS"] = input;
		
		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
      	ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {   
  				gridApp.setData(rtnData.selList);
  					/* 페이징 표시 */
				gridTotalRowCount = rtnData.totalCnt; //총 카운트
				drawGridPagingNavigation(gridCurrentPage);
			}else{
				alertMsg("error");
			}
   	  		kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
   		});
    }
   
    /* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel(); //조회 펑션
	}
    
	//입고내역서 등록 페이지 이동 
	function fn_reg() {
		var selectorColumn = gridRoot.getObjectById("selector");
		var input = {};
		var dt_check  =false;
		
		if(selectorColumn.getSelectedIndices() == ""){
			alertMsg("선택한 건이 없습니다.");
			return false;
		}
		
		input = gridRoot.getItemAt(rowIndexValue);
		INQ_PARAMS["PARAMS"] = {}
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE47056642.do";
		kora.common.goPage('/CE/EPCE4705631.do', INQ_PARAMS);
	}
	
	//상세조회
	function dtl_link(data){
		var idx = dataGrid.getSelectedIndices();
		var input = gridRoot.getItemAt(idx);
		var url = "/CE/EPCE29164642.do"; //입고정보상세조회
		if(data == '2'){
			url = "/CE/EPCE4738764.do";	 //수기입고정정내역조회
		}
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["PARAMS"] = {};
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE47056642.do";
		kora.common.goPage(url, INQ_PARAMS);
	}
	
    //취소
  	function fn_cnl(){ 
  		kora.common.goPageB('', INQ_PARAMS);
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
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" horizontalScrollPolicy="on"  sortableColumns="true"   headerHeight="35">');
			layoutStr.push('		<groupedColumns>');   	
			layoutStr.push('			<DataGridSelectorColumn id="selector"	  width="40"	textAlign="center" allowMultipleSelection="false" vertical-align="middle" draggable="false"  />');										//선택 
			layoutStr.push('			<DataGridColumn dataField="PNO" 				 				headerText="'+ parent.fn_text('sn')+ '" textAlign="center" width="50"   draggable="false"  />');						//순번
			layoutStr.push('			<DataGridColumn dataField="WRHS_CFM_DT" 				headerText="'+ parent.fn_text('wrhs_cfm_dt')+ '" width="100"  textAlign="center"   itemRenderer="HtmlItem" />');	//입고확인일자
			layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNM"			 		headerText="'+ parent.fn_text('whsdl')+ '"  textAlign="center" width="130"   />'); 											//도매업자
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRNO"			 	headerText="'+ parent.fn_text('bizrno')+ '"  textAlign="center" width="80"   formatter="{maskfmt1}"/>'); 											//지역
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM"			 		headerText="'+ parent.fn_text('mfc_bizrnm')+ '"  textAlign="center" width="130"   />'); 											//도매업자
			layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_NM"			 		headerText="'+ parent.fn_text('mfc_brch_nm')+ '"  textAlign="center" width="130"   />'); 											//도매업자
			
			layoutStr.push('			<DataGridColumnGroup  												headerText="'+ parent.fn_text('reg_info')+ '">');																															//입고량
			layoutStr.push('				<DataGridColumn dataField="CFM_QTY_TOT" 				headerText="'+ parent.fn_text('wrhs_qty')+ '" width="80" formatter="{numfmt}"  id="num1"  textAlign="right" />');		//가정용
			layoutStr.push('				<DataGridColumn dataField="CFM_GTN_TOT" 				headerText="'+ parent.fn_text('gtn')+ '" width="80" formatter="{numfmt}" id="num2" textAlign="right" />');		//유흥용
			layoutStr.push('				<DataGridColumn dataField="CFM_FEE_TOT" 				headerText="'+ parent.fn_text('fee')+ '" width="80" formatter="{numfmt}" id="num3" textAlign="right" />');	//직접
			layoutStr.push('				<DataGridColumn dataField="CFM_WHSL_FEE_STAX_TOT" headerText="'+ parent.fn_text('stax')+ '" width="80" formatter="{numfmt}" id="num4" textAlign="right" />');					//소계
			layoutStr.push('				<DataGridColumn dataField="CFM_ATM_TOT"  			headerText="'+ parent.fn_text('amt_tot')+ '" width="100" formatter="{numfmt}" id="num5" textAlign="right" />');				//보증금
			layoutStr.push('			</DataGridColumnGroup>');
			
			layoutStr.push('			<DataGridColumnGroup  												headerText="'+ parent.fn_text('crct_reg')+ '">');																															//입고량
			layoutStr.push('				<DataGridColumn dataField="CRCT_QTY" 					headerText="'+ parent.fn_text('wrhs_qty')+ '" width="80" formatter="{numfmt}"  id="num6"  textAlign="right" />');		//가정용
			layoutStr.push('				<DataGridColumn dataField="CRCT_GTN" 					headerText="'+ parent.fn_text('gtn')+ '" width="80" formatter="{numfmt}" id="num7" textAlign="right" />');		//유흥용
			layoutStr.push('				<DataGridColumn dataField="CRCT_FEE_TOT" 			headerText="'+ parent.fn_text('fee')+ '" width="80" formatter="{numfmt}" id="num8" textAlign="right" />');	//직접
			layoutStr.push('				<DataGridColumn dataField="CRCT_FEE_STAX_TOT" 	headerText="'+ parent.fn_text('stax')+ '" width="80" formatter="{numfmt}" id="num9" textAlign="right" />');					//소계
			layoutStr.push('				<DataGridColumn dataField="CRCT_ATM_TOT"  			headerText="'+ parent.fn_text('amt_tot')+ '" width="100" formatter="{numfmt}" id="num10" textAlign="right" />');				//보증금
			layoutStr.push('			</DataGridColumnGroup>');
			
			layoutStr.push('			<DataGridColumn dataField="WRHS_CRCT_STAT_CD_NM" headerText="'+ parent.fn_text('stat')+ '" width="100"  textAlign="center"  itemRenderer="HtmlItem"/>');														//등록구분
			
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn label="합계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num8}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num9}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num10}" formatter="{numfmt}" textAlign="right"/>');	
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
		gridApp.setData();
		
		var layoutCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			dataGrid.addEventListener("change", selectionChangeHandler);
		
		  	 //파라미터 call back function 실행
			 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
				 /* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
			 	 window[INQ_PARAMS.FN_CALLBACK]();
			 	//취약점점검 5923 기원우
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
			
			rowIndexValue = rowIndex;
			selectorColumn.setSelectedIndex(-1);
			selectorColumn.setSelectedIndex(rowIndex);
	
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	}
	
	
	
/****************************************** 그리드 셋팅 끝***************************************** */


</script>

<style type="text/css">

.srcharea .row .col{
width: 40%;
}  
.srcharea .row .col .tit{
width: 85px;
}
</style>

</head>
<body>		
    <div class="iframe_inner" >
    		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="whsl_se_cdList" value="<c:out value='${whsl_se_cdList}' />" />
			<input type="hidden" id="whsdlList" value="<c:out value='${whsdlList}' />" />
			<input type="hidden" id="mfc_bizrnmList" value="<c:out value='${mfc_bizrnmList}' />" />
    		<input type="hidden" id="std_mgnt_list" value="<c:out value='${std_mgnt_list}' />" />
    		<input type="hidden" id="brch_nmList" value="<c:out value='${brch_nmList}' />" />
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
				<div class="btn" style="float:right" id="UR">
				<!--btn_dwnd  -->
				<!--btn_excel  -->
				</div>
			</div>
		<section class="secwrap"   id="params">
				<div class="srcharea" style="margin-top: 10px"  > 
				<div class="row" >
					<div class="col"  >
						<div class="tit" id="exca_term"></div><!--정산기간-->
						<div class="box">
							<select  id=EXCA_STD_CD_SE style="width: 200px" class="i_notnull"></select>
						</div>
					</div>
				</div> <!-- end of row -->

				<div class="row">
						<div class="col">
							<div class="tit" id="mfc_bizrnm"></div>  <!--반환대상생산자-->
							<div class="box">
								<select id="MFC_BIZRNM" style="width: 250px" ></select>
							</div>
						</div>
				
					    <div class="col">
							<div class="tit" id="mfc_brch_nm"></div>  <!-- 반환대상 직매장/공장 -->
							<div class="box">
								<select id="MFC_BRCH_NM" style="width: 250px" ></select>
							</div>
						</div>
					</div> <!-- end of row -->
					
					<div class="row">
						<div class="col">
							<div class="tit" id="whsl_se_cd"></div>  <!-- 도매업자구분 -->
							<div class="box">
								<select id="BIZR_TP_CD" style="width: 179px" ></select>
							</div>
						</div>
						
						<div class="col" ">
							<div class="tit" id="enp_nm"></div>  <!-- 도매업자업체명 -->
							<div class="box"  >
								  <select id="WHSDL_BIZRNM" name="WHSDL_BIZRNM" style="width: 250px"></select>
							</div>
						</div>
					<div class="btn"  id="CR" ></div> <!--조회  -->
					</div> <!-- end of row -->
				</div>  <!-- end of srcharea -->
			</section>
			
			<section class="btnwrap mt10"  >		<!--그리드 컬럼  -->
				<div class="h4group" >
					<h5 class="tit"  style="font-size: 15px;" id="EXCA_DT"></h5>
				</div>
				<div class="btn" id="CL"></div>
			</section>
			<div class="boxarea mt10">  <!-- 634 -->
				<div id="gridHolder" style="height: 650px; background: #FFF;"></div>
			   	<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
			</div>	<!-- 그리드 셋팅 -->
			
		<section class="btnwrap" style="height:50px">
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

</body>
</html>