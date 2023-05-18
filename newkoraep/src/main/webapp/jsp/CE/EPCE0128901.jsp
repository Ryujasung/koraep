<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>회수용기기준금액관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>
<script type="text/javaScript" language="javascript" defer="defer">


	/* 페이징 사용 등록 */
	gridRowsPerPage = 15;	// 1페이지에서 보여줄 행 수
	gridCurrentPage = 1;	// 현재 페이지
	gridTotalRowCount = 0; //전체 행 수

     var INQ_PARAMS;
	 var ctnrNmList;
	 var rowIndexValue ="";
     
     $(function() {
    	  INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
    	  ctnrNmList = jsonObject($('#ctnrNmList').val());
    	 
    	//버튼 셋팅
    	 fn_btnSetting();
    	 
    	 //그리드 셋팅
		 fnSetGrid1();
		 
		//text 셋팅
		$('#rtrvl_ctnr_nm').text(parent.fn_text('rtrvl_ctnr_nm')); 		 //회수용기명
	
		/************************************
		 * 조회버튼 클릭 이벤트
		 ***********************************/
		$("#btn_sel").click(function(){
			//조회버튼 클릭시 페이징 초기화
			gridCurrentPage = 1;
			fn_sel();
		});
		
		/************************************
		 * 회수보증금관리 클릭 이벤트
		 ***********************************/
		$("#btn_page").click(function(){
			fn_page();
		});
		
		/************************************
		 * 회수수수료 클릭 이벤트
		 ***********************************/
		$("#btn_page2").click(function(){
			fn_page2();
		});
		
		/************************************
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ***********************************/
		 $("#btn_excel").click(function() {
			 fn_excel();
		 });
		
		 kora.common.setEtcCmBx2(ctnrNmList, "","", $("#RTRVL_CTNR_CD"), "RTRVL_CTNR_CD", "CTNR_NM", "N" ,'T');
		//파라미터 조회조건으로 셋팅
		if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
			kora.common.jsonToTable("params",INQ_PARAMS.SEL_PARAMS);
			
			/* 화면이동 페이징 셋팅 */
			gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
		}
		
	});
     
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
		
		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
		
		var url = "/CE/EPCE0128901_05.do";
		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
				alertMsg(rtnData.RSLT_MSG);
			}else{
				//파일다운로드
				frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
				frm.fileName.value = fileName;
				frm.submit();
			}
			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
		});
	}
     
	//조회
   function fn_sel(){
	 	var url = "/CE/EPCE0128901_19.do";
		var input = {};
		input["RTRVL_CTNR_CD"] 		= $("#RTRVL_CTNR_CD 	option:selected").val();
		
		/* 페이징  */
		input["ROWS_PER_PAGE"] = gridRowsPerPage;
		input["CURRENT_PAGE"] 	= gridCurrentPage;
		
		INQ_PARAMS["SEL_PARAMS"] = input;
		
    	showLoadingBar();
      	ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {
   					gridApp.setData(rtnData.initList);
   					
   					/* 페이징 표시 */
					gridTotalRowCount = rtnData.totalCnt; //총 카운트
					drawGridPagingNavigation(gridCurrentPage);
   				} else {
   					alertMsg("error");
   				}
   				hideLoadingBar(); 
   		});
   		
   }
	
   /* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel(); //조회 펑션
	}
	
	//회수보증금관리 페이지 이동
	function fn_page(){
		var selectorColumn = gridRoot.getObjectById("selector");
		if(selectorColumn.getSelectedIndices() == "") {
			alertMsg("선택한 건이 없습니다.");
			return;
		}else if(selectorColumn.getSelectedIndices().length >1) {
			alertMsg("한건만 선택이 가능합니다.");
			return;
		}
		var input =gridRoot.getItemAt(rowIndexValue);
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";    
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE0128901.do";
		kora.common.goPage('/CE/EPCE0198201.do', INQ_PARAMS);
		
	}
	//회수수수료 페이지 이동
	function fn_page2(){
		var selectorColumn = gridRoot.getObjectById("selector");
		if(selectorColumn.getSelectedIndices() == "") {
			alertMsg("선택한 건이 없습니다.");
			return;
		}else if(selectorColumn.getSelectedIndices().length >1) {
			alertMsg("한건만 선택이 가능합니다.");
			return;
		}
		var input =gridRoot.getItemAt(rowIndexValue);
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";    
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE0128901.do";
		kora.common.goPage('/CE/EPCE0182901.do', INQ_PARAMS);
	}
	
	/****************************************** 그리드 셋팅 시작***************************************** */
	/**
	 * 그리드 관련 변수 선언
	 */
	var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
	var gridApp, gridRoot, dataGrid, layoutStr, selectorColumn;

	/**
	 * 그리드 셋팅
	 */
	 function fnSetGrid1(reDrawYn) {
			rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%");

			layoutStr = new Array();
			layoutStr.push('<rMateGrid>');
			layoutStr	.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr	.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" sortableColumns="true"    horizontalGridLines="true" headerHeight="35">');
			layoutStr.push('		<columns>');
			layoutStr	.push('			<DataGridSelectorColumn id="selector"	 				headerText="'+ parent.fn_text('sel')+ '"						width="50"		textAlign="center" 	allowMultipleSelection="false" />');			//선택
			layoutStr.push('			<DataGridColumn dataField="RTRVL_CTNR_CD"  		headerText="'+ parent.fn_text('ctnr_cd')	+ '"					width="100"	textAlign="center"/>');														//용기코드
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM" 				headerText="'+ parent.fn_text('rtrvl_ctnr_nm')	+ '"		width="250"	textAlign="center"/>');														//회수용기명
			layoutStr	.push('			<DataGridColumn dataField="RTRVL_DPS"	 			headerText="'+ parent.fn_text('rtrvl_dps2')	+ '"  			width="150"	textAlign="right" />');														//회수보증금원
			layoutStr	.push('			<DataGridColumn dataField="RTRVL_DPS_APLC_DT"	headerText="'+ parent.fn_text('rtrvl_dps_aplc_dt') + '"   	width="230"  	textAlign="center" />');														//보증금원 적용기간
			layoutStr.push('			<DataGridColumn dataField="RTRVL_FEE"	 		 	headerText="'+ parent.fn_text('rtrvl_fee2')+ '"				width="150"	textAlign="right" />'); 														//회수수수료(원)
			layoutStr.push('			<DataGridColumn dataField="RTRVL_FEE_APLC_DT"	headerText="'+parent.fn_text('rtrvl_fee_aplc_dt') + '"		width="230"	textAlign="center"/>');														//수수료 적용기간
			layoutStr.push('		</columns>');
			layoutStr.push('	</DataGrid>');
			layoutStr.push('</rMateGrid>');
		};
		
	
	/**
	 * 조회기준-생산자 그리드 이벤트 핸들러
	 */
	function gridReadyHandler(id) {
		gridApp = document.getElementById(id); // 그리드를 포함하는 div 객체
		gridRoot = gridApp.getRoot(); // 데이터와 그리드를 포함하는 객체
		gridApp.setLayout(layoutStr.join("").toString());
		var layoutCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			dataGrid.addEventListener("change", selectionChangeHandler);
		
			 //파라미터 call back function 실행
			 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
				 /* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
			 	 window[INQ_PARAMS.FN_CALLBACK]();
			 	//취약점점검 5867 기원우
			 }else{
				 gridApp.setData();
				/* 페이징 표시 */
				drawGridPagingNavigation(gridCurrentPage);
			 }
			
			
		}
		var dataCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
		}
		var selectionChangeHandler = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			selectorColumn = gridRoot.getObjectById("selector");

			rowIndexValue = rowIndex;
			selectorColumn.setSelectedIndex(-1);
			selectorColumn.setSelectedIndex(rowIndex);
		
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	}

	/**
	 * 그리드 loading bar on
	 */
	function showLoadingBar() {
		kora.common.showLoadingBar(dataGrid, gridRoot);
	}

	/**
	 * 그리드 loading bar off
	 */
	function hideLoadingBar() {
		kora.common.hideLoadingBar(dataGrid, gridRoot);
	}

/****************************************** 그리드 셋팅 끝***************************************** */


</script>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="ctnrNmList" value="<c:out value='${ctnrNmList}' />"/>

    <div class="iframe_inner" >
			<div class="h3group">
				<h3 class="tit" id="title"></h3>
				<div class="btn_box" id="UR"></div>
			</div>

		<section class="secwrap" id='params'>
			<div class="srcharea"> <!-- 조회부분 -->
				<div class="row">
							<div class="col">
						<div class="tit" id="rtrvl_ctnr_nm"></div>  <!-- 회수용기명 -->
						<div class="box">
							<select id="RTRVL_CTNR_CD" style="width: 450px"></select>
						</div>
					</div>
			
				    <div class="btn"  id="CR"></div>
				</div> <!-- end of row -->
				
			</div>  <!-- end of srcharea -->
		</section>
	

			<div class="boxarea mt10">
				<div id="gridHolder" style="height: 605px; background: #FFF;"></div>
				<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
			</div>	<!-- 그리드 셋팅 -->
			

		<section class="btnwrap" >
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>

</div>

	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="excel" />
	</form>

</body>
</html>