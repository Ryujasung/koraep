<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
		
		var btchList;
		var btchCheck;
	
		$(document).ready(function(){
			btchList 	=  jsonObject($("#btchList").val());
			fn_btnSetting(); 
			
			$('#btch_cd').text(parent.fn_text('btch_cd'));
			$('#btch_nm').text(parent.fn_text('btch_nm'));
			$('#proc_nm').text(parent.fn_text('exec_proc'));
			$('#btch_st_dt').text(parent.fn_text('btch_st_dt'));
			$('#btch_end_dt').text(parent.fn_text('btch_end_dt'));
			$('#rept_yn').text(parent.fn_text('rept_yn'));
			$('#exec_tm').text(parent.fn_text('exec_tm'));
			$('#exec_term').text(parent.fn_text('exec_term'));
			$('#use_yn').text(parent.fn_text('use_yn'));
			
			//작성체크용
			$('#BTCH_CD').attr('alt', parent.fn_text('btch_cd'));
			$('#BTCH_NM').attr('alt', parent.fn_text('btch_nm'));
			$('#PROC_NM').attr('alt', parent.fn_text('exec_proc'));
			$('#ST_DTTM').attr('alt', parent.fn_text('btch_st_dt'));
			$('#EXEC_TM').attr('alt', parent.fn_text('exec_tm'));
			$('#EXEC_TERM').attr('alt', parent.fn_text('exec_term'));
			$('#REPT_YN').attr('alt', parent.fn_text('rept_yn'));
			$('#USE_YN').attr('alt', parent.fn_text('use_yn'));
			
			
			$('#ST_DTTM').YJcalendar({  
				toName : 'to',
				triggerBtn : true
			});
			$('#END_DTTM').YJcalendar({
				fromName : 'from',
				triggerBtn : true
			});
			
			
			$('#cho_tm').text(parent.fn_text('cho'));
			$('#cho_term').text(parent.fn_text('cho'));
			
			var tm = parent.fn_text('tm');
			var hr = parent.fn_text('hr');
			
			for(var i=0;i<24;i++){ // 시간 셋팅
				if(i < 10){  
					$("#EXEC_TM").append('<option value="0'+i+'">0'+i+tm+'</option>');
				} else {
					$("#EXEC_TM").append('<option value="'+i+'">'+i+tm+'</option>');  
				} 
			}
			
			for(var i=1;i<13;i++){ // 간격 셋팅
				$("#EXEC_TERM").append('<option value="'+i+'">'+i+hr+'</option>');
			}
			
			fn_set_grid();
			
			var reptList = ${reptList};
			var useList = ${useList};
			var procList = ${procList};
			kora.common.setEtcCmBx2(reptList, "", "", $("#REPT_YN"), "ETC_CD", "ETC_CD_NM", "N", "S");
			kora.common.setEtcCmBx2(useList, "", "", $("#USE_YN"), "ETC_CD", "ETC_CD_NM", "N", "S");
			kora.common.setEtcCmBx2(procList, "", "", $("#PROC_NM"), "OBJECT_NAME", "OBJECT_NAME", "N", "S");

			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			$("#btn_init").click(function(){
				fn_init();
			});
			
			
			$("#REPT_YN").change(function(){
				if($("#REPT_YN option:selected").val() == 'Y'){//반복
					$('#EXEC_TERM').prop("disabled", false);
				}else{ //단일
					$('#EXEC_TERM').val('');
					$('#EXEC_TERM').prop("disabled", true);
				}
			});
			
			
			/************************************
			 * 시작날짜  클릭시 - 삭제  변경 이벤트
			 ***********************************/
			$("#ST_DTTM").click(function(){
				    var start_dt = $("#ST_DTTM").val();
				     start_dt   =  start_dt.replace(/-/gi, "");
				     $("#ST_DTTM").val(start_dt)
			});
			/************************************
			 * 시작날짜  클릭시 - 추가  변경 이벤트
			 ***********************************/
			$("#ST_DTTM").change(function(){
			     var start_dt = $("#ST_DTTM").val();
			     start_dt   =  start_dt.replace(/-/gi, "");
				if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
			     $("#ST_DTTM").val(start_dt) 
			});
			/************************************
			 * 끝날짜  클릭시 - 삭제  변경 이벤트
			 ***********************************/
			$("#END_DTTM").click(function(){
				    var end_dt = $("#END_DTTM").val();
				         end_dt  = end_dt.replace(/-/gi, "");
				     $("#END_DTTM").val(end_dt)
			});
			/************************************
			 * 끝날짜  클릭시 - 추가  변경 이벤트
			 ***********************************/
			$("#END_DTTM").change(function(){
			     var end_dt  = $("#END_DTTM").val();
			           end_dt =  end_dt.replace(/-/gi, "");
				if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd")
			     $("#END_DTTM").val(end_dt) 
			});
			
		});
		
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
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center">'); 
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="false" headerText="'+parent.fn_text('cho')+'" width="4%" />');
			 layoutStr.push('	<DataGridColumn dataField="BTCH_CD"  headerText="'+parent.fn_text('btch_cd')+'" width="8%" />');
			 layoutStr.push('	<DataGridColumn dataField="BTCH_NM"  headerText="'+parent.fn_text('btch_nm')+'" width="20%"/>');
			 layoutStr.push('	<DataGridColumn dataField="PROC_NM"  headerText="'+parent.fn_text('exec_proc')+'" width="20%"/>');
			 layoutStr.push('	<DataGridColumn dataField="ST_DTTM"  headerText="'+parent.fn_text('btch_st_dt')+'" width="10%"/>');
			 layoutStr.push('	<DataGridColumn dataField="END_DTTM"  headerText="'+parent.fn_text('btch_end_dt')+'" width="10%"/>');
			 layoutStr.push('	<DataGridColumn dataField="EXEC_TM"  headerText="'+parent.fn_text('exec_tm')+'" width="7%"/>');
			 layoutStr.push('	<DataGridColumn dataField="EXEC_TERM"  headerText="'+parent.fn_text('exec_term')+'" width="7%"/>');
			 layoutStr.push('	<DataGridColumn dataField="REPT_YN_NM"  headerText="'+parent.fn_text('rept_yn')+'" width="7%"/>');
			 layoutStr.push('	<DataGridColumn dataField="USE_YN_NM"  headerText="'+parent.fn_text('use_yn')+'" width="7%"/>');
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
		         dataGrid.addEventListener("change", selectionChangeHandler); //이벤트 등록
		         gridApp.setData(btchList);
		     }
  
		     var selectionChangeHandler = function(event) {
				var rowIndex = event.rowIndex;
				selectorColumn.setSelectedIndex(-1);
				selectorColumn.setSelectedIndex(rowIndex);
				fn_rowToInput(rowIndex);
			 }
		     
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);

		 }
		
		 //행선택시 입력값 input에  넣기
		 function fn_rowToInput(rowIndex) {
			var item = gridRoot.getItemAt(rowIndex);

			$("#BTCH_CD").val(item['BTCH_CD']);
			$("#BTCH_NM").val(item['BTCH_NM']);
			$("#PROC_NM").val(item['PROC_NM']);
			$("#ST_DTTM").val(item['ST_DTTM']);
			$("#END_DTTM").val(item['END_DTTM']);
			$("#EXEC_TM").val(item['EXEC_TM']);
			$("#EXEC_TERM").val(item['EXEC_TERM']);
			$("#REPT_YN").val(item['REPT_YN']);
			$("#USE_YN").val(item['USE_YN']);
			
			if($("#REPT_YN option:selected").val() == 'Y'){//반복
				$('#EXEC_TERM').prop("disabled", false);
			}else{ //단일
				$('#EXEC_TERM').val('');
				$('#EXEC_TERM').prop("disabled", true);
			}
		 }
		 
		//초기화
	     function fn_init(){
	    		$("#BTCH_CD").val('');
				$("#BTCH_NM").val('');
				$("#PROC_NM").val('');
				$("#ST_DTTM").val('');
				$("#END_DTTM").val('');
				$("#EXEC_TM").val('');
				$("#EXEC_TERM").val('');
				$("#REPT_YN").val('');
				$("#USE_YN").val('');
				selectorColumn.setSelectedIndex(-1);
				dataGrid.setSelectedIndex(-1);
	     }
		
		function fn_reg(){
			
			if(!kora.common.cfrmDivChkValid("params")) {
				return;
			}
			
			if(!kora.common.fnDateCheck($("#ST_DTTM").val(), '-')){
				alertMsg('올바른 날짜형식이 아닙니다.', 'kora.common.focus_target("ST_DTTM")');
				return;
			}
			if($("#END_DTTM").val() != '' && !kora.common.fnDateCheck($("#END_DTTM").val(), '-')){
				alertMsg('올바른 날짜형식이 아닙니다.', 'kora.common.focus_target("END_DTTM")');
				return;
			}
			
			var toDay = kora.common.gfn_toDay();  // 현재일자
			var nextDay = kora.common.getDate("yyyy-mm-dd", "D", 1, false).replace(/-/gi, "")
			
			
			if($("#END_DTTM").val().replace(/-/gi, "") != '' && Number($("#END_DTTM").val().replace(/-/gi, "")) <= Number(toDay) ){
				alertMsg('배치종료일이 현재일자와 같거나 이전일 수 없습니다.');
				return;
			}
			if($("#END_DTTM").val().replace(/-/gi, "") != '' && $("#ST_DTTM").val().replace(/-/gi, "") > $("#END_DTTM").val().replace(/-/gi, "")){
				alertMsg('배치시작일이 배치종료일 이후일 수 없습니다.');
				return;
			}
			
			if($("#REPT_YN  option:selected").val() == 'Y'){ //반복
				if($("#EXEC_TERM  option:selected").val() == ''){
					alertMsg("반복여부 '반복' 일 경우 실행간격 선택은 필수입니다.", 'kora.common.focus_target("EXEC_TERM")');
					return;
				}
			}else{//단일
				
			}

			
			var now   		= new Date(); 				// 현재시간 가져오기
			var hour  		= now.getHours(); 			// 시간 가져오기
			if(Number($("#END_DTTM").val().replace(/-/gi, "")) == Number(nextDay) && Number($("#EXEC_TM").val()) <= Number(hour) ){ 
				alertMsg('실행될 수 없는 배치일정 입니다.');
				return;
			}
			//실행될 수 없는 스케줄 등록시 오류남..
			//반복일 경우는 실행간격에 따라 실행되수도 있지만... 일단 패스함
			
			
			btchCheck = 'Y';
			$.each(btchList, function(i, v) {
				if(v.BTCH_CD == $("#BTCH_CD").val() && v.PROC_NM == $("#PROC_NM").val()){
					btchCheck = 'N';
					return;
				}
			});
			
			var msg = '';
			if(btchCheck == 'N'){
				msg = '동일한 배치코드 및 실행프로시저 정보가 존재합니다. \n변경사항을 적용하시겠습니까?';
			}else{
				msg = '배치코드 및 실행프로시저 정보를 등록하시겠습니까?';
			}
			
			confirm(msg, 'fn_reg_exec');
		}
		
		function fn_reg_exec(){

			var input = {};
			input["BTCH_CD"] 		= $("#BTCH_CD").val();
			input["BTCH_NM"] 		= $("#BTCH_NM").val();
			input["PROC_NM"] 		= $("#PROC_NM").val();
			input["ST_DTTM"] 		= $("#ST_DTTM").val();
			input["END_DTTM"] 		= $("#END_DTTM").val();
			input["EXEC_TM"] 		= $("#EXEC_TM").val();
			input["EXEC_TERM"] 	= $("#EXEC_TERM").val();
			input["REPT_YN"] 		= $("#REPT_YN").val();
			input["USE_YN"] 			= $("#USE_YN").val();
			
			input["NEW_YN"] 		= btchCheck;
			
		 	var url = "/CE/EPCE3969301_09.do";
		 	ajaxPost(url, input, function(rtnData){
		 		if ("" != rtnData && null != rtnData) {
		 			if(rtnData.RSLT_CD == '0000'){
		 				alertMsg(rtnData.RSLT_MSG, 'fn_sel');
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
 				} else {
 					alertMsg("error", 'fn_sel');
 				}
		 	});
	 	}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){

			var url = "/CE/EPCE3969301_19.do";
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, [], function(rtnData){
				if(rtnData != null && rtnData != ""){
					fn_init();
					btchList = rtnData.searchList; //중복데이터 체크를 위해 저장
					gridApp.setData(btchList);
				}else{
					alertMsg("error");
				}
			}, false);
			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
		}

	</script>

	<style type="text/css">
		.row .tit{width: 77px;}
	</style>

</head>
<body>
	<div class="iframe_inner">
		<input type="hidden" id="btchList" value="<c:out value='${btchList}' />" />
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn_box">
			</div>
		</div>
		<section class="secwrap">
			<div class="srcharea" id="params">
				<div class="row">
					<div class="col">
						<div class="tit" id="proc_nm"></div>
						<div class="box">
							<select id="PROC_NM" name="PROC_NM" style="width: 179px;" class="i_notnull" alt="" >
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="btch_cd"></div>
						<div class="box">
							<input id="BTCH_CD" name="BTCH_CD" type="text" style="width: 179px;" class="i_notnull" alt=""  maxlength="10" >
						</div>
					</div>
					<div class="col">
						<div class="tit" id="btch_nm"></div>
						<div class="box">
							<input id="BTCH_NM" name="BTCH_NM" type="text" style="width: 179px;" class="i_notnull" alt=""  maxByteLength="90">
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col">
						<div class="tit" id="btch_st_dt"></div>
						<div class="box">
							<input id="ST_DTTM" name="from" type="text" style="width: 179px;" class="i_notnull" alt="" maxlength="8">
						</div>
					</div>
					<div class="col">
						<div class="tit" id="btch_end_dt"></div>
						<div class="box">
							<input id="END_DTTM"  name="to" type="text" style="width: 179px;" alt="" maxlength="8">
						</div>
					</div>
					<div class="col">
						<div class="tit" id="rept_yn"></div>
						<div class="box">
							<select id="REPT_YN" name="REPT_YN" style="width: 179px;" class="i_notnull" alt="" >
							</select>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col">
						<div class="tit" id="exec_tm"></div>
						<div class="box">
							<select id="EXEC_TM" name="EXEC_TM" style="width: 179px;" class="i_notnull" alt="" >
								<option value="" id="cho_tm"></option>
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="exec_term"></div>
						<div class="box">
							<select id="EXEC_TERM" name="EXEC_TERM" style="width: 179px;" alt="" >
								<option value="" id="cho_term"></option>
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="use_yn"></div>
						<div class="box">
							<select id="USE_YN" name="USE_YN" style="width: 179px;" class="i_notnull" alt="" >
							</select>
						</div>
					</div>
				</div>
			</div>
		</section>
		<section class="btnwrap mt20" >
			<div class="fl_r" id="CR">
			</div>
		</section>
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:530px;"></div>
			</div>
		</section>
	
	</div>

</body>
</html>
