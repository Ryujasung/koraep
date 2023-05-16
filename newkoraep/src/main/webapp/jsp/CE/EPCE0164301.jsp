<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>개별취급수수료관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>

<script type="text/javaScript" language="javascript" defer="defer">

	/* 페이징 사용 등록 */
	gridRowsPerPage = 15;	// 1페이지에서 보여줄 행 수
	gridCurrentPage = 1;	// 현재 페이지
	gridTotalRowCount = 0; //전체 행 수
	
	 var INQ_PARAMS;
     var mfcSeCdList;
     var bizrTpCd;
     var std_fee_yn;
     var toDay = kora.common.gfn_toDay();  // 현재 시간
	 var rowIndexValue ="";
	 var arr = new Array();
	 var arr2 = new Array();
     $(function() {
    	 
    	 INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
    	 mfcSeCdList = jsonObject($('#mfcSeCdList').val());
    	 bizrTpCd = jsonObject($('#bizrTpCd').val());
    	 std_fee_yn = jsonObject($('#std_fee_yn').val());
    	 
    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
    	 //그리드 셋팅
		 fnSetGrid1();
		 
		//text 셋팅
		$('#mfc_bizrnm').text(parent.fn_text('mfc_bizrnm'));			//생산자
		$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm'));	//잭매장/공장
		$('#ctnr_nm').text(parent.fn_text('ctnr_nm')); 			 		//빈용기명
		$('#bizr_tp_cd').text(parent.fn_text('bizr_tp_cd')); 			//거래처 구분
		$('#cust_bizrnm').text(parent.fn_text('cust_bizrnm')); 		//거래업체명
		$('#bizrno').text(parent.fn_text('bizrno')); 						//사업자번호
		$('#std_fee_reg_yn').text(parent.fn_text('std_fee_reg_yn')); //기준수수료여부
      
		/************************************
		 * 생산자 변경 이벤트
		 ***********************************/
		$("#MFC_SE_CD").change(function(){
			fn_mfc_se_cd();
		});
		
		/************************************
		 * 조회버튼 클릭 이벤트
		 ***********************************/
		$("#btn_sel").click(function(){
			//조회버튼 클릭시 페이징 초기화
			gridCurrentPage = 1;
			fn_sel();
		});
		
		/************************************
		 * 기준수수료조회 클릭 이벤트
		 ***********************************/
		$("#btn_pop").click(function(){
			fn_pop();
		});
		
		/************************************
		 * 삭제 클릭 이벤트
		 ***********************************/
		$("#btn_del").click(function(){
			fn_del_chk();
		});
		
		/************************************
		 * 변경 클릭 이벤트
		 ***********************************/
		$("#btn_upd").click(function(){
			fn_upd();
		});
		
		/************************************
		 * 추가 클릭 이벤트
		 ***********************************/
		$("#btn_reg").click(function(){
			fn_reg();
		});
		
		/************************************
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ***********************************/
		 $("#btn_excel").click(function() {
			 fn_excel();
		 });
		
		$("#MFC_BIZRNM  option").remove();
		
		 kora.common.setEtcCmBx2(std_fee_yn, "","", $("#STD_FEE_YN"), "ETC_CD", "ETC_CD_NM", "N" ,'T');		//기준수수료여부
		 kora.common.setEtcCmBx2(bizrTpCd, "","", $("#BIZR_TP_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');			//거래처구분
		 kora.common.setEtcCmBx2(mfcSeCdList, "","", $("#MFC_SE_CD"), "BIZRID_NO", "BIZRNM", "N" ,'T');		//생산자
		 kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'T');						//빈용기명
		 kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "BRCH_CD", "BRCH_NM", "N" ,'T');				//직매장/공장
	
		 //파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				kora.common.jsonToTable("params",INQ_PARAMS.SEL_PARAMS);
				/* 화면이동 페이징 셋팅 */
				gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
			}		 
	});
     
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
 		var fileName = $('#title').text() +"_" + today+hour+min+sec+".xlsx";
 		
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
 		input['fileName'] = fileName;
 		input['columns'] = JSON.stringify(col);
 		
 		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
 		
 		var url = "/CE/EPCE0164301_05.do";
 		ajaxPost(url, input, function(rtnData){
 			if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
 				alertMsg(rtnData.RSLT_MSG);
 			}else{
 				//파일다운로드
 				frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
 				frm.fileName.value = fileName;
 				frm.submit();
 			}
 			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar off
 		});
 	}
     
     //기준수수료 조회 팝업 호출
     function fn_pop(){
    			window.parent.NrvPub.AjaxPopup('/CE/EPCE0164388.do');
     }
     
     
   //생산자 변경시
     function fn_mfc_se_cd(){
	   	 $("#CTNR_CD  option").remove();
		 $("#MFC_BRCH_NM  option").remove();
		 $("#BIZR_TP_CD  option").remove();
    	 var url = "/CE/EPCE0164331_19.do" 
		 var input ={};
    	 
			     if( $("#MFC_SE_CD").val() !=""){
							arr= $("#MFC_SE_CD").val().split(";")
				   			input["BIZRID"] 	= arr[0];	 
							input["BIZRNO"]	= arr[1];
							showLoadingBar();
							ajaxPost(url, input, function(rtnData) {
										if ("" != rtnData && null != rtnData) {   
											 kora.common.setEtcCmBx2(rtnData.brchList, "","", $("#MFC_BRCH_NM"), "BRCH_CD", "BRCH_NM", "N" ,'T');  //직매장/공장 selectbox
											 kora.common.setEtcCmBx2(bizrTpCd, "","", $("#BIZR_TP_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');					//거래처구분
											 kora.common.setEtcCmBx2(rtnData.ctnrNmList, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'T'); 		//빈용기명 	   selectbox
										} else {
											alertMsg("error");
										}
								},false);
							hideLoadingBar();
					}else{
						 kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'T');						//빈용기명
						 kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "BRCH_CD", "BRCH_NM", "N" ,'T');				//직매장/공장
				   }
     }
     
	//조회
   function fn_sel(){
	    var url		=	"/CE/EPCE0164301_19.do";
		var input	= {};
			
			if($("#MFC_SE_CD").val() !=""){
				arr=	$("#MFC_SE_CD").val().split(";");
				input["BIZRID"] 				= arr[0];	 
				input["BIZRNO"] 				= arr[1];
			}
			
			if($("#MFC_BRCH_NM").val() !=""){
				arr2=	$("#MFC_BRCH_NM").val().split(";");
				input["MFC_BRCH_ID"] 		= arr2[0];
		   		input["MFC_BRCH_NO"]	= arr2[1];
			}
			
			input["CUST_BIZRNM"] 		= $("#CUST_BIZRNM").val();
			input["CUST_BIZRNO"] 		= $("#CUST_BIZRNO").val();
			input["CTNR_CD"] 			= $("#CTNR_CD	 		option:selected").val();
			input["BIZR_TP_CD"] 		= $("#BIZR_TP_CD		option:selected").val();
	   		input["STD_FEE_YN"] 		= $("#STD_FEE_YN").val();
			input["MFC_SE_CD"] 			= $("#MFC_SE_CD").val();
			input["MFC_BRCH_NM"] 	= $("#MFC_BRCH_NM").val();
	   		
	   		/* 페이징  */
			input["ROWS_PER_PAGE"] = gridRowsPerPage;
			input["CURRENT_PAGE"] 	= gridCurrentPage;
			INQ_PARAMS["SEL_PARAMS"] = input;
			
	   	    showLoadingBar();
     	    ajaxPost(url, input, function(rtnData) {
  				if ("" != rtnData && null != rtnData) {
  					gridApp.setData(rtnData.initList); 
  					gridTotalRowCount = rtnData.totalCnt; //총 카운트
					drawGridPagingNavigation(gridCurrentPage);
  				} else {
  					alertMsg("error");
  				}
  				hideLoadingBar(); 
  			}); 
   }
	
   /* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel(); //조회 펑션
	}
	
	 //개별취급수수료변경 페이지 이동
	function fn_upd(){
		var input = gridRoot.getItemAt(rowIndexValue);
		var selectorColumn = gridRoot.getObjectById("selector");
		
		if(selectorColumn.getSelectedIndices() == "") {
			alertMsg("선택한 건이 없습니다.");
			return false;
		}else if(input.STD_FEE_YN =="Y"){
			alertMsg("기준수수료등록이 표준인것은 변경하지 못합니다. ");
			return;
		}
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";     
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE0164301.do";
		kora.common.goPage('/CE/EPCE0164342.do', INQ_PARAMS);
		
	}
	 
	//개별취급수수료등록 페이지 이동
	function fn_reg(){
		INQ_PARAMS["FN_CALLBACK" ] = "fn_sel";    
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE0164301.do";
		kora.common.goPage('/CE/EPCE0164331.do', INQ_PARAMS);
	}
	
	//삭제여부
	function fn_del_chk(){
		//선택 건이 없을 경우 
		var selectorColumn = gridRoot.getObjectById("selector");
		var item = gridRoot.getItemAt(selectorColumn.getSelectedIndices());
		 if(selectorColumn.getSelectedIndices() == "") {
			 alertMsg(parent.fn_text('sel_not'))
				return false;
		 }else if(item.APLC_ST_DT<=toDay ){      //toDay>item["APLC_ST_DT"] && toDay>item["APLC_END_DT"]
		 		if(toDay <=item.APLC_END_DT){
					alertMsg("적용기간 시작일이 익일 이후인 경우만 삭제 가능합니다");
					return;
		 		}
		}
		 if(item.STD_FEE_YN =="Y"){
			alertMsg("기준수수료등록이 표준인것은 삭제하지 못합니다. ");
			return;
		}
		confirm(parent.fn_text('indv_fee')+" " +  parent.fn_text('info_del'),"fn_del");
		return;
	}
	
	
	//개별취급수수료 삭제
	function fn_del(){
		var input ={};
		var item = gridRoot.getItemAt(rowIndexValue);
		var url ="/CE/EPCE0164301_04.do";

		for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
			 input = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
		 }
		 input["SAVE_CHK"]			=	"U"
		 showLoadingBar(); 
		   ajaxPost(url, input, function(rtnData) {
  				if ("" != rtnData && null != rtnData) {
  					alertMsg(rtnData.RSLT_MSG);
  					if(rtnData.initList.length >0) gridApp.setData(rtnData.initList);
  				} else {
  					alertMsg("error");
  				}
  		},false);
  		hideLoadingBar(); 
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
			layoutStr.push('	<NumberMaskFormatter id="maskfmt1" formatString="###-##-#####"/>');
			layoutStr.push('	<NumberFormatter id="numfmt1" precision="1" useThousandsSeparator="true"/>');
			layoutStr	.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" horizontalScrollPolicy="on" draggableColumns="true" sortableColumns="true"   horizontalGridLines="true" headerHeight="60">');
			layoutStr.push('		<columns>');
			layoutStr	.push('			<DataGridSelectorColumn id="selector" headerText="'+ parent.fn_text('sel')+ '" width="50"	textAlign="center" allowMultipleSelection="false" />'); 							//선택
			layoutStr.push('			<DataGridColumn dataField="PNO" headerText="'+ parent.fn_text('sn')+ '" textAlign="center" width="50"   draggable="false"/>');
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM"    headerText="'+ parent.fn_text('mfc_bizrnm')	+ '"	width="180"	textAlign="center" />');	//생산자																		
			layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_NM" headerText="'+ parent.fn_text('mfc_brch_nm')	+ '"	width="180"	textAlign="center" />');	//직매장/공장																	
			layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNO"	 headerText="'+ parent.fn_text('cust_bizrno')	+ '"		width="130"	textAlign="center" formatter="{maskfmt1}" />');//도매업자 사업자번호
			layoutStr	.push('			<DataGridColumn dataField="CUST_BIZRNM"	 headerText="'+ parent.fn_text('cust_bizrnm')+ '"   	width="180"	textAlign="center" />');	//거래처 명
			layoutStr	.push('			<DataGridColumn dataField="CUST_BRCH_NM"  headerText="'+ parent.fn_text('brch_nm')+ '"   	width="180"	textAlign="center" />');	//거래처 명
			layoutStr	.push('			<DataGridColumn dataField="WHSL_FEE"	 headerText="'+ parent.fn_text('whsl_fee')	+ '"		width="100"	textAlign="right" formatter="{numfmt1}"/>');	//도매취급수수료
			layoutStr.push('			<DataGridColumn dataField="RTL_FEE"		headerText="'+ parent.fn_text('rtl_fee')+ '"				width="100"	textAlign="right" formatter="{numfmt1}"/>');	//소매취급수수료
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM"	 	 headerText="'+ parent.fn_text('ctnr_nm')	+ '"			width="200"	textAlign="center" />');									//빈용기명
			layoutStr.push('			<DataGridColumn dataField="APLC_DT"		 headerText="'+ parent.fn_text('aplc_dt')	+ '"			width="200"	textAlign="center" />'); //적용기간
			layoutStr.push('			<DataGridColumn dataField="STD_FEE_YN_NM" headerText="'+ parent.fn_text('std_fee_reg_yn')	+ '"	width="80"	textAlign="center" />'); //기준수수료여부
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

			rowIndexValue = rowIndex;
			selectorColumn.setSelectedIndex(-1);
			selectorColumn.setSelectedIndex(rowIndex);
		
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	}

	/**
	 * 그리드 loading bar on
	 */
	function showLoadingBar() {
		kora.common.showLoadingBar(dataGrid, gridRoot);
	}

	/**
	 * 그리드 loading bar off
	 */
	function hideLoadingBar() {
		kora.common.hideLoadingBar(dataGrid, gridRoot);
	}

/****************************************** 그리드 셋팅 끝***************************************** */


</script>

<style type="text/css">

.srcharea .row .col{
width: 23%;
} 
.srcharea .row .col .tit{
width: 70px;
}

</style>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="mfcSeCdList" value="<c:out value='${mfcSeCdList}' />"/>
<input type="hidden" id="bizrTpCd" value="<c:out value='${bizrTpCd}' />"/>
<input type="hidden" id="std_fee_yn" value="<c:out value='${std_fee_yn}' />"/>

    <div class="iframe_inner" id="testee" >
			<div class="h3group">
				<h3 class="tit" id="title"></h3>
				<div class="btn_box" id="UR"></div>
			</div>
		<section class="secwrap" id="params">
				<div class="srcharea"> <!-- 조회부분 -->
					<div class="row">
						<div class="col">
							<div class="tit" id="mfc_bizrnm"></div>  <!-- 생산자 -->
							<div class="box">
								<select id="MFC_SE_CD" style="width: 179px"></select>
							</div>
						</div>
						
						<div class="col">
							<div class="tit" id="mfc_brch_nm"></div>  <!-- 직매장/공장 -->
							<div class="box">
								<select id="MFC_BRCH_NM" style="width: 179px"></select>
							</div>
						</div>
				
					    <div class="col">
							<div class="tit" id="ctnr_nm"></div>  <!-- 빈용기명 -->
							<div class="box">
								<select id="CTNR_CD" style="width: 179px"></select>
							</div>
						</div>
						<div class="col">
							<div class="tit" id="std_fee_reg_yn" style="width: 116px;"></div>  <!-- 기준수수료여부 -->
							<div class="box">
								<select id="STD_FEE_YN" style="width: 90px"></select>
							</div>
						</div>
						
					</div> <!-- end of row -->
					
					<div class="row">
						<div class="col">
							<div class="tit" id="bizr_tp_cd"></div>  <!-- 거래처 구분 -->
							<div class="box">
								<select id="BIZR_TP_CD" style="width: 179px"></select>
							</div>
						</div>
						
						<div class="col">
							<div class="tit" id="cust_bizrnm"></div>  <!-- 업체명 -->
							<div class="box">
								<input type="text"  id="CUST_BIZRNM" style="width: 179px" maxByteLength="90"/>
							</div>
						</div>
						
						<div class="col">
							<div class="tit" id="bizrno"></div>  <!-- 사업자번호 -->
							<div class="box">
								<input type="text"  id="CUST_BIZRNO" style="width: 179px" format="number" maxlength="10"/>
							</div>
						</div>
				
					    <div class="btn">
								<button type="button" class="btn36 c1" style="width: 100px;" id="btn_sel">조회</button>
						</div>
					</div> <!-- end of row -->
				</div>  <!-- end of srcharea -->
			</section>
			
			<div class="boxarea mt10">
				<div id="gridHolder" style="height: 590px; background: #FFF;"></div>
				<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
			</div>	<!-- 그리드 셋팅 -->
			  <div class="h4group" >
				<h5 class="tit"  style="font-size: 16px;">
					&nbsp;&nbsp;※ 개별수수료 적용 내역을 조회합니다<br/>
	                &nbsp;&nbsp;※ 별도의 개별수수료 정보를 등록하지 않은 경우 기준수수료가 자동 적용됩니다. 
				</h5>
			</div>
		<section class="btnwrap"  style="height:50px">
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
		
</div>

	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="excel" />
	</form>

</body>
</html>