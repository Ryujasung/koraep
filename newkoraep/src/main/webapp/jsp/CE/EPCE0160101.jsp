<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>사업자관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>


<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>


<script type="text/javaScript" language="javascript" defer="defer">
// 	var initList = {initList};
	
	//페이지이동 조회조건 데이터 셋팅
	var INQ_PARAMS;
	
	/* 페이징 사용 등록 */
	gridRowsPerPage = 1000;	// 1페이지에서 보여줄 행 수
	gridCurrentPage = 1;	// 현재 페이지
	gridTotalRowCount = 0; //전체 행 수
	
	$(document).ready(function(){
		
		INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
		
		fn_btnSetting();
		
		$('#bizr_nm').text(parent.fn_text('bizr_nm'));
		$('#bizrno').text(parent.fn_text('bizrno'));
		$('#bizr_tp').text(parent.fn_text('bizr_tp'));
		$('#area_se').text(parent.fn_text('area_se'));
		$('#bizr_stat_cd').text(parent.fn_text('bizr_stat_cd'));
		$('#alt_req_stat').text(parent.fn_text('alt_req_stat'));
		$('#aff_ogn').text(parent.fn_text('aff_ogn'));
		$('#pay_yn').text(parent.fn_text('pay_yn'));
		$('#erp_cd_nm').text(parent.fn_text('erp_cd_nm'));
		
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

		if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
			kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
			gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
		}
		
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
		
		if( gridRoot.getItemAt(0).BIZR_TP_CD != 'W1' ){ alertMsg("소속단체설정은 도매업자만 가능합니다."); return; }
		
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
				
				if(columns[i].getDataField() == 'BIZRNM_PAGE'){// html 태크 사용중 컬럼은 대체
					item['dataField'] = 'BIZRNM';
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
		
		var url = "/CE/EPCE0160101_05.do";
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
		var url = "/CE/EPCE016010119.do"; 
		
		input["BIZRNO_SEL"] = $("#BIZRNO_SEL").val();
		input["BIZRNM_SEL"] = $("#BIZRNM_SEL").val();
		
		input["BizrTpCdList_SEL"] = $("#BizrTpCdList_SEL option:selected").val();
		input["AreaCdList_SEL"] = $("#AreaCdList_SEL option:selected").val();
		input["BizrStatCdList_SEL"] = $("#BizrStatCdList_SEL option:selected").val();
		input["AtlReqStatCdList_SEL"] = $("#AtlReqStatCdList_SEL option:selected").val();
		input["AffOgnCdList_SEL"] = $("#AffOgnCdList_SEL option:selected").val();
		input["PayYn_SEL"] = $("#PayYn_SEL option:selected").val();
		input["ErpCdList_SEL"] = $("#ErpCdList_SEL option:selected").val();
		
// 		if(0 < sData["BIZRNO_SEL"].length && 10 > sData["BIZRNO_SEL"].length){
// 			alertMsg("10자리의 사업자번호를 입력하셔야 합니다.");
// 			return;
// 		}

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
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE0160131.do";
		kora.common.goPage('/CE/EPCE0160131.do', INQ_PARAMS);
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
		 layoutStr.push('	<DataGridColumn dataField="PNO" headerText="'+ parent.fn_text('sn')+ '" textAlign="center" width="50"   draggable="false"/>');
		 layoutStr.push('	<DataGridColumn dataField="AREA_NM"  headerText="'+parent.fn_text('area')+'" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="BIZRNM_PAGE"  headerText="'+parent.fn_text('bizr_nm')+'" width="180" itemRenderer="HtmlItem" />');
		 layoutStr.push('	<DataGridColumn dataField="BIZRNO_DE"  headerText="'+parent.fn_text('bizrno')+'" width="150" formatter="{maskfmt}"/>');
		 layoutStr.push('	<DataGridColumn dataField="AFF_OGN_NM"  headerText="'+parent.fn_text('aff_ogn')+'" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="ALT_REQ_STAT_NM"  headerText="'+parent.fn_text('alt_req_stat')+'" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="BIZR_TP_NM"  headerText="'+parent.fn_text('bizr_tp')+'" width="140"/>');
		 layoutStr.push('	<DataGridColumn dataField="BIZR_STAT_CD"  headerText="'+parent.fn_text('stat')+'" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="RUN_STAT_NM"  headerText="'+parent.fn_text('run_stat')+'" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="RPST_NM"  headerText="'+parent.fn_text('rpst_nm')+'" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="USER_NM"  headerText="'+parent.fn_text('admin_nm')+'" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="ADMIN_ID"  headerText="'+parent.fn_text('id')+'" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="MBIL_NO"  headerText="'+parent.fn_text('mbil_tel_no')+'" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="RPST_TEL_NO"  headerText="'+parent.fn_text('tel_no')+'" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="FAX_NO"  headerText="'+parent.fn_text('fax_no')+'" width="150"/>');
		 layoutStr.push('	<DataGridColumn dataField="EMAIL"  headerText="'+parent.fn_text('email')+'" width="150"/>');
		 layoutStr.push('	<DataGridColumn dataField="CNTR_REG"  headerText="계약서" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="REG_DTTM"  headerText="등록일시" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="PAY_YN"  headerText="지급여부" width="100"/>');
         layoutStr.push('   <DataGridColumn dataField="PAY_END_DT"  headerText="'+parent.fn_text('pay_end_dt')+'" width="100"/>');
         layoutStr.push('   <DataGridColumn dataField="ADDR"  headerText="'+parent.fn_text('addr')+'" width="100"/>');
         layoutStr.push('   <DataGridColumn dataField="ERP_CD_NM"  headerText="'+parent.fn_text('erp_cd_nm')+'" width="100"/>');
         layoutStr.push('   <DataGridColumn dataField="ERP_LK_DT"  headerText="'+parent.fn_text('erp_lk_dt')+'" width="100"/>');
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
			 	/* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
			 	 window[INQ_PARAMS.FN_CALLBACK]();
			 	//취약점점검 5825 기원우 
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
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE0160101.do";
		kora.common.goPage('/CE/EPCE0160116.do', INQ_PARAMS);
		 
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

		var url = "/CE/EPCE0160101422.do";
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

		var url = "/CE/EPCE016010142.do";
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
		window.parent.NrvPub.AjaxPopup('/CE/EPCE0160101_1.do', pagedata);
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
		window.parent.NrvPub.AjaxPopup('/CE/EPCE01601018_1.do', pagedata);
	}

</script>
<style type="text/css">

.row .tit{width: 84px;}

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
						<div class="tit" id="bizr_nm"></div>  
						<div class="box">
							<input type="text" id="BIZRNM_SEL" name="BIZRNM_SEL" style="width: 179px;" maxByteLength="60">
						</div>
					</div>
					
					<div class="col">
						<div class="tit" id="bizr_tp"></div>  
						<div class="box">
							<select id="BizrTpCdList_SEL" name="BizrTpCdList_SEL" style="width: 179px">
							</select>
						</div>
					</div>
					
					<div class="col">
						<div class="tit" id="area_se"></div>  
						<div class="box">
							<select id="AreaCdList_SEL" name="AreaCdList_SEL" style="width: 179px">
							</select>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col">
						<div class="tit" id="bizrno"></div>
						<div class="box">
							<input type="text" id="BIZRNO_SEL" name="BIZRNO_SEL" style="width: 179px;" maxByteLength="60">
						</div>
					</div>
					
					<div class="col">
						<div class="tit" id="aff_ogn"></div>  
						<div class="box">
							<select id="AffOgnCdList_SEL" name="AffOgnCdList_SEL" style="width: 179px">
							</select>
						</div>
					</div>
					
<!-- 					<div class="col"> -->
<!-- 						<div class="tit" id="단체지부">단체지부</div>   -->
<!-- 						<div class="box"> -->
<!-- 							<select id="단체지부" style="width: 179px"> -->
<!-- 							</select> -->
<!-- 						</div> -->
<!-- 					</div> -->
					
<!-- 					<div class="col"> -->
<!-- 						<div class="tit" id="조회그룹">조회그룹</div>   -->
<!-- 						<div class="box"> -->
<!-- 							<select id="조회그룹" style="width: 149px"> -->
<!-- 							</select> -->
<!-- 						</div> -->
<!-- 					</div> -->
					
					<div class="col">
						<div class="tit" id="alt_req_stat" style=""></div>  
						<div class="box">
							<select id="AtlReqStatCdList_SEL" name="AtlReqStatCdList_SEL" style="width: 179px">
							</select>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col">
						<div class="tit" id="bizr_stat_cd" style=""></div>  
						<div class="box">
							<select id="BizrStatCdList_SEL" name="BizrStatCdList_SEL" style="width: 179px">
							</select>
						</div>
					</div>
                    <div class="col">
                        <div class="tit" id="pay_yn" style=""></div>  
                        <div class="box">
                            <select id="PayYn_SEL" name="PayYn_SEL" style="width: 179px">
                                <option value="" selected>전체</options>
                                <option value="Y">지급</options>
                                <option value="N">지급제외</options>
                            </select>
                        </div>
                    </div>
					<div class="col">
						<div class="tit" id="erp_cd_nm"></div>  
						<div class="box">
							<select id="ErpCdList_SEL" name="ErpCdList_SEL" style="width: 179px">
							</select>
						</div>
					</div>                    
					<div class="btn" id="CR">
					</div>
				</div> <!-- end of row -->
				
			</div>  <!-- end of srcharea -->
			</form>
		</section>

		<!-- 그리드 시작 -->
		<section class="secwrap mt10">

			<div class="boxarea">
				<div id="gridHolder" style="height: 570px; background: #FFF;"></div>
			</div>	<!-- 그리드 셋팅 -->
			<div class="gridPaging" id="gridPageNavigationDiv"></div>
			
		</section>	<!-- end of secwrap mt30  -->
		<section class="btnwrap" >
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