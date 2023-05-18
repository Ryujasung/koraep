<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>무인회수기소모품현황</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />


<script type="text/javaScript" language="javascript" defer="defer">
// 	var initList = {initList};
	
	//페이지이동 조회조건 데이터 셋팅
	var INQ_PARAMS;
	
	/* 페이징 사용 등록 */
	gridRowsPerPage = 15;	// 1페이지에서 보여줄 행 수
	gridCurrentPage = 1;	// 현재 페이지
	gridTotalRowCount = 0; //전체 행 수
	 var toDay = kora.common.gfn_toDay();// 현재 시간
	 var urm_list;
	 var urm_fix_list;
	 var sumData;//총합계
	$(document).ready(function(){
		
		INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
		urm_list 		= jsonObject($("#urm_list").val());		
		urm_fix_list 		= jsonObject($("#urm_fix_list").val());
        kora.common.setEtcCmBx2(urm_list, "","", $("#SERIAL_NO"), "SERIAL_NO", "URMCENO_SERIAL", "N" ,'T');		//도매업자 업체명
        $("#SERIAL_NO").select2();
        kora.common.setEtcCmBx2(urm_fix_list, "","", $("#URM_FIX_CD"), "URM_FIX_CD", "URM_EXP_NM", "N" ,'T');		//도매업자 업체명
		 $("#URM_FIX_CD").select2();
		 $('#title_sub').text('<c:out value="${titleSub}" />');
		fn_btnSetting();
		
		
		 fn_init(); 
		
		fn_set_grid();

// 		if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
// 			kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
// 			gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
// 		}
		
		/**
		*조회
		*/
		$("#btn_sel").click(function(){
			gridCurrentPage = 1;
			fn_sel();
		});
		
		/**
		*등록
		*/
		$("#btn_reg").click(function(){
			fn_reg();
		});
		/**
		*소모품등록
		*/
		$("#btn_add").click(function(){
			fn_add();
		});
		
		$("#btn_del").click(function(){
			fn_del_chk();
		});
		
		/************************************
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ***********************************/
		 $("#btn_excel").click(function() {
			 fn_excel();
		 });
		
		/************************************
		 * 단체설정 클릭 이벤트
		 ***********************************/
		
		 $("#btn_cnl").click(function(){
	        	fn_cnl();
	        });
		 //취소버튼 이전화면으로
		    function fn_cnl(){
		   	 kora.common.goPageB('/CE/EPCE9000501.do', INQ_PARAMS);
		    }
	        
	        /************************************
	         * 시작날짜  클릭시 - 삭제 변경 이벤트
	         ***********************************/
	        $("#START_DT").click(function(){
	            var start_dt = $("#START_DT").val();
	            start_dt   =  start_dt.replace(/-/gi, "");
	            $("#START_DT").val(start_dt)
	        });
	        
	        /************************************
	         * 시작날짜  클릭시 - 추가 변경 이벤트
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
	         * 끝날짜  클릭시 - 추가 변경 이벤트
	         ***********************************/
	        $("#END_DT").change(function(){
	            var end_dt  = $("#END_DT").val();
	            end_dt =  end_dt.replace(/-/gi, "");
	            if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd")
	            $("#END_DT").val(end_dt) 
	        });
		
	});
	 
	function fn_del_chk(){
   		var selectorColumn = gridRoot.getObjectById("selector");
		if(selectorColumn.getSelectedIndices() == "") {
			alertMsg("선택한 건이 없습니다.");
			return false;
		}
		 for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
			var item = {};
			item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			
		 }
		confirm("선택된 내역이 삭제됩니다. 계속 진행하시겠습니까? 삭제 처리된 내역은 복원되지 않으며 재등록 하셔야 합니다.","fn_del");
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
					
		var now = new Date();// 현재시간 가져오기
		var hour = new String(now.getHours());// 시간 가져오기
		var min = new String(now.getMinutes());// 분 가져오기
		var sec = new String(now.getSeconds());// 초 가져오기
		var today = kora.common.gfn_toDay();
		var fileName = $('#title_sub').text() +"_" + today+hour+min+sec+".xlsx";
		
		//그리드 컬럼목록 저장
		var col = new Array();
		var columns = dataGrid.getColumns();
		for(i=0; i<columns.length; i++){
			if(columns[i].getDataField() != undefined && columns[i].getDataField() != 'index'){ //순번 제외
				var item = {};
				item['headerText'] = columns[i].getHeaderText();
				
				if(columns[i].getDataField() == 'REG_SN'){// html 태크 사용중 컬럼은 대체
					item['dataField'] = 'PAGENO';
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
		
		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
		
		var url = "/CE/EPCE900053219_05.do";
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
	
	/**
	 * 목록조회
	 */
	function fn_sel(){
		var input = {};
		var url = "/CE/EPCE900053219.do"; 
		
		input["SERIAL_NO"] = $("#SERIAL_NO").val();
		input["START_DT"] = $("#START_DT").val();
		input["END_DT"] = $("#END_DT").val();
		input["URM_FIX_CD"] = $("#URM_FIX_CD").val();
		

		input["ROWS_PER_PAGE"] = gridRowsPerPage;
		input["CURRENT_PAGE"] = gridCurrentPage;
		
		INQ_PARAMS["SEL_PARAMS"] = input;
		
		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != ""){
				gridApp.setData(rtnData.searchList);
// 				console.log(rtnData.totalList);
				/* 페이징 표시 */
				sumData = rtnData.totalList[0];
				gridTotalRowCount = parseInt(sumData.CNT); //총 카운트
				drawGridPagingNavigation(gridCurrentPage);
			} else {
				alertMsg("error");
			}
			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
		});
		
	}
	
	/* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel(); //조회 펑션
	}
	
	 /**
	  * 상세조회 화면전환
	  */
	 function fn_page(){
		var input = {};
		input = gridRoot.getItemAt(rowIndex);
		
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE9000501.do";
		kora.common.goPage('/CE/EPCE9000536.do', INQ_PARAMS);
		
		
		 
	 }
	 
	 
	 function fn_del(){
		    var selectorColumn = gridRoot.getObjectById("selector");
			var input = {"list": ""};
			var row = new Array();
			var url ="/CE/EPCE9000538.do";
			if(selectorColumn.getSelectedIndices() == "") {
				alertMsg("선택한 건이 없습니다.");
				return false;
			}
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				
				/* if(item["RTN_STAT_CD"] !="RG" && item["RTN_STAT_CD"] !="RA"){
				    alertMsg("반환등록 또는 반환등록요청 상태의 정보만 삭제 가능합니다");
					return;
				} */
				row.push(item);
			}
			
		    input["list"] = JSON.stringify(row);
	    	//showLoadingBar()
		 	ajaxPost(url, input, function(rtnData){
				if(rtnData.RSLT_CD == "0000"){
					fn_sel();
					alertMsg(rtnData.RSLT_MSG);
				}else{
					fn_sel();
					alertMsg(rtnData.RSLT_MSG);
				}
				//hideLoadingBar();
			});    
		   
	   }
	 
	/**
	 * 등록화면 이동
	 */
	function fn_reg(){
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE9000501.do";
		kora.common.goPage('/CE/EPCE9000531.do', INQ_PARAMS);
	}
	
	/**
	 * 소모품등록화면 이동
	 */
	function fn_add(){
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE9000501.do";
		kora.common.goPage('/CE/EPCE9000533.do', INQ_PARAMS);
	}

	//비활동처리
	function fn_upd(){
		
		var chkLst = selectorColumn.getSelectedItems();
		
		if(chkLst.length < 1){
			alertMsg('선택된 행이 없습니다');
			return;
		}
		
		var msgList = new Array();
		
		for(var i=0; i<chkLst.length; i++){

			//상태값 비활동인 경우
			if(chkLst[i].USE_CD == "N"){
				alertMsg("이미폐기된 회수기가 선택되었습니다.\n다시 한 번 확인하시기 바랍니다.");
				return;
			}

			//관리자 여부 체크(센터 관리자그룹은 사업자 관리자 비활동 처리 가능)
			if(chkLst[i].USE_CD == "Y"){
					
					msgList.push(chkLst[i].URM_NM);

			}
		}
		
		var msg = "";
		if(msgList.length > 0){
			msg += "선택하신 회수기 (";
			for(var i=0; i<msgList.length; i++){
				if(i>0) msg += ', ';
				msg += msgList[i];
			}
			msg += ")가 폐기 처리됩니다.";
			msg += "\r계속 진행하시겠습니까?";
		}else{
			msg = "폐기 처리 시 해당 무인회수기의 사용이 불가능합니다.\n계속 진행하시겠습니까?";
		}

		confirm(msg, "fn_upd_exec");
	}

	function fn_upd_exec(){
		
		var data = {};
		var row = new Array();
		
		for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
			var item = {};
			item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			row.push(item);
		}
		
		data["list"] = JSON.stringify(row);

		var url = "/CE/EPCE900050142.do";
		ajaxPost(url, data, function(rtnData){
			if ("" != rtnData && null != rtnData) {
				alertMsg(rtnData.RSLT_MSG, 'fn_sel');
			} else {
				alertMsg("error");
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
			layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr.push('	<NumberFormatter id="numfmt1" precision="2" useThousandsSeparator="true"/>');
			layoutStr.push('    <NumberMaskFormatter id="maskfmt1" formatString="###-##-#####"/>');
			layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
		 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" verticalGridLines="true" headerHeight="35" headerWordWrap="true" horizontalGridLines="true" horizontalScrollPolicy="on" ');
		 layoutStr.push('	textAlign="center" ');
		 layoutStr.push(' 	draggableColumns="true" sortableColumns="true"  doubleClickEnabled="false" liveScrolling="false" showScrollTips="true">');
		 layoutStr.push('<groupedColumns>');
		 layoutStr.push('			<DataGridSelectorColumn id="selector" width="40" textAlign="center" allowMultipleSelection="true" vertical-align="middle"  draggable="false"/>');//선택 
		 layoutStr.push('	<DataGridColumn dataField="REG_SN" headerText="순번"  visible="false" />');
		 layoutStr.push('	<DataGridColumn dataField="SERIAL_NO"  headerText="무인회수기 시리얼번호" width="180"  itemRenderer="HtmlItem"/>');
		 layoutStr.push('	<DataGridColumn dataField="URM_FIX_DT"  headerText="교체일자" width="100"/>');
		 layoutStr.push('	<DataGridColumn dataField="URM_EXP_NM"  headerText="소모품명" width="200"/>');
		 layoutStr.push('	<DataGridColumn dataField="URM_CNT"  headerText="개수" width="80"/>');
		 layoutStr.push('			<DataGridColumnGroup  												headerText="부품단가(부가세 별도)">');
		layoutStr.push('				<DataGridColumn dataField="SUP_FEE" 		headerText="단가(원)" width="115" formatter="{numfmt}"  id="num1"  textAlign="right" />');		//가정용
		layoutStr.push('				<DataGridColumn dataField="CEN_PAY" 		headerText="센터 부담(원)" width="115" formatter="{numfmt}" id="num2" textAlign="right" />');		//유흥용
		layoutStr.push('				<DataGridColumn dataField="RET_PAY" 	  		headerText="소매점 부담(원)" width="115" formatter="{numfmt}" id="num3" textAlign="right" />');	//직접
		layoutStr.push('			</DataGridColumnGroup>');
		layoutStr.push('			<DataGridColumnGroup  												headerText="합계">');
		layoutStr.push('				<DataGridColumn dataField="SUP_PAY" 		headerText="공급가액" width="120" formatter="{numfmt}"  id="num4"  textAlign="right" />');		
		layoutStr.push('				<DataGridColumn dataField="FIX_VAT_FEE" 		headerText="부가세" width="120" formatter="{numfmt}" id="num5" textAlign="right" />');		
		layoutStr.push('				<DataGridColumn dataField="CEN_TOT" 	  		headerText="센터 부담(원)" width="120" formatter="{numfmt}" id="num6" textAlign="right" />');	
		layoutStr.push('				<DataGridColumn dataField="RET_TOT" 	  		headerText="소매점 부담(원)" width="120" formatter="{numfmt}" id="num7" textAlign="right" />');	
		layoutStr.push('				<DataGridColumn dataField="SUM_TOT" 	  		headerText="총합계(원)" width="120" formatter="{numfmt}" id="num8" textAlign="right" />');	
		layoutStr.push('			</DataGridColumnGroup>');
         layoutStr.push('		</groupedColumns>');
         layoutStr.push('		<footers>');
 		layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
 		layoutStr.push('				 <DataGridFooterColumn/>');
 		layoutStr.push('                 <DataGridFooterColumn/>');
 		layoutStr.push('				 <DataGridFooterColumn label="소계"  textAlign="center"/>');
         layoutStr.push('                <DataGridFooterColumn/>');
         layoutStr.push('                <DataGridFooterColumn/>');
 		layoutStr.push('				 <DataGridFooterColumn/>');
         layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');    
         layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');    
         layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');    
         layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');    
         layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');    
         layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');    
         layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');    
         layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num8}" formatter="{numfmt}" textAlign="right"/>');    
         layoutStr.push('            </DataGridFooter>');
         layoutStr.push('            <DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
         layoutStr.push('                <DataGridFooterColumn/>');
         layoutStr.push('				 <DataGridFooterColumn/>');
         layoutStr.push('                <DataGridFooterColumn label="총합계"  textAlign="center"/>');
         layoutStr.push('                <DataGridFooterColumn/>');
         layoutStr.push('                <DataGridFooterColumn/>');
         layoutStr.push('                <DataGridFooterColumn/>');
         layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum1" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');    
         layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum2" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');    
         layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum3" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');    
         layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum4" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');    
         layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum5" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');    
         layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum6" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');    
         layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum7" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');    
         layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum8" dataColumn="{num8}" formatter="{numfmt}" textAlign="right"/>');    
 		layoutStr.push('			</DataGridFooter>');
 		layoutStr.push('		</footers>');
 		layoutStr.push('      	<dataProvider>');
 	    layoutStr.push('         	<SpanArrayCollection source="{$gridData}"/>');
 	    layoutStr.push('      	</dataProvider>');
		 layoutStr.push('</DataGrid>');
		 layoutStr.push('</rMateGrid>');
	}

	// 그리드 및 메뉴 리스트 세팅
	 function gridReadyHandler(id) {
	 	 gridApp = document.getElementById(id);  // 그리드를 포함하는 div 객체
	     gridRoot = gridApp.getRoot();   // 데이터와 그리드를 포함하는 객체

	     gridApp.setLayout(layoutStr.join("").toString());
	     gridApp.setData();
	     
	     var layoutCompleteHandler = function(event) {
	         dataGrid = gridRoot.getDataGrid();  // 그리드 객체
	         selectorColumn = gridRoot.getObjectById("selector");
	         dataGrid.addEventListener("change", selectionChangeHandler); //이벤트 등록
	         //drawGridPagingNavigation(gridCurrentPage);  //페이징 표시
	         
	       	 //파라미터 call back function 실행
			 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
				 /* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
			 	 window[INQ_PARAMS.FN_CALLBACK]();
			 	//취약점점검 5957 기원우
			 }else{
				 gridApp.setData();
			 }
	     }
	     var selectionChangeHandler = function(event) {
			rowIndex = event.rowIndex;
		 }
	     var dataCompleteHandler = function(event) {
	     	dataGrid = gridRoot.getDataGrid();
	 	 }
	     
	     gridRoot.addEventListener("dataComplete", dataCompleteHandler);
	     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	 }
	
	
	 
	 
	//셋팅
    function fn_init(){
         
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
        
        //text 셋팅
       /*  $('.row > .col > .tit').each(function(){
            $(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
        }); */
            
        //div필수값 alt
        $("#START_DT").attr('alt',parent.fn_text('sel_term'));
        $("#END_DT").attr('alt',parent.fn_text('sel_term'));
    }
	
  //합계
	function totalsum1(column, data) {
		if(sumData) 
			return sumData.CEN_PAY_TOT; 
		else 
			return 0;
	}
	function totalsum2(column, data) {
		if(sumData) 
			return sumData.RET_PAY_TOT; 
		else 
			return 0;
	}
	function totalsum3(column, data) {
		if(sumData) 
			return sumData.SUP_FEE_TOT; 
		else 
			return 0;
	}
	function totalsum4(column, data) {
		if(sumData) 
			return sumData.SUP_PAY_TOT; 
		else 
			return 0;
	}
	function totalsum5(column, data) {
		if(sumData) 
			return sumData.FIX_VAT_FEE_TOT; 
		else 
			return 0;
	}
	function totalsum6(column, data) {
		if(sumData) 
			return sumData.CEN_TOT_TOT; 
		else 
			return 0;
	}
	function totalsum7(column, data) {
		if(sumData) 
			return sumData.RET_TOT_TOT; 
		else 
			return 0;
	}
	function totalsum8(column, data) {
		if(sumData) 
			return sumData.SUM_TOT_TOT; 
		else 
			return 0;
	}
</script>
<style type="text/css">

.row .tit{width: 84px;}

</style>
</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="urm_fix_list" value="<c:out value='${urm_fix_list}' />" />
<input type="hidden" id="urm_list" value="<c:out value='${urm_list}' />" />

	<div class="iframe_inner" >
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
			<div class="btn" style="float:right" id="UR"><button type="button" class="btn36 c2" style="width: 120px;" id="btn_excel"><span class="excel">엑셀저장</span></button></div>
		</div>
<!-- 셀렉트박스 부분 -->
		<section class="secwrap">
		<!-- <form name="frmMenu" id="frmMenu" method="post" > -->
			<div class="srcharea" id="sel_params"> <!-- 조회부분 -->
				<div class="row">
					<div class="col">
						<div class="tit">조회기간</div>    <!-- 조회기간 -->
                        <div class="box">
                            <div class="calendar">
                                <input type="text" id="START_DT" name="from" style="width: 179px;" class="i_notnull"><!--시작날짜  -->
                            </div>
                            <div class="obj">~</div>
                            <div class="calendar">
                                <input type="text" id="END_DT" name="to" style="width: 179px;"    class="i_notnull"><!-- 끝날짜 -->
                            </div>
                        </div>
					</div>
					<div class="col">
						<div class="tit" style="width: 150px">무인회수기 시리얼번호</div>  
						<div class="box">
							<select id="SERIAL_NO" name="SERIAL_NO" style="width: 330px;" class="i_notnull" ></select>
						</div>
					</div>
					 <div class="col">
                        <div class="tit">소모품명</div>    <!-- 조회기간 -->
                        <div class="box">
								<select id="URM_FIX_CD" name="URM_FIX_CD"   style="width: 300px"></select>
                        </div>
                    </div>
						<div class="btn" id="CR">
						
						</div>
				</div>
				
			</div>  <!-- end of srcharea -->
			<!-- </form> -->
		</section>

		<!-- 그리드 시작 -->
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height: 550px; background: #FFF;"></div>
			</div>	<!-- 그리드 셋팅 -->
				<div class="gridPaging" id="gridPageNavigationDiv"></div>
			
		</section>	<!-- end of secwrap mt30  -->
		<section class="btnwrap" >
			<div class="btnwrap" style="margin-top: 10px;">
				<div class="fl_l" id="BL">
					<!-- <button type="button" class="btn36 c4" style="width: 150px;" id="btn_cnl">무인회수기정보관리</button> -->
					<button type="button" class="btn36 c3" style="width: 150px;" id="btn_del">소모품정보삭제</button> 
				</div>
				<div class="fl_r" id="BR">
				</div>
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