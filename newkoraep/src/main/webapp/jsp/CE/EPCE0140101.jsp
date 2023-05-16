<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>

	<script type="text/javaScript" language="javascript" defer="defer">
		
		var INQ_PARAMS;
		
		/* 페이징 사용 등록 */
		gridRowsPerPage = 15;	// 1페이지에서 보여줄 행 수
		gridCurrentPage = 1;		// 현재 페이지
		gridTotalRowCount = 0; 	//전체 행 수
		
		$(document).ready(function(){
			
			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			
			fn_btnSetting();
			
			$('#user_nm_sel').text(parent.fn_text('user_nm'));
			$('#user_id_sel').text(parent.fn_text('id'));
			$('#user_stat_sel').text(parent.fn_text('user_stat'));
			$('#pwd_alt_req_sel').text(parent.fn_text('pwd_alt_req'));
			
			$('#bizr_tp_cd_sel').text(parent.fn_text('bizr_tp'));
			$('#bizrnm_sel').text(parent.fn_text('bizr_nm'));
			$('#bizrno_sel').text(parent.fn_text('bizrno'));
			$('#area_cd_sel').text(parent.fn_text('area_se'));
			
			$('#user_se_cd_sel').text(parent.fn_text('user_se'));

			
			fn_set_grid();

			var bizrTpList = jsonObject($('#bizrTpList').val());
			var areaList = jsonObject($('#areaList').val());
			var userSeList = jsonObject($('#userSeList').val());
			var pwdAltReqList = jsonObject($('#pwdAltReqList').val());
			var userStatList = jsonObject($('#userStatList').val());
			
			kora.common.setEtcCmBx2(bizrTpList, "", "", $("#BIZR_TP_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(areaList, "", "", $("#AREA_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(userSeList, "", "", $("#USER_SE_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(pwdAltReqList, "", "", $("#PWD_ALT_REQ_YN_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(userStatList, "", "Y", $("#USER_STAT_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			
			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
				/* 화면이동 페이징 셋팅 */
				gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
			}
			
			$("#btn_sel").click(function(){
				//조회버튼 클릭시 페이징 초기화
				gridCurrentPage = 1;
				fn_sel();
			});
			
			$("#btn_upd").click(function(){
				fn_upd();
			});
			
			$("#btn_upd2").click(function(){
				fn_upd2();
			});
			
			$("#btn_upd3").click(function(){
				fn_upd3();
			});
			
			$("#btn_upd4").click(function(){
				fn_upd4();
			});
			
			$("#btn_upd5").click(function(){
				fn_upd5();
			});
			
			$("#btn_pop").click(function(){
				fn_pop();
			});
			
			$("#btn_mail").click(function(){
				fn_mail();
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
			var fileName = $('#title').text() +"_" + today+hour+min+sec+".xlsx";
			
			//그리드 컬럼목록 저장
			var col = new Array();
			var columns = dataGrid.getColumns();
			for(i=0; i<columns.length; i++){
				if(columns[i].getDataField() != undefined && columns[i].getDataField() != 'index'){ //순번 제외
					var item = {};
					item['headerText'] = columns[i].getHeaderText();
					
					if(columns[i].getDataField() == 'USER_ID_PAGE'){// html 태크 사용중 컬럼은 대체
						item['dataField'] = 'USER_ID';
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
			
			var url = "/CE/EPCE0140101_05.do";
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
		
		/* 페이징 이동 스크립트 */
		function gridMovePage(goPage) {
			gridCurrentPage = goPage; //선택 페이지
			fn_sel(); //조회 펑션
		}
		
		//입력화면 이동
		function fn_reg(){

			INQ_PARAMS["FN_CALLBACK" ] = "";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE0140101.do";
			kora.common.goPage('/CE/EPCE8716231.do', INQ_PARAMS);
		}
		
		
		/**
		 * 목록조회
		 */
		function fn_sel(){
			var chkLst = selectorColumn.getSelectedItems();
			var sData = kora.common.gfn_formData("frmMenu");
			var url = "/CE/EPCE0140101_19.do";
			
			if(0 < sData["BIZRNO_SEL"].length && 10 > sData["BIZRNO_SEL"].length){
				alertMsg("10자리의 사업자번호를 입력하셔야 합니다.");
				return;
			}
			
			/* 페이징  */
			sData["ROWS_PER_PAGE"] = gridRowsPerPage;
			sData["CURRENT_PAGE"] 	= gridCurrentPage;
			
			//파라미터에 조회조건값 저장 
			INQ_PARAMS["SEL_PARAMS"] = sData;
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, sData, function(rtnData){
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
			 layoutStr.push(' <NumberMaskFormatter id="dateFmt" formatString="####-##-##"/>');
			 layoutStr.push('	<NumberMaskFormatter id="maskfmt" formatString="###-##-#####"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" headerWordWrap="true" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center">');
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="true" headerText="" width="40" verticalAlign="middle" />');
			 layoutStr.push('			<DataGridColumn dataField="PNO" 				 				headerText="'+ parent.fn_text('sn')+ '" textAlign="center" width="50"   draggable="false"/>');							//순번
			 layoutStr.push('	<DataGridColumn dataField="BIZR_TP_NM"  headerText="'+parent.fn_text('bizr_tp')+'" width="100" />');
			 layoutStr.push('	<DataGridColumn dataField="AREA_NM"  headerText="'+parent.fn_text('area_se')+'" width="100"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('bizr_nm')+'" width="200"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNO_DE"  headerText="'+parent.fn_text('bizrno')+'" width="100" formatter="{maskfmt}"/>');
			 layoutStr.push('	<DataGridColumn dataField="USER_NM"  headerText="'+parent.fn_text('user_nm')+'" width="100"/>');
			 layoutStr.push('	<DataGridColumn dataField="BRCH_NM"  headerText="'+parent.fn_text('aff')+'" width="100"/>');
			 layoutStr.push('	<DataGridColumn dataField="USER_ID_PAGE"  headerText="'+parent.fn_text('id')+'" width="100" itemRenderer="HtmlItem"/>');
			 layoutStr.push('	<DataGridColumn dataField="EMAIL"  headerText="'+parent.fn_text('email')+'" width="150"/>');
			 layoutStr.push('	<DataGridColumn dataField="MBIL_NO"  headerText="'+parent.fn_text('mbil_tel_no')+'" width="100"/>');
			 layoutStr.push('	<DataGridColumn dataField="TEL_NO"  headerText="'+parent.fn_text('tel_no')+'" width="100"/>');
			 layoutStr.push('	<DataGridColumn dataField="USER_SE_NM"  headerText="'+parent.fn_text('user_se')+'" width="100"/>');
			 layoutStr.push('	<DataGridColumn dataField="ATH_GRP_NM"  headerText="'+parent.fn_text('ath_grp')+'" width="100"/>');
			 layoutStr.push('	<DataGridColumn dataField="USER_STAT_NM"  headerText="'+parent.fn_text('stat')+'" width="80"/>');
			 layoutStr.push('	<DataGridColumn dataField="PWD_ALT_REQ_NM"  headerText="'+parent.fn_text('pwd_alt')+'" width="100"/>');
			 layoutStr.push('	<DataGridColumn dataField="PWD_ALT_REQ_DTTM"  headerText="'+parent.fn_text('alt_req_dt')+'" width="100" formatter="{dateFmt}"/>');
			 layoutStr.push('	<DataGridColumn dataField="ADDR"  headerText="'+parent.fn_text('addr')+'" width="100"/>');
			 layoutStr.push('</columns>');
			 layoutStr.push('      <dataProvider>');
			 layoutStr.push('         <SpanArrayCollection source="{$gridData}"/>');
			 layoutStr.push('      </dataProvider>');
			 layoutStr.push('</DataGrid>');
			 layoutStr.push('</rMateGrid>');
		}

		// 그리드 및 메뉴 리스트 세팅
		 function gridReadyHandler(id) {
		 	 gridApp = document.getElementById(id);  // 그리드를 포함하는 div 객체
		     gridRoot = gridApp.getRoot();   // 데이터와 그리드를 포함하는 객체

		     gridApp.setLayout(layoutStr.join("").toString());
		     
		     var layoutCompleteHandler = function(event) {
		         dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		         dataGrid.addEventListener("change", selectionChangeHandler); //이벤트 등록
		         drawGridPagingNavigation(gridCurrentPage);  //페이징 표시
		         
		       	 //파라미터 call back function 실행
				 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
				 	eval(INQ_PARAMS.FN_CALLBACK+"()");
				 }else{
					 gridApp.setData([]);
				 }
		     }
		     var selectionChangeHandler = function(event) {
				rowIndex = event.rowIndex;
			 }
		     var dataCompleteHandler = function(event) {
		     	dataGrid = gridRoot.getDataGrid();
		     	setSpanAttributes(); 
		     	
		     	//체크초기화
		     	selectorColumn = gridRoot.getObjectById("selector");
		     	selectorColumn.setSelectedIndex(-1);
		 	 }
		     
		     gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
		
		 /**
		  * 그리드 상태 및 비밀번호변경 건 스타일 처리
		  */
		 function setSpanAttributes() {
			 var collection; //그리드 데이터 객체
		     if (collection == null)
		         collection = gridRoot.getCollection();
		     if (collection == null) {
		         alert("collection 객체를 찾을 수 없습니다");
		         return;
		     }
		  
		     for (var i = 0; i < collection.getLength(); i++) {
		     	var data = gridRoot.getItemAt(i);
		     	
		     	if(data.USER_STAT_CD == "W" || data.PWD_ALT_REQ_YN == "Y" ){
		 	        collection.addRowAttributeDetailAt(i, null, "#FFCC00", null, false, 20);
		     	}
		     }
		 }
		
		//상세화면 이동
		function fn_page(){

			var input = {};
			input["USER_ID"] = gridRoot.getItemAt(rowIndex)["USER_ID"];
			
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE0140101.do";
			kora.common.goPage('/CE/EPCE0140164.do', INQ_PARAMS);
		}
		
		var gGubn;
		
		//회원복원
		function fn_upd(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			console.log(chkLst);
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}
			
			
			var msgList = new Array();
			
			for(var i=0; i<chkLst.length; i++){
				
				//상태값 활동인 경우
				if(chkLst[i].USER_STAT_CD == "Y"){
					alertMsg("이미 활동 상태인 회원이 선택되었습니다.\n다시 한 번 확인하시기 바랍니다.");
					return;
				}
				
				if(chkLst[i].USER_STAT_CD == "N"){
					if(chkLst[i].USER_NM == null || chkLst[i].USER_NM == ""){
					alertMsg("탈퇴처리한 회원입니다.\n다시 한 번 확인하시기 바랍니다.");
					return;
						
					}else if ((chkLst[i].EMAIL ==null || chkLst[i].EMAIL ==" ") && (chkLst[i].TEL_NO==null || chkLst[i].TEL_NO =="--")&&(chkLst[i].MBIL_NO==null || chkLst[i].MBIL_NO ==" - - ")){
						alertMsg("탈퇴처리한 회원입니다.\n다시 한 번 확인하시기 바랍니다.");	
						return;
					}
				}
			
				
				//관리자 여부 체크(센터 관리자그룹은 사업자 관리자 활동 처리 가능)
				if(chkLst[i].USER_SE_CD == "D"){
					//if(ssGrpCd == "A01"){
						//confirm("사업자 관리자("+chkLst[i].USER_NM+")를 활동 처리 시\n해당 사업장이 활성화됩니다.\n계속 진행하시겠습니까?", "");
						msgList.push(chkLst[i].USER_NM);
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

			var url = "/CE/EPCE0140101_21.do";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_sel');
				} else {
					alertMsg("error");
				}
			});
		}
		
		//관리자변경
		function fn_upd2(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}
			
			if(chkLst.length > 1){
				alertMsg("한건만 선택이 가능합니다.");
				return;
			}
			
			//소속사업장에 활동상태의 관리자가 존재할경우 변경 불가  
			//기본관리자를 비활동 또는 탈퇴처리 후 진행하시기 바랍니다.
			
			if("D" == chkLst[0].USER_SE_CD){
				alertMsg("관리자는 선택하실 수 없습니다.");
				return;
			}
			
			if(chkLst[0].USER_STAT_CD != "Y"){
				alertMsg("상태가 활동인 회원만 관리자로 변경이 가능합니다.");
				return;
			}
			
			confirm("선택한 사용자로 사업장 관리자 변경을 하시겠습니까?", 'fn_upd_exec');
			gGubn = "B";
			//현재 로그인한 사용자의 관리자정보가 변경되었을경우 처리 필요?
		}
		
		//비활동처리
		function fn_upd3(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg('선택된 행이 없습니다');
				return;
			}
			
			var msgList = new Array();
			
			for(var i=0; i<chkLst.length; i++){

				//상태값 비활동인 경우
				if(chkLst[i].USER_STAT_CD == "N"){
					alertMsg("비활동 상태인 회원이 선택되었습니다.\n다시 한 번 확인하시기 바랍니다.");
					return;
				}
	
				//관리자 여부 체크(센터 관리자그룹은 사업자 관리자 비활동 처리 가능)
				if(chkLst[i].USER_SE_CD == "D"){
					//if(ssGrpCd == "A01" || ssGrpCd == "A11" || ssGrpCd == "A12"){
						
						msgList.push(chkLst[i].USER_NM);
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
		
		//비밀번호변경승인
		function fn_upd4(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg('선택된 행이 없습니다');
				return;
			}
			
			for(var i=0; i<chkLst.length; i++){
				if(chkLst[i].PWD_ALT_REQ_YN != "Y"){
					alertMsg("비밀번호변경요청 대상이 아닌 항목이 선택되었습니다.\n다시 한 번 확인하시기 바랍니다.");
					return;
				}
			}
			
			confirm("보안을 위해 업무 담당자가 비밀번호변경요청을 하였는지 확인 바랍니다.\n승인 처리를 진행하시겠습니까?", "fn_upd_exec");
			gGubn = "D";
		}
		
		//비밀번호오류초기화
		function fn_upd5(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg('선택된 행이 없습니다');
				return;
			}
			
			confirm("비밀번호오류초기화 처리를 진행하시겠습니까?", "fn_upd_exec");
			gGubn = "E";
		}
		
		var parent_item;
		//사용자변경이력 팝업
		function fn_pop(){
			
			var idx = dataGrid.getSelectedIndex();
			
			if(idx < 0){
				alertMsg('선택된 행이 없습니다');
				return;
			}
			
			parent_item = gridRoot.getItemAt(idx);
			var pagedata = window.frameElement.name;
			window.parent.NrvPub.AjaxPopup('/CE/EPCE01401882.do', pagedata);
		}
		//휴면계정메일전송화면 이동 
		function fn_mail() {
			//INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE0140101.do";
			kora.common.goPage('/CE/EPCE0140199.do', INQ_PARAMS);
		}

	</script>

	<style type="text/css">
		.row .tit{width: 67px;}
	</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="bizrTpList" value="<c:out value='${bizrTpList}' />"/>
<input type="hidden" id="areaList" value="<c:out value='${areaList}' />"/>
<input type="hidden" id="userSeList" value="<c:out value='${userSeList}' />"/>
<input type="hidden" id="pwdAltReqList" value="<c:out value='${pwdAltReqList}' />"/>
<input type="hidden" id="userStatList" value="<c:out value='${userStatList}' />"/>



	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn_box" id="UR"></div>
		</div>
		<section class="secwrap">
			<form name="frmMenu" id="frmMenu" method="post" >
			<div class="srcharea" id="sel_params">
				<div class="row">
					<div class="col">
						<div class="tit" id="user_nm_sel"></div>
						<div class="box">						
							<input id="USER_NM_SEL" name="USER_NM_SEL" style="width: 159px;" type="text"/>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="user_id_sel"></div>
						<div class="box">
							<input id="USER_ID_SEL" name="USER_ID_SEL" style="width: 159px;" type="text"/>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="user_stat_sel"></div>
						<div class="box">
							<select id="USER_STAT_CD_SEL" name="USER_STAT_CD_SEL" style="width: 159px;">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="pwd_alt_req_sel" style="width:120px"></div>
						<div class="box">
							<select id="PWD_ALT_REQ_YN_SEL" name="PWD_ALT_REQ_YN_SEL" style="width: 159px;">
							</select>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col">
						<div class="tit" id="bizr_tp_cd_sel"></div>
						<div class="box">						
							<select id="BIZR_TP_CD_SEL" name="BIZR_TP_CD_SEL" style="width: 159px;">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="bizrnm_sel"></div>
						<div class="box">
							<input id="BIZRNM_SEL" name="BIZRNM_SEL" style="width: 159px;" type="text"/>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="bizrno_sel"></div>
						<div class="box">
							<input id="BIZRNO_SEL" name="BIZRNO_SEL" style="width: 159px;" type="text"/>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="area_cd_sel" style="width:120px"></div>
						<div class="box">
							<select id="AREA_CD_SEL" name="AREA_CD_SEL" style="width: 159px;">
							</select>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col">
						<div class="tit" id="user_se_cd_sel"></div>
						<div class="box">
							<select id="USER_SE_CD_SEL" name="USER_SE_CD_SEL" style="width: 159px;">
							</select>
						</div>
					</div>
					<div class="btn" id="CR">
					</div>
				</div>
			</div>
			</form>
		</section>
		
		<div class="boxarea mt10">
			<div id="gridHolder" style="height:570px;background: #FFF;"></div>
			<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
		</div>
	
		<section class="btnwrap" >
			<div class="fl_l" id="BL">
			</div>
			<div class="fl_r" id="BR">
				<button type="button" class="btn36 c2" style="width:100px; display:none" id="btn_reg">정보입력임시</button>
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
