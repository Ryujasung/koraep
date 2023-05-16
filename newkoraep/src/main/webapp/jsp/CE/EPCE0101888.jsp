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
			
			fn_btnSetting('EPCE0101888');
			
			parent_item = window.frames[$("#pagedata").val()].parent_item;
			$("#MFC_BIZRNM").text(kora.common.null2void(parent_item.BIZRNM));
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			$('#mfc_bizrnm_txt').text(parent.fn_text('mfc_bizrnm'));
			$('#adj_std_dt_txt').text(parent.fn_text('adj_std_dt'));
			$('#adj_item_txt').text(parent.fn_text('adj_item'));
			$('#adj_amt_txt').text(parent.fn_text('adj_amt'));
			$('#adj_rsn_txt').text(parent.fn_text('adj_rsn'));
			
			//작성체크용
			$('#STD_DT').attr('alt', parent.fn_text('adj_std_dt'));
			$('#ADJ_ITEM').attr('alt', parent.fn_text('adj_item'));
			$('#ADJ_AMT').attr('alt', parent.fn_text('adj_amt'));
			$('#ADJ_RSN').attr('alt', parent.fn_text('adj_rsn'));
			
			//날짜 셋팅
		    $('#STD_DT').YJcalendar({  
				triggerBtn : true
				//,dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
			});

			var adjItemList = jsonObject($('#adjItemList').val());
			kora.common.setEtcCmBx2(adjItemList, "", "", $("#ADJ_ITEM"), "ETC_CD", "ETC_CD_NM", "N", "S");
			
			fn_set_grid();
			
			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});

			$("#btn_init").click(function(){
				fn_init();
			});
			
			/************************************
			 * 날짜  클릭시 - 삭제  변경 이벤트
			 ***********************************/
			$("#STD_DT").click(function(){
				    var dt = $("#STD_DT").val();
				     dt   =  dt.replace(/-/gi, "");
				     $("#STD_DT").val(dt)
			});
			/************************************
			 * 날짜  클릭시 - 추가  변경 이벤트
			 ***********************************/
			$("#STD_DT").change(function(){
			    var dt = $("#STD_DT").val();
			    dt   =  dt.replace(/-/gi, "");
				if(dt.length == 8)  dt = kora.common.formatter.datetime(dt, "yyyy-mm-dd")
			     $("#STD_DT").val(dt) 
			});

		});

		function fn_cnl(){
			window.frames[$("#pagedata").val()].fn_sel();
			$('[layer="close"]').trigger('click');
		}
		
		//저장
		function fn_reg(){

			if(!kora.common.cfrmDivChkValid("params")){
				return;
			 }

			confirm('저장하시겠습니까?', 'fn_reg_exec');
		}
		
		function fn_reg_exec(){
			
			var input = {};
			input['MFC_BIZRID'] = parent_item.BIZRID;
			input['MFC_BIZRNO'] = parent_item.BIZRNO;
			input['STD_DT'] = $("#STD_DT").val().replace(/-/gi, "");
			input['ADJ_ITEM'] = $("#ADJ_ITEM").val();
			input['ADJ_AMT'] = $("#ADJ_AMT").val().replace(/,/gi, "");
			input['ADJ_RSN'] = $("#ADJ_RSN").val();
			input['BAL_SN'] = $("#BAL_SN").val();
			
			var url = "/CE/EPCE0101888_09.do";
			ajaxPost(url, input, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_sel');
				} else {
					alertMsg("error");
				}
			});
			
		}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){
			
			var url = "/CE/EPCE0101888_19.do";
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, parent_item, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.searchList);
				} 
				else {
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
			 layoutStr.push('<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center">'); //liveScrolling="false" showScrollTips="false"
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="false" headerText="'+parent.fn_text('cho')+'" width="10%" verticalAlign="middle" />');
			 layoutStr.push('	<DataGridColumn dataField="STD_DT"  headerText="'+parent.fn_text('adj_std_dt')+'" width="20%"/>');
			 layoutStr.push('	<DataGridColumn dataField="ADJ_AMT"  headerText="'+parent.fn_text('adj_amt')+'" width="20%" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="ADJ_RSN"  headerText="'+parent.fn_text('adj_rsn')+'" width="50%" textAlign="left"/>');
			 layoutStr.push('</columns>');
			 layoutStr.push('</DataGrid>');
			 layoutStr.push('</rMateGrid>');
		}
		
		
		 var editYn = false;
		 var indexData = '';
		
		// 그리드 및 메뉴 리스트 세팅
		 function gridReadyHandler(id) {
		 	 gridApp = document.getElementById(id);  // 그리드를 포함하는 div 객체
		     gridRoot = gridApp.getRoot();   // 데이터와 그리드를 포함하는 객체

		     gridApp.setLayout(layoutStr.join("").toString());
		     gridApp.setData([]);
		     
		     var layoutCompleteHandler = function(event) {
		         dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		         selectorColumn = gridRoot.getObjectById("selector");
		         dataGrid.addEventListener("change", selectionChangeHandler); //이벤트 등록
		         fn_sel();
		     }
		     
		     var selectionChangeHandler = function(event) {
				rowIndex = event.rowIndex;
				selectorColumn.setSelectedIndex(-1);
				selectorColumn.setSelectedIndex(rowIndex);
				fn_rowToInput(rowIndex);
			 }
		     
		     var dataCompleteHandler = function(event) {
		     	//fn_setChkBox();
		 	 }

			 gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);

		 }
		
		 //행선택시 입력값 input에  넣기
		 function fn_rowToInput(rowIndex2) {
			 
			$('#STD_DT_VIEW').attr('style', '');
			$('#STD_DT_EDIT').attr('style', 'display:none');
			 
			var item = gridRoot.getItemAt(rowIndex2);
			
			$("#STD_DT").val(item["STD_DT"]);
			$('#STD_DT_VIEW').text(item["STD_DT"]);
		 	$("#ADJ_ITEM").val(item["ADJ_ITEM"]);
		 	$("#ADJ_AMT").val(item["ADJ_AMT"]);
		 	$("#ADJ_RSN").val(item["ADJ_RSN"]);
		 	$("#BAL_SN").val(item["BAL_SN"]);

		 }
		 
		 function fn_init(){
			 
			selectorColumn.setSelectedIndex(-1);
			dataGrid.setSelectedIndex(-1);
			 
			$('#STD_DT_VIEW').attr('style', 'display:none');
			$('#STD_DT_EDIT').attr('style', '');

			$("#STD_DT").val('');
		 	$("#ADJ_ITEM").val('');
		 	$("#ADJ_AMT").val('');
		 	$("#ADJ_RSN").val('');
		 	$("#BAL_SN").val('');
			 
		 }
		
	</script>

	<style type="text/css">
		.row .tit{width: 67px;}
	</style>

</head>
<body>

<input type="hidden" id="adjItemList" value="<c:out value='${adjItemList}' />"/>

	<div class="layer_popup" style="width:900px;">
	
		<input type="hidden" id="pagedata"/> 
		
			<div class="layer_head">
				<h1 class="layer_title" id="title_sub"></h1>
				<button type="button" class="layer_close" layer="close"></button>
			</div>
			<div class="layer_body">
				<div class="secwrap" id="params">
					<input type="hidden" id="BAL_SN" name="BAL_SN" />
					<div class="srcharea">
						<div class="row">
							<div class="col">
								<div class="tit" id="mfc_bizrnm_txt"></div>
								<div class="boxView" id="MFC_BIZRNM" style="width:139px">
								</div>
							</div>
							<div class="col">
								<div class="tit" id="adj_std_dt_txt"></div>
								<div class="box" id="STD_DT_EDIT">
									<div class="calendar">
										<input type="text" id="STD_DT" name="STD_DT" style="width: 179px;" class="i_notnull">
									</div>
								</div>
								<div class="boxView" id="STD_DT_VIEW" style="display:none">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col">
								<div class="tit" id="adj_item_txt"></div>
								<div class="box">
									<select id="ADJ_ITEM" name="ADJ_ITEM" style="width: 179px;" class="i_notnull">
									</select>
								</div>
							</div>
							<div class="col">
								<div class="tit" id="adj_amt_txt"></div>
								<div class="box">
									<input type="text" id="ADJ_AMT" name="ADJ_AMT" style="width: 179px;" maxLength="13"  class="i_notnull" format="minus">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col">
								<div class="tit" id="adj_rsn_txt"></div>
								<div class="box">
									<input type="text" id="ADJ_RSN" name="ADJ_RSN" style="width: 479px;" maxByteLength="90" class="i_notnull">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="btn" id="CR">
							</div>
						</div>
					</div>
				</div>
				
				<section class="secwrap mt10">
					<div class="boxarea">
						<div id="gridHolder" style="height: 300px;">
						</div>
					</div>
				</section>
				
				<section class="btnwrap mt20" style="" >
					<div class="btn" id="BR" style="float:right">
					</div>
				</section>
				
			</div>
	</div>
</body>
</html>
