<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>개별취급수수료등록</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
   
     var mfcSeCdList;
     var bizrTpCd;
     var INQ_PARAMS;
     var toDay = kora.common.gfn_toDay();  // 현재 시간
     var gridselList={};  // 기준취급수수료 선택 조회 그리드 데이터
     var flag= false;
     $(function() {

    	 mfcSeCdList = jsonObject($('#mfcSeCdList').val());
         bizrTpCd = jsonObject($('#bizrTpCd').val());
         INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
    	 
    	//버튼 셋팅
 		fn_btnSetting();
    	 
    	 //그리드 셋팅
		 fnSetGrid1();
    	 
		//날짜 셋팅
	    $('#START_DT').YJcalendar({  
			toName : 'to',
			triggerBtn : true,
			
		});
		$('#END_DT').YJcalendar({
			fromName : 'from',
			triggerBtn : true
		});
		
		//text 셋팅
		$('#title_sub').text('<c:out value="${titleSub}" />');						  //타이틀
		$('#mfc_se_cd').text(parent.fn_text('mfc_se_cd')); //생산자
		$('#ctnr_nm').text(parent.fn_text('ctnr_nm')); 		 //빈용기명
		$('#aplc_dt').text(parent.fn_text('aplc_dt')); 		 //적용기간
		$('#aplc_dt2').text(parent.fn_text('aplc_dt')); 		 //적용기간2
		$('#whsl_fee').text(parent.fn_text('whsl_fee')); 		 //도매취급수수료
		$('#rtl_fee').text(parent.fn_text('rtl_fee'));			 //소매취급수수료
		$('#mfc_brch_nm').text(parent.fn_text('mfc_brch_nm')); 		 //직매장/공장
		$('#bizr_tp_cd').text(parent.fn_text('bizr_tp_cd')); 		 //거래처 구분 (도매업자 구분)
		
		 //div필수값 alt
		 $("#WHSL_FEE").attr('alt',parent.fn_text('whsl_fee'));   				//도매수수료
		 $("#RTL_FEE").attr('alt',parent.fn_text('rtl_fee'));						//소매수수료
		 $("#START_DT").attr('alt',parent.fn_text('aplc_dt'));					//적용기간
		 $("#END_DT").attr('alt',parent.fn_text('aplc_dt'));						//적용기간
		
      
		/************************************
		 * 생산자구분 변경 이벤트
		 ***********************************/
		$("#MFC_SE_CD").change(function(){
			fn_mfc_se_cd();
		});
		
		/************************************
		 * 빈용기명  변경 이벤트
		 ***********************************/
		$("#CTNR_CD").change(function(){
			fn_ctnr_nm();
		});
		
		/************************************
		 * 적용기간 변경 이벤트
		 ***********************************/
		$("#APLC_DT").change(function(){
			fn_init();
		});
		
		/************************************
		 * 조회버튼 클릭 이벤트
		 ***********************************/
		$("#btn_sel").click(function(){
			fn_sel();
		});
		
		/************************************
		 * 조회버튼2 클릭 이벤트
		 ***********************************/
		$("#btn_sel2").click(function(){
			fn_sel2();
		});
		
		/************************************
		 * 일괄적용버튼 클릭 이벤트
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
		
		$("#MFC_SE_CD  option").remove();
		$("#CTNR_NM  option").remove();
		$("#APLC_DT  option").remove();
		$("#MFC_BRCH_NM  option").remove();
		kora.common.setEtcCmBx2(mfcSeCdList, "","", $("#MFC_SE_CD"), "BIZRID_NO", "BIZRNM", "N" ,'S');			//생산자명 SELECTBOX
		kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');							//빈용기명 SELECTBOX
		kora.common.setEtcCmBx2([], "","", $("#APLC_DT"), "APLC_DT", "APLC_DT", "N" ,'S');								//적용기간 SELECTBOX
		kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "CTNR_CD", "MFC_BRCH_NM", "N" ,'T');			//직매장/공장 SELECTBOX
		kora.common.setEtcCmBx2(bizrTpCd, "","", $("#BIZR_TP_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');				//거래처구분
		
	});
    //생산자구분 변경시
     function fn_mfc_se_cd(){
	   	 $("#CTNR_CD  option").remove();
		 $("#APLC_DT  option").remove();
		 $("#MFC_BRCH_NM  option").remove();
		 $("#BIZR_TP_CD  option").remove();
		 kora.common.setEtcCmBx2("", "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');  			//빈용기명 	   selectbox
		 kora.common.setEtcCmBx2("", "","", $("#APLC_DT"), "APLC_DT_CD", "APLC_DT", "N" ,'T');  		//적용기간 selectbox
		 kora.common.setEtcCmBx2("", "","", $("#MFC_BRCH_NM"), "CTNR_CD", "CTNR_NM", "N" ,'T');  //직매장/공장 selectbox
		 kora.common.setEtcCmBx2(bizrTpCd, "","", $("#BIZR_TP_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');					//거래처구분
		 fn_init();
		 flag = false;
    	 var url = "/CE/EPCE0164331_19.do" 
		 var input ={};
    	 var arr = new Array();
    	 
    	 if($("#MFC_SE_CD").val() !=""){
				 arr= $("#MFC_SE_CD").val().split(";")
				 input["BIZRID"] 	=arr[0];	 
			     input["BIZRNO"] =arr[1];
			     input["USE_YN"] ="Y";
			     showLoadingBar();
		      	 ajaxPost(url, input, function(rtnData) {
		   				if ("" != rtnData && null != rtnData) {   
		   					 $("#CTNR_CD  option").remove();
		   					 $("#MFC_BRCH_NM  option").remove();
		   					 kora.common.setEtcCmBx2(rtnData.ctnrNmList, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');  //빈용기명 	   selectbox
		   					 kora.common.setEtcCmBx2(rtnData.brchList, "","", $("#MFC_BRCH_NM"), "BRCH_CD", "BRCH_NM", "N" ,'T');  //직매장/공장 selectbox
		   				} else {
		   					alertMsg("error");
		   				}
		   		 }, false);
		   	  	 hideLoadingBar();
    	 }
   	 
     }
    
     //빈용기명 변경시
     function fn_ctnr_nm(){
				var url = "/CE/EPCE0164331_192.do" 
				var input ={};
				     input["CTNR_CD"] =$("#CTNR_CD").val();
				     fn_init();
					 flag = false;
				   showLoadingBar();
		       	   ajaxPost(url, input, function(rtnData) {
		    				if ("" != rtnData && null != rtnData) {   
		    					 $("#APLC_DT  option").remove();
		    					 kora.common.setEtcCmBx2(rtnData.aplc_dt, "","", $("#APLC_DT"), "APLC_DT_CD", "APLC_DT", "N" ,'S');
		    				} else {
		    					alertMsg("error");
		    				}
		    		}, false);
		    		hideLoadingBar();
    	 
     }
     
     //적용기간 변경시
     function fn_init(){
    	 gridApp.setData([]);
    	 gridApp2.setData([]);
		 $("#WHSL_FEE").val("");
		 $("#RTL_FEE").val("");
		 flag = false;
		 
		//달력날짜 셋팅  달력 초기화
		$('#START_DT').YJdate({ dateSetting: '' });
		$('#END_DT').YJdate({ dateSetting: '' });
     }
     
     
	//조회
   function fn_sel(){
		
	 	var url = "/CE/EPCE0164331_193.do";
		var input = {};
		var arr	= new Array();
		var arr2 = new Array();
		var mfc_se_cd = $("#MFC_SE_CD").val();
		 	 arr	= $("#APLC_DT	option:selected").val().split("N");
		 	 arr2	= mfc_se_cd.split(";")
		if(arr ==""|| $("#MFC_SE_CD	option:selected").val() =="" || $("#CTNR_CD	option:selected").val() =="" ){
			alertMsg("생산자명 ,빈용기명 ,적용기간을 전부 선택해야합니다.")
			return 
		}
		input["CTNR_CD"] 		= $("#CTNR_CD		option:selected").val();
		input["APLC_ST_DT"] 		= arr[0];
		input["APLC_END_DT"] 		= arr[1];
		input["BIZRID"] 				= arr2[0];	 
	    input["BIZRNO"] 				= arr2[1];
		
    	   showLoadingBar();
      	   ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {
   					gridApp.setData(rtnData.selList);
   					gridselList = rtnData.selList;
		   			flag 			= true;
		   			var st_dt 	= rtnData.selList[0].APLC_ST_DT;
		   			var end_dt = rtnData.selList[0].APLC_END_DT;
		   			//st_dt='20180319'
		   			if( Number(st_dt) < Number(toDay)+1 &&  Number(toDay) < Number(end_dt)){
		   				st_dt =Number(toDay)+1;
		   			}
		   			
		   			
		   			//달력날짜 셋팅    
		   			$('#START_DT').YJdate({ dateSetting: st_dt });
		   			$('#END_DT').YJdate({ dateSetting: end_dt });

   				} else {
   					alertMsg("error");
   				}
   		}, false);
   		hideLoadingBar(); 
   			
   }
	//조회2
   function fn_sel2(){
	   if(!flag){
			alertMsg("기준취급수수료를 적용해야합니다.")
			return;
		}
	 	var url = "/CE/EPCE0164331_194.do";
		var input = {};
		var arr	= new Array();
		var arr2 = new Array();
		var start_dt	  			=	gridselList[0].APLC_ST_DT;     			 //적용 시작날짜 초기값
		var end_dt 	  			=	gridselList[0].APLC_END_DT; 	 			 //적용 끝날짜 초기값
		var mfc_se_cd 		= $("#MFC_SE_CD").val();
		var viewSart_dt 		= $("#START_DT").val();
		var viewEnd_dt    	= $("#END_DT").val();							
			 viewSart_dt   =  viewSart_dt.replace(/-/gi, "");
			 viewEnd_dt    =  viewEnd_dt.replace(/-/gi, "");
		//날짜 정합성 체크. 20160204
		if(!kora.common.fn_validDate($("#START_DT").val()) || !kora.common.fn_validDate($("#END_DT").val())){ 
			alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return; 
		}else if(viewSart_dt>viewEnd_dt){
			alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return;
		}else if(start_dt >viewSart_dt ){
	    	alertMsg("기준취급수수료 시작날짜보다  개별취급수수료 시작날짜가  적을수 없습니다.");
	    	return false;
	    }else if(end_dt <viewEnd_dt ){
	    	alertMsg("기준취급수수료 끝 날짜보다 개별취급수수료  끝날짜가  클수 없습니다.");
	    	return false;
	    }  
		
		 	 arr2	= mfc_se_cd.split(";")
			 arr = $("#MFC_BRCH_NM	option:selected").val().split(";");
		 	input["CTNR_CD"] 				=$("#CTNR_CD option:selected").val();
			input["BIZRID"] 					= arr2[0];	 
			input["BIZRNO"] 					= arr2[1];
			input["BIZR_TP_CD"]				= $("#BIZR_TP_CD	option:selected").val();
			input["MFC_BRCH_ID"]			= arr[0];
			input["MFC_BRCH_NO"]		= arr[1];
			input["START_DT"]				= viewSart_dt;
			input["END_DT"]					= viewEnd_dt;	
			input["LANG_SE_CD"]			= gridselList[0].LANG_SE_CD;
			input["REG_SN"]					= gridselList[0].REG_SN;	
			input["SAVE_CHK"]   			= "S"				
		
    	  showLoadingBar();
      	   ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {
   					if(rtnData.RSLT_MSG !="") alertMsg(rtnData.RSLT_MSG);
   					gridApp2.setData(rtnData.selList);
   				} else {
   					alertMsg("error");
   				}
   		});
   			hideLoadingBar(); 
		 
   }	
	 //수수료 및 날짜유효성 체크
	function fn_validChk(){
		var start_dt	  				 =	gridselList[0].APLC_ST_DT;     			 //적용 시작날짜 초기값
		var end_dt 	  				 =	gridselList[0].APLC_END_DT; 	 			//적용 끝날짜 초기값
		var psbl_st_whsl_fee	  	 =	gridselList[0].PSBL_ST_WHSL_FEE;		 //도매 초기 수수료 값
		var psbl_end_whsl_fee 	 =	gridselList[0].PSBL_END_WHSL_FEE;		 //도매 초기 수수료 값
		var psbl_st_rtl_fee	 	 =	gridselList[0].PSBL_ST_RTL_FEE;			 //소매 초기 수수료 값
		var psbl_end_rtl_fee		 =	gridselList[0].PSBL_END_RTL_FEE;		 //소매 초기 수수료 값
		var viewSart_dt = $("#START_DT").val().replace(/-/gi, "");  			
		var viewEnd_dt = $("#END_DT").val().replace(/-/gi, "");
		//날짜 정합성 체크. 20160204
		if(!kora.common.fn_validDate($("#START_DT").val(),"") || !kora.common.fn_validDate($("#END_DT").val())){ 
			alertMsg(parent.fn_text("date_chk")); 
			return false;
		}else if(!kora.common.gfn_isDate($("#START_DT").val()) || !kora.common.gfn_isDate($("#END_DT").val()) ){
			alertMsg("올바른 날짜 형식이 아닙니다.");
			return false;
		}else if(start_dt >viewSart_dt ){
	    	alertMsg("기준취급수수료 시작날짜보다  개별취급수수료 시작날짜가  적을수 없습니다.");
	    	return false;
	    } else if(viewSart_dt<toDay+1){
	    	alertMsg("적용기간은 익일 이후의 일자로만 설정 가능합니다");
	    	return false;
	 	}else if(end_dt <viewEnd_dt ){
	    	alertMsg("기준취급수수료 끝 날짜보다 개별취급수수료  끝날짜가  클수 없습니다.");
	    	return false;
	    } else if(psbl_st_whsl_fee > $("#WHSL_FEE").val() ){
	    	alertMsg("기준취급 도매수수료  최저조정범위보다 개별취급수수료 도매수수료 값이  작을수 없습니다.");
	    	return false;
	    } else if(psbl_end_whsl_fee < $("#WHSL_FEE").val() ){
	    	alertMsg("기준취급 도매수수료  최고조정범위보다 개별취급수수료 도매수수료 값이  클수 없습니다.");
	    	return false;
	    } else if(psbl_st_rtl_fee > $("#RTL_FEE").val() ){
	    	alertMsg("기준취급 소매수수료  최저조정범위보다 개별취급수수료 소매수수료 값이  작을수 없습니다.");
	    	return false;
	    } 
	    else if(psbl_end_rtl_fee < $("#RTL_FEE").val() ){
	    	alertMsg("기준취급 소매수수료  최고조정범위보다 개별취급수수료 소매수수료 값이  클수 없습니다.");
	    	return false;
	    }else{
	    return true;
	    }
	    
	}
	
	//일괄적용
	function fn_reg(){
		 
	    var selectorColumn2 = gridRoot2.getObjectById("selector");
		var input = {"list": ""};
		var row = new Array();
		var url ="/CE/EPCE0164331_09.do";
		
		if(!flag){
			alertMsg("기준취급수수료를 적용해야합니다.")
			return;
		}else if (!kora.common.cfrmDivChkValid("divInput")) {//필수입력값 체크
			return;
		}else if(selectorColumn2.getSelectedIndices() == "") {
			alertMsg("선택한 건이 없습니다.");
			return false;
		}else if(fn_validChk() ==false){//수수료 유효성 체크
			return
		}
	     
	    for(var i=0; i<selectorColumn2.getSelectedIndices().length; i++) {
			var item = {};
			item = gridRoot2.getItemAt(selectorColumn2.getSelectedIndices()[i]);
			item["CTNR_CD"]	    		=	gridselList[0].CTNR_CD;			
			item["WHSL_FEE"]	    	=	$("#WHSL_FEE").val();				//도매수수료
			item["RTL_FEE"]	    		=	$("#RTL_FEE").val();					//소매수수료
			item["START_DT"]	    	=	$("#START_DT").val();				//적용시작일자
			item["END_DT"]	    		=	$("#END_DT").val();					//적용종료일자 
			item["LANG_SE_CD"]	    	= 	gridselList[0].LANG_SE_CD;		//기준취급수수료 언어구분
			item["REG_SN"]	    		=	gridselList[0].REG_SN;				//기준취급수수료 등록순번
			item["BTN_SE_CD"]		    = "IS"; 										//버튼 코드 저장	
			item["SAVE_CHK"] 			= "S";
			row.push(item);
	    }
	    input["list"] = JSON.stringify(row);
	    showLoadingBar2()
	 	ajaxPost(url, input, function(rtnData){
			if(rtnData.RSLT_CD == "0000"){
				fn_sel2();
				alertMsg(rtnData.RSLT_MSG);
			}else{
				alertMsg(rtnData.RSLT_MSG);
			}
		},false);    
		hideLoadingBar2();
		
	}
	//취소
	function fn_cnl(){
		kora.common.goPageB('', INQ_PARAMS);
	}
	//----------------------- 그리드 설정 시작 -------------------------------------

	//rMate 그리드 생성 준비가 완료된 상태 시 호출할 함수를 지정합니다.
	var jsVars = "rMateOnLoadCallFunction=gridReadyHandler";
	var jsVars2 = "rMateOnLoadCallFunction=gridReadyHandler2";
	var gridApp, gridRoot, dataGrid, selectorColumn;
	var gridApp2, gridRoot2, dataGrid2, selectorColumn2;
	var layoutStr = new Array();
	var layoutStr2 = new Array();

	function fnSetGrid1() {

		//rMateDataGrid 를 생성합니다.
		//파라메터 (순서대로) 
		//1. 그리드의 id ( 임의로 지정하십시오. ) 
		//2. 그리드가 위치할 div 의 id (즉, 그리드의 부모 div 의 id 입니다.)
		//3. 그리드 생성 시 필요한 환경 변수들의 묶음인 jsVars
		//4. 그리드의 가로 사이즈 (생략 가능, 생략 시 100%)
		//5. 그리드의 세로 사이즈 (생략 가능, 생략 시 100%)
		rMateGridH5.create("grid1", "gridHolder", jsVars, "100%", "100%");
		rMateGridH5.create("grid2", "gridHolder2", jsVars2, "100%", "100%");

		layoutStr = new Array();
		layoutStr.push('<rMateGrid>');
		layoutStr	.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
		layoutStr	.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" sortableColumns="true"   horizontalGridLines="true" headerHeight="60">');
		layoutStr.push('		<columns>');
		layoutStr.push('			<DataGridColumn dataField="CTNR_CD"  headerText="'+ parent.fn_text('ctnr_cd')	+ '"	width="8%"	textAlign="center"/>');												//순번
		layoutStr.push('			<DataGridColumn dataField="CTNR_NM" headerText="'+ parent.fn_text('ctnr_nm')	+ '"	width="20%"	textAlign="center"/>');												//생산자
		layoutStr.push('			<DataGridColumn dataField="STD_FEE"	 headerText="'+ parent.fn_text('std_fee')+ '"		width="10%"	textAlign="center" />'); //기준취급수수료
		layoutStr.push('			<DataGridColumn dataField="STD_WHSL_FEE"	 headerText="'+ parent.fn_text('std_whsl_fee')	+ '"	width="10%"	textAlign="center"/>');//기준도매수수료
		layoutStr	.push('			<DataGridColumn dataField="STD_RTL_FEE"		 headerText="'+ parent.fn_text('std_rtl_fee')	+ '"		width="10%"	itemRenderer="HtmlItem"  textAlign="center" />');//기준소매수수료
		layoutStr.push('			<DataGridColumn dataField="PSBL_FEE"			 headerText="'+ parent.fn_text('psbl_fee')+ '"			width="10%"	textAlign="center" />'); //취급수수료 조정 가능범위
		layoutStr.push('			<DataGridColumn dataField="PSBL_WHSL_FEE" headerText="'+ parent.fn_text('psbl_whsl_fee')+ '"	width="10%"	textAlign="center" />');//도매수수료 조정 가능범위
		layoutStr.push('			<DataGridColumn dataField="PSBL_RTL_FEE"	 headerText="'+ parent.fn_text('psbl_rtl_fee')+ '"		width="10%"	textAlign="center" />');//소매수수료 조정 가능범위
		layoutStr.push('			<DataGridColumn dataField="APLC_DT"			 headerText="'+ parent.fn_text('aplc_dt')	+ '"			width="20%"	textAlign="center"/>');
		layoutStr	.push('			<DataGridColumn dataField="LANG_SE_CD"		 textAlign="center" visible="false"/>');
		layoutStr	.push('			<DataGridColumn dataField="APLC_ST_DT"		 textAlign="center" visible="false"/>');
		layoutStr	.push('			<DataGridColumn dataField="APLC_END_DT"	 textAlign="center" visible="false"/>');
		layoutStr.push('		</columns>');
		layoutStr.push('	</DataGrid>');
		layoutStr.push('</rMateGrid>');
		
		layoutStr2.push('<rMateGrid>');
		layoutStr2.push('	<NumberMaskFormatter id="maskfmt1" formatString="###-##-#####"/>');
		layoutStr2.push('	<NumberFormatter id="numfmt1" precision="1" useThousandsSeparator="true"/>');
		layoutStr2.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true"   horizontalScrollPolicy="on"  draggableColumns="true" sortableColumns="true"   horizontalGridLines="true" headerHeight="60">');
		layoutStr2.push('		<columns>');
		layoutStr2.push('			<DataGridSelectorColumn id="selector"	 		 headerText="'+ parent.fn_text('sel')+ '"					width="50"	textAlign="center" allowMultipleSelection="true" vertical-align="middle"  />');	//선택 
		layoutStr2.push('			<DataGridColumn dataField="index" 				 headerText="'+ parent.fn_text('sn')	+ '" 					width="50" 	textAlign="center" itemRenderer="IndexNoItem"   />');	//순번
		layoutStr2.push('			<DataGridColumn dataField="MFC_BIZRNM"    headerText="'+ parent.fn_text('mfc_bizrnm')	+ '"	width="120"	textAlign="center" />');	//생산자																		
		layoutStr2.push('			<DataGridColumn dataField="MFC_BRCH_NM" headerText="'+ parent.fn_text('mfc_brch_nm')	+ '"	width="100"	textAlign="center" />');	//직매장/공장																	
		layoutStr2.push('			<DataGridColumn dataField="BIZR_TP_NM"  	 headerText="'+ parent.fn_text('bizr_tp_cd')	+ '"		width="100"	textAlign="center" />');	//거래처구분																	
		layoutStr2.push('			<DataGridColumn dataField="CUST_BIZRNO"	 headerText="'+ parent.fn_text('cust_bizrno')	+ '"			width="120"	textAlign="center" formatter="{maskfmt1}" />');	//사업자번호
		layoutStr2.push('			<DataGridColumn dataField="CUST_BIZRNM"	 headerText="'+ parent.fn_text('cust_bizrnm')+ '"   	width="120"	textAlign="center" />');	//거래처명
		layoutStr2.push('			<DataGridColumn dataField="CUST_BRCH_NM"	 headerText="'+ parent.fn_text('brch_nm')+ '"   	width="120"	textAlign="center" />');	//거래처명
		layoutStr2.push('			<DataGridColumn dataField="CTNR_NM"	 	 headerText="'+ parent.fn_text('ctnr_nm')	+ '"			width="150"	textAlign="center" />');									//빈용기명
		layoutStr2.push('			<DataGridColumn dataField="WHSL_FEE"		 headerText="'+ parent.fn_text('whsl_fee')	+ '"		width="120"	textAlign="center" formatter="{numfmt1}"  />');	//도매취급수수료
		layoutStr2.push('			<DataGridColumn dataField="RTL_FEE"	 		 headerText="'+ parent.fn_text('rtl_fee')+ '"				width="120"	textAlign="center" formatter="{numfmt1}" />');	//소매취급수수료
		layoutStr2.push('			<DataGridColumn dataField="APLC_DT"			 headerText="'+ parent.fn_text('aplc_dt')	+ '"			width="150"	textAlign="center" />'); //적용기간
		layoutStr2.push('			<DataGridColumn dataField="MFC_BIZRID" 		 textAlign="center" visible="false" />')			
		layoutStr2.push('			<DataGridColumn dataField="CUST_BIZRID" 	 textAlign="center" visible="false" />')		
		layoutStr2.push('			<DataGridColumn dataField="CUST_BRCH_NO" textAlign="center" visible="false" />')
		layoutStr2.push('			<DataGridColumn dataField="BIZR_TP_CD" 		 textAlign="center" visible="false" />')		
		layoutStr2.push('		</columns>');
		layoutStr2.push('	</DataGrid>');
		layoutStr2.push('</rMateGrid>');
		
	}

	//그리드의 속성인 rMateOnLoadCallFunction 으로 설정된 함수.
	//rMate 그리드의 준비가 완료된 경우 이 함수가 호출됩니다.
	//이 함수를 통해 그리드에 레이아웃과 데이터를 삽입합니다.
	//파라메터 : id - rMateGridH5.create() 사용 시 사용자가 지정한 id 입니다.
	function gridReadyHandler(id) {
		gridApp = document.getElementById(id); // 그리드를 포함하는 div 객체
		gridRoot = gridApp.getRoot(); // 데이터와 그리드를 포함하는 객체

		gridApp.setLayout(layoutStr.join("").toString());

		var selectionChangeHandler = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			selectorColumn = gridRoot.getObjectById("selector");
		}

		var layoutCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			dataGrid.addEventListener("change", selectionChangeHandler);
		}

		var dataCompleteHandler = function(event) {
			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
			dataGrid.setEnabled(true);
			gridRoot.removeLoadingBar();
		}

		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
		gridApp.setData();
	}

	
	function gridReadyHandler2(id) {
		gridApp2 = document.getElementById(id); // 그리드를 포함하는 div 객체
		gridRoot2 = gridApp2.getRoot(); // 데이터와 그리드를 포함하는 객체

		gridApp2.setLayout(layoutStr2.join("").toString());

		var selectionChangeHandler2 = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			selectorColumn2 = gridRoot2.getObjectById("selector");
/* 		//	selectorColumn.setSelectedIndex(-1);
			selectorColumn.setSelectedIndex(rowIndex); */
		}

		var layoutCompleteHandler2 = function(event) {
			dataGrid2 = gridRoot2.getDataGrid(); // 그리드 객체
			dataGrid2.addEventListener("change", selectionChangeHandler2);
		}

		var dataCompleteHandler2 = function(event) {
			dataGrid2 = gridRoot2.getDataGrid(); // 그리드 객체
			dataGrid2.setEnabled(true);
			gridRoot2.removeLoadingBar();
		}

		gridRoot2.addEventListener("dataComplete", dataCompleteHandler2);
		gridRoot2.addEventListener("layoutComplete", layoutCompleteHandler2);
		gridApp2.setData();
	}

	function showLoadingBar() {
		kora.common.showLoadingBar(dataGrid, gridRoot);
	}

	function hideLoadingBar() {
		kora.common.hideLoadingBar(dataGrid, gridRoot);
	}
	
	function showLoadingBar2() {
		kora.common.showLoadingBar(dataGrid2, gridRoot2);
	}

	function hideLoadingBar2() {
		kora.common.hideLoadingBar(dataGrid2, gridRoot2);
	}
	//----------------------- 그리드 설정 끝 -----------------------
	
	

/****************************************** 그리드 셋팅 끝***************************************** */


</script>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="mfcSeCdList" value="<c:out value='${mfcSeCdList}' />"/>
<input type="hidden" id="bizrTpCd" value="<c:out value='${bizrTpCd}' />"/>

    <div class="iframe_inner" >
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
			</div>
		
		<section class="secwrap">
		<div class="h4group" >
			<h5 class="tit"  style="font-size: 16px; padding-left: 10px">□ 기준취급수수료 선택</h5>
		</div>
			<div class="srcharea" > <!-- 기준취급수수료 선택 -->
				<div class="row">
					<div class="col">
						<div class="tit" id="mfc_se_cd"></div>  <!-- 생산자 -->
						<div class="box">
							<select id="MFC_SE_CD" style="width: 179px"><select>
						</div>
					</div>
					
					<div class="col">
						<div class="tit" id="ctnr_nm"></div>  <!-- 빈용기명 -->
						<div class="box">
							<select id="CTNR_CD" style="width: 250px"></select>
						</div>
					</div>
					
					<div class="col">
						<div class="tit" id="aplc_dt"></div>  <!-- 적용기간 -->
						<div class="box">
							<select id="APLC_DT" style="width: 250px"></select>
						</div>
					</div>
			
				    <div class="btn" id="UR"></div>
				</div> <!-- end of row -->
			</div>  <!-- end of srcharea -->
			
			<div class="boxarea mt10"> <!--  기준취급수수료 선택 그리드 셋팅 -->
				<div id="gridHolder" style="height: 95px; background: #FFF;"></div>
			</div>	
			
		</section>
	
	<section class="secwrap" style="margin-top: 20px;">
	<div class="h4group" >
			<h5 class="tit"  style="font-size: 16px; padding-left: 10px">□ 개별 취급수수료 설정</h5>
		</div>
			<div class="srcharea" id="divInput"> <!-- 개별 취급수수료 설정 -->
				<div class="row">
					<div class="col">
						<div class="tit" id="aplc_dt2"></div>  <!-- 적용기간 -->
							<div class="box">
							<div class="calendar" >
								<input type="text" id="START_DT" name="from"	 style="width: 180px;" class="i_notnull" > <!--시작날짜  -->
							</div>
							<div class="obj">~</div>
							<div class="calendar" >
								<input type="text" id="END_DT" name="to" style="width: 180px;"	class="i_notnull" >   <!-- 끝날짜 -->
							</div>
						</div>
					</div>
					
					<div class="col">
						<div class="tit" id="whsl_fee"></div>  <!-- 도매취급수수료 -->
						<div class="box">
							<input type="text" id="WHSL_FEE" style="width: 179px" format="number"  maxlength="8" class="i_notnull" />
						</div>
					</div>
					
					<div class="col">
						<div class="tit" id="rtl_fee"></div>  <!-- 소매취급수수료 -->
						<div class="box">
						<input type="text" id="RTL_FEE" style="width: 179px" format="number"  maxlength="8" class="i_notnull" />
						</div>
					</div>
					
				</div> <!-- end of row -->
			</div>  <!-- end of srcharea -->
	&nbsp;&nbsp;※ 도/소매취급수수료는 기준취급수수료 조정가능범위 내에서 입력 가능합니다.</br>
	&nbsp;&nbsp;※ 도매취급수수료와 소매취급수수료의 합계 금액은 취급수수료조정가능범위 이내의 금액으로만 설정 가능합니다.</br>
	&nbsp;&nbsp;※ 적용기간은 익일 이후의 일자로만 설정 가능합니다.
		</section>
	
	
	<section class="secwrap" >
	<div class="h4group" style="margin-top: 5px">
			<h5 class="tit"  style="font-size: 16px; padding-left: 10px">□ 일괄 적용 대상 설정</h5>
		</div>
			<div class="srcharea"> <!-- 일괄 적용 대상 설정 -->
				<div class="row">
					<div class="col">
						<div class="tit" id="mfc_brch_nm"></div>  <!-- 직매장 / 공장 -->
						<div class="box">
							<select id="MFC_BRCH_NM" style="width: 179px"><select>
						</div>
					</div>
					
					<div class="col">
						<div class="tit" id="bizr_tp_cd"></div>  <!-- 거래처 구분 (도매업자 구분) -->
						<div class="box">
							<select id="BIZR_TP_CD" style="width: 179px"></select>
						</div>
					</div>
			
				    <div class="btn" id="CR"></div>
				</div> <!-- end of row -->
			</div>  <!-- end of srcharea -->
		
			<div class="boxarea mt10">
				<div id="gridHolder2" style="height: 560px; background: #FFF;"></div>
			</div>	<!-- 그리드 셋팅 -->
		<div class="h4group" >
			<h5 class="tit"  style="font-size: 15px; color: red; padding-left: 10px"> ※ 적용기간이 겹치는 내역이 존재하는 거래처는 제외하고 적용됩니다. 적용기간이 등록된 내역에 대해서는 변경 기능을 사용하여 주시기 바랍니다</h5>
		</div>
		</section>	<!-- end of secwrap mt30  -->
		<section class="btnwrap mt20"  >
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>

</div>

</body>
</html>