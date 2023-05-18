<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>소매회수전용P-BOX관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />
<script type="text/javaScript" language="javascript" defer="defer">

	/* 페이징 사용 등록 */
	gridRowsPerPage = 3000;// 1페이지에서 보여줄 행 수
	gridCurrentPage = 1;// 현재 페이지
	gridTotalRowCount = 0; //전체 행 수

	 var INQ_PARAMS;//파라미터 데이터
     var bizr_tp_cd_list;//도매업자구분
     var whsdl_cd_list;//도매업자 업체명 조회
	 var brch_cd_List;//지점
     var stat_cd_list;//상태
     var prpsCdList;        //용도코드
     var grid_info;//그리드 컬럼 정보
     var toDay = kora.common.gfn_toDay(); // 현재 시간
     var sumData; //총합계
	 
     $(function() {
    	 
   		INQ_PARAMS 		= jsonObject($("#INQ_PARAMS").val());		//파라미터 데이터
  	    stat_cd_list 		= jsonObject($("#stat_cd_list").val());		//상태
  	    bizr_tp_cd_list 	= jsonObject($("#bizr_tp_cd_list").val());	//도매업자구분
  	    whsdl_cd_list 		= jsonObject($("#whsdl_cd_list").val());		//도매업자 업체명 조회
  	  	brch_cd_List 		= jsonObject($("#brch_cd_List").val());		//직매장/공장 정보
  	  	prpsCdList      = jsonObject($("#prpsCdList").val());
  	  	//console.log(stat_cd_list)
  	  	
  	  	//기본셋팅
  	 	 fn_init();
  	  	
	  	 //버튼 셋팅
	   	fn_btnSetting();
	   	 
	   	//그리드 셋팅
		fnSetGrid1();
		
		/************************************
		 * 도매업자 구분 변경 이벤트
		 ***********************************/
		$("#BIZR_TP_CD").change(function(){
			fn_bizr_tp_cd();
		});
		
		/************************************
		 * 도매업자 업체명  변경 이벤트
		 ***********************************/
		$("#WHSDL_BIZRNM").change(function(){
			fn_whsdl_bizrnm();
		});
		/*
		$("#WHSDL_BIZRNM2").change(function(){
			fn_whsdl_bizrnm();
		});
		$("#WHSDL_BIZRNM3").change(function(){
			fn_whsdl_bizrnm();
		});
		*/
		/************************************
		 * 조회 클릭 이벤트
		 ***********************************/
		$("#btn_sel").click(function(){
			//조회버튼 클릭시 페이징 초기화
			gridCurrentPage = 1;
			fn_sel();
		});
		
		/************************************
		 * 회수정보 삭제 클릭 이벤트
		 ***********************************/
		$("#btn_del").click(function(){
			fn_del_chk();
		});
		
		/************************************
		 * 회수등록 일괄확인  클릭 이벤트
		 ***********************************/
		$("#btn_upd2").click(function(){
			fn_upd_check();
		});
		
		/************************************
		 * 회수정보 등록 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_page").click(function(){
			fn_page();
		});
		
		/************************************
		 * 회수정보 변경 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_page2").click(function(){
			fn_page2();
		});
		
		
		
		/************************************
		 * 증빙자료관리 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_page3").click(function(){
			fn_page3();
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
  		
	 });
     
     //초기화
     function fn_init(){
	    	 kora.common.setEtcCmBx2(stat_cd_list, "","", $("#RTRVL_STAT_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');							//상태
			 kora.common.setEtcCmBx2(bizr_tp_cd_list, "","", $("#BIZR_TP_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');							//도매업자구분 
		 	 kora.common.setEtcCmBx2(whsdl_cd_list, "","", $("#WHSDL_BIZRNM"), "BIZRID_NO", "BIZRNM", "N");		//도매업자 업체명
		 	//kora.common.setEtcCmBx2(whsdl_cd_list, "","", $("#WHSDL_BIZRNM2"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');		//도매업자 업체명
		 	//kora.common.setEtcCmBx2(whsdl_cd_list, "","", $("#WHSDL_BIZRNM3"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');		//도매업자 업체명
		 	 kora.common.setEtcCmBx2([], "","", $("#WHSDL_BRCHNM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');								//지점
		 	 kora.common.setEtcCmBx2(prpsCdList, "!2|","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N","T");
			 
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
			/* $('.row > .col > .tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			}); */
			
			//div필수값 alt
			$("#START_DT").attr('alt',parent.fn_text('sel_term'));   
			$("#END_DT").attr('alt',parent.fn_text('sel_term'));   
			 
		
			 //파라미터 조회조건으로 셋팅
			 if(kora.common.null2void(INQ_PARAMS.SEL_PARAMS) != ""){
				 if(brch_cd_List !=null){
					kora.common.setEtcCmBx2(brch_cd_List, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');			 //직매장/공장
				 }
					kora.common.jsonToTable("params",INQ_PARAMS.SEL_PARAMS);
					/* 화면이동 페이징 셋팅 */
					gridCurrentPage = INQ_PARAMS.SEL_PARAMS.CURRENT_PAGE;
			 }
			 
			 //도매업자  검색
	  		 $("#WHSDL_BIZRNM").select2();
	  		//$("#WHSDL_BIZRNM2").select2();
	  		//$("#WHSDL_BIZRNM3").select2();	 
     }
     
	 //도매업자구분 변경시 도매업자 조회
	function fn_bizr_tp_cd(){
		var url = "/WH/EPWH9000101_19.do" 
		var input ={};
		$("#WHSDL_BIZRNM").select2("val","");
		kora.common.setEtcCmBx2([], "","", $("#WHSDL_BRCHNM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');								//지점
		if($("#BIZR_TP_CD").val() !=""){
			input["BIZR_TP_CD"] =$("#BIZR_TP_CD").val();
			ajaxPost(url, input, function(rtnData) {
					if ("" != rtnData && null != rtnData) {  
						 	kora.common.setEtcCmBx2(rtnData.whsdl_cd_list, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');		 //업체명
					}else{
							 alertMsg("error");
					}
			},false);
		}else{
		 	kora.common.setEtcCmBx2(whsdl_cd_list, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');		 //업체명
		}
   }
 
	//업체명 변경시 지점 조회
	function fn_whsdl_bizrnm(){
		var url = "/WH/EPWH9000101_192.do" 
		var input ={};
		var arr	= new Array();
		if($("#WHSDL_BIZRNM").val() !=""){
				arr	= $("#WHSDL_BIZRNM").val().split(";");
				input["BIZRID"]		= arr[0];  
				input["BIZRNO"]		= arr[1];
				input["BIZR_TP_CD"]		=$("#BIZR_TP_CD").val();
				//$("#WHSDL_BIZRNM").select2("val","");
				ajaxPost(url, input, function(rtnData) {
						if ("" != rtnData && null != rtnData) {   
							kora.common.setEtcCmBx2(rtnData.brch_cd_List, "","", $("#WHSDL_BRCHNM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');				//지점
						}else{
								 alertMsg("error");
						}
				},false);
		}else{
			kora.common.setEtcCmBx2([], "","", $("#WHSDL_BRCHNM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'T');				//지점
		}
   }
  
   //회수정보관리 조회
    function fn_sel(){
		  var input	={};
		  var url = "/WH/EPWH9000101_193.do" 
		  var start_dt 			= $("#START_DT").val();
		  var end_dt    			= $("#END_DT").val();
		  var arr 					= 	new Array();	//업체명 split
		  var arr2 					= 	new Array();	//지점 split
		  start_dt   				=  start_dt.replace(/-/gi, "");
	 	  end_dt    				=  end_dt.replace(/-/gi, "");
	
		 //날짜 정합성 체크. 20160204
		 if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
			alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return; 
		 }else if(start_dt>end_dt){
			alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return;
		 } 
	
		if($("#WHSDL_BIZRNM").val() !="" ){	//도매업자
			 input["WHSDL_BIZRNO"]   	= $("#WHSDL_BIZRNM").val();
		 }
		/* if($("#WHSDL_BRCHNM").val() !="" ){	//지점
		 	 arr2		=[];
			 arr2	= $("#WHSDL_BRCHNM").val().split(";");
			 input["WHSDL_BRCH_ID"]   	= arr2[0];
			 input["WHSDL_BRCH_NO"] 	= arr2[1]; 
		} */
		
		input["BIZR_TP_CD"]   		= $("#BIZR_TP_CD").val();		//도매업자 구분
		input["RTRVL_STAT_CD"]  = $("#RTRVL_STAT_CD").val();	//상태
		input["START_DT"]			= $("#START_DT").val();			//날짜
		input["END_DT"]				= $("#END_DT").val();			
		input["BIZRNM"]				= $("#REG_CUST_NM").val();			//회수처
	
        input["PRPS_CD"]            = $("#PRPS_CD option:selected").val();  //용도
        
	  	//검색조건들 상세갔다왔을경우 똑같은 ID SELECTBOX 셋팅위해
		input["WHSDL_BIZRNM"] 		= $("#WHSDL_BIZRNM").val();
		input["WHSDL_BRCHNM"]		= $("#WHSDL_BRCHNM").val();
		 
		//직접입력 사업자번호
		input["WHSDL_BIZRNO_DE"]	= $("#WHSDL_BIZRNO_DE").val();
		
		/* 페이징  */
		input["ROWS_PER_PAGE"] 		= gridRowsPerPage;
		input["CURRENT_PAGE"] 			= gridCurrentPage;
		INQ_PARAMS["SEL_PARAMS"] 	= input;
		
		showLoadingBar();// 그리드 loading bar on
      	ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {   
   					gridApp.setData(rtnData.selList);
// 					sumData = rtnData.totalList[0];

					/* 페이징 표시 */
// 					gridTotalRowCount = parseInt(sumData.CNT); //총 카운트
					//drawGridPagingNavigation(gridCurrentPage);
					
					//AMT_TOT
// 					$("#t1").text(rtnData.amt_tot_list[0].T1);
// 					$("#t2").text(rtnData.amt_tot_list[0].T2);
// 					$("#t3").text(rtnData.amt_tot_list[0].T3);
// 					$("#t4").text(rtnData.amt_tot_list[0].T4);
// 					$("#t5").text(rtnData.amt_tot_list[0].T5);
					
   				}else{
   						 alertMsg("error");
   				}
      			hideLoadingBar();// 그리드 loading bar on
   		});
		
    }
   
    /* 페이징 이동 스크립트 */
	function gridMovePage(goPage) {
		gridCurrentPage = goPage; //선택 페이지
		fn_sel(); //조회 펑션
	}
    
    //회수등록일괄확인 체크
	function fn_upd_check(){
			var selectorColumn = gridRoot.getObjectById("selector");
			if(selectorColumn.getSelectedIndices() == "") {
				alertMsg("선택한 건이 없습니다.");
				return false;
			}
			 for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
					var input = {};
					input = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
					//회수등록 ,회수조정 상태인경우만 가능
					/*
					if(input["RTRVL_STAT_CD"] !="RG" && input["RTRVL_STAT_CD"] !="WG" && input["RTRVL_STAT_CD"] !="RJ" && input["RTRVL_STAT_CD"] !="WJ" ){
						alertMsg("올바르지 않은 상태의 내역이 선택 되었습니다. \n\n 다시 한 번 확인하시기 바랍니다");
						return;
					}
					*/
			 }
			confirm("선택하신 내역에 대해 확인 처리하시겠습니까?","fn_upd");
	}
   
   //회수등록일괄확인
	function fn_upd(){
			var selectorColumn = gridRoot.getObjectById("selector");
			var input = {"list": ""};
			var row = new Array();
			var url ="/WH/EPWH9000101_21.do";
			 for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
					var input = {};
					input = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
					row.push(input);
			 }
		    input["list"] = JSON.stringify(row);

		 	ajaxPost(url, input, function(rtnData){
				if(rtnData.RSLT_CD == "0000"){
					alertMsg(rtnData.RSLT_MSG, 'fn_sel');
				}else{
					alertMsg(rtnData.RSLT_MSG);
				}

			});    
		
	}
   
	//회수정보 삭제 confirm
   	function fn_del_chk(){
   		var selectorColumn = gridRoot.getObjectById("selector");
		if(selectorColumn.getSelectedIndices() == "") {
			alertMsg("선택한 건이 없습니다.");
			return false;
		}
		
		 for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var input = {};
				input = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				
				//회수등록 ,회수조정 상태인경우만 가능
				/* if(input["RTRVL_STAT_CD"] !="RG" && input["RTRVL_STAT_CD"] !="WG" && input["RTRVL_STAT_CD"] !="RJ" && input["RTRVL_STAT_CD"] !="WJ" && input["RTRVL_STAT_CD"] !="VC" ){
					alertMsg("올바르지 않은 상태의 내역이 선택 되었습니다. \n\n 다시 한 번 확인하시기 바랍니다");
					return;
				} */
		 }
		confirm("선택하신 내역에 대해 삭제 처리하시겠습니까?","fn_del");
	}
   
   //회수정보 삭제
   function fn_del(){
	    var selectorColumn = gridRoot.getObjectById("selector");
		var input = {"list": ""};
		var row = new Array();
		var url ="/WH/EPWH9000101_04.do";
		if(selectorColumn.getSelectedIndices() == "") {
			alertMsg("선택한 건이 없습니다.");
			return false;
		}
		 for(var i=0; i<selectorColumn.getSelectedIndices().length; i++) {
				var input = {};
				input = gridRoot.getItemAt(selectorColumn.getSelectedIndices()[i]);
				row.push(input);
		 }
	    input["list"] = JSON.stringify(row);
    	showLoadingBar()
	 	ajaxPost(url, input, function(rtnData){
			if(rtnData.RSLT_CD == "0000"){
				alertMsg(rtnData.RSLT_MSG, 'fn_sel');
			}else{
				alertMsg(rtnData.RSLT_MSG);
			}
			hideLoadingBar();
		});    
	   
   }
	//회수정보 등록 페이지 이동 
	function fn_page() {
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH9000101.do";
		kora.common.goPage('/WH/EPWH9000131.do', INQ_PARAMS);
	}
	//회수정보변경 페이지 이동 
	function fn_page2() {
		var selectorColumn 	=	gridRoot.getObjectById("selector");
		var input 				=	gridRoot.getItemAt(selectorColumn.getSelectedIndices());
		if(selectorColumn.getSelectedIndices() == "") {
			alertMsg("선택한 건이 없습니다.");
			return;
		}else if(selectorColumn.getSelectedIndices().length >1) {
			alertMsg("한건만 선택이 가능합니다.");
			return;
		}
		INQ_PARAMS["PARAMS"] 				= {}
		INQ_PARAMS["PARAMS"]				= input;
		INQ_PARAMS["FN_CALLBACK"] 		= "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] 	= "/WH/EPWH9000101.do";
		kora.common.goPage('/WH/EPWH9000142.do', INQ_PARAMS);
	}
	
	//증빙자료관리 페이지 이동 
	function fn_page3() {
		
		INQ_PARAMS={};
		INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH9000101.do";
		kora.common.goPage('/WH/EPWH9000197.do', INQ_PARAMS);
	}

	//회수정보관리 상세
	function link(){
		var idx = dataGrid.getSelectedIndices();
		var input = gridRoot.getItemAt(idx);
		//파라미터에 조회조건값 저장 
		INQ_PARAMS["PARAMS"] = {};
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK"] = "fn_sel";
		INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH9000101.do";
		kora.common.goPage('/WH/EPWH9000164.do', INQ_PARAMS);
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
				
				if(columns[i].getDataField() == 'PBOX_LST_NO'){// html 태크 사용중 컬럼은 대체
					item['dataField'] = 'PNO';  
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
		var url = "/WH/EPWH9000101_05.do";
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
			layoutStr.push('    <NumberMaskFormatter id="maskfmt1" formatString="###-##-#####"/>');
			layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" horizontalScrollPolicy="on" draggableColumns="true" sortableColumns="true"   headerHeight="35">');
			layoutStr.push('		<groupedColumns>');   	
			layoutStr.push('			<DataGridSelectorColumn id="selector"	 		 width="40"	textAlign="center" allowMultipleSelection="true" vertical-align="middle"  draggable="false"/>');													//선택 
			//layoutStr.push('			<DataGridColumn dataField="PNO" 				 				headerText="'+ parent.fn_text('sn')+ '"					width="50" 	textAlign="center"  	 draggable="false"/>');				//순번
			layoutStr.push('			<DataGridColumn dataField="PBOX_LST_NO" 				 visible="false"				headerText="번호"					width="50" 	textAlign="center"  	 draggable="false"/>');				//순번
			layoutStr.push('			<DataGridColumn dataField="RTRVL_DT"		 			headerText="일자"  	width="100"  	textAlign="center" 	  itemRenderer="HtmlItem"/>');	//회수등록일자
			layoutStr.push('			<DataGridColumn dataField="BOX_SE_CD"			headerText="상태"  	width="160" 	textAlign="center"  	 />'); 										//회수처
			layoutStr.push('            <DataGridColumn dataField="CUST_BIZRNM"      headerText="소매업체명"  width="150"   textAlign="center"   />');                    //회수처 사업자번호
			layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNO"			 	headerText="소매업체 사업자번호" 			width="200"  formatter="{maskfmt1}"	textAlign="center"  	 />'); 				
			layoutStr.push('            <DataGridColumn dataField="WHSDL_BIZRNM"      headerText="도매업체명"  width="150"   textAlign="center"   />');                    //회수처 사업자번호//지역
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRNO"			 	headerText="도매업체 사업자번호" 			width="200"  formatter="{maskfmt1}" 	textAlign="center"  	 />');
			layoutStr.push('			<DataGridColumn dataField="AREA_NM"			 				headerText="지역" 			width="150" 	textAlign="center"  	 />'); 										//지역
			//layoutStr.push('			<DataGridColumn dataField="AREA_CD"			 				headerText="지역" 		 visible="false"		width="150" 	textAlign="center"  	 />'); 										//지역
			layoutStr.push('			<DataGridColumnGroup  												headerText="수량">');																											//반환량
			//layoutStr.push('				<DataGridColumn dataField="RMG_QTY_TOT" 		headerText="재고" width="90" formatter="{numfmt}"  id="num1"  textAlign="right" />');		//가정용
			layoutStr.push('				<DataGridColumn dataField="DLIVY_QTY" 		headerText="출고량" width="120" formatter="{numfmt}" id="num2" textAlign="right" />');		//유흥용
			layoutStr.push('				<DataGridColumn dataField="RTN_QTY" 	  		headerText="회수량" width="120" formatter="{numfmt}" id="num3" textAlign="right" />');	//직접
			layoutStr.push('				<DataGridColumn dataField="DST_QTY" 	  		headerText="파손(분실)량" width="120" formatter="{numfmt}" id="num4" textAlign="right" />');	//직접
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumn dataField="KEEP_QTY"  				headerText="보관량" width="120" formatter="{numfmt}" id="num6" textAlign="right" />');				//출고량보증금
			//layoutStr.push('			<DataGridColumn dataField="RTN_GTN_TOT"  				headerText="회수량 보증금" width="100" formatter="{numfmt}" id="num7" textAlign="right" />');				//회수량보증금
// 			layoutStr.push('			<DataGridColumn dataField="ATM_TOT"   						headerText="'+ parent.fn_text('amt_tot')+ '" width="120" formatter="{numfmt1}" id="num6"  textAlign="right" />');		//금액합계
			//layoutStr.push('			<DataGridColumn dataField="SYS_NM" 							headerText="'+ parent.fn_text('reg_se')+ '" width="80" id="tmp1" textAlign="center" />');														//등록구분
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			//layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn label="'+parent.fn_text('total')+'"  textAlign="center"/>');
 			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
			//layoutStr.push('				<DataGridFooterColumn/>');
            //layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');    
            layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');    
             layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');    
             //layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');    
             /*      layoutStr.push('                <DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');   */ 
            //layoutStr.push('                <DataGridFooterColumn dataColumn="{tmp1}"/>');
            layoutStr.push('            </DataGridFooter>');
            layoutStr.push('            <DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn label="'+parent.fn_text('totalsum')+'"  textAlign="center"/>');
            layoutStr.push('                <DataGridFooterColumn/>');
 			layoutStr.push('				<DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            layoutStr.push('                <DataGridFooterColumn/>');
            //layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum1" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum2" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum3" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');   
            layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum4" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');   
             layoutStr.push('                <DataGridFooterColumn summaryOperation="totalsum6" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');    
             //layoutStr.push('                <DataGridFooterColumn summaryOperation="totalsum7" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');    
             /*   layoutStr.push('                <DataGridFooterColumn labelJsFunction="totalsum6" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');*/   
            //layoutStr.push('                <DataGridFooterColumn dataColumn="{tmp1}"/>');
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
					/* eval(INQ_PARAMS.FN_CALLBACK+"()"); */
			 	 window[INQ_PARAMS.FN_CALLBACK]();
			 	//취약점점검 6034 기원우
			 }else{
				 gridApp.setData();
				/* 페이징 표시 */
				//drawGridPagingNavigation(gridCurrentPage);
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
	    	/* if( eval(data.REG_RTRVL_FEE_TOT) > eval(data.RTRVL_RTL_FEE_TOT) ){ */
    		if( data['REG_RTRVL_FEE_TOT'] > data['RTRVL_RTL_FEE_TOT'] ){
    		//취약점점검 6035 기원우 
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
	
	//회수량 가정용 합계
	function totalsum1(column, data) {
		if(sumData) 
			return sumData.FH_RTRVL_QTY_TOT; 
		else 
			return 0;
	}
	
	//회수량 유흥용 합계
	function totalsum2(column, data) {
		if(sumData) 
			return sumData.FB_RTRVL_QTY_TOT; 
		else 
			return 0;
	}

	//회수량 합계
	function totalsum3(column, data) {
		if(sumData) 
			return sumData.RTRVL_QTY_TOT; 
		else 
			return 0;
	}

	//보증급 합계
	function totalsum4(column, data) {
		if(sumData) 
			return sumData.RTRVL_GTN_TOT; 
		else 
			return 0;
	}

	//도매수수료 합계
	function totalsum5(column, data) {
		if(sumData) 
			return sumData.REG_RTRVL_FEE_TOT; 
		else 
			return 0;
	}

	//금액합계 합계
	function totalsum6(column, data) {
		if(sumData) 
			return sumData.ATM_TOT; 
		else 
			return 0;
	}	
	function totalsum7(column, data) {
		if(sumData) 
			return sumData.ATM_TOT; 
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
width: 39px;
}

.info_tbl .rtrvl_tot  td{
    background: #478bbd;
    font-weight: 700;
    font-size: 15px;
    color: #fcfbfb;
}
.srcharea .row .box {
    width: 60%
}
#s2id_WHSDL_BIZRNM{
    width: 100%
}


</style>

</head>
<body>
    <div class="iframe_inner"  >
    
			<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="bizr_tp_cd_list" value="<c:out value='${bizr_tp_cd_list}' />" />
			<input type="hidden" id="whsdl_cd_list" value="<c:out value='${whsdl_cd_list}' />" />
			<input type="hidden" id="stat_cd_list" value="<c:out value='${stat_cd_list}' />" />
			<input type="hidden" id="grid_info" value="<c:out value='${grid_info}' />" />
			<input type="hidden" id="brch_cd_List" value="<c:out value='${brch_cd_List}' />" />
			<input type="hidden" id="prpsCdList" value="<c:out value='${prpsCdList}' />" />
			
			<div class="h3group">
				<h3 class="tit" id="title"></h3>
				<div class="btn" style="float:right" id="UR">
				<!--btn_dwnd  -->
				<!--btn_excel  -->
				<button type="button" class="btn36 c2" style="width: 120px;" id="btn_excel"><span class="excel">엑셀저장</span></button>
				</div>
			</div>
		<section class="secwrap"  id="params">
				<div class="srcharea" > 
					<div class="row">
							<div class="col"  style="width:430px;">
								<div class="tit" id="" style="width:85px">조회기간</div>	<!-- 조회기간 -->
								<div class="box" style="width:300px;padding:0px">
									<div class="calendar" >
										<input type="text" id="START_DT" name="from" style="width: 130px" class="i_notnull"><!--시작날짜  -->
									</div>
									<div class="obj">~</div>
									<div class="calendar" >
										<input type="text" id="END_DT" name="to" style="width: 130px;" class="i_notnull"><!-- 끝날짜 -->
									</div>
								</div>
							</div>
							<!-- <div class="col"  style="width:430px">
									<div class="tit" id="whsl_se_cd_txt" style="width: 85px"></div>  도매업자구분
									<div class="box">
										<select id="BIZR_TP_CD" style="max-width: 200px" ></select>
									</div>
							</div>  -->
							<div class="col" >
									<div class="tit" id=""  style="width:85px">도매업자명</div> <!--  도매업자명 -->
									<div class="box"  >
										  <select id="WHSDL_BIZRNM" name="WHSDL_BIZRNM" style=""></select>
									</div>
							</div>
							 
							<!-- 
							<div class="col"  style="width:430px">
									<div class="tit" id="" style="width:135px">도매업자 사업자번호</div>
									<div class="box">
										<input type="text" id=WHSDL_BIZRNO_DE style="width:185px" format="number"></select>
									</div>
							</div>
							 -->
							 
							<div class="btn"  id="CR" >
								<button type="button" class="btn36 c1" style="width: 100px;" id="btn_sel">조회</button></div>
					</div> <!-- end of row -->
					
							
					
					
				</div>  <!-- end of srcharea -->
			</section>
			
			<!--  
			<section class="secwrap2 mt20">
					<div class="srcharea" > 
							<div class="row">
								<div class="col" >
										<div class="tit"  style="width:130px">PBOX도매업자추가</div>
										<div class="box"  >
											  <select id="WHSDL_BIZRNM2" name="WHSDL_BIZRNM2" style=""></select>
										</div>
								</div>
								<div class="col"  style="width:150px">
										<div class="box"  >
											  <button type="button" class="btn36 c2" style="width: 80px;" id="btn_page">추가</button>
										</div>
								</div>
								<div class="col" >
										<div class="tit"  style="width:130px">PBOX도매업자삭제</div> 
										<div class="box"  >
											  <select id="WHSDL_BIZRNM3" name="WHSDL_BIZRNM3" style=""></select>
										</div>
								</div>
								<div class="col" >
										<div class="box"  >
											  <button type="button" class="btn36 c5" style="width: 80px;" id="btn_del">삭제</button>
										</div>
								</div>
								 
							</div> 
					</div>
			</section> 
		-->
		
		<section class="btnwrap mt10" >
 			<div class="btn" id="GL"></div> 
			<div class="btn" style="float:right" id="GR">
				<button type="button" class="btn36 c3" style="width: 150px;" id="btn_del">P-BOX정보삭제</button>
				<button type="button" class="btn36 c3" style="width: 150px;" id="btn_page2">P-BOX정보변경</button>
				<button type="button" class="btn36 c2" style="width: 150px;" id="btn_page">P-BOX정보등록</button>
			</div>
		</section>
		<div class="boxarea mt10">  <!-- 668 -->
			<div id="gridHolder" style="height: 668px; background: #FFF;"></div>
		   	<!-- <div class="gridPaging" id="gridPageNavigationDiv"></div>페이징 사용 등록 -->
		</div>	<!-- 그리드 셋팅 -->
		<div class="h4group" >
			<h5 class="tit"  style="font-size: 16px;">
				&nbsp;※ 조회기간의 기준은 테스트 입니다.<br/>
			</h5>
		</div>
		<section class="btnwrap" style="" >
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
