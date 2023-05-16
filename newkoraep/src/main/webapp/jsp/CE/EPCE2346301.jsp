<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
		
		var INQ_PARAMS;
	
		$(document).ready(function(){
			
			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			
			fn_btnSetting();

			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			
			//날짜 셋팅
		    $('#BILL_START_DT').YJcalendar({  
				toName : 'to',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
				
			});
			$('#BILL_END_DT').YJcalendar({
				fromName : 'from',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
			});
			//날짜 셋팅
		    $('#ACP_START_DT').YJcalendar({  
				toName : 'to2',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
				
			});
			$('#ACP_END_DT').YJcalendar({
				fromName : 'from2',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
			});
			
			var bizrList = jsonObject($('#bizrList').val());
			kora.common.setEtcCmBx2(bizrList, "", "", $("#MFC_BIZR"), "BIZRID_NO", "BIZRNM", "N", "T");
			
			var vacctNoList = jsonObject($('#vacctNoList').val());
			kora.common.setEtcCmBx2(vacctNoList, "", "", $("#VACCT_NO"), "VACCT_NO", "VACCT_NO", "N", "T");

			//그리드 셋팅
			fn_set_grid();
			fn_set_grid2();
			fn_set_grid3();
			
			$("#btn_sel").click(function(){
				fn_sel();
			});
			
			$("#btn_sel2").click(function(){
				fn_sel2();
			});
			
			$("#btn_cfm").click(function(){
				fn_cfm();
			});
			
			$("#btn_cfm2").click(function(){
				fn_cfm2();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			$("#btn_upd").click(function(){
				fn_upd();
			});
			
			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			/************************************
			 * 생산자 변경 이벤트
			 ***********************************/
			 $("#MFC_BIZR").change(function(){
					fn_bizr();
			 });
			
			 /************************************
			 * 시작날짜  클릭시 - 삭제  변경 이벤트
			 ***********************************/
			$("#BILL_START_DT").click(function(){
				    var start_dt = $("#BILL_START_DT").val();
				     start_dt   =  start_dt.replace(/-/gi, "");
				     $("#BILL_START_DT").val(start_dt)
			});
			
			/************************************
			 * 시작날짜  클릭시 - 추가  변경 이벤트
			 ***********************************/
			$("#BILL_START_DT").change(function(){
			     var start_dt = $("#BILL_START_DT").val();
			     start_dt   =  start_dt.replace(/-/gi, "");
				if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
			     $("#BILL_START_DT").val(start_dt) 
			});
			
			/************************************
			 * 끝날짜  클릭시 - 삭제  변경 이벤트
			 ***********************************/
			$("#BILL_END_DT").click(function(){
				    var end_dt = $("#BILL_END_DT").val();
				         end_dt  = end_dt.replace(/-/gi, "");
				     $("#BILL_END_DT").val(end_dt)
			});
			
			/************************************
			 * 끝날짜  클릭시 - 추가  변경 이벤트
			 ***********************************/
			$("#BILL_END_DT").change(function(){
			     var end_dt  = $("#BILL_END_DT").val();
			           end_dt =  end_dt.replace(/-/gi, "");
				if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd")
			     $("#BILL_END_DT").val(end_dt) 
			});
			
			/************************************
			 * 시작날짜  클릭시 - 삭제  변경 이벤트
			 ***********************************/
			$("#ACP_START_DT").click(function(){
				    var start_dt = $("#ACP_START_DT").val();
				     start_dt   =  start_dt.replace(/-/gi, "");
				     $("#ACP_START_DT").val(start_dt)
			});
			
			/************************************
			 * 시작날짜  클릭시 - 추가  변경 이벤트
			 ***********************************/
			$("#ACP_START_DT").change(function(){
			     var start_dt = $("#ACP_START_DT").val();
			     start_dt   =  start_dt.replace(/-/gi, "");
				if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
			     $("#ACP_START_DT").val(start_dt) 
			});
			
			/************************************
			 * 끝날짜  클릭시 - 삭제  변경 이벤트
			 ***********************************/
			$("#ACP_END_DT").click(function(){
				    var end_dt = $("#ACP_END_DT").val();
				         end_dt  = end_dt.replace(/-/gi, "");
				     $("#ACP_END_DT").val(end_dt)
			});
			
			/************************************
			 * 끝날짜  클릭시 - 추가  변경 이벤트
			 ***********************************/
			$("#ACP_END_DT").change(function(){
			     var end_dt  = $("#ACP_END_DT").val();
			           end_dt =  end_dt.replace(/-/gi, "");
				if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd")
			     $("#ACP_END_DT").val(end_dt) 
			});
			
		});

		//착오수납처리
		function fn_upd(){
			
			var chkLst = selectorColumn2.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("대상 가상계좌번호 수납내역을 선택해 주세요.");
				return;
			}
			
			confirm('선택된 가상계좌 수납 내역이 착오수납 처리됩니다. 처리된 내역은 복원되지 않습니다. 계속 진행하시겠습니까?', 'fn_upd_exec');
			
		}
		
		function fn_upd_exec(){
			
			var input = {};
			var row = new Array();
			
			for(var i=0; i<selectorColumn2.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot2.getItemAt(selectorColumn2.getSelectedIndices()[i]);
				row.push(item);
			}
			
			input["list"] = JSON.stringify(row);
			
			var url = "/CE/EPCE2346301_21.do";
			ajaxPost(url, input, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					if(rtnData.RSLT_CD = '0000'){
						alertMsg(rtnData.RSLT_MSG, 'fn_sel2');
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
				} else {
					alertMsg("error");
				}
			});
		}
		
		//저장 시 넘길 레코드 데이터
		var jsonHand = [];
		var jsonAuto = [];
		var jsonView = [];
		
		//수기확인
		function fn_cfm(){
			
			var chkLst1 = selectorColumn.getSelectedItems();
			var chkLst2 = selectorColumn2.getSelectedItems();

			if(fnSetTrgtAcpData(chkLst1, chkLst2)){
				var sIdxArr1 = selectorColumn.getSelectedIndices();
				var sIdxArr2 = selectorColumn2.getSelectedIndices();
				
				sIdxArr1.sort(function(a,b){return a-b;});
				sIdxArr2.sort(function(a,b){return a-b;});
			    for(var i=sIdxArr1.length-1; i>=0; i--) gridRoot.removeItemAt(sIdxArr1[i]);
			    for(var i=sIdxArr2.length-1; i>=0; i--) gridRoot2.removeItemAt(sIdxArr2[i]);
			    selectorColumn.setAllItemSelected(false);
			    selectorColumn2.setAllItemSelected(false);
			}
		}
		
		/**
		 * 수납대상 데이터 설정
		 */
		function fnSetTrgtAcpData(jData1, jData2){

			if(jData1.length < 1){ 
				alertMsg("선택된 고지서가 없습니다.");
				return false;
			}
			
			/*
			if(jData2.length < 1){
				alertMsg("선택된 가상계좌수납내역이 없습니다.");
				return false;
			}
			*/
			
			var nSumAmt1 = 0;
			var nSumAmt2 = 0;

			var tmpBizrNm = "";
			var tmpVacctNo = "";
			
			for(var i=0; i<jData1.length; i++){
				if(i == 0) {
				    tmpBizrNm = jData1[i].MFC_BIZRNM;
				    tmpVacctNo = jData1[i].RVACCT_NO;
				}

				if(tmpBizrNm != jData1[i].MFC_BIZRNM){
                    alertMsg("생산자정보가 동일한 고지서만 선택 가능합니다.");
                    return false;
                }
				
				if(tmpVacctNo != jData1[i].RVACCT_NO){
					alertMsg("계좌번호정보가 동일한 고지서만 선택 가능합니다.");
					return false;
				}
				
				nSumAmt1 += Number(kora.common.null2void(jData1[i].NOTY_AMT, "0"));
			}
			
			for(var i=0; i<jData2.length; i++){
				if(tmpVacctNo != jData2[i].VACCT_NO){
					alertMsg("선택된 고지서와 가상계좌수납내역의 계좌번호정보가 일치하지 않습니다.");
					return false;
				}
				
				nSumAmt2 += Number(kora.common.null2void(jData2[i].SUM_AMT, "0"));
			}

			if(nSumAmt1 != nSumAmt2){
				alertMsg("고지금액 합계액과 수납금액 합계액이 일치하지 않습니다.");
				return false;
			}

			//고지서내역 데이터 셋팅
			var arrBill = [];
			var tr_il = kora.common.getDate("yyyymmdd");
			var tr_time = "";
			
            if(jData2[0]){
        	    tr_il = jData2[0].TR_IL;
        	    tr_time = jData2[0].TR_TIME;
                
        	    for(var i=0; i<jData2.length; i++){
        		    console.log("dddddddddd" + jData2[i].TR_IL+ ", " + tr_il);

        		    if(Number(jData2[i].TR_IL)>Number(tr_il)) {
                		tr_il = jData2[i].TR_IL;
                		tr_time = jData2[i].TR_TIME;
                		console.log("CHWUKHKASF" + tr_il + ", " + jData2[i].TR_IL);
                    }
                }
        	    
        	    console.log("ASDFASDF" + tr_il);
            }
			
			for(var i=0; i<jData1.length; i++){
				var itmBill = {};
				itmBill["BILL_DOC_NO"] = jData1[i].BILL_DOC_NO;
				itmBill["BILL_ISSU_DT"] = jData1[i].BILL_ISSU_DT;
				itmBill["BILL_SE_CD"] = jData1[i].BILL_SE_CD;
				itmBill["BILL_SE_NM"] = jData1[i].BILL_SE_NM;
				itmBill["MFC_BIZRNM"] = jData1[i].MFC_BIZRNM;
				itmBill["NOTY_AMT"] = jData1[i].NOTY_AMT;
				itmBill["VACCT_NO"] = jData1[i].RVACCT_NO;
				
				itmBill["TR_IL"] = tr_il;
				itmBill["TR_TIME"] = tr_time;

				arrBill.push(itmBill); //고지서 데이터 처리용
				jsonView.push(itmBill); //하단 그리드 표시용
				
			}
			
			//수납내역 데이터 셋팅
			var arrAcp = [];
			for(var i=0; i<jData2.length; i++){
				var itmBill = {};
				
				itmBill["VACCT_NO"] = jData2[i].VACCT_NO;
				itmBill["TR_IL"] = jData2[i].TR_IL;
				itmBill["TR_TIME"] = jData2[i].TR_TIME;
				itmBill["TR_NO"] = jData2[i].TR_NO;

				arrAcp.push(itmBill); //계좌수납내역 데이터 처리용
			}
			
			var arrData = {};
			arrData["arrBill"] = arrBill;
			arrData["arrAcp" ] = arrAcp;
			
			jsonHand.push(arrData);
			gridApp3.setData(jsonView);
			
			return true;
		}
		
		
		//자동확인
		function fn_cfm2(){
			
			var clen1 = gridRoot.getCollection();
			var clen2 = gridRoot2.getCollection();
			
			if(clen1.getLength() == 0 || clen2.getLength() == 0) return;

			for(var i=clen1.getLength()-1; i>=0; i--){
				var grd1Item = gridRoot.getItemAt(i);
				var addItem = {};

				for(var j=clen2.getLength()-1; j>=0; j--){
					var grd2Item = gridRoot2.getItemAt(j);

					if(grd1Item.RVACCT_NO == grd2Item.VACCT_NO && grd1Item.NOTY_AMT == grd2Item.SUM_AMT )
					{
						addItem = fnSetJsonData(grd1Item, grd2Item);
						
						jsonAuto.push(addItem);
						jsonView.push(addItem);
						
						gridRoot.removeItemAt(i);
						gridRoot2.removeItemAt(j);
						
						break;
					}
				}
			}
			
			gridApp3.setData(jsonView);
		}
		
		/**
		 * 자동확인 데이터 셋팅
		 */
		function fnSetJsonData(data1, data2){
			var addItem = {};
			
			//고지서내역 데이터 셋팅
			addItem["BILL_DOC_NO"] = data1.BILL_DOC_NO;
			addItem["BILL_ISSU_DT"] = data1.BILL_ISSU_DT;
			addItem["BILL_SE_CD"] = data1.BILL_SE_CD;
			addItem["BILL_SE_NM"] = data1.BILL_SE_NM;
			addItem["MFC_BIZRNM"] = data1.MFC_BIZRNM;
			addItem["NOTY_AMT"] = data1.NOTY_AMT;

			//수납내역 데이터 셋팅
			addItem["VACCT_NO"] = data2.VACCT_NO;
			addItem["TR_IL"] = data2.TR_IL;
			addItem["TR_TIME"] = data2.TR_TIME;
			addItem["TR_NO"] = data2.TR_NO;
	
			return addItem;
		}
		
		//저장
		function fn_reg(){
		
			if(jsonHand.length == 0 && jsonAuto.length == 0){
				alertMsg("저장할 내역이 없습니다.");
				return; 
			}
			
			confirm("수납 대사 내역을 저장하시겠습니까?", 'fn_reg_exec');
		}
		
		function fn_reg_exec(){
			
			document.body.style.cursor = "wait";
			kora.common.showLoadingBar(dataGrid2, gridRoot2);// 그리드 loading bar on

			var data = {};
			var row = new Array();
	 		var url = "/CE/EPCE2346301_09.do";
	 		
	 		var data = {};
			data["jsonHand"] = JSON.stringify(jsonHand);
			data["jsonAuto"] = JSON.stringify(jsonAuto);
			
			ajaxPost(url, data, function(rtnData){
				
				document.body.style.cursor = "default";
				
				if(rtnData != null && rtnData != ""){
					if(rtnData.RSLT_CD =="0000"){
						alertMsg(rtnData.RSLT_MSG, 'fn_sel_all');
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
				}else{
					alertMsg("error");
				}
				
				kora.common.hideLoadingBar(dataGrid2, gridRoot2);// 그리드 loading bar off
	
			});
		}
		
		function fn_sel_all(){
			fnInitJsonParam();
			//fn_sel();
			//fn_sel2();
		}
		
		//생산자 변경 이벤트
		function fn_bizr(){
			
			var url = "/CE/EPCE2346301_193.do" 
			var input ={};
		    input["MFC_BIZR"] =$("#MFC_BIZR").val();

       	    ajaxPost(url, input, function(rtnData) {
       	    	if (null != rtnData) {   
   					kora.common.setEtcCmBx2(rtnData.searchList, "","", $("#VACCT_NO"), "VACCT_NO", "VACCT_NO", "N" ,'T');
   					gridApp2.setData([]);
   				} else {
   					alertMsg("error");
   				}
    		});
	       	    
		}
		
		/**
		 * 고지서 목록조회
		 */
		function fn_sel(){

			//데이터 초기화
			fnInitJsonParam();
			
			var url = "/CE/EPCE2346301_19.do";
			var input = {};
			
			input['BILL_START_DT'] = $("#BILL_START_DT").val();
			input['BILL_END_DT'] = $("#BILL_END_DT").val();
			input['MFC_BIZR'] = $("#MFC_BIZR option:selected").val();
	
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.searchList);
				} else {
					alertMsg("error");
				}
				kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
			});
			
		}
		
		/**
		 * 가상계좌 목록조회
		 */
		function fn_sel2(){
			
			//데이터 초기화
			fnInitJsonParam();

			var url = "/CE/EPCE2346301_192.do";
			var input = {};
			
			input['ACP_START_DT'] = $("#ACP_START_DT").val();
			input['ACP_END_DT'] = $("#ACP_END_DT").val();
			input['MFC_BIZR'] = $("#MFC_BIZR option:selected").val();
			input['VACCT_NO'] = $("#VACCT_NO option:selected").val();
	
			kora.common.showLoadingBar(dataGrid2, gridRoot2);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp2.setData(rtnData.searchList);
				} else {
					alertMsg("error");
				}
				kora.common.hideLoadingBar(dataGrid2, gridRoot2);// 그리드 loading bar off
			});
			
		}
		
		function fn_cnl(){
			fnInitJsonParam();
		}
		
		/**
		 * 처리 JSON 데이터 초기화
		 */
		function fnInitJsonParam(){
			gridApp3.setData([]);
			
			jsonHand = [];
			jsonAuto = [];
			jsonView = [];
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
			 layoutStr.push('<NumberFormatter id="numfmt" useThousandsSeparator="true" />'); /* precision="2" */
			 layoutStr.push('<DateFormatter id="datefmt" formatString="YYYY-MM-DD"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			 layoutStr.push('<groupedColumns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="true" headerText="" width="8%" verticalAlign="middle" />');
			 layoutStr.push('	<DataGridColumn dataField="MFC_BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="23%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BILL_ISSU_DT"  headerText="'+parent.fn_text('bill_issu_dt')+'" width="23%" formatter="{datefmt}"/>');
			 layoutStr.push('	<DataGridColumn dataField="BILL_SE_NM"  headerText="'+parent.fn_text('se')+'" width="23%"/>');
			 layoutStr.push('	<DataGridColumn dataField="NOTY_AMT" id="sum1"  headerText="'+parent.fn_text('noty_amt')+'" width="23%" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('</groupedColumns>');
			 layoutStr.push('<footers>');
			 layoutStr.push('	<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('		<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
			 layoutStr.push('		<DataGridFooterColumn/>');
			 layoutStr.push('		<DataGridFooterColumn/>');
			 layoutStr.push('		<DataGridFooterColumn/>');
			 layoutStr.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right"  />');
			 layoutStr.push('	</DataGridFooter>');
			 layoutStr.push('</footers>');
			 layoutStr.push('</DataGrid>');
			 layoutStr.push('</rMateGrid>');
		}
		
		// 그리드 및 메뉴 리스트 세팅
		 function gridReadyHandler(id) {
		 	 gridApp = document.getElementById(id);  // 그리드를 포함하는 div 객체
		     gridRoot = gridApp.getRoot();   // 데이터와 그리드를 포함하는 객체
		     gridApp.setLayout(layoutStr.join("").toString());
		     
		     var layoutCompleteHandler = function(event) {
		         dataGrid = gridRoot.getDataGrid();  // 그리드 객체
		         selectorColumn = gridRoot.getObjectById("selector");
		         gridApp.setData([]);
		     }
		     
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
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
			 layoutStr2.push('<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			 layoutStr2.push('<DateFormatter id="datefmt" formatString="YYYY-MM-DD"/>');
			 layoutStr2.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg2" headerHeight="35" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			 layoutStr2.push('<groupedColumns>');
			 layoutStr2.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="true" headerText="" width="8%" verticalAlign="middle" />');
			 layoutStr2.push('	<DataGridColumn dataField="VACCT_NO"  headerText="'+parent.fn_text('vr_vacct_no')+'" width="23%" />');
			 layoutStr2.push('	<DataGridColumn dataField="SEND_MAN"  headerText="'+parent.fn_text('rcpt_nm')+'" width="23%"/>');
			 layoutStr2.push('	<DataGridColumn dataField="TR_IL"  headerText="'+parent.fn_text('acp_dt')+'" width="23%" formatter="{datefmt}"/>');
			 layoutStr2.push('	<DataGridColumn dataField="SUM_AMT" id="sum1"  headerText="'+parent.fn_text('acp_amt')+'" width="23%" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr2.push('</groupedColumns>');
			 layoutStr2.push('<footers>');
			 layoutStr2.push('	<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr2.push('		<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
			 layoutStr2.push('		<DataGridFooterColumn/>');
			 layoutStr2.push('		<DataGridFooterColumn/>');
			 layoutStr2.push('		<DataGridFooterColumn/>');
			 layoutStr2.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr2.push('	</DataGridFooter>');
			 layoutStr2.push('</footers>');
			 layoutStr2.push('</DataGrid>');
			 layoutStr2.push('</rMateGrid>');
		}
		
		// 그리드 및 메뉴 리스트 세팅
		 function gridReadyHandler2(id) {
		 	 gridApp2 = document.getElementById(id);  // 그리드를 포함하는 div 객체
		     gridRoot2 = gridApp2.getRoot();   // 데이터와 그리드를 포함하는 객체
		     gridApp2.setLayout(layoutStr2.join("").toString());
		     
		     var layoutCompleteHandler = function(event) {
		         dataGrid2 = gridRoot2.getDataGrid();  // 그리드 객체
		         selectorColumn2 = gridRoot2.getObjectById("selector");
		         gridApp2.setData([]);
		     }

		     gridRoot2.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
		
		
		 /**
			 * 그리드 관련 변수 선언
			 */
		    var jsVars3 = "rMateOnLoadCallFunction=gridReadyHandler3";
			var gridApp3, gridRoot3, dataGrid3, layoutStr3, selectorColumn3;
			var layoutStr3 = new Array();
			var rowIndex3;
			
			/**
			 * 그리드 셋팅
			 */
			 function fn_set_grid3() {
				 
				 rMateGridH5.create("grid3", "gridHolder3", jsVars3, "100%", "100%");
				 
				 layoutStr3.push('<rMateGrid>');
				 layoutStr3.push('<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
				 layoutStr3.push('<DateFormatter id="datefmt" formatString="YYYY-MM-DD"/>');
				 layoutStr3.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg3" headerHeight="35" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" doubleClickEnabled="false" >');
				 layoutStr3.push('<groupedColumns>');
				 layoutStr3.push('	<DataGridColumn dataField="MFC_BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="20%" />');
				 layoutStr3.push('	<DataGridColumn dataField="BILL_ISSU_DT"  headerText="'+parent.fn_text('bill_issu_dt')+'" width="10%" formatter="{datefmt}"/>');
				 layoutStr3.push('	<DataGridColumn dataField="BILL_SE_NM"  headerText="'+parent.fn_text('bill_issu_se')+'" width="15%"/>');
				 layoutStr3.push('	<DataGridColumn dataField="NOTY_AMT" id="sum1"  headerText="'+parent.fn_text('noty_amt')+'" width="20%" formatter="{numfmt}" textAlign="right"/>');
				 layoutStr3.push('	<DataGridColumn dataField="VACCT_NO"  headerText="'+parent.fn_text('vr_vacct_no')+'" width="20%"/>');
				 layoutStr3.push('	<DataGridColumn dataField="TR_IL"  headerText="'+parent.fn_text('acp_dt')+'" width="15%" formatter="{datefmt}"/>');
				 layoutStr3.push('</groupedColumns>');	
				 layoutStr3.push('<footers>');
				 layoutStr3.push('	<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
				 layoutStr3.push('		<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
				 layoutStr3.push('		<DataGridFooterColumn/>');
				 layoutStr3.push('		<DataGridFooterColumn/>');
				 layoutStr3.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right" />');
				 layoutStr3.push('		<DataGridFooterColumn/>');
				 layoutStr3.push('		<DataGridFooterColumn/>');
				 layoutStr3.push('	</DataGridFooter>');
				 layoutStr3.push('</footers>');
				 layoutStr3.push('</DataGrid>');
				 layoutStr3.push('</rMateGrid>');

			}
			
			// 그리드 및 메뉴 리스트 세팅
			 function gridReadyHandler3(id) {
			 	 gridApp3 = document.getElementById(id);  // 그리드를 포함하는 div 객체
			     gridRoot3 = gridApp3.getRoot();   // 데이터와 그리드를 포함하는 객체
			     gridApp3.setLayout(layoutStr3.join("").toString());
			     
			     var layoutCompleteHandler = function(event) {
			         dataGrid3 = gridRoot3.getDataGrid();  // 그리드 객체
			       // dataGrid3.addEventListener("change", selectionChangeHandler); //이벤트 등록
			         gridApp3.setData([]);
			     }
		
			     gridRoot3.addEventListener("layoutComplete", layoutCompleteHandler);
			 }
		
	</script>

	<style type="text/css">
		.row .tit{width: 77px;}
	</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="bizrList" value="<c:out value='${bizrList}' />"/>
<input type="hidden" id="vacctNoList" value="<c:out value='${vacctNoList}' />"/>

	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
		</div>

		<section class="secwrap">
			<div class="halfarea" style="width: 49%; float: left;">
				<div class="srcharea"  id="divInput1">
					<div class="row">
						<div class="col">
							<div class="tit" id="bill_issu_dt_txt"></div>
							<div class="box">
					            <div class="calendar">
									<input type="text" id="BILL_START_DT" name="from" style="width: 140px;" >
								</div>
								<div class="obj">~</div>
								<div class="calendar">
									<input type="text" id="BILL_END_DT" name="to" style="width: 140px;" >
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col">
							<div class="tit" id="mfc_bizrnm_txt"></div>
							<div class="box">
								<select id="MFC_BIZR" name="MFC_BIZR" style="width: 159px" >
					            </select>
							</div>
						</div>
						<div class="btn" id="UL">
						</div>
					</div>
				</div>		
				
		        <div class="boxarea mt10">
		            <div id="gridHolder" class="w_382" style="height:225px;"></div>
		        </div> 
			</div>
		
		    <div class="halfarea" style="width: 49%; float: right;">
	     		<div class="srcharea"  id="divInput2">
					<div class="row">
						<div class="col">
							<div class="tit" id="acp_dt_txt"></div>
							<div class="box">
					            <div class="calendar">
									<input type="text" id="ACP_START_DT" name="from2" style="width: 140px;" >
								</div>
								<div class="obj">~</div>
								<div class="calendar">
									<input type="text" id="ACP_END_DT" name="to2" style="width: 140px;" >
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col">
							<div class="tit" id="vr_vacct_no_txt"></div>
							<div class="box">
								<select id="VACCT_NO" name="VACCT_NO" style="width: 179px" >
								</select>
							</div>
						</div>
						<div class="btn" id="UR">
						</div>
					</div>
				</div>
				
		      	<div class="boxarea mt10">
		      	    <div id="gridHolder2" class="w_382" style="height:225px;">
		      	</div>
	      </div>
		</section>
		
		<section class="btnwrap mt10" style="">
			<div class="fl_c" id="CL" style="padding-left:100px">
			</div>
			<div class="fl_r" style="" id="CR">
			</div>
		</section>	
		
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder3" style="height:230px;"></div>
			</div>
		</section>
		
		<section class="btnwrap mt20" style="">
			<div class="fl_r" id="BR">
			</div>
		</section>	
		
	</div>
	
</body>
</html>
