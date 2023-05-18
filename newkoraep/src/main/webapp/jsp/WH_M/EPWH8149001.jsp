<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>공지사항</title>
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
    gridRowsPerPage = 15; // 1페이지에서 보여줄 행 수
    gridCurrentPage = 1; // 현재 페이지

    $(document).ready(function() {

        //버튼 셋팅
        //fn_btnSetting();

        //언어관리
        $('#tot').text(fn_text('tot'));
        $('#cnt').text(fn_text('cnt'));
        $('#sel').text(fn_text('sel'));
        $('#sch').text(fn_text('sch'));
        $('#sbj').text(fn_text('sbj'));
        $('#cnts').text(fn_text('cnts'));
        $('#lst').text(fn_text('lst'));
        $('#reg').text(fn_text('reg'));
        $('#no').text(fn_text('no'));
        $('#reg_dt').text(fn_text('reg_dt'));
        $('#sel_cnt').text(fn_text('sel_cnt'));

        /*상세조회 바로이동*/
        var notiSeq = "<c:out value='${NOTI_SEQ}' />";
        if (notiSeq != '') {
            var sAction = "/WH/EPWH8149093.do";

            //페이지이동
            kora.common.goPageD(sAction, {
                "NOTI_SEQ": notiSeq
            }, {});
        }
        /*상세조회 바로이동*/


        /* 페이징 사용 등록 */
        gridTotalRowCount = ${totalCnt}[0].CNT;

        //페이지이동 조회조건 파라메터 정보
        jParams = ${INQ_PARAMS};

        //페이지이동 조회조건 데이터 셋팅
        kora.common.jsonToTable("TABLE_INQ", jParams);

        gridSet();


        $("#btn_reg").click(function() {
            fn_reg();
        });

        //목록
        $("#btn_lst").click(function() {
            fn_lst();
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

    //공지사항등록 화면으로 이동
    function fn_reg() {
        var sAction = "/WH/EPWH8149094.do";

        var jParams = {
            "FN_CALLBACK": "search"
        };
        kora.common.goPageD(sAction, jParams, {
            "cate": "sbj",
            "word": $("#word").val(),
            "NOW_PAGE": gridCurrentPage
        });
    }

    //목록
    function fn_lst() {
        location.href = "/WH/EPWH8149001.do";
    }


    //상세조회링크
    function fn_dtl_sel_lk(noti_seq) {
        var idx = dataGrid.getSelectedIndices();
        var item = gridRoot.getItemAt(idx);
        var sAction = "/WH/EPWH8149093.do";

        //페이지이동
        kora.common.goPageD(sAction, {
            "NOTI_SEQ": noti_seq
        }, {
            "cate": "sbj",
            "word": $("#word").val(),
            "NOW_PAGE": gridCurrentPage,
            "FN_CALLBACK": "search"
        });
    }

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
        layoutStr.push('    <DataGrid id="dg1" autoHeight="true" minHeight="750" rowHeight="70" styleName="gridStyle" wordWrap="true" variableRowHeight="true">'); //truncateToFit="true"
        layoutStr.push('        <columns>');
        //layoutStr.push('          <DataGridColumn dataField="NOTI_SEQ" headerText="'+fn_text('no')+'" textAlign="center"  width="4%" />');
        layoutStr.push('            <DataGridColumn dataField="SBJ" headerText="' + fn_text('sbj') + '" itemRenderer="HtmlItem" width="73%"  />');
        layoutStr.push('            <DataGridColumn dataField="REG_DTTM" headerText="' + fn_text('reg_dt') + '" formatter="{datefmt2}" textAlign="center" width="27%"/>');
        //layoutStr.push('          <DataGridColumn dataField="SEL_CNT" headerText="'+fn_text('sel_cnt')+'" formatter="{numfmt}" textAlign="center" width="6%" />');
        layoutStr.push('        </columns>');
        layoutStr.push('    </DataGrid>');
        layoutStr.push('    <Style>');
        layoutStr.push('        .gridStyle {');
        layoutStr.push('            headerColors:#565862,#565862;');
        layoutStr.push('            headerStyleName:gridHeaderStyle;');
        layoutStr.push('            verticalAlign:middle;headerHeight:70;fontSize:28;');
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
        gridApp.setData([]);

        /* 페이징 사용 등록 */
        if (kora.common.null2void(jParams.FN_CALLBACK) != "") {
			/*  eval(jParams.FN_CALLBACK+"()"); */
	    	 window[jParams.FN_CALLBACK]();
	    				 	//취약점점검 6049 기원우
	    				 	
        } else {
            gridMovePage(gridCurrentPage);
        }

    }

    // labelJsFunction 기능을 이용하여 Quarter 컬럼에 월 분기 표시를 함께 넣어줍니다.
    // labelJsFunction 함수의 파라메터는 다음과 같습니다.
    // function labelJsFunction(item:Object, value:Object, column:Column)
    //        item : 해당 행의 data 객체
    //        value : 해당 셀의 라벨
    //        column : 해당 셀의 열을 정의한 Column 객체
    // 그리드 설정시 DataGridColumn 항목에 추가 (예: labelJsFunction="convertItem")
    function convertItem(item, value, column) {
        var subject = item["SBJ"];
        var dttm = item["REG_DTTM"];
        var result = item["SBJ"] + "</BR>" + item["REG_DTTM"];

        return result;
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
            "CONDITION": "sbj",
            "WORD": $("#word").val(),
            "PAGE": goPage,
            "CNTROW": gridRowsPerPage
        };
        var url = "/WH/EPWH8149001_19.do";


        showLoadingBar();
        ajaxPost(url, sData, function(rtnData) {
            if (rtnData != null && rtnData != "") {
                /* 페이징 사용 등록 */
                gridTotalRowCount = rtnData.totalCnt[0].CNT;
                gridCurrentPage = goPage;
                drawGridPagingNavigation(goPage);

                gridApp.setData(rtnData.searchList);

                $("#total").text(fn_text('tot') + " " + gridTotalRowCount + fn_text('cnt'));
                
				if (rtnData.searchList.length == 0) {
					showMessage();	
				} else {
					hideMessage();
				}
            } else {
                alert("error");
            }
            hideLoadingBar();
        });
    }
</script>
</head>
<body>
    <div id="wrap">

        <%@include file="/jsp/include/header_m.jsp" %>

        <%@include file="/jsp/include/aside_m.jsp" %>

        <div id="container">

            <div id="subvisual">
                <h2 class="tit" id="title"></h2>
            </div><!-- id : subvisual -->

            <div id="contents">
                <div class="srch_box">
                    <input type="text" placeholder="검색어를 입력해주세요." id="word">
                    <button type="button" class="btn_srch" id="btn_sel"></button>
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
            </div><!-- id : contents -->

        </div><!-- id : container -->

        <%@include file="/jsp/include/footer_m.jsp" %>

    </div><!-- id : wrap -->

</body>
</html>