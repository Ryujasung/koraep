<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>상세입고현황</title>
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

 <!-- AUTOCOMPLETE /멀티SELECTBOX -->
<script type="text/javascript" src="https://cdn.rawgit.com/ax5ui/ax5core/master/dist/ax5core.min.js"></script>
<link rel="stylesheet" href="/js/ax5ui-autocomplete-master/dist/ax5autocomplete.css"/>
<script type="text/javascript" src="/js/ax5ui-autocomplete-master/dist/ax5autocomplete.js"></script>
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
<script type="text/javaScript" language="javascript" defer="defer">

	var sumData; /* 총합계 추가 */

	/* 페이징 사용 등록 */
	gridRowsPerPage = 15;//1페이지에서 보여줄 행 수
	gridCurrentPage = 1;//현재 페이지
	gridTotalRowCount = 0;//전체 행 수
    var INQ_PARAMS;//파라미터 데이터
    var ctnrSe;        //신구병
    var prpsCdList;    //용도
    var alkndCdList;   //주종
    var stat_cdList;//상태
    var whsl_se_cdList;//도매업자구분
    var brch_nmList;//생산자 직매장
    var dtList;//반환등록일자구분
    var toDay = kora.common.gfn_toDay();//현재 시간

    var mfc_bizrnmList;//생산자
    var areaList;//지역
    var whsdlList_C;//도매업자 원본
    var ctnrNmList_C;//빈용기 원본
    var ctnrNmList;
    var whsdlList;
 
    //멀티select
    var acSelected_M = new Array();//생산자
    var acSelected_C = new Array();//용기코드
    var acSelected_W = new Array();//도매업자
    var acSelected_A = new Array();//지역
    
    $(function() {
    	INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
        ctnrSe      = jsonObject($("#ctnrSe").val());
        prpsCdList  = jsonObject($("#prpsCdList").val());
        alkndCdList = jsonObject($("#alkndCdList").val());
    	stat_cdList = jsonObject($("#stat_cdList").val());
    	dtList = jsonObject($("#dtList").val());//반환등록일자구분
    	whsl_se_cdList = jsonObject($("#whsl_se_cdList").val());
    	ctnrNmList_C = jsonObject($("#ctnr_cd_list").val());
    	mfc_bizrnmList = jsonObject($("#mfc_bizrnmList").val());
    	areaList = jsonObject($("#areaList").val());
    	whsdlList_C = jsonObject($("#whsdlList").val());
    	
    	whsdlList = whsdlList_C;
		ctnrNmList = ctnrNmList_C; 
		kora.common.autoComplete(); //멀티 autoComplete
    	
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
		$('#sel_term').text(parent.fn_text('sel_term'));//조회기간
		$('#stat').text(parent.fn_text('stat'));//상태
		$('#mfc_bizrnm').text(parent.fn_text('mfc_bizrnm'));//반환대상생산자
		$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm'));//반환대상지점
		$('#reg_se').text(parent.fn_text('reg_se'));//등록구분
		$('#whsl_se_cd').text(parent.fn_text('whsl_se_cd'));//도매업자 구분
		$('#enp_nm').text(parent.fn_text('enp_nm'));//업체명
		$('#area').text(parent.fn_text('area')); //지역
		$('#ctnr_se').text(parent.fn_text('ctnr_se'));//빈용기 구분
		$('#ctnr_nm').text(parent.fn_text('ctnr_nm'));//빈용기명
		$('#rtl_fee_aplc_yn').text(parent.fn_text('rtl_fee_aplc_yn'));//소매수수료 적용여부
		
		
		//div필수값 alt
		 $("#START_DT").attr('alt',parent.fn_text('sel_term'));
		 $("#END_DT").attr('alt',parent.fn_text('sel_term'));
	 
		
		/************************************
		 * 도매업자 구분 변경 이벤트
		 ***********************************/
		$("#BIZR_TP_CD").change(function(){
			kora.common.fn_whsl_se_cd();
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
		 * 새로고침 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_add").click(function() {
			fn_add();
		 });
		
		
		/************************************
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_excel").click(function() {
			fn_excel();
		 });
		
  		fn_init();
  		
	});
     
     //초기화
     function fn_init(){
         kora.common.setEtcCmBx2(ctnrSe, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N", "T"); //빈용기구분
         kora.common.setEtcCmBx2(prpsCdList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');                                   //용도
         kora.common.setEtcCmBx2(alkndCdList, "","", $("#ALKND_CD"), "ETC_CD", "ETC_CD_NM", "N", "T"); //빈용기구분
    	 kora.common.setEtcCmBx2(dtList, "","", $("#SEARCH_GBN"), "ETC_CD", "ETC_CD_NM", "N");//조회기간 선택
   	 	 kora.common.setEtcCmBx2(stat_cdList, "","", $("#STAT_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');//상태
   	 	 kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');//직매장
		 kora.common.setEtcCmBx2(whsl_se_cdList, "","", $("#BIZR_TP_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');//도매업자구분 
     }

     //직매장/공장
     function fn_mfc_brch(){
     	if(acSelected_M.length ==1){
     			var url = "/CE/EPCE6139401_19.do";
 	    		var input 	= {};
 	    		input["BIZRID"]	= acSelected_M[0].MFC_BIZRID;
 	    		input["BIZRNO"]	= acSelected_M[0].MFC_BIZRNO;
 	    		ajaxPost(url, input, function(rtnData) {
 	 				if ("" != rtnData && null != rtnData) {
 	 					kora.common.setEtcCmBx2(rtnData.brch_nmList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T'); //직매장
 	 				}else{
 	 					alertMsg("error");
 	 				}
 	 			},false);
     	}else{
     		kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T'); //직매장
     	}
     	
     }
     
     
     
     function fn_add(){
			
			var url = "/CE/EPCE6139401_21.do";
			var input = "";
			
			ajaxPost(url, input, function(){
				gridCurrentPage = 1;
				fn_sel("Y");
				alert("완료되었습니다.");
				
			});
			
		}
     
   //입고현황 조회
    function fn_sel(chartYN,page){
		 var input = {};
		 var url = "/CE/EPCE6139401_194.do" 
		 if(page !="P"){
			 var start_dt = $("#START_DT").val();
			 var end_dt = $("#END_DT").val();
		     start_dt =  start_dt.replace(/-/gi, "");
		     end_dt =  end_dt.replace(/-/gi, "");
			//날짜 정합성 체크
			if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
				alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
				return; 
			}
			if(start_dt>end_dt){
				alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
				return;
			} 
			
			if ($("#MFC_BRCH_NM option:selected").val() != '' && $("#MFC_BRCH_NM option:selected").val() != null) {
				input["MFC_BRCH_ID"] = $("#MFC_BRCH_NM option:selected").val().split(';')[0];
				input["MFC_BRCH_NO"] = $("#MFC_BRCH_NM option:selected").val().split(';')[1];
			}
			
			input["MFC_LIST"] = JSON.stringify(acSelected_M);//생산자
			input["CTNR_LIST"] = JSON.stringify(acSelected_C);//빈용기
			input["WHSDL_LIST"] = JSON.stringify(acSelected_W);//도매업자
			input["AREA_LIST"] = JSON.stringify(acSelected_A);//지역
			input["SEARCH_GBN"] = $("#SEARCH_GBN").val();//날짜 구분 선택
			 
			//조회 SELECT변수값
			input["START_DT"]			= $("#START_DT").val();			
			input["END_DT"]				= $("#END_DT").val();			
			input["BIZR_TP_CD"]   	= $("#BIZR_TP_CD").val();		//도매업자 구분
			input["RTN_STAT_CD"]   	= $("#STAT_CD").val();	
			input["CHART_YN"]   		= chartYN;
			input["RTL_FEE_APLC_YN"] = $("#RTL_FEE_APLC_YN").val();
            input['CTNR_SE'] = $("#CTNR_SE option:selected").val();
            input['STANDARD_YN'] = $("#STANDARD_YN option:selected").val();
            input['PRPS_CD'] = $("#PRPS_CD option:selected").val();
            input['ALKND_CD'] = $("#ALKND_CD option:selected").val();
			 
			INQ_PARAMS["SEL_PARAMS"] = input;
			 
		}else{
			input = INQ_PARAMS["SEL_PARAMS"];
		}
			/* 페이징  */
			input["ROWS_PER_PAGE"] = gridRowsPerPage;
			input["CURRENT_PAGE"] 	= gridCurrentPage;
				
// 	  	showLoadingBar();
$("#modal").show();
   	   	ajaxPost(url, input, function(rtnData) {
				if ("" != rtnData && null != rtnData) {   
					gridApp.setData(rtnData.selList);
					if(chartYN =="Y"){
						if(rtnData.selList_chart.length>0){
							chartApp.setData(rtnData.selList_chart);
						}else{
							chartApp.setData(chartData);
						}		
					}
					
					var cfm_gtn_tot = 0;	//보증금
					var fee_tot = 0;			//수수료
					var stax_tot = 0;			//부가세
					var amt_tot = 0;			//총합
					
					/* 정산 후 금액으로 수정 */
					for(var i in rtnData.selList_chart){
						cfm_gtn_tot += Number(rtnData.selList_chart[i].CRCT_GTN_TOT);
						fee_tot += Number(rtnData.selList_chart[i].CRCT_FEE_TOT);
						stax_tot += Number(rtnData.selList_chart[i].CRCT_FEE_STAX_TOT);
						amt_tot += Number(rtnData.selList_chart[i].CRCT_ATM_TOT);
					}
					
					$('#CFM_GTN_TOT').text(kora.common.format_comma(cfm_gtn_tot));
					$('#FEE_TOT').text(kora.common.format_comma(fee_tot));
					$('#STAX_TOT').text(kora.common.format_comma(stax_tot));
					$('#AMT_TOT').text(kora.common.format_comma(amt_tot));
					
					
					/* 페이징 표시 */
					gridTotalRowCount = parseInt(rtnData.totalList[0].CNT); //총 카운트 	/* 총합계 추가 */
					drawGridPagingNavigation(gridCurrentPage);
					
					sumData = rtnData.totalList[0]; /* 총합계 추가 */
					
				}else{
					alertMsg("error");
				}
// 			hideLoadingBar(); 
			$("#modal").hide();
		}); 
    }
   
    /* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel("F","P"); //조회 펑션
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
		var fileName = $('#title').text() +"_" + today+hour+min+sec+".xlsx";
		
		//그룹헤더용
        var groupList = dataGrid.getGroupedColumns();
        var groupCntTot = 0;
        var groupCnt = 0;
        
		//그리드 컬럼목록 저장
		var col = new Array();
		var columns = dataGrid.getColumns();
		for(i=0; i<columns.length; i++){
			if(columns[i].getDataField() != undefined && columns[i].getDataField() != 'index'){ //순번 제외
				var item = {};
				
				//그룹헤더용
                if(groupCnt > 0){
                    item['groupHeader']  = '';
                    groupCnt--;
                }else{
                    item['groupHeader'] = groupList[i-groupCntTot].getHeaderText();
                    if(groupList[i-groupCntTot].children != null && groupList[i-groupCntTot].children.length > 0){
                        groupCnt = groupList[i-groupCntTot].children.length;
                        groupCnt--;
                        groupCntTot += (groupList[i-groupCntTot].children.length - 1);
                    }
                }
                //그룹헤더용
                
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
		var url = "/CE/EPCE6139401_05.do";
		showLoadingBar();
		ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
				alertMsg(rtnData.RSLT_MSG);
			}else{
				//파일다운로드
				frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
				frm.fileName.value = fileName;
				frm.submit();
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
			layoutStr.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr.push('	<NumberFormatter id="numfmt1" precision="2" useThousandsSeparator="true"/>');
			layoutStr.push('	<NumberMaskFormatter id="maskfmt1" formatString="###-##-#####"/>');
			layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" horizontalScrollPolicy="on"  sortableColumns="true"   headerHeight="35">');
			layoutStr.push('		<groupedColumns>');   	
			layoutStr.push('			<DataGridColumn dataField="PNO" 				 		headerText="'+ parent.fn_text('sn')+ '" 			width="50"		textAlign="center"   />');													//순번
			layoutStr.push('            <DataGridColumn dataField="RTN_DOC_NO"         headerText="'+ parent.fn_text('rtn_doc_no')+ '" width="120" textAlign="center" />');                   //입고확인일자
			layoutStr.push('			<DataGridColumn dataField="WRHS_CFM_DT" 		headerText="'+ parent.fn_text('wrhs_cfm_dt')+ '" width="100" textAlign="center"   formatter="{datefmt2}"/>');					//입고확인일자
			layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNM"			headerText="'+ parent.fn_text('whsdl')+ '" 		width="130"	textAlign="center"   />'); 													//도매업자
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRNO" 		headerText="'+parent.fn_text('whsdl')+parent.fn_text('bizrno')+ '" width="150"  textAlign="center"   formatter="{maskfmt1}" />');	//도매업자 사업자 번호
			layoutStr.push('			<DataGridColumn dataField="AREA_NM"			 		headerText="'+ parent.fn_text('area')+ '"  		width="100" 	textAlign="center"   />'); 													//지역
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM" 			headerText="'+ parent.fn_text('mfc_bizrnm')+ '"  	width="100"  textAlign="center" />');													//생산자
			layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_NM"   		headerText="'+ parent.fn_text('mfc_brch_nm')+ '" width="100"  textAlign="center" />');													//직매장
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM"   				headerText="'+ parent.fn_text('ctnr_nm')+ '" 	width="200"  	textAlign="center" />');													//빈용기
			layoutStr.push('			<DataGridColumn dataField="PRPS_NM"   				headerText="'+ parent.fn_text('prps_cd')+ '" 	width="100"  	textAlign="center" />');													//용도
			layoutStr.push('            <DataGridColumn dataField="ALKND_NM"     headerText="'+ parent.fn_text('alknd_cd')+ '"        width="100" textAlign="center"  />');
			layoutStr.push('            <DataGridColumn dataField="STANDARD_NM"     headerText="용기구분"        width="100" textAlign="center"  />');
			layoutStr.push('			<DataGridColumn dataField="CPCT_NM"   				headerText="'+ parent.fn_text('cpct')+ '" 			width="150"	textAlign="center" />');													//용량
			layoutStr.push('			<DataGridColumn dataField="RTN_QTY"					headerText="'+ parent.fn_text('rtn_qty2')+ '"  	width="80" 	textAlign="right" formatter="{numfmt}"  	id="num1"	 />');	 //반환량
			layoutStr.push('			<DataGridColumnGroup  									headerText="'+ parent.fn_text('bf_exca')+ '">');				
			layoutStr.push('				<DataGridColumn dataField="CFM_QTY" 	 			headerText="'+ parent.fn_text('wrhs_qty')+ '" 	width="100" 	textAlign="right" formatter="{numfmt}"  	id="num2"	/>');		//소계
			layoutStr.push('				<DataGridColumn dataField="CFM_GTN"  				headerText="'+ parent.fn_text('dps2')+ '" 		width="120"	textAlign="right" formatter="{numfmt}"	id="num3"	/>');		//보증금
			layoutStr.push('				<DataGridColumn dataField="CFM_FEE_TOT"  			headerText="'+ parent.fn_text('fee')+ '" 			width="120"	textAlign="right" formatter="{numfmt1}" id="num4"	/>');		//도매수수료
			layoutStr.push('				<DataGridColumn dataField="CFM_FEE_STAX_TOT" 	headerText="'+ parent.fn_text('stax')+ '" 			width="120" 	textAlign="right" formatter="{numfmt}" 	id="num5"	/>');		//도매수수료부가세
			layoutStr.push('				<DataGridColumn dataField="CFM_ATM_TOT"   		headerText="'+ parent.fn_text('amt')+ '" 			width="120" 	textAlign="right" formatter="{numfmt}" 	id="num6"	/>');		//금액합계
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumnGroup  									headerText="'+ parent.fn_text('af_exca')+ '">');			
			layoutStr.push('				<DataGridColumn dataField="CRCT_QTY" 	 			headerText="'+ parent.fn_text('wrhs_qty')+ '" 	width="100" 	textAlign="right" formatter="{numfmt}"  	id="num7"	/>');		//소계
			layoutStr.push('				<DataGridColumn dataField="CRCT_GTN"  				headerText="'+ parent.fn_text('dps2')+ '" 		width="120"	textAlign="right" formatter="{numfmt}"	id="num8"	/>');		//보증금
			layoutStr.push('				<DataGridColumn dataField="CRCT_FEE_TOT"  			headerText="'+ parent.fn_text('fee')+ '" 			width="120"	textAlign="right" formatter="{numfmt1}" id="num9"	/>');		//도매수수료
			layoutStr.push('				<DataGridColumn dataField="CRCT_FEE_STAX_TOT" 	headerText="'+ parent.fn_text('stax')+ '" 			width="120" 	textAlign="right" formatter="{numfmt}" 	id="num10"	/>');		//도매수수료부가세
			layoutStr.push('				<DataGridColumn dataField="CRCT_ATM_TOT"   		headerText="'+ parent.fn_text('amt')+ '" 			width="120" 	textAlign="right" formatter="{numfmt}" 	id="num11"	/>');		//금액합계
			layoutStr.push('			</DataGridColumnGroup>');			
			layoutStr.push('			<DataGridColumn dataField="STAT_CD_NM"			headerText="'+ parent.fn_text('stat')+ '"  			width="100" 	textAlign="center"    itemRenderer="HtmlItem" id="tmp1"/>'); 			//상태
			layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_NO"			headerText="'+ parent.fn_text('mfc_brch_no')+ '"  width="100"  textAlign="center"   itemRenderer="HtmlItem" id="tmp2"/>'); 			//직매장번호
			layoutStr.push('			<DataGridColumn dataField="RTN_REG_DT" 		headerText="'+ parent.fn_text('rtn_reg_dt')+ '" width="100" textAlign="center"   formatter="{datefmt2}" id="tmp3"/>');					//반환등록일자	
			layoutStr.push('			<DataGridColumn dataField="RTN_DT" 		headerText="'+ parent.fn_text('rtn_dt')+ '" width="100" textAlign="center"   formatter="{datefmt2}" id="tmp4"/>');					//반환일자	
			layoutStr.push('			<DataGridColumn dataField="RMK"			headerText="'+ parent.fn_text('rtl_fee_ext_rsn')+ '" width="150" 	textAlign="center" id="tmp5"/>'); //소매수수료 제외 사유
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="소계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');            
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num8}" formatter="{numfmt}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num9}" formatter="{numfmt}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num10}" formatter="{numfmt}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num11}" formatter="{numfmt}" textAlign="right"/>');            
            layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp1}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp2}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp3}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp4}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp5}"/>');
            layoutStr.push('            </DataGridFooter>');
            layoutStr.push('            <DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
            layoutStr.push('                <DataGridFooterColumn label="총합계" textAlign="center"/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum1" formatter="{numfmt}" dataColumn="{num1}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum2" formatter="{numfmt}" dataColumn="{num2}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum3" formatter="{numfmt}" dataColumn="{num3}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum4" formatter="{numfmt}" dataColumn="{num4}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum5" formatter="{numfmt}" dataColumn="{num5}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum6" formatter="{numfmt}" dataColumn="{num6}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum7" formatter="{numfmt}" dataColumn="{num7}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum8" formatter="{numfmt}" dataColumn="{num8}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum9" formatter="{numfmt}" dataColumn="{num9}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum10" formatter="{numfmt}" dataColumn="{num10}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum11" formatter="{numfmt}" dataColumn="{num11}" textAlign="right"/>');   
            layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp1}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp2}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp3}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp4}"/>');
    		layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp5}"/>');
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
	
	/* 총합계 추가 */
	function totalsum1(column, data) {
		if(sumData) 
			return sumData.RTN_QTY; 
		else 
			return 0;
	}
	
	function totalsum2(column, data) {
		if(sumData) 
			return sumData.CFM_QTY; 
		else 
			return 0;
	}
	
	function totalsum3(column, data) {
		if(sumData) 
			return sumData.CFM_GTN; 
		else 
			return 0;
	}
	
	function totalsum4(column, data) {
		if(sumData) 
			return sumData.CFM_FEE_TOT; 
		else 
			return 0;
	}
	
	function totalsum5(column, data) {
		if(sumData) 
			return sumData.CFM_FEE_STAX_TOT; 
		else 
			return 0;
	}
	
	function totalsum6(column, data) {
		if(sumData) 
			return sumData.CFM_ATM_TOT; 
		else 
			return 0;
	}
	function totalsum7(column, data) {
		if(sumData) 
			return sumData.CRCT_QTY; 
		else 
			return 0;
	}
	
	function totalsum8(column, data) {
		if(sumData) 
			return sumData.CRCT_GTN; 
		else 
			return 0;
	}
	
	function totalsum9(column, data) {
		if(sumData) 
			return sumData.CRCT_FEE_TOT; 
		else 
			return 0;
	}
	
	function totalsum10(column, data) {
		if(sumData) 
			return sumData.CRCT_FEE_STAX_TOT; 
		else 
			return 0;
	}
	
	function totalsum11(column, data) {
		if(sumData) 
			return sumData.CRCT_ATM_TOT; 
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
	layoutStrChart.push('        <Legend defaultMouseOverAction="false" useVisibleCheck="false"/>');
	layoutStrChart.push('      </Options>');
	layoutStrChart.push('  <NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
	layoutStrChart.push('   <Column3DChart showDataTips="true" cubeAngleRatio="1" columnWidthRatio="0.7" >');
	layoutStrChart.push('       <horizontalAxis>');
	layoutStrChart.push('             <CategoryAxis categoryField="MFC_BIZRNM"  id="hAxis" />');
	layoutStrChart.push('       </horizontalAxis>');
	layoutStrChart.push('<horizontalAxisRenderers>');
	layoutStrChart.push('<Axis3DRenderer axis="{hAxis}" canDropLabels="false"   styleName="axisLabel"  />'); //hAxis의 ID적용 및 canDropLabels 설정
	layoutStrChart.push('</horizontalAxisRenderers>'); 
	layoutStrChart.push('        <verticalAxis>');
	layoutStrChart.push('           <LinearAxis formatter="{numfmt}" />');
	layoutStrChart.push('       </verticalAxis>');
	layoutStrChart.push('          <series>');
	layoutStrChart.push('             <Column3DSeries labelPosition="outside" yField="CRCT_GTN_TOT" displayName="보증금" showValueLabels="[]" outsideLabelYOffset="-10" showTotalLabel="true" halfWidthOffset="0" itemRenderer="CylinderItemRenderer">');
	layoutStrChart.push('                  <showDataEffect>');
	layoutStrChart.push('                     <SeriesInterpolate/>');
	layoutStrChart.push('                </showDataEffect>');
	layoutStrChart.push('            </Column3DSeries>');
	layoutStrChart.push('            <Column3DSeries labelPosition="outside" yField="CRCT_FEE_TOT" displayName="수수료" showValueLabels="[]"  outsideLabelYOffset="-10" showTotalLabel="true" halfWidthOffset="0" itemRenderer="CylinderItemRenderer">');
	layoutStrChart.push('                <showDataEffect>');
	layoutStrChart.push('                     <SeriesInterpolate/>');
	layoutStrChart.push('                </showDataEffect>');
	layoutStrChart.push('            </Column3DSeries>');
	layoutStrChart.push('            <Column3DSeries labelPosition="outside" yField="CRCT_FEE_STAX_TOT" displayName="부가세" showValueLabels="[]"  outsideLabelYOffset="-10" showTotalLabel="true" halfWidthOffset="0" itemRenderer="CylinderItemRenderer">');
	layoutStrChart.push('                  <showDataEffect>');
	layoutStrChart.push('                     <SeriesInterpolate/>');
	layoutStrChart.push('                </showDataEffect>');
	layoutStrChart.push('            </Column3DSeries>');
	layoutStrChart.push('        </series>');
	layoutStrChart.push('    </Column3DChart>');
	layoutStrChart.push('<Style>.axisLabel{fontSize:10px;colorFill:#ff0000;}');  
	layoutStrChart.push('</Style>');
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

#CFM_GTN_TOT, #FEE_TOT , #STAX_TOT, #AMT_TOT{
 text-align: right;
 padding-right: 15px;
 
 }
</style>

</head>
<body>
    <div class="iframe_inner" >
    		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
            <input type="hidden" id="ctnrSe" value="<c:out value='${ctnrSe}' />" />
            <input type="hidden" id="prpsCdList" value="<c:out value='${prpsCdList}' />" />
            <input type="hidden" id="alkndCdList" value="<c:out value='${alkndCdList}' />" />
			<input type="hidden" id="ctnr_cd_list" value="<c:out value='${ctnr_cd}' />" />
			<input type="hidden" id="mfc_bizrnmList" value="<c:out value='${mfc_bizrnmList}' />" />
			<input type="hidden" id="areaList" value="<c:out value='${areaList}' />" />
			<input type="hidden" id="stat_cdList" value="<c:out value='${stat_cdList}' />" />
			<input type="hidden" id="whsl_se_cdList" value="<c:out value='${whsl_se_cdList}' />" />
			<input type="hidden" id="whsdlList" value="<c:out value='${whsdlList}' />" />
			<input type="hidden" id="dtList" value="<c:out value='${dtList}' />" />
			<div class="h3group">
				<h3 class="tit" id="title"></h3>
				<div class="btn" style="float:right" id="UR">
				<!--btn_dwnd  -->
				<!--btn_excel  -->
				</div>
			</div>
			
		<section class="secwrap"   id="params">
				<div class="srcharea" > 
					<div class="row" >
						<div class="col"  style="width: 50%;">
							<div class="tit" id="sel_term"></div>	<!-- 조회기간 -->
							<div class="box">
								<select id="SEARCH_GBN"  style="width: 130px; margin-right: 10px"></select>
								<div class="calendar">
									<input type="text" id="START_DT" name="from" style="width: 129px;" class="i_notnull"><!--시작날짜  -->
								</div>
								<div class="obj">~</div>
								<div class="calendar">
									<input type="text" id="END_DT" name="to" style="width: 129px;"	class="i_notnull"><!-- 끝날짜 -->
								</div>
							</div>
						</div>
						<div class="col" style="">
							<div class="tit" id="stat"></div>  <!--상태 -->
							<div class="box"  >
								<select id="STAT_CD" style="width: 200px" class="i_notnull" ></select>
							</div>
						</div>
					</div> <!-- end of row -->
					
					<div class="row">
						<div class="col" style="width: 50%;">
							<div class="tit" id="mfc_bizrnm"></div>  <!--반환대상생산자-->
							<div class="box">
								<!-- <select id="MFC_BIZRNM" style="width: 179px" ></select> -->
								<div data-ax5autocomplete="autocomplete" data-ax5autocomplete-config="{multiple: true}" style="max-width :500px; z-index: 0;"  id="data-ax5autocomplete_M_BRCH" ></div>
							</div>
						</div>
						<div class="col" style="">
							<div class="tit" id="mfc_brch_nm"></div>  <!-- 직매장 -->
							<div class="box"  >
								<select id="MFC_BRCH_NM" style="width: 200px" class="i_notnull" ></select>
							</div>
						</div>
					</div> <!-- end of row -->
					<div class="row">
						<div class="col" style="width: 50%;">
                            <div class="tit" id="ctnr_se"></div>  <!-- 용도 -->
                            <div class="box">
                                <select id="CTNR_SE" name="CTNR_SE" style="width:80px" class="i_notnull" ></select>
                                <select id="STANDARD_YN" name="STANDARD_YN" style="width:80px" class="i_notnull" >
                                	<option value="">전체</option>
                                	<option class="generated" value="Y">표준용기</option>
                                	<option class="generated" value="N">비표준용기</option>
                                </select>
                                <select id="PRPS_CD" name="PRPS_CD" style="width:169px" class="i_notnull" ></select>
                                <select id="ALKND_CD" name="ALKND_CD" style="width:110px" class="i_notnull" ></select>
                            </div>
                        </div>
                        <div class="col"  >
							<div class="tit" id="ctnr_nm"></div>  <!-- 빈용기명 -->
							<div class="box"  >
								<!-- <select id="CTNR_CD" style="width: 200px" class="i_notnull" ></select> -->
								<div data-ax5autocomplete="autocomplete" data-ax5autocomplete-config="{multiple: true}" style="max-width :500px; z-index: 0;"  id="data-ax5autocomplete_C" ></div> 
							</div>
						</div>
					</div><!-- end of row -->
					<div class="row">
                        <div class="col" style="width: 50%;">
                            <div class="tit" id="rtl_fee_aplc_yn" style="width:150px"></div>  <!-- 소매수수료 적용여부 -->
                            <div class="box" >
                                <select id="RTL_FEE_APLC_YN" name="RTL_FEE_APLC_YN" style="width: 179px" >
                                    <option>전체</option>
                                    <option value="Y">적용</option>
                                    <option value="N">제외</option>
                                </select>
                            </div>
                        </div>
						<div class="col">
							<div class="tit" id="area"></div>  <!-- 지역 -->
							<div class="box">
								<div data-ax5autocomplete="autocomplete" data-ax5autocomplete-config="{multiple: true}" style="max-width :500px; z-index: 0;" id="data-ax5autocomplete_A"   ></div>
							</div>
						</div>
					</div><!-- end of row -->
					<div class="row">
						<div class="col" style="">
							<div class="tit" id="whsl_se_cd"></div>  <!-- 도매업자구분 -->
							<div class="box">
								<select id="BIZR_TP_CD" style="width: 179px" ></select>
							</div>
						</div>
						<div class="col"  style="">
							<div class="tit" id="enp_nm"  style="width: 60px;"></div>  <!-- 도매업자업체명 -->
							<div class="box"  >
							  <!-- <select id="WHSDL_BIZRNM" name="WHSDL_BIZRNM" style="width: 179px"></select> -->
							  <div data-ax5autocomplete="autocomplete" data-ax5autocomplete-config="{multiple: true}" style="max-width :500px; z-index: 0;" id="data-ax5autocomplete_W" ></div> 
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
								<col style="width: 30%;">
								<col style="width: auto;">
							</colgroup>
							<thead>
								<tr>
									<th colspan="2" class="b">빈용기보증금 및 취급수수료 합계</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>빈용기보증금</td>
									<td id="CFM_GTN_TOT" ></td>
								</tr>
								<tr>
									<td>취급수수료</td>
									<td id="FEE_TOT" ></td>
								</tr>
								<tr>
									<td>부가세</td>
									<td id="STAX_TOT" ></td>
								</tr>
								<tr>
									<td class="bold c_01">총</td>
									<td class="bold c_01" id="AMT_TOT" ></td>
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
				<div id="gridHolder" style="height: 560px; background: #FFF;"></div>
			   	<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
			</div>	<!-- 그리드 셋팅 -->
			<section class="btnwrap"  >
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