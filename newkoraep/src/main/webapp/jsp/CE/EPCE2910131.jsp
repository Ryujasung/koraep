<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>반환내역서 등록</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />
<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS;	//파라미터 데이터
     var whsl_se_cd; 		//도매업자구분
     var ctnr_se;			//빈용기구분  구병 신병 
	 var rmk_list;     		//소매수수료 적용여부 비고
     var toDay = kora.common.gfn_toDay();  // 현재 시간
	 var rowIndexValue =0;
     var mfc_bizrnmList=[];							//생산자
     var ctnr_seList = [];								//빈용기구분
     var ctnr_nm=[]; 									//빈용기
     var regGbn =true;
 	 var arr 	= new Array();
	 var arr2 = new Array();
	 var flag_DT = "";
	 var whsl_chk = {};  
	 
     $(function() {
    	 
    	INQ_PARAMS 		= jsonObject($("#INQ_PARAMS").val());	//파라미터 데이터
    	whsl_se_cd 			= jsonObject($("#whsl_se_cd_list").val());	//도매업자 구분
    	ctnr_se 				= jsonObject($("#ctnr_se_list").val());		//빈용기 구분
    	rmk_list				= jsonObject($("#rmk_list").val());				//비고	
    	rtc_dt_list 			= jsonObject($("#rtc_dt_list").val());			//등록일자제한설정	
    	
    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
    	 //그리드 셋팅
		 fnSetGrid1();
		 
		//날짜 셋팅
  	    $('#RTN_DT').YJcalendar({  
 			triggerBtn : true,
 			dateSetting: toDay.replaceAll('-','')
 			});
		
		//text 셋팅
		$('#title_sub').text('<c:out value="${titleSub}" />');						  //타이틀
		$('#whsl_se_cd').text(parent.fn_text('whsl_se_cd'));															//도매업자 구분
		$('#enp_nm').text(parent.fn_text('enp_nm'));																	//업체명
		$('#brch').text(parent.fn_text('brch')); 			 																//지점
		$('#rtrvl_dt').text(parent.fn_text('rtrvl_dt')); 																		//반환일자
		$('#rtrvl_trgt_mfc_bizrnm').text(parent.fn_text('rtrvl_trgt')+parent.fn_text('mfc_bizrnm')); 			//반환대상생산자
		$('#rtrvl_trgt_mfc_brch_nm').text(parent.fn_text('rtrvl_trgt')+parent.fn_text('mfc_brch_nm')); 	//반환대상지점
		$('#ctnr_se').text(parent.fn_text('ctnr_se'));																		//빈용기 구분
		$('#ctnr_nm').text(parent.fn_text('ctnr_nm'));																	//빈용기명
		$('#rtn_qty').text(parent.fn_text('rtn_qty')); 			 														//반환량(개)
		$('#box_qty').text(parent.fn_text('box_qty')); 																	//상자
		$('#car_no').text(parent.fn_text('car_no')); 																		//차량번호
		
		//div필수값 alt
		 $("#RTN_DT").attr('alt',parent.fn_text('rtrvl_dt'));   
		 $("#MFC_BIZRNM").attr('alt',parent.fn_text('rtrvl_trgt')+parent.fn_text('mfc_bizrnm'));				//기준취습수수료
		 $("#MFC_BRCH_NM").attr('alt',parent.fn_text('rtrvl_trgt')+parent.fn_text('mfc_brch_nm'));   	//최저 기준취습수수료    
		 $("#PRPS_CD").attr('alt',parent.fn_text('ctnr_se'));   	
		 $("#CTNR_CD").attr('alt',parent.fn_text('ctnr_nm'));   	
		 $("#RTN_QTY").attr('alt',parent.fn_text('rtn_qty'));															//기준취습수수료
		 $("#BOX_QTY").attr('alt',parent.fn_text('box_qty'));															//상자
		 $("#CAR_NO").attr('alt',parent.fn_text('car_no'));   															//최저 기준취습수수료    
		 
		/************************************
		 * 도매업자 구분 변경 이벤트
		 ***********************************/
		$("#WHSL_SE_CD").change(function(){
			fn_whsl_se_cd();
		});
		 
		/************************************
		 * 업체명  변경 이벤트
		 ***********************************/
		$("#ENP_NM").change(function(){
			fn_enp_nm();
		});
		
		/************************************
		 * 지점  변경 이벤트
		 ***********************************/
		$("#BRCH_NM").change(function(){
			fn_brch_nm();
		});
		 
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
		 * 시작날짜  클릭시 - 삭제 변경 이벤트
		 ***********************************/
		$("#RTN_DT").click(function(){
			    var rtn_dt = $("#RTN_DT").val();
			    rtn_dt   =  rtn_dt.replace(/-/gi, "");
			     $("#RTN_DT").val(rtn_dt)
		});
		
		/************************************
		 * 시작날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		$("#RTN_DT").change(function(){
			
		     var rtn_dt = $("#RTN_DT").val();
		     rtn_dt   =  rtn_dt.replace(/-/gi, "");
			if(rtn_dt.length == 8)  rtn_dt = kora.common.formatter.datetime(rtn_dt, "yyyy-mm-dd")
		     $("#RTN_DT").val(rtn_dt) 
		      if($("#RTN_DT").val() !=flag_DT){ //클릭시 날짜 변경 할경우   기존날짜랑 현재날짜랑 다를 경우  데이터 초기화
		     	 flag_DT = $("#RTN_DT").val();  //변경시 날짜 
				 kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'S'); 	//반환대상 생산자
		    	 kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");											//빈용기구분
				 kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'S');					//반환대상 직매장/공장
		    	 kora.common.setEtcCmBx2(ctnr_seList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S'); 								//빈용기구분 코드
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
	
		/************************************
		 * 양식다운로드 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_dwnd").click(function(){
			fn_excelDown();
		});
		
		/************************************
		 * 엑셀등록 버튼 클릭 이벤트
		 ***********************************/
		$("#btn_excel_reg").click(function(){
			
			if( $("#WHSL_SE_CD").val()=="" ||$("#ENP_NM").val()=="" ||$("#BRCH_NM").val()=="" ){
				alertMsg("도매업자 구분 ,업체명 , 지점 을 선택 해주세요");
				return;
			}else if( $("#WHSL_SE_CD").val()      !=""   && $("#ENP_NM").val()     != ""   && $("#BRCH_NM").val()  != ""  ) {
				$("#WHSL_SE_CD").prop("disabled",true);
				$("#ENP_NM").prop("disabled",true);
				$("#BRCH_NM").prop("disabled",true);
				
				whsl_chk[0] =$("#WHSL_SE_CD").val();
				whsl_chk[1] =$("#ENP_NM").val();
				whsl_chk[2] =$("#BRCH_NM").val();
				kora.common.gfn_excelUploadPop("fn_popExcel");
			}
		});
		
  		fn_init();
    	kora.common.setEtcCmBx2(whsl_se_cd, "","", $("#WHSL_SE_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');			//도매업자구분
    	$("#ENP_NM").select2();
	});
     //초기화
     function fn_init(){
    	if(regGbn){
	    	 kora.common.setEtcCmBx2([], "","", $("#ENP_NM"), "ETC_CD", "ETC_CD_NM", "N" ,'S');							//업체명
			 kora.common.setEtcCmBx2([], "","", $("#BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S');						//지점
    	}
		kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'S');		//반환대상 생산자
		kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'S');	//반환대상 직매장/공장
		kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");							//빈용기구분
		kora.common.setEtcCmBx2(ctnr_seList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');				//빈용기구분 코드
		kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');							//빈용기명
		kora.common.setEtcCmBx2(rmk_list, "","", $("#RMK_SELECT"), "ETC_CD", "ETC_CD_NM", "N" ,'S');					//비고
		$('#RTN_DT').val(kora.common.formatter.datetime(toDay, "yyyy-mm-dd"));
		flag_DT = $("#RTN_DT").val(); 
		$("#BOX_QTY").val("");
		$("#RTN_QTY").val("");
		$("#CAR_NO").val("");
    	$("#RMK").val("");
		$("#select_rtl1").prop("checked", true)
		$("#RMK_SELECT").prop("disabled",true);
    	$("#RMK").prop("disabled",true);
     }
     
   //도매업자구분 변경시
     function fn_whsl_se_cd(){
    	var url = "/CE/EPCE2910131_19.do" 
		var input ={};
    	$("#ENP_NM").select2("val","");
    	input["BIZR_TP_CD"] =$("#WHSL_SE_CD").val();
    	fn_init();
    	if($("#WHSL_SE_CD").val() !=""){
           	ajaxPost(url, input, function(rtnData) {
        				if ("" != rtnData && null != rtnData) {   
        					ctnr_seList = rtnData.ctnr_seList;
        					kora.common.setEtcCmBx2(rtnData.ctnr_seList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S'); 	//빈용기구분 코드
        					kora.common.setEtcCmBx2(rtnData.enp_nmList, "","", $("#ENP_NM"), "BIZRID_NO", "BIZRNM", "N" ,'S');	//업체명
        				}else{
        						 alertMsg("error");
        				}
        	},false);
    	}
     }
   
   	//업체명 변경시
   	function fn_enp_nm(){
 		var url = "/CE/EPCE2910131_192.do" 
		var input ={};
 		if($("#ENP_NM").val() !=""){
 			arr=[];
		   	arr = $("#ENP_NM").val().split(";"); 
		   	input["BIZRID"] 	= arr[0];
		   	input["BIZRNO"] 	= arr[1];
		   	input["BIZR_TP_CD"] =$("#WHSL_SE_CD").val();
       	   	ajaxPost(url, input, function(rtnData) {
    				if ("" != rtnData && null != rtnData) {   
    					 	 kora.common.setEtcCmBx2(rtnData.brch_nmList, "","", $("#BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N","S");//지점
    				}else{   
    						 alertMsg("error");   
    				}   
    		},false);
 		}else{
 			 kora.common.setEtcCmBx2([], "","", $("#BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S');	//지점 
 		}
 		kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");									//빈용기구분
    	kora.common.setEtcCmBx2(ctnr_seList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S'); 						//빈용기구분 코드
		kora.common.setEtcCmBx2([], "","", $("#MFC_BIZRNM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'S');				//반환대상 생산자
		kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'S');			//반환대상 직매장/공장
		kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');									//빈용기명	    
		fn_rmk()//비고 부분 초기화
	   
   	}
   	//지점 변경시
   	function fn_brch_nm(){
 		var url = "/CE/EPCE2910131_193.do" 
		var input ={};
 		if($("#BRCH_NM").val() !=""){
			arr2 = [];
			arr2	= $("#BRCH_NM").val().split(";");
			input["CUST_BIZRID"] 		= arr[0];
			input["CUST_BIZRNO"] 		= arr[1];
			input["CUST_BRCH_ID"] 	= arr2[0];
			input["CUST_BRCH_NO"] 	= arr2[1];
			input["STAT_CD"] 			= 'Y'
	       	ajaxPost(url, input, function(rtnData) {
    				if ("" != rtnData && null != rtnData) {   
    					 mfc_bizrnmList = rtnData.mfc_bizrnmList;
    					 kora.common.setEtcCmBx2(rtnData.mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'S'); 	//반환대상 생산자
    				}else{
    						 alertMsg("error");
    				}
	    	},false);
  		}else{
   			kora.common.setEtcCmBx2([], "","", $("#MFC_BIZRNM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'S'); 	//반환대상 생산자
   		}
   		kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");							//빈용기구분
		kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'S');		//반환대상 직매장/공장
    	kora.common.setEtcCmBx2(ctnr_seList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S'); 				//빈용기구분 코드
		kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');							//빈용기명
		fn_rmk()//비고 부분 초기화
	    	
  	} 
   	//반환대상생산자 변경시
   	function fn_mfc_bizrnm(){
  		var url = "/CE/EPCE2910131_194.do" 
		var input ={};
  		if( $("#MFC_BIZRNM").val() !=""){
		   		var arr3 = new Array();
				arr3	= $("#MFC_BIZRNM").val().split(";");
				input["CUST_BIZRID"] 		= arr[0];
				input["CUST_BIZRNO"] 		= arr[1];
				input["CUST_BRCH_ID"] 	= arr2[0];
				input["CUST_BRCH_NO"] 	= arr2[1];
				input["MFC_BIZRID"] 		= arr3[0];
				input["MFC_BIZRNO"] 		= arr3[1];
				input["STAT_CD"] 				= "Y";
		       	ajaxPost(url, input, function(rtnData) {
		    		if ("" != rtnData && null != rtnData) {   
		    					 kora.common.setEtcCmBx2(rtnData.brch_dtssList, "","", $("#MFC_BRCH_NM"), "MFC_BRCH_ID_NO", "MFC_BRCH_NM", "N" ,'S');//반환대상 직매장/공장		
		    		}else{
		    					 alertMsg("error");
		    				}
		    	});
  		}else{  
				kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "MFC_BRCH_ID_NO", "MFC_BRCH_NM", "N" ,'S');//반환대상 직매장/공장		
  		}
  		kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");	//빈용기구분
  		kora.common.setEtcCmBx2(ctnr_seList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S'); 	//빈용기구분 코드
		kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');	//빈용기명
		fn_rmk()//비고 부분 초기화
   	}
   	//직매장/공장 변경시
   	function fn_mfc_brch_nm(){
   	    
        var url = "/CE/EPCE2910131_198.do" 
        var input ={};

        if( $("#MFC_BRCH_NM").val() !=""){
            var arr1 = new Array();
            var arr2 = new Array();
            var arr3 = new Array();
            var arr4 = new Array();
            arr1 = $("#MFC_BIZRNM").val().split(";");
            arr2 = $("#MFC_BRCH_NM").val().split(";");
            arr3 = $("#ENP_NM").val().split(";");
            arr4 = $("#BRCH_NM").val().split(";");
             
            input["MFC_BIZRID"]  = arr1[0];
            input["MFC_BIZRNO"]  = arr1[1];
            input["MFC_BRCH_ID"] = arr2[0];
            input["MFC_BRCH_NO"] = arr2[1];
            input["CUST_BIZRID"]  = arr3[0];
            input["CUST_BIZRNO"]  = arr3[1];
            input["CUST_BRCH_ID"] = arr4[0];
            input["CUST_BRCH_NO"] = arr4[1];

            
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
   	    
		//kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");				//빈용기구분
	    //kora.common.setEtcCmBx2(ctnr_seList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S'); 	//빈용기구분 코드
	    //kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');				//빈용기명
	    //fn_rmk()//비고 부분 초기화
   	}
	//빈용기 구분 선택시
	function fn_prps_cd(){
		if($("#MFC_BRCH_NM").val() =="") {
		   alertMsg("반환대상 직매장/공장을 선택해주세요");
		   return;
	   	}
		var url = "/CE/EPCE2910131_195.do" 
		var input ={};
		if( $("#PRPS_CD").val() !=""){
				ctnr_nm=[];
				var arr3	= $("#MFC_BIZRNM").val().split(";");
				var arr4	= $("#MFC_BRCH_NM").val().split(";"); 
				input["CUST_BIZRID"] 		= arr[0];						//도매업자아이디
				input["CUST_BIZRNO"] 		= arr[1];						//도매업자사업자번호
				input["CUST_BRCH_ID"] 	= arr2[0];					//도매업자 지점 아이디
				input["CUST_BRCH_NO"] 	= arr2[1];					//도매업자 지점 번호
				input["MFC_BIZRID"] 		= arr3[0];					//생산자 아이디
				input["MFC_BIZRNO"] 		= arr3[1];					//생산자 사업자번호
				input["MFC_BRCH_ID"] 		= arr4[0];					//생산자 직매장/공장 아이디
				input["MFC_BRCH_NO"] 	= arr4[1];					//생산자 직매장/공장 번호
				input["CTNR_SE"] 			= $("#CTNR_SE").val();	//빈용기명 구분 구/신
				input["PRPS_CD"] 			= $("#PRPS_CD").val();	//빈용기명  유흥/가정/공병/직접 
				input["RTN_DT"] 				= $("#RTN_DT").val(); 	//반환일자 
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
  		var ck = $("input[type=radio][name=select_rtl]:checked").val(); //소매수수료 라디오 
  		if(ck !="ext"){	//적용인경우
	  		$("#RMK_SELECT").prop("disabled",true);	//비고 선택부분 비활성화
	  		$("#RMK").prop("disabled",true);				//비고 입력부분 비활성화
	  		$("#RMK_SELECT").val("")						//비고 선택부분 초기화
	  		$("#RMK").val("");									//비고 입력부분 초기화
  		}else{				//제외인경우
	  		if($("#PRPS_CD").val() !="1"){	//유흥인데  소매수수료 제외를 누를경우
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
		}
		
		if(!kora.common.fn_validDate($("#RTN_DT").val())){   
			alertMsg("올바른 날짜 형식이 아닙니다.");
			return;
		}

		if(kora.common.format_noComma(kora.common.null2void($("#RTN_QTY").val(),0))  < 1) {
            alertMsg("반환량(개)를 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
            chkTarget = $("#RTN_QTY");
            
            return;
        }

        if(kora.common.format_noComma(kora.common.null2void($("#BOX_QTY").val(),0))  < 1) {
            alertMsg("상자를 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
            chkTarget = $("#BOX_QTY");
            
            return;
        }

		if( $("#WHSL_SE_CD").val()      !=""   && $("#ENP_NM").val()     != ""   && $("#BRCH_NM").val()  != ""  ) {
			$("#WHSL_SE_CD").prop("disabled",true);
			$("#ENP_NM").prop("disabled",true);
			$("#BRCH_NM").prop("disabled",true);
			whsl_chk[0] =$("#WHSL_SE_CD").val();
			whsl_chk[1] =$("#ENP_NM").val();
			whsl_chk[2] =$("#BRCH_NM").val();
        }
		
		

		regGbn 		=	false;
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
		}else if(!kora.common.cfrmDivChkValid("divInput")) {	//필수값 체크
			return;
		}else if(!kora.common.fn_validDate($("#RTN_DT").val())){ 
			alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return; 
		}

        if(kora.common.format_noComma(kora.common.null2void($("#RTN_QTY").val(),0))  < 1) {
            alertMsg("반환량(개)를 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
            chkTarget = $("#RTN_QTY");
            
            return;
        }

        if(kora.common.format_noComma(kora.common.null2void($("#BOX_QTY").val(),0))  < 1) {
            alertMsg("상자를 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
            chkTarget = $("#BOX_QTY");
            
            return;
        }
		
		regGbn 		=	false;
		var item = insRow("M");
		// 해당 데이터의 이전 수정내역을 삭제
		gridRoot.removeChangedData(gridRoot.getItemAt(idx));
		//해당 데이터 수정
		gridRoot.setItemAt(item, idx);
		//dataGrid.setSelectedIndex(-1);			
	}
	//행삭제
	function fn_del(){
		var idx = dataGrid.getSelectedIndex();
		if(idx < 0) {
			alertMsg("삭제할 행을 선택하시기 바랍니다.");
			return;
		}
		regGbn 		=	false;
		gridRoot.removeItemAt(idx);
	}
	 
	 
	//행변경 및 행추가시 그리드 셋팅
	insRow = function(gbn) {
		var input = {};
		var ctnrCd = $("#CTNR_CD").val();
		console.log(ctnrCd.substr(3,2));
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
			    		alertMsg("동일한 빈용기명이 있습니다.");
			    		return false;
			    	}
				} else {
		    		alertMsg("동일한 빈용기명이 있습니다..");
		    		return false;
				}
			}//end of if(gridData[i]...)
	    }
	    
		for(var i=0; i<ctnr_nm.length; i++){
			
			if(ctnr_nm[i].CTNR_CD == ctnrCd) {
				input["RTN_DT"]						= 	$("#RTN_DT").val();                           		//반환일자
			    input["MFC_BIZRNM"] 				= 	$("#MFC_BIZRNM option:selected").text();  	//생산자
			    input["MFC_BIZRNM_CD"] 		= 	$("#MFC_BIZRNM").val();  						 	//생산자코드 ID+NO
			    input["MFC_BRCH_NM"] 			= 	$("#MFC_BRCH_NM option:selected").text();	// 직매장/공장
			    input["MFC_BRCH_NM_CD"] 		= 	$("#MFC_BRCH_NM").val();					 		// 직매장/공장 ID+NO
			    input["CTNR_SE"] 					= 	$("#CTNR_SE").val();  	 							//빈용기명 구분 구/신
			    input["PRPS_NM"] 					= 	$("#PRPS_CD option:selected").text();   		//빈용기명 구분 유흥/가정
			   	input["PRPS_CD"] 					= 	$("#PRPS_CD").val();									//빈용기명  유흥/가정/직접 
			    input["CTNR_NM"] 					= 	$("#CTNR_CD option:selected").text(); 		 	//빈용기명
			    input["CTNR_CD"] 					= 	$("#CTNR_CD").val(); 								//빈용기 코드
			    input["CPCT_NM"] 					= 	ctnr_nm[i].CPCT_NM;								//용량ml
			    if(ctnrCd.substr(3,2) == "00"){
			    	input["STANDARD_NM"] 					= 	"표준용기";	
			    }else{
			    	input["STANDARD_NM"] 					= 	"비표준용기";	
			    }
			    if(	$("#BOX_QTY").val() ==""){
			    	 input["BOX_QTY"] 					= 	"0"													//상자
			    }else{
			    	 input["BOX_QTY"] 					= 	$("#BOX_QTY").val().replace(/\,/g,"");								//상자
			    }	
			    input["RTN_QTY"] 					= 	$("#RTN_QTY").val().replace(/\,/g,"");									//반환량	
			    input["RTN_GTN_UTPC"]      		= 	ctnr_nm[i].STD_DPS;									//기준보증금 
			    input["RTN_GTN"] 					= 	input["RTN_QTY"] * ctnr_nm[i].STD_DPS; 		//빈용기보증금(원) - 합계
			    input["RTN_WHSL_FEE_UTPC"]	=	ctnr_nm[i].WHSL_FEE;								//도매수수료
			    input["RTN_WHSL_FEE"]    		=	input["RTN_QTY"] *ctnr_nm[i].WHSL_FEE;		//도매수수료 합계
			    input["RTN_WHSL_FEE_STAX"]	=	kora.common.truncate(parseInt(input["RTN_WHSL_FEE"],10)/10);	//도매 부과세
			    
			    if($("#PRPS_CD").val() =="1"){	//빈용기구분이 가정일 경우에만 적용
					    if(rtl_fee_select =="ext"){							//소매수수료적영여부 제외시
				    		if($("#RMK_SELECT").val() =="" ){
				    			alertMsg("소매수수료 제외 선택시 ,비고에 사유를 입력하셔야 합니다.");
				    			return;
				    		}else if ($("#RMK").val() ==""){
				    			alertMsg("소매수수료 제외 선택시 ,비고에 사유를 입력하셔야 합니다.");
				    			return;
				    		}
					    	input["RTN_RTL_FEE_UTPC"]	=	0; 	//소매수수료    
							input["RTN_RTL_FEE"]      	=	0;		//소매수수료 합계	
							
							if($("#RMK_SELECT").val() !="C"){
								input["RMK"] 						=	$("#RMK_SELECT").val()+"-"+$("#RMK_SELECT option:selected").text();	//비고 텍스트값
								input["RMK_C"] 					=	$("#RMK_SELECT option:selected").text();											//비고 텍스트값(view용)
							}else{
								input["RMK"] 						=	$("#RMK_SELECT").val()+"-"+$("#RMK").val();	//비고 텍스트값
								input["RMK_C"] 					=	$("#RMK").val();												//비고 텍스트값(view용)
							}
					    }else{//소매수수료 적용 시
					    	  input["RTN_RTL_FEE_UTPC"]	=	ctnr_nm[i].RTL_FEE;										//소매수수료
							  input["RTN_RTL_FEE"]      		=	input["RTN_QTY"] * ctnr_nm[i].RTL_FEE;		//소매수수료 합계	
					    }
			    }else{
			    	  input["RTN_RTL_FEE_UTPC"]	=	ctnr_nm[i].RTL_FEE;										//소매수수료
					  input["RTN_RTL_FEE"]      		=	input["RTN_QTY"] * ctnr_nm[i].RTL_FEE;		//소매수수료 합계	
			    }
			    
			    //소매부과세를 도매부과세로
			    input["RTN_WHSL_FEE_STAX"]	=	kora.common.truncate( (parseInt(input["RTN_WHSL_FEE"],10) + parseInt(input["RTN_RTL_FEE"],10)) / 10 ); //도매 부과세
			    
			    
			    input["AMT_TOT"] 					=	Number(input["RTN_GTN"])+ Number(input["RTN_WHSL_FEE"]) + Number(input["RTN_WHSL_FEE_STAX"])+ Number(input["RTN_RTL_FEE"]); //총합계
			    //visible  false
			    input["CAR_NO"] 					=	$("#CAR_NO").val();																//차량번호
				input["CUST_BIZRID"] 				= arr[0];																					//도매업자아이디
				input["CUST_BIZRNO"] 			= arr[1];																					//도매업자사업자번호
				input["CUST_BRCH_ID"] 			= arr2[0];															  					//도매업자 지점 아이디
				input["CUST_BRCH_NO"] 			= arr2[1];																				//도매업자 지점 번호
				input["MFC_BIZRID"] 				= arr3[0];																				//생산자 아이디
				input["MFC_BIZRNO"] 				= arr3[1];																				//생산자 사업자번호
				input["MFC_BRCH_ID"] 			= arr4[0];																				//생산자 직매장/공장 아이디
				input["MFC_BRCH_NO"] 			= arr4[1];																				//생산자 직매장/공장 번호
				input["BIZR_TP_CD"]				= $("#WHSL_SE_CD").val(); 														//도매업자 구분 
				input["SYS_SE"]						= 'W';																					//시스템구분	
				input["RTN_STAT_CD"]				= 'RG';																					//반환상태코드
				break;
			}
		}
		return input;
	};	
	
	//등록
	function fn_reg(){
		
		var collection = gridRoot.getCollection();  //그리드 데이터
		if (collection.getLength() <1){
			alertMsg("데이터를 입력해주세요")
			return;
		}else if(	whsl_chk[0] !=$("#WHSL_SE_CD").val() || whsl_chk[1] !=$("#ENP_NM").val() || whsl_chk[2] !=$("#BRCH_NM").val()){
			alertMsg("변조된데이터 입니다");
			return;
		}else if(0 != collection.getLength()){
			confirm("등록하시겠습니까?", 'fn_reg_exec');
		}else{
			alertMsg("등록할 자료가 없습니다.\n\n자료를 입력 후 행추가 버튼을 클릭하여 저장할 자료를 여러건 입력한 다음 등록 버튼을 클릭하세요.");
		}
		 
	}
	
	function fn_reg_exec(){
		
		var data = {"list": ""};
		var row = new Array();
		var url = "/CE/EPCE2910131_09.do"; 
		var collection = gridRoot.getCollection();
		
	 	for(var i=0;i<collection.getLength(); i++){
	 		var tmpData = gridRoot.getItemAt(i);
	 		row.push(tmpData);//행 데이터 넣기
	 	}//end of for
		data["list"] = JSON.stringify(row);

		ajaxPost(url, data, function(rtnData){
			if(rtnData != null && rtnData != ""){
					if(rtnData.RSLT_CD =="A003"){ // 중복일경우
						alertMsg(rtnData.ERR_CTNR_NM+"은 " +rtnData.RSLT_MSG);
					}else if(rtnData.RSLT_CD =="A021"){
						alertMsg(rtnData.RSLT_MSG);
					}else if(rtnData.RSLT_CD =="0000"){
						alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
					}else if(rtnData.RSLT_CD !="0000"){
					    alertMsg(rtnData.ERR_CTNR_NM);
					}
			}else{
					alertMsg("error");
			}

		});//end of ajaxPost
		
	}
	
	  //취소버튼 이전화면으로
    function fn_cnl(){
   	 kora.common.goPageB('/CE/EPCE2910101.do', INQ_PARAMS);
    }
	
	//선택한 행 입력창에 값 넣기
	function fn_rowToInput (rowIndex){
		
		var item = gridRoot.getItemAt(rowIndex);
		fn_dataSet(item);
		$("#MFC_BIZRNM").val( item["MFC_BIZRNM_CD"]).prop("selected", true);      //생산자
		$("#MFC_BRCH_NM").val( item["MFC_BRCH_NM_CD"]).prop("selected", true);	//직매장/공장
		$("#CTNR_SE").val(item["CTNR_SE"]).prop("selected", true);   						//빈용기명 구분
		$("#PRPS_CD").val(item["PRPS_CD"]).prop("selected", true);   				 	//빈용기명구분
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
		var url 	 	= "/CE/EPCE2910131_196.do"; 
		ctnr_nm=[];
		input["CUST_BIZRID"] 		= item["CUST_BIZRID"];		//도매업자아이디
		input["CUST_BIZRNO"] 		= item["CUST_BIZRNO"];	//도매업자사업자번호
		input["CUST_BRCH_ID"] 	= item["CUST_BRCH_ID"];	//도매업자 지점 아이디
		input["CUST_BRCH_NO"] 	= item["CUST_BRCH_NO"];//도매업자 지점 번호
		input["MFC_BIZRID"] 		= item["MFC_BIZRID"];		//생산자 아이디
		input["MFC_BIZRNO"] 		= item["MFC_BIZRNO"];	//생산자 사업자번호
		input["MFC_BRCH_ID"] 		= item["MFC_BRCH_ID"];	//생산자 직매장/공장 아이디
		input["MFC_BRCH_NO"] 	= item["MFC_BRCH_NO"];	//생산자 직매장/공장 번호
		input["CTNR_SE"] 			= item["CTNR_SE"];			//빈용기명 구분 구/신
		input["PRPS_CD"] 			= item["PRPS_CD"];			//빈용기명  유흥/가정/공병/직접 
		input["RTN_DT"] 				= item["RTN_DT"];			//반환일자 
       	ajaxPost(url, input, function(rtnData) {
    			if ("" != rtnData && null != rtnData) {   
    				 ctnr_nm = rtnData.ctnr_nm
    				 kora.common.setEtcCmBx2(rtnData.brch_dtssList, "","", $("#MFC_BRCH_NM"), "MFC_BRCH_ID_NO", "MFC_BRCH_NM", "N" ,'S');		//반환대상 직매장/공장		
    				 kora.common.setEtcCmBx2(rtnData.ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');										//빈용기	
    			}else{
					alertMsg("error");
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
	  
  	//양식다운로드
     function fn_excelDown() {
    	 downForm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
     	 downForm.submit();
     };
     
     /**
      * 엑셀 업로드 후처리
      */
     function fn_popExcel(rtnData) {
     	gridRoot.removeAll();
     	var input  	= {};
     	var ctnrCd 	= "";
     	var url 		= "/CE/EPCE2910131_197.do";
     	var flag 		= false;
     	var dup_cnt 		= 0;		//동일한 용기코드 + 생산자 + 지사가 있을경우
    	var err_cnt 			= 0;		//잘못된 데이터로 디비 정보가 없을 경우
    	var err_msg="";
    	var err_msg2="";
    	var arr3 =new Array();
    	var arr4 =new Array();
		arr		=[];
		arr 	= $("#ENP_NM").val().split(";"); 
		arr2 	= [];
		arr2	= $("#BRCH_NM").val().split(";");
    	
    	 for(var i=0; i<rtnData.length ;i++) {
    		 if(	rtnData[i].반환일자 =="" ||
    			rtnData[i].생산자사업자번호 =="" ||	
    			rtnData[i].직매장공장번호 =="" ||
    			rtnData[i].빈용기코드 =="" ||
    			rtnData[i].반환량 =="" ||
    			rtnData[i].상자 =="" ||
    			rtnData[i].차량번호 =="" ){
    			alertMsg("필수입력값이 없습니다.")
    			return;
    		 }
    	 }
     	 for(var i=0; i<rtnData.length ;i++) {
     		 
     		flag= false
     		input["CUST_BIZRID"]		=	arr[0];											//도매업자 사업자아이디
     		input["CUST_BIZRNO"]		=	arr[1];											//도매업자 사업자 번호
     		input["CUST_BRCH_ID"]	=	arr2[0];										//도매업자지점 아이디
     		input["CUST_BRCH_NO"]	=	arr2[1];										//도매업자지점 번호
     		input["MFC_BIZRNO"]		=	rtnData[i].생산자사업자번호			//생산자 사업자번호
     		input["MFC_BRCH_NO"]	=	rtnData[i].직매장공장번호				//생산자 직매장 번호
     		input["RTN_DT"]				=	rtnData[i].반환일자						//반환일자
     		if(!kora.common.fn_validDate_ck( "R", input["RTN_DT"])){ 			//등록일자제한 체크
    			return;
    		} 
     		input["CTNR_CD"]				=	rtnData[i].빈용기코드						//빈용기코드
     		input["RTN_QTY"]				=	rtnData[i].반환량							//반환량
     		
     		if(rtnData[i].상자 ==""){
     			input["BOX_QTY"]				=	"0";										//상자
     		}else{
     			input["BOX_QTY"]				=	rtnData[i].상자							//상자	
     		}
     		input["CAR_NO"]				=	rtnData[i].차량번호						//차량번호
     		input["BIZR_TP_CD"]			=	$("#WHSL_SE_CD").val();				//도매업자구분
     		input["SYS_SE"]				= 'W';											//시스템구분	
			input["RTN_STAT_CD"]		= 'RG';											//반환상태코드
			input["PARAM_BTN_CD"]	= 'btn_excel_reg';								//버튼 코드
     		ajaxPost(url, input, function(rtnData) {
    				if ("" != rtnData && null != rtnData) {   
	    					if(rtnData.selList != undefined && rtnData.selList != null && rtnData.selList.length !=0){	// 쿼리상 데이터가 있을경우에만
	    							var collection = gridRoot.getCollection();  //그리드 데이터
	    							for(var i=0; i<collection.getLength(); i++) {
	    								var tmpData = gridRoot.getItemAt(i);
								    	if(tmpData["CTNR_CD"] == rtnData.selList[0].CTNR_CD // 쿼리상 데이터는 있지만 동일한용기코드가 있을경우.
								    			&& tmpData["MFC_BIZRNM_CD"] == rtnData.selList[0].MFC_BIZRNM_CD 
								    			&& tmpData["MFC_BRCH_NM_CD"] == rtnData.selList[0].MFC_BRCH_NM_CD  
								    			&& tmpData["CAR_NO"] == rtnData.selList[0].CAR_NO 
								    			&& tmpData["RTN_DT"] == rtnData.selList[0].RTN_DT 
								    	) {
								    			flag =true;
								    			arr3[dup_cnt]=input["MFC_BIZRNO"]+" ," +input["MFC_BRCH_NO"]+" ,"+input["RTN_DT"]+" ,"+input["CTNR_CD"];
								    			dup_cnt++;
										}
								    }	//end of for
									if(!flag)gridRoot.addItemAt(rtnData.selList[0]);	
	    					}else{// 쿼리상 데이터가 없을경우
	    						arr4[err_cnt]=input["MFC_BIZRNO"]+" ," +input["MFC_BRCH_NO"]+" ,"+input["RTN_DT"]+" ,"+input["CTNR_CD"];
	    						err_cnt++;
	    					}
	    					
    				}else{
						alertMsg("error");
    				}
    		},false);  
     	 }
     	 
     		err_msg = dup_cnt+" 개의 동일한 정보를 제외하고 등록 하였습니다. \n"  ;
     		err_msg2 =err_cnt+" 개의 확인되지 않은 정보가 등록 제외되었습니다.\n" ;
     
	     	if(dup_cnt >0 && err_cnt >0){
	     		alertMsg(err_msg+"\n"+err_msg2+"\n등록 정보를 다시 확인해주시기 바랍니다.");
	        }else if(dup_cnt >0){
	        	alertMsg(err_msg+"\n등록 정보를 다시 확인해주시기 바랍니다.");
     		}else if(err_cnt >0){
     			alertMsg(err_msg2+"\n등록 정보를 다시 확인해주시기 바랍니다." );
     		}
	     	
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
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" horizontalScrollPolicy="on" sortableColumns="true"   headerHeight="35">');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridColumn dataField="index" 				 headerText="'+ parent.fn_text('sn')+ '" itemRenderer="IndexNoItem" textAlign="center" width="50"  />');			//순번
			layoutStr.push('			<DataGridColumn dataField="RTN_DT"			 headerText="'+ parent.fn_text('rtrvl_dt')+ '"  		width="120"  textAlign="center"   formatter="{datefmt2}"/>'); 	//반환일자
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM" 	 headerText="'+ parent.fn_text('mfc_bizrnm')+ '"   width="150"  textAlign="center"	 />');									//생산자
			layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_NM" headerText="'+ parent.fn_text('mfc_brch_nm')+ '" width="200"  textAlign="center"  />');									//직매장/공장
			layoutStr.push('			<DataGridColumn dataField="PRPS_NM"  		 headerText="'+ parent.fn_text('prps_cd')+ '" 		width="100" 	textAlign="center"  />');									//용도(유흥용/가정용)
			layoutStr.push('			<DataGridColumn dataField="STANDARD_NM"  	 	 headerText="용기구분" 		width="120"  	textAlign="left" />');									//빈용기명
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM"  	 	 headerText="'+ parent.fn_text('ctnr_nm')+ '" 		width="250"  	textAlign="left" />');									//빈용기명
			layoutStr.push('			<DataGridColumn dataField="CTNR_CD" 		 headerText="'+ parent.fn_text('cd')+ '" 				width="80" 	textAlign="center" />');									//코드
			layoutStr.push('			<DataGridColumn dataField="CPCT_NM"  		 headerText="'+ parent.fn_text('cpct_cd')+'(ml)'+'" width="120" 	textAlign="center"  />');									//용량(ml)
			layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('qty')+ '">');																																								//수량
			layoutStr.push('				<DataGridColumn dataField="BOX_QTY" 	 headerText="'+ parent.fn_text('box_qty')+ '" 		width="70"  textAlign="right"    formatter="{numfmt}" id="num1"  />');	//상자
			layoutStr.push('				<DataGridColumn dataField="RTN_QTY" 		 headerText="'+ parent.fn_text('btl')+ '"				width="70"  textAlign="right"    formatter="{numfmt}" id="num2" />');	//병
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cntr')+ parent.fn_text('dps')+'">');																																	//빈용기보증금(원)																		
			layoutStr.push('				<DataGridColumn dataField="RTN_GTN_UTPC"   	headerText="'+ parent.fn_text('utpc')+ '" 		width="80"	 	textAlign="right"  formatter="{numfmt}"  />');					//단가
			layoutStr.push('				<DataGridColumn dataField="RTN_GTN" 			headerText="'+ parent.fn_text('amt')+ '"		width="100"	textAlign="right"  formatter="{numfmt}" id="num3"  />');	//금액
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cntr')+' '+ parent.fn_text('std_fee')+'">');																																				//빈용기 취급수수료(원
			layoutStr.push('				<DataGridColumn dataField="RTN_WHSL_FEE_UTPC"   	headerText="'+ parent.fn_text('utpc')+ '" 			width="80" 	textAlign="right"  formatter="{numfmt}" />');							//단가
			layoutStr.push('				<DataGridColumn dataField="RTN_WHSL_FEE"				headerText="'+ parent.fn_text('whsl_fee2')+ '" 	width="150" 	textAlign="right"  formatter="{numfmt1}"	id="num4"   />'); 	//도매수수료
			layoutStr.push('				<DataGridColumn dataField="RTN_RTL_FEE_UTPC"   		headerText="'+ parent.fn_text('utpc')+ '" 			width="80"		textAlign="right"  formatter="{numfmt}"  />');							//단가
			layoutStr.push('				<DataGridColumn dataField="RTN_RTL_FEE" 				headerText="'+ parent.fn_text('rtl_fee2')+ '" 		width="150" 	textAlign="right"  formatter="{numfmt1}"  	id="num6"/>');		//소매수수료
			layoutStr.push('				<DataGridColumn dataField="RTN_WHSL_FEE_STAX"  	headerText="'+ parent.fn_text('stax')+ '"	width="150" 	textAlign="right"  formatter="{numfmt}" 	id="num5"	     />');	//부가세
			layoutStr.push('			</DataGridColumnGroup>');
			layoutStr.push('			<DataGridColumn dataField="AMT_TOT"	headerText="'+ parent.fn_text('amt_tot')+ '"		width="150" 	textAlign="right"		 formatter="{numfmt1}" 	id="num8"  />');	//금액합계(원)
			layoutStr.push('			<DataGridColumn dataField="RMK_C"		headerText="'+ parent.fn_text('rmk')+ '"			width="150" 	textAlign="center"	 />');													//비고
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNM_CD"  	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_NM_CD"	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="CAR_NO"    				visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="CUST_BIZRID"  			visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNO"			visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="CUST_BRCH_ID"    		visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="CUST_BRCH_NO"    	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRID"  			visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="MFC_BIZRNO"			visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_ID"    		visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="MFC_BRCH_NO"    		visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="PRPS_CD"    				visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="BIZR_TP_CD"    			visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="RMK"    					visible="false" />');
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
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" 	textAlign="right"/>');	//상자
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" 	textAlign="right"/>');	//병
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" 	textAlign="right"/>');	//금액
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt1}" 	textAlign="right"/>');	//도매수수료
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt1}" 	textAlign="right"/>');	//소매수수료
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt}" 	textAlign="right"/>');	//부가세
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num8}" formatter="{numfmt1}" 	textAlign="right"/>');	//합계
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
		gridApp.setData();
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
width: 31%;
} 
.srcharea .row .col .tit{
width: 90px;
}
.srcharea .row .box{
width: 61%
}
.srcharea .row .box  select, #s2id_ENP_NM{
    width: 100%
}
</style>

</head>
<body>
    <div class="iframe_inner"  >
			<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="whsl_se_cd_list" value="<c:out value='${whsl_se_cd}' />" />
			<input type="hidden" id="ctnr_se_list" value="<c:out value='${ctnr_se}' />" />
			<input type="hidden" id="rmk_list" value="<c:out value='${rmk_list}' />" />
			<input type="hidden" id="rtc_dt_list" value="<c:out value='${rtc_dt_list}' />" />
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
				<div class="singleRow">
				<div class="btn" id="UR"></div>
				</div>
				
				<!--btn_dwnd  -->
				<!--btn_excel  -->
			</div>
			   
			<section class="secwrap">
				<div class="srcharea" id="whsl_info"> 
				<div class="row">
						<div class="col">
							<div class="tit" id="whsl_se_cd"></div>  <!--도매업자 구분 -->
							<div class="box">
								<select id="WHSL_SE_CD" style="" ></select>
							</div>
						</div>
						
						<div class="col">
							<div class="tit" id="enp_nm"></div>  <!-- 업체명 -->
							<div class="box">
								<select id="ENP_NM" style="" "></select>
							</div>
						</div>
				
					    <div class="col">
							<div class="tit" id="brch"></div>  <!-- 지점 -->
							<div class="box">
								<select id="BRCH_NM" style="" ></select>
							</div>
						</div>  
					</div> <!-- end of row -->
				</div>
		</section>
		<section class="secwrap mt10" >
				<div class="srcharea" id="divInput" > 
					<div class="row">
						<div class="col">
							<div class="tit" id="rtrvl_dt"></div>  <!-- 반환일자 -->
							<div class="box">
								<div class="calendar">
								<input type="text" id="RTN_DT"  style="" class="i_notnull" > <!--시작날짜  -->
							</div>
							</div>
						</div>
						
						<div class="col">
							<div class="tit" id="rtrvl_trgt_mfc_bizrnm"></div>  <!--반환대상생산자-->
							<div class="box">
								<select id="MFC_BIZRNM" style="" class="i_notnull" ></select>
							</div>
						</div>
				
					    <div class="col">
							<div class="tit" id="rtrvl_trgt_mfc_brch_nm" style="width: 120px"></div>  <!-- 반환대상 직매장/공장 -->
							<div class="box" style="width: 52%">
								<select id="MFC_BRCH_NM" style="" class="i_notnull" ></select>
							</div>
						</div>
					</div> <!-- end of row -->
					
					<div class="row">
						<div class="col">
							<div class="tit" id="ctnr_se"></div>  <!-- 빈용기구분 -->
							<div class="box">
								<select id="CTNR_SE" style="width: 36%" class="i_notnull" ></select>
								<select id="PRPS_CD" style="width: 61%" class="i_notnull" ></select>
							</div>
						</div>
						
						<div class="col" >
							<div class="tit" id="ctnr_nm"></div>  <!-- 빈용기명 -->
							<div class="box" >
								<select id="CTNR_CD" style="" class="i_notnull" ></select>
							</div>
						</div>
						<div class="col">
							<div class="tit"  style="width: 120px">소매수수료 적용여부</div>  
							<div class="box" id="RMK_LIST" style="width: 52%">   
								<label class="rdo"><input type="radio" id="select_rtl1" name="select_rtl" value="aplc"  checked="checked"><span id="">적용</span></label>
								<label class="rdo"><input type="radio" id="select_rtl2" name="select_rtl" value="ext"  ><span id="">제외</span></label>
							</div>
						</div>
					</div> <!-- end of row -->
					<div class="row">
						<div class="col">
							<div class="tit" id="rtn_qty"></div>  <!-- 반환량(개) -->
							<div class="box">
							<!-- 	  <input type="text"  id="RTN_QTY" style="width: 179px"  class="i_notnull"  onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)'  maxlength="8"/> -->
								  <input type="text"  id="RTN_QTY" style="text-align:right"  class="i_notnull"  format="minus"  maxlength="8"/>
							</div>
						</div>
						
						<div class="col">
							<div class="tit" id="box_qty"></div>  <!-- 상자 -->
							<div class="box">
								<input type="text"  id="BOX_QTY" style="text-align:right" format="minus"  maxlength="8"/>
							</div>
						</div>
						
						<div class="col">
							<div class="tit" id="car_no" style="width:120px"></div>  <!-- 차량번호 --> 
							<div class="box" style="width: 52%">
								<input type="text"  id="CAR_NO" style="" maxByteLength="30" class="i_notnull" />
							</div>
						</div>
					</div> <!-- end of row -->
					<div class="row">
						<div class="col" style="width:80%">
							<div class="tit" >비고</div>  <!-- 비고 -->
							<div class="box" >
									<select id="RMK_SELECT" style="width: 179px"  disabled="disabled"></select>
									<input type="text"  id="RMK" style="width: 250px" maxByteLength="30"  disabled="disabled" />
							</div>
						</div>
					</div> <!-- end of row -->
					<div style="float:right ;margin-top: 10px" id="CR" ></div>
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
					&nbsp;&nbsp;※ 반환정보는 거래처로 등록되어 있는 생산자의 직매장/공장에 대해서만 가능하며, 거래처 정보 등록은 생산자만 가능합니다.<br/>
	                &nbsp;&nbsp;※ 자료를 입력 후 행추가 버튼을 클릭하여 저장할 자료를 여러건 입력한 후 저장 버튼을 클릭하여 여러건을 동시에 저장 합니다
				</h5>
			</div>
			
		<section class="btnwrap" style="" >
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
		
		
</div>

<form name="downForm" id="downForm" action="" method="post">
	<input type="hidden" name="fileName" value="RTN_INFO_EXCEL_FORM.xlsx" />
	<input type="hidden" name="downDiv" value="" /> <!-- 공지사항 첨부 다운일경우 noti, 업로드 폴더인경우 up 로 넣어준다-->
</form>

</body>
</html>