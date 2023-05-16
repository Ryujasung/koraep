<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>출고정보 상세조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS; 	//파라미터 데이터
	 var iniList; 				//상세조회 반환내역서 공급 부분
	 var gridList;			//그리드 데이터
	 
     $(function() {
    	 
    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
    	 INQ_PARAMS	= jsonObject($("#INQ_PARAMS").val()); 	//파라미터 데이터
    	 iniList = jsonObject($("#iniList_list").val());				//상세조회 반환내역서 공급 부분
    	 gridList = jsonObject($("#gridList_list").val());			//그리드 데이터
    	 
    	 
    	 //그리드 셋팅
		 fnSetGrid1();
		
		//다국어 셋팅
		$('#title_sub').text('<c:out value="${titleSub}" />');										//타이틀
		$('#se').text(parent.fn_text('se'));										//구분
		$('#mtl').text(parent.fn_text('mtl'));										//상호
		$('#bizrno').text(parent.fn_text('bizrno2'));								//사업자등록번호
		$('#rpst').text(parent.fn_text('rpst'));									//대표자
		$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm'));						//직매장									
		$('#tel_no').text(parent.fn_text('tel_no2'));								//연락처
		$('#addr').text(parent.fn_text('addr'));									//주소
		$('#cntr').text(parent.fn_text('cntr'));					  				//빈용기
		
		/************************************
		 * 출고정보변경 버튼 클릭 이벤트
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
			fn_pnt();
		});
		
		/************************************
		 * 출력 버튼 클릭 이벤트
		 ***********************************/
		$("#btnPrinter").click(function(){
	
			gfn_viewReport('prtForm', '');
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
			
			var url = "/MF/EPMF66582641_05.do";
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
     	
     		$("#MFC_BIZRNM")    .text(iniList[0].MFC_BIZRNM);   //사업자명
     		$("#MFC_BIZRNO")    .text(kora.common.setDelim(iniList[0].MFC_BIZRNO, "999-99-99999"));  //사업자등록번호
     		$("#MFC_RPST_NM") .text(iniList[0].MFC_RPST_NM);      //사업 대표자명
     		$("#MFC_RPST_TEL_NO").text(iniList[0].MFC_RPST_TEL_NO); //사업자 연락처
     		$("#MFC_ADDR")      .text(iniList[0].MFC_ADDR);    //사업자 주소
     		$("#MFC_BRCH_NM")      .text(iniList[0].MFC_BRCH_NM);  //직매장/공장
     		
     		gridApp.setData(gridList);
     		
     	} 
     	else {
     		alertMsg("error");
     	}
     }
     //출고정보 변경
     function fn_page(){
    	  
    	 if(gridList[0].DLIVY_STAT_CD != 'RG'){
    		 alertMsg("출고등록 상태의 반환정보만 변경 가능합니다. 다시 한 번 확인하시기 바랍니다.");
    		 return;
    	 }
    	 
 		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
 		INQ_PARAMS["URL_CALLBACK"] = "/MF/EPMF66582641.do";

 		kora.common.goPage('/MF/EPMF6658242.do', INQ_PARAMS);
     }
     
     //목록
  	function fn_page2(){
  		kora.common.goPageB('/MF/EPMF6658201.do', INQ_PARAMS);
     }
    
    //인쇄
 	function fn_pnt(){
    	
 		$('form[name="prtForm"] input[name="DLIVY_DOC_NO"]').val(INQ_PARAMS.PARAMS.DLIVY_DOC_NO);
 		$('form[name="prtForm"] input[name="USER_NM"]').val(INQ_PARAMS.USER_NM);
		
 		kora.common.gfn_viewReport('prtForm', '');
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
			layoutStr.push('	<NumberMaskFormatter id="maskfmt" formatString="###-##-#####"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" horizontalScrollPolicy="on" sortableColumns="true" headerHeight="35">');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridColumn dataField="index"       	headerText="'+ parent.fn_text('sn')+ '" itemRenderer="IndexNoItem" textAlign="center" width="50"  />');	        //순번
			layoutStr.push('			<DataGridColumn dataField="DLIVY_DT"		headerText="'+ parent.fn_text('dlivy_dt')+ '"  textAlign="center" width="150"   formatter="{datefmt2}"/>'); 	//출고일자
			layoutStr.push('			<DataGridColumn dataField="CUST_NM"  		headerText="'+ parent.fn_text('cust_nm')+ '" textAlign="center" width="150" />');								//판매처명
			layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNO"  headerText="'+ parent.fn_text('whsdl_bizrno')+ '" textAlign="center" width="150"  formatter="{maskfmt}"/>');								//판매처명
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM" 		headerText="'+ parent.fn_text('ctnr_nm')+ '" textAlign="center" width="200" />');								//빈용기명
			layoutStr.push('			<DataGridColumn dataField="PRPS_SE"  		headerText="'+ parent.fn_text('prps_cd')+ '" textAlign="center" width="100" />');								//용도(유흥용/가정용)
			layoutStr.push('            <DataGridColumn dataField="STANDARD_NM"     headerText="용기구분"        width="100" textAlign="center"  />');
			layoutStr.push('			<DataGridColumn dataField="CPCT_NM"  		headerText="'+ parent.fn_text('cpct_cd')+'(ml)'+ '" textAlign="center" width="100" />');						//용량(ml)
			layoutStr.push('			<DataGridColumn dataField="DLIVY_QTY" id="num1"  headerText="'+ parent.fn_text('dlivy_qty')+ '" width="90" formatter="{numfmt}" textAlign="right" />');		//출고량(개)
			layoutStr.push('			<DataGridColumnGroup  						headerText="'+ parent.fn_text('cntr')+ parent.fn_text('dps')+'">');																//빈용기보증금(원)																		
			layoutStr.push('				<DataGridColumn dataField="DPS"     	headerText="'+ parent.fn_text('utpc')+ '"  width="80" formatter="{numfmt}" textAlign="right" />');				//단가
			layoutStr.push('				<DataGridColumn dataField="AMT" id="num2"  headerText="'+ parent.fn_text('total')+ '"  width="100" formatter="{numfmt}" textAlign="right" />');			//소계
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumn dataField="DLIVY_SE_NM"  		headerText="'+ parent.fn_text('dlivy_se')+ '" textAlign="center" width="150" />');							//출고구분
			layoutStr.push('			<DataGridColumn dataField="RMK"  			headerText="'+ parent.fn_text('rmk')+ '" textAlign="left" width="150" />');									//비고
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
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	//상자
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	//금액
			layoutStr.push('				<DataGridFooterColumn/>');
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
    	<input type="hidden" id="gridList_list" value="<c:out value='${gridList}' />" />
    	
    
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
				<div class="btn_box" id="UR">
				</div>
			</div>
			   
			<section class="secwrap">
						<div class="write_area">
							<div class="write_tbl">
								<table>
									<colgroup>
										<col style="width: 15%;">
										<col style="width: 30%;">
										<col style="width: 15%;">
										<col style="width: auto;">
									</colgroup>
									<tbody>
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
										<tr>
											<th class="bd_l" id="tel_no"></th> <!-- 연락처-->
											<td>
												<div class="row">
													<div class="txtbox" id="MFC_RPST_TEL_NO"></div>
												</div>
											</td>
											<th class="bd_l"  id="addr"></th><!-- 주소 -->
											<td>
												<div class="row">
													<div class="txtbox"  id=MFC_ADDR></div>
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

		<section class="btnwrap mt20" style="" >
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
	</div>
	
	<form name="prtForm" id="prtForm">
		<input type="hidden" name="CRF_NAME" value="EPCE66582641.crf" />
		<input type="hidden" name="DLIVY_DOC_NO" value="" />
		<input type="hidden" name="USER_NM" value="" />
	</form>
	
	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="excel" />
	</form>

</body>
</html>