<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>입고정정관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=1100, user-scalable=yes">

<%@include file="/jsp/include/common_page_m.jsp" %>

<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>

<script type="text/javaScript" language="javascript" defer="defer">

    /* 페이징 사용 등록 */
    gridRowsPerPage = 15;// 1페이지에서 보여줄 행 수
    gridCurrentPage = 1;// 현재 페이지
    gridTotalRowCount = 0;//전체 행 수
    
    var INQ_PARAMS;//파라미터 데이터
    var std_mgnt_list;//정산기간
    var whsdlList;//도매업자 업체명 조회
    var stat_cdList;//상태
    var mfc_bizrnmList;//상세 갔다올때 생산자  
    var brch_nmList;//상세 갔다올때 직매장정보
   
    var toDay = kora.common.gfn_toDay();// 현재 시간
    var rowIndexValue = 0;//그리드 선택value
    var regGbn = true;
    var arr    = new Array();//생산자                           
    var arr2 = new Array();//직매장
    var arr3 = new Array();//도매업자
    var arr4 = new Array();//정산기간
    var mfc_bizrnm_return;
    var parent_item;//팝업창 오픈시 필드값
     
    $(function() {
    	
        INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());  
        
        /*상세조회 바로이동*/
        var WRHS_DOC_NO = "<c:out value='${WRHS_DOC_NO}' />";
        var WRHS_CRCT_DOC_NO = "<c:out value='${WRHS_CRCT_DOC_NO}' />";
        if( WRHS_DOC_NO != ''){
            //파라미터에 조회조건값 저장 
            var input = {};
            input.WRHS_DOC_NO = WRHS_DOC_NO;
            input.WRHS_CRCT_DOC_NO = WRHS_CRCT_DOC_NO;
            INQ_PARAMS["PARAMS"] = input;
            INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
            INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH4704201.do";
            kora.common.goPage("/WH/EPWH4738764.do", INQ_PARAMS);
        }
        /*상세조회 바로이동*/
         
        std_mgnt_list  = jsonObject($("#std_mgnt_list").val());       
        whsdlList      = jsonObject($("#whsdlList").val());
        stat_cdList    = jsonObject($("#stat_cdList").val());       
        mfc_bizrnmList = jsonObject($("#mfc_bizrnmList").val());      
        brch_nmList    = jsonObject($("#brch_nmList").val());       
        
        //버튼 셋팅
        //fn_btnSetting();
         
        //그리드 셋팅
        fnSetGrid1();
        
        //text 셋팅
        $('#sel_term'   ).text(fn_text('sel_term'));    //조회기간
        $('#mfc_bizrnm' ).text(fn_text('mfc_bizrnm'));  //상생산자
        $('#mfc_brch_nm').text(fn_text('mfc_brch_nm')); //생산자지점
        $('#ctnr_nm'    ).text(fn_text('ctnr_nm'));     //빈용기명
        $('#stat'       ).text(fn_text('stat'));        //상태
        $('#exca_term'  ).text(fn_text('exca_term'));   //정산기간
        
        
        //div필수값 alt
        $("#EXCA_STD_CD_SE").attr('alt',fn_text('exca_term'));

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

    	kora.common.setEtcCmBx2(std_mgnt_list, "","", $("#EXCA_STD_CD_SE"), "EXCA_STD_CD_SE", "EXCA_STD_NM", "N","S");//정산기간 선택

        for(var k=0; k<std_mgnt_list.length; k++){ 
            if(std_mgnt_list[k].EXCA_STAT_CD == 'S'){
                $('#EXCA_STD_CD_SE').val(std_mgnt_list[k].EXCA_STD_CD_SE);
                break;
            }
        }
        
        fn_exca_std_cd(); //정산기간 변경 이벤트
        
        kora.common.setEtcCmBx2(stat_cdList, "","", $("#WRHS_CRCT_STAT_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');//상태
        //kora.common.setEtcCmBx2([], "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'T');//생산자
        kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'T');//직매장/공장
        kora.common.setEtcCmBx2(whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" );//도매업자 업체명

        //파라미터 조회조건으로 셋팅
        if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
            if(mfc_bizrnmList !=null){  
                kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'T');//생산자
            }
            
            if(brch_nmList !=null){
                kora.common.setEtcCmBx2(brch_nmList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');//직매장/공장
            }
            
            kora.common.jsonToTable("params",INQ_PARAMS.SEL_PARAMS);
            /* 화면이동 페이징 셋팅 */
            gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
        }
        
        if($("#btn_onoff").attr("class") != "on") {
            $("#btn_onoff").click();
        }
    }
     
    //정산기간 변경시  생산자 조회
    function fn_exca_std_cd(){
           var url = "/WH/EPWH4738701_194.do" 
           var input ={};
           //$("#WHSDL_BIZRNM").select2("val","");
           if($("#EXCA_STD_CD_SE").val() !=""){
               arr4     = [];
               arr4     = $("#EXCA_STD_CD_SE").val().split(";");
               input["EXCA_STD_CD"]            =  arr4[0];
               input["EXCA_TRGT_SE"]           =  arr4[1];
               ajaxPost(url, input, function(rtnData) {
                   if ("" != rtnData && null != rtnData) {   
                        mfc_bizrnm_return  =   rtnData.mfc_bizrnmList;
                        kora.common.setEtcCmBx2(rtnData.mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N", 'T'); //생산자
                   }else{
                        alert("error");
                   }
               });
           }// end of if($("#EXCA_STD_CD_SE").val() !="")
    }
    
  //생산자 변경시 생산자랑 거래중인 도매업자 조회 , 직매장/공장
  function fn_mfc_bizrnm(){
           var url = "/WH/EPWH2910101_19.do" 
           var input ={};
           var mfc_bizrnm   = $("#MFC_BIZRNM").val();
           arr  =[];
           arr  = mfc_bizrnm.split(";");
           input["MFC_BIZRID"] = arr[0];//직매장별거래처관리 테이블에서 생산자
           input["MFC_BIZRNO"] = arr[1];
           input["BIZRID"] = arr[0];//지점관리 테이블에서 사업자
           input["BIZRNO"] = arr[1];

           //$("#WHSDL_BIZRNM").select2("val","");
           ajaxPost(url, input, function(rtnData) {
           		if ("" != rtnData && null != rtnData) {   
                	kora.common.setEtcCmBx2(rtnData.brch_nmList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');             //직매장/공장
                    kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" );  //도매업자 업체명
                }else{
                    alert("error");
                }
           },false);
  }
  
  //직매장/공장 변경시  생산자랑 거래 중인 도매업자 업체명 조회
  function fn_mfc_brch_nm(){
       var url = "/WH/EPWH2910101_192.do" 
       var input ={};
       var mfc_brch_nm  = $("#MFC_BRCH_NM").val();
       arr2 = [];
       arr2 = mfc_brch_nm.split(";");
       input["MFC_BIZRID"] = arr[0];//직매장별거래처관리 테이블에서 생산자
       input["MFC_BIZRNO"] = arr[1];
       input["MFC_BRCH_ID"] = arr2[0];
       input["MFC_BRCH_NO"] = arr2[1];
       //$("#WHSDL_BIZRNM").select2("val","");
       ajaxPost(url, input, function(rtnData) {
       		if ("" != rtnData && null != rtnData) {   
            	kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" );  //도매업자 업체명
            }else{
                alert("error");
            }
       });
  }
 
    //입고정정확인  조회
    function fn_sel(){
        var input  ={};
        var url = "/WH/EPWH4704201_193.do" 
    
        if($("#MFC_BIZRNM").val() !="" ){      //생산자
            arr = [];
            arr = $("#MFC_BIZRNM").val().split(";");
            input["MFC_BIZRID"] = arr[0];
            input["MFC_BIZRNO"] = arr[1];
        }
    
        if($("#MFC_BRCH_NM").val() !="" ){ //직매장/공장
            arr2 = [];
            arr2 = $("#MFC_BRCH_NM").val().split(";");
            input["MFC_BRCH_ID"] = arr2[0];
            input["MFC_BRCH_NO"] = arr2[1];
        }
        
        if($("#WHSDL_BIZRNM").val() !="" ){    //도매업자
            arr3 = [];
            arr3 = $("#WHSDL_BIZRNM").val().split(";");
            input["WHSDL_BIZRID"] = arr3[0];
            input["WHSDL_BIZRNO"] = arr3[1];
        }
        
        arr4 = [];                                      //정산기간
        arr4 = $("#EXCA_STD_CD_SE").val().split(";");
        input["EXCA_STD_CD"] =  arr4[0];
        input["EXCA_TRGT_SE"] =  arr4[1];
       
        input["MFC_BIZRNM_RETURN"] = JSON.stringify(mfc_bizrnm_return); //정산기간 내 생산자
        input["WRHS_CRCT_STAT_CD"]  = $("#WRHS_CRCT_STAT_CD").val();    //상태
        
        //상세갔다가 올때 SELECT박스 값---------------------
        input["MFC_BIZRNM"]     = $("#MFC_BIZRNM").val(); 
        input["MFC_BRCH_NM"]    = $("#MFC_BRCH_NM").val();
        input["WHSDL_BIZRNM"]   = $("#WHSDL_BIZRNM").val();
        input["EXCA_STD_CD_SE"] = $("#EXCA_STD_CD_SE").val();
        //---------------------------------------------------------
        
        /* 페이징  */
        input["ROWS_PER_PAGE"] = gridRowsPerPage;
        input["CURRENT_PAGE"] = gridCurrentPage;
        INQ_PARAMS["SEL_PARAMS"] = input;
       
		hideMessage();
        kora.common.showLoadingBar(dataGrid, gridRoot);
        ajaxPost(url, input, function(rtnData) {
            if ("" != rtnData && null != rtnData) {   
                gridApp.setData(rtnData.selList);
                /* 페이징 표시 */
                gridTotalRowCount = parseInt(rtnData.totalList[0].CNT); //총 카운트     /* 총합계 추가 */
                drawGridPagingNavigation(gridCurrentPage);

                sumData = rtnData.totalList[0]; /* 총합계 추가 */

                if($("#btn_onoff").attr("class") == "on") {
                    $("#btn_onoff").click();
                }
                
				if (rtnData.selList.length == 0) {
					showMessage();	
				} 
            }else{
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
   
   //상세조회
   function link(){
       var idx = dataGrid.getSelectedIndices();
       var input = gridRoot.getItemAt(idx);
       var url = "/WH/EPWH4738764.do"; //입고정정내역조회
       
       console.log("MNUL_EXCA_SE : " + input["MNUL_EXCA_SE"]);
       
       
       if(undefined != input["MNUL_EXCA_SE"]) {
           url = "/WH/EPWH4705664.do";   //수기입고정정내역조회    
       }
       else {
           if(undefined == input["WRHS_CRCT_DOC_NO"] || null == input["WRHS_CRCT_DOC_NO"]) {
               input["WRHS_CRCT_DOC_NO"] = input["WRHS_CRCT_DOC_NO_RE"];
           }
       }
       
       //파라미터에 조회조건값 저장 
       INQ_PARAMS["PARAMS"] = {};
       INQ_PARAMS["PARAMS"] = input;
       INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
       INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH4704201.do";
       kora.common.goPage(url, INQ_PARAMS);
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
            layoutStr.push('    <DataGrid id="dg1" autoHeight="true" minHeight="843" rowHeight="110" styleName="gridStyle" wordWrap="true" variableRowHeight="true">'); //truncateToFit="true"
            layoutStr.push('        <columns>');
            layoutStr.push('            <DataGridColumn dataField="WRHS_CFM_DT" width="33%" textAlign="center" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('wrhs_cfm_dt') + "&lt;br&gt;(" + fn_text('stat')+ ")"+'"/>');   //입고확인일자, 상태
            layoutStr.push('            <DataGridColumn dataField="MFC_BIZRNM"  width="33%" textAlign="center" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('mfc_bizrnm') + "&lt;br&gt;" + fn_text('mfc_brch_nm') + '"/>');      //생산자, 직매장/공장
            layoutStr.push('            <DataGridColumn dataField="CFM_QTY_TOT" width="33%" textAlign="center" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('reg_wrhs_qty') + "&lt;br&gt;" + fn_text('crct_wrhs_qty') + '" />'); //등록 입고량, 정정 입고량
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
                eval(INQ_PARAMS.FN_CALLBACK+"()");
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
    //        item : 해당 행의 data 객체
    //        value : 해당 셀의 라벨
    //        column : 해당 셀의 열을 정의한 Column 객체
    // 그리드 설정시 DataGridColumn 항목에 추가 (예: labelJsFunction="convertItem") 
    function convertItem(item, value, column) {
        
        var dataField = column.getDataField();
        
        if(dataField == "WRHS_CFM_DT") {
            return kora.common.formatter.datetime(item["WRHS_CFM_DT_ORI"], "yyyy-mm-dd") + "</br>(" + item["WRHS_CRCT_STAT_CD_NM"] + ")";
        }
        else if(dataField == "MFC_BIZRNM") {
            return item["MFC_BIZRNM"] + "</br>(" + item["MFC_BRCH_NM"] + ")";
        }
        else if(dataField == "CFM_QTY_TOT") {
            return kora.common.format_comma(item["CFM_QTY_TOT"]) + "</br>(" + kora.common.format_comma(item["CRCT_QTY_TOT"]) + ")";
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
        <input type="hidden" id="std_mgnt_list" value="<c:out value='${std_mgnt_list}' />" />
        <input type="hidden" id="whsdlList" value="<c:out value='${whsdlList}' />" />
        <input type="hidden" id="mfc_bizrnmList" value="<c:out value='${mfc_bizrnmList}' />" />
        <input type="hidden" id="brch_nmList" value="<c:out value='${brch_nmList}' />" />
        <input type="hidden" id="stat_cdList" value="<c:out value='${stat_cdList}' />" />
    
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
                            <div class="sort" id="exca_term"></div>
                            <select id=EXCA_STD_CD_SE style="width: 435px;"></select>
                        </div>
                        <div class="boxed">
                            <div class="sort" id="stat"></div>
                            <select id="WRHS_CRCT_STAT_CD" style="width: 435px;"></select>
                        </div>
                        <div class="boxed">
                            <div class="sort" id="mfc_bizrnm"></div>
                            <select id="MFC_BIZRNM" style="width: 435px;"></select>
                        </div>
                        <div class="boxed">
                            <div class="sort" id="mfc_brch_nm"></div>
                            <select id="MFC_BRCH_NM"  style="width: 435px;"></select>
                        </div>
                        <div class="btn_wrap line">
                            <div class="fl_c">
                                <button type="button" class="btn70 c1" style="width: 220px;" id="btn_sel">조회</button>
                            </div>
                        </div>
                    </div>
                    <div class="row" style="display:none">
                        <div class="col">
                            <div class="tit" id="whsdl"></div>  <!-- 도매업자구분 -->
                            <div class="box">
                                <select id="WHSDL_BIZRNM" style="" ></select>
                            </div>
                        </div>
                    </div> <!-- end of row -->
                </div>
                <div class="contbox v4 pb40 mt0">
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