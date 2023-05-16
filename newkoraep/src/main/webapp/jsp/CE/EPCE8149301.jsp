<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">

	var INQ_PARAMS; //파라미터 데이터
	
	var layoutStr = new Array(); 

	layoutStr.push('<rMateGrid>');
	layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
	layoutStr.push('	<NumberFormatter id="numfmt1" precision="2" useThousandsSeparator="true"/>');
	layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" selectionMode="singleRow" sortableColumns="true" headerHeight="35">');
	layoutStr.push('	<columns>');
	layoutStr.push('		<DataGridSelectorColumn id="selector" width="30" textAlign="center" allowMultipleSelection="false" headerText="선택"/>');
	layoutStr.push('	<DataGridColumn dataField="POP_SEQ" headerText="순번" textAlign="center" width="30" />');
	layoutStr.push('		<DataGridColumn dataField="SBJ" headerText="제목" width="300"  />');
	layoutStr.push('		<DataGridColumn dataField="VIEW_ST_DATE" headerText="노출시작일" textAlign="center" width="120" />');
	layoutStr.push('		<DataGridColumn dataField="VIEW_END_DATE" headerText="노출종료일" textAlign="center" width="120" />');
	layoutStr.push('		<DataGridColumn dataField="USE_YN" headerText="사용여부" textAlign="center" width="80" />');
	layoutStr.push('		<DataGridColumn dataField="PRE_VIEW" headerText="미리보기" textAlign="center" width="80"  itemRenderer="HtmlItem" />');
	layoutStr.push('		<DataGridColumn dataField="CNTN_SE_NM" visible="false"/>');
	layoutStr.push('		<DataGridColumn dataField="CNTN_SE" visible="false"/>');
	layoutStr.push('		<DataGridColumn dataField="CNTN_IMG_FILE_NM" visible="false"/>');
	layoutStr.push('		<DataGridColumn dataField="POP_WID" visible="false"/>');
	layoutStr.push('		<DataGridColumn dataField="POP_HGT" visible="false"/>');
	layoutStr.push('		<DataGridColumn dataField="VIEW_LC_TOP" visible="false"/>');
	layoutStr.push('		<DataGridColumn dataField="VIEW_LC_LFT" visible="false"/>');
	layoutStr.push('	</columns>');
	layoutStr.push('	</DataGrid>');
	layoutStr.push('</rMateGrid>');

	var gridApp, gridRoot, dataGrid, selectorColumn;
	var rowIndex = -1;		//선택된 로우 index
	var list;

	$(document).ready(function(){
		
		INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
		list = jsonObject($("#init_list").val());
		
		//버튼 셋팅
	    fn_btnSetting();
		
	/* 	var msg = "<c:out value='${message}' />'";		//저장 및 수정 후 처리 메세지
		if(msg != null && msg != ""){
			console.log(msg)
			alertMsg(msg);
		} */
		
		for(var i=0; i<list.length; i++){
			var map = list[i];
			map["PRE_VIEW"] = '<a href="javascript:fn_prvw()" class="gridLink">미리보기</a>';
			list[i] = map;
		}
		
		var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
		rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%");	//그리드 생성
		
		$("#btn_reg").click(function(){
			fn_reg();	//등록
		});
		
		$("#btn_upd").click(function(){
			fn_upd();	//수정
		});
		
		$("#btn_del").click(function(){
			fn_del();	//삭제
		});
		
		$("#btn_use_stop").click(function(){
			fn_use_stop();	//사용중지
		});
		
		
	});


	function gridReadyHandler(id) {
		gridApp = document.getElementById(id);  // 그리드를 포함하는 div 객체
		gridRoot = gridApp.getRoot();   // 데이터와 그리드를 포함하는 객체
		
		gridApp.setLayout(layoutStr.join("").toString());
		gridApp.setData(list);
		
		var layoutCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		}
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	 
		var dataCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid();
			dataGrid.addEventListener("change", selectionChangeHandler);
			collection = gridRoot.getCollection();
		}

		var selectionChangeHandler = function(event) {

			rowIndex = event.rowIndex;
			if(rowIndex < 0){
				$("#POP_SEQ").val("");
			}else{
				var selectorColumn = gridRoot.getObjectById("selector");
				selectorColumn.setSelectedIndex(-1);
				selectorColumn.setSelectedIndex(rowIndex);
				
				var data = gridRoot.getItemAt(rowIndex);
				$("#POP_SEQ").val(data.POP_SEQ);
			}
		};
		 
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
	}

	var popWin;
	//미리보기
	function fn_prvw(){
		
		if(popWin) popWin.close();
		
		var idx = dataGrid.getSelectedIndices();
		var sData = gridRoot.getItemAt(idx);
		
		var w = sData.POP_WID;
		var h = sData.POP_HGT;
		var top = sData.VIEW_LC_TOP;
		var left = sData.VIEW_LC_LFT;
		
		popWin = window.open("/jsp/mngPopup.jsp?POP_SEQ=" + sData.POP_SEQ, "popPreView", 'width=' + w + ', height=' + h + ', left=' + left + ', top=' + top + ', resizable=1, location=0, toolbar=0');
		//window.open("/jsp/mngPopup.jsp?POP_SEQ=" + sData.POP_SEQ, popNm, 'width=' + w + ', height=' + h + ', left=' + left + ', top=' + top + ', resizable=1, location=0, toolbar=0');
		
	}


	//등록
	function fn_reg(){
		//$("#POP_SEQ").val("");
		//frmPop.action = "/CE/EPCE8149331.do";
		//frmPop.submit();
		
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE8149301.do";
		kora.common.goPage('/CE/EPCE8149331.do', INQ_PARAMS);
		
	}

	//수정
	function fn_upd(){
		if(rowIndex < 0){
			alertMsg("선택된 리스트가 없습니다.");
			return;
		}
		
		var POP_SEQ = $("#POP_SEQ").val();
		if(POP_SEQ == null || POP_SEQ == ""){
			alertMsg("선택된 리스트의 값을 얻지 못했습니다.");
			return;
		}
		
		//frmPop.action = "/CE/EPCE8149331.do";
		//frmPop.submit();
				
		var input = {};
		input["POP_SEQ"] = POP_SEQ;
		
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE8149301.do";
		kora.common.goPage('/CE/EPCE8149331.do', INQ_PARAMS);
	}

	//삭제
	function fn_del(){
		if(rowIndex < 0){
			alertMsg("선택된 리스트가 없습니다.");
			return;
		}
		
		var POP_SEQ = $("#POP_SEQ").val();
		if(POP_SEQ == null || POP_SEQ == ""){
			alertMsg("선택된 리스트의 값을 얻지 못했습니다.");
			return;
		}
		
		confirm('삭제하시겠습니까?', 'fn_del_exec');

	}
	
	function fn_del_exec(){
		var sData = {"POP_SEQ":$("#POP_SEQ").val(), "SEARCH_SBJ":"", "ADMIN_YN":"Y"};
		var url = "/CE/EPCE8149301_04.do";
		ajaxPost(url, sData, function(data){
			if(data.cd == "1"){
				alertMsg("삭제실패 - 선택된 리스트의 값을 얻지 못했습니다.");
				return;
			}else if(data.cd == "2"){
				alertMsg("삭제실패 - 처리중 오류가 발생하였습니다.");
				return;
			}else{
				gridApp.setData(data.list);
				rowIndex = -1;
			}
		});
	}

	//사용중지
	function fn_use_stop(){
		if(rowIndex < 0){
			alertMsg("선택된 리스트가 없습니다.");
			return;
		}
		
		var POP_SEQ = $("#POP_SEQ").val();
		if(POP_SEQ == null || POP_SEQ == ""){
			alertMsg("선택된 리스트의 값을 얻지 못했습니다.");
			return;
		}
		
		confirm('사용중지 하시겠습니까?', 'fn_use_stop_exec');
		
	}
	
	function fn_use_stop_exec(){
		
		var sData = {"POP_SEQ":$("#POP_SEQ").val(), "SEARCH_SBJ":"", "ADMIN_YN":"Y"};
		var url = "/CE/EPCE8149301_21.do";
		ajaxPost(url, sData, function(data){
			if(data.cd == "1"){
				alertMsg("변경실패 - 선택된 리스트의 값을 얻지 못했습니다.");
				return;
			}else if(data.cd == "2"){
				alertMsg("변경실패 - 처리중 오류가 발생하였습니다.");
				return;
			}else{
				gridApp.setData(data.list);
				rowIndex = -1;
				alertMsg("변경되었습니다",'fn_lst');
			}
		});
		
	}
	
	//기본화면 가기
	function fn_lst(){
		location.href =   "/CE/EPCE8149301.do";
	}
	
	</script>

	<div class="iframe_inner">
	
		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
		<input type="hidden" id="init_list" value="<c:out value='${list}' />" />
	
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn_box">
				<div class="btn" style="float:right" id=""></div>
			</div>
		</div>
		<section class="secwrap mt10">
			<div class="boxarea">
				
				<div class="list_tbl head pr17">
					<div id="gridHolder" style="height:422px;"></div>
				</div>

				<form name="frmPop" id="frmPop" method="post">
					<input type="hidden" name="POP_SEQ" id="POP_SEQ" value="" />
				</form>
				
			</div>
		</section>
		
		<section class="btnwrap mt20" style ="" >
			<div class="btn" style="float:right" id="BR"></div>
		</section>
		
	</div>
	
	
	
	
	