<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">

	//rMate 그리드 생성 준비가 완료된 상태 시 호출할 함수를 지정합니다.
	var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
	var gridApp, gridRoot, dataGrid;
	var layoutStr = new Array(); 
	
	var jParams;
	var searchList;
	
	var toDay = kora.common.gfn_toDay();  // 현재 시간
	var endDt = kora.common.getDate("yyyy-mm-dd",  "M", 1, null);

	$(document).ready(function(){
		
		$('#titleSub').text('<c:out value="${titleSub}" />');
		
		searchList = jsonObject($('#searchList').val());
		
		gridSet();
		fn_btnSetting();
		
		jParams = jsonObject($("#INQ_PARAMS").val());
		
		//$(".row > .col> .tit").each(function(){
		//	if($(this).attr("id")) $(this).text(parent.fn_text($(this).attr("id")));
		//});
		
		//목록
		$("#btn_lst").click(function(){
			fn_lst();
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
		
		if(jParams["PARAMS"] == undefined){
			alertMsg("먼저 데이터를 조회해야 합니다.");
			return;
		}
					
		var now  = new Date(); 				     // 현재시간 가져오기
		var hour = new String(now.getHours());   // 시간 가져오기
		var min  = new String(now.getMinutes()); // 분 가져오기
		var sec  = new String(now.getSeconds()); // 초 가져오기
		var today = kora.common.gfn_toDay();
		var fileName = $('#titleSub').text() +"_" + today+hour+min+sec+".xlsx";
		
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
		
		var input = jParams["PARAMS"];
		input['fileName'] = fileName;
		input['columns'] = JSON.stringify(col);
		
		var url = "/CE/EPCE81606012_05.do";
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
	
	//설문 항목등록 페이지로~~
	function fn_lst(){
		kora.common.goPageB('', jParams);
	}
	
	function gridSet(){
		//rMateDataGrid 를 생성합니다.
		//파라메터 (순서대로) 
		//1. 그리드의 id ( 임의로 지정하십시오. ) 
		//2. 그리드가 위치할 div 의 id (즉, 그리드의 부모 div 의 id 입니다.)
		//3. 그리드 생성 시 필요한 환경 변수들의 묶음인 jsVars
		//4. 그리드의 가로 사이즈 (생략 가능, 생략 시 100%)
		//5. 그리드의 세로 사이즈 (생략 가능, 생략 시 100%)
		rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%"); 
		
		layoutStr.push('<rMateGrid>');
		layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
		layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
		layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" headerHeight="35" doubleClickEnabled="true" textAlign="center" >');
		layoutStr.push('		<columns>');
		layoutStr.push('			<DataGridColumn dataField="index" headerText="순번" itemRenderer="IndexNoItem" textAlign="center" width="4%" />');
		layoutStr.push('			<DataGridColumn dataField="USER_ID" headerText="' + parent.fn_text('id') + '" width="18%" />');
		layoutStr.push('			<DataGridColumn dataField="USER_NM" headerText="' + parent.fn_text('user_nm') + '"  width="18%" />');
		layoutStr.push('			<DataGridColumn dataField="BIZRNM" headerText="' + parent.fn_text('bizr_nm') + '" width="30%" />');
		layoutStr.push('			<DataGridColumn dataField="BRCH_NM" headerText="' + parent.fn_text('brch_nm') + '" width="30%" />');
		layoutStr.push('		</columns>');
		layoutStr.push('	</DataGrid>');
		layoutStr.push('</rMateGrid>');
					
	}

	//그리드의 속성인 rMateOnLoadCallFunction 으로 설정된 함수.
	//rMate 그리드의 준비가 완료된 경우 이 함수가 호출됩니다.
	//이 함수를 통해 그리드에 레이아웃과 데이터를 삽입합니다.
	//파라메터 : id - rMateGridH5.create() 사용 시 사용자가 지정한 id 입니다.
	function gridReadyHandler(id) {
		
		gridApp = document.getElementById(id);  // 그리드를 포함하는 div 객체
		gridRoot = gridApp.getRoot();   // 데이터와 그리드를 포함하는 객체
		
		gridApp.setLayout(layoutStr.join("").toString());

		var layoutCompleteHandler = function(event) {
		    dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		    gridApp.setData(searchList);
		}
		
		var dataCompleteHandler = function(event) {
		    dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		    dataGrid.setEnabled(true);
		}
		
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);

	};

	</script>
	
	<div class="iframe_inner">
	
		<input type="hidden" id="searchList" value="<c:out value='${searchList}' />"/>
		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
		
	
		<div class="h3group">
			<h3 class="tit" id="titleSub"></h3>
			<div class="singleRow">
				<div class="btn" id="UR"></div>
			</div>
		</div>
			
		<!-- 조회 리스트 그리드 -->
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:418px;"></div>
			</div>
		</section>
		
		<!-- 설문 문항 등록버틍 -->
		<section class="btnwrap mt10" >
			<div class="fl_r" id="BR">
			</div>
		</section>
		<!-- //입력처리 버튼 -->
		
		<form name="frm" action="/jsp/file_down.jsp" method="post">
			<input type="hidden" name="fileName" value="" />
			<input type="hidden" name="saveFileName" value="" />
			<input type="hidden" name="downDiv" value="excel" />
		</form>
	</div>	<!-- //iframe_inner -->
	