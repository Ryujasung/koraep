<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>입금내역조회</title>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=1100, user-scalable=yes">
<meta name="description" content="사이트설명">
<meta name="keywords" content="사이트검색키워드">
<meta name="author" content="Newriver">
<meta property="og:title" content="공유제목">
<meta property="og:description" content="공유설명">
<meta property="og:image" content="공유이미지 800x400">

<%@include file="/jsp/include/common_page_m.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
			
		var INQ_PARAMS; //파라미터 데이터
		var searchList;
		var searchDtl;
		
		$(document).ready(function(){
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
			searchList = jsonObject($("#searchList").val());
			searchDtl = jsonObject($("#searchDtl").val());
			
			$('#WHSDL_BIZRNM').text(searchDtl[0].BIZRNM);
			$('#WHSDL_BIZRNO').text(kora.common.setDelim(searchDtl[0].BIZRNO, '999-99-99999'));
			$('#RPST_NM').text(searchDtl[0].RPST_NM);
			$('#ADDR').text(searchDtl[0].ADDR);
			$('#RPST_TEL_NO').text(searchDtl[0].RPST_TEL_NO);
			$('#PAY_AMT').text(kora.common.format_comma(searchDtl[0].PAY_AMT));
			$('#ACP_ACCT_DPSTR_NM').text(searchDtl[0].ACP_ACCT_DPSTR_NM);
			$('#ACP_ACCT_NO').text(searchDtl[0].ACP_ACCT_NO);
			
			fn_btnSetting();
			
			searchListMake();
			
			$('.txt').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			
			//fn_set_grid();
			
			$("#btn_page, .btn_back").click(function(){
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
				alert("데이터가 없습니다.");
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
					alert(rtnData.RSLT_MSG);
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

			INQ_PARAMS["PARAMS"] = searchDtl[0];
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
		
			function searchListMake(){
				//var rtn_gridList = jsonObject($("#rtn_gridList").val());		
				
				var html = '';
				$.each(searchList, function(i,v){

					if(i > 0){
						html += '<br>';	
					}
					html += '<div class="hgroup"><h3 class="tit">입금내역 '+(i+1)+'</h3></div>';
					html += '<div class="tbl">';
					html += '<table>';
					html += '	<colgroup>';
					html += '		<col style="width: 222px;">';
					html += '		<col style="width: auto;">';
					html += '	</colgroup>';
					html += '	<tbody>';
					html += '		<tr>';
					html += '			<th>입고확인일</th>';
					html += '			<td>'+kora.common.formatter.datetime(v.WRHS_CFM_DT, "yyyy-mm-dd")+'</td>';
					html += '		</tr>';
					html += '		<tr>';
					html += '			<th>생산자</th>';
					html += '			<td>'+v.MFC_BIZRNM+'</td>';
					html += '		</tr>';
					html += '		<tr>';
					html += '			<th>직매장/공장</th>';
					html += '			<td>'+v.MFC_BRCH_NM+'</td>';
					html += '		</tr>';
					html += '		<tr>';
					html += '			<th>입고량</th>';
					html += '			<td>'+kora.common.format_comma(v.WRHS_QTY)+'</td>';
					html += '		</tr>';
					html += '		<tr>';
					html += '			<th>보증금(원)</th>';
					html += '			<td>'+kora.common.format_comma(v.WRHS_GTN)+'</td>';
					html += '		</tr>';
					html += '		<tr>';
					html += '			<th>수수료(원)</th>';
					html += '			<td>'+kora.common.format_comma(v.FEE)+'</td>';
					html += '		</tr>';
					html += '		<tr>';
					html += '			<th>부가세(원)</th>';
					html += '			<td>'+kora.common.format_comma(v.FEE_STAX)+'</td>';
					html += '		</tr>';
					html += '		<tr>';
					html += '			<th>소계(원)</th>';
					html += '			<td>'+kora.common.format_comma(v.TOT)+'</td>';
					html += '		</tr>';
					html += '	</tbody>';
					html += '</table>';
					html += '<br>';
					html += '</div>';
				});
				
				$('#div_01').append(html);
			}

	</script>

	<style type="text/css">
		.row .tit{width: 67px;}
	</style>

</head>
<body>
<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
<input type="hidden" id="searchList" value="<c:out value='${searchList}' />" />
<input type="hidden" id="searchDtl" value="<c:out value='${searchDtl}' />" />
	<div id="wrap">
	
		<%@include file="/jsp/include/header_m.jsp" %>
		
		<%@include file="/jsp/include/aside_m.jsp" %>
			
		<div id="container">

			<div id="subvisual">
				<h2 class="tit" id="title_sub"></h2>
				<a href="#self" class="btn_back"><span class="hide">뒤로가기</span></a>
			</div><!-- id : subvisual -->

			<div id="contents">
				<div class="contbox bdn pb40">
					<div class="tbl">
						<table>
							<colgroup>
								<col style="width: 222px;">
								<col style="width: auto;">
							</colgroup>
							<tbody>
								<tr>
									<th class='txt' id="mtl_txt"></th>
									<td id="WHSDL_BIZRNM"></td>
								</tr>
								<tr>
									<th class='txt' id="bizrno2_txt"></th>
									<td id="WHSDL_BIZRNO"></td>
								</tr>
								<tr>
									<th class='txt' id="rpst_txt"></th>
									<td id="RPST_NM"></td>
								</tr>
								<tr>
									<th class='txt' id="addr_txt"></th>
									<td id="ADDR"></td>
								</tr>
								<tr>
									<th class='txt' id="tel_no2_txt"></th>
									<td id="RPST_TEL_NO"></td>
								</tr>
								<tr>
									<th class='txt' id="pay_amt_txt"></th>
									<td id="PAY_AMT"></td>
								</tr>
								<tr>
									<th class='txt' id="dpstr_txt"></th>
									<td id="ACP_ACCT_DPSTR_NM"></td>
								</tr>
								<tr>
									<th class='txt' id="pay_acct_txt"></th>
									<td id="ACP_ACCT_NO"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				
				<div class="contbox pb80">
					<div id="tableView" class="table_view">
						<div class="slick-wrap">
							<div class="tbl_slide" id="div_01">
							</div>
						</div>
					</div>
					<script>
						newriver.slider.tableVisual();
						newriver.sliderHeight();
					</script>
				</div>
				<div class="btn_wrap mt35">
					<div class="fl_c">
						<a id="btn_page" href="#self" class="btn70 c1" style="width: 220px;">목록</a>
					</div>
				</div>
			</div><!-- id : contents -->

		</div><!-- id : container -->

		<%@include file="/jsp/include/footer_m.jsp" %>
		
	</div><!-- id : wrap -->

</body>
</html>