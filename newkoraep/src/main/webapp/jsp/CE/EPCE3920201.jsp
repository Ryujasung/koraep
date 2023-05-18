<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>로그인이력조회</title>
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
			$(document).ready(function(){
				//2020-03-18 추가
				INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			   	
				 //버튼 셋팅
			   	 fn_btnSetting();
				 
			
			   	
				$('#START_DT').YJcalendar({  
					toName : 'to',
					triggerBtn : true,
					dateSetting : toDay.replaceAll('-','')
				});
				$('#END_DT').YJcalendar({
					fromName : 'from',
					triggerBtn : true,
					dateSetting : toDay.replaceAll('-','')
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
				

				
				/************************************
				 * 시작날짜 변경 이벤트
				 ***********************************/
				$("#START_DT").click(function(){
					    var start_dt = $("#START_DT").val();
					     start_dt   =  start_dt.replace(/-/gi, "");
					     $("#START_DT").val(start_dt)
				});
				/************************************
				 * 시작날짜 변경 이벤트
				 ***********************************/
				$("#START_DT").change(function(){
				     var start_dt = $("#START_DT").val();
				     start_dt   =  start_dt.replace(/-/gi, "");
					if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
				     $("#START_DT").val(start_dt) 
				});
				
				
				/************************************
				 * 끝날짜 변경 이벤트
				 ***********************************/
				$("#END_DT").click(function(){
					    var end_dt = $("#END_DT").val();
					         end_dt  = end_dt.replace(/-/gi, "");
					     $("#END_DT").val(end_dt)
				});
				/************************************
				 * 끝날짜 변경 이벤트
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
// 		input['excelYn'] = 'Y';	//엑셀 저장시 모든 검색이 필요해서
		input['fileName'] = fileName;
		input['columns'] = JSON.stringify(col);
		var url = "/CE/EPCE3920201_05.do";
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
			
			
		/* 페이징 이동 스크립트 */
		function gridMovePage(goPage) {
			gridCurrentPage = goPage; //선택 페이지
			fn_sel(); //조회 펑션
		}	
			
		function fn_sel(){
			
			var input ={}
			var url ="/CE/EPCE3920201_19.do";
			var start_dt = $("#START_DT").val();
			var end_dt    = $("#END_DT").val();
			
			     start_dt   =  start_dt.replace(/-/gi, "");
			     end_dt    =  end_dt.replace(/-/gi, "");

			
			  //필수입력값 체크
	 		if (!kora.common.cfrmDivChkValid("divInput")) {
	 			return;
	 		}
			  
	 		//날짜 정합성 체크. 20160204
			if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
				alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
				return; 
			}else if(start_dt>end_dt){
				alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
				return;
			} 
			//시간체크
			//kora.common.fn_validTime($("#STR_TM").val() ,$("#ETR_TM").val());
			   
			input[ "USER_ID"]            =$("#USER_ID").val()   //아이디 
			input[ "LGN_LGOT"]         =$("#LGN_LGOT").val()   //메뉴명
			input[ "START_DT"]         =$("#START_DT").val()   //시작날짜
			input[ "END_DT"]         =$("#END_DT").val()   //끝날짜
			input[ "STR_TM"]          =$("#STR_TM").val()   //시작시간
			input[ "ETR_TM"]          =$("#ETR_TM").val()   //끝시간
			
			/* 페이징  */
			input["ROWS_PER_PAGE"] = gridRowsPerPage;
			input["CURRENT_PAGE"] 	= gridCurrentPage;
			
			//2020-03-18 추가
			INQ_PARAMS["SEL_PARAMS"] = input;
			
			ajaxPost(url,input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					gridApp.setData(rtnData.lgnHistList); 
					
					/* 페이징 표시 */
					gridTotalRowCount = rtnData.totalCnt; //총 카운트
					drawGridPagingNavigation(gridCurrentPage);
				} else {
					alertMsg("error");
				}
			});
		
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
			layoutStr	.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" sortableColumns="true"   horizontalGridLines="true" headerHeight="35">');
			layoutStr.push('		<columns>');
			layoutStr.push('			<DataGridColumn dataField="PNO" headerText="'+ parent.fn_text('sn')+ '" textAlign="center" width="5%"   draggable="false"/>');
			layoutStr.push('			<DataGridColumn dataField="USER_ID" headerText="검색자ID" width="10%" textAlign="center"/>');
			layoutStr.push('			<DataGridColumn dataField="USER_NM" headerText="검색자명" width="10%" textAlign="center"/>');
			layoutStr.push('			<DataGridColumn dataField="MENU_NM" headerText="메뉴명" width="10%" textAlign="center" />');
			layoutStr.push('			<DataGridColumn dataField="TARGET_ID" headerText="대상자ID" width="10%" textAlign="center" />');
			layoutStr.push('			<DataGridColumn dataField="TARGET_NM" headerText="대상자명" width="10%" textAlign="center" />');
			layoutStr.push('			<DataGridColumn dataField="EMAIL" headerText="이메일" width="10%" textAlign="center"/>');
			layoutStr.push('			<DataGridColumn dataField="MBIL_NO" headerText="휴대폰" width="10%" textAlign="center"/>');
			layoutStr.push('			<DataGridColumn dataField="TEL_NO" headerText="연락처" width="10%" textAlign="center"/>');
			layoutStr.push('			<DataGridColumn dataField="STARTTIME" headerText="일시" width="15%" textAlign="center"/>');
			layoutStr.push('			<DataGridColumn dataField="CRUD" headerText="활동" width="10%" textAlign="center"/>');
			layoutStr.push('			<DataGridColumn dataField="ACSS_IP" headerText="접속 IP" width="10%" textAlign="center"/>');
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
				 //파라미터 call back function 실행
				 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
					 /* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
				 	 window[INQ_PARAMS.FN_CALLBACK]();
				 	//취약점점검 5914 기원우
				 }else{
					 gridApp.setData();
				 }
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
			
			
			
</head>
<body>

	<div class="iframe_inner">
			<div class="h3group">
			<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
				<h3 class="tit" id="title"></h3>
				<div class="btn" style="float:right" id="UR">
				</div>
			</div>
			<section class="secwrap" >
<!-- 					<div class="srcharea" id="divInput"> -->
					<div class="srcharea" id="sel_params">
						<div class="row">
							<div class="col">
								<div class="tit">조회일시</div>
								<div class="box">
									<div class="calendar">
										<input type="text" id="START_DT" name="from"	style="width: 150px;" class="i_notnull" alt="시작날짜">
									</div>
									<div class="box">
										<select id="STR_TM" style="width: 70px"></select>
									</div>
									<div class="obj">~</div>
									<div class="calendar">
										<input type="text" id="END_DT" name="to" style="width: 150px;" class="i_notnull" alt="끝 날짜">
									</div>
									<div class="box">
										<select id="ETR_TM" style="width: 70px"></select>
									</div>
								</div>
							</div>
			
				           <div class="col">
								<div class="tit">업무구분</div>
								<div class="box">
									<select style="width: 150px;" id="LGN_LGOT"  >
									   <option value='R'>조회</option>
									   <option value='C'>등록</option>
									   <option value='U'>수정</option>
									   <option value='D'>삭제</option>
									</select>
								</div>
							</div>
			
							<div class="col">
								<div class="tit">아이디</div>
								<div class="box">
									<input type="text" id="USER_ID" maxlength="16"	style="width: 150px; text-align: center;"  alt="아이디" >
								</div>
							</div>
<!-- 							<div class="singleRow"  style="padding: 0"> -->
							<div class="btn" id="CR"></div>
<!-- 						</div> -->
						</div>
					</div>		<!-- end of srcharea --> 
			</section>
			
			<section class="secwrap mt10">
					<div class="boxarea mt10">
						<div id="gridHolder" style="height: 560px; background: #FFF;"></div>
					</div><!-- 그리드 셋팅 --> 
					<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
			</section>
			<input  type="hidden" id="pram"/> 
	</div> <!-- end of  iframe_inner -->

<form name="frm" action="/jsp/file_down.jsp" method="post">
	<input type="hidden" name="fileName" value="" />
	<input type="hidden" name="saveFileName" value="" />
	<input type="hidden" name="downDiv" value="excel" />
</form>


</body>
</html>
		