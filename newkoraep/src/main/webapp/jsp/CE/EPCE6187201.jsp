<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>기간별 대비 현황</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<style>
/* The Modal (background) */
.searchModal {
display: none; /* Hidden by default */
position: fixed; /* Stay in place */
z-index: 10; /* Sit on top */
left: 0;
top: 0;
width: 100%; /* Full width */
height: 100%; /* Full height */
overflow: auto; /* Enable scroll if needed */
background-color: rgb(0,0,0); /* Fallback color */
background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
}
/* Modal Content/Box */
.search-modal-content {
background-color: #fefefe;
text-align:center;
margin: 15% auto; /* 15% from the top and centered */
padding: 20px;
border: 1px solid #888;
width: 180px; /* Could be more or less, depending on screen size */
border-radius:10px; 
}
</style>
<script type="text/javaScript" language="javascript" defer="defer">

var INQ_PARAMS = []; //파라미터 데이터
var mfc_bizrnm_sel; //생산자
var ctnrSe; // 빈용기 구분
var prpsCd;

var selGbn = '1'; //적용 그리드 확인용

$(function() {
	 
	INQ_PARAMS = jsonObject($("#INQ_PARAMS").val()); //파라미터 데이터
	mfc_bizrnm_sel = jsonObject($("#mfc_bizrnm_sel_list").val()); //생산자
	
	ctnrSe         = jsonObject($("#ctnrSe").val()); // 빈용기구분
	prpsCd         = jsonObject($("#prpsCd").val());
	
	//초기화
    fn_init();
	
	//버튼 셋팅
	fn_btnSetting();
	
    //날짜 셋팅
    $('#F_START_DT').YJcalendar({  
        toName : 'to',
        triggerBtn : true,
        dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -14, false).replaceAll('-','')
        
    });
    $('#F_END_DT').YJcalendar({
        fromName : 'from',
        triggerBtn : true,
        dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -8, false).replaceAll('-','')
    });
    //날짜 셋팅
    $('#S_START_DT').YJcalendar({  
        toName : 'to2',
        triggerBtn : true,
        dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
        
    });
    $('#S_END_DT').YJcalendar({
        fromName : 'from2',
        triggerBtn : true,
        dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
    });

    //그리드 셋팅
    fnSetGrid1();

    $("#btn_sel").click(function(){
        fn_sel();
    });
    
    $("#btn_pop").click(function(){
        fn_pop();
    });
    
    /************************************
     * 엑셀다운로드 버튼 클릭 이벤트
     ***********************************/
    $("#btn_excel").click(function() {
        fn_excel();
    });
    
    /************************************
     * 시작날짜  클릭시 - 삭제  변경 이벤트
     ***********************************/
    $("#F_START_DT").click(function(){
        $("#F_START_DT").val($("#F_START_DT").val().replace(/-/gi, ""));
    });
    
    /************************************
     * 시작날짜  클릭시 - 추가  변경 이벤트
     ***********************************/
    $("#F_START_DT").change(function(){
        var start_dt = $("#F_START_DT").val().replace(/-/gi, "");
        if(start_dt.length == 8) start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
        $("#F_START_DT").val(start_dt) 
    });
    
    /************************************
     * 끝날짜  클릭시 - 삭제  변경 이벤트
     ***********************************/
    $("#F_END_DT").click(function(){
	    $("#F_END_DT").val($("#F_END_DT").val().replace(/-/gi, ""));
    });
    
    /************************************
     * 끝날짜  클릭시 - 추가  변경 이벤트
     ***********************************/
    $("#F_END_DT").change(function(){
        var end_dt  = $("#F_END_DT").val().replace(/-/gi, "");
        if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd")
        $("#F_END_DT").val(end_dt) 
    });
    
    /************************************
     * 시작날짜  클릭시 - 삭제  변경 이벤트
     ***********************************/
    $("#S_START_DT").click(function(){
        $("#S_START_DT").val($("#S_START_DT").val().replace(/-/gi, ""));
    });
    
    /************************************
     * 시작날짜  클릭시 - 추가  변경 이벤트
     ***********************************/
    $("#S_START_DT").change(function(){
        var start_dt = $("#S_START_DT").val().replace(/-/gi, "");
        if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
        $("#S_START_DT").val(start_dt) 
    });
    
    /************************************
     * 끝날짜  클릭시 - 삭제  변경 이벤트
     ***********************************/
    $("#S_END_DT").click(function(){
        $("#S_END_DT").val($("#S_END_DT").val().replace(/-/gi, ""));
    });
    
    /************************************
     * 끝날짜  클릭시 - 추가  변경 이벤트
     ***********************************/
    $("#S_END_DT").change(function(){
        var end_dt  = $("#S_END_DT").val().replace(/-/gi, "");
        if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd")
        $("#S_END_DT").val(end_dt) 
    });
    
    /************************************
     * 빈용기구분 구병 / 신병 변경시
     ***********************************/
    $("#CTNR_SE").change(function(){
        fn_prps_cd();
    });

    /************************************
     * 빈용기 구분 변경 이벤트
     ***********************************/
    $("#PRPS_CD").change(function(){
        fn_prps_cd();
    });
    
});

function fn_init() {
	$('.row > .col > .tit').each(function(){
		$(this).text(parent.fn_text($(this).attr('id')) );
	});
	
	//생산자
	kora.common.setEtcCmBx2(mfc_bizrnm_sel, "", "", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N", "T");
	
	kora.common.setEtcCmBx2(ctnrSe, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N", "T"); //빈용기구분 신병/구병
    kora.common.setEtcCmBx2(prpsCd, "","1", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N", "T"); //빈용기구분 가정/유흥
    kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S'); //빈용기명
    
    //파라미터 조회조건으로 셋팅
    if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
        
        if(INQ_PARAMS.SEL_PARAMS.CTNR_SE != "") {
    	   fn_prps_cd();
        }

        kora.common.jsonToTable("params",INQ_PARAMS.SEL_PARAMS);
        /* 화면이동 페이징 셋팅 */
        gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
    }
    
}
//빈용기 구분 선택시
function fn_prps_cd(){

    var url = "/SELECT_RTRVL_CTNR_CD2.do"
    var input ={};

    input["CTNR_SE"] = $("#CTNR_SE").val(); //빈용기명 구분 구/신
    input["PRPS_CD"] = $("#PRPS_CD").val(); //빈용기명 유흥/가정

    ctnr_nm=[];

    ajaxPost(url, input, function(rtnData) {
        if ("" != rtnData && null != rtnData) {
            ctnr_nm = rtnData.ctnr_nm

            kora.common.setEtcCmBx2(rtnData.ctnr_nm, "","", $("#CTNR_CD"), "RTRVL_CTNR_CD", "CTNR_NM", "N" ,'T'); //빈용기
        }
        else{
            alertMsg("error");
        }
    },false);


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
				
	var now  = new Date(); 				     // 현재시간 가져오기
	var hour = new String(now.getHours());   // 시간 가져오기
	var min  = new String(now.getMinutes()); // 분 가져오기
	var sec  = new String(now.getSeconds()); // 초 가져오기
	var today = kora.common.gfn_toDay();
	var fileName = $('#title').text().replace("/","_") +"_" + today+hour+min+sec+".xlsx";
	
	//그리드 컬럼목록 저장
	var col = new Array();
	
	//그룹헤더용
	var groupList = dataGrid.getGroupedColumns();
	var groupCntTot = 0;
	var groupCnt = 0;
	
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
			item['dataField'] = columns[i].getDataField();
			item['textAlign'] = columns[i].getStyle('textAlign');
			item['id'] = kora.common.null2void(columns[i].id);
			
			col.push(item);
			//console.log(item);
		}
	}
	
	var input = INQ_PARAMS["SEL_PARAMS"];
	input['fileName'] = fileName;
	input['columns'] = JSON.stringify(col);
	
	var url = "/CE/EPCE6187201_05.do";
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

/**
 * 목록조회
 */
function fn_sel(){
	
	var url = "/CE/EPCE6187201_19.do";
	var input = {};
    input["MFC_BIZRNM"] = $('#MFC_BIZRNM').val();
    input['F_START_DT'] = $("#F_START_DT").val();
    input['F_END_DT']   = $("#F_END_DT").val();
    input['S_START_DT'] = $("#S_START_DT").val();
    input['S_END_DT']   = $("#S_END_DT").val();
    input['CTNR_CD']   = $("#CTNR_CD").val();
    input['CTNR_SE']   = $("#CTNR_SE").val();

	//파라미터에 조회조건값 저장 
	INQ_PARAMS["SEL_PARAMS"] = input;
	
	gridApp.setData([]); //그리드데이터 리셋
	
// 	kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
$("#modal").show();
	ajaxPost(url, input, function(rtnData){
		if(rtnData != null && rtnData != ""){
			gridApp.setData(rtnData.selList);
		} else {
			alertMsg("error");
		}
		kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
		$("#modal").hide();
	});
}

function fn_pop(){
	var url = "/CE/EPCE6187261.do";
	var input = {};
    input['F_START_DT'] = $("#F_START_DT").val();
    input['F_END_DT']   = $("#F_END_DT").val();
    input['S_START_DT'] = $("#S_START_DT").val();
    input['S_END_DT']   = $("#S_END_DT").val();
    console.log('input'+input);

    INQ_PARAMS["PARAMS"] = input;
	INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
	INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE6187201.do";
	kora.common.goPage(url, INQ_PARAMS);
	$("#modal").show();
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
	if(reDrawYn != 'Y'){
		rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%");
	}
	
	layoutStr = new Array();
	layoutStr.push('<rMateGrid>');
	layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
	layoutStr.push('	<PercentFormatter id="percfmt" precision="1" useThousandsSeparator="true"/>');
	layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" textAlign="center" >');
	layoutStr.push('		<groupedColumns>');
	layoutStr.push('			<DataGridColumn dataField="BIZRNM" headerText="'+parent.fn_text('mfc_bizrnm')+'" textAlign="center" width="150" />');
	layoutStr.push('			<DataGridColumnGroup id="TERM1" headerText="'+parent.fn_text('sel_term')+'1">');
    layoutStr.push('                <DataGridColumn id="num1" dataField="DLIVY_QTY_1" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num2" dataField="ALKND1_1" headerText="'+parent.fn_text('dlivy')+' 소주" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num3" dataField="ALKND2_1" headerText="'+parent.fn_text('dlivy')+' 맥주" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num4" dataField="ALKND9_1" headerText="'+parent.fn_text('dlivy')+' 음료" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num55" dataField="PRPS_CD1_1" headerText="'+parent.fn_text('dlivy')+' 가정용" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num5" dataField="CFM_QTY_1" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num6" dataField="FB_CFM_QTY_TOT_1" headerText="'+parent.fn_text('wrhs')+' 유흥용" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num7" dataField="FH_CFM_QTY_TOT_1" headerText="'+parent.fn_text('wrhs')+' 가정용 " width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num8" dataField="DRCT_CFM_QTY_TOT_1" headerText="'+parent.fn_text('wrhs')+' 직접" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num9" dataField="FB_CFM_QTY_TOT_11" headerText="'+parent.fn_text('wrhs')+' 소주" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num10" dataField="FH_CFM_QTY_TOT_11" headerText="'+parent.fn_text('wrhs')+' 맥주" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num11" dataField="DRCT_CFM_QTY_TOT_11" headerText="'+parent.fn_text('wrhs')+' 음료" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num12" dataField="DRCT_RTRVL_QTY_1" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num13" dataField="EXCH_QTY_1" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num14" dataField="RTRVL_QTY_1" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num15" dataField="QTY_RT_1" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
	layoutStr.push('			</DataGridColumnGroup>');
	layoutStr.push('           <DataGridColumnGroup id="TERM2" headerText="'+parent.fn_text('sel_term')+'2">');
    layoutStr.push('                <DataGridColumn id="num16" dataField="DLIVY_QTY_2" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num17" dataField="ALKND1_2" headerText="'+parent.fn_text('dlivy')+' 소주" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num18" dataField="ALKND2_2" headerText="'+parent.fn_text('dlivy')+' 맥주" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num19" dataField="ALKND9_2" headerText="'+parent.fn_text('dlivy')+' 음료" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num56" dataField="PRPS_CD1_2" headerText="'+parent.fn_text('dlivy')+' 가정용" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num20" dataField="CFM_QTY_2" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num21" dataField="FB_CFM_QTY_TOT_2" headerText="'+parent.fn_text('wrhs')+' 유흥용" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num22" dataField="FH_CFM_QTY_TOT_2" headerText="'+parent.fn_text('wrhs')+' 가정용 " width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num23" dataField="DRCT_CFM_QTY_TOT_2" headerText="'+parent.fn_text('wrhs')+' 직접" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num24" dataField="FB_CFM_QTY_TOT_22" headerText="'+parent.fn_text('wrhs')+' 소주" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num25" dataField="FH_CFM_QTY_TOT_22" headerText="'+parent.fn_text('wrhs')+' 맥주" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num26" dataField="DRCT_CFM_QTY_TOT_22" headerText="'+parent.fn_text('wrhs')+' 음료" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num27" dataField="DRCT_RTRVL_QTY_2" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num28" dataField="EXCH_QTY_2" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num29" dataField="RTRVL_QTY_2" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num30" dataField="QTY_RT_2" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
	layoutStr.push('			</DataGridColumnGroup>');
	layoutStr.push('           <DataGridColumnGroup id="CPR" headerText="증감량">');
    layoutStr.push('                <DataGridColumn id="num31" dataField="DLIVY_QTY_3" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num32" dataField="CFM_QTY_3" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num33" dataField="DRCT_RTRVL_QTY_3" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num34" dataField="EXCH_QTY_3" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num35" dataField="RTRVL_QTY_3" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num36" dataField="QTY_RT_3" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
	layoutStr.push('			</DataGridColumnGroup>');
    layoutStr.push('           <DataGridColumnGroup id="AVG" headerText="평균">');
    layoutStr.push('                <DataGridColumn id="num37" dataField="DLIVY_QTY_4" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num38" dataField="CFM_QTY_4" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num39" dataField="DRCT_RTRVL_QTY_4" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num40" dataField="EXCH_QTY_4" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num41" dataField="RTRVL_QTY_4" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('                <DataGridColumn id="num42" dataField="QTY_RT_4" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
    layoutStr.push('            </DataGridColumnGroup>');
	layoutStr.push('		</groupedColumns>');
    layoutStr.push('        <footers>');
    layoutStr.push('            <DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
    layoutStr.push('                <DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}"  formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}"  formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}"  formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}"  formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}"  formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num55}"  formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}"  formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num7}"  formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num8}"  formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num9}"  formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num10}"  formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num11}"  formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num12}"  formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num13}"  formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num14}"  formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="AVG" dataColumn="{num15}"  formatter="{numfmt}" textAlign="right"/>');
//     layoutStr.push('                <DataGridFooterColumn dataColumn="{num15}"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num16}"  formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num17}"  formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num18}"  formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num19}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num56}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num20}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num21}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num22}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num23}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num24}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num25}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num26}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num27}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num28}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num29}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn dataColumn="{num30}"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num31}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num32}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num33}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num34}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num35}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn dataColumn="{num36}"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num37}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num38}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num39}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num40}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num41}" formatter="{numfmt}" textAlign="right"/>');
    layoutStr.push('                <DataGridFooterColumn dataColumn="{num42}"/>');
    layoutStr.push('            </DataGridFooter>');
    layoutStr.push('        </footers>');
	layoutStr.push('	</DataGrid>');
	layoutStr.push('</rMateGrid>');
}

/**
 * 조회기준-생산자 그리드 이벤트 핸들러
 */
function gridReadyHandler(id) {
	gridApp = document.getElementById(id); // 그리드를 포함하는 div 객체
	gridRoot = gridApp.getRoot(); // 데이터와 그리드를 포함하는 객체
	gridApp.setLayout(layoutStr.join("").toString());

	var layoutCompleteHandler = function(event) {
		dataGrid = gridRoot.getDataGrid(); // 그리드 객체
		//gridApp.setData();
	}
	
	var dataCompleteHandler = function(event) {
		dataGrid = gridRoot.getDataGrid(); // 그리드 객체
	}
	
	gridRoot.addEventListener("dataComplete", dataCompleteHandler);
	gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
}	

/****************************************** 그리드 셋팅 끝***************************************** */
</script>

<style type="text/css">
	.srcharea .row .col .tit{width: 68px;}
</style>

</head>
<body>

	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
	<input type="hidden" id="mfc_bizrnm_sel_list" value="<c:out value='${mfc_bizrnm_sel}' />" />
	<input type="hidden" id="ctnrSe" value="<c:out value='${ctnrSe}' />" />
	<input type="hidden" id="prpsCd" value="<c:out value='${prpsCd}' />" />

    <div class="iframe_inner" >
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn" style="float:right" id="UR">
			</div>
		</div>
		<section class="secwrap"  id="params">
			<div class="srcharea" > 
				<div class="row" >
					<div class="col">
						<div class="tit" id="mfc_bizrnm"></div>
						<div class="box">		
							<select id="MFC_BIZRNM" name="MFC_BIZRNM" style="width: 179px;">
							</select>
						</div>
					</div>
                    <div class="col">
                        <div class="tit" id="sel_term"></div>
                        <div class="box">
                            <div class="calendar">
                                <input type="text" id="F_START_DT" name="from" style="width: 140px;" >
                            </div>
                            <div class="obj">~</div>
                            <div class="calendar">
                                <input type="text" id="F_END_DT" name="to" style="width: 140px;" >
                            </div>
                        </div>
                    </div>
                    <div class="col">
                        <div class="tit" id="sel_term"></div>
                        <div class="box">
                            <div class="calendar">
                                <input type="text" id="S_START_DT" name="from2" style="width: 140px;" >
                            </div>
                            <div class="obj">~</div>
                            <div class="calendar">
                                <input type="text" id="S_END_DT" name="to2" style="width: 140px;" >
                            </div>
                        </div>
                    </div>
				</div> <!-- end of row -->
				
				<div class="row">

                    <div class="col">
                        <div class="tit" id="ctnr_se"></div>  <!-- 빈용기구분 -->
                        <div class="box">
                            <select id="CTNR_SE" name="CTNR_SE" style="width:200px" class="i_notnull" ></select>
                        </div>
                    </div>

                    <div class="col" >
                        <div class="tit" id="ctnr_nm"></div>  <!-- 빈용기명 -->
                        <div class="box" >
                            <select id="CTNR_CD" name="CTNR_CD" style="width:200px" class="i_notnull" ></select>
                        </div>
                    </div>

                    <div class="btn"  id="CR" ></div> <!--조회  -->
                </div> <!-- end of row -->
                
			</div>  <!-- end of srcharea -->
		</section>
						
		<section class="btnwrap mt10" >
			<div class="btn" id="GL"></div>
			<div class="btn" style="float:right" id="GR"></div>
		</section>			
		<div class="boxarea mt10">
            <div id="gridHolder" style="height: 495px;"></div>
		</div>
		
		<div class="h4group" >
			<h5 class="tit"  style="font-size: 16px;">
				<!-- &nbsp;※ 조회기간의 기준은 출고일자 및 입고확인일자 입니다.<br/> -->
			</h5>  
		</div>
		
		<section class="btnwrap" style="" >
			<div class="btn" id="BL">
			</div>
			<div class="btn" style="float:right" id="BR"></div>
		</section>
		<div class="h4group" >
			   <h5 class="tit" style="font-size: 16px;">※ 보고 양식은 조회기간만 설정할 수 있으며, 생산자, 빈용기 구분, 빈용기명은 보고양식에 별도 설정이 불가합니다.</h5>
			</div>
	</div>
	
	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="excel" />
	</form>
		<div id="modal" class="searchModal"  style="display: none;">
		<div class="search-modal-content" >
			<h5> <img alt="" src="../../images/main/loading.gif"></h5>
		</div>
	</div>
</body>
</html>