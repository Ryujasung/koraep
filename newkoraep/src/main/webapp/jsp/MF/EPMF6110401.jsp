<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>입고현황</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>

<!-- rMateChart -->
<link rel="stylesheet" type="text/css" href="/rMateChart/rMateChartH5/Assets/Css/rMateChartH5.css"/>
<script language="javascript" type="text/javascript" src="/rMateChart/LicenseKey/rMateChartH5License.js"></script>
<script language="javascript" type="text/javascript" src="/rMateChart/rMateChartH5/JS/rMateChartH5.js"></script>
<script type="text/javascript" src="/rMateChart/rMateChartH5/Assets/Theme/theme.js"></script>

<!-- 샘플 작동을 위한 css와 js -->
<script type="text/javascript" src="/rMateChart/Web/JS/common.js"></script>
<script type="text/javascript" src="/rMateChart/Web/JS/sample_util.js"></script>
<link rel="stylesheet" type="text/css" href="/rMateChart/Web/sample.css"/>

<!-- SyntaxHighlighter -->
<script type="text/javascript" src="/rMateChart/Web/syntax/shCore.js"></script>
<script type="text/javascript" src="/rMateChart/Web/syntax/shBrushJScript.js"></script>
<link type="text/css" rel="stylesheet" href="/rMateChart/Web/syntax/shCoreDefault.css"/>
<!-- rMateChart -->

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
width: 240px; /* Could be more or less, depending on screen size */
border-radius:10px; 
}
</style>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />
<script type="text/javaScript" language="javascript" defer="defer">

	var sumData; /* 총합계 추가 */

	/* 페이징 사용 등록 */
	gridRowsPerPage = 15;	// 1페이지에서 보여줄 행 수
	gridCurrentPage = 1;	// 현재 페이지
	gridTotalRowCount = 0; //전체 행 수
	 var INQ_PARAMS 	= ${INQ_PARAMS}; 			//파라미터 데이터
	 var prps_cd = ${prps_cd};							//용도
     var ctnr_cd=${ctnr_cd}; 								//빈용기
     var mfc_bizrnmList 	= ${mfc_bizrnmList};			//생산자
     var areaList 			= ${areaList};					//지역
     var whsl_se_cdList 	= ${whsl_se_cdList};			//도매업자구분
     var whsdlList 			= ${whsdlList};					//도매업자 업체명 조회
     var toDay = kora.common.gfn_toDay(); 			// 현재 시간
	 var rowIndexValue =0;									//그리드 선택value
 	 var arr 	= new Array();									//생산자
	 var arr2 = new Array();								//도매업자
	 var pagingCurrent = 1;
	 
    $(function() {
    	 
    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
    	 //그리드 셋팅
		 fnSetGrid1(false);
		
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
		$('#title_sub').text('<c:out value="${titleSub}" />');						  															//타이틀
		$('#sel_term').text(parent.fn_text('sel_term'));																	//조회기간
		$('#stat').text(parent.fn_text('stat')); 																				//상태
		$('#mfc_bizrnm').text(parent.fn_text('mfc_bizrnm')); 														//반환대상생산자
		$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm')); 													//반환대상지점
		$('#reg_se').text(parent.fn_text('reg_se')); 																		//등록구분
		$('#whsl_se_cd').text(parent.fn_text('whsl_se_cd'));															//도매업자 구분
		$('#enp_nm').text(parent.fn_text('enp_nm'));																	//업체명
		$('#area').text(parent.fn_text('area')); 																			//지역
		$('#prps_cd').text(parent.fn_text('prps_cd')); 																	//용도
		$('#ctnr_nm').text(parent.fn_text('ctnr_nm')); 																	//빈용기명
		
		//div필수값 alt
		 $("#START_DT").attr('alt',parent.fn_text('sel_term'));   
		 $("#END_DT").attr('alt',parent.fn_text('sel_term'));   
	 
		/************************************
		 * 용도 변경 이벤트
		 ***********************************/
		$("#PRPS_CD").change(function(){
			fn_prps_cd();
		});
		 
		/************************************
		 * 생산자 구분 변경 이벤트
		 ***********************************/
		$("#MFC_BIZRNM").change(function(){
			fn_mfc_bizrnm();
		});
		
		/************************************
		 * 도매업자 구분 변경 이벤트
		 ***********************************/
		$("#WHSL_SE_CD").change(function(){
			fn_whsl_se_cd();
		});
		
		/************************************
		 * 도매업자  변경 이벤트
		 ***********************************/
		$("#WHSDL_BIZRNM").change(function(){
			//fn_whsdl_bizrnm();
		});

		/************************************
		 * 조회 클릭 이벤트
		 ***********************************/
		$("#btn_sel").click(function(){
			//조회버튼 클릭시 페이징 초기화
			gridCurrentPage = 1;
			fn_sel("Y");
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
		
		/************************************
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_excel").click(function() {
			fn_excel();
		 });
		
  		fn_init();
  		
  		$("#WHSDL_BIZRNM").select2();
  		
	});
     
     //초기화
     function fn_init(){
			 kora.common.setEtcCmBx2(prps_cd, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');									//용도
			 kora.common.setEtcCmBx2(ctnr_cd, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'T');									//빈용기명
			 kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'E');					//생산자
			 kora.common.setEtcCmBx2(areaList, "","", $("#AREA"), "ETC_CD", "ETC_CD_NM", "N" ,'T');											//지역
			 kora.common.setEtcCmBx2(whsl_se_cdList, "","", $("#WHSL_SE_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');						//도매업자구분 
			 kora.common.setEtcCmBx2(whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');		//도매업자 업체명
			 $("#START_DT").val(kora.common.getDate("yyyy-mm-dd", "D", -7, false));  															//일주일전 날짜 
			 $("#END_DT").val(kora.common.getDate("yyyy-mm-dd", "D", 0, false)); 																//현재 날짜
     }
     
     //용도 변경시 빈용기명 조회
     function fn_prps_cd(){
		var url = "/MF/EPMF6110401_192.do" 
		var input ={};
	    input["PRPS_CD"] =$("#PRPS_CD").val();
	    if( $("#MFC_BIZRNM").val() !="" ){ //생산자 선택시 해당 빈용기만 조회
   				input["MFC_BIZRID"]			= arr[0];	//빈용기 테이블 조회
   				input["MFC_BIZRNO"]		= arr[1];
	    }
		if($("#WHSDL_BIZRNM").val() !=""){	 //도매업자 선택시
		 	input["CUST_BIZRID"] 		= arr2[0];    	//도매업자아이디    
			input["CUST_BIZRNO"] 		= arr2[1];    	//도매업자사업자번호  
		 } 
      	ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {  
   					 	kora.common.setEtcCmBx2(rtnData.ctnr_cd, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'T');		 //빈용기명
   				}else{
   						 alertMsg("error");
   				}
   		 },false);
     }

     //생산자 변경시 생산자랑 거래중인 도매업자 조회 
     function fn_mfc_bizrnm(){
  			var url 				= "/MF/EPMF6110401_19.do" 
  			var input 			= {};
  			 input["PRPS_CD"] =$("#PRPS_CD").val();
    		 if($("#WHSL_SE_CD").val() !=""){
        		 input["BIZR_TP_CD"]	=$("#WHSL_SE_CD").val();
      			 }
  			if( $("#MFC_BIZRNM").val() ==""){ 	//생산자 전체로 검색시
  				input["MFC_BIZRID"]		="";  
  	  			input["MFC_BIZRNO"]	="";
  		   }else{
	  			arr	 =[];
	   			arr	 = $("#MFC_BIZRNM").val().split(";");
	   			input["MFC_BIZRID"]		= arr[0];  
	   			input["MFC_BIZRNO"]	= arr[1];
  		   }
      					$("#WHSDL_BIZRNM").select2("val","");
         	  ajaxPost(url, input, function(rtnData) {
      				if ("" != rtnData && null != rtnData) {   
      					kora.common.setEtcCmBx2(whsl_se_cdList, "","", $("#WHSL_SE_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');						//도매업자구분 
      					kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');	//도매업자 업체명
      					kora.common.setEtcCmBx2(prps_cd, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');				//용도
      					kora.common.setEtcCmBx2(rtnData.ctnr_cd, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'T');		 //빈용기명
      				}else{
      						 alertMsg("error");
      				}
      		},false);
     }
     
    //도매업자구분 변경시 도매업자 조회 ,생산자가 선택됐을경우 거래중인 도매업자만 조회
     function fn_whsl_se_cd(){
    	var url = "/MF/EPMF6110401_19.do" 
		var input ={};
		   if($("#WHSL_SE_CD").val() !=""){
		  		 	input["BIZR_TP_CD"] =$("#WHSL_SE_CD").val();
		   }
		   if( $("#MFC_BIZRNM").val() !="" ){ //생산자 선택시 선택된 생산자랑 거래중인 도매업자 조회
    				input["MFC_BIZRID"]		= arr[0];
    				input["MFC_BIZRNO"]	= arr[1];
		   }
    						$("#WHSDL_BIZRNM").select2("val","");
       	   ajaxPost(url, input, function(rtnData) {
    				if ("" != rtnData && null != rtnData) {  
    					 	kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');		 //업체명
    				}else{
    						 alertMsg("error");
    				}
    		},false);
     }
 
   //도매업자 변경시 생산자랑 거래중인 빈용기명만 조회
   function fn_whsdl_bizrnm(){
	   var url = "/MF/EPMF6110401_192.do" 
			var input ={};
		    input["PRPS_CD"] =$("#PRPS_CD").val();
			
		    if( $("#MFC_BIZRNM").val() !="" ){ //생산자 선택시 해당 빈용기만 조회
	   				input["MFC_BIZRID"]		= arr[0]; 
	   	  			input["MFC_BIZRNO"]	= arr[1];
		    }
		    if( $("#WHSDL_BIZRNM").val() !="" ){ 
		    	arr2	=[];
		    	arr2 	=$("#WHSDL_BIZRNM").val().split(";");
			 	input["CUST_BIZRID"] 		= arr2[0];    	//도매업자아이디    
				input["CUST_BIZRNO"] 		= arr2[1];    	//도매업자사업자번호  
	   		}else{
	   			arr2	=[];
	   		}
	      	ajaxPost(url, input, function(rtnData) {
	   				if ("" != rtnData && null != rtnData) {  
	   					 	kora.common.setEtcCmBx2(rtnData.ctnr_cd, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'T');		 //빈용기명
	   					 	kora.common.setEtcCmBx2(prps_cd, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');									//용도
	   				}else{
	   						 alertMsg("error");
	   				}
	   		 },false);
   }
   //입고현황 조회
    function fn_sel(chartYN){
			 var input	={};
			 var url = "/MF/EPMF6110401_193.do" 
			 var start_dt 			= $("#START_DT").val();
			 var end_dt    			= $("#END_DT").val();
			 pagingCurrent = 1;
		     start_dt   =  start_dt.replace(/-/gi, "");
		     end_dt    =  end_dt.replace(/-/gi, "");
			//날짜 정합성 체크
			if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
				alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
				return; 
			}
			if(start_dt>end_dt){
				alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
				return;
			} 
		 
		 if($("#MFC_BIZRNM").val() !="" ){		//생산자
			 var mfc_bizrnm	 	= $("#MFC_BIZRNM").val();	 
			 arr	 =[];
			 arr	 = mfc_bizrnm.split(";");
			 input["MFC_BIZRID"]   		= arr[0];
			 input["MFC_BIZRNO"]  	= arr[1];
		 }
		 if($("#WHSDL_BIZRNM").val() !="" ){		//생산자
			arr2	=[];
	    	arr2 	=$("#WHSDL_BIZRNM").val().split(";");
			input["WHSDL_BIZRID"]   	= arr2[0];
			input["WHSDL_BIZRNO"] 	= arr2[1];
		 }
		 
		 //조회 SELECT변수값
		 input["AREA_CD"]   			= $("#AREA").val();			
		 input["PRPS_CD"] 			= $("#PRPS_CD").val();
		 input["CTNR_CD"] 			= $("#CTNR_CD").val();
		 input["START_DT"]			= $("#START_DT").val();			
		 input["END_DT"]				= $("#END_DT").val();			
		 input["BIZR_TP_CD"]   		= $("#WHSL_SE_CD").val();		//도매업자 구분
		 input["CHART_YN"]   		= chartYN;
		 
		/* 페이징  */
		input["ROWS_PER_PAGE"] = gridRowsPerPage;
		input["CURRENT_PAGE"] 	= gridCurrentPage;
			
		INQ_PARAMS["SEL_PARAMS"] = input;
// 	  	showLoadingBar();
$("#modal").show();
   	   	ajaxPost(url, input, function(rtnData) {
				if ("" != rtnData && null != rtnData) {   
					gridApp.setData(rtnData.selList);
					if(chartYN =="Y"){
						//if(rtnData.selList_chart.length)
							if(rtnData.selList_chart.length>0){
							chartApp.setData(rtnData.selList_chart);
							}else{
								chartApp.setData(chartData);
							}		
					}
					
					var fb_cfm_qty_tot = 0;	//유흥
					var fh_cfm_qty_tot = 0;	//가정
					var drct_cfm_qty_tot = 0;	//직접
					var cfm_qty_tot = 0;		//통합
					
					for(var i in rtnData.selList_chart){
						fb_cfm_qty_tot += Number(rtnData.selList_chart[i].FB_CFM_QTY_TOT);
						fh_cfm_qty_tot += Number(rtnData.selList_chart[i].FH_CFM_QTY_TOT);
						drct_cfm_qty_tot += Number(rtnData.selList_chart[i].DRCT_CFM_QTY_TOT);
						cfm_qty_tot += Number(rtnData.selList_chart[i].CFM_QTY_TOT);
					}
					
					$('#FB_CFM_QTY_TOT').text(kora.common.format_comma(fb_cfm_qty_tot));
					$('#FH_CFM_QTY_TOT').text(kora.common.format_comma(fh_cfm_qty_tot));
					$('#DRCT_CFM_QTY_TOT').text(kora.common.format_comma(drct_cfm_qty_tot));
					$('#CFM_QTY_TOT').text(kora.common.format_comma(cfm_qty_tot));
					
					
					/* 페이징 표시 */
					gridTotalRowCount = parseInt(rtnData.totalList[0].CNT); //총 카운트 	/* 총합계 추가 */
					drawGridPagingNavigation(gridCurrentPage);
					
					sumData = rtnData.totalList[0]; /* 총합계 추가 */
					
				}else{
					alertMsg("error");
				}
// 				hideLoadingBar(); 
				$("#modal").hide();
		}); 
		
    }
   
    /* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel(); //조회 펑션
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
		var fileName = $('#title_sub').text() +"_" + today+hour+min+sec+".xlsx";
		
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
		var url = "/MF/EPMF6110401_05.do";
		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
				alertMsg(rtnData.RSLT_MSG);
			}else{
				//파일다운로드
				frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
				frm.fileName.value = fileName;
				frm.submit();
			}
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
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true"  sortableColumns="true"   headerHeight="35">');
			layoutStr.push('		<groupedColumns>');   	
			layoutStr.push('			<DataGridColumn dataField="PNO" 				headerText="'+ parent.fn_text('sn')+ '"  				width="80" 	textAlign="center"  />');													//순번
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM" 	headerText="'+ parent.fn_text('mfc_bizrnm')+ '"  	width="150"  	textAlign="center" />');													//생산자
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRNM" headerText="'+ parent.fn_text('whsdl')+ '"   		width="150" 	textAlign="center"  />'); 													//도매업자
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRNO_DE" headerText="'+ parent.fn_text('whsdl_bizrno')+ '" formatter="{maskfmt1}" width="170" 	textAlign="center"  />'); 													//도매업자
			layoutStr.push('			<DataGridColumn dataField="AREA"				headerText="'+ parent.fn_text('area')+ '"   			width="100" 	textAlign="center"  />'); 													//지역
			layoutStr.push('			<DataGridColumn dataField="PRPS_CD"  	 	headerText="'+ parent.fn_text('prps_cd')+ '"		width="150"	textAlign="center"  />');													//용도(유흥용/가정용)
			layoutStr.push('            <DataGridColumn dataField="STANDARD_NM"     headerText="용기구분"        width="100" textAlign="center"  />'); 															//표준/비표준용기 구분
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM"  	 	headerText="'+ parent.fn_text('ctnr_nm')+ '"		width="250" 	textAlign="center"  />');													//빈용기명
			layoutStr.push('			<DataGridColumn dataField="CPCT_CD"  	 	headerText="'+ parent.fn_text('cpct')+'"				width="150" 	textAlign="center"  />');													//용량(ml)]
			layoutStr.push('			<DataGridColumn dataField="QTY_TOT" 		headerText="'+ parent.fn_text('wrhs_qty')+ '" 	width="150" 	textAlign="right"  formatter="{numfmt}" id="num1" />');	//입고량
			layoutStr.push('			<DataGridColumn dataField="CRCT_QTY_TOT" 		headerText="'+ parent.fn_text('crct_wrhs_qty')+ '" 	width="150" 	textAlign="right"  formatter="{numfmt}" id="num2" />');	//입고량
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="소계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('			</DataGridFooter>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="총합계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum1" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum2" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	
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
			 	//취약점점검 5994 기원우
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
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
	}

	/**
	 * 그리드 loading bar on
	 */
	function showLoadingBar() {
		if (dataGrid != null && dataGrid != "undefined") {
			dataGrid.setEnabled(false);
			gridRoot.addLoadingBar();
		}
	}

	/**
	 * 그리드 loading bar off
	 */
	function hideLoadingBar() {
		if (dataGrid != null && dataGrid != "undefined") {
			dataGrid.setEnabled(true);
			gridRoot.removeLoadingBar();
		}
	}
	
	
	/* 총합계 추가 */
	function totalsum1(column, data) {
		if(sumData) 
			return sumData.QTY_TOT; 
		else 
			return 0;
	}
	function totalsum2(column, data) {
		if(sumData) 
			return sumData.CRCT_QTY_TOT; 
		else 
			return 0;
	}
	/* 총합계 추가 */
	
/****************************************** 그리드 셋팅 끝***************************************** */

	// -----------------------차트 설정 시작-----------------------
	 
	// rMate 차트 생성 준비가 완료된 상태 시 호출할 함수를 지정합니다.
	var chartVars = "rMateOnLoadCallFunction=chartReadyHandler";
	var layoutStrChart, chartApp;
	 
	// rMateChart 를 생성합니다.
	// 파라메터 (순서대로) 
	//  1. 차트의 id ( 임의로 지정하십시오. ) 
	//  2. 차트가 위치할 div 의 id (즉, 차트의 부모 div 의 id 입니다.)
	//  3. 차트 생성 시 필요한 환경 변수들의 묶음인 chartVars
	//  4. 차트의 가로 사이즈 (생략 가능, 생략 시 100%)
	//  5. 차트의 세로 사이즈 (생략 가능, 생략 시 100%)
	rMateChartH5.create("rChart", "chartHolder", chartVars, "100%", "100%"); 
	 
	// 차트의 속성인 rMateOnLoadCallFunction 으로 설정된 함수.
	// rMate 차트 준비가 완료된 경우 이 함수가 호출됩니다.
	// 이 함수를 통해 차트에 레이아웃과 데이터를 삽입합니다.
	// 파라메터 : id - rMateChartH5.create() 사용 시 사용자가 지정한 id 입니다.
	function chartReadyHandler(id) {
		chartApp = document.getElementById(id);
		chartApp.setLayout(layoutStrChart.join("").toString());
	}
	 
	// 스트링 형식으로 레이아웃 정의.
	layoutStrChart = new Array();
	layoutStrChart.push('<rMateChart backgroundColor="#FFFFFF"  borderStyle="none">');
	layoutStrChart.push('    <Options>');
	//layoutStrChart.push('        <Caption text=""/>');
	//layoutStrChart.push('         <SubCaption text="" textAlign="right" />');
	layoutStrChart.push('        <Legend defaultMouseOverAction="false" useVisibleCheck="false"/>');
	layoutStrChart.push('      </Options>');
	layoutStrChart.push('  <NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
	layoutStrChart.push('   <Column3DChart showDataTips="true" cubeAngleRatio="1" columnWidthRatio="0.7" >');
	layoutStrChart.push('       <horizontalAxis>');
	layoutStrChart.push('             <CategoryAxis categoryField="BIZRNM"/>');
	layoutStrChart.push('       </horizontalAxis>');
	layoutStrChart.push('        <verticalAxis>');
	layoutStrChart.push('           <LinearAxis formatter="{numfmt}" />');
	layoutStrChart.push('       </verticalAxis>');
	layoutStrChart.push('          <series>');
	layoutStrChart.push('             <Column3DSeries labelPosition="outside" yField="FB_CFM_QTY_TOT" displayName="유흥용"  showValueLabels="[]"  outsideLabelYOffset="-10" showTotalLabel="true" halfWidthOffset="0" itemRenderer="CylinderItemRenderer">');
	layoutStrChart.push('                  <showDataEffect>');
	layoutStrChart.push('                     <SeriesInterpolate/>');
	layoutStrChart.push('                </showDataEffect>');
	layoutStrChart.push('            </Column3DSeries>');
	layoutStrChart.push('            <Column3DSeries labelPosition="outside" yField="FH_CFM_QTY_TOT" displayName="가정용"  showValueLabels="[]" outsideLabelYOffset="-10" showTotalLabel="true" halfWidthOffset="0" itemRenderer="CylinderItemRenderer">');
	layoutStrChart.push('                <showDataEffect>');
	layoutStrChart.push('                     <SeriesInterpolate/>');
	layoutStrChart.push('                </showDataEffect>');
	layoutStrChart.push('            </Column3DSeries>');
	layoutStrChart.push('            <Column3DSeries labelPosition="outside" yField="DRCT_CFM_QTY_TOT" displayName="직접반환하는자용"  showValueLabels="[]"  outsideLabelYOffset="-10" showTotalLabel="true" halfWidthOffset="0" itemRenderer="CylinderItemRenderer">');
	layoutStrChart.push('                  <showDataEffect>');
	layoutStrChart.push('                     <SeriesInterpolate/>');
	layoutStrChart.push('                </showDataEffect>');
	layoutStrChart.push('            </Column3DSeries>');
	layoutStrChart.push('        </series>');
	layoutStrChart.push('    </Column3DChart>');
	layoutStrChart.push(' </rMateChart>');
	 
	// 차트 데이터
	var chartData = [{BIZRNM:"",FB_CFM_QTY_TOT:0,FH_CFM_QTY_TOT:0,DRCT_CFM_QTY_TOT:0}];
	 
	/**
	 * rMateChartH5 3.0이후 버전에서 제공하고 있는 테마기능을 사용하시려면 아래 내용을 설정하여 주십시오.
	 * 테마 기능을 사용하지 않으시려면 아래 내용은 삭제 혹은 주석처리 하셔도 됩니다.
	 *
	 * -- rMateChartH5.themes에 등록되어있는 테마 목록 --
	 * - simple
	 * - cyber
	 * - modern
	 * - lovely
	 * - pastel
	 * -------------------------------------------------
	 *
	 * rMateChartH5.themes 변수는 theme.js에서 정의하고 있습니다.
	 */
	rMateChartH5.registerTheme(rMateChartH5.themes);
	 
	/**
	 * 샘플 내의 테마 버튼 클릭 시 호출되는 함수입니다.
	 * 접근하는 차트 객체의 테마를 변경합니다.
	 * 파라메터로 넘어오는 값
	 * - simple
	 * - cyber
	 * - modern
	 * - lovely
	 * - pastel
	 * - default
	 *
	 * default : 테마를 적용하기 전 기본 형태를 출력합니다.
	 */
	function rMateChartH5ChangeTheme(theme){
		 chartApp.setTheme(theme);
	}
	 
	// -----------------------차트 설정 끝 -----------------------


</script>

<style type="text/css">
.srcharea .row .col .tit{
width: 96px;
}

.grideLink{text-decoration: underline}

</style>

</head>
<body>

    <div class="iframe_inner" >
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
				<div class="btn" style="float:right" id="UR">
				<!--btn_dwnd  -->
				<!--btn_excel  -->
				</div>
			</div>
			
		<section class="secwrap"   id="params">
				<div class="srcharea" > 
							<div class="row" >
									<div class="col"  >
										<div class="tit" id="sel_term"></div>	<!-- 조회기간 -->
										<div class="box">
											<div class="calendar">
												<input type="text" id="START_DT" name="from" style="width: 179px;" class="i_notnull"><!--시작날짜  -->
											</div>
											<div class="obj">~</div>
											<div class="calendar">
												<input type="text" id="END_DT" name="to" style="width: 179px;"	class="i_notnull"><!-- 끝날짜 -->
											</div>
										</div>
									</div>
								
							</div> <!-- end of row -->
							
							<div class="row">
									<div class="col" style="width: 25%">
										<div class="tit" id="mfc_bizrnm"></div>  <!--반환대상생산자-->
										<div class="box">
											<select id="MFC_BIZRNM" style="width: 179px" ></select>
										</div>
									</div>
									<div class="col"  style="width: 25%">
										<div class="tit" id="prps_cd"></div>  <!-- 용도 -->
										<div class="box">
											<select id="PRPS_CD" style="width: 179px" class="i_notnull" ></select>
										</div>
									</div>
									<div class="col" >
										<div class="tit" id="ctnr_nm"></div>  <!-- 빈용기명 -->
										<div class="box"  >
											<select id="CTNR_CD" style="width: 200px" class="i_notnull" ></select>
										</div>
									</div>
							</div> <!-- end of row -->
					
							<div class="row">
									<div class="col" style="width: 25%">
										<div class="tit" id="whsl_se_cd"></div>  <!-- 도매업자구분 -->
										<div class="box">
											<select id="WHSL_SE_CD" style="width: 179px" ></select>
										</div>
									</div>
									<div class="col" "  style="width: 25%">
										<div class="tit" id="enp_nm"></div>  <!-- 도매업자업체명 -->
										<div class="box"  >
											  <select id="WHSDL_BIZRNM" name="WHSDL_BIZRNM" style="width: 179px"></select>
										</div>
									</div>
									<div class="col">
										<div class="tit" id="area"></div>  <!-- 지역 -->
										<div class="box">
											<select id="AREA" style="width: 200px" ></select>
										</div>
									</div>
									<div class="btn"  id="CR" ></div> <!--조회  -->
							</div> <!-- end of row -->
				</div>  <!-- end of srcharea -->
			</section>
			
			<section class="secwrap2 mt15">
				<div class="boxarea" style="width:25%;margin:0px;">
					<div class="info_tbl" style="">
						<table>
							<colgroup>
								<col style="width: 40%;">
								<col style="width: auto;">
							</colgroup>
							<thead>
								<tr>
									<th colspan="2" class="b">입고량</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>유흥용</td>
									<td id="FB_CFM_QTY_TOT"></td>
								</tr>
								<tr>
									<td>가정용</td>
									<td id="FH_CFM_QTY_TOT"></td>
								</tr>
								<tr>
									<td>직접반환하는자용</td>
									<td id="DRCT_CFM_QTY_TOT"></td>
								</tr>
								<tr>
									<td class="bold c_01">총</td>
									<td class="bold c_01" id="CFM_QTY_TOT"></td>
								</tr>	
							</tbody>
						</table>
					</div>
				</div>
				<div style="width:75%;height:300px;float:right;padding:0 20px 0 15px;margin:0px">
					<!-- 차트가 삽입될 DIV -->
					<div id="chartHolder" style="height:300px"></div>
				</div>
			</section>
			
			<div class="boxarea mt10">  <!-- 634 -->
				<div id="gridHolder" style="height: 565px; background: #FFF;"></div>
			   	<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
			</div>	<!-- 그리드 셋팅 -->
			<div class="h4group" >
					<h5 class="tit"  style="font-size: 16px;">
						&nbsp;※ 조회기간의 기준은 입고확인일자 입니다.<br/>
					</h5>
			</div>
		<section class="btnwrap">
				<div class="btn" id="BL">
				<!-- <a href="#self" class="btn36 c3" style="width: 120px; " id="btn_reg">조사확인요청</a> -->
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