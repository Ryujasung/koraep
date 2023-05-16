<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>회수증빙자료관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=1100, user-scalable=yes">

<%@include file="/jsp/include/common_page_m.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">

    var INQ_PARAMS;
    var whsdl_cd_list;		//도매업자
    var parent_item;

    $(function() {
		
        INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
    	whsdl_cd_list = jsonObject($('#whsdl_cd_list').val());

    	//기본 셋팅
    	fn_init();
    	
    	//그리드 셋팅
		fnSetGrid1();
		 
		/************************************
		 * 조회버튼 클릭 이벤트
		 ***********************************/
		$("#btn_sel").click(function(){
			fn_sel();

			//조회조건 닫기
            $('#btn_manage').trigger('click');
		});
		
		/************************************
		 * 취소 클릭 이벤트
		 ***********************************/
		$("#btn_cnl").click(function(){
		    fn_lst();
		});
		
		/************************************
		 * 등록 클릭 이벤트
		 ***********************************/
		$("#btn_page").click(function(){
			fn_page();
		});
		
        /************************************
         * 목록 클릭 이벤트
         ***********************************/
        $("#btn_lst").click(function(){
            fn_lst();
        });
	});
     
    function fn_init(){
    	 
	    kora.common.setEtcCmBx2(whsdl_cd_list, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N");		 //업체명
	 	
        //날짜 셋팅
        $('#START_DT').YJdatepicker({
             periodTo : '#END_DT',
             initDate : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
        });
        $('#END_DT').YJdatepicker({
             periodFrom : '#START_DT',
             initDate : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
        });
	 	
		$('#sel_term_txt').text(parent.fn_text('sel_term'));					  			  //조회기간
		
		//div필수값 alt
		$("#START_DT").attr('alt',parent.fn_text('sel_term'));   
		$("#END_DT").attr('alt',parent.fn_text('sel_term'));   
    }
     

	//조회
    function fn_sel(){
	    var input	={};
		var url = "/WH/EPWH2925897_19.do" 
		var start_dt = $("#START_DT").val();
		var end_dt   = $("#END_DT").val();
		var arr 	 = new Array();	//업체명 split
		start_dt     = start_dt.replace(/-/gi, "");
	 	end_dt    	 = end_dt.replace(/-/gi, "");
	
		//날짜 정합성 체크. 20160204
		if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
			alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
		    return; 
		}
		else if(start_dt>end_dt){
		    alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return;
		} 
		
		if($("#WHSDL_BIZRNM").val() !="" ){	//도매업자
            arr		=[];
			arr	= $("#WHSDL_BIZRNM").val().split(";");
			input["WHSDL_BIZRID"] = arr[0];
			input["WHSDL_BIZRNO"] = arr[1]; 
		}
		
		input["START_DT"]	  = $("#START_DT").val();			 //날짜
		input["END_DT"]		  = $("#END_DT").val();		
		input["WHSDL_BIZRNM"] = $("#WHSDL_BIZRNM").val(); //도매업자선택

		INQ_PARAMS["SEL_PARAMS"] = input;
		kora.common.showLoadingBar(dataGrid, gridRoot);
      	ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {
				gridApp.setData(rtnData.selList);
				/* 페이징 표시 */
				gridTotalRowCount = rtnData.totalCnt; //총 카운트
			} else {
				alertMsg("error");
			}
			
			kora.common.hideLoadingBar(dataGrid, gridRoot);
   		});
	}
	
    //목록
    function fn_lst(){
        kora.common.goPageB('', INQ_PARAMS);
    }
 	
    //회수증빙자료등록
	function fn_page(){
		//파라미터에 조회조건값 저장 
        var arr = $("#WHSDL_BIZRNM").val().split(";");  //도매업자 
        var input = {}; 
        input["WHSDL_BIZRID"]           = arr[0]; 
        input["WHSDL_BIZRNO"]           = arr[1];
		
        INQ_PARAMS["WHSDL"] = input;
        INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
        INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH2925897.do";
        kora.common.goPage('/WH/EPWH2925888.do', INQ_PARAMS);
	}
   	
    //회수증빙자료다운로드
	function link(){
		var idx 	= dataGrid.getSelectedIndices();
		var input	= gridRoot.getItemAt(idx);
		
		console.log(JSON.stringify(input));

		INQ_PARAMS["WHSDL"] = input;
        INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
        INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH2925897.do";
        kora.common.goPage('/WH/EPWH29258882.do', INQ_PARAMS);
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
        layoutStr.push('    <NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
        layoutStr.push('    <DataGrid id="dg1" autoHeight="true" minHeight="550" rowHeight="100" styleName="gridStyle" textAlign="center">');
        layoutStr.push('        <columns>');
        layoutStr.push('            <DataGridColumn dataField="RTRVL_DT" labelJsFunction="convertItem" headerText="'+ fn_text('rtrvl_dt2')+ "&lt;br&gt;(" + fn_text('prf_reg_dt') + ')" itemRenderer="HtmlItem" width="34%" textAlign="center"/>');
        layoutStr.push('            <DataGridColumn dataField="FILE_NM" labelJsFunction="convertItem" headerText="'+ fn_text('prf_file')+ '" itemRenderer="HtmlItem" width="80%" textAlign="left" verticalAlign="middle" />');
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
            
            //파라미터 call back function 실행
            if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
               eval(INQ_PARAMS.FN_CALLBACK+"()");
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
            rowIndexValue = rowIndex;
        }
        gridRoot.addEventListener("dataComplete", dataCompleteHandler);
        gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
    }

    // labelJsFunction 기능을 이용하여 Quarter 컬럼에 월 분기 표시를 함께 넣어줍니다.
    // labelJsFunction 함수의 파라메터는 다음과 같습니다.
    // function labelJsFunction(item:Object, value:Object, column:Column)
    //        item : 해당 행의 data 객체
    //        value : 해당 셀의 라벨
    //        column : 해당 셀의 열을 정의한 Column 객체
    // 그리드 설정시 DataGridColumn 항목에 추가 (예: labelJsFunction="convertItem") 
    function convertItem(item, value, column) {
        
        var dataField = column.getDataField();
        
        if(dataField == "RTRVL_DT") {
            return kora.common.formatter.datetime(item["RTRVL_DT"], "yyyy-mm-dd") + "</br>(" + kora.common.formatter.datetime(item["REG_DTTM"], "yyyy-mm-dd") + ")";
        }
        else if(dataField == "FILE_NM") {
            return item["FILE_NM"];
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
    <input type="hidden" id="whsdl_cd_list" value="<c:out value='${whsdl_cd_list}' />"/>

    <div id="wrap">
    
        <%@include file="/jsp/include/header_m.jsp" %>
        
        <%@include file="/jsp/include/aside_m.jsp" %>

        <div id="container">

            <div id="subvisual">
                <h2 class="tit" id="title"></h2>
                <button class="btn_back" id="btn_lst"><span class="hide">뒤로가기</span></button>
            </div><!-- id : subvisual -->

            <div id="contents">
                <div class="btn_manage">
                    <button type="button" id="btn_manage"></button>
                </div>
                <div class="manage_wrap">
                    <div class="contbox">
                        <div class="boxed">
                            <div class="sort" id="sel_term_txt"></div>
                            <div class="row" style="display:none">
                                    <select id="WHSDL_BIZRNM" style=""></select>
                            </div>
                        </div>
                        <div class="boxed">
                            <input type="text" id="START_DT" style="width: 285px;" readonly>
                            <span class="swung">~</span>
                            <input type="text" id="END_DT" style="width: 285px;" readonly>
                            
                        </div>
                        <div class="btn_wrap line">
                            <div class="fl_c">
                                <button type="button" class="btn70 c1" style="width: 220px;" id="btn_sel">조회</button>
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
                    <div class="btn_wrap" style="height:50px">
                        <button class="btn70 c1" id="btn_cnl" style="width: 120px;">취소</button>
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