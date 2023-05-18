<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>입고관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
    gridRowsPerPage = 15;    // 1페이지에서 보여줄 행 수
    gridCurrentPage = 1;    // 현재 페이지
    gridTotalRowCount = 0; //전체 행 수
    
    var INQ_PARAMS;    //파라미터 데이터
    var dtList;                //반환등록일자구분
    var whsl_se_cdList;    //도매업자구분
    var mfc_bizrnmList;    //생산자
    var whsdlList;            //도매업자 업체명 조회
    var areaList;            //지역
    var sys_seList;        //등록구분
    var stat_cdList;        //상태
    var grid_info;            //그리드 컬럼 정보
    var brch_nmList;        //직매장/공장
    var toDay                 = kora.common.gfn_toDay();     // 현재 시간
    var sumData; //총합계
    var arr     = new Array();                                        //생산자
    var arr2 = new Array();                                    //직매장
    var arr3 = new Array();                                    //도매업자
     
    $(function() {
         
        INQ_PARAMS     = jsonObject($("#INQ_PARAMS").val());     //파라미터 데이터
        dtList         = jsonObject($("#dtList").val());         //반환등록일자구분
        whsl_se_cdList = jsonObject($("#whsl_se_cdList").val()); //도매업자구분
        mfc_bizrnmList = jsonObject($("#mfc_bizrnmList").val()); //생산자
        whsdlList      = jsonObject($("#whsdlList").val());      //도매업자 업체명 조회
        areaList       = jsonObject($("#areaList").val());       //지역
        sys_seList     = jsonObject($("#sys_seList").val());     //상태
        stat_cdList    = jsonObject($("#stat_cdList").val());    //등록구분
        grid_info      = jsonObject($("#grid_info").val());      //그리드 컬럼 정보
        brch_nmList    = jsonObject($("#brch_nmList").val());    //직매장
                
        //버튼 셋팅
        //fn_btnSetting();
         
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
        $('#sel_term'   ).text(fn_text('sel_term'));    //조회기간
        $('#stat'       ).text(fn_text('stat'));        //상태
        $('#mfc_bizrnm' ).text(fn_text('mfc_bizrnm'));  //반환대상생산자
        $('#mfc_brch_nm').text(fn_text('mfc_brch_nm')); //반환대상지점
        $('#reg_se'     ).text(fn_text('reg_se'));      //등록구분
        $('#whsl_se_cd' ).text(fn_text('whsl_se_cd'));  //도매업자 구분
        $('#enp_nm'     ).text(fn_text('enp_nm'));      //업체명
        $('#area'       ).text(fn_text('area'));        //지역
        
        //div필수값 alt
        $("#START_DT" ).attr('alt',fn_text('sel_term'));   
        $("#END_DT"   ).attr('alt',fn_text('sel_term'));   
      
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
        
        fn_init();
    });
     
    //초기화
    function fn_init(){
        kora.common.setEtcCmBx2(dtList, "","", $("#SEARCH_GBN"), "ETC_CD", "ETC_CD_NM", "N");                                        //조회기간 선택
        kora.common.setEtcCmBx2(stat_cdList, "","", $("#RTN_STAT_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');                            //상태
        kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'T');                    //생산자
        kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'T');                    //직매장/공장
        kora.common.setEtcCmBx2(sys_seList, "","", $("#SYS_SE"), "ETC_CD", "ETC_CD_NM", "N",'T');                                        //등록구분
         
        kora.common.setEtcCmBx2(whsl_se_cdList, "","", $("#WHSL_SE_CD"), "ETC_CD", "ETC_CD_NM", "N" );                        //도매업자구분 
        kora.common.setEtcCmBx2(whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" );        //도매업자 업체명
              
        kora.common.setEtcCmBx2(areaList, "","", $("#AREA"), "ETC_CD", "ETC_CD_NM", "N" ,'T');                                            //지역
        $("#START_DT").val(kora.common.getDate("yyyy-mm-dd", "D", -7, false));                                                              //일주일전 날짜 
        $("#END_DT").val(kora.common.getDate("yyyy-mm-dd", "D", 0, false));                                                                 //현재 날짜
        
          //파라미터 조회조건으로 셋팅
        if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
            if(brch_nmList !=null){
                 kora.common.setEtcCmBx2(brch_nmList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');     //직매장/공장
            }
            kora.common.jsonToTable("params",INQ_PARAMS.SEL_PARAMS);
            /* 화면이동 페이징 셋팅 */
            gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
        }
        
        if($("#btn_onoff").attr("class") != "on") {
            $("#btn_onoff").click();
        }
    }
     
    //도매업자구분 변경시 도매업자 조회 ,생산자가 선택됐을경우 거래중인 도매업자만 조회
    function fn_whsl_se_cd(){
        var url = "/WH/EPWH2983901_193.do" 
        var input ={};

        if($("#WHSL_SE_CD").val() !=""){
	        input["BIZR_TP_CD"] =$("#WHSL_SE_CD").val();
	    }

	    //생산자 선택시 선택된 생산자랑 거래중인 도매업자 조회
	    if( $("#MFC_BIZRNM").val() !="" ){
	        input["MFC_BIZRID"]        = arr[0];
	        input["MFC_BIZRNO"]    = arr[1];

	        //생산자 + 직매장 선택시 거래중이 도매업자 조회
	        if($("#MFC_BRCH_NM").val() !="" ){
	            input["MFC_BRCH_ID"]        = arr2[0];
	            input["MFC_BRCH_NO"]        = arr2[1];
	        }
	    }
        ajaxPost(url, input, function(rtnData) {
            if ("" != rtnData && null != rtnData) {  
        	    kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" );         //업체명
            }
            else{
                alert("error");
            }
        });
    }
 
   //생산자 변경시 생산자랑 거래중인 도매업자 조회 , 직매장/공장
   function fn_mfc_bizrnm(){
       var url = "/WH/EPWH2983901_19.do" 
       var input ={};
       arr     =[];
       arr     = $("#MFC_BIZRNM").val().split(";");
       input["MFC_BIZRID"]        = arr[0];  //직매장별거래처관리 테이블에서 생산자
       input["MFC_BIZRNO"]        = arr[1];
       input["BIZRID"]                = arr[0];    //지점관리 테이블에서 사업자
       input["BIZRNO"]                = arr[1];

       if($("#WHSL_SE_CD").val() !=""){
           input["BIZR_TP_CD"]        =$("#WHSL_SE_CD").val();
       } 

       //$("#WHSDL_BIZRNM").select2("val","");
       ajaxPost(url, input, function(rtnData) {
           if ("" != rtnData && null != rtnData) {   
               kora.common.setEtcCmBx2(rtnData.brch_nmList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');                 //직매장/공장
               kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N");    //도매업자 업체명
           }
           else{
               alert("error");
           }
       },false);
    }
   
    //직매장/공장 변경시  생산자랑 거래 중인 도매업자 업체명 조회
    function fn_mfc_brch_nm(){

        var url = "/WH/EPWH2983901_192.do" 
        var input ={};
        arr2    = [];
        arr2    = $("#MFC_BRCH_NM").val().split(";");
        input["MFC_BIZRID"]        = arr[0];  //직매장별거래처관리 테이블에서 생산자
        input["MFC_BIZRNO"]        = arr[1];
        input["MFC_BRCH_ID"]        = arr2[0];
        input["MFC_BRCH_NO"]    = arr2[1];
        
        if($("#WHSL_SE_CD").val() !=""){
            input["BIZR_TP_CD"]        =$("#WHSL_SE_CD").val();
        } 
        
        //$("#WHSDL_BIZRNM").select2("val","");
        ajaxPost(url, input, function(rtnData) {
            if ("" != rtnData && null != rtnData) {   
                kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" );    //도매업자 업체명
            }
            else{
                alert("error");
            }
        },false);
   }
  
   //입고관리 조회
    function fn_sel(){
        var input ={};
        var url = "/WH/EPWH2983901_194.do" 
        var start_dt = $("#START_DT").val().replace(/-/gi, "");
        var end_dt   = $("#END_DT").val().replace(/-/gi, "");
        var mfc_bizrnm  = $("#MFC_BIZRNM").val();     
        var mfc_brch_nm = $("#MFC_BRCH_NM").val();        
    
        //날짜 정합성 체크. 20160204
        if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
            alert("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
            return; 
        }
         
        if(start_dt>end_dt){
            alert("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
            return;
        } 
            
        input["SEARCH_GBN"]  = $("#SEARCH_GBN").val();  //날짜 구분 선택
        input["START_DT"]    = $("#START_DT").val();    
        input["END_DT"]      = $("#END_DT").val();            
        input["RTN_STAT_CD"] = $("#RTN_STAT_CD").val(); //상태
        input["SYS_SE"]      = $("#SYS_SE").val();      //시스템구분
        input["BIZR_TP_CD"]  = $("#WHSL_SE_CD").val();  //도매업자 구분
        input["AREA_CD"]     = $("#AREA").val();        //지역
         
        if($("#MFC_BIZRNM").val() !="" ){        //생산자
            arr =[];
            arr = $("#MFC_BIZRNM").val().split(";");
            input["MFC_BIZRID"] = arr[0];
            input["MFC_BIZRNO"] = arr[1];
        }

        if($("#MFC_BRCH_NM").val() !="" ){    //직매장/공장
            arr2 =[];
            arr2 = $("#MFC_BRCH_NM").val().split(";");
            input["MFC_BRCH_ID"] = arr2[0];
            input["MFC_BRCH_NO"] = arr2[1];
        }

        if($("#WHSDL_BIZRNM").val() !="" ){    //도매업자
            arr3 =[];
            arr3 = $("#WHSDL_BIZRNM").val().split(";");
            input["WHSDL_BIZRID"] = arr3[0];
            input["WHSDL_BIZRNO"] = arr3[1]; 
        }
         
        //상세갔다가 올때 SELECT박스 값
        input["MFC_BIZRNM"]   = $("#MFC_BIZRNM").val(); 
        input["MFC_BRCH_NM"]  = $("#MFC_BRCH_NM").val();
        input["WHSDL_BIZRNM"] = $("#WHSDL_BIZRNM").val();
        input["WHSL_SE_CD"]   = $("#WHSL_SE_CD").val();
        input["AREA"]         = $("#AREA").val();            
         
        /* 페이징  */
        input["ROWS_PER_PAGE"]   = gridRowsPerPage;
        input["CURRENT_PAGE"]    = gridCurrentPage;            
        INQ_PARAMS["SEL_PARAMS"] = input;
         
        
		hideMessage();
        kora.common.showLoadingBar(dataGrid, gridRoot);
         
        ajaxPost(url, input, function(rtnData) {
            if ("" != rtnData && null != rtnData) {
                gridApp.setData(rtnData.selList);
                sumData = rtnData.totalList[0];                       

                /* 페이징 표시 */
                gridTotalRowCount = parseInt(sumData.CNT); //총 카운트
                drawGridPagingNavigation(gridCurrentPage);
                       
                $("#FH_CFM_QTY_TOT")  .text(kora.common.format_comma(sumData.FH_CFM_QTY_TOT));
                $("#FB_CFM_QTY_TOT")  .text(kora.common.format_comma(sumData.FB_CFM_QTY_TOT));
                $("#DRCT_CFM_QTY_TOT").text(kora.common.format_comma(sumData.DRCT_CFM_QTY_TOT));
                $("#CFM_QTY_TOT")     .text(kora.common.format_comma(sumData.CFM_QTY_TOT));
                $("#RTN_QTY_TOT")     .text(kora.common.format_comma(sumData.RTN_QTY_TOT));
                    

                if($("#btn_onoff").attr("class") == "on") {
                    $("#btn_onoff").click();
                }
                
				if (rtnData.selList.length == 0) {
					showMessage();	
				} 
            }
            else{
                alert("error");
            }
            kora.common.hideLoadingBar(dataGrid, gridRoot);
        });
    }
   
    /* 페이징 이동 스크립트 */
    function gridMovePage(goPage) {
        gridCurrentPage = goPage; //선택 페이지
        fn_sel(); //조회 펑션
    }
    
    //입고정보상세조회
    function link(){
        var idx = dataGrid.getSelectedIndices();
        var input = gridRoot.getItemAt(idx);
        
        var statCd = input["RTN_STAT_CD"];
        
        if(statCd == 'RG' || statCd == 'SM' || statCd == 'SW' || statCd == 'RR') {
            alert(input["STAT_CD_NM"] + " 상태는 상세조회를 할 수 없습니다.");
            return false;
        }
        
        //파라미터에 조회조건값 저장 
        INQ_PARAMS["PARAMS"] = {};
        INQ_PARAMS["PARAMS"] = input;
        INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
        INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH2983901.do";
        kora.common.goPage('/WH/EPWH2983964.do', INQ_PARAMS);

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
            layoutStr.push('    <DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
            layoutStr.push('    <NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
            layoutStr.push('    <DataGrid id="dg1" autoHeight="true" minHeight="421" rowHeight="110" styleName="gridStyle" wordWrap="true" variableRowHeight="true">'); //truncateToFit="true"
            layoutStr.push('        <columns>');
            layoutStr.push('            <DataGridColumn dataField="RTN_DT" width="33%" textAlign="center" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('rtrvl_dt') + "&lt;br&gt;(" + fn_text('wrhs_cfm_dt')+ ")"+'"/>');     //반환일자
            layoutStr.push('            <DataGridColumn dataField="FH_CFM_QTY_TOT" width="33%" textAlign="center" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('mfc_bizrnm') + "&lt;br&gt;(" + fn_text('mfc_brch_nm') + ")"+ '"/>');    //가정용
            layoutStr.push('            <DataGridColumn dataField="MFC_BIZRNM" width="33%" textAlign="center" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('wrhs_qty') + "&lt;br&gt;(" + fn_text('stat') + ")"+ '" />');            //생산자
            layoutStr.push('        </columns>');
            layoutStr.push('    </DataGrid>');
            layoutStr.push('    <Style>');
            layoutStr.push('        .gridStyle {');
            layoutStr.push('            headerColors:#565862,#565862;');
            layoutStr.push('            headerStyleName:gridHeaderStyle;');
            layoutStr.push('            verticalAlign:middle;headerHeight:110;fontSize:28;');
            layoutStr.push('        }    ');
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
        
        var layoutCompleteHandler = function(event) {
            dataGrid = gridRoot.getDataGrid(); // 그리드 객체
            dataGrid.addEventListener("change", selectionChangeHandler);

            /* 페이징 사용 등록 */
            if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
				/* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
			 	 window[INQ_PARAMS.FN_CALLBACK]();
			 	//취약점점검 6044 기원우
            } else {
                gridApp.setData();
                /* 페이징 표시 */
                drawGridPagingNavigation(gridCurrentPage);
                //gridMovePage(gridCurrentPage);
            }
        }
        
        var dataCompleteHandler = function(event) {
            dataGrid = gridRoot.getDataGrid(); // 그리드 객체
            dataGrid.setEnabled(true);
            gridRoot.removeLoadingBar();
        }
        
        var selectionChangeHandler = function(event) {
            link();
        }
        
        gridRoot.addEventListener("dataComplete", dataCompleteHandler);
        gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
        gridApp.setData([]);
    }
    
    // labelJsFunction 기능을 이용하여 Quarter 컬럼에 월 분기 표시를 함께 넣어줍니다.
    // labelJsFunction 함수의 파라메터는 다음과 같습니다.
    // function labelJsFunction(item:Object, value:Object, column:Column)
    //          item : 해당 행의 data 객체
    //          value : 해당 셀의 라벨
    //          column : 해당 셀의 열을 정의한 Column 객체
    // 그리드 설정시 DataGridColumn 항목에 추가 (예: labelJsFunction="convertItem") 
    function convertItem(item, value, column) {
        
        var dataField = column.getDataField();
        
        if(dataField == "RTN_DT") {
            return kora.common.formatter.datetime(item["RTN_DT"], "yyyy-mm-dd") + "</br>(" + kora.common.formatter.datetime(item["WRHS_CFM_DT"], "yyyy-mm-dd")+")";
        }
        else if(dataField == "FH_CFM_QTY_TOT") {
            return item["MFC_BIZRNM"] + "</br>(" + item["MFC_BRCH_NM"]+")";
        }
        else if(dataField == "MFC_BIZRNM") {
            return kora.common.format_comma(item["CFM_QTY_TOT"]) + "</br>(" + item["STAT_CD_NM"]+")";
        }
        else {
            return "";
        }
    }
/****************************************** 그리드 셋팅 끝***************************************** */

    //목록
    function fn_page(){
        kora.common.goPageB('', INQ_PARAMS);
    }
    
</script>

</head>
<body>
    <div id="wrap">
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
    
    
        <%@include file="/jsp/include/header_m.jsp" %>
        
        <%@include file="/jsp/include/aside_m.jsp" %>
        
        <div id="container">

            <div id="subvisual">
                <h2 class="tit" id="title"></h2>
                <!-- <button class="btn_back" id="btn_lst2"><span class="hide">뒤로가기</span></button> -->                 
            </div><!-- id : subvisual -->

            <div id="contents">
                <div class="btn_manage">
                    <button type="button" id="btn_onoff"></button>
                </div>
                <div class="manage_wrap" id="params">
                    <div class="contbox">
                        <div class="boxed">
                            <div class="sort">조회기간</div>
                            <select id="SEARCH_GBN" style="width: 435px;"></select>
                        </div>
                        <div class="boxed">
                            <input type="text" id="START_DT" name="from" style="width: 285px;" readonly>
                            <span class="swung">~</span>
                            <input type="text" id="END_DT" name="to" style="width: 285px;" readonly>
                        </div>
                    </div>
                    <div class="contbox v2">
                        <div class="boxed">
                            <div class="sort" id="stat"></div>
                            <select id=RTN_STAT_CD style="width: 435px;"></select>
                        </div>
                        <div class="boxed">
                            <div class="sort" id="mfc_bizrnm"></div>
                            <select id="MFC_BIZRNM" style="width: 435px;"></select>
                        </div>
                        <div class="boxed">
                            <div class="sort" id="mfc_brch_nm"></div>
                            <select id="MFC_BRCH_NM" style="width: 435px;"></select>
                        </div>
                        <div class="boxed">
                            <div class="sort" id="area"></div>
                            <select id="AREA"  style="width: 435px;"></select>
                        </div>
                        <div class="btn_wrap line">
                            <div class="fl_c">
                                <button type="button" class="btn70 c1" style="width: 220px;" id="btn_sel">조회</button>
                            </div>
                        </div>
                    </div>
                    <div class="row" style="display:none">
                        <div class="col">
                            <div class="tit" id="whsl_se_cd"></div>  <!-- 도매업자구분 -->
                            <div class="box">
                                <select id="WHSL_SE_CD" style="" ></select>
                            </div>
                        </div>
                        
                        <div class="col">
                            <div class="tit" id="enp_nm"></div>  <!-- 도매업자업체명 -->
                            <div class="box"  >
                                  <select id="WHSDL_BIZRNM" name="WHSDL_BIZRNM" style=""></select>
                            </div>
                        </div>
                        
                        <div class="col" >
                            <div class="tit" id="reg_se"></div>  <!-- 등록구분 -->
                            <div class="box">
                                <select id="SYS_SE" style="" ></select>
                            </div>
                        </div>
                    </div> <!-- end of row -->
                </div>
                <div class="contbox mt0 pb30">
                    <div id="tableView" class="table_view">
                        <div class="slick-wrap">
                            <div class="tbl_slide">
                                <table>
                                    <colgroup>
                                        <col style="width: 119px;">
                                        <col style="width: 165px;">
                                        <col style="width: auto;">
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th rowspan="4">입고량</th>
                                            <td>가정용</td>
                                            <td><span id="FH_CFM_QTY_TOT"></span></td>
                                        </tr>
                                        <tr>
                                            <td>유흥용</td>
                                            <td><span id="FB_CFM_QTY_TOT"></span></td>
                                        </tr>
                                        <tr>
                                            <td>직접반환</td>
                                            <td><span id="DRCT_CFM_QTY_TOT"></span></td>
                                        </tr>
                                        <tr>
                                            <td class="red">총</td>
                                            <td class="red"><span id="CFM_QTY_TOT"></span></td>
                                        </tr>
                                        <tr>
                                            <th>반환량</th>
                                            <td class="red">총</td>
                                            <td class="red"><span id="RTN_QTY_TOT"></span></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="contbox v4 pb40 mt20">
                    <div class="tbl_board">
                        <div id="gridHolder"></div>
                    </div>
                    <div class="pagination mt20">
                        <div class="paging">
                            <div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
                        </div>
                    </div>
                </div>
                
                <script>newriver.manageAction();</script>
            </div><!-- id : contents -->
        </div><!-- id : container -->        
        <%@include file="/jsp/include/footer_m.jsp" %>
    </div><!-- id : wrap -->
</body>
</html>