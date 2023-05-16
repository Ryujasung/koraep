<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>반환내역서상세조회(오직보는것만)</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS;	//파라미터 데이터
	 var iniList;				//상세조회 반환내역서 공급 부분
	 var gridList;			//그리드 데이터
	 
     $(function() {

    	INQ_PARAMS 		= jsonObject($("#INQ_PARAMS").val());		
    	iniList 				= jsonObject($("#iniList").val());	
    	gridList 				= jsonObject($("#gridList").val());	

    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
    	 //그리드 셋팅
		 fnSetGrid1();
		
		//text 셋팅
		$('#title_sub').text('<c:out value="${titleSub}" />');						 					//타이틀
		$('#se').text(parent.fn_text('se'));											//구분
		$('#mtl_nm').text(parent.fn_text('mtl_nm'));								//상호명
		$('#mtl_nm2').text(parent.fn_text('mtl_nm'));							//상호명
		$('#bizrno').text(parent.fn_text('bizrno2'));								//사업자번호
		$('#bizrno2').text(parent.fn_text('bizrno2'));								//사업자번호	
		$('#user_nm').text(parent.fn_text('user_nm'));							//성명
		$('#user_nm2').text(parent.fn_text('user_nm'));						//성명
		$('#addr').text(parent.fn_text('addr'));									//주소
		$('#addr2').text(parent.fn_text('addr'));									//주소
		$('#tel_no').text(parent.fn_text('tel_no2'));								//주소
		$('#tel_no2').text(parent.fn_text('tel_no2'));								//주소
		$('#supplier').text(parent.fn_text('supplier'));							//공급자
		$('#receiver').text(parent.fn_text('receiver'));							//공급받는자
		$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm'));			//직매장									
		$('#car_no').text(parent.fn_text('car_no')); 								//차량번호
		$('#rtrvl_dt').text(parent.fn_text('rtrvl_dt')); 								//반환일자
		
	
		/************************************
		 * 목록 클릭 이벤트
		 ***********************************/
		$("#btn_page").click(function(){
			fn_page();
		});
		
		
		/************************************
		 * 인쇄 클릭 이벤트
		 ***********************************/
		$("#btn_pnt").click(function(){
			kora.common.gfn_viewReport('prtForm', '');
		});
	});
   
    function  fn_init(){
     	
     		$("#RTN_DT")   	  .text(kora.common.formatter.datetime(INQ_PARAMS.PARAMS.RTN_DT, "yyyy-mm-dd"));
     		$("#CAR_NO")          .text(iniList[0].CAR_NO);
     	
     		$("#MFC_BIZRNM")    .text(iniList[0].MFC_BIZRNM);
     		$("#MFC_BIZRNO")    .text(kora.common.setDelim(iniList[0].MFC_BIZRNO, "999-99-99999"));
     		$("#MFC_RPST_NM") .text(iniList[0].MFC_RPST_NM);
     		$("#MFC_RPST_TEL_NO").text(iniList[0].MFC_RPST_TEL_NO);
     		$("#MFC_ADDR")      .text(iniList[0].MFC_ADDR);
     		$("#MFC_BRCH_NM")      .text(iniList[0].MFC_BRCH_NM);
     		
     		$("#WHSDL_BIZRNM")      .text(iniList[0].WHSDL_BIZRNM);
     		$("#WHSDL_BIZRNO")      .text(kora.common.setDelim(iniList[0].WHSDL_BIZRNO, "999-99-99999"));
     		$("#WHSDL_RPST_NM")   .text(iniList[0].WHSDL_RPST_NM);
     		$("#WHSDL_RPST_TEL_NO")  .text(iniList[0].WHSDL_RPST_TEL_NO);
     		$("#WHSDL_ADDR")        .text(iniList[0].WHSDL_ADDR);
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
  	function fn_page(){
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
			layoutStr.push('			<DataGridColumn dataField="index"			headerText="'+ parent.fn_text('sn')+ '" 		width="4%"	textAlign="center"  itemRenderer="IndexNoItem" />');	//순번
			layoutStr.push('			<DataGridColumn dataField="PRPS_CD"  	headerText="'+ parent.fn_text('prps_cd')+ '" width="7%" 	textAlign="center"  />');		//용도(유흥용/가정용)
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM"  	headerText="'+ parent.fn_text('ctnr_nm')+ '" width="15%" 	textAlign="left" />');		//빈용기명
			layoutStr.push('			<DataGridColumn dataField="CTNR_CD" 	headerText="'+ parent.fn_text('cd')+ '" 		width="4%" 	textAlign="center" />');		//코드
			layoutStr.push('			<DataGridColumn dataField="CPCT_NM"  	headerText="'+ parent.fn_text('cpct_cd')+'(ml)'+'" width="6%"	textAlign="center"   />');	//용량(ml)
			layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('qty')+ '">');																																						//수량
			layoutStr.push('				<DataGridColumn dataField="BOX_QTY" headerText="'+ parent.fn_text('box_qty')+ '"	width="4%" formatter="{numfmt}" textAlign="right"  id="num1" />');			//상자
			layoutStr.push('				<DataGridColumn dataField="RTN_QTY"	headerText="'+ parent.fn_text('btl')+ '" 		width="4%" formatter="{numfmt}" textAlign="right"   	id="num2"  />');		//병
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cntr')+ parent.fn_text('dps')+'">');																															//빈용기보증금(원)																		
			layoutStr.push('				<DataGridColumn dataField="RTN_GTN_UTPC"   	headerText="'+ parent.fn_text('utpc')+ '"	width="4%" formatter="{numfmt}" textAlign="right" />');					//단가
			layoutStr.push('				<DataGridColumn dataField="RTN_GTN"				headerText="'+ parent.fn_text('amt')+ '"	width="5%" formatter="{numfmt}" textAlign="right"   id="num3"  />');//금액
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cntr')+' '+ parent.fn_text('std_fee')+'">');																																			//빈용기 취급수수료(원
			layoutStr.push('				<DataGridColumn dataField="RTN_WHSL_FEE_UTPC"		headerText="'+ parent.fn_text('utpc')+ '" 			width="4%" 	formatter="{numfmt}" 	textAlign="right" />');						//단가
			layoutStr.push('				<DataGridColumn dataField="RTN_WHSL_FEE"				headerText="'+ parent.fn_text('whsl_fee2')+ '" 	width="6.5%" 	formatter="{numfmt1}" textAlign="right"   id="num4"  />'); 	//도매수수료
			layoutStr.push('				<DataGridColumn dataField="RTN_RTL_FEE_UTPC"   		headerText="'+ parent.fn_text('utpc')+ '" 			width="4%" 	formatter="{numfmt}" 	textAlign="right" />');						//단가
			layoutStr.push('				<DataGridColumn dataField="RTN_RTL_FEE" 				headerText="'+ parent.fn_text('rtl_fee2')+ '" 		width="6.5%" 	formatter="{numfmt1}" textAlign="right"  id="num6"  />');	//소매수수료
			layoutStr.push('				<DataGridColumn dataField="RTN_WHSL_FEE_STAX"  	headerText="'+ parent.fn_text('stax')+ '" 	width="6.5%" 	formatter="{numfmt}" 	textAlign="right"   id="num5"  />');	//도매부가세
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumn dataField="AMT_TOT"	headerText="'+ parent.fn_text('amt_tot')+ '" width="6%" textAlign="right"	     formatter="{numfmt}"  id="num8"   />');	//금액합계(원)
			layoutStr.push('			<DataGridColumn dataField="RMK_C"		headerText="'+ parent.fn_text('rmk')+ '"		width="7%" textAlign="center"  />');														//비고
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
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');	//도매수수료
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');	//소매수수료
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt1}" textAlign="right"/>');	//도매부가세
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
				<div class="btn" style="float:right" id="UR"><!--인쇄  -->
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
											<th colspan="1" id="se"></th>					<!-- 구분 -->
											<th class="bd_l"  id="rtrvl_dt"></th>			<!-- 반환일자 -->
											<td>
												<div class="row">
													<div class="txtbox" id="RTN_DT"></div>
												</div>
											</td>
											<th class="bd_l" id="car_no"></th> <!-- 차량번호 -->
											<td>
												<div class="row">
													<div class="txtbox" id="CAR_NO"></div>
												</div>
											</td>
										</tr>
										<tr>
											<th rowspan="3"  id="supplier"></th>
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
											<th class="bd_l"  id="user_nm"></th><!-- 성명 -->
											<td>
												<div class="row">
													<div class="txtbox"  id=WHSDL_RPST_NM></div>
												</div>
											</td>
											<th class="bd_l" style="background-color: white; border-left-color: white;"></th>
											<td>
												<div class="row">
													<div class="txtbox"></div>
												</div>
											</td>
										</tr>
										<tr>
											<th class="bd_l" id="tel_no"></th> <!-- 연락처 -->
											<td>
												<div class="row">
													<div class="txtbox" id="WHSDL_RPST_TEL_NO"></div>
												</div>
											</td>
											<th class="bd_l"  id="addr"></th> <!-- 주소 -->
											<td>
												<div class="row">
													<div class="txtbox" id="WHSDL_ADDR"></div>
												</div>
											</td>
										</tr>
										<tr>
											<th rowspan="3" id="receiver"></th>
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
											<th class="bd_l"  id="user_nm2"></th><!-- 성명 -->
											<td>
												<div class="row">
													<div class="txtbox" id="MFC_RPST_NM"></div> 	
												</div>
											</td>
											<th class="bd_l"  id="mfc_brch_nm"></th><!-- 직매장 -->
											<td>
												<div class="row">
													<div class="txtbox" id="MFC_BRCH_NM"></div>
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
											<th class="bd_l"  id="addr2"></th><!-- 생산자 주소 -->
											<td>
												<div class="row">
													<div class="txtbox"  id="MFC_ADDR"></div>
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
			  <div class="h4group" >
				<h5 class="tit"  style="font-size: 16px;">
					&nbsp;&nbsp;※ 반환 대상 직매장/공장 추가는 [정보관리 > 직매장별거래처관리] 메뉴에서 거래 생산자별 직매장을 추가하셔야  반환내역서 등록이 가능합니다.<br/>
	                &nbsp;&nbsp;※ 자료를 입력 후 행추가 버튼을 클릭하여 저장할 자료를 여러건 입력한 후 저장 버튼을 클릭하여 여러건을 동시에 저장 합니다
				</h5>
			</div>
		<section class="btnwrap" style="height: 50px; " >
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
</div>

<form name="prtForm" id="prtForm">
	<input type="hidden" name="CRF_NAME" value="EPMF2910164.crf" />	<!-- 필수 -->
	<input type="hidden" name="RTN_DOC_NO"   id="RTN_DOC_NO"  />
	<input type="hidden" name="MFC_BIZRID"  id="MFC_BIZRID" />
	<input type="hidden" name="MFC_BIZRNO"  id="MFC_BIZRNO"   />
	<input type="hidden" name="WHSDL_BIZRID" id="WHSDL_BIZRID"    />
	<input type="hidden" name="WHSDL_BIZRNO"  id="WHSDL_BIZRNO" />
	<input type="hidden" name="MFC_BRCH_ID" id="MFC_BRCH_ID"  />
	<input type="hidden" name="MFC_BRCH_NO"   id="MFC_BRCH_NO"  />
</form>


</body>
</html>