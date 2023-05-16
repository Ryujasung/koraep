<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>반환수집소정보관리</title>
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
	var rcs_list;//도매업자 업체명 조회
	
	/* 페이징 사용 등록 */
	gridRowsPerPage = 1000;	// 1페이지에서 보여줄 행 수
	gridCurrentPage = 1;	// 현재 페이지
	gridTotalRowCount = 0; //전체 행 수
	
	$(document).ready(function(){
		
		INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
		rcs_list 		= jsonObject($("#rcs_list").val());		//도매업자 업체명 조회
		fn_btnSetting();
		
		$('#bizr_nm').text('반환수집소명');
// 		$('#bizrno').text('반환수집소번호');
		$('#bizr_tp').text('반환수집소상태');
		$('#area_se').text('무인회수기여부');
		$('#bizr_stat_cd').text('관리업체');
		/* $('#alt_req_stat').text(parent.fn_text('alt_req_stat'));
		$('#aff_ogn').text(parent.fn_text('aff_ogn'));
		$('#pay_yn').text(parent.fn_text('pay_yn'));
		$('#erp_cd_nm').text(parent.fn_text('erp_cd_nm')); */
		
		fn_set_grid();
		var BizrTpCdList = jsonObject($('#BizrTpCdList').val());
		var AreaCdList = jsonObject($('#AreaCdList').val());
		var AtlReqStatCdList = jsonObject($('#AtlReqStatCdList').val());
		var BizrStatCdList = jsonObject($('#BizrStatCdList').val());
		var AffOgnCdList = jsonObject($('#AffOgnCdList').val());
		var ErpCdList = jsonObject($('#ErpCdList').val());
		
		kora.common.setEtcCmBx2(BizrTpCdList, "", "", $("#BizrTpCdList_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
		kora.common.setEtcCmBx2(AreaCdList, "", "", $("#AreaCdList_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
		kora.common.setEtcCmBx2(BizrStatCdList, "", "", $("#BizrStatCdList_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
		kora.common.setEtcCmBx2(AtlReqStatCdList, "", "", $("#AtlReqStatCdList_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
		kora.common.setEtcCmBx2(AffOgnCdList, "", "", $("#AffOgnCdList_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
		kora.common.setEtcCmBx2(ErpCdList, "", "", $("#ErpCdList_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
		kora.common.setEtcCmBx2(rcs_list, "","", $("#RCS_NM"), "RCS_NO", "RCS_NM", "N" ,'T');		//도매업자 업체명

		if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
			kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
			gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
		}
		
		$("#RCS_NM").change(function(){
			//옆 인풋박스에 소모품번호 넣기
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
		 * 활동/비활동처리버튼 클릭 이벤트
		 */
		$("#btn_useYn1").click(function(){
			fn_upd();
		});
		$("#btn_useYn2").click(function(){
			fn_upd2();
		});
		
		//휴폐업조회
		$("#btn_check").click(function(){
			fn_check();
		});
		
		/**
		 * 사업자 변경내역 버튼 클릭 이벤트
		 */
		$("#btnPopChng").click(function(){
			fn_pop();
		});
		
		
		/**
		 * 관리자 아이디 등록 버튼 클릭 이벤트
		 */
		$("#btnPopAdmin").click(function(){
			fn_pop2();
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
		$("#btn_upd5").click(function(){
			fn_upd5();
		});
		
		$("#RCS_NM").select2();	 
		
	});
	
	
	
	//단체설정
	function fn_upd5(){
		var selectorColumn = gridRoot.getObjectById("selector");
		var input = {"list": ""};
		var row = new Array();
		var aff_ogn_cnt=0;
		
		if(selectorColumn.getSelectedIndices() == "") {
			alertMsg("선택한 건이 없습니다.");
			return false;
		}
		
		if( gridRoot.getItemAt(0).BIZR_TP_CD != 'W1' ){ alertMsg("소속단체설정은 관리업체만 가능합니다."); return; }
		
		for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
			var item = {};
			item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			row.push(item);
			aff_ogn_cnt++;
		}
		
	    input["list"] = row;
	    input["aff_ogn_cnt"] = aff_ogn_cnt;
	    input["INQ_PARAMS"] = INQ_PARAMS.SEL_PARAMS;
	    parent_item= input;
		var pagedata = window.frameElement.name;
		var url = "/CE/EPCE0160188.do";//단체설정
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
				
				if(columns[i].getDataField() == 'RCS_NO'){// html 태크 사용중 컬럼은 대체
					item['dataField'] = 'NO';
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
		
		var url = "/CE/EPCE9000201_05.do";
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
		var url = "/CE/EPCE900020119.do"; 
		
		input["RCS_NM"] = $("#RCS_NM").val();
		input["WHSDL_BIZRNM"] = $("#WHSDL_BIZRNM").val();
		
		input["URM_YN"] = $("#URM_YN option:selected").val();
		input["RCS_BIZR_CD"] = $("#RCS_BIZR_CD option:selected").val();
		input["AREA_CD"] = $("#AreaCdList_SEL option:selected").val();
		

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
	 * 등록화면 이동
	 */
	function fn_reg(){
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE9000201.do";
		kora.common.goPage('/CE/EPCE9000231.do', INQ_PARAMS);
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
		 
		 layoutStr.push('<rMateGrid>');
		 layoutStr.push('	<NumberMaskFormatter id="maskfmt" formatString="###-##-#####"/>');
		 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" verticalGridLines="true" headerHeight="35" headerWordWrap="true" horizontalGridLines="true" horizontalScrollPolicy="auto" ');
		 layoutStr.push('	textAlign="center" ');
		 layoutStr.push(' 	draggableColumns="true" sortableColumns="true"  doubleClickEnabled="false" liveScrolling="false" showScrollTips="true">');
		 layoutStr.push('<columns>');
		 layoutStr.push('	<DataGridSelectorColumn id="selector" textAlign="center" allowMultipleSelection="true" width="35" height="5%" verticalAlign="middle" />');
		 layoutStr.push('	<DataGridColumn dataField="RCS_NO" headerText="번호"  visible="false"	 textAlign="center" width="50"   draggable="false"/>');
		 //layoutStr.push('	<DataGridColumn dataField="RCS_NO"  visible="false"	 headerText="번호" textAlign="center" width="50"   draggable="false"/>');
		 layoutStr.push('	<DataGridColumn dataField="RCS_NM"  headerText="반환수집소명" width="150" itemRenderer="HtmlItem"/>');
		 layoutStr.push('	<DataGridColumn dataField="RCS_BIZR_CD"  headerText="반환수집소상태" width="100" />');
		 layoutStr.push('	<DataGridColumn dataField="URM_YN"  headerText="무인회수기여부" width="100" />');
// 		 layoutStr.push('	<DataGridColumn dataField="AFF_OGN_NM"  headerText="무인회수기번호" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="WHSDL_BIZRNM"  headerText="관리업체명" width="150"/>');
		 layoutStr.push('	<DataGridColumn dataField="WHSDL_BIZRNO"  headerText="관리업체 사업자번호"  formatter="{maskfmt}" width="150"/>');
		 layoutStr.push('	<DataGridColumn dataField="PNO"  headerText="우편번호" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="ADDR"  headerText="주소" width="500"/>');
		 layoutStr.push('	<DataGridColumn dataField="START_DT"  headerText="계약(운영) 시작일" width="150"/>');
		 layoutStr.push('	<DataGridColumn dataField="END_DT"  headerText="계약(운영) 종료일" width="150"/>');
		 layoutStr.push('	<DataGridColumn dataField="AREA_NM"  headerText="지역" width="150"/>');
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
		 }
	     var dataCompleteHandler = function(event) {
	     	dataGrid = gridRoot.getDataGrid();
	 	 }
	     
	     gridRoot.addEventListener("dataComplete", dataCompleteHandler);
	     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	 }
	
	 /**
	  * 상세조회 화면전환
	  */
	 function fn_page(){
		var input = {};
		input = gridRoot.getItemAt(rowIndex);
		
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE9000201.do";
		kora.common.goPage('/CE/EPCE9000216.do', INQ_PARAMS);
		 
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

		var url = "/CE/EPCE9000201422.do";
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
			if(chkLst[i].BIZR_STAT_CD == "Y"){
				alertMsg("이미 활동 상태인 회원이 선택되었습니다.\n다시 한 번 확인하시기 바랍니다.");
				return;
			}

			//관리자 여부 체크(센터 관리자그룹은 사업자 관리자 활동 처리 가능)
			if(chkLst[i].BIZR_SE_CD == "D"){
				//if(ssGrpCd == "A01"){
					//confirm("사업자 관리자("+chkLst[i].USER_NM+")를 활동 처리 시\n해당 사업장이 활성화됩니다.\n계속 진행하시겠습니까?", "");
					msgList.push(chkLst[i].BIZRNM);
				/*	
				}
				else{
					alertMsg("관리자는 활동 처리할 수 없습니다.");
					return;
				}
				*/
			}
		}
		
		var msg = "";
		if(msgList.length > 0){
			msg += "사업자 관리자(";
			for(var i=0; i<msgList.length; i++){
				if(i>0) msg += ', ';
				msg += msgList[i];
			}
			msg += ")를 활동 처리 시\n해당 사업장이 활성화됩니다.\n계속 진행하시겠습니까?";
		}else{
			msg = "회원복원 처리 시 해당 사용자의 시스템 사용이 가능해집니다.\n계속 진행하시겠습니까?";
		}

		confirm(msg, "fn_upd_exec");
		gGubn = "A";
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

		var url = "/CE/EPCE900020142.do";
		ajaxPost(url, data, function(rtnData){
			if ("" != rtnData && null != rtnData) {
				alertMsg(rtnData.RSLT_MSG, 'fn_sel');
			} else {
				alertMsg("error");
			}
		});
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
			if(chkLst[i].BIZR_STAT_CD == "N"){
				alertMsg("비활동 상태인 회원이 선택되었습니다.\n다시 한 번 확인하시기 바랍니다.");
				return;
			}

			//관리자 여부 체크(센터 관리자그룹은 사업자 관리자 비활동 처리 가능)
			if(chkLst[i].BIZR_SE_CD == "D"){
				//if(ssGrpCd == "A01" || ssGrpCd == "A11" || ssGrpCd == "A12"){
					
					msgList.push(chkLst[i].BIZRNM);
				/*	
					cnfmMsg = "선택하신 사업자의 관리자("+chkLst[i].USER_NM+")가 비활동 처리됩니다.";
					cnfmMsg = cnfmMsg + "\r관리자 변경을 원하실 경우에는 '정보관리 > 회원관리'에서 '관리자변경'을 진행하시기 바랍니다.";
					cnfmMsg = cnfmMsg + "\r사업자 비활동 처리를 원하실 경우에는 '정보관리 > 사업자관리'에서 해당 사업자의 '비활동처리'를 진행하시기 바랍니다.";
					cnfmMsg = cnfmMsg + "\r비활동 처리 시 해당 사용자의 시스템 사용이 불가능합니다.\n계속 진행하시겠습니까?";
					confirm(cnfmMsg, "");
				}else{
					alertMsg("관리자는 비활동 처리할 수 없습니다.");
					return;
				}
				*/
			}
		}
		
		var msg = "";
		if(msgList.length > 0){
			msg += "선택하신 사업자의 관리자(";
			for(var i=0; i<msgList.length; i++){
				if(i>0) msg += ', ';
				msg += msgList[i];
			}
			msg += ")가 비활동 처리됩니다.";
			msg += "\r관리자 변경을 원하실 경우에는 '정보관리 > 회원관리'에서 '관리자변경'을 진행하시기 바랍니다.";
			msg += "\r사업자 비활동 처리를 원하실 경우에는 '정보관리 > 사업자관리'에서 해당 사업자의 '비활동처리'를 진행하시기 바랍니다.";
			msg += "\r계속 진행하시겠습니까?";
		}else{
			msg = "비활동 처리 시 해당 사용자의 시스템 사용이 불가능합니다.\n계속 진행하시겠습니까?";
		}

		confirm(msg, "fn_upd_exec");
		gGubn = "C";
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
		window.parent.NrvPub.AjaxPopup('/CE/EPCE9000201_1.do', pagedata);
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
		window.parent.NrvPub.AjaxPopup('/CE/EPCE90002018_1.do', pagedata);
	}

</script>
<style type="text/css">

.row .tit{width: 84px;}

</style>
<style type="text/css">

.row .tit{width: 84px;}

.form-control {
height: 50px;
font-size: 16px
}
#s2id_RCS_NM{
    width: 100%
}

.fa-close:before, .fa-times:before {
    content: "X"; 
    font-weight: 550;
 }
</style>
</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="BizrTpCdList" value="<c:out value='${BizrTpCdList}' />"/>
<input type="hidden" id="AreaCdList" value="<c:out value='${AreaCdList}' />"/>
<input type="hidden" id="AtlReqStatCdList" value="<c:out value='${AtlReqStatCdList}' />"/>
<input type="hidden" id="BizrStatCdList" value="<c:out value='${BizrStatCdList}' />"/>
<input type="hidden" id="AffOgnCdList" value="<c:out value='${AffOgnCdList}' />"/>
<input type="hidden" id="ErpCdList" value="<c:out value='${ErpCdList}' />"/>
<input type="hidden" id="rcs_list" value="<c:out value='${rcs_list}' />" />

	<div class="iframe_inner" >
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn" style="float:right" id="UR"></div>
		</div>
<!-- 셀렉트박스 부분 -->
		<section class="secwrap">
		<form name="frmMenu" id="frmMenu" method="post" >
			<div class="srcharea" id="sel_params"> <!-- 조회부분 -->
				<div class="row">
					<div class="col">
						<div class="tit" id="bizr_nm" style="width: 100px"></div>  
						<div class="box">
							<!-- <input type="text" id="RCS_NM" name="RCS_NM" style="width: 300px;" maxByteLength="60"> -->
							<select id="RCS_NM" name="RCS_NM"   style="width: 300px"></select>
						</div>
					</div>
					
						<div class="col">
						<div class="tit" id="bizr_stat_cd"  style="width: 100px"></div>  
						<div class="box">
								<input type="text"  id="WHSDL_BIZRNM" name="WHSDL_BIZRNM" style="width: 300px;" >
						</div>
					</div>
					<div class="col">
						<div class="tit" id="area_se" style="width: 100px"></div>  
						<div class="box">
							<select id="URM_YN" name="URM_YN" style="width: 300px">
							<option value="">전체 </option>
							<option value="Y">유 </option>
							<option value="N">무</option>
							</select>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col">
						<div class="tit" id="bizr_tp" style="width: 100px"></div>  
						<div class="box">
							<select id="RCS_BIZR_CD" name="RCS_BIZR_CD" style="width: 300px">
								<option value="">전체 </option>
								<option value="Y">운영 </option>
								<option value="N">미운영</option>
							</select>
						</div>
					</div>
					
					<div class="col">
						<div class="tit" id="bizr_stat_cd"  style="width: 100px">지역</div>  
						<div class="box">
							<select id="AreaCdList_SEL" name="AreaCdList_SEL" style="width: 300px">
							</select>
						</div>
					</div>
					<div class="btn" id="CR">
					</div>
				</div>
				 <!-- end of row -->
				
			</div>  <!-- end of srcharea -->
			</form>
		</section>

		<!-- 그리드 시작 -->
		<section class="secwrap mt10">

			<div class="boxarea">
				<div id="gridHolder" style="height: 570px; background: #FFF;"></div>
			</div>	<!-- 그리드 셋팅 -->
			<div class="gridPaging" style="display: none;" id="gridPageNavigationDiv"></div>
			
		</section>	<!-- end of secwrap mt30  -->
		<section class="btnwrap" style="padding-top:10px;">
			<div class="btnwrap">
				<div class="fl_l" id="BL">
				</div>
				<!-- <div class="fl_r" id="BR">
				</div> -->
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