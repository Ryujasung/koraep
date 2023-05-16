
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>회수조정</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">
  
	 var INQ_PARAMS;	//파라미터 데이터
     var toDay = kora.common.gfn_toDay();  // 현재 시간
	 var rowIndexValue =0;
     var initList;										//도매업자
     var brch_nmList									//도매업자 지점
     var dps_fee_list;								//회수용기 보증금,취급수수료
	 
     $(function() {
    	 
    	INQ_PARAMS 		= jsonObject($("#INQ_PARAMS").val());	
    	initList 				= jsonObject($("#initList").val());		
    	brch_nmList 		= jsonObject($("#brch_nmList").val());
    	
    	 //초기 셋팅
    	fn_init();
    	 
    	//버튼 셋팅
    	fn_btnSetting();
    	 
    	//그리드 셋팅
		fnSetGrid1();
		 
		//날짜 셋팅
  	    $('#RTRVL_DT').YJcalendar({  
 			triggerBtn : true,
 			dateSetting: toDay.replaceAll('-','')
 		});
		
		
		/************************************
		 * 시작날짜  클릭시 - 삭제 변경 이벤트
		 ***********************************/
		$("#RTRVL_DT").click(function(){
			var rtn_dt = $("#RTRVL_DT").val();
			rtn_dt   =  rtn_dt.replace(/-/gi, "");
			$("#RTRVL_DT").val(rtn_dt)
		});
		
		/************************************
		 * 시작날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		$("#RTRVL_DT").change(function(){
		     var dt = $("#RTRVL_DT").val();
		     dt = dt.replace(/-/gi, "");
			 if(dt.length == 8)  dt = kora.common.formatter.datetime(dt, "yyyy-mm-dd")
	     	 $("#RTRVL_DT").val(dt) 
	     	 if($("#RTRVL_DT").val() !=flag_DT){ //클릭시 날짜 변경 할경우 기존날짜랑 현재날짜랑 다를 경우  데이터 초기화
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
		 * 추가 클릭 이벤트
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
     
     //초기화
     function fn_init(){
    	 
    		 kora.common.setEtcCmBx2(brch_nmList, "","", $("#WHSDL_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S');		//지점
 		
    		$("#WHSDL_BIZRNM").text(initList[0].WHSDL_BIZRNM);
    		$("#RTL_CUST_BIZRNM").text(initList[0].REG_CUST_NM);
    		$("#WHSDL_BIZRNO").text(kora.common.setDelim(initList[0].WHSDL_BIZRNO_DE, "999-99-99999"));
    		$("#RTL_CUST_BIZRNO").text(kora.common.setDelim(initList[0].RTL_CUST_BIZRNO, "999-99-99999"));
		
			$('#RTRVL_DT').val(kora.common.formatter.datetime(toDay, "yyyy-mm-dd")); 
			flag_DT = $("#RTRVL_DT").val(); 
			 
			//text 셋팅
			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			
			$('#whsdl').text(parent.fn_text('whsdl'));										  //도매업자
			$('#whsdl_bizrno').text(parent.fn_text('whsdl_bizrno'));					  //도매업자사업자번호
			$('#reg_cust_nm').text(parent.fn_text('reg_cust_nm'));					  //회수처명
			$('#reg_cust_bizrno').text(parent.fn_text('reg_cust_bizrno'));			  //회수처 사업자번호
			
			$('#title_sub').text('<c:out value="${titleSub}" />');						   //타이틀
			//div필수값 alt
			$("#RTRVL_DT").attr('alt',parent.fn_text('rtrvl_dt2'));   						//회수일자
			$("#RTRVL_QTY").attr('alt',parent.fn_text('rtrvl_qty2'));   					//회수량
			$("#REG_RTRVL_FEE").attr('alt',parent.fn_text('rtl_fee2'));   					//소매수수료
			$("#RTL_CUST_BIZRNM").attr('alt',parent.fn_text('reg_cust_nm'));   		//회수처
			$("#RTL_CUST_BIZRNO").attr('alt',parent.fn_text('reg_cust_bizrno'));   	//회수처사업자번호
			$("#RTRVL_CTNR_CD").attr('alt',parent.fn_text('ctnr_nm2'));   			//회수용기
			$("#WHSDL_BRCH_NM").attr('alt',parent.fn_text('brch'));   				//도매업자 지점
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
					alertMsg("error");
   				}
   		},false);
   }
	 
	 //행등록
	function fn_reg2(){
		if(!kora.common.cfrmDivChkValid("divInput")) {
			return;
		}else if(!kora.common.fn_validDate($("#RTRVL_DT").val())){  
			alertMsg("올바른 날짜 형식이 아닙니다.");
			return;
		}
		var input 	=	insRow("A");
		if(!input){
			return;
		}
		gridRoot.addItemAt(input);
		dataGrid.setSelectedIndex(-1);			

	}
	 //행 수정
	function fn_upd(){
		var idx = dataGrid.getSelectedIndex();
		if(idx < 0) {
			alertMsg("변경할 행을 선택하시기 바랍니다.");
			return;
		}else if(!kora.common.cfrmDivChkValid("divInput")) {	//필수값 체크
			return;
		}else if(!kora.common.fn_validDate($("#RTRVL_DT").val())){ 
			alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return; 
		}
		var item = insRow("M");
		// 해당 데이터의 이전 수정내역을 삭제
		gridRoot.removeChangedData(gridRoot.getItemAt(idx));
		
		//해당 데이터 수정
		gridRoot.setItemAt(item, idx);
		dataGrid.setSelectedIndex(-1);			
	}
	 
	 
	//행삭제
	function fn_del(){
		var idx = dataGrid.getSelectedIndex();

		if(idx < 0) {
			alertMsg("삭제할 행을 선택하시기 바랍니다.");
			return;
		}
		gridRoot.removeItemAt(idx);
	}
	 
	 
	//행변경 및 행추가시 그리드 셋팅
	insRow = function(gbn) {
			var input 				= {};
			var collection = gridRoot.getCollection();
		    for(var i=0;i<collection.getLength(); i++){
		 		var tmpData = gridRoot.getItemAt(i);
		 		if(tmpData.RTRVL_CTNR_CD == $("#RTRVL_CTNR_CD").val() && tmpData.RTRVL_DT== $("#RTRVL_DT").val()) { 
				 		if(gbn == "M") {
							if(rowIndexValue != i) {
					    		alertMsg("동일한 빈용기명이 있습니다.");
					    		return false;
					    	}
						} else {
				    		alertMsg("동일한 빈용기명이 있습니다..");
				    		return false;
						}
		 		}
		 	}
		  
			for(var i=0; i<dps_fee_list.length; i++){
				if(dps_fee_list[i].RTRVL_CTNR_CD == $("#RTRVL_CTNR_CD").val() ) {
						input["CTNR_NM"] 					= 	$("#RTRVL_CTNR_CD option:selected").text();	//빈용기명
					    input["RTRVL_CTNR_CD"] 			= 	$("#RTRVL_CTNR_CD").val(); 							//빈용기 코드
						input["CPCT_NM"] 					= 	dps_fee_list[i].CPCT_NM;								//용량ml
						input["PRPS_NM"] 					= 	dps_fee_list[i].PRPS_NM;								//용도
					    input["RTRVL_QTY"] 				= 	$("#RTRVL_QTY").val().replace(/\,/g,"");									//회수량
					    input["RTRVL_GTN"] 				= 	input["RTRVL_QTY"] * dps_fee_list[i].RTRVL_DPS; 	//보증금(원) - 합계
					    input["REG_RTRVL_FEE"]    		=	$("#REG_RTRVL_FEE").val().replace(/\,/g,"");									//등록소매수수료
					    input["RTRVL_RTL_FEE"]    		=	input["RTRVL_QTY"] *dps_fee_list[i].RTRVL_FEE;		//회수소매수수료
					    input["AMT_TOT"] 					=	Number(input["RTRVL_GTN"])+ Number(input["REG_RTRVL_FEE"]);  //총합계
						break;		
				}
			}
			input["RTRVL_DT"]					= 	$("#RTRVL_DT").val();                           	//회수일자
			input["WHSDL_BIZRID"] 			= initList[0].WHSDL_BIZRID;
			input["WHSDL_BIZRNO"] 			= initList[0].WHSDL_BIZRNO;
			input["WHSDL_BIZRNM"] 			= initList[0].WHSDL_BIZRNM;

			var arr = $("#WHSDL_BRCH_NM").val().split(";"); 												//도매업자 지점
			input["WHSDL_BRCH_ID"] 			= arr[0];
			input["WHSDL_BRCH_NO"] 		= arr[1];
			input["WHSDL_BRCH_NM"] 		= 	$("#WHSDL_BRCH_NM option:selected").text();	// 지점
			input["WHSDL_BRCH_NM_CD"] 	= 	$("#WHSDL_BRCH_NM").val();						// 지점 ID+NO
			
		    input["REG_CUST_NM"] 			= initList[0].REG_CUST_NM;						//회수처
		    input["RTL_CUST_BIZRNO"] 		= initList[0].RTL_CUST_BIZRNO;					//회수처사업자번호
		    input["RTL_CUST_BIZRID"] 		= initList[0].RTL_CUST_BIZRID;					//회수처 ID
		    input["RTL_CUST_BRCH_ID"] 		= initList[0].RTL_CUST_BRCH_ID;					//회수처지점 ID
		    input["RTL_CUST_BRCH_NO"] 	= initList[0].RTL_CUST_BRCH_NO;				//회수처지점 번호
		    input["RTRVL_DOC_NO"] 			= initList[0].RTRVL_DOC_NO;						//회수문서번호
		    input["RTRVL_STAT_CD"] 			= initList[0].RTRVL_STAT_CD;						//상태

		    if($("#RMK").val() ==""){																		//비고
     			input["RMK"]						=	" ";												
     		}else{
     			input["RMK"]						=	$("#RMK").val();						
     		}
			input["SYS_SE"]						= 'W';													//시스템구분	
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
					alertMsg("회수조정인 경우 모든 행을 삭제할 수 없습니다.");
				}else{
					 	for(var i=0;i<collection.getLength(); i++){
					 		var tmpData = gridRoot.getItemAt(i);
					 		tmpData["ADJ"]	="T"; //회수조정인경우 T  마스터 상태값변경때문에
					 		row.push(tmpData);//행 데이터 넣기
					 	}//end of for
						data["list"] = JSON.stringify(row);
						ajaxPost(url, data, function(rtnData){
							if(rtnData != null && rtnData != ""){
									if(rtnData.RSLT_CD =="A003"){ // 중복일경우
										alertMsg(rtnData.ERR_CTNR_NM+"은 " +rtnData.RSLT_MSG);
									}else if(rtnData.RSLT_CD =="0000"){
										alertMsg(rtnData.RSLT_MSG);
					  					fn_cnl();
									}
							}else{
									alertMsg("error");
							}
						},false);//end of ajaxPost
			  }
				
		}else{// 변경된 자료 없을경우
			alertMsg("변경된 자료가 없습니다.");
		}
		 
	}
	
	  //취소버튼 이전화면으로
    function fn_cnl(){
   	 kora.common.goPageB('/WH/EPWH2925801.do', INQ_PARAMS);
    }
    
	//선택한 행 입력창에 값 넣기
	function fn_rowToInput (rowIndex){
		var item = gridRoot.getItemAt(rowIndex);
		fn_dataSet(item);
		$("#WHSDL_BRCH_NM").val(item["WHSDL_BRCH_NM_CD"]).prop("selected", true); 	//지점
		$("#RTRVL_CTNR_CD").val( item["RTRVL_CTNR_CD"]).prop("selected", true); 				//회수용기
		$("#RTRVL_DT").val(kora.common.formatter.datetime(item["RTRVL_DT"], "yyyy-mm-dd") ); //회수일  
		$("#RTRVL_QTY").val( item["RTRVL_QTY"]);   															//회수량(개)
		$("#REG_RTRVL_FEE").val(item["REG_RTRVL_FEE"]);													//소매수수료
		$("#RMK").val(item["RMK"]);																				//비고
	}
	
	function fn_dataSet(item){
		var input	={};
		var url 	 	= "/WH/EPWH2925831_192.do"; 
		dps_fee_list=[];
		input["RTRVL_DT"] 	= item["RTRVL_DT"];			//회수일자 

       	ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {   
   					dps_fee_list = rtnData.dps_fee_list
   					kora.common.setEtcCmBx2(rtnData.dps_fee_list, "","", $("#RTRVL_CTNR_CD"), "RTRVL_CTNR_CD", "CTNR_NM", "N" ,'S');	//빈용기명(소매)
   				}else{
					alertMsg("error");
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
			layoutStr.push('	<NumberFormatter id="numfmt1" precision="2" useThousandsSeparator="true"/>');
			layoutStr.push('	<NumberMaskFormatter id="maskfmt1" formatString="###-##-#####"/>');
			layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" horizontalScrollPolicy="on" sortableColumns="true"   headerHeight="35">');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridColumn dataField="index" 				 	headerText="'+ parent.fn_text('sn')+ '"						width="50" 	textAlign="center" 	  itemRenderer="IndexNoItem" />');			//순번
			layoutStr.push('			<DataGridColumn dataField="RTRVL_DT"			 	headerText="'+ parent.fn_text('rtrvl_dt2')+ '"  			width="120"  	textAlign="center"  	/>'); 													//회수일자
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BRCH_NM" headerText="'+ parent.fn_text('whsdl_brch')+ '"   		width="150"  	textAlign="center"	/>');														//도매업자 지점
			layoutStr.push('			<DataGridColumn dataField="REG_CUST_NM" 	 	headerText="'+ parent.fn_text('reg_cust_nm')+ '"   	width="150"  	textAlign="center"	/>');														//회수처
			layoutStr.push('			<DataGridColumn dataField="PRPS_NM" 			headerText="'+ parent.fn_text('prps_cd')+ '" 				width="200"  	textAlign="center"  	/>');														//용도
			layoutStr.push('			<DataGridColumn dataField="RTL_CUST_BIZRNO" headerText="'+ parent.fn_text('reg_cust_bizrno')+ '"  width="150"  	textAlign="center"	 formatter="{maskfmt1}"/>');					//회수처 사업자번호
			layoutStr.push('			<DataGridColumn dataField="CPCT_NM"  		 	headerText="'+ parent.fn_text('cpct')+ '" 					width="100" 	textAlign="center" 	 />');													//용량
			layoutStr.push('			<DataGridColumn dataField="RTRVL_QTY"  		 	headerText="'+ parent.fn_text('rtrvl_qty')+'" 				width="120" 	textAlign="right" 		 formatter="{numfmt}" id="num1"  />');		//회수량
			layoutStr.push('			<DataGridColumn dataField="RTRVL_GTN" 	 		headerText="'+ parent.fn_text('rtrvl_dps')+ '" 			width="120"  	textAlign="right"  	 formatter="{numfmt}" id="num2" />');		//회수보증금
			layoutStr.push('			<DataGridColumn dataField="REG_RTRVL_FEE" 	headerText="'+ parent.fn_text('rtrvl_fee')+ '"				width="120"  	textAlign="right"  	 formatter="{numfmt}" id="num3" />');		//회수수수료
			layoutStr.push('			<DataGridColumn dataField="AMT_TOT"   			headerText="'+ parent.fn_text('total')+ '" 					width="120"	textAlign="right" 		 formatter="{numfmt}" id="num4"  />');		//소계
			layoutStr.push('			<DataGridColumn dataField="RMK" 					headerText="'+ parent.fn_text('rmk')+ '"					width="100"	textAlign="center" 	   />');													//비고
			layoutStr.push('			<DataGridColumn dataField="SYS_SE"  	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="RTRVL_CTNR_CD"	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="RTRVL_RTL_FEE"		visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRID"		visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRNO"	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BRCH_ID"	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BRCH_NO"	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="RTL_CUST_BIZRID"		visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="RTL_CUST_BRCH_ID"	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="RTL_CUST_BRCH_NO"	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="RTRVL_DOC_NO"		visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BRCH_NM_CD"	isible="false" />');
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="합계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	//회수량
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	//회수보증금
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	//회수수수료
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');	//소계
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('			</DataGridFooter>');
			layoutStr.push('		</footers>');
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
		gridApp.setData(initList);
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
			rowIndexValue = rowIndex;
			fn_rowToInput(rowIndex);
		
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	}


/****************************************** 그리드 셋팅 끝***************************************** */


</script>

<style type="text/css">

.srcharea .row .col{
width: 31%;
} 

.srcharea .row .col .tit{
width: 120px;
}

</style>

</head>
<body>
    <div class="iframe_inner"  >
			<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="initList" value="<c:out value='${initList}' />" />
			<input type="hidden" id="brch_nmList" value="<c:out value='${brch_nmList}' />" />
			
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
				<div class="singleRow">
				<div class="btn" id="UR"></div>
				</div>
				<!--btn_dwnd  -->
				<!--btn_excel  -->
			</div>
			<section class="secwrap">
				 <div class="write_area">
						<div class="write_tbl">
							<table>
								<colgroup>
									<col style="width: 15%;">
								<col style="width: 20%;">
								<col style="width: 15%;">
								<col style="width: auto;">
							</colgroup>
							<tbody>
								<tr>
									<th class="bd_l" id="whsdl"></th> <!-- 도매업자업체명 -->		
									<td>
										<div class="row">
											<div class="txtbox" id="WHSDL_BIZRNM"></div>
										</div>
									</td>
									<th class="bd_l" id="whsdl_bizrno"></th> <!-- 도매업자 사업자번호 -->
									<td>
										<div class="row">
											<div class="txtbox" id="WHSDL_BIZRNO"></div>
										</div>
									</td>
								</tr>
								<tr>
									<th class="bd_l" id="reg_cust_nm"></th> <!--회수처-->
									<td>
										<div class="row">
											<div class="txtbox" id="RTL_CUST_BIZRNM"></div>
										</div>
									</td>
									<th class="bd_l"  id="reg_cust_bizrno"></th><!--회수처 사업자번호-->
									<td>
										<div class="row">
											<div class="txtbox"  id=RTL_CUST_BIZRNO></div>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
		</section>
		<section class="secwrap mt10">
				<div class="srcharea"  id="divInput" > 
						<div class="row">
								<div class="col">
									<div class="tit" id="brch_txt"></div>  <!-- 지점 -->
									<div class="box">
										<select id="WHSDL_BRCH_NM" style="width: 179px"  class="i_notnull" ></select>
									</div>
								</div>
								<div class="col">
									<div class="tit" id="rtrvl_dt2_txt"></div>  <!-- 회수일자 -->
									<div class="box">
										<div class="calendar">
											<input type="text" id="RTRVL_DT"  style="width: 180px;" class="i_notnull" /> <!--시작날짜  -->
										</div>
									</div>
								</div>
							    <div class="col">
									<div class="tit" id="ctnr_nm2_txt"></div>  <!-- 빈용기명(소매) -->
									<div class="box">
										<select id="RTRVL_CTNR_CD" style="width: 179px" class="i_notnull" ></select>
									</div>
								</div>
						</div> <!-- end of row -->
						<div class="row">
								<div class="col">
									<div class="tit" id="rtrvl_qty2_txt"></div>  <!-- 회수량 -->
									<div class="box">
										<input type="text" id="RTRVL_QTY" style="width: 179px;text-align:right"  format="minus"   class="i_notnull"  maxlength="8"/>
									</div>
								</div>
								<div class="col" style="">
									<div class="tit" id="rtl_fee2_txt"></div>  <!-- 소매수수료 -->
									<div class="box" style="" >
										<input type="text" id="REG_RTRVL_FEE" style="width: 179px;text-align:right" format="minus"   class="i_notnull"  />
									</div>
								</div>   
								<div class="col">
									<div class="tit" id="rmk_txt"></div>  <!-- 비고 -->
									<div class="box">
										  <input type="text"  id="RMK" style="width: 179px"   maxByteLength="100"/>
									</div>
								</div>
						</div> <!-- end of row -->
						<div class="singleRow" style="float:right ">
								<div class="btn" id="CR"></div>
						</div>
				</div>  <!-- end of srcharea -->
			</section>
				
			<div class="boxarea mt10">
				<div id="gridHolder" style="height: 560px; background: #FFF;"></div>
			</div>	<!-- 그리드 셋팅 -->
			<section class="btnwrap mt10" >
					<div class="btn" id="BL"></div>
					<div class="btn" style="float:right" id="BR"></div>
			</section>
</div>

</body>
</html>