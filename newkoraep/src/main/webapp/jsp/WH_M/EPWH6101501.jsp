<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>출고현황</title>
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

	var sumData; /* 총합계 추가 */

	var INQ_PARAMS = []; //파라미터 데이터

	/* 페이징 사용 등록 */
	gridRowsPerPage = 10;	// 1페이지에서 보여줄 행 수
	gridCurrentPage = 1;		// 현재 페이지
	gridTotalRowCount = 0; 	//전체 행 수

	 var pagingCurrent = 1;
	 
    $(function() {
    	 
    	$('.btn_manage button').click();
    	
    	//버튼 셋팅
    	fn_btnSetting();
    	
    	$('.row > .col > .tit').each(function(){
			$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
		});
    	
    	//그리드 셋팅
		fnSetGrid1();
		
		var prpsCdList = ${prpsCdList};
		var mfcBizrList = ${mfcBizrList};
		var whsdlBizrList = ${whsdlBizrList};
		var ctnrNmList = ${ctnrNmList};
    	
		kora.common.setEtcCmBx2(prpsCdList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');
		kora.common.setEtcCmBx2(ctnrNmList, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'T');
		kora.common.setEtcCmBx2(mfcBizrList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'T');	
		kora.common.setEtcCmBx2(whsdlBizrList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N");
    	 
		//날짜 셋팅
	    $('#START_DT').YJdatepicker({
	         periodTo : '#END_DT',
	         initDate : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
	    });
	    $('#END_DT').YJdatepicker({
	         periodFrom : '#START_DT',
	         initDate : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
	    });
			
		/************************************
		 * 시작날짜  클릭시 - 삭제 변경 이벤트
		 ***********************************/
		$("#START_DT").click(function(){
			    var start_dt = $("#START_DT").val();
			     start_dt   =  start_dt.replace(/-/gi, "");
			     $("#START_DT").val(start_dt)
		});
		
		/************************************
		 * 시작날짜  클릭시 - 추가 변경 이벤트
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
		 * 끝날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		$("#END_DT").change(function(){
		     var end_dt  = $("#END_DT").val();
		           end_dt =  end_dt.replace(/-/gi, "");
			if(end_dt.length == 8)  end_dt = kora.common.formatter.datetime(end_dt, "yyyy-mm-dd")
		     $("#END_DT").val(end_dt) 
		});

		
		/************************************
		 * 생산자 구분 변경 이벤트
		 ***********************************/
		$("#MFC_BIZRNM").change(function(){
			fn_mfc_bizrnm();
		});
		
		/************************************
		 * 용도 변경 이벤트
		 ***********************************/
		$("#PRPS_CD").change(function(){
			fn_prps_cd();
		});
		
  		//$("#WHSDL_BIZRNM").select2();
  		
  		$("#btn_sel").click(function(){
  			//조회버튼 클릭시 페이징 초기화
			gridCurrentPage = 1;
			fn_sel("Y"); //조회버튼 클릭 시 챠트조회
			$('.btn_manage button').click();
		});
  		
	});

    //용도 변경시 빈용기명 조회
    function fn_prps_cd(){
		var url = "/WH/EPWH6101501_193.do" 
		var input ={};
		
	    input["PRPS_CD"] =$("#PRPS_CD").val();
	    
	    if( $("#MFC_BIZRNM").val() !="" ){ //생산자 선택시 해당 빈용기만 조회
  			input["MFC_BIZRID"]		= arr[0];
  			input["MFC_BIZRNO"]		= arr[1];
	    }
		if($("#WHSDL_BIZRNM").val() !=""){	 //도매업자 선택시
		 	input["CUST_BIZRID"] 		= arr2[0];
			input["CUST_BIZRNO"] 	= arr2[1];
		 } 

     	ajaxPost(url, input, function(rtnData) {
  				if ("" != rtnData && null != rtnData) {  
  					 	kora.common.setEtcCmBx2(rtnData.ctnr_cd, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'T');		 //빈용기명
  				}else{
  						 alert("error");
  				}
  		 },false);

    }
    
  	//생산자 변경시 생산자랑 거래중인 도매업자 조회 
    function fn_mfc_bizrnm(){
 			var url 		= "/WH/EPWH6101501_192.do" 
 			var input 	= {};
 			
 			input["PRPS_CD"] =$("#PRPS_CD").val();
 			
 			if($("#MFC_BIZRNM").val() == ""){ 	//생산자 전체로 검색시
 				input["MFC_BIZRID"]	= "";  
 	  			input["MFC_BIZRNO"]	= "";
 		   }else{
	  			arr	 =[];
	   			arr	 = $("#MFC_BIZRNM").val().split(";");
	   			input["MFC_BIZRID"]	= arr[0];  
	   			input["MFC_BIZRNO"]	= arr[1];
 		   }

        	ajaxPost(url, input, function(rtnData) {
     				if ("" != rtnData && null != rtnData) {   
     					kora.common.setEtcCmBx2(rtnData.ctnr_cd, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'T');	//빈용기명
     				}else{
     					alert("error");
     				}
     		},false);
    }

    /* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel(); //조회 펑션
	}
    
    /**
	 * 목록조회
	 */
	function fn_sel(chartYn){
    	
		var url = "/WH/EPWH6101501_19.do";
		var input = {};
		
		input['START_DT'] = $("#START_DT").val();
		input['END_DT'] = $("#END_DT").val();
		input['MFC_BIZRNM'] = $("#MFC_BIZRNM option:selected").val();
		input['WHSDL_BIZRNM'] = $("#WHSDL_BIZRNM option:selected").val();
		input['PRPS_CD'] = $("#PRPS_CD option:selected").val();
		input['CTNR_CD'] = $("#CTNR_CD option:selected").val();
		
		input['CHART_YN'] = chartYn;

		/* 페이징  */
		input["ROWS_PER_PAGE"] = gridRowsPerPage;
		input["CURRENT_PAGE"] 	= gridCurrentPage;
		
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["SEL_PARAMS"] = input;
		
		hideMessage();
		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != ""){
				gridApp.setData(rtnData.searchList);
				
			 	if(chartYn == "Y"){ //조회버튼 클릭 시 챠트조회
					
					/* if(rtnData.searchList2 == undefined || rtnData.searchList2.length == 0){
						chartApp.setData(chartData);
					}else{
						chartApp.setData(rtnData.searchList2);
					} */
					
					var prps0 = 0;
					var prps1 = 0;
					var prps2 = 0;
					var dlivyQty = 0;
					
					for(var i in rtnData.searchList2){
						prps0 += Number(rtnData.searchList2[i].PRPS0);
						prps1 += Number(rtnData.searchList2[i].PRPS1);
						//prps2 += Number(rtnData.searchList2[i].PRPS2);
						dlivyQty += Number(rtnData.searchList2[i].DLIVY_QTY);
					}
					
					$('#PRPS0').text(kora.common.format_comma(prps0));
					$('#PRPS1').text(kora.common.format_comma(prps1));
					//$('#PRPS2').text(kora.common.format_comma(prps2));
					$('#DLIVY_QTY').text(kora.common.format_comma(dlivyQty));
					
				}
				
				/* 페이징 표시 */
				gridTotalRowCount = parseInt(rtnData.totalList[0].CNT); //총 카운트 	/* 총합계 추가 */
				drawGridPagingNavigation(gridCurrentPage);
				
				sumData = rtnData.totalList[0]; /* 총합계 추가 */
				
				if (rtnData.searchList.length == 0) {
					showMessage();	
				} 
				
			} else {
				alert("error");
			}
			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
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
	 function fnSetGrid1(reDrawYn) {
			rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%");

			layoutStr = new Array();
			layoutStr.push('<rMateGrid>');
			layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr.push('     <DataGrid id="dg1" autoHeight="true" minHeight="310" rowHeight="110" styleName="gridStyle" textAlign="center" wordWrap="true" variableRowHeight="true">');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridColumn dataField="BIZRNM"	labelJsFunction="convertItem1"	headerText="'+ parent.fn_text('mfc_bizrnm')+ "&lt;br&gt;(" + parent.fn_text('ctnr_nm') + ')"  	itemRenderer="HtmlItem" textAlign="center" width="200" />'); 	//반환등록일자
			layoutStr.push('			<DataGridColumn dataField="EXCA_DLIVY_QTY" 	headerText="'+ parent.fn_text('exca_dlivy_qty')+ '" 	width="100" 	textAlign="right"    formatter="{numfmt}" id="sum3" />');
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('	</DataGrid>');
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
			gridApp.setData();
			drawGridPagingNavigation(gridCurrentPage);  //페이징 표시
		}
		var dataCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
		}
		var selectionChangeHandler = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			selectorColumn = gridRoot.getObjectById("selector");
			rowIndexValue = rowIndex;
		
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	}	
	
	/* 총합계 추가 */
	function totalsum1(column, data) {
		if(sumData) 
			return sumData.DLIVY_QTY; 
		else 
			return 0;
	}
	function totalsum2(column, data) {
		if(sumData) 
			return sumData.CRCT_DLIVY_QTY; 
		else 
			return 0;
	}
	function totalsum3(column, data) {
		if(sumData) 
			return sumData.EXCA_DLIVY_QTY; 
		else 
			return 0;
	}
	/* 총합계 추가 */
	
	function convertItem1(item, value, column) {
	    var value1 = kora.common.null2void(item["BIZRNM"]);
	    var value2 = kora.common.null2void(item["CTNR_NM"]);
	    
	    var result;
	    if( value2 == ''){
	    	result  = value1;	
	    }else{
	    	result  = value1 + "</BR>(" + value2 + ")";
	    }
	    
	    return result;
	}
	
	/****************************************** 그리드 셋팅 끝***************************************** */
</script>

<style type="text/css">
</style>

</head>
<body>

		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
		<input type="hidden" id="stat_cd_list" value="<c:out value='${stat_cd_list}' />" />
		
	<div id="wrap">
	
		<%@include file="/jsp/include/header_m.jsp" %>
		
		<%@include file="/jsp/include/aside_m.jsp" %>

		<div id="container">

			<div id="subvisual">
				<h2 class="tit">제품매입현황</h2>
			</div><!-- id : subvisual -->

			<div id="contents">
				<div class="btn_manage">
					<button type="button" id="btn_manage"></button>
				</div>
				<div class="manage_wrap">
					<div class="contbox">
						<div class="boxed">
							<div class="sort">조회기간</div>
                            <div class="cont" style="font-size:28px;color:#222222;">출고일자 기준</div>
						</div>
						<div class="boxed">
							<input type="text" id="START_DT" style="width: 285px;" readonly>
							<span class="swung">~</span>
							<input type="text" id="END_DT" style="width: 285px;" readonly>
							<div class="btn_wrap ml10">
								<button type="button" class="btn63 c1" style="width: 110px;">조회</button>
							</div>
						</div>
					</div>
					<div class="contbox v2">
						<div class="boxed">
							<div class="sort">용도</div>
							<select style="width: 435px;" id="PRPS_CD"></select>
						</div>
						<div class="boxed">
							<div class="sort">빈용기명</div>
							<select style="width: 435px;" id="CTNR_CD"></select>
						</div>
						<div class="boxed">
							<div class="sort">생산자</div>
							<select style="width: 435px;" id="MFC_BIZRNM"></select>
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
										<col style="width: 260px;">
										<col style="width: auto;">
									</colgroup>
									<tbody>
										<tr>
											<td>유흥용</td>
											<td id="PRPS0"></td>
										</tr>
										<tr>
											<td>가정용</td>
											<td id="PRPS1"></td>
										</tr>
										<tr>
											<td class="bold c_01">총</td>
											<td class="bold c_01" id="DLIVY_QTY"></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
				<div class="tblbox">
					<div class="tbl_inquiry v2">
						<div class="tbl_board">
							<div id="gridHolder" style="height:200px;"></div>
						</div>
						<div class="pagination mt20">
							<div class="paging">
								<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
							</div>
						</div>
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