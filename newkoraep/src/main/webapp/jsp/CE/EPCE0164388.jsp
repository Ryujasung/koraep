<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>기준취급수수료조회 레이어팝업창</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
	<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>
	<script type="text/javaScript" language="javascript" defer="defer">

	/* 페이징 사용 등록 */
 	gridRowsPerPage 	= 10;	// 1페이지에서 보여줄 행 수
 	gridCurrentPage 		= 1;	// 현재 페이지
 	gridTotalRowCount 	= 0; //전체 행 수
	
    // var initList ={initList};					//초기 리스트 값
     var mfcSeCdList;
     var INQ_PARAMS;
     
     $(function() {
		
    	 INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
    	 mfcSeCdList = jsonObject($('#mfcSeCdList').val());
    	 
    	 //그리드 셋팅
		 fnSetGrid1();
		 
		//text 셋팅
		$('#mfc_se_cd').text(parent.fn_text('mfc_se_cd')); //생산자
		$('#ctnr_nm').text(parent.fn_text('ctnr_nm')); 		 //빈용기명
		
		$("#titleSub").text("<c:out value="${titleSub}" />");
	
      
		/************************************
		 * 생산자구분 변경 이벤트
		 ***********************************/
		$("#MFC_BIZRNM").change(function(){
			fn_mfc_bizrnm();
		});
		
		/************************************
		 * 조회버튼 클릭 이벤트
		 ***********************************/
		$("#btn_sel").click(function(){
			//조회버튼 클릭시 페이징 초기화
			gridCurrentPage = 1;
			fn_sel();
		});
		
	
		kora.common.setEtcCmBx2(mfcSeCdList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'T');
		 kora.common.setEtcCmBx2([], "","", $("#CTNR_NM"), "CTNR_CD", "CTNR_NM", "N" ,'T');
			
	});
    //생산자구분 변경시
     function fn_mfc_bizrnm(){
    	
    			var url = "/CE/EPCE0105901_192.do" 
				var input ={};
    			var arr = new Array();
    		    var mfc_bizrnm = $("#MFC_BIZRNM").val();
    		    	
        	   			 arr= mfc_bizrnm.split(";")
    				     input["BIZRID"] 	=	arr[0];
    	    	   		 input["BIZRNO"]	=	arr[1];
    	    	   		 
    	    	   	 	if(mfc_bizrnm==""){
        	    			input["BIZRID"] 	=	"";
        	    		   	input["BIZRNO"]	=	"";
        	    		}
				   showLoadingBar();
		       	   ajaxPost(url, input, function(rtnData) {
		    				if ("" != rtnData && null != rtnData) {   
		    					 $("#CTNR_NM  option").remove();
		    					 kora.common.setEtcCmBx2(rtnData.ctnrNmList, "","", $("#CTNR_NM"), "CTNR_CD", "CTNR_NM", "N" ,'T');
		    				} else {
		    					alertMsg("error");
		    				}
		    		},false);
		    		hideLoadingBar();
     }
     
	//조회
   function fn_sel(){

	 	var url = "/CE/EPCE0105901_19.do";
		var input = {};
		var mfc_bizrnm = $("#MFC_BIZRNM").val();
		var arr = new Array();
		
		 arr= mfc_bizrnm.split(";")
		input["BIZRID"] 	=	arr[0];
	   	input["BIZRNO"]	=	arr[1];
		input["CTNR_CD"] 		= $("#CTNR_NM		option:selected").val();
		
		 for(var i=0;i<mfcSeCdList.length;i++){
				if(mfcSeCdList[i].BIZRID_NO == mfc_bizrnm){
					input["BIZR_TP_CD"]  =mfcSeCdList[i].BIZR_TP_CD
				}
			}
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
	   		},false);
	   		hideLoadingBar(); 
		 
   }
	
   /* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel(); //조회 펑션
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
			layoutStr	.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" sortableColumns="true"   horizontalGridLines="true" headerHeight="60" horizontalScrollPolicy="on">');
			layoutStr.push('		<columns>');
			layoutStr.push('			<DataGridColumn dataField="CTNR_CD"  headerText="'+ parent.fn_text('ctnr_cd')	+ '"	width="70"	textAlign="center"/>');
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM" headerText="'+ parent.fn_text('ctnr_nm')	+ '"	width="290"	textAlign="center"/>');
			layoutStr	.push('			<DataGridColumn dataField="STD_DPS"	 headerText="'+ parent.fn_text('std_dps')	+ '"   width="100"	itemRenderer="HtmlItem"  textAlign="center" />');//보증금원
			layoutStr	.push('			<DataGridColumn dataField="STD_DPS_APLC_DT"	 headerText="'+ parent.fn_text('std_dps')	+ parent.fn_text('aplc_dt')+ '"   width="200"	itemRenderer="HtmlItem"  textAlign="center" />');//보증금원 적용날짜
			layoutStr.push('			<DataGridColumn dataField="STD_FEE"	 headerText="'+ parent.fn_text('std_fee')+ '"		width="100"	textAlign="center" />'); //기준취급수수료
			layoutStr.push('			<DataGridColumn dataField="STD_WHSL_FEE"	 headerText="'+ parent.fn_text('std_whsl_fee')	+ '"	width="100"	textAlign="center"/>');//기준도매수수료
			layoutStr	.push('			<DataGridColumn dataField="STD_RTL_FEE"		 headerText="'+ parent.fn_text('std_rtl_fee')	+ '"		width="100"	itemRenderer="HtmlItem"  textAlign="center" />');//기준소매수수료
			layoutStr.push('			<DataGridColumn dataField="PSBL_FEE"			 headerText="'+ parent.fn_text('psbl_fee')+ '"			width="100"	textAlign="center" />'); //취급수수료 조정 가능범위
			layoutStr.push('			<DataGridColumn dataField="PSBL_WHSL_FEE" headerText="'+ parent.fn_text('psbl_whsl_fee')+ '"	width="100"	textAlign="center" />');//도매수수료 조정 가능범위
			layoutStr.push('			<DataGridColumn dataField="PSBL_RTL_FEE"	 headerText="'+ parent.fn_text('psbl_rtl_fee')+ '"		width="100"	textAlign="center" />');//소매수수료 조정 가능범위
			layoutStr.push('			<DataGridColumn dataField="APLC_DT"			 headerText="'+ parent.fn_text('aplc_dt')	+ '"			width="160"	textAlign="center"/>');
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
		//gridApp.setData(initList);
		var layoutCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			dataGrid.addEventListener("change", selectionChangeHandler);
			
			 //파라미터 call back function 실행
			 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
			 	/* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
			 	 window[INQ_PARAMS.FN_CALLBACK]();
			 	//취약점점검 5827 기원우
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
	<input type="hidden" id="mfcSeCdList" value="<c:out value='${mfcSeCdList}' />"/>
	
		<div class="layer_popup" style="width:1024px;">
			<div class="layer_head">
				<h1 class="layer_title title"  id="titleSub"></h1>
				<button type="button" class="layer_close" layer="close">팝업닫기</button>
			</div>
			<div class="layer_body">
			
						<section class="secwrap">
						<div class="srcharea"> <!-- 조회부분 -->
							<div class="row">
								<div class="col">
									<div class="tit" id="mfc_se_cd"></div>  <!-- 생산자 -->
									<div class="box">
										<select id="MFC_BIZRNM" style="width: 179px">
										</select>
									</div>
								</div>
								
								<div class="col">
									<div class="tit" id="ctnr_nm"></div>  <!-- 빈용기명 -->
									<div class="box">
										<select id="CTNR_NM" style="width: 250px">
										</select>
									</div>
								</div>
						
							    <div class="btn">
										<button type="button" class="btn36 c1" style="width: 100px;" id="btn_sel">조회</button>
								</div>
							</div> <!-- end of row -->
							
						</div>  <!-- end of srcharea -->
					</section>
				
					<section class="secwrap mt30">
			
						<div class="boxarea mt10">
							<div id="gridHolder" style="height: 430px; background: #FFF;"></div>
							<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
						</div>	<!-- 그리드 셋팅 -->
						
					</section>	<!-- end of secwrap mt30  -->
				
			</div><!-- end of  layer_body-->
	
	</div>  <!-- end of layer_popup -->
</body>
</html>

