<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>주간누계현황</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<!-- <script type="text/javascript" src="/rMateGrid/Web/JS/util.js"></script> -->
<script type="text/javascript" src="/rMateGrid/r/Web/syntax/shCore.js"></script>
<script type="text/javascript" src="/rMateGrid/r/Web/syntax/shBrushJScript.js"></script>
<link type="text/css" rel="stylesheet" href="/rMateGrid/r/Web/syntax/shCoreDefault.css"/>
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
		
  		$("#btn_sel").click(function(){
			fn_sel("Y");
		});
  		
  		/************************************
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ***********************************/
		 $("#btn_excel").click(function() {
			 fn_excel();
		 });
  		
	});
    
	
	 // 엑셀 export
	 // excelExportSave(url:String, async:Boolean);
	 //     url : 업로드할 서버의 url, 기본값 null
	 //     async : 비동기 모드로 수행여부, 기본값 false
	 function fn_excel() {

		var now  = new Date(); 				     // 현재시간 가져오기
		var hour = new String(now.getHours());   // 시간 가져오기
		var min  = new String(now.getMinutes()); // 분 가져오기
		var sec  = new String(now.getSeconds()); // 초 가져오기
		var today = kora.common.gfn_toDay();
		var fileName = $('#title').text().replace("/","_") +"_" + today+hour+min+sec+".xlsx";
		 
	 	dataGrid.exportFileName = fileName;
		//dataGrid.exportSheetName = "Sheet1";
	
	 	gridRoot.excelExportSave("", false);
	 }
	
  //엑셀저장
	function fn_excel_bak(){

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
		
		var columns = dataGrid.getColumns(); console.log("columns.length = " + columns.length);
		for(i=0; i<columns.length; i++){
			if(columns[i].getDataField() != undefined && columns[i].getDataField() != 'index'){ //순번 제외
				var item = {};

				//그룹헤더용
				if(groupCnt > 0){
					item['groupHeader']  = '';
					groupCnt--;
				}else{
					console.log(i+";;"+groupCntTot+";;"+groupList[i-groupCntTot].getHeaderText());
					item['groupHeader'] = groupList[i-groupCntTot].getHeaderText();
					if(groupList[i-groupCntTot].children != null && groupList[i-groupCntTot].children.length > 0){
						groupCnt = groupList[i-groupCntTot].children.length;
						if(groupList[i-groupCntTot].getHeaderText() == '출고' || groupList[i-groupCntTot].getHeaderText() == '회수'){
							groupCnt += 12;
						}
						groupCnt--;
						groupCntTot += (groupList[i-groupCntTot].children.length - 1);
					}
				}
				//그룹헤더용
				
				console.log(columns[i].getHeaderText());
				item['headerText'] = columns[i].getHeaderText();
				item['dataField'] = columns[i].getDataField();
				item['textAlign'] = columns[i].getStyle('textAlign');
				item['id'] = kora.common.null2void(columns[i].id);
				
				col.push(item);
			}
		}
		
		var input = INQ_PARAMS["SEL_PARAMS"];
		input['fileName'] = fileName;
		input['columns'] = JSON.stringify(col);
		
		var url = "/CE/EPCE6186201_05.do";
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
    	
		var url = "/CE/EPCE6186201_19.do";
		var input = {};
		
		input['STD_DT'] = $("#START_DT").val().replace(/-/gi, "");

		//파라미터에 조회조건값 저장 
		INQ_PARAMS["SEL_PARAMS"] = input;
		
// 		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
		$("#modal").show();
		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != ""){
				gridApp.setData(rtnData.selList);
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

	// 데이터 방식이 XML 방식일 경우 dataType을 설정합니다.
	jsVars += "&dataType=xml";
	
	/**
	 * 그리드 셋팅
	 */
	 function fnSetGrid1(reDrawYn) {
			rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%");

			layoutStr = new Array();
			
			
			layoutStr.push('<rMateGrid>');
			layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr.push('	<PercentFormatter id="percfmt" precision="2" useThousandsSeparator="true"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" textAlign="center" headerWordWrap="true" selectionMode="singleCell" >');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridColumn dataField="ALKND_NM" headerText="'+parent.fn_text('se')+'" width="70" />');
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM" headerText="'+parent.fn_text('mfc_bizrnm')+'" width="100" />');
			layoutStr.push('			<DataGridColumnGroup headerText="'+parent.fn_text('dlivy')+'">');
			layoutStr.push('				<DataGridColumnGroup headerText="'+parent.fn_text('1week_sum')+'">');
			layoutStr.push('					<DataGridColumn dataField="DLIVY_QTY_1WEEK" headerText="'+parent.fn_text('sum2')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('					<DataGridColumn dataField="DLIVY_QTY_1WEEK_NEW" headerText="'+parent.fn_text('ctnr_new')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('					<DataGridColumn dataField="DLIVY_QTY_1WEEK_OLD" headerText="'+parent.fn_text('ctnr_old')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('				</DataGridColumnGroup>');
			layoutStr.push('				<DataGridColumnGroup headerText="'+parent.fn_text('2week_sum')+'">');
			layoutStr.push('					<DataGridColumn dataField="DLIVY_QTY_SUM" headerText="'+parent.fn_text('sum2')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('					<DataGridColumn dataField="DLIVY_QTY_SUM_NEW" headerText="'+parent.fn_text('ctnr_new')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('					<DataGridColumn dataField="DLIVY_QTY_SUM_OLD" headerText="'+parent.fn_text('ctnr_old')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('				</DataGridColumnGroup>');
			layoutStr.push('				<DataGridColumnGroup headerText="'+parent.fn_text('week_avg')+'">');
			layoutStr.push('					<DataGridColumn dataField="DLIVY_QTY_AVG" headerText="'+parent.fn_text('sum2')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('					<DataGridColumn dataField="DLIVY_QTY_AVG_NEW" headerText="'+parent.fn_text('ctnr_new')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('					<DataGridColumn dataField="DLIVY_QTY_AVG_OLD" headerText="'+parent.fn_text('ctnr_old')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('				</DataGridColumnGroup>');
			layoutStr.push('				<DataGridColumnGroup headerText="'+parent.fn_text('2week')+'">');
			layoutStr.push('					<DataGridColumn dataField="DLIVY_QTY_2WEEK" headerText="'+parent.fn_text('sum2')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('					<DataGridColumn dataField="DLIVY_QTY_2WEEK_NEW" headerText="'+parent.fn_text('ctnr_new')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('					<DataGridColumn dataField="DLIVY_QTY_2WEEK_OLD" headerText="'+parent.fn_text('ctnr_old')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('				</DataGridColumnGroup>');
			layoutStr.push('				<DataGridColumn dataField="DLIVY_INDE_QTY" headerText="'+parent.fn_text('week_avg_cpr_qty')+'" formatter="{numfmt}" width="100" textAlign="right" />');
			layoutStr.push('				<DataGridColumn dataField="DLIVY_INDE_RT" headerText="'+parent.fn_text('week_avg_cpr_rt')+'" formatter="{percfmt}" width="100" textAlign="right" />');
			layoutStr.push('			</DataGridColumnGroup>');
			
			layoutStr.push('			<DataGridColumnGroup headerText="'+parent.fn_text('rtrvl')+'">');
			layoutStr.push('				<DataGridColumnGroup headerText="'+parent.fn_text('1week_sum')+'">');
			layoutStr.push('					<DataGridColumn dataField="CFM_QTY_1WEEK" headerText="'+parent.fn_text('sum2')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('					<DataGridColumn dataField="CFM_QTY_1WEEK_NEW" headerText="'+parent.fn_text('ctnr_new')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('					<DataGridColumn dataField="CFM_QTY_1WEEK_OLD" headerText="'+parent.fn_text('ctnr_old')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('				</DataGridColumnGroup>');
			layoutStr.push('				<DataGridColumnGroup headerText="'+parent.fn_text('2week_sum')+'">');
			layoutStr.push('					<DataGridColumn dataField="CFM_QTY_SUM" headerText="'+parent.fn_text('sum2')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('					<DataGridColumn dataField="CFM_QTY_SUM_NEW" headerText="'+parent.fn_text('ctnr_new')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('					<DataGridColumn dataField="CFM_QTY_SUM_OLD" headerText="'+parent.fn_text('ctnr_old')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('				</DataGridColumnGroup>');
			layoutStr.push('				<DataGridColumnGroup headerText="'+parent.fn_text('week_avg')+'">');
			layoutStr.push('					<DataGridColumn dataField="CFM_QTY_AVG" headerText="'+parent.fn_text('sum2')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('					<DataGridColumn dataField="CFM_QTY_AVG_NEW" headerText="'+parent.fn_text('ctnr_new')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('					<DataGridColumn dataField="CFM_QTY_AVG_OLD" headerText="'+parent.fn_text('ctnr_old')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('				</DataGridColumnGroup>');
			layoutStr.push('				<DataGridColumnGroup headerText="'+parent.fn_text('2week')+'">');
			layoutStr.push('					<DataGridColumn dataField="CFM_QTY_2WEEK" headerText="'+parent.fn_text('sum2')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('					<DataGridColumn dataField="CFM_QTY_2WEEK_NEW" headerText="'+parent.fn_text('ctnr_new')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('					<DataGridColumn dataField="CFM_QTY_2WEEK_OLD" headerText="'+parent.fn_text('ctnr_old')+'" width="100" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('				</DataGridColumnGroup>');
			layoutStr.push('				<DataGridColumn dataField="CFM_INDE_QTY" headerText="'+parent.fn_text('week_avg_cpr_qty')+'" formatter="{numfmt}" width="100" textAlign="right" />');
			layoutStr.push('				<DataGridColumn dataField="CFM_INDE_RT" headerText="'+parent.fn_text('week_avg_cpr_rt')+'" formatter="{percfmt}" width="100" textAlign="right" />');
			layoutStr.push('			</DataGridColumnGroup>');
			
			layoutStr.push('			<DataGridColumnGroup headerText="'+parent.fn_text('2week_sum_rtrvl_rt')+'" >');
			//layoutStr.push('				<DataGridColumnGroup headerText="">');
			layoutStr.push('					<DataGridColumn dataField="RTRVL_RT" headerText="'+parent.fn_text('sum2')+'" width="100" formatter="{percfmt}" textAlign="right" />');
			layoutStr.push('					<DataGridColumn dataField="RTRVL_RT_NEW" headerText="'+parent.fn_text('ctnr_new')+'" width="100" formatter="{percfmt}" textAlign="right" />');
			layoutStr.push('					<DataGridColumn dataField="RTRVL_RT_OLD" headerText="'+parent.fn_text('ctnr_old')+'" width="100" formatter="{percfmt}" textAlign="right" />');
			//layoutStr.push('				</DataGridColumnGroup>');
			layoutStr.push('			</DataGridColumnGroup>');
			
			layoutStr.push('			<DataGridColumnGroup headerText="'+parent.fn_text('2week_rtrvl_rt')+'" >');
			//layoutStr.push('				<DataGridColumnGroup headerText="">');
			layoutStr.push('					<DataGridColumn dataField="RTRVL_RT_2WEEK" headerText="'+parent.fn_text('sum2')+'" width="100" formatter="{percfmt}" textAlign="right" />');
			layoutStr.push('					<DataGridColumn dataField="RTRVL_RT_2WEEK_NEW" headerText="'+parent.fn_text('ctnr_new')+'" width="100" formatter="{percfmt}" textAlign="right" />');
			layoutStr.push('					<DataGridColumn dataField="RTRVL_RT_2WEEK_OLD" headerText="'+parent.fn_text('ctnr_old')+'" width="50" formatter="{percfmt}" textAlign="right" />'); //마지막은 왜 width가 두배로 먹나...
			//layoutStr.push('				</DataGridColumnGroup>');
			layoutStr.push('			</DataGridColumnGroup>');

			layoutStr.push('		</groupedColumns>');
			
			layoutStr.push('		<dataProvider>');
			layoutStr.push('			<SpanSummaryCollection source="{$gridData}">');
			layoutStr.push('				<mergingFields>');
			layoutStr.push('					<SpanMergingField name="ALKND_NM" colNum="0"/>');
			layoutStr.push('					<SpanMergingField name="MFC_BIZRNM" colNum="1"/>');
			layoutStr.push('				</mergingFields>');
			layoutStr.push('			</SpanSummaryCollection>');
			layoutStr.push('		</dataProvider>');

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
			gridApp.setData();
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
							<div class="tit" id="std_dt_txt"></div>
							<div class="box">
								<div class="calendar">
									<input type="text" id="START_DT" name="from" style="width: 139px;" class="i_notnull"><!--시작날짜  -->
								</div>
							</div>
						</div>
						<div class="btn" id="CR"></div>
					</div> <!-- end of row -->
				</div>  <!-- end of srcharea -->
			</section>
			
			<div class="boxarea mt15">
				<div id="gridHolder" style="height: 480px;"></div>
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