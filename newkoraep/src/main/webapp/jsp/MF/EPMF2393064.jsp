<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>보증금고지서 상세조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS	;
	 var searchList		;
	 var searchDtl			;

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
			if($(this).attr('id') == 'NOTY_AMT'){
				/* $(this).text(kora.common.format_comma(eval('data.'+$(this).attr('id'))) + ' 원'); */
				$(this).text(kora.common.format_comma(data[$(this).attr('id')]) + ' 원');
				//취약점점검 5879 기원우
			}else if($(this).attr('id') == 'BIZRNO'){
				/* $(this).text(kora.common.setDelim(eval('data.'+$(this).attr('id')), '999-99-99999') ); */
			    $(this).text(kora.common.setDelim(data[$(this).attr('id')], '999-99-99999'));
				//취약점점검 5880 기원우 
            }else if($(this).attr('id') == 'RISU_RSN' && data.RISU_RSN != undefined){
                /* $(this).html(eval('data.'+$(this).attr('id')).replaceAll('\\n', '<br>')); */
                $(this).html(data[$(this).attr('id')].replaceAll('\\n', '<br>'));
              //취약점점검 5883 기원우
            }else if($(this).attr('id') == 'RISU_DT' && data.RISU_DT != undefined){
                /* $(this).text(kora.common.setDelim(eval('data.'+$(this).attr('id')), '9999-99-99') ); */
                $(this).text(kora.common.setDelim(data[$(this).attr('id')], '9999-99-99'));
              //취약점점검 5980 기원우
			}else{
				/* $(this).text(eval('data.'+$(this).attr('id'))); */
				$(this).text(data[$(this).attr('id')]);
				//취약점점검 5981 기원우 
			}
		});
		
        //가산금 존재시 보여줌
        if(data.ADD_AMT_SE != undefined){
            $('#risuSection').show();
        }
		
		$("#btn_cnl").click(function(){
			fn_cnl();
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

	});
     
    //인쇄
  	function fn_pnt(){
  		/* $('form[name="prtForm"] input[name="BILL_DOC_NO"]').val(searchDtl.BILL_DOC_NO);
  		$('form[name="prtForm"] input[name="MFC_BIZRNO"]').val(searchDtl.MFC_BIZRNO);
  		kora.common.gfn_viewReport('prtForm', ''); */
  		var bill_doc_no = searchDtl.BILL_DOC_NO;
		var day = bill_doc_no.substring(3,11);
		var number = parseInt(day);
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
				
				if(columns[i].getDataField() == 'DLIVY_REG_DT_PAGE'){// html 태크 사용중 컬럼은 대체
					item['dataField'] = 'DLIVY_REG_DT';
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
		
		var url = "/MF/EPMF2393064_05.do";
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
     
	
	//발급취소요청
	function fn_cnl(){

		if(searchDtl.ISSU_STAT_CD != 'I'){
			alertMsg("발급 상태의 고지서만 발급취소 가능합니다.");
			return false;
		}
		 		
		var pagedata = window.frameElement.name;
		var url = "/MF/EPMF2393088.do";
		window.parent.NrvPub.AjaxPopup(url, pagedata);
	}
      
    //고지서 취소요청 처리
	function fn_upd2(text){

		var url ="/MF/EPMF2393088_21.do";

		var input = {};
	    input["BILL_DOC_NO"] = searchDtl.BILL_DOC_NO;
	    input["REQ_RSN"] = text;

	 	ajaxPost(url, input, function(rtnData){
			if(rtnData.RSLT_CD == "0000"){
				alertMsg(rtnData.RSLT_MSG, 'fn_page');
			}else{
				alertMsg(rtnData.RSLT_MSG);
			}
		});
	
	}
	
     //목록
  	function fn_page(){
  		kora.common.goPageB("", INQ_PARAMS);
     }
     
  	//출고정보 상세화면 이동
	function fn_page2(){
		var idx = dataGrid.getSelectedIndices();
		var input = gridRoot.getItemAt(idx);
		
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/MF/EPMF2393064.do";
		kora.common.goPage('/MF/EPMF66582642.do', INQ_PARAMS);
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
		 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
		 layoutStr.push('<groupedColumns>');
		 layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" width="50"/>');
		 layoutStr.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="200" />');
		 layoutStr.push('	<DataGridColumn dataField="BRCH_NM"  headerText="'+parent.fn_text('mfc_brch_nm')+'" width="200" />');
		 layoutStr.push('	<DataGridColumn dataField="DLIVY_REG_DT_PAGE"  headerText="'+parent.fn_text('reg_dt2')+'" width="150" itemRenderer="HtmlItem" />');
		 layoutStr.push('	<DataGridColumn dataField="DLIVY_QTY_TOT" id="sum1" headerText="'+parent.fn_text('qty')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr.push('	<DataGridColumn dataField="DLIVY_GTN_TOT" id="sum2" headerText="'+parent.fn_text('dps2')+'" width="150" formatter="{numfmt}" textAlign="right"/>');
		 layoutStr.push('	<DataGridColumn dataField="MAPP_SE_NM"  headerText="'+parent.fn_text('se')+'" width="150"/>');
		 layoutStr.push('</groupedColumns>');
		 layoutStr.push('	<footers>');
		 layoutStr.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
		 layoutStr.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
		 layoutStr.push('			<DataGridFooterColumn/>');
		 layoutStr.push('			<DataGridFooterColumn/>');
		 layoutStr.push('			<DataGridFooterColumn/>');
		 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right" />');
		 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right" />');
		 layoutStr.push('			<DataGridFooterColumn/>');
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
							<col style="width: 10%;">
							<col style="width: 10%;">
							<col style="width: 10%;">
							<col style="width: 15%;">
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
								<th class="bd_l"  id="rcpt_bank_txt"></th>
								<td>
									<div class="row">
										<div class="txtbox" id="BANK_NM"></div>
									</div>
								</td>
								<th class="bd_l" id="rcpt_vacct_no_txt"></th>
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
		<input type="hidden" name="CRF_NAME" value="EPCE2393064.crf" />
		<input type="hidden" name="BILL_DOC_NO" id="BILL_DOC_NO" value="" />
        <input type="hidden" name="MFC_BIZRNO" id="MFC_BIZRNO" value="" />
		<input type="hidden" name="S_USER_NM" id="S_USER_NM" value="${ssUserNm}"/>
		<input type="hidden" name="S_BIZR_NM" id="S_BIZR_NM" value="${ssBizrNm}"/>
	</form>
	
	<form name="prtForm3" id="prtForm3">
		<input type="hidden" name="CRF_NAME" value="EPCE2393064_2.crf" /> 
		<input type="hidden" name="BILL_DOC_NO" id="BILL_DOC_NO" value="" />
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