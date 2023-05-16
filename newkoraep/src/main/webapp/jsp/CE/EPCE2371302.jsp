<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>고지서취소요청내역조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>

<script type="text/javaScript" language="javascript" defer="defer" >
    
    /* 페이징 사용 등록 */
    gridRowsPerPage = 15;    // 1페이지에서 보여줄 행 수
    gridCurrentPage = 1;        // 현재 페이지
    gridTotalRowCount = 0;     //전체 행 수
    
    var toDay = kora.common.gfn_toDay();  // 현재 시간
    var mfc_bizrnm_sel;
    var stat_cdList;
    var execHistPram ={};
    var parent_item; 
    $(document).ready(function(){
        
        mfc_bizrnm_sel = jsonObject($("#mfc_bizrnm_sel_list").val());//생산자
        stat_cdList = jsonObject($("#stat_cdList_list").val());//상태

        toDay = toDay.substring(0,4)+"-"+toDay.substring(4,6)+"-"+toDay.substring(6);
        $('#START_DT').YJcalendar({  
            toName : 'to',
            triggerBtn : true,
            dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
        });
        $('#END_DT').YJcalendar({
            fromName : 'from',
            triggerBtn : true,
            dateSetting : toDay.replaceAll('-','')
        });
    
        for(var i=0;i<25;i++){ // 시간 셋팅
            if(i < 10){  
                $("#STR_TM").append('<option value="0'+i+'">0'+i+'</option>');
                $("#ETR_TM").append('<option value="0'+i+'">0'+i+'</option>');
            } else {
                $("#STR_TM").append('<option value="'+i+'">'+i+'</option>');
                $("#ETR_TM").append('<option value="'+i+'">'+i+'</option>');
                    
            } 
        }// end of for 
        
        $("#ETR_TM").val("24");   //시간 24시로 설정
        fnSetGrid();  //그리드 셋팅
    
        kora.common.setEtcCmBx2(mfc_bizrnm_sel, "", "", $("#MFC_BIZRNM_SEL"), "BIZRID_NO", "BIZRNM", "N", "T");
        kora.common.setEtcCmBx2(stat_cdList, "","", $("#REQ_STAT_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');
        
        /************************************
         * 시작날짜  클릭시 - 삭제  변경 이벤트
         ***********************************/
        $("#START_DT").click(function(){
            var start_dt = $("#START_DT").val();
            start_dt   =  start_dt.replace(/-/gi, "");
            $("#START_DT").val(start_dt)
        });
        /************************************
         * 시작날짜  클릭시 - 추가  변경 이벤트
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
         * 끝날짜  클릭시 - 추가  변경 이벤트
         ***********************************/
        $("#END_DT").change(function(){
            var end_dt  = $("#END_DT").val();
            end_dt =  end_dt.replace(/-/gi, "");
            if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd")
            $("#END_DT").val(end_dt) 
        });
        
        
        /************************************
         * 조회버튼 클릭 이벤트
         ***********************************/
        $("#btn_sel").click(function(){
            //조회버튼 클릭시 페이징 초기화
            gridCurrentPage = 1;
            fn_sel();
        });
        
        $('#menu_set_sel').text(parent.fn_text('menu_set'));
        $('#sel_term').text(parent.fn_text('sel_term'));          //조회기간
        $('#sc_nm').text(parent.fn_text('sc_nm'));
        $('#mfc_bizrnm_sel').text(parent.fn_text('mfc_bizrnm'));    //생산자
        $('#stat').text(parent.fn_text('stat'));                  //상태
        
    });
    
    /* 페이징 이동 스크립트 */
    function gridMovePage(goPage) {
        gridCurrentPage = goPage; //선택 페이지
        fn_sel(); //조회 펑션
    }

    function fn_sel(){
        var input ={}
        var url ="/CE/EPCE2371302_19.do";
        var start_dt = $("#START_DT").val();
        var end_dt = $("#END_DT").val();
        
        start_dt = start_dt.replace(/-/gi, "");
        end_dt = end_dt.replace(/-/gi, "");
        
        //날짜 정합성 체크. 20160204
        if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
            alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
            return; 
        }

        if(start_dt>end_dt){
            alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
            return;
        } 
        
        //날짜포맷확인
        if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd");
        if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd");
        
        input["START_DT"] = $("#START_DT").val()   //시작날짜
        input["END_DT"] = $("#END_DT").val()   //끝날짜
        input["MFC_BIZRNM_SEL"] = $("#MFC_BIZRNM_SEL").val()//생산자
        input["REQ_ID"] = $("#REQ_ID").val()   //아이디
        input["BILL_DOC_NO"] = $("#BILL_DOC_NO").val()   //반환문서번호    
        input["REQ_STAT_CD"] = $("#REQ_STAT_CD").val()   //상태
        
        /* 페이징  */
        input["ROWS_PER_PAGE"] = gridRowsPerPage;
        input["CURRENT_PAGE"]     = gridCurrentPage;
        
        showLoadingBar();
        ajaxPost(url,input, function(rtnData){
            if(rtnData != null && rtnData != ""){
                gridApp.setData(rtnData.execHistList);
                
                /* 페이징 표시 */
                gridTotalRowCount = rtnData.totalCnt; //총 카운트
                drawGridPagingNavigation(gridCurrentPage);
            } else {
                alertMsg("error");
            }
        }, false);
        hideLoadingBar();
    }    

    function link() {
        var idx = dataGrid.getSelectedIndices();
        var pagedata = window.frameElement.name;
        parent_item = gridRoot.getItemAt(idx);
        window.parent.NrvPub.AjaxPopup('/CE/EPCE2371388.do', pagedata);
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
    function fnSetGrid(reDrawYn) {
        rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%");

        layoutStr = new Array();
        layoutStr.push('<rMateGrid>');
        layoutStr    .push('    <NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
        layoutStr.push('    <DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" sortableColumns="true"   horizontalGridLines="true" headerHeight="35">');
        layoutStr.push('        <columns>');
        layoutStr.push('            <DataGridColumn dataField="PNO" headerText="'+ parent.fn_text('sn')+ '" textAlign="center" width="5%"   draggable="false"/>');
        layoutStr.push('            <DataGridColumn dataField="REQ_DATE" headerText="요청일자" width="8%" textAlign="center"/>');
        layoutStr.push('            <DataGridColumn dataField="BILL_SE_NM" headerText="고지서구분" width="10%" textAlign="center" />');
        layoutStr.push('            <DataGridColumn dataField="BILL_DOC_NO" headerText="고지서문서번호" width="12%" itemRenderer="HtmlItem"  textAlign="center" />');
        layoutStr.push('            <DataGridColumn dataField="BIZRNM" headerText="사업자명" width="17%" textAlign="center" />');
        layoutStr.push('            <DataGridColumn dataField="REQ_ID" headerText="아이디" width="10%" textAlign="center"/>');
        layoutStr.push('            <DataGridColumn dataField="USER_NM" headerText="성명" width="10%" textAlign="center"/>');
        layoutStr.push('            <DataGridColumn dataField="REQ_STAT_NM" headerText="상태" width="10%" textAlign="center"/>');
        layoutStr.push('            <DataGridColumn dataField="PARAM" headerText="요청사유" width="8%" textAlign="center" itemRenderer="HtmlItem"/>');
        layoutStr.push('            <DataGridColumn dataField="CNL_REQ_SEQ" headerText="CNL_REQ_SEQ" visible="false" />');
        layoutStr.push('        </columns>');
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
        gridApp.setData([]);
        var layoutCompleteHandler = function(event) {
            dataGrid = gridRoot.getDataGrid(); // 그리드 객체
            dataGrid.addEventListener("change", selectionChangeHandler);
            drawGridPagingNavigation(gridCurrentPage);  //페이징 표시
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
    
    /****************************************** 그리드 셋팅 끝***************************************** */
</script>
            
<style type="text/css">
.row .col select{ 
width: 180px; 
}
</style>    
</head>
<body>
    <div class="iframe_inner">
        <input type="hidden" id="mfc_bizrnm_sel_list" value="<c:out value='${mfc_bizrnm_sel}' />" />
        <input type="hidden" id="stat_cdList_list" value="<c:out value='${stat_cdList}' />" />
        <div class="h3group">
            <h3 class="tit" id="title"></h3>
        </div>
        <section class="secwrap">
            <div class="srcharea" id="divInput">
                <div class="row">
                    <div class="col">
                        <div class="tit" id="sel_term" style="width:90px"></div>
                        <div class="box" style="width:380px">
                            <div class="calendar">
                                <input type="text" id="START_DT" name="from" style="width: 180px;" class="i_notnull" >
                            </div>
                                    
                            <div class="obj">~</div>
                                    
                            <div class="calendar">
                                <input type="text" id="END_DT" name="to" style="width: 180px;" class="i_notnull" >
                            </div>
                                    
                        </div>
                    </div>
            
                    <div class="col" style="width:300px">  <!-- 생산자 선택 -->
                        <div class="tit" id="mfc_bizrnm_sel" style="width:50px"></div>
                        <div class="box">
                            <select id="MFC_BIZRNM_SEL" style="width: 179px"></select>
                        </div>
                    </div>
                        
                    <div class="col">
                        <div class="tit" style="width:50px">아이디</div>
                        <div class="box">
                            <input type="text" id="REQ_ID" maxlength="15" style="width: 180px; text-align: center;"  alt="아이디" >
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col">
                        <div class="tit" style="width:90px">고지서문서번호</div>
                        <div class="box" style="width:380px">
                            <input type="text" id="BILL_DOC_NO" maxlength="15"    style="width: 180px; text-align: center;"  alt="반환문서번호 " >
                        </div>
                    </div>
                    <div class="col" >
                        <div class="tit" id="stat" style="width:50px"></div> 
                        <div class="box">
                            <select style="width: 180px;" id="REQ_STAT_CD"></select>
                        </div>
                    </div>
                    <div class="btn">
                        <button type="button" class="btn36 c1" style="width: 100px;" id="btn_sel">조회</button>
                    </div>
                </div>        <!-- end of row -->
            </div>    <!-- end of srcharea --> 
        </section>
    
        <section class="secwrap mt10">
                <div class="boxarea mt10">
                    <div id="gridHolder" style="height: 560px; background: #FFF;"></div>
                </div><!-- 그리드 셋팅 --> 
                <div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
        </section>
        <input  type="hidden" id="PAGE_REG_DTTM"/> 
    </div> <!-- end of  iframe_inner -->
</body>
</html>        