<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>회수내역 상세정보</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">
  
	 var INQ_PARAMS;	//파라미터 데이터
     var toDay = kora.common.gfn_toDay();  // 현재 시간
	 var rowIndexValue =0;
     var initList;											//도매업자
     var dps_fee_list;									//회수용기 보증금,취급수수료
     var whsdl_bizrnm_chk;
	 
     $(function() {
    	 
    	INQ_PARAMS 				= jsonObject($("#INQ_PARAMS").val());	
    	initList 						= jsonObject($("#initList").val());		
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
		$("#btn_lst").click(function(){
			fn_lst();
		});
	
	});
     
     //초기화
     function fn_init(){
    	 
    	console.log(initList);
    		$("#URM_NM").text(initList[0].URM_NM);
    		$("#SERIAL_NO").text(initList[0].SERIAL_NO);
		
			$('#RTRVL_DT').val(kora.common.formatter.datetime(toDay, "yyyy-mm-dd")); 
			flag_DT = $("#RTRVL_DT").val(); 
			 
			//text 셋팅
			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			
			$('#urmnm').text('소매점명');										  //도매업자
			$('#serialno').text('시리얼번호');					  //도매업자사업자번호
			
			$('#title_sub').text('<c:out value="${titleSub}" />');						   //타이틀
     }
       
   
     
	  //취소버튼 이전화면으로
    function fn_lst(){
   	 kora.common.goPageB('/CE/EPCE9000601.do', INQ_PARAMS);
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
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" horizontalScrollPolicy="on" sortableColumns="true"   headerHeight="35">');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridColumn dataField="index" 				 	headerText="'+ parent.fn_text('sn')+ '"						width="50" 	textAlign="center" 	  itemRenderer="IndexNoItem" />');			//순번
			layoutStr.push('			<DataGridColumn dataField="RTRVL_DT"			 	headerText="회수일자"  			width="120"  	textAlign="center"  	/>'); 													//회수일자
			layoutStr.push('			<DataGridColumn dataField="URM_NM" headerText="소매점명"   		width="150"  	textAlign="center"	/>');														//도매업자 지점
			layoutStr.push('			<DataGridColumn dataField="SERIAL_NO" 	 	headerText="시리얼번호"   	width="150"  	textAlign="center"	/>');														//회수처
			layoutStr.push('			<DataGridColumn dataField="PRPS_NM" 			headerText="'+ parent.fn_text('prps_cd')+ '" 				width="100"  	textAlign="center"  	/>');														//용도
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM"  		 	headerText="'+ parent.fn_text('cpct')+ '" 					width="200" 	textAlign="center" 	 />');													//용량
			layoutStr.push('			<DataGridColumn dataField="URM_QTY"  		 	headerText="'+ parent.fn_text('rtrvl_qty')+'" 				width="120" 	textAlign="right" 		 formatter="{numfmt}" id="num1"  />');		//회수량
			layoutStr.push('			<DataGridColumn dataField="URM_GTN" 	 		headerText="'+ parent.fn_text('rtrvl_dps')+ '" 			width="120"  	textAlign="right"  	 formatter="{numfmt}" id="num2" />');		//회수보증금
			layoutStr.push('			<DataGridColumn dataField="RTRVL_RTL_FEE" 	headerText="'+ parent.fn_text('rtrvl_fee')+ '"				width="120"  	textAlign="right"  	 formatter="{numfmt}" id="num3" />');		//회수수수료
			layoutStr.push('			<DataGridColumn dataField="AMT_TOT"   			headerText="'+ parent.fn_text('total')+ '" 					width="120"	textAlign="right" 		 formatter="{numfmt}" id="num4"  />');		//소계
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="합계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			//layoutStr.push('				<DataGridFooterColumn/>');
			//layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	//회수량
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	//회수보증금
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	//회수수수료
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');	//소계
			
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
				<!--btn_excel  -->
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
									<th class="bd_l" id="urmnm"></th> <!-- 소매점명 -->		
									<td>
										<div class="row">
											<div class="txtbox" id="URM_NM"></div>
										</div>
									</td>
									<th class="bd_l" id="serialno"></th> <!-- 시리얼번호 -->
									<td>
										<div class="row">
											<div class="txtbox" id="SERIAL_NO"></div>
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

</body>
</html>