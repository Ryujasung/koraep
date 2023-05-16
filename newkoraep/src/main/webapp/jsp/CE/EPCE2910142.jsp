<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>반환내역서 변경</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS;		//파라미터 데이터
     var ctnr_se;				//빈용기구분  구병 신병
     var ctnr_seList;			//빈용기구분
     var ctnr_nm;				//빈용기
     var initList;  				//그리드 초기값
     var initList2;  				//그리드 초기값
     var rmk_list;     			//소매수수료 적용여부 비고
     var toDay = kora.common.gfn_toDay();  // 현재 시간
     var arr 	= new Array();
	 var rowIndexValue =0;
     $(function() {
    	 INQ_PARAMS =jsonObject($("#INQ_PARAMS").val());	//파라미터 데이터
         ctnr_se			= jsonObject($("#ctnr_se_list").val());		//빈용기구분  구병 신병
         ctnr_seList		= jsonObject($("#ctnr_seList").val());			//빈용기구분
         ctnr_nm			=jsonObject($("#ctnr_nm_list").val()); 		//빈용기
         rmk_list			= jsonObject($("#rmk_list").val());				//비고
         initList  			=jsonObject($("#initList").val());				//그리드 초기값
         initList2 			=jsonObject($("#initList").val());				//그리드 초기값
    	 
    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
    	 //그리드 셋팅
		 fnSetGrid1();
		//text 셋팅
		$('#title_sub').text('<c:out value="${titleSub}" />');						 															//타이틀
		$('#whsl_se_cd').text(parent.fn_text('whsl_se_cd'));															//도매업자 구분
		$('#whsdl').text(parent.fn_text('whsdl'));																			//도매업자
		$('#brch').text(parent.fn_text('brch')); 			 																//지점
		$('#rtrvl_dt').text(parent.fn_text('rtrvl_dt')); 																		//반환일자
		$('#mfc_bizrnm').text(parent.fn_text('rtrvl_trgt')+parent.fn_text('mfc_bizrnm')); 						//반환대상생산자
		$('#mfc_brch_nm').text(parent.fn_text('rtrvl_trgt')+parent.fn_text('mfc_brch_nm')); 				//반환대상지점
		$('#ctnr_se').text(parent.fn_text('ctnr_se'));																		//빈용기 구분
		$('#ctnr_nm').text(parent.fn_text('ctnr_nm'));																	//빈용기명
		$('#rtn_qty').text(parent.fn_text('rtn_qty')); 			 														//반환량(개)
		$('#box_qty').text(parent.fn_text('box_qty')); 																	//상자
		$('#car_no').text(parent.fn_text('car_no')); 																		//차량번호
		
		//div필수값 alt
		 $("#PRPS_CD").attr('alt',parent.fn_text('ctnr_se'));   	
		 $("#CTNR_CD").attr('alt',parent.fn_text('ctnr_nm'));   	
		 $("#RTN_QTY").attr('alt',parent.fn_text('rtn_qty'));															//기준취습수수료
		 $("#CAR_NO").attr('alt',parent.fn_text('car_no'));   															//최저 기준취습수수료    
		 $("#BOX_QTY").attr('alt',parent.fn_text('box_qty'));															//상자
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
		 * 빈용기코드 변경 이벤트
		 ***********************************/
		$("#CTNR_CD").change(function(){
			fn_rmk();			
		});
		
		/************************************
		 * 소매수수료 적용여부 이벤트
		 ***********************************/
		$("#RMK_LIST").change(function(){  
			fn_rmk_list();     
		});
		
		/************************************
		 * 비고 변경 이벤트
		 ***********************************/
		$("#RMK_SELECT").change(function(){  
			fn_rmk_select();     
		});
		
		/************************************
		 * 행 삭제 클릭 이벤트
		 ***********************************/
		$("#btn_del").click(function(){
			fn_del2();
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
  		fn_init();
	});
     
	//초기화
	function fn_init(){
		$("#BOX_QTY").val("");
		$("#RTN_QTY").val("");
		$("#CAR_NO").val("");
		$("#RTN_DT").text(kora.common.formatter.datetime(INQ_PARAMS.PARAMS.RTN_DT_ORI, "yyyy-mm-dd"));	//반환일자
		$("#CAR_NO").text(INQ_PARAMS.PARAMS.CAR_NO);																			//차량번호
		$("#MFC_BIZRNM").text(INQ_PARAMS.PARAMS.MFC_BIZRNM);															//생산자명
		$("#MFC_BRCH_NM").text(INQ_PARAMS.PARAMS.MFC_BRCH_NM);														//생산자지사명
		$("#CUST_BIZRNM").text(INQ_PARAMS.PARAMS.CUST_BIZRNM);															//도매업자명
		$("#CUST_BRCH_NM").text(INQ_PARAMS.PARAMS.CUST_BRCH_NM);													//도매업자지사명
		arr[0] =INQ_PARAMS.PARAMS.WHSDL_BIZRID;				//도매업자 사업자 아이디
		arr[1] =INQ_PARAMS.PARAMS.WHSDL_BIZRNO_ORI;		//도매업자 사업자 번호
		arr[2] =INQ_PARAMS.PARAMS.WHSDL_BRCH_ID;			//도매업자 지사 사업자 아이디
		arr[3] =INQ_PARAMS.PARAMS.WHSDL_BRCH_NO;		//도매업자 지사 번호
		arr[4] =INQ_PARAMS.PARAMS.MFC_BIZRID;					//생산자 사업자 아이디
		arr[5] =INQ_PARAMS.PARAMS.MFC_BIZRNO;				//생산자 사업자 번호
		arr[6] =INQ_PARAMS.PARAMS.MFC_BRCH_ID;				//생산자 지사 사업자 아이디
		arr[7] =INQ_PARAMS.PARAMS.MFC_BRCH_NO;			//생산자 지사 번호
		arr[8] =INQ_PARAMS.PARAMS.RTN_DT_ORI;				//반환일자
		kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");							//빈용기구분
		kora.common.setEtcCmBx2(ctnr_seList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N", "S");						//빈용기구분 코드
		kora.common.setEtcCmBx2(ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');					//빈용기명
		kora.common.setEtcCmBx2(rmk_list, "","", $("#RMK_SELECT"), "ETC_CD", "ETC_CD_NM", "N" ,'S');				//비고
	}
   //빈용기 구분 선택시
   function fn_prps_cd(){
		var url = "/CE/EPCE2910142_19.do" 
		var input ={};
		if( $("#PRPS_CD").val() !=""){
				input["CUST_BIZRID"] 		= arr[0];	//도매업자아이디
				input["CUST_BIZRNO"] 		= arr[1];	//도매업자사업자번호
				input["CUST_BRCH_ID"] 	= arr[2];	//도매업자 지점 아이디
				input["CUST_BRCH_NO"] 	= arr[3];	//도매업자 지점 번호
				input["MFC_BIZRID"] 		= arr[4];	//생산자 아이디
				input["MFC_BIZRNO"] 		= arr[5];	//생산자 사업자번호
				input["MFC_BRCH_ID"] 		= arr[6];	//생산자 직매장/공장 아이디
				input["MFC_BRCH_NO"] 	= arr[7];	//생산자 직매장/공장 번호
				input["RTN_DT"] 				= arr[8] 	//반환일자 
				input["CTNR_SE"] 			= $("#CTNR_SE").val();		//빈용기명 구분 구/신
				input["PRPS_CD"] 			= $("#PRPS_CD").val();		//빈용기명  유흥/가정/공병/직접 
		       	ajaxPost(url, input, function(rtnData) {
		    			if ("" != rtnData && null != rtnData) {   
		    				 ctnr_nm = rtnData.ctnr_nm
		    				 kora.common.setEtcCmBx2(rtnData.ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S'); //빈용기	
		    			}else{
							alertMsg("error");
		    			}
		    	},false);
		}else{
				ctnr_nm=[];
				kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S'); //빈용기	
		}
		fn_rmk()//비고 부분 초기화
   	}
//소매수수료 적용여부 ㅇㄷ----------------------------------------------------------------------------------------------------
	//소매수수료 적용여부
	function fn_rmk_list(){
 		var ck = $("input[type=radio][name=select_rtl]:checked").val();	//소매수수료 라디오 
 		if(ck !="ext"){											//적용인경우
	  		$("#RMK_SELECT").prop("disabled",true);	//비고 선택부분 비활성화
	  		$("#RMK").prop("disabled",true);				//비고 입력부분 비활성화
	  		$("#RMK_SELECT").val("")						//비고 선택부분 초기화
	  		$("#RMK").val("");									//비고 입력부분 초기화
 		}else{														//제외인경우
	  		if($("#PRPS_CD").val() !="1"){					//유흥인데  소매수수료 제외를 누를경우
	      		 $("#select_rtl1").prop('checked', true);
	      		 alertMsg("빈용기 구분이 가정용 일경우에만 적용됩니다.");
	      		 return;
	      	}
 		 	$("#RMK_SELECT").removeAttr("disabled");//비고 선택부분 활성화	
 		}
	}
	//비고 선택 변경
	function fn_rmk_select(){
	  	if($("#RMK_SELECT").val() =="A" || $("#RMK_SELECT").val() =="B"){ 	//소비자 직접반화 ,무인회수기인경우
	  		 $("#RMK").prop("disabled",true);											//비고 입력란 비활성화
	  		 $("#RMK").val($("#RMK_SELECT option:selected").text());				//비고 선택부분 텍스트 입력
	  	}else if($("#RMK_SELECT").val() =="C"){ 										//직접입력인경우
	  		 $("#RMK").removeAttr("disabled");											//비고 입력란 활성화
	  		 $("#RMK").val("");																//비고 입력란 초기화
	  	}else if($("#RMK_SELECT").val() ==""){											//선택일경우
	  		$("#RMK").prop("disabled",true);  											//비고 입력란 비활성화
	  		$("#RMK").val("");																	//초기화
	  	}  
  	}
	//비고부분 초기화
	function fn_rmk(){
		$("#RMK").val("");									//비고입력부분
  		$("#RMK_SELECT").val("");						//비고선택부분
	    $("#select_rtl1").prop('checked', true);		//소매수수료여부 적용
		$("#RMK_SELECT").prop("disabled",true);	//비고선택부분 비활성화
  		$("#RMK").prop("disabled",true);				//비고입력부분 비활성화
	}
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
	 
	 //행등록
	function fn_reg2(){
	
		if(!kora.common.cfrmDivChkValid("divInput")) {
			return;
		}else if( $("#BIZR_TP_CD").val()      !=""   && $("#ENP_NM").val()     != ""   && $("#BRCH_NM").val()  != ""  ) {
			$("#BIZR_TP_CD").prop("disabled",true);
			$("#ENP_NM").prop("disabled",true);
			$("#BRCH_NM").prop("disabled",true);
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
		}else if(!kora.common.cfrmDivChkValid("divInput")) {
			return;
		}
		var item = insRow("M");
		
		// 해당 데이터의 이전 수정내역을 삭제
		gridRoot.removeChangedData(gridRoot.getItemAt(idx));
		//해당 데이터 수정
		gridRoot.setItemAt(item, idx);
		//dataGrid.setSelectedIndex(-1);			
	}
	 
	//행삭제
	function fn_del2(){
		var idx = dataGrid.getSelectedIndex();

		if(idx < 0) {
			alertMsg("삭제할 행을 선택하시기 바랍니다.");
			return;
		}
		gridRoot.removeItemAt(idx);
	}
	 
	//행변경 및 행추가시 그리드 셋팅
	insRow = function(gbn) {
		var input = {};
		var ctnrCd = $("#CTNR_CD").val();
		var MFC_BIZRID 	 	=  arr[4];	//생산자 아이디
		var MFC_BIZRNO 	=	arr[5];	//생산자 사업자번호
		var MFC_BRCH_ID 	=  arr[6];	//생산자 지사 아이디
		var MFC_BRCH_NO =	arr[7];	//생산자 지사 번호
		var collection = gridRoot.getCollection();
		var rtl_fee_select = $("input[type=radio][name=select_rtl]:checked").val();	//수수료적용여부  라디오체크여부
		for(var i=0;i<collection.getLength(); i++){
	 		var tmpData = gridRoot.getItemAt(i);
	 		if(tmpData.CTNR_CD == ctnrCd ){
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
	    
		for(var i=0; i<ctnr_nm.length; i++){
			
			if(ctnr_nm[i].CTNR_CD == ctnrCd) {
				if(ctnrCd.substr(3,2) == "00"){
			    	input["STANDARD_NM"] 					= 	"표준용기";	
			    }else{
			    	input["STANDARD_NM"] 					= 	"비표준용기";	
			    }
			 	 if($("#BOX_QTY").val() !=0 ){
			    	input["BOX_QTY"] 					= $("#BOX_QTY").val();									//상자
			    }else{
			    	input["BOX_QTY"] 					= "0"															//상자
			    }
			    input["MFC_BIZRNM"] 				= INQ_PARAMS.PARAMS.MFC_BIZRNM	//생산자명
			    input["MFC_BRCH_NM"] 			= INQ_PARAMS.PARAMS.MFC_BRCH_NM // 직매장/공장
			    input["CTNR_SE"] 					= $("#CTNR_SE").val();  	 								//빈용기명 구분 구/신
			    input["PRPS_NM"] 					= $("#PRPS_CD option:selected").text();   			//빈용기명 구분 유흥/가정
			    input["PRPS_CD"] 					= $("#PRPS_CD").val();  						 			//빈용기명 구분 유흥/가정 코드
			    input["CTNR_NM"] 					= $("#CTNR_CD option:selected").text(); 			//빈용기명
			    input["CTNR_CD"] 					= $("#CTNR_CD").val(); 									//빈용기 코드
			    input["CPCT_NM"] 					= ctnr_nm[i].CPCT_NM;									//용량ml
			    input["RTN_QTY"] 					= $("#RTN_QTY").val();									//반환량	
			    input["RTN_GTN_UTPC"]      		=	ctnr_nm[i].STD_DPS;									//기준보증금 
			    input["RTN_GTN"] 					=  input["RTN_QTY"] * ctnr_nm[i].STD_DPS; 		//빈용기보증금(원) - 합계
			    input["RTN_WHSL_FEE_UTPC"]	=	ctnr_nm[i].WHSL_FEE;								//도매수수료
			    input["RTN_WHSL_FEE"]    		=	input["RTN_QTY"] *ctnr_nm[i].WHSL_FEE;		//도매수수료 합계
			    input["RTN_WHSL_FEE_STAX"]	=	kora.common.truncate(parseInt(input["RTN_WHSL_FEE"],10)/10);	//도매 부과세
				//소매수수료 적용여부 ㅇㄷ----------------------------------------------------------------------------------------
			    if($("#PRPS_CD").val() =="1"){		//빈용기구분이 가정일 경우에만 적용
					    if(rtl_fee_select =="ext"){	//소매수수료적영여부 제외시
				    		if($("#RMK_SELECT").val() =="" ){
				    			alertMsg("소매수수료 제외 선택시 ,비고에 사유를 입력하셔야 합니다.");
				    			return;
				    		}else if ($("#RMK").val() ==""){
				    			alertMsg("소매수수료 제외 선택시 ,비고에 사유를 입력하셔야 합니다.");
				    			return;
				    		}
					    	input["RTN_RTL_FEE_UTPC"]	=	0; 	//소매수수료    
							input["RTN_RTL_FEE"]      	=	0;		//소매수수료 합계	
							if($("#RMK_SELECT").val() !="C"){	//비고선택부분이  직접입력이 아닐경우
								input["RMK"] 						=	$("#RMK_SELECT").val()+"-"+$("#RMK_SELECT option:selected").text();	//비고 텍스트값
								input["RMK_C"] 					=	$("#RMK_SELECT option:selected").text();											//비고 텍스트값(view용)
							}else{//비고선택이 직접입력일경우
								input["RMK"] 						=	$("#RMK_SELECT").val()+"-"+$("#RMK").val();	//비고 텍스트값
								input["RMK_C"] 					=	$("#RMK").val();										//비고 텍스트값(view용)
							}
					    }else{//소매수수료 적용 시
					    	  input["RTN_RTL_FEE_UTPC"]		=	ctnr_nm[i].RTL_FEE;										//소매수수료
							  input["RTN_RTL_FEE"]      		=	input["RTN_QTY"] * ctnr_nm[i].RTL_FEE;			//소매수수료 합계	
					    }
		    	}else{//빈용기 구분이 유흥일 경우
			    	  input["RTN_RTL_FEE_UTPC"]		=	ctnr_nm[i].RTL_FEE;										//소매수수료
					  input["RTN_RTL_FEE"]      		=	input["RTN_QTY"] * ctnr_nm[i].RTL_FEE;			//소매수수료 합계	
		   	 	}
			    
			  	//소매부과세를 도매부과세로
			    input["RTN_WHSL_FEE_STAX"]	=	kora.common.truncate( (parseInt(input["RTN_WHSL_FEE"],10) + parseInt(input["RTN_RTL_FEE"],10)) / 10 ); //도매 부과세
			    
			    
				//-------------------------------------------------------------------------------------------------------------
			    input["CAR_NO"] 						=	$("#CAR_NO").val();									//차량번호
			    input["AMT_TOT"] 					=	input["RTN_GTN"]+ input["RTN_WHSL_FEE"] + input["RTN_WHSL_FEE_STAX"]+ input["RTN_RTL_FEE"]; //총합계
			    input["CUST_BIZRID"] 				= arr[0];	//도매업자아이디
			    input["CUST_BIZRNO"] 				= arr[1];	//도매업자사업자번호
			    input["CUST_BRCH_ID"] 			= arr[2];	//도매업자 지점 아이디
			    input["CUST_BRCH_NO"] 			= arr[3];	//도매업자 지점 번호
			    input["MFC_BIZRID"] 				= arr[4];	//생산자 아이디
			    input["MFC_BIZRNO"] 				= arr[5];	//생산자 사업자번호
			    input["MFC_BRCH_ID"] 				= arr[6];	//생산자 직매장/공장 아이디
			    input["MFC_BRCH_NO"] 			= arr[7];	//생산자 직매장/공장 번호
			    input["RTN_DT"] 						= arr[8] 	//반환일자 
			    input["SYS_SE"]						= 'W';	//시스템구분	
			    input["RTN_STAT_CD"]				= 'RG';	//반환상태코드
			    input["FH_RTN_QTY_TOT"]			= '0';		//가정용 반환량 합계
			    input["FB_RTN_QTY_TOT"]			= '0';		//영업용 반환량 합계
			    input["DRCT_RTN_QTY_TOT"]		= '0';		//직접    반환량 합계
			    input["BIZR_TP_CD"] 				= INQ_PARAMS.PARAMS.BIZR_TP_CD_ORI  	// 도매업자 구분 
			    input["RTN_DOC_NO"]				= initList[0].RTN_DOC_NO	    							// 반환문서번호
			    input["REG_PRSN_ID"]				= initList[0].REG_PRSN_ID	  								// 등록자 
			    input["REG_DTTM"]					= initList[0].REG_DTTM	  	  								// 등록일시 최조
			    input["GBN"]                        = INQ_PARAMS.PARAMS.GBN      // 도매업자 구분
			   break;
			}
				
		}

		return input;
	};	
	function fn_del_chk(){
		confirm("반환 내역이 모두 삭제되었습니다. 계속 진행하시겠습니까? 삭제 처리된 내역은 복원되지 않으며 재등록 하셔야 합니다.","fn_del");
	}
	function fn_del(){
		var url ="/CE/EPCE2910142_04.do"; 
		var input ={}
		input["RTN_DOC_NO"]				=  initList[0].RTN_DOC_NO	 // 반환문서번호
		ajaxPost(url, input, function(rtnData){
				if(rtnData.RSLT_CD == "0000"){
					alertMsg(rtnData.RSLT_MSG);
					fn_cnl2();
				}else{
					alertMsg(rtnData.RSLT_MSG);
				}
		},false);  
	}
	
	//등록
	function fn_reg(){
		
		//var data = {"list": ""};
		//var row = new Array();
		//var url = "/CE/EPCE2910142_21.do";
		
		var changedData = gridRoot.getChangedData();
		if(0 != changedData.length){
			
			var collection = gridRoot.getCollection();
			if(collection.getLength()==0){
				fn_del_chk();	//행 데이터 전부 삭제 할경우 데이터 삭제
			}else{//변경시 
				
				confirm('저장하시겠습니까?', 'fn_reg_exec');
	
			}	
					
		}else{// 변경된 자료 없을경우
			alertMsg("변경된 자료가 없습니다.");
		}
	}
	
	function fn_reg_exec(){
		
		var data = {"list": ""};
		var row = new Array();
		var url = "/CE/EPCE2910142_21.do"; 
		var collection = gridRoot.getCollection();
		
		for(var i=0;i<collection.getLength(); i++){
	 		var tmpData = gridRoot.getItemAt(i);
	 		row.push(tmpData);//행 데이터 넣기
	 	}
		data["list"] = JSON.stringify(row);
		ajaxPost(url, data, function(rtnData){
			if(rtnData != null && rtnData != ""){
					if(rtnData.RSLT_CD =="A003"){ // 중복일경우
						alertMsg(rtnData.RSLT_MSG);
					}else if(rtnData.RSLT_CD =="0000"){
						alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
					} 
			}else{
					alertMsg("error");
			}
		},false); 
		
	}
	
	  //취소버튼 이전화면으로  반환상세페이지로 이동
    function fn_cnl(){
   	 kora.common.goPageB('', INQ_PARAMS);
    }
	  
    //모든 데이터 삭제 할경우  반환관리 화면으로 이동
    function fn_cnl2(){
   	 kora.common.goPageB('/CE/EPCE2910101.do', INQ_PARAMS);
    }
	
	//선택한 행 입력창에 값 넣기
	function fn_rowToInput (rowIndex){
		var item = gridRoot.getItemAt(rowIndex);
		fn_dataSet(item);
		$("#CTNR_SE").val( item["CTNR_SE"]).prop("selected", true);   							//빈용기명 구분 구병 /신병
		$("#PRPS_CD").val(	item["PRPS_CD"]).prop("selected", true);   						//빈용기명 구분 유흥/가정 / 직접
		$("#CTNR_CD").val(	item["CTNR_CD"]).prop("selected", true);    						//빈용기명
		$("#RTN_QTY").val(item["RTN_QTY"]);
		$("#BOX_QTY")  .val(item["BOX_QTY"]);
		$("#CAR_NO")  .val(item["CAR_NO"]); 
		
		//소매수수료 적용여부 ㅇㄷ----------
		if(item["RMK"] !=undefined){//비고가 있을경우 
			if(item["RMK"].substring(0,1) =="C"){  	//비고중 직접입력일경우
				$("#RMK").removeAttr("disabled");  //input창 활성화
			}else{
				$("#RMK").prop("disabled",true);		//비고입력창 비활성화
			}
			$("#select_rtl2").prop('checked', true); 					//소매수수료적용여부 제외로
	    	$("#RMK_SELECT").removeAttr("disabled");			//비고 선택부분 활성화
			$("#RMK_SELECT").val(item["RMK"].substring(0,1)); //비고 원본(코드+글자) 비고 선택부분 코드
			$("#RMK").val(item["RMK_C"]);  							//비고 글자만
		}else{									//비고가 없을경우
			$("#select_rtl1").prop('checked', true); 		//소매수수료적용여부 적용
	    	$("#RMK_SELECT").prop("disabled",true);	//비고선택부분 비활성화
	    	$("#RMK").prop("disabled",true);				//비고입력창 비활성화
			$("#RMK_SELECT").val(""); 						//비고선택부분 선택으로
			$("#RMK").val("");  								//비고 초기화  
		}
		//-------------------------------------------
	};
	
	function fn_dataSet(item){
		  var input	={};
		  var url 	 	= "/CE/EPCE2910142_192.do"; 
		   input["CUST_BIZRID"] 		= item["CUST_BIZRID"];			//도매업자아이디
		   input["CUST_BIZRNO"] 		= item["CUST_BIZRNO"];		//도매업자사업자번호
		   input["CUST_BRCH_ID"] 		= item["CUST_BRCH_ID"];		//도매업자 지점 아이디
		   input["CUST_BRCH_NO"] 	= item["CUST_BRCH_NO"];	//도매업자 지점 번호
		   input["MFC_BIZRID"] 			= item["MFC_BIZRID"];			//생산자 아이디
		   input["MFC_BIZRNO"] 		= item["MFC_BIZRNO"];		//생산자 사업자번호
		   input["MFC_BRCH_ID"] 		= item["MFC_BRCH_ID"];		//생산자 직매장/공장 아이디
		   input["MFC_BRCH_NO"] 	= item["MFC_BRCH_NO"];		//생산자 직매장/공장 번호
		   input["CTNR_SE"] 				= item["CTNR_SE"];				//빈용기명 구분 구/신
		   input["PRPS_CD"] 				= item["PRPS_CD"];				//빈용기명  유흥/가정/공병/직접 
		   input["RTN_DT"] 				= item["RTN_DT"];				//반환일자 
       	   ajaxPost(url, input, function(rtnData) {
    				if ("" != rtnData && null != rtnData) {   
						 ctnr_nm	 = [];
    					 ctnr_nm = rtnData.ctnr_nm
    					 kora.common.setEtcCmBx2(ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');					//빈용기명
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
			layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" horizontalScrollPolicy="on" sortableColumns="true" draggableColumns="true"  headerHeight="35" textAlign="center">');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridColumn dataField="index" 				 headerText="'+ parent.fn_text('sn')+ '" itemRenderer="IndexNoItem" textAlign="center" width="50"  />');		//순번
			layoutStr.push('			<DataGridColumn dataField="RTN_DT"			 headerText="'+ parent.fn_text('rtrvl_dt')+ '"  textAlign="center" width="100"   formatter="{datefmt2}"/>'); 		//반환일자
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM" 	 headerText="'+ parent.fn_text('mfc_bizrnm')+ '"  width="100" />');															//생산자
			layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_NM" headerText="'+ parent.fn_text('mfc_brch_nm')+ '"  width="100"  />');								//직매장/공장
			layoutStr.push('			<DataGridColumn dataField="PRPS_NM"  		 headerText="'+ parent.fn_text('prps_cd')+ '" width="100" />');																	//용도(유흥용/가정용)
			layoutStr.push('            <DataGridColumn dataField="STANDARD_NM"     headerText="용기구분"        width="100" textAlign="center"  />');
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM"  		 headerText="'+ parent.fn_text('ctnr_nm')+ '" textAlign="left" width="250" />');																	//빈용기명
			layoutStr.push('			<DataGridColumn dataField="CTNR_CD" 		 headerText="'+ parent.fn_text('cd')+ '" width="90" />');																			//코드
			layoutStr.push('			<DataGridColumn dataField="CPCT_NM"  		 headerText="'+ parent.fn_text('cpct_cd')+'(ml)'+'" width="120"  textAlign="center"/>');									//용량(ml)
			layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('qty')+ '">');																																				//수량
			layoutStr.push('				<DataGridColumn dataField="BOX_QTY" id="num1"  headerText="'+ parent.fn_text('box_qty')+ '" width="50" formatter="{numfmt}" textAlign="right" />');	//상자
			layoutStr.push('				<DataGridColumn dataField="RTN_QTY" 	id="num2"  headerText="'+ parent.fn_text('btl')+ '" width="70" formatter="{numfmt}" textAlign="right" />');			//병
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('ctnr_nm')+ parent.fn_text('dps')+'">');																												//빈용기보증금(원)																		
			layoutStr.push('				<DataGridColumn dataField="RTN_GTN_UTPC"   headerText="'+ parent.fn_text('utpc')+ '" width="80" formatter="{numfmt}" textAlign="right" />');				//단가
			layoutStr.push('				<DataGridColumn dataField="RTN_GTN" id="num3"  headerText="'+ parent.fn_text('amt')+ '" width="100" formatter="{numfmt}" textAlign="right" />');		//금액
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('ctnr_nm')+ parent.fn_text('std_fee')+'">');																																//빈용기 취급수수료(원
			layoutStr.push('				<DataGridColumn dataField="RTN_WHSL_FEE_UTPC"   headerText="'+ parent.fn_text('utpc')+ '" width="80" formatter="{numfmt}" textAlign="right" />');							//단가
			layoutStr.push('				<DataGridColumn dataField="RTN_WHSL_FEE" id="num4"  headerText="'+ parent.fn_text('whsl_fee')+ '" width="150" formatter="{numfmt1}" textAlign="right" />'); 			//도매수수료
			layoutStr.push('				<DataGridColumn dataField="RTN_RTL_FEE_UTPC"   headerText="'+ parent.fn_text('utpc')+ '" width="80" formatter="{numfmt}" textAlign="right" />');							//단가
			layoutStr.push('				<DataGridColumn dataField="RTN_RTL_FEE" id="num5"  headerText="'+ parent.fn_text('rtl_fee')+ '" width="150" formatter="{numfmt1}" textAlign="right" />');				//소매수수료
			layoutStr.push('				<DataGridColumn dataField="RTN_WHSL_FEE_STAX"  id="num7" headerText="'+ parent.fn_text('stax')+ '" width="150" formatter="{numfmt}" textAlign="right" />');	//부가세
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumn dataField="AMT_TOT" id="num6"  headerText="'+ parent.fn_text('amt_tot')+ '" width="70" formatter="{numfmt}" textAlign="right" />');							//금액합계(원)
			layoutStr.push('			<DataGridColumn dataField="RMK_C"		headerText="'+ parent.fn_text('rmk')+ '"			width="150" 	textAlign="left"	 />');															//비고
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM_CD"  	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_NM_CD"	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="CAR_NO"    				visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="CUST_BIZRID"  		visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNO"		visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="CUST_BRCH_ID"    	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="CUST_BRCH_NO"    visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRID"  		visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNO"		visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_ID"    	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_NO"    	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="PRPS_CD"    			visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="BIZR_TP_CD"    		visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="RTN_DOC_NO"    	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="RMK"    				visible="false" />');
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
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	//상자
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	//병
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	//금액
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');	//도매수수료
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt1}" textAlign="right"/>');	//소매수수료
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');	//부가세
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');	//합계
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
		gridApp.setData(initList2);
		
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
width: 48%;
} 
.srcharea .row .col .tit{
width: 120px;
}
.srcharea .row .box{
width: 68%
}


</style>

</head>
<body>

    <div class="iframe_inner" id="testee" >
                 
             
    		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="ctnr_se_list" value="<c:out value='${ctnr_se}' />" />
			<input type="hidden" id="ctnr_seList" value="<c:out value='${ctnr_seList}' />" />
			<input type="hidden" id="ctnr_nm_list" value="<c:out value='${ctnr_nm}' />" />
    		<input type="hidden" id="initList" value="<c:out value='${initList}' />" />
    		<input type="hidden" id="rmk_list" value="<c:out value='${rmk_list}' />" />
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
				<div class="btn" style="float:right" id="UR">
				<!--btn_dwnd  -->
				<!--btn_excel  -->
				</div>
			</div>
			<section class="secwrap">
						<div class="write_area">
							<div class="write_tbl">
								<table>
									<colgroup>
										<col style="width: 20%;">
										<col style="width: 30%;">
										<col style="width: 20%;">
										<col style="width: 30%;">
									</colgroup>
									<tbody>
										<tr>
											<th class="bd_l"  id="whsdl"></th>			<!-- 도매업자 -->
											<td>
												<div class="row">
													<div class="txtbox" id="CUST_BIZRNM"></div>
												</div>
											</td>
											<th class="bd_l" id="brch"></th> <!-- 지점 -->
											<td>
												<div class="row">
													<div class="txtbox" id="CUST_BRCH_NM"></div>
												</div>
											</td>
										</tr>
										<tr>
											<th class="bd_l"  id="rtrvl_dt"></th>			<!-- 반환일자 -->
											<td>
												<div class="row">
													<div class="txtbox" id="RTN_DT"></div>
												</div>
											</td>
											<th class="bd_l" id="car_no"></th> <!-- 차량번호 -->
											<td>
												<div class="row">
													<div class="txtbox" id="CAR_NO"></div>
												</div>
											</td>
										</tr>
										<tr>
											<th class="bd_l"  id="mfc_bizrnm"></th>			<!-- 반환대산 생산자 -->
											<td>
												<div class="row">
													<div class="txtbox" id="MFC_BIZRNM"></div>
												</div>
											</td>
											<th class="bd_l" id="mfc_brch_nm"></th> <!-- 반환대상 직매장/공장 -->
											<td>
												<div class="row">
													<div class="txtbox" id="MFC_BRCH_NM"></div>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</section>
					
		<section class="secwrap" >
		
				<div class="srcharea" style="margin-top: 10px" id="divInput" > 
					
					<div class="row">
						<div class="col">
							<div class="tit" id="ctnr_se"></div>  <!-- 빈용기구분 -->
							<div class="box">
								<select id="CTNR_SE" style="width: 80px" class="i_notnull" ></select> <!-- 구병/신병 -->
								<select id="PRPS_CD" style="width: 150px" class="i_notnull" ></select><!-- 유흥 / 가정 / 직접 -->
							</div>
						</div>
						
						<div class="col" >
							<div class="tit" id="ctnr_nm"></div>  <!-- 빈용기명 -->
							<div class="box" style="width: 65%" >
								<select id="CTNR_CD"  class="i_notnull" ></select>
							</div>
						</div>
					</div> <!-- end of row -->
					<div class="row">
						<div class="col">
							<div class="tit" >소매수수료 적용여부</div>  
							<div class="box" id="RMK_LIST">   
								<label class="rdo"><input type="radio" id="select_rtl1" name="select_rtl" value="aplc"  checked="checked"><span id="">적용</span></label>
								<label class="rdo"><input type="radio" id="select_rtl2" name="select_rtl" value="ext"  ><span id="">제외</span></label>
							</div>
						</div>
						<div class="col" style="">
							<div class="tit" >비고</div>  <!-- 비고 -->
							<div class="box" >
									<select id="RMK_SELECT" style="width: 38%"  disabled="disabled"></select>
									<input type="text"  id="RMK" style="width: 59%" maxByteLength="30"  disabled="disabled" />
							</div>
						</div>
					</div> <!-- end of row -->
					<div class="row">
						<div class="col">
							<div class="tit" id="box_qty"></div>  <!-- 상자 -->
							<div class="box">
								<input type="text"  id="BOX_QTY" style="width: 100%;max-width: 524px;" format="number" maxlength="8"/>
							</div>
						</div>
						<div class="col">
							<div class="tit" id="rtn_qty"></div>  <!-- 반환량(개) -->
							<div class="box">
								  <input type="text"  id="RTN_QTY" style="width: 100%;max-width: 524px;"  class="i_notnull"  format="number" maxlength="8"/>
							</div>
						</div>
					</div> <!-- end of row -->
					<div class="singleRow" style="float:right ">
						<div class="btn" id="CR"></div>
					</div>
					
				</div>  <!-- end of srcharea -->
			</section>
			<!-- <section class="btnwrap mt20"  >
			<div style="float:right" id="CR"></div>
			</section> -->
			<div class="boxarea mt10">
				<div id="gridHolder" style="height: 560px; background: #FFF;"></div>
			</div>	<!-- 그리드 셋팅 -->
			  <div class="h4group" >
				<h5 class="tit"  style="font-size: 16px;">
					&nbsp;&nbsp;※ 반환 대상 직매장/공장 추가는 [정보관리 > 직매장별거래처관리] 메뉴에서 거래 생산자별 직매장을 추가하셔야  반환내역서 등록이 가능합니다.<br/>
	                &nbsp;&nbsp;※ 자료를 입력 후 행추가 버튼을 클릭하여 저장할 자료를 여러건 입력한 후 저장 버튼을 클릭하여 여러건을 동시에 저장 합니다
				</h5>
			</div>
		<section class="btnwrap mt10" >
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
	
</div>

</body>
</html>