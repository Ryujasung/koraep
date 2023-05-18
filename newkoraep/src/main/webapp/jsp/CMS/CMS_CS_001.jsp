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
		var URL_CALLBACK;
		$(document).ready(function(){
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			URL_CALLBACK = INQ_PARAMS.URL_CALLBACK;
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
			
			//그리드 셋팅
			fn_set_grid();
			
			$("#btn_page").click(function(){
				fn_page();
			});
			
			$("#btn_sel").click(function(){
				fn_sel();
			});
			
		});
		
		function fn_page(){
			kora.common.goPageB(URL_CALLBACK, INQ_PARAMS);
		}

		
		function fn_check(){
			
			var data = {};
			var row = new Array();
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(item);
			}
			
			data["list"] = JSON.stringify(row);

			var url = "/CE/EPCE0160101422.do";
			document.body.style.cursor = "wait";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_sel');
				} else {
					alertMsg("error");
				}
				document.body.style.cursor = "default";
			});
		} 
		
		/**
		 * 조회
		 */
		function fn_sel(){

			// 수정
			var url = "/CMS/CMSCS001_19.do";
			var input = {};
			
			input['START_DT_SEL'] = $("#START_DT_SEL").val()
			input['END_DT_SEL'] = $("#END_DT_SEL").val()
			input['MENU_CD'] = URL_CALLBACK.substring(4, 15);
	
			//파라미터에 조회조건값 저장 
			INQ_PARAMS["SEL_PARAMS"] = input; 
			
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
		 * 예금주 조회 결과 상세 이동
		 */
		function fn_page2(){
			// 수정
			var idx = dataGrid.getSelectedIndices();
			var input = gridRoot.getItemAt(idx)
				
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/CMS/CMSCS001.do";
			INQ_PARAMS["FIRST_URL"] = URL_CALLBACK;
			kora.common.goPage('/CMS/CMSCS002.do', INQ_PARAMS);
			
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
			 layoutStr.push('	<NumberMaskFormatter id="dateFmt" formatString="###-##-#####"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			 layoutStr.push('<groupedColumns>');
			 //layoutStr.push('	<DataGridSelectorColumn  id="selector" allowMultipleSelection="true" headerText="" width="40" verticalAlign="middle" />');
			 layoutStr.push('	<DataGridColumn dataField="IDX" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" width="50"/>');
			 layoutStr.push('	<DataGridColumn dataField="REG_IDX" width="150" visible="false"/>');
			 layoutStr.push('	<DataGridColumn dataField="REG_DTTM" headerText="'+parent.fn_text('reg_dt3')+'" width="220" itemRenderer="HtmlItem" />');
			 layoutStr.push('	<DataGridColumn dataField="REG_CNT" headerText="'+parent.fn_text('reg_idx')+'" />');
			 layoutStr.push('	<DataGridColumn dataField="AC_CNT"  headerText="'+parent.fn_text('ah_c')+'" />');
			 layoutStr.push('	<DataGridColumn dataField="AM_CNT" headerText="'+parent.fn_text('ah_mis')+'" />');
			 layoutStr.push('	<DataGridColumn dataField="AE_CNT"  headerText="'+parent.fn_text('ah_e')+'" />');
			 layoutStr.push('	<DataGridColumn dataField="AV_CNT"  headerText="'+parent.fn_text('ah_v')+'" />');
			 layoutStr.push('	<DataGridColumn dataField="CE_CNT"  headerText="'+parent.fn_text('ah_ce')+'" />');
			 layoutStr.push('</groupedColumns>');
			 layoutStr.push('<dataProvider>');
			 layoutStr.push('	<SpanArrayCollection extractable="false" source="{$gridData}"/>');
			 layoutStr.push('</dataProvider>');
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
				 	//취약점점검 5967 기원우
				 }else{
					gridApp.setData();
				 }
		     }
		     var selectionChangeHandler = function(event) {
				rowIndex = event.rowIndex;
			 }
		     var dataCompleteHandler = function(event) {
		    	 setSpanAttributes(); // 채광은 추가
		 	 }
		     
		     gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
		// 추가
		 function setSpanAttributes() {
			 var collection; //그리드 데이터 객체
		     if (collection == null)
		         collection = gridRoot.getCollection();
		     if (collection == null) {
		         alertMsg("collection 객체를 찾을 수 없습니다");
		         return;
		     }
		  
		     for (var i = 0; i < collection.getLength(); i++) {
		     	var data = gridRoot.getItemAt(i);

		     	if(data.PAY_STAT_CD == "P"){
		 	        collection.addRowAttributeDetailAt(i, null, "#FFCC00", null, false, 20);
		     	}
		     }
		 }
	</script>

	<style type="text/css">
		.row .tit{width: 82px;}
	</style>

</head>
<body>

	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
	<input type="hidden" id="bizrList" value="<c:out value='${bizrList}' />"/>
	<input type="hidden" id="brchList" value="<c:out value='${brchList}' />"/>
	<input type="hidden" id="whsdlSeCdList" value="<c:out value='${whsdlSeCdList}' />"/>
	<input type="hidden" id="whsdlList" value="<c:out value='${whsdlList}' />"/>
	
	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
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
					<!-- 채광은 추가 -->
					<div class="btn" id="CR">
					</div>
					<!-- 채광은 끝 -->
				</div>
			</div>
		</section>
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:400px;"></div>
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
