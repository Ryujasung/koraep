<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>반환관리</title>
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

	 var INQ_PARAMS;	//파라미터 데이터
	 var dtList;				//반환등록일자구분
     var mfc_bizrnmList;	//생산자
	 var brch_nmList;		//생산자 직매장/공장

     var areaList;			//지역
     var sys_seList;		//상태
     var stat_cdList;		//등록구분
     
     $(function() {
    	 
   		INQ_PARAMS 		= jsonObject($("#INQ_PARAMS").val());		//파라미터 데이터
  		dtList 				= jsonObject($("#dtList").val());					//반환등록일자구분
  	    mfc_bizrnmList 	= jsonObject($("#mfc_bizrnmList").val());		//생산자

  	    areaList 			= jsonObject($("#areaList").val());			//지역
  	    sys_seList 			= jsonObject($("#sys_seList").val());			//상태
  	    stat_cdList 		= jsonObject($("#stat_cdList").val());		//등록구분

  	  	brch_nmList 		= jsonObject($("#brch_nmList").val());		//직매장/공장 정보
  	  	
	   	 //그리드 셋팅
		 fnSetGrid1();

		/*모바일용 날짜셋팅*/
		$('#START_DT').YJdatepicker({
			periodTo : '#END_DT'
			,initDate : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
		});
		$('#END_DT').YJdatepicker({
			periodFrom : '#START_DT'
			,initDate : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
		});
		 
		//text 셋팅
		$('#title_sub').text('<c:out value="${titleSub}" />');						  									//타이틀
		$('#sel_term').text(fn_text('sel_term'));																	//조회기간
		$('#stat').text(fn_text('stat')); 																				//상태
		$('#mfc_bizrnm').text(fn_text('mfc_bizrnm')); 														//반환대상생산자
		$('#mfc_brch_nm').text(fn_text('mfc_brch_nm')); 													//반환대상지점
		$('#reg_se').text(fn_text('reg_se')); 																		//등록구분
		$('#whsl_se_cd').text(fn_text('whsl_se_cd'));															//도매업자 구분
		$('#enp_nm').text(fn_text('enp_nm'));																	//업체명
		$('#area').text(fn_text('area')); 																			//지역

		/************************************
		 * 생산자 구분 변경 이벤트
		 ***********************************/
		$("#MFC_BIZRNM").change(function(){
			fn_mfc_bizrnm();
		});

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
		 * 반환내역서 등록 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_page").click(function(){
			fn_page();
		});
		
  		fn_init();
  		
	 });
     
     
     //초기화
     function fn_init(){
    		 kora.common.setEtcCmBx2(dtList, "","", $("#SEARCH_GBN"), "ETC_CD", "ETC_CD_NM", "N");									//조회기간 선택
	    	 kora.common.setEtcCmBx2(stat_cdList, "","", $("#RTN_STAT_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');						//상태
			 kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'T');					//생산자
			 kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');								//직매장/공장
			 kora.common.setEtcCmBx2(sys_seList, "","", $("#SYS_SE"), "ETC_CD", "ETC_CD_NM", "N",'T');									//등록구분
			 kora.common.setEtcCmBx2(areaList, "","", $("#AREA"), "ETC_CD", "ETC_CD_NM", "N" ,'T');										//지역

			 //파라미터 조회조건으로 셋팅
			 if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				 if(brch_nmList !=null){
					kora.common.setEtcCmBx2(brch_nmList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');			 //직매장/공장
				 }
					kora.common.jsonToTable("params",INQ_PARAMS.SEL_PARAMS);
					/* 화면이동 페이징 셋팅 */
					gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
				}
	 
     }
 
   //생산자 변경시 생산자랑 거래중인 도매업자 조회 , 직매장/공장
   function fn_mfc_bizrnm(){
	  		var url = "/WH/EPWH2910101_19.do" 
			var input ={};
			arr	 =[];
			
			if("" != $("#MFC_BIZRNM").val() && null != $("#MFC_BIZRNM").val()){
				arr	 = $("#MFC_BIZRNM").val().split(";");
				input["MFC_BIZRID"]		= arr[0];  //직매장별거래처관리 테이블에서 생산자
				input["MFC_BIZRNO"]		= arr[1];
				input["BIZRID"]				= arr[0];	//지점관리 테이블에서 사업자
				input["BIZRNO"]				= arr[1];
		 	    if($("#WHSL_SE_CD").val() !=""){
		   			  input["BIZR_TP_CD"]		=$("#WHSL_SE_CD").val();
		   			} 

	       	    ajaxPost(url, input, function(rtnData) {
	    				if ("" != rtnData && null != rtnData) {   
	    					kora.common.setEtcCmBx2(rtnData.brch_nmList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');	 			//직매장/공장
	    				}else{
	    					alert("error");
	    				}
	    		},false);
			}else {
				kora.common.setEtcCmBx2("", "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');	 			//직매장/공장
			}
			
   }
  
   //반환내역서 조회
    function fn_sel(){
	   
		 var input	={};
		 var url = "/WH/EPWH2910101_194.do" 
		 var start_dt 			= $("#START_DT").val().replace(/-/gi, "");
		 var end_dt    		= $("#END_DT").val().replace(/-/gi, "");
		 var mfc_bizrnm	 	= $("#MFC_BIZRNM").val();	 
		 var mfc_brch_nm	= $("#MFC_BRCH_NM").val();	
		
		 //날짜 정합성 체크. 20160204
		 if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
			alert("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return; 
		 }else if(start_dt>end_dt){
			alert("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return;
		 } 
	 
		 input["SEARCH_GBN"]   	= $("#SEARCH_GBN").val();	//날짜 구분 선택
		 input["START_DT"]			= $("#START_DT").val();			
		 input["END_DT"]				= $("#END_DT").val();			
		 input["RTN_STAT_CD"]   	= $("#RTN_STAT_CD").val();		//상태
		 input["SYS_SE"]				= $("#SYS_SE").val();				//시스템구분
		 input["AREA_CD"]   		= $("#AREA").val();					//지역
		 
		 if($("#MFC_BIZRNM").val() !="" ){		//생산자
			 var arr = $("#MFC_BIZRNM").val().split(";");
			 input["MFC_BIZRID"]   	= arr[0];
			 input["MFC_BIZRNO"]  	= arr[1];
		 }
		 if($("#MFC_BRCH_NM").val() !="" ){	//직매장/공장
			 var arr2 = $("#MFC_BRCH_NM").val().split(";");
			 input["MFC_BRCH_ID"]   	= arr2[0];
			 input["MFC_BRCH_NO"]  	= arr2[1];
		 }
	
	  	//검색조건들 상세갔다왔을경우 똑같은 ID SELECTBOX 셋팅위해
		input["MFC_BIZRNM"] 		= $("#MFC_BIZRNM").val(); 
		input["MFC_BRCH_NM"] 	= $("#MFC_BRCH_NM").val();
		input["AREA"]   				= $("#AREA").val();	
		 
		/* 페이징  */
		input["ROWS_PER_PAGE"] = gridRowsPerPage;
		input["CURRENT_PAGE"] 	= gridCurrentPage;
		INQ_PARAMS["SEL_PARAMS"] = input;
		
		hideMessage();
		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
      	 ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {   
   					gridApp.setData(rtnData.selList);

   					/* 페이징 표시 */
   					gridTotalRowCount = parseInt(rtnData.totalList[0].CNT); //총 카운트
					drawGridPagingNavigation(gridCurrentPage);
   					
					if (rtnData.selList.length == 0) {
						showMessage();	
					} 
   				}else{
   					 alert("error");
   				}
     		kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
     		
   		});
    }
   
    /* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel(); //조회 펑션
	}
    
	//반환내역서 등록 페이지 이동 
	function fn_page() {
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH2910101.do";
		kora.common.goPage('/WH/EPWH2910131.do', INQ_PARAMS);
	}
	
	//반환관리 상세
	function link(){
		var idx = dataGrid.getSelectedIndices();
		var input = gridRoot.getItemAt(idx);
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["PARAMS"] = {};
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH2910101.do";
		kora.common.goPage('/WH/EPWH2910164.do', INQ_PARAMS);
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
			layoutStr.push('	<DataGrid id="dg1" autoHeight="true" minHeight="672" rowHeight="110" styleName="gridStyle" textAlign="center" wordWrap="true" variableRowHeight="true">');
			layoutStr.push('		<columns>');   	
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('mfc_bizrnm')+"&lt;br&gt;("+fn_text('rtn_reg_dt')+ ')" width="50%" />');
			layoutStr.push('			<DataGridColumn dataField="RTN_QTY_TOT" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('rtn_qty2')+"&lt;br&gt;("+fn_text('stat')+ ')" width="50%" />');
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
			 	eval(INQ_PARAMS.FN_CALLBACK+"()");
			 	
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
		
		if(dataField == "MFC_BIZRNM") {
			return item["MFC_BIZRNM"] + "</br>(" + kora.common.formatter.datetime(item["RTN_REG_DT"], "yyyy-mm-dd") + ")";
		}
		else if(dataField == "RTN_QTY_TOT") {
			return kora.common.format_comma(item["RTN_QTY_TOT"]) + "</br>(" + item["STAT_CD_NM"] + ")";
		}
		else {
			return "";
		}
	}

</script>

</head>
<body>

		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
		<input type="hidden" id="dtList" value="<c:out value='${dtList}' />" />
		<input type="hidden" id="mfc_bizrnmList" value="<c:out value='${mfc_bizrnmList}' />" />
		<input type="hidden" id="areaList" value="<c:out value='${areaList}' />" />
		<input type="hidden" id="sys_seList" value="<c:out value='${sys_seList}' />" />
		<input type="hidden" id="stat_cdList" value="<c:out value='${stat_cdList}' />" />
		<input type="hidden" id="brch_nmList" value="<c:out value='${brch_nmList}' />" />
			
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
							<div class="sort" id="sel_term"></div>
							<select style="width: 435px;" id="SEARCH_GBN">
							</select>
						</div>
						<div class="boxed">
							<input type="text" id="START_DT" style="width: 285px;" readonly>
							<span class="swung">~</span>
							<input type="text" id="END_DT" style="width: 285px;" readonly>
						</div>
					</div>
					<div class="contbox v2">
						<div class="boxed">
							<div class="sort" id="mfc_bizrnm"></div>
							<select style="width: 435px;" id="MFC_BIZRNM"></select>
						</div>
						<div class="boxed">
							<div class="sort" id="mfc_brch_nm"></div>
							<select style="width: 435px;" id="MFC_BRCH_NM"></select>
						</div>
						<div class="boxed">
							<div class="sort" id="area"></div>
							<select id="AREA" style="width: 435px;"></select>
						</div>
						<div class="boxed">
							<div class="sort" id="reg_se"></div>
							<select id="SYS_SE" style="width: 435px;"></select>
						</div>
						<div class="boxed">
							<div class="sort" id="stat"></div>
							<select id="RTN_STAT_CD" style="width: 435px;"></select>
						</div>
						<div class="btn_wrap line">
							<div class="fl_c">
								<button class="btn70 c1" style="width: 220px;" id="btn_sel">조회</button>
							</div>
						</div>
					</div>
				</div>
				<div class="contbox mt0 pb0" >
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
