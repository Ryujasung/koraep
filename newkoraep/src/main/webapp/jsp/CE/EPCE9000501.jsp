<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>회수기관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>


<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />


<script type="text/javaScript" language="javascript" defer="defer">
// 	var initList = {initList};
	
	//페이지이동 조회조건 데이터 셋팅
	var INQ_PARAMS;
	var urm_list
	var urm_list2;//도매업자 업체명 조회

	/* 페이징 사용 등록 */
	gridRowsPerPage = 100;	// 1페이지에서 보여줄 행 수
	gridCurrentPage = 1;	// 현재 페이지
	gridTotalRowCount = 0; //전체 행 수
	
	$(document).ready(function(){
		
		INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
		urm_list2 		= jsonObject($("#urm_list2").val());		//도매업자 업체명 조회
		urm_list 		= jsonObject($("#urm_list").val());		//도매업자 업체명 조회
// 		var serialList 		= jsonObject($("#serialList").val());
		
		fn_btnSetting();
		
		$('#bizr_nm').text('소매점명');
		$('#urm_ce_no').text('센터고유번호');
		$('#serial_no').text('시리얼번호');
		$('#area_se').text('지역');
		$('#sel_term').text('회수일자');
		
		
		fn_set_grid();
		var AreaCdList = jsonObject($('#AreaCdList').val());
		kora.common.setEtcCmBx2(AreaCdList, "", "", $("#AreaCdList_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
		kora.common.setEtcCmBx2(urm_list, "","", $("#BIZRNM_SEL"), "URM_CODE_NO", "URM_NM", "N" ,'S');	
		kora.common.setEtcCmBx2(urm_list2, "","", $("#URM_CE_NO"), "SERIAL_NO", "URM_CE_NO", "N" ,'T');		//도매업자 업체명
// 		kora.common.setEtcCmBx2(serialList, "","", $("#BIZRNO_SEL"), "URM_CE_NO", "SERIAL_NO", "N" ,'S');		//지점
		$("#START_DT").val(kora.common.getDate("yyyy-mm-dd", "D", -7, false));//일주일전 날짜 
		$("#END_DT").val(kora.common.getDate("yyyy-mm-dd", "D", 0, false));//현재 날짜
		$("#BIZRNM_SEL").select2();	 
		$("#URM_CE_NO").select2();	
		if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
			kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
			gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
		}
		
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
		//div필수값 alt
		 $("#START_DT").attr('alt',parent.fn_text('sel_term'));
		 $("#END_DT").attr('alt',parent.fn_text('sel_term'));
		 
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
				start_dt = start_dt.replace(/-/gi, "");
				if(start_dt.length == 8) start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
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
				var end_dt = $("#END_DT").val();
				end_dt = end_dt.replace(/-/gi, "");
				if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd")
				$("#END_DT").val(end_dt) 
			});
		 
		 
		 
		/**
		*조회
		*/
		$("#btn_sel").click(function(){
			gridCurrentPage = 1;
			fn_sel();
		});
		
		/**
		*등록
		*/
		$("#btn_reg").click(function(){
			fn_reg();
		});
		/**
		*소모품등록
		*/
		$("#btn_add").click(function(){
			fn_add();
		});
		
		/**
		 * 활동/비활동처리버튼 클릭 이벤트
		 */
		$("#btn_useYn1").click(function(){
			fn_upd();
		});
		$("#btn_useYn2").click(function(){
			fn_upd2();
		});
		
		/* 종료 및 이동 버튼  */
		$("#btn_move").click(function(){
			fn_move();
		});
		
		
		$("#btn_pop").click(function(){
			fn_pop();
		});
		
		$("#btn_pop3").click(function(){
			fn_pop3();
		});
		
		/************************************
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ***********************************/
		 $("#btn_excel").click(function() {
			 fn_excel();
		 });
		
		/************************************
		 * 단체설정 클릭 이벤트
		 ***********************************/
		
		
	});
	
	
	//단체설정
	function fn_move(){
		var selectorColumn = gridRoot.getObjectById("selector");
		var input = {"list": ""};
		var row = new Array();
		var urm_cnt=0;
		
		if(selectorColumn.getSelectedIndices() == "") {
			alertMsg("선택한 건이 없습니다.");
			return false;
		}
		console.log(gridRoot.getItemAt(selectorColumn.getSelectedIndices()));
		console.log(selectorColumn.getSelectedIndices());
 		if( gridRoot.getItemAt(selectorColumn.getSelectedIndices()).USE_YN != 'Y' ){ 
 			alertMsg("폐기되었거나, 이동된 무인회수기입니다 \n다시 한 번 확인하시기 바랍니다.");
			return;
 		}
		console.log(selectorColumn.getSelectedIndices().length);
		for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
			var item = {};
			item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			row.push(item);
			urm_cnt++;
		}
		
	    input["list"] = row;
	    input["urm_cnt"] = urm_cnt;
	    input["INQ_PARAMS"] = INQ_PARAMS.SEL_PARAMS;
	    parent_item= input;
		var pagedata = window.frameElement.name;
		var url = "/CE/EPCE9000588.do";//소매점이동
		window.parent.NrvPub.AjaxPopup(url, pagedata);
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
					
		var now = new Date();// 현재시간 가져오기
		var hour = new String(now.getHours());// 시간 가져오기
		var min = new String(now.getMinutes());// 분 가져오기
		var sec = new String(now.getSeconds());// 초 가져오기
		var today = kora.common.gfn_toDay();
		var fileName = $('#title').text() +"_" + today+hour+min+sec+".xlsx";
		
		//그리드 컬럼목록 저장
		var col = new Array();
		var columns = dataGrid.getColumns();
		for(i=0; i<columns.length; i++){
			if(columns[i].getDataField() != undefined && columns[i].getDataField() != 'index'){ //순번 제외
				var item = {};
				item['headerText'] = columns[i].getHeaderText();
				
				if(columns[i].getDataField() == 'URM_NM'){// html 태크 사용중 컬럼은 대체
					item['dataField'] = 'URM_NM_ORI';
				}else{
					item['dataField'] = columns[i].getDataField();
				}
				
				item['textAlign'] = columns[i].getStyle('textAlign');
				item['id'] = kora.common.null2void(columns[i].id);
				
				col.push(item);
			}
		}
		
		var input = INQ_PARAMS["SEL_PARAMS"];
		input['fileName'] = fileName;
		input['columns'] = JSON.stringify(col);
		
		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
		
		var url = "/CE/EPCE9000501_05.do";
		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
				alertMsg(rtnData.RSLT_MSG);
			}else{
				//파일다운로드
				frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
				frm.fileName.value = fileName;
				frm.submit();
			}
			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
		});
	}
	
	/**
	 * 목록조회
	 */
	function fn_sel(){
		var input = {};
		var url = "/CE/EPCE900050119.do"; 
// 		var start_dt = $("#START_DT").val();
// 	 	var end_dt = $("#END_DT").val();
// 		start_dt = start_dt.replace(/-/gi, "");
// 	 	end_dt = end_dt.replace(/-/gi, "");
	
// 		if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
// 			alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
// 			return; 
// 		}else if(start_dt>end_dt){
// 			alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
// 			return;
// 		} 
// 		input["START_DT"] = $("#START_DT").val();
// 		input["END_DT"] = $("#END_DT").val();
		input["BIZRNM_SEL"] = $("#BIZRNM_SEL option:selected").val();
		input["URM_CE_NO"] = $("#URM_CE_NO option:selected").text();
		input["AreaCdList_SEL"] = $("#AreaCdList_SEL option:selected").val();
		input["SERIAL_NO"] = $("#SERIAL_NO").val();
		input["USE_YN"] = $("#USE_YN").val();

		input["ROWS_PER_PAGE"] = gridRowsPerPage;
		input["CURRENT_PAGE"] = gridCurrentPage;
		
		INQ_PARAMS["SEL_PARAMS"] = input;
		
		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != ""){
				gridApp.setData(rtnData.searchList);

				/* 페이징 표시 */
				gridTotalRowCount = rtnData.totalCnt; //총 카운트
				drawGridPagingNavigation(gridCurrentPage);
			} else {
				alertMsg("error");
			}
			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
		});
		
	}
	
	/* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel(); //조회 펑션
	}
	
	 /**
	  * 상세조회 화면전환
	  */
	 function fn_page(){
		var input = {};
		input = gridRoot.getItemAt(rowIndex);
		
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE9000501.do";
		kora.common.goPage('/CE/EPCE9000516.do', INQ_PARAMS);
		 
	 }
	 
	/**
	 * 등록화면 이동
	 */
	function fn_reg(){
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE9000501.do";
		kora.common.goPage('/CE/EPCE9000531.do', INQ_PARAMS);
	}
	
	/**
	 * 소모품등록화면 이동
	 */
	function fn_add(){
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE9000501.do";
		kora.common.goPage('/CE/EPCE9000532.do', INQ_PARAMS);
	}

	//비활동처리
	function fn_upd(){
		
		var chkLst = selectorColumn.getSelectedItems();
		
		if(chkLst.length < 1){
			alertMsg('선택된 행이 없습니다');
			return;
		}
		
		var msgList = new Array();
		
		for(var i=0; i<chkLst.length; i++){

			//상태값 비활동인 경우
			if(chkLst[i].USE_YN != "Y"){
				alertMsg("사용중인 회수기에서만 폐기처리가 가능합니다. \n다시 한 번 확인하시기 바랍니다.");
				return;
			}

			
		}
		
		var msg = "";
		if(msgList.length > 0){
			msg += "선택하신 회수기 (";
			for(var i=0; i<msgList.length; i++){
				if(i>0) msg += ', ';
				msg += msgList[i];
			}
			msg += ")가 폐기 처리됩니다.";
			msg += "\r계속 진행하시겠습니까?";
		}else{
			msg = "폐기 처리 시 해당 무인회수기의 사용이 불가능합니다.\n계속 진행하시겠습니까?";
		}

		confirm(msg, "fn_upd_exec");
		gGubn = "C";
	}

	function fn_upd_exec(){
		
		var data = {};
		var row = new Array();
		
		for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
			var item = {};
			item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			row.push(item);
		}
		
		data["list"] = JSON.stringify(row);
		data["gGubn"] = gGubn;

		var url = "/CE/EPCE900050142.do";
		ajaxPost(url, data, function(rtnData){
			if ("" != rtnData && null != rtnData) {
				alertMsg(rtnData.RSLT_MSG, 'fn_sel');
			} else {
				alertMsg("error");
			}
		});
	}
	/**
	 * 그리드 관련 변수 선언
	 */
	 var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
	 var gridApp, gridRoot, dataGrid, layoutStr, selectorColumn;
	 var layoutStr = new Array();
	 var rowIndex;
	 
	/**
	 * 메뉴관리 그리드 셋팅
	 */
	 function fn_set_grid() {
		 
		 rMateGridH5.create("grid", "gridHolder", jsVars, "100%", "100%");
		 
// 		 layoutStr = new Array();
		 
		 layoutStr.push('<rMateGrid>');
			layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr.push('	<NumberFormatter id="numfmt1" precision="2" useThousandsSeparator="true"/>');
			layoutStr.push('    <NumberMaskFormatter id="maskfmt1" formatString="###-##-#####"/>');
			layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
		 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" verticalGridLines="true" headerHeight="35" headerWordWrap="true" horizontalGridLines="true" horizontalScrollPolicy="auto" ');
		 layoutStr.push('	textAlign="center" ');
		 layoutStr.push(' 	draggableColumns="true" sortableColumns="true"  doubleClickEnabled="false" liveScrolling="false" showScrollTips="true">');
		 layoutStr.push('<columns>');
		 layoutStr.push('	<DataGridSelectorColumn id="selector" textAlign="center" allowMultipleSelection="false" width="35" height="5%" verticalAlign="middle" />');
// 		 layoutStr.push('			<DataGridColumn dataField="PAGENO" 				 				headerText="'+ parent.fn_text('sn')+ '"					width="50" 	textAlign="center"  	 draggable="false"/>');				//순번
		 layoutStr.push('	<DataGridColumn dataField="URM_NO" headerText="번호" textAlign="center" visible="false"  width="50"   draggable="false"/>');
		 layoutStr.push('	<DataGridColumn dataField="URM_NM"  headerText="소매점명" width="200" itemRenderer="HtmlItem"/>');
		 layoutStr.push('	<DataGridColumn dataField="URM_CE_NO"  headerText="센터고유번호" width="120" />');
		 layoutStr.push('	<DataGridColumn dataField="SERIAL_NO"  headerText="시리얼번호" width="200" />');
		 layoutStr.push('	<DataGridColumn dataField="AREA_NM"  headerText="지역" width="130" />');
		 layoutStr.push('	<DataGridColumn dataField="START_DT"  headerText="설치일자" width="100"/>');
// 		 layoutStr.push('	<DataGridColumn dataField="END_DT"  headerText="폐기일자" width="100"/>');
// 		 layoutStr.push('	<DataGridColumn dataField="PNO"  headerText="우편번호" width="80"/>');
		 
// 		  layoutStr.push('	<DataGridColumn dataField="USE_YN"  headerText="사용여부" width="100" visible="false" />');
		  layoutStr.push('	<DataGridColumn dataField="USE_NM"  headerText="사용여부" width="80"/>');
		  layoutStr.push('	<DataGridColumn dataField="ADDR"  headerText="주소" width="450"/>');
		 //layoutStr.push('	<DataGridColumn dataField="TOTAL_TOT"  headerText="총량" formatter="{numfmt}" width="100"/>');
// 		   layoutStr.push('	<DataGridColumn dataField="USE_TOT"  headerText="사용량" formatter="{numfmt}" width="100"/>');
// 		   layoutStr.push('	<DataGridColumn dataField="USE_RTRVL_TOT"  headerText="회수량" formatter="{numfmt}" width="100"/>');
		 //layoutStr.push('	<DataGridColumn dataField="RMG_TOT"  headerText="잔여량" formatter="{numfmt}"  width="100"/>');
         layoutStr.push('</columns>');
		 layoutStr.push('</DataGrid>');
		 layoutStr.push('</rMateGrid>');
	}

	// 그리드 및 메뉴 리스트 세팅
	 function gridReadyHandler(id) {
	 	 gridApp = document.getElementById(id);  // 그리드를 포함하는 div 객체
	     gridRoot = gridApp.getRoot();   // 데이터와 그리드를 포함하는 객체

	     gridApp.setLayout(layoutStr.join("").toString());
	     gridApp.setData();
	     
	     var layoutCompleteHandler = function(event) {
	         dataGrid = gridRoot.getDataGrid();  // 그리드 객체
	         selectorColumn = gridRoot.getObjectById("selector");
	         dataGrid.addEventListener("change", selectionChangeHandler); //이벤트 등록
	         drawGridPagingNavigation(gridCurrentPage);  //페이징 표시
	         
	       	 //파라미터 call back function 실행
			 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
			 	eval(INQ_PARAMS.FN_CALLBACK+"()");
			 }else{
				 gridApp.setData();
			 }
	     }
	     var selectionChangeHandler = function(event) {
			rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			selectorColumn = gridRoot.getObjectById("selector");
			
			selectorColumn.setSelectedIndex(-1);
			selectorColumn.setSelectedIndex(rowIndex);
		 }
	     var dataCompleteHandler = function(event) {
	     	dataGrid = gridRoot.getDataGrid();
	 	 }
	     
	     gridRoot.addEventListener("dataComplete", dataCompleteHandler);
	     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	 }
	
	
	 
	 //휴폐업 조회
	 function fn_check(){
			
		var data = {};
		var row = new Array();
		
		var chkLst = selectorColumn.getSelectedItems();
		
		if(chkLst.length < 1){
			alertMsg("선택된 행이 없습니다.");
			return;
		}
		
		for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
			var item = {};
			item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			row.push(item);
		}
		
		data["list"] = JSON.stringify(row);

		var url = "/CE/EPCE9000501422.do";
		document.body.style.cursor = "wait";
		ajaxPost(url, data, function(rtnData){
			if ("" != rtnData && null != rtnData) {
				alertMsg(rtnData.RSLT_MSG, 'fn_sel');
			} else {
				alertMsg("error");
			}
			document.body.style.cursor = "default";
		});
	} 
	 
	//활동복원
	function fn_upd2(){
		
		var chkLst = selectorColumn.getSelectedItems();
		
		if(chkLst.length < 1){
			alertMsg("선택된 행이 없습니다.");
			return;
		}
		
		var msgList = new Array();
		
		for(var i=0; i<chkLst.length; i++){
			
			//상태값 활동인 경우
			if(chkLst[i].USE_YN == "Y"){
				alertMsg("이미 활동 상태인 회수기를 선택되었습니다.\n다시 한 번 확인하시기 바랍니다.");
				return;
			}

			
		}
		
		var msg = "";
		if(msgList.length > 0){
			msg += "선택하신 회수기(";
			for(var i=0; i<msgList.length; i++){
				if(i>0) msg += ', ';
				msg += msgList[i];
			}
			msg += ")를 활동 처리 시\n해당 회수기가 활성화됩니다.\n계속 진행하시겠습니까?";
		}else{
			msg = "활성화 처리 시 해당 사용자의 시스템 사용이 가능해집니다.\n계속 진행하시겠습니까?";
		}

		confirm(msg, "fn_upd_exec");
		gGubn = "A";
	}

	


	 var parent_item;
	//사업자변경이력 팝업
	function fn_pop(){
		
		var idx = dataGrid.getSelectedIndex();
		
		if(idx < 0){
			alertMsg('선택된 행이 없습니다');
			return;
		}
		
		parent_item = gridRoot.getItemAt(idx);
		var pagedata = window.frameElement.name;

		window.parent.NrvPub.AjaxPopup('/CE/EPCE9000501_1.do', pagedata);
	}
	
	//사업자변경이력 팝업
	function fn_pop3(){
		
		var idx = dataGrid.getSelectedIndex();
		if(idx < 0){
			alertMsg('선택된 행이 없습니다');
			return;
		}
		parent_item = gridRoot.getItemAt(idx);
		var pagedata = window.frameElement.name;

		window.parent.NrvPub.AjaxPopup('/CE/EPCE9000501_3.do', pagedata);
	}
	
	//관리자아이디 등록팝업
	function fn_pop2(){
		var selector = gridRoot.getObjectById("selector");
		var chkLst = selector.getSelectedItems();
		var idx = dataGrid.getSelectedIndex();

		if(idx < 0){
			alertMsg('선택된 행이 없습니다');
			return;
		}
		if(chkLst.length > 1){
			alertMsg("한건만 선택이 가능합니다.");
			return;
		}
		
		parent_item = gridRoot.getItemAt(idx);		
		
		if(parent_item.ADMIN_STAT_CD == 'Y'){
			alertMsg("해당 사업자의 관리자 아이디가 활동 상태입니다. \n회원탈퇴 후 등록이 가능합니다.");
			return;
		}
		
		var pagedata = window.frameElement.name;
		window.parent.NrvPub.AjaxPopup('/CE/EPCE90005018_1.do', pagedata);
	}

</script>
<style type="text/css">

/* .row .tit{width: 84px;} */

 #s2id_BIZRNM_SEL{
    width: 100%
}

</style>
</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="AreaCdList" value="<c:out value='${AreaCdList}' />"/>
<input type="hidden" id="urm_list2" value="<c:out value='${urm_list2}' />" />
<input type="hidden" id="urm_list" value="<c:out value='${urm_list}' />" />

	<div class="iframe_inner" >
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn" style="float:right" id="UR"></div>
		</div>
<!-- 셀렉트박스 부분 -->
		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<!-- 조회부분 -->
				<div class="row">
					<!-- <div class="col" style="width:430px;">
						<div class="tit" id="sel_term" style="width:85px"></div>	
						<div class="box" style="width:300px;padding:0px">
							<div class="calendar">
								<input type="text" id="START_DT" name="from" style="width: 130px;" class="i_notnull">시작날짜 
							</div>
							<div class="obj">~</div>
							<div class="calendar">
								<input type="text" id="END_DT" name="to" style="width: 130px;"	class="i_notnull">끝날짜
							</div>
						</div>
						</div> -->
						<div class="col">
							<div class="tit" id="bizr_nm" style="width: 85px"></div>
							<div class="box" style="width:250px;padding:0px">
								<select id="BIZRNM_SEL" name="BIZRNM_SEL" style="width: 250px"></select>
								<!-- <input type="text" id="BIZRNM_SEL" name="BIZRNM_SEL" style="width: 179px;" maxByteLength="60"> -->
							</div>
						</div>
						<div class="col">
							<div class="tit" id="urm_ce_no" style="width: 85px"></div>
							<div class="box">
								<!-- <input type="text" id="BIZRNO_SEL" name="BIZRNO_SEL" style="width: 179px;" maxByteLength="60"> -->
								<select id="URM_CE_NO" name="URM_CE_NO" style="width: 250px"></select>
							</div>
	
						</div>
					</div>
					<div class="row">
						<div class="col">
							<div class="tit" id="area_se" style="width: 85px"></div>
							<div class="box">
								<select id="AreaCdList_SEL" name="AreaCdList_SEL" style="width: 250px">
								</select>
							</div>
						</div>
						<div class="col">
							<div class="tit" id="serial_no" style="width: 85px;"></div>
							<div class="box">
								<input type="text" lass="i_notnull" id="SERIAL_NO" name="SERIAL_NO" style="width: 250px" >
							</div>
						</div>
						<div class="col">
							<div class="tit" id="use_yn" style="width: 85px;">사용여부</div>
							<div class="box">
								<select id="USE_YN" name="USE_YN" style="width: 250px">
									<option value="">선택</option>
									<option value="Y">사용중</option>
									<option value="M">이동</option>
									<option value="N">폐기</option>
								</select>
							</div>
						</div>
						<div class="btn" id="CR"></div>
					</div>
				</div>
				<!-- end of srcharea -->
		</section>

		<!-- 그리드 시작 -->
		<section class="secwrap mt10">

			<div class="boxarea">
				<div id="gridHolder" style="height: 570px; background: #FFF;"></div>
			</div>	<!-- 그리드 셋팅 -->
			<div class="gridPaging"  id="gridPageNavigationDiv"></div>
			
		</section>	<!-- end of secwrap mt30  -->
		<section class="btnwrap"  style="padding-top:10px;">
			<div class="btnwrap">
				<div class="fl_l" id="BL">
				</div>
				<div class="fl_r" id="BR">
				</div>
			</div>
		</section>
</div>

	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="excel" />
	</form>

</body>
</html>