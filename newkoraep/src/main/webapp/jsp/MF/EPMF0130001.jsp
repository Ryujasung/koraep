<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>입고정보생산자ERP대조</title>
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
    gridRowsPerPage = 15;   // 1페이지에서 보여줄 행 수
    gridCurrentPage = 1;    // 현재 페이지
    gridTotalRowCount = 0; //전체 행 수
    
    var sumData;
    
    var INQ_PARAMS; //파라미터 데이터

    var whsl_se_cdList; //도매업자구분
    var mfc_bizrnmList; //생산자
    var brch_nmList;    //직매장/공장

    $(function() {
         
        INQ_PARAMS = jsonObject($("#INQ_PARAMS").val()); //파라미터 데이터
        mfc_bizrnmList = jsonObject($("#mfc_bizrnmList").val());     //생산자
        whsl_se_cdList = jsonObject($("#whsl_se_cdList").val());     //도매업자구분
        
        //버튼 셋팅
        fn_btnSetting();
             
        //그리드 셋팅
        fnSetGrid1();
        
        //화면 초기화
        fn_init();
        
        $("#WHSDL_BIZRNM").select2();
        //fn_whsl_se_cd(); //도매업자 조회
        
        /************************************
         * 생산자 변경 이벤트
         ***********************************/
        $("#MFC_BIZRNM").change(function(){
            fn_mfc_bizrnm();
        });
        
        /************************************
         * 직매장/공장 변경 이벤트
         **********************************/
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
         * 엑셀다운로드 버튼 클릭 이벤트
         ***********************************/
        $("#btn_excel").click(function() {
            fn_excel();
         });

        $("#btn_page").click(function() {
            link(2);
         });
        
    });
    
    function fn_init() {
        //text셋팅
        $('.row > .col > .tit').each(function(){
            $(this).text(parent.fn_text($(this).attr('id')) );
        });
        
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
        
        //div필수값 alt
        $("#START_DT").attr('alt',parent.fn_text('sel_term'));   
        $("#END_DT").attr('alt',parent.fn_text('sel_term'));   
        
        
        kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N"); //생산자
        //kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'T'); //직매장/공장
        fn_mfc_bizrnm();
        
        kora.common.setEtcCmBx2(whsl_se_cdList, "","", $("#WHSL_SE_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T'); //도매업자구분 
        kora.common.setEtcCmBx2([], "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T'); //도매업자 업체명
        kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'T'); //빈용기    
        
        if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
            
            if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS.MFC_BRCH_NM) != "" || kora.common.null2void(INQ_PARAMS.SEL_PARAMS.WHSDL_BIZRNM) != ""){
                $("#MFC_BIZRNM").val(INQ_PARAMS.SEL_PARAMS.MFC_BIZRNM);
                fn_mfc_bizrnm();
            }

            if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS.CTNR_CD) != ""){
                fn_ctnr_cd();
            }
            
            kora.common.jsonToTable("params",INQ_PARAMS.SEL_PARAMS);
            
            /* 화면이동 페이징 셋팅 */
            gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
        }
    }
    

    //빈용기 구분 선택시
    function fn_ctnr_cd(){

        var url = "/SELECT_CTNR_CD2.do" 
        var input ={};

        ctnr_nm=[];
        var arr = $("#MFC_BIZRNM").val().split(";");
        input["MFC_BIZRID"]  = arr[0]; //생산자 아이디
        input["MFC_BIZRNO"]  = arr[1]; //생산자 사업자번호

        ajaxPost(url, input, function(rtnData) {

            if ("" != rtnData && null != rtnData) {   
                ctnr_nm = rtnData.ctnr_nm
                kora.common.setEtcCmBx2(rtnData.ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'T'); //빈용기   
            }
            else{
                alertMsg("error");
            }
        },false);


    }
    
    //도매업자구분 변경시 도매업자 조회, 생산자가 선택됐을경우 거래중인 도매업자만 조회
    function fn_whsl_se_cd(){
        var url = "/MF/EPMF2916401_193.do" 
        var input ={};
            
        if($("#WHSL_SE_CD").val() !=""){
            input["BIZR_TP_CD"] =$("#WHSL_SE_CD").val();
        }
        
        //생산자 선택시 선택된 생산자랑 거래중인 도매업자 조회
        if( $("#MFC_BIZRNM").val() !="" ){
            var arr = $("#MFC_BIZRNM").val().split(";");
            input["MFC_BIZRID"] = arr[0];
            input["MFC_BIZRNO"] = arr[1];
        }
        
        //생산자 + 직매장 선택시 거래중이 도매업자 조회
        if($("#MFC_BRCH_NM").val() !="" ){
            var arr2 = $("#MFC_BRCH_NM").val().split(";");
            input["MFC_BRCH_ID"] = arr2[0];
            input["MFC_BRCH_NO"] = arr2[1];
        }
        
        $("#WHSDL_BIZRNM").select2("val","");
        
        ajaxPost(url, input, function(rtnData) {
            if ("" != rtnData && null != rtnData) {  
                kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');        //업체명
            }
            else{
                alertMsg("error");
            }
        });
    }
 
    //생산자 변경시 생산자랑 거래중인 도매업자 조회 , 직매장/공장
    function fn_mfc_bizrnm(){
        var url = "/MF/EPMF2916401_19.do" 
        var input ={};
        var arr = [];
        var arr = $("#MFC_BIZRNM").val().split(";");

        input["MFC_BIZRID"] = arr[0]; //직매장별거래처관리 테이블에서 생산자
        input["MFC_BIZRNO"] = arr[1];
        input["BIZRID"]     = arr[0]; //지점관리 테이블에서 사업자
        input["BIZRNO"]     = arr[1];

        if($("#WHSL_SE_CD").val() !=""){
            input["BIZR_TP_CD"] =$("#WHSL_SE_CD").val();
        }
        
        ajaxPost(url, input, function(rtnData) {
            if ("" != rtnData && null != rtnData) {
                $("#WHSDL_BIZRNM").select2("val","");
                
                kora.common.setEtcCmBx2(rtnData.brch_nmList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');             //직매장/공장
                kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');  //도매업자 업체명
                fn_ctnr_cd();
            }
            else{
                alertMsg("error");
            }
        }, false);
    }
   
    //직매장/공장 변경시  생산자랑 거래 중인 도매업자 업체명 조회
    function fn_mfc_brch_nm(){
        var url = "/MF/EPMF2916401_192.do" 
        var input ={};
        var arr = [];
            
        arr = $("#MFC_BIZRNM").val().split(";");
        input["MFC_BIZRID"]  = arr[0];  //직매장별거래처관리 테이블에서 생산자
        input["MFC_BIZRNO"]  = arr[1];
        
        if($("#WHSL_SE_CD").val() !=""){
            input["BIZR_TP_CD"]        =$("#WHSL_SE_CD").val();
        } 
        
        ajaxPost(url, input, function(rtnData) {
            if ("" != rtnData && null != rtnData) {   
                kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');  //도매업자 업체명
                $("#WHSDL_BIZRNM").select2("val","");
            }
            else{
                alertMsg("error");
            }
        });
    }
  
    //조회
    function fn_sel(){
        var input = {};
        var url = "/MF/EPMF0130001_19.do" 
         
        var input = kora.common.gfn_formData("frmSel");
        
        /* 페이징  */
        input["ROWS_PER_PAGE"] = gridRowsPerPage;
        input["CURRENT_PAGE"]   = gridCurrentPage;
        
        if($("#MFC_BIZRNM").val() != "" && $("#MFC_BIZRNM").val() != null){      //생산자
            var arr = [];
            var arr = $("#MFC_BIZRNM").val().split(";");
            input["MFC_BIZRID"] = arr[0];
            input["MFC_BIZRNO"] = arr[1];
        }
        
        if($("#MFC_BRCH_NM").val() != "" && $("#MFC_BRCH_NM").val() != null){ //직매장/공장
            var arr2 =[];
            arr2    = $("#MFC_BRCH_NM").val().split(";");
            input["MFC_BRCH_ID"] = arr2[0];
            input["MFC_BRCH_NO"] = arr2[1];
        }
        
        if($("#WHSDL_BIZRNM").val() != "" && $("#WHSDL_BIZRNM").val() != null){ //도매업자
            var arr3 =[];
            arr3   = $("#WHSDL_BIZRNM").val().split(";");
            input["WHSDL_BIZRID"] = arr3[0];
            input["WHSDL_BIZRNO"] = arr3[1]; 
        }
            
        INQ_PARAMS["SEL_PARAMS"] = input;
        
        kora.common.showLoadingBar(dataGrid, gridRoot);
        
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
            kora.common.hideLoadingBar(dataGrid, gridRoot);
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
        var now  = new Date();                   // 현재시간 가져오기
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
        input['excelYn'] = 'Y'; //엑셀 저장시 모든 검색이 필요해서
        input['fileName'] = fileName;
        input['columns'] = JSON.stringify(col);
        
        var url = "/MF/EPMF0130001_05.do";
        kora.common.showLoadingBar(dataGrid, gridRoot);
        
        ajaxPost(url, input, function(rtnData){
            if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
                alertMsg(rtnData.RSLT_MSG);
            }
            else{
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
        layoutStr.push('    <NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
        layoutStr.push('    <NumberMaskFormatter id="maskfmt1" formatString="###-##-#####"/>');
        layoutStr.push('    <DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
        layoutStr.push('    <DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" textAlign="center" id="dg1" draggableColumns="true" horizontalScrollPolicy="on"  sortableColumns="true" headerHeight="35">');
        layoutStr.push('        <groupedColumns>');     
        layoutStr.push('            <DataGridColumn dataField="PNO" headerText="'+ parent.fn_text('sn')+ '" width="50"/>');
        layoutStr.push('            <DataGridColumn dataField="WHSDL_CFM_DT"   headerText="'+ parent.fn_text('wrhs_cfm_dt')+ '"  textAlign="center" width="100" itemRenderer="HtmlItem"/>');   //반환등록일자
        layoutStr.push('            <DataGridColumn dataField="WHSDL_BIZRNM" headerText="'+ parent.fn_text('whsdl')+ '" width="130"/>');
        layoutStr.push('            <DataGridColumn dataField="WHSDL_BIZRNO_DE" headerText="'+ parent.fn_text('bizrno')+ '" width="150" formatter="{maskfmt1}" />');
        layoutStr.push('            <DataGridColumn dataField="CTNR_NM" headerText="'+ parent.fn_text('ctnr_nm')+ '" width="130"/>');
        layoutStr.push('            <DataGridColumn dataField="MFC_BIZRNM" headerText="'+ parent.fn_text('mfc_bizrnm')+ '" width="130"/>');
        layoutStr.push('            <DataGridColumn dataField="MFC_BRCH_NM" headerText="'+ parent.fn_text('mfc_brch_nm')+ '" width="130"/>');
        layoutStr.push('            <DataGridColumnGroup  headerText="'+ parent.fn_text('itms_system')+ '">');                                                                                                           //지급관리 시스템
        layoutStr.push('                <DataGridColumn dataField="SYS_QTY"  headerText="'+ parent.fn_text('wrhs_qty')+ '" width="100" formatter="{numfmt}"  id="num1"  textAlign="right" />'); //입고량
        layoutStr.push('                <DataGridColumn dataField="SYS_GTN"  headerText="'+ parent.fn_text('gtn')+  '" width="100" formatter="{numfmt}"  id="num2"  textAlign="right" />');     //보증금
        layoutStr.push('                <DataGridColumn dataField="SYS_FEE"  headerText="'+ parent.fn_text('fee')+  '" width="100" formatter="{numfmt}" id="num3" textAlign="right" />');       //수수료
        layoutStr.push('                <DataGridColumn dataField="SYS_STAX" headerText="'+ parent.fn_text('stax')+ '" width="100" formatter="{numfmt}" id="num4" textAlign="right" />');       //부가세
        layoutStr.push('                <DataGridColumn dataField="SYS_AMT"  headerText="'+ parent.fn_text('amt')+  '" width="120" formatter="{numfmt}" id="num5" textAlign="right" />');       //금액
        layoutStr.push('            </DataGridColumnGroup>');
        layoutStr.push('            <DataGridColumnGroup  headerText="'+ parent.fn_text('erp_system')+ '">');                                                                                                           //지급관리 시스템
        layoutStr.push('                <DataGridColumn dataField="ERP_QTY"  headerText="'+ parent.fn_text('wrhs_qty')+ '" width="100" formatter="{numfmt}"  id="num6"  textAlign="right" />'); //입고량
        layoutStr.push('                <DataGridColumn dataField="ERP_GTN"  headerText="'+ parent.fn_text('gtn')+  '" width="100" formatter="{numfmt}"  id="num7"  textAlign="right" />');     //보증금
        layoutStr.push('                <DataGridColumn dataField="ERP_FEE"  headerText="'+ parent.fn_text('fee')+  '" width="100" formatter="{numfmt}" id="num8" textAlign="right" />');       //수수료
        layoutStr.push('                <DataGridColumn dataField="ERP_STAX" headerText="'+ parent.fn_text('stax')+ '" width="100" formatter="{numfmt}" id="num9" textAlign="right" />');       //부가세
        layoutStr.push('                <DataGridColumn dataField="ERP_AMT"  headerText="'+ parent.fn_text('amt')+  '" width="120" formatter="{numfmt}" id="num10" textAlign="right" />');       //금액
        layoutStr.push('            </DataGridColumnGroup>');
        layoutStr.push('        </groupedColumns>');
        layoutStr.push('        <footers>');
        layoutStr.push('            <DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
        layoutStr.push('                <DataGridFooterColumn label="소계" textAlign="center"/>');
        layoutStr.push('                <DataGridFooterColumn/>');
        layoutStr.push('                <DataGridFooterColumn/>');
        layoutStr.push('                <DataGridFooterColumn/>');
        layoutStr.push('                <DataGridFooterColumn/>');
        layoutStr.push('                <DataGridFooterColumn/>');
        layoutStr.push('                <DataGridFooterColumn/>');
        layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');
        layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');
        layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');
        layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');
        layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');
        layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');
        layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');
        layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num8}" formatter="{numfmt}" textAlign="right"/>');
        layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num9}" formatter="{numfmt}" textAlign="right"/>');
        layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num10}" formatter="{numfmt}" textAlign="right"/>');
        layoutStr.push('            </DataGridFooter>');
        layoutStr.push('            <DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
        layoutStr.push('                <DataGridFooterColumn label="총합계" textAlign="center"/>');
        layoutStr.push('                <DataGridFooterColumn/>');
        layoutStr.push('                <DataGridFooterColumn/>');
        layoutStr.push('                <DataGridFooterColumn/>');
        layoutStr.push('                <DataGridFooterColumn/>');
        layoutStr.push('                <DataGridFooterColumn/>');
        layoutStr.push('                <DataGridFooterColumn/>');
        layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum1" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');   
        layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum2" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');   
        layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum3" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');   
        layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum4" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');   
        layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum5" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');   
        layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum6" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');   
        layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum7" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');   
        layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum8" dataColumn="{num8}" formatter="{numfmt}" textAlign="right"/>');   
        layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum9" dataColumn="{num9}" formatter="{numfmt}" textAlign="right"/>');   
        layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum10" dataColumn="{num10}" formatter="{numfmt}" textAlign="right"/>');   
        layoutStr.push('            </DataGridFooter>');
        layoutStr.push('        </footers>');
        layoutStr.push('    </DataGrid>');
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

    /* 총합계 추가 */
    function totalsum1(column, data) {
        if(sumData) 
            return sumData.SYS_QTY; 
        else 
            return 0;
    }
    function totalsum2(column, data) {
        if(sumData) 
            return sumData.SYS_GTN; 
        else 
            return 0;
    }
    function totalsum3(column, data) {
        if(sumData) 
            return sumData.SYS_FEE; 
        else 
            return 0;
    }
    function totalsum4(column, data) {
        if(sumData) 
            return sumData.SYS_STAX; 
        else 
            return 0;
    }
    function totalsum5(column, data) {
        if(sumData) 
            return sumData.SYS_AMT; 
        else 
            return 0;
    }
    function totalsum6(column, data) {
        if(sumData) 
            return sumData.ERP_QTY; 
        else 
            return 0;
    }
    function totalsum7(column, data) {
        if(sumData) 
            return sumData.ERP_GTN; 
        else 
            return 0;
    }
    function totalsum8(column, data) {
        if(sumData) 
            return sumData.ERP_FEE; 
        else 
            return 0;
    }
    function totalsum9(column, data) {
        if(sumData) 
            return sumData.ERP_STAX; 
        else 
            return 0;
    }
    function totalsum10(column, data) {
        if(sumData) 
            return sumData.ERP_AMT; 
        else 
            return 0;
    }
    /* 총합계 추가 */
    
    
    function link(gbn){
        var idx = dataGrid.getSelectedIndices();
        var chk = gridRoot.getItemAt(idx);
        var input = {};
        var url = "";
        
        if(gbn == "1") {
            url = '/MF/EPMF0130101.do';
            input["WHSDL_BIZRID"] = chk["WHSDL_BIZRID"];
            input["WHSDL_BIZRNO"] = chk["WHSDL_BIZRNO"];
            input["MFC_BIZRID"]   = chk["MFC_BIZRID"];
            input["MFC_BIZRNO"]   = chk["MFC_BIZRNO"];
            input["MFC_BRCH_ID"]  = chk["MFC_BRCH_ID"];
            input["MFC_BRCH_NO"]  = chk["MFC_BRCH_NO"];
            input["WHSDL_CFM_DT"] = chk["CFM_DT"];
        }
        else {
            url = '/MF/EPMF0130201.do';
            input["START_DT"] = $("#START_DT").val().replaceAll('-','');
            input["END_DT"]   = $("#END_DT").val().replaceAll('-','');

            if($("#MFC_BIZRNM").val() !="" ){      //생산자
                var arr = [];
                var arr = $("#MFC_BIZRNM").val().split(";");
                input["MFC_BIZRID"] = arr[0];
                input["MFC_BIZRNO"] = arr[1];
            }
        }
        
        //파라미터에 조회조건값 저장 
        INQ_PARAMS["PARAMS"] = {};
        INQ_PARAMS["PARAMS"] = input;
        INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
        INQ_PARAMS["URL_CALLBACK"] = "/MF/EPMF0130001.do";
        kora.common.goPage(url, INQ_PARAMS);
    }
    
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
        <input type="hidden" id="whsl_se_cdList" value="<c:out value='${whsl_se_cdList}' />" />
        
        <div class="h3group">
            <h3 class="tit" id="title"></h3>
            <div class="btn" style="float:right" id="UR">
            </div>
        </div>
        
        <section class="secwrap" id="params">
            <div class="srcharea" > 
                <form name="frmSel" id="frmSel" method="post" >
                <div class="row">
                    <div class="col" style="width:430px">
                        <div class="tit" id="sel_term"></div>
                        <div class="box">       
                            <div class="calendar">
                                <input type="text" id="START_DT" name="START_DT" style="width: 140px;" class="i_notnull" ><!--시작날짜  -->
                            </div>
                            <div class="obj">~</div>
                            <div class="calendar">
                                <input type="text" id="END_DT" name="END_DT" style="width: 140px;"  class="i_notnull" ><!-- 끝날짜 -->
                            </div>
                        </div>
                    </div>
                    <div class="col">
                        <div class="tit" id="mfc_bizrnm"></div>
                        <div class="box">                       
                            <select id="MFC_BIZRNM" name="MFC_BIZRNM" style="width: 179px;">
                            </select>
                        </div>
                    </div>
                    <div class="col">
                        <div class="tit" id="mfc_brch_nm" style=""></div>
                        <div class="box">
                            <select id="MFC_BRCH_NM" name="MFC_BRCH_NM" style="width: 179px;">
                            </select>
                        </div>
                    </div>
                </div> <!-- end of row -->
                
                <div class="row">
                    <div class="col"  style="width:430px">
                        <div class="tit" id="whsl_se_cd"></div>
                        <div class="box">
                            <select id="WHSL_SE_CD" name="WHSL_SE_CD" style="width:200px" ></select>
                        </div>
                    </div>
                    
                    <div class="col">
                        <div class="tit" id="enp_nm"></div>
                        <div class="box"  >
                              <select id="WHSDL_BIZRNM" name="WHSDL_BIZRNM" style="width:179px"></select>
                        </div>
                    </div>
                    
                    <div class="col" >
                        <div class="tit" id="ctnr_nm"></div>  <!-- 빈용기명 -->
                        <div class="box" >
                            <select id="CTNR_CD" name="CTNR_CD" style="width:179px" class="i_notnull" ></select>
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
        </div>  <!-- 그리드 셋팅 -->
            
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

</body>
</html>