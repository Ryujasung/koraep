<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
			
		var INQ_PARAMS; //파라미터 데이터
		var searchList;
		var searchDtl;
		
		$(document).ready(function(){
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
			searchList = jsonObject($("#searchList").val());
			searchDtl = jsonObject($("#searchDtl").val());
			
			$('.txt').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			
			$('#WHSDL_BIZRNM').text(searchDtl[0].BIZRNM);
			$('#WHSDL_BIZRNO').text(kora.common.setDelim(searchDtl[0].BIZRNO, '999-99-99999'));
			$('#RPST_NM').text(searchDtl[0].RPST_NM);
			$('#ADDR').text(searchDtl[0].ADDR);
			$('#RPST_TEL_NO').text(searchDtl[0].RPST_TEL_NO);
			$('#PAY_AMT').text(kora.common.format_comma(searchDtl[0].PAY_AMT));
			$('#ACP_ACCT_DPSTR_NM').text(searchDtl[0].ACP_ACCT_DPSTR_NM);
			$('#ACP_ACCT_NO').text(searchDtl[0].ACP_ACCT_NO);
			$('#REAL_PAY_DT').text(searchDtl[0].REAL_PAY_DT);
			
			fn_btnSetting();

			fn_set_grid();
			
			$("#btn_page").click(function(){
				fn_page2();
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
									
			var now  = new Date(); 				     // 현재시간 가져오기
			var hour = new String(now.getHours());   // 시간 가져오기
			var min  = new String(now.getMinutes()); // 분 가져오기
			var sec  = new String(now.getSeconds()); // 초 가져오기
			var today = kora.common.gfn_toDay();
			var fileName = $('#title_sub').text() +"_" + today+hour+min+sec+".xlsx";
			
			//그리드 컬럼목록 저장
			var col = new Array();
			var columns = dataGrid.getColumns();
			for(i=0; i<columns.length; i++){
				if(columns[i].getDataField() != undefined && columns[i].getDataField() != 'index'){ //순번 제외
					var item = {};
					item['headerText'] = columns[i].getHeaderText();
					
					if(columns[i].getDataField() == 'WRHS_CFM_DT_PAGE'){// html 태크 사용중 컬럼은 대체
						item['dataField'] = 'WRHS_CFM_DT';
					}else{
						item['dataField'] = columns[i].getDataField();
					}
					
					item['textAlign'] = columns[i].getStyle('textAlign');
					item['id'] = kora.common.null2void(columns[i].id);
					
					col.push(item);
				}
			}
			
			var input = INQ_PARAMS["PARAMS"];
			input['fileName'] = fileName;
			input['columns'] = JSON.stringify(col);
			
			var url = "/WH/EPWH2371364_05.do";
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
		
		function fn_page2(){
			kora.common.goPageB('', INQ_PARAMS);
		}
		
		//입고 상세화면 이동
		function fn_page(){

			var idx = dataGrid.getSelectedIndices();
			var input = gridRoot.getItemAt(idx);
			
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH2371364.do";
			kora.common.goPage('/WH/EPWH29164642.do', INQ_PARAMS);
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
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			 layoutStr.push('<groupedColumns>');
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" width="50"/>');
             layoutStr.push('   <DataGridColumn dataField="RTN_REG_DT"  headerText="'+parent.fn_text('rtn_reg_dt')+'" width="150" itemRenderer="HtmlItem" />');
             layoutStr.push('   <DataGridColumn dataField="RTN_DT"  headerText="'+parent.fn_text('rtrvl_dt')+'" width="150" />');
			 layoutStr.push('	<DataGridColumn dataField="WRHS_CFM_DT_PAGE"  headerText="'+parent.fn_text('wrhs_cfm_dt')+'" width="150" itemRenderer="HtmlItem" />');
			 layoutStr.push('	<DataGridColumn dataField="WHSDL_BIZRNM"  headerText="'+parent.fn_text('whsdl')+'" width="200"/>');
			 layoutStr.push('	<DataGridColumn dataField="MFC_BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150"/>');
			 layoutStr.push('	<DataGridColumn dataField="MFC_BRCH_NM" headerText="'+parent.fn_text('mfc_brch_nm')+'" width="100" />');
			 layoutStr.push('	<DataGridColumn dataField="WRHS_QTY" id="sum1" headerText="'+parent.fn_text('wrhs_qty')+'" width="100" textAlign="right" formatter="{numfmt}"/>');
			 layoutStr.push('	<DataGridColumn dataField="WRHS_GTN" id="sum2" headerText="'+parent.fn_text('gtn')+'" width="100" textAlign="right" formatter="{numfmt}"/>');
			 layoutStr.push('	<DataGridColumn dataField="FEE" id="sum3" headerText="'+parent.fn_text('fee')+'" width="100" textAlign="right" formatter="{numfmt}"/>');
			 layoutStr.push('	<DataGridColumn dataField="FEE_STAX" id="sum4" headerText="'+parent.fn_text('stax')+'" width="100" textAlign="right" formatter="{numfmt}"/>');
			 layoutStr.push('	<DataGridColumn dataField="TOT" id="sum5" headerText="'+parent.fn_text('total')+'" width="100" textAlign="right" formatter="{numfmt}"/>');
			 layoutStr.push('</groupedColumns>');
			 layoutStr.push('	<footers>');
			 layoutStr.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
             layoutStr.push('           <DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum3}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum4}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum5}" formatter="{numfmt}" textAlign="right" />');
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
			 }
		     var dataCompleteHandler = function(event) {

		 	 }
		     
		     gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		 }

	</script>

	<style type="text/css">
		.row .tit{width: 67px;}
	</style>

</head>
<body>
	<div class="iframe_inner">
		
		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
		<input type="hidden" id="searchList" value="<c:out value='${searchList}' />" />
		<input type="hidden" id="searchDtl" value="<c:out value='${searchDtl}' />" />
	
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
			<div class="btn_box">
				<div class="btn" id="UR">
				</div>
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
								<th><span class='txt' id='mtl_txt'></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="WHSDL_BIZRNM"></div>
									</div>
								</td>
								<th><span class='txt' id='bizrno2_txt'></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="WHSDL_BIZRNO"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th><span class='txt' id='rpst_txt'></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="RPST_NM"></div>
									</div>
								</td>
								<th><span class='txt' id='addr_txt'></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="ADDR"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th><span class='txt' id='tel_no2_txt'></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="RPST_TEL_NO"></div>
									</div>
								</td>
								<th><span class='txt' id='pay_amt_txt'></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="PAY_AMT"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th><span class='txt' id='dpstr_txt'></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="ACP_ACCT_DPSTR_NM"></div>
									</div>
								</td>
								<th><span class='txt' id='pay_acct_txt'></span></th>
								<td>
									<div class="row">
										<div class="txtbox" id="ACP_ACCT_NO"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th><span class='txt' id='real_pay_dt_txt'></span></th>
								<td colspan="3">
									<div class="row">
										<div class="txtbox" id="REAL_PAY_DT"></div>
									</div>
								</td>
							</tr>
						</table>
					</div>
				</div>
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
	
	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="excel" />
	</form>
	
</body>
</html>
