<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">

	//rMate 그리드 생성 준비가 완료된 상태 시 호출할 함수를 지정합니다.
	var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
	var gridApp, gridRoot, dataGrid;
	var layoutStr = new Array(); 
	
	var jParams = ${INQ_PARAMS};
	
	var toDay = kora.common.gfn_toDay();  // 현재 시간
	
	$(document).ready(function(){
		gridSet();
		fn_btnSetting();
		
		$(".row > .col> .tit").each(function(){
			if($(this).attr("id")) $(this).text(parent.fn_text($(this).attr("id")));
		});
		
		$(".row > .col> .box").children().each(function(){
			if($(this).attr("alt")) $(this).attr("alt", parent.fn_text($(this).attr("alt")));
		});
	
		$('#use_y').text(parent.fn_text('use_y'));
		$('#use_n').text(parent.fn_text('use_n'));
		$("#SVY_NO").prop("disabled",true);
		
		var svy_se_cd_list = ${svy_se_cd_list};
		var svy_trgt_cd_list = ${svy_trgt_cd_list};
		
		kora.common.setEtcCmBx2(svy_se_cd_list, "", "", $("#SEARCH_SVY_SE_CD"), "ETC_CD", "ETC_CD_NM", "N", "T");
		kora.common.setEtcCmBx2(svy_trgt_cd_list, "", "", $("#SEARCH_SVY_TRGT_CD"), "ETC_CD", "ETC_CD_NM", "N", "T");
		
		kora.common.setEtcCmBx2(svy_se_cd_list, "", "", $("#SVY_SE_CD"), "ETC_CD", "ETC_CD_NM", "N", "S");
		kora.common.setEtcCmBx2(svy_trgt_cd_list, "", "", $("#SVY_TRGT_CD"), "ETC_CD", "ETC_CD_NM", "N", "S");
		
		
		$('#SVY_ST_DT').YJcalendar({  
			toName : 'to',
			triggerBtn : true,
			dateSetting : toDay
		});
		$('#SVY_END_DT').YJcalendar({
			fromName : 'from',
			triggerBtn : true,
			dateSetting : toDay
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
		
		//초기화
		$("#btn_init").click(function(){
			fn_frmInit();
		});
		
		//저장
		$("#btn_reg").click(function(){
			fn_reg();
		});

		
		//설문문항등록
		$("#btn_item_reg").click(function(){
			fn_item_reg();
		});
	});
	

	//조회
	function fn_search(){
		var se_cd = $("#SEARCH_SVY_SE_CD").val();
		var trgt_cd = $("#SEARCH_SVY_TRGT_CD").val();
		var sbj = $.trim($("#SEARCH_SBJ").val());
		
		var sData = {"SVY_SE_CD":se_cd, "SVY_TRGT_CD":trgt_cd, "SBJ" : sbj};
		var url = "/MF/EPMF8160601_19.do";
		
		showLoadingBar();
		ajaxPost(url, sData, function(rtnData){
			hideLoadingBar();
			if(rtnData != null && rtnData != ""){				
				gridApp.setData(rtnData.searchList);				
			} else {
				alertMsg("error");
			}
		});
	}
	
	
	
	//입력폼 초기화
	function fn_frmInit(){
		var dt = toDay.substring(0,4)+"-"+toDay.substring(4,6)+"-"+toDay.substring(6);
		$("#SVY_NO").val("");
		$("#SBJ").val("");
		$("#SVY_SE_CD").val("");
		$("#SVY_TRGT_CD").val("");
		$("#SVY_ST_DT").val(dt);  //calendar 셋팅
		$("#SVY_END_DT").val(dt); // calender 셋팅
		$(":radio[name='USE_YN']").eq(0).prop("checked", true);
		
		dataGrid.setSelectedIndex(-1);
	}
	
	
	//저장
	function fn_reg(){
		var svy_no = $("#SVY_NO").val();
		var sData = kora.common.gfn_formData("frmSvy");
		
		sData["SVY_NO"] = "";
		if(svy_no != null && svy_no != "") sData["SVY_NO"] = svy_no;
		
		if(!kora.common.cfrmDivChkValid("frmSvy")) return;				//validation
		
		showLoadingBar();
		ajaxPost("/MF/EPMF8160601_09.do", sData, function(rtnData){
			hideLoadingBar();
			
			alertMsg(rtnData.RSLT_MSG);
			if(rtnData.RSLT_CD != null && rtnData.RSLT_CD != "") return;
			
			fn_search();
		});
	}
	
	//설문 항목등록 페이지로~~
	function fn_item_reg(){
		var idx = dataGrid.getSelectedIndex();
		if(idx == null || idx == undefined || idx < 0){
			alertMsg("등록할 설문조사를 선택 하세요");
			return;
		}
		
		jParams = gridRoot.getItemAt(idx);
		jParams["SEARCH_SVY_SE_CD"] = $("#SEARCH_SVY_SE_CD").val();
		jParams["SEARCH_SVY_TRGT_CD"] = $("#SEARCH_SVY_TRGT_CD").val();
		jParams["SEARCH_SBJ"] = $("#SEARCH_SBJ").val();
		kora.common.goPage('/MF/EPMF81606641.do', jParams);
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
		layoutStr.push('			<DataGridColumn dataField="SVY_NO" headerText="' + parent.fn_text('tit_svy_no') + '" textAlign="center"   width="15%" />');
		layoutStr.push('			<DataGridColumn dataField="SBJ" headerText="' + parent.fn_text('tit_svy_sbj') + '" itemRenderer="HtmlItem"  width="25%" />');
		layoutStr.push('			<DataGridColumn dataField="SVY_SE_CD_NM" headerText="' + parent.fn_text('tit_svy_se_cd') + '"  textAlign="center" width="10%" />');
		layoutStr.push('			<DataGridColumn dataField="SVY_TRGT_CD_NM" headerText="' + parent.fn_text('tit_svy_trgt_cd') + '"  textAlign="center" width="10%" />');
		layoutStr.push('			<DataGridColumn dataField="SVY_ST_DT" headerText="' + parent.fn_text('tit_st_dt') + '" formatter="{datefmt2}" textAlign="center"  width="12%"/>');	
		layoutStr.push('			<DataGridColumn dataField="SVY_END_DT" headerText="' + parent.fn_text('tit_end_dt') + '" formatter="{datefmt2}" textAlign="center"  width="12%"/>');				
		layoutStr.push('			<DataGridColumn dataField="SVY_ITEM_CNT" headerText="' + parent.fn_text('tit_item_cnt') + '" formatter="{numfmt}" textAlign="center"  width="8%" />');
		layoutStr.push('			<DataGridColumn dataField="USE_YN" headerText="' + parent.fn_text('tit_use_yn') + '" textAlign="center"  width="8%" />');
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
			
			var dataRow = gridRoot.getItemAt(rowIndex);
			
			var sDt = dataRow["SVY_ST_DT"];
			var eDt = dataRow["SVY_END_DT"];
			sDt = sDt.substring(0,4)+"-"+sDt.substring(4,6)+"-"+sDt.substring(6);
			eDt = eDt.substring(0,4)+"-"+eDt.substring(4,6)+"-"+eDt.substring(6);
			
			$("#SVY_NO").val(dataRow["SVY_NO"]);
			$("#SBJ").val(dataRow["SBJ"]);
			$("#SVY_SE_CD").val(dataRow["SVY_SE_CD"]);
			$("#SVY_TRGT_CD").val(dataRow["SVY_TRGT_CD"]);
			$("#SVY_ST_DT").val(sDt);  //calendar 셋팅
			$("#SVY_END_DT").val(eDt); // calender 셋팅
			if(dataRow["USE_YN"] == "Y"){
				$(":radio[name='USE_YN']").eq(0).prop("checked", true);
			}else{
				$(":radio[name='USE_YN']").eq(1).prop("checked", true);	
			}
		}
		
		var dobuleClickHandler = function(event) {
			fn_item_reg();
		}
		
		var layoutCompleteHandler = function(event) {
		    dataGrid = gridRoot.getDataGrid();  // 그리드 객체
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

		gridApp.setData([]);
	};
	

	function showLoadingBar() {
		if(dataGrid != null && dataGrid != "undefined"){
			 dataGrid.setEnabled(false);
			 gridRoot.addLoadingBar();
		}
	}

	function hideLoadingBar() {
		if(dataGrid != null && dataGrid != "undefined"){
			 dataGrid.setEnabled(true);
			 gridRoot.removeLoadingBar();
		}
	}
	

	</script>
	
	<div class="iframe_inner">
	
		<div class="h3group">
			<h3 class="tit" id="title"></h3>		
		</div>
	
		<!-- 검색조건 -->
		<section class="secwrap">
			<div class="srcharea">
				<div class="row">
					<div class="col">
						<div class="tit" style="padding-right: 15px;" id="tit_svy_se_cd"></div>
						<div class="box">						
							<select id="SEARCH_SVY_SE_CD" name="SEARCH_SVY_SE_CD" style="width: 150px;">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" style="padding-right: 15px;" id="tit_svy_trgt_cd"></div>
						<div class="box">
							<select id="SEARCH_SVY_TRGT_CD" name="SEARCH_SVY_TRGT_CD" style="width: 150px;">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" style="padding-right: 15px;" id="tit_svy_sbj"></div>
						<div class="box">
							<input id="SEARCH_SBJ" name="SEARCH_SBJ" type="text" style="width: 200px;" alt=""  maxlength="20" />
						</div>
					</div>
					
					<div class="btn" id="UR">
						<!-- 조회버튼 자동처리 -->
					</div>
				</div>
			</div>
		</section>
		<!-- //검색조건 -->
		
		
		<!-- 입력폼 -->
		<section class="secwrap">
			<div class="srcharea" style="margin-top: 50px;">
			
				<form name="frmSvy" id="frmSvy" method="post" onsubmit="return false;">
					<div class="row">
						<div class="col">
							<div class="tit" style="padding-right: 15px;" id="tit_svy_no"></div>
							<div class="box">
								<input id="SVY_NO" name="SVY_NO" type="text" style="width: 200px;" readonly />
							</div>
						</div>
						<div class="col">
							<div class="tit" style="padding-right: 15px;" id="tit_svy_sbj"></div>
							<div class="box">
								<input type="text" id="SBJ" name="SBJ" alt="tit_svy_sbj" style="width: 350px;" maxlength="40" class="i_notnull" />
							</div>
						</div>
					</div>
					
					<div class="row">
						<div class="col">
							<div class="tit"  style="padding-right: 15px;" id="tit_svy_se_cd"></div>
							<div class="box">						
								<select id="SVY_SE_CD" name="SVY_SE_CD" alt="tit_svy_se_cd" class="i_notnull" style="width: 200px;">
								</select>
							</div>
						</div>
						<div class="col">
							<div class="tit" style="padding-right: 15px;" id="tit_svy_trgt_cd"></div>
							<div class="box">
								<select id="SVY_TRGT_CD" name="SVY_TRGT_CD" alt="tit_svy_trgt_cd"  class="i_notnull" style="width: 200px;">
								</select>
							</div>
						</div>
					</div>
					
					
					<div class="row">
						<div class="col">
							<div class="tit" style="padding-right: 15px;" id="tit_svy_term"></div>
							<div class="box">
								<div class="calendar">
									<input type="text" id="SVY_ST_DT" name="SVY_ST_DT" alt="tit_svy_from_dt" readonly style="width: 150px;" class="i_notnull" alt="시작날짜" />
								</div>
								<div class="obj">~</div>
								<div class="calendar">
									<input type="text" id="SVY_END_DT" name="SVY_END_DT" alt="tit_svy_end_dt" readonly style="width: 150px;" class="i_notnull" alt="끝 날짜" />
								</div>
							</div>
						</div>
						<div class="col">
							<div class="tit" style="padding-right: 15px;" id="tit_use_yn"></div>
							<div class="box">
								<label class="rdo"><input type="radio" name="USE_YN" value="Y" checked="checked" /><span id="use_y"></span></label>
								<label class="rdo"><input type="radio" name="USE_YN" value="N"/><span id="use_n"></span></label>
							</div>
						</div>
					</div>
					
				</form>
				
			</div>
		</section>
		<!-- //입력폼 -->

		<!-- 입력처리 버튼 자동 -->
		<section class="btnwrap mt10" >
			<div class="fl_r" id="CR">
			</div>
		</section>
		<!-- //입력처리 버튼 -->
		
		
		<!-- 조회 리스트 그리드 -->
		<section class="secwrap mt30">
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
		
	</div>	<!-- //iframe_inner -->
	