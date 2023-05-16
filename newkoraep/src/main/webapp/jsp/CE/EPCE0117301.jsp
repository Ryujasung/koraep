<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />

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
			
			$('#whsdl').text(parent.fn_text('whsdl'));
			$('#area').text(parent.fn_text('area'));
			$('#deal_se').text(parent.fn_text('deal_yn'));
			$('#bizr_tp_cd').text(parent.fn_text('bizr_tp_cd'));
			$('#cust_bizrnm').text(parent.fn_text('cust_bizrnm'));
			$('#cust_bizrno').text(parent.fn_text('cust_bizrno'));
			
			var bizrList = jsonObject($('#bizrList').val());
			var areaList = jsonObject($('#areaList').val());
			var statList = jsonObject($('#statList').val());
			var bizrTpList = jsonObject($('#bizrTpList').val());

			kora.common.setEtcCmBx2(bizrList, "", "", $("#WHSDL_BIZR_SEL"), "BIZRID_NO", "BIZRNM", "N", "T");
			kora.common.setEtcCmBx2(areaList, "", "", $("#AREA_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(statList, "", "", $("#STAT_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(bizrTpList, "", "", $("#BIZR_TP_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			
			$("#WHSDL_BIZR_SEL").select2();
			
			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
				/* 화면이동 페이징 셋팅 */
				gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
				
				$("#WHSDL_BIZR_SEL").select2('val', INQ_PARAMS.SEL_PARAMS.WHSDL_BIZR_SEL);
			}
			
			//그리드 셋팅
			fn_set_grid();
			
			//조회
			$("#btn_sel").click(function(){
				//조회버튼 클릭시 페이징 초기화
				gridCurrentPage = 1;
				fn_sel();
			});
			
			//등록 버튼
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			//업무설정 버튼
			$("#btn_page").click(function(){
				fn_page();
			});
			
			//거래복원
			$("#btn_activity").click(function(){
				fn_activity();
			});
			
			//거래종료처리
			$("#btn_inactivity").click(function(){
				fn_inactivity();
			});
			
			/************************************
			 * 엑셀다운로드 버튼 클릭 이벤트
			 ***********************************/
			 $("#btn_excel").click(function() {
				 fn_excel();
			 });
		});
		
		/**
		 * 업무설정 화면 이동
		 */
		function fn_page(){
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE0117301.do";
			kora.common.goPage('/CE/EPCE0117342.do', INQ_PARAMS);
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
			var fileName = $('#title').text() +"_" + today+hour+min+sec+".xlsx";
			
			//그리드 컬럼목록 저장
			var col = new Array();
			var columns = dataGrid.getColumns();
			for(i=0; i<columns.length; i++){
				if(columns[i].getDataField() != undefined && columns[i].getDataField() != 'index'){ //순번 제외
					var item = {};
					item['headerText'] = columns[i].getHeaderText();
					
					if(columns[i].getDataField() == 'CUST_BIZRNM_LINK'){// html 태크 사용중 컬럼은 대체
						item['dataField'] = 'CUST_BIZRNM';
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
			
			var url = "/CE/EPCE0121801_05.do";
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
		
		//거래종료처리
		function fn_inactivity(){
			var selector = gridRoot.getObjectById("selector");
			var chkLst = selector.getSelectedItems();

			if(chkLst.length < 1){
				alertMsg("선택된 내역이 없습니다.");
				return;
			}
			
			var row  = new Array();
			var cnt = 0;

			for(var i=0; i<chkLst.length; i++){
				var item = {};
				item = chkLst[i];
				if("N" != chkLst[i].STAT_CD){
					row.push(item);
					cnt++;
				}
			}
			
			if(chkLst.length != cnt){
				alertMsg("거래 상태가 아닌 구분이 선택되었습니다.\n다시 한 번 확인하사기 바랍니다.");
				return;
			}
			
			confirm('거래종료 처리하시겠습니까?', 'fn_inactivity_exec');
			
		}
		
		//거래복원
		function fn_activity(){
			var selector = gridRoot.getObjectById("selector");
			var chkLst = selector.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("선택된 내역이 없습니다.");
				return;
			}
			
			var row  = new Array();
			var cnt = 0;

			for(var i=0; i<chkLst.length; i++){
				var item = {};
				item = chkLst[i];
				if("Y" != chkLst[i].STAT_CD){
					row.push(item);
					cnt++;
				}
			}
			
			if(chkLst.length != cnt){
				alertMsg("거래종료 상태가 아닌 구분이 선택되었습니다.\n다시 한 번 확인하사기 바랍니다.");
				return;
			}
			
			confirm('거래복원 처리하시겠습니까?', 'fn_activity_exec');
			
		}
		
		//거래복원 confirm 처리
		function fn_activity_exec(){
			var selector = gridRoot.getObjectById("selector");
			var chkLst = selector.getSelectedItems();
			var url  = "/CE/EPCE0121801_21.do";
			var data = {};
			var row  = new Array();
			var cnt = 0;

			for(var i=0; i<chkLst.length; i++){
				var item = {};
				item = chkLst[i];
				if("Y" != chkLst[i].STAT_CD){
					row.push(item);
					cnt++;
				}
			}
			data["list"] = JSON.stringify(row);
			data["exec_stat_cd"] = "Y";
			
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_sel');
				} else {
					alertMsg("error");
				}
			});
			
		}
				
		//거래종료처리 confirm 처리
		function fn_inactivity_exec(){
			var selector = gridRoot.getObjectById("selector");
			var chkLst = selector.getSelectedItems();
			var url  = "/CE/EPCE0121801_21.do";
			var data = {};
			var row  = new Array();
			var cnt = 0;
			
			for(var i=0; i<chkLst.length; i++){
				var item = {};
				item = chkLst[i];
				if("N" != chkLst[i].STAT_CD){
					row.push(item);
					cnt++;
				}
			}
			data["list"] = JSON.stringify(row);
			data["exec_stat_cd"] = "N";
			
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_sel');
				} else {
					alertMsg("error");
				}
			});
			
		}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){

			//소매거래처 관리를 통해 등록된 소매거래처는 지역코드가 없기때문에, 지역 조회 조건으로는 조회가 안된다...
			
			if($("#CUST_BIZRNO_SEL").val().length > 0 && $("#CUST_BIZRNO_SEL").val().length < 10){
				alertMsg("10자리의 사업자번호를 입력하셔야 합니다.");
				return;
			}
			
			var input = {};
			input["WHSDL_BIZR_SEL"] 		= $("#WHSDL_BIZR_SEL option:selected").val();
			input["AREA_CD_SEL"] 				= $("#AREA_CD_SEL option:selected").val();
			input["STAT_CD_SEL"] 				= $("#STAT_CD_SEL option:selected").val();
			input["BIZR_TP_CD_SEL"] 		= $("#BIZR_TP_CD_SEL option:selected").val();
			input["CUST_BIZRNM_SEL"] 		= $("#CUST_BIZRNM_SEL").val();
			input["CUST_BIZRNO_SEL"] 		= $("#CUST_BIZRNO_SEL").val();
			
			/* 페이징  */
			input["ROWS_PER_PAGE"] = gridRowsPerPage;
			input["CURRENT_PAGE"] 	= gridCurrentPage;
			
			/* 가맹점여부 */
			input["FRC_YN"] 	= "Y";
			
			//파라미터에 조회조건값 저장 
			INQ_PARAMS["SEL_PARAMS"] = input;
			
			var url = "/CE/EPCE0121801_19.do";
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.searchList);
					/* 페이징 표시 */
					gridTotalRowCount = rtnData.totalCnt; //총 카운트
					drawGridPagingNavigation(gridCurrentPage);
				} 
				else {
					alertMsg("error");
				}
				kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
			});
			
		}
		
		/**
		 * 등록화면 이동
		 */
		function fn_reg(){
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE0117301.do";
			kora.common.goPage('/CE/EPCE0117331.do', INQ_PARAMS);
		}
		
		/**
		 * 그리드 관련 변수 선언
		 */
	    var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
		var gridApp, gridRoot, dataGrid, layoutStr, selectorColumn;
		var layoutStr = new Array();
		
		/**
		 * 메뉴관리 그리드 셋팅
		 */
		 function fn_set_grid() {
			 
			 rMateGridH5.create("grid", "gridHolder", jsVars, "100%", "100%");
			 
			 layoutStr.push('<rMateGrid>');
			 layoutStr.push('	<NumberMaskFormatter id="maskfmt" formatString="###-##-#####"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalGridLines="true" textAlign="center" draggableColumns="true" sortableColumns="true"> ');
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" textAlign="center" allowMultipleSelection="true" width="3%" verticalAlign="middle" />');
			 layoutStr.push('	<DataGridColumn dataField="PNO" headerText="'+ parent.fn_text('sn')+ '" textAlign="center" width="4%"   draggable="false"/>');	
			 layoutStr.push('	<DataGridColumn dataField="WHSDL_BIZRNM"  headerText="'+parent.fn_text('whsdl')+'" width="15%" />');
			 layoutStr.push('	<DataGridColumn dataField="WHSDL_BRCH_NM"  headerText="'+parent.fn_text('brch_nm')+'" width="15%"/>');
			 layoutStr.push('	<DataGridColumn dataField="AREA_NM"  headerText="'+parent.fn_text('area')+'" width="7%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZR_TP_CD_NM"  headerText="'+parent.fn_text('bizr_tp_cd')+'" width="10%"/>');
			 layoutStr.push('	<DataGridColumn dataField="CUST_BIZRNM_LINK"  headerText="'+parent.fn_text('cust_bizrnm')+'" width="15%" itemRenderer="HtmlItem"/>');
			 layoutStr.push('	<DataGridColumn dataField="CUST_BIZRNO_DE"  headerText="'+parent.fn_text('bizrno')+'" width="10%" formatter="{maskfmt}"/>');
			 layoutStr.push('	<DataGridColumn dataField="STAT_NM"  headerText="'+parent.fn_text('deal_se')+'" width="10%"/>');
			 layoutStr.push('</columns>');
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
		    	 selectorColumn = gridRoot.getObjectById("selector");
		    	 
		    	 drawGridPagingNavigation(gridCurrentPage);  //페이징 표시
		    	 
		    	//파라미터 call back function 실행
				 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
				 	eval(INQ_PARAMS.FN_CALLBACK+"()");
				 }else{
					 gridApp.setData();
				 }
		     }
		
		     var dataCompleteHandler = function(event) {
		     }
		    
		     gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);

		 }
		
		var parent_item;
		function fn_pop(){
			
			var idx = dataGrid.getSelectedIndex();
			parent_item = gridRoot.getItemAt(idx);

			var pagedata = window.frameElement.name;
			window.parent.NrvPub.AjaxPopup('/CE/EPCE0121888.do', pagedata);
		}

	</script>
	
	<style type="text/css">
		.row .tit{width: 77px;}
	</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="bizrList" value="<c:out value='${bizrList}' />"/>
<input type="hidden" id="areaList" value="<c:out value='${areaList}' />"/>
<input type="hidden" id="statList" value="<c:out value='${statList}' />"/>
<input type="hidden" id="bizrTpList" value="<c:out value='${bizrTpList}' />"/>

	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn" style="float:right" id="UR"></div>
		</div>
		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">
					<!-- 도매업자명 combo -->
					<div class="col">
						<div class="tit" id="whsdl"></div>
						<div class="box">
							<select id="WHSDL_BIZR_SEL" name="WHSDL_BIZR_SEL" style="width: 179px" ></select>
						</div>
					</div>
					<!-- 지역 combo -->
					<div class="col">
						<div class="tit" id="area"></div>
						<div class="box">
							<select id="AREA_CD_SEL" name="AREA_CD_SEL" style="width: 179px" ></select>
						</div>
					</div>
					<!-- 거래구분 combo -->
					<div class="col">
						<div class="tit" id="deal_se" style="width:120px"></div>
						<div class="box">
							<select id="STAT_CD_SEL" name="STAT_CD_SEL" style="width: 179px" ></select>
						</div>
					</div>
				</div>
	
				<div class="row">
					<!-- 거래처구분 combo -->
					<div class="col">
						<div class="tit" id="bizr_tp_cd"></div>
						<div class="box">
							<select id="BIZR_TP_CD_SEL" name="BIZR_TP_CD_SEL" style="width: 179px"></select>
						</div>
					</div> 
					<!-- 거래처명 text -->
					<div class="col" >
						<div class="tit" id="cust_bizrnm"></div>
						<div class="box">
							<input type="text" id="CUST_BIZRNM_SEL" name="CUST_BIZRNM_SEL" style="width: 179px;" />
						</div>
					</div>
					<!-- 거래처사업자번호 text -->
					<div class="col" >
						<div class="tit" id="cust_bizrno" style="width:120px"></div>
						<div class="box">
							<input type="text" id="CUST_BIZRNO_SEL" name="CUST_BIZRNO_SEL" maxlength="10" style="width: 179px;" format="number" />
						</div>
					</div>
					<div class="btn" id="CR">
					</div>
				</div>
			</div>
		</section>
		
		<div class="boxarea mt10">
			<div id="gridHolder" style="height:564px;background: #FFF;""></div>
			<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
		</div>
		
		<section class="btnwrap" >
			<div class="btn" id="BL">
			</div>
			<div class="btn" style="float:right" id="BR">
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
