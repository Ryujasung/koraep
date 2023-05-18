<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script src="/js/kora/paging_common.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<script type="text/javaScript" language="javascript" defer="defer">
			
		var INQ_PARAMS;
		var stdMgntList;
		var excaSeList;
		var excaProcStatList;
		var bizrTpList;
		
		$(function() {

			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			stdMgntList = jsonObject($('#stdMgntList').val());
			excaSeList = jsonObject($('#excaSeList').val());
			excaProcStatList = jsonObject($('#excaProcStatList').val());
			bizrTpList = jsonObject($('#bizrTpList').val());
			
			//버튼 셋팅
			fn_btnSetting();
						
			$('.tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			
			kora.common.setEtcCmBx2(stdMgntList, "","", $("#EXCA_STD_CD_SEL"), "EXCA_STD_CD", "EXCA_STD_NM", "N" ,'T');
			for(var k=0; k<stdMgntList.length; k++){ 
		    	if(stdMgntList[k].EXCA_STAT_CD == 'T'){
		    		$('#EXCA_STD_CD_SEL').val(stdMgntList[k].EXCA_STD_CD);
		    		break;
		    	}
		    }
			
			
			//교환정산기간 추가
	        $("#EXCA_STD_CD_SEL").append("<option value='C'>교환정산</option>");
	        $("#EXCA_STD_CD_SEL").append("<option value='M'>수기정산</option>");
	        
			kora.common.setEtcCmBx2(bizrTpList, "","", $("#BIZR_TP_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N" ,'T');
		    kora.common.setEtcCmBx2(excaSeList, "","", $("#EXCA_SE_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N" ,'T');
		    kora.common.setEtcCmBx2(excaProcStatList, "","", $("#EXCA_PROC_STAT_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N" ,'T');
		    
		  //파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
			}
		    
			//그리드 셋팅
			fn_set_grid();

			//정산서발급취소
			$("#btn_upd").click(function(){
				fn_upd();
			});
			
			/************************************
			 * 조회 클릭 이벤트
			 ***********************************/
			$("#btn_sel").click(function(){
				//조회버튼 클릭시 페이징 초기화
				gridCurrentPage = 1;
				fn_sel();
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
					
 					if(columns[i].getDataField() == 'EXCA_REG_DT_PAGE'){// html 태그 사용중 컬럼은 대체
						item['dataField'] = 'EXCA_REG_DT';
					}else if(columns[i].getDataField() == 'EXCA_PROC_STAT_NM'){// html 태그 사용중 컬럼은 대체
						item['dataField'] = 'EXCA_PROC_STAT_NM';
					}else{ 
						item['dataField'] = columns[i].getDataField();
					}
					
					item['textAlign'] = columns[i].getStyle('textAlign');
					item['id'] = kora.common.null2void(columns[i].id);
					
					col.push(item);
				}
			}
			
			var input = INQ_PARAMS["SEL_PARAMS"];
			input['fileName'] = fileName;
			input['columns'] = JSON.stringify(col);
			
			var url = "/CE/EPCE9000901_05.do";
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
		
		
		/**
		 * 목록 조회
		 */
		function fn_sel(){
			
			var input = {};
			input["EXCA_STD_CD_SEL"] = $("#EXCA_STD_CD_SEL").val();
			input["BIZRNM_SEL"] = $("#BIZRNM_SEL").val();
			input["EXCA_PROC_STAT_CD_SEL"] = $("#EXCA_PROC_STAT_CD_SEL").val();
			

			INQ_PARAMS["SEL_PARAMS"] = input;
			
			var url = "/CE/EPCE9000901_19.do";
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.searchList);
				} 
				else {
					alertMsg("error");
				}
				kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
			});
			
		}
		
	    /* 페이징 이동 스크립트 */
		function gridMovePage(goPage) {
			gridCurrentPage = goPage; //선택 페이지
			fn_sel(); //조회 펑션
		}
		
		//상세화면 이동
		function fn_page(){
			var idx = dataGrid.getSelectedIndices();
			var input = gridRoot.getItemAt(idx);
			
				//파라미터에 조회조건값 저장 
				INQ_PARAMS["PARAMS"] = {};
				INQ_PARAMS["PARAMS"] = input;
				INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
				INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE9000901.do";
				kora.common.goPage('/CE/EPCE9000902.do', INQ_PARAMS);
			//}		
			
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
			 layoutStr.push(' <NumberMaskFormatter id="dateFmt" formatString="####-##-##"/>');
			 layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			 layoutStr.push('	<NumberMaskFormatter id="maskfmt" formatString="###-##-#####"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true"  textAlign="center" 	draggableColumns="true" sortableColumns="true" > ');
			 layoutStr.push('<groupedColumns>');
			 layoutStr.push('	<DataGridColumn dataField="index" headerText="'+parent.fn_text('sn')+'" itemRenderer="IndexNoItem" textAlign="center" width="50" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCA_REG_DT_PAGE"  headerText="'+parent.fn_text('issu_dt')+'" width="90" itemRenderer="HtmlItem" />');
			 layoutStr.push('	<DataGridColumn dataField="BIZR_TP_NM"  headerText="'+parent.fn_text('bizr_se')+'" width="100" />');
			 layoutStr.push('	<DataGridColumn dataField="BIZRNM"  headerText="'+parent.fn_text('bizr_nm')+'" width="200" />');
			 layoutStr.push('	<DataGridColumn dataField="WHSDL_BIZRNO"  headerText="사업자번호" width="120" formatter="{maskfmt}"/>');
			 layoutStr.push('	<DataGridColumn dataField="BANK_NM"  headerText="'+parent.fn_text('bank')+'" width="100" />');
			 layoutStr.push('	<DataGridColumn dataField="ACCT_NO"  headerText="'+parent.fn_text('vacct_no')+'" width="140" />');
			 //layoutStr.push('	<DataGridColumn dataField="REAL_PAY_DT" headerText="'+parent.fn_text('real_pay_dt')+'" width="140" formatter="{dateFmt}"/>');
			 layoutStr.push('	<DataGridColumn dataField="ACP_DT" headerText="'+parent.fn_text('acp_dt2')+'" width="110" formatter="{dateFmt}" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCA_AMT" id="num1"  headerText="'+parent.fn_text('exca_amt')+'" width="120" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCA_ISSU_SE_NM" headerText="'+parent.fn_text('exca_issu_se')+'" width="100" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCA_SE_NM" headerText="'+parent.fn_text('exca_se')+'" width="100" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCA_PROC_STAT_NM" headerText="'+parent.fn_text('stat')+'" width="100" itemRenderer="HtmlItem" />');
             layoutStr.push('   <DataGridColumn dataField="STD_YEAR" headerText="'+parent.fn_text('std_year')+'" width="80" />');
             layoutStr.push('   <DataGridColumn dataField="YEAR_CHG_YN" headerText="'+parent.fn_text('year_chg_exca_yn')+'" width="80" />');
			 layoutStr.push('</groupedColumns>');
			 layoutStr.push('<footers>');
			 layoutStr.push('	<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('		<DataGridFooterColumn label="'+parent.fn_text('sum')+'" textAlign="center"/>');
			 layoutStr.push('		<DataGridFooterColumn/>');
			 layoutStr.push('		<DataGridFooterColumn/>');
			 layoutStr.push('		<DataGridFooterColumn/>');
			 layoutStr.push('		<DataGridFooterColumn/>');
			 layoutStr.push('		<DataGridFooterColumn/>');
			 layoutStr.push('		<DataGridFooterColumn/>');
			 layoutStr.push('		<DataGridFooterColumn/>');
			 layoutStr.push('		<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('		<DataGridFooterColumn/>');
			 layoutStr.push('		<DataGridFooterColumn/>');
			 layoutStr.push('		<DataGridFooterColumn/>');
             layoutStr.push('       <DataGridFooterColumn/>');
             layoutStr.push('       <DataGridFooterColumn/>');
			 layoutStr.push('	</DataGridFooter>');
			 layoutStr.push('</footers>');
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
		    	 
		    	 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
				 	/* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
				 	 window[INQ_PARAMS.FN_CALLBACK]();
				 	//취약점점검 5960 기원우
				 }else{
					 gridApp.setData();
				 }
		    }
		    var dataCompleteHandler = function(event) {
		    }
		    
		    gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		    gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);

		 }

	</script>

	<style type="text/css">
		.row .tit{width: 77px;}
	</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="stdMgntList" value="<c:out value='${stdMgntList}' />"/>
<input type="hidden" id="excaSeList" value="<c:out value='${excaSeList}' />"/>
<input type="hidden" id="excaProcStatList" value="<c:out value='${excaProcStatList}' />"/>
<input type="hidden" id="bizrTpList" value="<c:out value='${bizrTpList}' />"/>

	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="singleRow">
				<div class="btn" id="UR"></div>
			</div>
		</div>

		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">
					<div class="col">
						<div class="tit" id="exca_term_txt"></div>
						<div class="box">
							<select id="EXCA_STD_CD_SEL" name="EXCA_STD_CD_SEL" style="width: 179px" ></select>
						</div>
					</div>
					
					<div class="col">
						<div class="tit" id="bizr_nm_txt"></div>
						<div class="box">
							<input id="BIZRNM_SEL" name="BIZRNM_SEL" type="text" style="width: 179px;"  alt="" >
						</div>
					</div>
					
					<div class="col">
						<div class="tit" id="stat_txt"></div>
						<div class="box">
							<select id="EXCA_PROC_STAT_CD_SEL" name="EXCA_PROC_STAT_CD_SEL" style="width: 179px" ></select>
						</div>
					</div>
					
					<div class="btn" id="CR"></div>
				</div>
			</div>
		</section>
		
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:600px;"></div>
			</div>
		</section>
		<section class="btnwrap mt20" >
			<div class="btn" id="BL">
			</div>
			<div class="btn" style="float:right" id="BR">
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
