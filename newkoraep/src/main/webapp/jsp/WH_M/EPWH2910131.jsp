<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>반환내역서 등록</title>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=1100, user-scalable=yes">
<meta name="description" content="사이트설명">
<meta name="keywords" content="사이트검색키워드">
<meta name="author" content="Newriver">
<meta property="og:title" content="공유제목">
<meta property="og:description" content="공유설명">
<meta property="og:image" content="공유이미지 800x400">

<%@include file="/jsp/include/common_page_m.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS;//파라미터 데이터
     var ctnr_se;//빈용기구분  구병 신병 
	 var rmk_list;//소매수수료 적용여부 비고
	 var rowIndexValue = 0;
     //var mfc_bizrnmList = [];//생산자
     //var ctnr_seList = [];//빈용기구분
     var ctnr_nm = [];//빈용기

	 var flag_DT = "";
	 var whsl_chk = {};  
	 
     $(function() {
    	 
    	INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());//파라미터 데이터
    	ctnr_se = jsonObject($("#ctnr_se_list").val());//빈용기 구분
    	rmk_list = jsonObject($("#rmk_list").val());//비고	
    	rtc_dt_list	= jsonObject($("#rtc_dt_list").val());//등록일자제한설정	

    	//그리드 셋팅
		fnSetGrid1();

  	  	/*모바일용 날짜셋팅*/
 		$('#RTN_DT').YJdatepicker({
 			initDate : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
 		});
		
 		//text 셋팅
		$('.box_wrap .boxed .sort').each(function(){
			if($(this).attr('id') != ''){
				$(this).html(fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt')) ) );
			}
		});

		//div필수값 alt
		 $("#RTN_DT").attr('alt',fn_text('rtrvl_dt'));   
		 $("#MFC_BIZRNM").attr('alt',fn_text('rtrvl_trgt')+fn_text('mfc_bizrnm'));
		 $("#MFC_BRCH_NM").attr('alt', fn_text('rtrvl_trgt_brch'));
		 $("#PRPS_CD").attr('alt',fn_text('ctnr_se'));   	
		 $("#CTNR_CD").attr('alt',fn_text('ctnr_nm'));   	
		 $("#RTN_QTY").attr('alt',fn_text('rtn_qty'));
		 $("#BOX_QTY").attr('alt',fn_text('box_qty'));
		 $("#CAR_NO").attr('alt',fn_text('car_no'));

		/************************************
		 * 반환대상생산자 구분 변경 이벤트
		 ***********************************/
		$("#MFC_BIZRNM").change(function(){
			fn_mfc_bizrnm();
		});
		/************************************
		 * 반환대상 직매장/공장  구분 변경 이벤트
		 ***********************************/
		$("#MFC_BRCH_NM").change(function(){
			fn_mfc_brch_nm();
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
		 * 시작날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		$("#RTN_DT").change(function(){
			if($("#RTN_DT").val() !=flag_DT){ //클릭시 날짜 변경 할경우   기존날짜랑 현재날짜랑 다를 경우  데이터 초기화
				flag_DT = $("#RTN_DT").val();  //변경시 날짜 
				//kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'S'); 	//반환대상 생산자
				//kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");										//빈용기구분
				kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'S');					//반환대상 직매장/공장
				//kora.common.setEtcCmBx2(ctnr_seList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S'); 							//빈용기구분 코드
				kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');		
			} 
		});
		
		/************************************
		 * 행 삭제 클릭 이벤트
		 ***********************************/
		$("#btn_del").click(function(){
			fn_del();
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
		 * 저장 클릭 이벤트
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
    	
    	if('${sBizrTpCd}' == 'W2'){ //공병상
    		$('#RMK_SELECT').val('C'); //직접입력
    		$('#RMK').val('공병상');
    		$("#select_rtl2").prop('checked', true); //소매수수료적용여부 제외로

    		$("#RMK_SELECT").removeAttr("disabled");//비고 선택부분 활성화
    		$("#RMK").removeAttr("disabled");//비고 선택부분 활성화
			
    		$("#w2Hide_1").hide();
    		$("#w2Hide_2").hide();
    	} 
    	
	});
     
     //초기화
     function fn_init(){

		kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");//빈용기구분
		kora.common.setEtcCmBx2(rmk_list, "","", $("#RMK_SELECT"), "ETC_CD", "ETC_CD_NM", "N" ,'S');//비고
		kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'S');//반환대상 직매장/공장
		kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');//빈용기명	    
		
		flag_DT = $("#RTN_DT").val(); 
		
		$("#BOX_QTY").val("");
		$("#RTN_QTY").val("");
		$("#CAR_NO").val("");
		
		if('${sBizrTpCd}' != 'W2'){ //공병상
	    	$("#RMK").val("");
			$("#select_rtl1").prop("checked", true)
			$("#RMK_SELECT").prop("disabled",true);
	    	$("#RMK").prop("disabled",true);
		}
		
		fn_whsl_se_cd();
     }
     
   	//도매업자구분 변경시 - 자동수행
    function fn_whsl_se_cd(){
   		
    	var url = "/WH/EPWH2910131_19.do" 
		var input ={};

        ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {   
				//ctnr_seList = rtnData.ctnr_seList;
				kora.common.setEtcCmBx2(rtnData.ctnr_seList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');//빈용기구분 코드
				
				fn_brch_nm(); //자동수행
				
			}else{
				alert("error");
			}
       	},false);
    	
    }

    //지점 변경시 - 자동수행
   	function fn_brch_nm(){
 		var url = "/WH/EPWH2910131_193.do" 
		var input ={};
 		
		input["STAT_CD"] = 'Y'
       	ajaxPost(url, input, function(rtnData) {
			if ("" != rtnData && null != rtnData) {   
				 //mfc_bizrnmList = rtnData.mfc_bizrnmList;
				 kora.common.setEtcCmBx2(rtnData.mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'S');//반환대상 생산자
			}else{
				 alert("error");
			}
    	},false);
  	} 
   	
   	//반환대상생산자 변경시
   	function fn_mfc_bizrnm(){
  		var url = "/WH/EPWH2910131_194.do" 
		var input ={};
  		if( $("#MFC_BIZRNM").val() !=""){
	   		var arr3 = $("#MFC_BIZRNM").val().split(";");
			
	   		input["MFC_BIZRID"] = arr3[0];
			input["MFC_BIZRNO"] = arr3[1];
            input["BIZR_TP_CD"] = arr3[2];
			input["STAT_CD"] = "Y";
			
	       	ajaxPost(url, input, function(rtnData) {
	    		if ("" != rtnData && null != rtnData) {   
	    			kora.common.setEtcCmBx2(rtnData.brch_dtssList, "","", $("#MFC_BRCH_NM"), "MFC_BRCH_ID_NO", "MFC_BRCH_NM", "N" ,'S');//반환대상 직매장/공장		
	    		}else{
	    			alert("error");
	    		}
	    	});
  		}else{  
			kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "MFC_BRCH_ID_NO", "MFC_BRCH_NM", "N" ,'S');//반환대상 직매장/공장		
  		}
  		
        kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");//빈용기구분
        kora.common.setEtcCmBx2([], "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');//빈용기구분 코드
        kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');//빈용기명
		fn_rmk()//비고 부분 초기화
   	}
   	
   	//직매장/공장 변경시
   	function fn_mfc_brch_nm(){
   	    
        var url = "/WH/EPWH2910131_198.do" 
        var input ={};

        if( $("#MFC_BRCH_NM").val() !=""){
            var arr1 = new Array();
            arr1 = $("#MFC_BIZRNM").val().split(";");
            var arr2 = new Array();
            arr2 = $("#MFC_BRCH_NM").val().split(";");
             
            input["MFC_BIZRID"]  = arr1[0];
            input["MFC_BIZRNO"]  = arr1[1];
            input["MFC_BRCH_ID"] = arr2[0];
            input["MFC_BRCH_NO"] = arr2[1];

            ajaxPost(url, input, function(rtnData) {
                if ("" != rtnData && null != rtnData) {
                    kora.common.setEtcCmBx2(rtnData.ctnr_seList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');    //빈용기구분 코드
                    bizrTpCd = rtnData.bizr_tp_cd;
                }
                else{
                    alertMsg("error");
                }
            });
        }
        else {
            kora.common.setEtcCmBx2([], "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');    //빈용기구분 코드
        }

        kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');//빈용기명
        fn_rmk()//비고 부분 초기화
   	    
		//kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");//빈용기구분
	    //kora.common.setEtcCmBx2(ctnr_seList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');//빈용기구분 코드
	    //kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');//빈용기명
	    
	    //빈용기 조회
	    fn_prps_cd();
	    
	    fn_rmk();//비고 부분 초기화
   	}
   	
	//빈용기 구분 선택시
	function fn_prps_cd(){
		if($("#MFC_BRCH_NM").val() =="") {
		   alert("반환대상 직매장/공장을 선택해주세요");
		   return;
	   	}
		var url = "/WH/EPWH2910131_195.do" 
		var input = {};
		if( $("#PRPS_CD").val() !=""){
			ctnr_nm=[];
			var arr3 = $("#MFC_BIZRNM").val().split(";");
			var arr4 = $("#MFC_BRCH_NM").val().split(";"); 
			
			input["MFC_BIZRID"] = arr3[0];//생산자 아이디
			input["MFC_BIZRNO"] = arr3[1];//생산자 사업자번호
			input["MFC_BRCH_ID"] = arr4[0];//생산자 직매장/공장 아이디
			input["MFC_BRCH_NO"] = arr4[1];//생산자 직매장/공장 번호
			input["CTNR_SE"] = $("#CTNR_SE").val();//빈용기명 구분 구/신
			input["PRPS_CD"] = $("#PRPS_CD").val();//빈용기명  유흥/가정/공병/직접 
			input["RTN_DT"] = $("#RTN_DT").val();//반환일자 
			ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {   
   					 ctnr_nm = rtnData.ctnr_nm
   					 kora.common.setEtcCmBx2(rtnData.ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S'); //빈용기	
   				}else{
					alert("error");
   				}
	    	},false);
		}else{
			ctnr_nm=[];
			kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S'); //빈용기	
		}
		
		fn_rmk();//비고 부분 초기화
   	}
	
//소매수수료 적용여부 ㅇㄷ----------------------------------------------------------------------------------------------------
	//소매수수료 적용여부
	function fn_rmk_list(){
  		var ck = $("input[type=radio][name=select_rtl]:checked").val(); //소매수수료 라디오 
  		if(ck !="ext"){	//적용인경우
	  		$("#RMK_SELECT").prop("disabled",true);//비고 선택부분 비활성화
	  		$("#RMK").prop("disabled",true);//비고 입력부분 비활성화
	  		$("#RMK_SELECT").val("");//비고 선택부분 초기화
	  		$("#RMK").val("");//비고 입력부분 초기화
  		}else{//제외인경우
	  		if($("#PRPS_CD").val() == "0"){	//유흥인데  소매수수료 제외를 누를경우 (공병상의 경우 직접반환도 처리)
	      		 $("#select_rtl1").prop('checked', true);
	      		 alert("빈용기 구분이 가정용 일경우에만 적용됩니다.");
	      		 return;
	      	}
  		 	$("#RMK_SELECT").removeAttr("disabled");//비고 선택부분 활성화
  		}
	}
	
	//비고 선택 변경
	function fn_rmk_select(){
	  	if($("#RMK_SELECT").val() =="A" || $("#RMK_SELECT").val() =="B"){//소비자 직접반화 ,무인회수기인경우
	  		 $("#RMK").prop("disabled",true);//비고 입력란 비활성화
	  		 $("#RMK").val($("#RMK_SELECT option:selected").text());//비고 선택부분 텍스트 입력
	  	}else if($("#RMK_SELECT").val() =="C"){//직접입력인경우
	  		 $("#RMK").removeAttr("disabled");//비고 입력란 활성화
	  		 $("#RMK").val("");//비고 입력란 초기화
	  	}else if($("#RMK_SELECT").val() ==""){//선택일경우
	  		$("#RMK").prop("disabled",true);//비고 입력란 비활성화
	  		$("#RMK").val("");//초기화
	  	}  
   	}
	
	//비고부분 초기화
	function fn_rmk(){
		
		if('${sBizrTpCd}' != 'W2'){ //공병상
			$("#RMK").val("");//비고입력부분
	   		$("#RMK_SELECT").val("");//비고선택부분
		    $("#select_rtl1").prop('checked', true);//소매수수료여부 적용
			$("#RMK_SELECT").prop("disabled",true);//비고선택부분 비활성화
	   		$("#RMK").prop("disabled",true);//비고입력부분 비활성화
		}
	}
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
	 
	 //행등록
	function fn_reg2(){
		
		if(!kora.common.cfrmDivChkValid("divInput")) {
			return;
		}else if(!kora.common.fn_validDate($("#RTN_DT").val())){   
			alert("올바른 날짜 형식이 아닙니다.");
			return;
		}else if( $("#WHSL_SE_CD").val() !="" && $("#ENP_NM").val() != "" && $("#BRCH_NM").val() != "" ) {
			$("#WHSL_SE_CD").prop("disabled",true);
			$("#ENP_NM").prop("disabled",true);
			$("#BRCH_NM").prop("disabled",true);
			whsl_chk[0] =$("#WHSL_SE_CD").val();
			whsl_chk[1] =$("#ENP_NM").val();
			whsl_chk[2] =$("#BRCH_NM").val();
		}  

		var input = insRow("A");
		if(!input){
			return;
		}
		
		gridRoot.addItemAt(input);
		gridRoot.calculateAutoHeight(); //모바일에서 필요..
		dataGrid.setSelectedIndex(-1);			  
	}
	
	//행 수정
	function fn_upd(){
		var idx = dataGrid.getSelectedIndex();
		if(idx < 0) {
			alert("변경할 행을 선택하시기 바랍니다.");
			return;
		}else if(!kora.common.cfrmDivChkValid("divInput")) { //필수값 체크
			return;
		}else if(!kora.common.fn_validDate($("#RTN_DT").val())){ 
			alert("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return; 
		}

		var item = insRow("M");
		
		// 해당 데이터의 이전 수정내역을 삭제
		gridRoot.removeChangedData(gridRoot.getItemAt(idx));
		
		//해당 데이터 수정
		gridRoot.setItemAt(item, idx);
		gridRoot.calculateAutoHeight(); //모바일에서 필요..
		//dataGrid.setSelectedIndex(-1);			
	}
	 
	//행삭제
	function fn_del(){
		var idx = dataGrid.getSelectedIndex();
		if(idx < 0) {
			alert("삭제할 행을 선택하시기 바랍니다.");
			return;
		}
				
		gridRoot.removeItemAt(idx);
		gridRoot.calculateAutoHeight(); //모바일에서 필요..
	}

	//행변경 및 행추가시 그리드 셋팅
	insRow = function(gbn) {
		var input = {};
		var ctnrCd = $("#CTNR_CD").val();
		var mfc_bizrnm_cd = $("#MFC_BIZRNM").val();
		var mfc_brch_nm_cd = $("#MFC_BRCH_NM").val();
	    
	    var rtl_fee_select = $("input[type=radio][name=select_rtl]:checked").val();//수수료적용여부  라디오체크여부
		var arr3 = new Array();
		var arr4 = new Array();
		arr3	= $("#MFC_BIZRNM").val().split(";");
		arr4	= $("#MFC_BRCH_NM").val().split(";");
		
	 	if(!kora.common.fn_validDate_ck( "R", $("#RTN_DT").val())){ //등록일자제한 체크
			return;
		} 
	 	
	 	var collection = gridRoot.getCollection();  //그리드 데이터
	 	for(var i=0; i<collection.getLength(); i++) {
	 		var tmpData = gridRoot.getItemAt(i);
	    	if(tmpData["CTNR_CD"] == ctnrCd &&  tmpData["MFC_BIZRNM_CD"] == mfc_bizrnm_cd
	    			&& tmpData["MFC_BRCH_NM_CD"] == mfc_brch_nm_cd ) {
				if(gbn == "M") {
					if(rowIndexValue != i) {
			    		alert("동일한 빈용기명이 있습니다.");
			    		return false;
			    	}
				} else {
		    		alert("동일한 빈용기명이 있습니다..");
		    		return false;
				}
			}//end of if(gridData[i]...)
	    }
	    
		for(var i=0; i<ctnr_nm.length; i++){
			
			if(ctnr_nm[i].CTNR_CD == ctnrCd) {
				input["RTN_DT"]	= $("#RTN_DT").val();//반환일자
			    input["MFC_BIZRNM"] = $("#MFC_BIZRNM option:selected").text();//생산자
			    input["MFC_BIZRNM_CD"] = $("#MFC_BIZRNM").val();//생산자코드 ID+NO
			    input["MFC_BRCH_NM"] = $("#MFC_BRCH_NM option:selected").text();// 직매장/공장
			    input["MFC_BRCH_NM_CD"] = $("#MFC_BRCH_NM").val();// 직매장/공장 ID+NO
			    input["CTNR_SE"] = $("#CTNR_SE").val();//빈용기명 구분 구/신
			    input["PRPS_NM"] = $("#PRPS_CD option:selected").text();//빈용기명 구분 유흥/가정
			   	input["PRPS_CD"] = $("#PRPS_CD").val();//빈용기명  유흥/가정/직접 
			    input["CTNR_NM"] = $("#CTNR_CD option:selected").text();//빈용기명
			    input["CTNR_CD"] = $("#CTNR_CD").val();//빈용기 코드
			    input["CPCT_NM"] = ctnr_nm[i].CPCT_NM;//용량ml
			    
			    if(	$("#BOX_QTY").val() ==""){
			    	input["BOX_QTY"] = "0"//상자
			    }else{
			    	input["BOX_QTY"] = $("#BOX_QTY").val().replace(/\,/g,"");//상자
			    }
			    
			    input["RTN_QTY"] = $("#RTN_QTY").val().replace(/\,/g,"");//반환량	
			    input["RTN_GTN_UTPC"] = ctnr_nm[i].STD_DPS;//기준보증금 
			    input["RTN_GTN"] = input["RTN_QTY"] * ctnr_nm[i].STD_DPS;//빈용기보증금(원) - 합계
			    input["RTN_WHSL_FEE_UTPC"] = ctnr_nm[i].WHSL_FEE;//도매수수료
			    input["RTN_WHSL_FEE"] = input["RTN_QTY"] *ctnr_nm[i].WHSL_FEE;//도매수수료 합계
			    input["RTN_WHSL_FEE_STAX"] = kora.common.truncate(parseInt(input["RTN_WHSL_FEE"],10)/10);//도매 부과세
			    
			    if($("#PRPS_CD").val() =="1" || $("#PRPS_CD").val() =="2"){	//빈용기구분이 가정일 경우에만 적용   (공병상일경우 직접반환도 적용)
					    if(rtl_fee_select =="ext"){//소매수수료적영여부 제외시
				    		if($("#RMK_SELECT").val() =="" ){
				    			alert("소매수수료 제외 선택시 ,비고에 사유를 입력하셔야 합니다.");
				    			return;
				    		}else if ($("#RMK").val() ==""){
				    			alert("소매수수료 제외 선택시 ,비고에 사유를 입력하셔야 합니다.");
				    			return;
				    		}
					    	input["RTN_RTL_FEE_UTPC"] = 0;//소매수수료    
							input["RTN_RTL_FEE"] = 0;//소매수수료 합계	
							
							if($("#RMK_SELECT").val() !="C"){
								input["RMK"] = $("#RMK_SELECT").val()+"-"+$("#RMK_SELECT option:selected").text();//비고 텍스트값
								input["RMK_C"] = $("#RMK_SELECT option:selected").text();//비고 텍스트값(view용)
							}else{
								input["RMK"] = $("#RMK_SELECT").val()+"-"+$("#RMK").val(); //비고 텍스트값
								input["RMK_C"] = $("#RMK").val();//비고 텍스트값(view용)
							}
							
					    }else{//소매수수료 적용 시
					    	  input["RTN_RTL_FEE_UTPC"]	= ctnr_nm[i].RTL_FEE;//소매수수료
							  input["RTN_RTL_FEE"] = input["RTN_QTY"] * ctnr_nm[i].RTL_FEE;//소매수수료 합계	
					    }
			    }else{
			    	  input["RTN_RTL_FEE_UTPC"]	= ctnr_nm[i].RTL_FEE;										//소매수수료
					  input["RTN_RTL_FEE"] = input["RTN_QTY"] * ctnr_nm[i].RTL_FEE;		//소매수수료 합계	
			    }
			    
			  	//소매부과세를 도매부과세로
			    input["RTN_WHSL_FEE_STAX"] = kora.common.truncate( (parseInt(input["RTN_WHSL_FEE"],10) + parseInt(input["RTN_RTL_FEE"],10)) / 10 ); //도매 부과세
			    
			    input["AMT_TOT"] = Number(input["RTN_GTN"])+ Number(input["RTN_WHSL_FEE"]) + Number(input["RTN_WHSL_FEE_STAX"])+ Number(input["RTN_RTL_FEE"]); //총합계
			    //visible  false
			    input["CAR_NO"] = $("#CAR_NO").val();//차량번호
				input["MFC_BIZRID"]	= arr3[0];//생산자 아이디
				input["MFC_BIZRNO"] = arr3[1];//생산자 사업자번호
				input["MFC_BRCH_ID"]= arr4[0];//생산자 직매장/공장 아이디
				input["MFC_BRCH_NO"]= arr4[1];//생산자 직매장/공장 번호
				input["BIZR_TP_CD"]	= $("#WHSL_SE_CD").val();//도매업자 구분 
				input["SYS_SE"]	= 'W';//시스템구분	
				input["RTN_STAT_CD"] = 'RG';//반환상태코드
				
				break;
			}
		}
		return input;
	};	
	
	//등록
	function fn_reg(){
		
		var collection = gridRoot.getCollection();  //그리드 데이터
		if (collection.getLength() <1){
			alert("데이터를 입력해주세요")
			return;
		}else if(	whsl_chk[0] !=$("#WHSL_SE_CD").val() || whsl_chk[1] !=$("#ENP_NM").val() || whsl_chk[2] !=$("#BRCH_NM").val()){
			alert("변조된데이터 입니다");
			return;
		}else if(0 != collection.getLength()){
			if(confirm("등록하시겠습니까?")){
				fn_reg_exec();
			}
		}else{
			alert("등록할 자료가 없습니다.\n\n자료를 입력 후 행추가 버튼을 클릭하여 저장할 자료를 여러건 입력한 다음 등록 버튼을 클릭하세요.");
		}
		 
	}
	
	function fn_reg_exec(){
		
		var data = {"list": ""};
		var row = new Array();
		var url = "/WH/EPWH2910131_09.do"; 
		var collection = gridRoot.getCollection();
		
	 	for(var i=0;i<collection.getLength(); i++){
	 		var tmpData = gridRoot.getItemAt(i);
	 		row.push(tmpData);//행 데이터 넣기
	 	}//end of for
		data["list"] = JSON.stringify(row);

		ajaxPost(url, data, function(rtnData){
			if(rtnData != null && rtnData != ""){
				if(rtnData.RSLT_CD =="0000"){
					alert(rtnData.RSLT_MSG);
					fn_cnl();
				}else if(rtnData.RSLT_CD =="A003"){ // 중복일경우
					alert(rtnData.ERR_CTNR_NM+"은 " +rtnData.RSLT_MSG);
				}else{
					alert(rtnData.RSLT_MSG);
				}
			}else{
					alert("error");
			}

		});//end of ajaxPost
		
	}
	
	//취소버튼 이전화면으로
    function fn_cnl(){
   	 	kora.common.goPageB('', INQ_PARAMS);
    }
	
	//선택한 행 입력창에 값 넣기
	function fn_rowToInput (rowIndex){
		
		var item = gridRoot.getItemAt(rowIndex);
		fn_dataSet(item);
		$("#MFC_BIZRNM").val( item["MFC_BIZRNM_CD"]).prop("selected", true);      //생산자
		$("#MFC_BRCH_NM").val( item["MFC_BRCH_NM_CD"]).prop("selected", true);	//직매장/공장
		$("#CTNR_SE").val(item["CTNR_SE"]).prop("selected", true);   						//빈용기명 구분
		$("#PRPS_CD").val(item["PRPS_CD"]).prop("selected", true);   				 		//빈용기명구분
		$("#CTNR_CD").val(item["CTNR_CD"]).prop("selected", true);    				 	//빈용기명
		$("#RTN_QTY").val(item["RTN_QTY"]);
		$("#BOX_QTY").val(item["BOX_QTY"]);
		$("#CAR_NO").val(item["CAR_NO"]); 
	
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
		var url 	 	= "/WH/EPWH2910131_196.do"; 
		ctnr_nm=[];

		input["MFC_BIZRID"] = item["MFC_BIZRID"];	//생산자 아이디
		input["MFC_BIZRNO"] = item["MFC_BIZRNO"];	//생산자 사업자번호
		input["MFC_BRCH_ID"] = item["MFC_BRCH_ID"];	//생산자 직매장/공장 아이디
		input["MFC_BRCH_NO"] = item["MFC_BRCH_NO"];	//생산자 직매장/공장 번호
		input["CTNR_SE"] = item["CTNR_SE"];			//빈용기명 구분 구/신
		input["PRPS_CD"] = item["PRPS_CD"];			//빈용기명  유흥/가정/공병/직접 
		input["RTN_DT"] = item["RTN_DT"];			//반환일자 
		
       	ajaxPost(url, input, function(rtnData) {
    			if ("" != rtnData && null != rtnData) {   
    				 ctnr_nm = rtnData.ctnr_nm
    				 kora.common.setEtcCmBx2(rtnData.brch_dtssList, "","", $("#MFC_BRCH_NM"), "MFC_BRCH_ID_NO", "MFC_BRCH_NM", "N" ,'S');		//반환대상 직매장/공장		
    				 kora.common.setEtcCmBx2(rtnData.ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');										//빈용기	
    			}else{
					alert("error");
    			}
    	},false);
		   
	}
	
	/* ---------숫자이 외 꺼 막기 테스트 ----------- */
	function onlyNumber(event){
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
			return;
		else
			return false;
	}
	function removeChar(event) {
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
			return;
		else
			event.target.value = event.target.value.replace(/[^0-9]/g, "");
	}
	 /* ------------------------------------------------- */  

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
 			layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
 			layoutStr.push('	<DataGrid id="dg1" autoHeight="true" minHeight="750" rowHeight="110" styleName="gridStyle" textAlign="center">');
 			layoutStr.push('		<columns>');
 			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('mfc_bizrnm')+"&lt;br&gt;("+fn_text('ctnr_nm')+ ')" width="70%"/>');
 			layoutStr.push('			<DataGridColumn dataField="RTN_DT" labelJsFunction="convertItem" itemRenderer="HtmlItem" headerText="'+ fn_text('rtrvl_dt')+"&lt;br&gt;("+fn_text('rtn_qty2')+ ')" width="30%"/>');
 			layoutStr.push('		</columns>');
 			layoutStr.push('	</DataGrid>');
 			layoutStr.push('    <Style>');
 			layoutStr.push('		.gridStyle {');
 			layoutStr.push('			headerColors:#565862,#565862;');
 			layoutStr.push('			headerStyleName:gridHeaderStyle;');
 			layoutStr.push('			verticalAlign:middle;headerHeight:70;fontSize:28;');
 			layoutStr.push('		}');
 			layoutStr.push('		.gridHeaderStyle {');
 			layoutStr.push('			color:#ffffff;');
 			layoutStr.push('			fontWeight:bold;');
 			layoutStr.push('			horizontalAlign:center;');
 			layoutStr.push('			verticalAlign:middle;');
 			layoutStr.push('		}');
 			layoutStr.push('    </Style>');
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
 			
 			gridApp.setData();
 		}
 		var dataCompleteHandler = function(event) {
 			dataGrid = gridRoot.getDataGrid(); // 그리드 객체
 		}
 		var selectionChangeHandler = function(event) {
 			var rowIndex = event.rowIndex;
 			var columnIndex = event.columnIndex;
 			rowIndexValue = rowIndex;
 			fn_rowToInput(rowIndex);
 		}
 		gridRoot.addEventListener("dataComplete", dataCompleteHandler);
 		gridRoot.addEventListener("layoutComplete", layoutCompleteHandler);
 	}

 	// labelJsFunction 기능을 이용하여 Quarter 컬럼에 월 분기 표시를 함께 넣어줍니다.
 	// labelJsFunction 함수의 파라메터는 다음과 같습니다.
 	// function labelJsFunction(item:Object, value:Object, column:Column)
 	//	      item : 해당 행의 data 객체
 	//	      value : 해당 셀의 라벨
 	//	      column : 해당 셀의 열을 정의한 Column 객체
 	// 그리드 설정시 DataGridColumn 항목에 추가 (예: labelJsFunction="convertItem") 
 	function convertItem(item, value, column) {
 		
 		var dataField = column.getDataField();
 		
 		if(dataField == "MFC_BIZRNM"){
 			return item["MFC_BIZRNM"] + "</br>(" + item["CTNR_NM"] + ")";
 		}
 		else if(dataField == "RTN_DT"){
 			return kora.common.formatter.datetime(item["RTN_DT"], "yyyy-mm-dd") + "</br>(" + kora.common.format_comma(item["RTN_QTY"]) + ")";
 		}
 		else {
 			return "";
 		}
 	}
 	
 /****************************************** 그리드 셋팅 끝******************************************/


</script>

<style>
	.contbox .boxed.v2 .sort {width: 190px;}
	.contbox .boxed.v2 .cont {width: 440px;}
</style>

</head>
<body>

	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
	<input type="hidden" id="whsl_se_cd_list" value="<c:out value='${whsl_se_cd}' />" />
	<input type="hidden" id="ctnr_se_list" value="<c:out value='${ctnr_se}' />" />
	<input type="hidden" id="rmk_list" value="<c:out value='${rmk_list}' />" />
	<input type="hidden" id="rtc_dt_list" value="<c:out value='${rtc_dt_list}' />" />

	<div id="wrap">
	
		<%@include file="/jsp/include/header_m.jsp" %>
		
		<%@include file="/jsp/include/aside_m.jsp" %>

		<div id="container">

			<div id="subvisual">
				<h2 class="tit" id="title"></h2>
				<button class="btn_back" id="btn_cnl"><span class="hide">뒤로가기</span></button>
			</div><!-- id : subvisual -->

			<div id="contents">
				<div class="contbox pb50" id="divInput">
					<div class="box_wrap" style="margin: -20px 0 0">
						<div class="boxed v2">
							<div class="sort" id="rtrvl_dt_txt"></div>
							<div class="cont">
								<input type="text" id="RTN_DT" style="width: 285px;" class="i_notnull">
							</div>
						</div>
					</div>
					<div class="box_wrap">
						<div class="boxed v2">
							<div class="sort" id="rtrvl_trgt_mfc_txt"></div>
							<div class="cont">
								<select id="MFC_BIZRNM" style="width: 450px;" class="i_notnull"></select>
							</div>
						</div>
						<div class="boxed v2 mt10">
							<div class="sort" id="rtrvl_trgt_brch_txt"></div>
							<div class="cont">
								<select id="MFC_BRCH_NM" style="width: 450px;" class="i_notnull"></select>
							</div>
						</div>
						<div class="boxed v2 mt10">
							<div class="sort" id="ctnr_se_txt"></div>
							<div class="cont">
								<select style="width: 150px;" id="CTNR_SE" class="i_notnull"></select>
								<select style="width: 250px;margin-left:5px" id="PRPS_CD" class="i_notnull"></select>
							</div>
						</div>
						<div class="boxed v2 mt10">
							<div class="sort" id="ctnr_nm2_txt"></div>
							<div class="cont">
								<select style="width: 450px;" id="CTNR_CD" class="i_notnull"></select>
							</div>
						</div>
					</div>
					<div class="box_wrap">
						<div class="boxed v2" id="w2Hide_1">
							<div class="sort" id="rtl_fee_aplc_yn_br_txt"></div>
							<div class="cont" style="font-size:17pt;color:#222222;font-weight:bold" id="RMK_LIST">
								<input type="radio" id="select_rtl1" name="select_rtl" value="aplc" checked="checked" style="width:30px;height:30px;margin-right:10px"/><span>적용</span>
								<input type="radio" id="select_rtl2" name="select_rtl" value="ext" style="width:30px;height:30px;margin:0 10px 0 10px"/><span>제외</span>
							</div>
						</div>
						<div class="boxed v2 mt10">
							<div class="sort" id="rtn_qty_txt"></div>
							<div class="cont"><input type="number" placeholder="직접입력" style="text-align: right;" maxlength="10" id="RTN_QTY" class="i_notnull" format="number"></div>
						</div>
						<div class="boxed v2 mt10">
							<div class="sort" id="box_qty_txt"></div>
							<div class="cont"><input type="number" placeholder="직접입력" style="text-align: right;" maxlength="10" id="BOX_QTY" class="i_notnull" format="number"></div>
						</div>
					</div>
					<div class="box_wrap">
						<div class="boxed v2">
							<div class="sort" id="car_no_txt"></div>
							<div class="cont"><input type="text" maxlength="50" id="CAR_NO" class="i_notnull"></div>
						</div>
						<div class="boxed v2 mt10" id="w2Hide_2">
							<div class="sort" id="rmk_txt"></div>
							<div class="cont">
								<select id="RMK_SELECT" style="width: 279px" disabled="disabled"></select>
								<br>
								<input type="text" id="RMK" style="width: 450px;margin-top:5px" maxlength="50" disabled="disabled" />
							</div>
						</div>
					</div>
					<div class="btn_wrap mt10 line">
						<div class="fl_c">
							<button class="btnCircle c2" id="btn_upd">변경</button>
							<button class="btnCircle c1" id="btn_del">삭제</button>
							<button class="btnCircle c3" id="btn_reg2">추가</button>
						</div>
					</div>
				</div>
				
				<div class="tblbox">
					<div class="tbl_inquiry v2">
						<div id="gridHolder"></div> <!-- 그리드 -->
					</div>
					<div class="btn_wrap" style="height:50px">
						<button class="btnCircle c1" id="btn_reg">등록</button>
					</div>
				</div>
				
			</div><!-- id : contents -->

		</div><!-- id : container -->

		<%@include file="/jsp/include/footer_m.jsp" %>
		
	</div><!-- id : wrap -->


</body>
</html>