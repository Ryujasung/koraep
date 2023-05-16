<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">

		var parent_item;
	
		$(document).ready(function(){
			
			fn_btnSetting('EPCE4791431');
			
			//parent_item = window.frames[$("#pagedata").val()].parent_item;
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			$('#exca_term_nm_txt').text(parent.fn_text('exca_term_nm'));
			$('#cet_fyer_exca_yn_txt').text(parent.fn_text('cet_fyer_exca_yn'));
			$('#exca_term_cho').text(parent.fn_text('exca_term_cho'));
			$('#qtr_txt').text(parent.fn_text('qtr'));
			$('#mt_txt').text(parent.fn_text('mt'));
			$('#qtr_txt2').text(parent.fn_text('qtr'));
			$('#mt_txt2').text(parent.fn_text('mt'));
			$('#drct_input_txt').text(parent.fn_text('drct_input'));
			$('#crct_psbl_term').text(parent.fn_text('crct_psbl_term'));
			$('#crct_cfm_end_dt').text(parent.fn_text('crct_cfm_end_dt'));
			$('#exca_trgt_cho').text(parent.fn_text('exca_trgt_cho'));
			$('#whl').text(parent.fn_text('whl'));
			$('#std_n').text(parent.fn_text('std_n'));
			
			$('#EXCA_STD_NM').attr('alt', parent.fn_text('exca_term_nm'));
			$('#CRCT_PSBL_ST_DT').attr('alt', parent.fn_text('crct_psbl_term'));
			$('#CRCT_PSBL_END_DT').attr('alt', parent.fn_text('crct_psbl_term'));
			$('#CRCT_CFM_END_DT').attr('alt', parent.fn_text('crct_cfm_end_dt'));
			
			fn_set_grid();

			var date = new Date();
		    var year = date.getFullYear();
		    var selected = "";
		    for(i=2016; i<=year; i++){
		    	if(i == year) selected = "selected";
		    	$('#QTY_YEAR').append('<option value="'+i+'" '+selected+'>'+i+'</option>');
		    	$('#MT_YEAR').append('<option value="'+i+'" '+selected+'>'+i+'</option>');
		    }
		    for(i=1; i<=4; i++){
		    	$('#QTY').append('<option value="'+i+'">'+i+'</option>');
		    }
		    for(i=1; i<=12; i++){
		    	var dd = '';
		    	if(i < 10){
		    		dd = '0' + i;
		    	}else{
		    		dd = i;
		    	}
		    	$('#MT').append('<option value="'+dd+'">'+dd+'</option>');
		    }
			
			
		  	//날짜 셋팅
		    $('#EXCA_ST_DT').YJcalendar({  
				toName : 'to',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
				
			});
			$('#EXCA_END_DT').YJcalendar({
				fromName : 'from',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
			});
			
			//날짜 셋팅
		    $('#CRCT_PSBL_ST_DT').YJcalendar({  
				toName : 'to_crct',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
				
			});
			$('#CRCT_PSBL_END_DT').YJcalendar({
				fromName : 'from_crct',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", +7, false).replaceAll('-','')
			});
			
            $('#CRCT_CFM_END_DT').YJcalendar({
                triggerBtn : true,
                dateSetting : kora.common.getDate("yyyy-mm-dd", "D", +7, false).replaceAll('-','')
            });
		    
			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			$('#TRGT_YN').change(function(){
				if($(this).val() == 'I'){
					$("#trgtGrid").css("display","");	
				}else{
					$("#trgtGrid").css("display","none");	
				}
			});

		});
		
		function fn_cnl(){
			window.frames[$("#pagedata").val()].fn_sel();
			$('[layer="close"]').trigger('click');
		}
		
		//저장
		function fn_reg(){

			if(!kora.common.cfrmDivChkValid("divInput_P")) {
				return;
			}
			
			var excaTerm = $("input:radio[name='EXCA_SE_CD']:checked").val();
			if(excaTerm == undefined || excaTerm == ''){
				alertMsg("정산기간을 선택해 주세요.");
				return;
			}
			
			if($('#TRGT_YN').val() == 'I'){
				var chkLst = selectorColumn.getSelectedItems();
				
				if(chkLst.length < 1){
					alertMsg("정산대상 생산자를 선택해 주세요.");
					return;
				}
			}
			
            if(kora.common.fnGetDateRange(kora.common.rtnDate(), $("#CRCT_PSBL_ST_DT").val()) < 0) {
        	    alertMsg("정정가능기간 시작일자를 오늘 이후 날짜로 선택하세요.");
                return;
            }

		    if(kora.common.fnGetDateRange(kora.common.rtnDate(), $("#CRCT_PSBL_END_DT").val()) < 0) {
        	    alertMsg("정정가능기간 종료일자를 오늘 이후 날짜로 선택하세요.");
                return;
            } 

            if(kora.common.fnGetDateRange($("#CRCT_PSBL_END_DT").val(), $("#CRCT_CFM_END_DT").val()) < 0) {
                alertMsg("상호확인종료일자를 정정가능기간 종료일자 이후 날짜로 선택하세요.");
                return;
            } 

		    
		    confirm('저장하시겠습니까?', 'fn_reg_exec');
			
		}
		
		function fn_reg_exec(){
			
			var input = {};
			var row = new Array();
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(item);
			}
			
			input["list"] = JSON.stringify(row);
			
			input["EXCA_STD_NM"] = $('#EXCA_STD_NM').val();
			
			if($("#CET_FYER_EXCA_YN").prop("checked")){
				input["CET_FYER_EXCA_YN"] = "Y";
			}else{
				input["CET_FYER_EXCA_YN"] = "N";
			}
			
			input["EXCA_SE_CD"] = $("input:radio[name='EXCA_SE_CD']:checked").val();
			
			input["QTY_YEAR"] = $('#QTY_YEAR').val();
			input["QTY"] = $('#QTY').val();
			
			input["MT_YEAR"] = $('#MT_YEAR').val();
			input["MT"] = $('#MT').val();
			
			input["EXCA_ST_DT"] = $('#EXCA_ST_DT').val();
			input["EXCA_END_DT"] = $('#EXCA_END_DT').val();
			
			input["CRCT_PSBL_ST_DT"] = $('#CRCT_PSBL_ST_DT').val();
			input["CRCT_PSBL_END_DT"] = $('#CRCT_PSBL_END_DT').val();
			input["CRCT_CFM_END_DT"] = $('#CRCT_CFM_END_DT').val();
			
			input["TRGT_YN"] = $('#TRGT_YN').val()

			var url = "/CE/EPCE4791431_09.do";
			ajaxPost(url, input, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					if(rtnData.RSLT_CD = '0000'){
						alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
				} else {
					alertMsg("error");
				}
			});
		}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){
			
			var url = "/CE/EPCE4791431_19.do";
			
			ajaxPost(url, [], function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.searchList);
				} 
				else {
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
			 layoutStr.push('<rMateGrid>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" rowHeight="35" headerHeight="35" headerPaddingTop="0" headerPaddingBottom="0" paddingTop="0" paddingBottom="0" horizontalGridLines="true" textAlign="center" >');
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="true" width="50" verticalAlign="middle" />');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="200" />');
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
		        
		         fn_sel();
		     }
		     var selectionChangeHandler = function(event) {
				rowIndex = event.rowIndex;
			 }
		     var dataCompleteHandler = function(event) {
		    	 $("#trgtGrid").css("display","none");	//그리드 숨김
		 	 }
		     
		     gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
		
	</script>

</head>
<body>
	<div class="layer_popup" style="width:650px;">
	
		<input type="hidden" id="pagedata"/> 
		
			<div class="layer_head">
				<h1 class="layer_title" id="title_sub"></h1>
				<button type="button" class="layer_close" layer="close"></button>
			</div>
			<div class="layer_body" style="padding-top:10px">
				<div class="secwrap" id="divInput_P">
					<div class="write_area">
						<div class="write_tbl">
							<table>
								<colgroup>
									<col style="width: 150px;">
									<col style="width: auto;">
								</colgroup>
								<tr>
									<th ><span id="exca_term_nm_txt"></span></th>
									<td>
										<div class="row">
											<input id="EXCA_STD_NM" name="EXCA_STD_NM" type="text" style="width: 379px;" class="i_notnull" alt="" >
										</div>
									</td>
								</tr>
								<tr>
									<th ><span id="cet_fyer_exca_yn_txt"></span></th>
									<td>
										<div class="row" >
											<div class="chkbox">
												<label class="chk">
													<input type="checkbox" id="CET_FYER_EXCA_YN" name="CET_FYER_EXCA_YN" value="Y"><span></span>
												</label>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<th><span id="exca_term_cho"></span></th>
									<td style="padding-bottom:10px">
										<div class="row">
											<label class="rdo" style="width:70px"><input type="radio" name="EXCA_SE_CD" value="Q" ><span id="qtr_txt"></span></label>
											<select id="QTY_YEAR" name="QTY_YEAR" style="width:90px"></select>
											<select id="QTY" name="QTY" style="width:80px"></select><span id="qtr_txt2"></span>
										</div>
										<div class="row">
											<label class="rdo" style="width:70px"><input type="radio" name="EXCA_SE_CD" value="M" ><span id="mt_txt"></span></label>
											<select id="MT_YEAR" name="MT_YEAR" style="width:90px"></select>
											<select id="MT" name="MT" style="width:80px"></select><span id="mt_txt2"></span>
										</div>
										<div class="row2" >
											<label class="rdo" style="width:66px"><input type="radio" name="EXCA_SE_CD" value="S" ><span id="drct_input_txt"></span></label>
											<div class="calendar">
												<input type="text" id="EXCA_ST_DT" name="from" style="width: 130px;" ><!--시작날짜  -->
											</div>
											<div class="obj">~</div>
											<div class="calendar">
												<input type="text" id="EXCA_END_DT" name="to" style="width: 130px;" ><!-- 끝날짜 -->
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<th ><span id="crct_psbl_term"></span></th>
									<td style="padding-bottom:10px">
										<div class="row2" >
											<div class="calendar">
												<input type="text" id="CRCT_PSBL_ST_DT" name="from_crct" style="width: 130px;" class="i_notnull"><!--시작날짜  -->
											</div>
											<div class="obj">~</div>
											<div class="calendar">
												<input type="text" id="CRCT_PSBL_END_DT" name="to_crct" style="width: 130px;" class="i_notnull"><!-- 끝날짜 -->
											</div>
										</div>
									</td>
								</tr>
                                <tr>
                                    <th ><span id="crct_cfm_end_dt"></span></th>
                                    <td style="padding-bottom:10px">
                                        <div class="row2" >
                                            <div class="calendar">
                                                <input type="text" id="CRCT_CFM_END_DT"  style="width: 130px;" class="i_notnull"><!--시작날짜  -->
                                            </div>
                                        </div>
                                    </td>
                                </tr>
								<tr>
									<th ><span id="exca_trgt_cho"></span></th>
									<td>
										<div class="row">
											<select id="TRGT_YN" name="TRGT_YN">
												<option id="whl" value="W"></option>
												<option id="std_n" value="I"></option>
											</select>
											
											<div style="margin:10px 10px 0 0;width:100%;" id="trgtGrid">
												<div id="gridHolder" style="height:247px;"></div>
											</div>
											
										</div>
									</td>
								</tr>
							</table>
		
						</div>
						<div class="btnwrap">
							<div class="fl_l" id="BL">
							</div>
							<div class="fl_r" id="BR">
							</div>
						</div>
					</div>
				</div>
				
			</div>
	
	</div>
</body>
</html>
