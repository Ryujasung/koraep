<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>등록일자제한설정</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

     var work_se_list;		//업무구분
     var rtc_dt_se_list;    //제한일자구분
     var rtc_dt_se_list2;  //제한일자구분
     var selList;
     var input ={};
     
	$(function() {
		
		work_se_list		=  jsonObject($("#work_se_list").val());
		selList			=  jsonObject($("#selList").val());     
		rtc_dt_se_list	=  jsonObject($("#rtc_dt_se_list").val());  
		rtc_dt_se_list2	=  jsonObject($("#rtc_dt_se_list").val());    
		
		//초기설정
		fn_init();		
		
		//그리드설정
		fnSetGrid1(); 
		
		//버튼 셋팅
		fn_btnSetting();
		
		//fn_sel();//조회
		
		/************************************
		 * 저장버튼 클릭 이벤트
		 ***********************************/
		$("#btn_reg").click(function(){
			fn_reg();
		});
		/************************************
		 * 업무구분 변경 이벤트
		 ***********************************/
		$("#WORK_SE").change(function(){
			$("#RTC_ST_SE").val("");
			$("#RTC_END_SE").val("");
			$("#RTC_ST_DT").val("");
			$("#RTC_END_DT").val(""); 
		});   
		
		/************************************
		 * 이전제한일자 변경 이벤트
		 ***********************************/
		$("#RTC_ST_SE").change(function(){
			fn_dataSet("RTC_ST_SE","RTC_ST_DT");
		}); 
		
		/************************************
		 * 이후제한일자 변경 이벤트
		 ***********************************/
		$("#RTC_END_SE").change(function(){
			fn_dataSet("RTC_END_SE","RTC_END_DT");  
		});
		
	});
	function fn_init(){
		//text 셋팅
		$('.row > .col > .tit').each(function(){
			$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
		});
		//div필수값 alt
		$("#WORK_SE").attr('alt',parent.fn_text('work_se'));   
		$("#RTC_ST_SE").attr('alt',parent.fn_text('rtc_st_dt'));   
		$("#RTC_ST_DT").attr('alt',parent.fn_text('rtc_st_dt'));   
		$("#RTC_END_SE").attr('alt',parent.fn_text('rtc_end_dt'));   
		$("#RTC_END_DT").attr('alt',parent.fn_text('rtc_end_dt'));   
		kora.common.setEtcCmBx2(work_se_list, "","", $("#WORK_SE"),"ETC_CD", "ETC_CD_NM", "N","S");		//업무설정
		kora.common.setEtcCmBx2(rtc_dt_se_list, "","", $("#RTC_ST_SE"),"ETC_CD", "ETC_CD_NM", "N","S");	//이전제한일자 구분
		kora.common.setEtcCmBx2(rtc_dt_se_list2, "","", $("#RTC_END_SE"),"ETC_CD", "ETC_CD_NM", "N","S");//이후제한일자 구분
		$("#RTC_ST_DT").val("");
		$("#RTC_END_DT").val("");
	}
	
	function fn_dataSet(SE,DT){
		$("#"+DT).prop("disabled",true);	
		$("#"+DT).val("");
		//년 일수 일자
			
		if($("#"+SE).val() =="B"){ 
			$("#"+DT).val("30");
		}else if($("#"+SE).val() =="C"){
			$("#"+DT).val("7");
		}else if($("#"+SE).val() =="D" ||$("#"+SE).val() =="E"){
			$("#"+DT).removeAttr("disabled");//활성화
		}
		
	}
	
	//조회
	function fn_sel(){
   	    var input ={};
   		var url ="/CE/EPCE3988501_19.do"
 	    ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {
				gridApp.setData(rtnData.selList);
			} else {
				alertMsg("error");
			}
 	    },false);
	}
	    
	//저장
	function fn_reg(){
		
		var url ="/CE/EPCE3988501_09.do"
		var input ={};
		var rtc_st_dt_se="";
		var rtc_end_dt_se="";
		var rtc_st_se 	=$("#RTC_ST_SE").val();
		var rtc_end_se =$("#RTC_END_SE").val();
		//필수입력값 체크
		if (!kora.common.cfrmDivChkValid("divInput")) {
			return;
		}
		//이전제한일자  확인
		if(rtc_st_se=="A"){		//년도
			rtc_st_dt_se ="Y";		//년도
		}else if(rtc_st_se=="B" || rtc_st_se=="C" ){//1개월 ,1주
			rtc_st_dt_se ="Q";							//일수
		}else  if(rtc_st_se=="D"){						//일수입력
			rtc_st_dt_se ="Q";							//일자
			if($("#RTC_ST_DT").val()=="" ){
				alertMsg("제한시작일자를 입력해주세요");
				return;
			}else if($("#RTC_ST_DT").val().length >3){
				alertMsg("일수입력은 최대 3자리 입력 가능합니다.");
				return;
			}
		}else  if(rtc_st_se=="E"){//날짜지정입력
			rtc_st_dt_se ="D";	//일자
			if($("#RTC_ST_DT").val()=="" ){
				alertMsg("제한시작일자를 입력해주세요");
				return;
			}else if(!kora.common.fn_validDate($("#RTC_ST_DT").val()) ){ 
				alertMsg("이전제한일자를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
				return; 
			}
		}
		
		//이후제한일자  확인
		if(rtc_end_se=="A"){		//년도
			rtc_end_dt_se="Y"; 	//년도
		}else if(rtc_end_se=="B" || rtc_end_se=="C"){	//1개월 ,1주
			rtc_end_dt_se="Q";								//일자
		}else  if(rtc_end_se=="D"){						//일수입력
			rtc_end_dt_se="Q";								//일자
			if($("#RTC_END_DT").val()=="" ){
				alertMsg("제한종료일자를 입력해주세요");
				return;
			}else if($("#RTC_END_DT").val().length >3){
				alertMsg("일수입력은 최대 3자리 입력 가능합니다.");
				return;
			}
		}else  if(rtc_end_se=="E"){							//날짜지정입력
			rtc_end_dt_se="D";								//일자
			if($("#RTC_END_DT").val()=="" ){
				alertMsg("제한종료일자를 입력해주세요");
				return;
			}else if(!kora.common.fn_validDate($("#RTC_END_DT").val()) ){ 
				alertMsg("이후제한일자를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
				return; 
			}
		}
		if( rtc_st_se=="E" && rtc_end_se=="E"){		//둘다 날짜지정입력일경우  시작일이 종료일보다 클경우
			if(Number($("#RTC_ST_DT").val()) > Number($("#RTC_END_DT").val())){   
				alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
				return;
			}
		}
		
		input["WORK_SE"]			= $("#WORK_SE").val();			//업무구분
		input["RTC_ST_DT_SE"]		=  rtc_st_dt_se 					//제한시작일자구분
		input["RTC_ST_SE"]			= $("#RTC_ST_SE").val();			//제한시작구분
		input["RTC_ST_DT"]          = $("#RTC_ST_DT").val();		//제한시작일자
		input["RTC_END_DT_SE"]	= 	rtc_end_dt_se					//제한종료일자구분
		input["RTC_END_SE"]		= $("#RTC_END_SE").val();		//제한종료구분
		input["RTC_END_DT"]		= $("#RTC_END_DT").val();		//제한종료일자
		ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {
				alertMsg(rtnData.RSLT_MSG);
			//	fn_init(); //입력창 초기화
				fn_sel();  
			} else {
				alertMsg("error");
			}
			hideLoadingBar();
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
		layoutStr	.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
		layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" sortableColumns="true"   horizontalGridLines="true" headerHeight="35">');
		layoutStr.push('		<columns>');
		layoutStr.push('			<DataGridColumn dataField="WORK_NM" 		headerText="'+parent.fn_text('work_se')+'" 			width="18%" textAlign="center" />');
		layoutStr.push('			<DataGridColumn dataField="RTC_ST_NM" 		headerText="'+parent.fn_text('rtc_st_dt_se')+'" 		width="22%" textAlign="center" />');
		layoutStr.push('			<DataGridColumn dataField="RTC_ST_DT" 		headerText="'+parent.fn_text('rtc_st_dt')+'" 			width="22%" textAlign="center" />');
		layoutStr.push('			<DataGridColumn dataField="RTC_END_NM"	headerText="'+parent.fn_text('rtc_end_dt_se')+'"	width="22%" textAlign="center" />');
		layoutStr.push('			<DataGridColumn dataField="RTC_END_DT"    	headerText="'+parent.fn_text('rtc_end_dt')+'"		width="22%" textAlign="center" />');
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
		gridApp.setData(selList);
		var layoutCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			dataGrid.addEventListener("change", selectionChangeHandler);
		}
		var dataCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
		}
		var selectionChangeHandler = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			selectorColumn = gridRoot.getObjectById("selector");
			fn_rowToInput(rowIndex);
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	}


	
	//행선택시 입력값 input에  넣기
	function fn_rowToInput(rowIndex) {
		var item = gridRoot.getItemAt(rowIndex);
		$("#WORK_SE").val(item["WORK_SE"]).prop("selected", true);			// 업무구분
		$("#RTC_ST_SE").val(item["RTC_ST_SE"]).prop("selected", true); 		// 이전제한일자구분
	    $("#RTC_END_SE").val(item["RTC_END_SE"]).prop("selected", true); 	// 이후제한일자구분
		$("#RTC_ST_DT").val(item["RTC_ST_DT"]);										// 이전제한일자
		$("#RTC_END_DT").val(item["RTC_END_DT"]);                                // 이후제한일자
		
		if(item["RTC_ST_SE"] =="D" ||item["RTC_ST_SE"] =="E"){
			$("#RTC_ST_DT").removeAttr("disabled");//활성화 
		}else{
			$("#RTC_ST_DT").prop("disabled",true);	
		}
		if(item["RTC_END_SE"] =="D" ||item["RTC_END_SE"] =="E"){
			$("#RTC_END_DT").removeAttr("disabled");//활성화 
		}else{
			$("#RTC_END_DT").prop("disabled",true);	
		}
		
	};

/****************************************** 그리드 셋팅 끝***************************************** */


</script>

<style type="text/css">
.srcharea .row .col .tit{
width: 90px;
}
</style>
</head>
<body>
    <div class="iframe_inner">
      	<input type="hidden" id="work_se_list" value="<c:out value='${work_se_list}' />" />
		<input type="hidden" id="rtc_dt_se_list" value="<c:out value='${rtc_dt_se_list}' />" />
		<input type="hidden" id="selList" value="<c:out value='${selList}' />" />
   		<div class="h3group">
			<h3 class="tit" id="title"></h3>
		</div>
		<section class="secwrap mt30">
			<div class="srcharea" id="divInput">
				<div class="row">
					<div class="col">
						<div class="tit" id="work_se_txt"></div>
						<div class="box">
							<select id="WORK_SE" style="width: 179px" class="i_notnull" ></select><!-- 업무구분 -->
						</div>
					</div>  
	            </div>  <!--end of row  -->
	            <div class="row">
					<div class="col">
						<div class="tit" id="rtc_st_dt_txt"></div><!-- 이전제한일자 -->
						<div class="box">
							<select id="RTC_ST_SE" style="width: 179px" class="i_notnull" ></select>
						</div>
					</div>
					<div class="col">
						<div class="box">
							<input type="text" id="RTC_ST_DT"  style="width: 179px;" maxByteLength="8" disabled="disabled"/>
						</div>
					</div>
	            </div>  <!--end of row  -->
				<div class="row">
					<div class="col">
						<div class="tit" id="rtc_end_dt_txt"></div><!-- 이후제한일자 -->
						<div class="box">
							<select type="text" id="RTC_END_SE"	style="width: 179px;" class="i_notnull" ></select>
						</div>
					</div>  
					<div class="col">
						<div class="box">
							<input type="text" id="RTC_END_DT"	 style="width: 179px;" maxByteLength="8" disabled="disabled"/>
						</div>
					</div>
					<div class="singleRow" style="float:right ">
						<div class="btn" id="CR"></div>
					</div>
				</div><!--end of row  -->
			</div>
			<div class="boxarea mt10">
				<div id="gridHolder" style="height: 250px; background: #FFF;"></div>
			</div>	<!-- 그리드 셋팅 -->
		</section>	<!-- end of secwrap mt30  -->
	</div>

</body>
</html>