<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
		
		var INQ_PARAMS;
	
		$(document).ready(function(){
			
			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			
			fn_btnSetting();

			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			
			//날짜 셋팅
		    $('#START_DT_SEL').YJcalendar({  
				toName : 'to',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
			});
			$('#END_DT_SEL').YJcalendar({
				fromName : 'from',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
			});
			
			var bizrList = jsonObject($('#bizrList').val());
			kora.common.setEtcCmBx2(bizrList, "", "", $("#MFC_BIZR_SEL"), "BIZRID_NO", "BIZRNM", "N", "T");

			var billSeCdList = jsonObject($('#billSeCdList').val());
			$.each(billSeCdList, function(i){
				$('#BILL_SE_CD_DIV').append('<label class="chk"><input type="checkbox" checked id="BILL_SE_CD_SEL" name="BILL_SE_CD_SEL" value="'+billSeCdList[i].ETC_CD+'"><span>'+billSeCdList[i].ETC_CD_NM+'</span></label>');
			});
			
			var issuStatCdList = jsonObject($('#issuStatCdList').val());
			$.each(issuStatCdList, function(i){
				$('#ISSU_STAT_CD_DIV').append('<label class="chk"><input type="checkbox" checked id="ISSU_STAT_CD_SEL" name="ISSU_STAT_CD_SEL" value="'+issuStatCdList[i].ETC_CD+'"><span>'+issuStatCdList[i].ETC_CD_NM+'</span></label>');
			});
			
			kora.common.getComboYearDesc($("#STD_YEAR_SEL"), "2016", "2015");
			
			
						
			//그리드 셋팅
			fn_set_grid();
			
			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS_I) != ""){
				kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS_I);
				
				$('input:checkbox[name="BILL_SE_CD_SEL"]').each(function(){
					this.checked = false;
				});
				
				$('input:checkbox[name="ISSU_STAT_CD_SEL"]').each(function(){
					this.checked = false;
				});
				
				$.each(INQ_PARAMS.SEL_PARAMS_I.BILL_SE_CD_SEL, function(i, v){
					$('input:checkbox[name="BILL_SE_CD_SEL"]:checkbox[value="'+v+'"]').prop("checked", true);
				});
				
				$.each(INQ_PARAMS.SEL_PARAMS_I.ISSU_STAT_CD_SEL, function(i, v){
					$('input:checkbox[name="ISSU_STAT_CD_SEL"]:checkbox[value="'+v+'"]').prop("checked", true);
				});
			}
			
			$("#btn_sel").click(function(){
				fn_sel();
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
			
			if(INQ_PARAMS["SEL_PARAMS_I"] == undefined){
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
					
					if(columns[i].getDataField() == 'BILL_ISSU_DT_PAGE'){// html 태크 사용중 컬럼은 대체
						item['dataField'] = 'BILL_ISSU_DT';
					}else{
						item['dataField'] = columns[i].getDataField();
					}
					
					item['textAlign'] = columns[i].getStyle('textAlign');
					item['id'] = kora.common.null2void(columns[i].id);
					
					col.push(item);
				}
			}
			
			var input = INQ_PARAMS["SEL_PARAMS_I"];
			input['fileName'] = fileName;
			input['columns'] = JSON.stringify(col);
			
			var url = "/CE/EPCE2393001_05.do";
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
		
		//상세화면 이동
		function fn_page(){

			var idx = dataGrid.getSelectedIndices();
			var input = gridRoot.getItemAt(idx);
			
			var url = '';
			if(input.BILL_SE_CD == 'G'){ //보증금
				url = '/CE/EPCE2393064.do';
			}else if(input.BILL_SE_CD == 'F'){ //취급수수료
				url = '/CE/EPCE23930642.do';
			}else if(input.BILL_SE_CD == 'M'){ //보증금(조정)
				url = '/CE/EPCE23930643.do';
			}
			
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE2393001.do";
			kora.common.goPage(url, INQ_PARAMS);
		}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){
			
			var billSeCdSel = new Array();
			$('input:checkbox[name="BILL_SE_CD_SEL"]').each(function(){
			      if(this.checked){
			    	  billSeCdSel.push(this.value);
			      }
			});
			
			var issuStatCdSel = new Array();
			$('input:checkbox[name="ISSU_STAT_CD_SEL"]').each(function(){
			      if(this.checked){
			    	  issuStatCdSel.push(this.value);
			      }
			});
			
			
			var input = {};
			input['START_DT_SEL'] = $("#START_DT_SEL").val();
			input['END_DT_SEL'] = $("#END_DT_SEL").val();
			input['MFC_BIZR_SEL'] = $("#MFC_BIZR_SEL option:selected").val();
            input['STD_YEAR_SEL'] = $("#STD_YEAR_SEL option:selected").val();
			input['BILL_SE_CD_SEL'] = JSON.stringify(billSeCdSel);
			input['ISSU_STAT_CD_SEL'] = JSON.stringify(issuStatCdSel);
	
			//파라미터에 조회조건값 저장 
			INQ_PARAMS["SEL_PARAMS_I"] = input; 
			
			var url = "/CE/EPCE2393001_19.do";
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.searchList);
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
			 layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			 layoutStr.push('<groupedColumns>');
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" width="50"/>');
			 layoutStr.push('	<DataGridColumn dataField="BILL_ISSU_DT_PAGE"  headerText="'+parent.fn_text('issu_dt')+'" width="110" itemRenderer="HtmlItem" />');
			 layoutStr.push('	<DataGridColumn dataField="BILL_SE_NM"  headerText="'+parent.fn_text('se')+'" width="120"/>');
			 layoutStr.push('	<DataGridColumn dataField="ISSU_STAT_NM"  headerText="'+parent.fn_text('stat')+'" width="130"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150" />');
			 layoutStr.push('	<DataGridColumn dataField="BANK_NM"  headerText="'+parent.fn_text('bank')+'" width="150" />');
			 layoutStr.push('	<DataGridColumn dataField="VACCT_NO"  headerText="'+parent.fn_text('vr_vacct_no')+'" width="130" />');
			 layoutStr.push('	<DataGridColumn dataField="NOTY_AMT" id="sum1" headerText="'+parent.fn_text('noty_amt')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="ADD_GTN" id="sum2" headerText="'+parent.fn_text('adit_gtn')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="FEE_PAY_GTN" id="sum3" headerText="'+parent.fn_text('pay_plan_gtn')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
             layoutStr.push('   <DataGridColumn dataField="STD_YEAR" headerText="'+parent.fn_text('std_year')+'" width="80" />');
			 layoutStr.push('</groupedColumns>');
			 layoutStr.push('	<footers>');
			 layoutStr.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum3}" formatter="{numfmt}" textAlign="right" />');
             layoutStr.push('           <DataGridFooterColumn/>');
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
		 	 }
		     
		     gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
		
	</script>

	<style type="text/css">
		.row .tit{width: 77px;}
	</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="bizrList" value="<c:out value='${bizrList}' />"/>
<input type="hidden" id="billSeCdList" value="<c:out value='${billSeCdList}' />"/>
<input type="hidden" id="issuStatCdList" value="<c:out value='${issuStatCdList}' />"/>

	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn" style="float:right" id="UR"></div>
		</div>
		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">
					<div class="col">
						<div class="tit" id="sel_term_txt"></div>
						<div class="box">		
							<div class="calendar">
								<input type="text" id="START_DT_SEL" name="from" style="width: 140px;" ><!--시작날짜  -->
							</div>
							<div class="obj">~</div>
							<div class="calendar">
								<input type="text" id="END_DT_SEL" name="to" style="width: 140px;"	><!-- 끝날짜 -->
							</div>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="mfc_bizrnm_txt" style=""></div>
						<div class="box">
							<select id="MFC_BIZR_SEL" name="MFC_BIZR_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
                    <div class="col">
                        <div class="tit" id="std_year_txt" style=""></div>
                        <div class="box">
                            <select id="STD_YEAR_SEL" name="STD_YEAR_SEL" style="width: 89px;">
                                <option value="" selected>전체</option>
                            </select>
                        </div>
                    </div>
				</div>
				<div class="row">
					<div class="col" style="width:407px">
						<div class="tit" id="se_txt"></div>
						<div class="box" id="BILL_SE_CD_DIV">	
						</div>
					</div>
					<div class="col">
						<div class="tit" id="stat_txt" style=""></div>
						<div class="box" id="ISSU_STAT_CD_DIV">
						</div>
					</div>
					<div class="btn" id="CR">
					</div>
				</div>
			</div>
		</section>
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:418px;"></div>
			</div>
		</section>
	
		<section class="btnwrap mt20" >
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
