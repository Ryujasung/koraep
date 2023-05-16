<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">

	//rMate 그리드 생성 준비가 완료된 상태 시 호출할 함수를 지정합니다.
	var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
	var gridApp, gridRoot, dataGrid;
	var layoutStr = new Array(); 
	
	var jParams;
	
	var toDay = kora.common.gfn_toDay();  // 현재 시간
	var endDt = kora.common.getDate("yyyy-mm-dd",  "M", 1, null);

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
	
		$('#use_y').text(parent.fn_text('use_y'));
		$('#use_n').text(parent.fn_text('use_n'));
		
        $('#aplc_y').text(parent.fn_text('aplc_y'));
        $('#aplc_n').text(parent.fn_text('aplc_n'));
        
        $('#popup_y').text(parent.fn_text('popup_y'));
        $('#popup_n').text(parent.fn_text('popup_n'));

		
		$("#SVY_NO").prop("disabled",true);
		
		var svy_se_cd_list = jsonObject($("#svy_se_cd_list").val());
		var svy_trgt_cd_list = jsonObject($("#svy_trgt_cd_list").val());
		var rst_trgt_cd_list = jsonObject($("#rst_trgt_cd_list").val());
		
        $.each(svy_trgt_cd_list, function(i){
            $('#SVY_TRGT_CD').append('<label class="chk"><input type="checkbox" id="SVY_TRGT_CD_SEL" name="SVY_TRGT_CD_SEL" value="'+svy_trgt_cd_list[i].ETC_CD+'"><span>'+svy_trgt_cd_list[i].ETC_CD_NM+'</span></label>');
        });
		
		kora.common.setEtcCmBx2(svy_se_cd_list, "", "", $("#SEARCH_SVY_SE_CD"), "ETC_CD", "ETC_CD_NM", "N", "T");
		kora.common.setEtcCmBx2(svy_trgt_cd_list, "", "", $("#SEARCH_SVY_TRGT_CD"), "ETC_CD", "ETC_CD_NM", "N", "T");
		
		kora.common.setEtcCmBx2(svy_se_cd_list, "", "", $("#SVY_SE_CD"), "ETC_CD", "ETC_CD_NM", "N", "S");
		kora.common.setEtcCmBx2(rst_trgt_cd_list, "", "", $("#RST_TRGT_CD"), "ETC_CD", "ETC_CD_NM", "N");
		$("#RST_TRGT_CD").val("N");
		
		$('#SVY_ST_DT').YJcalendar({  
			toName : 'to',
			triggerBtn : true,
			dateSetting : toDay
		});
		$('#SVY_END_DT').YJcalendar({
			fromName : 'from',
			triggerBtn : true,
			dateSetting : endDt.replaceAll("-", "")
		});
		
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
		
		$("#SVY_ST_DT, #SVY_END_DT").keyup(function(){
			var str = $(this).val();
			var lstStr = str.substring(str.length-1).replace(/[^0-9]/g,'');
			str = str.substring(0, str.length -1) + lstStr;
			
			if(str.length == 4 || str.length == 7){
				$(this).val(str+"-");
			}else{
				$(this).val(str);
			}
		});
		
	});
	
	//참여인원 리스트
	function fn_page(){
		
		var idx = dataGrid.getSelectedIndex();
		if(idx == null || idx == undefined || idx < 0){
			return;
		}
		
		var INQ_PARAMS = {};
		
		INQ_PARAMS["SEARCH_SVY_SE_CD"] = $("#SEARCH_SVY_SE_CD").val();
		INQ_PARAMS["SEARCH_SVY_TRGT_CD"] = $("#SEARCH_SVY_TRGT_CD").val();
		INQ_PARAMS["SEARCH_SBJ"] = $("#SEARCH_SBJ").val();
		
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["PARAMS"] = gridRoot.getItemAt(idx);
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE8160601.do";
		kora.common.goPage('/CE/EPCE81606012.do', INQ_PARAMS)
		
	}
	
    //설문결과비고 페이지로
    function fn_page2(){
        var idx = dataGrid.getSelectedIndex();
        if(idx == null || idx == undefined || idx < 0){
            return;
        }
        
        var INQ_PARAMS = {};
        
        INQ_PARAMS = gridRoot.getItemAt(idx);
        //INQ_PARAMS["SEARCH_SBJ"] = $.trim($("#SEARCH_SBJ").val());
        INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE8160601.do";
        kora.common.goPage("/CE/EPCE81606532.do", INQ_PARAMS);
    }
	

	//조회
	function fn_search(){
		var se_cd = $("#SEARCH_SVY_SE_CD").val();
		var trgt_cd = $("#SEARCH_SVY_TRGT_CD").val();
		var sbj = $.trim($("#SEARCH_SBJ").val());
		
		var sData = {"SVY_SE_CD":se_cd, "SVY_TRGT_CD":trgt_cd, "SBJ" : sbj};
		var url = "/CE/EPCE8160601_19.do";
		
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
		$("#RST_TRGT_CD").val("N");
		$("#OLD_SVY_ST_DT").val("");
		$("#SVY_ST_DT").val(dt);  //calendar 셋팅
		$("#SVY_END_DT").val(endDt); // calender 셋팅
		$(":radio[name='USE_YN']").eq(0).prop("checked", true);
		$(":radio[name='APLC_YN']").eq(0).prop("checked", true);
		$(":radio[name='POPUP_YN']").eq(0).prop("checked", true);
        $('input:checkbox[name="SVY_TRGT_CD_SEL"]').each(function() {
            this.checked = false; //checked 처리
        });
        
		obj_readonly(false);
		dataGrid.setSelectedIndex(-1);
	}
	
	
	//저장
	function fn_reg(){
		var svy_no = $("#SVY_NO").val();
		var sData = kora.common.gfn_formData("frmSvy");
		
		sData["SVY_NO"] = "";
		var oldSDt = $("#OLD_SVY_ST_DT").val();
		var oldEDt = $("#OLD_SVY_END_DT").val();
		var sDt = $("#SVY_ST_DT").val();
		var eDt = $("#SVY_END_DT").val();
		var seCd = $("#SVY_SE_CD").val();
		
		if(!kora.common.gfn_isDate(sDt)){
			alertMsg("시작일자가 올바른 날짜 형식이 아닙니다.");
			return;
		}else if(!kora.common.gfn_isDate(eDt)){
			alertMsg("종료일자가 올바른 날짜 형식이 아닙니다.");
			return;
		}
		
		if(oldSDt != null && oldSDt != "") oldSDt = oldSDt.replaceAll("-", "");
		if(oldEDt != null && oldEDt != "") oldEDt = oldEDt.replaceAll("-", "");
		sDt = sDt.replaceAll("-", "");
		eDt = eDt.replaceAll("-", "");
		
		if(svy_no != null && svy_no != "") sData["SVY_NO"] = svy_no;
		
		if(Number(oldSDt) > 0) {
			if(Number(oldSDt) != Number(sDt) || Number(oldEDt) != Number(eDt)){
				alertMsg("설문조사기간은 수정이 불가능 합니다.");
				return;
			}
		}
		else {
	        if(Number(sDt) < Number(toDay)){
	            alertMsg("시작일자는 현재일자 이후로 지정하십시오.");
	            return; 
	        }else if(Number(eDt) < Number(sDt)){
	            alertMsg("종료일자는 시작일자 이후만 가능 합니다.");
	            return; 
	        }

	        if($('input:checkbox[name="SVY_TRGT_CD_SEL"]:checked').length < 1) {
	            alertMsg("설문조사대상을 선택하셔야 합니다.");
	            return;
	        }
		}
		
		sData["SVY_ST_DT"] = sDt;
		sData["SVY_END_DT"] = eDt;
		sData["SVY_SE_CD"] = seCd;
		
		var svyTrgtCdSel = new Array();
        $('input:checkbox[name="SVY_TRGT_CD_SEL"]').each(function(){
            if(this.checked){
        	    svyTrgtCdSel.push(this.value);
            }
        });
        
        sData["SVY_TRGT_CD"] = JSON.stringify(svyTrgtCdSel);
		
		if(!kora.common.cfrmDivChkValid("frmSvy")) return;				//validation
		
		showLoadingBar();
		ajaxPost("/CE/EPCE8160601_09.do", sData, function(rtnData){
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
		kora.common.goPage('/CE/EPCE81606641.do', jParams);
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
		layoutStr.push('	<DataGridColumn dataField="index" headerText="순번" itemRenderer="IndexNoItem" textAlign="center" width="4%" />');
		layoutStr.push('			<DataGridColumn dataField="SVY_NO" headerText="' + parent.fn_text('tit_svy_no') + '" textAlign="center"   width="15%" />');
		layoutStr.push('			<DataGridColumn dataField="SBJ" headerText="' + parent.fn_text('tit_svy_sbj') + '" itemRenderer="HtmlItem"  width="25%" />');
		layoutStr.push('			<DataGridColumn dataField="SVY_SE_CD_NM" headerText="' + parent.fn_text('tit_svy_se_cd') + '"  textAlign="center" width="10%" />');
		layoutStr.push('			<DataGridColumn dataField="SVY_TRGT_CD_NM" headerText="' + parent.fn_text('tit_svy_trgt_cd') + '"  textAlign="center" width="10%" />');
		layoutStr.push('			<DataGridColumn dataField="SVY_ST_DT" headerText="' + parent.fn_text('tit_st_dt') + '" formatter="{datefmt2}" textAlign="center"  width="12%"/>');	
		layoutStr.push('			<DataGridColumn dataField="SVY_END_DT" headerText="' + parent.fn_text('tit_end_dt') + '" formatter="{datefmt2}" textAlign="center"  width="12%"/>');
		layoutStr.push('			<DataGridColumn dataField="SVY_ITEM_CNT" headerText="' + parent.fn_text('tit_item_cnt') + '" formatter="{numfmt}" textAlign="center"  width="8%" />');
		layoutStr.push('			<DataGridColumn dataField="VOTE_CNT" headerText="' + parent.fn_text('tit_vote_cnt') + '" textAlign="center"  width="8%" itemRenderer="HtmlItem" />');
		layoutStr.push('			<DataGridColumn dataField="USE_YN" headerText="' + parent.fn_text('tit_use_yn') + '" textAlign="center"  width="8%" />');
		layoutStr.push('            <DataGridColumn dataField="APLC_YN" headerText="' + parent.fn_text('anc_aplc_yn') + '" textAlign="center"  width="8%" />');
		layoutStr.push('            <DataGridColumn dataField="POPUP_YN" headerText="' + parent.fn_text('popup_yn') + '" textAlign="center"  width="8%" />');		
	    layoutStr.push('            <DataGridColumn dataField="RST_LNK" headerText="' + parent.fn_text('tit_svy_rst') + '" textAlign="center"  width="8%" itemRenderer="HtmlItem" />');
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
		gridApp.setData([]);
		
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
			
			$('input:checkbox[name="SVY_TRGT_CD_SEL"]').each(function() {
			    this.checked = false; //checked 처리
			});

			var svyTrgtCd = dataRow["SVY_TRGT_CD"].split("|");
			for(var i=0;i<svyTrgtCd.length;i++){
			    $('input:checkbox[name="SVY_TRGT_CD_SEL"]').each(function() {
				    if(this.value == svyTrgtCd[i]){ //값 비교
				        this.checked = true; //checked 처리
				    }
				});
            }
			
			$("#SVY_NO").val(dataRow["SVY_NO"]);
			$("#SBJ").val(dataRow["SBJ"]);
			$("#SVY_SE_CD").val(dataRow["SVY_SE_CD"]);
			//$("#SVY_TRGT_CD").val(dataRow["SVY_TRGT_CD"]);
			$("#RST_TRGT_CD").val(dataRow["RST_TRGT_CD"]);
			$("#OLD_SVY_ST_DT").val(sDt);
			$("#OLD_SVY_END_DT").val(eDt);
			$("#SVY_ST_DT").val(sDt);  //calendar 셋팅
			$("#SVY_END_DT").val(eDt); // calender 셋팅
			
			if(dataRow["USE_YN"] == "Y"){
				$(":radio[name='USE_YN']").eq(0).prop("checked", true);
			}else{
				$(":radio[name='USE_YN']").eq(1).prop("checked", true);	
			}
			
            if(dataRow["APLC_YN"] == "Y"){
                $(":radio[name='APLC_YN']").eq(0).prop("checked", true);
            }else{
                $(":radio[name='APLC_YN']").eq(1).prop("checked", true); 
            }
			
			
            if(dataRow["POPUP_YN"] == "Y"){
                $(":radio[name='POPUP_YN']").eq(0).prop("checked", true);
            }else{
                $(":radio[name='POPUP_YN']").eq(1).prop("checked", true); 
            }
			
            
			obj_readonly(true);
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

		if(jParams != null && Object.keys(jParams).length > 0){
            for(var key in jParams){
                $("#" + key).val(jParams[key]);
            }
            fn_search();
        }
	};

	function showLoadingBar() {
		kora.common.showLoadingBar(dataGrid, gridRoot);
	}

	function hideLoadingBar() {
		kora.common.hideLoadingBar(dataGrid, gridRoot);
	}
	
	function obj_readonly(gbn) {
        $("#SBJ").attr("readonly",gbn);
        $("#SVY_SE_CD").attr("disabled",gbn);
        $("#SVY_ST_DT").attr("readonly",gbn);
        $("#SVY_END_DT").attr("readonly",gbn); 

        $('input:checkbox[name="SVY_TRGT_CD_SEL"]').each(function() {
            this.disabled = gbn;
        });
        
        if(gbn) {
            $(".YJcalendar-trigger").hide();
        }
        else {
            $(".YJcalendar-trigger").show();
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
							<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}'/>" />
							<input type="hidden" id="svy_se_cd_list" value="<c:out value='${svy_se_cd_list}'/>" />
							<input type="hidden" id="svy_trgt_cd_list" value="<c:out value='${svy_trgt_cd_list}'/>" />
							<input type="hidden" id="rst_trgt_cd_list" value="<c:out value='${rst_trgt_cd_list}'/>" />

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
			<div class="srcharea" style="margin-top: 30px;">
			
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
                            <div class="box" id="SVY_TRGT_CD">
                            </div>
                        </div>
						<div class="col" style="display:none">
							<div class="tit" style="padding-right: 15px;" id="tit_rst_trgt_cd"></div>
							<div class="box">
								<select id="RST_TRGT_CD" name="RST_TRGT_CD" alt="tit_rst_trgt_cd"  class="i_notnull" style="width: 200px;">
								</select>
							</div>
						</div>
					</div>
					
					
					<div class="row">
						<div class="col">
							<div class="tit" style="padding-right: 15px;" id="tit_svy_term"></div>
							<div class="box">
								<div class="calendar">
									<input type="hidden" id="OLD_SVY_ST_DT" />
									<input type="text" id="SVY_ST_DT" style="ime-mode:disabled;" name="from" maxlength="10" alt="tit_svy_from_dt" style="width: 150px;" class="i_notnull" alt="시작날짜" />
								</div>
								<div class="obj">~</div>
								<div class="calendar">
                                <input type="hidden" id="OLD_SVY_END_DT" />
									<input type="text" id="SVY_END_DT" style="ime-mode:disabled;" name="to" maxlength="10" alt="tit_svy_end_dt" style="width: 150px;" class="i_notnull" alt="끝 날짜" />
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
                        <div class="col">
                            <div class="tit" style="padding-right: 15px;" id="anc_aplc_yn"></div>
                            <div class="box">
                                <label class="rdo"><input type="radio" name="APLC_YN" value="Y" checked="checked" /><span id="aplc_y"></span></label>
                                <label class="rdo"><input type="radio" name="APLC_YN" value="N"/><span id="aplc_n"></span></label>
                            </div>
                        </div>
                        <div class="col">
                            <div class="tit" style="padding-right: 15px;" id="popup_yn"></div>
                            <div class="box">
                                <label class="rdo"><input type="radio" name="POPUP_YN" value="Y" checked="checked" /><span id="popup_y"></span></label>
                                <label class="rdo"><input type="radio" name="POPUP_YN" value="N"/><span id="popup_n"></span></label>
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
		
	</div>	<!-- //iframe_inner -->
	