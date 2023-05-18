<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
			
		var INQ_PARAMS;//파라미터 데이터
	
		$(document).ready(function(){
			
			INQ_PARAMS 		=  jsonObject($("#INQ_PARAMS").val());	///파라미터 데이터    
			var stdYnList		=  jsonObject($("#stdYnList").val());         //표준여부
		    var menuSetList 	=  jsonObject($("#menuSetList").val()); //메뉴SET
		    var bizrTpList 		=  jsonObject($("#bizrTpList").val());        //사업자유형
		    var useYnList 		=  jsonObject($("#useYnList").val());        //사용여부
		    
			fn_btnSetting();

			$('#std_yn').text(parent.fn_text('std_yn'));
			$('#menu_set').text(parent.fn_text('menu_set'));
			$('#bizr_tp').text(parent.fn_text('bizr_tp'));
			$('#reg_bizr').text(parent.fn_text('reg_bizr'));
			$('#ath_grp_nm').text(parent.fn_text('ath_grp_nm'));
			$('#use_yn').text(parent.fn_text('use_yn'));
			
			$('#btn_sel').text(parent.fn_text('sel'));
		    
			kora.common.setEtcCmBx2(stdYnList, "", "", $("#STD_YN_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(menuSetList, "", "", $("#MENU_SET_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(bizrTpList, "", "", $("#BIZR_TP_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(useYnList, "", "", $("#USE_YN_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");

			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
			}
			
			fn_set_grid();

			$("#btn_sel").click(function(){
				fn_sel();
			});
			
			$("#btn_upd").click(function(){
				fn_upd();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
		});

		/**
		 * 목록조회
		 */
		function fn_sel(){
			
			var input = {};
			input["STD_YN_SEL"] 			= $("#STD_YN_SEL option:selected").val();
			input["MENU_SET_CD_SEL"] 	= $("#MENU_SET_CD_SEL option:selected").val();
			input["BIZR_TP_CD_SEL"] 	= $("#BIZR_TP_CD_SEL option:selected").val();
			input["USE_YN_SEL"] 			= $("#USE_YN_SEL option:selected").val();
			input["REG_BIZR_SEL"] 		= $("#REG_BIZR_SEL").val();
			input["ATH_GRP_NM_SEL"] 	= $("#ATH_GRP_NM_SEL").val();
			
			//파라미터에 조회조건값 저장 
			INQ_PARAMS["SEL_PARAMS"] = input;
			
			var url = "/CE/EPCE393780119.do";
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.searchList);
				} 
				else {
					alertMsg("error");
				}
				
			}, false);
			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
		}
		
		/**
		 * 등록화면 이동
		 */
		function fn_reg(){
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE3937801.do";
			kora.common.goPage('/CE/EPCE3937831.do', INQ_PARAMS);
		}
		
		/**
		 * 변경화면 이동
		 */
		function fn_upd(){
			
			var idx  = dataGrid.getSelectedIndices();
			var item = gridRoot.getItemAt(idx);
			
			if(idx == '' || idx == null || idx == undefined){
				alertMsg('선택된 행이 없습니다.');
				return;
			}
			
			var input = {};
			input["ATH_GRP_CD"] 	= item.ATH_GRP_CD;
			input["BIZRID"] 			= item.BIZRID;
			input["BIZRNO"] 			= item.BIZRNO;
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE3937801.do";
			kora.common.goPage('/CE/EPCE3937842.do', INQ_PARAMS);
		}
		
		/**
		 * 그리드 관련 변수 선언
		 */
	    var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
		var gridApp, gridRoot, dataGrid, layoutStr, selectorColumn;
		var layoutStr = new Array();
		
		/**
		 * 메뉴관리 그리드 셋팅
		 */
		 function fn_set_grid() {
			 
			 rMateGridH5.create("grid", "gridHolder", jsVars, "100%", "100%");
			 
			 layoutStr.push('<rMateGrid>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center">');
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" headerText="'+parent.fn_text('cho')+'" width="4%" allowMultipleSelection="false" />');
			 layoutStr.push('	<DataGridColumn dataField="index"  headerText="'+parent.fn_text('sn')+'" width="4%" itemRenderer="IndexNoItem" />');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('reg_bizr')+'" width="15%"/>');
			 layoutStr.push('	<DataGridColumn dataField="STD_YN"  headerText="'+parent.fn_text('std_yn')+'" width="8%"/>');
			 layoutStr.push('	<DataGridColumn dataField="ATH_GRP_CD"  headerText="'+parent.fn_text('ath_grp_cd')+'" width="15%"/>');
			 layoutStr.push('	<DataGridColumn dataField="ATH_GRP_NM"  headerText="'+parent.fn_text('ath_grp_nm')+'" width="19%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZR_TP_NM"  headerText="'+parent.fn_text('bizr_tp')+'" width="15%"/>');
			 layoutStr.push('	<DataGridColumn dataField="MENU_SET_NM"  headerText="'+parent.fn_text('menu_set')+'" width="10%"/>');
			 layoutStr.push('	<DataGridColumn dataField="USE_YN"  headerText="'+parent.fn_text('use_yn')+'" width="10%"/>');
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

		     var selectionChangeHandler = function(event) {
				var rowIndex = event.rowIndex;
				selectorColumn = gridRoot.getObjectById("selector");
				selectorColumn.setSelectedIndex(-1);
				selectorColumn.setSelectedIndex(rowIndex);
			 }
		     
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		     
			 //파라미터 call back function 실행
			 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
				 /* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
			 	 window[INQ_PARAMS.FN_CALLBACK]();
			 	//취약점점검 5916 기원우

			 }
		 }

	</script>

	<style type="text/css">
		.row .tit{width: 77px;}
	</style>
</head>
<body>
	<div class="iframe_inner">
	    <input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
		<input type="hidden" id="stdYnList" value="<c:out value='${stdYnList}' />" />
		<input type="hidden" id="menuSetList" value="<c:out value='${menuSetList}' />" />
		<input type="hidden" id="bizrTpList" value="<c:out value='${bizrTpList}' />" />
   		<input type="hidden" id="useYnList" value="<c:out value='${useYnList}' />" />
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
		</div>
		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">
					<div class="col">
						<div class="tit"  style="" id="std_yn"></div>
						<div class="box">						
							<select id="STD_YN_SEL" name="STD_YN_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="menu_set"></div>
						<div class="box">
							<select id="MENU_SET_CD_SEL" name="MENU_SET_CD_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="bizr_tp"></div>
						<div class="box">
							<select id="BIZR_TP_CD_SEL" name="BIZR_TP_CD_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col">
						<div class="tit"  style="" id="reg_bizr"></div>
						<div class="box">						
							<input id="REG_BIZR_SEL" name="REG_BIZR_SEL" type="text" style="width: 179px;" >
						</div>
					</div>
					<div class="col">
						<div class="tit" id="ath_grp_nm"></div>
						<div class="box">
							<input id="ATH_GRP_NM_SEL" name="ATH_GRP_NM_SEL" type="text" style="width: 179px;" >
						</div>
					</div>
					<div class="col">
						<div class="tit" id="use_yn"></div>
						<div class="box">
							<select id="USE_YN_SEL" name="USE_YN_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
					<div class="btn" id="UR">
					</div>
				</div>
			</div>
		</section>
		
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:530px;"></div>
			</div>
		</section>
		
		<section class="btnwrap mt20" >
			<div class="btnwrap">
				<div class="fl_r" id="BR">
				</div>
			</div>
		</section>
		
		<div style="height:50px"></div>
		
	</div>

</body>
</html>
