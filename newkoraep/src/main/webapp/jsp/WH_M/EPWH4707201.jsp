<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>정산서 조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=1100, user-scalable=yes">

<%@include file="/jsp/include/common_page_m.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">
			
	var INQ_PARAMS;
	var stdMgntList;
	var excaSeList;
	var excaProcStatList;
	var bizrTpList;
	
	$(document).ready(function(){

		INQ_PARAMS       = jsonObject($('#INQ_PARAMS').val());
		stdMgntList      = jsonObject($('#stdMgntList').val());
		excaSeList       = jsonObject($('#excaSeList').val());
		excaProcStatList = jsonObject($('#excaProcStatList').val());
		bizrTpList       = jsonObject($('#bizrTpList').val());
		
		$('.sort').each(function(){
			$(this).text(fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
		});
		
		kora.common.setEtcCmBx2(stdMgntList, "","", $("#EXCA_STD_CD_SEL"), "EXCA_STD_CD", "EXCA_STD_NM", "N" ,'S');
		for(var k=0; k<stdMgntList.length; k++){ 
	    	if(stdMgntList[k].EXCA_STAT_CD == 'S'){
	    		$('#EXCA_STD_CD_SEL').val(stdMgntList[k].EXCA_STD_CD);
	    		break;
	    	}
	    }
		
	    kora.common.setEtcCmBx2(bizrTpList, "","", $("#BIZR_TP_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N" ,'T');
	    kora.common.setEtcCmBx2(excaSeList, "","", $("#EXCA_SE_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N" ,'T');
	    kora.common.setEtcCmBx2(excaProcStatList, "","", $("#EXCA_PROC_STAT_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N" ,'T');
		
	    //파라미터 조회조건으로 셋팅
		if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
			kora.common.jsonToTable("sel_params",INQ_PARAMS.SEL_PARAMS);
		}
	    
		//그리드 셋팅
		fn_set_grid();

		//정산서발급취소
		$("#btn_upd").click(function(){
			fn_upd();
		});
		
		//조회 버튼
		$("#btn_sel").click(function(){
			fn_sel();
			
			//조회조건 닫기
            $('#btn_manage').trigger('click');
		});
					
	});
	
	function fn_upd(){
		
		var EXCA_STD_CD_SEL = $("#EXCA_STD_CD_SEL option:selected").val();
		
		if(EXCA_STD_CD_SEL == ""){
			alert("정산기간을 선택하세요.");
			return;
		}
		
		for(var i=0; i<stdMgntList.length; i++){
			if(stdMgntList[i].EXCA_STD_CD == EXCA_STD_CD_SEL){
				if(stdMgntList[i].EXCA_STAT_CD != "S"){
					alert("진행 상태의 정산기간에 대해서만 발급 취소 처리가 가능합니다.");
					return;
				}
			}
		}
		
		confirm("해당 정산기간에 발급된 전체 정산서가 발급 취소됩니다.\n계속 진행하시겠습니까?", 'fn_upd_exec');
		
	}
	
	//상세화면 이동
	function link(){

		var idx = dataGrid.getSelectedIndices();
		var input = gridRoot.getItemAt(idx);
		
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH4707201.do"; 
		kora.common.goPage('/WH/EPWH4707264.do', INQ_PARAMS);
	}


	/**
	 * 목록조회
	 */
	function fn_sel(){

		if($('#EXCA_STD_CD_SEL').val() == '' ){
			alert('정산기간을 선택하세요.');
			return;
		}
		
		var input = {};
		input["EXCA_STD_CD_SEL"] = $("#EXCA_STD_CD_SEL").val();
		input["BIZR_TP_CD_SEL"] = $("#BIZR_TP_CD_SEL").val();
		input["BIZRNM_SEL"] = $("#BIZRNM_SEL").val();
		input["EXCA_SE_CD_SEL"] = $("#EXCA_SE_CD_SEL").val();
		input["EXCA_PROC_STAT_CD_SEL"] = $("#EXCA_PROC_STAT_CD_SEL").val();

		INQ_PARAMS["SEL_PARAMS"] = input;
		
		var url = "/WH/EPWH4707201_19.do";
		
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
		 
        rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%");
        layoutStr = new Array();
        layoutStr.push('<rMateGrid>');
        layoutStr.push('    <DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
        layoutStr.push('    <NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
        layoutStr.push('    <DataGrid id="dg1" autoHeight="true" minHeight="926" rowHeight="110" styleName="gridStyle" wordWrap="true" variableRowHeight="true">'); //truncateToFit="true"
        layoutStr.push('        <columns>');
        layoutStr.push('            <DataGridColumn dataField="EXCA_REG_DT_PAGE" width="50%" textAlign="center" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('issu_dt') + "&lt;br&gt;(" + fn_text('exca_amt')+ ")"+'"/>');     //발급일자, 정산금액
        layoutStr.push('            <DataGridColumn dataField="EXCA_SE_NM" width="50%" textAlign="center" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('exca_se') + "&lt;br&gt;" + fn_text('stat') + '"/>');    //정산구분, 상태
        layoutStr.push('        </columns>');
        layoutStr.push('    </DataGrid>');
        layoutStr.push('    <Style>');
        layoutStr.push('        .gridStyle {');
        layoutStr.push('            headerColors:#565862,#565862;');
        layoutStr.push('            headerStyleName:gridHeaderStyle;');
        layoutStr.push('            verticalAlign:middle;headerHeight:110;fontSize:28;backgroundColor:#ffffff');
        layoutStr.push('        }    ');
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
	    	dataGrid.addEventListener("change", selectionChangeHandler);
	    	 
	    	 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
			 	eval(INQ_PARAMS.FN_CALLBACK+"()");
			 }else{
				 gridApp.setData();
				 
				//조회조건 열기
                $('#btn_manage').trigger('click');
			 }
	    }
	    var dataCompleteHandler = function(event) {
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
    //          item : 해당 행의 data 객체
    //          value : 해당 셀의 라벨
    //          column : 해당 셀의 열을 정의한 Column 객체
    // 그리드 설정시 DataGridColumn 항목에 추가 (예: labelJsFunction="convertItem") 
    function convertItem(item, value, column) {
        
        var dataField = column.getDataField();
        
        if(dataField == "EXCA_REG_DT_PAGE") {
            return kora.common.formatter.datetime(item["EXCA_REG_DT_PAGE"], "yyyy-mm-dd") + "</br>(" + kora.common.format_comma(item["EXCA_AMT"]) +")";
        }
        else if(dataField == "EXCA_SE_NM") {
            return item["EXCA_SE_NM"] + "</br>(" + item["EXCA_PROC_STAT_NM"]+")";
        }
        else {
            return "";
        }
    }
</script>
</head>
<body>
<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="stdMgntList" value="<c:out value='${stdMgntList}' />"/>
<input type="hidden" id="excaSeList" value="<c:out value='${excaSeList}' />"/>
<input type="hidden" id="excaProcStatList" value="<c:out value='${excaProcStatList}' />"/>
<input type="hidden" id="bizrTpList" value="<c:out value='${bizrTpList}' />"/>

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
                    <div class="contbox v2">
                        <div class="boxed">
                            <div class="sort" id="exca_term_txt"></div>
                            <select id="EXCA_STD_CD_SEL" name="EXCA_STD_CD_SEL" style="width: 435px;" ></select>
                        </div>
                        <div class="boxed">
                            <div class="sort" id="exca_se_txt"></div>
                            <select style="width: 435px;" id="EXCA_SE_CD_SEL"></select>
                        </div>
                        <div class="boxed">
                            <div class="sort" id="stat_txt"></div>
                            <select style="width: 435px;" id="EXCA_PROC_STAT_CD_SEL"></select>
                        </div>
                        <div class="btn_wrap line">
                            <div class="fl_c">
                                <button class="btn70 c1" style="width: 220px;" id="btn_sel">조회</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row" style="display:none">
                    <div class="col" >
                        <div class="tit" id="bizr_se_txt"></div>
                        <div class="box">
                            <select id="BIZR_TP_CD_SEL" name="BIZR_TP_CD_SEL" style="width: 179px" ></select>
                        </div>
                    </div>
                    <div class="col" >
                        <div class="tit" id="bizr_nm_txt"></div>
                        <div class="box">
                            <input id="BIZRNM_SEL" name="BIZRNM_SEL" type="text" style="width: 179px;"  alt="" >
                        </div>
                    </div>
                </div>
                <div class="contbox v4 pb40 mt0">
                    <div class="tbl_board">
                        <div id="gridHolder"></div>
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
