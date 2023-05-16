<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>반환정보조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=1100, user-scalable=yes">

<%@include file="/jsp/include/common_page_m.jsp" %>

<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>
<script type="text/javaScript" language="javascript" defer="defer">

	var sumData; /* 총합계 추가 */

	 /* 페이징 사용 등록 */
	 gridRowsPerPage 	= 15;	// 1페이지에서 보여줄 행 수
	 gridCurrentPage 		= 1;	// 현재 페이지
	 gridTotalRowCount 	= 0;	//전체 행 수

	 var INQ_PARAMS;								//파라미터 데이터
     var toDay = kora.common.gfn_toDay(); 	// 현재 시간
     var list_set_cnt =0;
     var rtrvl_gtn_tot =0;							//그리드총 보증금합계
     var reg_rtrvl_fee_tot =0;						//그리드 소매수수료 총 합계
	 
     $(function() {
    	 
   		INQ_PARAMS 	= jsonObject($("#INQ_PARAMS").val()); //파라미터 데이터
  	  	
  	  	//기본셋팅
  	 	fn_init();
  	  	
	   	//그리드 셋팅
		fnSetGrid1();
		
		/************************************
		 * 조회 클릭 이벤트
		 ***********************************/
		$("#btn_sel").click(function(){
			//조회버튼 클릭시 페이징 초기화
			gridCurrentPage = 1;
			fn_sel();
		});
	 });
     
     //초기화
     function fn_init(){
			 
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
		$('.row > .col > .tit').each(function(){
			$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
		});
			
		//파라미터 조회조건으로 셋팅
		if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
			kora.common.jsonToTable("params",INQ_PARAMS.SEL_PARAMS);
			/* 화면이동 페이징 셋팅 */
			gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
    	}
		
        if($("#btn_onoff").attr("class") != "on") {
            $("#btn_onoff").click();
        }
    }
	  
	//회수정보관리 조회
    function fn_sel(){
		rtrvl_gtn_tot 	  =0;
		reg_rtrvl_fee_tot =0;
		var input	={};
		var url = "/RT/EPRT9025801_193.do" 
		var start_dt = $("#START_DT").val();
		var end_dt  = $("#END_DT").val();
		start_dt   	= start_dt.replace(/-/gi, "");
	 	end_dt    	= end_dt.replace(/-/gi, "");

		//날짜 정합성 체크. 20160204
		if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
			alert("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return; 
		}
		else if(start_dt>end_dt){
			alert("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return;
		} 
		 
		input["START_DT"] = $("#START_DT").val();			//날짜
		input["END_DT"]	  = $("#END_DT").val();			
		
		/* 페이징  */
		input["ROWS_PER_PAGE"]   = gridRowsPerPage;
		input["CURRENT_PAGE"] 	 = gridCurrentPage;
		INQ_PARAMS["SEL_PARAMS"] = input;
		
		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
		
      	ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {
                gridApp.setData(rtnData.selList);
                sumData = rtnData.totalList[0];

                /* 페이징 표시 */
                gridTotalRowCount = parseInt(sumData.CNT); //총 카운트
                drawGridPagingNavigation(gridCurrentPage);
                
                //AMT_TOT
                $("#RTRVL_QTY_TOT"    ).text(kora.common.format_comma(sumData.RTRVL_QTY_TOT));
                $("#RTRVL_GTN_TOT"    ).text(kora.common.format_comma(sumData.RTRVL_GTN_TOT));
                $("#REG_RTRVL_FEE_TOT").text(kora.common.format_comma(sumData.REG_RTRVL_FEE_TOT));
                $("#ATM_TOT"          ).text(kora.common.format_comma(sumData.ATM_TOT));
   			}
			else{
   				alert("error");
   			}
			
            if($("#btn_onoff").attr("class") == "on") {
                $("#btn_onoff").click();
            }
			
			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
   		});
    }
   
    /* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel(); //조회 펑션
	}
    
	//회수정보관리 상세
	function link(dataVal){
		var idx = dataGrid.getSelectedIndices();
		var input = gridRoot.getItemAt(idx);
		var url = "/RT/EPRT9025864.do";

		//파라미터에 조회조건값 저장 
		INQ_PARAMS["PARAMS"] = {};
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/RT/EPRT9025801.do";  
		kora.common.goPage(url, INQ_PARAMS);  
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
        layoutStr.push('    <DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
        layoutStr.push('    <NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
        layoutStr.push('    <DataGrid id="dg1" autoHeight="true" minHeight="210" rowHeight="110" styleName="gridStyle">'); //truncateToFit="true"
        layoutStr.push('        <columns>');
        layoutStr.push('            <DataGridColumn dataField="WHSDL_BIZRNM"  width="45%" textAlign="center" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('whsdl') + "&lt;br&gt;(" + fn_text('stat')+ ")"+'"/>');            //도매업자, 상태
        layoutStr.push('            <DataGridColumn dataField="RTRVL_REG_DT"  width="30%" textAlign="center" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('rtn_reg_dt') + "&lt;br&gt;(" + fn_text('rtn_qty2') + ")"+ '"/>'); //등록일자, 반환량
        layoutStr.push('            <DataGridColumn dataField="RTRVL_GTN_TOT" width="25%" textAlign="center" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('dps2') + "&lt;br&gt;(" + fn_text('rtl_fee2') + ")"+ '" />');      //보증금, 소매수수료
        layoutStr.push('        </columns>');
        layoutStr.push('    </DataGrid>');
        layoutStr.push('    <Style>');
        layoutStr.push('        .gridStyle {');
        layoutStr.push('            headerColors:#565862,#565862;');
        layoutStr.push('            headerStyleName:gridHeaderStyle;');
        layoutStr.push('            verticalAlign:middle;headerHeight:110;fontSize:28;');
        layoutStr.push('        }    ');
        layoutStr.push('        .gridHeaderStyle {');
        layoutStr.push('            color:#ffffff;');
        layoutStr.push('            fontWeight:bold;');
        layoutStr.push('            horizontalAlign:center;');
        layoutStr.push('            verticalAlign:middle;');
        layoutStr.push('        }');
        layoutStr.push('    </Style>');
        layoutStr.push('</rMateGrid>');
	};

	/**
	 * 조회기준-생산자 그리드 이벤트 핸들러
	 */
	function gridReadyHandler(id) {
		gridApp = document.getElementById(id); // 그리드를 포함하는 div 객체
		gridRoot = gridApp.getRoot(); // 데이터와 그리드를 포함하는 객체
		gridApp.setLayout(layoutStr.join("").toString());
		gridApp.setData();
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
		gridApp.setData([]);
	}
	
    // labelJsFunction 기능을 이용하여 Quarter 컬럼에 월 분기 표시를 함께 넣어줍니다.
    // labelJsFunction 함수의 파라메터는 다음과 같습니다.
    // function labelJsFunction(item:Object, value:Object, column:Column)
    //          item : 해당 행의 data 객체
    //          value : 해당 셀의 라벨
    //          column : 해당 셀의 열을 정의한 Column 객체
    // 그리드 설정시 DataGridColumn 항목에 추가 (예: labelJsFunction="convertItem") 
    function convertItem(item, value, column) {
        
        var dataField = column.getDataField();
        
        if(dataField == "WHSDL_BIZRNM") {
            return item["WHSDL_BIZRNM"] + "</br>(" + item["RTRVL_STAT_NM"]+")";
        }
        else if(dataField == "RTRVL_REG_DT") {
            return kora.common.formatter.datetime(item["RTRVL_REG_DT"], "yyyy-mm-dd") + "</br>(" + kora.common.format_comma(item["RTRVL_QTY_TOT"])+")";
        }
        else if(dataField == "RTRVL_GTN_TOT") {
            return kora.common.format_comma(item["RTRVL_GTN_TOT"]) + "</br>(" + kora.common.format_comma(item["REG_RTRVL_FEE_TOT"]) +")";
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
    <div id="wrap">
        <%@include file="/jsp/include/header_m.jsp" %>
        
        <%@include file="/jsp/include/aside_m.jsp" %>

        <div id="container">

            <div id="subvisual">
                <h2 class="tit" id="title"></h2>
            </div><!-- id : subvisual -->

            <div id="contents">
                <div class="btn_manage">
                    <button type="button" id="btn_onoff"></button>
                </div>
                <div class="manage_wrap" id="params">
                    <div class="contbox">
                        <div class="boxed">
                            <div class="sort">조회기간</div>
                        </div>
                        <div class="boxed">
                            <input type="text" id="START_DT" name="from" style="width: 285px;" readonly>
                            <span class="swung">~</span>
                            <input type="text" id="END_DT" name="to" style="width: 285px;" readonly>
                        </div>
                        <div class="btn_wrap line">
                            <div class="fl_c">
                                <button type="button" class="btn70 c1" style="width: 220px;" id="btn_sel">조회</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="contbox mt0 pb30">
                    <div id="tableView" class="table_view">
                        <div class="slick-wrap">
                            <div class="tbl_slide">
                                <table>
                                    <colgroup>
                                        <col style="width: 265px;">
                                        <col style="width: auto;">
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th>반환량</th>
                                            <td><span id="RTRVL_QTY_TOT"></span></td>
                                        </tr>
                                        <tr>
                                            <th>보증금</th>
                                            <td><span id="RTRVL_GTN_TOT"></span></td>
                                        </tr>
                                        <tr>
                                            <th>소매수수료</th>
                                            <td><span id="REG_RTRVL_FEE_TOT"></span></td>
                                        </tr>
                                        <tr>
                                            <th class="red">총</th>
                                            <td class="red"><span id="ATM_TOT"></span></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="contbox v4 pb40 mt20">
                    <div class="tbl_board">
                        <div id="gridHolder"></div>
                    </div>
                    <div class="pagination mt20">
                        <div class="paging">
                            <div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
                        </div>
                    </div>
                </div>
                
                <script>newriver.manageAction();</script>
            </div><!-- id : contents -->
        </div><!-- id : container -->        
        <%@include file="/jsp/include/footer_m.jsp" %>
    </div><!-- id : wrap -->
</body>
</html>
