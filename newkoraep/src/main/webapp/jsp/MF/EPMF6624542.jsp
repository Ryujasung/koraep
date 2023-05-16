<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
			
		var INQ_PARAMS = ${INQ_PARAMS}; //파라미터 데이터
		var searchList = ${searchList};
		var reqCtnrList = ${reqCtnrList};
		var cfmCtnrList = ${cfmCtnrList};
		
		$(document).ready(function(){
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			fn_btnSetting();
			
			$('#reg_dt2').text(parent.fn_text('reg_dt2'));
			$('#exch_dt').text(parent.fn_text('exch_dt'));
			$('#exch_reg_mfc').text(parent.fn_text('exch_reg_mfc'));
			$('#exch_cfm_mfc').text(parent.fn_text('exch_cfm_mfc'));
			$('#reg_ctnr_nm').text(parent.fn_text('reg_ctnr_nm'));
			$('#exch_ctnr_nm').text(parent.fn_text('exch_ctnr_nm'));
			$('#exch_qty').text(parent.fn_text('exch_qty'));
			$('#rmk').text(parent.fn_text('rmk'));
			
			$('#REQ_CTNR_CD').attr('alt', parent.fn_text('reg_ctnr_nm'));
			$('#CFM_CTNR_CD').attr('alt', parent.fn_text('exch_ctnr_nm'));
			$('#EXCH_QTY').attr('alt', parent.fn_text('exch_qty'));
			
			$('#EXCH_REG_DT').text(searchList[0].EXCH_REG_DT_TXT);
			$('#EXCH_DT').text(searchList[0].EXCH_DT_TXT);
			$('#REQ_MFC').text(searchList[0].REQ_BIZRNM+" "+searchList[0].REQ_BRCH_NM);
			$('#CFM_MFC').text(searchList[0].CFM_BIZRNM+" "+searchList[0].CFM_BRCH_NM);
			
			kora.common.setEtcCmBx2(reqCtnrList, "","", $('#REQ_CTNR_CD'), "CTNR_CD", "CTNR_NM", "N" ,'S');
			kora.common.setEtcCmBx2(cfmCtnrList, "","", $('#CFM_CTNR_CD'), "CTNR_CD", "CTNR_NM", "N" ,'S');
			
			fn_set_grid();
			
			$("#btn_cnl").click(function(){
				fn_cnl();
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

			var url  = "/MF/EPMF6624542_21.do";
			var data = {};
			var row = new Array();
			var collection = gridRoot.getCollection();
		 	for(var i=0;i<collection.getLength(); i++){
		 		var item = gridRoot.getItemAt(i);
		 		row.push(item);
		 	}
		 	
			data["list"] = JSON.stringify(row);
			data["EXCH_REQ_DOC_NO"] = searchList[0].EXCH_REQ_DOC_NO;
			
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
				} else {
					alertMsg("error");
				}
			});
		}
		
		//행추가
		function fn_reg(){
			
			if(!kora.common.cfrmDivChkValid("params")) {
				return;
			}
			
			var reqStdDps = $('#REQ_CTNR_CD option:selected').val().split(";")[1];
			var cfmStdDps = $('#CFM_CTNR_CD option:selected').val().split(";")[1];  
			
			if(reqStdDps != cfmStdDps) {
				alertMsg('빈용기보증금이 동일한 용기만 교환등록 가능합니다.\n등록 빈용기('+reqStdDps+'원) : 교환 빈용기('+cfmStdDps+'원)');
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
			
			if(reqStdDps != cfmStdDps) {
				alertMsg('빈용기보증금이 동일한 용기만 교환등록 가능합니다.\n등록 빈용기('+reqStdDps+'원) : 교환 빈용기('+cfmStdDps+'원)');
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
			
			var url  = "/MF/EPMF6624531_19.do";

			//input['BIZRID_NO'] = searchList[0].REQ_MFC_BIZRID +";"+ searchList[0].REQ_MFC_BIZRNO;
			
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

			input["EXCH_REQ_DOC_NO"] = searchList[0].EXCH_REQ_DOC_NO;
			input["EXCH_DT"] = searchList[0].EXCH_DT;
			input["REQ_CTNR_CD"] = $('#REQ_CTNR_CD option:selected').val().split(";")[0];
			input["CFM_CTNR_CD"] = $('#CFM_CTNR_CD option:selected').val().split(";")[0];
			input["REQ_CTNR_NM"] = $('#REQ_CTNR_CD option:selected').text();
			input["CFM_CTNR_NM"] = $('#CFM_CTNR_CD option:selected').text();
			input["EXCH_QTY"] = $('#EXCH_QTY').val().replace(/\,/g,"");
			input["RMK"] = $('#RMK').val();

			var collection = gridRoot.getCollection();
		 	for(var i=0;i<collection.getLength(); i++){
		 		var tmpData = gridRoot.getItemAt(i);
		 		if(	 tmpData.EXCH_REQ_DOC_NO == input["EXCH_REQ_DOC_NO"] 
		 			&& tmpData.REQ_CTNR_CD == input["REQ_CTNR_CD"] && tmpData.CFM_CTNR_CD == input["CFM_CTNR_CD"]
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
		
		
		function fn_cnl(){
			kora.common.goPageB('', INQ_PARAMS);
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
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			 layoutStr.push('<groupedColumns>');
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" width="50"/>');
			 layoutStr.push('	<DataGridColumn dataField="REQ_CTNR_NM"  headerText="'+parent.fn_text('reg_ctnr_nm')+'" width="250"/>');
			 layoutStr.push('	<DataGridColumn dataField="CFM_CTNR_NM"  headerText="'+parent.fn_text('exch_ctnr_nm')+'" width="250"/>');
			 layoutStr.push('	<DataGridColumn dataField="CPCT_NM"  headerText="'+parent.fn_text('cpct')+'" width="150"/>');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_QTY" id="exchQtyTot"  headerText="'+parent.fn_text('exch_qty')+'" width="100" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumnGroup headerText="'+parent.fn_text('cntr_dps2')+'">');
		 	 layoutStr.push('		<DataGridColumn dataField="EXCH_GTN_UTPC" headerText="'+parent.fn_text('utpc')+'" width="110" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('		<DataGridColumn dataField="EXCH_GTN" id="exchGtnTot" headerText="'+parent.fn_text('total')+'" width="110" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	</DataGridColumnGroup>'); 
			 layoutStr.push('	<DataGridColumn dataField="RMK"  headerText="'+parent.fn_text('rmk')+'" width="" textAlign="left"/>');
			 layoutStr.push('</groupedColumns>');
			 layoutStr.push('	<footers>');
			 layoutStr.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{exchQtyTot}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{exchGtnTot}" formatter="{numfmt}" textAlign="right" />');
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
				 gridApp.setData(searchList);
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
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
			<div class="btn_box">
			</div>
		</div>
		<section class="secwrap">
			<div class="srcharea">
				<div class="write_area" style="border-top:0px">
					<div class="write_tbl">
						<table>
							<colgroup>
								<col style="width: 180px;">
								<col style="width: 280px;">
								<col style="width: 180px;">
								<col style="width: auto;">
							</colgroup>
							<tr>
								<th><span id='reg_dt2'></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="EXCH_REG_DT"></div>
									</div>
								</td>
								<th><span id='exch_dt'></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="EXCH_DT"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th><span id='exch_reg_mfc'></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="REQ_MFC"></div>
									</div>
								</td>
								<th><span id='exch_cfm_mfc'></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="CFM_MFC"></div>
									</div>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>
			
			<div class="srcharea mt10" id="params">
				<div class="row">
					<div class="col">
						<div class="tit" id="reg_ctnr_nm"  ></div>
						<div class="box">
							<select id="REQ_CTNR_CD" name="REQ_CTNR_CD" style="width: 279px;" class="i_notnull">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="exch_ctnr_nm"  ></div>
						<div class="box">
							<select id="CFM_CTNR_CD" name="CFM_CTNR_CD" style="width: 279px;" class="i_notnull" >
							</select>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col">
						<div class="tit" id="exch_qty"></div>
						<div class="box">
							<input id="EXCH_QTY" name="EXCH_QTY" type="text" style="width: 279px;text-align:right" class="i_notnull" alt="" maxlength="11" format="minus" >
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
				<div id="gridHolder" style="height:350px;"></div>
			</div>
		</section>
	
		<section class="btnwrap mt20" style="">
			<div class="fl_l" id="BL">

			</div>
			<div class="fl_r" id="BR">
			</div>
		</section>
		
	</div>
	
</body>
</html>
