<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>반환정보조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>
<script type="text/javaScript" language="javascript" defer="defer">

	var sumData; /* 총합계 추가 */

	 /* 페이징 사용 등록 */
	 gridRowsPerPage = 30;// 1페이지에서 보여줄 행 수
	 gridCurrentPage = 1;// 현재 페이지
	 gridTotalRowCount = 0;//전체 행 수

	 var INQ_PARAMS;//파라미터 데이터
     var toDay = kora.common.gfn_toDay(); 	// 현재 시간
     var list_set_cnt = 0;
     var rtrvl_gtn_tot = 0;//그리드총 보증금합계
     var reg_rtrvl_fee_tot = 0;//그리드 소매수수료 총 합계
	 
     $(function() {
    	 
   		INQ_PARAMS 	= jsonObject($("#INQ_PARAMS").val()); //파라미터 데이터
  	  	
  	  	//기본셋팅
  	 	fn_init();
  	  	
	  	//버튼 셋팅
	   	fn_btnSetting();
	   	 
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
  		
	 });
     
     //초기화
     function fn_init(){
			 
		 	//날짜 셋팅
			$('#START_DT').YJcalendar({  
				toName : 'to',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
			 });
			$('#END_DT').YJcalendar({
				fromName : 'from',
				triggerBtn : true,
				dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
			 });  
			//text 셋팅
			$('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			
			//div필수값 alt
			$("#START_DT").attr('alt',parent.fn_text('sel_term'));   
			$("#END_DT").attr('alt',parent.fn_text('sel_term'));   
		
			//파라미터 조회조건으로 셋팅
			if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				kora.common.jsonToTable("params",INQ_PARAMS.SEL_PARAMS);
				/* 화면이동 페이징 셋팅 */
				gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
			}
			var layoutTr = new Array();	
			layoutTr.push('<tr class="rtrvl_tot" >');
			layoutTr.push('<td >도매업자</td>');
			layoutTr.push('<td >총 반환량</td>');
			layoutTr.push('<td >지급예정</td>');
			layoutTr.push('<td >지급완료</td>');
			layoutTr.push('<td >잔여 반환량</td>');
			layoutTr.push('<td >등록 미확인</td>');
			layoutTr.push('</tr>');
			$("#rtrvl_list").append(layoutTr.join("").toString());  
     }
	  
	//회수정보관리 조회
    function fn_sel(w_id,w_no){
		  rtrvl_gtn_tot = 0;
		  reg_rtrvl_fee_tot = 0;
		  var input	={};
		  var url = "/RT/EPRT9025801_193.do" 
		  var start_dt = $("#START_DT").val();
		  var end_dt = $("#END_DT").val();
		  start_dt = start_dt.replace(/-/gi, "");
	 	  end_dt = end_dt.replace(/-/gi, "");
	
		 //날짜 정합성 체크. 20160204
		 if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
			alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return; 
		 }else if(start_dt>end_dt){
			alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return;
		 } 
		  if(w_id !=undefined ){
			  input["WHSDL_BIZRID"] = w_id;
			  input["WHSDL_BIZRNO"] = w_no;
		  }
		 
		input["START_DT"] = $("#START_DT").val();//날짜
		input["END_DT"] = $("#END_DT").val();
		
		/* 페이징  */
		input["ROWS_PER_PAGE"] = gridRowsPerPage;
		input["CURRENT_PAGE"] = gridCurrentPage;
		INQ_PARAMS["SEL_PARAMS"] = input;
		
		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
      	ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {
   					gridApp.setData(rtnData.selList);
   					/* 페이징 표시 */
   					
   					if(rtnData.selList.length>0){
						gridTotalRowCount = rtnData.selList[0].TOTAL_CNT; //총 카운트
   					}
					drawGridPagingNavigation(gridCurrentPage);
					
					sumData = rtnData.totalList[0]; /* 총합계 추가 */
					
					$("#rtrvl_list").children().remove();
					
					var layoutTr_init = new Array();
					layoutTr_init.push('<tr class="rtrvl_tot" >');
					layoutTr_init.push('<td >도매업자</td>');
					layoutTr_init.push('<td >총 반환량</td>');
					layoutTr_init.push('<td >지급예정</td>');
					layoutTr_init.push('<td >지급완료</td>');
					layoutTr_init.push('<td >잔여 반환량</td>');
					layoutTr_init.push('<td >등록 미확인</td>');
					layoutTr_init.push('</tr>');
					$("#rtrvl_list").append(layoutTr_init.join("").toString());
					
					$.each(rtnData.rtrvl_tot_list, function(i, v){	
						var layoutTr = new Array();	
						layoutTr.push('<tr>');					  
						layoutTr.push('	<td style="text-decoration: underline !important; cursor: pointer;"  onclick=fn_sel("'+v.WHSDL_BIZRID+'","'+v.WHSDL_BIZRNO+'") >'+v.WHSDL_BIZRNM+'</td>');//도매업자   
						layoutTr.push('	<td >'+v.T1+'</td>');//총반환량   모든상태 유흥+가정
						layoutTr.push('	<td >'+v.T2+'</td>');//지급예정	회수확인,소매&도매확인 상태   	유흥+가정   
						layoutTr.push('	<td >'+v.T3+'</td>');//지급완료	지급확인 상태   						유흥+가정
						layoutTr.push('	<td >'+v.T4+'</td>');//잔여반환량	총반환량 -(지급예정+지급완료)
						layoutTr.push('	<td >'+v.T5+'</td>');//등록미확인	도매&소매등록  상태  				유흥+가정
						layoutTr.push('</tr>');
						$("#rtrvl_list").append(layoutTr.join("").toString());  
						rtrvl_gtn_tot 		+=v.RTRVL_GTN_TOT;
						reg_rtrvl_fee_tot 	+=v.REG_RTRVL_FEE_TOT;
					});	
					
   				}else{
   						 alertMsg("error");
   				}
      			kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
      			window.frameElement.style.height = $('.iframe_inner').height()+'px'; //height 조정
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
		var url="";
		if(dataVal == 1){
			url="/RT/EPRT9025864.do";
		}else{
			url="/RT/EPRT9025842.do";
		}
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["PARAMS"] = {};
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/RT/EPRT9025801.do";  
		kora.common.goPage(url, INQ_PARAMS);  
	}
	function statChg_chk(){
		confirm("선택하신 내역을 확인 처리 하시겠습니까?","statChg");
	}
	//확인상태변경
	function statChg(){
		var idx = dataGrid.getSelectedIndices();
		var input = gridRoot.getItemAt(idx);
		var url = "/RT/EPRT9025801_21.do"
		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
	 	ajaxPost(url, input, function(rtnData) {
	 		if(rtnData.RSLT_CD == "0000"){
				fn_sel();
				alertMsg(rtnData.RSLT_MSG);
			}else{
				alertMsg(rtnData.RSLT_MSG);
			}
	 		kora.common.hideLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
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
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" sortableColumns="true"   headerHeight="35">');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridColumn dataField="PNO" headerText="'+ parent.fn_text('sn')+ '" width="5%" textAlign="center"	 draggable="false"/>');//순번
			layoutStr.push('			<DataGridColumn dataField="RTRVL_REG_DT" headerText="'+ parent.fn_text('rtn_reg_dt')+ '"  width="15%" textAlign="center" />');//반환등록일자
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRNM" headerText="'+ parent.fn_text('whsdl')+ '" width="20%" textAlign="center"	 itemRenderer="HtmlItem" />');//도매업자
			layoutStr.push('			<DataGridColumn dataField="RTRVL_STAT_NM" headerText="'+ parent.fn_text('stat')+ '" width="15%" textAlign="center"	/>');//상태
			layoutStr.push('			<DataGridColumn dataField="RTRVL_QTY_TOT" headerText="'+ parent.fn_text('rtn_qty2')+ '" width="10%" textAlign="right" formatter="{numfmt}" id="num1"/>');//반환량
			layoutStr.push('			<DataGridColumn dataField="RTRVL_GTN_TOT" headerText="'+ parent.fn_text('dps2')+ '" width="10%" textAlign="right" formatter="{numfmt}" id="num2"/>');//보증금
			layoutStr.push('			<DataGridColumn dataField="REG_RTRVL_FEE_TOT" headerText="'+ parent.fn_text('rtl_fee2')+ '" width="10%" textAlign="right" formatter="{numfmt}" id="num3" />');//소매수수료
			layoutStr.push('			<DataGridColumn dataField="ATM_TOT" headerText="'+ parent.fn_text('sum')+ '" width="10%" textAlign="right" formatter="{numfmt}" id="num4" />');//합계
			layoutStr.push('			<DataGridColumn dataField="CFM_PROC" headerText="'+ parent.fn_text('cfm')+ '" width="10%" textAlign="center" itemRenderer="HtmlItem" id="tmp1" />');//확인
			layoutStr.push('			<DataGridColumn dataField="RTN_DATA_CHG" headerText="'+ parent.fn_text('chg')+ '" width="10%" textAlign="center"  itemRenderer="HtmlItem" id="tmp2" />');//변경
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="소계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp1}"/>');
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp2}"/>');
			layoutStr.push('			</DataGridFooter>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="총합계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum1" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum2" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum3" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum4" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp1}"/>');
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp2}"/>');
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
		gridApp.setData();
		var layoutCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			dataGrid.addEventListener("change", selectionChangeHandler);

			 //파라미터 call back function 실행
			 if(kora.common.null2void(INQ_PARAMS.FN_CALLBACK) != ""){
					/* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
			 	 window[INQ_PARAMS.FN_CALLBACK]();
			 	//취약점점검 6004 기원우
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

	/* 총합계 추가 */
	function totalsum1(column, data) {
		if(sumData) 
			return sumData.RTRVL_QTY_TOT; 
		else 
			return 0;
	}
	function totalsum2(column, data) {
		if(sumData) 
			return sumData.RTRVL_GTN_TOT; 
		else 
			return 0;
	}
	function totalsum3(column, data) {
		if(sumData) 
			return sumData.REG_RTRVL_FEE_TOT; 
		else 
			return 0;
	}
	function totalsum4(column, data) {
		if(sumData) 
			return sumData.ATM_TOT; 
		else 
			return 0;
	}
	/* 총합계 추가 */
	
/****************************************** 그리드 셋팅 끝***************************************** */
</script>

<style type="text/css">
.srcharea .row .col{
/* width: 28%; */
}  
.srcharea .row .col .tit{
width: 85px;
}


.info_tbl table tbody .rtrvl_tot td{
    background: #478bbd;
    font-weight: 700;
    font-size: 15px;
    color: #fcfbfb;
}
</style>

</head>
<body>
	    <div class="iframe_inner"  >
				<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
				<div class="h3group">
					<h3 class="tit" id="title"></h3>
					<div class="btn" style="float:right" id="UR"></div>
				</div>
				<section class="secwrap"  id="params">
						<div class="srcharea" > 
								<div class="row" >
										<div class="col"  style="">
											<div class="tit" id="sel_term_txt"></div>	<!-- 조회기간 -->
											<div class="box">
												<div class="calendar">
													<input type="text" id="START_DT" name="from" style="width: 200px;" class="i_notnull"><!--시작날짜  -->
												</div>
												<div class="obj">~</div>
												<div class="calendar">
													<input type="text" id="END_DT" name="to" style="width: 200px;"	class="i_notnull"><!-- 끝날짜 -->
												</div>
											</div>
										</div>
										<div class="btn"  id="CR" ></div>
								</div> <!-- end of row -->	
						</div>  <!-- end of srcharea -->
				</section><!-- end of <section class="secwrap"  id="params"> -->
				<section class="secwrap2 mt20">
						<div class="boxarea">
							<div class="info_tbl">
								<table style="width: 100%;">
									<colgroup>
										<col style="width: 15%;">
										<col style="width: 17%;">
										<col style="width: 17%;">
										<col style="width: 17%;">
										<col style="width: 17%;">
										<col style="width: 17%;;">
									</colgroup>
									<tbody id='rtrvl_list'></tbody>
								</table>
							</div>
						</div><!-- end of <div class="boxarea"> -->
				</section> <!-- end of <section class="secwrap2 mt20"> -->
				<section class="btnwrap mt10"  >	<!--그리드설정  -->
					<div class="btn" id="CL"></div>
				</section>
				<div class="boxarea mt10">  <!-- 634 -->
					<div id="gridHolder" style="height: 634px; background: #FFF;"></div>
				   	<div class="gridPaging" id="gridPageNavigationDiv"  ></div><!-- 페이징 사용 등록 -->
				</div>	<!-- 그리드 셋팅 -->
				<section class="btnwrap" style="" >
						<div class="btn" id="BL"></div>
						<div class="btn" style="float:right" id="BR"></div>
				</section>
		</div><!-- end of  <div class="iframe_inner"  >  -->
</body>
</html>
