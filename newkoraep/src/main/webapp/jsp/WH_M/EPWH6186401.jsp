<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>회수대비초과반환현황</title>
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
	 gridRowsPerPage = 15;// 1페이지에서 보여줄 행 수
	 gridCurrentPage = 1;// 현재 페이지
	 gridTotalRowCount = 0;//전체 행 수
	 
	 var INQ_PARAMS; //파라미터 데이터
	 var areaList;

    $(function() {
	     INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
	     areaList = jsonObject($("#areaList").val());
	     
	     kora.common.setEtcCmBx2(areaList, "","", $("#AREA_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N" ,'T');
	     
	   	//날짜 셋팅
	    $('#START_DT').YJdatepicker({
	         periodTo : '#END_DT',
	         initDate : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
	    });
	    $('#END_DT').YJdatepicker({
	         periodFrom : '#START_DT',
	         initDate : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
	    });
	     
	  	//text 셋팅
		$('.contbox .boxed .sort').each(function(){
			if($(this).attr('id') != ''){
				$(this).html(fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt')) ) );
			}
		});
	    
    	 //그리드 셋팅
		 fnSetGrid1();

		/************************************
		 * 조회 클릭 이벤트
		 ***********************************/
		$("#btn_sel").click(function(){
			//조회버튼 클릭시 페이징 초기화
			gridCurrentPage = 1;
			fn_sel("Y");
		});
		
	});
          
   //조회
    function fn_sel(chartYN, page){
			var input	={};
			var url = "/WH/EPWH6186401_192.do" 
			if(page !="P"){
				var start_dt = $("#START_DT").val().replace(/-/gi, "");
				var end_dt = $("#END_DT").val().replace(/-/gi, "");
			    
				//날짜 정합성 체크
				if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
					alert("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
					return; 
				}else if(start_dt>end_dt){
					alert("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
					return;
				} 
				
				input["OVER_DIV"] = $("#OVER_DIV option:selected").val();
			 	
				//조회 SELECT변수값
				input["START_DT"] = $("#START_DT").val();			
				input["END_DT"]	= $("#END_DT").val();	
				input["AREA_CD"] = $("#AREA_CD_SEL").val();//지역
				input["CHART_YN"] = chartYN;
				INQ_PARAMS["SEL_PARAMS"] = input;
				
			}else{
				input = INQ_PARAMS["SEL_PARAMS"];
			}
			
			/* 페이징  */
			input["ROWS_PER_PAGE"] = gridRowsPerPage;
			input["CURRENT_PAGE"] = gridCurrentPage;
			
			hideMessage();
			kora.common.showLoadingBar(dataGrid, gridRoot);
	   	   	ajaxPost(url, input, function(rtnData) {
				if ("" != rtnData && null != rtnData) {   
					gridApp.setData(rtnData.selList);
					/*
					if(chartYN =="Y"){
						//if(rtnData.selList_chart.length)
						 	if(rtnData.selList_chart.length>0){
							chartApp.setData(rtnData.selList_chart);
							}else{
								chartApp.setData(chartData);
							}		 
					}
					*/
					
					var rtrvl_m_tot = 0;			//회수 유흥
					var rtrvl_h_tot = 0;			//회수 가정
					var r_m_tot = 0;				//반환 유흥
					var r_h_tot = 0;				//반환 가정
					var r_d_tot = 0;				//반환 직접
					
					for(var i in rtnData.selList_chart){
						rtrvl_m_tot += Number(rtnData.selList_chart[i].RTRVL_M);
						rtrvl_h_tot += Number(rtnData.selList_chart[i].RTRVL_H); 
						r_m_tot += Number(rtnData.selList_chart[i].CFM_M);
						r_h_tot += Number(rtnData.selList_chart[i].CFM_H);
					}
					
					$('#RTRVL_H_TOT').text(kora.common.format_comma(rtrvl_h_tot));
					$('#RTRVL_M_TOT').text(kora.common.format_comma(rtrvl_m_tot));
					$('#R_M_TOT').text(kora.common.format_comma(r_m_tot));
					$('#R_H_TOT').text(kora.common.format_comma(r_h_tot));
					$('#M_TOT').text(kora.common.format_comma(rtrvl_m_tot-r_m_tot));
					$('#H_TOT').text(kora.common.format_comma(rtrvl_h_tot-r_h_tot));
					
					/* 페이징 표시 */
					if(rtnData.selList != undefined && rtnData.selList != null && rtnData.selList.length !=0) gridTotalRowCount = rtnData.selList[0].TOTALCOUNT; //총 카운트 
					drawGridPagingNavigation(gridCurrentPage);
			
					if (rtnData.selList.length == 0) {
						showMessage();	
					} 
				}else{
					alert("error");
				}
				kora.common.hideLoadingBar(dataGrid, gridRoot);
				
				//조회조건 열기
				$('#btn_manage').trigger('click');
			}); 
    }
   
    /* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel("F","P"); //조회 펑션
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
			layoutStr.push('	<DataGrid id="dg1" autoHeight="true" minHeight="550" rowHeight="110" styleName="gridStyle" textAlign="center" wordWrap="true" variableRowHeight="true">');
			layoutStr.push('		<columns>');
			layoutStr.push('			<DataGridColumn dataField="AREA_CD" headerText="'+ parent.fn_text('area')+ '" width="20%" verticalAlign="middle" />');
			layoutStr.push('			<DataGridColumn dataField="RTRVL_TOT" labelJsFunction="convertItem" headerText="'+ parent.fn_text('rtrvl_qty2')+ "&lt;br&gt;(" + parent.fn_text('rtn_qty2') + ')" itemRenderer="HtmlItem" width="40%" textAlign="right"/>');
			layoutStr.push('			<DataGridColumn dataField="RTRVL_CPR_RTRVL_TOT" labelJsFunction="convertItem" headerText="'+ parent.fn_text('rtrvl_cpr_rtn_qty')+ "&lt;br&gt;(" + parent.fn_text('rtrvl_cpr_rtn_rt') + ')" itemRenderer="HtmlItem" width="40%" textAlign="right"/>');
			layoutStr.push('		</columns>');
			layoutStr.push('   	<dataProvider>');
		    layoutStr.push('    		<SpanArrayCollection source="{$gridData}"/>');
		    layoutStr.push('   	</dataProvider>');
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
			
	}

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
			
			//조회조건 열기
			$('#btn_manage').trigger('click');
		}
		var dataCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			setSpanAttributes(); 
		}
		var selectionChangeHandler = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			rowIndexValue = rowIndex;
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
		
		if(dataField == "RTRVL_TOT") {
			return kora.common.format_comma(item["RTRVL_TOT"]) + "</br>(" + kora.common.format_comma(item["CFM_TOT"]) + ")";
		}
		else if(dataField == "RTRVL_CPR_RTRVL_TOT") {
			return kora.common.format_comma(item["RTRVL_CPR_RTRVL_TOT"]) + "</br>(" + item["RTRVL_CPR_RTRVL_RT"] + ")";
		}
		else {
			return "";
		}
	}
	
	/****************************************** 그리드 셋팅 끝***************************************** */
	
	/**
	 * 그리드 상태 및 비밀번호변경 건 스타일 처리
	 */
	 
 	//그리드 데이터 객체
	 function setSpanAttributes() {
	 	var collection = gridRoot.getCollection();
	    if (collection == null) {
	        alert("collection 객체를 찾을 수 없습니다");
	        return;
	    } 
	    for (var i = 0; i < collection.getLength(); i++) {
	    	var data = gridRoot.getItemAt(i).RTRVL_CPR_RTRVL_RT;
	    	
	    	if( (data >= 80 && data < 90  )|| (data >= 110 && data < 120) ){  //  
	    		//console.log("1 :  "+data   +'   :  ' +   i )
		       	collection.addRowAttributeDetailAt(i, null, "#5587ED", null, false, 20);	//파랑   90 >s  >= 80     ,    120 > s > =110       
	    	} else if((data >= 70 && data < 80) || (data >= 120 && data < 130) ){
	    		//console.log("2 :  "+data +'   :  ' +   i  )
		      	collection.addRowAttributeDetailAt(i, null, "#FFCC00", null, false, 20); //노랑  80 > s >= 70     ,    130 > s >= 120
	    	} else if(data < 70 || data >= 130){ 
	    		//console.log("3 :  "+data +'   :  ' +   i  )
		       	collection.addRowAttributeDetailAt(i, null, "#F15F5F", null, false, 20);   //빨강    70>s     ,         130 > s
	    	}   																								   // 90 ~ 109  아무것도 없다
	    }   
	}
	


</script>

</head>
<body>

  	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
  	<input type="hidden" id="areaList" value="<c:out value='${areaList}' />" />

	<div id="wrap">
	
		<%@include file="/jsp/include/header_m.jsp" %>
		
		<%@include file="/jsp/include/aside_m.jsp" %>

		<div id="container">

			<div id="subvisual">
				<h2 class="tit" id="title"></h2>
			</div><!-- id : subvisual -->

			<div id="contents">
				<div class="btn_manage">
					<button type="button" id="btn_manage"></button>
				</div>
				<div class="manage_wrap">
					<div class="contbox">
						<div class="boxed">
							<div class="sort" id="sel_term_txt"></div>
                            <div class="cont" style="font-size:28px;color:#222222;">회수일자, 반환일자 기준</div>
						</div>
						<div class="boxed">
							<input type="text" id="START_DT" style="width: 285px;" readonly>
							<span class="swung">~</span>
							<input type="text" id="END_DT" style="width: 285px;" readonly>
						</div>
					</div>
					<div class="contbox v2">
						<div class="boxed">
							<div class="sort" id="cpr_qty_sel_txt"></div>
							<select style="width: 435px;" id="OVER_DIV">
								<option value="">전체</option>
								<option value="1">가정용</option>
								<option value="2">유흥용</option>
							</select>
						</div>
						<div class="boxed">
							<div class="sort" id="area_txt"></div>
							<select style="width: 435px;" id="AREA_CD_SEL">
							</select>
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
										<col style="width: 200px;">
										<col style="width: 200px;">
										<col style="width: auto;">
									</colgroup>
									<tbody>
										<tr>
											<th>구분</th>
											<th>유흥용</th>
											<th>가정용</th>
										</tr>
										<tr>
											<th>회수</th>
											<td id="RTRVL_M_TOT" style="border-right:none;text-align:right">&nbsp;</td>
											<td id="RTRVL_H_TOT" >&nbsp;</td>
										</tr>
										<tr>
											<th>반환</th>
											<td id="R_M_TOT" style="border-right:none;text-align:right">&nbsp;</td>
											<td id="R_H_TOT" >&nbsp;</td>
										</tr>
										<tr>
											<th >총</th>
											<td  id="M_TOT" style="border-right:none;text-align:right">&nbsp;</td>
											<td  id="H_TOT" >&nbsp;</td>
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