<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>반환수집소내역관리</title>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
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
<!-- 
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />
 -->
 
<script type="text/javaScript" language="javascript" defer="defer">

	/* 페이징 사용 등록 */
	gridRowsPerPage = 15;// 1페이지에서 보여줄 행 수
	gridCurrentPage = 1;// 현재 페이지
	gridTotalRowCount = 0;//전체 행 수

	 var INQ_PARAMS;//파라미터 데이터
	 var dtList;//반환등록일자구분
     var whsl_se_cdList;//도매업자구분
     var mfc_bizrnmList;//생산자
	 var brch_nmList;//생산자 직매장/공장
     var whsdlList;//도매업자 업체명 조회
     var areaList;//지역
     var sys_seList;//상태
     var stat_cdList;//등록구분
     var grid_info;//그리드 컬럼 정보
     var sumData;//총합계
     var toDay = kora.common.gfn_toDay();// 현재 시간
 	 var arr 	= new Array();//생산자
	 var arr2 = new Array();
	 var arr3 = new Array();
	 var acSelected= new Array();
	 var cpctCdList;        //용량코드
	 
     $(function() {
   		INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());//파라미터 데이터
  		dtList = jsonObject($("#dtList").val());//반환등록일자구분
  	    whsl_se_cdList = jsonObject($("#whsl_se_cdList").val());//도매업자구분
  	    mfc_bizrnmList = jsonObject($("#mfc_bizrnmList").val());//생산자
  	    whsdlList = jsonObject($("#whsdlList").val());//도매업자 업체명 조회
  	    areaList = jsonObject($("#areaList").val());//지역
  	    sys_seList = jsonObject($("#sys_seList").val());//상태
  	    stat_cdList = jsonObject($("#stat_cdList").val());//등록구분
  	    grid_info = jsonObject($("#grid_info").val());//그리드 컬럼 정보
  	  	brch_nmList = jsonObject($("#brch_nmList").val());//직매장/공장 정보
  	   	cpctCdList = jsonObject($("#cpctCdList").val());       
  	  	
	  	  //버튼 셋팅
	   	 fn_btnSetting();
	   	 
	   	 //그리드 셋팅
		 fnSetGrid1();
		
	   	 //날짜 셋팅
		$('#START_DT').YJdatepicker({
				toName : 'to',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
		});
	   	 
		$('#END_DT').YJdatepicker({
				fromName : 'from',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
		});
		 
		//text 셋팅
		//$('#title_sub').text('<c:out value="${titleSub}" />');//타이틀
		$('#sel_term').text(parent.fn_text('sel_term'));//조회기간
		$('#stat').text(parent.fn_text('stat'));//상태
		$('#mfc_bizrnm').text(parent.fn_text('mfc_bizrnm'));//반환대상생산자
		$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm'));//반환대상지점
		$('#reg_se').text(parent.fn_text('reg_se'));//등록구분
		$('#whsl_se_cd').text(parent.fn_text('whsl_se_cd'));//도매업자 구분
		$('#enp_nm').text(parent.fn_text('enp_nm'));//업체명
		$('#area').text(parent.fn_text('area'));//지역
		
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
		 * 반환내역서 삭제 클릭 이벤트
		 ***********************************/
		$("#btn_del").click(function(){
			fn_del_chk();
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
		 * 실태조사 클릭 이벤트
		 ***********************************/
		$("#btn_reg").click(function(){
			fn_reg_check();
		});
		/************************************
		 * 반환내역서 등록 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_page").click(function(){
			fn_page();
		});
		
		/************************************
		 * 회수정보 변경 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_upd").click(function(){
			fn_upd();
		});
		
        /************************************
         * 반환내역등록 일괄확인 버튼 클릭 이벤트
         ***********************************/
        $("#btn_upd2").click(function(){
            fn_upd2_check();
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
			start_dt = start_dt.replace(/-/gi, "");
			if(start_dt.length == 8) start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
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
			var end_dt = $("#END_DT").val();
			end_dt = end_dt.replace(/-/gi, "");
			if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd")
			$("#END_DT").val(end_dt) 
		});
		
		/************************************
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_excel").click(function() {
			fn_excel();
		 });
		
  		fn_init();
  		/* 	
  		 //autoComplete 셋팅 멀티 SELECTBOX 
  		 $('[data-ax5autocomplete]').ax5autocomplete({
             removeIcon: '<i class="fa fa-times" aria-hidden="true"></i>',
             onSearch: function (callBack) {
                 var searchWord = this.searchWord;
                 setTimeout(function () {
                     var regExp = new RegExp(searchWord);
                     var myOptions = [];
                     whsdlList.forEach(function (n) {				//리스트정보
                         if (n.CUST_BIZRNM.match(regExp)) {
                             myOptions.push({
                                 value: n.CUST_BIZRID_NO,		//SELECTBOX value
                                 text: n.CUST_BIZRNM				//SELECTBOX text
                             })
                         }
                     });
                     callBack({
                    	 options: myOptions,
                     });
                     
                 }, 150);
  
             }
         });
  		 */
	 });
     
   //변경 페이지 이동 
  	function fn_upd() {
  		var selectorColumn 	= gridRoot.getObjectById("selector");
  		var input = gridRoot.getItemAt(selectorColumn.getSelectedIndices());
  		if(selectorColumn.getSelectedIndices() == "") {
  			alertMsg("선택한 건이 없습니다.");
  			return;
  		}else if(selectorColumn.getSelectedIndices().length >1) {
  			alertMsg("한건만 선택이 가능합니다.");
  			return;
  		//회수등록 ,회수조정 상태인경우만 가능	
  		};
  		
  		if(input.RTN_STAT_CD != 'RG'){
			alertMsg("반환등록 상태의 반환정보만 변경 가능합니다. 다시 한 번 확인하시기 바랍니다.");
			return;
 	   	 }

 	   	//파라미터에 조회조건값 저장 
 		INQ_PARAMS["PARAMS"] = {}
 		INQ_PARAMS["PARAMS"] = input;
 		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
 		INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH9000301.do";

 		kora.common.goPage('/WH/EPWH9000342.do', INQ_PARAMS);
  	}

  	//반환내역등록 일괄확인 
    function fn_upd2_check() {
        var selectorColumn  = gridRoot.getObjectById("selector");
        var input = gridRoot.getItemAt(selectorColumn.getSelectedIndices());
        
        if(selectorColumn.getSelectedIndices() == "") {
            alertMsg("선택한 건이 없습니다.");
            return;
		}else if(selectorColumn.getSelectedIndices().length >1) {
			alertMsg("한건만 선택이 가능합니다.");
			return;
		//회수등록 ,회수조정 상태인경우만 가능	
		}
        INQ_PARAMS["PARAMS"] 				= {}
		INQ_PARAMS["PARAMS"]				= input;
		INQ_PARAMS["FN_CALLBACK"] 		= "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] 	= "/WH/EPWH9000301.do";
		kora.common.goPage('/WH/EPWH9000342.do', INQ_PARAMS);
        
        //confirm("선택하신 내역이 모두 변경 됩니다. 계속 진행하시겠습니까?","fn_upd2");
    }
   
   
    //반환등록요청 상태변경
    function fn_upd2(){
        var selectorColumn = gridRoot.getObjectById("selector");
        var input = {"list": ""};
        var row = new Array();
        var url ="/WH/EPWH9000301_212.do";
        for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
            var item = {};
            item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
            row.push(item);
        }
        
        input["list"] = JSON.stringify(row);
        showLoadingBar();
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
  	
   
    //autoComplete 도매업자 멀티 SELECTBOX
    function fn_autoCompleteSelected(data){
    	acSelected = new Array();
    	if(data.length>0){
    		for(var i =0;i<data.length ;i++){
   				var input={};
			    input["WHSDL_BIZRID_NO"]	=data[i].value
				input["WHSDL_BIZRNM"] 		=data[i].text;
				acSelected.push(input);
    		}	 
    	}
    }
     
    //초기화
    function fn_init(){
    	//kora.common.setEtcCmBx2(cpctCdList, "","", $("#CPCT_CD"), "ETC_CD", "ETC_CD_NM", "N","T");
   		//kora.common.setEtcCmBx2(dtList, "","", $("#SEARCH_GBN"), "ETC_CD", "ETC_CD_NM", "N");//조회기간 선택
    	kora.common.setEtcCmBx2(stat_cdList, "","", $("#RTN_STAT_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');//상태
		kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'T');//생산자
		kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');//직매장/공장
		kora.common.setEtcCmBx2(sys_seList, "","", $("#SYS_SE"), "ETC_CD", "ETC_CD_NM", "N",'T');//등록구분
		kora.common.setEtcCmBx2(whsl_se_cdList, "","", $("#WHSL_SE_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');//도매업자구분 
	 	kora.common.setEtcCmBx2(whsdlList, "","", $("#WHSDL_BIZRNM"), "BIZRNO", "BIZRNM", "N");//도매업자 업체명
	 	//console.log(whsdlList)
		kora.common.setEtcCmBx2(areaList, "","", $("#AREA"), "ETC_CD", "ETC_CD_NM", "N" ,'T');//지역
		$("#START_DT").val(kora.common.getDate("yyyy-mm-dd", "D", -7, false));//일주일전 날짜 
		$("#END_DT").val(kora.common.getDate("yyyy-mm-dd", "D", 0, false));//현재 날짜
	
		//파라미터 조회조건으로 셋팅
		if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
			if(brch_nmList !=null){
				kora.common.setEtcCmBx2(brch_nmList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');//직매장/공장
			}
			
			kora.common.jsonToTable("params",INQ_PARAMS.SEL_PARAMS);
			/* 화면이동 페이징 셋팅 */
			gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
		}
		
		//도매업자  검색
  		//$("#WHSDL_BIZRNM").select2();
		 
    }
    
    //도매업자구분 변경시 도매업자 조회 ,생산자가 선택됐을경우 거래중인 도매업자만 조회
    function fn_whsl_se_cd(){
    	var url = "/WH/EPWH9000301_193.do" 
		var input ={};
		   if($("#WHSL_SE_CD").val()  !=""){
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
    					kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" );//업체명
    				}else{
    					alertMsg("error");
    				}
    		});
     }
 
   //생산자 변경시 생산자랑 거래중인 도매업자 조회 , 직매장/공장
   function fn_mfc_bizrnm(){
	  		var url = "/WH/EPWH9000301_19.do" 
			var input = {};
				 arr = [];
				 arr = $("#MFC_BIZRNM").val().split(";");
				 input["MFC_BIZRID"] = arr[0];  //직매장별거래처관리 테이블에서 생산자
				 input["MFC_BIZRNO"] = arr[1];
				 input["BIZRID"] = arr[0];	//지점관리 테이블에서 사업자
				 input["BIZRNO"] = arr[1];
		 	    if($("#WHSL_SE_CD").val() !=""){
 	   			  input["BIZR_TP_CD"] = $("#WHSL_SE_CD").val();
 	   			} 
	    		
		 	    $("#WHSDL_BIZRNM").select2("val","");
	       		
		 	    ajaxPost(url, input, function(rtnData) {
	    			if ("" != rtnData && null != rtnData) {   
	    				kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" );//도매업자 업체명
	    				kora.common.setEtcCmBx2(rtnData.brch_nmList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');//직매장/공장
	    			}else{
	    				alertMsg("error");
	    			}
	    		},false);
   }
   //직매장/공장 변경시  생산자랑 거래 중인 도매업자 업체명 조회
   function fn_mfc_brch_nm(){
		var url = "/WH/EPWH9000301_192.do" 
		var input ={};
		arr2	= [];
 	    arr2	= $("#MFC_BRCH_NM").val().split(";");
		input["MFC_BIZRID"] = arr[0];  //직매장별거래처관리 테이블에서 생산자
		input["MFC_BIZRNO"] = arr[1];
 	    input["MFC_BRCH_ID"] = arr2[0];
 			  	input["MFC_BRCH_NO"] = arr2[1];
 			  	
		if($("#WHSL_SE_CD").val() !=""){
			input["BIZR_TP_CD"] = $("#WHSL_SE_CD").val();
		}
   		
		$("#WHSDL_BIZRNM").select2("val","");

		ajaxPost(url, input, function(rtnData) {
   			if ("" != rtnData && null != rtnData) {
   				kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');//도매업자 업체명
   			}else{
   				alertMsg("error");
   			}
   		},false);
   }
  
   //반환내역서 조회
    function fn_sel(){
	 	var input	={};
	 	var url = "/WH/EPWH9000301_194.do";
	 	var start_dt = $("#START_DT").val();
	 	var end_dt = $("#END_DT").val();
	 	/* var mfc_bizrnm = $("#MFC_BIZRNM").val();
	 	var mfc_brch_nm = $("#MFC_BRCH_NM").val();	 */
		start_dt = start_dt.replace(/-/gi, "");
	 	end_dt = end_dt.replace(/-/gi, "");
	
		//날짜 정합성 체크. 20160204
		if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
			alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return; 
		}else if(start_dt>end_dt){
			alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return;
		} 
		
		input["START_DT"] = $("#START_DT").val();
		input["END_DT"] = $("#END_DT").val();
		input["RCS_NM"] = $("#RCS_NM").val();
		input["STAT_NM"] = $("#STAT_NM").val();
		input["WHSDL_BIZRNM"] = $("#WHSDL_BIZRNM").val();
		//console.log(input["WHSDL_BIZRNM"])
		input["AREA_CD"] = $("#AREA").val();//지역
		input["INT_STAT_NM"] = $("#INT_STAT_NM").val();
		input["CPCT_CD"] = $("#CPCT_CD").val();
		
		/* if($("#MFC_BIZRNM").val() !="" ){//생산자
			 arr = [];
			 arr = $("#MFC_BIZRNM").val().split(";");
			 input["MFC_BIZRID"] = arr[0];
			 input["MFC_BIZRNO"] = arr[1];
		}
		if($("#MFC_BRCH_NM").val() !="" ){	//직매장/공장
			 arr2 = [];
			 arr2 = $("#MFC_BRCH_NM").val().split(";");
			 input["MFC_BRCH_ID"] = arr2[0];
			 input["MFC_BRCH_NO"] = arr2[1];
		}
		if($("#WHSDL_BIZRNM").val() !="" ){	//도매업자
		 	 arr3 = [];
			 arr3 = $("#WHSDL_BIZRNM").val().split(";");
			 input["WHSDL_BIZRID"] = arr3[0];
			 input["WHSDL_BIZRNO"] = arr3[1];
		} */
	    //input["WHSDL_LIST"]		= JSON.stringify(acSelected);    도매업자 멀티SELECTBOX 일경우   
	
	  	//검색조건들 상세갔다왔을경우 똑같은 ID SELECTBOX 셋팅위해
		 /* input["MFC_BIZRNM"] = $("#MFC_BIZRNM").val(); 
		 input["MFC_BRCH_NM"] = $("#MFC_BRCH_NM").val();
		 input["WHSDL_BIZRNM"] = $("#WHSDL_BIZRNM").val();
		 input["WHSL_SE_CD"] = $("#WHSL_SE_CD").val();
		 input["AREA"] = $("#AREA").val();//지역 */
		 
		/* 페이징  */
		input["ROWS_PER_PAGE"] = gridRowsPerPage;
		input["CURRENT_PAGE"] = gridCurrentPage;
		INQ_PARAMS["SEL_PARAMS"] = input;
		//kora.common.showLoadingBar(dataGrid, gridRoot);//그리드 loading bar on
		ajaxPost(url, input, function(rtnData) {
		    //console.log("ddddd : " + JSON.stringify(rtnData));
			if ("" != rtnData && null != rtnData) {
				gridApp.setData(rtnData.selList);
				/* 페이징 표시 */
				 //sumData = rtnData.totalList[0];
				//gridTotalRowCount = parseInt(sumData.CNT); //총 카운트
				drawGridPagingNavigation(gridCurrentPage); 
				
				//AMT_TOT
				$("#t1").text(rtnData.amt_tot_list[0].T1);
				$("#t2").text(rtnData.amt_tot_list[0].T2);
			}else{
				alertMsg("error");
			}
			
			hideLoadingBar();// 그리드 loading bar on
   		});
    }
   
    /* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel(); //조회 펑션
	}
    
    //실태조사 상태변경 체크
	function fn_reg_check(){
			var selectorColumn = gridRoot.getObjectById("selector");
			if(selectorColumn.getSelectedIndices() == "") {
				alertMsg("선택한 건이 없습니다.");
				return false;
			}

			 for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				//반환등록 ,입고조정 ,입고확인 상태만 가능
				if(item["RTN_STAT_CD"] !="RG" && item["RTN_STAT_CD"] !="WC"	&& item["RTN_STAT_CD"] !="WJ"){
					alertMsg("실태조사 대상 설정 처리가 불가능한 자료가 선택되었습니다. 다시 한 번 확인하시기 바랍니다");
					return;
				}
			 }
				confirm("선택하신 내역이 모두 실태조사 대상 설정 처리됩니다. 계속 진행하시겠습니까?","fn_reg");
	}
   
   //실태조사 상태변경
	function fn_reg(){
			var selectorColumn = gridRoot.getObjectById("selector");
			var input = {"list": ""};
			var row = new Array();
			var url ="/WH/EPWH9000301_21.do";
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
   
	//반환내역서 삭제 confirm
   	function fn_del_chk(){
   		var selectorColumn = gridRoot.getObjectById("selector");
		if(selectorColumn.getSelectedIndices() == "") {
			alertMsg("선택한 건이 없습니다.");
			return false;
		}
		 for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
			var item = {};
			item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			
			/* if(item["RTN_STAT_CD"] !="RG" && item["RTN_STAT_CD"] !="RA"){
				alertMsg("반환등록 또는 반환등록요청 상태의 정보만 삭제 가능합니다");
				return;
			} */
		 }
		confirm("선택된 내역이 모두 삭제됩니다. 계속 진행하시겠습니까? 삭제 처리된 내역은 복원되지 않으며 재등록 하셔야 합니다.","fn_del");
	}
   
   //반환내역서 삭제
   function fn_del(){
	    var selectorColumn = gridRoot.getObjectById("selector");
		var input = {"list": ""};
		var row = new Array();
		var url ="/WH/EPWH9000301_04.do";
		if(selectorColumn.getSelectedIndices() == "") {
			alertMsg("선택한 건이 없습니다.");
			return false;
		}
		
		for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
			var item = {};
			item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			
			/* if(item["RTN_STAT_CD"] !="RG" && item["RTN_STAT_CD"] !="RA"){
			    alertMsg("반환등록 또는 반환등록요청 상태의 정보만 삭제 가능합니다");
				return;
			} */
			row.push(item);
		}
		
	    input["list"] = JSON.stringify(row);
    	showLoadingBar()
	 	ajaxPost(url, input, function(rtnData){
			if(rtnData.RSLT_CD == "0000"){
				fn_sel();
				alertMsg(rtnData.RSLT_MSG);
			}else{
				fn_sel();
				alertMsg(rtnData.RSLT_MSG);
			}
			hideLoadingBar();
		});    
	   
   }
	//반환내역서 등록 페이지 이동 
	function fn_page() {
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH9000301.do";
		kora.common.goPage('/WH/EPWH9000331.do', INQ_PARAMS);
	}
	//반환관리 상세
	function link(){
		var idx = dataGrid.getSelectedIndices();
		//console.log(idx);
		var input = gridRoot.getItemAt(idx);
		//console.log(input);
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["PARAMS"] = {};
		INQ_PARAMS["PARAMS"] = input;
		//console.log(INQ_PARAMS["PARAMS"]);
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH9000301.do";
		kora.common.goPage('/WH/EPWH9000364.do', INQ_PARAMS);
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
		var now = new Date();// 현재시간 가져오기
		var hour = new String(now.getHours());// 시간 가져오기
		var min = new String(now.getMinutes());// 분 가져오기
		var sec = new String(now.getSeconds());// 초 가져오기
		var today = kora.common.gfn_toDay();
		var fileName = $('#title_sub').text().replace("/","_") +"_" + today+hour+min+sec+".xlsx";
		
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
				
				if(columns[i].getDataField() == 'RTN_DT'){// html 태크 사용중 컬럼은 대체
					item['dataField'] = 'RTN_DT_ORI';
				}else{
					item['dataField'] = columns[i].getDataField();
				}
				
				item['textAlign'] = columns[i].getStyle('textAlign');
				item['id'] = kora.common.null2void(columns[i].id);
				col.push(item);
			}
		}
		
		
        
		var input = INQ_PARAMS["SEL_PARAMS"];
		input['excelYn'] = 'Y';
		input['fileName'] = fileName;
		input['columns'] = JSON.stringify(col);
		var url = "/WH/EPWH9000301_05.do";
		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
	 	ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
				alertMsg(rtnData.RSLT_MSG);
			}else{
				//파일다운로드
				frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
				frm.fileName.value = fileName;
				frm.submit();
			}
			
			hideLoadingBar()// 그리드 loading bar on
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
		layoutStr.push('	<DataGrid id="dg1" autoHeight="true" minHeight="310" rowHeight="110" styleName="gridStyle" textAlign="center" wordWrap="true" variableRowHeight="true">');
		layoutStr.push('		<columns>');   	
		layoutStr.push('			<DataGridColumn dataField="RCS_NM" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="반환수집소명'+"&lt;br&gt;("+fn_text('rtrvl_dt')+ ')" width="70%" />');
		layoutStr.push('			<DataGridColumn dataField="RTN_QTY" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('rtn_qty')+"&lt;br&gt;("+fn_text('stat')+ ')" width="30%" />');
		layoutStr.push('		</columns>');		
		layoutStr.push('	</DataGrid>');
		layoutStr.push('    <Style>');
		layoutStr.push('		.gridStyle {');
		layoutStr.push('			headerColors:#565862,#565862;');
		layoutStr.push('			headerStyleName:gridHeaderStyle;');
		layoutStr.push('			verticalAlign:middle;headerHeight:70;fontSize:28;');
		layoutStr.push('		}');
		layoutStr.push('		.gridHeaderStyle {');
		layoutStr.push('			color:#ffffff;');
		layoutStr.push('			fontWeight:bold;');
		layoutStr.push('			horizontalAlign:center;');
		layoutStr.push('			verticalAlign:middle;');
		layoutStr.push('		}');
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
			 	eval(INQ_PARAMS.FN_CALLBACK+"()");
			 }else{
				 gridApp.setData();
				/* 페이징 표시 */
				drawGridPagingNavigation(gridCurrentPage);
				
			 }
			
		}
		var dataCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			//setSpanAttributes();
		}
		var selectionChangeHandler = function(event) {
		
			/*
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			selectorColumn = gridRoot.getObjectById("selector");
			*/
			link();
		
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	}
	
	// labelJsFunction 기능을 이용하여 Quarter 컬럼에 월 분기 표시를 함께 넣어줍니다.
	// labelJsFunction 함수의 파라메터는 다음과 같습니다.
	// function labelJsFunction(item:Object, value:Object, column:Column)
	//	      item : 해당 행의 data 객체
	//	      value : 해당 셀의 라벨
	//	      column : 해당 셀의 열을 정의한 Column 객체
	// 그리드 설정시 DataGridColumn 항목에 추가 (예: labelJsFunction="convertItem") 
	function convertItem(item, value, column) {
		
		var dataField = column.getDataField();
		
		if(dataField == "RCS_NM") {
			return item["RCS_NM"] + "</br>(" + kora.common.formatter.datetime(item["RTRVL_DT"], "yyyy-mm-dd") + ")";
		}
		else if(dataField == "RTN_QTY") {
			return kora.common.format_comma(item["RTN_QTY"]) + "</br>(" + item["STAT_NM"] + ")";
		}
		else {
			return "";
		}
	}
	
	
	/**
	 * 그리드 상태 및 비밀번호변경 건 스타일 처리
	 */
	 //그리드 데이터 객체
	 /*
	 function setSpanAttributes() {
		 var collection = gridRoot.getCollection();
	    if (collection == null) {
	        alertMsg("collection 객체를 찾을 수 없습니다");
	        return;
	    } 
	
	    for (var i = 0; i < collection.getLength(); i++) {
	    	var data = gridRoot.getItemAt(i);
	    	if( data.RTN_STAT_CD == 'PP' || data.RTN_STAT_CD == 'PC' ){
	    		collection.addRowAttributeDetailAt(i, null, "#FFCC00", null, false, 20);
	    	}
	    }
	} 
	*/
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

.form-control {
height: 50px;
font-size: 16px
}

.fa-close:before, .fa-times:before {
    content: "X"; 
    font-weight: 550;
 }
</style>

</head>
<body>
	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
	<input type="hidden" id="dtList" value="<c:out value='${dtList}' />" />
	<input type="hidden" id="whsl_se_cdList" value="<c:out value='${whsl_se_cdList}' />" />
	<input type="hidden" id="mfc_bizrnmList" value="<c:out value='${mfc_bizrnmList}' />" />
	<input type="hidden" id="whsdlList" value="<c:out value='${whsdlList}' />" />
	<input type="hidden" id="areaList" value="<c:out value='${areaList}' />" />
	<input type="hidden" id="sys_seList" value="<c:out value='${sys_seList}' />" />
	<input type="hidden" id="stat_cdList" value="<c:out value='${stat_cdList}' />" />
	<input type="hidden" id="grid_info" value="<c:out value='${grid_info}' />" />
	<input type="hidden" id="brch_nmList" value="<c:out value='${brch_nmList}' />" />
	<input type="hidden" id="cpctCdList" value="<c:out value='${cpctCdList}' />" />
			
    <div class="wrap" >  
    	<%@include file="/jsp/include/header_m.jsp" %>
		<%@include file="/jsp/include/aside_m.jsp" %>
		
			<div class="container">
			
				<div id="subvisual">
					<h2 class="tit" id="title"></h2>
				</div><!-- id : subvisual -->
			
					<div class="btn" style="float:right" id="UR"></div>
				<div id="contents">
					<div class="btn_manage">
					<button type="button" id="btn_manage"></button>
					</div>
				
				<div class="manage_wrap" id="params">
				
					<div class="contbox">
						<div class="boxed">
							<div class="sort"  >회수일자</div>	<!-- 회수일자 -->
							<div class="cont" style="font-size:28px;color:#222222;">회수등록일자 기준</div>
						</div>
						<div class="boxed" >
							<div class="calendar">
								<input type="text" id="START_DT" name="from" style="width: 285px;" class="i_notnull" /><!--시작날짜  -->
							</div>
								<div class="swung">~</div>
							<div class="calendar">
								<input type="text" id="END_DT" name="to" style="width: 285px;"	class="i_notnull"><!-- 끝날짜 -->
							</div>
						</div>
					</div> <!-- end of contbox -->
							
					<div class="contbox v2" >
						<div class="boxed">
							<div class="sort">반환수집소명</div>  <!--반환수집소 지점-->
							<input type="text" id="RCS_NM" style="width: 435px;"/>
							<!-- <select id="RCS_NM" style="" ></select> -->
						</div>
						<div class="boxed" >
							<div class="sort">상태</div>
								<select id=STAT_NM style="width: 435px;">
										<option value="">전체</option>
										<option value="회수확인">회수확인</option>
										<option value="회수등록">회수등록</option>
								</select>
						</div>				

						<div class="boxed" >
							<div class="sort">용량(신/구병)</div>
								<!-- <select id="CPCT_CD" style="width: 435px"></select> -->
								<select id="CPCT_CD" >
									<option value="">전체</option>
									<option class="generated" value="13">190ml미만[신병]</option>
									<option class="generated" value="23">400ml미만[신병]</option>
									<option class="generated" value="33">1000ml미만[신병]</option>
									<option class="generated" value="43">1000ml이상[신병]</option>
									<option class="generated" value="11">190ml미만</option>
									<option class="generated" value="21">400ml미만</option>
									<option class="generated" value="31">1000ml미만</option>
									<option class="generated" value="41">1000ml이상</option>
									<option class="generated" value="42">1000ml이상 (백화수복 등)</option>
								</select>   
						</div>
						<select id="WHSDL_BIZRNM" name="WHSDL_BIZRNM"  style="display: none;"></select>
						<div class="btn_wrap line">
							<div class="fl_c">
								<button type="button" class="btn70 c1" style="width: 220px;" id="btn_sel">조회</button>
							</div>
						</div>
						
					</div> <!-- end of contbox v2 -->
				</div>
					
					
					<!--  멀티 SELECTBOX 
					<div class="row">
					    <div class="col-md-6">
					        Multiple SELECTBOX
					        <div class="form-group">
					            <div data-ax5autocomplete="autocomplete2" data-ax5autocomplete-config="{multiple: true}"></div>
					        </div>
					    </div>
					</div>
					 -->
				
				<div class="contbox mt0 pb20" >
					<div id="tableView" class="table_view">
						<div class="slick-wrap">
							<div class="tbl_slide" >
								<table>
									<colgroup>
										<col style="width: 170px;">
										<col style="width: auto;">
									</colgroup>
									<tbody>
									
										<tr>
											<th>총회수량</th><td id="t1">0</td>
										</tr>
										<tr>
											<th>총보증금</th><td id="t2">0</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>					

		<!-- 
		<section class="btnwrap mt10" >
			<div class="btn" id="GL"></div>
			<div class="btn" style="float:right" id="GR">
				<button type="button" class="btn36 c3" style="width: 150px;" id="btn_del">회수정보삭제</button>
				<button type="button" class="btn36 c3" style="width: 150px;" id="btn_upd2">회수정보변경</button>
				<button type="button" class="btn36 c2" style="width: 150px;" id="btn_page">회수정보작성</button>
		
			</div>
		</section>
		 -->
		 <div class="tblbox">
				<div class="tbl_inquiry v2">  <!-- 668 -->
					<div id="gridHolder" style="height: 668px; background: #FFF;"></div>
				</div>
				<div class="pagination mt20">
					<div class="paging">
				   		<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
				   	</div>
				</div>	<!-- 그리드 셋팅 -->
				<div class="btn_wrap mt30" style="height:50px">
						<button class="btnCircle c1" id="btn_page">등록</button>
				</div>	
		</div>
			<section class="btnwrap" style="height:50px">
					<div class="btn" id="BL"></div>
					<div class="btn" style="float:right" id="BR"></div>
			</section>
					</div><!-- id : contents -->
</div><!-- id : container -->

		<script>
			//조회조건 처리
			newriver.manageAction();
		</script>

		<%@include file="/jsp/include/footer_m.jsp" %>
		<!-- 
			<form name="frm" action="/jsp/file_down.jsp" method="post">
				<input type="hidden" name="fileName" value="" />
				<input type="hidden" name="saveFileName" value="" />
				<input type="hidden" name="downDiv" value="excel" />
			</form>
			 -->
	</div><!-- id : wrap -->	
</body>
</html>
