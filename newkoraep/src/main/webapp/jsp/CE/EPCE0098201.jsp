<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>문의하기 공지사항</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="_csrf" content="<c:out value='${_csrf.token}' />" />
<meta name="_csrf_header" content="<c:out value='${_csrf.headerName}' />" />

<link rel="stylesheet" href="/common/css/slick.css">
<link rel="stylesheet" href="/common/css/common.css">
<link rel="stylesheet" href="/common/css/reset.css">

<!-- 페이징 관련 스타일 -->
<style type="text/css">
	.gridPaging { text-align:center; font-family:verdana; font-size:12px; width:100%; padding:15px 0px 15px 0px; }
	.gridPaging a { color:#797674; text-decoration:none; border:1px solid #e0e0e0; background-color:#f6f4f4; padding:3px 5px 3px 5px;}
	.gridPaging a:link { color:#797674; text-decoration:none; }
	.gridPaging a:visited { color:#797674; text-decoration:none; }
	.gridPaging a:hover { text-decoration:none; border:1px solid #7a8ba2; text-decoration:none; }
	.gridPaging a:active { text-decoration:none; }
	.gridPagingMove { font-weight:bold; }
	.gridPagingDisable { font-weight:bold; color:#cccccc; border:1px solid #e0e0e0; background-color:#f6f4f4; padding:3px 5px 3px 5px;}
	.gridPagingCurrent { font-weight:bold; color:#ffffff; border:1px solid #2f3d64; background-color:#2f3d64; padding:3px 5px 3px 5px;}
</style>

<link rel="stylesheet" type="text/css" href="/rMateGrid/rMateGridH5/Assets/rMateH5.css"/>
<script type="text/javascript" src="/rMateGrid/LicenseKey/rMateGridH5License.js"></script>	<!-- rMateGridH5 라이센스 -->
<script type="text/javascript" src="/rMateGrid/rMateGridH5/JS/rMateGridH5.js"></script>		<!-- rMateGridH5 라이브러리 -->
<script type="text/javascript" src="/rMateGrid/rMateGridH5/JS/jszip.min.js"></script>


<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>
<script src="/js/jquery/jquery-ui.js"></script>
<script src="/js/jquery/jquery.ui.datepicker-ko.js"></script>

<script src="/common/js/jquery-1.11.1.min.js"></script>
<script src="/common/js/mobile-detect.min.js"></script>
<script src="/common/js/slick.js"></script>
<script src="/common/js/pub.plugin.js"></script>
<script src="/common/js/pub.common.js"></script>
<script src="/js/kora/kora_common.js"></script>

<script src="/js/kora/paging_common.js"></script>


<script type="text/javaScript" language="javascript" defer="defer">

/* 페이징 사용 등록 */
gridRowsPerPage 	= 12;	// 1페이지에서 보여줄 행 수
gridCurrentPage 		= 1;	// 현재 페이지
gridTotalRowCount 	= 0; //전체 행 수

var INQ_PARAMS;
var selList 				= [];

$(document).ready(function(){
	
	INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
	//if(INQ_PARAMS ==null) INQ_PARAMS ={}; 
	
	/************************************
	 * 취소 버튼 클릭 이벤트
	 ***********************************/
	$("#btn_cnl").click(function(){
		 $('[layer="close"]').trigger('click');
	});

	/************************************
	 * 조회 버튼 클릭 이벤트
	 ***********************************/
	$("#btn_sel").click(function(){
		//조회버튼 클릭시 페이징 초기화
		gridCurrentPage = 1;
		fn_sel();
	});
	
	
	/************************************
	 * FAQ 버튼 클릭 이벤트
	 ***********************************/
	$("#btn_page2").click(function(){
		fn_page();
	});
 	 //파라미터 조회조건으로 셋팅
	 if( kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
			kora.common.jsonToTable("params",INQ_PARAMS.SEL_PARAMS);
			/* 화면이동 페이징 셋팅 */
			gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
			$("#SBJ_CNTN_TYPE").val(INQ_PARAMS.SEL_PARAMS.SBJ_CNTN_TYPE);
			$("#SBJ_CNTN").val(INQ_PARAMS.SEL_PARAMS.SBJ_CNTN);
		} 
		
	fn_init();		//초기 값
	 
		
	//그리드 셋팅
	fnSetGrid1(); 	
	$("#SBJ_CNTN").keydown(function(e){if(e.keyCode == 13)  fn_sel(); });
});

	//초기 셋팅
	function fn_init(){
		
		var url ="/EP/EPCE0098201_19.do"
		var input ={};
		input["SBJ_CNTN_TYPE"] 	= $("#SBJ_CNTN_TYPE").val();	//제목 ,내용 타입
	  	input["SBJ_CNTN"] 			= $("#SBJ_CNTN").val(); 	
	  	/* 페이징  */
		input["ROWS_PER_PAGE"] = gridRowsPerPage;
		input["CURRENT_PAGE"] 	= gridCurrentPage;
	
		INQ_PARAMS["SEL_PARAMS"] = input;
		ajaxPost(url, input, function(rtnData){
				if ("" != rtnData && null != rtnData) {   
					selList=rtnData.selList ;
						/* 페이징 표시 */
					gridTotalRowCount = rtnData.totalCnt; //총 카운트
					$("#SEL_CNT").text(gridTotalRowCount);
					drawGridPagingNavigation(gridCurrentPage);
				}else{
						 alertMsg("error");
				}
		},false);	
		 
	}
 	 //조회
 	 function fn_sel(){
 		var url ="/EP/EPCE0098201_19.do"
		var input	={};
		
		input["SBJ_CNTN_TYPE"] 	= $("#SBJ_CNTN_TYPE").val();	//제목 ,내용 타입
	  	input["SBJ_CNTN"] 			= $("#SBJ_CNTN").val(); 			
		
		/* 페이징  */
		input["ROWS_PER_PAGE"] = gridRowsPerPage;
		input["CURRENT_PAGE"] 	= gridCurrentPage;
		INQ_PARAMS["SEL_PARAMS"] = input;
		ajaxPost(url, input, function(rtnData){
				if ("" != rtnData && null != rtnData) {   
					gridApp.setData(rtnData.selList);
   					/* 페이징 표시 */
					gridTotalRowCount = rtnData.totalCnt; //총 카운트
					$("#SEL_CNT").text(gridTotalRowCount);
					drawGridPagingNavigation(gridCurrentPage);
				}else{
					alertMsg(rtnData.RSLT_MSG);
				}
		});
		
 	 }
 	
 	 
 	//상세
 	function link(){
 		var idx = dataGrid.getSelectedIndices();
 		var input = gridRoot.getItemAt(idx);
 		//파라미터에 조회조건값 저장 
 		INQ_PARAMS["PARAMS"] = {};
 		INQ_PARAMS["PARAMS"] = input;
 		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
 		INQ_PARAMS["URL_CALLBACK"] = "/EP/EPCE0098201.do";
 		kora.common.goPage('/EP/EPCE0098288.do', INQ_PARAMS);
 	}
 	
 	//FAQ이동
 	function fn_page(){
 		INQ_PARAMS={};
 		kora.common.goPage('/EP/EPCE00982882.do', INQ_PARAMS);
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
 			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" sortableColumns="true"    headerHeight="35">');
 			layoutStr.push('		<groupedColumns>');   	
 			layoutStr.push('			<DataGridColumn dataField="NOTI_SEQ"	headerText="번호"		width="50"  textAlign="center"		    />');		//번호
 			layoutStr.push('			<DataGridColumn dataField="SBJ" 				headerText="제목"		width="350"  textAlign="left" 	   itemRenderer="HtmlItem" />');		//제목
 			layoutStr.push('			<DataGridColumn dataField="REG_DTTM"	headerText="등록일" 	width="100"  textAlign="center"		  />'); 	//등록일
 			layoutStr.push('			<DataGridColumn dataField="SEL_CNT" 		headerText="조회수"  	width="100"  textAlign="center" />');		//조회수
 			layoutStr.push('		</groupedColumns>');
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
 		gridApp.setData();
 		var layoutCompleteHandler = function(event) {
 			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
 			dataGrid.addEventListener("change", selectionChangeHandler);
 			
 			 //파라미터 call back function 실행
			 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
			 	eval(INQ_PARAMS.FN_CALLBACK+"()");
			 }else{
				gridApp.setData(selList);
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

 /****************************************** 그리드 셋팅 끝***************************************** */


</script>
<style type="text/css">


</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>

	<div class="layer_popup" style="width: 820px;">
		<div class="layer_head">
			<h1 class="layer_title">문의하기</h1>
		</div>
		<div class="layer_body">
			<div class="secwrap">
				<div class="infobox">
					<div class="inner">
						<div class="call">
							<span class="color1">지급관리 시스템 콜센터</span>1522 - 0082
						</div>
						<div class="time">
							<strong>운영시간 : 평일(월~금) 9시~18시</strong><br> 토,일요일과 공휴일은 운영하지
							않습니다.
						</div>
					</div>
				</div>
			</div>
			<div class="secwrap mt30">
				<div class="tablist">
					<ul>
						<li class="on"><a style="cursor: pointer;" id="btn_page1">공지사항</a></li>
						<li><a style="cursor: pointer;" id="btn_page2">FAQ</a></li>
					</ul>
					<div class="btnbox">
						<a class="btn36 c11" style="width: 100px;"
							href="https://113366.com/cosmoor/">원격지원요청</a>
					</div>
				</div>
				<div class="tabcont mt25">
					<div>
						<div class="titbox">공지사항</div>
						<div class="srcharea" id="params">
							<div class="srchbox">
								<div class="count">
									총 <span class="num" id='SEL_CNT'></span>건
								</div>
								<div class="ipt_box">
									<select style="width: 99px;" id="SBJ_CNTN_TYPE">
										<option value="S" selected>제목</option>
										<option value="C">내용</option>
									</select> 
									<input type="text" style="width: 353px; margin-left: 5px;"id="SBJ_CNTN"> 
									<a class="btn36 c2"style="width: 80px; margin-left: 10px; cursor: pointer;"	id='btn_sel'>검색</a>
								</div>
							</div>
						</div>
						<div class="boxarea mt10">
							<div id="gridHolder" style="height: 300px; background: #FFF;"></div>
							<div class="gridPaging" id="gridPageNavigationDiv"></div>	<!-- 페이징 사용 등록 -->
						</div><!-- 그리드 셋팅 -->
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>