<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>반환정보상세조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">
  
	 var INQ_PARAMS;	//파라미터 데이터
     var toDay = kora.common.gfn_toDay();  // 현재 시간
     var initList;											//도매업자
	 
     $(function() {
    	 
    	INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());	
    	initList = jsonObject($("#initList").val());		
    	 //초기 셋팅
    	fn_init();
    	 
    	//버튼 셋팅
    	fn_btnSetting();
    	 
    	//그리드 셋팅
		fnSetGrid1();
		 
		//날짜 셋팅
  	    $('#RTRVL_DT').YJcalendar({  
 			triggerBtn : true,
 			dateSetting: toDay.replaceAll('-','')
 		});
		
		/************************************
		 * 목록버튼 클릭 이벤트
		 ***********************************/
		$("#btn_cnl").click(function(){
			fn_lst();
		});
	
		/************************************
		 * 인쇄 클릭 이벤트
		 ***********************************/
		$("#btn_pnt").click(function(){
			kora.common.gfn_viewReport('prtForm', '');
		});
		
	});
     
     //초기화
     function fn_init(){
    	 
    		$("#WHSDL_BIZRNM").text(initList[0].WHSDL_BIZRNM);
    		$("#WHSDL_BIZRNO").text(kora.common.setDelim(initList[0].WHSDL_BIZRNO, "999-99-99999"));
			$('#RTRVL_DT').val(kora.common.formatter.datetime(toDay, "yyyy-mm-dd")); 
			$('#whsdl').text(parent.fn_text('whsdl'));										  //도매업자
			$('#whsdl_bizrno').text(parent.fn_text('whsdl_bizrno'));					  //도매업자사업자번호
			$('#title_sub').text('<c:out value="${titleSub}" />');						   //타이틀
			$("#prtForm").find("#RTRVL_DOC_NO").val(INQ_PARAMS.PARAMS.RTRVL_DOC_NO);
     }
     
	 //취소버튼 이전화면으로
    function fn_lst(){
   	 kora.common.goPageB('/RT/EPRT9025801.do', INQ_PARAMS);
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
			layoutStr.push('	<NumberMaskFormatter id="maskfmt1" formatString="###-##-#####"/>');
			layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" sortableColumns="true"   headerHeight="35">');
			layoutStr.push('		<groupedColumns>'); 
			layoutStr.push('			<DataGridColumn dataField="index" 				 	headerText="'+ parent.fn_text('sn')+ '"				width="5%" 	textAlign="center" 	  itemRenderer="IndexNoItem" />');			//순번
			layoutStr.push('			<DataGridColumn dataField="RTRVL_DT"			 	headerText="'+ parent.fn_text('rtn_reg_dt')+ '"  	width="15%"  	textAlign="center"  	/>'); 													//회수일자
			layoutStr.push('			<DataGridColumn dataField="PRPS_NM" 			headerText="'+ parent.fn_text('prps_cd')+ '"		width="10%"  	textAlign="center"  	/>');														//용도
			layoutStr.push('			<DataGridColumn dataField="CPCT_NM"  		 	headerText="'+ parent.fn_text('cpct')+ '" 			width="20%" 	textAlign="center" 	 />');													//용량
			layoutStr.push('			<DataGridColumn dataField="RTRVL_QTY"  		 	headerText="'+ parent.fn_text('rtn_qty2')+'" 		width="10%" 	textAlign="right" 		 formatter="{numfmt}" id="num1"  />');		//회수량
			layoutStr.push('			<DataGridColumn dataField="RTRVL_GTN" 	 		headerText="'+ parent.fn_text('dps2')+ '" 	width="10%"  	textAlign="right"  	 formatter="{numfmt}" id="num2" />');		//회수보증금
			layoutStr.push('			<DataGridColumn dataField="REG_RTRVL_FEE" 	headerText="'+ parent.fn_text('rtl_fee2')+ '"		width="10%"  	textAlign="right"  	 formatter="{numfmt}" id="num3" />');		//회수수수료
			layoutStr.push('			<DataGridColumn dataField="AMT_TOT"   			headerText="'+ parent.fn_text('sum')+ '" 			width="10%"	textAlign="right" 		 formatter="{numfmt}" id="num4"  />');		//소계
			layoutStr.push('			<DataGridColumn dataField="RMK" 					headerText="'+ parent.fn_text('rmk')+ '"			width="10%"	textAlign="center" 	   />');													//비고
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="합계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	//회수량
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	//회수보증금
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	//회수수수료
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');	//소계
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
		gridApp.setData(initList);
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
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	}

	/**
	 * 그리드 loading bar on
	 */
	function showLoadingBar() {
		if (dataGrid != null && dataGrid != "undefined") {
			dataGrid.setEnabled(false);
			gridRoot.addLoadingBar();
		}
	}

	/**
	 * 그리드 loading bar off
	 */
	function hideLoadingBar() {
		if (dataGrid != null && dataGrid != "undefined") {
			dataGrid.setEnabled(true);
			gridRoot.removeLoadingBar();
		}
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
    <div class="iframe_inner"  >
			<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="initList" value="<c:out value='${initList}' />" />
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
				<div class="singleRow">
				<div class="btn" id="UR"></div>
				</div>
				<!--btn_dwnd  -->
				<!--btn_pnt  -->
			</div>
			<section class="secwrap">
				 <div class="write_area">
						<div class="write_tbl">
							<table>
								<colgroup>
									<col style="width: 15%;">
								<col style="width: 20%;">
								<col style="width: 15%;">
								<col style="width: auto;">
							</colgroup>
							<tbody>
								<tr>
									<th class="bd_l" id="whsdl"></th> <!-- 도매업자업체명 -->		
									<td>
										<div class="row">
											<div class="txtbox" id="WHSDL_BIZRNM"></div>
										</div>
									</td>
									<th class="bd_l" id="whsdl_bizrno"></th> <!-- 도매업자 사업자번호 -->
									<td>
										<div class="row">
											<div class="txtbox" id="WHSDL_BIZRNO"></div>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
		</section>
		
		<div class="boxarea mt10">
			<div id="gridHolder" style="height: 560px; background: #FFF;"></div>
		</div>	<!-- 그리드 셋팅 -->
		<section class="btnwrap mt10" >
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
</div>
<form name="prtForm" id="prtForm">
	<input type="hidden" name="CRF_NAME" value="EPRT9025864.crf" />	<!-- 필수 -->
	<input type="hidden" name="RTRVL_DOC_NO" id="RTRVL_DOC_NO"  />
	<input type="hidden" name="S_USER_NM" id="S_USER_NM" value="${ssUserNm}"/>
	<input type="hidden" name="S_BIZR_NM" id="S_BIZR_NM" value="${ssBizrNm}"/>
</form>
</body>
</html>