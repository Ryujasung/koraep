<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>설문조사 문항등록</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
<script type="text/javaScript" language="javascript" defer="defer">

var INQ_PARAMS;
var ansr_list;  //문항 답변 형식
var ansrStr = "";
var cntn;

//rMate 그리드 생성 준비가 완료된 상태 시 호출할 함수를 지정합니다.

var svy_no = "";
var svy_se = "";
var svy_item_no = "";
var imgIdx = -1;    //첨부(참조) 이미지 인덱스
var pagedata = window.frameElement.name;

var addFlag  = true;
var saveFlag = true;
var toDay = kora.common.gfn_toDay();  // 현재 시간

$(document).ready(function(){

    INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
    svy_no = INQ_PARAMS["SVY_NO"];
    svy_se = INQ_PARAMS["SVY_SE_CD"];

    ansr_list = jsonObject($("#ansr_list").val());
    ansrStr = JSON.stringify(ansr_list).replaceAll('"', '\'');
    cntn = jsonObject($("#cntn").val());
    
    $("#title_sub").text("<c:out value="${titleSub}" />");  //제목

    fn_btnSetting();

    gridSet();
    //한글텍스트
    $(".tit").each(function(){
        if($(this).attr("id")) $(this).text(parent.fn_text($(this).attr("id")));
    });

    /***** 선택 설문 정보 세팅 *******/
    var sDt = INQ_PARAMS["SVY_ST_DT"];
    var eDt = INQ_PARAMS["SVY_END_DT"];

    if(Number(eDt) < Number(toDay))  addFlag  = false;
    if(Number(sDt) <= Number(toDay)) saveFlag = false;

    sDt = sDt.substring(0,4)+"-"+sDt.substring(4,6)+"-"+sDt.substring(6);
    eDt = eDt.substring(0,4)+"-"+eDt.substring(4,6)+"-"+eDt.substring(6);

    $("#txt_svy_sbj").val(INQ_PARAMS["SBJ"]);
    $("#txt_svy_term").val(sDt + " ~ " + eDt);
    $("#BBS_TEXT").text(cntn[0].CNTN);
    /**************************************/

    //목록보기
    $("#btn_list").click(function(){
        var sData = {};
        sData["SEARCH_SVY_SE_CD"] = INQ_PARAMS["SEARCH_SVY_SE_CD"];
        sData["SEARCH_SVY_TRGT_CD"] = INQ_PARAMS["SEARCH_SVY_TRGT_CD"];
        sData["SEARCH_SBJ"] = INQ_PARAMS["SEARCH_SBJ"];

        kora.common.goPageD("/CE/EPCE8160601.do", "", sData, "M");
    });

    //설명저장
    $("#btn_cntn_reg").click(function(){
        fn_cntn_chk();
    });

    //항목추가 버튼 클릭
    $("#btn_item_add_row").click(function(){
        fn_item_add_row();
    });

    //항목 삭제 클릭
    $("#btn_item_del_row").click(function(){
        fn_item_del_row();
    });

    //항목저장
    $("#btn_item_reg").click(function(){
        fn_item_chk();
    });

    //옵션추가
    $("#btn_opt_add_row").click(function(){
        fn_opt_add_row();
    });

    //옵션삭제
    $("#btn_opt_del_row").click(function(){
        fn_opt_del_row();
    });

    //옵션저장
    $("#btn_opt_reg").click(function(){
        fn_option_chk();
    });
    
    //iframe 크기조절
    CKEDITOR.on('instanceReady',function(ev) {
        ev.editor.on('resize',function(reEvent){
            window.frameElement.style.height = $('.iframe_inner').height()+'px';
        });
    });
    
    CKEDITOR.replace('BBS_TEXT', {
	   height:225
    });
});


//최초 등록된 설문문항 조회
function fn_search(){
    svy_item_no = "";   //선택된 항목번호 제거 - 옵션추가 못하도록 처리..

    var url = "/CE/EPCE81606641_19.do";
    ajaxPost(url, INQ_PARAMS, function(rtnData){
        if(rtnData != null && rtnData != ""){
            gridApp.setData(rtnData);
        }
    });
}

//설명저장체크
function fn_cntn_chk(){
    
    if(CKEDITOR.instances.BBS_TEXT.getData().length < 1){
        alertMsg("내용을 입력해 주세요.");
        return; 
    }
    
    confirm("설문조서 설명을 등록하시겠습니까?", 'fn_cntn_reg_exec');
}

//설명저장
function fn_cntn_reg_exec(){
    
    var sData = {};
    sData["SVY_NO"] = svy_no;
    sData["CNTN"] = CKEDITOR.instances.BBS_TEXT.getData();
    
    var url = "/CE/EPCE81606641_093.do";
    ajaxPost(url, sData, function(rtnData){
        alertMsg(rtnData.RSLT_MSG);
    });
}

//항목추가
function fn_item_add_row(){

    var rowIndex = dataGrid.getSelectedIndex();

    console.log("rowIndex : " + rowIndex);
    console.log("svy_se : " + svy_se);

    if(svy_se == "S") {
       if(rowIndex >= 0) {
           alertMsg("단일항목조사에서는 문항을 한개 이상 추가할 수 없습니다.");
           return
       }
    }

    var item = {"SVY_NO": svy_no};
    item["SVY_ITEM_NO"] = "";
    item["ASK_CNTN"] = "";
    item["ANSR_SE_CD"] = "";
    item["SAVE_YN"] = "N";

    gridRoot.addItemAt(item);
}

//항목삭제
function fn_item_del_row() {
    var rowIndex = dataGrid.getSelectedIndex();
    if(rowIndex == null || rowIndex == undefined || rowIndex < 0) return;
    gridRoot.removeItemAt(rowIndex);
    svy_item_no = "";   //선택된 항목번호 제거 - 옵션추가 못하도록 처리..
}


//항목저장
function fn_item_chk(){
    if(!addFlag){
        alertMsg("종료된 설문조사는 수정이 불가능 합니다.");
        return;
    }

    if(!saveFlag){
        confirm('진행중인 설문조를 변경하시면, 설문조사 결과가 달라질 수 있습니다.\n\n계속 진행하시겠습니까?', 'fn_item_reg');
        return;
    }
    
    fn_item_reg();
}

function fn_item_reg(){

    var dataList = gridRoot.getGridData();
    var chgData = gridRoot.getChangedData();
    var list = new Array();

    for(var i=0; i<chgData.length; i++){
        var map = chgData[i]["data"];
        map["JOB"] = chgData[i]["job"];

        if(map["JOB"] != "I"){
            list.push(map);
            continue;
        }

        if(map["SVY_ITEM_NO"] == ""){
            alertMsg("누락된 조사문항 표시순서가 있습니다. \r입력후 다시 저장 하십시오.");
            return;
        }else if(map["SVY_ITEM_NO_NM"] == ""){
            alertMsg("누락된 조사문항 번호가 있습니다. \r입력후 다시 저장 하십시오.");
            return;
        }else if(map["ASK_CNTN"] == ""){
            alertMsg("누락된 조사문항 내용이 있습니다. \r입력후 다시 저장 하십시오.");
            return;
        }else if(map["ANSR_SE_CD"] == ""){
            alertMsg("누락된 답변형식이 있습니다. \r입력후 다시 저장 하십시오.");
            return;
        }

        var flag = true;
        for(var k=0; k<dataList.length; k++){
            if(dataList[k]["SVY_ITEM_NO"] != "Y") continue;
            if(map["SVY_ITEM_NO"] != dataList[k]["SVY_ITEM_NO"]) continue;
            flag = false;
            break;
        }

        if(!flag){
            alertMsg("중복된 조사문항 번호가 있습니다. \r확인후 다시 저장 하십시오.");
            return;
        }
        list.push(map);
    }

    if(list.length <= 0){
        alertMsg("저장할 데이타가 없습니다.");
        return;
    }

    var sData = {"item_list":JSON.stringify(list)};
    var url = "/CE/EPCE81606641_09.do";
    ajaxPost(url, sData, function(rtnData){
        alertMsg(rtnData.RSLT_MSG);
        if(rtnData.RSLT_CD != null && rtnData.RSLT_CD != "") return;

        fn_search();
    });
}



//선택문항 옵션조회
function fn_option_search(){
    var sData = {"SVY_NO": svy_no, "SVY_ITEM_NO" : svy_item_no};
    var url = "/CE/EPCE81606641_192.do";
    ajaxPost(url, sData, function(rtnData){
        if(rtnData != null && rtnData != ""){
            gridApp2.setData(rtnData.searchList);
        }
    });
}

//선택문항 옵션추가
function fn_opt_add_row(){
    if(svy_item_no == ""){
        alertMsg("선택된 조사문항이 없거나 저장되지 않은 항목은 옵션을 처리할 수 없습니다.");
        return;
    }
    var option = {"SVY_NO": svy_no};
    option["SVY_ITEM_NO"] = svy_item_no;
    option["OPT_NO"] = "";
    option["OPT_CNTN"] = "";
    option["REFN_IMG"] = "";
    option["REFN_IMG_NM"] = "";
    option["ICON"] = "/images/util/attach_ico.png";
    option["SAVE_YN"] = "N";
    gridRoot2.addItemAt(option);
}

//선택문항 옵션삭제
function fn_opt_del_row(){
    var rowIndex = dataGrid2.getSelectedIndex();
    if(rowIndex == null || rowIndex == undefined || rowIndex < 0) return;
    gridRoot2.removeItemAt(rowIndex);
}


//옵션저장
function fn_option_chk(){
    if(!addFlag){
        alertMsg("종료된 설문조사는 수정이 불가능 합니다.");
        return;
    }

    if(!saveFlag){
        confirm('진행중인 설문조를 변경하시면, 설문조사 결과가 달라질 수 있습니다.\n\n계속 진행하시겠습니까?', 'fn_option_reg');
        return;
    }
    
    fn_option_reg();
}

//옵션저장
function fn_option_reg(){
    if(svy_item_no == ""){
        alertMsg("선택된 조사문항이 없거나 저장되지 않은 항목은 옵션을 처리할 수 없습니다.");
        return;
    }

    var dataList = gridRoot2.getGridData();
    var chgData = gridRoot2.getChangedData();
    var list = new Array();

    for(var i=0; i<chgData.length; i++){
        var map = chgData[i]["data"];
        map["JOB"] = chgData[i]["job"];

        if(map["JOB"] != "I"){
            list.push(map);
            continue;
        }

        if(map["OPT_NO"] == ""){
            alertMsg("누락된 선택옵션번호가 있습니다. \r입력후 다시 저장 하십시오.");
            return;
        }else if(map["OPT_CNTN"] == ""){
            alertMsg("누락된 선택옵션 내용이 있습니다. \r입력후 다시 저장 하십시오.");
            return;
        }

        var flag = true;
        for(var k=0; k<dataList.length; k++){
            if(dataList[k]["SAVE_YN"] != "Y") continue;
            if(map["OPT_NO"] != dataList[k]["OPT_NO"]) continue;
            flag = false;
            break;
        }

        if(!flag){
            alertMsg("중복된 선택옵션번호가 있습니다. \r확인후 다시 저장 하십시오.");
            return;
        }
        list.push(map);
    }

    if(list.length <= 0){
        alertMsg("저장할 데이타가 없습니다.");
        return;
    }

    var sData = {"option_list":JSON.stringify(list)};
    var url = "/CE/EPCE81606641_092.do";
    ajaxPost(url, sData, function(rtnData){
        alertMsg(rtnData.RSLT_MSG);
        if(rtnData.RSLT_CD != null && rtnData.RSLT_CD != "") return;

        fn_option_search();
    });
}

//파일첨부 팝업
function fn_imgRegPop(rowIdx, colIdx){
    imgIdx = rowIdx;
    var sData = {"TITLE" : "이미지 첨부", "UPLOAD_TYPE" : "IMG", "MAX_UPLOAD_COUNT" : "1", "pagedata":pagedata};
    window.parent.NrvPub.AjaxPopup("/POP_FILE_UPLOAD_VIEW.do", sData);
}

//첨부이미지 저장결과
function fn_popResult(rtnData){
    var filePath = rtnData[0]["filePath"];
    var uploadFileName = rtnData[0]["uploadFileName"];

    filePath = filePath.replaceAll("\"","") + "/" + uploadFileName;
    filePath = filePath.replaceAll("\"","/");

    gridRoot2.setItemFieldAt(filePath, imgIdx, "REFN_IMG");
    gridRoot2.setItemFieldAt(uploadFileName, imgIdx, "REFN_IMG_NM");
}

//첨부 이미지 보기
function fn_imgViewPop(imgSrc, imgNm){
    if(imgSrc == null || imgSrc == "") return;

    var sData = {"imgSrc":encodeURI(imgSrc), "imgNm":imgNm, "pagedata":pagedata}
    window.parent.NrvPub.AjaxPopup('/CE/EPCE81606642.do', sData);
}

var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
var jsVars2 = "rMateOnLoadCallFunction=gridReadyHandler2";

var gridApp, gridRoot, dataGrid, selectorColumn;
var gridApp2, gridRoot2, dataGrid2, selectorColumn2;

var layoutStr = new Array();
var layoutStr2 = new Array();

function gridSet(){
    //rMateDataGrid 를 생성합니다.
    rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%");
    layoutStr.push('<rMateGrid>');
    layoutStr.push('    <DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
    layoutStr.push('    <NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
    layoutStr.push('    <DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" itemEditBeginningJsFunction="itemEditCheck" headerWordWrap="true" headerHeight="35" editable="true">');
    layoutStr.push('        <columns>');
    layoutStr.push('            <DataGridColumn dataField="SVY_ITEM_NO" headerText="' + parent.fn_text('sel_ord') + '" maxChars="3" type="int" textAlign="right"  width="10%" />');
    layoutStr.push('            <DataGridColumn dataField="SVY_ITEM_NO_NM" headerText="' + parent.fn_text('no') + '" maxChars="4" textAlign="right"  width="15%" />');
    layoutStr.push('            <DataGridColumn dataField="ASK_CNTN" maxChars="200" headerText="' + parent.fn_text('tit_svy_item') + '" editable="true" width="60%" />');
    layoutStr.push('            <DataGridColumn dataField="ANSR_SE_CD" headerText="' + parent.fn_text('tit_ansr_se_cd') + '" itemEditor="ComboBoxEditor" itemRendererDataProvider="' + ansrStr + '"  itemRendererDataField="ETC_CD"  itemRendererLabelField="ETC_CD_NM" editorDataField="selectedDataField" itemRenderer="DataProviderItem" width="30%" />');
    layoutStr.push('        </columns>');
    layoutStr.push('    </DataGrid>');
    layoutStr.push('</rMateGrid>');

    rMateGridH5.create("grid2", "gridHolder2", jsVars2, "100%", "100%");
    layoutStr2.push('<rMateGrid>');
    layoutStr2.push('   <DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
    layoutStr2.push('   <NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
    layoutStr2.push('   <DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg2" itemEditBeginningJsFunction="optionEditCheck" headerWordWrap="true" headerHeight="35" rowHeight="35" editable="true">');
    layoutStr2.push('       <columns>');
    layoutStr2.push('           <DataGridColumn dataField="OPT_NO" headerText="' + parent.fn_text('tit_opt_no') + '" maxChars="3" type="int" textAlign="right"  width="13%" />');
    layoutStr2.push('           <DataGridColumn dataField="OPT_CNTN" headerText="' + parent.fn_text('tit_opt_cntn') + '"  editable="true" width="55%" />');
    layoutStr2.push('           <DataGridColumn dataField="REFN_IMG_NM" headerText="' + parent.fn_text('tit_refn_img') + '"  id="imageCol" itemRenderer="HtmlItem" styleJsFunction="fn_cellCss" editable="false" textAlign="center" width="25%" />');
    layoutStr2.push('           <DataGridColumn dataField="ICON" headerText="" id="iconCol" editable="false" itemRenderer="ImageItem" styleJsFunction="fn_cellCss" textAlign="center" width="7%"/>');
    layoutStr2.push('       </columns>');
    layoutStr2.push('   </DataGrid>');
    layoutStr2.push('</rMateGrid>');
}

//좌측 조사문항 이벤트 핸들러
function gridReadyHandler(id) {
    gridApp = document.getElementById(id);  // 그리드를 포함하는 div 객체
    gridRoot = gridApp.getRoot();   // 데이터와 그리드를 포함하는 객체
    gridApp.setLayout(layoutStr.join("").toString());
    gridApp.setData();

    var layoutCompleteHandler = function(event) {
        dataGrid = gridRoot.getDataGrid();  // 그리드 객체
        dataGrid.addEventListener("change", selectionChangeHandler);
    }

    var dataCompleteHandler = function(event) {
        dataGrid = gridRoot.getDataGrid();  // 그리드 객체
        dataGrid.setEnabled(true);
        gridRoot.removeLoadingBar();
    }

    //행선택
    var selectionChangeHandler = function(event) {
        var rowIndex = event.rowIndex;
        var columnIndex = event.columnIndex;
        svy_item_no = "";

        if(rowIndex == null || rowIndex == undefined || rowIndex < 0) return;

        var dataRow = gridRoot.getItemAt(rowIndex);
        if(dataRow["SAVE_YN"] == "Y"){
            
            if(dataRow["ANSR_SE_CD"] == "I" || dataRow["ANSR_SE_CD"] == "X") {
        	   gridApp2.setData([]);   //선택된 조사문항이 없으면 빈 그리드로 처리
        	   return;
            }
            
            svy_item_no = dataRow["SVY_ITEM_NO"];
            fn_option_search();
        }else{
            gridApp2.setData([]);   //선택된 조사문항이 없으면 빈 그리드로 처리
        }
    }

    gridRoot.addEventListener("dataComplete", dataCompleteHandler);
    gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);

    gridApp.setData([]);
    fn_search();    //최초 등록된 설문문항 조회
    //gridApp.setData(searchList);
};


//우측 선택문항 옵션 이벤트 핸들러
function gridReadyHandler2(id) {
    gridApp2 = document.getElementById(id);  // 그리드를 포함하는 div 객체
    gridRoot2 = gridApp2.getRoot();   // 데이터와 그리드를 포함하는 객체
    gridApp2.setLayout(layoutStr2.join("").toString());
    gridApp2.setData();

    var layoutCompleteHandler2 = function(event) {
        dataGrid2 = gridRoot2.getDataGrid();  // 그리드 객체
        dataGrid2.addEventListener("change", selectionChangeHandler2);
        dataGrid2.addEventListener("itemClick", itemClickHandler);
    }

    var dataCompleteHandler2 = function(event) {
        dataGrid2 = gridRoot2.getDataGrid();  // 그리드 객체

        var iconCol = gridRoot2.getObjectById("iconCol");
        iconCol.addEventListener("itemImageClick", itemImageClickHandler);

        //var imageCol = gridRoot2.getObjectById("imageCol");
        //imageCol.addEventListener("itemClick", itemClickHandler);

        dataGrid2.setEnabled(true);
        gridRoot2.removeLoadingBar();
    }

    //행선택
    var selectionChangeHandler2 = function(event) {
        var rowIndex = event.rowIndex;
        var columnIndex = event.columnIndex;
        if(rowIndex == null || rowIndex == undefined || rowIndex < 0) return;
    }


    //등록 이미지 팝업
    var itemClickHandler = function(event) {
        var rowIndex = event.rowIndex;
        var colIndex = event.columnIndex;

        var column = dataGrid2.getDisplayableColumns()[colIndex];
        var dataField = column.getDataField();

        if(dataField == "REFN_IMG_NM"){
            var dataRow = gridRoot2.getItemAt(rowIndex);
            fn_imgViewPop(dataRow["REFN_IMG"], dataRow["REFN_IMG_NM"]);
        }
        else if(dataField == "ICON"){
            fn_imgRegPop(rowIndex, colIndex);
        }
    }

    //이미지 첨부 팝업
    var itemImageClickHandler = function(event) {
        var rowIndex = event.rowIndex;
        var colIndex = event.columnIndex;

        fn_imgRegPop(rowIndex, colIndex);   //이미지 등록 팝업
    }


    gridRoot2.addEventListener("dataComplete", dataCompleteHandler2);
    gridRoot2.addEventListener("layoutComplete", layoutCompleteHandler2);
};


//우측그리드 항목번호 수정여부 처리
function itemEditCheck(rowIndex, columnIndex, item, dataField){
    if(dataField == "SVY_ITEM_NO" && item["SAVE_YN"] == "Y"){
        return false;
    }else{
        return true;
    }
}

//우측 그리드 css
function fn_cellCss(item, column) {
    return {cursor:'hand'};
}

//좌측그리드 옵션번호 수정여부 처리
function optionEditCheck(rowIndex, columnIndex, item, dataField) {
    if(dataField == "OPT_NO" && item["SAVE_YN"] == "Y"){
        return false;
    }else{
        return true;
    }
}

</script>

</head>
<body>
    <div class="iframe_inner">
        <input type="hidden" id="INQ_PARAMS" value='<c:out value="${INQ_PARAMS}"/>' />
        <input type="hidden" id="ansr_list" value='<c:out value="${ansr_list}"/>' />
        <input type="hidden" id="cntn" value='<c:out value="${cntn}"/>' />
        <div class="h3group">
            <h3 class="tit" id="title_sub"></h3>
        </div>
        
        <section class="secwrap">
            <div class="srcharea">
                <div class="row">
                    <div class="col">
                        <div class="tit" style="padding-right: 15px;" id="tit_svy_sbj"></div>
                        <div class="box" >
                            <input type="text" id="txt_svy_sbj" style="width: 400px;" disabled="true" />

                        </div>
                    </div>
                    <div class="col">
                        <div class="tit" style="padding-right: 15px;" id="tit_svy_term"></div>
                        <div class="box">
                            <input type="text" id="txt_svy_term" style="width: 200px;" disabled="true" />
                        </div>
                    </div>

                    <div class="btn" id="UR">
                    </div>
                </div>
            </div>
        </section>
        <section class="secwrap mt20">
            <div class="h4group">
                <h4 class="tit" style="float:left;" id='tit_svy_cntn'></h4>

                <!-- 버튼 위치 행추가,삭제, 저장 -->
                <div class="btn_box" id="BR"></div>
            </div>
            <div class="srcharea">
                <div class="write_box">
                    <div class="txt" style="padding:17px">
                        <textarea class="ckeditor"  name="BBS_TEXT" id="BBS_TEXT" style="width:100%;"></textarea>
                    </div>
                </div>
            </div>
        </section>
        <section class="secwrap mt40">
            <div class="halfarea" style="width: 49%; float: left;">
                <div class="h4group">
                    <h4 class="tit" style="float:left;" id='tit_svy_item'></h4>

                    <!-- 버튼 위치 행추가,삭제, 저장 -->
                    <div class="btn_box" id="CL"></div>
                </div>

                <div class="boxarea">
                    <div id="gridHolder" class="w_382" style="height:400px;"></div>
                </div>
            </div>

            <div class="halfarea" style="width: 49%; float: right;">
                <div class="h4group">
                    <h4 class="tit" style="float:left;" id='tit_item_sel_opt'></h4>

                    <!-- 버튼 위치 행추가,삭제, 저장 -->
                    <div class="btn_box" id="CR"></div>
                </div>
                <div class="boxarea">
                    <div id="gridHolder2" class="w_382" style="height:400px;">
                </div>
          </div>
        </section>
    </div>
</body>
</html>