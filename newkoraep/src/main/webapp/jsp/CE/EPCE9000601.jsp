<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>무인회수기 회수내역</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />
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

	/* 페이징 사용 등록 */
	gridRowsPerPage = 15;// 1페이지에서 보여줄 행 수
	gridCurrentPage = 1;// 현재 페이지
	gridTotalRowCount = 0;//전체 행 수

	 var INQ_PARAMS;//파라미터 데이터
     var areaList;//지역
     var sumData;//총합계
     var toDay = kora.common.gfn_toDay();// 현재 시간
 	 var arr 	= new Array();//생산자
	 var arr2 = new Array();
	 var arr3 = new Array();
	 var acSelected= new Array();
	 var AreaCdList;
	 var urm_list; //소매점명 조회
	 var urm_list2; //센터고유번호 조회
	 var rtrvl_cd_list;	//회수용기조회
	 
     $(function() {
   		INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());//파라미터 데이터
  	    areaList = jsonObject($("#areaList").val());//지역
  	   AreaCdList = jsonObject($('#AreaCdList').val());
  	   urm_list2 		= jsonObject($("#urm_list2").val());		//센터고유번호 조회
  	   urm_list 		= jsonObject($("#urm_list").val());		//소매점명 조회
  	   rtrvl_cd_list 		= jsonObject($("#rtrvl_cd_list").val());		//회수용기조회
	  	  //버튼 셋팅
	   	 fn_btnSetting();
	   	 
	   	 //그리드 셋팅
		 fnSetGrid1();
		
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
		$('#title_sub').text('<c:out value="${titleSub}" />');//타이틀
		$('#sel_term').text('회수일자');
		$('#rtrvl_ctnr_cd').text('용량(신/구병)');//상태
		$('#serial_no').text('시리얼번호');//반환대상생산자
		$('#area_se').text('지역');
		
		//div필수값 alt
		 $("#START_DT").attr('alt',parent.fn_text('sel_term'));
		 $("#END_DT").attr('alt',parent.fn_text('sel_term'));
      
// 		/************************************
// 		 * 생산자 구분 변경 이벤트
// 		 ***********************************/
// 		$("#MFC_BIZRNM").change(function(){
// 			fn_mfc_bizrnm();
// 		});
		
// 		/************************************
// 		 * 직매장/공장 구분 변경 이벤트
// 		 ***********************************/
// 		$("#MFC_BRCH_NM").change(function(){
// 			fn_mfc_brch_nm();
// 		});
		
// 		/************************************
// 		 * 도매업자 구분 변경 이벤트
// 		 ***********************************/
// 		$("#WHSL_SE_CD").change(function(){
// 			fn_whsl_se_cd();
// 		});
			
		/************************************
		 * 무인회수기 회수 내역 삭제 클릭 이벤트
		 ***********************************/
		$("#btn_del").click(function(){
			fn_del_chk();
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
		 * 실태조사 클릭 이벤트
		 ***********************************/
		$("#btn_reg").click(function(){
			fn_reg_check();
		});
		/************************************
		 * 반환내역서 등록 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_page").click(function(){
			fn_page();
		});
		
		/************************************
		 * 회수정보 변경 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_upd2").click(function(){
			fn_upd();
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
			start_dt = start_dt.replace(/-/gi, "");
			if(start_dt.length == 8) start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
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
			var end_dt = $("#END_DT").val();
			end_dt = end_dt.replace(/-/gi, "");
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
  		/* 	
  		 //autoComplete 셋팅 멀티 SELECTBOX 
  		 $('[data-ax5autocomplete]').ax5autocomplete({
             removeIcon: '<i class="fa fa-times" aria-hidden="true"></i>',
             onSearch: function (callBack) {
                 var searchWord = this.searchWord;
                 setTimeout(function () {
                     var regExp = new RegExp(searchWord);
                     var myOptions = [];
                     whsdlList.forEach(function (n) {				//리스트정보
                         if (n.CUST_BIZRNM.match(regExp)) {
                             myOptions.push({
                                 value: n.CUST_BIZRID_NO,		//SELECTBOX value
                                 text: n.CUST_BIZRNM				//SELECTBOX text
                             })
                         }
                     });
                     callBack({
                    	 options: myOptions,
                     });
                     
                 }, 150);
  
             }
         });
  		 */
	 });
     
   //변경 페이지 이동 
  	function fn_upd() {
  		var selectorColumn 	= gridRoot.getObjectById("selector");
  		var input = gridRoot.getItemAt(selectorColumn.getSelectedIndices());
  		if(selectorColumn.getSelectedIndices() == "") {
  			alertMsg("선택한 건이 없습니다.");
  			return;
  		}else if(selectorColumn.getSelectedIndices().length >1) {
  			alertMsg("한건만 선택이 가능합니다.");
  			return;
  		//회수등록 ,회수조정 상태인경우만 가능	
  		};
  		

 	   	//파라미터에 조회조건값 저장 
 		INQ_PARAMS["PARAMS"] = {}
 		INQ_PARAMS["PARAMS"] = input;
 		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
 		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE9000601.do";

 		kora.common.goPage('/CE/EPCE9000642.do', INQ_PARAMS);
  	}

  	//반환내역등록 일괄확인 
//     function fn_upd2_check() {
//         var selectorColumn  = gridRoot.getObjectById("selector");
//         var input = gridRoot.getItemAt(selectorColumn.getSelectedIndices());
        
//         if(selectorColumn.getSelectedIndices() == "") {
//             alertMsg("선택한 건이 없습니다.");
//             return;
//         }
        
//         for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
//             var item = {};
//             item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
//             //반환등록 ,입고조정 ,입고확인 상태만 가능
//             if(item["STAT_NM"] != "회수등록"){
//                 alertMsg("회수등록 상태만 가능합니다. 다시 한 번 확인하시기 바랍니다.");
//                 return;
//             }
//         }
        
//         confirm("선택하신 내역이 모두 회수확인 됩니다. 계속 진행하시겠습니까?","fn_upd2");
//     }
   
   
    //반환등록요청 상태변경
//     function fn_upd2(){
//         var selectorColumn = gridRoot.getObjectById("selector");
//         var input = {"list": ""};
//         var row = new Array();
//         var url ="/CE/EPCE9000601_212.do";
//         for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
//             var item = {};
//             item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
//             row.push(item);
//         }
        
//         input["list"] = JSON.stringify(row);
//         showLoadingBar();
//         ajaxPost(url, input, function(rtnData){
//             if(rtnData.RSLT_CD == "0000"){
//                 fn_sel();
//                 alertMsg(rtnData.RSLT_MSG);
//             }else{
//                 alertMsg(rtnData.RSLT_MSG);
//             }
//             hideLoadingBar();
//         });
//     }
  	
   
    
     
    //초기화
    function fn_init(){
    	kora.common.setEtcCmBx2(urm_list, "","", $("#URM_NM"), "URM_CODE_NO", "URM_NM", "N" ,'T');		//도매업자 업체명
		kora.common.setEtcCmBx2(urm_list2, "","", $("#URM_CE_NO"), "SERIAL_NO", "URM_CE_NO", "N" ,'T');		//도매업자 업체명

    	kora.common.setEtcCmBx2(AreaCdList, "", "", $("#AreaCdList_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
// 		kora.common.setEtcCmBx2(urm_list2, "","", $("#URM_NM"), "URM_CODE_NO", "URM_NM", "N" ,'T');		//도매업자 업체명
		kora.common.setEtcCmBx2(rtrvl_cd_list, "","", $("#RTRVL_CTNR_CD"), "RTRVL_CTNR_CD", "CTNR_NM", "N" ,'T');		//도매업자 업체명
		$("#START_DT").val(kora.common.getDate("yyyy-mm-dd", "D", -7, false));//일주일전 날짜 
		$("#END_DT").val(kora.common.getDate("yyyy-mm-dd", "D", 0, false));//현재 날짜
		$("#URM_NM").select2();
		$("#URM_CE_NO").select2();	
		//text 셋팅
		$('.row > .col > .tit').each(function(){
			$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
		});
    }
    
  
   //무인회수기 조회
    function fn_sel(){
	   
	 	var input	={};
	 	var url = "/CE/EPCE9000601_194.do";
	 	var start_dt = $("#START_DT").val();
	 	var end_dt = $("#END_DT").val();
		start_dt = start_dt.replace(/-/gi, "");
	 	end_dt = end_dt.replace(/-/gi, "");
	
		if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
			alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return; 
		}else if(start_dt>end_dt){
			alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return;
		} 
		input["START_DT"] = $("#START_DT").val();
		input["END_DT"] = $("#END_DT").val();
		input["SERIAL_NO"] = $("#SERIAL_NO").val();//상태
		input["RTRVL_CTNR_CD"] = $("#RTRVL_CTNR_CD option:selected").val();  //용량
		input["AREA_CD"] = $("#AreaCdList_SEL option:selected").val();
		input["URM_CODE_NO"] = $("#URM_NM option:selected").val();
		input["URM_CE_NO"] = $("#URM_CE_NO option:selected").text();
		/* 페이징  */
		input["ROWS_PER_PAGE"] = gridRowsPerPage;
		input["CURRENT_PAGE"] = gridCurrentPage;
		INQ_PARAMS["SEL_PARAMS"] = input;
// 		kora.common.showLoadingBar(dataGrid, gridRoot);//그리드 loading bar on
		$("#modal").show();
		ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {
				gridApp.setData(rtnData.selList);
				/* 페이징 표시 */
				sumData = rtnData.totalList[0];
				gridTotalRowCount = parseInt(sumData.CNT); //총 카운트
				drawGridPagingNavigation(gridCurrentPage);
				$("#t1").text(sumData.T1);
				$("#t2").text(sumData.T2);
				$("#t3").text(sumData.T3);
				$("#t4").text(sumData.T4);
			}else{
				alertMsg("error");
			}
			
// 			hideLoadingBar();// 그리드 loading bar on
			$("#modal").hide();
   		});
    }
   
    /* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel(); //조회 펑션
	}
    
    //실태조사 상태변경 체크
	function fn_reg_check(){
			var selectorColumn = gridRoot.getObjectById("selector");
			if(selectorColumn.getSelectedIndices() == "") {
				alertMsg("선택한 건이 없습니다.");
				return false;
			}

			 for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				//반환등록 ,입고조정 ,입고확인 상태만 가능
				if(item["RTN_STAT_CD"] !="RG" && item["RTN_STAT_CD"] !="WC"	&& item["RTN_STAT_CD"] !="WJ"){
					alertMsg("실태조사 대상 설정 처리가 불가능한 자료가 선택되었습니다. 다시 한 번 확인하시기 바랍니다");
					return;
				}
			 }
				confirm("선택하신 내역이 모두 실태조사 대상 설정 처리됩니다. 계속 진행하시겠습니까?","fn_reg");
	}
   
   //실태조사 상태변경
	function fn_reg(){
			var selectorColumn = gridRoot.getObjectById("selector");
			var input = {"list": ""};
			var row = new Array();
			var url ="/CE/EPCE9000601_21.do";
			for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var item = {};
				item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(item);
			}
		    input["list"] = JSON.stringify(row);
		    showLoadingBar()
		 	ajaxPost(url, input, function(rtnData){
				if(rtnData.RSLT_CD == "0000"){
					fn_sel();
					alertMsg(rtnData.RSLT_MSG);
				}else{
					alertMsg(rtnData.RSLT_MSG);
				}
				hideLoadingBar();
			});
		
	}
   
	//무인회수기 삭제 confirm
   	function fn_del_chk(){
   		var selectorColumn = gridRoot.getObjectById("selector");
		if(selectorColumn.getSelectedIndices() == "") {
			alertMsg("선택한 건이 없습니다.");
			return false;
		}
		 for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
			var item = {};
			item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			
		 }
		confirm("선택된 내역이 삭제됩니다. 계속 진행하시겠습니까? 삭제 처리된 내역은 복원되지 않으며 재등록 하셔야 합니다.","fn_del");
	}
   
   //무인회수기 삭제
   function fn_del(){
	    var selectorColumn = gridRoot.getObjectById("selector");
		var input = {"list": ""};
		var row = new Array();
		var url ="/CE/EPCE9000601_04.do";
		if(selectorColumn.getSelectedIndices() == "") {
			alertMsg("선택한 건이 없습니다.");
			return false;
		}
		
		for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
			var item = {};
			item = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
			row.push(item);
		}
		
	    input["list"] = JSON.stringify(row);
    	showLoadingBar()
	 	ajaxPost(url, input, function(rtnData){
			if(rtnData.RSLT_CD == "0000"){
				fn_sel();
				alertMsg(rtnData.RSLT_MSG, 'fn_sel');
			}else{
				fn_sel();
				alertMsg(rtnData.RSLT_MSG);
			}
			hideLoadingBar();
		});    
	   
   }
	//무인회수기 등록 페이지 이동 
	function fn_page() {
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE9000601.do";
		kora.common.goPage('/CE/EPCE9000631.do', INQ_PARAMS);
	}
	//무인회수기 상세
	function link(){
		var idx = dataGrid.getSelectedIndices();
		var input = gridRoot.getItemAt(idx);
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["PARAMS"] = {};
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/CE/EPCE9000601.do";
		kora.common.goPage('/CE/EPCE9000664.do', INQ_PARAMS);
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
		var now = new Date();// 현재시간 가져오기
		var hour = new String(now.getHours());// 시간 가져오기
		var min = new String(now.getMinutes());// 분 가져오기
		var sec = new String(now.getSeconds());// 초 가져오기
		var today = kora.common.gfn_toDay();
		var fileName = $('#title_sub').text().replace("/","_") +"_" + today+hour+min+sec+".xlsx";
		
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
				
				if(columns[i].getDataField() == 'RTRVL_DT'){// html 태크 사용중 컬럼은 대체
					item['dataField'] = 'RTRVL_DT_ORI';
				}else{
					item['dataField'] = columns[i].getDataField();
				}
				
				item['textAlign'] = columns[i].getStyle('textAlign');
				item['id'] = kora.common.null2void(columns[i].id);
				col.push(item);
			}
		}
		
		
        
		var input = INQ_PARAMS["SEL_PARAMS"];
		input['excelYn'] = 'Y';
		input['fileName'] = fileName;
		input['columns'] = JSON.stringify(col);
		var url = "/CE/EPCE9000601_05.do";
		kora.common.showLoadingBar(dataGrid, gridRoot);// 그리드 loading bar on
	 	ajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
				alertMsg(rtnData.RSLT_MSG);
			}else{
				//파일다운로드
				frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
				frm.fileName.value = fileName;
				frm.submit();
			}
			
			hideLoadingBar()// 그리드 loading bar on
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
		layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" horizontalScrollPolicy="on"  sortableColumns="true" headerHeight="35">');
		layoutStr.push('		<groupedColumns>');
		layoutStr.push('			<DataGridSelectorColumn id="selector" width="40" textAlign="center" allowMultipleSelection="true" vertical-align="middle"  draggable="false"/>');//선택 
		layoutStr.push('			<DataGridColumn dataField="PNO" headerText="순번" visible="false" textAlign="center" width="50" draggable="false"/>');//순번
		layoutStr.push('			<DataGridColumn dataField="URM_NM" headerText="소매점명" textAlign="center" width="200"/>');
		layoutStr.push('			<DataGridColumn dataField="SERIAL_NO" headerText="시리얼번호"  textAlign="center" width="200"  />');//도매업자구분
		layoutStr.push('			<DataGridColumn dataField="URM_CE_NO" headerText="센터고유번호"  textAlign="center" width="200"  />');//도매업자구분
		layoutStr.push('			<DataGridColumn dataField="RTRVL_DT" headerText="회수일자"  textAlign="center" width="150"  itemRenderer="HtmlItem" />');//반환문서번호
		layoutStr.push('			<DataGridColumn dataField="AREA_NM" headerText="지역" textAlign="center" width="150" />');//상태
		layoutStr.push('			<DataGridColumn dataField="URM_QTY_TOT" headerText="회수량" textAlign="center"  formatter="{numfmt}" id="num1" width="100" />');//지역
		layoutStr.push('			<DataGridColumn dataField="URM_GTN_TOT" headerText="보증금" textAlign="center"  formatter="{numfmt}" id="num2" width="200" />');
		layoutStr.push('			<DataGridColumn dataField="URM_RTL_FEE_TOT" headerText="수수료" textAlign="center"  formatter="{numfmt}" id="num3" width="180" />');
		layoutStr.push('			<DataGridColumn dataField="SYS_NM" headerText="시스템구분" width="150" id="tmp1" textAlign="right" />');
		layoutStr.push('		</groupedColumns>');
		layoutStr.push('		<footers>');
		layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
		layoutStr.push('				<DataGridFooterColumn/>');
		layoutStr.push('				<DataGridFooterColumn/>');
		layoutStr.push('				<DataGridFooterColumn label="'+parent.fn_text('total')+'"  textAlign="center"/>');
        layoutStr.push('                <DataGridFooterColumn/>');
        layoutStr.push('                <DataGridFooterColumn/>');
		layoutStr.push('				<DataGridFooterColumn/>');
        layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');    
        layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');    
        layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');    
        layoutStr.push('                <DataGridFooterColumn dataColumn="{tmp1}"/>');
        layoutStr.push('            </DataGridFooter>');
        layoutStr.push('            <DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
        layoutStr.push('                <DataGridFooterColumn/>');
        layoutStr.push('				<DataGridFooterColumn/>');
        layoutStr.push('                <DataGridFooterColumn label="'+parent.fn_text('totalsum')+'"  textAlign="center"/>');
        layoutStr.push('                <DataGridFooterColumn/>');
        layoutStr.push('                <DataGridFooterColumn/>');
        layoutStr.push('                <DataGridFooterColumn/>');
        layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum1" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');   
        layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum2" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');   
        layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum3" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');   
        layoutStr.push('                <DataGridFooterColumn dataColumn="{tmp1}"/>');
		layoutStr.push('			</DataGridFooter>');
		layoutStr.push('		</footers>');
		layoutStr.push('      	<dataProvider>');
	    layoutStr.push('         	<SpanArrayCollection source="{$gridData}"/>');
	    layoutStr.push('      	</dataProvider>');
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
			setSpanAttributes();
		}
		var selectionChangeHandler = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			selectorColumn = gridRoot.getObjectById("selector");
		}
		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
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
	    	var data = gridRoot.getItemAt(i);
	    	if( data.RTN_STAT_CD == 'PP' || data.RTN_STAT_CD == 'PC' ){
	    		collection.addRowAttributeDetailAt(i, null, "#FFCC00", null, false, 20);
	    	}
	    }
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
	//회수량 합계
	function totalsum1(column, data) {
		if(sumData) 
			return sumData.URM_QTY_TOT; 
		else 
			return 0;
	}
	
	//보증금 합계
	function totalsum2(column, data) {
		if(sumData) 
			return sumData.URM_GTN_TOT; 
		else 
			return 0;
	}

	//수수료 합계
	function totalsum3(column, data) {
		if(sumData) 
			return sumData.URM_RTL_FEE_TOT; 
		else 
			return 0;
	}

	
/****************************************** 그리드 셋팅 끝***************************************** */
</script>

<style type="text/css">

.srcharea .row .col{
width: 25%;
}  
.srcharea .row .col .tit{
width: 50px;
}
.srcharea .row .box {
    width: 60%
}
.info_tbl .rtrvl_tot  td{
    background: #478bbd;
    font-weight: 700;
    font-size: 15px;
    color: #fcfbfb;
}
.form-control {
height: 50px;
font-size: 16px
}
 #s2id_URM_NM{
    width: 100%
}

.fa-close:before, .fa-times:before {
    content: "X"; 
    font-weight: 550;
 }
</style>

</head>
<body>
    <div class="iframe_inner"  >
			<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="areaList" value="<c:out value='${areaList}' />" />
			<input type="hidden" id="AreaCdList" value="<c:out value='${AreaCdList}' />"/>
			<input type="hidden" id="urm_list" value="<c:out value='${urm_list}' />" />
			<input type="hidden" id="urm_list2" value="<c:out value='${urm_list2}' />" />
			<input type="hidden" id="rtrvl_cd_list" value="<c:out value='${rtrvl_cd_list}' />" />
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
				<div class="btn" style="float:right" id="UR">
				<!--btn_dwnd  -->
				<!--btn_excel  -->
				</div>
			</div>
			<section class="secwrap"  id="params">
				<div class="srcharea" > 
				<div class="row" >
					<div class="col" style="width:430px;">
						<div class="tit" id="sel_term" style="width:85px"></div>	
						<div class="box" style="width:300px;padding:0px">
							<div class="calendar">
								<input type="text" id="START_DT" name="from" style="width: 130px;" class="i_notnull"><!--시작날짜  -->
							</div>
							<div class="obj">~</div>
							<div class="calendar">
								<input type="text" id="END_DT" name="to" style="width: 130px;"	class="i_notnull"><!-- 끝날짜 -->
							</div>
						</div>
					</div>
					<div class="col">
						<div class="tit" id="area_se"  style="width: 70px;"></div>  
						<div class="box">
							<select id="AreaCdList_SEL" name="AreaCdList_SEL"  style="max-width: 200px">
							</select>
						</div>
					</div>
					<div class="col" >
						<div class="tit" id="rtrvl_ctnr_cd" style="width: 85px;"></div>
						<div class="box">
							<!-- <select id="CPCT_CD" ></select>    -->
							<select id="RTRVL_CTNR_CD" NAME="RTRVL_CTNR_CD"  >
							</select>
						</div>
					</div>
				</div> <!-- end of row -->

				<div class="row">
						
						<div class="col" style="width:430px;">
							<div class="tit" style="width: 85px;">소매점명</div>  
							<div class="box">
								<select id="URM_NM" name="URM_NM"   style=""></select>
								<!-- <input type="text" id="BIZRNM_SEL" name="BIZRNM_SEL" style="width: 179px;" maxByteLength="60"> -->
							</div>
						</div>
					    <div class="col" >
							<div class="tit" id="urm_ce_no" style="width: 85px;">센터고유번호</div>  
							<div class="box" >
							<select id="URM_CE_NO" name="URM_CE_NO" style="width: 200px"></select>
							</div>
						</div>
						<div class="col" >
							<div class="tit" id="serial_no" style="width: 70px;"></div>  
							<div class="box" >
								<input type="text" lass="i_notnull"  id="SERIAL_NO" >
							</div>
						</div>
					
				    
						<!-- <div class="col" >
							<div class="tit"  style="width: 85px;">상태</div>
							<div class="box"  >
								  <select id="STAT_NM" name="STAT_NM">
								  		<option value="">전체</option>
								  		<option value="회수등록">회수등록</option>
								  		<option value="회수확인">회수확인</option>
								  </select>
							</div>
						</div> -->
						<div class="btn"  id="CR" ></div>
					</div> <!-- end of row -->
					
				</div>  <!-- end of srcharea -->
			</section>
			<section class="secwrap2 mt20">
				<div class="boxarea">
					<div class="info_tbl">
						<table style="width: 100%;">
							<colgroup>
								<col style="width: 10%;">
								<col style="width: 22.5%;">
								<col style="width: 22.5%;">
								<col style="width: 22.5%;">
								<col style="width: 22.5%;">
							</colgroup>
							<tbody>
								<tr class="rtrvl_tot" >
									<td rowspan="2" >합계</td>
									<td >총 사용량</td>
									<td >총 회수량</td>
									<td >총 보증금</td>
									<td >총 수수료</td>
								</tr>
								<tr>
									<td id='t1'></td>
									<td id='t2'></td>
									<td id='t3'></td>
									<td id='t4'></td>
									
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</section>
		<section class="btnwrap mt10" >
			<div class="btn" id="GL"></div>
			<div class="btn" style="float:right" id="GR"></div>
		</section>
			<div class="boxarea mt10">  <!-- 668 -->
				<div id="gridHolder" style="height: 668px; background: #FFF;"></div>
			   	<div class="gridPaging" id="gridPageNavigationDiv"></div><!-- 페이징 사용 등록 -->
			</div>	<!-- 그리드 셋팅 -->
		<section class="btnwrap" style="height:50px">
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
