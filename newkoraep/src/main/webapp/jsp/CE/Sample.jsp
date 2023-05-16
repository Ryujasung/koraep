<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>게시판-공지사항</title>

<link rel="stylesheet" href="/css/basic.css" type="text/css">
<link rel="stylesheet" href="/css/common.css" type="text/css">
<link rel="stylesheet" type="text/css" href="/rGridDemo/Samples/rMateGridH5Sample.css"/>
<link rel="stylesheet" type="text/css" href="/rGridDemo/rMateGridH5/Assets/rMateH5.css"/>
<!-- rMateGridH5 라이센스 -->
<script type="text/javascript" src="/rGridDemo/LicenseKey/rMateGridH5License.js"></script>
<!-- rMateGridH5 라이브러리 -->
<script type="text/javascript" src="/rGridDemo/rMateGridH5/JS/rMateGridH5.js"></script>

<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>
<script src="/js/common.js" ></script>
<script type="text/javascript" src="/js/kora/kora_common.js" ></script>

<script type="text/javaScript" language="javascript" defer="defer" charset="utf-8">

var strMbrSeCd = gfn_getCookie("MBR_SE_CD");
var strGrpCd   = gfn_getCookie("GRP_CD"); //메뉴권한그룹 추가(20151120 DHC)
var totalRow = 0;
var jParams = {};

//페이징 관련 자바스크립트
var gridTotalRowCount;	// 전체 데이터 건수 - html이 서버에서 작성될때 반드시 넣어줘야 하는 변수입니다.

var gridRowsPerPage = 12;	// 1페이지에서 보여줄 행 수
var gridViewPageCount = 10;		// 페이지 네비게이션에서 보여줄 페이지의 수
var gridCurrentPage = 1;	// 현재 페이지
var gridTotalPage;	// 전체 페이지 계산

var epcnMbrList = ${epcnMbrList};  //epcnMbrList[i].BIZRNO
var grdStdList = [];

$(document).ready(function(){
	
	totalRow = ${totalCnt}[0].CNT;
	
	//페이지이동 조회조건 파라메터 정보
	jParams = ${INQ_PARAMS};
	
	//페이지이동 조회조건 데이터 셋팅
	kora.common.jsonToTable("TABLE_INQ",jParams);
	fnCommSetLabel(epcnMbrList, grdStdList, "CTNR_CD", "CTNR_NM");
	
	$("#total").text("총 "+totalRow+"건");
	
	$("#btnIns").show();
	
	
	gridSet();
});

function fnCommSetLabel(data, grdData, grdCode, grdLabel){
	
	var grd = grdData;
	
	try {
		$.each(data, function(i, v) {
			var $code  = eval("v."+grdCode);
			var $value = eval("v."+grdLabel);
			
			grd.push({'label':$value, 'code':$code});
			
		});
		
	} catch (e) {
		alertMsg("Label 만들기 실패!");
		return;
	}
	
}

//공지사항등록 화면으로 이동
function linknlnm(){
	
	var sAction="/EPMB/EPMBNLNM.do";
	
	var jParams = {"FN_CALLBACK" : "search"};
	kora.common.goPageD(sAction, jParams, {"cate":$("#cate").val(), "word":$("#word").val(), "NOW_PAGE" : gridCurrentPage});
	
}

//상세조회링크
function link(seq){
	
	var idx = dataGrid.getSelectedIndices();
	
	var item = gridRoot.getItemAt(idx);
	
	var sAction="/EPMB/EPMBNLND.do";
	
	//페이지이동
    kora.common.goPageD(sAction, {"SEQ": seq}, {"cate":$("#cate").val(), "word":$("#word").val(), "NOW_PAGE" : gridCurrentPage, "FN_CALLBACK" : "search"});
	
};

//----------------------- 그리드 설정 시작 -------------------------------------

//rMate 그리드 생성 준비가 완료된 상태 시 호출할 함수를 지정합니다.
var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
var gridApp, gridRoot, dataGrid;
var layoutStr = new Array(); 

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
	layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');  // 1,222
	layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" headerHeight="35" horizontalScrollPolicy="auto" >');
	layoutStr.push('		<columns>');
	layoutStr.push('			<DataGridColumn dataField="IDX" headerText="번호" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
	layoutStr.push('			<DataGridColumn dataField="STD_CTNR_CD" headerText="STD_CTNR_CD" width="100"    itemEditor="ComboBoxEditor" editorDataField="selectedDataField" itemRendererDataField="code" itemRenderer="DataProviderItem" itemRendererDataProvider="'+JSON.stringify(grdStdList).replace( eval("/" + "\"" + "/g"),"\'")+'" />'); 
	layoutStr.push('			<DataGridColumn dataField="DTSS_NO" headerText="DTSS_NO" width="100"    itemEditor="ComboBoxEditor" editorDataField="selectedDataField" itemRendererDataField="code" itemRenderer="DataProviderItem" itemRendererDataProvider="'+JSON.stringify(grdStdList).replace( eval("/" + "\"" + "/g"),"\'")+'" />'); 
	layoutStr.push('			<DataGridColumn dataField="SBJ" headerText="제목" width="200" />');
	layoutStr.push('			<DataGridColumn dataField="JOB" headerText="JOB" width="20"     />');
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
	
	var selectionChangeHandler = function(event) {				
		var rowIndex = event.rowIndex;
		var columnIndex = event.columnIndex;
	}
	
	var layoutCompleteHandler = function(event) {
	    dataGrid = gridRoot.getDataGrid();  // 그리드 객체
	    dataGrid.addEventListener("change", selectionChangeHandler);
	}
	
	var dataCompleteHandler = function(event) {
	    dataGrid = gridRoot.getDataGrid();  // 그리드 객체
	    dataGrid.setEnabled(true);
	    gridRoot.removeLoadingBar();
	}
	
	gridRoot.addEventListener("dataComplete", dataCompleteHandler);
	gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	gridApp.setData();  //${searchList}
	
	if(kora.common.null2void(jParams.FN_CALLBACK) != ""){
		eval(jParams.FN_CALLBACK+"()");
	} else {
	//	gridMovePage(gridCurrentPage);
	}
	
}

//----------------------- 그리드 설정 끝 -----------------------

function showLoadingBar() {
	kora.common.showLoadingBar(dataGrid, gridRoot);
}

function hideLoadingBar() {
	kora.common.hideLoadingBar(dataGrid, gridRoot);
}

// 주어진 페이지 번호에 따라 페이지 네비게이션 html을 만들고 gridPageNavigationDiv에 innerHTML로 넣어줍니다.
function drawGridPagingNavigation(goPage) {
	
	gridTotalRowCount = totalRow;
	gridTotalPage = Math.ceil(gridTotalRowCount / gridRowsPerPage);
	
	if (gridTotalPage == 0) {
		gridPageNavigationDiv.innerHTML = "<span class='pageBtn'> <a class='first'><em class='blind'>처음페이지</em></a> <a class='prev'><em class='blind'>이전페이지</em></a> <a class='next'><em class='blind'>다음페이지</em></a> <a class='last'><em class='blind'>마지막페이지</em></a> </span>";
		return;
	}
	
	var retStr = "";
	var prepage = parseInt((goPage - 1)/gridViewPageCount) * gridViewPageCount;
	var nextpage = ((parseInt((goPage - 1)/gridViewPageCount)) * gridViewPageCount) + gridViewPageCount + 1;
	
	// 맨앞으로
	retStr += "<span class='pageBtn'> ";
	if (goPage > 1) {
		retStr += "<a href='javascript:gridMovePage(1)' class='first_on'><em class='blind'>처음페이지</em></a> ";
	} else {
		retStr += "<a class='first'><em class='blind'>처음페이지</em></a> ";
	}
	
	// 앞으로
	if (goPage > gridViewPageCount) {
		retStr += "<a href='javascript:gridMovePage(" + prepage + ")' class='prev_on'><em class='blind'>이전페이지</em></a> ";
	} else {
		retStr += "<a class='prev'><em class='blind'>이전페이지</em></a> ";
	}
	
	retStr += "</span> <span class='num'> ";

	for (var i = (1 + prepage); i < gridViewPageCount + 1 + prepage; i++) {
		if (goPage == i) {
			if(1 == goPage){
				retStr += "<strong class='bg_none'>";
			} else {
				retStr += "<strong>";
			}
			retStr += i;
			retStr += "</strong> ";
		} else {
			retStr += "<a href='javascript:gridMovePage(" + i + ")'>" + i + "</a> ";
		}

		if (i >= gridTotalPage) {
			break;
		}
		
	}
	
	retStr += "</span> <span class='pageBtn'> ";

	// 뒤로
	if (nextpage <= gridTotalPage) {
		retStr += "<a href='javascript:gridMovePage(" + nextpage + ")' class='next_on'><em class='blind'>다음페이지</em></a> ";
	} else {
		retStr += "<a class='next'><em class='blind'>다음페이지</em></a> ";
	}
	
	// 맨뒤로
	if (goPage != gridTotalPage) {
		retStr += "<a href='javascript:gridMovePage(" + gridTotalPage + ")' class='last_on'><em class='blind'>마지막페이지</em></a> </span>";
	} else {
		retStr += "<a class='last'><em class='blind'>마지막페이지</em></a> </span>";
	}
	
	gridPageNavigationDiv.innerHTML = retStr;
	
}

function gridMovePage(goPage) {
	
	search(goPage);
	
}

//페이징 조회
function search(goPage){
	
	if(goPage == null) {
		if($("#NOW_PAGE").val() > 0){
			goPage = $("#NOW_PAGE").val();
		}
		else {
			goPage = gridCurrentPage
		}
	}
	
	var sData = {"CONDITION":$("#cate").val(), "WORD":$("#word").val(), "PAGE" : goPage, "CNTROW" : gridRowsPerPage};
	var url = "/CE/SAMPLE_SELECT.do";
	
	showLoadingBar();
	ajaxPost(url, sData, function(rtnData){
		
		if(rtnData != null && rtnData != ""){
			gridApp.setData(rtnData.searchList);
			totalRow = rtnData.totalCnt[0].CNT;
			drawGridPagingNavigation(goPage);
			gridCurrentPage = goPage;
			$("#total").text("총 "+totalRow+"건");
		} else {
			alertMsg("error");
		}
		
	});
	hideLoadingBar();
};


//Row 값 넣기    //epcnMbrList[i].BIZRNO
function insRow(){
	
	var item = {};
	for(var i=0; i<epcnMbrList.length; i++){
		//	item["SBJ"] =epcnMbrList[i].BIZRNO;
	}
	
	return item;
};


//행추가
function addRow(){
	
	var item = insRow();
	gridRoot.addItemAt(item);
	
}

//행삭제
function delRow(){
	
	var idx = dataGrid.getSelectedIndices();
	
	reset();
	
	gridRoot.removeItemAt(idx);
	
};

</script>

	
</head>
<body>

<div id="skipNavi">
	<strong>컨텐츠 바로가기</strong>
	<ul>
		<li><a href="#nav">주메뉴 바로가기</a></li>
		<li><a href="#contents">본문으로 바로가기</a></li>
	</ul>
</div>

<div id="wrap">
	<header>
		<div class="gnbGroup">
			<h1><a id="mainLogo" href="#"><img src="/images/img_logo.jpg" alt="KORA 한국순환자원유통지원센터"></a></h1>
			<ul class="gnb">
			</ul>
			
			<div class="subMenu">
			</div>
			
			<div class="lnk">
				<a id="adminLnk" href="#">관리자</a>
				<a id="helpLnk" href="#">도움말</a>
			</div>
		</div>
	</header>
	
	<div id="container">
		<div class="left_ct">
			<div class="loginBox">
				<p class="admin"><strong>관리자</strong>님 반갑습니다.</p>
				<div class="btnBox">
					<span class="btnLogout"><a href="#">로그아웃</a></span>
					<span><a id="myMenu" href="#">My메뉴</a></span>
				</div>
			</div>
			<nav id="nav" class="lnb">
			</nav>
		</div>
		<div id="contents" class="contents">
			<h3>공지사항</h3>
			<div class="noticeTop">
				<p class="total" id="total"></p>
				<p class="search" id="TABLE_INQ">
					<input type="hidden" id="NOW_PAGE" value="-1">
					<span>
						<select id="cate" style="width:87px">
							<option value="sbj">제목</option>
							<option value="cntn">내용</option>
						</select>
					</span>
					<span><input type="text" id="word" style="width:180px" maxByteLength="60"></span>
					<span><a href="javascript:search();" class="btn_s">검색</a></span>
				</p>
			</div>
			
			<div class="buttonList textR">
				<span><a href="javascript:delRow();" class="btn minus">행삭제</a></span>
				<span><a href="javascript:addRow();" class="btn plus">행추가</a></span>
			</div>
			
			<div class="table_box">
				<div class="tableGrid" id="gridHolder" style="height:304px; width:785px;">
				</div>
				<div class="paging" id="gridPageNavigationDiv">
				</div>
								
				<div class="buttonR_bottom">
					<a href="javascript:linknlnm();" class="btn_b" id="btnIns">등록</a>
				</div>
				
			</div>
		</div>	<!-- //contents -->
	</div>		<!-- //container -->
	
	<footer id="footer">

	</footer>
</div>
</body>
</html>