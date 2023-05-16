<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>회수정보상세</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script src="/js/kora/paging_common.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<script type="text/javaScript" language="javascript" defer="defer">
  
		var INQ_PARAMS;
		var initList;
		var toDay = kora.common.gfn_toDay();  // 현재 시간
	 	var rowIndexValue =0;
	 	var whsdl_bizrnm_chk;
	 	
	 
     $(function() {
			
			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			initList 		      = jsonObject($("#initList").val());
			//상계처리 데이터가 없으면
    	 	if(initList == null || initList == "") {
    	 		alertMsg("상계처리할 데이터가 없습니다.");
    	 		kora.common.goPage('/CE/EPCE9000901.do', INQ_PARAMS);
    	 	}
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
					item['dataField'] = columns[i].getDataField();
					item['textAlign'] = columns[i].getStyle('textAlign');
					item['id'] = kora.common.null2void(columns[i].id);
					
					col.push(item);
				}
			}
			
			var input = INQ_PARAMS["SEL_PARAMS"];
			input['fileName'] = fileName;
			input['columns'] = JSON.stringify(col);
			input['WHSDL_BIZRNO']=$('#WHSDL_BIZRNO').text();
			input['OFFSET_REG_DT']=$('#OFFSET_REG_DT').text();
			var url = "/CE/EPCE9000902_05.do";
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
     
     //초기화
     function fn_init(){
    		$("#WHSDL_BIZRNM").text(initList[0].BIZRNM);
			$("#WHSDL_BIZRNO").text(initList[0].WHSDL_BIZRNO_DE);
			$("#OFFSET_REG_DT").text(initList[0].OFFSET_REG_DT);
			$('#RTRVL_DT').val(kora.common.formatter.datetime(toDay, "yyyy-mm-dd"));
			flag_DT = $("#RTRVL_DT").val();
			
			//text 셋팅
			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
						
			$('#whsdl').text(parent.fn_text('whsdl'));										  //도매업자
			$('#whsdl_bizrno').text(parent.fn_text('whsdl_bizrno'));					  //도매업자사업자번호
			
			$('#title_sub').text('<c:out value="${titleSub}" />');						   //타이틀
			//div필수값 alt
			$("#WHSDL_BIZRNO").attr('alt',parent.fn_text('whsdl_bizrno'));   	//도매업자사업자번호
			
     }
     
     
		//취소버튼 이전화면으로
		function fn_lst(){
			kora.common.goPageB('/CE/EPCE9000901.do', INQ_PARAMS);
			
		}
		
			/**
		 * 그리드 관련 변수 선언
		 */
	    var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
		var gridApp, gridRoot, dataGrid, layoutStr, selectorColumn;
		var layoutStr = new Array();
		var rowIndex;
    
	
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
			 rMateGridH5.create("grid", "gridHolder", jsVars, "100%", "100%");
			 layoutStr.push('<rMateGrid>');
			 layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			 layoutStr.push('	<NumberMaskFormatter id="maskfmt" formatString="###-##-#####"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			 layoutStr.push('<groupedColumns>');
			 layoutStr.push('	<DataGridSelectorColumn id="selector" allowMultipleSelection="true" headerText="" width="40" verticalAlign="middle" />');
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" width="50"/>');
			 layoutStr.push('	<DataGridColumn dataField="WRHS_CFM_DT"  headerText="'+parent.fn_text('wrhs_cfm_dt')+'" width="100" itemRenderer="HtmlItem" />');
			 layoutStr.push('	<DataGridColumn dataField="AREA_NM"  headerText="'+parent.fn_text('area_nm')+'" width="170" />');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('whsdl')+'" width="170" />');
			 //layoutStr.push('	<DataGridColumn dataField="WHSDL_BIZRNO_DE"  headerText="'+parent.fn_text('whsdl_bizrno')+'" width="170" />');
			 layoutStr.push('	<DataGridColumn dataField="CFM_QTY_TOT" id="sum1" headerText="'+parent.fn_text('wrhs_qty')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="CFM_GTN_TOT" id="sum2" headerText="'+parent.fn_text('dps2')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="CFM_FEE_TOT" id="sum3" headerText="'+parent.fn_text('fee')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="CFM_FEE_STAX_TOT" id="sum4" headerText="'+parent.fn_text('stax')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="CFM_TOT" id="sum5" headerText="'+parent.fn_text('amt')+'" width="120" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="MFC_BIZRNM"  headerText="'+parent.fn_text('mfc_bizrnm')+'" width="150"/>');
			 layoutStr.push('	<DataGridColumn dataField="MFC_BRCH_NM"  headerText="'+parent.fn_text('mfc_brch_nm')+'" width="190"/>');
			 layoutStr.push('	<DataGridColumn dataField="OFFSET_REG_DT"  headerText="상계처리일시" width="40"/>');
			 //layoutStr.push('	<DataGridColumn dataField="BIZRNM"	visible="false" />');
			 //layoutStr.push('	<DataGridColumn dataField="WHSDL_BIZRNO_DE"	visible="false" />');
			 //layoutStr.push('	<DataGridColumn dataField="ACP_DT"	visible="false" />');
			 layoutStr.push('</groupedColumns>');
			 layoutStr.push('	<footers>');
			 layoutStr.push('		<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('			<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"  />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			// layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum3}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum4}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum5}" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('			<DataGridFooterColumn/>');
			 layoutStr.push('		</DataGridFooter>');
			 layoutStr.push('	</footers>');
			 layoutStr.push('</DataGrid>');
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

	<div class="iframe_inner">
		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
		<input type="hidden" id="initList" value="<c:out value='${initList}' />" />
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
			<div class="btn_box">
				<div class="btn" id="UR">
				</div>
			</div>
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
											<div class="txtbox" id="WHSDL_BIZRNM" ></div>
										</div>
									</td>
									<th class="bd_l" id="whsdl_bizrno"></th> <!-- 도매업자 사업자번호 -->
									<td>
										<div class="row">
											<div class="txtbox" id="WHSDL_BIZRNO" ></div>
										</div>
									</td>
									<input type="hidden" id="OFFSET_REG_DT"/>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
		</section>
				<div class="boxarea mt10">
			<div id="gridHolder" style="height: 560px; background: #FFF;"></div>
		</div>	<!-- 그리드 셋팅 -->
			
		<section class="btnwrap mt20" >
			<div class="fl_r" id="BR">
			</div>
		</section>
			</div>
	
	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="excel" />
	</form>
	
</body>
</html>