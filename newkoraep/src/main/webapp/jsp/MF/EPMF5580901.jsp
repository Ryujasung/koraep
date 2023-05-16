<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">

//rMate 그리드 생성 준비가 완료된 상태 시 호출할 함수를 지정합니다.
var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
var jsVars2 = "rMateOnLoadCallFunction=gridReadyHandler2";
var gridApp, gridRoot, dataGrid;
var gridApp2, gridRoot2, dataGrid2;
var layoutStr = new Array(); 
var layoutStr2 = new Array();

var myMenuCd = "";
var lnbGrpCd = location.href;

$(document).ready(function(){
	
	myMenuCd = lnbGrpCd.substring(lnbGrpCd.lastIndexOf("/")+1);
	lnbGrpCd = myMenuCd.substring(0,6);
	
	fn_btnSetting(); 
	
	gridSet();
	
	//한글텍스트
	$(".tit").each(function(){
		if($(this).attr("id")) $(this).text(parent.fn_text($(this).attr("id")));
	});
	
	$("#btn_menu_add").click(function(){
		fn_menuAdd();
	});
	
	$("#btn_menu_del").click(function(){
		fn_menuDel();
	});
	
	$("#btn_menu_save").click(function(){
		fn_menuSave();
	});
	
});


//메뉴목록조회
function fn_search(){
	var sData = {};
	var url = "/MF/EPMF5580901_19.do";
	ajaxPost(url, sData, function(rtnData){
		var list = rtnData.allMenuList;
		var idx = -1;
		for(var i=0; i<list.length; i++){
			var url = list[i].MENU_URL;
			if(url.indexOf(myMenuCd) > -1){
				idx = i;
				break;	
			}
		}
		if(idx > -1) list.splice(idx,1);
		
		gridApp.setData(list); 	//전체메뉴 리스트
		gridApp2.setData(rtnData.myMenuList);	//마이메뉴
	});
}


//마이메뉴로 메뉴추가
function fn_menuAdd(){
	var myMenuList = gridRoot2.getGridData();
	
	var obj = gridRoot.getObjectById("selector");
    var idxs = obj.getSelectedIndices();

    if(idxs == null || idxs.length == 0){
    	alertMsg("선택된 메뉴가 없습니다.");
    	return;
    }
    
    //idxs.sort();
    for(var i=0; i<idxs.length; i++){
    	var sData = gridRoot.getItemAt(idxs[i]);
    	var flag = false;
    	for(var x=0; x<myMenuList.length; x++){
    		if(sData["MENU_CD"] == myMenuList[x]["MENU_CD"] 
    			&& sData["LANG_SE_CD"] == myMenuList[x]["LANG_SE_CD"]){
    			flag = true;
    			break;
    		}
    	}
    	
    	if(flag) continue;
    	gridRoot2.addItemAt(sData);
    }
    obj.setSelectedIndices([]);
}

//마이 메뉴에서 삭제
function fn_menuDel(){
	var obj = gridRoot2.getObjectById("selector");
    var idxs = obj.getSelectedIndices();
    
    if(idxs == null || idxs.length == 0){
    	alertMsg("선택된 메뉴가 없습니다.");
    	return;
    }
    
    //idxs.sort();
    for(var i=idxs.length -1; i >= 0; i--){
    	gridRoot2.removeItemAt(idxs[i]);	
    }
}


//마이메뉴 저장
function fn_menuSave(){
	var chgData = gridRoot2.getChangedData();
	
	if(chgData.length <= 0){
		alertMsg("변경된 메뉴가 없습니다.");
		return;
	}
	
	for(var i=0; i<chgData.length; i++){
		var map = chgData[i]["data"];
		map["JOB"] = chgData[i]["job"];
		chgData[i] = map;
	}
	
	var sData = {"list":JSON.stringify(chgData)};
	var url = "/MF/EPMF5580901_09.do";
	ajaxPost(url, sData, function(rtnData){
		alertMsg("저장 되었습니다.");
		gridApp2.setData(rtnData.myMenuList);

		fn_setLnb(rtnData.myMenuList);
	});
}

//lnb 변경
function fn_setLnb(list){
	var lnbTxt = new Array();
	lnbTxt.push('<li><a href="/MF/EPMF5580901.do" id="' + lnbGrpCd + '">마이메뉴관리</a></li>');
	lnbTxt.push('<li><a href="/MF/EPMF5599001.do" id="' + lnbGrpCd + '">본인정보조회</a></li>');
	
	for(var i=0; i<list.length; i++){
		lnbTxt.push('<li><a href="' + list[i].MENU_URL + '" id="' + lnbGrpCd + '">' + list[i].MENU_NM + '</a></li>');
	}

	parent.smObject[lnbGrpCd] = lnbTxt.join("").toString();
	$(".lnb", parent.document).html('<ul>' + parent.smObject[lnbGrpCd] + '</ul>');
	parent.NrvPub.IframePage2();
}


function gridSet(){
	//rMateDataGrid 를 생성합니다.
	rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%"); 
	layoutStr.push('<rMateGrid>');
	layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
	layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
	layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" headerHeight="35" textAlign="center" >');
	layoutStr.push('		<columns>');
	layoutStr.push('			<DataGridSelectorColumn id="selector" allowMultipleSelection="true" verticalAlign="middle" width="15%" />');
	layoutStr.push('			<DataGridColumn dataField="MENU_GRP_NM" headerText="' + parent.fn_text('menu_grp') + '" width="30%" />');
	layoutStr.push('			<DataGridColumn dataField="MENU_NM" headerText="' + parent.fn_text('menu_nm') + '" width="55%" />');
	layoutStr.push('		</columns>');
	layoutStr.push('	</DataGrid>');
	layoutStr.push('</rMateGrid>');

	rMateGridH5.create("grid2", "gridHolder2", jsVars2, "100%", "100%"); 
	layoutStr2.push('<rMateGrid>');
	layoutStr2.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
	layoutStr2.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
	layoutStr2.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg2" sortableColumns="true" sortExpertMode="true" headerHeight="35" textAlign="center">');
	layoutStr2.push('		<columns>');
	layoutStr2.push('			<DataGridSelectorColumn id="selector" allowMultipleSelection="true" verticalAlign="middle" width="15%" />');
	layoutStr2.push('			<DataGridColumn dataField="MENU_GRP_NM" headerText="' + parent.fn_text('menu_grp') + '" width="30%" />');
	layoutStr2.push('			<DataGridColumn dataField="MENU_NM" headerText="' + parent.fn_text('menu_nm') + '" width="55%" />');
	layoutStr2.push('		</columns>');
	layoutStr2.push('	</DataGrid>');
	layoutStr2.push('</rMateGrid>');

}

//좌측 조사문항 이벤트 핸들러
function gridReadyHandler(id) {
	gridApp = document.getElementById(id);  // 그리드를 포함하는 div 객체
	gridRoot = gridApp.getRoot();   // 데이터와 그리드를 포함하는 객체
	
	gridApp.setLayout(layoutStr.join("").toString());
	
	//행선택
	var selectionChangeHandler = function(event) {				
		var rowIndex = event.rowIndex;
		var columnIndex = event.columnIndex;
		if(rowIndex == null || rowIndex == undefined || rowIndex < 0) return;
	}
	
	var layoutCompleteHandler = function(event) {
	    dataGrid = gridRoot.getDataGrid();  // 그리드 객체
	    dataGrid.addEventListener("change", selectionChangeHandler);
	    
	    fn_search();
	}
	
	var dataCompleteHandler = function(event) {
	    dataGrid = gridRoot.getDataGrid();  // 그리드 객체
	    dataGrid.setEnabled(true);
	    gridRoot.removeLoadingBar();
	}
	
	gridRoot.addEventListener("dataComplete", dataCompleteHandler);
	gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);

	gridApp.setData([]);
};


//우측 선택문항 옵션 이벤트 핸들러
function gridReadyHandler2(id) {
	gridApp2 = document.getElementById(id);  // 그리드를 포함하는 div 객체
	gridRoot2 = gridApp2.getRoot();   // 데이터와 그리드를 포함하는 객체
	
	gridApp2.setLayout(layoutStr2.join("").toString());
	
	//행선택
	var selectionChangeHandler2 = function(event) {				
		var rowIndex = event.rowIndex;
		var columnIndex = event.columnIndex;
		if(rowIndex == null || rowIndex == undefined || rowIndex < 0) return;
	}
	
	var layoutCompleteHandler2 = function(event) {
	    dataGrid2 = gridRoot2.getDataGrid();  // 그리드 객체
	    dataGrid2.addEventListener("change", selectionChangeHandler2);
	}
	
	
	var dataCompleteHandler2 = function(event) {
		dataGrid2 = gridRoot2.getDataGrid();  // 그리드 객체
		dataGrid2.setEnabled(true);
		gridRoot2.removeLoadingBar();
	}
	
	gridRoot2.addEventListener("dataComplete", dataCompleteHandler2);
	gridRoot2.addEventListener("layoutComplete", layoutCompleteHandler2);

	gridApp2.setData([]);
};



function showLoadingBar() {
	 kora.common.showLoadingBar(dataGrid, gridRoot);
}

function hideLoadingBar() {
	kora.common.hideLoadingBar(dataGrid, gridRoot);
}


</script>
	
	<div class="iframe_inner">
	
		<div class="h3group">
			<h3 class="tit" id="title"></h3>		
		</div>
	
	
		<!-- 입력폼 -->
		<!-- 
		<section class="secwrap">
			<div class="srcharea" style="margin-top: 50px;">
			</div>
		</section>
		 -->
		<!-- //입력폼 -->
	
		<!-- 조회 리스트 그리드 -->
		<section class="secwrap">
			<div class="halfarea" style="width: 47%; float: left;">
				<div class="h4group">
					<h4 class="tit" style="float:left;" id='menu'></h4>
					<div class="btn_box" style="float:right;" id="CL">

					</div>
				</div>
				
		        <div class="boxarea">
		            <div id="gridHolder" class="w_382" style="height:400px;"></div>
		        </div> 
			</div>
			
		    <div class="halfarea" style="width: 47%; float: right;">
				<div class="h4group">
					<h4 class="tit" style="float:left;" id='tit_my_menu'></h4>
					<div class="btn_box" style="float:right;" id="CR">

					</div>
				</div>
		      	<div class="boxarea">
		      	    <div id="gridHolder2" class="w_382" style="height:400px;">  
		      	</div>
	      </div>
		</section>
		
	</div>	<!-- //iframe_inner -->
	