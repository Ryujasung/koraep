<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>입금내역조회</title>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=1100, user-scalable=yes">
<meta name="description" content="사이트설명">
<meta name="keywords" content="사이트검색키워드">
<meta name="author" content="Newriver">
<meta property="og:title" content="공유제목">
<meta property="og:description" content="공유설명">
<meta property="og:image" content="공유이미지 800x400">

<%@include file="/jsp/include/common_page_m.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
		
		var INQ_PARAMS;
	
		$(document).ready(function(){
			
			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			var whsdlSeCdList = jsonObject($('#whsdlSeCdList').val());

			var statList = jsonObject($('#statList').val());
			
			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
				
			/*모바일용 날짜셋팅*/
			$('#START_DT_SEL').YJdatepicker({
				periodTo : '#END_DT_SEL'
				,initDate : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
			});
			$('#END_DT_SEL').YJdatepicker({
				periodFrom : '#START_DT_SEL'
				,initDate : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
			});
			
			kora.common.setEtcCmBx2(statList, "", "", $("#STAT_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			
			$('#title_sub').text('<c:out value="${titleSub}" />');						  									//타이틀
			
			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
			}
			if(kora.common.null2void(INQ_PARAMS.URL_CALLBACK) == ""){
				$('.btn_manage button').click();
			}

			//그리드 셋팅
			fn_set_grid();
			
			$("#btn_sel").click(function(){
				fn_sel();
			});
			
			$("#btn_page").click(function(){
				fn_page2();
			});
			
			 /************************************
			 * 도매업자 구분 변경 이벤트
			 ***********************************/
			$("#WHSDL_SE_CD_SEL").change(function(){
				fn_whsl_se_cd();
			});
		});
		
		function fn_page(){
			var idx = dataGrid.getSelectedIndices();
			var input = gridRoot.getItemAt(idx)
			
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/RT/EPRT9071301.do";
			kora.common.goPage('/RT/EPRT9071364.do', INQ_PARAMS);
		}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){
			var url = "/RT/EPRT9071301_19.do";
			var input = {};
			
			input['START_DT_SEL'] = $("#START_DT_SEL").val();
			input['END_DT_SEL'] = $("#END_DT_SEL").val();
			input['STAT_CD_SEL'] = $("#STAT_CD_SEL option:selected").val();
			input['WHSDL_SE_CD_SEL'] = '';
			input['WHSDL_BIZR_SEL'] = '';
	
			//파라미터에 조회조건값 저장 
			INQ_PARAMS["SEL_PARAMS"] = input; 
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.searchList);
				} else {
					alert("error");
				}
				kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
				if(kora.common.null2void(INQ_PARAMS.URL_CALLBACK) == ""){
					$('.btn_manage button').click();
				}else{
					INQ_PARAMS["URL_CALLBACK"] = "";					
				}
			});
			
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
			 layoutStr.push(' <NumberMaskFormatter id="dateFmt" formatString="####-##-##"/>');
			 layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" rowHeight="90" fontSize="30" autoHeight="true" minHeight="520" textAlign="center" >');
			 layoutStr.push('<groupedColumns>');
			 layoutStr.push('	<DataGridColumn dataField="PAY_REG_DT_PAGE" headerText="'+parent.fn_text('reg_dt2')+'" width="100" itemRenderer="HtmlItem" />');
			 layoutStr.push('	<DataGridColumn dataField="PAY_AMT" id="sum4" headerText="'+parent.fn_text('pay_amt')+'" width="100" formatter="{numfmt}" textAlign="right"/>');
			 layoutStr.push('	<DataGridColumn dataField="PAY_STAT_NM"  headerText="'+parent.fn_text('stat')+'" width="100"/>');
			 layoutStr.push('</groupedColumns>');
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
				fn_page();
			 }
		     var dataCompleteHandler = function(event) {
		    	 setSpanAttributes();
		 	 }
		     
		     gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		     gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		 }
		
		
		 function setSpanAttributes() {
			 var collection; //그리드 데이터 객체
		     if (collection == null)
		         collection = gridRoot.getCollection();
		     if (collection == null) {
		         alert("collection 객체를 찾을 수 없습니다");
		         return;
		     }
		  		     
		     for (var i = 0; i < collection.getLength(); i++) {
		     	var data = gridRoot.getItemAt(i);
		     	console.log(data.PAY_STAT_CD);
		     	/* if(data.PAY_STAT_CD == "P"){
		 	        collection.addRowAttributeDetailAt(i, null, "#FFCC00", null, false, 20);
		     	} */
		     }
		 }
		
	</script>

	<style type="text/css">
	</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
<input type="hidden" id="statList" value="<c:out value='${statList}' />"/>
		
	<div id="wrap">
	
		<%@include file="/jsp/include/header_m.jsp" %>
		
		<%@include file="/jsp/include/aside_m.jsp" %>

		<div id="container">

			<div id="subvisual">
				<h2 class="tit" id="title_sub"></h2>
			</div><!-- id : subvisual -->

			<div id="contents">
				<div class="btn_manage">
					<button type="button" id="btn_manage"></button>
				</div>
				<div class="manage_wrap" id="sel_params">
					<div class="contbox">
						<div class="boxed">
							<input type="text" id="START_DT_SEL" style="width: 285px;" readonly>
							<span class="swung">~</span>
							<input type="text" id="END_DT_SEL" style="width: 285px;" readonly>
						</div>
					</div>
					<div class="contbox v2">
						<div class="boxed">
							<div class="sort">상태</div>
							<select style="width: 435px;" id="STAT_CD_SEL"></select>
						</div>
						<div class="btn_wrap line">
							<div class="fl_c">
								<button class="btn70 c1" style="width: 220px;" id="btn_sel">조회</button>
							</div>
						</div>
					</div>
				</div>
				<div class="tblbox">
					<div class="tbl_inquiry v2">
						<div id="gridHolder"></div> <!-- 그리드 -->
					</div>
					<!-- <div class="btn_wrap" style="height:50px">
						<button class="btnCircle c1" id="btn_page">등록</button>
					</div> -->
					<!-- <div class="pagination mt45">
						<div class="paging">
							<div class="gridPaging" id="gridPageNavigationDiv"></div>페이징 사용 등록
						</div>
					</div> -->
				</div>

			</div><!-- id : contents -->

		</div><!-- id : container -->
		
		<script>
			//조회조건 처리
			newriver.manageAction();
		</script>

		<%@include file="/jsp/include/footer_m.jsp" %>

	</div><!-- id : wrap -->

</body>
</html>