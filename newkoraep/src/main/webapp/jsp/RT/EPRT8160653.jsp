<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">

	//rMate 그리드 생성 준비가 완료된 상태 시 호출할 함수를 지정합니다.
	var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
	var gridApp, gridRoot, dataGrid;
	var layoutStr = new Array(); 
	
	var jParams;
	var voteAbleYn = "N";
	var voteYn = "N";
	var rstTrgtCd = "";
	
	$(document).ready(function(){
		gridSet();
		fn_btnSetting();
		
		jParams = jsonObject($("#INQ_PARAMS").val());
		
		$(".row > .col> .tit").each(function(){
			if($(this).attr("id")) $(this).text(parent.fn_text($(this).attr("id")));
		});
		
		$(".row > .col> .box").children().each(function(){
			if($(this).attr("alt")) $(this).attr("alt", parent.fn_text($(this).attr("alt")));
		});
	
		if(Object.keys(jParams).length > 0){
			for(var key in jParams){
				$("#" + key).val(jParams[key]);
			}
			fn_search();
		}
		
		//조회
		$("#btn_sel").click(function(){
			fn_search();
		});
			
		//설문참여하기
		$("#btn_go_vote").click(function(){
			fn_go_vote();
		});
	});
	

	//조회
	function fn_search(){
		var sbj = $.trim($("#SEARCH_SBJ").val());
		var sData = {"SBJ" : sbj};
		var url = "/RT/EPRT8160653_19.do";

		showLoadingBar();
		ajaxPost(url, sData, function(rtnData){
			hideLoadingBar();
			if(rtnData != null && rtnData != ""){				
				gridApp.setData(rtnData.searchList);
				$("#total").text(parent.fn_text('tot')+" "+rtnData.searchList.length + parent.fn_text('cnt'));
			} else {
				alertMsg("error");
			}
		});
	}
	
	
	//설문참여하기 페이지로~~
	function fn_go_vote(){
		var BIZR_TP_CD = $("#BIZR_TP_CD").val().substring(0,1);
		var idx = dataGrid.getSelectedIndex();
		if(idx == null || idx == undefined || idx < 0){
			alertMsg("참여할 설문조사를 선택 하세요");
			return;
		}
		
		var url = "/RT/EPRT81606531.do";	//설문참여 페이지
		if(voteAbleYn != "Y" || voteYn == "Y"){
			//T1:센터, M1: 주류생산자, M2: 음료생산자, W1.도매업자, W2: 공병상, R1: 소매업자(가정용), R2: 소매업자(영업용)
			if( BIZR_TP_CD != 'T' ){// 센터는 해당 안됨.
				if( rstTrgtCd == 'A' ){// 모든사용자
				}else if( rstTrgtCd == 'N' ){// 확인불가
					alertMsg("이미 참여 하였거나 참여 하실수 없는 설문입니다.");
					return;
				}else{
					if( rstTrgtCd != BIZR_TP_CD ){
						alertMsg("이미 참여 하였거나 참여 하실수 없는 설문입니다.");
						return;
					}
				}
			}
			url = "/RT/EPRT81606532.do";	//설문결과 페이지
		}
		
		jParams = gridRoot.getItemAt(idx);
		jParams["SEARCH_SBJ"] = $.trim($("#SEARCH_SBJ").val());
		kora.common.goPage(url, jParams);
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
		layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" headerHeight="35" doubleClickEnabled="true" >');
		layoutStr.push('		<columns>');
		layoutStr.push('			<DataGridSelectorColumn id="selector" allowMultipleSelection="false" textAlign="center" headerText="' + parent.fn_text('cho') + '" width="4%" />');
		layoutStr.push('			<DataGridColumn dataField="index" headerText="번호" itemRenderer="IndexNoItem" textAlign="center" width="4%"/>');
		layoutStr.push('			<DataGridColumn dataField="SBJ" headerText="' + parent.fn_text('tit_svy_sbj') + '"  width="35%" />');
		layoutStr.push('			<DataGridColumn dataField="SVY_SE_CD_NM" headerText="' + parent.fn_text('tit_svy_se_cd') + '"  textAlign="center" width="10%" />');
		layoutStr.push('			<DataGridColumn dataField="SVY_TRGT_CD_NM" headerText="' + parent.fn_text('tit_svy_trgt_cd') + '"  textAlign="center" width="10%" />');
		layoutStr.push('			<DataGridColumn dataField="SVY_ST_DT" headerText="' + parent.fn_text('tit_st_dt') + '" formatter="{datefmt2}" textAlign="center"  width="10%"/>');	
		layoutStr.push('			<DataGridColumn dataField="SVY_END_DT" headerText="' + parent.fn_text('tit_end_dt') + '" formatter="{datefmt2}" textAlign="center"  width="10%"/>');				
		layoutStr.push('			<DataGridColumn dataField="SVY_ITEM_CNT" headerText="' + parent.fn_text('tit_item_cnt') + '" formatter="{numfmt}" textAlign="center"  width="8%" />');
		layoutStr.push('			<DataGridColumn dataField="VOTE_CNT" headerText="' + parent.fn_text('tit_vote_cnt') + '" textAlign="center"  width="8%" />');
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
		
		//행선택
		var selectionChangeHandler = function(event) {				
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			if(rowIndex == null || rowIndex == undefined || rowIndex < 0) return;
			selectorColumn.setSelectedIndex(-1);
			selectorColumn.setSelectedIndex(rowIndex);
			
			var dataRow = gridRoot.getItemAt(rowIndex);
			voteAbleYn = dataRow["VOTE_ABLE_YN"];
			voteYn = dataRow["VOTE_YN"];
			rstTrgtCd = dataRow["RST_TRGT_CD"];
		}
		
		var dobuleClickHandler = function(event) {
			fn_go_vote();
		}
		
		var layoutCompleteHandler = function(event) {
		    dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		    
		    selectorColumn = gridRoot.getObjectById("selector");
		    dataGrid.addEventListener("change", selectionChangeHandler);
		    dataGrid.addEventListener("itemDoubleClick", dobuleClickHandler);
		}
		
		var dataCompleteHandler = function(event) {
		    dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		    dataGrid.setEnabled(true);
		    gridRoot.removeLoadingBar();
		}
		
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);

		//gridApp.setData([]);
		fn_search();
	};
	

	function showLoadingBar() {
		kora.common.showLoadingBar(dataGrid, gridRoot);
	}

	function hideLoadingBar() {
		kora.common.hideLoadingBar(dataGrid, gridRoot);
	}
	

	</script>
	
	<div class="iframe_inner">
	<input type="hidden" id="BIZR_TP_CD" value="<c:out value='${BIZR_TP_CD}'/>" />
		<div class="h3group">
			<h3 class="tit" id="title"></h3>		
		</div>
	
        <!-- 검색조건 -->
        <section class="secwrap">
            <div class="srcharea">
                <div class="row">
                    <div class="col" id="total" style="margin-top: 12px;"></div>
                    <div class="col" style="float: right;">
                        <div class="btn" style="float:right" id="UR"></div>
                    </div>
                    <div class="col" style="margin-right: 37px; float: right; margin-top: 6px;">
                        <div class="tit" style="padding-right: 15px;" id="tit_svy_sbj"></div>
                        <div class="box" style="width:20%;">
                            <input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}'/>" />
                            <input id="SEARCH_SBJ" name="SEARCH_SBJ" type="text" style="width:200px;" alt=""  maxlength="20" />
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- //검색조건 -->
		
		<div class="h4group mt30">
			<div class="btn_box" id="CR"></div>
		</div>
		<!-- 조회 리스트 그리드 -->
		<section class="secwrap">
			<div class="boxarea">
				<div id="gridHolder" style="height:418px;"></div>
			</div>
		</section>
		
	
		
	</div>	<!-- //iframe_inner -->
	