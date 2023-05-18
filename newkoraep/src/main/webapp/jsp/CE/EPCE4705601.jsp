<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>수기입고정정</title>
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
	gridTotalRowCount 	= 0; 	//전체 행 수
	
	var sumData; /* 총합계 추가 */
	
     var toDay = kora.common.gfn_toDay(); 	// 현재 시간
	 var INQ_PARAMS;		//파라미터 데이터
	 var std_mgnt_list;		//정산기간
     var stat_cdList;			//상태
     var whsl_se_cdList;		//도매업자 구분
     var whsdlList;				//도매업자 업체명 조회
     var mfc_bizrnmList;		//상세 갔다올때 생산자  
	 var brch_nmList;			//상세 갔다올때 직매장정보
	 var parent_item;			//팝업창 오픈시 필드값
	 var btn_upd_val;
	 var arr 	= new Array();							
	 var arr2 = new Array();
	 var arr3 = new Array();
	 var arr4 = new Array();
	 
	 var mfc_bizrnm_return = new Array(); //음 조회때문에 하나더 생성
	 var whsdlList_return =new Array();
	 
     $(function() {
    	 
    	INQ_PARAMS 		=  jsonObject($("#INQ_PARAMS").val());
    	std_mgnt_list		=  jsonObject($("#std_mgnt_list").val());
    	stat_cdList 		=  jsonObject($("#stat_cdList").val());
    	whsl_se_cdList 	=  jsonObject($("#whsl_se_cdList").val());       
    	whsdlList 			=  jsonObject($("#whsdlList").val());      
    	mfc_bizrnmList 	=  jsonObject($("#mfc_bizrnmList").val());
    	brch_nmList 		=  jsonObject($("#brch_nmList").val());       
    	 
    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
    	 //그리드 셋팅
		 fnSetGrid1();
		
		//text 셋팅
		$('#title_sub').text('<c:out value="${titleSub}" />');		//타이틀
		$('#exca_term').text(parent.fn_text('exca_term'));			//정산기간
		$('#mfc_bizrnm').text(parent.fn_text('mfc_bizrnm')); 		//상생산자
		$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm')); 	//생산자지점
		$('#whsl_se_cd').text(parent.fn_text('whsl_se_cd'));		//도매업자 구분
		$('#whsdl').text(parent.fn_text('whsdl'));						//도매업자
		$('#stat').text(parent.fn_text('stat')); 							//상태
		
		//div필수값 alt
		 $("#EXCA_STD_CD_SE").attr('alt',parent.fn_text('exca_term'));   
      
		/************************************
		 * 정산기간 변경 이벤트
		 ***********************************/
		$("#EXCA_STD_CD_SE").change(function(){
			fn_exca_std_cd();
		});
		 
		/************************************
		 * 생산자  변경 이벤트
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
			fn_bizr_tp_cd();
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
		 * 정정 확인 클릭 이벤트
		 ***********************************/
		$("#btn_upd").click(function(){
			fn_upd_chk(1);
		});
		
		/************************************
		 * 정정 반련 클릭 이벤트
		 ***********************************/
		$("#btn_upd2").click(function(){
			fn_upd_chk(2);
		});
		
		/************************************
		 * 확인 취소 클릭 이벤트
		 ***********************************/
		$("#btn_upd3").click(function(){
			fn_upd_chk(3);
		});
		
        /************************************
         * 입고정정이월 클릭 이벤트
         ***********************************/
        $("#btn_forwd").click(function(){
            fn_forwd_chk();
        });
        
		/************************************
		 * 정정내역 수정 클릭 이벤트
		 ***********************************/
		$("#btn_page").click(function(){
			fn_page();
		});
		
		/************************************
		 * 수기정산등록 클릭 이벤트
		 ***********************************/
		$("#btn_page2").click(function(){
			fn_page2("AR");
		});
		
		/************************************
		 * 정정건재등록 클릭 이벤트
		 ***********************************/
		$("#btn_page3").click(function(){
			fn_page2("R");
		});
		
		/************************************
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_excel").click(function() {
			fn_excel();
		 });
		
  		fn_init();
	    	
	});
     																
     //초기화
     function fn_init(){
    	
    		 kora.common.setEtcCmBx2(std_mgnt_list, "","", $("#EXCA_STD_CD_SE"), "EXCA_STD_CD_SE", "EXCA_STD_NM", "N","S"); //정산기간 선택
    		 for(var k=0; k<std_mgnt_list.length; k++){ 
 		    	if(std_mgnt_list[k].EXCA_STAT_CD == 'S'){
 		    		$('#EXCA_STD_CD_SE').val(std_mgnt_list[k].EXCA_STD_CD_SE);
 		    		break;
 		    	}
 		     }
    		 fn_exca_std_cd(); //정산기간 선택 이벤트
    		 
    		 kora.common.setEtcCmBx2(stat_cdList, "","", $("#WRHS_CRCT_STAT_CD"), "ETC_CD", "ETC_CD_NM", "N" ,"T");		//상태  
			 kora.common.setEtcCmBx2(whsl_se_cdList, "","", $("#BIZR_TP_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');					//도매업자 구분
			 kora.common.setEtcCmBx2(whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');	//도매업자 업체명
			 //kora.common.setEtcCmBx2([], "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'T');									//생산자
			 kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');							//직매장/공장
		
			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				if(mfc_bizrnmList !=null){	
					 kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'T');			//생산자
				}
				if(brch_nmList !=null){
					 kora.common.setEtcCmBx2(brch_nmList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');		 //직매장/공장
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
     
   //생산자 변경시 생산자랑 거래중인 도매업자 조회 , 직매장/공장
   function fn_mfc_bizrnm(){
		var url = "/CE/EPCE4705601_19.do" 
		var input ={};
		$("#WHSDL_BIZRNM").select2("val","");
		if($("#MFC_BIZRNM").val() !=""){
			arr	 =[];
			arr	 = $("#MFC_BIZRNM").val().split(";");
			input["MFC_BIZRID"]			= arr[0];  //직매장별거래처관리 테이블에서 생산자
			input["MFC_BIZRNO"]		= arr[1];
			input["BIZRID"]				= arr[0];	//지점관리 테이블에서 사업자
			input["BIZRNO"]				= arr[1];
			input["BIZR_TP_CD"] =$("#BIZR_TP_CD").val();
			ajaxPost(url, input, function(rtnData) {
				if ("" != rtnData && null != rtnData) {   
					 whsdlList_return = rtnData.whsdlList;
					 kora.common.setEtcCmBx2(rtnData.brch_nmList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');	 			//직매장/공장
					 kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');	//도매업자 업체명
				}else{
						 alertMsg("error");
				}
			},false);
		}else{
			 kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');							//직매장/공장
			 kora.common.setEtcCmBx2(whsl_se_cdList, "","", $("#BIZR_TP_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');					//도매업자 구분
			 kora.common.setEtcCmBx2(whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');	//도매업자 업체명
		}
   }
   //직매장/공장 변경시  생산자랑 거래 중인 도매업자 업체명 조회
   function fn_mfc_brch_nm(){
		var url = "/CE/EPCE2910101_192.do" 
		var input ={};
		$("#WHSDL_BIZRNM").select2("val","");
		if($("#MFC_BIZRNM").val() !=""){
			arr2	= [];
			arr2	= $("#MFC_BRCH_NM").val().split(";");
			input["MFC_BIZRID"]			= arr[0];  //직매장별거래처관리 테이블에서 생산자
			input["MFC_BIZRNO"]		= arr[1];
			input["MFC_BRCH_ID"]		= arr2[0];
			input["MFC_BRCH_NO"]	= arr2[1];
			input["BIZR_TP_CD"] 		=$("#BIZR_TP_CD").val();
			ajaxPost(url, input, function(rtnData) {
				if ("" != rtnData && null != rtnData) {   
						whsdlList_return = rtnData.whsdlList;
	   					kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');	//도매업자 업체명
	   			}else{
	   					alertMsg("error");
				}
			},false);
		}else{
			 kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');							//직매장/공장
			 kora.common.setEtcCmBx2(whsl_se_cdList, "","", $("#BIZR_TP_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');					//도매업자 구분
			 if(whsdlList_return.length>0){
	  				kora.common.setEtcCmBx2(whsdlList_return, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');	 //한건이라도 업체명 조회시 전체
  			 }else{
  				kora.common.setEtcCmBx2(whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');		 	//업체명 따로 조회한적 없을경우
  			 }
		}
   }
   
 	//도매업자구분 변경시 도매업자 조회 ,생산자가 선택됐을경우 거래중인 도매업자만 조회
   function fn_bizr_tp_cd(){
  		var url = "/CE/EPCE2910101_192.do" 
		var input ={};
  		$("#WHSDL_BIZRNM").select2("val","");
  		if($("#BIZR_TP_CD").val() !=""){ //선택
			//생산자 선택시 선택된 생산자랑 거래중인 도매업자 조회
			if( $("#MFC_BIZRNM").val() !="" ){
					arr	 =[];
					arr	 = $("#MFC_BIZRNM").val().split(";");
	  				input["MFC_BIZRID"]		= arr[0];
	  				input["MFC_BIZRNO"]	= arr[1];
	  				//생산자 + 직매장 선택시 거래중이 도매업자 조회
	  				if($("#MFC_BRCH_NM").val() !="" ){
			  				arr2	= [];
			  				arr2	= $("#MFC_BRCH_NM").val().split(";");
	 				 	    input["MFC_BRCH_ID"]		= arr2[0];
	 		    			input["MFC_BRCH_NO"]	= arr2[1];
	  				}
			}
			input["BIZR_TP_CD"] =$("#BIZR_TP_CD").val();
	     	ajaxPost(url, input, function(rtnData) {
	  				if ("" != rtnData && null != rtnData) {  
	  					 	kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');		 //업체명
	  				}else{
	  						 alertMsg("error");
	  				}
	  		},false);
  		}else{ //전체
  			if(whsdlList_return.length>0){
  				kora.common.setEtcCmBx2(whsdlList_return, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');	 //한건이라도 업체명 조회시 전체
  			}else{
  				kora.common.setEtcCmBx2(whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');		 	//업체명 따로 조회한적 없을경우
  			}
  		}
   }
   
  
   //수기입고정정  조회
    function fn_sel(){
		 var input	={};
		 var url = "/CE/EPCE4705601_193.do" 
		 if(!kora.common.cfrmDivChkValid("divInput")) {
			return;
		 }
		 if($("#MFC_BIZRNM").val() !="" ){ //생산자
			 arr =[];
			 arr = $("#MFC_BIZRNM").val().split(";");
			 input["MFC_BIZRID"]   	= arr[0];
			 input["MFC_BIZRNO"]  	= arr[1];
		 }
		 if($("#MFC_BRCH_NM").val() !="" ){ //직매장/공장
			 arr2 = [];
			 arr2 = $("#MFC_BRCH_NM").val().split(";");
			 input["MFC_BRCH_ID"]   	= arr2[0];
			 input["MFC_BRCH_NO"]  	= arr2[1];
		 }
		 if($("#WHSDL_BIZRNM").val() !="" ){ //도매업자
			 arr3 =[];
			 arr3 = $("#WHSDL_BIZRNM").val().split(";");
			 input["WHSDL_BIZRID"]   	= arr3[0];
			 input["WHSDL_BIZRNO"] 	= arr3[1];
		 }
		 
	 	 arr4	 = [];										//정산기간
 		 arr4	 = $("#EXCA_STD_CD_SE").val().split(";");
		 input["EXCA_STD_CD"]		=  arr4[0];
		 input["EXCA_TRGT_SE"]		=  arr4[1];
		 
		 input["WRHS_CRCT_STAT_CD"] 	= $("#WRHS_CRCT_STAT_CD").val();	//상태
		 input["BIZR_TP_CD"]   				= $("#BIZR_TP_CD").val();				//도매업자 구분
		 
		 input["MFC_BIZRNM_RETURN"] = JSON.stringify(mfc_bizrnm_return);	//정산기간 내 생산자
		 //상세갔다가 올때 SELECT박스 값---------------------
		 input["MFC_BIZRNM"] 			= $("#MFC_BIZRNM").val(); 
		 input["MFC_BRCH_NM"] 		= $("#MFC_BRCH_NM").val();
		 input["WHSDL_BIZRNM"] 		= $("#WHSDL_BIZRNM").val();
		 input["EXCA_STD_CD_SE"]		= $("#EXCA_STD_CD_SE").val();
		 //---------------------------------------------------------
		 
		/* 페이징  */
		input["ROWS_PER_PAGE"] = gridRowsPerPage;
		input["CURRENT_PAGE"] 	= gridCurrentPage;
			
		INQ_PARAMS["SEL_PARAMS"] = input;
		showLoadingBar();
      	ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {   
   					gridApp.setData(rtnData.selList);
   					/* 페이징 표시 */
					gridTotalRowCount = parseInt(rtnData.totalList[0].CNT); //총 카운트 	/* 총합계 추가 */
					drawGridPagingNavigation(gridCurrentPage);
					
					sumData = rtnData.totalList[0]; /* 총합계 추가 */
					
   				}else{
   					alertMsg("error");
   				}
   		 hideLoadingBar(); 
   		 });
    }
   
    /* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel(); //조회 펑션
	}
	
	//정정확인 ,정정반려, 확인취소 클릭 이벤트
	function fn_upd_chk(data) {
		
		var alertMessage = "";	
		var selectorColumn = gridRoot.getObjectById("selector");
		
		var chkLst = selectorColumn.getSelectedItems();
		if(chkLst.length < 1){
			alertMsg("선택된 행이 없습니다.");
			return;
		}
		
		 for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			    if(data=="1"){
			    	if(item.MNUL_EXCA_SE == 'R') { //재정산등록
				    	if(	item.WRHS_CRCT_STAT_CD !="W"){ //상호확인이 아닐경우
				    		alertMsg("정정확인은 상호확인 상태인 자료만 요청가능합니다.\n\n다시 한 번 확인하시기 바랍니다.");
							return;
				    	}
			    	}
			    	else { //재정산등록이 아닐경우
				    	if(	item.WRHS_CRCT_STAT_CD !="R"){
					    	alertMsg("정정확인은 정정등록 상태인 자료만 요청가능합니다.\n\n다시 한 번 확인하시기 바랍니다.");
							return;
				    	}
			    	}
			    }else if(data=="2"){
			    	if(item.MNUL_EXCA_SE == 'R') { //재정산등록
				    	if(	item.WRHS_CRCT_STAT_CD !="W"){ //상호확인이 아닐경우
				    		alertMsg("정정반려는 상호확인 상태인 자료만 요청가능합니다.\n\n다시 한 번 확인하시기 바랍니다.");
							return;
				    	}
			    	}
			    	else { //재정산등록이 아닐경우
				    	if(	item.WRHS_CRCT_STAT_CD !="R"){
				    		alertMsg("정정반려는 정정등록 상태인 자료만 요청가능합니다.\n\n다시 한 번 확인하시기 바랍니다.");
							return;
				    	}
			    	}
			    }else if(data=="3"){
			    	if(	item.WRHS_CRCT_STAT_CD !="C"){
				    	alertMsg("확인취소는 정정확인 상태인 자료만 요청가능합니다.\n\n다시 한 번 확인하시기 바랍니다.");
						return;
			    	}
			    }
		 }
	    
	    if(data=="1"){
	    	alertMessage = "선택하신 수기입고정정내역이 모두 정정확인 상태로 변경됩니다.\n\n계속 진행하시겠습니까?";
	    }else if(data=="2"){
	    	alertMessage = "선택하신 수기입고정정내역이 모두 정정반려 상태로 변경됩니다.\n\n계속 진행하시겠습니까?";
	    }else if(data=="3"){
	    	alertMessage = "선택하신 정정확인 내역이 모두 확인취소 됩니다.\n\n계속 진행하시겠습니까?";
	    }
	    btn_upd_val = data//css때문에 value값 넘기지 못해서 전역형으로..값 넘기기
		confirm(alertMessage,"fn_upd");
	}
	
	//정정확인 ,정정반려, 확인취소 상태변경
	function fn_upd(){
		var selectorColumn = gridRoot.getObjectById("selector");
		var input 		= {"list": ""};
		var row 			= new Array();
		var url 			="/CE/EPCE4705601_21.do";
		var stat			="";		//변경할 상태값
		var stat_chk	="";		//변경전 상태값 확인
		
		if(btn_upd_val=="1"){		//정정확인
			stat="C";
			stat_chk="R";
			stat_chk2="W";
	    }else if(btn_upd_val=="2"){//정정반려
	    	stat="T";
	    	stat_chk2="W";
	    }else if(btn_upd_val=="3"){//확인취소  정정등록로 변경
	    	stat="R";
	    	stat_chk="C";
	    	stat_chk2="C";
	    }
		for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				item.WRHS_CRCT_STAT_CD = stat;
				item.WRHS_CRCT_STAT_CD_CHK = stat_chk;
				item.WRHS_CRCT_STAT_CD_CHK2 = stat_chk2;
				item.STAT_CD_CHK = "1";
				row.push(item);
		 }
	    input["list"] = JSON.stringify(row);

	 	ajaxPost(url, input, function(rtnData){
			if(rtnData.RSLT_CD == "0000"){
				alertMsg(rtnData.RSLT_MSG, 'fn_sel');
			}else{
				alertMsg(rtnData.RSLT_MSG);
			}

		});     
	}	
	
	//상세조회
	function dtl_link(data){
		var idx = dataGrid.getSelectedIndices();
		var input = gridRoot.getItemAt(idx);
		var url = "/CE/EPCE29164642.do"; //입고정보상세조회
		if(data == '2'){
			url = "/CE/EPCE4705664.do";	 //수기입고정정내역조회
		}
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["PARAMS"] = {};
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE4705601.do";
		kora.common.goPage(url, INQ_PARAMS);
	}
	
	function  fn_data_chk(){
		 arr4	 = [];										//정산기간
 		 arr4	 = $("#EXCA_STD_CD_SE").val().split(";");
		var dt_check  =false;
		for(var i=0; i<std_mgnt_list.length;i++){
			 if(std_mgnt_list[i].EXCA_STD_CD == arr4[0]){							//정산기간코드에서
				 if(std_mgnt_list[i].EXCA_STAT_CD =="S"){							//처리상태가 진행인놈중
					 if(std_mgnt_list[i].CRCT_PSBL_ST_DT<= toDay ){     			//시작날짜가 오늘날짜보다 작거나 같고
						 if(std_mgnt_list[i].CRCT_PSBL_END_DT >= toDay ){ 		//끝날짜가 오늘날짜보다 크거나 같을경우에만
							 dt_check = true;						 							//가능
						 }
					 }
				 }
			  break;
			 }
		}	
		
		if(!dt_check){
			alertMsg("정정가능기간이 아닙니다.");
			return false;
		}
	}
	
	// 수정 페이지 이동
	function fn_page(){
	    	var selectorColumn = gridRoot.getObjectById("selector");
			var input = {};
			 if(!kora.common.cfrmDivChkValid("divInput")) {
				return;
		    }else if(fn_data_chk() ==false){  
				return; 
			}else if(selectorColumn.getSelectedIndices() == "") {
				alertMsg("선택한 건이 없습니다.");
				return;
			}else if(selectorColumn.getSelectedIndices().length >1) {
				alertMsg("한건만 선택이 가능합니다.");
				return;
			}
			 
			input = gridRoot.getItemAt(selectorColumn.getSelectedIndices());	
			var stat_cd =  input["WRHS_CRCT_STAT_CD"];
			if(stat_cd !="R" && stat_cd !="T" ){
				alertMsg("정정 등록, 정정 반려 상태인경우에만 등록변경이 가능합니다. \n\n 다시 한 번 확인하시기 바랍니다");
				return;
			}
			
			var url = '';
			if(input["MNUL_EXCA_SE"] == 'M'){ //수기등록
				url = '/CE/EPCE47056422.do';
			}else{
				url = '/CE/EPCE4705642.do';
			}
			
			//정산기간명
			input["EXCA_STD_CD_NM"] = $('#EXCA_STD_CD_SE option:selected').text();
			
			INQ_PARAMS["PARAMS"] = {}
			INQ_PARAMS["PARAMS"] = input;			
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE4705601.do";
			INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
			kora.common.goPage(url, INQ_PARAMS); 
	}
	
    //입고정정이월
    function fn_forwd_chk() {
        var alertMessage = "";  
        var selectorColumn = gridRoot.getObjectById("selector");
        var input       = {"list": ""};
        var row         = new Array();
        var url         = "/CE/EPCE4738701_195.do";
        
        var chkLst = selectorColumn.getSelectedItems();
        if(chkLst.length < 1){
            alertMsg("선택된 행이 없습니다.");
            return;
        }
        
        for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
            var item = {};
            item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
            
            if(item.MNUL_EXCA_SE !="R"){
                alertMsg("이월가능건이 아닙니다.\n\n재정산등록 건만 이월처리 가능합니다.");
                return;
            }

            row.push(item);
        }
        
        input["list"] = JSON.stringify(row);
        
        ajaxPost(url, input, function(rtnData){
            if(rtnData.RSLT_CD == "0000"){
               excaData = rtnData;
               confirm("선택하신 수기입고정정내역이 모두 ["+rtnData.EXCA_STD_NM +"] 으로 이월처리 됩니다.\n\n계속 진행하시겠습니까?" ,"fn_forwd");  
            }else{
                alertMsg(rtnData.RSLT_MSG);
            }
        });         
    }
    
    function fn_forwd() {
        var selectorColumn = gridRoot.getObjectById("selector");
        var input       = {"list": ""};
        var row         = new Array();
        var url         = "/CE/EPCE4738701_212.do";
        var excaStdCd   = excaData.EXCA_STD_CD; //변경할 정산기준코드
        
        for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
            var item = {};
            item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
            item.NEW_EXCA_STD_CD = excaStdCd;
            item.WRHS_CRCT_DOC_NO = item.WRHS_CRCT_DOC_NO_RE;
            row.push(item);
        }
        
        input["list"] = JSON.stringify(row);

        ajaxPost(url, input, function(rtnData){
            if(rtnData.RSLT_CD == "0000"){
                alertMsg(rtnData.RSLT_MSG, 'fn_sel');
            }else{
                alertMsg(rtnData.RSLT_MSG);
            }
        });         
    }

	//수기정산등록, 등록 페이지  이동
	function fn_page2(data){
		
		var url ="";
		var input = {};
		var row = new Array();
		var chkCnt = 1;
		
		//진행중인 정산기간 여부 체크
		ajaxPost("/CE/EPCE4705601_195.do", {}, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {   
   					chkCnt = rtnData.chkCnt;
   					if(rtnData.chkCnt == 0){
   						alertMsg("진행중인 정산기간이 존재하지 않습니다.");
   					}else if(rtnData.chkCnt > 1){
   						alertMsg("진행중인 정산기간이 두개이상 존재합니다.");
   					}
   				}else{
   					alertMsg("error");
   				}
   		 }, false);
		
		if(chkCnt != 1){
			return;
		}
		
		
		if(data =="AR"){
			url = "/CE/EPCE47056312.do"; //수기정산등록 페이지 이동
		}else{
			url = "/CE/EPCE47056642.do"; //정정건재등록 페이지 이동
		}
		
		input["EXCA_STD_CD"]  			= arr4[0];	//정산기간코드
		input["EXCA_TRGT_SE"]  			= arr4[1];	//정산대상구분
		input["EXCA_STD_CD_SE"] = $("#EXCA_STD_CD_SE").val();
		INQ_PARAMS["EXCA_PARAM"]  	= input;
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE4705601.do";
		INQ_PARAMS["FN_CALLBACK"]   = "fn_sel";
		kora.common.goPage(url, INQ_PARAMS);
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
		var now  		= new Date(); 				     		// 현재시간 가져오기
		var hour 		= new String(now.getHours());   	// 시간 가져오기
		var min  		= new String(now.getMinutes());	// 분 가져오기
		var sec  		= new String(now.getSeconds());// 초 가져오기
		var today 		= kora.common.gfn_toDay();
		var fileName 	= $('#title_sub').text() +"_" + today+hour+min+sec+".xlsx";
		
		//그룹헤더용
        var groupList = dataGrid.getGroupedColumns();
        var groupCntTot = 0;
        var groupCnt = 0;
        
		//그리드 컬럼목록 저장
		var col = new Array();
		var columns = dataGrid.getColumns();
		for(i=0; i<columns.length; i++){
			if(columns[i].getDataField() != undefined && columns[i].getDataField() != 'index'){ //순번 제외
				var item = {};

				//그룹헤더용
                if(groupCnt > 0){
                    item['groupHeader']  = '';
                    groupCnt--;
                }else{
                    item['groupHeader'] = groupList[i-groupCntTot].getHeaderText();
                    if(groupList[i-groupCntTot].children != null && groupList[i-groupCntTot].children.length > 0){
                        groupCnt = groupList[i-groupCntTot].children.length;
                        groupCnt--;
                        groupCntTot += (groupList[i-groupCntTot].children.length - 1);
                    }
                }
                //그룹헤더용
                
				item['headerText'] = columns[i].getHeaderText();
				
				if(columns[i].getDataField() == 'WRHS_CRCT_STAT_CD_NM'){// html 태크 사용중 컬럼은 대체
					item['dataField'] = 'WRHS_CRCT_STAT_CD_NM_ORI';  
				}else if(columns[i].getDataField() == 'WRHS_CFM_DT'){
					item['dataField'] = 'WRHS_CFM_DT_ORI';  
				}else{
					item['dataField'] = columns[i].getDataField();
				}
			
				item['textAlign'] = columns[i].getStyle('textAlign');
				item['id'] = kora.common.null2void(columns[i].id);
				col.push(item);
			}
		}
		
		var input 			= INQ_PARAMS["SEL_PARAMS"];
		var url 				= "/CE/EPCE4705601_05.do"; 
		input['excelYn'] 	= 'Y';	//엑셀 저장시 모든 검색이 필요해서
		input['fileName'] 	= fileName;
		input['columns'] 	= JSON.stringify(col);
		showLoadingBar()
 		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
				alertMsg(rtnData.RSLT_MSG);
			}else{
				//파일다운로드
				frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
				frm.fileName.value = fileName;
				frm.submit();
			}
 			hideLoadingBar();
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
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" sortableColumns="true"  horizontalScrollPolicy="on" headerHeight="35">');
			layoutStr.push('		<groupedColumns>');   	
			layoutStr.push('			<DataGridSelectorColumn id="selector"	 		 width="40"	textAlign="center" allowMultipleSelection="true" vertical-align="middle"  />');															//선택 
			layoutStr.push('			<DataGridColumn dataField="PNO" 				 				headerText="'+ parent.fn_text('sn')+ '" 				width="50"    textAlign="center"  />');												//순번
			layoutStr.push('			<DataGridColumn dataField="WRHS_CFM_DT" 				headerText="'+ parent.fn_text('crct_wrhs_dt')+ '"	width="120"  textAlign="center"   itemRenderer="HtmlItem" />');			//정정입고확인일자
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRNM"			 	headerText="'+ parent.fn_text('whsdl')+ '"  			width="130"  textAlign="center"  />'); 												//도매업자명
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRNO" 				headerText="'+parent.fn_text('bizrno')+ '"  			width="110"  formatter="{maskfmt1}" textAlign="center" />');	 //도매업자 사업자 번호
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM" 					headerText="'+ parent.fn_text('mfc_bizrnm')+ '"  	width="100"  textAlign="center" />');													//생산자명
			layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_NM"   				headerText="'+ parent.fn_text('mfc_brch_nm')+ '" width="100"  textAlign="center" />');													//생산자  직매장
			layoutStr.push('			<DataGridColumnGroup  														headerText="'+ parent.fn_text('reg_info')+ '">');
			layoutStr.push('				<DataGridColumn dataField="CRCT_QTY_TOT" 					headerText="'+ parent.fn_text('wrhs_qty')+ '"	width="80"	formatter="{numfmt}" id="num1" textAlign="right" />');	//입고량
			layoutStr.push('				<DataGridColumn dataField="CRCT_GTN_TOT" 		  			headerText="'+ parent.fn_text('dps2')+ '" 	width="110"   formatter="{numfmt}" id="num2" textAlign="right" />');	//보증금
			layoutStr.push('				<DataGridColumn dataField="CRCT_FEE_TOT" 					headerText="'+ parent.fn_text('fee')+ '" 	width="110" 	formatter="{numfmt1}" id="num3" textAlign="right" />');	//도매수수료
			layoutStr.push('				<DataGridColumn dataField="CRCT_WHSL_FEE_STAX_TOT" 	headerText="'+ parent.fn_text('stax')+ '" 	width="110" 	formatter="{numfmt}" id="num4" textAlign="right" />');	//부가세
			layoutStr.push('				<DataGridColumn dataField="CRCT_AMT" 	 						headerText="'+ parent.fn_text('amt')+ '" 	width="100" 	formatter="{numfmt}" id="num5" textAlign="right" />');	//금액
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumnGroup  														headerText="'+ parent.fn_text('crct_reg')+ '">');
			layoutStr.push('				<DataGridColumn dataField="CRCT_QTY_TOT2" 					headerText="'+ parent.fn_text('wrhs_qty')+ '"	width="80" 	formatter="{numfmt}" id="num6"   textAlign="right" />'); //입고량
			layoutStr.push('				<DataGridColumn dataField="CRCT_GTN_TOT2" 		  			headerText="'+ parent.fn_text('dps2')+ '" 		width="110" 	formatter="{numfmt}" id="num7" 	textAlign="right" />');	//보증금
			layoutStr.push('				<DataGridColumn dataField="CRCT_FEE_TOT2" 					headerText="'+ parent.fn_text('fee')+ '" 	width="110" 	formatter="{numfmt1}" id="num8" textAlign="right" />'); //도매수수료
			layoutStr.push('				<DataGridColumn dataField="CRCT_WHSL_FEE_STAX_TOT2" headerText="'+ parent.fn_text('stax')+ '" 	width="110" 	formatter="{numfmt}" id="num9" textAlign="right" />'); //도매부가세
			layoutStr.push('				<DataGridColumn dataField="CRCT_AMT2" 	 						headerText="'+ parent.fn_text('amt')+ '" 	width="100" 	formatter="{numfmt}" id="num10" textAlign="right" />'); //금액
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumn dataField="WRHS_CRCT_STAT_CD_NM"		headerText="'+ parent.fn_text('stat')+ '" 	width="100" id="tmp1" textAlign="center"   itemRenderer="HtmlItem"/>'); 		//상태
			layoutStr.push('			<DataGridColumn dataField="MNUL_EXCA_SE_NM"   			headerText="'+ parent.fn_text('se')+ '" 		width="80"  id="tmp2" textAlign="center"  />');												//생산자  직매장
			
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
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt1}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt1}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt1}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num8}" formatter="{numfmt}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num9}" formatter="{numfmt}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num10}" formatter="{numfmt1}" textAlign="right"/>');  
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp1}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp2}"/>');
            layoutStr.push('            </DataGridFooter>');
            layoutStr.push('            <DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">'); /* 총합계 추가 */
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn label="총합계" textAlign="center"/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum1"  formatter="{numfmt}"   dataColumn="{num1}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum2"  formatter="{numfmt}"   dataColumn="{num2}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum3"  formatter="{numfmt1}"  dataColumn="{num3}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum4"  formatter="{numfmt1}"  dataColumn="{num4}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum5"  formatter="{numfmt1}"  dataColumn="{num5}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum6"  formatter="{numfmt}"   dataColumn="{num6}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum7"  formatter="{numfmt}"   dataColumn="{num7}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum8"  formatter="{numfmt}"   dataColumn="{num8}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum9"  formatter="{numfmt}"   dataColumn="{num9}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum10"  formatter="{numfmt1}" dataColumn="{num10}" textAlign="right"/>');   
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp1}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp2}"/>');
			layoutStr.push('			</DataGridFooter>'); /* 총합계 추가 */
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
			 	//취약점점검 5922 기원우
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
	
	/* 총합계 추가 */
	function totalsum1(column, data) {
		if(sumData) 
			return sumData.CRCT_QTY_TOT; 
		else 
			return 0;
	}
	
	function totalsum2(column, data) {
		if(sumData) 
			return sumData.CRCT_GTN_TOT; 
		else 
			return 0;
	}
	
	function totalsum3(column, data) {
		if(sumData) 
			return sumData.CRCT_FEE_TOT; 
		else 
			return 0;
	}
	
	function totalsum4(column, data) {
		if(sumData) 
			return sumData.CRCT_WHSL_FEE_STAX_TOT; 
		else 
			return 0;
	}
	
	function totalsum5(column, data) {
		if(sumData) 
			return sumData.CRCT_AMT; 
		else 
			return 0;
	}
	
	function totalsum6(column, data) {
		if(sumData) 
			return sumData.CRCT_QTY_TOT2; 
		else 
			return 0;
	}
	function totalsum7(column, data) {
		if(sumData) 
			return sumData.CRCT_GTN_TOT2; 
		else 
			return 0;
	}
	
	function totalsum8(column, data) {
		if(sumData) 
			return sumData.CRCT_FEE_TOT2; 
		else 
			return 0;
	}
	
	function totalsum9(column, data) {
		if(sumData) 
			return sumData.CRCT_WHSL_FEE_STAX_TOT2; 
		else 
			return 0;
	}
	
	function totalsum10(column, data) {
		if(sumData) 
			return sumData.CRCT_AMT2; 
		else 
			return 0;
	}
	
	/* 총합계 추가 */
	
/****************************************** 그리드 셋팅 끝***************************************** */


</script>

<style type="text/css">
	.row .tit{width: 82px;}
</style>

</head>
<body>
    <div class="iframe_inner" >
       		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="std_mgnt_list" value="<c:out value='${std_mgnt_list}' />" />
			<input type="hidden" id="stat_cdList" value="<c:out value='${stat_cdList}' />" />
			<input type="hidden" id="whsl_se_cdList" value="<c:out value='${whsl_se_cdList}' />" />
			<input type="hidden" id="whsdlList" value="<c:out value='${whsdlList}' />" />
			<input type="hidden" id="mfc_bizrnmList" value="<c:out value='${mfc_bizrnmList}' />" />
			<input type="hidden" id="brch_nmList" value="<c:out value='${brch_nmList}' />" />
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
				<div class="btn" style="float:right" id="UR"><!--btn_dwnd  -->
				<!--btn_excel  -->
				</div>
			</div>
			<section class="secwrap"  id="params">
				<div class="srcharea" id="divInput"> 
					<div class="row" >
						<div class="col"  >
							<div class="tit" id="exca_term"></div><!--정산기간-->
							<div class="box">
								<select  id=EXCA_STD_CD_SE style="width: 200px" class="i_notnull"></select>
							</div>
						</div>
						<div class="col" >
							<div class="tit" id="mfc_bizrnm"></div>  <!--반환대상생산자-->
							<div class="box">
								<select   id="MFC_BIZRNM" style="width: 200px" ></select>
							</div>
						</div>
					    <div class="col"  style=""  >
							<div class="tit" id="mfc_brch_nm"></div>  <!-- 반환대상 직매장/공장 -->
							<div class="box">
								<select   id="MFC_BRCH_NM" style="width: 200px" ></select>
							</div>
						</div>
					</div> <!-- end of row -->
					<div class="row">
							<div class="col"    style="">
								<div class="tit" id="whsl_se_cd"></div>  <!-- 도매업자구분 -->
								<div class="box"  >
									  <select  id="BIZR_TP_CD" name="BIZR_TP_CD" style="width: 200px"></select>
								</div>
							</div>
							<div class="col"  >
								<div class="tit" id="whsdl"></div>  <!-- 도매업자업체명 -->
								<div class="box"  >
									  <select  id="WHSDL_BIZRNM" name="WHSDL_BIZRNM" style="width: 200px"></select>
								</div>
							</div>
							<div class="col"  >
								<div class="tit" id="stat"></div><!--상태-->
								<div class="box">
									<select c id=WRHS_CRCT_STAT_CD style="width: 200px"></select>
								</div>
							</div>
							<div class="btn" id="CR">
							</div>
					</div> <!-- end of row -->
				</div>  <!-- end of srcharea -->
			</section>

			<div class="boxarea mt10">  <!-- 634 -->
				<div id="gridHolder" style="height: 640px; background: #FFF;"></div>
			   	<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
			</div>	<!-- 그리드 셋팅 -->
			<section class="btnwrap" style="height:50px" >
					<div class="btn" id="BL"></div>
					<div class="btn" style="float:right" id="BR"></div>
			</section>
			
			<form name="frm" action="/jsp/file_down.jsp" method="post">
				<input type="hidden" name="fileName" value="" />
				<input type="hidden" name="saveFileName" value="" />
				<input type="hidden" name="downDiv" value="excel" />
			</form>
	</div>
</body>
</html>