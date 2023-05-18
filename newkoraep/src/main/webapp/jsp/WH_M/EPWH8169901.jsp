<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>FAQ</title>
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

    var jParams = {};

    /* 페이징 사용 등록 */
    gridRowsPerPage = 12; // 1페이지에서 보여줄 행 수
    gridCurrentPage = 1; // 현재 페이지

    $(document).ready(function() {

        //버튼 셋팅
        fn_btnSetting();

        $('#sel').text(parent.fn_text('sel'));
        $('#sch').text(parent.fn_text('sch'));
        /* $('#sbj').text(parent.fn_text('sbj')); */
        $('#cnts').text(parent.fn_text('cnts'));
        $('#cnt').text(parent.fn_text('cnt'));
        $('#lst').text(parent.fn_text('lst'));
        $('#reg').text(parent.fn_text('reg'));
        $('#no').text(parent.fn_text('no'));
        $('#reg_prsn').text(parent.fn_text('reg_prsn'));
        $('#reg_dt').text(parent.fn_text('reg_dt'));
        $('#bizr_nm').text(parent.fn_text('bizr_nm'));

        /* 페이징 사용 등록 */
        gridTotalRowCount = ${totalCnt}[0].CNT;

        //페이지이동 조회조건 파라메터 정보
        jParams = ${INQ_PARAMS};

        //페이지이동 조회조건 데이터 셋팅
        kora.common.jsonToTable("TABLE_INQ", jParams);

        gridSet();

        //$("#total").text("총 "+totalRow+"건");

        $("#btn_reg").click(function() {
            fn_reg();
        });

        //목록
        $("#btn_lst").click(function() {
            location.href = "/WH/EPWH8169901.do";
        });

        //조회
        $("#btn_sel").click(function() {
            search();
        });

        $("#word").keypress(function(e) {
            if (e.which == 13) {
                search();
            }
        });
    });

    //FAQ등록 화면으로 이동
    function fn_reg() { //이전 linkfqfm

        var sAction = "/WH/EPWH8169998.do";

        var jParams = {
            "FN_CALLBACK": "search"
        };
        kora.common.goPageD(sAction, jParams, {
            "cate": $("#cate").val(),
            "word": $("#word").val(),
            "NOW_PAGE": gridCurrentPage
        });

    }

    //상세조회링크
    function fn_dtl_sel_lk(faq_seq) { //이전 link

        var idx = dataGrid.getSelectedIndices();

        var item = gridRoot.getItemAt(idx);

        var sAction = "/WH/EPWH8169997.do";

        //페이지이동
        kora.common.goPageD(sAction, {
            "FAQ_SEQ": faq_seq
        }, {
            "cate": $("#cate").val(),
            "word": $("#word").val(),
            "NOW_PAGE": gridCurrentPage,
            "FN_CALLBACK": "search"
        });

    };

    //rMate 그리드 생성 준비가 완료된 상태 시 호출할 함수를 지정합니다.
    var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
    var gridApp, gridRoot, dataGrid;
    var layoutStr = new Array();

    function gridSet() {

        //rMateDataGrid 를 생성합니다.
        //파라메터 (순서대로)
        //1. 그리드의 id ( 임의로 지정하십시오. )
        //2. 그리드가 위치할 div 의 id (즉, 그리드의 부모 div 의 id 입니다.)
        //3. 그리드 생성 시 필요한 환경 변수들의 묶음인 jsVars
        //4. 그리드의 가로 사이즈 (생략 가능, 생략 시 100%)
        //5. 그리드의 세로 사이즈 (생략 가능, 생략 시 100%)
        rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%");
        layoutStr.push('<rMateGrid>');
        layoutStr.push('    <DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
        layoutStr.push('    <NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
        layoutStr.push('    <DataGrid id="dg1" autoHeight="true" minHeight="550" rowHeight="110" styleName="gridStyle" verticalAlign="middle" wordWrap="true" variableRowHeight="true">');
        layoutStr.push('        <columns>');
        /* layoutStr.push('         <DataGridColumn dataField="RNUM" headerText="'+parent.fn_text('no')+'" textAlign="center" width="4%" />'); */
        layoutStr.push('            <DataGridColumn dataField="SBJ" headerText="' + parent.fn_text('sbj') + '" width="65%" itemRenderer="HtmlItem" />');
        layoutStr.push('            <DataGridColumn dataField="REG_DTTM" headerText="' + parent.fn_text('reg_dt') + '" width="24%" formatter="{datefmt2}" textAlign="center" />');
        layoutStr.push('        </columns>');
        layoutStr.push('    <dataProvider>');
        layoutStr.push('            <SpanArrayCollection source="{$gridData}"/>');
        layoutStr.push('    </dataProvider>');
        layoutStr.push('    </DataGrid>');
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
        
        
    }

    //그리드의 속성인 rMateOnLoadCallFunction 으로 설정된 함수.
    //rMate 그리드의 준비가 완료된 경우 이 함수가 호출됩니다.
    //이 함수를 통해 그리드에 레이아웃과 데이터를 삽입합니다.
    //파라메터 : id - rMateGridH5.create() 사용 시 사용자가 지정한 id 입니다.
    function gridReadyHandler(id) {
        gridApp = document.getElementById(id); // 그리드를 포함하는 div 객체
        gridRoot = gridApp.getRoot(); // 데이터와 그리드를 포함하는 객체

        gridApp.setLayout(layoutStr.join("").toString());

        var selectionChangeHandler = function(event) {
            var rowIndex = event.rowIndex;
            var columnIndex = event.columnIndex;
        }

        var layoutCompleteHandler = function(event) {
            dataGrid = gridRoot.getDataGrid(); // 그리드 객체
            dataGrid.addEventListener("change", selectionChangeHandler);
        }

        var dataCompleteHandler = function(event) {
            dataGrid = gridRoot.getDataGrid(); // 그리드 객체
            dataGrid.setEnabled(true);
            gridRoot.removeLoadingBar();
        }

        gridRoot.addEventListener("dataComplete", dataCompleteHandler);
        gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
        gridApp.setData([]); //${searchList}

        /* 페이징 사용 등록 */
        if (kora.common.null2void(jParams.FN_CALLBACK) != "") {
            /* eval(jParams.FN_CALLBACK+"()"); */
	    	 window[jParams.FN_CALLBACK]();
	    				 	//취약점점검 6050 기원우
        } else {
            gridMovePage(gridCurrentPage);
        }

    }

    function showLoadingBar() {
        if (dataGrid != null && dataGrid != "undefined") {
            dataGrid.setEnabled(false);
            gridRoot.addLoadingBar();
        }
    }

    function hideLoadingBar() {
        if (dataGrid != null && dataGrid != "undefined") {
            dataGrid.setEnabled(true);
            gridRoot.removeLoadingBar();
        }
    }

    function gridMovePage(goPage) {

        search(goPage);

    }

    //페이징 조회
    function search(goPage) {

        if (goPage == null) {
            if ($("#NOW_PAGE").val() > 0) {
                goPage = $("#NOW_PAGE").val();
            } else {
                goPage = gridCurrentPage
            }
        }

        var sData = {
            "CONDITION": $("#cate").val(),
            "WORD": $("#word").val(),
            "PAGE": goPage,
            "CNTROW": gridRowsPerPage
        };
        var url = "/WH/EPWH8169901_19.do";

        showLoadingBar();
        ajaxPost(url, sData, function(rtnData) {

            if (rtnData != null && rtnData != "") {

                gridTotalRowCount = rtnData.totalCnt[0].CNT;
                gridCurrentPage = goPage;
                drawGridPagingNavigation(goPage);
                gridApp.setData(rtnData.searchList);
                $("#total").text(parent.fn_text('tot') + " " + gridTotalRowCount + parent.fn_text('cnt'));
                
				if (rtnData.searchList.length == 0) {
					showMessage();	
				} else {
					hideMessage();
				}
            } else {
                alert("error");
            }

        });
        hideLoadingBar();
    }
</script>
</head>
<body>
<input type="hidden" id="cate" value="sbj">
    <div id="wrap">

        <%@include file="/jsp/include/header_m.jsp" %>

        <%@include file="/jsp/include/aside_m.jsp" %>

        <div id="container">

            <div id="subvisual">
                <h2 class="tit">FAQ</h2>
            </div><!-- id : subvisual -->

            <div id="contents">
                <div class="srch_box">
                    <input type="text" placeholder="검색어를 입력해주세요." id="word">
                    <button type="button" class="btn_srch" id="btn_sel"></button>
                </div>
                <div class="contbox v4 pb40 mt20">
                    <div class="tbl_board">
                        <div id="gridHolder" style="height:775px;"></div>
                    </div>
                    <div class="pagination mt20">
                        <div class="paging">
                            <div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
                        </div>
                    </div>
                </div>
            </div><!-- id : contents -->

        </div><!-- id : container -->

        <%@include file="/jsp/include/footer_m.jsp" %>

    </div><!-- id : wrap -->

</body>
</html>