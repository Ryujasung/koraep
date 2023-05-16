<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>  
<head>
<title>실태조사</title>
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
	
	 var INQ_PARAMS;	//파라미터 데이터
	 var dtList;				//반환등록일자구분
     var whsl_se_cdList;	//도매업자구분
     var mfc_bizrnmList;	//생산자
     var whsdlList;			//도매업자 업체명 조회
     var areaList;			//지역
     var sys_seList;		//등록구분
     var stat_cdList;		//상태
     var grid_info;			//그리드 컬럼 정보
	 var brch_nmList;		//직매장/공장
	 var dbClick = false; //더블클릭방지 변수
     
     var toDay = kora.common.gfn_toDay(); 			// 현재 시간
 	 var arr 	= new Array();									//생산자
	 var arr2 = new Array();
	 var arr3 = new Array();
	 var pagingCurrent = 1;
	 var parent_item;		//팝업창 오픈시 필드값
	 var sumData; //총합계
     $(function() {
    	 
    		INQ_PARAMS 		= jsonObject($("#INQ_PARAMS").val());		//파라미터 데이터
      		dtList 				= jsonObject($("#dtList").val());					//반환등록일자구분
      	    whsl_se_cdList 	= jsonObject($("#whsl_se_cdList").val());		//도매업자구분
      	    mfc_bizrnmList 	= jsonObject($("#mfc_bizrnmList").val());		//생산자
      	    whsdlList 			= jsonObject($("#whsdlList").val());				//도매업자 업체명 조회
      	    areaList 			= jsonObject($("#areaList").val());					//지역
      	    sys_seList 			= jsonObject($("#sys_seList").val());				//상태
      	    stat_cdList 		= jsonObject($("#stat_cdList").val());				//등록구분
      	    grid_info 			= jsonObject($("#grid_info").val());				//그리드 컬럼 정보
      	  	brch_nmList 		= jsonObject($("#brch_nmList").val());			//직매장
    	 
    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
    	 //그리드 셋팅
		 fnSetGrid1();
		
		//날짜 셋팅
		    $('#START_DT').YJcalendar({  
				toName : 'to',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
				
			});
			$('#END_DT').YJcalendar({
				fromName : 'from',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
			});
		
		//text 셋팅
		$('#title_sub').text('<c:out value="${titleSub}" />');						  									//타이틀
		$('#sel_term').text(parent.fn_text('sel_term'));																	//조회기간
		$('#stat').text(parent.fn_text('stat')); 																				//상태
		$('#mfc_bizrnm').text(parent.fn_text('mfc_bizrnm')); 														//반환대상생산자
		$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm')); 													//반환대상지점
		$('#rsrc_se').text(parent.fn_text('rsrc_se')); 																		//등록구분
		$('#whsl_se_cd').text(parent.fn_text('whsl_se_cd'));															//도매업자 구분
		$('#enp_nm').text(parent.fn_text('enp_nm'));																	//업체명
		$('#area').text(parent.fn_text('area')); 																			//지역
		
		//div필수값 alt
		 $("#START_DT").attr('alt',parent.fn_text('sel_term'));   
		 $("#END_DT").attr('alt',parent.fn_text('sel_term'));   
      
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
		$("#WHSL_SE_CD").change(function(){
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
		 * 입고내역서조정 클릭 이벤트
		 ***********************************/
		$("#btn_page").click(function(){
			fn_page();
		});
		
		/************************************
		 * 실태조사요청취소클릭 이벤트
		 ***********************************/
		$("#btn_upd").click(function(){
			fn_upd_chk();
		});
	
		/************************************
		 * 시작날짜  클릭시 - 삭제 변경 이벤트
		 ***********************************/
		$("#START_DT").click(function(){
			    var start_dt = $("#START_DT").val();
			     start_dt   =  start_dt.replace(/-/gi, "");
			     $("#START_DT").val(start_dt)
		});
		
		/************************************
		 * 시작날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		$("#START_DT").change(function(){
		     var start_dt = $("#START_DT").val();
		     start_dt   =  start_dt.replace(/-/gi, "");
			if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
		     $("#START_DT").val(start_dt) 
		});
		
		/************************************
		 * 끝날짜  클릭시 - 삭제  변경 이벤트
		 ***********************************/
		$("#END_DT").click(function(){
			    var end_dt = $("#END_DT").val();
			         end_dt  = end_dt.replace(/-/gi, "");
			     $("#END_DT").val(end_dt)
		});
		
		/************************************
		 * 끝날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		$("#END_DT").change(function(){
		     var end_dt  = $("#END_DT").val();
		           end_dt =  end_dt.replace(/-/gi, "");
			if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd")
		     $("#END_DT").val(end_dt) 
		});
		
		/************************************
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_excel").click(function() {
			fn_excel();
		 });
		
        /************************************
         * 실태조사표(도매) 버튼 클릭 이벤트
         ***********************************/
        $("#btn_doc_w").click(function() {
            fn_doc("W");
        });
        
        /************************************
         * 실태조사표(생산자) 버튼 클릭 이벤트
         ***********************************/
        $("#btn_doc_m").click(function() {
            fn_doc("M");
         });
        
  		fn_init();//초기 데이터 셋팅
  	
	});
     
     //초기화
     function fn_init(){
    	 
    		 kora.common.setEtcCmBx2(dtList, "","", $("#SEARCH_GBN"), "ETC_CD", "ETC_CD_NM", "N");										//조회기간 선택
	    	 kora.common.setEtcCmBx2(stat_cdList, "","", $("#RTN_STAT_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');							//상태
			 kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'T');					//생산자
			 kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'T');					//직매장/공장
			 kora.common.setEtcCmBx2(sys_seList, "","", $("#SYS_SE"), "ETC_CD", "ETC_CD_NM", "N",'T');										//등록구분
			 kora.common.setEtcCmBx2(whsl_se_cdList, "","", $("#WHSL_SE_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');						//도매업자구분 
			 kora.common.setEtcCmBx2(whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');		//도매업자 업체명
			 kora.common.setEtcCmBx2(areaList, "","", $("#AREA"), "ETC_CD", "ETC_CD_NM", "N" ,'T');											//지역
			 $("#START_DT").val(kora.common.getDate("yyyy-mm-dd", "D", -7, false));  															//일주일전 날짜 
			 $("#END_DT").val(kora.common.getDate("yyyy-mm-dd", "D", 0, false)); 																//현재 날짜
			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				if(brch_nmList !=null){
					 kora.common.setEtcCmBx2(brch_nmList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');	 //직매장/공장
				}
				kora.common.jsonToTable("params",INQ_PARAMS.SEL_PARAMS);
				/* 화면이동 페이징 셋팅 */
				gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
			}
	  		$("#WHSDL_BIZRNM").select2();// 업체명 자동완성
			    	
     }

     //도매업자구분 변경시 도매업자 조회 ,생산자가 선택됐을경우 거래중인 도매업자만 조회
     function fn_whsl_se_cd(){
    	var url = "/CE/EPCE2916401_193.do" 
		var input ={};
    	
		   if($("#WHSL_SE_CD").val() !=""){
		 	  input["BIZR_TP_CD"] =$("#WHSL_SE_CD").val();
		   }
		   //생산자 선택시 선택된 생산자랑 거래중인 도매업자 조회
		   if( $("#MFC_BIZRNM").val() !="" ){
    				input["MFC_BIZRID"]		= arr[0];
    				input["MFC_BIZRNO"]	= arr[1];
    				//생산자 + 직매장 선택시 거래중이 도매업자 조회
    				if($("#MFC_BRCH_NM").val() !="" ){
    				 	      input["MFC_BRCH_ID"]		= arr2[0];
    		    			  input["MFC_BRCH_NO"]		= arr2[1];
    				}
		   }
    					 $("#WHSDL_BIZRNM").select2("val","");
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
	  		var url = "/CE/EPCE2916401_19.do" 
			var input ={};
				 arr	 =[];
				 arr	 = $("#MFC_BIZRNM").val().split(";");
				 input["MFC_BIZRID"]		= arr[0];  //직매장별거래처관리 테이블에서 생산자
				 input["MFC_BIZRNO"]		= arr[1];
				 input["BIZRID"]				= arr[0];	//지점관리 테이블에서 사업자
				 input["BIZRNO"]				= arr[1];
			   if($("#WHSL_SE_CD").val() !=""){
				input["BIZR_TP_CD"] =$("#WHSL_SE_CD").val();
			   }
	       	   ajaxPost(url, input, function(rtnData) {
	    				if ("" != rtnData && null != rtnData) {   
	    					 kora.common.setEtcCmBx2(rtnData.brch_nmList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');	 			//직매장/공장
	    					 kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');	//도매업자 업체명
	    					$("#WHSDL_BIZRNM").select2("val","");
	    					 }else{
	    						 alertMsg("error");
	    				}
	    		});
   }
   //직매장/공장 변경시  생산자랑 거래 중인 도매업자 업체명 조회
   function fn_mfc_brch_nm(){
		var url = "/CE/EPCE2916401_192.do" 
			var input ={};
				 arr2	= [];
		 	     arr2	= $("#MFC_BRCH_NM").val().split(";");
				 input["MFC_BIZRID"]		= arr[0];  //직매장별거래처관리 테이블에서 생산자
				 input["MFC_BIZRNO"]		= arr[1];
		 	     input["MFC_BRCH_ID"]		= arr2[0];
   			  	 input["MFC_BRCH_NO"]	= arr2[1];
   		 	  	 if($("#WHSL_SE_CD").val() !=""){
   			 	 input["BIZR_TP_CD"]		=$("#WHSL_SE_CD").val();
   			  	 } 
	       	   ajaxPost(url, input, function(rtnData) {
	    				if ("" != rtnData && null != rtnData) {   
	    					 kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');	//도매업자 업체명
	    					$("#WHSDL_BIZRNM").select2("val","");
	    					 }else{
	    						 alertMsg("error");
	    				}
	    		});
   }
  
   //입고관리 조회
    function fn_sel(){
	 var input	={};
	 var url = "/CE/EPCE2916401_194.do" 
	 var start_dt 			= $("#START_DT").val();
	 var end_dt    			= $("#END_DT").val();
	 pagingCurrent = 1;
		     start_dt   =  start_dt.replace(/-/gi, "");
		     end_dt    =  end_dt.replace(/-/gi, "");
	
			//날짜 정합성 체크. 20160204
			if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
				alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
				return; 
			}
	     //	kora.common.fnDateCompare ()    종료일이 시작일 보다 작을때 false 를 체크 해보자
			if(start_dt>end_dt){
				alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
				return;
			} 
		 input["SEARCH_GBN"]   	= $("#SEARCH_GBN").val();	//날짜 구분 선택
		 input["START_DT"]			= $("#START_DT").val();			
		 input["END_DT"]				= $("#END_DT").val();			
		 input["RTN_STAT_CD"]   	= $("#RTN_STAT_CD").val();	//상태
		 input["SYS_SE"]				= $("#SYS_SE").val();				//실태조사구분
		 input["BIZR_TP_CD"]   		= $("#WHSL_SE_CD").val();		//도매업자 구분
		 input["AREA_CD"]   			= $("#AREA").val();			//지역
		 
		 if($("#MFC_BIZRNM").val() !="" ){		//생산자
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
		 	 arr3		=[];
			 arr3	= $("#WHSDL_BIZRNM").val().split(";");
			 input["WHSDL_BIZRID"]   	= arr3[0];
			 input["WHSDL_BIZRNO"] 	= arr3[1]; 
		 }
		 
		 //상세갔다가 올때 SELECT박스 값
		 input["MFC_BIZRNM"] 		= $("#MFC_BIZRNM").val(); 
		 input["MFC_BRCH_NM"] 	= $("#MFC_BRCH_NM").val();
		 input["WHSDL_BIZRNM"] 	= $("#WHSDL_BIZRNM").val();
		 input["WHSL_SE_CD"] 		= $("#WHSL_SE_CD").val();
		 input["AREA"]   				= $("#AREA").val();			
		 
		/* 페이징  */
		input["ROWS_PER_PAGE"] = gridRowsPerPage;
		input["CURRENT_PAGE"] 	= gridCurrentPage;
			
		//임시 실태조사
		input["ACRH_DOC_NO"]="";
		INQ_PARAMS["SEL_PARAMS"] = input;
// 		showLoadingBar();
$("#modal").show();
      	ajaxPost(url, input, function(rtnData) {
	  		if ("" != rtnData && null != rtnData) {   
	  			gridApp.setData(rtnData.selList);
	  			sumData = rtnData.totalList[0];

	  			/* 페이징 표시 */
	  			gridTotalRowCount = parseInt(sumData.CNT); //총 카운트
				drawGridPagingNavigation(gridCurrentPage);
	  		}else{
	  			alertMsg("error");
	  		}
	  		
// 	  		hideLoadingBar(); 
	  		$("#modal").hide();
   		});
    }
   
    /* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel(); //조회 펑션
	}

	//입고내역서조정  페이지 이동 
	function fn_page() {
		var selectorColumn = gridRoot.getObjectById("selector");
		var input = {};
		if(selectorColumn.getSelectedIndices() == "") {
			alertMsg("선택한 건이 없습니다.");
			return false;
		}
		if(selectorColumn.getSelectedIndices().length >1) {
			alertMsg("한건만 선택이 가능합니다.");
			return false;
		}
		input = gridRoot.getItemAt(selectorColumn.getSelectedIndices());
		var rtn_stat_cd =  input["RTN_STAT_CD"];
		 
		if(rtn_stat_cd!="CC" && rtn_stat_cd!="RR" && rtn_stat_cd!="SW" && rtn_stat_cd !="SM"){
			alertMsg("입고내역서 조정이 불가능한 자료입니다. 다시 한 번 확인하시기 바랍니다");
			return;
		}
		var url ='/CE/EPCE2983931_092.do'	//템프에 저장		
	 	ajaxPost(url, input, function(rtnData){
			if(rtnData.RSLT_CD != "0000"){
				alertMsg(rtnData.RSLT_MSG);
				return;
			}else if(rtnData.RSLT_CD == "0000"){
				//파라미터에 조회조건값 저장 
				INQ_PARAMS["PARAMS"] = {}
				INQ_PARAMS["PARAMS"] = input;			
				INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
				INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE2916401.do";
				kora.common.goPage('/CE/EPCE2916431.do', INQ_PARAMS);
			}
		});    
	}
	
	//실태조사요청 취소 확인
	function fn_upd_chk() {
		var selectorColumn = gridRoot.getObjectById("selector");
		var input = {};
		if(selectorColumn.getSelectedIndices() == "") {
			alertMsg("선택한 건이 없습니다.");
			return false;
		}
		 for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				//반환등록 ,입고조정 ,입고확인 상태만 가능
				if(item["RTN_STAT_CD"] !="SW" && item["RTN_STAT_CD"] !="SM"	&& item["RTN_STAT_CD"] !="RR"){     
					alertMsg("실태조사취소 처리가 불가능한 자료가 선택되었습니다. 다시 한 번 확인하시기 바랍니다");
					return;
				}
		 }
			confirm("선택하신 내역이 모두 실태조사 취소 처리됩니다. 계속 진행하시겠습니까?","fn_upd");
		
	}
	//실태조사요청 취소
	function fn_upd(){
		
		var selectorColumn = gridRoot.getObjectById("selector");
		var input = {"list": ""};
		var row = new Array();
		var url ="/CE/EPCE2916401_21.do";

		 for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(item);
		 }
	     input["list"] = JSON.stringify(row);
	     showLoadingBar()
		 ajaxPost(url, input, function(rtnData){
				if(rtnData.RSLT_CD == "0000"){
					fn_sel();
					alertMsg(rtnData.RSLT_MSG);
				}else{
					alertMsg(rtnData.RSLT_MSG);
				}
				hideLoadingBar();    
			});     
	    
		
	}	
	
	//상세조회
	function dtl_link(data){
		var idx = dataGrid.getSelectedIndices();
		var input = gridRoot.getItemAt(idx);
		var url = "/CE/EPCE2916464.do";
		if(data == '2'){
			url = "/CE/EPCE29164642.do";
		}
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["PARAMS"] = {};
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE2916401.do";
		kora.common.goPage(url, INQ_PARAMS);
	}
	
	 //증빙파일 , 조사요청정보 
	function link(data){
		var idx = dataGrid.getSelectedIndices();
		parent_item = gridRoot.getItemAt(idx);
		var pagedata = window.frameElement.name;
		var url = "/CE/EPCE29164883.do";		//실태조사요청정보

		if(data == '1'){
			url = "/CE/EPCE2916488.do";		//증빙파일등록
		}else if(data == '2'){
			url = "/CE/EPCE29164882.do";	//증빙파일조회
		}
		
		if(!dbClick) {
			dbClick = true;
	
			window.parent.NrvPub.AjaxPopup(url, pagedata);
			
            setTimeout(function(){
            	dbClick = false;
            },1000);
		}
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
		var fileName = $('#title_sub').text() +"_" + today+hour+min+sec+".xlsx";
		
		//그리드 컬럼목록 저장
		var col = new Array();
		var columns = dataGrid.getColumns();
		for(i=0; i<columns.length; i++){
			if(columns[i].getDataField() != undefined && columns[i].getDataField() != 'index'){ //순번 제외
				var item = {};
				item['headerText'] = columns[i].getHeaderText();
				
				if(columns[i].getDataField() == 'STAT_CD_NM'){// html 태크 사용중 컬럼은 대체
					item['dataField'] = 'STAT_CD_NM_ORI';  
				}else if(columns[i].getDataField() == 'ADD_FILE'){
					item['dataField'] = 'ADD_FILE_ORI';  
				}else if(columns[i].getDataField() == 'REQ_RSN'){
					item['dataField'] = 'REQ_RSN_ORI';  
				}else{
					item['dataField'] = columns[i].getDataField();
				}
				
				item['textAlign'] = columns[i].getStyle('textAlign');
				item['id'] = kora.common.null2void(columns[i].id);

				col.push(item);
			}
		}
		
		var input = INQ_PARAMS["SEL_PARAMS"];
		input['excelYn'] = 'Y';	//엑셀 저장시 모든 검색이 필요해서
		input['fileName'] = fileName;
		input['columns'] = JSON.stringify(col);
		var url = "/CE/EPCE2916401_05.do";
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
	

    //실태조사표작성  페이지 이동 
    function fn_doc(se) {
        var selectorColumn = gridRoot.getObjectById("selector");
        var input = {};
        
        if(selectorColumn.getSelectedIndices() == "") {
            alertMsg("선택한 건이 없습니다.");
            return false;
        }
        if(selectorColumn.getSelectedIndices().length >1) {
            alertMsg("한건만 선택이 가능합니다.");
            return false;
        }
        input = gridRoot.getItemAt(selectorColumn.getSelectedIndices());
        input["RSRC_DOC_KND"] = se;
        
        INQ_PARAMS["PARAMS"] = {}
        INQ_PARAMS["PARAMS"] = input;           
        INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
        INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE2916401.do";
        kora.common.goPage('/CE/EPCE29164312.do', INQ_PARAMS);
    }
    
    //실태조사표 상세 조회 
    function rsrc_doc_link(se){
        var idx = dataGrid.getSelectedIndices();
        var input = gridRoot.getItemAt(idx);
        
        input["RSRC_DOC_KND"] = se;
        INQ_PARAMS["PARAMS"] = {};
        INQ_PARAMS["PARAMS"] = input;
        INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
        INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE2916401.do";
        kora.common.goPage('/CE/EPCE29164313.do', INQ_PARAMS);
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
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true"  sortableColumns="true"  horizontalScrollPolicy="on"  headerHeight="35">');
			layoutStr.push('		<groupedColumns>');   	
			layoutStr.push('			<DataGridSelectorColumn id="selector"	 		 width="40"	textAlign="center" allowMultipleSelection="true" vertical-align="middle" draggable="false" />');																//선택 
			layoutStr.push('			<DataGridColumn dataField="PNO" 				 				headerText="'+ parent.fn_text('sn')+ '" textAlign="center" width="50"   draggable="false" />');													//순번
			layoutStr.push('			<DataGridColumn dataField="WRHS_CFM_DT" 				headerText="'+ parent.fn_text('wrhs_cfm_dt')+ '" width="100"  textAlign="center"   formatter="{datefmt2}"/>');	//입고확인일자
			layoutStr.push('			<DataGridColumn dataField="RTN_REG_DT"		 				headerText="'+ parent.fn_text('rtn_reg_dt')+ '"  textAlign="center" width="100"   formatter="{datefmt2}"/>'); 	//반환등록일자
			layoutStr.push('			<DataGridColumn dataField="RTN_DT"			 				headerText="'+ parent.fn_text('rtrvl_dt')+ '"  textAlign="center" width="90"   formatter="{datefmt2}"/>'); 			//반환일자
			layoutStr.push('			<DataGridColumn dataField="STAT_CD_NM"					headerText="'+ parent.fn_text('stat')+ '"  textAlign="center" width="100"    itemRenderer="HtmlItem"/>'); 		//상태
			layoutStr.push('			<DataGridColumn dataField="RTN_DOC_NO"					headerText="'+ parent.fn_text('rtn_doc_no')+ '"  textAlign="center" width="120"  />'); 									//반환문서번호
			layoutStr.push('			<DataGridColumn dataField="WRHS_DOC_NO"				headerText="'+ parent.fn_text('wrhs_doc_no')+ '"  textAlign="center" width="120"  />'); 								//입고문서번호
			layoutStr.push('			<DataGridColumn dataField="BIZR_TP_CD"						headerText="'+ parent.fn_text('se')+ '"  textAlign="center" width="70"  />'); 												//도매업자구분
			layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNM"			 		headerText="'+ parent.fn_text('whsdl')+ '"  textAlign="center" width="130"   />'); 											//도매업자
			layoutStr.push('			<DataGridColumn dataField="AREA_NM"			 				headerText="'+ parent.fn_text('area')+ '"  textAlign="center" width="80"   />'); 											//지역
			layoutStr.push('			<DataGridColumn dataField="RTN_QTY_TOT"			 		headerText="'+ parent.fn_text('rtn_qty2')+ '"  textAlign="right" width="80" formatter="{numfmt}"  id="num11"  />'); 		//반환량
			layoutStr.push('			<DataGridColumnGroup  												headerText="'+ parent.fn_text('wrhs_qty')+ '">');																															//입고량
			layoutStr.push('				<DataGridColumn dataField="FH_CFM_QTY_TOT" 		headerText="'+ parent.fn_text('fh_rtn_qty_tot')+ '" width="80" formatter="{numfmt}"  id="num1"  textAlign="right" />');		//가정용
			layoutStr.push('				<DataGridColumn dataField="FB_CFM_QTY_TOT" 		  	headerText="'+ parent.fn_text('fb_rtn_qty_tot')+ '" width="80" formatter="{numfmt}" id="num2" textAlign="right" />');		//유흥용
			layoutStr.push('				<DataGridColumn dataField="DRCT_CFM_QTY_TOT" 	headerText="'+ parent.fn_text('drct_rtn_qty_tot')+ '" width="110" formatter="{numfmt}" id="num3" textAlign="right" />');	//직접
			layoutStr.push('				<DataGridColumn dataField="CFM_QTY_TOT" 	 			headerText="'+ parent.fn_text('total')+ '" width="100" formatter="{numfmt}" id="num4" textAlign="right" />');					//소계
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumn dataField="CFM_GTN_TOT"  				headerText="'+ parent.fn_text('dps2')+ '" width="100" formatter="{numfmt}" id="num5" textAlign="right" />');				//보증금
			layoutStr.push('			<DataGridColumn dataField="CFM_WHSL_FEE_TOT"  		headerText="'+ parent.fn_text('whsl_fee2')+ '" width="100" formatter="{numfmt1}" id="num6"  textAlign="right" />');		//도매수수료
			layoutStr.push('			<DataGridColumn dataField="CFM_RTL_FEE_TOT" 		 	headerText="'+ parent.fn_text('rtl_fee2')+ '" width="100" formatter="{numfmt1}" id="num8"  textAlign="right" />'); 		//소매수수료
			layoutStr.push('			<DataGridColumn dataField="CFM_WHSL_FEE_STAX_TOT" headerText="'+ parent.fn_text('stax')+ '" width="80" formatter="{numfmt}" id="num7"  textAlign="right" />');			//부가세
			layoutStr.push('			<DataGridColumn dataField="CFM_ATM_TOT"   				headerText="'+ parent.fn_text('amt_tot')+ '" width="120" formatter="{numfmt}" id="num10"  textAlign="right" />');		//금액합계
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM" 					headerText="'+ parent.fn_text('mfc_bizrnm')+ '"  	width="100" id="tmp1" textAlign="center" />');												//생산자
			layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_NM"   				headerText="'+ parent.fn_text('mfc_brch_nm')+ '" width="100" id="tmp2" textAlign="center" />');												//직매장
			layoutStr.push('			<DataGridColumn dataField="SYS_SE_NM" 						headerText="'+ parent.fn_text('reg_se')+ '" width="100" id="tmp3" textAlign="center" />');														//등록구분
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRNO" 				headerText="'+parent.fn_text('whsdl')+parent.fn_text('bizrno')+ '"  formatter="{maskfmt1}"   width="110" id="tmp4" textAlign="center" />');				//도매업자 사업자 번호
			layoutStr.push('			<DataGridColumn dataField="ADD_FILE" 						headerText="'+ parent.fn_text('prf_file')+ '" width="100" id="tmp5" textAlign="center"  itemRenderer="HtmlItem"/>');														//등록구분
			layoutStr.push('			<DataGridColumn dataField="REQ_RSN" 							headerText="'+parent.fn_text('rh_req_info')+ '"   width="70" id="tmp6" textAlign="center"  itemRenderer="HtmlItem"/>');				//도매업자 사업자 번호
            layoutStr.push('            <DataGridColumn dataField="RSRC_DOC_KND"                         headerText="'+parent.fn_text('rsrc_doc')+ '"   width="60" id="tmp7" textAlign="center"  itemRenderer="HtmlItem"/>');              //도매업자 사업자 번호
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn label="'+parent.fn_text('total')+'"  textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num11}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num8}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num10}" formatter="{numfmt}" textAlign="right"/>');	
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp1}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp2}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp3}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp4}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp5}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp6}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp7}"/>');
			layoutStr.push('			</DataGridFooter>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn label="'+parent.fn_text('totalsum')+'"  textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum1" formatter="{numfmt}" dataColumn="{num11}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum2" formatter="{numfmt}" dataColumn="{num1}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum3" formatter="{numfmt}" dataColumn="{num2}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum4" formatter="{numfmt}" dataColumn="{num3}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum5" formatter="{numfmt}" dataColumn="{num4}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum6" formatter="{numfmt}" dataColumn="{num5}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum7" formatter="{numfmt}" dataColumn="{num6}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum9" formatter="{numfmt}" dataColumn="{num8}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum8" formatter="{numfmt}" dataColumn="{num7}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum11" formatter="{numfmt}" dataColumn="{num10}" textAlign="right"/>'); 
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp1}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp2}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp3}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp4}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp5}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp6}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp7}"/>');
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
			
			/* ---------------드레그 컬럼 셋팅---------------------------------------------------------- */
			var columnLayout = null;
		
			if(grid_info.length>0) {
				for(var g=0;g<grid_info.length;g++){
						if(grid_info[g].GRID_ID =='dataGrid'){
							columnLayout = JSON.parse(grid_info[g].PRAM)
						}
				}
			}
			function checkValue(colLay, cols) {
				if ( colLay.headerText == cols.getDataField() || colLay.headerText == cols.getHeaderText() || colLay.headerText == cols.getDataField() )
					return true;
				else
					return false;
			}
			// 숨김 정보를 삽입하고 순서를 재정의합니다.
			if ( columnLayout ) {
				var newCol = [];
				var columns =  dataGrid.getGroupedColumns();
	
				//그리드정보가 일치하지 않으면 리턴
				if(columnLayout.length != columns.length){
					
				}else{
				
					for ( var j = 0  ; j < columnLayout.length ; j ++ ){
						for ( var i = 0  ; i < columns.length ; i++ ){
							// 그룹 컬럼일 경우
							if ( columns[i].children ) {
								var gCol = [];
								if ( checkValue( columnLayout[j], columns[i] ) ) {
								for ( var k = 0 ; k < columnLayout[j].children.length ; k++ ) {
									for ( var m = 0 ; m < columns[i].children.length ; m++ ) {
											if ( checkValue( columnLayout[j].children[k], columns[i].children[m] ) )
												gCol.push(columns[i].children[m]);
										}
									}
									columns[i].children = gCol;
									newCol[j] = columns[i];
									break;
								}
							} else if ( checkValue( columnLayout[j], columns[i] ) ) {
								newCol[j] = columns[i];
								break;
							}
						}
					}
					dataGrid.setGroupedColumns(newCol);
				}
			}
		/* ---------------------------------------------------------------------------------------- */
			
		  	 //파라미터 call back function 실행
			 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
			 	eval(INQ_PARAMS.FN_CALLBACK+"()");
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
	
	//반환량 합계
	function totalsum1(column, data) {
		if(sumData)
			return sumData.RTN_QTY_TOT;
		else
			return 0;
	}

	//입고량 가정용 합계
	function totalsum2(column, data) {
		if(sumData)
			return sumData.FH_CFM_QTY_TOT;
		else
			return 0;
	}

	//입고량 유흥용 합계
	function totalsum3(column, data) {
		if(sumData)
			return sumData.FB_CFM_QTY_TOT;
		else
			return 0;
	}

	//입고량 직접반환하는자 합계
	function totalsum4(column, data) {
		if(sumData)
			return sumData.DRCT_CFM_QTY_TOT;
		else
			return 0;
	}

	//입고량 소계 합계
	function totalsum5(column, data) {
		if(sumData)
			return sumData.CFM_QTY_TOT;
		else
			return 0;
	}

	//보증금 합계
	function totalsum6(column, data) {
		if(sumData)
			return sumData.CFM_GTN_TOT;
		else
			return 0;
	}

	//도매수수료 합계
	function totalsum7(column, data) {
		if(sumData)
			return sumData.CFM_WHSL_FEE_TOT;
		else
			return 0;
	}

	//도매수수료 부가세 합계
	function totalsum8(column, data) {
		if(sumData)
			return sumData.CFM_WHSL_FEE_STAX_TOT;
		else
			return 0;
	}

	//소매수수료 합계
	function totalsum9(column, data) {
		if(sumData)
			return sumData.CFM_RTL_FEE_TOT;
		else
			return 0;
	}

	//금액합계
	function totalsum11(column, data) {
		if(sumData)
			return sumData.CFM_ATM_TOT;
		else
			return 0;
	}

	
	
/****************************************** 그리드 셋팅 끝***************************************** */


</script>

<style type="text/css">

.srcharea .row .col{
width: 28%;
}  
.srcharea .row .col .tit{
width: 81px;
}
.srcharea .row .box {
    width: 60%
}
.srcharea .row .box  select, #s2id_WHSDL_BIZRNM{
    width: 100%
}
</style>

</head>
<body>

    <div class="iframe_inner" >
    		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="dtList" value="<c:out value='${dtList}' />" />
			<input type="hidden" id="whsl_se_cdList" value="<c:out value='${whsl_se_cdList}' />" />
			<input type="hidden" id="mfc_bizrnmList" value="<c:out value='${mfc_bizrnmList}' />" />
			<input type="hidden" id="whsdlList" value="<c:out value='${whsdlList}' />" />
			<input type="hidden" id="areaList" value="<c:out value='${areaList}' />" />
			<input type="hidden" id="sys_seList" value="<c:out value='${sys_seList}' />" />
			<input type="hidden" id="whsdlList" value="<c:out value='${whsdlList}' />" />
			<input type="hidden" id="stat_cdList" value="<c:out value='${stat_cdList}' />" />
			<input type="hidden" id="grid_info" value="<c:out value='${grid_info}' />" />
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
					<div class="col" style="width: 56%" >
						<div class="tit" id="sel_term"></div>	<!-- 조회기간 -->
						<div class="box" style="width: 80%">
							<select id="SEARCH_GBN"  style="width: 130px; margin-right: 10px"></select>
							<div class="calendar">
								<input type="text" id="START_DT" name="from" style="width: 140px;" class="i_notnull"><!--시작날짜  -->
							</div>
							<div class="obj">~</div>
							<div class="calendar">
								<input type="text" id="END_DT" name="to" style="width: 140px;"	class="i_notnull"><!-- 끝날짜 -->
							</div>
						</div>
					</div>

					<div class="col" style="margin-left: 21px;">
						<div class="tit" id="stat"></div><!--상태-->
						<div class="box">
							<select id=RTN_STAT_CD style=""></select>
						</div>
					</div>
				</div> <!-- end of row -->

				<div class="row">
						<div class="col">
							<div class="tit" id="mfc_bizrnm"></div>  <!--반환대상생산자-->
							<div class="box">
								<select id="MFC_BIZRNM" style="" ></select>
							</div>
						</div>
				
					    <div class="col">
							<div class="tit" id="mfc_brch_nm"></div>  <!-- 반환대상 직매장/공장 -->
							<div class="box">
								<select id="MFC_BRCH_NM" style="" ></select>
							</div>
						</div>
						
						<div class="col">
							<div class="tit" id="rsrc_se"></div>  <!-- 실태조사구분 -->
							<div class="box">
								<select id="SYS_SE" style="" ></select>
							</div>
						</div>
					</div> <!-- end of row -->
					
					<div class="row">
						<div class="col">
							<div class="tit" id="whsl_se_cd"></div>  <!-- 도매업자구분 -->
							<div class="box">
								<select id="WHSL_SE_CD"  style=""></select>
							</div>
						</div>
						
						<div class="col" ">
							<div class="tit" id="enp_nm"></div>  <!-- 도매업자업체명 -->
							<div class="box"  >
								  <select id="WHSDL_BIZRNM" name="WHSDL_BIZRNM" style=""></select>
							</div>
						</div>
						
						<div class="col">
							<div class="tit" id="area"></div>  <!-- 지역 -->
							<div class="box">
								<select id="AREA" style="" ></select>
							</div>
						</div>
					<div class="btn"  id="CR" ></div>
					</div> <!-- end of row -->
				</div>  <!-- end of srcharea -->
			</section>
			
		<section class="btnwrap mt10" >
			<div class="btn" id="GL"></div>
			<div class="btn" style="float:right" id="GR"></div>
		</section>
			<div class="boxarea mt10">  <!-- 668 -->
				<div id="gridHolder" style="height: 668px; background: #FFF;"></div>
			   	<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
				
			</div>	<!-- 그리드 셋팅 -->
		<section class="btnwrap" style="height:45px" >
				<div class="btn" id="BL"></div>
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