<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />

	<script type="text/javaScript" language="javascript" defer="defer">

		var INQ_PARAMS;
	
		$(document).ready(function(){
			
			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			
			fn_btnSetting();

			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
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
			
			var stdMgntList = jsonObject($('#stdMgntList').val());
			kora.common.setEtcCmBx2(stdMgntList, "","", $("#EXCA_STD_CD"), "EXCA_STD_CD", "EXCA_STD_NM", "N" ,'S');
			for(var k=0; k<stdMgntList.length; k++){ 
		    	if(stdMgntList[k].EXCA_STAT_CD == 'S'){
		    		$('#EXCA_STD_CD').val(stdMgntList[k].EXCA_STD_CD);
		    		break;
		    	}
		    }
			
			var acctNoList = jsonObject($('#acctNoList').val());
			kora.common.setEtcCmBx2(acctNoList, "", "", $("#ACCT_NO"), "ACCT_NO", "ACCT_NO", "N");
			
			var whslSeCdList = jsonObject($('#whslSeCdList').val());
			var whsdlList = jsonObject($('#whsdlList').val());
			kora.common.setEtcCmBx2(whslSeCdList, "","", $("#WHSL_SE_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');
		 	kora.common.setEtcCmBx2(whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');

		 	//도매업자  검색
	  		$("#WHSDL_BIZRNM").select2();
		 	
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
			 * 도매업자 구분 변경 이벤트
			 ***********************************/
			$("#WHSL_SE_CD").change(function(){
				fn_whsl_se_cd();
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

	     function fn_whsl_se_cd(){
	    	var url = "/SELECT_WHSDL_BIZR_LIST.do" 
			var input ={};
			   if($("#WHSL_SE_CD").val()  !=""){
			 		input["BIZR_TP_CD"] = $("#WHSL_SE_CD").val();
			   }
			   /*
			   //생산자 선택시 선택된 생산자랑 거래중인 도매업자 조회
			   if( $("#MFC_BIZRNM").val() !="" ){
    				input["MFC_BIZRID"]	= arr[0];
    				input["MFC_BIZRNO"]	= arr[1];
    				//생산자 + 직매장 선택시 거래중이 도매업자 조회
    				if($("#MFC_BRCH_NM").val() !="" ){
   				 	      input["MFC_BRCH_ID"]	= arr2[0];
   		    			  input["MFC_BRCH_NO"]	= arr2[1];
    				
			   }
			   */
	    		$("#WHSDL_BIZRNM").select2("val","");
	       	    ajaxPost(url, input, function(rtnData) {
    				if ("" != rtnData && null != rtnData) {  
    					kora.common.setEtcCmBx2(rtnData, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');		 //업체명
    				}else{
    					alertMsg("error");
    				}
	    		});
	     }
		
		//착오수납처리
		function fn_upd(){
			
			var chkLst = selectorColumn2.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("대상 계좌번호 수납내역을 선택해 주세요.");
				return;
			}
			
			confirm('선택된 계좌 수납 내역이 착오수납 처리됩니다. 처리된 내역은 복원되지 않습니다. 계속 진행하시겠습니까?', 'fn_upd_exec');
			
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
			
			var url = "/CE/EPCE4735001_21.do";
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
		var jsonView = [];
		
		//수기확인
		function fn_cfm(){
			
			var chkLst1 = selectorColumn.getSelectedItems();
			var chkLst2 = selectorColumn2.getSelectedItems();
			console.log(chkLst1);
			console.log(chkLst2);
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
		
		//상계처리
		function fn_cfm2(){
			
			var chkLst1 = selectorColumn.getSelectedItems();
			var chkLst2 = selectorColumn2.getSelectedItems();

			if(fnSetTrgtAcpData2(chkLst1, chkLst2)){
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
				alertMsg("선택된 정산서가 없습니다.");
				return false;
			}
			
			/*
			if(jData2.length < 1){
				alertMsg("선택된 계좌수납내역이 없습니다.");
				return false;
			}
			*/
			
			var nSumAmt1 = 0;
			var nSumAmt2 = 0;

            var tmpBizrNo = "";
            var tmpAcctNo = "";
			
			for(var i=0; i<jData1.length; i++){
				if(i == 0) {
				    tmpBizrNo = jData1[i].BIZRNO;
				    tmpAcctNo = jData1[i].ACP_ACCT_NO;
				}
				
                if(tmpBizrNo != jData1[i].BIZRNO){
                    alertMsg("도매업자정보가 동일한 정산서만 선택 가능합니다.");
                    return false;
                }

                if(tmpAcctNo != jData1[i].ACP_ACCT_NO){
					alertMsg("계좌번호정보가 동일한 정산서만 선택 가능합니다.");
					return false;
				}
				
				nSumAmt1 += Number(kora.common.null2void(jData1[i].EXCA_AMT, "0"));
			}
			
			for(var i=0; i<jData2.length; i++){
				if(tmpAcctNo != jData2[i].ACCT_NO){
					alertMsg("선택된 정산서와 계좌수납내역의 계좌번호정보가 일치하지 않습니다.");
					return false;
				}
				nSumAmt2 += Number(kora.common.null2void(jData2[i].TX_AMT, "0"));
			}

			if(nSumAmt1 != nSumAmt2){
				alertMsg("정산금액 합계액과 수납금액 합계액이 일치하지 않습니다.");
				return false;
			}

			//고지서내역 데이터 셋팅
			var arrBill = [];
			for(var i=0; i<jData1.length; i++){
				var itmBill = {};
				itmBill["STAC_DOC_NO"] = jData1[i].STAC_DOC_NO;
				itmBill["EXCA_ISSU_SE_CD"] = jData1[i].EXCA_ISSU_SE_CD;
				itmBill["EXCA_SE_CD"] = jData1[i].EXCA_SE_CD;
				itmBill["EXCA_STD_CD"] = jData1[i].EXCA_STD_CD;
				itmBill["EXCA_REG_DT"] = jData1[i].EXCA_REG_DT;
				itmBill["BIZRNM"] = jData1[i].BIZRNM;
				itmBill["BIZRID"] = jData1[i].BIZRID;
				itmBill["BIZRNO"] = jData1[i].BIZRNO;
				itmBill["EXCA_AMT"] = jData1[i].EXCA_AMT;
				itmBill["GTN"] = jData1[i].GTN;
				itmBill["ACCT_NO"] = jData1[i].ACP_ACCT_NO;
				
				if(jData2[0]){
					itmBill["ACCT_TXDAY"] = jData2[0].ACCT_TXDAY;
					itmBill["ACCT_TXTIME"] = jData2[0].ACCT_TXTIME;
					itmBill["JEOKYO"] = jData2[0].JEOKYO;
				}else{
					itmBill["ACCT_TXDAY"] = kora.common.getDate("yyyymmdd");
					itmBill["ACCT_TXTIME"] = "";
					itmBill["JEOKYO"] = "";
				}
				
				arrBill.push(itmBill); //고지서 데이터 처리용
				jsonView.push(itmBill); //하단 그리드 표시용
				
			}
			
			//수납내역 데이터 셋팅
			var arrAcp = [];
			for(var i=0; i<jData2.length; i++){
				var itmBill = {};
				
				itmBill["BANK_CD"] = jData2[i].BANK_CD;
				itmBill["ACCT_NO"] = jData2[i].ACCT_NO;
				itmBill["ACCT_TXDAY"] = jData2[i].ACCT_TXDAY;
				itmBill["ACCT_TXDAY_SEQ"] = jData2[i].ACCT_TXDAY_SEQ;

				arrAcp.push(itmBill); //계좌수납내역 데이터 처리용
			}
			
			var arrData = {};
			arrData["arrBill"] = arrBill;
			arrData["arrAcp" ] = arrAcp;
			
			jsonHand.push(arrData);
			gridApp3.setData(jsonView);
			
			return true;
		}
		
		/**
		 * 상계처리 데이터 설정
		 */
		function fnSetTrgtAcpData2(jData1, jData2){

			if(jData1.length < 1){ 
				alertMsg("선택된 정산서가 없습니다.");
				return false;
			}
			var nSumAmt1 = 0;
			var nSumAmt2 = 0;

            var tmpBizrNo = "";
            var tmpAcctNo = "";
			
			for(var i=0; i<jData1.length; i++){
				if(i == 0) {
				    tmpBizrNo = jData1[i].BIZRNO;
				    tmpAcctNo = jData1[i].ACP_ACCT_NO;
				}
				
                if(tmpBizrNo != jData1[i].BIZRNO){
                    alertMsg("도매업자정보가 동일한 정산서만 선택 가능합니다.");
                    return false;
                }

				nSumAmt1 += Number(kora.common.null2void(jData1[i].EXCA_AMT, "0"));
			}
			
			for(var i=0; i<jData2.length; i++){
				
				nSumAmt2 += Number(kora.common.null2void(jData2[i].TX_AMT, "0"));
			}

			if(nSumAmt1 != nSumAmt2){
				alertMsg("정산금액 합계액과 수납금액 합계액이 일치하지 않습니다.");
				return false;
			}

			//고지서내역 데이터 셋팅
			var arrBill = [];
			for(var i=0; i<jData1.length; i++){
				var itmBill = {};
				itmBill["STAC_DOC_NO"] = jData1[i].STAC_DOC_NO;
				itmBill["EXCA_ISSU_SE_CD"] = jData1[i].EXCA_ISSU_SE_CD;
				itmBill["EXCA_SE_CD"] = jData1[i].EXCA_SE_CD;
				itmBill["EXCA_STD_CD"] = jData1[i].EXCA_STD_CD;
				itmBill["EXCA_REG_DT"] = jData1[i].EXCA_REG_DT;
				itmBill["BIZRNM"] = jData1[i].BIZRNM;
				itmBill["BIZRID"] = jData1[i].BIZRID;
				itmBill["BIZRNO"] = jData1[i].BIZRNO;
				itmBill["EXCA_AMT"] = jData1[i].EXCA_AMT;
				itmBill["GTN"] = jData1[i].GTN;
				itmBill["ACCT_NO"] = jData1[i].ACP_ACCT_NO;
				
				if(jData2[0]){
					itmBill["ACCT_TXDAY"] = jData2[0].ACCT_TXDAY;
					itmBill["ACCT_TXTIME"] = jData2[0].ACCT_TXTIME;
					itmBill["JEOKYO"] = jData2[0].JEOKYO;
				}else{
					itmBill["ACCT_TXDAY"] = kora.common.getDate("yyyymmdd");
					itmBill["ACCT_TXTIME"] = "";
					itmBill["JEOKYO"] = "";
				}
				
				arrBill.push(itmBill); //고지서 데이터 처리용
				jsonView.push(itmBill); //하단 그리드 표시용
				
			}
			
			//수납내역 데이터 셋팅
			var arrAcp = [];
			for(var i=0; i<jData2.length; i++){
				var itmBill = {};
				
				itmBill["BANK_CD"] = jData2[i].BANK_CD;
				itmBill["ACCT_NO"] = jData2[i].ACCT_NO;
				itmBill["ACCT_TXDAY"] = jData2[i].ACCT_TXDAY;
				itmBill["ACCT_TXDAY_SEQ"] = jData2[i].ACCT_TXDAY_SEQ;

				arrAcp.push(itmBill); //계좌수납내역 데이터 처리용
			}
			
			var arrData = {};
			arrData["arrBill"] = arrBill;
			arrData["arrAcp" ] = arrAcp;
			
			jsonHand.push(arrData);
			gridApp3.setData(jsonView);
			
			return true;
		}
		
		//저장
		function fn_reg(){
		
			if(jsonHand.length == 0){
				alertMsg("저장할 내역이 없습니다.");
				return; 
			}
			
			confirm("수납 대사 내역을 저장하시겠습니까?", 'fn_reg_exec');
		}
		
		function fn_reg_exec(){
			
		    console.log("dsdddddddddddd : " + JSON.stringify(jsonHand));
		    
			document.body.style.cursor = "wait";

			var data = {};
			var row = new Array();
	 		var url = "/CE/EPCE4735001_09.do";
	 		
	 		var data = {};
			data["jsonHand"] = JSON.stringify(jsonHand);
			
			ajaxPost(url, data, function(rtnData){
				if(rtnData != null && rtnData != ""){
					if(rtnData.RSLT_CD =="0000"){
						alertMsg(rtnData.RSLT_MSG, 'fn_sel_all');
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
				}else{
					alertMsg("error");
				}
				
				document.body.style.cursor = "default";
			});
			
		}
		
		function fn_sel_all(){
			fnInitJsonParam();
			//fn_sel();
			//fn_sel2();
		}
				
		/**
		 * 정산서 목록조회
		 */
		function fn_sel(){

			var EXCA_STD_CD = $("#EXCA_STD_CD option:selected").val();
			
			if(EXCA_STD_CD == ""){
				alertMsg("정산기간을 선택하세요.");
				return;
			}
			
			//데이터 초기화
			fnInitJsonParam();
			
			var url = "/CE/EPCE4735001_19.do";
			var input = {};
			
			input['EXCA_STD_CD'] = $("#EXCA_STD_CD option:selected").val();
			input['WHSL_SE_CD'] = $("#WHSL_SE_CD option:selected").val();
			input['WHSDL_BIZRNM'] = $("#WHSDL_BIZRNM option:selected").val();
	
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
		 * 계좌 목록조회
		 */
		function fn_sel2(){
			
			//데이터 초기화
			fnInitJsonParam();

			var url = "/CE/EPCE4735001_192.do";
			var input = {};
			
			input['ACP_START_DT'] = $("#ACP_START_DT").val();
			input['ACP_END_DT'] = $("#ACP_END_DT").val();
			input['MFC_BIZR'] = $("#MFC_BIZR option:selected").val();
			input['ACCT_NO'] = $("#ACCT_NO option:selected").val();
	
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
			 layoutStr.push('	<NumberMaskFormatter id="maskfmt" formatString="###-##-#####"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			 layoutStr.push('<groupedColumns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="true" headerText="" width="8%" verticalAlign="middle" />');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('whsdl')+'" width="23%"/>');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNO_DE"  headerText="'+parent.fn_text('bizrno')+'" width="23%" formatter="{maskfmt}" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCA_REG_DT"  headerText="'+parent.fn_text('exca_issu_dt')+'" width="23%" formatter="{datefmt}"/>');
			 layoutStr.push('	<DataGridColumn dataField="EXCA_AMT" id="sum1"  headerText="'+parent.fn_text('exca_amt')+'" width="23%" formatter="{numfmt}" textAlign="right"/>');
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
			 layoutStr2.push('	<DataGridColumn dataField="ACCT_NO"  headerText="'+parent.fn_text('vacct_no')+'" width="23%" />');
			 layoutStr2.push('	<DataGridColumn dataField="ACCT_TXDAY"  headerText="'+parent.fn_text('acp_dt')+'" width="23%" formatter="{datefmt}"/>');
			 layoutStr2.push('	<DataGridColumn dataField="TX_AMT" id="sum1"  headerText="'+parent.fn_text('acp_amt')+'" width="23%" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr2.push('	<DataGridColumn dataField="JEOKYO"  headerText="'+parent.fn_text('smr')+'" width="23%"/>');
			 layoutStr2.push('</groupedColumns>');
			 layoutStr2.push('<footers>');
			 layoutStr2.push('	<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr2.push('		<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
			 layoutStr2.push('		<DataGridFooterColumn/>');
			 layoutStr2.push('		<DataGridFooterColumn/>');
			 layoutStr2.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr2.push('		<DataGridFooterColumn/>');
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
				 layoutStr3.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('whsdl')+'" width="20%" />');
				 layoutStr3.push('	<DataGridColumn dataField="EXCA_REG_DT"  headerText="'+parent.fn_text('exca_issu_dt')+'" width="10%" formatter="{datefmt}"/>');
				 layoutStr3.push('	<DataGridColumn dataField="EXCA_AMT" id="sum1"  headerText="'+parent.fn_text('exca_amt')+'" width="20%" formatter="{numfmt}" textAlign="right"/>');
				 layoutStr3.push('	<DataGridColumn dataField="ACCT_NO"  headerText="'+parent.fn_text('vacct_no')+'" width="20%"/>');
				 layoutStr3.push('	<DataGridColumn dataField="ACCT_TXDAY"  headerText="'+parent.fn_text('acp_dt')+'" width="15%" formatter="{datefmt}"/>');
				 layoutStr3.push('	<DataGridColumn dataField="JEOKYO" headerText="'+parent.fn_text('smr')+'" width="15%"/>');
				 layoutStr3.push('</groupedColumns>');	
				 layoutStr3.push('<footers>');
				 layoutStr3.push('	<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
				 layoutStr3.push('		<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
				 layoutStr3.push('		<DataGridFooterColumn/>');
				 layoutStr3.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right" />');
				 layoutStr3.push('		<DataGridFooterColumn/>');
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
	<input type="hidden" id="whslSeCdList" value="<c:out value='${whslSeCdList}' />"/>
	<input type="hidden" id="whsdlList" value="<c:out value='${whsdlList}' />"/>
	<input type="hidden" id="acctNoList" value="<c:out value='${acctNoList}' />"/>
	<input type="hidden" id="stdMgntList" value="<c:out value='${stdMgntList}' />"/>

	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
		</div>

		<section class="secwrap">
			<div class="halfarea" style="width: 49%; float: left;">
				<div class="srcharea"  id="divInput1">
					<div class="row">
						<div class="col">
							<div class="tit" id="whsdl_txt"></div>
							<div class="box">
					            <select id="WHSL_SE_CD" name="WHSL_SE_CD" style="width: 109px" ></select>
					            <select id="WHSDL_BIZRNM" name="WHSDL_BIZRNM" style="width: 210px" ></select>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col">
							<div class="tit" id="exca_term_txt"></div>
							<div class="box">
					            <select id="EXCA_STD_CD" name="EXCA_STD_CD" style="width: 179px" ></select>
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
							<div class="tit" id="vacct_no_txt"></div>
							<div class="box">
								<select id="ACCT_NO" name="ACCT_NO" style="width: 179px" >
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
