<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>반환수집소내역작성</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script src="/js/kora/paging_common.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />
<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS;	//파라미터 데이터
     var whsl_se_cd; 		//도매업자구분
     var ctnr_se;			//빈용기구분  구병 신병 
	 var rmk_list;     		//소매수수료 적용여부 비고
	 var whsdlList;//도매업자 업체명 조회
	 var rcsList;
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
	 var cpctCdList;        //용량코드
	 var AreaCdList;
	 
     $(function() {
    	 
    	INQ_PARAMS 		= jsonObject($("#INQ_PARAMS").val());	//파라미터 데이터
    	//console.log(INQ_PARAMS);
    	whsl_se_cd 			= jsonObject($("#whsl_se_cd_list").val());	//도매업자 구분
    	ctnr_se 				= jsonObject($("#ctnr_se_list").val());		//빈용기 구분
    	rmk_list				= jsonObject($("#rmk_list").val());				//비고	
    	rtc_dt_list 			= jsonObject($("#rtc_dt_list").val());			//등록일자제한설정	
    	whsdlList = jsonObject($("#whsdlList").val());//도매업자 업체명 조회
    	rcsList  = jsonObject($("#rcsList").val());
    	cpctCdList      = jsonObject($("#cpctCdList").val());      
   	   AreaCdList = jsonObject($('#AreaCdList').val());
    	
    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
    	 //그리드 셋팅
		 fnSetGrid1();
		 
		//날짜 셋팅
  	    $('#RTRVL_DT').YJcalendar({  
 			triggerBtn : true,
 			dateSetting: toDay.replaceAll('-','')
 			});
		
		//text 셋팅
		$('#title_sub').text('<c:out value="무인회수기내역작성" />');						  //타이틀
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
		 $("#RTRVL_DT").attr('alt',parent.fn_text('rtrvl_dt'));   
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
/* 		$("#PRPS_CD").change(function(){
			fn_prps_cd();
		}); */
		
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
		$("#RTRVL_DT").click(function(){
			    var rtn_dt = $("#RTRVL_DT").val();
			    rtn_dt   =  rtn_dt.replace(/-/gi, "");
			     $("#RTRVL_DT").val(rtn_dt)
		});
		
		/************************************
		 * 시작날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
/* 		$("#RTRVL_DT").change(function(){
			
		     var rtn_dt = $("#RTRVL_DT").val();
		     rtn_dt   =  rtn_dt.replace(/-/gi, "");
			if(rtn_dt.length == 8)  rtn_dt = kora.common.formatter.datetime(rtn_dt, "yyyy-mm-dd")
		     $("#RTRVL_DT").val(rtn_dt) 
		      if($("#RTRVL_DT").val() !=flag_DT){ //클릭시 날짜 변경 할경우   기존날짜랑 현재날짜랑 다를 경우  데이터 초기화
		     	 flag_DT = $("#RTRVL_DT").val();  //변경시 날짜 
				 kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'S'); 	//반환대상 생산자
		    	 kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");											//빈용기구분
				 kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'S');					//반환대상 직매장/공장
		    	// kora.common.setEtcCmBx2(ctnr_seList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S'); 								//빈용기구분 코드
				 kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');		
		     } 
		}); */
		
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
			
		   if( $("#RCS_NM").val()=="" ){
				alertMsg("반환수집소를 선택 해주세요");
				return;
			}else{
				/* $("#WHSL_SE_CD").prop("disabled",true);
				$("#ENP_NM").prop("disabled",true);
				$("#BRCH_NM").prop("disabled",true);  */
				
				/* whsl_chk[0] =$("#WHSL_SE_CD").val();
				whsl_chk[1] =$("#ENP_NM").val();
				whsl_chk[2] =$("#BRCH_NM").val(); */
				kora.common.gfn_excelUploadPop("fn_popExcel");
			}
		});
		
  		fn_init();
    	//kora.common.setEtcCmBx2(whsl_se_cd, "","", $("#WHSL_SE_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');			//도매업자구분
    	$("#ENP_NM").select2();
	});
     //초기화
     function fn_init(){
    	if(regGbn){
	    	 kora.common.setEtcCmBx2([], "","", $("#ENP_NM"), "ETC_CD", "ETC_CD_NM", "N" ,'S');							//업체명
			 kora.common.setEtcCmBx2([], "","", $("#BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S');						//지점
    	}
    	
    	//kora.common.setEtcCmBx2(cpctCdList, "","", $("#CPCT_CD"), "ETC_CD", "ETC_CD_NM", "N","T");
    	kora.common.setEtcCmBx2(AreaCdList, "", "", $("#AreaCdList_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
    	
    	kora.common.setEtcCmBx2(whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');//도매업자 업체명
    	
    	kora.common.setEtcCmBx2(rcsList, "","", $("#RCS_NM"), "RCS_NO", "RCS_NM", "N" ,'S');
    	
		kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'S');		//반환대상 생산자
		kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'S');	//반환대상 직매장/공장
		//kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");							//빈용기구분
		//kora.common.setEtcCmBx2(ctnr_seList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');				//빈용기구분 코드
		kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');							//빈용기명
		//kora.common.setEtcCmBx2(rmk_list, "","", $("#RMK_SELECT"), "ETC_CD", "ETC_CD_NM", "N" ,'S');					//비고
		$('#RTRVL_DT').val(kora.common.formatter.datetime(toDay, "yyyy-mm-dd"));
		flag_DT = $("#RTRVL_DT").val(); 
		$("#BOX_QTY").val("");
		$("#RTN_QTY").val("");
		$("#CAR_NO").val("");
    	$("#RMK").val("");
		$("#select_rtl1").prop("checked", true)
		$("#RMK_SELECT").prop("disabled",true);
    	$("#RMK").prop("disabled",true);
    	//도매업자  검색
  		$("#WHSDL_BIZRNM").select2();
  		$("#RCS_NM").select2();
  		
  		if(rcsList[0] == null){
			alert('수집소 내역작성이 불가능한 공병상입니다.');
			location.href = "/WH/EPWH9000301.do";
		}
     }
     
   //autoComplete 도매업자 멀티 SELECTBOX
     function fn_autoCompleteSelected(data){
     	acSelected = new Array();
     	if(data.length>0){
     		for(var i =0;i<data.length ;i++){
    				var input={};
 			    input["RCS_NO"]	=data[i].value
 				input["RCS_NM"] 		=data[i].text;
 				acSelected.push(input);
     		}	 
     	}
     }
     
   //도매업자구분 변경시
     function fn_whsl_se_cd(){
    	var url = "/WH/EPWH2910131_19.do" 
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
 		var url = "/WH/EPWH2910131_192.do" 
		var input ={};
 		if($("#ENP_NM").val() !=""){
 			arr=[];
		   	//arr = $("#ENP_NM").val().split(";"); 
		   	//input["BIZRID"] 	= arr[0];
		   	//input["BIZRNO"] 	= arr[1];
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
 		var url = "/WH/EPWH2910131_193.do" 
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
  		var url = "/WH/EPWH2910131_194.do" 
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
   	    
        var url = "/WH/EPWH2910131_198.do" 
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
		var url = "/WH/EPWH2910131_195.do" 
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
				input["RTRVL_DT"] 				= $("#RTRVL_DT").val(); 	//반환일자 
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
		
		
		/* if(!kora.common.fn_validDate($("#RTRVL_DT").val())){   
			alertMsg("올바른 날짜 형식이 아닙니다.");
			return;
		} */

		 if(kora.common.format_noComma(kora.common.null2void($("#RCS_NM").val(),0))  < 1) {
            alertMsg("반환수집소을(를) 선택하십시요.", "kora.common.cfrmDivChkValid_focus");
            chkTarget = $("#RCS_NM");
            
            return;
        } 
		
		 if(kora.common.format_noComma(kora.common.null2void($("#CPCT_CD").val(),0))  < 1) {
	            alertMsg("용량(신/구병)을(를) 선택하십시요.", "kora.common.cfrmDivChkValid_focus");
	            chkTarget = $("#CPCT_CD");
	            
	            return;
	       }
		 
		 if(kora.common.format_noComma(kora.common.null2void($("#RTN_QTY").val(),0))  < 1) {
	            alertMsg("회수량을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	            chkTarget = $("#RTN_QTY");
	            
	            return;
	        } 
		 
		/*  if(kora.common.format_noComma(kora.common.null2void($("#RTN_GTN").val(),0))  < 1) {
	            alertMsg("보증금을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	            chkTarget = $("#RTN_GTN");
	            
	            return;
	        }  */

		if(!kora.common.cfrmDivChkValid("divInput")) {
			return;
		}
        /* if(kora.common.format_noComma(kora.common.null2void($("#BOX_QTY").val(),0))  < 1) {
            alertMsg("상자를 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
            chkTarget = $("#BOX_QTY");
            
            return;
        } */

		/* if( $("#WHSL_SE_CD").val()      !=""   && $("#ENP_NM").val()     != ""   && $("#BRCH_NM").val()  != ""  ) {
			$("#WHSL_SE_CD").prop("disabled",true);
			$("#ENP_NM").prop("disabled",true);
			$("#BRCH_NM").prop("disabled",true);
			whsl_chk[0] =$("#WHSL_SE_CD").val();
			whsl_chk[1] =$("#ENP_NM").val();
			whsl_chk[2] =$("#BRCH_NM").val();
        } */
		
		

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
		}
		 if(kora.common.format_noComma(kora.common.null2void($("#RCS_NM").val(),0))  < 1) {
	            alertMsg("반환수집소을(를) 선택하십시요.", "kora.common.cfrmDivChkValid_focus");
	            chkTarget = $("#RCS_NM");
	            
	            return;
	        } 
			
			 if(kora.common.format_noComma(kora.common.null2void($("#CPCT_CD").val(),0))  < 1) {
		            alertMsg("용량(신/구병)을(를) 선택하십시요.", "kora.common.cfrmDivChkValid_focus");
		            chkTarget = $("#CPCT_CD");
		            
		            return;
		       }
			 
			 if(kora.common.format_noComma(kora.common.null2void($("#RTN_QTY").val(),0))  < 1) {
		            alertMsg("회수량을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
		            chkTarget = $("#RTN_QTY");
		            
		            return;
		        } 
			 
			 /* if(kora.common.format_noComma(kora.common.null2void($("#RTN_GTN").val(),0))  < 1) {
		            alertMsg("보증금을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
		            chkTarget = $("#RTN_GTN");
		            
		            return;
		        }  */
		/* if(idx < 0) {
			alertMsg("변경할 행을 선택하시기 바랍니다.");
			return;
		}else if(!kora.common.cfrmDivChkValid("divInput")) {	//필수값 체크
			return;
		}else if(!kora.common.fn_validDate($("#RTRVL_DT").val())){ 
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
        } */
		
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
		var mfc_bizrnm_cd = $("#MFC_BIZRNM").val();
		var mfc_brch_nm_cd = $("#MFC_BRCH_NM").val();
	   
	    var rtl_fee_select = $("input[type=radio][name=select_rtl]:checked").val();//수수료적용여부  라디오체크여부
		
		input["RTRVL_DT"] 					=	$("#RTRVL_DT").val().replaceAll('-','');		
		input["WHSDL_BIZRNM"] 					=	$("#WHSDL_BIZRNM").val();
		input["RCS_NM"] 					=	$("#RCS_NM option:selected").text()
		input["AREA_CD"] 					=	$("#AreaCdList_SEL option:selected").val();		
		var cpct_cd =$("#CPCT_CD option:selected").val();
		input["CPCT_CD"] 					=	cpct_cd;		
		//회수량*보증금단가
		var tmp_pay;
		if(cpct_cd == 13){
			tmp_pay = 70; 
		}else if(cpct_cd == 23){
			tmp_pay = 100; 
		}else if(cpct_cd == 33){
			tmp_pay = 130; 
		}else if(cpct_cd == 43){
			tmp_pay = 350; 
		}else{
			tmp_pay = 0;
		}
		input["RTN_GTN"] 					=	$("#RTN_QTY").val() * tmp_pay;
		input["RTN_QTY"] 					=	$("#RTN_QTY").val();
		input["LOC_GOV"] 					=	$("#LOC_GOV").val();
		
		input["PRPS_CD"] 					=	$("#PRPS_CD option:selected").val();		
		input["PRPS_NM"] 					=	$("#PRPS_CD option:selected").text();
		input["CPCT_NM"] 					=	$("#CPCT_CD option:selected").text();		
		return input;
	};	
	
	//등록
	function fn_reg(){
		
		var collection = gridRoot.getCollection();  //그리드 데이터
		if (collection.getLength() <1){
			alertMsg("데이터를 입력해주세요")
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
		var url = "/WH/EPWH9000331_09.do"; 
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
					}else if(rtnData.RSLT_CD =="1111"){
						alertMsg("해당 반환수집소 계약일 내의 회수 일자만 선택 가능합니다. ");
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
   	 kora.common.goPageB('/WH/EPWH9000301.do', INQ_PARAMS);
    }
	
	//선택한 행 입력창에 값 넣기
	function fn_rowToInput (rowIndex){
		
		var item = gridRoot.getItemAt(rowIndex);
		//fn_dataSet(item);
		$("#SERIAL_NO").val(item["SERIAL_NO"]);
		$("#RTRVL_DT").val(item["RTRVL_DT"]);
		$("#REG_SN").val(item["REG_SN"]);    
		$("#AreaCdList_SEL").val( item["AREA_CD"]).prop("selected", true);	//직매장/공장
		$("#CPCT_CD").val(item["CPCT_CD"]).prop("selected", true);   						//빈용기명 구분
		$("#RTN_GTN").val(item["RTN_GTN"]);
		$("#RTN_QTY").val(item["RTN_QTY"]);
	
		//소매수수료 적용여부----------
		/* if(item["RMK"] !=undefined){//비고가 있을경우 
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
		} */
		//-------------------------------------------
	};
	function fn_dataSet(item){
		var input	={};
		var url 	 	= "/WH/EPWH2910131_196.do"; 
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
		input["RTRVL_DT"] 				= item["RTRVL_DT"];			//반환일자 
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
     	var url 		= "/WH/EPWH9000331_197.do";
     	var flag 		= false;
     	var dup_cnt 		= 0;		//동일한 용기코드 + 생산자 + 지사가 있을경우
    	var err_cnt 			= 0;		//잘못된 데이터로 디비 정보가 없을 경우
    	var err_msg="";
    	var err_msg2="";
    	var arr3 =new Array();
    	var arr4 =new Array();
		arr		=[];
		//arr 	= $("#ENP_NM").val().split(";"); 
		arr2 	= [];
		//arr2	= $("#BRCH_NM").val().split(";");
    	
    	 for(var i=0; i<rtnData.length ;i++) {
    		 if(	
    			rtnData[i].회수일자 =="" ||	
    			rtnData[i].회수량 =="" ||
    			rtnData[i].용량 =="" ||
    			rtnData[i].용도 =="" ||
    			rtnData[i].보증금 =="" ){
    			alertMsg("필수입력값이 없습니다.")
    			return;
    		 }
    	 }
     	 for(var i=0; i<rtnData.length ;i++) {
     		flag= false
     		input["RTRVL_DT"]		=	rtnData[i].회수일자;											//도매업자 사업자 번호
     		input["RCS_NM"] 					=	$("#RCS_NM option:selected").text()
     		input["RTN_QTY"]				=	rtnData[i].회수량;					
     		input["CPCT_CD"]		=	rtnData[i].용량;			
     		input["PRPS_CD"]	=	rtnData[i].용도;								
     		input["RTN_GTN"]	=	rtnData[i].보증금;				
     		if(!kora.common.fn_validDate_ck( "R", input["RTRVL_DT"])){ 			//등록일자제한 체크
    			return;
    		} 
     		arr3=input;
     		//gridRoot.addItemAt(input);
			//input["PARAM_BTN_CD"]	= 'btn_excel_reg';								//버튼 코드
     		ajaxPost(url, input, function(rtnData) {
     			gridRoot.addItemAt(rtnData.selList[0]);	
    				/*  if ("" != rtnData && null != rtnData) {
    					alert("@1");
	    					if(rtnData.selList != undefined && rtnData.selList != null && rtnData.selList.length !=0){	// 쿼리상 데이터가 있을경우에만
	    						alert("@2");
	    							var collection = gridRoot.getCollection();  //그리드 데이터
	    							for(var i=0; i<collection.getLength(); i++) {
	    								alert("@3");
	    								var tmpData = gridRoot.getItemAt(i);
								    	if(tmpData["CTNR_CD"] == rtnData.selList[0].CTNR_CD // 쿼리상 데이터는 있지만 동일한용기코드가 있을경우.
								    			&& tmpData["MFC_BIZRNM_CD"] == rtnData.selList[0].MFC_BIZRNM_CD 
								    			&& tmpData["MFC_BRCH_NM_CD"] == rtnData.selList[0].MFC_BRCH_NM_CD  
								    			&& tmpData["CAR_NO"] == rtnData.selList[0].CAR_NO 
								    			&& tmpData["RTRVL_DT"] == rtnData.selList[0].RTRVL_DT 
								    	) {
								    		alert("@5");
								    			flag =true;
								    			arr3[dup_cnt]=input["MFC_BIZRNO"]+" ," +input["MFC_BRCH_NO"]+" ,"+input["RTRVL_DT"]+" ,"+input["CTNR_CD"];
								    			dup_cnt++;
										}
								    }	//end of for
									if(!flag)gridRoot.addItemAt(rtnData.selList[0]);	
	    					}else{// 쿼리상 데이터가 없을경우
	    						alert("@6");
	    						arr4[err_cnt]=input["MFC_BIZRNO"]+" ," +input["MFC_BRCH_NO"]+" ,"+input["RTRVL_DT"]+" ,"+input["CTNR_CD"];
	    						err_cnt++;
	    					}
	    					
    				}else{
    					alert("@7");
						alertMsg("error");
    				}  */
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
			//layoutStr.push('			<DataGridSelectorColumn id="selector" width="40" textAlign="center" allowMultipleSelection="true" vertical-align="middle"  draggable="false"/>');//선택 
			//layoutStr.push('			<DataGridColumn dataField="REG_SQ" headerText="번호" textAlign="center" width="50" draggable="false"/>');//순번
			layoutStr.push('			<DataGridColumn dataField="RTRVL_DT" headerText="회수일자"  textAlign="center" width="300"  />');//반환문서번호
			//layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRNM" headerText="관리업체" textAlign="center" width="200"/>');
			layoutStr.push('			<DataGridColumn dataField="RCS_NM" headerText="반환수집소"  textAlign="center" width="300"  />');//도매업자구분
			//layoutStr.push('			<DataGridColumn dataField="AREA_CD" headerText="지역" textAlign="center" width="200" />');//상태
			layoutStr.push('			<DataGridColumn dataField="RTN_QTY" headerText="회수량" width="300" formatter="{numfmt}" id="num8"  textAlign="right" />');//회수량
			layoutStr.push('			<DataGridColumn dataField="CPCT_NM" headerText="용량(신구병)" visible="false"  textAlign="center" width="200" />');
			layoutStr.push('			<DataGridColumn dataField="CPCT_CD" headerText="용량(신구병)"  textAlign="center" width="200" />');
			layoutStr.push('			<DataGridColumn dataField="PRPS_NM" headerText="용도" textAlign="center" visible="false" width="200" />');//지역
			layoutStr.push('			<DataGridColumn dataField="PRPS_CD" headerText="용도" textAlign="center" width="200" />');//지역
			layoutStr.push('			<DataGridColumn dataField="RTN_GTN" headerText="보증금" width="300" formatter="{numfmt}" id="num5" textAlign="right" />');//보증금
			//layoutStr.push('			<DataGridColumn dataField="STAT_NM" headerText="등록구분" textAlign="center" width="200" />');
			//layoutStr.push('			<DataGridColumn dataField="RTRVL_FEE" headerText="취급수수료" width="150" formatter="{numfmt}" id="num6"  textAlign="right" />');//도매수수료
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			//layoutStr.push('				<DataGridFooterColumn/>');
			//layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn label="'+parent.fn_text('totalsum')+'"  textAlign="center"/>');
			//layoutStr.push('				<DataGridFooterColumn/>');
			//layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num8}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');	
			//layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');	
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

.srcharea .row .box  select, #s2id_RCS_NM{
    width: 100%
}

.srcharea .row .col{
width: 31%;
} 
.srcharea .row .col .tit{
width: 90px;
}
.srcharea .row .box{
width: 61%
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
			<input type="hidden" id="whsdlList" value="<c:out value='${whsdlList}' />" />
			<input type="hidden" id="rcsList" value="<c:out value='${rcsList}' />" />
			<input type="hidden" id="cpctCdList" value="<c:out value='${cpctCdList}' />" />
			<input type="hidden" id="AreaCdList" value="<c:out value='${AreaCdList}' />"/>
			<div class="h3group">
				<h3 class="tit" >반환수집소내역작성</h3>
				<div class="singleRow">
					<div class="btn" id="UR">
						<a href="#self" class="btn36 c1" style="width: 150px;" id="btn_dwnd"><span class="form"></span><span class="form">양식다운로드</span></a>
						<a href="#self" class="btn36 c10" style="width: 120px; " id="btn_excel_reg"><span class="excel_register">엑셀등록</span></a>				
					</div>
				</div>
				
				<!--btn_dwnd  -->
				<!--btn_excel  -->
			</div>
			   
			<section class="secwrap">
				<div class="srcharea" id="whsl_info"> 
				<div class="row">
						<div class="col">
							<div class="tit">반환수집소</div>  <!--반환대상생산자-->
							<div class="box">
								<!-- <input type="text"  id="RCS_NM" class="i_notnull" style="x"/> -->
								<select id="RCS_NM" name="RCS_NM" style="x"></select>
							</div>
						</div>
						
					</div> <!-- end of row -->
				</div>
		</section>
		<section class="secwrap mt10" >
				<div class="srcharea" id="divInput" > 
					<div class="row">
						<div class="col">
							<div class="tit">회수일자</div>  <!-- 반환일자 -->
							<div class="box">
								<div class="calendar">
								<input type="text" id="RTRVL_DT"  style="" class="i_notnull" > <!--시작날짜  -->
							</div>
							</div>
						</div>
						<!-- <div class="col">
							<div class="tit">관리업체</div>  
							<div class="box">
								<select id="WHSDL_BIZRNM" name="WHSDL_BIZRNM" style="x"></select>
							</div>
						</div>  -->
						<div class="col">
							<div class="tit">용량(신/구병)</div>  <!-- 빈용기구분 -->
							<div class="box">
								<!-- <select id="CPCT_CD"   class="i_notnull" ></select> -->
								<select id="CPCT_CD" >
								<option value="">전체</option>
								<option class="generated" value="13">190ml미만[신병]</option>
								<option class="generated" value="23">400ml미만[신병]</option>
								<option class="generated" value="33">1000ml미만[신병]</option>
								<option class="generated" value="43">1000ml이상[신병]</option>
								<option class="generated" value="11">190ml미만</option>
								<option class="generated" value="21">400ml미만</option>
								<option class="generated" value="31">1000ml미만</option>
								<option class="generated" value="41">1000ml이상</option>
								<option class="generated" value="42">1000ml이상 (백화수복 등)</option>
							</select>
							</div>
						</div>
						<div class="col">
							<div class="tit">용도</div>  <!-- 빈용기구분 -->
							<div class="box">
								<select id="PRPS_CD"   >
									<option value="1">가정용</option>
									<option value="0">유흥용</option>
								</select>
							</div>
						</div>
						
					</div> <!-- end of row -->
						
					<div class="row">
						<!-- <div class="col">
							<div class="tit">지역</div>
							<div class="box" style="">
								<select id="AreaCdList_SEL" name="AreaCdList_SEL" style="" class="i_notnull" ></select>
							</div>
						</div> -->
						<div class="col">
							<div class="tit"  >회수량</div>  <!-- 차량번호 --> 
							<div class="box" >
								<input type="text"  id="RTN_QTY"  class="i_notnull" />
							</div>
						</div>
						
						
						<div class="col" style="display: none;">
							<div class="tit" >보증금</div>  <!-- 반환량(개) -->
							<div class="box">
								  <input type="text"  id="RTN_GTN"   />
							</div>
						</div>
						
					</div> <!-- end of row -->
					
					<div style="float:right ;margin-top: 10px" id="CR" >
						<button type="button" class="btn36 c5" style="width: 100px; margin-right: 5px;" id="btn_upd">행변경</button>
						<button type="button" class="btn36 c1" style="width: 100px; margin-right: 5px;" id="btn_del">행삭제</button>
						<button type="button" class="btn36 c2" style="width: 100px;" id="btn_reg2">행추가</button>			
					</div>
				</div>  <!-- end of srcharea -->
			</section>
			<!-- <section class="btnwrap mt20"  >
			<div style="float:right" id="CR"></div>
			</section> -->
			<div class="boxarea mt10">
				<div id="gridHolder" style="height: 560px; background: #FFF;"></div>
			</div>	<!-- 그리드 셋팅 -->
			
		<section class="btnwrap" style="">
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right; margin-top: 10px;" id="BR">
					<button type="button" class="btn36 c4" style="width: 100px;" id="btn_cnl">취소</button>
					<button type="button" class="btn36 c2" style="width: 100px;" id="btn_reg">등록</button>			
				</div>
		</section>
		
		
</div>

<form name="downForm" id="downForm" action="" method="post">
	<input type="hidden" name="fileName" value="RCS_INFO_EXCEL_FORM.xlsx" />
	<input type="hidden" name="downDiv" value="" /> <!-- 공지사항 첨부 다운일경우 noti, 업로드 폴더인경우 up 로 넣어준다-->
</form>

</body>
</html>