<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
		
		$(document).ready(function(){
			
			var langSeList =jsonObject($("#langSeList").val());	
			var menuSetList =jsonObject($("#menuSetList").val());	
			var menuGrpList =jsonObject($("#menuGrpList").val());	
			var menuSeList =jsonObject($("#menuSeList").val());	
			
			
			
			fn_btnSetting(); 
			
			$('#lang_se_sel').text(parent.fn_text('lang_se'));
			$('#menu_set_sel').text(parent.fn_text('menu_set'));
			$('#menu_grp_sel').text(parent.fn_text('menu_grp'));
			$('#menu_grp').text(parent.fn_text('menu_grp'));
			$('#menu_cd').text(parent.fn_text('menu_cd'));
			$('#menu_nm').text(parent.fn_text('menu_nm'));
			$('#up_menu_cd').text(parent.fn_text('up_menu_cd'));
			$('#menu_lvl').text(parent.fn_text('menu_lvl'));
			$('#menu_se').text(parent.fn_text('menu_se'));
			$('#menu_ord').text(parent.fn_text('menu_ord'));
			$('#menu_url').text(parent.fn_text('menu_url'));
			
			$('#use_yn').text(parent.fn_text('use_yn'));
			$('#use_y').text(parent.fn_text('use_y'));
			$('#use_n').text(parent.fn_text('use_n'));
			
			$('#lang_se').text(parent.fn_text('lang_se'));
			$('#menu_set').text(parent.fn_text('menu_set'));
			
			//작성체크용
			$('#MENU_GRP_CD').attr('alt', parent.fn_text('menu_grp'));
			$('#MENU_CD').attr('alt', parent.fn_text('menu_cd'));
			$('#MENU_NM').attr('alt', parent.fn_text('menu_nm'));
			$('#UP_MENU_CD').attr('alt', parent.fn_text('up_menu_cd'));
			$('#MENU_LVL').attr('alt', parent.fn_text('menu_lvl'));
			$('#MENU_SE_CD').attr('alt', parent.fn_text('menu_se'));
			$('#MENU_ORD').attr('alt', parent.fn_text('menu_ord'));
			$('#MENU_URL').attr('alt', parent.fn_text('menu_url'));
			$('#LANG_SE_CD').attr('alt', parent.fn_text('lang_se'));
			$('#MENU_SET_CD').attr('alt', parent.fn_text('menu_set'));
			
			
			fn_set_grid();
		
			kora.common.setEtcCmBx2(langSeList, "", "", $("#LANG_SE_CD_SEL"), "LANG_SE_CD", "LANG_SE_CD", "N", "T");
			kora.common.setEtcCmBx2(langSeList, "", "", $("#LANG_SE_CD"), "LANG_SE_CD", "LANG_SE_CD", "N", "S");
			kora.common.setEtcCmBx2(menuSetList, "", "", $("#MENU_SET_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(menuSetList, "", "", $("#MENU_SET_CD"), "ETC_CD", "ETC_CD_NM", "N", "S");
			kora.common.setEtcCmBx2(menuGrpList, "", "", $("#MENU_GRP_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(menuGrpList, "", "", $("#MENU_GRP_CD"), "ETC_CD", "ETC_CD_NM", "N", "S");
			kora.common.setEtcCmBx2(menuSeList, "", "", $("#MENU_SE_CD"), "ETC_CD", "ETC_CD_NM", "N", "S");

			$("#btn_sel").click(function(){
				fn_sel();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			$("#btn_del").click(function(){
				fn_del();
			});
			
			$("#btn_init").click(function(){
				fn_init();
			});
			
			
			//상위메뉴코드 콤보 셋팅
			$("#MENU_GRP_CD").change(function(){
				fn_upMenuCdSet();
			});
			
			$("#MENU_SET_CD").change(function(){
				fn_upMenuCdSet();
			});
			
			$("#MENU_LVL").change(function(){
				fn_upMenuCdSet();
			});
			
			$("#LANG_SE_CD").change(function(){
				fn_upMenuCdSet();
			});
			
		});
	
		function fn_upMenuCdSet(){
			var MENU_GRP_CD = $("#MENU_GRP_CD option:selected").val();
			var MENU_SET_CD = $("#MENU_SET_CD option:selected").val();
			var LANG_SE_CD = $("#LANG_SE_CD option:selected").val();
			var MENU_LVL = $("#MENU_LVL option:selected").val();
			var MENU_CD = $("#MENU_CD_ORI").val();
			
			if(MENU_LVL == '1'){
				$('#UP_MENU_CD').children().remove();
			}else if(MENU_GRP_CD != '' && MENU_SET_CD != '' && MENU_LVL == '2'){
				$('#UP_MENU_CD').children().remove();
				$('#UP_MENU_CD').append("<option value='"+MENU_SET_CD+MENU_GRP_CD+"'>"+MENU_SET_CD+MENU_GRP_CD+"</option>");
			}else if(MENU_GRP_CD != '' && MENU_SET_CD != '' && LANG_SE_CD != '' && MENU_LVL == '3'){
				
				var url = "/CE/EPCE3960201_193.do";
				var input = {};
				input['MENU_SET_CD'] = MENU_SET_CD;
				input['MENU_GRP_CD'] = MENU_GRP_CD;
				input['LANG_SE_CD'] = LANG_SE_CD;
				input['MENU_CD'] = MENU_CD;
				ajaxPost(url, input, function(rtnData){
					if(rtnData != null && rtnData != ""){
						kora.common.setEtcCmBx2(rtnData.searchList, "", "", $("#UP_MENU_CD"), "MENU_CD", "MENU_CD", "N", "");
					} 
					else {
						alertMsg("error");
					}
					
				}, false);
				
			}
		}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){

			var input = {};
			input["LANG_SE_CD_SEL"] 	= $("#LANG_SE_CD_SEL option:selected").val();
			input["MENU_SET_CD_SEL"] 	= $("#MENU_SET_CD_SEL option:selected").val();
			input["MENU_GRP_CD_SEL"] 	= $("#MENU_GRP_CD_SEL option:selected").val();
			
			var url = "/CE/EPCE3960201_19.do";
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					fn_init();
					gridApp.setData(rtnData.searchList);
				} 
				else {
					alertMsg("error");
				}
				
				//.var selector = gridRoot.getObjectById("selector");
				//.selector.setAllItemSelected(false);
				kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
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
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center">'); //liveScrolling="false" showScrollTips="false"
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="false" headerText="'+parent.fn_text('cho')+'" width="3%" />');
			 layoutStr.push('	<DataGridColumn dataField="LANG_SE_CD"  headerText="'+parent.fn_text('lang_se')+'" width="7%" />');
			 layoutStr.push('	<DataGridColumn dataField="MENU_SET_NM"  headerText="'+parent.fn_text('menu_set')+'" width="7%"/>');
			 layoutStr.push('	<DataGridColumn dataField="MENU_GRP_NM"  headerText="'+parent.fn_text('menu_grp')+'" width="7%"/>');
			 layoutStr.push('	<DataGridColumn dataField="MENU_CD"  headerText="'+parent.fn_text('menu_cd')+'" width="10%"/>');
			 layoutStr.push('	<DataGridColumn dataField="MENU_NM"  headerText="'+parent.fn_text('menu_nm')+'" width="15%"/>');
			 layoutStr.push('	<DataGridColumn dataField="UP_MENU_CD"  headerText="'+parent.fn_text('up_menu_cd')+'" width="10%"/>');
			 layoutStr.push('	<DataGridColumn dataField="MENU_LVL"  headerText="'+parent.fn_text('menu_lvl')+'" width="7%"/>');
			 layoutStr.push('	<DataGridColumn dataField="MENU_SE_NM"  headerText="'+parent.fn_text('menu_se')+'" width="7%"/>');
			 layoutStr.push('	<DataGridColumn dataField="MENU_ORD"  headerText="'+parent.fn_text('menu_ord')+'" width="7%"/>');
			 layoutStr.push('	<DataGridColumn dataField="MENU_URL"  headerText="'+parent.fn_text('menu_url')+'" width="13%"/>');
			 layoutStr.push('	<DataGridColumn dataField="USE_YN"  headerText="'+parent.fn_text('use_yn')+'" width="7%"/>');
			 layoutStr.push('</columns>');
			
			 layoutStr.push('</DataGrid>');
			 layoutStr.push('</rMateGrid>');
		}
		
		
		 var editYn = false;
		 var indexData = '';
		
		// 그리드 및 메뉴 리스트 세팅
		 function gridReadyHandler(id) {
		 	 gridApp = document.getElementById(id);  // 그리드를 포함하는 div 객체
		     gridRoot = gridApp.getRoot();   // 데이터와 그리드를 포함하는 객체

		     gridApp.setLayout(layoutStr.join("").toString());
		     gridApp.setData([]);
		     
		     var layoutCompleteHandler = function(event) {
		         dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		         dataGrid.addEventListener("change", selectionChangeHandler); //이벤트 등록
		     }
		     
		     //그리드 자동선택기능 주석처리
		     //var dataCompleteHandler = function(event) {
		     //	if(editYn) fn_editPostSelectRow(); //수정후 재 해당로우 다시 찾아 매핑
		     //}
		     
		     var selectionChangeHandler = function(event) {
				rowIndex = event.rowIndex;
				selectorColumn = gridRoot.getObjectById("selector");
				fn_rowToInput(rowIndex);
			 }
		     
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		     //그리드 자동선택기능 주석처리
		     //gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		 }
		
		 //행선택시 입력값 input에  넣기
		 function fn_rowToInput(rowIndex2) {
			var item = gridRoot.getItemAt(rowIndex2);
			
			selectorColumn.setSelectedIndex(-1);
			selectorColumn.setSelectedIndex(rowIndex2);
			
			$("#MENU_GRP_CD").val(item["MENU_GRP_CD"]);
		 	$("#MENU_CD").val(item["MENU_CD"]);
		 	$("#MENU_CD_ORI").val(item["MENU_CD"]);
		 	$("#MENU_NM").val(item["MENU_NM"]);
		 	$("#MENU_LVL").val(item["MENU_LVL"]);
		 	$("#MENU_URL").val(item["MENU_URL"]);
		 	$("#MENU_ORD").val(item["MENU_ORD"]);
		 	$("#MENU_SE_CD").val(item["MENU_SE_CD"]);
		 	$("#MENU_SET_CD").val(item["MENU_SET_CD"]);
		 	$("#LANG_SE_CD").val(item["LANG_SE_CD"]);
		 	
		 	$(':radio[name="USE_YN"][value="' + item["USE_YN"] + '"]').prop("checked", true);
		 	
		 	//상위메뉴코드 콤보 셋팅
		 	fn_upMenuCdSet();
		 	$("#UP_MENU_CD").val(item["UP_MENU_CD"]);
		 }
		 
		//초기화
	     function fn_init(){
			
			 //if(selectorColumn != undefined && selectorColumn != 'undefined' && selectorColumn != null){
	    	 //	selectorColumn.setSelectedIndex(-1);
			 //}

	    	 $("#MENU_CD").val("");
	    	 $("#MENU_NM").val("");
	    	 $("#UP_MENU_CD").val("");
	    	 $("#MENU_LVL").val("2");
	    	 $("#MENU_ORD").val("");
	    	 $("#MENU_URL").val("");
	    	 $("#USE_YN").val("Y").prop("checked",true);

	    	 $("#MENU_GRP_CD").val("");
	    	 $("#MENU_SE_CD").val("");
	    	 $("#LANG_SE_CD").val("");
	    	 $("#MENU_SET_CD").val("");
	     }

		 //저장
		 function fn_reg(){

			 if(!kora.common.cfrmDivChkValid("frmMenu")) {
				return;
			 }

			//UP_MENU_CD
			if($('#MENU_LVL option:selected').val() != '1' && kora.common.null2void($('#UP_MENU_CD option:selected').val()) == ''){
				alertMsg('상위메뉴코드 을(를) 확인하세요.');
				return;
			}
			
			$("#MENU_GRP_NM").val($("#MENU_GRP_CD option:selected").text()); 
			 
			//메뉴 체크
			var sData = kora.common.gfn_formData("frmMenu");
			var url  = "/CE/EPCE3960201_192.do";
			sData['GUBUN'] = 'reg';
			ajaxPost(url, sData, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					if(rtnData.RSLT_CD == '0000' || rtnData.RSLT_CD == 'A003'){
						var msg = '';
						if(rtnData.RSLT_CD == 'A003'){
							msg = parent.fn_text('same_cd');
						}else{
							msg = parent.fn_text('new_cd');
						}
						confirm(msg, 'fn_reg_exec');
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
				} else {
					alertMsg("error");
				}
			}, false);
			 
		 }
		 
		 function fn_reg_exec(){
			 
			 	var sData = kora.common.gfn_formData("frmMenu");
			 	var url = "/CE/EPCE3960201_09.do";
			 	ajaxPost(url, sData, function(rtnData){
			 		if ("" != rtnData && null != rtnData) {

	 					//그리드 자동선택기능 주석처리
	 					//editYn = true;
	 					//indexData = sData['LANG_SE_CD'] + sData['MENU_CD'];
	 					
			 			alertMsg(rtnData.RSLT_MSG, 'fn_sel');

	 				} else {
	 					alertMsg("error");
	 				}
			 	});
		 }
		 
		//삭제
		 function fn_del(){

			if(selectorColumn == undefined || selectorColumn == 'undefined' || selectorColumn == null || selectorColumn.getSelectedIndices() == "") {
				alertMsg("선택한 건이 없습니다.");
				return false;
			}

			//메뉴 체크
			var sData = gridRoot.getItemAt(dataGrid.getSelectedIndex());
			var url  = "/CE/EPCE3960201_192.do";
			sData['GUBUN'] = 'del';
			ajaxPost(url, sData, function(rtnData){
				if ("" != rtnData && null != rtnData){
					if(rtnData.RSLT_CD == '0000'){
						var msg = '해당 메뉴에 관련된 모든데이터가 삭제됩니다. \n삭제하시겠습니까?';
						confirm(msg, 'fn_del_exec');
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
				} else {
					alertMsg("error");
				}
			}, false);
		 }
		
		function fn_del_exec(){
			
			/*
			var chkLst = selectorColumn.getSelectedItems();
			var item = {};
			item["MENU_CD"] = chkLst[0].MENU_CD;
			item["LANG_SE_CD"] = chkLst[0].LANG_SE_CD;
			*/
			var sData = gridRoot.getItemAt(dataGrid.getSelectedIndex());
			
		 	var url = "/CE/EPCE3960201_04.do";
		 	ajaxPost(url, sData, function(rtnData){
		 		if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_sel');
				} else {
					alertMsg("error");
				}
		 	});
		}
		 
		//수정 후 자기로우 다시 찾아서 선택
		 function fn_editPostSelectRow(){

			var collection = gridRoot.getCollection(); 
			 
		 	var rowIndex2 = -1;
		 	var cnt = collection.getLength(); 
		 	for(var i=0; i<cnt; i++){
		 		var data = gridRoot.getItemAt(i);
		 		if(indexData != data.LANG_SE_CD + $.trim(data.MENU_CD) ) continue;
		 		rowIndex2 = i;
		 		break;
		 	}
		 	if(rowIndex2 < 0) return;

		 	gridSetSelectedIndex(rowIndex2);
		 	fn_rowToInput(rowIndex2);
		 }

		 //선택된 행으로 스크롤 이동
		 function gridSetSelectedIndex(idx) {
		     // 현재 그리드의 verticalScrollPosition을 조사하여 스크롤을 일으킬지 조사하여 필요시 세팅
		     var verticalScrollPosition = dataGrid.getVerticalScrollPosition();
		     // 그리드의 행수를 가져옵니다 (이 값은 화면에 제대로 표시되지 않는 행을 포함하기 때문에 실제와 다른 값으로 보일 수 있으며, DataGrid의 variableRowHeight가 true일 경우에는 추정치를 의미합니다.
		     var rowCount = dataGrid.getRowCount();
		     if (rowCount > 0)
		         rowCount = rowCount - 1;
		     var halfRowCount = (rowCount / 2).toFixed();
		  
		     dataGrid.setSelectedIndex(idx);
		     if (idx < verticalScrollPosition || idx > verticalScrollPosition + rowCount) {
		         if (idx - halfRowCount >= 0) // 화면 중간에 위치하도록 계산
		             dataGrid.setVerticalScrollPosition(idx - halfRowCount);
		         else
		             dataGrid.setVerticalScrollPosition(0);
		     }

		     editYn = false;
		     indexData = '';
		 }
 
	</script>
			
</head>
<body>
	<!-- 메뉴관리 -->
	<div class="iframe_inner">
	    <input type="hidden" id="langSeList" value="<c:out value='${langSeList}' />" />
		<input type="hidden" id="menuSetList" value="<c:out value='${menuSetList}' />" />
		<input type="hidden" id="menuGrpList" value="<c:out value='${menuGrpList}' />" />
		<input type="hidden" id="menuSeList" value="<c:out value='${menuSeList}' />" />
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn_box">
			</div>
		</div>
		<section class="secwrap">
			<div class="srcharea">
				<div class="row">
					<div class="col">
						<div class="tit"  style="padding-right: 24px;" id="lang_se_sel"></div>
						<div class="box">						
							<select id="LANG_SE_CD_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="menu_set_sel"></div>
						<div class="box">
							<select id="MENU_SET_CD_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="menu_grp_sel"></div>
						<div class="box">
							<select id="MENU_GRP_CD_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="btn" id="UR">
					</div>
				</div>
			</div>
		</section>
		<section class="secwrap mt10">
			<div class="srcharea" style="">
			
				<form name="frmMenu" id="frmMenu" method="post" >
					
					<div class="row">
						<div class="col">
							<div class="tit" style="padding-right: 24px;" id="lang_se"></div>
							<div class="box">
								<select id="LANG_SE_CD" name="LANG_SE_CD" style="width: 179px;" class="i_notnull" alt="" >
								</select>
							</div>
						</div>
						<div class="col">
							<div class="tit" id="menu_set"></div>
							<div class="box">
								<select id="MENU_SET_CD" name="MENU_SET_CD" style="width: 179px;" class="i_notnull" alt="" >
								</select>
							</div>
						</div>
					</div>
					
					<div class="row">
						<div class="col">
							<div class="tit" style="padding-right: 24px;" id="menu_grp"></div>
							<div class="box">
								<select id="MENU_GRP_CD" name="MENU_GRP_CD" style="width: 179px;" class="i_notnull" alt="" >
								</select>
								<input type="hidden" id="MENU_GRP_NM" name="MENU_GRP_NM"/>
							</div>
						</div>
						<div class="col">
							<div class="tit" id="menu_cd"></div>
							<div class="box">
								<input id="MENU_CD" name="MENU_CD" type="text" style="width: 179px;" class="i_notnull" alt=""  maxlength="20" >
								<input type="hidden" id="MENU_CD_ORI" style="display:none"/>
							</div>
						</div>
						<div class="col">
							<div class="tit" style="margin-right: 34px;" id="menu_nm"></div>
							<div class="box">
								<input id="MENU_NM" name="MENU_NM" type="text" style="width: 179px;" class="i_notnull" alt="" maxByteLength="90">
							</div>
						</div>
					</div>
					
					<div class="row">
						<div class="col">
							<div class="tit" id="up_menu_cd"></div>
							<div class="box">
								<!-- <input id="UP_MENU_CD" name="UP_MENU_CD" type="text" style="width: 179px;" alt="" maxlength="20" > -->
								<select id="UP_MENU_CD" name="UP_MENU_CD" style="width: 179px;" alt="" >
								</select>
							</div>
						</div>
						<div class="col">
							<div class="tit" id="menu_lvl"></div>
							<div class="box">
								<select id="MENU_LVL" name="MENU_LVL" style="width: 179px;" alt="" class="i_notnull" >
									<option value="1">1</option>
									<option value="2" selected>2</option>
									<option value="3">3</option>
								</select>
							</div>
						</div>
						<div class="col">
							<div class="tit" id="menu_se"></div>
							<div class="box">
								<select id="MENU_SE_CD" name="MENU_SE_CD" style="width: 179px;" class="i_notnull" alt="" >
								</select>
							</div>
						</div>
					</div>
					
					<div class="row">
						<div class="col">
							<div class="tit" style="padding-right: 24px;" id="menu_ord"></div>
							<div class="box">
								<input id="MENU_ORD" name="MENU_ORD" type="text" style="width: 179px;" class="i_notnull" alt="" maxlength="6" format="number">
							</div>
						</div>
						<div class="col">
							<div class="tit" id="menu_url"></div>
							<div class="box">
								<input id="MENU_URL" name="MENU_URL" type="text" style="width: 179px;" class="i_notnull" alt="" maxlength="90">
							</div>
						</div>
						<div class="col">
							<div class="tit" id="use_yn"></div>
							<div class="box">
								<label class="rdo"><input type="radio" id="USE_YN" name="USE_YN" value="Y" checked="checked"/><span id="use_y"></span></label>
								<label class="rdo"><input type="radio" id="USE_YN" name="USE_YN" value="N"/><span id="use_n"></span></label>
							</div>
						</div>
					</div>
					
				</form>
				
			</div>
		</section>
		<section class="btnwrap mt20" >
			<div class="fl_r" id="CR">
			</div>
		</section>
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:530px;"></div>
			</div>
		</section>
		
	</div>

</body>
</html>
