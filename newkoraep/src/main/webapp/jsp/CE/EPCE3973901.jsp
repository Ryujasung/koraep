<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>API전송이력조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

		<%@include file="/jsp/include/common_page.jsp" %>
	
		<!-- 페이징 사용 등록 -->
		<script src="/js/kora/paging_common.js"></script>
	  
		<script type="text/javaScript" language="javascript" defer="defer" >
		
		/* 페이징 사용 등록 */
		gridRowsPerPage = 15;	// 1페이지에서 보여줄 행 수
		gridCurrentPage = 1;		// 현재 페이지
		gridTotalRowCount = 0; 	//전체 행 수
		//2020-03-18 추가
		var INQ_PARAMS;	//파라미터 데이터
			var toDay = kora.common.gfn_toDay();  // 현재 시간
			var lk_api_cd_sel;
			var execHistPram ={};
			
			var parent_item; 
			
			$(document).ready(function(){
				
				lk_api_cd_sel 		=  jsonObject($("#lk_api_cd_sel").val());      
				
				INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
				
				//버튼 셋팅.
				fn_btnSetting();
				
				$('#START_DT').YJcalendar({  
					toName : 'to',
					triggerBtn : true
				});
				$('#END_DT').YJcalendar({
					fromName : 'from',
					triggerBtn : true
				});
			
			   toDay = toDay.substring(0,4)+"-"+toDay.substring(4,6)+"-"+toDay.substring(6);
				$("#START_DT").val(toDay);  //calendar 셋팅
				$("#END_DT").val(toDay); // calender 셋팅
				
				for(var i=0;i<25;i++){ // 시간 셋팅
						if(i < 10){  
							$("#STR_TM").append('<option value="0'+i+'">0'+i+'</option>');
							$("#ETR_TM").append('<option value="0'+i+'">0'+i+'</option>');
						} else {
							$("#STR_TM").append('<option value="'+i+'">'+i+'</option>');
							$("#ETR_TM").append('<option value="'+i+'">'+i+'</option>');
							    
						} 
				}// end of for 
				
				$("#ETR_TM").val("24");   //시간 24시로 설정
				fnSetGrid();  //그리드 셋팅
				
				//콤보박스
				kora.common.setEtcCmBx2(lk_api_cd_sel, "", "", $("#LK_API_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
				
				/************************************
				 * 업무구분 변경 이벤트
				 ***********************************/
				/* $("#MENU_GRP_CD").change(function(){
					fnMenuGrpCd();
				}); */
				
				/************************************
				 * 메뉴명 변경 이벤트
				 ***********************************/
				/* $("#MENU_CD").change(function(){
					fnMenuCd();
				}); */
				
				/************************************
				 * 시작날짜  클릭시 - 삭제  변경 이벤트
				 ***********************************/
				$("#START_DT").click(function(){
					    var start_dt = $("#START_DT").val();
					     start_dt   =  start_dt.replace(/-/gi, "");
					     $("#START_DT").val(start_dt)
				});
				/************************************
				 * 시작날짜  클릭시 - 추가  변경 이벤트
				 ***********************************/
				$("#START_DT").change(function(){
				     var start_dt = $("#START_DT").val();
				     start_dt   =  start_dt.replace(/-/gi, "");
					if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
				     $("#START_DT").val(start_dt) 
				});
				
				
				/************************************
				 * 끝날짜  클릭시 - 삭제  변경 이벤트
				 ***********************************/
				$("#END_DT").click(function(){
					    var end_dt = $("#END_DT").val();
					         end_dt  = end_dt.replace(/-/gi, "");
					     $("#END_DT").val(end_dt)
				});
				/************************************
				 * 끝날짜  클릭시 - 추가  변경 이벤트
				 ***********************************/
				$("#END_DT").change(function(){
				     var end_dt  = $("#END_DT").val();
				           end_dt =  end_dt.replace(/-/gi, "");
					if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd")
				     $("#END_DT").val(end_dt) 
				});
				
				
				/************************************
				 * 조회버튼 클릭 이벤트
				 ***********************************/
				$("#btn_sel").click(function(){
					//조회버튼 클릭시 페이징 초기화
					gridCurrentPage = 1;
					fn_sel();
				});

				 $("#btn_excel").click(function() {
					 fn_excel();
				 });
				 
			});
			
		/* 페이징 이동 스크립트 */
		function gridMovePage(goPage) {
			gridCurrentPage = goPage; //선택 페이지
			fn_sel(); //조회 펑션
		}		
			
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
			var fileName = $('#title').text().replace("/","_")  +"_" + today+hour+min+sec+".xlsx";
			
			//그리드 컬럼목록 저장
			var col = new Array();
			var columns = dataGrid.getColumns();
			for(i=0; i<columns.length; i++){
				if(columns[i].getDataField() != undefined && columns[i].getDataField() != 'index' && columns[i].getDataField() !='PRAM'){ //순번 제외
					var item = {};
					item['headerText'] = columns[i].getHeaderText();
					item['dataField'] = columns[i].getDataField();
					item['textAlign'] = columns[i].getStyle('textAlign');
					item['id'] = kora.common.null2void(columns[i].id);
					col.push(item);
				}
			}
			
			var input = INQ_PARAMS["SEL_PARAMS"];
//	 		input['excelYn'] = 'Y';	//엑셀 저장시 모든 검색이 필요해서
			input['fileName'] = fileName;
			input['columns'] = JSON.stringify(col);
			var url = "/CE/EPCE3973901_05.do";
			var start_dt = $("#START_DT").val();
			var end_dt    = $("#END_DT").val();
			
			     start_dt   =  start_dt.replace(/-/gi, "");
			     end_dt    =  end_dt.replace(/-/gi, "");
			 	if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
					alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
					return; 
				}else if(start_dt>end_dt){
					alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
					return;
				}    
			 kora.common.showLoadingBar(dataGrid, gridRoot);
			ajaxPost(url, input, function(rtnData){
				if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
					alertMsg(rtnData.RSLT_MSG);
				}else{
					//파일다운로드
					frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
					frm.fileName.value = fileName;
					frm.submit();
				}
				kora.common.hideLoadingBar(dataGrid, gridRoot);
			}); 
		}
				
		function fn_sel(){
			var input ={}
			var url ="/CE/EPCE3973901_193.do";
			var start_dt = $("#START_DT").val();
			var end_dt    = $("#END_DT").val();
			
		     start_dt   =  start_dt.replace(/-/gi, "");
		     end_dt    =  end_dt.replace(/-/gi, "");

			//날짜 정합성 체크. 20160204
			if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
				alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
				return; 
			}
	     	//	kora.common.fnDateCompare ()    종료일이 시작일 보다 작을때 false 를 체크 해보자
			if(start_dt>end_dt){
				alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
				return;
			} 
			
		 	//날짜포맷확인
			if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd");
			if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd");
			
			//시간체크
			//kora.common.fn_validTime($("#STR_TM").val() ,$("#ETR_TM").val());
			   
			input["LK_API_CD_SEL"] 	= $("#LK_API_CD_SEL option:selected").val();//전송구분
			input["BIZRNM_SEL"] 	= $("#BIZRNM_SEL").val();					//사업자명
			input["BIZRNO"] 	    = $("#BIZRNO").val();						//사업자번호
			
			input[ "START_DT"]      =$("#START_DT").val()   //시작날짜
			input[ "END_DT"]        =$("#END_DT").val()   //끝날짜
			input[ "STR_TM"]        =$("#STR_TM").val()   //시작시간
			input[ "ETR_TM"]        =$("#ETR_TM").val()   //끝시간
			
			/* 페이징  */
			input["ROWS_PER_PAGE"] = gridRowsPerPage;
			input["CURRENT_PAGE"] 	= gridCurrentPage;
			
			//2020-03-18 추가
			INQ_PARAMS["SEL_PARAMS"] = input;
			
			kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
			ajaxPost(url,input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.execHistList);
					
					/* 페이징 표시 */
					gridTotalRowCount = rtnData.totalCnt; //총 카운트
					drawGridPagingNavigation(gridCurrentPage);
				} else {
					alertMsg("error");
				}
			}, false); 
			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
		}	
		
		function link() {
			var idx = dataGrid.getSelectedIndices();
			var pagedata = window.frameElement.name;
			parent_item = gridRoot.getItemAt(idx);
			window.parent.NrvPub.AjaxPopup('/CE/EPCE3961366.do', pagedata);
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
		function fnSetGrid(reDrawYn) {
			rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%");
	
			layoutStr = new Array();
			layoutStr.push('<rMateGrid>');
			layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr.push('	<NumberMaskFormatter id="maskfmt" formatString="###-##-#####"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" sortableColumns="true"   horizontalGridLines="true" headerHeight="35">');
			layoutStr.push('		<columns>');
			layoutStr.push('			<DataGridColumn dataField="PNO" headerText="'+ parent.fn_text('sn')+ '" textAlign="center" width="5%"   draggable="false"/>');
			layoutStr.push('			<DataGridColumn dataField="LK_API_CD" headerText="전송구분" width="20%" itemRenderer="HtmlItem"  textAlign="center" />');
			layoutStr.push('			<DataGridColumn dataField="BIZRNM" headerText="사업자명" width="10%" textAlign="center" />');
			layoutStr.push('			<DataGridColumn dataField="BIZRNO" headerText="사업자번호" width="10%" textAlign="center" formatter="{maskfmt}"/>');
			layoutStr.push('			<DataGridColumn dataField="ERP_NM" headerText="ERP업체명" width="10%" textAlign="center" />');
			layoutStr.push('			<DataGridColumn dataField="ERR_YN" headerText="결과구분" width="10%" textAlign="center" />');
			layoutStr.push('			<DataGridColumn dataField="ERR_MSG" headerText="오류내역" width="20%" textAlign="center"/>');
			layoutStr.push('			<DataGridColumn dataField="ACPT_ERR" headerText="수신오류내역" width="10%" textAlign="center"/>');
			layoutStr.push('			<DataGridColumn dataField="REG_DTTM" headerText="일시" width="10%" textAlign="center"/>');
			layoutStr.push('			<DataGridColumn dataField="ACSS_IP" headerText="접속 IP" width="10%" textAlign="center"/>');
			layoutStr.push('			<DataGridColumn dataField="PRAM" headerText="전문내용" width="6%" textAlign="center" itemRenderer="HtmlItem"/>');			
			layoutStr.push('		</columns>');
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
			gridApp.setData([]);
			var layoutCompleteHandler = function(event) {
				dataGrid = gridRoot.getDataGrid(); // 그리드 객체
				dataGrid.addEventListener("change", selectionChangeHandler);
				drawGridPagingNavigation(gridCurrentPage);  //페이징 표시
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
	
		/*
		link = function() {
			dataGrid   = gridRoot.getDataGrid();  // 그리드 객체
			idx        = dataGrid.getSelectedIndex();
			tmpRowData = gridRoot.getItemAt(idx);
			
   	      $("#PAGE_REG_DTTM").val(tmpRowData["REG_DTTM"]);
		  var pagedata = window.frameElement.name;

	      window.parent.NrvPub.AjaxPopup('/CE/EPCE3973964.do', pagedata);

		}
		*/
	
    /****************************************** 그리드 셋팅 끝***************************************** */
		</script>
			
			
			
</head>		
<body>
  	<div class="iframe_inner">
  			<input type="hidden" id="lk_api_cd_sel" value="<c:out value='${lk_api_cd_sel}' />" />
  			<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<div class="h3group">
				<h3 class="tit" id="title"></h3>
				<div class="btn" style="float:right" id="UR">
			</div>
			<section class="secwrap">
					<div class="srcharea" id="divInput">
						<div class="row">
							<div class="col">
								<div class="tit">조회일시</div>
								<div class="box">
									<div class="calendar">
										<input type="text" id="START_DT" name="from"	style="width: 180px;" class="i_notnull" alt="시작날짜">
									</div>
									<div class="box">
										<select id="STR_TM" style="width: 70px"></select>
									</div>
									<div class="obj">~</div>
									<div class="calendar">
										<input type="text" id="END_DT" name="to" style="width: 180px;" class="i_notnull" alt="끝 날짜">
									</div>
									<div class="box">
										<select id="ETR_TM" style="width: 70px"></select>
									</div>
								</div>
							</div>
			
						</div>
						<div class="row">
			
							<div class="col">
								<div class="tit">전송구분</div>
								<div class="box">
									<select style="width: 180px;" id="LK_API_CD_SEL" name="LK_API_CD_SEL" class="i_notnull"></select>
								</div>
							</div>
							<div class="col">
								<div class="tit">사업자명</div>
								<div class="box">
									<input type="text" id="BIZRNM_SEL" name="BIZRNM_SEL" maxlength="30" class="i_notnull" tyle="width: 180px; text-align: center;"  alt="사업자명" >
								</div>
							</div>
							<div class="col">
								<div class="tit">사업자번호</div>
								<div class="box">
									<input type="text" id="BIZRNO" name="BIZRNO" maxlength="30" class="i_notnull" tyle="width: 180px; text-align: center;"  alt="사업자번호" >
								</div>
							</div>
							<!-- <div class="btn">
								<button type="button" class="btn36 c1" style="width: 100px;" id="btn_sel">조회</button>
							</div> -->
							
							<div class="btn" id="CR">
							</div>
						</div>		<!-- end of row -->
					</div>		<!-- end of srcharea --> 
			</section>
	
			<section class="secwrap mt10">
					<div class="boxarea mt10">
						<div id="gridHolder" style="height: 560px; background: #FFF;"></div>
					</div><!-- 그리드 셋팅 --> 
					<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
			</section>
			<input  type="hidden" id="PAGE_REG_DTTM"/> 
	</div> <!-- end of  iframe_inner -->
<form name="frm" action="/jsp/file_down.jsp" method="post">
	<input type="hidden" name="fileName" value="" />
	<input type="hidden" name="saveFileName" value="" />
	<input type="hidden" name="downDiv" value="excel" />
</form>
</body>
</html>
		