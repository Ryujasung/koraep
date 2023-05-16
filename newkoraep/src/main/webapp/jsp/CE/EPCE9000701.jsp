<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>지역별무인회수기현황</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<!-- rMateMapChart -->
<script language="javascript" type="text/javascript" src="/rMateMapChart/LicenseKey/rMateMapChartH5License.js"></script>
<script language="javascript" type="text/javascript" src="/rMateMapChart/rMateMapChartH5/JS/rMateMapChartH5.js"></script>
<link rel="stylesheet" type="text/css" href="/rMateMapChart/rMateMapChartH5/Assets/rMateMapChartH5.css"/>

<!-- rMateChart -->
<link rel="stylesheet" type="text/css" href="/rMateChart/rMateChartH5/Assets/Css/rMateChartH5.css"/>
<script language="javascript" type="text/javascript" src="/rMateChart/LicenseKey/rMateChartH5License.js"></script>
<script language="javascript" type="text/javascript" src="/rMateChart/rMateChartH5/JS/rMateChartH5.js"></script>
<script type="text/javascript" src="/rMateChart/rMateChartH5/Assets/Theme/theme.js"></script>

<!-- 샘플 작동을 위한 css와 js -->
<script type="text/javascript" src="/rMateChart/Web/JS/common.js"></script>
<script type="text/javascript" src="/rMateChart/Web/JS/sample_util.js"></script>
<link rel="stylesheet" type="text/css" href="/rMateChart/Web/sample.css"/>

<!-- SyntaxHighlighter -->
<script type="text/javascript" src="/rMateChart/Web/syntax/shCore.js"></script>
<script type="text/javascript" src="/rMateChart/Web/syntax/shBrushJScript.js"></script>
<link type="text/css" rel="stylesheet" href="/rMateChart/Web/syntax/shCoreDefault.css"/>
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
width: 240px; /* Could be more or less, depending on screen size */
border-radius:10px; 
}
</style>
<script type="text/javaScript" language="javascript" defer="defer">
    var INQ_PARAMS;//파라미터 데이터
    var areaList;//지역
    var toDay = kora.common.gfn_toDay();// 현재 시간
    var selList;
    
    var collist_sel;	// 회수처
    
    $(function() {
         
        INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
        areaList = jsonObject($("#areaList").val());//지역
        
        $('#coll_se').text('회수처 구분');
        
        fn_init(); 
          
        //버튼 셋팅
        fn_btnSetting();
         
        //맵차트 셋팅
        fnSetMap(false);
         
        //그리드 셋팅(지역)
        fnSetGrid();

        //그리드 셋팅(생산자)
        fnSetGrid2();
        
        //파이차트 셋팅
        //fnSetChart();
        
        /************************************
         * 조회 클릭 이벤트
         ***********************************/
        $("#btn_sel").click(function(){
            fn_sel();
        });
        
        $("#btn_pop").click(function(){
            fn_pop();
        });
        
        /************************************
         * 시작날짜  클릭시 - 삭제 변경 이벤트
         ***********************************/
        $("#START_DT").click(function(){
            var start_dt = $("#START_DT").val();
            start_dt   =  start_dt.replace(/-/gi, "");
            $("#START_DT").val(start_dt)
        });
        
        /************************************
         * 시작날짜  클릭시 - 추가 변경 이벤트
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
         * 끝날짜  클릭시 - 추가 변경 이벤트
         ***********************************/
        $("#END_DT").change(function(){
            var end_dt  = $("#END_DT").val();
            end_dt =  end_dt.replace(/-/gi, "");
            if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd")
            $("#END_DT").val(end_dt) 
        });
    });
    
    //셋팅
    function fn_init(){
        kora.common.setEtcCmBx2(areaList, "","", $("#AREA_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');//지역
         
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
        
        //text 셋팅
        $('.row > .col > .tit').each(function(){
            $(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
        });
            
        //div필수값 alt
        $("#START_DT").attr('alt',parent.fn_text('sel_term'));
        $("#END_DT").attr('alt',parent.fn_text('sel_term'));
    }
 
    //조회
    function fn_sel(){
        var input = {};
        var url = "/CE/EPCE9000701_19.do" 
        var start_dt = $("#START_DT").val();
        var end_dt = $("#END_DT").val();
        start_dt = start_dt.replace(/-/gi, "");
        end_dt = end_dt.replace(/-/gi, "");

        //날짜 정합성 체크
        if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
            alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
            return; 
        }else if(start_dt>end_dt){
            alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
            return;
        } 

        //조회 SELECT변수값
        input["START_DT"] = $("#START_DT").val();
        input["END_DT"] = $("#END_DT").val();
        
        input["CollecList_SEL"] = $('#CollecList_SEL option:selected').val();	// 조회처 구분     
        if( input["CollecList_SEL"] == "무인회수기"){
        	 input["CollecList_SEL"] = 1;
        }else if(input["CollecList_SEL"] == '반환수집소'){
        	 input["CollecList_SEL"] = 2;
        }else{
        	input["CollecList_SEL"] = 3;
        }

        
        INQ_PARAMS["SEL_PARAM"] =input;
        $("#modal").show();
//         document.body.style.cursor = "wait";
        ajaxPost(url, input, function(rtnData) {
            if ("" != rtnData && null != rtnData) {
                selList = rtnData.selList;
                gridApp.setData(rtnData.selList);
                var pieData  = new Array();
                $.each(rtnData.selList, function(i, v){
                	var pieDataLine = {};
                	if(input["CollecList_SEL"] == 1 || input["CollecList_SEL"] == 2){
                    	pieDataLine["TITLE_OUT"]  = v.AREA_NM + "(" + "회수" + ")";
                    	pieDataLine["VAL_OUT"]    = v.RTN_QTY;
                	}else if(input["CollecList_SEL"] == 3){
                		pieDataLine["TITLE_OUT"]  = v.AREA_NM + "(" + "회수" + ")";
                    	pieDataLine["VAL_OUT"]    = v.RTN_QTY;

                	}
                    pieData.push(pieDataLine);
                });
                chartApp.setData(pieData);
            }
            else{
                alertMsg("error");
            }
//             document.body.style.cursor = "default";
            $("#modal").hide();
        });
    }    
       
    /****************************************** 맵차트 셋팅 시작***************************************** */
    // ----------------------- 맵차트 설정 시작 -------------------------------------
    // rMate 맵차트 생성 준비가 완료된 상태 시 호출할 함수를 지정합니다.
    var mapVars = "rMateOnLoadCallFunction=mapReadyHandler";
    
    var mapData = [
        {"code":"B02", "sales":85, "profit":540},
        {"code":"B01", "sales":95.9, "profit":17.7},
        {"code":"B06", "sales":66.7, "profit":125.6},  
        {"code":"B05", "sales":75.9, "profit":43.7},
        {"code":"A07", "sales":31.1, "profit":155.9},
        {"code":"A03", "sales":95.5, "profit":120.5},
        {"code":"A05", "sales":54.8, "profit":98.3},
        {"code":"A02", "sales":100.5, "profit":148.7},
        {"code":"A01", "sales":135.8, "profit":40},
        {"code":"A06", "sales":119.3, "profit":133.7},
        {"code":"A04", "sales":39.5, "profit":34.7},
        {"code":"B08", "sales":1.3, "profit":145.5},
        {"code":"B07", "sales":23.5, "profit":113.2},
        {"code":"B09", "sales":11.7, "profit":213.2},
        {"code":"B04", "sales":11.9, "profit":71.7},
        {"code":"B03", "sales":55.4, "profit":62.6},
        {"code":"B10", "sales":8, "profit":6.5},
    ];

    var layoutStrMap;
    // Map Data 경로 정의
    // setMapDataBase함수로 mapDataBase를 문자열로 넣어줄 경우 주석처리나 삭제하십시오.
    var mapDataBaseURL = "/rMateMapChart/Samples/MapDataBaseXml/SouthKorea.xml"; 
//     var mapDataBaseURL = "/rMateMapChart/Samples/MapDataBaseXml/WorldCountry.xml"; 
    
    // MapChart Source 선택
    // MapSource 디렉토리의 지도 이미지중 택일가능하며, 이외에 사용자가 작성한 별도의 Svg이미지를 지정할 수 있습니다.(매뉴얼 참조)
    var sourceURL = "/rMateMapChart/Samples/MapSource/SouthKorea.svg";   
//     var sourceURL = "/rMateMapChart/Samples/MapSource/WorldCountry.svg";   
    
    // 맵차트의 속성인 rMateOnLoadCallFunction 으로 설정된 함수.
    // rMate 맵차트 준비가 완료된 경우 이 함수가 호출됩니다.
    // 이 함수를 통해 맵차트에 레이아웃과 데이터를 삽입합니다.
    // 파라메터 : id - rMateMapChartH5.create() 사용 시 사용자가 지정한 id 입니다.
    // 맵차트 콜백함수 7개 존재합니다.
    // 1. setLayout - 스트링으로 작성된 레이아웃 XML을 삽입합니다.
    // 2. setData - 배열로 작성된 데이터를 삽입합니다.
    // 3. setMapDataBase - 스트링으로 작성된 MapData XML을 삽입합니다.
    // 4. setLayoutURLEx - 레이아웃 XML 경로를 지시합니다.
    // 5. setDataURLEx - 데이터 XML 경로를 지시합니다.
    // 6. setMapDataBaseURLEx - MapData XML 경로를 지시합니다.
    // 7. setSourceURLEx - Map Source 경로를 지시합니다.
    function mapReadyHandler(id) {
        document.getElementById(id).setLayout(layoutStrMap);
        document.getElementById(id).setData(mapData);
        document.getElementById(id).setMapDataBaseURLEx(mapDataBaseURL);
        document.getElementById(id).setSourceURLEx(sourceURL);
    }

    function fnSetMap() {
        // rMateMapChart 를 생성합니다.
        // 파라메터 (순서대로) 
        //  1. 맵차트의 id ( 임의로 지정하십시오. ) 
        //  2. 맵차트가 위치할 div 의 id (즉, 차트의 부모 div 의 id 입니다.)
        //  3. 맵차트 생성 시 필요한 환경 변수들의 묶음인 chartVars
        //  4. 맵차트의 가로 사이즈 (생략 가능, 생략 시 100%)
        //  5. 맵차트의 세로 사이즈 (생략 가능, 생략 시 100%)
         
        layoutStrMap ='<rMateMapChart>'
          +'<MapChart id="mainMap" showDataTips="true" divDataTipJsFunction="divDataTipFunction" mapChangeJsFunction="clickFunction">'
          +'<series>'
             +'<MapSeries id="mapseries" selectionMarking="line" labelPosition="inside" displayName="Map Series">'
                   +'<showDataEffect>'
                     +'<SeriesInterpolate duration="1000"/>'
                 +'</showDataEffect>'
                    +'<stroke>'
                     +'<Stroke color="#CAD7E0" weight="0.8" alpha="1"/>'
                 +'</stroke>'
                    +'<rollOverStroke>'
                     +'<Stroke color="#CAD7E0" weight="0.8" alpha="1"/>'
                 +'</rollOverStroke>'
                +'</MapSeries>'
         +'</series>'
        +'</MapChart>'
        +'</rMateMapChart>';
         
        rMateMapChartH5.create("map1", "mapHolder", mapVars, "100%", "100%");
    }
    
    function clickFunction(code, label, data) {
        
        if(INQ_PARAMS.SEL_PARAM ==null) return; 
    
        var url = "/CE/EPCE9000701_19.do"
        var input = INQ_PARAMS["SEL_PARAM"];
        input["AREA_CD"] = code;
        
        document.body.style.cursor = "wait";
        ajaxPost(url, input, function(rtnData) {
            if ("" != rtnData && null != rtnData) {
                //selList = rtnData.selList;
                gridApp2.setData(rtnData.selList);
                var pieData  = new Array()
                $.each(rtnData.selList, function(i, v){
                	var pieDataLine = {};
                    pieDataLine["TITLE_OUT"]  = v.COLL_NM + "(" + "회수" + ")";
                    pieDataLine["VAL_OUT"]    = v.COLL_RTN_QTY;
                 
                    pieData.push(pieDataLine);
                });

                chartApp.setData(pieData);
            }else{
                alertMsg("error");
            }
            document.body.style.cursor = "default";
        });
        
        $("#AREA_NM").text(label);
    }

    function fn_pop(){
    	var url = "/CE/EPCE9000761.do";
    	var input = {};
    	INQ_PARAMS["PARAMS"] = input;
    	INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
    	INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE9000701.do";
    	kora.common.goPage(url, INQ_PARAMS);
    	$("#modal").show();
    }
    
    function divDataTipFunction(seriesId, code, label, data) {
        if(INQ_PARAMS.SEL_PARAM ==null) return; 
        var RTN_QTY =0;               //무인회수기량
        var RTN_QTY_RT =0;            //무인회수기비율
        //2664-1134
        //console.log(JSON.stringify(selList.FLAG))
        for(var i=0; i<selList.length;i++){
            if(selList[i].AREA_CD == code){
            	RTN_QTY      = kora.common.gfn_setComma(selList[i].RTN_QTY);
            	RTN_QTY_RT   = kora.common.trunc(selList[i].RTN_QTY_RT,3);
                break;
            } 
        }
		
        
        var str = 
            '<div class="boxarea" style="width:300px; padding-right:10px; padding-left:10px">'
                +'<div class="info_tbl" style="">'
                    +'<table>'
                        +'<colgroup>'
                            +'<col style="width: 25%;">'
                            +'<col style="width: 40%;">'
                            +'<col style="width: 35%">'
                        +'</colgroup>'
                        +'<thead>'
                            +'<tr>'
                                    +'<th colspan="4" class="b">'+label+'</th>'
                            +'</tr>'
                        +'</thead>'
                        +'<tbody>'
                            +'<tr>'
                                    +'<td>구분</td>'
                                    +'<td>합</td>'
                                    +'<td>비율</td>'
                            +'</tr>'
                            +'<tr>'
                                    +'<td>회수량</td>'
                                    +'<td id="" style="text-align:right;padding-right:5px">'+RTN_QTY+'</td>'
                                    +'<td id="" style="text-align:right;padding-right:5px">'+RTN_QTY_RT+' %</td>'
                            +'</tr>'
                        +'</tbody>'
                    +'</table>'
                +'</div>'
            +'</div>'
        
        return str;
    }
    /****************************************** 맵차트 셋팅 종료***************************************** */
    
    
    /****************************************** 파이차트 셋팅 시작***************************************** */

    // -----------------------차트 설정 시작-----------------------
    // rMate 차트 생성 준비가 완료된 상태 시 호출할 함수를 지정합니다.
    var chartVars = "rMateOnLoadCallFunction=chartReadyHandler";
    
    var chartApp;
    
    var layoutStrChart = 
        '<rMateChart backgroundColor="#FFFFFF"  borderStyle="none">'
            +'<Options>'
                +'<Legend useVisibleCheck="true"/>'
            +'</Options>'
            +'<NumberFormatter id="numFmt"/>'
            +'<Pie3DChart showDataTips="true" explodingAlone="true" depth="50" paddingLeft="100" paddingTop="50" paddingRight="100" paddingBottom="50">'
                +'<series>'
                    +'<Pie3DSeries nameField="TITLE_IN" field="VAL_IN" displayName="" labelPosition="inside" formatter="{numFmt}" color="#ffffff" >'
                        +'<showDataEffect>'
                            +'<SeriesSlide direction="right" duration="1000"/>'
                        +'</showDataEffect>'
                    +'</Pie3DSeries>'
                    +'<Pie3DSeries nameField="TITLE_OUT" field="VAL_OUT" displayName="" labelPosition="inside" formatter="{numFmt}" color="#ffffff" insideLabelRatio="0.8" innerStackRatio="0.06" >'
                    +'<showDataEffect>'
                        +'<SeriesSlide direction="right" duration="1000"/>'
                    +'</showDataEffect>'
                +'</Pie3DSeries>'
                +'</series>'
            +'</Pie3DChart>'
        +'</rMateChart>';

    rMateChartH5.create("chart", "chartHolder", chartVars, "100%", "100%");

    var chartData = [{TITLE_IN:"", TITLE_OUT:"", VAL_IN:"", VAL_OUT:""}];
    
    function chartReadyHandler(id){
        chartApp = document.getElementById(id);
        chartApp.setLayout(layoutStrChart);
        chartApp = document.getElementById(id);
        
    }
    
    // 차트 데이터
    /**
     * rMateChartH5 3.0이후 버전에서 제공하고 있는 테마기능을 사용하시려면 아래 내용을 설정하여 주십시오.
     * 테마 기능을 사용하지 않으시려면 아래 내용은 삭제 혹은 주석처리 하셔도 됩니다.
     *
     * -- rMateChartH5.themes에 등록되어있는 테마 목록 --
     * - simple
     * - cyber
     * - modern
     * - lovely
     * - pastel
     * -------------------------------------------------
     *
     * rMateChartH5.themes 변수는 theme.js에서 정의하고 있습니다.
     */
    rMateChartH5.registerTheme(rMateChartH5.themes);
    
    /**
     * 샘플 내의 테마 버튼 클릭 시 호출되는 함수입니다.
     * 접근하는 차트 객체의 테마를 변경합니다.
     * 파라메터로 넘어오는 값
     * - simple
     * - cyber
     * - modern
     * - lovely
     * - pastel
     * - default
     *
     * default : 테마를 적용하기 전 기본 형태를 출력합니다.
     */
    function rMateChartH5ChangeTheme(theme){
	    chartAppsetTheme(theme);
        //document.getElementById("chart").setTheme(theme);
    }
    /****************************************** 파이차트 셋팅 종료***************************************** */

    /****************************************** 그리드 셋팅 시작***************************************** */
    /**
     * 그리드 관련 변수 선언
     */
    var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
    var gridApp, gridRoot, dataGrid, layoutStr, selectorColumn;

    /**
     * 그리드 셋팅
     */
    function fnSetGrid() {
        rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%");

        layoutStr = new Array();
        layoutStr.push('<rMateGrid>');
        layoutStr.push('    <NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
        layoutStr.push('    <NumberFormatter id="numfmt1" precision="2" useThousandsSeparator="true"/>');
        layoutStr.push('    <PercentFormatter id="percfmt" precision="1" useThousandsSeparator="true"/>');
        layoutStr.push('    <DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" draggableColumns="true" sortableColumns="true" textAlign="center" >');
        layoutStr.push('        <groupedColumns>');
        layoutStr.push('            <DataGridColumn dataField="index" headerText="'+parent.fn_text('rank')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');			//순위
        layoutStr.push('            <DataGridColumn dataField="AREA_NM" headerText="'+parent.fn_text('area')+'" textAlign="center" width="200" />');												//지역
        layoutStr.push('			 <DataGridColumn dataField="RTN_QTY" headerText="회수량" width="200" formatter="{numfmt}" textAlign="right" id="num1"  />');	// 회수량
        layoutStr.push('            <DataGridColumn dataField="RTN_QTY_RT" headerText="비율" id="dg1col1" width="120" formatter="{numfmt1}" textAlign="right" />');								// 지역별 회수비율
        layoutStr.push('            <DataGridColumn dataField="RTN_GTN" headerText="'+parent.fn_text('gtn')+'"  width="120" formatter="{numfmt}" textAlign="right" id="num2" />');			// 보증금
        layoutStr.push('        </groupedColumns>');
		layoutStr.push('		<footers>');
		layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
		layoutStr.push('				<DataGridFooterColumn label="합계" textAlign="center"/>');
		layoutStr.push('				<DataGridFooterColumn/>');
		layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	
		layoutStr.push('				<DataGridFooterColumn/>');
		layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');		
		layoutStr.push('			</DataGridFooter>');
		layoutStr.push('		</footers>');        
        layoutStr.push('    </DataGrid>');
        layoutStr.push('</rMateGrid>');
    }

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
            gridApp.setData();
        }
        var dataCompleteHandler = function(event) {
            dataGrid = gridRoot.getDataGrid(); // 그리드 객체
        }
        var selectionChangeHandler = function(event) {
            var rowIndex = event.rowIndex;
            var columnIndex = event.columnIndex;
            selectorColumn = gridRoot.getObjectById("selector");
            var data = gridRoot.getItemAt(rowIndex);
		    clickFunction(data["AREA_CD"], data["AREA_NM"], data);
            
        }
        gridRoot.addEventListener("dataComplete", dataCompleteHandler);
        gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
    }    
    

    /**
     * 그리드 관련 변수 선언
     */
    var jsVars2 = "rMateOnLoadCallFunction=gridReadyHandler2";
    var gridApp2, gridRoot2, dataGrid2, layoutStr2, selectorColumn2;

    /**
     * 그리드 셋팅
     */
    function fnSetGrid2() {
        rMateGridH5.create("grid2", "gridHolder2", jsVars2, "100%", "100%");
		
        layoutStr2 = new Array();
        layoutStr2.push('<rMateGrid>');
        layoutStr2.push('    <NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
        layoutStr2.push('    <NumberFormatter id="numfmt1" precision="2" useThousandsSeparator="true"/>');
        layoutStr2.push('    <PercentFormatter id="percfmt" precision="1" useThousandsSeparator="true"/>');
        layoutStr2.push('    <DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" draggableColumns="true" sortableColumns="true" textAlign="center" >');
        layoutStr2.push('        <groupedColumns>');
        layoutStr2.push('            <DataGridColumn dataField="index" headerText="'+parent.fn_text('rank')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
	    layoutStr2.push('            <DataGridColumn dataField="FLAG" headerText="회수처" textAlign="center" width="200" />');
	    layoutStr2.push('            <DataGridColumn dataField="COLL_NM" headerText="무인회수기/반환수집소명" textAlign="center" width="200" />');
	    layoutStr2.push('            <DataGridColumn dataField="SERIAL_NO" headerText="시리얼번호/수집소번호" textAlign="center" width="200" />');
	    layoutStr2.push('            <DataGridColumn dataField="COLL_RTN_QTY" headerText="회수량" width="120" formatter="{numfmt}" textAlign="right"  id="num11" />');
	    layoutStr2.push('            <DataGridColumn dataField="COLL_QTY_RT" headerText="비율" id="dg1col1" width="120" formatter="{numfmt1}" textAlign="right" />');
        layoutStr2.push('            <DataGridColumn dataField="RTN_GTN" headerText="'+parent.fn_text('gtn')+'" width="120" formatter="{numfmt}" textAlign="right" id="num22"  />');
        layoutStr2.push('        </groupedColumns>');
		layoutStr2.push('		<footers>');
		layoutStr2.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
		layoutStr2.push('				<DataGridFooterColumn label="합계" textAlign="center"/>');
		layoutStr2.push('				<DataGridFooterColumn/>');
		layoutStr2.push('				<DataGridFooterColumn/>');
		layoutStr2.push('				<DataGridFooterColumn/>');
		layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num11}" formatter="{numfmt}" textAlign="right"/>');	
		layoutStr2.push('				<DataGridFooterColumn/>');
		layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num22}" formatter="{numfmt}" textAlign="right"/>');		
		layoutStr2.push('			</DataGridFooter>');
		layoutStr2.push('		</footers>');                
        layoutStr2.push('    </DataGrid>');
        layoutStr2.push('</rMateGrid>');
    }

    /**
     * 조회기준-생산자 그리드 이벤트 핸들러
     */
    function gridReadyHandler2(id) {
        gridApp2 = document.getElementById(id); // 그리드를 포함하는 div 객체
        gridRoot2 = gridApp2.getRoot(); // 데이터와 그리드를 포함하는 객체
        gridApp2.setLayout(layoutStr2.join("").toString());
        gridApp2.setData();
        
        var layoutCompleteHandler2 = function(event) {
            dataGrid2 = gridRoot2.getDataGrid(); // 그리드 객체
            dataGrid2.addEventListener("change", selectionChangeHandler2);
            gridApp.setData();
        }
        var dataCompleteHandler2 = function(event) {
            dataGrid2 = gridRoot2.getDataGrid(); // 그리드 객체
        }
        var selectionChangeHandler2 = function(event) {
            var rowIndex = event.rowIndex;
            var columnIndex = event.columnIndex;
            selectorColumn2 = gridRoot.getObjectById("selector");
        }
        gridRoot2.addEventListener("dataComplete", dataCompleteHandler2);
        gridRoot2.addEventListener("layoutComplete", layoutCompleteHandler2);
    }    

    
    
    
    /****************************************** 그리드 셋팅 끝***************************************** */
</script>

<style type="text/css">
.srcharea .row .col .tit{
    width: 96px;
}

.fa-close:before, .fa-times:before {
    content: "X"; 
    font-weight: 550;
}
 
 
.ax5autocomplete-display-table >div>a>div{
    margin-top: 8px;
}
</style>

</head>
<body>
    <div class="iframe_inner" >
           <input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
        <input type="hidden" id="areaList" value="<c:out value='${areaList}' />" />
        <div class="h3group">
            <h3 class="tit" id="title"></h3>
            <div class="btn" style="float:right" id="UR">
            <!--btn_dwnd  -->
            <!--btn_excel  -->
            </div>
        </div>
        <section class="secwrap"   id="params">
            <div class="srcharea mt10" > 
                <div class="row" >
                    <div class="col"  style="width: 50%">
                        <div class="tit" id="sel_term_txt"></div>    <!-- 조회기간 -->
                        <div class="box">
                            <div class="calendar">
                                <input type="text" id="START_DT" name="from" style="width: 179px;" class="i_notnull"><!--시작날짜  -->
                            </div>
                            <div class="obj">~</div>
                            <div class="calendar">
                                <input type="text" id="END_DT" name="to" style="width: 179px;"    class="i_notnull"><!-- 끝날짜 -->
                            </div>
                        </div>
                    </div>
                </div> <!-- end of row -->
                <div class="row">
                <div class="col">
						<div class="tit" id="coll_se"></div>  
                            <div class="box">
                            	<select id="CollecList_SEL" style="width: 179px">
                        			<option>전체</option>
                        			<option>무인회수기</option>
                        			<option>반환수집소</option>
                        		</select>
                        	</div>
                  </div>      	
                     <div class="btn"  id="CR" >
                     <button type="button" class="btn36 c1" style="width: 100px;" id="btn_pop">월별 회수량</button>
                     </div> <!--조회  -->
                  </div> <!-- end of row -->
            </div>  <!-- end of srcharea -->
        </section>
    
        <!-- 맵차트 셋팅 -->
        <div class="boxarea mt20" style="width:45%; display: inline-block;">  <!-- 634 -->
            <div id="mapHolder" style="height: 590px; background: #FFF;"></div>
        </div>
        
        <!-- 파이차트 셋팅 -->
        <div class="boxarea mt20" style="width:45%; display: inline-block;">
            <!-- 차트가 삽입될 DIV -->
            <div id="chartHolder" style="height: 590px; background: #FFF;"></div>
        </div>
        
        <!-- 그리드 셋팅 -->
        <div class="boxarea mt15">
            <div id="gridHolder" style="height: 272px;"></div></BR>
            <div class="h4group" >
                <h5 id="AREA_NM" class="tit" style="font-size: 16px;">지역명</h5>
            </div>
            <div id="gridHolder2" style="height: 272px;"></div>
        </div>
		<div class="h4group" >
					<h5 class="tit"  style="font-size: 16px;">
						&nbsp;※ 조회기간의 기준은 출고일자, 입고확인일자, 직접회수일자, 교환확인일자 기준입니다.<br/>
						&nbsp;※ 지역구분은 생산자 직매장/공장 지역 기준입니다.<br/>
					</h5>
		</div>            
        <section class="btnwrap" style="" >
            <div class="btn" id="BL"></div>
            <div class="btn" style="float:right" id="BR"></div>
        </section>
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