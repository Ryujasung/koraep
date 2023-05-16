<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
			
		var INQ_PARAMS; //파라미터 데이터
		var reqCtnrList = '';
		var cfmCtnrList = '';
	
		$(document).ready(function(){
			
			fn_btnSetting();
			
			INQ_PARAMS	= jsonObject($("#INQ_PARAMS").val());
			rtc_dt_list 			= jsonObject($("#rtc_dt_list").val());			//등록일자제한설정	

			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			$('#exch_reg_mfc_info').text(parent.fn_text('exch_reg_mfc_info'));
			$('#exch_cfm_mfc_info').text(parent.fn_text('exch_cfm_mfc_info'));
			$('#mfc_cho').text(parent.fn_text('mfc_cho'));
			$('#mfc_brch_cho').text(parent.fn_text('mfc_brch_cho'));
			$('#mfc_cho2').text(parent.fn_text('mfc_cho'));
			$('#mfc_brch_cho2').text(parent.fn_text('mfc_brch_cho'));
			$('#exch_dt').text(parent.fn_text('exch_dt'));
			$('#reg_ctnr_nm').text(parent.fn_text('reg_ctnr_nm'));
			$('#exch_ctnr_nm').text(parent.fn_text('exch_ctnr_nm'));
			$('#exch_qty').text(parent.fn_text('exch_qty'));
			$('#rmk').text(parent.fn_text('rmk'));
			
			$('#REQ_MFC_BIZR').attr('alt', parent.fn_text('exch_reg_mfc'));
			$('#REQ_MFC_BRCH').attr('alt', parent.fn_text('exch_reg_mfc_brch'));
			$('#CFM_MFC_BIZR').attr('alt', parent.fn_text('exch_cfm_mfc'));
			$('#CFM_MFC_BRCH').attr('alt', parent.fn_text('exch_cfm_mfc_brch'));
			$('#EXCH_RGST_DT').attr('alt', parent.fn_text('exch_dt'));
			$('#REQ_CTNR_CD').attr('alt', parent.fn_text('reg_ctnr_nm'));
			$('#CFM_CTNR_CD').attr('alt', parent.fn_text('exch_ctnr_nm'));
			$('#EXCH_QTY').attr('alt', parent.fn_text('exch_qty'));

			fn_set_grid();

			//날짜 셋팅
		    $('#EXCH_RGST_DT').YJcalendar({  
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
				
			});
			
			var bizrNmList = jsonObject($("#bizrNmList_list").val());

			kora.common.setEtcCmBx2(bizrNmList, "", "", $("#REQ_MFC_BIZR"), "BIZRID_NO", "BIZRNM", "N", "S");
			kora.common.setEtcCmBx2(bizrNmList, "", "", $("#CFM_MFC_BIZR"), "BIZRID_NO", "BIZRNM", "N", "S");
				
			$('#REQ_MFC_BRCH').append("<option value=''>"+parent.fn_text('cho')+"</option>");
			$('#CFM_MFC_BRCH').append("<option value=''>"+parent.fn_text('cho')+"</option>");
			
			$('#REQ_CTNR_CD').append("<option value=''>"+parent.fn_text('cho')+"</option>");
			$('#CFM_CTNR_CD').append("<option value=''>"+parent.fn_text('cho')+"</option>");
			
			
			/************************************
			 * 등록 생산자명 변경 이벤트
			 ***********************************/
			 $("#REQ_MFC_BIZR").change(function(){
					fn_bizrTpCd($(this), $("#REQ_MFC_BRCH"));
					fn_ctnrCd($(this), $("#REQ_CTNR_CD"));
			 });
			
			/************************************
			 * 확인 생산자명 변경 이벤트
			 ***********************************/
			 $("#CFM_MFC_BIZR").change(function(){
					fn_bizrTpCd($(this), $("#CFM_MFC_BRCH"));
					fn_ctnrCd($(this), $("#CFM_CTNR_CD"));
			 });
			
			/************************************
			 * 날짜  클릭시 - 삭제  변경 이벤트
			 ***********************************/
			$("#EXCH_RGST_DT").click(function(){
				    var start_dt = $("#EXCH_RGST_DT").val();
				     start_dt   =  start_dt.replace(/-/gi, "");
				     $("#EXCH_RGST_DT").val(start_dt)
			});
			/************************************
			 * 날짜  클릭시 - 추가  변경 이벤트
			 ***********************************/
			$("#EXCH_RGST_DT").change(function(){
			     var start_dt = $("#EXCH_RGST_DT").val();
			     start_dt   =  start_dt.replace(/-/gi, "");
				if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
			     $("#EXCH_RGST_DT").val(start_dt) 
			});
			
			//행추가
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			//행변경
			$("#btn_upd").click(function(){
				fn_upd();
			});
			
			//행삭제
			$("#btn_del").click(function(){
				fn_del();
			});
			
			//취소
			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			//등록
			$("#btn_reg2").click(function(){
				fn_reg2();
			});
			
		});
		
		function fn_reg2(){
			
			var collection = gridRoot.getCollection();
			if(collection.getLength() < 1){
				alertMsg("데이터가 없습니다.");
				return;
			}
			
			confirm('저장하시겠습니까?', 'fn_reg2_exec');
		}
		
		function fn_reg2_exec(){

			var url  = "/CE/EPCE6624531_09.do";
			var data = {};
			var row = new Array();
			var collection = gridRoot.getCollection();
		 	for(var i=0;i<collection.getLength(); i++){
		 		var item = gridRoot.getItemAt(i);
		 		row.push(item);
		 	}
			
			data["list"] = JSON.stringify(row);
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					
					if(rtnData.RSLT_CD =="0000"){
						alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
					
				} else {
					alertMsg("error");
				}
			});
		}
		
		//취소
		function fn_cnl(){
			kora.common.goPageB('', INQ_PARAMS);
		}
		
		//행추가
		function fn_reg(){
			
			if(!kora.common.cfrmDivChkValid("params")) {
				return;
			}

			var reqStdDps = $('#REQ_CTNR_CD option:selected').val().split(";")[1];
			var cfmStdDps = $('#CFM_CTNR_CD option:selected').val().split(";")[1]; 
			
			/* 빈용기 보증금 체크 일시 해제
			/* 2019-05-03 김미경 요청
			if(reqStdDps != cfmStdDps) {
				alertMsg('빈용기보증금이 동일한 용기만 교환등록 가능합니다.\n등록 빈용기('+reqStdDps+'원) : 교환 빈용기('+cfmStdDps+'원)');
				return;
			}
			*/
			
			
			if(!kora.common.fnDateCheck($("#EXCH_RGST_DT").val(), '-')){
				alertMsg('올바른 날짜형식이 아닙니다.', 'kora.common.focus_target("EXCH_RGST_DT")');
				return;
			}
			
			if($('#EXCH_QTY').val() == '0'){
				alertMsg("교환량은 0개로 등록할 수 없습니다.");
				return;
			}
			
			var input = insRow('A');
			if(!input) return;
			
			//DB데이터 체크
			fn_dataCheck('ADD', input);
			
		}
		
		//행변경
		function fn_upd(){
			
			var idx = dataGrid.getSelectedIndex();
			
			if(idx < 0) {
				alertMsg("변경할 행을 선택하시기 바랍니다.");
				return;
			}
			
			if(!kora.common.cfrmDivChkValid("params")) {
				return;
			 }
			
			var reqStdDps = $('#REQ_CTNR_CD option:selected').val().split(";")[1];
			var cfmStdDps = $('#CFM_CTNR_CD option:selected').val().split(";")[1]; 
			
			/* 빈용기 보증금 체크 일시 해제
			/* 2019-05-03 김미경 요청
			if(reqStdDps != cfmStdDps) {
				alertMsg('빈용기보증금이 동일한 용기만 교환등록 가능합니다.\n등록 빈용기('+reqStdDps+'원) : 교환 빈용기('+cfmStdDps+'원)');
				return;
			}
			*/
			
			if($('#EXCH_QTY').val() == '0'){
				alertMsg("교환량은 0개로 등록할 수 없습니다.");
				return;
			}

			var input = insRow('M');
			if(!input) return;
			
			//DB데이터 체크
			fn_dataCheck('UPD', input, idx);	
		}
		
		//행삭제
		function fn_del(){
			var idx = dataGrid.getSelectedIndex();

			if(idx < 0) {
				alertMsg("삭제할 행을 선택하시기 바랍니다.");
				return;
			}
			
			gridRoot.removeItemAt(idx);
		}
		
		//저장여부, 사업자유형 체크
		function fn_dataCheck(gbn, input, idx){
			
			var url  = "/CE/EPCE6624531_19.do";

			ajaxPost(url, input, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					if(rtnData.RSLT_CD != '0000'){
						alertMsg(rtnData.RSLT_MSG, '');
					}else{
						
						if(rtnData.CTNR_INFO[0] == null || rtnData.CTNR_INFO[0] == ''){
							
						}else{
							input['CPCT_NM'] = rtnData.CTNR_INFO[0].CPCT_NM;
							input['EXCH_GTN_UTPC'] = rtnData.CTNR_INFO[0].STD_DPS;
							input['EXCH_GTN'] = Number(input["EXCH_QTY"]) * Number(input['EXCH_GTN_UTPC']);
						}
						
						if(gbn == 'ADD'){
							//데이터 추가
							gridRoot.addItemAt(input);
							dataGrid.setSelectedIndex(-1);
						}else if(gbn == 'UPD'){
							//해당 데이터 수정
							gridRoot.setItemAt(input, idx);
						}
					}
				} else {
					alertMsg("error");
				}
			});
		}
		
		//로우데이터 셋팅
		function insRow(gbn){
			
			var input = {};
			var REQ_MFC_BIZR = $('#REQ_MFC_BIZR option:selected').val();
			var REQ_MFC_BRCH = $('#REQ_MFC_BRCH option:selected').val();
			var CFM_MFC_BIZR = $('#CFM_MFC_BIZR option:selected').val();
			var CFM_MFC_BRCH = $('#CFM_MFC_BRCH option:selected').val();
			
			if(REQ_MFC_BIZR == CFM_MFC_BIZR){
				alertMsg('교환등록 및 확인 생산자 정보를 동일한 생산자로 선택할 수 없습니다.');
	 			return false;
			}else if(!kora.common.fn_validDate_ck( "R", $("#EXCH_RGST_DT").val())){ //등록일자제한 체크
				return;
			}
			input["REQ_MFC_BIZRID"] = REQ_MFC_BIZR.split(";")[0];
			input["REQ_MFC_BIZRNO"] = REQ_MFC_BIZR.split(";")[1];
			input["REQ_MFC_BRCH_ID"] = REQ_MFC_BRCH.split(";")[0];
			input["REQ_MFC_BRCH_NO"] = REQ_MFC_BRCH.split(";")[1];
			input["CFM_MFC_BIZRID"] = CFM_MFC_BIZR.split(";")[0];
			input["CFM_MFC_BIZRNO"] = CFM_MFC_BIZR.split(";")[1];
			input["CFM_MFC_BRCH_ID"] = CFM_MFC_BRCH.split(";")[0];
			input["CFM_MFC_BRCH_NO"] = CFM_MFC_BRCH.split(";")[1];
			input["EXCH_DT"] = $('#EXCH_RGST_DT').val().replace(/\-/g,"");
			input["REQ_CTNR_CD"] = $('#REQ_CTNR_CD option:selected').val().split(";")[0];
			input["CFM_CTNR_CD"] = $('#CFM_CTNR_CD option:selected').val().split(";")[0];
			input["REQ_CTNR_NM"] = $('#REQ_CTNR_CD option:selected').text();
			input["CFM_CTNR_NM"] = $('#CFM_CTNR_CD option:selected').text();
			input["EXCH_QTY"] = $('#EXCH_QTY').val().replace(/\,/g,"");
			input["RMK"] = $('#RMK').val();

			var collection = gridRoot.getCollection();
		 	for(var i=0;i<collection.getLength(); i++){
		 		var tmpData = gridRoot.getItemAt(i);
		 		if(tmpData.REQ_MFC_BIZRID == input["REQ_MFC_BIZRID"] && tmpData.REQ_MFC_BIZRNO == input["REQ_MFC_BIZRNO"]
		 			&& tmpData.REQ_MFC_BRCH_ID == input["REQ_MFC_BRCH_ID"] && tmpData.REQ_MFC_BRCH_NO == input["REQ_MFC_BRCH_NO"]
		 			&& tmpData.CFM_MFC_BIZRID == input["CFM_MFC_BIZRID"] && tmpData.CFM_MFC_BIZRID == input["CFM_MFC_BIZRID"]
		 			&& tmpData.REQ_MFC_BRCH_NO == input["REQ_MFC_BRCH_NO"] && tmpData.REQ_MFC_BRCH_NO == input["REQ_MFC_BRCH_NO"]
		 			&& tmpData.EXCH_DT == input["EXCH_DT"]
		 			&& tmpData.REQ_CTNR_CD == input["REQ_CTNR_CD"]
		 			&& tmpData.CFM_CTNR_CD == input["CFM_CTNR_CD"]
		 		  ){
		 			
		 			if(gbn == 'M' && rowIndex == i){ //행변경시 선택된 행의 데이터는 패스
		 				continue;
		 			}
		 			
		 			alertMsg('중복된 데이터가 존재합니다.');
		 			return false;
		 		}
		 	}
			
			return input;
		}

		//생산자명 변경시 지점
		function fn_bizrTpCd(obj, tt){
			var url = "/SELECT_BRCH_LIST.do" 
			var input ={};
		    input["BIZRID_NO"] = obj.val();
		    input["STAT_CD"] = "Y";

       	    ajaxPost(url, input, function(rtnData) {
   				if (null != rtnData) {   
   					kora.common.setEtcCmBx2(rtnData, "","", tt, "BRCH_ID_NO", "BRCH_NM", "N" ,'T');
   				} else {
   					alertMsg("error");
   				}
    		}, false);
		}
		
		//생산자 선택시 빈용기명 조회
		function fn_ctnrCd(obj, tt){
			var url = "/SELECT_CTNR_LIST.do" 
			var input ={};
		    input["BIZRID_NO"] = obj.val();
		    input["USE_YN"] = "Y";

       	    ajaxPost(url, input, function(rtnData) {
   				if (null != rtnData) {   
   					kora.common.setEtcCmBx2(rtnData, "","", tt, "CTNR_CD", "CTNR_NM", "N" ,'S');
   				} else {
   					alertMsg("error");
   				}
    		}, false);
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
			 layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			 layoutStr.push(' <NumberMaskFormatter id="dateFmt" formatString="####-##-##"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center">');
			 layoutStr.push('<groupedColumns>');
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" width="50"/>');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_DT"  headerText="'+parent.fn_text('exch_dt')+'" width="100" formatter="{dateFmt}"/>');
			 layoutStr.push('	<DataGridColumn dataField="REQ_CTNR_NM"  headerText="'+parent.fn_text('reg_ctnr_nm')+'" width="200"/>');
			 layoutStr.push('	<DataGridColumn dataField="CFM_CTNR_NM"  headerText="'+parent.fn_text('exch_ctnr_nm')+'" width="200"/>');
			 layoutStr.push('	<DataGridColumn dataField="CPCT_NM"  headerText="'+parent.fn_text('cpct')+'" width="110"/>');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_QTY" id="exchQty" headerText="'+parent.fn_text('exch_qty')+'" width="110" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumnGroup headerText="'+parent.fn_text('cntr_dps2')+'">');
		 	 layoutStr.push('		<DataGridColumn dataField="EXCH_GTN_UTPC" headerText="'+parent.fn_text('utpc')+'" width="110" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('		<DataGridColumn dataField="EXCH_GTN" id="exchGtnAmt" headerText="'+parent.fn_text('total')+'" width="110" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	</DataGridColumnGroup>');
			 layoutStr.push('	<DataGridColumn dataField="RMK"  headerText="'+parent.fn_text('rmk')+'" width="100" textAlign="left"/>');
			 layoutStr.push('</groupedColumns>');
			 layoutStr.push('	<footers>');
			 layoutStr.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{exchQty}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{exchGtnAmt}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('		</DataGridFooter>');
			 layoutStr.push('	</footers>');
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
		         gridApp.setData();
		     }
		     var selectionChangeHandler = function(event) {
				rowIndex = event.rowIndex;
				fn_rowToInput ();
			 }
		     var dataCompleteHandler = function(event) {
		 	 }
		     
		     gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
		
		//선택한 행 입력창에 값 넣기
		function fn_rowToInput (){
			var item = gridRoot.getItemAt(rowIndex);
			$("#REQ_MFC_BIZR").val(item["REQ_MFC_BIZRID"]+";"+item["REQ_MFC_BIZRNO"]).prop("selected", true);
			$("#CFM_MFC_BIZR").val(item["CFM_MFC_BIZRID"]+";"+item["CFM_MFC_BIZRNO"]).prop("selected", true);
			$("#REQ_MFC_BIZR").trigger('change');
		 	$("#CFM_MFC_BIZR").trigger('change');
			$("#REQ_MFC_BRCH").val(item["REQ_MFC_BRCH_ID"]+";"+item["REQ_MFC_BRCH_NO"]).prop("selected", true);
			$("#CFM_MFC_BRCH").val(item["CFM_MFC_BRCH_ID"]+";"+item["CFM_MFC_BRCH_NO"]).prop("selected", true);
			$('#EXCH_RGST_DT').val(kora.common.formatter.datetime(item['EXCH_DT'], 'yyyy-mm-dd'));
			$("#REQ_CTNR_CD").val(item["REQ_CTNR_CD"]).prop("selected", true);
			$("#CFM_CTNR_CD").val(item["CFM_CTNR_CD"]).prop("selected", true);
			$('#EXCH_QTY').val(item['EXCH_QTY']);
			$('#RMK').val(item['RMK']);
		};

	</script>

	<style type="text/css">
		.row .tit{width: 90px;}
	</style>

</head>
<body>
	<div class="iframe_inner">
	
		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
		<input type="hidden" id="bizrNmList_list" value="<c:out value='${bizrNmList}' />" />
		<input type="hidden" id="rtc_dt_list" value="<c:out value='${rtc_dt_list}' />" />
		
	
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
		</div>
		<section class="secwrap" id="params">
		
			<div class="srcharea">
			
				<div class="write_area" style="border-top:0px">
					<div class="write_tbl">
						<table>
							<colgroup>
								<col style="width: 280px;">
								<col style="width: auto;">
							</colgroup>
							<tr>
								<th><span id='exch_reg_mfc_info'></span></th>
								<td>
									<div class="row">
										<div class="col" style="margin: 0 20px 0 0;">
											<div class="tit" id="mfc_cho" ></div>
											<div class="box">
												<select id="REQ_MFC_BIZR" name="REQ_MFC_BIZR" style="width: 179px;" class="i_notnull">
												</select>
											</div>
										</div>
										<div class="col">
											<div class="tit" id="mfc_brch_cho" style="width:110px"></div>
											<div class="box">
												<select id="REQ_MFC_BRCH" name="REQ_MFC_BRCH" style="width: 179px;" class="i_notnull">
												</select>
											</div>
										</div>
									</div>
								</td>
							</tr>
							<tr>
								<th><span id='exch_cfm_mfc_info'></span></th>
								<td>
									<div class="row">
										<div class="col" style="margin: 0 20px 0 0;">
											<div class="tit" id="mfc_cho2" ></div>
											<div class="box">
												<select id="CFM_MFC_BIZR" name="CFM_MFC_BIZR" style="width: 179px;" class="i_notnull">
												</select>
											</div>
										</div>
										<div class="col">
											<div class="tit" id="mfc_brch_cho2" style="width:110px"></div>
											<div class="box">
												<select id="CFM_MFC_BRCH" name="CFM_MFC_BRCH" style="width: 179px;" class="i_notnull">
												</select>
											</div>
										</div>
									</div>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		
			<div class="srcharea mt10">
				<div class="row">
					<div class="col">
						<div class="tit" id="exch_dt"></div>
						<div class="box">						
							<div class="calendar">
								<input type="text" id="EXCH_RGST_DT" name="EXCH_RGST_DT" style="width: 179px;" class="i_notnull" >
							</div>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="reg_ctnr_nm"  ></div>
						<div class="box">
							<select id="REQ_CTNR_CD" name="REQ_CTNR_CD" style="width: 179px;" class="i_notnull">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="exch_ctnr_nm"  ></div>
						<div class="box">
							<select id="CFM_CTNR_CD" name="CFM_CTNR_CD" style="width: 179px;" class="i_notnull">
							</select>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col">
						<div class="tit" id="exch_qty"></div>
						<div class="box">		
							<input id="EXCH_QTY" name="EXCH_QTY" type="text" style="width: 179px;text-align:right" class="i_notnull" maxlength="11" format="minus">
						</div>
					</div>
					<div class="col">
						<div class="tit" id="rmk"  ></div>
						<div class="box">
							<input id="RMK" name="RMK" type="text" style="width: 500px;" alt="" maxByteLength="90" >
						</div>
					</div>
				</div>
			</div>
		</section>
		
		<section class="btnwrap mt10" style="">
			<div class="fl_r" id="UR">
			</div>
		</section>
		
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:530px;"></div>
			</div>
		</section>
	
		<section class="btnwrap mt20" style="">
			<div class="fl_l" >
				<div class="h4group" >
					<h5 class="tit"  style="font-size: 16px;text-align:left">
						※ 자료를 입력 후 [행추가] 버튼을 클릭하여 저장할 자료를 여러 건 입력한 후 [등록] 버튼을 클릭하여 여러 건을 동시에 저장합니다.
					</h5>
				</div>
			</div>
			<div class="fl_r" id="BR">
			</div>
		</section>
		
	</div>
	
</body>
</html>
