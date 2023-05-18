<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>직매장/공장관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>
<script type="text/javaScript" language="javascript" defer="defer">

    /* 페이징 사용 등록 */
    gridRowsPerPage = 15;   // 1페이지에서 보여줄 행 수
    gridCurrentPage = 1;    // 현재 페이지
    gridTotalRowCount = 0; //전체 행 수
    
     var INQ_PARAMS ;
     var mfc_bizrnmList ;
     var stat_cd_list;
     var area_cd_list;
     var pay_exec_yn_list;
     var grp_brch_no_list;
     var arr    = new Array();                                  //생산자
     var arr2 = new Array();                                //직매장
     var pagingCurrent = 1;
     var parent_item;                                           //팝업창 오픈시 필드값
     var checkData      ="Y"
     $(function() {
         
         INQ_PARAMS         = jsonObject($('#INQ_PARAMS').val());       //파라미터 데이터
         mfc_bizrnmList     = jsonObject($('#mfc_bizrnmList').val());       //생산자
         stat_cd_list       = jsonObject($('#stat_cd_list').val());         //상태
         area_cd_list       = jsonObject($('#area_cd_list').val());         //지역 
         pay_exec_yn_list   = jsonObject($('#pay_exec_yn_list').val());     //지급실행여부
         grp_brch_no_list   = jsonObject($('#grp_brch_no_list').val()); //총괄매장
         
         //버튼 셋팅
         fn_btnSetting();
         
         //그리드 셋팅
         fnSetGrid1();

         /************************************
         * 생산자 변경 이벤트
         ***********************************/
        $("#BIZRNM").change(function(){
            fn_mfc_bizrnm();
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
         * 활동복원 클릭 이벤트
         ***********************************/
        $("#btn_upd").click(function(){
            checkData="Y"
            fn_upd_chk();
        });
        
        /************************************
         * 비활동처리 클릭 이벤트
         ***********************************/
        $("#btn_upd2").click(function(){
            checkData="N"
            fn_upd_chk();
        });
        
        /************************************
         * 지역설정 클릭 이벤트
         ***********************************/
        $("#btn_upd3").click(function(){
            fn_upd3();
        });
        
        /************************************
         * 변경 클릭 이벤트
         ***********************************/
        $("#btn_upd4").click(function(){
            fn_upd4();
        });
        
        /************************************
         * 등록 클릭 이벤트
         ***********************************/
        $("#btn_reg").click(function(){
            fn_reg();
        });
        
        /************************************
         * 엑셀다운로드 버튼 클릭 이벤트
         ***********************************/
        $("#btn_excel").click(function() {
            fn_excel();
         });
        
        fn_init();
    });
     
     //초기화
     function fn_init(){
             kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#BIZRNM"), "BIZRID_NO", "BIZRNM", "N");          //생산자
            fn_mfc_bizrnm();
             //kora.common.setEtcCmBx2([], "","", $("#GRP_BRCH_CD"), "BRCH_NO", "BRCH_NM", "N" ,'T');                   //총괄직매장
             kora.common.setEtcCmBx2(area_cd_list, "","", $("#AREA_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');              //지역
             kora.common.setEtcCmBx2(stat_cd_list, "","", $("#STAT_CD"), "ETC_CD", "ETC_CD_NM", "N",'T');                   //상태
             //kora.common.setEtcCmBx2(pay_exec_yn_list, "","", $("#PAY_EXEC_YN"), "ETC_CD", "ETC_CD_NM", "N" ,'T');    //지급실행여부
        
             //text 셋팅
            $('#title_sub').text('<c:out value="${titleSub}" />');                                  //타이틀
            $('#mfc_bizrnm').text(parent.fn_text('mfc_bizrnm'));            //생산자
            $('#grp_brch_nm').text(parent.fn_text('grp_brch_nm'));  //총괄직매장상생산자
            $('#area').text(parent.fn_text('area'));                            //지역
            $('#stat').text(parent.fn_text('stat'));                                //상태
            $('#pay_exec_yn').text(parent.fn_text('pay_exec_yn'));      //지급실행여부
            
             //파라미터 조회조건으로 셋팅
             if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
                    if(grp_brch_no_list !=null){
                        kora.common.setEtcCmBx2(grp_brch_no_list, "","", $("#GRP_BRCH_NO"), "BRCH_NO", "BRCH_NM", "N" ,'T');        //총괄지점
                    }
                    kora.common.jsonToTable("params",INQ_PARAMS.SEL_PARAMS);
                    /* 화면이동 페이징 셋팅 */
                    gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
                }
  }
     
   //총괄직매장 조회
   function fn_mfc_bizrnm(){
            var url = "/MF/EPMF0150201_19.do" 
            var input ={};
            if($("#BIZRNM").val() !="" ){       //생산자
                    arr  =[];
                    arr  = $("#BIZRNM").val().split(";");
                    input["BIZRID"]     = arr[0];
                    input["BIZRNO"]     = arr[1];
                    ajaxPost(url, input, function(rtnData) {
                                if ("" != rtnData && null != rtnData) {   
                                     kora.common.setEtcCmBx2(rtnData.grp_brch_noList, "","", $("#GRP_BRCH_CD"), "BRCH_NO", "BRCH_NM", "N" ,'T');                //직매장/공장
                                 }else{
                                         alertMsg("error");
                                }
                    });
             }else{
                 kora.common.setEtcCmBx2([], "","", $("#GRP_BRCH_CD"), "BRCH_NO", "BRCH_NM", "N" ,'T');                 //총괄직매장
             }
   }
  
   //조회
    function fn_sel(){
     var input  ={};
     var url = "/MF/EPMF0150201_192.do" 
          pagingCurrent = 1;
             
         if($("#BIZRNM").val() !="" ){      //생산자
             arr     =[];
             arr     = $("#BIZRNM").val().split(";");
             input["BIZRID"]        = arr[0];
             input["BIZRNO"]        = arr[1];
         }
         
         input["BIZRNM"]                = $("#BIZRNM").val();                       //생산자IDNO
         input["GRP_BRCH_NO"]   = $("#GRP_BRCH_CD").val();          //총괄직매장
         input["STAT_CD"]               = $("#STAT_CD").val();                  //상태
         input["AREA_CD"]               = $("#AREA_CD").val();                  //지역
         //input["PAY_EXEC_YN"]     = $("#PAY_EXEC_YN").val();          //지급실행여부
         
        /* 페이징  */
        input["ROWS_PER_PAGE"] = gridRowsPerPage;
        input["CURRENT_PAGE"]   = gridCurrentPage;
        INQ_PARAMS["SEL_PARAMS"] = input;
        showLoadingBar();
        ajaxPost(url, input, function(rtnData) {
                if ("" != rtnData && null != rtnData) {   
                    gridApp.setData(rtnData.selList);
                    /* 페이징 표시 */
                gridTotalRowCount = rtnData.totalCnt; //총 카운트
                drawGridPagingNavigation(gridCurrentPage);
                }else{
                         alertMsg("error");
                }
        },false);
        hideLoadingBar(); 
    }
   
    /* 페이징 이동 스크립트 */
    function gridMovePage(goPage) {
        gridCurrentPage = goPage; //선택 페이지
        fn_sel(); //조회 펑션
    }
    
    //활동복원 ,비활동처리
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
                if(item["STAT_CD"] ==checkData){     
                    alertMsg("올바르지 않은 상태의 내역이 선택 되었습니다.\n\n다시 한 번 확인하시기 바랍니다.");
                    return;
                }
         }
            if(checkData =="Y"){
                confirm("선택하신 내역이 모두 활동복원 상태로 변경됩니다.\n\n계속 진행하시겠습니까?","fn_upd");
            }else{
                confirm("선택하신 내역이 모두 비활동처리 상태로 변경됩니다.\n\n계속 진행하시겠습니까?","fn_upd");
            }
    }
    
    //활동복원 ,비활동처리
    function fn_upd(){
        var selectorColumn = gridRoot.getObjectById("selector");
        var input = {"list": ""};
        var row = new Array();
        var url ="/MF/EPMF0150201_21.do";

         for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
                var item = {};
                item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
                item.STAT_CD =checkData;
                row.push(item);
         }
        input["list"] = JSON.stringify(row);

            ajaxPost(url, input, function(rtnData){
                if(rtnData.RSLT_CD == "0000"){
                    alertMsg(rtnData.RSLT_MSG, 'fn_sel');
                }else{
                    alertMsg(rtnData.RSLT_MSG);
                }
            },false);     
        
    }   
    
    //지역설정
    function fn_upd3(){
        var selectorColumn = gridRoot.getObjectById("selector");
        var input = {"list": ""};
        var row = new Array();
        var areaCnt=0;
        
        if(selectorColumn.getSelectedIndices() == "") {
            alertMsg("선택한 건이 없습니다.");
            return false;
        }
         for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
                var item = {};
                item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
                row.push(item);
                areaCnt++
         }
        input["list"]           =   row;
        input["areaCnt"]    =   areaCnt;
        input["INQ_PARAMS"]  =INQ_PARAMS.SEL_PARAMS;
        parent_item= input;
        var pagedata = window.frameElement.name;
        var url = "/MF/EPMF0150288.do";     //지역설정
        window.parent.NrvPub.AjaxPopup(url, pagedata);
    }
    
    //변경페이지
    function fn_upd4(){

        var chkLst = selectorColumn.getSelectedItems();
        var item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[0]);
        
        if(chkLst.length < 1){
            alertMsg("선택된 행이 없습니다.");
            return;
        }
        
        if(chkLst.length > 1){
            alertMsg("한건만 선택이 가능합니다.");
            return;
        }

        //파라미터에 조회조건값 저장 
        INQ_PARAMS["PARAMS"] = {};
        INQ_PARAMS["PARAMS"] = item;
        INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
        INQ_PARAMS["URL_CALLBACK"] = "/MF/EPMF0150201.do";
        kora.common.goPage("/MF/EPMF0150242.do", INQ_PARAMS);
    }
    
    //등록페이지
    function fn_reg(){
        INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
        INQ_PARAMS["URL_CALLBACK"] = "/MF/EPMF0150201.do";
        kora.common.goPage("/MF/EPMF0150231.do", INQ_PARAMS);
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
        var fileName = $('#title_sub').text().replace("/","_") +"_" + today+hour+min+sec+".xlsx";
        
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
         var url = "/MF/EPMF0150201_05.do"; 
        ajaxPost(url, input, function(rtnData){
            if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
                alertMsg(rtnData.RSLT_MSG);
            }else{
                //파일다운로드
                frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
                frm.fileName.value = fileName;
                frm.submit();
            }
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
            layoutStr.push('    <DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" draggableColumns="true" sortableColumns="true"  horizontalScrollPolicy="on"  headerHeight="35">');
            layoutStr.push('        <groupedColumns>');     
            layoutStr.push('            <DataGridSelectorColumn id="selector" width="40" textAlign="center" allowMultipleSelection="true" vertical-align="middle" draggable="false"   />');                                         //선택 
            layoutStr.push('            <DataGridColumn dataField="PNO"                                 headerText="'+ parent.fn_text('sn')+ '"                 width="50"    textAlign="center"  draggable="false"  />');  //순번
            layoutStr.push('            <DataGridColumn dataField="BIZRNM"                          headerText="'+ parent.fn_text('mfc_bizrnm')+ '" width="250"  textAlign="center"         />');                           //생산자
            layoutStr.push('            <DataGridColumn dataField="GRP_BRCH_NM"                 headerText="'+ parent.fn_text('grp_brch_nm')+ '"    width="200"  textAlign="center"       />');                         //총괄직매장
            layoutStr.push('            <DataGridColumn dataField="BRCH_NM"                         headerText="'+ parent.fn_text('mfc_brch_nm')+ '"    width="150"  textAlign="center"       />');                             //직매장
            layoutStr.push('            <DataGridColumn dataField="BRCH_BIZRNO"     headerText="'+ parent.fn_text('brch_bizrno')+ '" width="110"  textAlign="center" />');                               //직매장번호
            layoutStr.push('            <DataGridColumn dataField="BRCH_NO"                         headerText="'+parent.fn_text('mfc_brch_no')+ '"     width="150"  textAlign="center" />');                               //직매장번호
            layoutStr.push('            <DataGridColumn dataField="AREA_NM"                         headerText="'+ parent.fn_text('area')+ '"               width="130"  textAlign="center"  />');                          //지역
            //layoutStr.push('          <DataGridColumn dataField="PAY_EXEC_YN_NM"          headerText="'+ parent.fn_text('pay_se')+ '"             width="100"  textAlign="center" />');                               //지급구분
            layoutStr.push('            <DataGridColumn dataField="STAT_CD_NM"                      headerText="'+ parent.fn_text('stat')+ '"               width="100"  textAlign="center" />');                               //상태
            layoutStr.push('        </groupedColumns>');
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
        gridApp.setData();
        var layoutCompleteHandler = function(event) {
            dataGrid = gridRoot.getDataGrid(); // 그리드 객체
            dataGrid.addEventListener("change", selectionChangeHandler);
            selectorColumn = gridRoot.getObjectById("selector");
            
             //파라미터 call back function 실행
             if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
 				/* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
 			 	 window[INQ_PARAMS.FN_CALLBACK]();
 			 	//취약점점검 5875 기원우
             }else{
                 console.log(gridCurrentPage)
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
            rowIndexValue = rowIndex;
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
.srcharea .row .col .tit{
width: 80px;
}
.srcharea .row .col{
width: 28%;
}  
</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="mfc_bizrnmList" value="<c:out value='${mfc_bizrnmList}' />"/>
<input type="hidden" id="stat_cd_list" value="<c:out value='${stat_cd_list}' />"/>
<input type="hidden" id="area_cd_list" value="<c:out value='${area_cd_list}' />"/>
<input type="hidden" id="pay_exec_yn_list" value="<c:out value='${pay_exec_yn_list}' />"/>
<input type="hidden" id="grp_brch_no_list" value="<c:out value='${grp_brch_no_list}' />"/>         


    <div class="iframe_inner" >
            <div class="h3group">
                <h3 class="tit" id="title_sub"></h3>
                <div class="btn" style="float:right" id="UR">
                <!--btn_dwnd  -->
                <!--btn_excel  -->
                </div>
            </div>
        <section class="secwrap"   id="params">
                <div class="srcharea" style="" > 
                    <div class="row" >
                        <div class="col"  style="">
                            <div class="tit" id="mfc_bizrnm"></div><!--생산자-->
                            <div class="box">
                                <select id="BIZRNM" style="width: 210px"></select>
                            </div>
                        </div>
                        <div class="col"  style="">
                            <div class="tit" id="grp_brch_nm"></div><!--총괄직매장-->
                            <div class="box">
                                <select id="GRP_BRCH_CD" style="width: 210px"></select>
                            </div>
                        </div>
                    </div> <!-- end of row -->
    
                    <div class="row">
                            <div class="col"    style="">
                                <div class="tit" id="area"></div>  <!-- 지역 -->
                                <div class="box"  >
                                      <select id="AREA_CD" style="width: 210px"></select>
                                </div>
                            </div>
                            <div class="col" >
                                <div class="tit" id="stat"></div>  <!--상태-->
                                <div class="box">
                                    <select id="STAT_CD" style="width: 210px" ></select>
                                </div>
                            </div>
                            <div class="col"  style="display:none">
                                <div class="tit" id="pay_exec_yn"></div>  <!-- 지급실행여부 -->
                                <div class="box">
                                    <select   id="PAY_EXEC_YN" style="width: 210px" ></select>
                                </div>
                            </div>          
                            <div class="btn"  id="CR" ></div> <!--조회  -->
                    </div> <!-- end of row -->
                </div>  <!-- end of srcharea -->
            </section>
            <section class="btnwrap mt10"  >        <!--그리드 컬럼  -->
                <div class="btn" id="CL"></div>
            </section>
            <div class="boxarea mt10">  <!-- 634 -->
                <div id="gridHolder" style="height: 570px; background: #FFF;"></div>
                <div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
            </div>  <!-- 그리드 셋팅 -->
        <section class="btnwrap"  >
                <div class="btn" id="BL"></div>
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