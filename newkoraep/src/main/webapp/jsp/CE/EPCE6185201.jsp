<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>연도별 출고/회수 현황</title>
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
	
	var selGbn = '1'; //적용 그리드 확인용
	
    $(function() {
    	 
    	INQ_PARAMS = jsonObject($("#INQ_PARAMS").val()); //파라미터 데이터
		mfc_bizrnm_sel = jsonObject($("#mfc_bizrnm_sel_list").val()); //생산자
    	
		//생산자
		kora.common.setEtcCmBx2(mfc_bizrnm_sel, "", "", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N", "T");
		
    	//버튼 셋팅
    	fn_btnSetting();
    	
    	$('.row > .col > .tit').each(function(){
			$(this).text(parent.fn_text($(this).attr('id')) );
		});
    	
		$('#std_year').text(parent.fn_text('std_year'));
		$('#sel_term').text(parent.fn_text('sel_term'));
		
    	var date = new Date();
	    var year = date.getFullYear();
	    var selected = "";
	    for(i=2016; i<=year; i++){
	    	if(i == year) selected = "selected";
	    	$('#STD_YEAR_SEL').append('<option value="'+i+'" '+selected+'>'+i+'</option>');
	    }
    	
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
			fn_sel("Y");
		});
  		
  		$("#btn_chart").click(function(){
			fn_chart();
		});

  		$("#SEL_GBN").change(function(){
			selGbnCh();
		});
  		
  		
  		/************************************
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ***********************************/
		 $("#btn_excel").click(function() {
			 fn_excel();
		 });
  		
		 /************************************
		 * 라디오버튼  변경 이벤트
		 ***********************************/
		$(':radio[name="STD_RADIO"]').click(function(){

			if($(':radio[name="STD_RADIO"]:checked').val() == "YEAR"){
				$('#STD_YEAR_SEL').prop("disabled", false);
				$('#START_DT').prop("disabled", true);
				$('#END_DT').prop("disabled", true);
			}else if($(':radio[name="STD_RADIO"]:checked').val() == "DAY"){
				$('#STD_YEAR_SEL').prop("disabled", true);
				$('#START_DT').prop("disabled", false);
				$('#END_DT').prop("disabled", false);
			}
			
		});  		

	});
    
	function selGbnCh(){
		if($("#SEL_GBN").val() == '1'){
			$('#mfcDiv').attr('style','display:none');
		}else{
			$('#mfcDiv').attr('style','display:block');
		}
	}
	
	var chartData = '';
	var chartData2 = '';
	var textData = {};
	var width = '';
	var height = '';
	function fn_chart(){
		var collection = gridRoot.getCollection();
		if(collection.getLength() < 1){
			alertMsg("데이터가 없습니다.");
			return;
		}
		
		if(INQ_PARAMS["SEL_PARAMS"] == undefined){
			alertMsg("먼저 데이터를 조회해야 합니다.");
			return;
		}
		
		var url = "/CE/EPCE6185201_192.do";
		var input = INQ_PARAMS["SEL_PARAMS"];
		var chartUrl = '';
		
// 		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
$("#modal").show();
		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != ""){
				
				if(selGbn == '1'){
					chartUrl = '/jsp/chartPopup_pie.jsp';
					
					chartData = rtnData.selList;
					textData['title'] = '주종별 출고/회수량';
					textData['stdYear'] = input['STD_YEAR_SEL'];
					
					chartData2 = rtnData.selList2;
					textData['title2'] = '용도별 출고/회수량';
					textData['stdYear'] = input['STD_YEAR_SEL'];
					
					width = '950';
					height = '750';
					
				}else if(selGbn == '2'){
					chartUrl = '/jsp/chartPopup_col.jsp';
					
					chartData = rtnData.selList;
					textData['title'] = '월별 출고/회수량 - 용도별';
					
					textData['labelUp'] = '출고';
					textData['labelBt'] = '회수';
					
					textData['displayNm1'] = '유흥용';
					textData['displayNm2'] = '가정용';
					textData['displayNm3'] = '직접반환하는자용';
					
					width = '1000';
					height = '550';
				}else if(selGbn == '3'){
					chartUrl = '/jsp/chartPopup_line.jsp';
					
					chartData = rtnData.selList;
					textData['title'] = '월별 회수율 - 주종별';
					
					textData['displayNm1'] = '소주';
					textData['displayNm2'] = '맥주';
					textData['displayNm3'] = '기타주류';
					textData['displayNm4'] = '음료';
					
					width = '1000';
					height = '450';
				}else{
					chartUrl = '/jsp/chartPopup_com.jsp';
					
					chartData = rtnData.selList;
					textData['title'] = '연도별 출고/회수 현황';
					
					textData['displayNm1'] = '출고';
					textData['displayNm2'] = '회수';
					textData['displayNmLine'] = '회수율';
					
					width = '1000';
					height = '550';
				}
				
			} else {
				alertMsg("error");
			}
			window.open(chartUrl, "chartView", "width="+width+", height="+height+", location=0 ");
// 			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
			$("#modal").hide();
		});
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
		
		var url = "/CE/EPCE6185201_05.do";
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
    	
		var url = "/CE/EPCE6185201_19.do";
		var input = {};
		
		if($(':radio[name="STD_RADIO"]:checked').val() == "YEAR"){
			input["STD_YEAR_SEL"] = $('#STD_YEAR_SEL').val();
		}else if($(':radio[name="STD_RADIO"]:checked').val() == "DAY"){
			input['START_DT'] = $("#START_DT").val().replace(/\-/g,"");
			input['END_DT'] = $("#END_DT").val().replace(/\-/g,"");
			input['STD_YEAR_SEL'] = $("#END_DT").val().replace(/\-/g,"").substr(0, 4);
		}
		
		input["SEL_GBN"] = $('#SEL_GBN').val();
		input["MFC_BIZRNM"] = $('#MFC_BIZRNM').val();
		
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["SEL_PARAMS"] = input;
		
		gridApp.setData([]); //그리드데이터 리셋
		if($('#SEL_GBN').val() == '1' && selGbn != '1'){
			fnSetGrid1('Y');
			selGbn = '1';
		}else if($('#SEL_GBN').val() == '2' && selGbn != '2'){
			fnSetGrid2();
			selGbn = '2';
		}else if($('#SEL_GBN').val() == '3' && selGbn != '3'){
			fnSetGrid3();
			selGbn = '3';
		}else if(($('#SEL_GBN').val() == '4' && selGbn != '4') || ($('#SEL_GBN').val() == '5' && selGbn != '4') ){
			fnSetGrid4();
			selGbn = '4';
        }else if($('#SEL_GBN').val() == '6' && selGbn != '6'){
            fnSetGrid5();
            selGbn = '6';
		}
		
// 		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
$("#modal").show();
		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != ""){
				gridApp.setData(rtnData.selList);
			} else {
				alertMsg("error");
			}
// 			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
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
		if(reDrawYn != 'Y'){
			rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%");
		}
		
		layoutStr = new Array();
		layoutStr.push('<rMateGrid>');
		layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
		layoutStr.push('	<PercentFormatter id="percfmt" precision="1" useThousandsSeparator="true"/>');
		layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" textAlign="center" >');
		layoutStr.push('		<groupedColumns>');
		layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM" headerText="'+parent.fn_text('mfc_bizrnm')+'" textAlign="center" width="150" />');
		layoutStr.push('			<DataGridColumn dataField="ALKND_NM" width="70" headerText="'+parent.fn_text('se')+'" headerColSpan="3"  />');
        layoutStr.push('            <DataGridColumn dataField="CTNR_NM" width="70" headerText="'+parent.fn_text('se')+'" />');
		layoutStr.push('			<DataGridColumn dataField="PRPS_NM" width="120" headerText="'+parent.fn_text('se')+'" />');
		layoutStr.push('			<DataGridColumnGroup id="stdYear3" headerText="'+''+'">');
		layoutStr.push('				<DataGridColumn dataField="DLIVY_QTY_3" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('				<DataGridColumn dataField="CFM_QTY_3" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_3" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_3" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_3" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('				<DataGridColumn dataField="QTY_RT_3" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('			</DataGridColumnGroup>');
		layoutStr.push('			<DataGridColumnGroup id="stdYear2" headerText="'+''+'">');
		layoutStr.push('				<DataGridColumn dataField="DLIVY_QTY_2" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_2" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_2" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_2" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_2" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('				<DataGridColumn dataField="QTY_RT_2" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('			</DataGridColumnGroup>');
		layoutStr.push('			<DataGridColumnGroup id="stdYear1" headerText="'+''+'">');
        layoutStr.push('                <DataGridColumn dataField="DLIVY_QTY_1" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_1" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_1" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_1" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_1" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="QTY_RT_1" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('			</DataGridColumnGroup>');
		layoutStr.push('		</groupedColumns>');
		layoutStr.push('<dataProvider>');
		layoutStr.push('	<SpanSummaryCollection source="{$gridData}">');
		layoutStr.push('		<mergingFields>');
		layoutStr.push('			<SpanMergingField name="MFC_BIZRNM" colNum="0"/>');
        layoutStr.push('            <SpanMergingField name="ALKND_NM" colNum="1"/>');
        layoutStr.push('            <SpanMergingField name="CTNR_NM" colNum="2"/>');
		layoutStr.push('		</mergingFields>');
		layoutStr.push('	</SpanSummaryCollection>');
		layoutStr.push('</dataProvider>');		
		layoutStr.push('	</DataGrid>');
		layoutStr.push('</rMateGrid>');
		
		if(reDrawYn == 'Y'){
			gridApp.setLayout(layoutStr.join("").toString());
		}
	}
	
	/**
	 * 그리드 셋팅
	 */
	function fnSetGrid2(reDrawYn) {

		layoutStr = new Array();
		layoutStr.push('<rMateGrid>');
		layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
		layoutStr.push('	<PercentFormatter id="percfmt" precision="1" useThousandsSeparator="true"/>');
		layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" textAlign="center" >');
		layoutStr.push('		<groupedColumns>');
		layoutStr.push('			<DataGridColumn dataField="MM_NM" width="70" headerText="'+parent.fn_text('se')+'" />');
		layoutStr.push('			<DataGridColumnGroup id="stdYear5" headerText="'+''+'">');
		layoutStr.push('				<DataGridColumn dataField="DLIVY_QTY_5" headerText="'+parent.fn_text('dlivy')+'"  width="80" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_5" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_5" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_5" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_5" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('				<DataGridColumn dataField="QTY_RT_5" headerText="'+parent.fn_text('rtrvl_rt')+'"  width="80" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('			</DataGridColumnGroup>');
		layoutStr.push('			<DataGridColumnGroup id="stdYear4" headerText="'+''+'">');
		layoutStr.push('				<DataGridColumn dataField="DLIVY_QTY_4" headerText="'+parent.fn_text('dlivy')+'"  width="80" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_4" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_4" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_4" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_4" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('				<DataGridColumn dataField="QTY_RT_4" headerText="'+parent.fn_text('rtrvl_rt')+'"  width="80" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('			</DataGridColumnGroup>');
		layoutStr.push('			<DataGridColumnGroup id="stdYear3" headerText="'+''+'">');
		layoutStr.push('				<DataGridColumn dataField="DLIVY_QTY_3" headerText="'+parent.fn_text('dlivy')+'" width="80" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_3" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_3" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_3" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_3" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('				<DataGridColumn dataField="QTY_RT_3" headerText="'+parent.fn_text('rtrvl_rt')+'" width="80" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('			</DataGridColumnGroup>');
		layoutStr.push('			<DataGridColumnGroup id="stdYear2" headerText="'+''+'">');
		layoutStr.push('				<DataGridColumn dataField="DLIVY_QTY_2" headerText="'+parent.fn_text('dlivy')+'" width="80" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_2" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_2" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_2" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_2" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('				<DataGridColumn dataField="QTY_RT_2" headerText="'+parent.fn_text('rtrvl_rt')+'" width="80" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('			</DataGridColumnGroup>');
		layoutStr.push('			<DataGridColumnGroup id="stdYear1" headerText="'+''+'">');
		layoutStr.push('				<DataGridColumn dataField="DLIVY_QTY_1" headerText="'+parent.fn_text('dlivy')+'" width="80" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_1" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_1" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_1" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_1" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('				<DataGridColumn dataField="QTY_RT_1" headerText="'+parent.fn_text('rtrvl_rt')+'" width="80" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('			</DataGridColumnGroup>');
		layoutStr.push('		</groupedColumns>');
		layoutStr.push('	</DataGrid>');
		layoutStr.push('</rMateGrid>');
		
		gridApp.setLayout(layoutStr.join("").toString());
	}
	 
	/**
	 * 그리드 셋팅
	 */
	function fnSetGrid3(reDrawYn) {

		layoutStr = new Array();
		layoutStr.push('<rMateGrid>');
		layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
		layoutStr.push('	<PercentFormatter id="percfmt" precision="1" useThousandsSeparator="true"/>');
		layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" textAlign="center" >');
		layoutStr.push('		<groupedColumns>');
		layoutStr.push('			<DataGridColumn dataField="MM_NM" width="70" headerText="'+parent.fn_text('se')+'" />');
		layoutStr.push('			<DataGridColumnGroup headerText="'+'소주'+'">');
		layoutStr.push('				<DataGridColumn dataField="DLIVY_QTY_1" headerText="'+parent.fn_text('dlivy')+'"  width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_1" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_1" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_1" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_1" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('				<DataGridColumn dataField="QTY_RT_1" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('			</DataGridColumnGroup>');
		layoutStr.push('			<DataGridColumnGroup headerText="'+'맥주'+'">');
		layoutStr.push('				<DataGridColumn dataField="DLIVY_QTY_2" headerText="'+parent.fn_text('dlivy')+'" id="sum1" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_2" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_2" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_2" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_2" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('				<DataGridColumn dataField="QTY_RT_2" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('			</DataGridColumnGroup>');
		layoutStr.push('			<DataGridColumnGroup headerText="'+'기타주류'+'">');
		layoutStr.push('				<DataGridColumn dataField="DLIVY_QTY_3" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_3" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_3" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_3" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_3" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('				<DataGridColumn dataField="QTY_RT_3" headerText="'+parent.fn_text('rtrvl_rt')+'" id="sum6" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('			</DataGridColumnGroup>');
		layoutStr.push('			<DataGridColumnGroup headerText="'+'음료'+'">');
		layoutStr.push('				<DataGridColumn dataField="DLIVY_QTY_9" headerText="'+parent.fn_text('dlivy')+'" id="sum7" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_9" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_9" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_9" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_9" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('				<DataGridColumn dataField="QTY_RT_9" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('			</DataGridColumnGroup>');
		layoutStr.push('		</groupedColumns>');
		layoutStr.push('	</DataGrid>');
		layoutStr.push('</rMateGrid>');
		
		gridApp.setLayout(layoutStr.join("").toString());
	}

	/**
	 * 그리드 셋팅
	 */
	function fnSetGrid4(reDrawYn) {

		layoutStr = new Array();
		layoutStr.push('<rMateGrid>');
		layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
		layoutStr.push('	<PercentFormatter id="percfmt" precision="1" useThousandsSeparator="true"/>');
		layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" textAlign="center" >');
		layoutStr.push('		<groupedColumns>');
		layoutStr.push('			<DataGridColumn dataField="AREA_NM" headerText="'+parent.fn_text('se')+'" textAlign="center" width="150" />');
		layoutStr.push('			<DataGridColumnGroup id="stdYear3" headerText="'+''+'">');
		layoutStr.push('				<DataGridColumn dataField="DLIVY_QTY_3" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_3" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_3" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_3" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_3" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('				<DataGridColumn dataField="QTY_RT_3" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('			</DataGridColumnGroup>');
		layoutStr.push('			<DataGridColumnGroup id="stdYear2" headerText="'+''+'">');
		layoutStr.push('				<DataGridColumn dataField="DLIVY_QTY_2" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_2" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_2" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_2" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_2" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('				<DataGridColumn dataField="QTY_RT_2" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('			</DataGridColumnGroup>');
		layoutStr.push('			<DataGridColumnGroup id="stdYear1" headerText="'+''+'">');
		layoutStr.push('				<DataGridColumn dataField="DLIVY_QTY_1" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_1" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_1" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_1" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_1" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('				<DataGridColumn dataField="QTY_RT_1" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
		layoutStr.push('			</DataGridColumnGroup>');
		layoutStr.push('		</groupedColumns>');
		layoutStr.push('	</DataGrid>');
		layoutStr.push('</rMateGrid>');
		
		gridApp.setLayout(layoutStr.join("").toString());
	}
	
    /**
     * 그리드 셋팅
     */
    function fnSetGrid5(reDrawYn) {

        layoutStr = new Array();
        layoutStr.push('<rMateGrid>');
        layoutStr.push('    <NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
        layoutStr.push('    <PercentFormatter id="percfmt" precision="1" useThousandsSeparator="true"/>');
        layoutStr.push('    <DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" textAlign="center" >');
        layoutStr.push('        <groupedColumns>');
        layoutStr.push('            <DataGridColumn dataField="MFC_BIZRNM" headerText="'+parent.fn_text('mfc_bizrnm')+'" textAlign="center" width="150" />');
        layoutStr.push('            <DataGridColumn dataField="ALKND_NM" width="70" headerText="'+parent.fn_text('se')+'" headerColSpan="3"  />');
        layoutStr.push('            <DataGridColumn dataField="CTNR_NM" width="70" headerText="'+parent.fn_text('se')+'" />');
        layoutStr.push('            <DataGridColumn dataField="PRPS_NM" width="120" headerText="'+parent.fn_text('se')+'" />');
        layoutStr.push('            <DataGridColumnGroup id="stdMth_1" headerText="1월">');
        layoutStr.push('                <DataGridColumn dataField="DLIVY_QTY_1" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_1" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_1" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_1" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_1" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="QTY_RT_1" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('            </DataGridColumnGroup>');
        layoutStr.push('            <DataGridColumnGroup id="stdMth_2" headerText="2월">');
        layoutStr.push('                <DataGridColumn dataField="DLIVY_QTY_2" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_2" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_2" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_2" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_2" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="QTY_RT_2" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('            </DataGridColumnGroup>');
        layoutStr.push('            <DataGridColumnGroup id="stdMth_3" headerText="3월">');
        layoutStr.push('                <DataGridColumn dataField="DLIVY_QTY_3" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_3" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_3" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_3" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_3" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="QTY_RT_3" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('            </DataGridColumnGroup>');
        layoutStr.push('            <DataGridColumnGroup id="stdMth_4" headerText="4월">');
        layoutStr.push('                <DataGridColumn dataField="DLIVY_QTY_4" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_4" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_4" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_4" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_4" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="QTY_RT_4" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('            </DataGridColumnGroup>');
        layoutStr.push('            <DataGridColumnGroup id="stdMth_5" headerText="5월">');
        layoutStr.push('                <DataGridColumn dataField="DLIVY_QTY_5" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_5" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_5" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_5" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_5" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="QTY_RT_5" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('            </DataGridColumnGroup>');
        layoutStr.push('            <DataGridColumnGroup id="stdMth_6" headerText="6월">');
        layoutStr.push('                <DataGridColumn dataField="DLIVY_QTY_6" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_6" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_6" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_6" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_6" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="QTY_RT_6" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('            </DataGridColumnGroup>');
        layoutStr.push('            <DataGridColumnGroup id="stdMth_7" headerText="7월">');
        layoutStr.push('                <DataGridColumn dataField="DLIVY_QTY_7" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_7" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_7" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_7" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_7" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="QTY_RT_7" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('            </DataGridColumnGroup>');
        layoutStr.push('            <DataGridColumnGroup id="stdMth_8" headerText="8월">');
        layoutStr.push('                <DataGridColumn dataField="DLIVY_QTY_8" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_8" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_8" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_8" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_8" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="QTY_RT_8" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('            </DataGridColumnGroup>');
        layoutStr.push('            <DataGridColumnGroup id="stdMth_9" headerText="9월">');
        layoutStr.push('                <DataGridColumn dataField="DLIVY_QTY_9" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_9" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_9" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_9" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_9" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="QTY_RT_9" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('            </DataGridColumnGroup>');
        layoutStr.push('            <DataGridColumnGroup id="stdMth_10" headerText="10월">');
        layoutStr.push('                <DataGridColumn dataField="DLIVY_QTY_10" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_10" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_10" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_10" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_10" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="QTY_RT_10" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('            </DataGridColumnGroup>');
        layoutStr.push('            <DataGridColumnGroup id="stdMth_11" headerText="11월">');
        layoutStr.push('                <DataGridColumn dataField="DLIVY_QTY_11" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_11" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_11" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_11" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_11" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="QTY_RT_11" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('            </DataGridColumnGroup>');
        layoutStr.push('            <DataGridColumnGroup id="stdMth_12" headerText="12월">');
        layoutStr.push('                <DataGridColumn dataField="DLIVY_QTY_12" headerText="'+parent.fn_text('dlivy')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="CFM_QTY_12" headerText="'+parent.fn_text('wrhs')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="DRCT_RTRVL_QTY_12" headerText="'+parent.fn_text('drct_rtrvl')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="EXCH_QTY_12" headerText="'+parent.fn_text('exch')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="RTRVL_QTY_12" headerText="'+parent.fn_text('rtrvl_sum')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('                <DataGridColumn dataField="QTY_RT_12" headerText="'+parent.fn_text('rtrvl_rt')+'" width="100" formatter="{numfmt}" textAlign="right" />');
        layoutStr.push('            </DataGridColumnGroup>');
        layoutStr.push('        </groupedColumns>');
        layoutStr.push('<dataProvider>');
        layoutStr.push('    <SpanSummaryCollection source="{$gridData}">');
        layoutStr.push('        <mergingFields>');
        layoutStr.push('            <SpanMergingField name="MFC_BIZRNM" colNum="0"/>');
        layoutStr.push('            <SpanMergingField name="ALKND_NM" colNum="1"/>');
        layoutStr.push('            <SpanMergingField name="CTNR_NM" colNum="2"/>');
        layoutStr.push('        </mergingFields>');
        layoutStr.push('    </SpanSummaryCollection>');
        layoutStr.push('</dataProvider>');      
        layoutStr.push('    </DataGrid>');
        layoutStr.push('</rMateGrid>');
        
        gridApp.setLayout(layoutStr.join("").toString());
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
			
			if(selGbn == '1' || selGbn == '4'  || selGbn == '5'){
				gridRoot.getObjectById("stdYear3").setHeaderText(Number($('#STD_YEAR_SEL').val())-2);
				gridRoot.getObjectById("stdYear2").setHeaderText(Number($('#STD_YEAR_SEL').val())-1);
				gridRoot.getObjectById("stdYear1").setHeaderText($('#STD_YEAR_SEL').val());
			}else if(selGbn == '2'){
				gridRoot.getObjectById("stdYear5").setHeaderText(Number($('#STD_YEAR_SEL').val())-4);
				gridRoot.getObjectById("stdYear4").setHeaderText(Number($('#STD_YEAR_SEL').val())-3);
				gridRoot.getObjectById("stdYear3").setHeaderText(Number($('#STD_YEAR_SEL').val())-2);
				gridRoot.getObjectById("stdYear2").setHeaderText(Number($('#STD_YEAR_SEL').val())-1);
				gridRoot.getObjectById("stdYear1").setHeaderText($('#STD_YEAR_SEL').val());
			}
			
		}
		
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	}	
	
	/****************************************** 그리드 셋팅 끝***************************************** */

</script>

<style type="text/css">
	.srcharea .row .col .tit{width: 65px;}
</style>

</head>
<body>

	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
	<input type="hidden" id="mfc_bizrnm_sel_list" value="<c:out value='${mfc_bizrnm_sel}' />" />

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
						<div class="tit" id="se"></div>
						<div class="box">		
							<select id="SEL_GBN" name="SEL_GBN" style="width: 179px;">
								<option value="1">생산자별</option>
								<option value="6">월별</option>
								<option value="3">주종별</option>
								<option value="4">지역별-생산자</option>
								<option value="5">지역별-도매업자</option>
							</select>
						</div>
					</div>
					<div class="col">
						<div style="float: left; position: relative; margin: 0 20px 0 0; padding: 0 0 0 10px; font-weight: 700; font-size: 14px; line-height: 36px; color: #222222;">
							<input type="radio" id="STD_RADIO1" name="STD_RADIO" value="YEAR" style="margin:10px; width: 19px; height: 19px;  background: url(../../images/util/rdo.png) 0 0 no-repeat;" checked />
							<span id="std_year"></span>
						</div>					
						<!-- >div class="tit" id="std_year"></div -->
						<div class="box">		
							<select id="STD_YEAR_SEL" name="STD_YEAR_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="col"  >
						<div style="float: left; position: relative; margin: 0 20px 0 0; padding: 0 0 0 10px; font-weight: 700; font-size: 14px; line-height: 36px; color: #222222;">
							<input type="radio" id="STD_RADIO2" name="STD_RADIO" value="DAY" style="margin:10px; width: 19px; height: 19px;  background: url(../../images/util/rdo.png) 0 0 no-repeat;" />
							<span id="sel_term"></span>
						</div>					
						<!-- div class="tit" id="sel_term"></div-->
						<div class="box">
							<div class="calendar">
								<input type="text" id="START_DT" name="from" style="width: 139px;" class="i_notnull" disabled><!--시작날짜  -->
							</div>
							<div class="obj">~</div>
							<div class="calendar">
								<input type="text" id="END_DT" name="to" style="width: 139px;"	class="i_notnull" disabled><!-- 끝날짜 -->
							</div>
						</div>
					</div>					
					<div class="col" id="mfcDiv" style="display:none">
						<div class="tit" id="mfc_bizrnm"></div>
						<div class="box">		
							<select id="MFC_BIZRNM" name="MFC_BIZRNM" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="btn" id="CR"></div>
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