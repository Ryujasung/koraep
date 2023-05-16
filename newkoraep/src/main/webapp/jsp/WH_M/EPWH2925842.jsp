<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>회수정보등록</title>
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

<script type="text/javaScript" language="javascript" defer="defer">
  
	 var INQ_PARAMS;	//파라미터 데이터
	 var rowIndexValue = 0;
     var initList;			//수정 초기값
     var initList2;			
     //var brch_nmList		//도매업자 지점
     var dps_fee_list;	//회수용기 보증금,취급수수료
     
     $(function() {
    	 
    	INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
    	initList = jsonObject($("#initList").val());		
    	initList2 = jsonObject($("#initList").val());		
    	//brch_nmList = jsonObject($("#brch_nmList").val());		
    	rtc_dt_list	= jsonObject($("#rtc_dt_list").val());			//등록일자제한설정	

    	 //초기 셋팅
    	fn_init();
    	 
    	//버튼 셋팅
    	//fn_btnSetting();
    	 
    	//그리드 셋팅
		fnSetGrid1();
		 
		 /*모바일용 날짜셋팅*/
 		$('#RTRVL_DT').YJdatepicker({
 			initDate : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
 		});

 		/************************************
		 * 회수량 변경시 - 소매수수료 계산
		 ***********************************/
		$("#RTRVL_QTY").change(function(){
			if($("#RTRVL_QTY").val() != '' && $("#RTRVL_CTNR_CD").val() != ''){
				for(var i=0; i<dps_fee_list.length; i++){
					if(dps_fee_list[i].RTRVL_CTNR_CD == $("#RTRVL_CTNR_CD").val() ) {
						var rtrvlFee = Number($("#RTRVL_QTY").val().replace(/\,/g,"")) * Number(dps_fee_list[i].RTRVL_FEE); // 소매수수료 자동계산
						$('#REG_RTRVL_FEE').val(kora.common.format_comma(rtrvlFee));
						break;		
					}
				}
			}
			
		});
		
		/************************************
		 * 빈용기명 변경 이벤트
		 ***********************************/
		 $("#RTRVL_CTNR_CD").change(function(){
			 if($("#RTRVL_CTNR_CD").val() != ''){
				$("#RTRVL_QTY").trigger('change');
				prpsCdCheck();
			}
		 });
		 
 		/************************************
		 * 시작날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		$("#RTRVL_DT").change(function(){
	     	 if($("#RTRVL_DT").val() != flag_DT){ //클릭시 날짜 변경 할경우  기존날짜랑 현재날짜랑 다를 경우  데이터 초기화
		     	flag_DT = $("#RTRVL_DT").val(); //변경시 날짜 
		     	fn_rtrvl_dt();
	   		  } 
		});
		
		/************************************
		 * 행 삭제 클릭 이벤트
		 ***********************************/
		$("#btn_del").click(function(){
			fn_del();
		});
		/************************************
		 * 행 변경 클릭 이벤트
		 ***********************************/
		$("#btn_upd").click(function(){
			fn_upd();
		});
		/************************************
		 * 행 추가 클릭 이벤트
		 ***********************************/
		$("#btn_reg2").click(function(){
			fn_reg2();
		});
		
		/************************************
		 * 저장 클릭 이벤트
		 ***********************************/
		$("#btn_reg").click(function(){
			fn_reg();
		});
		/************************************
		 * 취소버튼 클릭 이벤트
		 ***********************************/
		$("#btn_cnl").click(function(){
			fn_cnl();
		});
	
	});
     
     function prpsCdCheck(){
    	 for(var i=0; i<dps_fee_list.length; i++){ 
 			if(dps_fee_list[i].RTRVL_CTNR_CD == $("#RTRVL_CTNR_CD").val() ) { 
 				if(dps_fee_list[i].PRPS_CD == '0'){//유흥용일 경우 소매수수료 수정 불가
 					$('#REG_RTRVL_FEE').attr('readonly', 'readonly');
 				}else{
 					$('#REG_RTRVL_FEE').attr('readonly', false);
 				}
 				break;		
 			}
 		}
     }
     
     //초기화
     function fn_init(){
   		//kora.common.setEtcCmBx2(brch_nmList, "",$("#brchIdNo").val(), $("#WHSDL_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S');		//지점
   		
   		$("#WHSDL_BIZRNM").text(initList[0].WHSDL_BIZRNM);
   		$("#RTL_CUST_BIZRNM").text(initList[0].REG_CUST_NM);
   		$("#WHSDL_BIZRNO").text(kora.common.setDelim(initList[0].WHSDL_BIZRNO_DE, "999-99-99999"));
   		$("#RTL_CUST_BIZRNO").text(kora.common.setDelim(initList[0].RTL_CUST_BIZRNO, "999-99-99999"));
	
		flag_DT = $("#RTRVL_DT").val(); 
		 
		//text 셋팅
		$('.box_wrap .boxed .sort, .txtTable tr th').each(function(){
			if($(this).attr('id') != ''){
				$(this).html(fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt')) ) );
			}
		});
		
		//div필수값 alt
		$("#RTRVL_DT").attr('alt',fn_text('rtrvl_dt2'));//회수일자
		$("#RTRVL_QTY").attr('alt',fn_text('rtrvl_qty2'));//회수량
		$("#REG_RTRVL_FEE").attr('alt',fn_text('rtl_fee2'));//소매수수료
		$("#RTL_CUST_BIZRNM").attr('alt',fn_text('reg_cust_nm'));//회수처
		$("#RTL_CUST_BIZRNO").attr('alt',fn_text('reg_cust_bizrno'));//회수처사업자번호
		$("#RTRVL_CTNR_CD").attr('alt',fn_text('ctnr_nm2'));//회수용기
		//$("#WHSDL_BRCH_NM").attr('alt',fn_text('brch'));//도매업자 지점
		
		fn_rtrvl_dt();
	}
 
   //회수일자 변경시
   function fn_rtrvl_dt(){
		var url = "/WH/EPWH2925831_192.do"; 
		var input ={};
		input["RTRVL_DT"] = $("#RTRVL_DT").val();
      	ajaxPost(url, input, function(rtnData) {
   			if ("" != rtnData && null != rtnData) {   
   				dps_fee_list = rtnData.dps_fee_list;
   				kora.common.setEtcCmBx2(rtnData.dps_fee_list, "","", $("#RTRVL_CTNR_CD"), "RTRVL_CTNR_CD", "CTNR_NM", "N" ,'S');	//빈용기명(소매)
   			}else{
				alert("error");
   			}
   		},false);
   }
	 
	 //행등록
	function fn_reg2(){
		if(!kora.common.cfrmDivChkValid("divInput")) {
			return;
		}else if(!kora.common.fn_validDate($("#RTRVL_DT").val())){  
			alert("올바른 날짜 형식이 아닙니다.");
			return;
		}
		var input = insRow("A");
		if(!input){
			return;
		}
		
		gridRoot.addItemAt(input);
		gridRoot.calculateAutoHeight(); //모바일에서 필요..
		dataGrid.setSelectedIndex(-1);			

	}
	 //행 수정
	function fn_upd(){
		var idx = dataGrid.getSelectedIndex();
		if(idx < 0) {
			alert("변경할 행을 선택하시기 바랍니다.");
			return;
		}else if(!kora.common.cfrmDivChkValid("divInput")) {	//필수값 체크
			return;
		}else if(!kora.common.fn_validDate($("#RTRVL_DT").val())){ 
			alert("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return; 
		}
		var item = insRow("M");
		
		// 해당 데이터의 이전 수정내역을 삭제
		gridRoot.removeChangedData(gridRoot.getItemAt(idx));
		
		//해당 데이터 수정
		gridRoot.setItemAt(item, idx);
		gridRoot.calculateAutoHeight(); //모바일에서 필요..
		//dataGrid.setSelectedIndex(-1);			
	}
	 
	//행삭제
	function fn_del(){
		var idx = dataGrid.getSelectedIndex();
		if(idx < 0) {
			alert("삭제할 행을 선택하시기 바랍니다.");
			return;
		}
		gridRoot.removeItemAt(idx);
		gridRoot.calculateAutoHeight(); //모바일에서 필요..
	}
	 
	//행변경 및 행추가시 그리드 셋팅
	insRow = function(gbn) {
		if($("#RTRVL_QTY").val() == '0'){
			alert("회수량 입력은 필수입니다.");
			return false;
		}
		
		var input = {};
		var collection = gridRoot.getCollection();
			
		if(!kora.common.fn_validDate_ck( "U", $("#RTRVL_DT").val(),initList[0].REG_DTTM_STD )){ //등록일자제한 체크   
			return; 
		} 
			
	    for(var i=0;i<collection.getLength(); i++){
	 		var tmpData = gridRoot.getItemAt(i);
	 		if(tmpData.RTRVL_CTNR_CD == $("#RTRVL_CTNR_CD").val() && tmpData.RTRVL_DT== $("#RTRVL_DT").val()) { 
			 	if(gbn == "M") {
					if(rowIndexValue != i) {
				   		alert("동일한 빈용기명이 있습니다.");
				   		return false;
				   	}
				} else {
			    	alert("동일한 빈용기명이 있습니다..");
			    	return false;
				}
	 		}
	 	}
		    
		for(var i=0; i<dps_fee_list.length; i++){
			if(dps_fee_list[i].RTRVL_CTNR_CD == $("#RTRVL_CTNR_CD").val() ) {
				input["CTNR_NM"] = $("#RTRVL_CTNR_CD option:selected").text();	//빈용기명
			    input["RTRVL_CTNR_CD"] = $("#RTRVL_CTNR_CD").val();//빈용기 코드
				input["CPCT_NM"] = dps_fee_list[i].CPCT_NM;//용량ml
				input["PRPS_NM"] = dps_fee_list[i].PRPS_NM;//용도
			    input["RTRVL_QTY"] = $("#RTRVL_QTY").val().replace(/\,/g,"");//회수량
			    input["RTRVL_GTN"] = input["RTRVL_QTY"] * dps_fee_list[i].RTRVL_DPS;//보증금(원) - 합계
			    input["REG_RTRVL_FEE"] = $("#REG_RTRVL_FEE").val().replace(/\,/g,"");//등록소매수수료
			    input["RTRVL_RTL_FEE"] = input["RTRVL_QTY"] * dps_fee_list[i].RTRVL_FEE;//회수소매수수료
			    input["AMT_TOT"] = Number(input["RTRVL_GTN"])+ Number(input["REG_RTRVL_FEE"]);//총합계
				break;		
			}
		}
		input["RTRVL_DT"] = $("#RTRVL_DT").val();//회수일자
		input["REG_DTTM_STD"] = initList[0].REG_DTTM_STD;//등록일자제한  수정시 등록일자 기준으로 `체크 

		input["WHSDL_BIZRID"] = initList[0].WHSDL_BIZRID;
		input["WHSDL_BIZRNO"] = initList[0].WHSDL_BIZRNO;
		input["WHSDL_BIZRNM"] = initList[0].WHSDL_BIZRNM;
		
		//var arr = $("#WHSDL_BRCH_NM").val().split(";");//도매업자 지점
		input["WHSDL_BRCH_ID"] = initList[0].WHSDL_BRCH_ID;
		input["WHSDL_BRCH_NO"] = initList[0].WHSDL_BRCH_NO;
		input["WHSDL_BRCH_NM"] = initList[0].WHSDL_BRCH_NM
		//input["WHSDL_BRCH_NM_CD"] 	= 	$("#WHSDL_BRCH_NM").val();// 지점 ID+NO
		
		input["REG_CUST_NM"] = initList[0].REG_CUST_NM;//회수처
	    input["RTL_CUST_BIZRNO"] = initList[0].RTL_CUST_BIZRNO;//회수처사업자번호
	    input["RTL_CUST_BIZRID"] = initList[0].RTL_CUST_BIZRID;//회수처 ID
	    input["RTL_CUST_BRCH_ID"] = initList[0].RTL_CUST_BRCH_ID;//회수처지점 ID
	    input["RTL_CUST_BRCH_NO"] = initList[0].RTL_CUST_BRCH_NO;//회수처지점 번호
	    input["RTRVL_DOC_NO"] = initList[0].RTRVL_DOC_NO;//회수문서번호
	    input["RTRVL_STAT_CD"] = initList[0].RTRVL_STAT_CD;//상태값
		if($("#RMK").val() == ""){//비고
    			input["RMK"] = " ";												
    		}else{
    			input["RMK"] = $("#RMK").val();						
    		}
		input["SYS_SE"] = 'W'; //시스템구분	
		return input;   
	};	
	
	//등록
	function fn_reg(){
		var data = {"list": ""};
		var row = new Array();
		var url = "/WH/EPWH2925842_09.do"; 
		var changedData = gridRoot.getChangedData();
		
		if(0 != changedData.length){
			var collection = gridRoot.getCollection();
			if(collection.getLength()==0){
				fn_del_chk();	//행 데이터 전부 삭제 할경우 데이터 삭제
			}else{
			 	for(var i=0;i<collection.getLength(); i++){
			 		var tmpData = gridRoot.getItemAt(i);
			 		tmpData["ADJ"] = "F"; //회수조정인경우 T  마스터 상태값변경때문에
			 		row.push(tmpData);//행 데이터 넣기
			 	}//end of for
				data["list"] = JSON.stringify(row);

				ajaxPost(url, data, function(rtnData){
					if(rtnData != null && rtnData != ""){
						if(rtnData.RSLT_CD =="0000"){
							alert(rtnData.RSLT_MSG);
							fn_cnl();
						}else if(rtnData.RSLT_CD =="A003"){ // 중복일경우
							alert(rtnData.ERR_CTNR_NM+"은 " +rtnData.RSLT_MSG);
						}else{
							alert(rtnData.RSLT_MSG);
						}
					}else{
						alert("error");
					}
				});//end of ajaxPost
			}			
		}else{// 변경된 자료 없을경우
			alert("변경된 자료가 없습니다.");
		}
		 
	}
	
	//삭제
	function fn_del_chk(){
		if(confirm("회수 내역이 모두 삭제되었습니다. 계속 진행하시겠습니까? 삭제 처리된 내역은 복원되지 않으며 재등록 하셔야 합니다.")){
			fn_del_exec();
		}
	}
	
	function fn_del_exec(){
		var url ="/WH/EPWH2925801_04.do"; 
		var input ={}
		input["RTRVL_DOC_NO"] = initList[0].RTRVL_DOC_NO;	//회수문서번호
	 	ajaxPost(url, input, function(rtnData){
			if(rtnData.RSLT_CD == "0000"){
				alert(rtnData.RSLT_MSG);
				fn_lst();
			}else{
				alert(rtnData.RSLT_MSG);
			}
		},false);  
	}
	
	//취소버튼 이전화면으로
    function fn_cnl(){
   		kora.common.goPageB('', INQ_PARAMS);
    }
	
  	//목록화면으로
    function fn_lst(){
   		kora.common.goPageB('/WH/EPWH2925801.do', INQ_PARAMS);
    }
    
	//선택한 행 입력창에 값 넣기
	function fn_rowToInput (rowIndex){
		var item = gridRoot.getItemAt(rowIndex);
		fn_dataSet(item);
		//$("#WHSDL_BRCH_NM").val(item["WHSDL_BRCH_NM_CD"]).prop("selected", true);//지점
		$("#RTRVL_CTNR_CD").val( item["RTRVL_CTNR_CD"]).prop("selected", true);//회수용기
		$("#RTRVL_DT").val(kora.common.formatter.datetime(item["RTRVL_DT"], "yyyy-mm-dd") ); //회수일  
		$("#RTRVL_QTY").val( item["RTRVL_QTY"]);//회수량(개)
		$("#REG_RTRVL_FEE").val(item["REG_RTRVL_FEE"]);//소매수수료
		$("#RMK").val(item["RMK"]);//비고
	
		//$("#RTRVL_CTNR_CD").trigger('change');
		prpsCdCheck();
	}
	
	function fn_dataSet(item){
		var input = {};
		var url = "/WH/EPWH2925831_192.do"; // 수수료조회
		dps_fee_list=[];
		input["RTRVL_DT"] 	= item["RTRVL_DT"];//회수일자 
       	ajaxPost(url, input, function(rtnData) {
   			if ("" != rtnData && null != rtnData) {   
   				dps_fee_list = rtnData.dps_fee_list
   				kora.common.setEtcCmBx2(rtnData.dps_fee_list, "","", $("#RTRVL_CTNR_CD"), "RTRVL_CTNR_CD", "CTNR_NM", "N" ,'S');//빈용기명(소매)
   			}else{
				alert("error");
   			}
		},false);
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
			layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr.push('	<DataGrid id="dg1" autoHeight="true" minHeight="750" rowHeight="110" styleName="gridStyle" textAlign="center">');
			layoutStr.push('		<columns>');
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BRCH_NM" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('whsdl_brch')+"&lt;br&gt;("+fn_text('ctnr_nm')+ ')" width="70%"/>');
			layoutStr.push('			<DataGridColumn dataField="RTRVL_DT" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('rtrvl_dt2')+"&lt;br&gt;("+fn_text('rtrvl_qty')+ ')" width="30%"/>');
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
			
			gridApp.setData(initList2);
		}
		var dataCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
		}
		var selectionChangeHandler = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			rowIndexValue = rowIndex;
			fn_rowToInput(rowIndex);
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
		
		if(dataField == "WHSDL_BRCH_NM"){
			return item["WHSDL_BRCH_NM"] + "</br>(" + item["CTNR_NM"] + ")";
		}
		else if(dataField == "RTRVL_DT"){
			return kora.common.formatter.datetime(item["RTRVL_DT"], "yyyy-mm-dd") + "</br>(" + kora.common.format_comma(item["RTRVL_QTY"]) + ")";
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
	<input type="hidden" id="initList" value="<c:out value='${initList}' />" />

	<input type="hidden" id="brchIdNo" value="<c:out value='${brchIdNo}' />" />
	<input type="hidden" id="rtc_dt_list" value="<c:out value='${rtc_dt_list}' />" />
	
	<div id="wrap">
	
		<%@include file="/jsp/include/header_m.jsp" %>
		
		<%@include file="/jsp/include/aside_m.jsp" %>

		<div id="container">

			<div id="subvisual">
				<h2 class="tit" id="title"></h2>
				<button class="btn_back" id="btn_cnl"><span class="hide">뒤로가기</span></button>
			</div><!-- id : subvisual -->

			<div id="contents">
			
				<div class="contbox bdn pb40">
					<div class="tbl">
						<table class="txtTable">
							<colgroup>
								<col style="width: 177px;">
								<col style="width: auto;">
							</colgroup>
							<tbody>
								<tr>
									<th id="whsdl_txt"></th>
									<td id="WHSDL_BIZRNM"></td>
								</tr>
								<tr>
									<th id="whsdl_bizrno_br_txt"></th>
									<td id="WHSDL_BIZRNO"></td>
								</tr>
								<tr>
									<th id="reg_cust_nm_txt"></th>
									<td id="RTL_CUST_BIZRNM"></td>
								</tr>
								<tr>
									<th id="reg_cust_bizrno_br_txt"></th>
									<td id="RTL_CUST_BIZRNO"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			
				<div class="contbox pb50" id="divInput">
					<div class="box_wrap" style="margin: -20px 0 0; display:none" >
						<div class="boxed v2">
							<div class="sort" id="brch_txt"></div>
							<div class="cont">
								<select id="WHSDL_BRCH_NM" style="width: 285px;" ></select>
							</div>
						</div>
					</div>
					<div class="box_wrap">
						<div class="boxed v2">
							<div class="sort" id="rtrvl_dt2_txt"></div>
							<div class="cont">
								<input type="text" id="RTRVL_DT" style="width: 285px;" class="i_notnull">
							</div>
						</div>
						<div class="boxed v2 mt10">
							<div class="sort" id="ctnr_nm2_txt"></div>
							<div class="cont">
								<select style="width: 450px;" id="RTRVL_CTNR_CD" class="i_notnull"></select>
							</div>
						</div>
					</div>
					<div class="box_wrap">
						<div class="boxed v2">
							<div class="sort" id="rtrvl_qty2_txt"></div>
							<div class="cont"><input type="number" placeholder="직접입력" style="text-align: right;" maxlength="8" id="RTRVL_QTY" class="i_notnull" format="number"></div>
						</div>
						<div class="boxed v2 mt10">
							<div class="sort" id="rtl_fee2_txt"></div>
							<div class="cont"><input type="number" placeholder="직접입력" style="text-align: right;" maxlength="10" id="REG_RTRVL_FEE" class="i_notnull" format="number"></div>
						</div>
						<div class="boxed v2 mt10">
							<div class="sort" id="rmk_txt"></div>
							<div class="cont"><input type="text" placeholder="직접입력" style="text-align: right;" maxlength="50" id="RMK" ></div>
						</div>
					</div>
					<div class="btn_wrap mt10 line">
						<div class="fl_c">
							<button class="btnCircle c2" id="btn_upd">변경</button>
							<button class="btnCircle c1" id="btn_del">삭제</button>
							<button class="btnCircle c3" id="btn_reg2">추가</button>
						</div>
					</div>
				</div>
				
				<div class="tblbox">
					<div class="tbl_inquiry v2">
						<div id="gridHolder"></div> <!-- 그리드 -->
					</div>
					<div class="btn_wrap" style="height:50px">
						<button class="btnCircle c1" id="btn_reg">저장</button>
					</div>
				</div>
				
			</div><!-- id : contents -->

		</div><!-- id : container -->

		<%@include file="/jsp/include/footer_m.jsp" %>
		
	</div><!-- id : wrap -->
	
</body>
</html>