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

	<script type="text/javaScript" language="javascript" defer="defer">
		
		var INQ_PARAMS;
		var ahRltNmList;
		var searchList;
		
		$(document).ready(function(){
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			ahRltNmList = jsonObject($("#ahRltNmList").val());	//이체실행상태
			searchList = jsonObject($("#searchList").val());
			fn_btnSetting();

			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			
			kora.common.setEtcCmBx2(ahRltNmList, "", "", $("#AH_RLT_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			
			//조회구분 셋팅
			rdoGrid(ahRltNmList);

			//그리드 셋팅
			fn_set_grid();
			
			//취소
			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			//실행여부 변경
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			//조회조건 변경 시마다 조회
			$("input[name='AH_RLT_CD_SEL']").click(function() {
				fn_sel();
			})
		});

		function fn_cnl(){
			INQ_PARAMS["URL_CALLBACK"] = INQ_PARAMS["FIRST_URL"];
			kora.common.goPageB('', INQ_PARAMS);
		}
			
		// 실행여부 변경 저장
		function fn_reg(){
				
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}

			confirm('이체실행상태를 이체실행으로 변경하시겠습니까?', "fn_reg_exec");
		}
		
		function fn_reg_exec(){

			var data = {};
			var row = new Array();
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				
				if(item.AH_RLT_MSG == '해당계좌 없음' ){
					alertMsg("'해당계좌 없음'이 포함되어 있어 상태변경을 할 수 없습니다.");
					return;
				}
				
			/* 	if(item.AH_RLT_CD != 'AM') {
					alertMsg("예금주불일치인 항목만 이체실행상태변경이 가능합니다.");	
					return;
				} */
				row.push(item);
			}
			data["list"] = JSON.stringify(row);

			document.body.style.cursor = "wait";
			kora.common.showLoadingBar(dataGrid, gridRoot)
			var url = "/CMS/CMSCS002_03.do";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					if(rtnData.RSLT_CD == '0000'){
						alertMsg(rtnData.RSLT_MSG, 'fn_sel');
	 				}else{
	 					alertMsg(rtnData.RSLT_MSG);
	 				}
				} else {
					alertMsg("error");
				}
				kora.common.hideLoadingBar(dataGrid, gridRoot);
				document.body.style.cursor = "default";
			});
		}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){
			var url = "/CMS/CMSCS002_01.do";
			var input = {};
			
			input["AH_RLT_CD_SEL"] = $("input[name='AH_RLT_CD_SEL']:checked").val();
			input['REG_IDX'] = INQ_PARAMS.PARAMS['REG_IDX'];
	
			//파라미터에 조회조건값 저장 
			INQ_PARAMS["SEL_PARAMS"] = input;
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.searchList);
					fn_setCountData(rtnData.countList[0]);
				} else {
					alertMsg("error");
				}
				kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
			});
			
		}
		
		/**
		 * 건수 출력
		 */
		function fn_setCountData(countList) {
			$("#regCnt").text(countList["REG_CNT"]);
			$("#amCnt").text(countList["AM_CNT"]);
			$("#acCnt").text(countList["AC_CNT"]);
			$("#aeCnt").text(countList["AE_CNT"]);
			$("#avCnt").text(countList["AV_CNT"]);
			$("#ceCnt").text(countList["CE_CNT"]);
		}
		
		/**
		 * 라디오 그리기
		 */
		function rdoGrid(data) {
			var html='<label class="rdo"><input type="radio" name="AH_RLT_CD_SEL" value="" checked="checked"><span id="">전체</span></label>';
			$.each(data,function(i){
				html += '<label class="rdo"><input type="radio" name="AH_RLT_CD_SEL" value="'+data[i].ETC_CD+'"><span>'+data[i].ETC_CD_NM+'</span></label>';
			});
			$(".box").append(html);
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
			 layoutStr.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="true" headerText="" width="40" verticalAlign="middle" />');
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" width="50"/>');
			 layoutStr.push('	<DataGridColumn dataField="ACP_BANK_NM" headerText="'+parent.fn_text('rcpt_bank')+'" width="140" />');
			 layoutStr.push('	<DataGridColumn dataField="ACP_ACCT_NO" headerText="'+parent.fn_text('rcpt_vacct_no')+'" />');
			 layoutStr.push('	<DataGridColumn dataField="ACP_ACCT_DPSTR_NM" headerText="'+parent.fn_text('acp_acct_dpstr_nm')+'"/>');
			 layoutStr.push('	<DataGridColumn dataField="SEL_AH_DPSTR_NM" headerText="'+parent.fn_text('sel_ah_dpstr_nm')+'"/>');
			 layoutStr.push('	<DataGridColumn dataField="AH_RLT_NM" headerText="'+parent.fn_text('ah_rlt_nm')+'" width="140" />');
			 layoutStr.push('	<DataGridColumn dataField="TX_EXEC_NM"  headerText="'+parent.fn_text('tx_exec_nm')+'" width="140"/>');
			 layoutStr.push('	<DataGridColumn dataField="AH_RLT_MSG" headerText="'+parent.fn_text('err_msg')+'" width="220" />');
			 layoutStr.push('</groupedColumns>');
			 layoutStr.push('		<dataProvider>');
			 layoutStr.push('			<SpanArrayCollection extractable="false" source="{$gridData}"/>');
			 layoutStr.push('		</dataProvider>');
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

		         //파라미터 call back function 실행
				 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
				 	eval(INQ_PARAMS.FN_CALLBACK+"()");
				 }else{
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
		.row .tit{width: 82px;}
	</style>

</head>
<body>

	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
	<input type="hidden" id="ahRltNmList" value="<c:out value='${ahRltNmList}' />"/>
	<input type="hidden" id="searchList" value="<c:out value='${searchList}' />"/>
    
	<div class="iframe_inner">
 		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
            <div class="btn_box" id="UR">
            </div>
		</div>

		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">

					<div class="col">
						<div class="tit" id="sel_se_txt" style=""></div>
						<div class="box"></div>
					</div>
					
				</div>
			</div>
		</section>
		
		<section class="secwrap2 mt15">
			<div class="boxarea">
				<div class="info_tbl">
					<table>
						<thead>
							<tr>
								<th class="b">전체</th>
								<th class="b"><span id="regCnt"></span>건</th>
								<th>일치</th>
								<th><span id="acCnt"></span>건</th>
								<th>불일치</th>
								<th><span id="amCnt"></span>건</th>
								<th>오류</th>
								<th><span id="aeCnt"></span>건</th>
								<th>확인요망</th>
								<th><span id="avCnt"></span>건</th>
								<th>연결실패</th>
								<th><span id="ceCnt"></span>건</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</section>
		
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:430px;"></div>
			</div>
		</section>

		<section class="btnwrap mt20" >
			<div class="fl_l" id="BL">
			</div>
			<div class="fl_r" id="BR">
			</div>
		</section>
		
	</div>
    		
</body>
</html>
