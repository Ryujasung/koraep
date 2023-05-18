<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>입고현황</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=1100, user-scalable=yes">

<%@include file="/jsp/include/common_page_m.jsp" %>

<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>

<script type="text/javaScript" language="javascript" defer="defer">

    /* 페이징 사용 등록 */
    gridRowsPerPage = 15;    // 1페이지에서 보여줄 행 수
    gridCurrentPage = 1;    // 현재 페이지
    gridTotalRowCount = 0; //전체 행 수
    
    var INQ_PARAMS     = ""; //파라미터 데이터
    var prps_cd        = ""; //용도
    var ctnr_cd        = ""; //빈용기
    var mfc_bizrnmList = ""; //생산자
    var areaList       = ""; //지역
    var whsl_se_cdList = ""; //도매업자구분
    var whsdlList      = ""; //도매업자 업체명 조회

    var toDay          = kora.common.gfn_toDay(); // 현재 시간
    var rowIndexValue  = 0;                 //그리드 선택value
    var arr            = new Array();       //생산자
    var arr2           = new Array();       //도매업자
    var pagingCurrent = 1;
    
    $(function() {
         
        INQ_PARAMS     = jsonObject($("#INQ_PARAMS").val());     //파라미터 데이터
        prps_cd        = jsonObject($("#prps_cd").val());        //용도
        ctnr_cd        = jsonObject($("#ctnr_cd").val());        //빈용기
        mfc_bizrnmList = jsonObject($("#mfc_bizrnmList").val()); //생산자
        areaList       = jsonObject($("#areaList").val());       //지역
        whsl_se_cdList = jsonObject($("#whsl_se_cdList").val()); //도매업자구분
        whsdlList      = jsonObject($("#whsdlList").val());      //도매업자 업체명 조회
                
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
        $('#prps_nm'    ).text(fn_text('prps_cd'));     //용도
        $('#ctnr_nm'    ).text(fn_text('ctnr_nm'));     //빈용기명

        //div필수값 alt
        $("#START_DT").attr('alt',fn_text('sel_term'));
        $("#END_DT"  ).attr('alt',fn_text('sel_term'));        
        
        /************************************
         * 용도 변경 이벤트
         ***********************************/
        $("#PRPS_CD").change(function(){
            fn_prps_cd();
        });
         
        /************************************
         * 생산자 구분 변경 이벤트
         ***********************************/
        $("#MFC_BIZRNM").change(function(){
            fn_mfc_bizrnm();
        });
        
        /************************************
         * 조회 클릭 이벤트
         ***********************************/
        $("#btn_sel").click(function(){
            //조회버튼 클릭시 페이징 초기화
            gridCurrentPage = 1;
            fn_sel("Y");
        });

        fn_init();
    });
     
    //초기화
    function fn_init(){
        kora.common.setEtcCmBx2(prps_cd, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');                                   //용도
        kora.common.setEtcCmBx2(ctnr_cd, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'T');                                    //빈용기명
        kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'T');                 //생산자
        kora.common.setEtcCmBx2(areaList, "","", $("#AREA"), "ETC_CD", "ETC_CD_NM", "N" ,'T');                                         //지역
        kora.common.setEtcCmBx2(whsl_se_cdList, "","", $("#WHSL_SE_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'E');                     //도매업자구분 
        kora.common.setEtcCmBx2(whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'E');      //도매업자 업체명
        $("#START_DT").val(kora.common.getDate("yyyy-mm-dd", "D", -7, false));                                                             //일주일전 날짜 
        $("#END_DT").val(kora.common.getDate("yyyy-mm-dd", "D", 0, false));                                                                //현재 날짜
	
        if($("#btn_onoff").attr("class") != "on") {
            $("#btn_onoff").click();
        }
    }
    
    //용도 변경시 빈용기명 조회
    function fn_prps_cd(){
        var url = "/WH/EPWH6110401_192.do" 
        var input ={};
        input["PRPS_CD"] =$("#PRPS_CD").val();
        if( $("#MFC_BIZRNM").val() !="" ){ //생산자 선택시 해당 빈용기만 조회
            input["MFC_BIZRID"] = arr[0];    //빈용기 테이블 조회
            input["MFC_BIZRNO"] = arr[1];
        }
        
        if($("#WHSDL_BIZRNM").val() !=""){     //도매업자 선택시
            input["CUST_BIZRID"] = arr2[0];        //도매업자아이디    
            input["CUST_BIZRNO"] = arr2[1];        //도매업자사업자번호  
        } 
        
        ajaxPost(url, input, function(rtnData) {
            if ("" != rtnData && null != rtnData) {  
                kora.common.setEtcCmBx2(rtnData.ctnr_cd, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'T');         //빈용기명
            }
            else{
                alert("error");
            }
        },false);
    }

    //생산자 변경시 생산자랑 거래중인 도매업자 조회 
    function fn_mfc_bizrnm(){
        var url   = "/WH/EPWH6110401_19.do" 
        var input = {};

        input["PRPS_CD"] = $("#PRPS_CD").val();
        
        if($("#WHSL_SE_CD").val() !=""){
            input["BIZR_TP_CD"] = $("#WHSL_SE_CD").val();
        }
        
        if( $("#MFC_BIZRNM").val() ==""){     //생산자 전체로 검색시
            input["MFC_BIZRID"] = "";  
            input["MFC_BIZRNO"] = "";
        }
        else{
            arr = [];
            arr =  $("#MFC_BIZRNM").val().split(";");
            input["MFC_BIZRID"] = arr[0];  
            input["MFC_BIZRNO"] = arr[1];
        }
        
        ajaxPost(url, input, function(rtnData) {
            if ("" != rtnData && null != rtnData) {   
                kora.common.setEtcCmBx2(prps_cd, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');                //용도
                kora.common.setEtcCmBx2(rtnData.ctnr_cd, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'T');         //빈용기명
            }
            else{
                alert("error");
            }
        },false);
    }
   
    //입고현황 조회
    function fn_sel(chartYN){
        var input    = {};
        var url      = "/WH/EPWH6110401_193.do" 
        var start_dt = $("#START_DT").val().replace(/-/gi, "");
        var end_dt   = $("#END_DT").val().replace(/-/gi, "");
        pagingCurrent = 1;
        
        //날짜 정합성 체크
        if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
            alert("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
            return; 
        }
        
        if(start_dt>end_dt){
            alert("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
            return;
        } 
        
        if($("#MFC_BIZRNM").val() !="" ){        //생산자
            var mfc_bizrnm = $("#MFC_BIZRNM").val();     
            arr = [];
            arr = mfc_bizrnm.split(";");
            input["MFC_BIZRID"] = arr[0];
            input["MFC_BIZRNO"] = arr[1];
        }
        
        if($("#WHSDL_BIZRNM").val() !="" ){        //생산자
            arr2 = [];
            arr2 = $("#WHSDL_BIZRNM").val().split(";");
            input["WHSDL_BIZRID"] = arr2[0];
            input["WHSDL_BIZRNO"] = arr2[1];
        }
        
        //조회 SELECT변수값
        input["AREA_CD"]    = $("#AREA").val();            
        input["PRPS_CD"]    = $("#PRPS_CD").val();
        input["CTNR_CD"]    = $("#CTNR_CD").val();
        input["START_DT"]   = $("#START_DT").val();            
        input["END_DT"]     = $("#END_DT").val();            
        input["BIZR_TP_CD"] = $("#WHSL_SE_CD").val(); //도매업자 구분
        input["CHART_YN"]   = chartYN;
        
        /* 페이징  */
        input["ROWS_PER_PAGE"] = gridRowsPerPage;
        input["CURRENT_PAGE"]  = gridCurrentPage;
           
        INQ_PARAMS["SEL_PARAMS"] = input;
        
		hideMessage();
        kora.common.showLoadingBar(dataGrid, gridRoot);

        ajaxPost(url, input, function(rtnData) {
            if ("" != rtnData && null != rtnData) {
                gridApp.setData(rtnData.selList);
                sumData = rtnData.totalList[0]; /* 총합계 추가 */
                   
                $("#QTY_TOT")     .text(kora.common.format_comma(sumData.QTY_TOT));
                $("#CRCT_QTY_TOT").text(kora.common.format_comma(sumData.CRCT_QTY_TOT));
                    
                if($("#btn_onoff").attr("class") == "on") {
                    $("#btn_onoff").click();
                }
                   
                /* 페이징 표시 */
                gridTotalRowCount = parseInt(rtnData.totalList[0].CNT); //총 카운트     /* 총합계 추가 */
                drawGridPagingNavigation(gridCurrentPage);
                
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
        layoutStr.push('    <DataGrid id="dg1" autoHeight="true" minHeight="750" rowHeight="110" styleName="gridStyle" wordWrap="true" variableRowHeight="true">'); //truncateToFit="true"
        layoutStr.push('        <columns>');
        layoutStr.push('            <DataGridColumn dataField="MFC_BIZRNM" width="66%" textAlign="center" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('mfc_bizrnm') + "&lt;br&gt;(" + fn_text('ctnr_nm')+ ")"+'"/>');     //생산자, 빈용기명
        layoutStr.push('            <DataGridColumn dataField="QTY_TOT"    width="33%" textAlign="center" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('lst_wrhs_qty') + "&lt;br&gt;" + fn_text('crct_cfm_qty') + '"/>');    //최종확인수량, 정정확인수량
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
			 	//취약점점검 6047 기원우
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
        
        if(dataField == "MFC_BIZRNM") {
            return item["MFC_BIZRNM"] + "</br>(" + item["CTNR_NM"]+")";
        }
        else if(dataField == "QTY_TOT") {
            return kora.common.format_comma(item["QTY_TOT"]) + "</br>(" + kora.common.format_comma(item["CRCT_QTY_TOT"])+")";
        }
        else {
            return "";
        }
    }
/****************************************** 그리드 셋팅 끝***************************************** */
</script>

</head>
<body>
    <div id="wrap">
        <input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
        <input type="hidden" id="prps_cd" value="<c:out value='${prps_cd}' />" />
        <input type="hidden" id="ctnr_cd" value="<c:out value='${ctnr_cd}' />" />
        <input type="hidden" id="mfc_bizrnmList" value="<c:out value='${mfc_bizrnmList}' />" />
        <input type="hidden" id="areaList" value="<c:out value='${areaList}' />" />
        <input type="hidden" id="whsl_se_cdList" value="<c:out value='${whsl_se_cdList}' />" />
        <input type="hidden" id="whsdlList" value="<c:out value='${whsdlList}' />" />
        
    
        <%@include file="/jsp/include/header_m.jsp" %>
        
        <%@include file="/jsp/include/aside_m.jsp" %>
        
        <div id="container">

            <div id="subvisual">
                <h2 class="tit" id="title"></h2>
            </div><!-- id : subvisual -->

            <div id="contents">
                <div class="btn_manage">
                    <button type="button" id="btn_onoff"></button>
                </div>
                <div class="manage_wrap" id="params">
                    <div class="contbox">
                        <div class="boxed">
                            <div class="sort">조회기간</div>
                            <div class="cont" style="font-size:28px;color:#222222;">입고확인일자 기준</div>
                        </div>
                        <div class="boxed">
                            <input type="text" id="START_DT" name="from" style="width: 285px;" readonly>
                            <span class="swung">~</span>
                            <input type="text" id="END_DT" name="to" style="width: 285px;" readonly>
                        </div>
                    </div>
                    <div class="contbox v2">
                        <div class="boxed">
                            <div class="sort" id="mfc_bizrnm"></div>
                            <select id="MFC_BIZRNM" style="width: 435px;"></select>
                        </div>
                        <div class="boxed">
                            <div class="sort" id="prps_nm"></div>
                            <select id="PRPS_CD" style="width: 435px;"></select>
                        </div>
                        <div class="boxed">
                            <div class="sort" id="ctnr_nm"></div>
                            <select id="CTNR_CD" style="width: 435px;"></select>
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
                                        <col style="width: 195px;">
                                        <col style="width: auto;">
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th rowspan="3">입고량</th>
                                            <td>최종확인수량</td>
                                            <td><span id="QTY_TOT"></span></td>
                                        </tr>
                                        <tr>
                                            <td>정정확인수량</td>
                                            <td><span id="CRCT_QTY_TOT"></span></td>
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