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
			
			fn_btnSetting();

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
			
			
			$('#title_sub').text('<c:out value="${titleSub}" />');//타이틀
			
			kora.common.setEtcCmBx2(statList, "", "", $("#STAT_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			kora.common.setEtcCmBx2(whsdlSeCdList, "","", $("#WHSDL_SE_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N");
			fn_whsl_se_cd();
			//kora.common.setEtcCmBx2(whsdlList, "", "", $("#WHSDL_BIZR_SEL"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N", "T");
			//$("#WHSDL_BIZR_SEL").select2();
			
			
			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
				
				//$("#WHSDL_BIZR_SEL").select2('val', INQ_PARAMS.SEL_PARAMS.WHSDL_BIZR_SEL);
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
			
			$("#btn_upd").click(function(){
				fn_upd();
			});
			
			$("#btn_upd2").click(function(){
				fn_upd2();
			});
			
			/************************************
			 * 엑셀다운로드 버튼 클릭 이벤트
			 ***********************************/
			 $("#btn_excel").click(function() {
				 fn_excel();
			 });
			
			 /************************************
			 * 도매업자 구분 변경 이벤트
			 ***********************************/
			$("#WHSDL_SE_CD_SEL").change(function(){
				fn_whsl_se_cd();
			});
		});
		
		//도매업자구분 변경시 도매업자 조회 ,생산자가 선택됐을경우 거래중인 도매업자만 조회
	     function fn_whsl_se_cd(){
	    	var url = "/SELECT_WHSDL_BIZR_LIST.do" 
			var input ={};
			   if($("#WHSDL_SE_CD_SEL").val()  !=""){
			   		input["BIZR_TP_CD"] =$("#WHSDL_SE_CD_SEL").val();
			   }

	    	   //$("#WHSDL_BIZR_SEL").select2("val","");
	       	   ajaxPost(url, input, function(rtnData) {
	   				if ("" != rtnData && null != rtnData) {  
	   					kora.common.setEtcCmBx2(rtnData, "","", $("#WHSDL_BIZR_SEL"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ); //업체명
	   				}else{
	   					alert("error");
	   				}
	    		});
	     }	
		
		//엑셀저장
		function fn_excel(){

			var collection = gridRoot.getCollection();
			if(collection.getLength() < 1){
				alert("데이터가 없습니다.");
				return;
			}
			
			if(INQ_PARAMS["SEL_PARAMS"] == undefined){
				alert("먼저 데이터를 조회해야 합니다.");
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
					
					if(columns[i].getDataField() == 'PAY_REG_DT_PAGE'){// html 태크 사용중 컬럼은 대체
						item['dataField'] = 'PAY_REG_DT';
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
			
			var url = "/WH/EPWH2371301_05.do";
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
					alert(rtnData.RSLT_MSG);
				}else{
					//파일다운로드
					frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
					frm.fileName.value = fileName;
					frm.submit();
				}
			});
		}
		
		function fn_page(){
			var idx = dataGrid.getSelectedIndices();
			var input = gridRoot.getItemAt(idx)
			
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH2371301.do";
			kora.common.goPage('/WH/EPWH2371364.do', INQ_PARAMS);
		}
		
		function fn_upd2(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alert("선택된 행이 없습니다.");
				return;
			}
						
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				if(item.PAY_STAT_CD != 'R'){
					alert('지급오류 항목만 처리 가능합니다.');
					return;
				}
			}
			
			confirm('선택된 내역에 대해 오류건 재전송 하시겠습니까?', "fn_upd2_exec");
		}
		
		function fn_upd2_exec(){
			
			var data = {};
			var row = new Array();
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(item);
			}
			
			data["list"] = JSON.stringify(row);
			
			var url = "/WH/EPWH2371331_092.do";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					if(rtnData.RSLT_CD == '0000'){
						alert(rtnData.RSLT_MSG, 'fn_sel');
	 				}else{
	 					alert(rtnData.RSLT_MSG);
	 				}
				} else {
					alert("error");
				}
			});
			
		}
		
		function fn_page2(){
			
			var chkLst = selectorColumn.getSelectedItems();
			
			if(chkLst.length < 1){
				alert("선택된 행이 없습니다.");
				return;
			}
						
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				if(item.PAY_STAT_CD != 'L'){
					alert('지급예정 항목만 연계 자료 생성이 가능합니다.');
					return;
				}
			}
			
			confirm('선택된 내역에 대해 연계전송 하시겠습니까?', "fn_page2_exec");
		}
		
		function fn_page2_exec(){
			
			var data = {};
			var row = new Array();
			
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(item);
			}
			
			data["list"] = JSON.stringify(row);
			
			INQ_PARAMS["PARAMS"] = data;
			INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
			INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH2371301.do";
			kora.common.goPage('/WH/EPWH2371331.do', INQ_PARAMS);
			
		}
		
		/**
		 * 목록조회
		 */
		function fn_sel(){

			var url = "/WH/EPWH2371301_19.do";
			var input = {};
			
			input['START_DT_SEL'] = $("#START_DT_SEL").val();
			input['END_DT_SEL'] = $("#END_DT_SEL").val();
			input['STAT_CD_SEL'] = $("#STAT_CD_SEL option:selected").val();
			//input['WHSDL_SE_CD_SEL'] = $("#WHSDL_SE_CD_SEL option:selected").val();
			//input['WHSDL_BIZR_SEL'] = $("#WHSDL_BIZR_SEL option:selected").val();
			input['WHSDL_SE_CD_SEL'] = '';
			input['WHSDL_BIZR_SEL'] = '';
	
			//파라미터에 조회조건값 저장 
			INQ_PARAMS["SEL_PARAMS"] = input; 
			
			hideMessage();	
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.searchList);
					
					if (rtnData.searchList.length == 0) {
						showMessage();	
					} 
					
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
            layoutStr.push('    <NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
            layoutStr.push('    <NumberMaskFormatter id="dateFmt" formatString="####-##-##"/>');
            layoutStr.push('    <DataGrid id="dg1" autoHeight="true" minHeight="550" rowHeight="110" styleName="gridStyle" textAlign="center" wordWrap="true" variableRowHeight="true">');
            layoutStr.push('        <columns>');
            layoutStr.push('            <DataGridColumn dataField="PAY_REG_DT_PAGE" headerText="'+parent.fn_text('reg_dt2')+'" width="100" itemRenderer="HtmlItem" />');
            layoutStr.push('            <DataGridColumn dataField="PAY_AMT" id="sum4" headerText="'+parent.fn_text('pay_amt')+'" width="100" formatter="{numfmt}" textAlign="right"/>');
            layoutStr.push('            <DataGridColumn dataField="PAY_STAT_NM"  headerText="'+parent.fn_text('stat')+'" width="100"/>');
            layoutStr.push('        </columns>');
            layoutStr.push('    <dataProvider>');
            layoutStr.push('            <SpanArrayCollection source="{$gridData}"/>');
            layoutStr.push('    </dataProvider>');
            layoutStr.push('    </DataGrid>');
            layoutStr.push('    <Style>');
            layoutStr.push('        .gridStyle {');
            layoutStr.push('            headerColors:#565862,#565862;');
            layoutStr.push('            headerStyleName:gridHeaderStyle;');
            layoutStr.push('            verticalAlign:middle;headerHeight:70;fontSize:28;');
            layoutStr.push('        }');
            layoutStr.push('        .gridHeaderStyle {');
            layoutStr.push('            color:#ffffff;');
            layoutStr.push('            fontWeight:bold;');
            layoutStr.push('            horizontalAlign:center;');
            layoutStr.push('            verticalAlign:middle;');
            layoutStr.push('        }');
            layoutStr.push('    </Style>');
            layoutStr.push('    <Box id="messageBox" width="100%" height="100%" backgroundAlpha="0.3" verticalAlign="top" horizontalAlign="center" visible="false" margin-top="150px">');
            layoutStr.push('    	<Box backgroundAlpha="1" backgroundColor="#FFFFFF" borderColor="#000000" borderStyle="solid" paddingTop="5px" paddingBottom="5px" paddingRight="5px" paddingLeft="5px">');
            layoutStr.push('    		<Label id="messageLabel" text="조회된 내역이 없습니다" fontSize="24px" fontWeight="bold" textAlign="center"/>');
            layoutStr.push('    	</Box>');
            layoutStr.push('    </Box>');
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
						/* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
				 	 window[INQ_PARAMS.FN_CALLBACK]();
				 	//취약점점검 6039 기원우
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
<input type="hidden" id="searchList" value="<c:out value='${searchList}' />" />
<input type="hidden" id="searchDtl" value="<c:out value='${searchDtl}' />" />
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