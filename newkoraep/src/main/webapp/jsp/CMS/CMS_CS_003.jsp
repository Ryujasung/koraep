<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">

		var IS_ACCT = true;	// 실계좌
		var acctList;
		
		$(document).ready(function(){
			acctList = jsonObject($("#acctNoList").val());	//계좌목록

			fn_btnSetting();

			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			
			//날짜 셋팅
			$('#START_DT_SEL').YJcalendar({
				toName : 'to',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
			});
			$('#END_DT_SEL').YJcalendar({
				fromName : 'from',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
			});
			
			kora.common.setEtcCmBx2(acctList, "", "", $("#ACCT_NO_LIST"), "ACCT_CD", "ACCT_NM", "N", "");
			
			//잔액계좌명 셋팅
			$.each($(".accInfo .row .col .tit"), function(i,v){
				$(v).text(acctList[i].ACCT_NM);
			});
			
			//그리드 셋팅
			fn_set_grid();
			
			$("#btn_sel").click(function(){
				fn_sel();
			});
			
			// 인쇄
			$("#btn_pnt").click(function(){
				fn_pnt();
			});

			// 엑셀저장
			$("#btn_excel").click(function(){
				fn_excel();
			});

			$("#ACCT_NO_LIST").click(function(){
				var acctCd = $("#ACCT_NO_LIST option:selected").val()
				if(acctCd.charAt(0) === '2') {
					IS_ACCT = false;
				} else {
					IS_ACCT = true;
				}
			});
			
			$("#ACCT_NO_LIST").trigger("click");

		});
		
		/**
		 * 잔액조회
		 */
		function fn_balChk(){
			fn_clearBalance();
			
			var url = "/CMS/CMSCS003_02.do";
			var input = {};
			
			input['END_DT_SEL'] = $("#END_DT_SEL").val();
			
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null ) {
					$.each(rtnData.searchList, function(i, result) {
						$(".balance").eq(i).text(kora.common.format_comma(result.TX_CUR_BAL));
					});
					
				}

			}, false);
		}
		
		/**
		 * 잔액초기화
		 */
		function fn_clearBalance() {
			$(".balance").text("");
		}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){
			fn_balChk();
			var url = "/CMS/CMSCS003_01.do";
			var input = {};
			var stat = $("#STAT_SEL option:selected").val();
			
			input['START_DT_SEL'] = $("#START_DT_SEL").val();
			input['END_DT_SEL'] = $("#END_DT_SEL").val();
			input['ACCT_NO'] = $("#ACCT_NO_LIST option:selected").val();
			
			if(IS_ACCT) {
				input['ACCT_SEL'] = '02';
				input['INOUT'] = stat;								// 실계좌 - 1:출금, 2:입금 
			} else {
				input['ACCT_SEL'] = '01';
				input['INOUT'] = (stat == "") ? stat : stat - 1;	// 가상계좌 - 0:지급, 1:입금
			}
			
			//파라미터에 조회조건값 저장 
			INQ_PARAMS["SEL_PARAMS"] = input; 
			
			kora.common.showLoadingBar(dataGrid, gridRoot); // 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.searchList);
				} else {
					alertMsg("error");
				}
				kora.common.hideLoadingBar(dataGrid, gridRoot);	// 그리드 loading bar off
			});
		}
		
		 //인쇄
	    function fn_pnt(){
			
			var stat = $("#STAT_SEL option:selected").val();
			
			if(IS_ACCT) {
				$("#CRF_NAME").val("거래내역조회_실계좌.crf");
				$('input[name="PRT_INOUT"]').val(stat);
			} else {
				$("#CRF_NAME").val("거래내역조회_가상계좌.crf");
				$('input[name="PRT_INOUT"]').val(stat == "" ? stat : stat - 1);
			}
			
			$('input[name="PRT_START_DT"]').val($("#START_DT_SEL").val());
			$('input[name="PRT_END_DT"  ]').val($("#END_DT_SEL").val());
			$('input[name="PRT_ACCT_NO"]').val($("#ACCT_NO_LIST option:selected").val());
			
			kora.common.gfn_viewReport('prtForm', '');
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
					item['dataField'] = columns[i].getDataField();
					item['textAlign'] = columns[i].getStyle('textAlign');
					item['id'] = kora.common.null2void(columns[i].id);
					
					col.push(item);
				}
			}
			
			var input = INQ_PARAMS["SEL_PARAMS"];
			input['fileName'] = fileName;
			input['columns'] = JSON.stringify(col);
			
			var url = "/CMS/CMSCS003_03.do";
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
			layoutStr.push('<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr.push('<DateFormatter id="datefmt" formatString="YYYY-MM-DD"/>');
			layoutStr.push('<NumberMaskFormatter id="timefmt" formatString="##:##:##"/>');
			layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			layoutStr.push('<groupedColumns>');
			layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" width="50"/>');
			layoutStr.push('	<DataGridColumn dataField="TR_DT"  headerText="'+parent.fn_text('tr_dt')+'" defaultWidth="140" formatter="{datefmt}" />');
			layoutStr.push('	<DataGridColumn dataField="TR_TM" headerText="'+parent.fn_text('tr_tm')+'" defaultWidth="140" formatter="{timefmt}" />');
			layoutStr.push('	<DataGridColumn dataField="BANK_NM" headerText="'+parent.fn_text('bank')+'" defaultWidth="80" />');
			layoutStr.push('	<DataGridColumn dataField="ACCT_NO" headerText="'+parent.fn_text('vacct_no')+'" defaultWidth="200" />');
			layoutStr.push('	<DataGridColumn dataField="INOUT" headerText="'+parent.fn_text('stat')+'" defaultWidth="80" />');
			layoutStr.push('	<DataGridColumn dataField="TR_AMT" id="sum" headerText="'+parent.fn_text('amt')+'" defaultWidth="150" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('	<DataGridColumn dataField="SHOW_NM" headerText="'+parent.fn_text('dpstr')+'" defaultWidth="200" />');
			layoutStr.push('	<DataGridColumn dataField="JEOKYO" headerText="'+parent.fn_text('smr')+'" defaultWidth="200" />');
			layoutStr.push('</groupedColumns>');
			layoutStr.push('	<footers>');
			layoutStr.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
			layoutStr.push('			<DataGridFooterColumn/>');
			layoutStr.push('			<DataGridFooterColumn/>');
			layoutStr.push('			<DataGridFooterColumn/>');
			layoutStr.push('			<DataGridFooterColumn/>');
			layoutStr.push('			<DataGridFooterColumn/>');
			layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum}" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('			<DataGridFooterColumn/>');
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
		
				//파라미터 call back function 실행
				if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
					/* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
				 	 window[INQ_PARAMS.FN_CALLBACK]();
				 	//취약점점검 5969 기원우
				}else{
					gridApp.setData();
				}
		    }
		    var selectionChangeHandler = function(event) {
				rowIndex = event.rowIndex;
		 	}
			var dataCompleteHandler = function(event) {}
			
			gridRoot.addEventListener("dataComplete", dataCompleteHandler);
			gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		}
	</script>

	<style type="text/css">
		.row .tit{width: 77px;}
 		.accInfo .row .col{width: 400px;}
 		.accInfo .row .tit{width: 140px;}
 		.accInfo .row .box .balance {width:150px;text-align:right;} 
 		.accInfo .row .box .obj {font-size:14px;height:36px;}
	</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="acctNoList" value="<c:out value='${acctNoList}' />"/>

	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn_box" id="UR"></div>
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
								<input type="text" id="END_DT_SEL" name="to" style="width: 140px;" ><!-- 끝날짜 -->
							</div>
						</div>
					</div>
					
					<div class="col">
						<div class="tit" id="acct_se_txt"></div>
						<div class="box " >
							<select id="ACCT_NO_LIST" style="width: 179px;"></select>
						</div>
					</div>
					
					<div class="col">
						<div class="tit" id="deal_se_txt"></div>
						<div class="box">
							<select id="STAT_SEL" style="width: 179px;">
								<option value="">전체</option>
								<option value="2">입금</option>
								<option value="1">출금</option>
							</select>
						</div>
					</div>
					
					<div class="btn" id="CR"></div>

				</div>
			</div>
		</section>
		
		<section class="secwrap mt10" >
			<div class="srcharea accInfo" >
				<div class="row">
					<div class="col" >
						<div class="tit" id=""></div>
						<div class="box">
							<div class="obj balance"></div><div class="obj">원</div>
						</div>
					</div>
					<div class="col" >
						<div class="tit" id=""></div>
						<div class="box">
							<div class="obj balance"></div><div class="obj">원</div>
						</div>
					</div>
					<div class="col" >
						<div class="tit" id=""></div>
						<div class="box">
							<div class="obj balance"></div><div class="obj">원</div>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col" >
						<div class="tit" id=""></div>
						<div class="box">
							<div class="obj balance"></div><div class="obj">원</div>
						</div>
					</div>
					<div class="col" >
						<div class="tit" id=""></div>
						<div class="box">
							<div class="obj balance"></div><div class="obj">원</div>
						</div>
					</div>
					<div class="col" >
						<div class="tit" id=""></div>
						<div class="box">
							<div class="obj balance"></div><div class="obj">원</div>
						</div>
					</div>
				</div>

			</div>
		</section> 
			
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:500px;"></div>
			</div>
		</section>

		<section class="btnwrap mt20" >
			<div class="fl_l" id="BL">
			</div>
			<div class="fl_r" id="BR">
			</div>
		</section>

	</div>
	
	<form name="prtForm" id="prtForm">
		<!-- 필수 -->
		<input type="hidden" id="CRF_NAME" name="CRF_NAME" value="거래내역조회_실계좌.crf" />
		<!-- 파라메타 -->
		<input type="hidden" id="PRT_START_DT" name="PRT_START_DT" value="" />
		<input type="hidden" id="PRT_END_DT" name="PRT_END_DT" value="" />
		<input type="hidden" id="PRT_ACCT_NO" name="PRT_ACCT_NO" value="" />
		<input type="hidden" id="PRT_INOUT" name="PRT_INOUT" value="" />
		<input type="hidden" name="USER_NM" id="USER_NM" value="${ssUserNm}"/>
		<input type="hidden" name="BSNM_NM" id="BSNM_NM" value="${ssBizrNm}"/>
	</form>

	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="excel" />
	</form>
</body>
</html>
