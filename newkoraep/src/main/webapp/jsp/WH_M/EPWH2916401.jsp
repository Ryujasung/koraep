<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>실태조사</title>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=1100, user-scalable=yes">
<meta name="description" content="사이트설명">
<meta name="keywords" content="사이트검색키워드">
<meta name="author" content="Newriver">
<meta property="og:title" content="공유제목">
<meta property="og:description" content="공유설명">
<meta property="og:image" content="공유이미지 800x400">

<%@include file="/jsp/include/common_page_m.jsp" %>

<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>

<script type="text/javaScript" language="javascript" defer="defer">

	/* 페이징 사용 등록 */
	gridRowsPerPage = 15;// 1페이지에서 보여줄 행 수
	gridCurrentPage = 1;// 현재 페이지
	gridTotalRowCount = 0;//전체 행 수
	
	 var INQ_PARAMS;//파라미터 데이터
	 var dtList;//반환등록일자구분
     var whsl_se_cdList;//도매업자구분
     var mfc_bizrnmList;//생산자
     var whsdlList;//도매업자 업체명 조회
     var areaList;//지역
     var sys_seList;//등록구분
     var stat_cdList;//상태
     var grid_info;//그리드 컬럼 정보
	 var brch_nmList;//직매장/공장
     
     var toDay = kora.common.gfn_toDay();// 현재 시간
 	 var arr = new Array();//생산자
	 var arr2 = new Array();
	 var arr3 = new Array();
	 var pagingCurrent = 1;
	 var parent_item;//팝업창 오픈시 필드값
	 var sumData; //총합계
	 
     $(function() {
		INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());//파라미터 데이터
     	dtList = jsonObject($("#dtList").val());//반환등록일자구분
     	whsl_se_cdList = jsonObject($("#whsl_se_cdList").val());//도매업자구분
     	mfc_bizrnmList = jsonObject($("#mfc_bizrnmList").val());//생산자
     	whsdlList = jsonObject($("#whsdlList").val());//도매업자 업체명 조회
     	areaList = jsonObject($("#areaList").val());//지역
     	sys_seList = jsonObject($("#sys_seList").val());//상태
     	stat_cdList	= jsonObject($("#stat_cdList").val());//등록구분
     	grid_info = jsonObject($("#grid_info").val());//그리드 컬럼 정보
     	brch_nmList	= jsonObject($("#brch_nmList").val());//직매장
    	 
    	//버튼 셋팅
    	fn_btnSetting();
    	 
    	//그리드 셋팅
		fnSetGrid1();
		
		//날짜 셋팅
		$('#START_DT').YJdatepicker({
	         periodTo : '#END_DT',
	         initDate : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
	    });
	    $('#END_DT').YJdatepicker({
	         periodFrom : '#START_DT',
	         initDate : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
	    });
		
		//text 셋팅
		$('#title_sub').text('<c:out value="${titleSub}" />');//타이틀
		$('#sel_term').text(parent.fn_text('sel_term'));//조회기간
		$('#stat').text(parent.fn_text('stat'));//상태
		$('#mfc_bizrnm').text(parent.fn_text('mfc_bizrnm'));//반환대상생산자
		$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm'));//반환대상지점
		$('#rsrc_se').text(parent.fn_text('rsrc_se'));//등록구분
		$('#whsl_se_cd').text(parent.fn_text('whsl_se_cd'));//도매업자 구분
		$('#enp_nm').text(parent.fn_text('enp_nm'));//업체명
		$('#area').text(parent.fn_text('area'));//지역
		
		//div필수값 alt
		 $("#START_DT").attr('alt',parent.fn_text('sel_term'));   
		 $("#END_DT").attr('alt',parent.fn_text('sel_term'));   
		 
		 // 조회 화면 열기
		 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) == ""){
			 $('.btn_manage button').click();
		 }
		 
      
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
			$('.btn_manage button').click();
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
			$("#START_DT").val(start_dt);
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
			$("#END_DT").val(end_dt);
		});
		
		/************************************
		 * 끝날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		$("#END_DT").change(function(){
			var end_dt  = $("#END_DT").val();
		    end_dt =  end_dt.replace(/-/gi, "");
			if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd");
		    $("#END_DT").val(end_dt);
		});
		
		/************************************
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_excel").click(function() {
			fn_excel();
		});
		
  		fn_init();//초기 데이터 셋팅
  	
	});
     
     //초기화
     function fn_init(){
    	 
		kora.common.setEtcCmBx2(dtList, "","", $("#SEARCH_GBN"), "ETC_CD", "ETC_CD_NM", "N");//조회기간 선택
		kora.common.setEtcCmBx2(stat_cdList, "","", $("#RTN_STAT_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');//상태
		kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'T');//생산자
		kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'T');//직매장/공장
		kora.common.setEtcCmBx2(sys_seList, "","", $("#SYS_SE"), "ETC_CD", "ETC_CD_NM", "N",'T');//등록구분
		
		/* kora.common.setEtcCmBx2(whsl_se_cdList, "","", $("#WHSL_SE_CD"), "ETC_CD", "ETC_CD_NM", "N" );//도매업자구분 */ 
		/* kora.common.setEtcCmBx2(whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" );//도매업자 업체명 */
		
		kora.common.setEtcCmBx2(areaList, "","", $("#AREA"), "ETC_CD", "ETC_CD_NM", "N" ,'T');//지역
		$("#START_DT").val(kora.common.getDate("yyyy-mm-dd", "D", -7, false));//일주일전 날짜 
		$("#END_DT").val(kora.common.getDate("yyyy-mm-dd", "D", 0, false));//현재 날짜
		
		//파라미터 조회조건으로 셋팅
		if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
			if(brch_nmList !=null){
				 kora.common.setEtcCmBx2(brch_nmList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');	 //직매장/공장
			}
			kora.common.jsonToTable("params",INQ_PARAMS.SEL_PARAMS);
			// 화면이동 페이징 셋팅
			gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
		}
  		//$("#WHSDL_BIZRNM").select2();// 업체명 자동완성
			    	
     }

     //도매업자구분 변경시 도매업자 조회 ,생산자가 선택됐을경우 거래중인 도매업자만 조회
     function fn_whsl_se_cd(){
    	var url = "/WH/EPWH2916401_193.do" 
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
    	
		//$("#WHSDL_BIZRNM").select2("val","");
		ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {  
				kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" );//업체명
			}else{
				alert("error");
			}
		});
     }
 
   //생산자 변경시 생산자랑 거래중인 도매업자 조회 , 직매장/공장
   function fn_mfc_bizrnm(){
  		var url = "/WH/EPWH2916401_19.do" 
		var input ={};
		arr = [];
		arr	= $("#MFC_BIZRNM").val().split(";");
		input["MFC_BIZRID"] = arr[0];//직매장별거래처관리 테이블에서 생산자
		input["MFC_BIZRNO"]	= arr[1];
		input["BIZRID"] = arr[0];//지점관리 테이블에서 사업자
		input["BIZRNO"] = arr[1];
		 
	   	if($("#WHSL_SE_CD").val() !=""){
			input["BIZR_TP_CD"] =$("#WHSL_SE_CD").val();
	   	}
	   	
      	   	ajaxPost(url, input, function(rtnData) {
  				if ("" != rtnData && null != rtnData) {   
  					 kora.common.setEtcCmBx2(rtnData.brch_nmList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');//직매장/공장
  					 kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" );//도매업자 업체명
  					//$("#WHSDL_BIZRNM").select2("val","");
  				}else{
  					alert("error");
  				}
   		});
   }
   
   //직매장/공장 변경시  생산자랑 거래 중인 도매업자 업체명 조회
   function fn_mfc_brch_nm(){
		var url = "/WH/EPWH2916401_192.do" 
			var input = {};
				 arr2 = [];
		 	     arr2 = $("#MFC_BRCH_NM").val().split(";");
				 input["MFC_BIZRID"] = arr[0];//직매장별거래처관리 테이블에서 생산자
				 input["MFC_BIZRNO"] = arr[1];
		 	     input["MFC_BRCH_ID"] = arr2[0];
   			  	 input["MFC_BRCH_NO"] = arr2[1];
   			  	 
		if($("#WHSL_SE_CD").val() !=""){
 			input["BIZR_TP_CD"] = $("#WHSL_SE_CD").val();
 		} 
	       	   
		ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {   
				kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" );	//도매업자 업체명
	 			//$("#WHSDL_BIZRNM").select2("val","");
			}else{
 				alert("error");
 			}
		});
   }
  
   //입고관리 조회
	function fn_sel(){
		var input	= {};
	 	var url = "/WH/EPWH2916401_194.do" 
	 	var start_dt = $("#START_DT").val();
	 	var end_dt = $("#END_DT").val();
	 	pagingCurrent = 1;
		start_dt = start_dt.replace(/-/gi, "");
		end_dt = end_dt.replace(/-/gi, "");
	
		//날짜 정합성 체크. 20160204
		if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
			alert("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return; 
		}
	     //	kora.common.fnDateCompare ()    종료일이 시작일 보다 작을때 false 를 체크 해보자
		if(start_dt>end_dt){
			alert("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return;
		}
	     
		 input["SEARCH_GBN"] = $("#SEARCH_GBN").val();//날짜 구분 선택
		 input["START_DT"] = $("#START_DT").val();			
		 input["END_DT"] = $("#END_DT").val();			
		 input["RTN_STAT_CD"] = $("#RTN_STAT_CD").val();//상태
		 input["SYS_SE"] = $("#SYS_SE").val();//실태조사구분
		 input["BIZR_TP_CD"] = $("#WHSL_SE_CD").val();//도매업자 구분
		 /* input["AREA_CD"]   			= $("#AREA").val();	//지역 */
		 
		 if($("#MFC_BIZRNM").val() !=""){//생산자
			 arr = [];
			 arr = $("#MFC_BIZRNM").val().split(";");
			 input["MFC_BIZRID"] = arr[0];
			 input["MFC_BIZRNO"] = arr[1];
		 }
		 if($("#MFC_BRCH_NM").val() !="" ){//직매장/공장
			 arr2 = [];
			 arr2 = $("#MFC_BRCH_NM").val().split(";");
			 input["MFC_BRCH_ID"] = arr2[0];
			 input["MFC_BRCH_NO"] = arr2[1];
		 }
		/* if($("#WHSDL_BIZRNM").val() !="" ){	//도매업자
		 	 arr3		=[];
			 arr3	= $("#WHSDL_BIZRNM").val().split(";");
			 input["WHSDL_BIZRID"]   	= arr3[0];
			 input["WHSDL_BIZRNO"] 	= arr3[1]; 
		 } */
		 
		 //상세갔다가 올때 SELECT박스 값
		 input["MFC_BIZRNM"] = $("#MFC_BIZRNM").val(); 
		 input["MFC_BRCH_NM"] = $("#MFC_BRCH_NM").val();
		 input["WHSDL_BIZRNM"] = $("#WHSDL_BIZRNM").val();
		 /* input["WHSL_SE_CD"] = $("#WHSL_SE_CD").val(); */
		 input["AREA"] = $("#AREA").val();			
		 
		/* 페이징  */
		input["ROWS_PER_PAGE"] = gridRowsPerPage;
		input["CURRENT_PAGE"] = gridCurrentPage;
			
		//임시 실태조사
		input["ACRH_DOC_NO"]="";
		INQ_PARAMS["SEL_PARAMS"] = input;
		
		hideMessage();
		showLoadingBar();
      	ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {   
   					gridApp.setData(rtnData.selList);
   		  			sumData = rtnData.totalList[0];

   		  			/* 페이징 표시 */
   		  			gridTotalRowCount = parseInt(sumData.CNT); //총 카운트
					drawGridPagingNavigation(gridCurrentPage);
   		  			
					if (rtnData.selList.length == 0) {
						showMessage();	
					} 
   				}else{
   					alert("error");
   				}
   				hideLoadingBar(); 
   		});
      	
      	console.log("INQ_PARAMS : " + JSON.stringify(INQ_PARAMS));
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
			alert("선택한 건이 없습니다.");
			return false;
		}
		if(selectorColumn.getSelectedIndices().length >1) {
			alert("한건만 선택이 가능합니다.");
			return false;
		}
		input = gridRoot.getItemAt(selectorColumn.getSelectedIndices());
		var rtn_stat_cd =  input["RTN_STAT_CD"];
		 
		if(rtn_stat_cd!="CC" && rtn_stat_cd!="RR" && rtn_stat_cd!="SW" && rtn_stat_cd !="SM"){
			alert("입고내역서 조정이 불가능한 자료입니다. 다시 한 번 확인하시기 바랍니다");
			return;
		}
		var url ='/WH/EPWH2983931_092.do'	//템프에 저장		
	 	ajaxPost(url, input, function(rtnData){
			if(rtnData.RSLT_CD != "0000"){
				alert(rtnData.RSLT_MSG);
				return;
			}else if(rtnData.RSLT_CD == "0000"){
				//파라미터에 조회조건값 저장 
				INQ_PARAMS["PARAMS"] = {}
				INQ_PARAMS["PARAMS"] = input;			
				INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
				INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH2916401.do";
				kora.common.goPage('/WH/EPWH2916431.do', INQ_PARAMS);
			}
		});    
	}
	
	//실태조사요청 취소 확인
	function fn_upd_chk() {
		var selectorColumn = gridRoot.getObjectById("selector");
		var input = {};
		if(selectorColumn.getSelectedIndices() == "") {
			alert("선택한 건이 없습니다.");
			return false;
		}
		 for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				//반환등록 ,입고조정 ,입고확인 상태만 가능
				if(item["RTN_STAT_CD"] !="SW" && item["RTN_STAT_CD"] !="SM"	&& item["RTN_STAT_CD"] !="RR"){     
					alert("실태조사취소 처리가 불가능한 자료가 선택되었습니다. 다시 한 번 확인하시기 바랍니다");
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
		var url ="/WH/EPWH2916401_21.do";

		 for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(item);
		 }
	     input["list"] = JSON.stringify(row);
	     showLoadingBar()
		 ajaxPost(url, input, function(rtnData){
			if(rtnData.RSLT_CD == "0000"){
				alert(rtnData.RSLT_MSG);
			}else{
				alert(rtnData.RSLT_MSG);
			}
			hideLoadingBar();    
		});     
	    fn_sel();
	}	
	
	//상세조회
	function dtl_link(){
		var idx = dataGrid.getSelectedIndices();
		var input = gridRoot.getItemAt(idx);
		var data = "1";
		
		if(kora.common.null2void(input.WRHS_DOC_NO) != "" ) {
		    data = "2";
		}
		
		var url = "/WH/EPWH2916464.do";
		if(data == '2'){
			url = "/WH/EPWH29164642.do";
		}
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["PARAMS"] = {};
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH2916401.do";
		kora.common.goPage(url, INQ_PARAMS);
	}
	
	 //증빙파일 , 조사요청정보 
	function link(data){
		var idx = dataGrid.getSelectedIndices();
		parent_item = gridRoot.getItemAt(idx);
		var params = "&params=" + fn_encrypt(parent_item.RSRC_DOC_NO);

		//var url = "/WH/EPWH29164883.do?"+_params;
		//kora.common.iWebAction('6000', {_url : url } );
		
        var url = "/WH/EPWH29164883.do";

        console.log("INQ_PARAMS1 : " + JSON.stringify(INQ_PARAMS));
        
        INQ_PARAMS["PARAMS"] = {};
        INQ_PARAMS["PARAMS"] = parent_item;
        INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
        INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH2916401.do";
		
        console.log("INQ_PARAMS2 : " + JSON.stringify(INQ_PARAMS));
        
		kora.common.goPage(url, INQ_PARAMS);

/* 		
		var url = "https://" + location.host + "/WH/EPWH29164883.do?_csrf=" + gtoken + params;
        
        alert("url : " + url);
        
        kora.common.iWebAction('5000', {_url: url});
         */
	}
	
	//엑셀저장
	function fn_excel(){

		var collection = gridRoot.getCollection();
		if(collection.getLength() < 1){
			alert("데이터가 없습니다.");
			return;
		}
		
		if(INQ_PARAMS["SEL_PARAMS"] == undefined){
			alert("먼저 데이터를 조회해야 합니다.");
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
		var url = "/WH/EPWH2916401_05.do";
		showLoadingBar()
		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
				alert(rtnData.RSLT_MSG);
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
			layoutStr.push('    <DataGrid id="dg1" autoHeight="true" minHeight="672" rowHeight="110" styleName="gridStyle" textAlign="center" wordWrap="true" variableRowHeight="true">');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridColumn dataField="RTN_REG_DT"	labelJsFunction="convertItem1"	headerText="'+ parent.fn_text('rtn_reg_dt')+ "&lt;br&gt;(" + parent.fn_text('rh_req_info') + ')"  	itemRenderer="HtmlItem" textAlign="center" width="30%" />'); 	//반환등록일자
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM"	labelJsFunction="convertItem2"	headerText="'+ parent.fn_text('mfc_bizrnm')+ "&lt;br&gt;(" + parent.fn_text('whsdl') + ')"  	itemRenderer="HtmlItem" textAlign="center" width="45%" />'); 												//도매업자구분
			layoutStr.push('			<DataGridColumn dataField="RTN_QTY2"	labelJsFunction="convertItem3"	headerText="'+ parent.fn_text('rtn_qty2')+ "&lt;br&gt;(" + parent.fn_text('stat') + ')"  		itemRenderer="HtmlItem" textAlign="center" width="25%"  />'); 		//반환량
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('	</DataGrid>');
            layoutStr.push('    <Style>');
            layoutStr.push('        .gridStyle {');
            layoutStr.push('            headerColors:#565862,#565862;');
            layoutStr.push('            headerStyleName:gridHeaderStyle;');
            layoutStr.push('            verticalAlign:middle;headerHeight:70;fontSize:28;');
            layoutStr.push('        }');
            layoutStr.push('        .gridHeaderStyle {');
            layoutStr.push('            color:#ffffff;');
            layoutStr.push('            fontWeight:bold;');
            layoutStr.push('            horizontalAlign:center;');
            layoutStr.push('            verticalAlign:middle;');
            layoutStr.push('        }');
            layoutStr.push('    </Style>');
            layoutStr.push('    <Box id="messageBox" width="100%" height="100%" backgroundAlpha="0.3" verticalAlign="top" horizontalAlign="center" visible="false" margin-top="150px">');
            layoutStr.push('    	<Box backgroundAlpha="1" backgroundColor="#FFFFFF" borderColor="#000000" borderStyle="solid" paddingTop="5px" paddingBottom="5px" paddingRight="5px" paddingLeft="5px">');
            layoutStr.push('    		<Label id="messageLabel" text="조회된 내역이 없습니다" fontSize="24px" fontWeight="bold" textAlign="center"/>');
            layoutStr.push('    	</Box>');
            layoutStr.push('    </Box>');            
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
			 	//취약점점검 6041 기원우
			 }else{
				 gridApp.setData();
				 //페이징 표시 
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
			console.log(columnIndex);
			if(columnIndex == 0){
				link(3);
			}else{
				dtl_link();	
			}
			
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
	
	// 변환등록일자/변환일자
	function convertItem1(item, value, column) {
	    var value1 = kora.common.formatter.datetime(item["RTN_REG_DT"], 'yyyy-mm-dd');
	    var value2 = kora.common.null2void(item["REQ_RSN"]);
	    
	    var result;
	    if( value2 == ''){
	    	result  = value1;	
	    }else{
	    	result  = value1 + "</BR>(" + value2 + ")";
	    }
	    
	    return result;
	}
	// 구분/도매업자
	function convertItem2(item, value, column) {
	    var value1 = kora.common.null2void(item["MFC_BIZRNM"]);
	    var value2 = kora.common.null2void(item["CUST_BIZRNM"]);
	    var result;
	    if( value2 == ''){
	    	result  = value1;	
	    }else{
	    	result  = value1 + "</BR>(" + value2 + ")";
	    }
	    return result;
	}
	
	// 변환량/상태
	function convertItem3(item, value, column) {
		var value1 = kora.common.format_comma(item["RTN_QTY_TOT"]);
	    var value2 = kora.common.null2void(item["STAT_CD_NM"]);
	    var result;
	    if( value2 == ''){
	    	result  = value1;	
	    }else{
	    	result  = value1 + "</BR>(" + value2 + ")";
	    }
	    return result;
	}	
	
/****************************************** 그리드 셋팅 끝***************************************** */


</script>

<style type="text/css">

/* .srcharea .row .col{
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
} */
</style>

</head>
<body>
<input type="hidden" id="cate" value="sbj">
	<div id="wrap">
	
		<%@include file="/jsp/include/header_m.jsp" %>
		
		<%@include file="/jsp/include/aside_m.jsp" %>
		
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
			
		<div id="container">

			<div id="subvisual">
				<h2 class="tit" id="title_sub"></h2>
			</div><!-- id : subvisual -->

			<div id="contents">
				<div class="btn_manage">
					<button type="button"></button>
				</div>
				<div class="manage_wrap" id="params">
					<div class="contbox">
						<div class="boxed">
							<div class="sort" id="sel_term">조회기간</div>
							<select id="SEARCH_GBN" style="width: 435px;"></select>
						</div>
						<div class="boxed">
							<input type="text" id="START_DT" style="width: 285px;" readonly>
							<span class="swung">~</span>
							<input type="text" id="END_DT" style="width: 285px;" readonly>
							<div class="btn_wrap ml10">
								<button type="button" class="btn63 c1" style="width: 110px;">조회</button>
							</div>
						</div>
					</div>
					<div class="contbox v2">
						<div class="boxed">
							<div class="sort">상태</div>
							<select id="RTN_STAT_CD" style="width: 435px;"></select>
						</div>
						<div class="boxed">
							<div class="sort">생산자</div>
							<select id="MFC_BIZRNM" style="width: 435px;"></select>
						</div>
						<div class="boxed">
							<div class="sort">직매장/공장</div>
							<select id="MFC_BRCH_NM" style="width: 435px;"></select>
						</div>
						<div class="boxed">
							<div class="sort">실태조사구분</div>
							<select id="SYS_SE" style="width: 435px;"></select>
						</div>
						<div class="btn_wrap line">
							<div class="fl_c">
								<a id="btn_sel" href="#self" class="btn70 c1" style="width: 220px;">조회</a>
							</div>
						</div>
					</div>
				</div>
                <div class="contbox mt0 pb0" >
                </div>
				<div class="tblbox">
					<div class="tbl_inquiry v2">
						<div class="tbl_board">
							<div id="gridHolder"></div>
						</div>
						<div class="pagination mt20">
							<div class="paging">
								<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
							</div>
						</div>
					</div>
				</div>
			</div><!-- id : contents -->

		</div><!-- id : container -->

        <script>
            //조회조건 처리
            newriver.manageAction();
        </script>

		<%@include file="/jsp/include/footer_m.jsp" %>
		
	</div><!-- id : wrap -->

</body>
</html>