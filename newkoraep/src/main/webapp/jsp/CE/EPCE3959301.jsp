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
			var btnSeList =jsonObject($("#btnSeList").val());	
			var btnLcSeList =jsonObject($("#btnLcSeList").val());	
			fn_btnSetting();
			
			$('#lang_se_sel').text(parent.fn_text('lang_se'));
			$('#menu_set_sel').text(parent.fn_text('menu_set'));
			$('#menu_grp_sel').text(parent.fn_text('menu_grp'));
			
			$('#sc_lst').text(parent.fn_text('sc_lst'));
			$('#btn_mgnt').text(parent.fn_text('btn_mgnt'));
			
			$('#btn_se_txt').text(parent.fn_text('btn_se'));
			$('#lc_se_txt').text(parent.fn_text('lc_se'));
			$('#btn_cd_txt').text(parent.fn_text('btn_cd'));
			$('#btn_nm_txt').text(parent.fn_text('btn_nm'));
			$('#exec_info_txt').text(parent.fn_text('exec_info'));
			$('#sel_ord_txt').text(parent.fn_text('sel_ord'));
			
			//작성체크용
			$('#BTN_SE_CD').attr('alt', parent.fn_text('btn_se'));
			$('#BTN_LC_SE').attr('alt', parent.fn_text('lc_se'));
			$('#BTN_CD').attr('alt', parent.fn_text('btn_cd'));
			$('#BTN_NM').attr('alt', parent.fn_text('btn_nm'));
			$('#EXEC_INFO').attr('alt', parent.fn_text('exec_info'));
			$('#SEL_ORD').attr('alt', parent.fn_text('sel_ord'));
			
		
			kora.common.setEtcCmBx2(langSeList, "", "", $("#LANG_SE_CD_SEL"), "LANG_SE_CD", "LANG_SE_CD", "N", "T");
			kora.common.setEtcCmBx2(menuSetList, "", "", $("#MENU_SET_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(menuGrpList, "", "", $("#MENU_GRP_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(btnSeList, "", "", $("#BTN_SE_CD"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(btnLcSeList, "", "", $("#BTN_LC_SE"), "ETC_CD", "ETC_CD_NM", "N", "T");
			
			
			fn_set_grid();
			fn_set_grid2();
			
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
			
		});
		
		/**
		 * 목록조회
		 */
		function fn_sel(){

			var input = {};
			input["LANG_SE_CD_SEL"] 	= $("#LANG_SE_CD_SEL option:selected").val();
			input["MENU_SET_CD_SEL"] 	= $("#MENU_SET_CD_SEL option:selected").val();
			input["MENU_GRP_CD_SEL"] 	= $("#MENU_GRP_CD_SEL option:selected").val();
			
			var url = "/CE/EPCE3959301_19.do";

			//우측하단 그리드 초기화
			gridApp2.setData([]);
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.searchList);
				} 
				else {
					alertMsg("error");
				}
				kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off

			});
		}
		
		//저장
		 function fn_reg(){
			
			if(selectorColumn == undefined || selectorColumn == 'undefined' || selectorColumn == null || selectorColumn.getSelectedIndex() == -1){
				alertMsg("화면목록에서 메뉴를 선택하세요.");
				return;
			}
			
			if(!kora.common.cfrmDivChkValid("frmMenu")) {
				return;
			}
	
			confirm('저장하시겠습니까?', 'fn_reg_exec');
		 }
		
		function fn_reg_exec(){
			
			var sData = kora.common.gfn_formData("frmMenu");

		 	var url = "/CE/EPCE3959301_09.do";
		 	ajaxPost(url, sData, function(rtnData){
		 		if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_rowToSel');
				} else {
					alertMsg("error");
				}
		 	});
		 	
		}
		
		
		 //삭제
		 function fn_del(){

			if(selectorColumn == undefined || selectorColumn == 'undefined' || selectorColumn == null || selectorColumn.getSelectedIndex() == -1){
				alertMsg("화면목록에서 메뉴를 선택하세요.");
				return;
			}
			
			if(selectorColumn2 == undefined || selectorColumn2 == 'undefined' || selectorColumn2 == null || selectorColumn2.getSelectedIndex() == -1){
				alertMsg("버튼관리에서 버튼을 선택하세요.");
				return;
			}
	
			confirm('삭제하시겠습니까?', 'fn_del_exec');
		 }
		 
		 function fn_del_exec(){
			 
			 	var item = gridRoot2.getItemAt(selectorColumn2.getSelectedIndex());
				
				var input = {};
				input["LANG_SE_CD"] 	= item["LANG_SE_CD"];
				input["MENU_CD"] 		= item["MENU_CD"];
				input["BTN_CD"] 			= item["BTN_CD"];
				
			 	var url = "/CE/EPCE3959301_21.do";
			 	ajaxPost(url, input, function(rtnData){
			 		if ("" != rtnData && null != rtnData) {
						alertMsg(rtnData.RSLT_MSG, 'fn_rowToSel');
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
		
		/**
		 * 그리드 셋팅
		 */
		 function fn_set_grid() {
			 
			 rMateGridH5.create("grid", "gridHolder", jsVars, "100%", "100%");
			 
			 layoutStr.push('<rMateGrid>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center">');
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="false" headerText="'+parent.fn_text('cho')+'" width="8%" />');
			 layoutStr.push('	<DataGridColumn dataField="LANG_SE_CD"  headerText="'+parent.fn_text('lang_se')+'" width="14%" />');
			 layoutStr.push('	<DataGridColumn dataField="MENU_SET_NM"  headerText="'+parent.fn_text('menu_set')+'" width="15%"/>');
			 layoutStr.push('	<DataGridColumn dataField="MENU_GRP_NM"  headerText="'+parent.fn_text('menu_grp')+'" width="15%"/>');
			 layoutStr.push('	<DataGridColumn dataField="MENU_NM"  headerText="'+parent.fn_text('menu_nm')+'" width="30%"/>');
			 layoutStr.push('	<DataGridColumn dataField="MENU_SE"  headerText="'+parent.fn_text('menu_se')+'" width="18%"/>');
			 layoutStr.push('</columns>');
			
			 layoutStr.push('</DataGrid>');
			 layoutStr.push('</rMateGrid>');
		}
		
		// 그리드 및 메뉴 리스트 세팅
		 function gridReadyHandler(id) {
		 	 gridApp = document.getElementById(id);  // 그리드를 포함하는 div 객체
		     gridRoot = gridApp.getRoot();   // 데이터와 그리드를 포함하는 객체

		     gridApp.setLayout(layoutStr.join("").toString());
		     gridApp.setData([]);
		     
		     var layoutCompleteHandler = function(event) {
		         dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		         selectorColumn = gridRoot.getObjectById("selector");
		         dataGrid.addEventListener("change", selectionChangeHandler); //이벤트 등록
		     }

		     var selectionChangeHandler = function(event) {
				var rowIndex = event.rowIndex;
				selectorColumn.setSelectedIndex(-1);
				selectorColumn.setSelectedIndex(rowIndex);
				fn_rowToSel();
			 }
		     
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
		
		//행선택시 조회
		function fn_rowToSel() {
			var item = gridRoot.getItemAt(selectorColumn.getSelectedIndex());
			
			var input = {};
			input["LANG_SE_CD"] 	= item["LANG_SE_CD"];
			input["MENU_CD"] 		= item["MENU_CD"];
			
			var url = "/CE/EPCE3959301_192.do";
			
			kora.common.showLoadingBar(dataGrid2, gridRoot2);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
   					fn_init();
					gridApp2.setData(rtnData.searchList);
					$('#frmMenu').find('#LANG_SE_CD').val(item["LANG_SE_CD"]);
					$('#frmMenu').find('#MENU_CD').val(item["MENU_CD"]);
				}else{
					alertMsg("error");
				}
				kora.common.hideLoadingBar(dataGrid2, gridRoot2);// 그리드 loading bar off

			});
		}
		
		 /**
		 * 그리드 관련 변수 선언
		 */
	    var jsVars2 = "rMateOnLoadCallFunction=gridReadyHandler2";
		var gridApp2, gridRoot2, dataGrid2, layoutStr2, selectorColumn2;
		var layoutStr2 = new Array();
		
		/**
		 * 그리드 셋팅
		 */
		 function fn_set_grid2() {
			 
			 rMateGridH5.create("grid2", "gridHolder2", jsVars2, "100%", "100%");
			 
			 layoutStr2.push('<rMateGrid>');
			 layoutStr2.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg2" headerHeight="35" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center">');
			 layoutStr2.push('<columns>');
			 layoutStr2.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="false" headerText="'+parent.fn_text('cho')+'" width="7%" />');
			 layoutStr2.push('	<DataGridColumn dataField="BTN_SE_NM"  headerText="'+parent.fn_text('btn_se')+'" width="13%" />');
			 layoutStr2.push('	<DataGridColumn dataField="BTN_LC_SE_NM"  headerText="'+parent.fn_text('lc_se')+'" width="12%"/>');
			 layoutStr2.push('	<DataGridColumn dataField="BTN_NM"  headerText="'+parent.fn_text('btn_nm')+'" width="20%"/>');
			 layoutStr2.push('	<DataGridColumn dataField="EXEC_INFO"  headerText="'+parent.fn_text('exec_info')+'" width="48%"/>');
			 layoutStr2.push('</columns>');
			
			 layoutStr2.push('</DataGrid>');
			 layoutStr2.push('</rMateGrid>');
		}
		
		// 그리드 및 메뉴 리스트 세팅
		 function gridReadyHandler2(id) {
		 	 gridApp2 = document.getElementById(id);  // 그리드를 포함하는 div 객체
		     gridRoot2 = gridApp2.getRoot();   // 데이터와 그리드를 포함하는 객체

		     gridApp2.setLayout(layoutStr2.join("").toString());
		     gridApp2.setData([]);
		     
		     var layoutCompleteHandler = function(event) {
		         dataGrid2 = gridRoot2.getDataGrid();  // 그리드 객체
		         selectorColumn2 = gridRoot2.getObjectById("selector");
		         dataGrid2.addEventListener("change", selectionChangeHandler); //이벤트 등록
		     }

		     var selectionChangeHandler = function(event) {
				var rowIndex2 = event.rowIndex;
				selectorColumn2.setSelectedIndex(-1);
				selectorColumn2.setSelectedIndex(rowIndex2);
				fn_rowToInput();
			 }

		     gridRoot2.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
		
		//행선택시 입력값 input에  넣기
		function fn_rowToInput() {
			var item = gridRoot2.getItemAt(selectorColumn2.getSelectedIndex());

			$("#BTN_SE_CD").val(item["BTN_SE_CD"]);
		 	$("#BTN_LC_SE").val(item["BTN_LC_SE"]);
		 	$("#BTN_CD").val(item["BTN_CD"]);
		 	$("#BTN_NM").val(item["BTN_NM"]);
		 	$("#EXEC_INFO").val(item["EXEC_INFO"]);
		 	$("#SEL_ORD").val(item["SEL_ORD"]);
		 }
		
		function fn_init(){
			
			$("#BTN_SE_CD").val("");
		 	$("#BTN_LC_SE").val("");
		 	$("#BTN_CD").val("");
		 	$("#BTN_NM").val("");
		 	$("#EXEC_INFO").val("");
		 	$("#SEL_ORD").val("");
		}
	</script>

	<style type="text/css">
		.row .tit{width: 55px;}
	</style>
</head>
<body>
	<!-- 버튼관리 -->
	<div class="iframe_inner">
	    <input type="hidden" id="langSeList" value="<c:out value='${langSeList}' />" />
		<input type="hidden" id="menuSetList" value="<c:out value='${menuSetList}' />" />
		<input type="hidden" id="menuGrpList" value="<c:out value='${menuGrpList}' />" />
		<input type="hidden" id="btnSeList" value="<c:out value='${btnSeList}' />" />
   		<input type="hidden" id="btnLcSeList" value="<c:out value='${btnLcSeList}' />" />
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
		</div>
		<section class="secwrap">
			<div class="srcharea">
				<div class="row">
					<div class="col">
						<div class="tit" id="lang_se_sel"></div>
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
	
		<section class="secwrap mt30">
			<div class="halfarea" style="width: 39%; float: left;">
				<div class="h4group">
					<h4 class="tit"  id='sc_lst'></h4>
				</div>
		        <div class="boxarea">
		            <div id="gridHolder" class="w_382" style="height:660px;"></div>
		        </div> 
			</div>
		
		
		    <div class="halfarea" style="width: 59%; float: right;">
				<div class="h4group">
					<h4 class="tit" id='btn_mgnt'></h4>
				</div>
	     		<div class="srcharea"  id="divInput2">
	     			<form name="frmMenu" id="frmMenu" method="post" >
	     			<input type="hidden" id="LANG_SE_CD" name="LANG_SE_CD"/>
	     			<input type="hidden" id="MENU_CD" name="MENU_CD"/>
					<div class="row">
						<div class="col">
							<div class="tit" id="btn_se_txt"></div>
							<div class="box">
								<select id="BTN_SE_CD" name="BTN_SE_CD" style="width: 129px" class="i_notnull">
					           </select>
							</div>
						</div>
						<div class="col">
							<div class="tit" id="lc_se_txt"></div>
							<div class="box">
								<select id="BTN_LC_SE" name="BTN_LC_SE" style="width: 200px" class="i_notnull">
					           </select>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col">
							<div class="tit" id="btn_cd_txt"></div>
							<div class="box">
								<input type="text" id="BTN_CD" name="BTN_CD" style="width: 129px" class="i_notnull" maxlength="20"/>
							</div>
						</div>
						<div class="col">
							<div class="tit" id="btn_nm_txt"></div>
							<div class="box">
								<input type="text" id="BTN_NM" name="BTN_NM" style="width: 200px" class="i_notnull" maxByteLength="90"/>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col" style="width: 100%; margin:0px;">
							<div class="tit" id="exec_info_txt"></div>
							<div class="box" style="width:100%;">
								<input type="text" id="EXEC_INFO" name="EXEC_INFO" style="width: 100%" class="i_notnull" maxlength="200">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col">
							<div class="tit" id="sel_ord_txt"></div>
							<div class="box">
								<input type="text" id="SEL_ORD" name="SEL_ORD" style="width: 100px" class="i_notnull" maxlength="3" format="number"/>
							</div>
						</div>
						<div class="btn" id="CR">
						</div>
					</div>
					</form>
				</div>		
		      	<div class="boxarea mt10">
		      	    <div id="gridHolder2" class="w_382" style="height:383px;">
		      	</div>
	      </div>
		</section>
	</div>
</body>
</html>
