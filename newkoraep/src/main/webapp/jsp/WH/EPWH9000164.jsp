<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>회수정보상세</title>
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
		 * 회수조정 클릭 이벤트
		 ***********************************/
		$("#btn_page").click(function(){
			fn_page();
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
    	 
    	 
    		$("#WHSDL_BIZRNM").text(initList[0].WHSDL_BIZRNM);
    		$("#RTL_CUST_BIZRNM").text(initList[0].REG_CUST_NM);
    		$("#WHSDL_BIZRNO").text(kora.common.setDelim(initList[0].WHSDL_BIZRNO, "999-99-99999"));
    		$("#RTL_CUST_BIZRNO").text(kora.common.setDelim(initList[0].RTL_CUST_BIZRNO, "999-99-99999"));
		
			$('#RTRVL_DT').val(kora.common.formatter.datetime(toDay, "yyyy-mm-dd")); 
			flag_DT = $("#RTRVL_DT").val(); 
			 
			//text 셋팅
			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			
			$('#whsdl').text(parent.fn_text('whsdl'));										  //도매업자
			$('#whsdl_bizrno').text(parent.fn_text('whsdl_bizrno'));					  //도매업자사업자번호
			$('#reg_cust_nm').text(parent.fn_text('reg_cust_nm'));					  //회수처명
			$('#reg_cust_bizrno').text(parent.fn_text('reg_cust_bizrno'));			  //회수처 사업자번호
			
			$('#title_sub').text('<c:out value="${titleSub}" />');						   //타이틀
			//div필수값 alt
			$("#RTRVL_DT").attr('alt',parent.fn_text('rtrvl_dt2'));   						//회수일자
			$("#RTRVL_QTY").attr('alt',parent.fn_text('rtrvl_qty2'));   					//회수량
			$("#REG_RTRVL_FEE").attr('alt',parent.fn_text('rtl_fee2'));   					//소매수수료
			$("#RTL_CUST_BIZRNM").attr('alt',parent.fn_text('reg_cust_nm'));   		//회수처
			$("#RTL_CUST_BIZRNO").attr('alt',parent.fn_text('reg_cust_bizrno'));   	//회수처사업자번호
			$("#RTRVL_CTNR_CD").attr('alt',parent.fn_text('ctnr_nm2'));   			//회수용기
			$("#WHSDL_BRCH_NM").attr('alt',parent.fn_text('brch'));   				//도매업자 지점
     }
       
     //회수조정
     function fn_page(){
    	 
     	 if(initList[0].RTRVL_STAT_CD !="RG" && initList[0].RTRVL_STAT_CD !="WG" 
    		&& initList[0].RTRVL_STAT_CD !="RJ" && initList[0].RTRVL_STAT_CD !="WJ"  ){
    		 alertMsg("조정이 불가능한 상태의 내역입니다. \n\n 다시 한 번 확인하시기 바랍니다");
    		 return;
    	 }    
    	 
    	var input 	={}
    	 
    	input["WHSDL_BIZRID"]					= initList[0].WHSDL_BIZRID; 	//도매업자아이디 지사때문에
    	input["WHSDL_BIZRNO"]				= initList[0].WHSDL_BIZRNO; //도매업자사업자번호 	지사때문에
    	input["RTRVL_DOC_NO"]				= initList[0].RTRVL_DOC_NO; //문서번호 
    	INQ_PARAMS["PARAMS"] 				= {}
 		INQ_PARAMS["PARAMS"]				= input;
 		INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH2925801.do";
 		
 		kora.common.goPage('/WH/EPWH29258422.do', INQ_PARAMS);
    	 
     }
     
	  //취소버튼 이전화면으로
    function fn_lst(){
   	 kora.common.goPageB('/WH/EPWH9000101.do', INQ_PARAMS);
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
			layoutStr.push('			<DataGridColumn dataField="RTRVL_DT"			 	headerText="출고회수일자"  			width="120"  	textAlign="center"  	/>'); 													//회수일자
			layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNM" headerText="소매업체명"   		width="150"  	textAlign="center"	/>');														//도매업자 지점
			layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNO" 	 	headerText="소매업체사업자번호"   	width="150"  	textAlign="center" formatter="{maskfmt1}"	/>');														//회수처
			//layoutStr.push('			<DataGridColumn dataField="ETC_CD_NM" 			headerText="P_BOX상태코드" 				width="200"  	textAlign="center"  	/>');														//용도
			//layoutStr.push('			<DataGridColumn dataField="RTRVL_CTNR_CD"  		 	headerText="회수용기코드" 				width="120" 	textAlign="right" 		   />');		//회수량
			layoutStr.push('			<DataGridColumn dataField="DLIVY_QTY" headerText="출고량"  width="150"  	textAlign="center"	formatter="{numfmt}" id="num1" />');					//회수처 사업자번호
			layoutStr.push('			<DataGridColumn dataField="DLIVY_GTN" 	 		headerText="출고량보증금" 			width="120"  	textAlign="right"  	 formatter="{numfmt}" id="num2" />');		//회수보증금
			layoutStr.push('			<DataGridColumn dataField="RTN_QTY"  		 	headerText="회수량" 					width="100" 	textAlign="center" 	formatter="{numfmt}" id="num3" />');													//용량
			layoutStr.push('			<DataGridColumn dataField="RTN_GTN" 	headerText="회수량보증금"				width="120"  	textAlign="right"  	 formatter="{numfmt}" id="num4" />');		//회수수수료
			layoutStr.push('			<DataGridColumn dataField="SYS_SE"  	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="RTRVL_CTNR_CD"	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="RTRVL_RTL_FEE"		visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRID"		visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRNO"	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BRCH_ID"	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BRCH_NO"	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="RTL_CUST_BIZRID"		visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="RTL_CUST_BRCH_ID"	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="RTL_CUST_BRCH_NO"	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="RTRVL_DOC_NO"		visible="false" />');
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
								<!-- <tr>
									<th class="bd_l" id="reg_cust_nm"></th> 회수처
									<td>
										<div class="row">
											<div class="txtbox" id="RTL_CUST_BIZRNM"></div>
										</div>
									</td>
									<th class="bd_l"  id="reg_cust_bizrno"></th>회수처 사업자번호
									<td>
										<div class="row">
											<div class="txtbox"  id=RTL_CUST_BIZRNO></div>
										</div>
									</td>
								</tr> -->
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