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
			var whsdlSeCdList = jsonObject($('#whsdlSeCdList').val());
			var whsdlList = jsonObject($('#whsdlList').val());
			var statList = jsonObject($('#statList').val());
			var mfc_bizrnm_sel = jsonObject($("#mfc_bizrnm_sel_list").val());        //생산자
			var txExecNmList = jsonObject($("#txExecNmList").val());	//이체실행상태
			fn_btnSetting();

			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
				
			//날짜 셋팅
		    $('#START_DT_SEL').YJcalendar({  
				toName : 'to',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
				
			});
			$('#END_DT_SEL').YJcalendar({
				fromName : 'from',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
			});
			
			kora.common.setEtcCmBx2(mfc_bizrnm_sel, "", "", $("#MFC_BIZRNM_SEL"), "BIZRID_NO", "BIZRNM", "N", "T");
			kora.common.setEtcCmBx2(statList, "", "", $("#STAT_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(whsdlSeCdList, "","", $("#WHSDL_SE_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N" ,'T');
			kora.common.setEtcCmBx2(whsdlList, "", "", $("#WHSDL_BIZR_SEL"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N", "T");
			kora.common.setEtcCmBx2(txExecNmList, "", "", $("#TX_EXEC_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			$("#WHSDL_BIZR_SEL").select2();
			
			kora.common.getComboYearDesc($("#STD_YEAR_SEL"), "2016", "2015");
			
			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
				
				$("#WHSDL_BIZR_SEL").select2('val', INQ_PARAMS.SEL_PARAMS.WHSDL_BIZR_SEL);
			}

			//그리드 셋팅
			fn_set_grid();
			
			$("#btn_sel").click(function(){
				fn_sel();
			});
			
			$("#btn_page").click(function(){
				fn_page2();
			});
			
			$("#btn_upd").click(function(){
				fn_upd();
			});
			
			$("#btn_upd2").click(function(){
				fn_upd2();
			});
			
			//예금주조회
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			//예금주조회결과
			$("#btn_pop").click(function(){
				fn_pop();
			});
			
            /************************************
	         * 지출 클릭 이벤트
	         ***********************************/
            $("#btn_pnt2").click(function(){
                fn_pnt2();
            });
            
            /************************************
            * 인쇄 클릭 이벤트
            ***********************************/
            $("#btn_pnt").click(function(){
                fn_pnt();
            });
			
			/************************************
			 * 엑셀다운로드 버튼 클릭 이벤트
			 ***********************************/
			 $("#btn_excel").click(function() {
				 fn_excel();
			 });
			
			 /************************************
			 * 도매업자 구분 변경 이벤트
			 ***********************************/
			$("#WHSDL_SE_CD_SEL").change(function(){
				fn_whsl_se_cd();
			});
		});
		
		//도매업자구분 변경시 도매업자 조회 ,생산자가 선택됐을경우 거래중인 도매업자만 조회
	     function fn_whsl_se_cd(){
	    	var url = "/SELECT_WHSDL_BIZR_LIST.do" 
			var input ={};
			   if($("#WHSDL_SE_CD_SEL").val()  !=""){
			   		input["BIZR_TP_CD"] =$("#WHSDL_SE_CD_SEL").val();
			   }

	    	   $("#WHSDL_BIZR_SEL").select2("val","");
	       	   ajaxPost(url, input, function(rtnData) {
	   				if ("" != rtnData && null != rtnData) {  
	   					kora.common.setEtcCmBx2(rtnData, "","", $("#WHSDL_BIZR_SEL"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T'); //업체명
	   				}else{
	   					alertMsg("error");
	   				}
	    		});
	    }
		
        //이체목록 인쇄
        function fn_pnt2(){
            
            var collection = gridRoot.getCollection();
            if(collection.getLength() < 1){
                alertMsg("데이터가 없습니다.");
                return;
            }
            
            if(INQ_PARAMS["SEL_PARAMS"] == undefined){
                alertMsg("먼저 데이터를 조회해야 합니다.");
                return;
            }
            
            $("#CRF_NAME").val("지급이체내역.crf");
            
            $('form[name="prtForm"] input[name="RP_STRT_DT"     ]').val($.trim($("#START_DT_SEL").val()).replace(/\-/gi, ""));
            $('form[name="prtForm"] input[name="RP_END_DT"      ]').val($.trim($("#END_DT_SEL").val()).replace(/\-/gi, ""));
            $('form[name="prtForm"] input[name="RP_WHSLD_BIZRNO"]').val($("#WHSDL_BIZR_SEL option:selected").val().split(";")[1]);
            $('form[name="prtForm"] input[name="RP_PYMT_STAT_CD"]').val($("#STAT_CD_SEL option:selected").val());
            $('form[name="prtForm"] input[name="RD_MBR_SE_NM"   ]').val($("#WHSDL_SE_CD_SEL option:selected").text());
            $('form[name="prtForm"] input[name="RD_WHSLD_BIZRNM"]').val($("#WHSDL_BIZR_SEL option:selected").text());
            kora.common.gfn_viewReport('prtForm', '');
        }
	        
        //인쇄
        function fn_pnt(){
            
            var collection = gridRoot.getCollection();
            if(collection.getLength() < 1){
                alertMsg("데이터가 없습니다.");
                return;
            }
            
            if(INQ_PARAMS["SEL_PARAMS"] == undefined){
                alertMsg("먼저 데이터를 조회해야 합니다.");
                return;
            }
            
            $("#CRF_NAME").val("EPGMPLDPt.crf");
            
            $('form[name="prtForm"] input[name="RP_STRT_DT"     ]').val($.trim($("#START_DT_SEL").val()).replace(/\-/gi, ""));
            $('form[name="prtForm"] input[name="RP_END_DT"      ]').val($.trim($("#END_DT_SEL").val()).replace(/\-/gi, ""));
            $('form[name="prtForm"] input[name="RP_WHSLD_BIZRNO"]').val($("#WHSDL_BIZR_SEL option:selected").val().split(";")[1]);
            $('form[name="prtForm"] input[name="RP_PYMT_STAT_CD"]').val($("#STAT_CD_SEL option:selected").val());
            $('form[name="prtForm"] input[name="RD_MBR_SE_NM"   ]').val($("#WHSDL_SE_CD_SEL option:selected").text());
            $('form[name="prtForm"] input[name="RD_WHSLD_BIZRNM"]').val($("#WHSDL_BIZR_SEL option:selected").text());
            kora.common.gfn_viewReport('prtForm', '');
        }
		
		//엑셀저장
		function fn_excel(){
			var collection = gridRoot.getCollection();
			if(collection.getLength() < 1){
				alertMsg("데이터가 없습니다.");
				return;
			}
			
			if(INQ_PARAMS["SEL_PARAMS"] == undefined){
				alertMsg("먼저 데이터를 조회해야 합니다.");
				return;
			}

			var now  = new Date(); 				     // 현재시간 가져오기
			var hour = new String(now.getHours());   // 시간 가져오기
			var min  = new String(now.getMinutes()); // 분 가져오기
			var sec  = new String(now.getSeconds()); // 초 가져오기
			var today = kora.common.gfn_toDay();
			var fileName = $('#title').text() +"_" + today+hour+min+sec+".xlsx";
			
			//그리드 컬럼목록 저장
			var col = new Array();
			var columns = dataGrid.getColumns();
			for(i=0; i<columns.length; i++){
				if(columns[i].getDataField() != undefined && columns[i].getDataField() != 'index'){ //순번 제외
					var item = {};
					item['headerText'] = columns[i].getHeaderText();
					
					if(columns[i].getDataField() == 'PAY_REG_DT_PAGE'){// html 태크 사용중 컬럼은 대체
						item['dataField'] = 'PAY_REG_DT';
					}else{
						item['dataField'] = columns[i].getDataField();
					}
					
					item['textAlign'] = columns[i].getStyle('textAlign');
					item['id'] = kora.common.null2void(columns[i].id);
					
					col.push(item);
				}
			}
			
			var input = INQ_PARAMS["SEL_PARAMS"];
			input['fileName'] = fileName;
			input['columns'] = JSON.stringify(col);
			
			var url = "/CE/EPCE2371301_05.do";
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
					alertMsg(rtnData.RSLT_MSG);
				}else{
					//파일다운로드
					frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
					frm.fileName.value = fileName;
					frm.submit();
				}
			});
		}
		
		function fn_page(){
			var idx = dataGrid.getSelectedIndices();
			var input = gridRoot.getItemAt(idx)
			
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE2371301.do";
			kora.common.goPage('/CE/EPCE2371364.do', INQ_PARAMS);
		}
		
		function fn_upd2(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}
						
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				if(item.PAY_STAT_CD != 'R'){
					alertMsg('지급오류 항목만 처리 가능합니다.');
					return;
				}
			}
			
			confirm('선택된 내역에 대해 오류건 재전송 하시겠습니까?', "fn_upd2_exec");
		}
		
		function fn_upd2_exec(){
			
			var data = {};
			var row = new Array();
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(item);
			}
			
			data["list"] = JSON.stringify(row);
			
			var url = "/CE/EPCE2371331_092.do";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					if(rtnData.RSLT_CD == '0000'){
						alertMsg(rtnData.RSLT_MSG, 'fn_sel');
	 				}else{
	 					alertMsg(rtnData.RSLT_MSG);
	 				}
				} else {
					alertMsg("error");
				}
			});
			
		}
		
		function fn_page2(){
			
			var chkLst = selectorColumn.getSelectedItems();
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}
			 
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
 				if(item.PAY_STAT_CD != 'L'){
					alertMsg('지급준비 항목만 연계 자료 생성이 가능합니다.');
					return;
				} 				
 				else if(item.TX_EXEC_CD == 'TV' && item.PAY_STAT_CD == 'L'){
					alertMsg('예금주조회 실행 후 전송 가능합니다.');
					return;
				} 
				
				 /* if(item.PAY_STAT_CD != 'L' || item.TX_EXEC_CD != 'TY'){
					alertMsg('지급준비 및 이체실행한 항목만 연계 자료 생성이 가능합니다.');
					return;
				} */ 
			}
			
			confirm('선택된 내역에 대해 연계전송 하시겠습니까?', "fn_page2_exec");
		}
		
		function fn_page2_exec(){
			
			var data = {};
			var row = new Array();
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(item);
			}
			
			data["list"] = JSON.stringify(row);
			
			INQ_PARAMS["PARAMS"] = data;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE2371301.do";
			kora.common.goPage('/CE/EPCE2371331.do', INQ_PARAMS);
			
		}
		
		//예금주조회
		function fn_reg(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alertMsg("선택된 행이 없습니다.");
				return;
			}
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			
				if(item.PAY_STAT_CD != 'L'){
					alertMsg('지급준비인 항목만 예금주 조회가 가능합니다.');
					return;
				} 
			
			}
			
			confirm('선택된 내역에 대해 예금주 조회를 하시겠습니까?', "fn_reg_exec");
		}
		
		function fn_reg_exec(){
			
			var data = {};
			var row = new Array();
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				var param = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				
				param["ACCT_NO"] = item["ACP_ACCT_NO"];
				param["ACCT_DPSTR_NM"] = item["ACP_ACCT_DPSTR_NM"];
				param["BANK_CD"] = item["BANK_CD"];
				param["PAY_DOC_NO"] = item["PAY_DOC_NO"];
				
				row.push(param);
			}
			
			data["list"] = JSON.stringify(row);
			data['PARAM_BTN_CD'] = kora.common.btn_id;	//버튼 아이디
			data['PARAM_MENU_CD'] = gUrl;				//메뉴CD

			var url = "/CMS/CMSCS002_02.do";
			
			var cnt = Math.round(row.length / 200);
			var min = cnt ? cnt : 1;
			alertMsg("약 " + min + "분 후에 예금주조회결과를 확인해주세요.");
			
			$.ajax({
				url : url,
				type : 'POST',
				data : data,
				dataType : 'json',
				cache : false,
				async : true,
				traditional : true,
				beforeSend: function(request) {
				    request.setRequestHeader("AJAX", true);
				    request.setRequestHeader(gheader, $("meta[name='_csrf']").attr("content"));
				},
				success : function(data) {},
				error : function(c) {
					console.log(c);
					if(c.status == 401 || c.status == 403){
						window.parent.location.href = "/login.do";
					}else if(c.responseText != null && c.responseText != ""){
						alert("처리중 오류가 발생하였습니다. \r\n다시 시도 하십시오.");	
					}
				}
			});
		}
		
		function fn_pop(){
			confirm('예금주조회결과 페이지로 이동하시겠습니까?', "fn_pop_exec");
		}
		
		function fn_pop_exec(){
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE2371301.do";
			kora.common.goPage('/CMS/CMSCS001.do', INQ_PARAMS);
		}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){
			var url = "/CE/EPCE2371301_19.do";
			var input = {};
			
			input['START_DT_SEL'] = $("#START_DT_SEL").val();
			input['END_DT_SEL'] = $("#END_DT_SEL").val();
			input['STAT_CD_SEL'] = $("#STAT_CD_SEL option:selected").val();
			input['WHSDL_SE_CD_SEL'] = $("#WHSDL_SE_CD_SEL option:selected").val();
			input['WHSDL_BIZR_SEL'] = $("#WHSDL_BIZR_SEL option:selected").val();
			input["MFC_BIZRNM_SEL"]    = $("#MFC_BIZRNM_SEL").val()  //출고 생산자 선택
			input['STD_YEAR_SEL'] = $("#STD_YEAR_SEL option:selected").val();
			input['TX_EXEC_CD_SEL'] = $("#TX_EXEC_CD_SEL option:selected").val();
	
			//파라미터에 조회조건값 저장 
			INQ_PARAMS["SEL_PARAMS"] = input; 
			
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
			 layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			 layoutStr.push(' <NumberMaskFormatter id="dateFmt" formatString="####-##-##"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			 layoutStr.push('<groupedColumns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="true" headerText="" width="40" verticalAlign="middle" />');
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" width="50"/>');
			 layoutStr.push('	<DataGridColumn dataField="PAY_REG_DT_PAGE" headerText="'+parent.fn_text('pay_plan_dt')+'" width="100" itemRenderer="HtmlItem" />');
			 layoutStr.push('	<DataGridColumn dataField="WHSDL_BIZRNM" headerText="'+parent.fn_text('whsdl')+'" width="170" />');
			 layoutStr.push('	<DataGridColumn dataField="ACP_BANK_NM" headerText="'+parent.fn_text('acp_bank_nm')+'" width="100" />');
			 layoutStr.push('	<DataGridColumn dataField="ACP_ACCT_NO" headerText="'+parent.fn_text('acp_acct_no')+'" width="120" />');
			 layoutStr.push('	<DataGridColumn dataField="REAL_PAY_DT" headerText="'+parent.fn_text('real_pay_dt')+'" width="140" />');
			 layoutStr.push('	<DataGridColumn dataField="BIZR_ABBR_NM" headerText="'+parent.fn_text('bizr_abbr_nm')+'" width="140" />');
			 layoutStr.push('	<DataGridColumn dataField="GTN_TOT" id="sum1" headerText="'+parent.fn_text('dps2')+'" width="100" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="FEE_TOT" id="sum2" headerText="'+parent.fn_text('fee')+'" width="100" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="FEE_STAX_TOT" id="sum3" headerText="'+parent.fn_text('stax')+'" width="100" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="PAY_AMT" id="sum4" headerText="'+parent.fn_text('pay_amt')+'" width="100" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="PAY_STAT_NM"  headerText="'+parent.fn_text('stat')+'" width="100"/>');
			 layoutStr.push('	<DataGridColumn dataField="TX_EXEC_NM"  headerText="'+parent.fn_text('tx_exec_nm')+'" width="120"/>');
			 layoutStr.push('	<DataGridColumn dataField="STD_YEAR"  headerText="'+parent.fn_text('std_year')+'" width="80"/>');
			 layoutStr.push('</groupedColumns>');
			 layoutStr.push('	<footers>');
			 layoutStr.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum3}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum4}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('		</DataGridFooter>');
			 layoutStr.push('	</footers>');
			 layoutStr.push('		<dataProvider>');
			 layoutStr.push('			<SpanArrayCollection extractable="false" source="{$gridData}"/>');
			 layoutStr.push('		</dataProvider>');
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
		         dataGrid.addEventListener("change", selectionChangeHandler); //이벤트 등록

		         //파라미터 call back function 실행
				 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
				 	eval(INQ_PARAMS.FN_CALLBACK+"()");
				 }else{
					gridApp.setData();
				 }
		     }
		     var selectionChangeHandler = function(event) {
				rowIndex = event.rowIndex;
			 }
		     var dataCompleteHandler = function(event) {
		    	 setSpanAttributes();
		 	 }
		     
		     gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
		
		
		 function setSpanAttributes() {
			 var collection; //그리드 데이터 객체
		     if (collection == null)
		         collection = gridRoot.getCollection();
		     if (collection == null) {
		         alertMsg("collection 객체를 찾을 수 없습니다");
		         return;
		     }
		  
		     for (var i = 0; i < collection.getLength(); i++) {
		     	var data = gridRoot.getItemAt(i);

		     	if(data.PAY_STAT_CD == "P"){
		 	        collection.addRowAttributeDetailAt(i, null, "#FFCC00", null, false, 20);
		     	}
		     }
		 }
		
	</script>

	<style type="text/css">
		.row .tit{width: 82px;}
	</style>

</head>
<body>

	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
	<input type="hidden" id="whsdlSeCdList" value="<c:out value='${whsdlSeCdList}' />"/>
	<input type="hidden" id="whsdlList" value="<c:out value='${whsdlList}' />"/>
	<input type="hidden" id="statList" value="<c:out value='${statList}' />"/>
	<input type="hidden" id="txExecNmList" value="<c:out value='${txExecNmList}' />"/>
    <input type="hidden" id="mfc_bizrnm_sel_list" value="<c:out value='${mfc_bizrnm_sel}' />" />

	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
            <div class="btn_box" id="UR">
            </div>
		</div>
		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">
					<div class="col">
						<div class="tit" id="sel_term_txt"></div>
						<div class="box">		
							<div class="calendar">
								<input type="text" id="START_DT_SEL" name="from" style="width: 130px;" ><!--시작날짜  -->
							</div>
							<div class="obj">~</div>
							<div class="calendar">
								<input type="text" id="END_DT_SEL" name="to" style="width: 130px;" ><!-- 끝날짜 -->
							</div>
						</div>
					</div>
					<div class="col" >
						<div class="tit" id="whsl_se_cd_txt" ></div>
						<div class="box">
							<select id="WHSDL_SE_CD_SEL" name="WHSDL_SE_CD_SEL" style="width: 179px"></select>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="enp_nm_txt"></div> 
						<select id="WHSDL_BIZR_SEL" name="WHSDL_BIZR_SEL" style="width: 180px;"></select>
					</div>
				</div>
				<div class="row">
                    <div class="col" >  <!--출고 생산자 선택 -->
                        <div class="tit" id="mfc_bizrnm_txt" ></div>
                        <div class="box" style="width:280px">
                            <select id="MFC_BIZRNM_SEL" style="width: 179px"></select>
                        </div>
                    </div>
					<div class="col">
						<div class="tit" id="stat_txt" style=""></div>
						<div class="box">
							<select id="STAT_CD_SEL" name="STAT_CD_SEL" style="width: 179px;">
							</select>
						</div>
					</div>
				
	                <div class="col">
	                    <div class="tit" id="std_year_txt" style=""></div>
	                    <div class="box">
	                        <select id="STD_YEAR_SEL" name="STD_YEAR_SEL" style="width: 179px;">
	                            <option value="" selected>전체</option>
	                        </select>
	                    </div>
	                </div>
	                <div class="col">
						<div class="tit" id="tx_exec_nm_txt"></div>
						<div class="box">
							<select id="TX_EXEC_CD_SEL" name="TX_EXEC_CD_SEL" style="width: 179px;"></select>
						</div>
					</div>
	                
	                <div class="btn" id="CR"></div>
				</div>
			</div>
		</section>
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:430px;"></div>
			</div>
		</section>
        <div class="h4group" >
            <h5 class="tit"  style="font-size: 16px;">
            </h5>
        </div>
		<section class="btnwrap mt20" >
			<div class="fl_l" id="BL">
			</div>
			<div class="fl_r" id="BR">
			</div>
		</section>
		
	</div>
    
    <form name="prtForm" id="prtForm">
        <!-- 필수 -->
        <input type="hidden" id="CRF_NAME" name="CRF_NAME" value="EPGMPLDPt.crf" />
        
        <!-- 파라메타 -->
        <input type="hidden" id="RP_STRT_DT" name="RP_STRT_DT" value="" />
        <input type="hidden" id="RP_END_DT" name="RP_END_DT" value="" />
        <input type="hidden" id="RP_WHSLD_BIZRNO" name="RP_WHSLD_BIZRNO" value="" />
        <input type="hidden" id="RP_PYMT_STAT_CD" name="RP_PYMT_STAT_CD" value="" />
        <input type="hidden" id="RD_MBR_SE_NM" name="RD_MBR_SE_NM" value="" />
        <input type="hidden" id="RD_WHSLD_BIZRNM" name="RD_WHSLD_BIZRNM" value="" />
        <input type="hidden" name="USER_NM" id="USER_NM" value="${ssUserNm}"/>
        <input type="hidden" name="BSNM_NM" id="BSNM_NM" value="${ssBizrNm}"/>
    </form>
	
	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="excel" />
	</form>
	
</body>
</html>
