<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>생산자별 출고/회수 현황</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />

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
<link type="text/css" rel="stylesheet" href="/rMateChart/Web/syntax/shCoreDefault.css"/>
<!-- rMateChart -->

<script type="text/javaScript" language="javascript" defer="defer">

	var INQ_PARAMS = []; //파라미터 데이터

    $(function() {
    	 
    	//버튼 셋팅
    	fn_btnSetting();
    	
    	$('.row > .col > .tit').each(function(){
			$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
		});
    	
    	//그리드 셋팅
		fnSetGrid1();

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

		
  		$("#btn_sel").click(function(){
			fn_sel("Y"); //조회버튼 클릭 시 챠트조회
		});
  		
  		/************************************
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ***********************************/
		 $("#btn_excel").click(function() {
			 fn_excel();
		 });
  		
	});
    
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
        var groupCnt2Tot = 0;
        var groupCnt2 = 0;
        
        var groupCntTot = 0;
        var groupCnt = 0;
        
        var j=0;
        var t=0;
        
        
        var columns = dataGrid.getColumns();
        for(i=0; i<columns.length; i++){
            
            if(columns[i].getDataField() != undefined && columns[i].getDataField() != 'index'){ //순번 제외
                var item = {};

                //그룹헤더용
                if(groupCnt > 0) {
                    item['groupHeader2']  = "M";
                    item['groupHeader'] = "";

                    groupCnt--;
                }
                else {
                    if(groupCnt2 > 0){
                        item['groupHeader2']  = "M";
                        if(groupList[t].children != null && groupList[t].children.length > 0){
                            item['groupHeader'] = groupList[t].children[j].getHeaderText();
                            
                            if(groupList[t].children[j].children != null && groupList[t].children[j].children.length > 0){
                                groupCnt = groupList[t].children[j].children.length;
                                groupCnt--;
                                groupCntTot += (groupList[t].children[j].children.length - 1);
                            }
                            
                            j++;
                        }
    
                        groupCnt2--;
                    }
                    else{
                	    var calc = i-groupCnt2Tot-groupCntTot;
                	    console.log("calc : " + calc);
                	    try{
                		    item['groupHeader2'] = groupList[i-groupCnt2Tot].getHeaderText();
                	    } 
                	    catch(ex) {
                		    item['groupHeader2'] = groupList[i-groupCnt2Tot-groupCntTot].getHeaderText();
                	    }
                        
                        
                        t = i-groupCnt2Tot-groupCntTot;
                        j = 0;

                        if(groupList[t].children != null && groupList[t].children.length > 0){
                            item['groupHeader'] = groupList[i-groupCnt2Tot].children[j].getHeaderText();
                            
                        	if(groupList[i-groupCnt2Tot].children[j].children != null && groupList[i-groupCnt2Tot].children[j].children.length > 0){
                                groupCnt = groupList[i-groupCnt2Tot].children[j].children.length;
                                groupCnt--;
                                groupCntTot += (groupList[i-groupCnt2Tot].children[j].children.length - 1);
                            }

                            groupCnt2 = groupList[i-groupCnt2Tot].children.length;
                            groupCnt2--;
                            groupCnt2Tot += (groupList[i-groupCnt2Tot].children.length - 1);
                            
                            j++;
                        }
                        else {
                            item['groupHeader'] = item['groupHeader2'];
                        }
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
		
		var url = "/CE/EPCE6123901_05.do";
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
	function fn_sel(chartYn){
    	
		var url = "/CE/EPCE6123901_19.do";
		var input = {};
		
		input['START_DT'] = $("#START_DT").val();
		input['END_DT'] = $("#END_DT").val();
		
		input['CHART_YN'] = chartYn;

		//파라미터에 조회조건값 저장 
		INQ_PARAMS["SEL_PARAMS"] = input;
		
// 		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
$("#modal").show();
		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != ""){
				gridApp.setData(rtnData.searchList);
				
				if(chartYn == "Y"){ //조회버튼 클릭 시 챠트조회

					if(rtnData.searchList == undefined || rtnData.searchList.length == 0){
						chartApp.setData(chartData);
					}else{
						chartApp.setData(rtnData.searchList);
					}
					
					var dlivyQty = 0;
					var cfmQty = 0;
					var tot = 0;
					
					for(var i in rtnData.searchList){
						dlivyQty += Number(rtnData.searchList[i].DLIVY_QTY_TOT);
						cfmQty += Number(rtnData.searchList[i].RTRVL_QTY);
					}
					
					$('#DLIVY_QTY').text(kora.common.format_comma(dlivyQty));
					$('#CFM_QTY').text(kora.common.format_comma(cfmQty));
					//$('#TOT').text(kora.common.format_comma(dlivyQty + cfmQty));
					
				}
				
			} else {
				alertMsg("error");
			}
// 		kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
			$("#modal").hide();
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
			layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr.push('	<PercentFormatter id="percfmt" precision="1" useThousandsSeparator="true"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM" headerText="'+parent.fn_text('mfc_bizrnm')+'" textAlign="center" width="150" />');
			layoutStr.push('			<DataGridColumnGroup headerText="'+parent.fn_text('dlivy_a')+'">');
			layoutStr.push('				<DataGridColumn dataField="DLIVY_QTY_1" headerText="'+parent.fn_text('fh')+'" id="dg1col0" width="120" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('				<DataGridColumn dataField="DLIVY_QTY_2" headerText="'+parent.fn_text('fb')+'" id="dg1col1" width="120" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('				<DataGridColumn dataField="DLIVY_QTY_TOT" headerText="'+parent.fn_text('dlivy_sum')+'" id="dg1col2" width="120" formatter="{numfmt}" textAlign="right" />');
            layoutStr.push('            </DataGridColumnGroup>');
            layoutStr.push('            <DataGridColumnGroup headerText="'+parent.fn_text('rtrvl_b')+'">');
			layoutStr.push('			    <DataGridColumnGroup headerText="'+parent.fn_text('wrhs')+'">');
			layoutStr.push('			    	<DataGridColumn dataField="CFM_QTY_1" headerText="'+parent.fn_text('fh')+'" id="dg1col3" width="120" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('				    <DataGridColumn dataField="CFM_QTY_2" headerText="'+parent.fn_text('drct_rtn')+'" id="dg1col4" width="120" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('				    <DataGridColumn dataField="CFM_QTY_3" headerText="'+parent.fn_text('fb')+'" id="dg1col5" width="120" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('				    <DataGridColumn dataField="CFM_QTY_TOT" headerText="'+parent.fn_text('wrhs_sum')+'" id="dg1col6" width="120" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('			    </DataGridColumnGroup>');
            layoutStr.push('                <DataGridColumnGroup headerText="'+parent.fn_text('drct_rtrvl')+'">');
            layoutStr.push('                    <DataGridColumn dataField="DRCT_RTRVL_QTY_1" headerText="'+parent.fn_text('fh')+'" id="dg1col7" width="120" formatter="{numfmt}" textAlign="right" />');
            layoutStr.push('                    <DataGridColumn dataField="DRCT_RTRVL_QTY_2" headerText="'+parent.fn_text('fb')+'" id="dg1col8" width="120" formatter="{numfmt}" textAlign="right" />');
            layoutStr.push('                    <DataGridColumn dataField="DRCT_RTRVL_QTY_TOT" headerText="'+parent.fn_text('drct_rtrvl_sum')+'" id="dg1col9" width="120" formatter="{numfmt}" textAlign="right" />');
            layoutStr.push('                </DataGridColumnGroup>');
            layoutStr.push('                <DataGridColumnGroup headerText="'+parent.fn_text('exch')+'">');
            layoutStr.push('                    <DataGridColumn dataField="EXCH_QTY_1" headerText="'+parent.fn_text('exch_wrhs_qty')+'" id="dg1col10" width="120" formatter="{numfmt}" textAlign="right" />');
            layoutStr.push('                    <DataGridColumn dataField="EXCH_QTY_2" headerText="'+parent.fn_text('exch_dlivy_qty')+'" id="dg1col11" width="120" formatter="{numfmt}" textAlign="right" />');
            layoutStr.push('                    <DataGridColumn dataField="EXCH_QTY_TOT" headerText="'+parent.fn_text('exch_qty2')+'" id="dg1col12" width="120" formatter="{numfmt}" textAlign="right" />');
            layoutStr.push('                </DataGridColumnGroup>');
            layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY" headerText="'+parent.fn_text('rtrvl_sum2')+'" id="dg1col13" width="120" formatter="{numfmt}" textAlign="right" />');
            layoutStr.push('            </DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumn dataField="QTY_RT" headerText="'+parent.fn_text('rtrvl_rt')+'&lt;br&gt;(A/B)" id="dg1col14" width="120" formatter="{percfmt}" textAlign="right"/>');
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{dg1col0}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{dg1col1}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{dg1col2}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{dg1col3}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{dg1col4}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{dg1col5}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{dg1col6}" formatter="{numfmt}" textAlign="right"/>');
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{dg1col7}" formatter="{numfmt}" textAlign="right"/>');
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{dg1col8}" formatter="{numfmt}" textAlign="right"/>');
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{dg1col9}" formatter="{numfmt}" textAlign="right"/>');
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{dg1col10}" formatter="{numfmt}" textAlign="right"/>');
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{dg1col11}" formatter="{numfmt}" textAlign="right"/>');
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{dg1col12}" formatter="{numfmt}" textAlign="right"/>');
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{dg1col13}" formatter="{numfmt}" textAlign="right"/>');
            layoutStr.push('                <DataGridFooterColumn dataColumn="{dg1col14}" />');
			layoutStr.push('			</DataGridFooter>');
			layoutStr.push('		</footers>');
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
			rowIndexValue = rowIndex;
		
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	}	
	
	/****************************************** 그리드 셋팅 끝***************************************** */


	// -----------------------차트 설정 시작-----------------------
	 
	// rMate 차트 생성 준비가 완료된 상태 시 호출할 함수를 지정합니다.
	var chartVars = "rMateOnLoadCallFunction=chartReadyHandler";
	var layoutStrChart, chartApp;
	 
	// rMateChart 를 생성합니다.
	// 파라메터 (순서대로) 
	//  1. 차트의 id ( 임의로 지정하십시오. ) 
	//  2. 차트가 위치할 div 의 id (즉, 차트의 부모 div 의 id 입니다.)
	//  3. 차트 생성 시 필요한 환경 변수들의 묶음인 chartVars
	//  4. 차트의 가로 사이즈 (생략 가능, 생략 시 100%)
	//  5. 차트의 세로 사이즈 (생략 가능, 생략 시 100%)
	rMateChartH5.create("rChart", "chartHolder", chartVars, "100%", "100%"); 
	 
	// 차트의 속성인 rMateOnLoadCallFunction 으로 설정된 함수.
	// rMate 차트 준비가 완료된 경우 이 함수가 호출됩니다.
	// 이 함수를 통해 차트에 레이아웃과 데이터를 삽입합니다.
	// 파라메터 : id - rMateChartH5.create() 사용 시 사용자가 지정한 id 입니다.
	function chartReadyHandler(id) {
		chartApp = document.getElementById(id);
		chartApp.setLayout(layoutStrChart.join("").toString());
	}
	 
	// 스트링 형식으로 레이아웃 정의.
	
	layoutStrChart = new Array();
	layoutStrChart.push('<rMateChart backgroundColor="#FFFFFF"  borderStyle="none">');
	layoutStrChart.push('    <Options>');
	//layoutStrChart.push('        <Caption text=""/>');
	//layoutStrChart.push('        <SubCaption text="" textAlign="right" />');
	layoutStrChart.push('      <Legend defaultMouseOverAction="false" useVisibleCheck="false"/>');
	layoutStrChart.push('   </Options>');
	layoutStrChart.push('   <Column3DChart showDataTips="true" cubeAngleRatio="1" columnWidthRatio="0.7" >');
	layoutStrChart.push('       <horizontalAxis>');
	layoutStrChart.push('             <CategoryAxis categoryField="MFC_BIZRABBRNM"/>');
	layoutStrChart.push('       </horizontalAxis>');
	layoutStrChart.push('        <verticalAxis>');
	layoutStrChart.push('           <LinearAxis/>');
	layoutStrChart.push('       </verticalAxis>');
	layoutStrChart.push('          <series>');
	layoutStrChart.push('             <Column3DSeries labelPosition="outside" yField="DLIVY_QTY_TOT" displayName="출고량" outsideLabelYOffset="-10" showTotalLabel="true" showValueLabels="[]" halfWidthOffset="0" itemRenderer="CylinderItemRenderer">');
	layoutStrChart.push('                  <showDataEffect>');
	layoutStrChart.push('                     <SeriesInterpolate/>');
	layoutStrChart.push('                </showDataEffect>');
	layoutStrChart.push('            </Column3DSeries>');
	layoutStrChart.push('            <Column3DSeries labelPosition="outside" yField="RTRVL_QTY" displayName="회수량" outsideLabelYOffset="-10" showTotalLabel="true" showValueLabels="[]" halfWidthOffset="0" itemRenderer="CylinderItemRenderer">');
	layoutStrChart.push('                <showDataEffect>');
	layoutStrChart.push('                     <SeriesInterpolate/>');
	layoutStrChart.push('                </showDataEffect>');
	layoutStrChart.push('            </Column3DSeries>');
	layoutStrChart.push('        </series>');
	layoutStrChart.push('    </Column3DChart>');
	layoutStrChart.push(' </rMateChart>');
	 
	// 차트 데이터
	var chartData = [{MFC_BIZRABBRNM:"", DLIVY_QTY_TOT:0, RTRVL_QTY:0}];
	 
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
		 chartApp.setTheme(theme);
	}
	 
	// -----------------------차트 설정 끝 -----------------------

</script>

<style type="text/css">
	.srcharea .row .col .tit{width: 75px;}
</style>

</head>
<body>

    <div class="iframe_inner" >
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn" style="float:right" id="UR">
			</div>
		</div>
		<section class="secwrap"  id="params">
				<div class="srcharea" > 
					<div class="row" >
						<div class="col"  >
							<div class="tit" id="sel_term_txt"></div>
							<div class="box">
								<div class="calendar">
									<input type="text" id="START_DT" name="from" style="width: 139px;" class="i_notnull"><!--시작날짜  -->
								</div>
								<div class="obj">~</div>
								<div class="calendar">
									<input type="text" id="END_DT" name="to" style="width: 139px;"	class="i_notnull"><!-- 끝날짜 -->
								</div>
							</div>
						</div>
						<div class="btn" id="CR"></div>
					</div> <!-- end of row -->
				</div>  <!-- end of srcharea -->
			</section>
			
			<section class="secwrap2 mt15">
				<div class="boxarea" style="width:20%;margin:0px;">
					<div class="info_tbl" style="">
						<table>
							<colgroup>
								<col style="width: 60%;">
								<col style="width: 40%;">
							</colgroup>
							<thead>
								<tr>
									<th colspan="2" class="b">출고/회수량</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>출고량</td>
									<td id="DLIVY_QTY"></td>
								</tr>
								<tr>
									<td>회수량</td>
									<td id="CFM_QTY"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div style="width:80%;height:300px;float:right;padding:0 20px 0 15px;margin:0px">
					<!-- 차트가 삽입될 DIV -->
					<div id="chartHolder" style="height:300px"></div>
				</div>
			</section>
			
			<div class="boxarea mt15">
				<div id="gridHolder" style="height: 480px;"></div>
			</div>
			
			<div class="h4group" >
				<h5 class="tit"  style="font-size: 16px;">
					&nbsp;※ 조회기간의 기준은 출고일자, 입고확인일자, 직접회수일자 및 교환확인일자 입니다.<br/>
				</h5>  
			</div>
			
			<section class="btnwrap" style="" >
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
		<div id="modal" class="searchModal"  style="display: none;">
		<div class="search-modal-content" >
			<h5> <img alt="" src="../../images/main/loading.gif"></h5>
		</div>
	</div>
</body>
</html>