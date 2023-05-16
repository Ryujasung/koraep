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
		
			var lk_api_cd_sel;
			var execHistPram ={};
			
			$(document).ready(function(){
				
				lk_api_cd_sel = jsonObject($("#lk_api_cd_sel").val());      
				
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
			
				$("#START_DT").val(kora.common.getDate("yyyy-mm-dd", "D", -1, false));//일주일전 날짜 
				$("#END_DT").val(kora.common.getDate("yyyy-mm-dd", "D", 0, false));//현재 날짜
				
				fnSetGrid();  //그리드 셋팅
				
				//콤보박스
				kora.common.setEtcCmBx2(lk_api_cd_sel, "", "", $("#ANC_SE"), "ETC_CD", "ETC_CD_NM", "N", "T");
				
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

			});
			
		/* 페이징 이동 스크립트 */
		function gridMovePage(goPage) {
			gridCurrentPage = goPage; //선택 페이지
			fn_sel(); //조회 펑션
		}		
			
		function fn_sel(){
			var input ={}
			var url ="/CE/EPCE5589776_1.do";
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
			kora.common.fn_validTime($("#STR_TM").val() ,$("#ETR_TM").val());
			   
			input["ANC_SE"] = $("#ANC_SE option:selected").val();//사업자명
			input["ANC_SBJ"] = $("#ANC_SBJ").val();//전송구분
			input[ "START_DT"] = $("#START_DT").val();//시작날짜
			input[ "END_DT"] = $("#END_DT").val();//끝날짜
			
			/* 페이징  */
			input["ROWS_PER_PAGE"] = gridRowsPerPage;
			input["CURRENT_PAGE"] 	= gridCurrentPage;
			
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
		
	/****************************************** 그리드 셋팅 시작***************************************** */
		/**
		 * 그리드 관련 변수 선언
		 */
		var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
		var gridApp, gridRoot, dataGrid, layoutStr, selectorColumn;
		var layoutStr = new Array();
		var rowIndex;
		/**
		 * 그리드 셋팅
		 */
		function fnSetGrid(reDrawYn) {
			rMateGridH5.create("grid", "gridHolder", jsVars, "100%", "100%");
			 layoutStr.push('<rMateGrid>');
			 layoutStr.push('<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerHeight="35" headerWordWrap="true" horizontalGridLines="true" draggableColumns="true" sortableColumns="true" textAlign="center">');
			 layoutStr.push('<columns>');
			 layoutStr.push('	<DataGridColumn dataField="ANC_SE_NM"  headerText="'+parent.fn_text('anc_se')+'" width="20%" />');
			 layoutStr.push('	<DataGridColumn dataField="TRGT_SE_NM"  headerText="'+parent.fn_text('anc_trgt')+'" width="20%" />');
			 layoutStr.push('	<DataGridColumn dataField="ANC_SBJ"  headerText="'+parent.fn_text('sbj')+'" width="60%" textAlign="left" />');
			 layoutStr.push('	<DataGridColumn dataField="REG_DTTM"  headerText="'+parent.fn_text('reg_dt2')+'" width="20%" />');
			 layoutStr.push('</columns>');
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
	
		
		link = function() {
			dataGrid   = gridRoot.getDataGrid();  // 그리드 객체
			idx        = dataGrid.getSelectedIndex();
			tmpRowData = gridRoot.getItemAt(idx);
			
   	      $("#PAGE_REG_DTTM").val(tmpRowData["REG_DTTM"]);
		  var pagedata = window.frameElement.name;

	      window.parent.NrvPub.AjaxPopup('/CE/EPCE3973964.do', pagedata);

		}
	
    /****************************************** 그리드 셋팅 끝***************************************** */
		</script>
			
			
			
</head>		
<body>
  	<div class="iframe_inner">
  			<input type="hidden" id="lk_api_cd_sel" value="<c:out value='${lk_api_cd_sel}' />" />
			<div class="h3group">
				<h3 class="tit" id="title"></h3>
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
									<div class="obj">~</div>
									<div class="calendar">
										<input type="text" id="END_DT" name="to" style="width: 180px;" class="i_notnull" alt="끝 날짜">
									</div>
								</div>
							</div>
							
							<div class="col">
								<div class="tit">알림구분</div>
								<div class="box">
									<select style="width: 180px;" id="ANC_SE" name="ANC_SE" class="i_notnull"></select>
								</div>
							</div>
							<div class="col">
								<div class="tit">제목</div>
								<div class="box">
									<input type="text" id="ANC_SBJ" name="ANC_SBJ" maxlength="50" class="i_notnull" style="width: 280px; text-align: left;"  alt="제목" >
								</div>
							</div>
							<!-- <div class="btn">
								<button type="button" class="btn36 c1" style="width: 100px;" id="btn_sel">조회</button>
							</div> -->
							
							<div class="btn" id="UR">
			
						</div>
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

</body>
</html>
		