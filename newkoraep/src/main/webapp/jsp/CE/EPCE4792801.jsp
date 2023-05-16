<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
	
		var INQ_PARAMS;//파라미터 데이터
		
		$(document).ready(function(){
			
			INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
			var excaStdMgnt =jsonObject($("#excaStdMgnt").val());	
			var mfcBizrList = jsonObject($('#mfcBizrList').val());
			
			fn_btnSetting();
			
			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});

			$('#EXCA_TERM').text(kora.common.setDelim(excaStdMgnt.EXCA_ST_DT,'9999-99-99') +" ~ "+ kora.common.setDelim(excaStdMgnt.EXCA_END_DT,'9999-99-99'));
			
			kora.common.setEtcCmBx2(mfcBizrList, "", "", $("#MFC_BIZR_SEL"), "BIZRID_NO", "BIZRNM", "N", "S");
			if( kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				$("#MFC_BIZR_SEL").val(INQ_PARAMS.SEL_PARAMS.MFC_BIZR_SEL);
			}
			
			//그리드 셋팅
			fn_set_grid();
			
			$("#btn_sel").click(function(){
				fn_sel();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});

		});
		
		var fn_reg_stat = '0';
		function fn_reg(){
			
			if(fn_reg_stat == '1'){
				return;
			}
			
			var collection = gridRoot.getCollection();
			
			if(collection.getLength() < 1){
				alertMsg("정산서발급 내역이 없습니다.");
				return;
			}

			confirm("도매업자 정산서 발급을 진행하시겠습니까?", "fn_reg_exec");
		}
		
		function fn_reg_exec(){
			
			fn_reg_stat = '1';
			
			var collection = gridRoot.getCollection();
			var data = {};
			/*
			var row  = new Array();
			for(var i=0; i<collection.getLength(); i++){
				var item = {};
				item = gridRoot.getItemAt(i);
				row.push(item);
			}
			*/
			
			var url  = "/CE/EPCE4792801_09.do";
			//data["list"] = JSON.stringify(row);
			data["MFC_BIZR_SEL"] = $("#MFC_BIZR_SEL").val();
			
			document.body.style.cursor = "wait";
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					if(rtnData.RSLT_CD =="0000"){
						alertMsg(rtnData.RSLT_MSG, 'fn_sel');
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
				} else {
					alertMsg("error");
				}
				document.body.style.cursor = "default";
				kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
				fn_reg_stat = '0';
			});
			
		}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){

			if(fn_reg_stat == '1'){
				return;
			}
			
			if($('#MFC_BIZR_SEL').val() == '' ){
				alertMsg('생산자를 선택하세요.');
				return;
			}
			
			var url = "/CE/EPCE4792801_19.do";
			var input = {};
			input["MFC_BIZR_SEL"] = $("#MFC_BIZR_SEL").val();
			
			INQ_PARAMS["SEL_PARAMS"] = input;
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.searchList);
				} else {
					alertMsg("error");
				}
				kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
			});
			
		}
		
		//도매업자정산내역 상세화면 이동
		function fn_page(){

			var idx = dataGrid.getSelectedIndices();
			var input = gridRoot.getItemAt(idx);
			
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE4792801.do"; 
			kora.common.goPage('/CE/EPCE4792864.do', INQ_PARAMS);
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
			 layoutStr.push('	<NumberMaskFormatter id="maskfmt" formatString="###-##-#####"/>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" horizontalScrollPolicy="auto" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center" >');
			 layoutStr.push('	<groupedColumns>');   
			 layoutStr.push('	<DataGridColumn dataField="WHSDL_BIZRNM_PAGE"  headerText="'+parent.fn_text('whsdl')+'" width="300" itemRenderer="HtmlItem" />');
			 layoutStr.push('	<DataGridColumn dataField="WHSDL_BIZRNO_DE" headerText="'+parent.fn_text('bizrno')+'" width="150" formatter="{maskfmt}" />');
			 layoutStr.push('	<DataGridColumn dataField="GTN" id="sum1" headerText="'+parent.fn_text('gtn')+'" width="150" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="FEE" id="sum2" headerText="'+parent.fn_text('fee')+'" width="150" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="FEE_STAX" id="sum3" headerText="'+parent.fn_text('stax')+'" width="150" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	<DataGridColumn dataField="EXCA_AMT" id="sum4" headerText="'+parent.fn_text('amt')+'" width="150" formatter="{numfmt}" textAlign="right" />');
			 layoutStr.push('	</groupedColumns>');
			 layoutStr.push('		<footers>');
			 layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			 layoutStr.push('				<DataGridFooterColumn/>');
			 layoutStr.push('				<DataGridFooterColumn/>');
			 layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum3}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum4}" formatter="{numfmt}" textAlign="right"/>');	
			 layoutStr.push('			</DataGridFooter>');
			 layoutStr.push('		</footers>');
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
		         
		       	 //파라미터 call back function 실행
				 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
				 	eval(INQ_PARAMS.FN_CALLBACK+"()");
				 }else{
					 gridApp.setData();
				 }
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
		.row .tit{width: 67px;}
	</style>
</head>
<body>
	<div class="iframe_inner">
		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
		<input type="hidden" id="excaStdMgnt" value="<c:out value='${excaStdMgnt}' />" />
		<input type="hidden" id="mfcBizrList" value="<c:out value='${mfcBizrList}' />"/>
		
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn_box">
			</div>
		</div>
		
		<section class="secwrap">
			<div class="srcharea" id="sel_params">
				<div class="row">
					<div class="col">
						<div class="tit" id="exca_term_txt"></div>
						<div class="box" style="line-height:36px;" id="EXCA_TERM"></div>
					</div>
					<div class="col">
						<div class="tit" id="mfc_bizrnm_txt"></div>
						<div class="box">
							<select id="MFC_BIZR_SEL" name="MFC_BIZR_SEL" style="width: 179px" class="i_notnull"></select>
						</div>
					</div>
					<div class="btn" id="CR"></div>
				</div>
			</div>
		</section>
		
		<section class="secwrap mt10">
			<div class="boxarea">
				<div id="gridHolder" style="height:430px;"></div>
			</div>
		</section>
	
		<section class="btnwrap mt20" >
			<div class="fl_l" id="BL">
			</div>
			<div class="fl_r" id="BR">
			</div>
		</section>
		
	</div>
	
</body>
</html>
