<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
	
		var INQ_PARAMS;//파라미터 데이터
	
		$(document).ready(function(){
			
			$('#title_sub').text('<c:out value="${titleSub}" />'); //타이틀
			
			INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
			var mfcBizrList =jsonObject($("#mfcBizrList").val());	
			
			fn_btnSetting();
			
			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});

			//날짜 셋팅
		    $('#START_DT').YJcalendar({  
				toName : 'to',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "F", 0, false).replaceAll('-','')
			});
			$('#END_DT').YJcalendar({
				fromName : 'from',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "L", 0, false).replaceAll('-','')
			});
			
			kora.common.setEtcCmBx2(mfcBizrList, "","", $("#MFC_BIZR_SEL"), "BIZRID_NO", "BIZRNM", "N" ,'S');	

			//그리드 셋팅
			fn_set_grid();
			
			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
			}
			
			$("#btn_sel").click(function(){
				fn_sel();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			$("#btn_cnl").click(function(){
				fn_cnl();
			})

			/************************************
			 * 시작날짜  클릭시 - 삭제  변경 이벤트
			 ***********************************/
			$("#START_DT").click(function(){
				    var start_dt = $("#START_DT").val();
				     start_dt   =  start_dt.replace(/-/gi, "");
				     $("#START_DT").val(start_dt)
			});
			
			/************************************
			 * 시작날짜  클릭시 - 추가  변경 이벤트
			 ***********************************/
			$("#START_DT").change(function(){
			     var start_dt = $("#START_DT").val();
			     start_dt   =  start_dt.replace(/-/gi, "");
				if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
			     $("#START_DT").val(start_dt) 
			});
			
			/************************************
			 * 끝날짜  클릭시 - 삭제  변경 이벤트
			 ***********************************/
			$("#END_DT").click(function(){
				    var end_dt = $("#END_DT").val();
				         end_dt  = end_dt.replace(/-/gi, "");
				     $("#END_DT").val(end_dt)
			});
			
			/************************************
			 * 끝날짜  클릭시 - 추가  변경 이벤트
			 ***********************************/
			$("#END_DT").change(function(){
			     var end_dt  = $("#END_DT").val();
			           end_dt =  end_dt.replace(/-/gi, "");
				if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd")
			     $("#END_DT").val(end_dt) 
			});
			
		});
		
		function fn_cnl(){
			kora.common.goPageB('', INQ_PARAMS);
		}
		
		//저장
		function fn_reg(){
			
			var collection = gridRoot.getCollection();
			if(collection.getLength() < 1 || INQ_PARAMS["PARAMS"] == undefined){
				alertMsg("먼저 데이터를 조회해야 합니다.");
				return;
			}
			
			confirm('정산요청 하시겠습니까?', 'fn_reg_exec');
		}
		
		function fn_reg_exec(){
			
			var input = {};
			input = INQ_PARAMS["PARAMS"];
			//input['MFC_BIZR_SEL'] = $("#MFC_BIZR_SEL option:selected").val();
			//input['START_DT'] = $("#START_DT").val().replace(/-/gi, "");
			//input['END_DT'] = $("#END_DT").val().replace(/-/gi, "");
			
		 	var url = "/CE/EPCE4792931_09.do";
		 	ajaxPost(url, input, function(rtnData){
			 	if ("" != rtnData && null != rtnData) {
			 		if(rtnData.RSLT_CD == '0000'){
						alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
				} else {
					alertMsg("error");
				}
		 	});
		}
		
		function fn_page(){
			var idx = dataGrid.getSelectedIndices();
			var input = gridRoot.getItemAt(idx);

			//파라미터에 조회조건값 저장 
			INQ_PARAMS["SEL_PARAMS"] = INQ_PARAMS["PARAMS"];
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK2" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE4792931.do";
			kora.common.goPage('/CE/EPCE47929644.do', INQ_PARAMS);
		}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){

			if($("#MFC_BIZR_SEL option:selected").val() == ''){
				alertMsg('생산자선택은 필수입니다.');
				return;
			}
			
			var input = {};
			input['MFC_BIZR_SEL'] = $("#MFC_BIZR_SEL option:selected").val();
			input['START_DT'] = $("#START_DT").val().replace(/-/gi, "");
			input['END_DT'] = $("#END_DT").val().replace(/-/gi, "");
			
			//파라미터에 조회조건값 저장 
			INQ_PARAMS["PARAMS"] = input;
			
			var url = "/CE/EPCE4792931_19.do";
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
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
			 layoutStr.push('	<DataGridColumn dataField="REQ_BIZRNM" headerText="'+parent.fn_text('exca_req_mfc')+'" width="200" />');
			 layoutStr.push('	<DataGridColumn dataField="TRGT_BIZRNM_PAGE" headerText="'+parent.fn_text('exca_trgt_mfc')+'" width="200" itemRenderer="HtmlItem" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_DLIVY_QTY" id="sum1" headerText="'+parent.fn_text('exch_dlivy_qty')+'" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_DLIVY_GTN" id="sum2" headerText="'+parent.fn_text('exch_dlivy_gtn')+'" width="140" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_WRHS_QTY" id="sum3" headerText="'+parent.fn_text('exch_wrhs_qty')+'" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCH_WRHS_GTN" id="sum4" headerText="'+parent.fn_text('exch_wrhs_gtn')+'" width="140" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="SF_AMT" id="sum5" headerText="'+parent.fn_text('sf_amt')+'" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="STD_YEAR" headerText="'+parent.fn_text('std_year')+'" width="100" />');
			 layoutStr.push('</groupedColumns>');
			 layoutStr.push('		<footers>');
			 layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('				<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
			 layoutStr.push('				<DataGridFooterColumn/>');
			 layoutStr.push('				<DataGridFooterColumn/>');
			 layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum3}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum4}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum5}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('				<DataGridFooterColumn/>');
			 layoutStr.push('			</DataGridFooter>');
			 layoutStr.push('		</footers>');
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
				 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK2) != ""){
				 	/* eval(INQ_PARAMS.FN_CALLBACK2+"()"); */
				 	 window[INQ_PARAMS.FN_CALLBACK2]();
				 	//취약점점검 5934 기원우
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
		.row .tit{width: 67px;}
	</style>
</head>
<body>
	<div class="iframe_inner">
		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
		<input type="hidden" id="mfcBizrList" value="<c:out value='${mfcBizrList}' />" />
		
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
			<div class="btn_box">
			</div>
		</div>
		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">
					<div class="col">
						<div class="tit" id="mfc_bizrnm_txt"></div>
						<div class="box">						
							<select id="MFC_BIZR_SEL" name="MFC_BIZR_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="col" >
							<div class="tit" id="sel_term_exch_cfm_txt" style="width:160px"></div>
							<div class="box">
								<div class="calendar">
									<input type="text" id="START_DT" name="from" style="width: 130px;" class="i_notnull" >
								</div>
								<div class="obj" >~</div>
								<div class="calendar">
									<input type="text" id="END_DT" name="to" style="width: 130px;" class="i_notnull" >
								</div>
							</div>
						</div>
					<div class="btn" id="CR">
					</div>
				</div>
			</div>
		</section>

			<div class="boxarea mt10">
				<div id="gridHolder" style="height:430px;"></div>
			</div>
			
			<div class="h4group mt10" >
				<h5 class="tit"  style="font-size: 16px;">
					&nbsp;&nbsp;※ 교환 확인이 완료된 내역에 대해서만 조회 가능합니다.<br/>
					&nbsp;&nbsp;※ 정산요청 이후 교환 내역에 대한 정보 변경이 불가합니다. 확인 완료 후 정산요청 진행 바랍니다.
				</h5>
			</div>
			

	
		<section class="btnwrap" >
			<div class="fl_l" id="BL">
			</div>
			<div class="fl_r" id="BR">
			</div>
		</section>
		
	</div>
	
</body>
</html>
