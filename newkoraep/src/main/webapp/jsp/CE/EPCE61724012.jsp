<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>신구병 통계현황-생산자</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<style>
/* The Modal (background) */
.searchModal {
display: none; /* Hidden by default */
position: fixed; /* Stay in place */
z-index: 10; /* Sit on top */
left: 0;
top: 0;
width: 100%; /* Full width */
height: 100%; /* Full height */
overflow: auto; /* Enable scroll if needed */
background-color: rgb(0,0,0); /* Fallback color */
background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
}
/* Modal Content/Box */
.search-modal-content {
background-color: #fefefe;
text-align:center;
margin: 15% auto; /* 15% from the top and centered */
padding: 20px;
border: 1px solid #888;
width: 180px; /* Could be more or less, depending on screen size */
border-radius:10px; 
}
</style>
<script type="text/javaScript" language="javascript" defer="defer">

	var sumData;
	
	var INQ_PARAMS;	//파라미터 데이터

	var mfc_bizrnmList;	//생산자
	var ctnrSe;
	var prpsCd;

    $(function() {
    	 
    	$('#title_sub').text('<c:out value="${titleSub}" />');
    	
    	INQ_PARAMS = jsonObject($("#INQ_PARAMS").val()); //파라미터 데이터
  	    mfc_bizrnmList = jsonObject($("#mfc_bizrnmList").val());	 //생산자
  	  	ctnrSe = jsonObject($("#ctnrSe").val());
  	  	prpsCd = jsonObject($("#prpsCd").val());
  	  	
		//버튼 셋팅
		fn_btnSetting();
		 	 
		//그리드 셋팅
		fnSetGrid1();
		
		//text셋팅
		$('.row > .col > .tit').each(function(){
			$(this).text(parent.fn_text($(this).attr('id')) );
		});
		
		kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'T'); //생산자
		kora.common.setEtcCmBx2(ctnrSe, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N", "T"); //빈용기구분
		kora.common.setEtcCmBx2(prpsCd, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N", "T"); //빈용기구분
		kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S'); //빈용기	


		/************************************
		 * 생산자 구분 변경 이벤트
		 ***********************************/
		$("#MFC_BIZRNM").change(function(){
			fn_mfc_bizrnm();
		});

		/************************************
		 * 빈용기구분 구병 / 신병 변경시 
		 ***********************************/
		$("#CTNR_SE").change(function(){
			fn_prps_cd();
		});
		
		/************************************
		 * 빈용기 구분 변경 이벤트
		 ***********************************/
		$("#PRPS_CD").change(function(){
			fn_prps_cd();
		});
		
		/************************************
		 * 조회 클릭 이벤트
		 ***********************************/
		$("#btn_sel").click(function(){
			//조회버튼 클릭시 페이징 초기화
			gridCurrentPage = 1;
			fn_sel();
		});

		/************************************
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_excel").click(function() {
			fn_excel();
		 });

		$("#btn_page").click(function() {
			fn_page();
		 });
		
	});

    function fn_page(){
        
		kora.common.goPageB('', INQ_PARAMS);
    	
    }
    
  	//빈용기 구분 선택시
	function fn_prps_cd(){

		var url = "/SELECT_CTNR_CD2.do" 
		var input ={};

		ctnr_nm=[];
		//var arr	= $("#WHSDL_BIZRNM").val().split(";");
		var arr3	= $("#MFC_BIZRNM").val().split(";");
		//var arr4	= $("#MFC_BRCH_NM").val().split(";"); 
		//input["CUST_BIZRID"] 		= arr[0];					//도매업자아이디
		//input["CUST_BIZRNO"] 		= arr[1];					//도매업자사업자번호
		//input["CUST_BRCH_ID"] 	= arr2[0];					//도매업자 지점 아이디
		//input["CUST_BRCH_NO"] 	= arr2[1];					//도매업자 지점 번호
		input["MFC_BIZRID"] 		= arr3[0];					//생산자 아이디
		input["MFC_BIZRNO"] 		= arr3[1];					//생산자 사업자번호
		//input["MFC_BRCH_ID"] 	= arr4[0];					//생산자 직매장/공장 아이디
		//input["MFC_BRCH_NO"] 	= arr4[1];					//생산자 직매장/공장 번호
		input["CTNR_SE"] 			= $("#CTNR_SE").val();	//빈용기명 구분 구/신
		input["PRPS_CD"] 			= $("#PRPS_CD").val();	//빈용기명  유흥/가정/공병/직접 
		//input["RTN_DT"] 				= $("#RTN_DT").val(); //반환일자 
		ajaxPost(url, input, function(rtnData) {
 			if ("" != rtnData && null != rtnData) {   
				ctnr_nm = rtnData.ctnr_nm
				kora.common.setEtcCmBx2(rtnData.ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'T'); //빈용기	
 			}else{
			alertMsg("error");
 			}
    	},false);


   	}
    
   //생산자 변경시 생산자랑 거래중인 도매업자 조회 , 직매장/공장
   function fn_mfc_bizrnm(){
		
   }
   
   //조회
    function fn_sel(){
		var input = {};
		var url = "/CE/EPCE61724012_19.do" 
		 
		var input = kora.common.gfn_formData("frmSel");
					
		INQ_PARAMS["SEL_PARAMS"] = input;
		
// 		kora.common.showLoadingBar(dataGrid, gridRoot);
$("#modal").show();
		ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {   
				gridApp.setData(rtnData.searchList);
			}else{
				alertMsg("error");
			}
// 			kora.common.hideLoadingBar(dataGrid, gridRoot);
			$("#modal").hide();
		});
		      	
    }
      
	//엑셀저장
	function fn_excel(){

		var collection = gridRoot.getCollection();
		if(collection.getLength() < 1){
			alertMsg("데이터가 없습니다.");
			return;
		}
		if(INQ_PARAMS["SEL_PARAMS"] == undefined){
			alertMsg("먼저 데이터를 조회해야 합니다.");
			return;
		}
		var now  = new Date(); 				     // 현재시간 가져오기
		var hour = new String(now.getHours());   // 시간 가져오기
		var min  = new String(now.getMinutes()); // 분 가져오기
		var sec  = new String(now.getSeconds()); // 초 가져오기
		var today = kora.common.gfn_toDay();
		var fileName = $('#title').text().replace("/","_")  +"_" + today+hour+min+sec+".xlsx";
		
		//그리드 컬럼목록 저장
		var col = new Array();
		var columns = dataGrid.getColumns();
		for(i=0; i<columns.length; i++){
			if(columns[i].getDataField() != undefined && columns[i].getDataField() != 'index'){ //순번 제외
				var item = {};
				item['headerText'] = columns[i].getHeaderText();
				item['dataField'] = columns[i].getDataField();
				item['textAlign'] = columns[i].getStyle('textAlign');
				item['id'] = kora.common.null2void(columns[i].id);
				col.push(item);
			}
		}
		
		var input = INQ_PARAMS["SEL_PARAMS"];
		input['excelYn'] = 'Y';	//엑셀 저장시 모든 검색이 필요해서
		input['fileName'] = fileName;
		input['columns'] = JSON.stringify(col);
		var url = "/CE/EPCE61724012_05.do";
		 kora.common.showLoadingBar(dataGrid, gridRoot);
		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
				alertMsg(rtnData.RSLT_MSG);
			}else{
				//파일다운로드
				frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
				frm.fileName.value = fileName;
				frm.submit();
			}
			kora.common.hideLoadingBar(dataGrid, gridRoot);
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
			layoutStr.push('	<NumberFormatter id="numfmt1" precision="2" useThousandsSeparator="true"/>');
			layoutStr.push('	<NumberMaskFormatter id="maskfmt1" formatString="###-##-#####"/>');
			layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" textAlign="center" id="dg1" draggableColumns="true" horizontalScrollPolicy="on"  sortableColumns="true" headerHeight="35">');
			layoutStr.push('		<groupedColumns>');   	
			layoutStr.push('			<DataGridColumn itemRenderer="IndexNoItem" headerText="'+ parent.fn_text('sn')+ '" width="50"/>');
			layoutStr.push('			<DataGridColumn dataField="BIZRNM" headerText="'+ parent.fn_text('mfc_bizrnm')+ '" width="130"/>');
			layoutStr.push('			<DataGridColumn dataField="BIZRNO" headerText="'+ parent.fn_text('bizrno')+ '" width="130" formatter="{maskfmt1}"/>');
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM" headerText="'+ parent.fn_text('ctnr_nm')+ '" width="150"/>');
			layoutStr.push('			<DataGridColumn dataField="PRPS_NM" headerText="'+ parent.fn_text('prps_cd')+ '" width="80"/>');
			layoutStr.push('			<DataGridColumn dataField="CPCT_NM" headerText="'+ parent.fn_text('cpct_cd')+ '" width="100"/>');
			layoutStr.push('			<DataGridColumn dataField="DLIVY_QTY" headerText="'+ parent.fn_text('dlivy_qty2')+ '" width="100" id="sum1" textAlign="right" formatter="{numfmt}" />');
			layoutStr.push('			<DataGridColumn dataField="CFM_QTY" headerText="'+ parent.fn_text('rtn_qty2')+ '" width="100" id="sum2" textAlign="right" formatter="{numfmt}" />');
			layoutStr.push('			<DataGridColumn dataField="RMN_QTY" headerText="'+ parent.fn_text('rmn_qty')+ '" width="100" id="sum3" textAlign="right" formatter="{numfmt}" />');
			layoutStr.push('			<DataGridColumn dataField="STCK_QTY" headerText="'+ parent.fn_text('stck_qty')+ '" width="130" id="sum4" textAlign="right" formatter="{numfmt}" />');
			layoutStr.push('			<DataGridColumn dataField="DLIVY_QTY_2017" headerText="2017년 이후 '+ parent.fn_text('dlivy_qty2')+ '" width="150" id="sum5" textAlign="right" formatter="{numfmt}" />');
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="합계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum1}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum2}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum3}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum4}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{sum5}" formatter="{numfmt}" textAlign="right"/>');
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
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			selectorColumn = gridRoot.getObjectById("selector");
	
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	}
	
/****************************************** 그리드 셋팅 끝***************************************** */

</script>

<style type="text/css">
	.row .tit{width: 87px;}
</style>

</head>
<body>

    <div class="iframe_inner" >
    
   		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
		<input type="hidden" id="mfc_bizrnmList" value="<c:out value='${mfc_bizrnmList}' />" />
		<input type="hidden" id="ctnrSe" value="<c:out value='${ctnrSe}' />" />
		<input type="hidden" id="prpsCd" value="<c:out value='${prpsCd}' />" />
		
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
			<div class="btn" style="float:right" id="UR">
			</div>
		</div>
		
		<section class="secwrap" id="params">
			<div class="srcharea" > 
				<form name="frmSel" id="frmSel" method="post" >
				<div class="row">
					<div class="col">
						<div class="tit" id="mfc_bizrnm"></div>
						<div class="box">
							<select id="MFC_BIZRNM" name="MFC_BIZRNM" style="width:200px" ></select>
						</div>
					</div>
			
					<div class="col">
						<div class="tit" id="ctnr_se"></div>  <!-- 빈용기구분 -->
						<div class="box">
							<select id="CTNR_SE" name="CTNR_SE" style="width:90px" class="i_notnull" ></select>
							<select id="PRPS_CD" name="PRPS_CD" style="width:105px" class="i_notnull" ></select>
						</div>
					</div>
					
					<div class="col" >
						<div class="tit" id="ctnr_nm"></div>  <!-- 빈용기명 -->
						<div class="box" >
							<select id="CTNR_CD" name="CTNR_CD" style="width:200px" class="i_notnull" ></select>
						</div>
					</div>
				
					<div class="btn"  id="CR" ></div> <!--조회  -->
					 
				</div> <!-- end of row -->

				</form>	
			</div>  <!-- end of srcharea -->
		</section>
					
		<div class="boxarea mt10">
			<div id="gridHolder" style="height: 638px; background: #FFF;"></div>
		</div>	<!-- 그리드 셋팅 -->
			
		<section class="btnwrap mt10" style="" >
				<div class="btn" id="BL">
				</div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
		
</div>

<form name="frm" action="/jsp/file_down.jsp" method="post">
	<input type="hidden" name="fileName" value="" />
	<input type="hidden" name="saveFileName" value="" />
	<input type="hidden" name="downDiv" value="excel" />
</form>
	<div id="modal" class="searchModal"  style="display: none;">
		<div class="search-modal-content" >
			<h5> <img alt="" src="../../images/main/loading.gif"></h5>
		</div>
	</div>
</body>
</html>