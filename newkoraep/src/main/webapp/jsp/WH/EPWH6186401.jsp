<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>회수대비초과반환현황</title>
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
<script type="text/javaScript" language="javascript" defer="defer">

	var sumData = {}; /* 총합계 추가 */

	/* 페이징 사용 등록 */
	 gridRowsPerPage = 15;// 1페이지에서 보여줄 행 수
	 gridCurrentPage = 1;// 현재 페이지
	 gridTotalRowCount = 0; 	//전체 행 수
	 var INQ_PARAMS;//파라미터 데이터
     var whsl_se_cdList;//도매업자구분
     var areaList;//지역
     var whsdlList_C;//도매업자 원본
     var whsdlList;//도매업자
     var toDay = kora.common.gfn_toDay();// 현재 시간
	 var acSelected_W = new Array();//도매업자
	 var acSelected_A = new Array();//지역

	 var chartData = [{AREA_CD:"",RTRVL_M:0,CFM_M:0,CFM_H:0 ,CFM_M:0}];// 차트 데이터
    $(function() {
    	 
	     INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
	     areaList =  jsonObject($("#areaList").val());//지역
	     whsl_se_cdList = jsonObject($("#whsl_se_cdList").val());//도매업자구분
	     whsdlList_C = jsonObject($("#whsdlList").val());//도매업자 업체명 조회
	     
	     whsdlList = whsdlList_C;

	   	 fn_init(); 
	      
    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
    	 //그리드 셋팅
		 fnSetGrid1(false);

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
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_excel").click(function() {
			fn_excel();
		 });
		
		/************************************
		 * 도매업자 구분 변경 이벤트
		 ***********************************/
		$("#BIZR_TP_CD").change(function(){
			fn_whsl_se_cd();
		});
		
	});
     
     //초기화
     function fn_init(){
    	 
	    	kora.common.setEtcCmBx2(whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N");		 //업체명
	
			kora.common.setEtcCmBx2(whsl_se_cdList, "","", $("#BIZR_TP_CD"), "ETC_CD", "ETC_CD_NM", "N" );					//도매업자구분 
			kora.common.setEtcCmBx2(areaList, "","", $("#AREA_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N" ,'T');								//지역
			
			var dlivy_cpr_rtrvl_qtylist = [{"ETC_CD":"1", "ETC_CD_NM":"유흥용"} ,{"ETC_CD":"2", "ETC_CD_NM":"가정용"},{"ETC_CD":"3", "ETC_CD_NM":"초과율"} ];
			kora.common.setEtcCmBx2(dlivy_cpr_rtrvl_qtylist, "","", $("#DLIVY_CPR_RTRVL_QTY"), "ETC_CD", "ETC_CD_NM", "N" ,'T');			//출고대비초과회수량
			
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
			 
     }
 
     //도매업자구분 변경시 도매업자 조회 ,생산자가 선택됐을경우 거래중인 도매업자만 조회
     function fn_whsl_se_cd(){
    	var url = "/MF/EPMF6110401_19.do" 
		var input ={};
		   if($("#BIZR_TP_CD").val() !=""){
		  		 	input["BIZR_TP_CD"] =$("#BIZR_TP_CD").val();
		   }


       	   ajaxPost(url, input, function(rtnData) {
    				if ("" != rtnData && null != rtnData) {  
    					 	kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');		 //업체명
    				}else{
    						 alertMsg("error");
    				}
    		},false);
     }
     
   //조회
    function fn_sel(chartYN ,page){
			var input	={};
			var url = "/WH/EPWH6186401_192.do" 
			if(page !="P"){
				var start_dt 			= $("#START_DT").val();
				var end_dt    			= $("#END_DT").val();
				pagingCurrent = 1;
			    start_dt   =  start_dt.replace(/-/gi, "");
			    end_dt    =  end_dt.replace(/-/gi, "");
				//날짜 정합성 체크
				if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
					alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
					return; 
				}else if(start_dt>end_dt){
					alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
					return;
				} 
				
				if($("#WHSDL_BIZRNM").val() !="" ){//도매업자
			 		var arr2 =[];
		   			arr2 = $("#WHSDL_BIZRNM").val().split(";");	
		   			input["WHSDL_BIZRID"] = arr2[0];
		   			input["WHSDL_BIZRNO"] = arr2[1];
			 	}
				
				input["AREA_CD"] = $("#AREA_CD_SEL").val();//지역
				 
				input["BIZR_TP_CD"] = $("#BIZR_TP_CD").val();//도매업자 구분
				input["OVER_DIV"] = $("#OVER_DIV option:selected").val();
			 	
				//조회 SELECT변수값
				input["START_DT"] = $("#START_DT").val();
				input["END_DT"] = $("#END_DT").val();
				input["CHART_YN"] = chartYN;
				INQ_PARAMS["SEL_PARAMS"] = input;
			}else{
				input = INQ_PARAMS["SEL_PARAMS"];
			}
			/* 페이징  */
			input["ROWS_PER_PAGE"] = gridRowsPerPage;
			input["CURRENT_PAGE"] = gridCurrentPage;
			
// 		  	showLoadingBar();
$("#modal").show();
	   	   	ajaxPost(url, input, function(rtnData) {
				if ("" != rtnData && null != rtnData) {
					gridApp.setData(rtnData.selList);
					sumData = rtnData.totalList[0];
					
					if(chartYN =="Y"){
						//if(rtnData.selList_chart.length)
					 	if(rtnData.selList_chart.length>0){
							chartApp.setData(rtnData.selList_chart);
						}else{
							chartApp.setData(chartData);
						}
					}
					
					var rtrvl_m_tot = 0;//회수 유흥
					var rtrvl_h_tot = 0;//회수 가정
					var r_m_tot = 0;//반환 유흥
					var r_h_tot = 0;//반환 가정
					var r_d_tot = 0;//반환 직접
					
					for(var i in rtnData.selList_chart){
						rtrvl_m_tot += Number(rtnData.selList_chart[i].RTRVL_M);
						rtrvl_h_tot += Number(rtnData.selList_chart[i].RTRVL_H); 
						r_m_tot += Number(rtnData.selList_chart[i].CFM_M);
						r_h_tot += Number(rtnData.selList_chart[i].CFM_H);
						r_d_tot += Number(rtnData.selList_chart[i].CFM_D);
					}
					
					$('#RTRVL_H_TOT').text(kora.common.format_comma(rtrvl_h_tot));
					$('#RTRVL_M_TOT').text(kora.common.format_comma(rtrvl_m_tot));
					$('#R_M_TOT').text(kora.common.format_comma(r_m_tot));
					$('#R_H_TOT').text(kora.common.format_comma(r_h_tot));
					$('#M_TOT').text(kora.common.format_comma(rtrvl_m_tot - r_m_tot));
					$('#H_TOT').text(kora.common.format_comma(rtrvl_h_tot - r_h_tot));
					
					/* 페이징 표시 */
					if(rtnData.selList != undefined && rtnData.selList != null && rtnData.selList.length !=0) gridTotalRowCount = rtnData.selList[0].TOTALCOUNT; //총 카운트 
					drawGridPagingNavigation(gridCurrentPage);
					
					/* 총합계 추가 */
					/* sumData.RTRVL_H = rtrvl_h_tot;
					sumData.RTRVL_M = rtrvl_m_tot;
					sumData.RTRVL_TOT = rtrvl_h_tot + rtrvl_m_tot;
					sumData.CFM_H = r_h_tot;
					sumData.CFM_D = r_d_tot
					sumData.CFM_M = r_m_tot;
					sumData.CFM_TOT = r_h_tot + r_m_tot;
					
					sumData.RTRVL_CPR_RTRVL_H = r_h_tot - rtrvl_h_tot;
					sumData.RTRVL_CPR_RTRVL_M = r_m_tot - rtrvl_m_tot;
					sumData.RTRVL_CPR_RTRVL_TOT = (r_h_tot + r_m_tot) - (rtrvl_h_tot + rtrvl_m_tot); */
					
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
		var url = "/WH/EPWH6186401_05.do";
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
			layoutStr.push('	<NumberMaskFormatter id="maskfmt" formatString="###-##-#####"/>');
			layoutStr.push('	<NumberFormatter id="numfmt1" precision="2" useThousandsSeparator="true"/>');
			layoutStr.push('	<PercentFormatter id="percfmt" useThousandsSeparator="true"/>');	
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true"  horizontalScrollPolicy="on"   sortableColumns="true"   headerHeight="35">');
			layoutStr.push('		<groupedColumns>');   	
			layoutStr.push('			<DataGridColumn dataField="PNO" headerText="'+ parent.fn_text('sn')+ '" width="80" 	textAlign="center"  />');//순번
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRNM" headerText="'+ parent.fn_text('whsdl')+ '" width="200" 	textAlign="center"  />');//도매업자
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRNO" headerText="'+ parent.fn_text('whsdl_bizrno')+ '" width="200" 	textAlign="center"  formatter="{maskfmt}"  />');//도매업자 사업자번호
			layoutStr.push('			<DataGridColumn dataField="TEL_NO" headerText="'+ parent.fn_text('rpst_tel_no')+ '" width="200" 	textAlign="center"  />');//도매업자 대표번호
			layoutStr.push('			<DataGridColumn dataField="AREA_CD" headerText="'+ parent.fn_text('area')+ '"  width="100" 	textAlign="center"  />');//지역
			layoutStr.push('			<DataGridColumnGroup headerText="'+ parent.fn_text('rtrvl')+ '">');//회수
			layoutStr.push('				<DataGridColumn dataField="RTRVL_H" headerText="'+ parent.fn_text('fh')+ '" width="100" formatter="{numfmt}"	id="num1" textAlign="right" />');//가정용
			layoutStr.push('				<DataGridColumn dataField="RTRVL_M" headerText="'+ parent.fn_text('fb')+ '" width="100" formatter="{numfmt}"	id="num2" textAlign="right" />');//유흥용
			layoutStr.push('				<DataGridColumn dataField="RTRVL_TOT" headerText="'+ parent.fn_text('total')+ '" width="100" formatter="{numfmt}"	id="num3" textAlign="right" />');//소계
			layoutStr.push('				<DataGridColumn dataField="RTRVL_TOT_RT_H" headerText="'+ parent.fn_text('fh_rt')+ '" width="100" formatter="{percfmt}" id="tmp1"	textAlign="right" />');//가정용비율
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('rtn')+ '">');//반환량
			layoutStr.push('				<DataGridColumn dataField="CFM_H" headerText="'+ parent.fn_text('fh')+ '" width="100" formatter="{numfmt}"	id="num4"  textAlign="right" />');//가정용
			layoutStr.push('				<DataGridColumn dataField="CFM_D" headerText="'+ parent.fn_text('drct_rtn')+ '" width="100" formatter="{numfmt}" id="num5"  textAlign="right" />');//직접
			layoutStr.push('				<DataGridColumn dataField="CFM_M" headerText="'+ parent.fn_text('fb')+ '" width="100" formatter="{numfmt}" 	id="num6" textAlign="right" />');//유흥용
			layoutStr.push('				<DataGridColumn dataField="CFM_TOT" headerText="'+ parent.fn_text('total')+ '" width="100" formatter="{numfmt}"	id="num7" textAlign="right" />');//소계
			layoutStr.push('				<DataGridColumn dataField="CFM_RT_H" headerText="'+ parent.fn_text('fh_rt')+ '" width="100" formatter="{percfmt}" id="tmp2" textAlign="right" />');//가정용비율
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumnGroup headerText="'+ parent.fn_text('rtrvl_cpr_rtn_qty')+ '">');//회수대비초과반환량
			layoutStr.push('				<DataGridColumn dataField="RTRVL_CPR_RTRVL_H" headerText="'+ parent.fn_text('fh')+ '" width="100" formatter="{numfmt}"	id="num8"	 textAlign="right" />');//가정용
			layoutStr.push('				<DataGridColumn dataField="CFM_D" headerText="'+ parent.fn_text('drct_rtn')+ '" width="100" formatter="{numfmt}" id="num9"	 textAlign="right" />');//직접
			layoutStr.push('				<DataGridColumn dataField="RTRVL_CPR_RTRVL_M" headerText="'+ parent.fn_text('fb')+ '" width="100" formatter="{numfmt}"	id="num10" textAlign="right" />');//유흥용
			layoutStr.push('				<DataGridColumn dataField="RTRVL_CPR_RTRVL_TOT" headerText="'+ parent.fn_text('total')+ '" width="100" formatter="{numfmt}"	id="num11" textAlign="right" />');//소계 
			layoutStr.push('				<DataGridColumn dataField="RTRVL_CPR_RTRVL_RT_H" headerText="'+ parent.fn_text('fh_rt')+ '" width="100" formatter="{percfmt}" id="tmp3" textAlign="right" />');//가정용비율
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumnGroup headerText="'+ parent.fn_text('rtrvl_cpr_rtn_rt')+ '">');
			layoutStr.push('				<DataGridColumn dataField="CFM_RTRVL_PER_H" headerText="'+ parent.fn_text('fh')+ '" width="100" formatter="{percfmt}" textAlign="right" />');
			layoutStr.push('				<DataGridColumn dataField="CFM_RTRVL_PER_M" headerText="'+ parent.fn_text('fb')+ '" width="100" formatter="{percfmt}" textAlign="right" />');
			layoutStr.push('			</DataGridColumnGroup>');
			//layoutStr.push('			<DataGridColumn dataField="RTRVL_CPR_RTRVL_RT" headerText="'+ parent.fn_text('rtrvl_cpr_rtn_rt')+ '" width="100" formatter="{percfmt}" textAlign="right"  />'); //회수대비반환비율
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="소계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp1}"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp2}"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num8}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num9}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num10}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num11}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp3}"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('			</DataGridFooter>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="총합계" textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum1" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum2" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum3" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp1}"/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum4" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum5" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum6" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum7" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp2}"/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum8" dataColumn="{num8}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum9" dataColumn="{num9}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum10" dataColumn="{num10}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn labelJsFunction="totalsum11" dataColumn="{num11}" formatter="{numfmt}" textAlign="right"/>');
			layoutStr.push('				<DataGridFooterColumn dataColumn="{tmp3}"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('			</DataGridFooter>');
			layoutStr.push('		</footers>');
		    layoutStr.push('      <dataProvider>');
		    layoutStr.push('         <SpanArrayCollection source="{$gridData}"/>');
		    layoutStr.push('      </dataProvider>');
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
			 	//취약점점검 6030 기원우
			 }else{
				 gridApp.setData();
				/* 페이징 표시 */
				drawGridPagingNavigation(gridCurrentPage);
			 }
			
		}
		var dataCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			dataGrid.setEnabled(true);
		    setSpanAttributes(); 
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
	
	/**
	 * 그리드 상태 및 비밀번호변경 건 스타일 처리
	 */
	 
 	//그리드 데이터 객체
	 function setSpanAttributes() {
	 	var collection = gridRoot.getCollection();
	    if (collection == null) {
	        alertMsg("collection 객체를 찾을 수 없습니다");
	        return;
	    } 
	    for (var i = 0; i < collection.getLength(); i++) {
	    	var data = gridRoot.getItemAt(i).RTRVL_CPR_RTRVL_RT;
	    	
	    	if( (data >= 80 && data < 90  )|| (data >= 110 && data < 120) ){  //  
	    		//console.log("1 :  "+data   +'   :  ' +   i )
		       	collection.addRowAttributeDetailAt(i, null, "#5587ED", null, false, 20);	//파랑   90 >s  >= 80     ,    120 > s > =110       
	    	} else if((data >= 70 && data < 80) || (data >= 120 && data < 130) ){
	    		//console.log("2 :  "+data +'   :  ' +   i  )
		      	collection.addRowAttributeDetailAt(i, null, "#FFCC00", null, false, 20); //노랑  80 > s >= 70     ,    130 > s >= 120
	    	} else if(data < 70 || data >= 130){ 
	    		//console.log("3 :  "+data +'   :  ' +   i  )
		       	collection.addRowAttributeDetailAt(i, null, "#F15F5F", null, false, 20);   //빨강    70>s     ,         130 > s
	    	}   																								   // 90 ~ 109  아무것도 없다
	    }   
	}
	
	
	 /* 총합계 추가 */
	 function totalsum1(column, data) {
	 	if(sumData) 
	 		return sumData.RTRVL_H; 
	 	else 
	 		return 0;
	 }
	 function totalsum2(column, data) {
	 	if(sumData) 
	 		return sumData.RTRVL_M; 
	 	else 
	 		return 0;
	 }
	 function totalsum3(column, data) {
	 	if(sumData) 
	 		return sumData.RTRVL_TOT; 
	 	else 
	 		return 0;
	 }
	 function totalsum4(column, data) {
	 	if(sumData) 
	 		return sumData.CFM_H; 
	 	else 
	 		return 0;
	 }
	 function totalsum5(column, data) {
		 	if(sumData) 
		 		return sumData.CFM_D; 
		 	else 
		 		return 0;
		 }
	 function totalsum6(column, data) {
	 	if(sumData) 
	 		return sumData.CFM_M; 
	 	else 
	 		return 0;
	 }
	 function totalsum7(column, data) {
	 	if(sumData) 
	 		return sumData.CFM_TOT; 
	 	else 
	 		return 0;
	 }
	 
	 function totalsum8(column, data) {
	 	if(sumData) 
	 		return sumData.RTRVL_CPR_RTRVL_H; 
	 	else 
	 		return 0;
	 }
	 function totalsum9(column, data) {
	 	if(sumData) 
	 		return sumData.CFM_D; 
	 	else 
	 		return 0;
	 }
	 function totalsum10(column, data) {
	 	if(sumData) 
	 		return sumData.RTRVL_CPR_RTRVL_M; 
	 	else 
	 		return 0;
	 }
	 function totalsum11(column, data) {
	 	if(sumData) 
	 		return sumData.RTRVL_CPR_RTRVL_TOT; 
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
	layoutStrChart.push('             <CategoryAxis categoryField="AREA_CD" id="hAxis" />');
	layoutStrChart.push('       </horizontalAxis>');
	layoutStrChart.push('<horizontalAxisRenderers>');
	layoutStrChart.push('<Axis3DRenderer axis="{hAxis}" canDropLabels="false"   styleName="axisLabel"  />'); //hAxis의 ID적용 및 canDropLabels 설정
	layoutStrChart.push('</horizontalAxisRenderers>'); 
	
	layoutStrChart.push('<verticalAxis>');
	layoutStrChart.push('           <LinearAxis formatter="{numfmt}" />');
	//layoutStrChart.push('   <BrokenAxis id="vAxis" brokenMinimum="7000" brokenMaximum="150000" brokenRatio="0.8" formatter="{numfmt}"/>');
	layoutStrChart.push('</verticalAxis>');
	
	/* layoutStrChart.push(' <verticalAxisRenderers>');
	layoutStrChart.push(' <BrokenAxis3DRenderer  axis="{vAxis}"/>');
	layoutStrChart.push(' </verticalAxisRenderers>');
	 */
	layoutStrChart.push('          <series>');
	layoutStrChart.push('             <Column3DSeries labelPosition="outside" yField="RTRVL_M" displayName="유흥용회수" outsideLabelYOffset="-10" showTotalLabel="true" showValueLabels="[]"  halfWidthOffset="0" itemRenderer="CylinderItemRenderer">');
	layoutStrChart.push('                  <showDataEffect>');
	layoutStrChart.push('                     <SeriesInterpolate/>');
	layoutStrChart.push('                </showDataEffect>');
	layoutStrChart.push('            </Column3DSeries>');
	layoutStrChart.push('            <Column3DSeries labelPosition="outside" yField="CFM_M" displayName="유흥용반환" outsideLabelYOffset="-10" showTotalLabel="true" showValueLabels="[]"  halfWidthOffset="0" itemRenderer="CylinderItemRenderer">');
	layoutStrChart.push('                <showDataEffect>');
	layoutStrChart.push('                     <SeriesInterpolate/>');
	layoutStrChart.push('                </showDataEffect>');
	layoutStrChart.push('            </Column3DSeries>');
	layoutStrChart.push('            <Column3DSeries labelPosition="outside" yField="RTRVL_H" displayName="가정용회수" outsideLabelYOffset="-10" showTotalLabel="true" showValueLabels="[]" halfWidthOffset="0" itemRenderer="CylinderItemRenderer">');
	layoutStrChart.push('                  <showDataEffect>');
	layoutStrChart.push('                     <SeriesInterpolate/>');
	layoutStrChart.push('                </showDataEffect>');
	layoutStrChart.push('            </Column3DSeries>');
	layoutStrChart.push('            <Column3DSeries labelPosition="outside" yField="CFM_H" displayName="가정용반환" outsideLabelYOffset="-10" showTotalLabel="true" showValueLabels="[]" halfWidthOffset="0" itemRenderer="CylinderItemRenderer">');
	layoutStrChart.push('                  <showDataEffect>');
	layoutStrChart.push('                     <SeriesInterpolate/>');
	layoutStrChart.push('                </showDataEffect>');
	layoutStrChart.push('            </Column3DSeries>');
	layoutStrChart.push('        </series>');
	layoutStrChart.push('    </Column3DChart>');
	layoutStrChart.push('<Style>.axisLabel{fontSize:10px;colorFill:#ff0000;}');  
	layoutStrChart.push('</Style>');
	layoutStrChart.push(' </rMateChart>');
	 
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
	

	// 이미지 저장
	function saveAsImage(){
	   // IE 판별
	    if(compIE())
	        menus.items[0].callback();
	}
	
	function compIE(){
		   var agent = navigator.userAgent;
		    if(agent.indexOf("MSIE 7.0") > -1 || agent.indexOf("MSIE 8.0") > - 1 || agent.indexOf("Trident 4.0") > -1){
		        alertMsg("IE7,8 에서는 이미지 변환 및 전송기능이 지원되지 않습니다.");
		       return false;
		   }
		   if(document.documentMode && document.documentMode <= 5){
		     alertMsg("쿼크모드에서는 이미지 변환 및 전송기능이 지원되지 않습니다.");
		     return false;
		   }
		   return true;
		}
/* 	// 데이터 에디터를 사용할 경우 
	chartVars += "&useDataEditor=true";
	
	// 차트 메뉴를 사용할 경우
	chartVars += "&chartMenu=menus"; */
	// 차트메뉴에 설정할 데이터
	var menus = {
	 options : {
	     textField : "name", // 메뉴에 출력할 메뉴 아이템의 문자열
	      callbackField : "callback" // 메뉴 아이템 클릭 시 실행할 콜백 함수
	 }, 
	 items : [
	       {
	           name : "PNG 저장",
	            callback : function(){
	              /**
	              * rMateChartH5 - 저장되어지는 파일 명
	                * png - 확장자
	                 * http://../downloadLocal.jsp - IE 9 혹은 로컬 다운로드를 지원하지 않는 브라우저를 위한 다운로드 jsp 서버 경로
	                * function(){ .. } - 다운받으려는 데이터 base64 인코딩 하여 반환하는 함수
	               */
	             rMateChartH5.downloadToLocal("rMateChartH5", "png", "http://demo.riamore.net/demo/chart/downloadLocal.jsp", function(){
	                 return document.getElementById("rChart").saveAsImage();
	             });
	         }
	       },{
	         name : "PDF 저장",
	            callback : function(){
	              /**
	              * rMateChartH5 - 저장되어지는 파일 명
	                * pdf - 확장자
	                 * http://../downloadLocal.jsp - IE 9 혹은 로컬 다운로드를 지원하지 않는 브라우저를 위한 다운로드 jsp 서버 경로
	                * function(){ .. } - 다운받으려는 데이터 base64 인코딩 하여 반환하는 함수
	               */
	             rMateChartH5.downloadToLocal("rMateChartH5", "pdf", "http://demo.riamore.net/demo/chart/downloadLocal.jsp", function(){
	                 return document.getElementById("rChart").getSnapshot("jpeg"); // jpeg만 지원
	               }, (function(){
	                 var holder = document.getElementById("chartHolder"),
	                        width = holder.offsetWidth,
	                     height = holder.offsetHeight;
	                   return {portrait : width < height, size : {width : width, height : height}};
	             })());
	          }
	       }
	   ]
	};
	 
	// -----------------------차트 설정 끝 -----------------------


</script>

<style type="text/css">
.srcharea .row .col .tit{
width: 96px;
}
</style>

</head>
<body>

    <div class="iframe_inner" >
    
    		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="areaList" value="<c:out value='${areaList}' />" />
			<input type="hidden" id="whsl_se_cdList" value="<c:out value='${whsl_se_cdList}' />" />
			<input type="hidden" id="whsdlList" value="<c:out value='${whsdlList}' />" />
			<div class="h3group">
				<h3 class="tit" id="title"></h3>
				<div class="btn" style="float:right" id="UR">
				<button type="button" class="btn36 c2" style="width: 100px;" onclick="saveAsImage();">이미지저장</button>
				<!--btn_dwnd  -->
				<!--btn_excel  -->
				</div>
			</div>
		<section class="secwrap"   id="params">
				<div class="srcharea mt10" > 
							<div class="row" >
									<div class="col"  style="width: 40%">
										<div class="tit" id="sel_term_txt"></div>	<!-- 조회기간 -->
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
									<div class="col" >
										<div class="tit" id="cpr_qty_sel_txt"></div>  <!--초과량만표시 -->
										<div class="box">
											<select id="OVER_DIV" style="width: 179px" >
												<option value="">전체</option>
												<option value="1">가정용</option>
												<option value="2">유흥용</option>
											</select>
										</div>
									</div>
							</div> <!-- end of row -->
							 
							<div class="row">
									<div class="col" style="">
										<div class="tit" id="whsl_se_cd_txt"></div>  <!-- 도매업자구분 -->
										<div class="box">
											<select id="BIZR_TP_CD" style="width: 179px" ></select>
										</div>
									</div>
									<div class="col" "  style="">
										<div class="tit" id="enp_nm_txt"></div>  <!-- 도매업자업체명 -->
										<div class="box"  >
											<select id="WHSDL_BIZRNM" style="width: 279px" ></select>
										</div>
									</div>
							</div> <!-- end of row -->
							<div class="row">
									<div class="col">
										<div class="tit" id="area_txt"></div>  <!-- 지역 -->
										<div class="box">
											<select id="AREA_CD_SEL" style="width: 179px" ></select>
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
								<col style="width: 20%;">
								<col style="width: 40%;">
								<col style="width: 40%">
							</colgroup>
							<thead>
								<tr>
									<th colspan="3" class="b">회수대비반환</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>구분</td>
									<td>유흥용</td>
									<td>가정용</td>
								</tr>
								<tr>
									<td>회수</td>
									<td id="RTRVL_M_TOT"></td>
									<td id="RTRVL_H_TOT"></td>
								</tr>
								<tr>
									<td>반환</td>
									<td id="R_M_TOT"></td>
									<td id="R_H_TOT"></td>
								</tr>
								<tr>
									<td class="bold c_01">총</td>
									<td class="bold c_01" id="M_TOT"></td>
									<td class="bold c_01" id="H_TOT"></td>
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
				<div id="gridHolder" style="height: 620px; background: #FFF;"></div>
			   	<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
			</div>	<!-- 그리드 셋팅 -->
			<div class="h4group" >
					<h5 class="tit"  style="font-size: 16px;">
						&nbsp;※ 조회기간의 기준은 회수일자, 반환일자 입니다.<br/>
					</h5>  
			</div>
			<section class="btnwrap">
					<div class="btn" id="BL"></div>
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