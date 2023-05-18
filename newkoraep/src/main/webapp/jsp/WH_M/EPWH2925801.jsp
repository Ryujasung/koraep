<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>회수정보관리</title>
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

<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>

<script type="text/javaScript" language="javascript" defer="defer">

	/* 페이징 사용 등록 */
	gridRowsPerPage 	= 15;	// 1페이지에서 보여줄 행 수
	gridCurrentPage 		= 1;	// 현재 페이지
	gridTotalRowCount 	= 0; //전체 행 수

	 var INQ_PARAMS;		//파라미터 데이터
     var stat_cd_list;		//상태
     var toDay = kora.common.gfn_toDay(); // 현재 시간
     var sumData; //총합계
     
     $(function() {
    	 
   		INQ_PARAMS 		= jsonObject($("#INQ_PARAMS").val());		//파라미터 데이터
  	    stat_cd_list 		= jsonObject($("#stat_cd_list").val());		//상태
  	  	
  	  	//기본셋팅
  	 	 fn_init();
  	  	
	  	 //버튼 셋팅
	   	//fn_btnSetting();
	   	 
	   	//그리드 셋팅
		fnSetGrid1();
	   	
		/************************************
		 * 조회 클릭 이벤트
		 ***********************************/
		$("#btn_sel").click(function(){
			//조회버튼 클릭시 페이징 초기화
			gridCurrentPage = 1;
			fn_sel();
			
			//조회조건 닫기
			$('#btn_manage').trigger('click');
		});
		
        /************************************
         * 회수정보 등록 버튼 클릭 이벤트
         ***********************************/
        $("#btn_page").click(function(){
            fn_page();
        });
        
        
        /************************************
         * 회수정보 등록 버튼 클릭 이벤트
         ***********************************/
        $("#btn_page2").click(function(){
            fn_page2();
        });
	 });
     
     //초기화
     function fn_init(){
    	 
	    	kora.common.setEtcCmBx2(stat_cd_list, "","", $("#RTRVL_STAT_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');					//상태

	    	//지점조회
			fn_whsdl_bizrnm();
	    	
			/*모바일용 날짜셋팅*/
			$('#START_DT').YJdatepicker({
				periodTo : '#END_DT'
				,initDate : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
			});
			$('#END_DT').YJdatepicker({
				periodFrom : '#START_DT'
				,initDate : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
			});
						
			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				kora.common.jsonToTable("params",INQ_PARAMS.SEL_PARAMS);
				/* 화면이동 페이징 셋팅 */
				gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
			}
     }

   //지점 조회
 	function fn_whsdl_bizrnm(){
 		var url = "/WH/EPWH2925801_192.do" 
 		var input ={};
		ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {   
				kora.common.setEtcCmBx2(rtnData.brch_cd_List, "","", $("#WHSDL_BRCHNM"), "BRCH_ID_NO", "BRCH_NM", "N", 'T');//지점
			}else{
				alert("error");
			}
		},false);
   }
   
     
   //회수정보관리 조회
    function fn_sel(){
		  var input	={};
		  var url = "/WH/EPWH2925801_193.do" 
		  var start_dt 	= $("#START_DT").val();
		  var end_dt   = $("#END_DT").val();
		  start_dt   	=  start_dt.replace(/-/gi, "");
	 	  end_dt    		=  end_dt.replace(/-/gi, "");
	
		 //날짜 정합성 체크. 20160204
		 if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
			alert("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return; 
		 }else if(start_dt>end_dt){
			alert("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return;
		 }
	
		input["SEL_GBN"]			= $("#SEL_GBN").val();
		input["START_DT"]			= $("#START_DT").val();
		input["END_DT"]				= $("#END_DT").val();			
		input["BIZRNM"]				= $("#REG_CUST_NM").val();
		input["WHSDL_BRCHNM"]	= $("#WHSDL_BRCHNM").val();
		input["RTRVL_STAT_CD"]	= $("#RTRVL_STAT_CD").val();
		input["REG_CUST_NM"]		= $("#REG_CUST_NM").val();
		

		/* 페이징  */
		input["ROWS_PER_PAGE"] 		= gridRowsPerPage;
		input["CURRENT_PAGE"] 			= gridCurrentPage;
		INQ_PARAMS["SEL_PARAMS"] 	= input;
		
		hideMessage();
		kora.common.showLoadingBar(dataGrid, gridRoot);
      	ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {   
   					gridApp.setData(rtnData.selList);
					sumData = rtnData.totalList[0];

					/* 페이징 표시 */
					gridTotalRowCount = parseInt(sumData.CNT); //총 카운트
					drawGridPagingNavigation(gridCurrentPage);
					
					//AMT_TOT
					$("#t1").text(rtnData.amt_tot_list[0].T1);
					$("#t2").text(rtnData.amt_tot_list[0].T2);
					$("#t3").text(rtnData.amt_tot_list[0].T3);
					$("#t4").text(rtnData.amt_tot_list[0].T4);
					$("#t5").text(rtnData.amt_tot_list[0].T5);
					
					if (rtnData.selList.length == 0) {
						showMessage();	
					} 
					
   				}else{
   					alert("error");
   				}
   				kora.common.hideLoadingBar(dataGrid, gridRoot);

   		});
    }
   
    /* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel(); //조회 펑션
	}
    
    //회수정보 등록 페이지 이동 
    function fn_page() {
        INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
        INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH2925801.do";
        kora.common.goPage('/WH/EPWH2925831.do', INQ_PARAMS);
    }
    
    //회수증빙자료관리 페이지 이동 
    function fn_page2() {
        INQ_PARAMS={};
        INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
        INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH2925801.do";
        kora.common.goPage('/WH/EPWH2925897.do', INQ_PARAMS);
    }
    
	//회수정보관리 상세
	function link(){
		var idx = dataGrid.getSelectedIndices();
		var input = gridRoot.getItemAt(idx);
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["PARAMS"] = {};
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH2925801.do";
		kora.common.goPage('/WH/EPWH2925864.do', INQ_PARAMS);
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
			layoutStr.push('	<DataGrid id="dg1" autoHeight="true" minHeight="310" rowHeight="110" styleName="gridStyle" textAlign="center" wordWrap="true" variableRowHeight="true">');
			layoutStr.push('		<columns>');   	
			layoutStr.push('			<DataGridColumn dataField="RTL_CUST_BIZRNM" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('reg_cust_nm')+"&lt;br&gt;("+fn_text('rtrvl_reg_dt')+ ')" width="70%" />');
			layoutStr.push('			<DataGridColumn dataField="RTRVL_QTY_TOT" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('rtn_qty2')+"&lt;br&gt;("+fn_text('stat')+ ')" width="30%" />');
			layoutStr.push('		</columns>');		
			layoutStr.push('	</DataGrid>');
			layoutStr.push('    <Style>');
			layoutStr.push('		.gridStyle {');
			layoutStr.push('			headerColors:#565862,#565862;');
			layoutStr.push('			headerStyleName:gridHeaderStyle;');
			layoutStr.push('			verticalAlign:middle;headerHeight:70;fontSize:28;');
			layoutStr.push('		}');
			layoutStr.push('		.gridHeaderStyle {');
			layoutStr.push('			color:#ffffff;');
			layoutStr.push('			fontWeight:bold;');
			layoutStr.push('			horizontalAlign:center;');
			layoutStr.push('			verticalAlign:middle;');
			layoutStr.push('		}');
			layoutStr.push('    </Style>');
			layoutStr.push('    <Box id="messageBox" width="100%" height="100%" backgroundAlpha="0.3" verticalAlign="top" horizontalAlign="center" visible="false" margin-top="150px">');
            layoutStr.push('    	<Box backgroundAlpha="1" backgroundColor="#FFFFFF" borderColor="#000000" borderStyle="solid" paddingTop="5px" paddingBottom="5px" paddingRight="5px" paddingLeft="5px">');
            layoutStr.push('    		<Label id="messageLabel" text="조회된 내역이 없습니다" fontSize="24px" fontWeight="bold" textAlign="center"/>');
            layoutStr.push('    	</Box>');
            layoutStr.push('    </Box>');			
			layoutStr.push('</rMateGrid>');
				};

	/**
	 * 조회기준-생산자 그리드 이벤트 핸들러
	 */
	function gridReadyHandler(id) {
		gridApp = document.getElementById(id); // 그리드를 포함하는 div 객체
		gridRoot = gridApp.getRoot(); // 데이터와 그리드를 포함하는 객체
		gridApp.setLayout(layoutStr.join("").toString());

		var layoutCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			dataGrid.addEventListener("change", selectionChangeHandler);

			 //파라미터 call back function 실행
			 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
				 /* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
			 	 window[INQ_PARAMS.FN_CALLBACK]();
			 	//취약점점검 6042 기원우
			 	
			 }else{
				 gridApp.setData();
				/* 페이징 표시 */
				drawGridPagingNavigation(gridCurrentPage);
				
				//조회조건 열기
				$('#btn_manage').trigger('click');
			 }
			 
		}
		var dataCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
		}
		var selectionChangeHandler = function(event) {
			link();
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	}

	// labelJsFunction 기능을 이용하여 Quarter 컬럼에 월 분기 표시를 함께 넣어줍니다.
	// labelJsFunction 함수의 파라메터는 다음과 같습니다.
	// function labelJsFunction(item:Object, value:Object, column:Column)
	//	      item : 해당 행의 data 객체
	//	      value : 해당 셀의 라벨
	//	      column : 해당 셀의 열을 정의한 Column 객체
	// 그리드 설정시 DataGridColumn 항목에 추가 (예: labelJsFunction="convertItem") 
	function convertItem(item, value, column) {
		
		var dataField = column.getDataField();
		
		if(dataField == "RTL_CUST_BIZRNM") {
			return item["RTL_CUST_BIZRNM"] + "</br>(" + kora.common.formatter.datetime(item["RTRVL_REG_DT"], "yyyy-mm-dd") + ")";
		}
		else if(dataField == "RTRVL_QTY_TOT") {
			return kora.common.format_comma(item["RTRVL_QTY_TOT"]) + "</br>(" + item["RTRVL_STAT_NM"] + ")";
		}
		else {
			return "";
		}
	}
	
/****************************************** 그리드 셋팅 끝***************************************** */
</script>

</head>
<body>

	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
	<input type="hidden" id="stat_cd_list" value="<c:out value='${stat_cd_list}' />" />
		
	<div id="wrap">
	
		<%@include file="/jsp/include/header_m.jsp" %>
		
		<%@include file="/jsp/include/aside_m.jsp" %>

		<div id="container">

			<div id="subvisual">
				<h2 class="tit" id="title"></h2>
				<!-- <a href="#self" class="btn_back"><span class="hide">뒤로가기</span></a> -->
			</div><!-- id : subvisual -->

			<div id="contents">
				<div class="btn_manage">
					<button type="button" id="btn_manage"></button>
				</div>
				<div class="manage_wrap" id="params">
					<div class="contbox">
						<div class="boxed">
							<div class="sort">조회기간</div>
                            <div class="cont" style="font-size:28px;color:#222222;">회수등록일자 기준</div>
						</div>
						<div class="boxed">
							<input type="text" id="START_DT" style="width: 285px;" readonly>
							<span class="swung">~</span>
							<input type="text" id="END_DT" style="width: 285px;" readonly>
						</div>
					</div>
					<div class="contbox v2">
						<div class="boxed">
							<div class="sort">지점</div>
							<select style="width: 435px;" id="WHSDL_BRCHNM"></select>
						</div>
						<div class="boxed">
							<div class="sort">상태</div>
							<select style="width: 435px;" id="RTRVL_STAT_CD"></select>
						</div>
						<div class="boxed">
							<div class="sort">회수처</div>
							<input type="text" id="REG_CUST_NM" style="width: 435px;"/>
						</div>
						<div class="btn_wrap line">
							<div class="fl_c">
								<button class="btn70 c1" style="width: 220px;" id="btn_sel">조회</button>
							</div>
						</div>
					</div>
				</div>
				<div class="contbox mt0 pb20" >
					<div id="tableView" class="table_view">
						<div class="slick-wrap">
							<div class="tbl_slide" >
								<table>
									<colgroup>
										<col style="width: 170px;">
										<col style="width: auto;">
									</colgroup>
									<tbody>
										<tr>
											<th>총회수량</th><td id="t1">0</td>
										</tr>
										<tr>
											<th>지급예정</th><td id="t2">0</td>
										</tr>
										<tr>
											<th>지급완료</th><td id="t3">0</td>
										</tr>
										<tr>
											<th>잔여회수량</th><td id="t4">0</td>
										</tr>
										<tr>
											<th>등록미확인</th><td id="t5">0</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
				<div class="tblbox">
					<div class="tbl_inquiry v2">
						<div id="gridHolder"></div> <!-- 그리드 -->
					</div>
					<div class="pagination mt20">
						<div class="paging">
							<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
						</div>
					</div>
					<div class="btn_wrap mt30" style="height:50px">
                        <button class="btn70 c3 ml20" style="width: 210px;" id="btn_page2">증빙자료관리</button>
						<button class="btnCircle c1" id="btn_page">등록</button>
					</div>					
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
