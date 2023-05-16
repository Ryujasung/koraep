<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>소모품등록</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script src="/js/kora/paging_common.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />
<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS;	//파라미터 데이터
// 	 var urm_fix_list;
	 
     $(function() {
    	 
    	INQ_PARAMS 		= jsonObject($("#INQ_PARAMS").val());	//파라미터 데이터
//    		urm_fix_list 		= jsonObject($("#urm_fix_list").val());
    	//console.log(urm_fix_list[0].URM_FIX_CD);
    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
    	 //그리드 셋팅
		 fnSetGrid1();
		 
	   	 
		//text 셋팅
		$('#title_sub').text('<c:out value="소모품등록" />');						  //타이틀

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
			
			/* if( $("#WHSL_SE_CD").val()=="" ||$("#ENP_NM").val()=="" ||$("#BRCH_NM").val()=="" ){
				alertMsg("도매업자 구분 ,업체명 , 지점 을 선택 해주세요");
				return;
			}else if( $("#WHSL_SE_CD").val()      !=""   && $("#ENP_NM").val()     != ""   && $("#BRCH_NM").val()  != ""  ) {
				$("#WHSL_SE_CD").prop("disabled",true);
				$("#ENP_NM").prop("disabled",true);
				$("#BRCH_NM").prop("disabled",true); */
				
				/* whsl_chk[0] =$("#WHSL_SE_CD").val();
				whsl_chk[1] =$("#ENP_NM").val();
				whsl_chk[2] =$("#BRCH_NM").val(); */
				kora.common.gfn_excelUploadPop("fn_popExcel");
			//}
		});
		
  		fn_init();
    	$("#ENP_NM").select2();
    	$("#SERIAL_NO").select2();	
	});
     //초기화
     function fn_init(){
    	
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
 		//kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");									//빈용기구분
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
  		//kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");	//빈용기구분
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
	
		 
		 if(kora.common.format_noComma(kora.common.null2void($("#URM_FIX_CD").val(),0))  < 1) {
	            alertMsg("소모품번호을(를) 선택하십시요.", "kora.common.cfrmDivChkValid_focus");
	            chkTarget = $("#URM_FIX_CD");
	            
	            return;
	        }
	
	
		 if(kora.common.format_noComma(kora.common.null2void($("#URM_EXP_NM").val(),0))  < 1) {
            alertMsg("소모품명을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
            chkTarget = $("#URM_EXP_NM");
            
            return;
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
		}
		
		 if(kora.common.format_noComma(kora.common.null2void($("#URM_FIX_CD").val(),0))  < 1) {
	            alertMsg("소모품명을(를) 선택하십시요.", "kora.common.cfrmDivChkValid_focus");
	            chkTarget = $("#URM_FIX_CD");
	            
	            return;
	        }
	
	
		 if(kora.common.format_noComma(kora.common.null2void($("#CEN_PAY").val(),0))  < 1) {
         alertMsg("센터부담금액을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
         chkTarget = $("#CEN_PAY");
         
         return;
     } 
		 
		 if(kora.common.format_noComma(kora.common.null2void($("#RET_PAY").val(),0))  < 1) {
	            alertMsg("소매점부담금액을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	            chkTarget = $("#RET_PAY");
	            
	            return;
	        } 
		 
		 if(kora.common.format_noComma(kora.common.null2void($("#TOT_PAY").val(),0))  < 1) {
	            alertMsg("총금액을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	            chkTarget = $("#TOT_PAY");
	            
	            return;
	        }

		 if(kora.common.format_noComma(kora.common.null2void($("#CUST_PAY").val(),0))  < 1) {
	            alertMsg("출고원가을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	            chkTarget = $("#CUST_PAY");
	            
	            return;
	        }
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
		var urmfixcd = $("#URM_FIX_CD").val();
		input["URM_EXP_NM"] =	$("#URM_EXP_NM").val();
		input["URM_FIX_CD"] =	$("#URM_FIX_CD").val();
		var collection = gridRoot.getCollection();  //그리드 데이터
		
		for(var i=0; i<collection.getLength(); i++) {
	 		var tmpData = gridRoot.getItemAt(i);
	    	if(tmpData["URM_FIX_CD"] == urmfixcd ) {
				if(gbn == "M") {
					if(rowIndexValue != i) {
			    		alertMsg("동일한 소모품번호가 있습니다.");
			    		return false;
			    	}
				} else {
					alertMsg("동일한 소모품번호가 있습니다.");
		    		return false;
				}
			}//end of if(gridData[i]...)
	    }
	 	
		return input;
	};	
	
	//등록
	function fn_reg(){
		
		var collection = gridRoot.getCollection();  //그리드 데이터
		if (collection.getLength() <1){
			alertMsg("데이터를 입력해주세요")
			return;
		/* }else if(	whsl_chk[0] !=$("#WHSL_SE_CD").val() || whsl_chk[1] !=$("#ENP_NM").val() || whsl_chk[2] !=$("#BRCH_NM").val()){
			alertMsg("변조된데이터 입니다");
			return; */
		}else if(0 != collection.getLength()){
			confirm("등록하시겠습니까?", 'fn_reg_exec');
		}else{
			alertMsg("등록할 자료가 없습니다.\n\n자료를 입력 후 행추가 버튼을 클릭하여 저장할 자료를 여러건 입력한 다음 등록 버튼을 클릭하세요.");
		}
		 
	}
	
	function fn_reg_exec(){
		
		var data = {"list": ""};
		var row = new Array();
		var url = "/CE/EPCE9000831_09.do"; 
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
   	 kora.common.goPageB('/CE/EPCE9000801.do', INQ_PARAMS);
    }
	
	//선택한 행 입력창에 값 넣기
	function fn_rowToInput (rowIndex){
		
		var item = gridRoot.getItemAt(rowIndex);
		//fn_dataSet(item);
		//$("#SERIAL_NO").val(item["SERIAL_NO"]);
		$("#URM_EXP_NM").val(item["URM_EXP_NM"]);
		$("#URM_FIX_CD").val(item["URM_FIX_CD"]);    
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
    	/*  downForm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken; */
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
     	var url 		= "/CE/EPCE9000831_197.do";
     	var flag 		= false;
     	var dup_cnt 		= 0;		//동일한 용기코드 + 생산자 + 지사가 있을경우
    	var err_cnt 			= 0;		//잘못된 데이터로 디비 정보가 없을 경우
    	var err_msg="";
    	var err_msg2="";
    	//var arr3 =new Array();
    	//var arr4 =new Array();
		arr		=[];
		//arr 	= $("#ENP_NM").val().split(";"); 
		arr2 	= [];
		//arr2	= $("#BRCH_NM").val().split(";");
    	//console.log(rtnData);
    	 for(var i=0; i<rtnData.length ;i++) {
    		 if(	rtnData[i].소모품명 =="" ||
    				rtnData[i].소모품번호 ==""){
    			alertMsg("필수입력값이 없습니다.")
    			return;
    		 }
    	 }
     	 for(var i=0; i<rtnData.length ;i++) {
     		flag= false
     		input["URM_EXP_NM"]		=	rtnData[i].소모품명;											//도매업자 사업자아이디
     		input["URM_FIX_CD"]		=	rtnData[i].소모품번호;											//도매업자 사업자 번호
     		/* if(!kora.common.fn_validDate_ck( "R", input["RTRVL_DT"])){ 			//등록일자제한 체크
    			return;
    		}  */
     		//arr3=input;
     		//gridRoot.addItemAt(input);
			//input["PARAM_BTN_CD"]	= 'btn_excel_reg';								//버튼 코드
     		ajaxPost(url, input, function(rtnData) {
//      			gridRoot.addItemAt(rtnData.selList[0]);	
    				  if ("" != rtnData && null != rtnData) {
	    					if(rtnData.selList != undefined && rtnData.selList != null && rtnData.selList.length !=0){	// 쿼리상 데이터가 있을경우에만
	    							var collection = gridRoot.getCollection();  //그리드 데이터
	    							for(var i=0; i<collection.getLength(); i++) {
	    								var tmpData = gridRoot.getItemAt(i);
								    	if(tmpData["URM_FIX_CD"] == rtnData.selList[0].URM_FIX_CD) // 쿼리상 데이터는 있지만 동일한용기코드가 있을경우.
								    	{
								    			flag =true;
// 								    			arr3[dup_cnt]=input["URM_FIX_CD"];
								    			dup_cnt++;
										}
								    }	//end of for
									if(!flag)gridRoot.addItemAt(rtnData.selList[0]);	
	    					}else{// 쿼리상 데이터가 없을경우
	    						alert("@6");
// 	    						arr4[err_cnt]=input["URM_FIX_CD"]
	    						err_cnt++;
	    					}
	    					
    				}else{
						alertMsg("error");
    				}  
    				
    		},false);  
     	 }
     	 
     		err_msg = dup_cnt+" 개의 동일한 정보를 제외하고 등록 하였습니다. \n"  ;
     		err_msg2 =err_cnt+" 개의 이미 등록된 정보가 등록 제외되었습니다.\n" ;
     
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
			//layoutStr.push('	<NumberMaskFormatter id="maskfmt1" formatString="###-##-#####"/>');
			layoutStr.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" horizontalScrollPolicy="on"  sortableColumns="true" headerHeight="35">');
			layoutStr.push('		<groupedColumns>');
			layoutStr.push('			<DataGridColumn dataField="URM_EXP_NM" headerText="소모품명" textAlign="center" width="500"/>');
			layoutStr.push('			<DataGridColumn dataField="URM_FIX_CD" headerText="소모품번호"  textAlign="center" width="500"  />');//도매업자구분
			layoutStr.push('		</groupedColumns>');
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

 #s2id_SERIAL_NO{
    width: 100%
}
</style>

</head>
<body>
    <div class="iframe_inner"  >
			<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
<%-- 			<input type="hidden" id="urm_fix_list" value="<c:out value='${urm_fix_list}' />" /> --%>
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
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
				<div class="srcharea"> 
				<div class="row">
<!-- 						<div class="col" style="width: 500px">
							<div class="tit" style="width: 150px">무인회수기 시리얼번호</div>  도매업자 구분
							<div class="box">
								<select id="SERIAL_NO" name="SERIAL_NO"   style="width: 250px"></select>
								<input type="text"  id="SERIAL_NO"   class="i_notnull" />
							</div>
						</div> -->
						
					<div class="col">
                        <div class="tit"">소모품명</div>    <!-- 조회기간 -->
                        <div class="box">
                       			<!-- <select id="URM_FIX_CD" name="URM_FIX_CD" style="width: 330px;">
								<option value="A01">배터리</option>
								<option value="A02">B</option>
								</select> -->
								<!-- <select id="URM_FIX_CD" name="URM_FIX_CD"   style="width: 300px"></select> -->
								<input type="text" id="URM_EXP_NM" name="URM_EXP_NM"  class="i_notnull">
<!-- 								<select id="URM_FIX_CD" name="URM_FIX_CD"   style="width: 300px"></select> -->
                        </div>
                    </div>
                        
                         <div class="col">
                        <div class="tit">소모품번호</div>    <!-- 조회기간 -->
                        <div class="box">
                       			<!-- <select id="URM_FIX_CD" name="URM_FIX_CD" style="width: 330px;">
								<option value="A01">배터리</option>
								<option value="A02">B</option>
								</select> -->
								<input type="text" id="URM_FIX_CD" name="URM_FIX_CD"  class="i_notnull">
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
			
		<section class="btnwrap" >
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right; margin-top: 10px;" id="BR">
					<button type="button" class="btn36 c4" style="width: 100px;" id="btn_cnl">취소</button>
					<button type="button" class="btn36 c2" style="width: 100px;" id="btn_reg">등록</button>
				</div>
		</section>
		
		
</div>

<form name="downForm" id="downForm" action="" method="post">
	<input type="hidden" name="fileName" value="URM_FIX_CD_EXCEL_FORM.xlsx" />
	<input type="hidden" name="downDiv" value="" /> <!-- 공지사항 첨부 다운일경우 noti, 업로드 폴더인경우 up 로 넣어준다-->
</form>

</body>
</html>