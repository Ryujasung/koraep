<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>직접회수내역 상세조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS; 	//파라미터 데이터
	 var iniList; 				//상세조회
	 
     $(function() {
    	 
    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
    	 INQ_PARAMS	= jsonObject($("#INQ_PARAMS").val()); 	//파라미터 데이터
    	 iniList = jsonObject($("#iniList_list").val());				//상세조회
    	 
    	 //그리드 셋팅
		 fnSetGrid1();
		
		//다국어 셋팅
		$('#title_sub').text('<c:out value="${titleSub}" />');			//타이틀
		$('#mtl').text(parent.fn_text('mtl'));									//상호
		$('#bizrno').text(parent.fn_text('bizrno2'));							//사업자등록번호
		$('#rpst').text(parent.fn_text('rpst'));									//대표자
		$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm'));		//직매장		
		$('#cntr').text(parent.fn_text('cntr'));					  				//빈용기
		$('#drct_rtrvl_dt').text(parent.fn_text('drct_rtrvl_dt'));			//직접반환일자
		
		/************************************
		 * 목록 클릭 이벤트
		 ***********************************/
		$("#btn_page2").click(function(){
			fn_page2();
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
				item['dataField'] = columns[i].getDataField();
				item['textAlign'] = columns[i].getStyle('textAlign');
				item['id'] = kora.common.null2void(columns[i].id);
				
				col.push(item);
			}
		}
		
		var input = INQ_PARAMS["PARAMS"];
		input['fileName'] = fileName;
		input['columns'] = JSON.stringify(col);
		
		var url = "/CE/EPCE6654264_05.do";
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
	 
   	//빈용기재사용 생산자 정보 표시
    function  fn_init(){
     	
     	if(iniList != null && iniList != ""){
     	
     		$("#RTL_RTN_DT").text(kora.common.setDelim(iniList[0].RTL_RTN_DT, "9999-99-99"));   //직접회순일자
     		$("#MFC_BIZRNM").text(iniList[0].MFC_BIZRNM);   //사업자명
     		$("#MFC_BIZRNO").text(kora.common.setDelim(iniList[0].MFC_BIZRNO_DE, "999-99-99999"));  //사업자등록번호
     		$("#MFC_RPST_NM").text(iniList[0].MFC_RPST_NM);      //사업 대표자명
     		$("#MFC_BRCH_NM").text(iniList[0].MFC_BRCH_NM);  //직매장/공장
     		
     		gridApp.setData(iniList);
     		
     	} 
     	else {
     		alertMsg("error");
     	}
     }
     
     //목록
  	function fn_page2(){
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
			layoutStr.push('	<NumberMaskFormatter id="maskfmt1" formatString="###-##-#####"/>');
			layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" horizontalScrollPolicy="on" headerHeight="35" >');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridColumn dataField="index" headerText="'+ parent.fn_text('sn')+ '" itemRenderer="IndexNoItem" textAlign="center" width="50"  />');
			layoutStr.push('			<DataGridColumn dataField="RTL_RTN_DT" headerText="'+ parent.fn_text('drct_rtn_dt')+ '" textAlign="center" width="110"   formatter="{datefmt2}"/>');
			layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_NM" headerText="'+ parent.fn_text('mfc_brch_nm')+ '" textAlign="center" width="100"  />');
			layoutStr.push('			<DataGridColumn dataField="RTL_RTN_NM" headerText="'+ parent.fn_text('drct_rtn_user_nm')+ '" textAlign="center" width="120" />');
			layoutStr.push('			<DataGridColumn dataField="RTL_RTN_BIZRNO" headerText="'+ parent.fn_text('bizrno2')+ '" textAlign="center" width="150"  formatter="{maskfmt1}"/>');	
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM" headerText="'+ parent.fn_text('ctnr_nm')+ '" textAlign="center" width="200" />');
			layoutStr.push('			<DataGridColumn dataField="CTNR_CD" headerText="'+ parent.fn_text('cd')+ '"  textAlign="center" width="100" />');
			layoutStr.push('			<DataGridColumn dataField="CPCT_NM"  headerText="'+ parent.fn_text('cpct') + '" textAlign="center" width="100" />');
			layoutStr.push('			<DataGridColumn dataField="RTL_RTN_QTY" id="num1" headerText="'+ parent.fn_text('drct_rtn_qty')+ '" width="110" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('			<DataGridColumn dataField="DRCT_PAY_GTN" id="num2" headerText="'+ parent.fn_text('drct_pay_dps2')+ '" width="130" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('			<DataGridColumn dataField="DRCT_PAY_FEE" id="num3" headerText="'+ parent.fn_text('drct_pay_fee')+ '" width="130" formatter="{numfmt}" textAlign="right" />');
			layoutStr.push('			<DataGridColumn dataField="RMK" headerText="'+ parent.fn_text('rmk')+ '" textAlign="left" width="100" />');
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="합계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	//소매직접반환량(개)
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	//직접지급보증금(원)
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	//직접지급수수료(원)
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
    	<input type="hidden" id="iniList_list" value="<c:out value='${iniList}' />" />
    	
    	
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
								<col style="width: 200px;">
								<col style="width: 300px;">
								<col style="width: 200px;">
								<col style="width: auto;">
							</colgroup>
							<tbody>
								<tr>
									<th colspan="1" class="bd_l" id="drct_rtrvl_dt"></th>
									<td colspan="3" >
										<div class="row">
											<div class="txtbox" id="RTL_RTN_DT"></div>
										</div>
									</td>
								</tr>
								<tr>
									<th class="bd_l"  id="mtl"></th>	<!-- 상호 -->
									<td>
										<div class="row">
											<div class="txtbox" id="MFC_BIZRNM"></div>
										</div>
									</td>
									<th class="bd_l" id="bizrno"></th> <!-- 사업자등록번호 -->
									<td>
										<div class="row">
											<div class="txtbox" id="MFC_BIZRNO"></div>
										</div>
									</td>
								</tr>
								<tr>
									<th class="bd_l" id="rpst"></th> <!-- 대표자 -->
									<td>
										<div class="row">
											<div class="txtbox" id="MFC_RPST_NM"></div>
										</div>
									</td>
									<th class="bd_l" id="mfc_brch_nm"></th> <!-- 직매장공장 -->
									<td>
										<div class="row">
											<div class="txtbox" id="MFC_BRCH_NM"></div>
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

		<section class="btnwrap mt20" style=" " >
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
	</div>
	
	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="excel" />
	</form>

</body>
</html>