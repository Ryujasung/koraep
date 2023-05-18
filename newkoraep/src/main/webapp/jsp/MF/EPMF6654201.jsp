<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>직접반환 관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<!-- 페이징 사용 등록 -->
<script src="/js/kora/all_paging_common.js"></script>

<script type="text/javaScript" language="javascript" defer="defer" >

	 	/* 페이징 사용 등록 */
		gridRowsPerPage = 15;// 1페이지에서 보여줄 행 수
		gridCurrentPage = 1;// 현재 페이지
		gridTotalRowCount = 0;//전체 행 수

		var INQ_PARAMS; //파라미터 데이터
	 	var jParams = {};
	 	
	    var stat_cdList;//상태
		var mfc_bizrnm_sel;//생산자
	    var mfc_brch_nm_sel;//직매장/공장 ING

		var sumData; //총합계
		
		$(document).ready(function(){
			
			INQ_PARAMS 	= jsonObject($("#INQ_PARAMS").val()); //파라미터 데이터
		 	
		    stat_cdList = jsonObject($("#stat_cdList_list").val()); //상태
			mfc_bizrnm_sel = jsonObject($("#mfc_bizrnm_sel_list").val());	//생산자
		    mfc_brch_nm_sel = jsonObject($("#mfc_brch_nm_sel_list").val());	 //직매장
			
			//버튼 셋팅
		    fn_btnSetting();
		    
			//그리드 셋팅
		    fnSetGrid1();
			
			//날짜 셋팅
		    $('#START_DT').YJcalendar({
				toName : 'to',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
			});
			$('#END_DT').YJcalendar({
				fromName : 'from',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
			});
			
			//다국어 세팅
		    $('#sel_term').text(parent.fn_text('sel_term'));//조회기간
		    $('#stat').text(parent.fn_text('stat'));//상태
		    $('#mfc_bizrnm_sel').text(parent.fn_text('mfc_bizrnm'));//생산자
		    $('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm'));//직매장/공장

		    
		  	//생산자
			kora.common.setEtcCmBx2(mfc_bizrnm_sel, "", "", $("#MFC_BIZRNM_SEL"), "BIZRID_NO", "BIZRNM", "N");
			fn_bizrTpCd();
			
		 	//상태
	   	 	kora.common.setEtcCmBx2(stat_cdList, "","", $("#RTL_RTN_STAT_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');
	   		

			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				kora.common.jsonToTable("sel_params", INQ_PARAMS.SEL_PARAMS);
				
				/* 화면이동 페이징 셋팅 */
				gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
			}
			
		    
			/************************************
			 * 시작날짜  클릭시 - 삭제  변경 이벤트
			 ***********************************/
			$("#START_DT").click(function(){
			     var start_dt = $("#START_DT").val();
			     start_dt   =  start_dt.replace(/-/gi, "");
			     $("#START_DT").val(start_dt);
			});
			/************************************
			 * 시작날짜  클릭시 - 추가  변경 이벤트
			 ***********************************/
			$("#START_DT").change(function(){
			     var start_dt = $("#START_DT").val();
			     start_dt   =  start_dt.replace(/-/gi, "");
				if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd");
			     $("#START_DT").val(start_dt);
			});
			
			/************************************
			 * 끝날짜  클릭시 - 삭제  변경 이벤트
			 ***********************************/
			$("#END_DT").click(function(){
				    var end_dt = $("#END_DT").val();
				         end_dt  = end_dt.replace(/-/gi, "");
				     $("#END_DT").val(end_dt);
			});
			/************************************
			 * 끝날짜  클릭시 - 추가  변경 이벤트
			 ***********************************/
			$("#END_DT").change(function(){
			     var end_dt  = $("#END_DT").val();
			           end_dt =  end_dt.replace(/-/gi, "");
				if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd");
			     $("#END_DT").val(end_dt);
			});
			
			/************************************
			 * 직접반환정보변경 버튼 클릭 이벤트
			 ***********************************/
			$("#btn_upd").click(function(){
				fn_upd();
			});
			
			/************************************
			 * 조회버튼 클릭 이벤트
			 ***********************************/
			$("#btn_sel").click(function(){
				//조회버튼 클릭시 페이징 초기화
				gridCurrentPage = 1;
				fn_sel();
			});
			
			//등록
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			//삭제
			$("#btn_del").click(function(){
				fn_del();
			});
			
			/************************************
			 * 생산자명 변경 이벤트
			 ***********************************/
			 $("#MFC_BIZRNM_SEL").change(function(){
				fn_bizrTpCd();
			 });
			
			 /************************************
			 * 엑셀다운로드 버튼 클릭 이벤트
			 ***********************************/
			 $("#btn_excel").click(function() {
				 fn_excel();
			 });
			
		});
		
		//생산자명 변경시
		function fn_bizrTpCd(){
			
			var url = "/MF/EPMF6645201_191.do" 
			var input ={};
			var mfc_brch_info = [];
			
		    input["BIZRID_NO"] = $("#MFC_BIZRNM_SEL").val();
		    
			if( $("#MFC_BIZRNM_SEL").val() ==""){
				kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM_SEL"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');
			}else{
	       	    ajaxPost(url, input, function(rtnData) {
	   				if ("" != rtnData && null != rtnData) {
	   					mfc_brch_info = rtnData.searchList; 
	   					kora.common.setEtcCmBx2(rtnData.searchList, "","", $("#MFC_BRCH_NM_SEL"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');
	   				} else {
	   					alertMsg("error");
	   				}
	    		}, false);
			}

		}
		
		//직접반환정보 변경
	     function fn_upd(){
	    	  
	    	 var selectorColumn = gridRoot.getObjectById("selector");
	    	 var chkLst = selectorColumn.getSelectedItems();
				
				if(chkLst.length < 1){
					alertMsg("선택된 행이 없습니다.");
					return;
				}
				
				if(chkLst.length > 1){
					alertMsg("한건만 선택이 가능합니다.");
					return;
				}
				
				var item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[0]);
				
				if(item.RTL_RTN_STAT_CD != 'TG' ){
					alertMsg("직접반환등록 상태의 정보만 변경 가능합니다. 다시 한 번 확인하시기 바랍니다.");
		    		return;
				}
				
				INQ_PARAMS["PARAMS"] = item;
				INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		 		INQ_PARAMS["URL_CALLBACK"] = "/MF/EPMF6654201.do";
	
		 		kora.common.goPage('/MF/EPMF6654242.do', INQ_PARAMS);
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
			var fileName = $('#title_sub').text() +"_" + today+hour+min+sec+".xlsx";
			
			//그리드 컬럼목록 저장
			var col = new Array();
			var columns = dataGrid.getColumns();
			for(i=0; i<columns.length; i++){
				if(columns[i].getDataField() != undefined && columns[i].getDataField() != 'index'){ //순번 제외
					var item = {};
					item['headerText'] = columns[i].getHeaderText();
					
					if(columns[i].getDataField() == 'RTL_RTN_REG_DT_PAGE'){// html 태크 사용중 컬럼은 대체
						item['dataField'] = 'RTL_RTN_REG_DT';
					}else{
						item['dataField'] = columns[i].getDataField();
					}
					
					item['textAlign'] = columns[i].getStyle('textAlign');
					item['id'] = kora.common.null2void(columns[i].id);
					
					col.push(item);
				}
			}
			
			var input = INQ_PARAMS["SEL_PARAMS"];
			input['fileName'] = fileName;
			input['columns'] = JSON.stringify(col);
			
			var url = "/MF/EPMF6654201_05.do";
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
					
	//조회
	function fn_sel(){

		var input ={}
		var url ="/MF/EPMF6654201_19.do";
		
		var start_dt = $("#START_DT").val().replace(/-/gi, "");
		var end_dt    = $("#END_DT").val().replace(/-/gi, "");

		//날짜 정합성 체크
		if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
			alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return; 
		}
     	//	kora.common.fnDateCompare ()    종료일이 시작일 보다 작을때 false 를 체크 해보자
		if(start_dt>end_dt){
			alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return;
		} 
				   
		input["START_DT"] = $("#START_DT").val(); //시작날짜
		input["END_DT"] = $("#END_DT").val(); //끝날짜
		input["RTL_RTN_STAT_CD"] = $("#RTL_RTN_STAT_CD").val(); // 상태 
		
		input["MFC_BIZRNM_SEL"] = $("#MFC_BIZRNM_SEL").val(); // 생산자 선택
		input["MFC_BRCH_NM_SEL"] =$("#MFC_BRCH_NM_SEL").val(); //직매장/공장 선택
		
		/* 페이징  */
		input["ROWS_PER_PAGE"] = gridRowsPerPage;
		input["CURRENT_PAGE"] = gridCurrentPage;
		
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["SEL_PARAMS"] = input;
		
		kora.common.showLoadingBar(dataGrid, gridRoot);
		ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {   
				gridApp.setData(rtnData.selList);
				sumData = rtnData.totalList[0];
				
				/* 페이징 표시 */
				gridTotalRowCount = parseInt(sumData.CNT); //총 카운트
				drawGridPagingNavigation(gridCurrentPage);
			}else{
				alertMsg("error");
			}
			kora.common.hideLoadingBar(dataGrid, gridRoot);
		});
		
	
	}	
	
	/* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel(); //조회 펑션
	}
		
	function fn_reg(){
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/MF/EPMF6654201.do";
		kora.common.goPage('/MF/EPMF6654231.do', INQ_PARAMS);
	}
	
   	var del_row = new Array();
  	//삭제
    function fn_del(){
    	del_row = new Array();
 	    var selectorColumn = gridRoot.getObjectById("selector");

 		if(selectorColumn.getSelectedIndices() == "") {
 			alertMsg("선택한 건이 없습니다.");
 			return false;
 		}

 		 for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
			var item = {};
			item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			
			if(item["RTL_RTN_STAT_CD"] !="TG"){
				alertMsg("직접반환등록 상태의 정보만 삭제 가능합니다");
				return;
			}
			del_row.push(item);
 		 }
 		 
 		 confirm("선택된 정보에 대해 삭제 처리하시겠습니까? 삭제 처리된 내역은 복원되지 않으며 재등록 하셔야 합니다.", 'fn_del_exec');
    }
  	
  	function fn_del_exec(){
  		
  		var input = {"list": ""};
 		var url ="/MF/EPMF6654201_04.do";
  		input["list"] = JSON.stringify(del_row);

	 	 ajaxPost(url, input, function(rtnData){
	 		if ("" != rtnData && null != rtnData) {   
	 			alertMsg(rtnData.RSLT_MSG, 'fn_sel');
	 		}else{
	 			alertMsg('error');
	 		}
		 });
  		
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
			layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr.push('	<DateFormatter id="datefmt" formatString="YYYY-MM-DD"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" horizontalScrollPolicy="on" draggableColumns="true"  headerHeight="35" >');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridSelectorColumn id="selector" width="40" textAlign="center" allowMultipleSelection="true" vertical-align="middle" draggable="false" />');			//선택
			layoutStr.push('			<DataGridColumn dataField="PNO" headerText="'+ parent.fn_text('sn')+ '" textAlign="center" width="50"   draggable="false"/>');							//순번
			layoutStr.push('			<DataGridColumn dataField="RTL_RTN_REG_DT_PAGE"  headerText="'+ parent.fn_text('reg_dt2')+'" textAlign="center" width="150" itemRenderer="HtmlItem"/>');  //등록일자
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM"  headerText="'+ parent.fn_text('mfc_bizrnm')+ '" textAlign="center" width="200"/>');    //생산자
			layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_NM"  headerText="'+ parent.fn_text('mfc_brch_nm')+ '" textAlign="center" width="200"/>');   //직매장/공장
			layoutStr.push('			<DataGridColumn dataField="RTL_RTN_QTY_TOT" id="num1"  headerText="'+ parent.fn_text('drct_rtrvl_qty')+ '" textAlign="right" width="150" formatter="{numfmt}"/>');  //직접반환량
			layoutStr.push('			<DataGridColumn dataField="RTL_PAY_GTN_TOT" id="num2"  headerText="'+ parent.fn_text('drct_pay_dps')+ '" textAlign="right" width="150" formatter="{numfmt}"/>');   //직접지급보증금
			layoutStr.push('			<DataGridColumn dataField="RTL_RTN_STAT_NM"  headerText="'+ parent.fn_text('stat')+ '" textAlign="center" width="120" id="tmp1" />');  //상태
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	//량 합
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	//보증금 합
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp1}"/>');
			layoutStr.push('			</DataGridFooter>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn label="'+parent.fn_text('totalsum')+'" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum1" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum2" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp1}"/>');
			layoutStr.push('			</DataGridFooter>');
			layoutStr.push('		</footers>');
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
		gridApp.setData([]);
		var layoutCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			dataGrid.addEventListener("change", selectionChangeHandler);
			
			  //파라미터 call back function 실행
			 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
					/* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
			 	 window[INQ_PARAMS.FN_CALLBACK]();
			 	//취약점점검 5999 기원우
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
	
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		
	}

	//직접반환량 합계
	function totalsum1(column, data) {
		if(sumData)
			return sumData.RTL_RTN_QTY_TOT;
		else
			return 0;
	}

	//직접지급보증금 합계
	function totalsum2(column, data) {
		if(sumData)
			return sumData.RTL_PAY_GTN_TOT;
		else
			return 0;
	}

	//상세조회 링크
	 function link() {
		
		var idx = dataGrid.getSelectedIndices();
		var input = gridRoot.getItemAt(idx);
		
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/MF/EPMF6654201.do";
		kora.common.goPage('/MF/EPMF6654264.do', INQ_PARAMS);
	}
	

   /****************************************** 그리드 셋팅 끝***************************************** */
	</script>
	
	</head>
	
	<style type="text/css">
		.row .tit{width: 77px;}
	</style>
	
	<body>

  	<div class="iframe_inner"  id="testee" >
			<div class="h3group">
				<h3 class="tit" id="title"></h3>
				<div class="btn" style="float:right" id="UR">
			</div>
		</div>
		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">

				<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
				<input type="hidden" id="stat_cdList_list" value="<c:out value='${stat_cdList}' />" />
				<input type="hidden" id="mfc_bizrnm_sel_list" value="<c:out value='${mfc_bizrnm_sel}' />" />
				<input type="hidden" id="mfc_brch_nm_sel_list" value="<c:out value='${mfc_brch_nm_sel}' />" />
				
					<div class="col" >
						<div class="tit" id="sel_term"></div>
						<div class="box">
							<div class="calendar">
								<input type="text" id="START_DT" name="from" style="width: 130px;" class="i_notnull" >
							</div>
							
							<div class="obj">~</div>
							
							<div class="calendar">
								<input type="text" id="END_DT" name="to" style="width: 130px;" class="i_notnull" >
							</div>
							
						</div>
					</div>
	
					<div class="col" >
						<div class="tit" id="stat" ></div> 
						<div class="box">
							<select style="width: 180px;" id="RTL_RTN_STAT_CD"></select>
						</div>
					</div>
					
				</div>
				<div class="row">
					<div class="col" >  <!-- 생산자 선택 -->
						<div class="tit" id="mfc_bizrnm_sel" style=""></div>
						<div class="box">
							<select id="MFC_BIZRNM_SEL" style="width: 179px"></select>
						</div>
					</div>
					<div class="col" >
						<div class="tit" id="mfc_brch_nm"></div>  <!--직매장/공장-->
						<select style="width: 180px;" id="MFC_BRCH_NM_SEL"></select>
					</div>
					
					<div class="btn" id="CR">
					</div>
					
				</div>		<!-- end of row -->
			</div>		<!-- end of srcharea --> 
		</section>
		<section class="btnwrap mt10" >
			<div class="btn" id="GL"></div>
			<div class="btn" style="float:right" id="GR"></div>
		</section>
		<div class="boxarea mt10">
			<!-- 그리드 셋팅 -->
			<div id="gridHolder" style="height: 648px; background: #FFF;"></div>
			<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
		</div>

		<section class="btnwrap" >
			<div class="btn" style="" id="BL"></div>
			<div class="btn" style="float:right" id="BR"></div>
		</section>
		
	</div> <!-- end of  iframe_inner -->
	
	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="excel" />
	</form>

</body>
</html>

		