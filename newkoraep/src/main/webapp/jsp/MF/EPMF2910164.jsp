<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>반환관리상세</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS;///파라미터 데이터
	 var iniList;//상세조회 반환내역서 공급 부분
	 var gridList;//그리드 데이터
     $(function() {
    	 INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());	///파라미터 데이터 
    	 iniList = jsonObject($("#iniList").val());//상세조회 반환내역서 공급 부분
    	 gridList = jsonObject($("#gridList").val());//그리드 데이터

    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
    	 //그리드 셋팅
		 fnSetGrid1();
		
		//text 셋팅
		$('#title_sub').text('<c:out value="${titleSub}" />');//타이틀
		$('#se').text(parent.fn_text('se'));//구분
		$('#mtl_nm').text(parent.fn_text('mtl_nm'));//상호명
		$('#mtl_nm2').text(parent.fn_text('mtl_nm'));//상호명
		$('#bizrno').text(parent.fn_text('bizrno2'));//사업자번호
		$('#bizrno2').text(parent.fn_text('bizrno2'));//사업자번호	
		$('#user_nm').text(parent.fn_text('user_nm'));//성명
		$('#user_nm2').text(parent.fn_text('user_nm'));//성명
		$('#addr').text(parent.fn_text('addr'));//주소
		$('#addr2').text(parent.fn_text('addr'));//주소
		$('#tel_no').text(parent.fn_text('tel_no2'));//주소
		$('#tel_no2').text(parent.fn_text('tel_no2'));//주소
		$('#supplier').text(parent.fn_text('supplier'));//공급자
		$('#receiver').text(parent.fn_text('receiver'));//공급받는자
		$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm'));//직매장
		$('#car_no').text(parent.fn_text('car_no'));//차량번호
		$('#rtrvl_dt').text(parent.fn_text('rtrvl_dt'));//반환일자
		$('#rtn_reg_dt').text(parent.fn_text('rtn_reg_dt'));//반환등록일자
		$('#rtn_doc_no').text(parent.fn_text('rtn_doc_no'));//반환문서번호
		
		/************************************
		 * 반환내역서 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_page").click(function(){
			fn_page();
		});
	
		/************************************
		 * 목록 클릭 이벤트
		 ***********************************/
		$("#btn_page2").click(function(){
			fn_page2();
		});
		
		
		/************************************
		 * 인쇄 클릭 이벤트
		 ***********************************/
		$("#btn_pnt").click(function(){
			kora.common.gfn_viewReport('prtForm', '');
		});
		
		/************************************
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_excel").click(function() {
			fn_excel();
		});
		
	});
    
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
  		var now = new Date();// 현재시간 가져오기
  		var hour = new String(now.getHours());// 시간 가져오기
  		var min = new String(now.getMinutes());// 분 가져오기
  		var sec = new String(now.getSeconds());// 초 가져오기
  		var today = kora.common.gfn_toDay();
  		var fileName = $('#title_sub').text().replace("/","_") +"_" + today+hour+min+sec+".xlsx";
  		
  		//그리드 컬럼목록 저장
  		var col = new Array();
  		var columns = dataGrid.getColumns();
  		for(i=0; i<columns.length; i++){
  			if(columns[i].getDataField() != undefined && columns[i].getDataField() != 'index'){ //순번 제외
  				var item = {};
  				item['headerText'] = columns[i].getHeaderText();

  				if(columns[i].getDataField() == 'RTN_DT'){// html 태크 사용중 컬럼은 대체
 					item['dataField'] = 'RTN_DT_ORI';
 				}else{
 					item['dataField'] = columns[i].getDataField();
 				}
  				
  				item['textAlign'] = columns[i].getStyle('textAlign');
  				item['id'] = kora.common.null2void(columns[i].id);
  				col.push(item);
  			}
  		}
  		
  		var input = INQ_PARAMS["SEL_PARAMS"];
  		input['excelYn'] = 'Y';
  		input['fileName'] = fileName;
  		input['RTN_DOC_NO'] = INQ_PARAMS.PARAMS.RTN_DOC_NO;
  		input['columns'] = JSON.stringify(col);
  		var url = "/MF/EPMF2910164_05.do";
  		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
  	 	ajaxPost(url, input, function(rtnData){
  			if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
  				alertMsg(rtnData.RSLT_MSG);
  			}else{
  				//파일다운로드
  				frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
  				frm.fileName.value = fileName;
  				frm.submit();
  			}
  			
  			hideLoadingBar();// 그리드 loading bar on
  		});  
  	}
     
  	/**
 	 * 그리드 loading bar off
 	 */
 	function hideLoadingBar() {
 		kora.common.hideLoadingBar(dataGrid, gridRoot);
 	}
   
    function  fn_init(){
   		$("#RTN_DT").text(kora.common.formatter.datetime(INQ_PARAMS.PARAMS.RTN_DT_ORI, "yyyy-mm-dd"));
 		    $("#RTN_REG_DT").text(kora.common.formatter.datetime(INQ_PARAMS.PARAMS.RTN_REG_DT, "yyyy-mm-dd"));//반환등록일자
   	
   		$("#MFC_BIZRNM").text(iniList[0].MFC_BIZRNM);
   		$("#MFC_BIZRNO").text(kora.common.setDelim(iniList[0].MFC_BIZRNO, "999-99-99999"));
   		$("#MFC_RPST_NM").text(iniList[0].MFC_RPST_NM);
   		$("#MFC_RPST_TEL_NO").text(iniList[0].MFC_RPST_TEL_NO);
   		$("#MFC_ADDR").text(iniList[0].MFC_ADDR);
   		$("#MFC_BRCH_NM").text(iniList[0].MFC_BRCH_NM);
   		$("#CAR_NO").text(iniList[0].CAR_NO);
   		
   		$("#WHSDL_BIZRNM").text(iniList[0].WHSDL_BIZRNM);
   		$("#WHSDL_BIZRNO").text(kora.common.setDelim(iniList[0].WHSDL_BIZRNO, "999-99-99999"));
   		$("#WHSDL_RPST_NM").text(iniList[0].WHSDL_RPST_NM);
   		$("#WHSDL_RPST_TEL_NO").text(iniList[0].WHSDL_RPST_TEL_NO);
   		$("#WHSDL_ADDR").text(iniList[0].WHSDL_ADDR);
   		$("#RTN_DOC_NO").text(INQ_PARAMS.PARAMS.RTN_DOC_NO);
   		gridApp.setData(gridList);
   		
   		//form값 셋팅
   		$("#prtForm").find("#RTN_DOC_NO").val(INQ_PARAMS.PARAMS.RTN_DOC_NO);
   		$("#prtForm").find("#MFC_BIZRID").val(INQ_PARAMS.PARAMS.MFC_BIZRID);
   		$("#prtForm").find("#MFC_BIZRNO").val(INQ_PARAMS.PARAMS.MFC_BIZRNO);
   		$("#prtForm").find("#WHSDL_BIZRID").val(INQ_PARAMS.PARAMS.WHSDL_BIZRID);
   		$("#prtForm").find("#WHSDL_BIZRNO").val(INQ_PARAMS.PARAMS.WHSDL_BIZRNO);
   		$("#prtForm").find("#MFC_BRCH_ID").val(INQ_PARAMS.PARAMS.MFC_BRCH_ID);  
   		$("#prtForm").find("#MFC_BRCH_NO").val(INQ_PARAMS.PARAMS.MFC_BRCH_NO);
     }
    
     //목록
  	function fn_page2(){
  		//kora.common.goPageB('/CE/EPCE2910101.do', INQ_PARAMS);
  		kora.common.goPageB('', INQ_PARAMS);
     }
    
     
	/****************************************** 그리드 셋팅 시작***************************************** */
	/**
	 * 그리드 관련 변수 선언
	 */
	var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
	var gridApp, gridRoot, dataGrid, layoutStr, selectorColumn;

	/**
	 * 그리드 셋팅
	 */
	 function fnSetGrid1(reDrawYn) {
			rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%");

			layoutStr = new Array();
			  
			layoutStr.push('<rMateGrid>');
			layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr.push('	<NumberFormatter id="numfmt1" precision="2" useThousandsSeparator="true"/>');
			layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true"  draggableColumns="true" sortableColumns="true"  headerHeight="35">');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridColumn dataField="index" headerText="'+ parent.fn_text('sn')+ '" width="4%"	textAlign="center"  itemRenderer="IndexNoItem" />');//순번
			layoutStr.push('			<DataGridColumn dataField="PRPS_CD" headerText="'+ parent.fn_text('prps_cd')+ '" width="7%" textAlign="center"  />');//용도(유흥용/가정용)
			layoutStr.push('            <DataGridColumn dataField="STANDARD_NM"     headerText="용기구분"        width="7%" textAlign="center"  />');
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM" headerText="'+ parent.fn_text('ctnr_nm')+ '" width="15%" textAlign="left" />');//빈용기명
			layoutStr.push('			<DataGridColumn dataField="CTNR_CD" headerText="'+ parent.fn_text('cd')+ '" width="4%" 	textAlign="center" />');//코드
			layoutStr.push('			<DataGridColumn dataField="CPCT_NM" headerText="'+ parent.fn_text('cpct_cd')+'(ml)'+'" width="6%"	textAlign="center" />');//용량(ml)
			layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('qty')+ '">');//수량
			layoutStr.push('				<DataGridColumn dataField="BOX_QTY" headerText="'+ parent.fn_text('box_qty')+ '" width="4%" formatter="{numfmt}" textAlign="right"  id="num1" />');//상자
			layoutStr.push('				<DataGridColumn dataField="RTN_QTY"	headerText="'+ parent.fn_text('btl')+ '" width="4%" formatter="{numfmt}" textAlign="right" id="num2"  />');//병
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cntr')+ parent.fn_text('dps')+'">');//빈용기보증금(원)
			layoutStr.push('				<DataGridColumn dataField="RTN_GTN_UTPC" headerText="'+ parent.fn_text('utpc')+ '" width="4%" formatter="{numfmt}" textAlign="right" />');//단가
			layoutStr.push('				<DataGridColumn dataField="RTN_GTN" headerText="'+ parent.fn_text('amt')+ '" width="5%" formatter="{numfmt}" textAlign="right"   id="num3"  />');//금액
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cntr')+' '+ parent.fn_text('std_fee')+'">');//빈용기 취급수수료(원
			layoutStr.push('				<DataGridColumn dataField="RTN_WHSL_FEE_UTPC" headerText="'+ parent.fn_text('utpc')+ '" width="4%" 	formatter="{numfmt}" textAlign="right" />');						//단가
			layoutStr.push('				<DataGridColumn dataField="RTN_WHSL_FEE" headerText="'+ parent.fn_text('whsl_fee2')+ '" width="6.5%" 	formatter="{numfmt1}" textAlign="right"   id="num4"  />'); 	//도매수수료
			layoutStr.push('				<DataGridColumn dataField="RTN_RTL_FEE_UTPC" headerText="'+ parent.fn_text('utpc')+ '" width="4%" 	formatter="{numfmt}" textAlign="right" />');						//단가
			layoutStr.push('				<DataGridColumn dataField="RTN_RTL_FEE" headerText="'+ parent.fn_text('rtl_fee2')+ '" width="6.5%" 	formatter="{numfmt1}" textAlign="right"  id="num6"  />');	//소매수수료
			layoutStr.push('				<DataGridColumn dataField="RTN_WHSL_FEE_STAX"  	headerText="'+ parent.fn_text('stax')+ '" width="6.5%" formatter="{numfmt}" textAlign="right"   id="num5"  />');	//부가세
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumn dataField="AMT_TOT" headerText="'+ parent.fn_text('amt_tot')+ '" width="6%" textAlign="right" formatter="{numfmt}"  id="num8" />');//금액합계(원)
			layoutStr.push('			<DataGridColumn dataField="RMK_C" headerText="'+ parent.fn_text('rmk')+ '" width="7%" textAlign="center"  />');//비고
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="합계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	//상자
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	//병
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	//금액
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt1}" textAlign="right"/>');	//도매수수료
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt1}" textAlign="right"/>');	//소매수수료
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');	//부가세
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num8}" formatter="{numfmt}" textAlign="right"/>');	//합계
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('			</DataGridFooter>');
			layoutStr.push('		</footers>');
			layoutStr.push('	</DataGrid>');
			layoutStr.push('</rMateGrid>');
		};

	/**
	 * 조회기준-생산자 그리드 이벤트 핸들러
	 */
	function gridReadyHandler(id) {
		gridApp = document.getElementById(id); // 그리드를 포함하는 div 객체
		gridRoot = gridApp.getRoot(); // 데이터와 그리드를 포함하는 객체
		gridApp.setLayout(layoutStr.join("").toString());
		gridApp.setData();
		fn_init();
		var layoutCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			dataGrid.addEventListener("change", selectionChangeHandler);
		}
		var dataCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
		}
		var selectionChangeHandler = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			selectorColumn = gridRoot.getObjectById("selector");
			rowIndexValue = rowIndex;
		
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	}

/****************************************** 그리드 셋팅 끝***************************************** */


</script>

<style type="text/css">

.srcharea .row .col{
width: 31%;
} 
.srcharea .row .col .tit{
width: 120px;
}

</style>

</head>
<body>
    <div class="iframe_inner" id="testee" >
    		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="iniList" value="<c:out value='${iniList}' />" />
			<input type="hidden" id="gridList" value="<c:out value='${gridList}' />" />
			
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
				<div class="btn_box" style="float:right" id="UR"><!--인쇄  -->
				</div>
			</div>
			   
			<section class="secwrap">
						<div class="write_area">
							<div class="write_tbl">
								<table>
									<colgroup>
										<col style="width: 10%;">
										<col style="width: 15%;">
										<col style="width: 20%;">
										<col style="width: 15%;">
										<col style="width: auto;">
									</colgroup>
									<tbody>
										<tr>
											<th colspan="1" id="rtn_doc_no"></th>				<!-- 반환문서 -->
											<td colspan="4" style="border-left: 1px solid #c3c8d1;">
												<div class="row">
													<div class="txtbox" id="RTN_DOC_NO"></div>
												</div>
											</td>
										</tr>
										<tr>
											<th colspan="1" id="se"></th>					<!-- 구분 -->
											<th class="bd_l" id="rtn_reg_dt"></th> <!-- 반환등록일자 -->
											<td>
												<div class="row">
													<div class="txtbox" id="RTN_REG_DT"></div>
												</div>
											</td> 
											<th class="bd_l"  id="rtrvl_dt"></th>			<!-- 반환일자 -->
											<td>
												<div class="row">
													<div class="txtbox" id="RTN_DT"></div>
												</div>
											</td>
										</tr>
										<tr>
											<th rowspan="3"  id="supplier"></th> <!--공급자  -->
											<th class="bd_l" id="mtl_nm"></th> <!-- 상호명 -->
											<td>
												<div class="row">
													<div class="txtbox" id="WHSDL_BIZRNM"></div>
												</div>
											</td>
											<th class="bd_l" id="bizrno"></th> <!-- 사업자번호-->
											<td>
												<div class="row">
													<div class="txtbox" id="WHSDL_BIZRNO"></div>
												</div>
											</td>
										</tr>
										<tr>
											<th class="bd_l"  id="addr"></th> <!-- 주소 -->
											<td colspan="3">
												<div class="row">
													<div class="txtbox" id="WHSDL_ADDR"></div>
												</div>
											</td>
										<!-- 	<th class="bd_l" style="background-color: white; border-left-color: white;"></th>
											<td>
												<div class="row">
													<div class="txtbox"></div>
												</div>
											</td> -->
										</tr>
										<tr>
											<th class="bd_l" id="tel_no"></th> <!-- 연락처 -->
											<td>
												<div class="row">
													<div class="txtbox" id="WHSDL_RPST_TEL_NO"></div>
												</div>
											</td>
											<th class="bd_l"  id="user_nm"></th><!-- 성명 -->
											<td>
												<div class="row">
													<div class="txtbox"  id=WHSDL_RPST_NM></div>
												</div>
											</td>
										</tr>
										<tr>
											<th rowspan="4" id="receiver"></th>
											<th class="bd_l" id="mtl_nm2"></th>
											<td>
												<div class="row">
													<div class="txtbox" id="MFC_BIZRNM"></div> <!-- 상호명 -->
												</div>
											</td>
											<th class="bd_l" id="bizrno2" ></th>
											<td>
												<div class="row">
													<div class="txtbox" id="MFC_BIZRNO"></div>	<!-- 사업자등록번호 -->
												</div>
											</td>
										</tr>
										<tr>
											<th class="bd_l"  id="addr2"></th><!-- 생산자 주소 -->
											<td colspan="3" >
												<div class="row" >
													<div class="txtbox"  id="MFC_ADDR"></div>
												</div>
											</td>
										</tr>
										<tr>
											<th class="bd_l" id="tel_no2"></th><!-- 전화번호 -->
											<td>
												<div class="row">
													<div class="txtbox"  id="MFC_RPST_TEL_NO"></div>
												</div>
											</td>
											<th class="bd_l"  id="user_nm2"></th><!-- 성명 -->
											<td>
												<div class="row">
													<div class="txtbox" id="MFC_RPST_NM"></div> 	
												</div>
											</td>
										</tr>
										<tr>
											<th class="bd_l"  id="mfc_brch_nm"></th><!-- 직매장 -->
											<td>
												<div class="row">
													<div class="txtbox" id="MFC_BRCH_NM"></div>
												</div>
											</td>
											<th class="bd_l" id="car_no"></th> <!-- 차량번호 -->
											<td>
												<div class="row">
													<div class="txtbox" id="CAR_NO"></div>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</section>
			<div class="boxarea mt10">
				<div id="gridHolder" style="height: 400px; background: #FFF;"></div>
			</div>	<!-- 그리드 셋팅 -->
		<section class="btnwrap mt10"  >
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
</div>

<form name="prtForm" id="prtForm">
	<input type="hidden" name="CRF_NAME" value="EPCE2910164.crf" />	<!-- 필수 -->
	<input type="hidden" name="RTN_DOC_NO"   id="RTN_DOC_NO"  />
	<input type="hidden" name="MFC_BIZRID"  id="MFC_BIZRID" />
	<input type="hidden" name="MFC_BIZRNO"  id="MFC_BIZRNO"   />
	<input type="hidden" name="WHSDL_BIZRID" id="WHSDL_BIZRID"    />
	<input type="hidden" name="WHSDL_BIZRNO"  id="WHSDL_BIZRNO" />
	<input type="hidden" name="MFC_BRCH_ID" id="MFC_BRCH_ID"  />
	<input type="hidden" name="MFC_BRCH_NO"   id="MFC_BRCH_NO"  />
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