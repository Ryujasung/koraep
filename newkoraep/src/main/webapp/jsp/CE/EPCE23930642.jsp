<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>취급수수료고지서 상세조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS;
	 var searchList;
	 var searchDtl	;

     $(function() {
    	 
    	 INQ_PARAMS	= jsonObject($('#INQ_PARAMS').val());
    	 searchList		= jsonObject($('#searchList').val());
    	 searchDtl		= jsonObject($('#searchDtl').val());

    	 $('#title_sub').text('<c:out value="${titleSub}" />');
    	 
    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
    	 //그리드 셋팅
		 fn_set_grid();
		
		//text 셋팅
		$('.write_area .write_tbl table tr th.bd_l').each(function(){
			$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
		});
		
		$('.h4group > .tit').each(function(){
			$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
		});
	
		/************************************
		 * 목록 클릭 이벤트
		 ***********************************/
		$("#btn_page").click(function(){
			fn_page();
		});
		
		var data = searchDtl;
		$('.row > .txtbox').each(function(){
			if($(this).attr('id') == 'NOTY_AMT' || $(this).attr('id') == 'ADD_AMT'){
				$(this).text(kora.common.format_comma(eval('data.'+$(this).attr('id'))) + ' 원');
			}else if($(this).attr('id') == 'BIZRNO'){
				$(this).text(kora.common.setDelim(eval('data.'+$(this).attr('id')), '999-99-99999') );
			}else if($(this).attr('id') == 'RISU_RSN' && data.RISU_RSN != undefined){
				$(this).html(eval('data.'+$(this).attr('id')).replaceAll('\\n', '<br>'));
			}else if($(this).attr('id') == 'RISU_DT' && data.RISU_DT != undefined){
				$(this).text(kora.common.setDelim(eval('data.'+$(this).attr('id')), '9999-99-99') );
			}else{
				$(this).text(eval('data.'+$(this).attr('id')));
			}
		});
		
		//가산금 존재시 보여줌
		if(data.ADD_AMT_SE != undefined){
			$('#risuSection').show();
		}
		
		$("#btn_upd").click(function(){
			fn_upd();
		});
		
		/************************************
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ***********************************/
		 $("#btn_excel").click(function() {
			 fn_excel();
		 });
		
		/************************************
		 * 인쇄 클릭 이벤트
		 ***********************************/
		$("#btn_pnt").click(function(){
			fn_pnt();
		});
		
		/************************************
		 * 용기별합계 클릭 이벤트
		 ***********************************/
		$("#btn_pnt2").click(function(){
			fn_pnt2();
		});
		
		/************************************
		 * 재고지 팝업
		 ***********************************/
		$("#btn_pop").click(function(){
			fn_pop();
		});
		
		//취소요청사유
		$("#btn_pop2").click(function(){
			fn_pop2();
		});
		
		//취소요청취소
		$("#btn_upd2").click(function(){
			fn_upd2();
		});
		
		//재고지취소
		$("#btn_upd3").click(function(){
			fn_upd3();
		});
		 	
	});
     
     
   var parent_item; 
     
   //취소요청사유
  	function fn_pop2(){
       	if(searchDtl.ISSU_STAT_CD != 'C'){ alertMsg('취소요청 내역에 대해서만 조회 가능 합니다.'); return; }
       	
       	var pagedata = window.frameElement.name;
  		parent_item.CNL_REQ_SEQ = searchDtl.CNL_REQ_SEQ;
  		window.parent.NrvPub.AjaxPopup('/CE/EPCE23930882.do', pagedata);
  	}
     
  	//취소요청 취소
 	function fn_upd2(){
 		if(searchDtl.ISSU_STAT_CD != 'C'){
 			alertMsg("취소요청 상태의 고지서만 취소요청취소 가능합니다.");
 			return false;
 		}
     	
 		confirm("취소요청취소 처리 하시겠습니까?", 'fn_upd2_exec');
 	}
 	
 	function fn_upd2_exec(){
 		
 		var data = {};
  		var url = "/CE/EPCE2393064_212.do";
  		
  		data["BILL_DOC_NO"] = searchDtl.BILL_DOC_NO;
  		data["CNL_REQ_SEQ"] = searchDtl.CNL_REQ_SEQ;
  				
 		ajaxPost(url, data, function(rtnData){
 			if(rtnData != null && rtnData != ""){
 				if(rtnData.RSLT_CD =="0000"){
 					alertMsg(rtnData.RSLT_MSG, 'fn_page');
 				}else{
 					alertMsg(rtnData.RSLT_MSG);
 				}
 			}else{
 				alertMsg("error");
 			}
 		}, false);
 				
 	}
 	
 	//재고지 취소
   	function fn_upd3(){

    	if(searchDtl.ADD_AMT_SE == '' || searchDtl.ADD_AMT_SE == undefined){
    		alertMsg('재고지처리된 고지서가 아닙니다.');
     		return;
    	}
    	
   		if(INQ_PARAMS.PARAMS.ISSU_STAT_CD != 'I'){
     		alertMsg('발급상태의 고지서만 재고지취소 가능합니다.');
     		return;
     	}
       	
   		confirm("재고지취소 하시겠습니까?", 'fn_upd3_exec');
   	}
   	
   	function fn_upd3_exec(){
   		
   		var data = {};
   		var url = "/CE/EPCE2393064_213.do";
   		
   		data["BILL_DOC_NO"] = searchDtl.BILL_DOC_NO;
    				
   		ajaxPost(url, data, function(rtnData){
   			if(rtnData != null && rtnData != ""){
   				if(rtnData.RSLT_CD =="0000"){
   					alertMsg(rtnData.RSLT_MSG, 'fn_reload');
   				}else{
   					alertMsg(rtnData.RSLT_MSG);
   				}
   			}else{
   				alertMsg("error");
   			}
   		}, false);
   				
   	}
     
    //재고지
    function fn_pop(){

    	if(INQ_PARAMS.PARAMS.ISSU_STAT_CD != 'I'){
    		alertMsg('발급상태의 고지서만 재고지 가능합니다.');
    		return;
    	}
    	
		parent_item = searchDtl;
		var pagedata = window.frameElement.name;
		window.parent.NrvPub.AjaxPopup('/CE/EPCE2393088.do', pagedata);
	}
     
    //인쇄
   	function fn_pnt(){
		var bill_doc_no = searchDtl.BILL_DOC_NO;
		var day = bill_doc_no.substring(3,11);
		var number = parseInt(day);
		console.log(number);
		if(number > 20210609) {     // 21.6.10 일자이후 자원순환보증금관리센터
			$('form[name="prtForm"] input[name="BILL_DOC_NO"]').val(searchDtl.BILL_DOC_NO);
	   		$('form[name="prtForm"] input[name="MFC_BIZRNO"]').val(searchDtl.MFC_BIZRNO);
	   		kora.common.gfn_viewReport('prtForm', '');
		}else{
			$('form[name="prtForm3"] input[name="BILL_DOC_NO"]').val(searchDtl.BILL_DOC_NO);
	   		$('form[name="prtForm3"] input[name="MFC_BIZRNO"]').val(searchDtl.MFC_BIZRNO);
	   		kora.common.gfn_viewReport('prtForm3', '');
			}
   		
     }

  	//용기별합계
   	function fn_pnt2(){
   		var bill_doc_no = searchDtl.BILL_DOC_NO;
		var day = bill_doc_no.substring(3,11);
		var number = parseInt(day);
		
		if(number > 20210609) {     // 21.6.10 일자이후 자원순환보증금관리센터
			$('form[name="prtForm2"] input[name="BILL_DOC_NO"]').val(searchDtl.BILL_DOC_NO);
	   		$('form[name="prtForm2"] input[name="MFC_BIZRNO"]').val(searchDtl.MFC_BIZRNO);
	   		kora.common.gfn_viewReport('prtForm2', '');
		}else{
			$('form[name="prtForm4"] input[name="BILL_DOC_NO"]').val(searchDtl.BILL_DOC_NO);
	   		$('form[name="prtForm4"] input[name="MFC_BIZRNO"]').val(searchDtl.MFC_BIZRNO);
	   		kora.common.gfn_viewReport('prtForm4', '');
			}
     }
    
    //엑셀저장
	function fn_excel(){

		var collection = gridRoot.getCollection();
		if(collection.getLength() < 1){
			alertMsg("데이터가 없습니다.");
			return;
		}
		
		var now  = new Date(); 				     // 현재시간 가져오기
		var hour = new String(now.getHours());   // 시간 가져오기
		var min  = new String(now.getMinutes()); // 분 가져오기
		var sec  = new String(now.getSeconds()); // 초 가져오기
		var today = kora.common.gfn_toDay();
		var fileName = $('#title_sub').text() +"_" + today+hour+min+sec+".xlsx";
		
		//그리드 컬럼목록 저장
		var col = new Array();
		var columns = dataGrid.getColumns();
		for(i=0; i<columns.length; i++){
			if(columns[i].getDataField() != undefined && columns[i].getDataField() != 'index'){ //순번 제외
				var item = {};
				item['headerText'] = columns[i].getHeaderText();
				
				if(columns[i].getDataField() == 'WRHS_CFM_DT_PAGE'){// html 태크 사용중 컬럼은 대체
					item['dataField'] = 'WRHS_CFM_DT';
				}else{
					item['dataField'] = columns[i].getDataField();
				}
				
				item['textAlign'] = columns[i].getStyle('textAlign');
				item['id'] = kora.common.null2void(columns[i].id);
				
				col.push(item);
			}
		}
		
		var input = INQ_PARAMS["PARAMS"];
		input['fileName'] = fileName;
		input['columns'] = JSON.stringify(col);
		
		var url = "/CE/EPCE23930642_05.do";
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
     
    //발급취소
 	function fn_upd(){
 		
    	if(searchDtl.ISSU_STAT_CD == 'A'){
 			alertMsg("수납확인 상태의 고지서는 발급취소할 수 없습니다.");
 			return false;
 		}
    	
    	if(searchDtl.ADD_ISSU_YN == 'Y'){
    		alertMsg("보증금(조정) 고지서를 먼저 취소하시기 바랍니다.");
 			return false;
 		}
     	
 		confirm("발급된 고지서를 취소하시겠습니까?", 'fn_upd_exec');
 	}
 	
 	function fn_upd_exec(){
 		
 		var data = {};
 		var row = new Array();
  		var url = "/CE/EPCE2393064_21.do";
  		
  		data["BILL_DOC_NO"] = searchDtl.BILL_DOC_NO;
  		data["CNL_REQ_SEQ"] = searchDtl.CNL_REQ_SEQ;
  				
 		ajaxPost(url, data, function(rtnData){
 			if(rtnData != null && rtnData != ""){
 				if(rtnData.RSLT_CD =="0000"){
 					alertMsg(rtnData.RSLT_MSG, 'fn_page');
 				}else{
 					alertMsg(rtnData.RSLT_MSG);
 				}
 			}else{
 				alertMsg("error");
 			}
 		}, false);
 				
 	}
   
    //목록
  	function fn_page(){
  		kora.common.goPageB("", INQ_PARAMS);
    }
    
    //현재페이지 재조회
  	function fn_reload(){
  		kora.common.goPage("/CE/EPCE23930642.do", INQ_PARAMS, "R");
    }
    
  	//입고내역서 상세화면 이동
	function fn_page2(){
		var idx = dataGrid.getSelectedIndices();
		var input = gridRoot.getItemAt(idx);
		
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE23930642.do";
		kora.common.goPage('/CE/EPCE29164642.do', INQ_PARAMS);
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
		 layoutStr.push('	<NumberMaskFormatter id="maskfmt" formatString="###-##-#####"/>');
		 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="on" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
		 layoutStr.push('<groupedColumns>');
		 layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" width="50"/>');
		 layoutStr.push('	<DataGridColumn dataField="MFC_BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150" />');
		 layoutStr.push('	<DataGridColumn dataField="MFC_BRCH_NM"  headerText="'+parent.fn_text('mfc_brch_nm')+'" width="150" />');
		 layoutStr.push('	<DataGridColumn dataField="WHSDL_BIZRNM"  headerText="'+parent.fn_text('whsdl')+'" width="150" />');
		 layoutStr.push('	<DataGridColumn dataField="WHSDL_BIZRNO"  headerText="'+parent.fn_text('whsdl_bizrno')+'" width="150" formatter="{maskfmt}" />');
		 layoutStr.push('	<DataGridColumn dataField="WRHS_CFM_DT_PAGE"  headerText="'+parent.fn_text('wrhs_cfm_dt')+'" width="150" itemRenderer="HtmlItem" />');
		 layoutStr.push('	<DataGridColumn dataField="WRHS_QTY" id="sum1" headerText="'+parent.fn_text('wrhs_qty')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr.push('	<DataGridColumn dataField="WRHS_FEE" id="sum2" headerText="'+parent.fn_text('fee')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr.push('	<DataGridColumn dataField="WRHS_FEE_STAX" id="sum3" headerText="'+parent.fn_text('stax')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr.push('	<DataGridColumn dataField="WRHS_GTN" id="sum4" headerText="'+parent.fn_text('refn_gtn')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr.push('</groupedColumns>');
		 layoutStr.push('	<footers>');
		 layoutStr.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
		 layoutStr.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
		 layoutStr.push('			<DataGridFooterColumn/>');
		 layoutStr.push('			<DataGridFooterColumn/>');
		 layoutStr.push('			<DataGridFooterColumn/>');
		 layoutStr.push('			<DataGridFooterColumn/>');
		 layoutStr.push('			<DataGridFooterColumn/>');
		 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right" />');
		 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right" />');
		 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum3}" formatter="{numfmt}" textAlign="right" />');
		 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum4}" formatter="{numfmt}" textAlign="right" />');
		 layoutStr.push('		</DataGridFooter>');
		 layoutStr.push('	</footers>');
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
			 gridApp.setData(searchList);
	     }
	     var selectionChangeHandler = function(event) {
			rowIndex = event.rowIndex;
		 }
	     var dataCompleteHandler = function(event) {
	 	 }
	     
	     gridRoot.addEventListener("dataComplete", dataCompleteHandler);
	     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	 }

</script>

<style type="text/css">
</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="searchList" value="<c:out value='${searchList}' />"/>
<input type="hidden" id="searchDtl" value="<c:out value='${searchDtl}' />"/>

    <div class="iframe_inner" >
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
			<div class="btn_box" id="UR"></div>
		</div>
		   
		<section class="secwrap">
			<div class="write_area">
				<div class="write_tbl">
					<table>
						<colgroup>
							<col style="width: 15%;">
							<col style="width: 25%;">
							<col style="width: 15%;">
							<col style="width: 45%;">
						</colgroup>
						<tbody>
							<tr>
								<th class="bd_l"  id="mtl_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="BIZRNM"></div>
									</div>
								</td>
								<th class="bd_l" id="bizrno2_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="BIZRNO"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th class="bd_l"  id="rpst_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="RPST_NM"></div>
									</div>
								</td>
								<th class="bd_l" id="addr_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="ADDR"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th class="bd_l"  id="tel_no2_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="RPST_TEL_NO"></div>
									</div>
								</td>
								<th class="bd_l" id="noty_amt_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="NOTY_AMT"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th class="bd_l"  id="pay_bank_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="BANK_NM"></div>
									</div>
								</td>
								<th class="bd_l" id="vr_vacct_no_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="VACCT_NO"></div>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</section>

		<section class="secwrap mt10" id="risuSection" style="display:none">
			<div class="write_area">
				<div class="write_tbl">
					<table>
						<colgroup>
							<col style="width: 15%;">
							<col style="width: 25%;">
							<col style="width: 15%;">
							<col style="width: 45%;">
						</colgroup>
						<tbody>
							<tr>
								<th class="bd_l"  id="add_amt_se_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="ADD_AMT_SE_NM"></div>
									</div>
								</td>
								<th class="bd_l" id="add_amt_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="ADD_AMT"></div>
									</div>
								</td>
							</tr>
							<tr>
								<th class="bd_l"  id="risu_dt_txt"></th>
								<td >
									<div class="row">
										<div class="txtbox" id="RISU_DT"></div>
									</div>
								</td>
								<th class="bd_l"  id="risu_rsn_txt"></th>
								<td >
									<div class="row">
										<div class="txtbox" id="RISU_RSN"></div>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</section>

		<div class="boxarea mt20">
			<div class="h4group" >
				<h5 class="tit" id="bill_issu_dtl_data_txt"><h5>
			</div>
			<div id="gridHolder" style="height: 400px; background: #FFF;"></div>
		</div>

		<section class="btnwrap mt20"  >
			<div class="btn"	 id="BL"></div>
			<div class="btn" style="float:right" id="BR"></div>
		</section>
		
	</div>
	
	<form name="prtForm" id="prtForm">
		<input type="hidden" name="CRF_NAME" value="EPCE23930642.crf" />
		<input type="hidden" name="BILL_DOC_NO" value="" />
        <input type="hidden" name="MFC_BIZRNO" id="MFC_BIZRNO" value="" />
		<input type="hidden" name="S_USER_NM" id="S_USER_NM" value="${ssUserNm}"/>
		<input type="hidden" name="S_BIZR_NM" id="S_BIZR_NM" value="${ssBizrNm}"/>
	</form>
	
	<form name="prtForm2" id="prtForm2">
		<input type="hidden" name="CRF_NAME" value="EPCE23930642_2.crf" />
		<input type="hidden" name="BILL_DOC_NO" value="" />
        <input type="hidden" name="MFC_BIZRNO" id="MFC_BIZRNO" value="" />
		<input type="hidden" name="S_USER_NM" id="S_USER_NM" value="${ssUserNm}"/>
		<input type="hidden" name="S_BIZR_NM" id="S_BIZR_NM" value="${ssBizrNm}"/>
	</form>
	
	<form name="prtForm3" id="prtForm3">
		<input type="hidden" name="CRF_NAME" value="EPCE23930642_3.crf" />
		<input type="hidden" name="BILL_DOC_NO" value="" />
        <input type="hidden" name="MFC_BIZRNO" id="MFC_BIZRNO" value="" />
		<input type="hidden" name="S_USER_NM" id="S_USER_NM" value="${ssUserNm}"/>
		<input type="hidden" name="S_BIZR_NM" id="S_BIZR_NM" value="${ssBizrNm}"/>
	</form>
	
	<form name="prtForm4" id="prtForm4">
		<input type="hidden" name="CRF_NAME" value="EPCE23930642_4.crf" />
		<input type="hidden" name="BILL_DOC_NO" value="" />
        <input type="hidden" name="MFC_BIZRNO" id="MFC_BIZRNO" value="" />
		<input type="hidden" name="S_USER_NM" id="S_USER_NM" value="${ssUserNm}"/>
		<input type="hidden" name="S_BIZR_NM" id="S_BIZR_NM" value="${ssBizrNm}"/>
	</form>

	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="excel" />
	</form>

</body>
</html>