<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>수기정산등록</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />
<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS; 	//파라미터 데이터

     var ctnr_se_list;	//빈용기구분  구병 신병
     var ctnr_prps_list;	//빈용기구분 가정 유흥
     var rmk_list;     	//소매수수료 적용여부 비고
     var std_mgnt_list;
     
     var rowIndexValue = '';
     var ctnr_nm = '';
     
     var exca_st_dt = '';
     var exca_end_dt = '';
     var exca_st_dt_c = '';
     var exca_end_dt_c = '';

     $(function() {
    
    	INQ_PARAMS 	=  jsonObject($("#INQ_PARAMS").val());	
   		
    	std_mgnt_list	= jsonObject($("#std_mgnt_list").val());
    	ctnr_se_list 	= jsonObject($("#ctnr_se_list").val());      
   		ctnr_prps_list 	= jsonObject($("#ctnr_prps_list").val());	
   		rmk_list			= jsonObject($("#rmk_list").val());
   		mfc_bizrnmList = jsonObject($("#mfc_bizrnmList").val());      
   		
   		$('#title_sub').text('<c:out value="${titleSub}" />');				//타이틀
   		
   		$('.row > .col > .tit').each(function(){
			$(this).text(parent.fn_text($(this).attr('id')) );
		});
   		
   		//div필수값 alt
		$("#CRCT_RTN_DT").attr('alt', parent.fn_text('crct_rtn_dt'));
		$("#CRCT_WRHS_CFM_DT").attr('alt', parent.fn_text('crct_wrhs_dt'));
		$("#MFC_BIZRNM").attr('alt', parent.fn_text('mfc_bizrnm'));
		$("#MFC_BRCH_NM").attr('alt', parent.fn_text('mfc_brch_nm'));
		$("#WHSDL_BIZRNM").attr('alt', parent.fn_text('whsdl'));
		$("#WHSDL_BRCH_NM").attr('alt', parent.fn_text('whsdl_brch'));
		$("#CTNR_CD").attr('alt', parent.fn_text('ctnr_nm'));
		$("#CFM_QTY").attr('alt', parent.fn_text('cfm_qty'));
   		
   		kora.common.setEtcCmBx2(std_mgnt_list, "", INQ_PARAMS.EXCA_PARAM.EXCA_STD_CD_SE, $("#EXCA_STD_CD_SE"), "EXCA_STD_CD_SE", "EXCA_STD_NM", "N"); //정산기간 선택
   		kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N", "S");
   		kora.common.setEtcCmBx2(ctnr_se_list, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");
		kora.common.setEtcCmBx2(rmk_list, "","", $("#RMK_SELECT"), "ETC_CD", "ETC_CD_NM", "N" ,'S');
		
		kora.common.setEtcCmBx2([], "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N", "S");
		kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "BIZRID_NO", "BIZRNM", "N", "S");
		kora.common.setEtcCmBx2([], "","", $("#WHSDL_BIZRNM"), "BIZRID_NO", "BIZRNM", "N", "S");
		kora.common.setEtcCmBx2([], "","", $("#WHSDL_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N", "S");
		kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N", "S");
		
		var exca_idx = $("#EXCA_STD_CD_SE").children('option:selected').index();
		
   		exca_st_dt = std_mgnt_list[exca_idx].EXCA_ST_DT;
   		exca_end_dt = std_mgnt_list[exca_idx].EXCA_END_DT;
   		exca_st_dt_c = std_mgnt_list[exca_idx].EXCA_ST_DT_C;
   		exca_end_dt_c = std_mgnt_list[exca_idx].EXCA_END_DT_C;
		
		$("#WHSDL_BIZRNM").select2();
   		
    	 //버튼 셋팅
    	 fn_btnSetting();
    	 
    	 //그리드 셋팅
		 fnSetGrid1();
    	 
		//날짜 셋팅
		 $('#CRCT_RTN_DT').YJcalendar({  
				triggerBtn : true
				,dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
		 });	
		
		//날짜 셋팅
		 $('#CRCT_WRHS_CFM_DT').YJcalendar({  
				triggerBtn : true
				,dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
		 });	
    	 
		/************************************
		 * 정산기간 변경 이벤트
		 ***********************************/
		$("#EXCA_STD_CD_SE").change(function(){
			fn_exca_std_cd();
		});
		
		/************************************
		 * 생산자  변경 이벤트
		 ***********************************/
		$("#MFC_BIZRNM").change(function(){
			fn_mfc_bizrnm();
		});
		
		/************************************
		 * 직매장/공장 구분 변경 이벤트
		 ***********************************/
		$("#MFC_BRCH_NM").change(function(){
			fn_mfc_brch_nm();
		});
		
		/************************************
		 * 도매업자  변경 이벤트
		 ***********************************/
		$("#WHSDL_BIZRNM").change(function(){
			fn_whsdl_bizrnm();
		});
		
		/************************************
		 * 도매업자 지점 변경 이벤트
		 ***********************************/
		$("#WHSDL_BRCH_NM").change(function(){
			fn_brch_nm();
		});
		
		/************************************
		 * 빈용기구분 구병 / 신병 변경시 
		 ***********************************/
		$("#CTNR_SE").change(function(){
			fn_prps_cd();
		});
		
		/************************************
		 * 빈용기 구분 변경 이벤트 유흥/가정/직접
		 ***********************************/
		$("#PRPS_CD").change(function(){
			fn_prps_cd();
		});
		
		/************************************
		 * 빈용기코드 변경 이벤트
		 ***********************************/
		$("#CTNR_CD").change(function(){
			//fn_rmk();			
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
		 *등록 클릭 이벤트
		 ***********************************/
		$("#btn_reg").click(function(){
			fn_reg();
		});
		
		/************************************
		 * 취소 클릭 이벤트
		 ***********************************/
		$("#btn_cnl").click(function(){
			fn_cnl();
		});
		
		/************************************
		 * 정정반환일자 적용버튼 클릭 이벤트
		 ***********************************/
		$("#btn_upd2").click(function(){
			confirm("반환일자 변경 시 취급수수료 정보가 변경될 수 있습니다. 계속 진행하시겠습니까?", "fn_ck"); 
		});

        var rtn_prev_val = $("#CRCT_RTN_DT").val();
		/************************************
		 * 시작날짜  클릭시 - 삭제 변경 이벤트
		 ***********************************/
		$("#CRCT_RTN_DT").click(function(){
			rtn_prev_val = $(this).val();
			
			var start_dt = $("#CRCT_RTN_DT").val();
			start_dt = start_dt.replace(/-/gi, "");
			$("#CRCT_RTN_DT").val(start_dt);
		});
		
		/************************************
		 * 시작날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		$("#CRCT_RTN_DT").change(function(){
		    var start_dt = $("#CRCT_RTN_DT").val();
		    start_dt = start_dt.replace(/-/gi, "");
		    
		    if(start_dt < exca_st_dt || start_dt > exca_end_dt  ){
		    	//$("#CRCT_RTN_DT").val(rtn_prev_val);
            	//alertMsg("정산기간을 확인하세요.\n정산기간:"+exca_st_dt_c+"~"+exca_end_dt_c);
		    } else {		    
				if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
			    $("#CRCT_RTN_DT").val(start_dt) 
			    
			    fn_prps_cd();
		    }
		});
		
        var prev_val = $("#CRCT_WRHS_CFM_DT").val();

		/************************************
		 * 시작날짜  클릭시 - 삭제 변경 이벤트
		 ***********************************/
		$("#CRCT_WRHS_CFM_DT").click(function(){
            prev_val = $(this).val();

		    var start_dt = $("#CRCT_WRHS_CFM_DT").val();
			start_dt = start_dt.replace(/-/gi, "");
			$("#CRCT_WRHS_CFM_DT").val(start_dt);
		});
		
		/************************************
		 * 시작날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		
        $("#CRCT_WRHS_CFM_DT").change(function(){
            var dt = $("#CRCT_WRHS_CFM_DT").val();
            dt = dt.replace(/-/gi, "");
            
            var today = kora.common.gfn_toDay();
            
            if(dt > today){
               $("#CRCT_WRHS_CFM_DT").val(prev_val);
                alertMsg("입고확인일자는 오늘 이전 일자만 입력할 수 있습니다.");
            } else if(dt < exca_st_dt || dt > exca_end_dt  ){
            	//$("#CRCT_WRHS_CFM_DT").val(prev_val);
            	//alertMsg("정산기간을 확인하세요.\n정산기간:"+exca_st_dt_c+"~"+exca_end_dt_c);
            } else {
                
                if(dt.length == 8) dt = kora.common.formatter.datetime(dt, "yyyy-mm-dd")
                $("#CRCT_WRHS_CFM_DT").val(dt)
                
                fn_prps_cd();
            }
        });     
		
	});

   //빈용기 구분 선택시
     function fn_prps_cd(){
 		var url = "/SELECT_CTNR_CD.do" 
 		var input ={};
 		
 		var arr  = $("#MFC_BIZRNM").val().split(";");
		var arr2 = $("#MFC_BRCH_NM").val().split(";");
		var arr3 = $("#WHSDL_BIZRNM").val().split(";");
		var arr4 = $("#WHSDL_BRCH_NM").val().split(";");

		if(arr != '' && arr2 != '' && arr3 != '' && arr4 != '' && $("#CRCT_RTN_DT").val() != '' && $("#PRPS_CD").val() != ''){
		
			input["MFC_BIZRID"] 	= arr[0];
			input["MFC_BIZRNO"] 	= arr[1];
			input["MFC_BRCH_ID"] 	= arr2[0];
			input["MFC_BRCH_NO"] 	= arr2[1];
			input["CUST_BIZRID"] 	= arr3[0];
			input["CUST_BIZRNO"] 	= arr3[1];
			input["CUST_BRCH_ID"] 	= arr4[0];
			input["CUST_BRCH_NO"] 	= arr4[1];

			input["RTN_DT"] 		= $("#CRCT_RTN_DT").val();	//반환일자
			input["CTNR_SE"] 		= $("#CTNR_SE").val();				//빈용기명 구분 구/신
			input["PRPS_CD"] 		= $("#PRPS_CD").val();				//빈용기명  유흥/가정/공병/직접 
			
	        ajaxPost(url, input, function(rtnData) {
				if ("" != rtnData && null != rtnData) {   
					 ctnr_nm = rtnData.ctnr_nm
					 kora.common.setEtcCmBx2(rtnData.ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N", 'S'); //빈용기	
				}else{
					alertMsg("error");
				}
	   		});
		
   		}else{
   			kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N", 'S'); //빈용기	
   		}
 		
 	} 
   
    //업체명 변경시
    function fn_brch_nm(){
        var url = "/CE/EPCE4705601_196.do" 
        var input ={};
        
        if($("#WHSDL_BRCH_NM").val() !=""){
            var arr  = $("#MFC_BIZRNM").val().split(";");
            var arr2 = $("#MFC_BRCH_NM").val().split(";");
            var arr3 = $("#WHSDL_BIZRNM").val().split(";");
            var arr4 = $("#WHSDL_BRCH_NM").val().split(";");
            
            input["MFC_BIZRID"]     = arr[0];
            input["MFC_BIZRNO"]     = arr[1];
            input["MFC_BRCH_ID"]    = arr2[0];
            input["MFC_BRCH_NO"]    = arr2[1];
            input["CUST_BIZRID"]    = arr3[0];
            input["CUST_BIZRNO"]    = arr3[1];
            input["CUST_BRCH_ID"]   = arr4[0];
            input["CUST_BRCH_NO"]   = arr4[1];
            
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
        else{
            kora.common.setEtcCmBx2([], "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');    //빈용기구분 코드
            kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');//빈용기명
        }
    }
     
   //정산기간 변경시  생산자 조회
     function fn_exca_std_cd(){
  	 		var url = "/CE/EPCE4705601_194.do" 
  			var input ={};
  	 		
  			var exca_idx = $("#EXCA_STD_CD_SE").children('option:selected').index();
  			
  	   		exca_st_dt = std_mgnt_list[exca_idx].EXCA_ST_DT;
  	   		exca_end_dt = std_mgnt_list[exca_idx].EXCA_END_DT;
  	   		exca_st_dt_c = std_mgnt_list[exca_idx].EXCA_ST_DT_C;
  	   		exca_end_dt_c = std_mgnt_list[exca_idx].EXCA_END_DT_C;
  	   		
  	 		if($("#EXCA_STD_CD_SE").val() !=""){
	  	 		var arr4 = $("#EXCA_STD_CD_SE").val().split(";");
	  			input["EXCA_STD_CD"]			=  arr4[0];
	  			input["EXCA_TRGT_SE"]		=  arr4[1];
	  			ajaxPost(url, input, function(rtnData) {
	  				if ("" != rtnData && null != rtnData) {   
	  					 kora.common.setEtcCmBx2(rtnData.mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'S'); //생산자
	  					 kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S');	//직매장/공장
	  					$("#WHSDL_BIZRNM").select2("val","");
	  		  			 kora.common.setEtcCmBx2([], "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'S');	//도매업자 업체명
	  		  			 kora.common.setEtcCmBx2([], "", "", $("#WHSDL_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N", "S");
	  				}else{
	  					 alertMsg("error");
	  				}
	  			},false);
  	 		}else{

  	 		}
     }
     
   	//생산자 변경시 생산자랑 거래중인 도매업자 조회 , 직매장/공장
     function fn_mfc_bizrnm(){
  		var url = "/CE/EPCE4705601_19.do" 
  		var input ={};
  		
  		$("#WHSDL_BIZRNM").select2("val","");
  		
  		if($("#MFC_BIZRNM").val() !=""){
  			var arr = $("#MFC_BIZRNM").val().split(";");
  			input["MFC_BIZRID"]		= arr[0];  //직매장별거래처관리 테이블에서 생산자
  			input["MFC_BIZRNO"]		= arr[1];
  			input["BIZRID"]				= arr[0];	//지점관리 테이블에서 사업자
  			input["BIZRNO"]				= arr[1];
  			ajaxPost(url, input, function(rtnData) {
  				if ("" != rtnData && null != rtnData) {   
  					 kora.common.setEtcCmBx2(rtnData.brch_nmList, "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S');	 			//직매장/공장
  					 kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'S');	//도매업자 업체명
  					 kora.common.setEtcCmBx2([], "", "", $("#WHSDL_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N", "S");
  				}else{
  						 alertMsg("error");
  				}
  			},false);
  		}else{
  			 kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S');	//직매장/공장
  			 kora.common.setEtcCmBx2([], "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'S');	//도매업자 업체명
  			 kora.common.setEtcCmBx2([], "", "", $("#WHSDL_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N", "S");
  		}
     }
   
   	 var whsdlList_bak = '';
     //직매장/공장 변경시  생산자랑 거래 중인 도매업자 업체명 조회
     function fn_mfc_brch_nm(){
    	 
  		var url = "/CE/EPCE2910101_192.do" 
  		var input ={};
  		
  		$("#WHSDL_BIZRNM").select2("val","");
  		
  			var arr = $("#MFC_BIZRNM").val().split(";");
  			var arr2	= $("#MFC_BRCH_NM").val().split(";");
  			input["MFC_BIZRID"]		= arr[0];  //직매장별거래처관리 테이블에서 생산자
  			input["MFC_BIZRNO"]		= arr[1];
  			input["MFC_BRCH_ID"]		= arr2[0];
  			input["MFC_BRCH_NO"]	= arr2[1];
  			ajaxPost(url, input, function(rtnData) {
  				if ("" != rtnData && null != rtnData) {   
  						whsdlList_bak = rtnData.whsdlList;
  	   					kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'S');	//도매업자 업체명
  	   					kora.common.setEtcCmBx2([], "", "", $("#WHSDL_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N", "S");
  	   			}else{
  	   					alertMsg("error");
  				}
  			},false);

     } 
     
 	   //생산자 변경시 생산자랑 거래중인 도매업자 조회 , 직매장/공장
 	     function fn_whsdl_bizrnm(){
 	  		var url = "/SELECT_BRCH_LIST.do" 
 	  		var input ={};
 	  		if($("#WHSDL_BIZRNM").val() != ''){
 	  			
 	  			//빈용기명 콤보 초기화
 	  			kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');	//빈용기명
                kora.common.setEtcCmBx2([], "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N", "S");
 	  			
	 			var arr = $("#WHSDL_BIZRNM").val().split(";");
	 			input["BIZRID"]	= arr[0];
	 			input["BIZRNO"]	= arr[1];
	 			ajaxPost(url, input, function(rtnData) {
	 				if ("" != rtnData && null != rtnData) {   
	 					kora.common.setEtcCmBx2(rtnData, "", "", $("#WHSDL_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N", "S");
	 				}else{
	 					alertMsg("error");
	 				}
	 			},false);
	 			
 	  		}else{
 	  			kora.common.setEtcCmBx2([], "", "", $("#WHSDL_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N", "S");
 	  		}
 	  		
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
    
	 //행추가
	function fn_reg2(){
	
        var start_dt = $("#CRCT_RTN_DT").val();
	    start_dt = start_dt.replace(/-/gi, "");
	    
		var dt = $("#CRCT_WRHS_CFM_DT").val();
        dt = dt.replace(/-/gi, "");

	    
	    if(start_dt < exca_st_dt || start_dt > exca_end_dt  ){
	    	alertMsg("정정반환일자를 확인하세요.\n정산기간:"+exca_st_dt_c+"~"+exca_end_dt_c);
        	return;
	    }
        	
        	
		if(dt < exca_st_dt || dt > exca_end_dt  ){
			alertMsg("입고확인일자를 확인하세요.\n정산기간:"+exca_st_dt_c+"~"+exca_end_dt_c);
        	return;
		}
        	
        	
		if(!kora.common.cfrmDivChkValid("divInput")) {
			return;
		}
		
		if($('#WHSDL_BIZRNM').val() == ''){
			alertMsg('도매업자를 확인하세요.');
			return;
		}
		
		if(!kora.common.cfrmDivChkValid("divInput2")) {
			return;
		}
		
		if(Number($('#CFM_QTY').val()) < 1){
			alertMsg('확인량을 입력해주세요.');
			return;
		}
		
		var input = insRow("A");
		if(!input){
			return;
		}
		
		$("#EXCA_STD_CD_SE").prop("disabled",true);
		$("#CRCT_RTN_DT").prop("disabled",true);
		$("#CRCT_WRHS_CFM_DT").prop("disabled",true);
		$("#MFC_BIZRNM").prop("disabled",true);
		$("#MFC_BRCH_NM").prop("disabled",true);
		$("#WHSDL_BIZRNM").prop("disabled",true);
		$("#WHSDL_BRCH_NM").prop("disabled",true);
		$(".YJcalendar-trigger").attr('style','display:none');
		
		gridRoot2.addItemAt(input);
		dataGrid2.setSelectedIndex(-1);		

	}
	
	 //행 수정
	function fn_upd(){
		var idx = dataGrid2.getSelectedIndex();
		
		if(idx < 0) {
			alertMsg("변경할 행을 선택하시기 바랍니다.");
			return;
		}
		
		if(!kora.common.cfrmDivChkValid("divInput")) {
			return;
		}
		if(!kora.common.cfrmDivChkValid("divInput2")) {
			return;
		}
		
		if(Number($('#CFM_QTY').val()) < 1){
			alertMsg('확인량을 입력해주세요.');
			return;
		}
		
		var item = insRow("M");

		//해당 데이터 수정
		gridRoot2.setItemAt(item, idx);

	}
	 
	//행삭제
	function fn_del(){
		var idx = dataGrid2.getSelectedIndex();
 
		if(idx < 0) {
			alertMsg("삭제할 행을 선택하시기 바랍니다.");
			return;
		}
		
		gridRoot2.removeItemAt(idx);

	}
	 
	//행변경 및 행추가시 그리드 셋팅
	insRow = function(gbn) {
		var input = {};
		var ctnrCd = $("#CTNR_CD").val();
		var collection = gridRoot2.getCollection();
		var rtl_fee_select = $("input[type=radio][name=select_rtl]:checked").val();//수수료적용여부  라디오체크여부
		
	 	for(var i=0;i<collection.getLength(); i++){
	 		var tmpData = gridRoot2.getItemAt(i);
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
			
			if(ctnr_nm[i].CTNR_CD == ctnrCd) { //같은 용기코드가 있을경우

			    input["CTNR_SE"] = $("#CTNR_SE").val();  	 								//빈용기명 구분 구/신
			    input["PRPS_NM"] = $("#PRPS_CD option:selected").text();   		//빈용기명 구분 유흥/가정
			    input["PRPS_CD"] = $("#PRPS_CD").val();  						 			//빈용기명 구분 유흥/가정 코드
			    input["CTNR_NM"] = $("#CTNR_CD option:selected").text(); 			//빈용기명
			    input["CTNR_CD"] = $("#CTNR_CD").val(); 									//빈용기 코드
			    input["CPCT_NM"] = ctnr_nm[i].CPCT_NM;									//용량ml
				if($("#CFM_QTY").val() !=""){
					input["CRCT_QTY"] = $("#CFM_QTY").val();	//확인수량
				}else{
				  	input["CRCT_QTY"] ="0";
				}
				if($("#DMGB_QTY").val() !=""){
					input["CRCT_DMGB_QTY"] 	= $("#DMGB_QTY").val(); 	//결병
				}else{
					input["CRCT_DMGB_QTY"] 	="0";
				}
				if($("#VRSB_QTY").val() !=""){
					input["CRCT_VRSB_QTY"] = $("#VRSB_QTY").val(); 	//잡병
				}else{
					input["CRCT_VRSB_QTY"] ="0";
				}
			    input["CRCT_GTN"] 					=  input["CRCT_QTY"] * ctnr_nm[i].STD_DPS; //빈용기보증금(원) - 합계
			    input["CRCT_WHSL_FEE"]    		=	input["CRCT_QTY"] * ctnr_nm[i].WHSL_FEE; //도매수수료 합계
			    input["CRCT_WHSL_FEE_STAX"]	=	kora.common.truncate(parseInt(input["CRCT_WHSL_FEE"],10)/10);	 //도매 부과세

			    if($("#PRPS_CD").val() =="1"){	//빈용기구분이 가정일 경우에만 적용
				    if(rtl_fee_select =="ext"){ //소매수수료적용여부 제외시
			    		if($("#RMK_SELECT").val() =="" ){
			    			alertMsg("소매수수료 제외 선택시 ,비고에 사유를 입력하셔야 합니다.");
			    			return;
			    		}else if ($("#RMK").val() ==""){
			    			alertMsg("소매수수료 제외 선택시 ,비고에 사유를 입력하셔야 합니다.");
			    			return;
			    		}
						if($("#RMK_SELECT").val() !="C"){
							input["RMK"] 						=	$("#RMK_SELECT").val()+"-"+$("#RMK_SELECT option:selected").text();	//비고 텍스트값
							input["RMK_C"] 					=	$("#RMK_SELECT option:selected").text();											//비고 텍스트값(view용)
						}else{
							input["RMK"] 						=	$("#RMK_SELECT").val()+"-"+$("#RMK").val();	//비고 텍스트값
							input["RMK_C"] 					=	$("#RMK").val();										//비고 텍스트값(view용)
						}
						input["CRCT_RTL_FEE"]      		=	'0';		//소매수수료 합계	
						input["CRCT_RTL_FEE_STAX"]   =	'0.00';	//소매 부과세
						
				    }else{//소매수수료 적용 시
						  input["CRCT_RTL_FEE"]      		=	input["CRCT_QTY"] * ctnr_nm[i].RTL_FEE;			//소매수수료 합계	
						  input["CRCT_RTL_FEE_STAX"]    	=	kora.common.truncate(parseInt(input["CRCT_RTL_FEE"],10)/10);		//소매 부과세
				    }
			    }else{
					  input["CRCT_RTL_FEE"]      		=	input["CRCT_QTY"] * ctnr_nm[i].RTL_FEE;			//소매수수료 합계	
					  input["CRCT_RTL_FEE_STAX"]    	=	kora.common.truncate(parseInt(input["CRCT_RTL_FEE"],10)/10);		//소매 부과세
			    }

			    //소매부가세를 도매부가세로
			    input["CRCT_RTL_FEE_STAX"] = 0;
			    input["CRCT_WHSL_FEE_STAX"]	=	kora.common.truncate( (parseInt(input["CRCT_WHSL_FEE"],10) + parseInt(input["CRCT_RTL_FEE"],10)) / 10 );	//도매 부과세
			    
			    input["CRCT_AMT"] 					=	Number(input["CRCT_GTN"]) + Number(input["CRCT_WHSL_FEE"]) + Number(input["CRCT_WHSL_FEE_STAX"]) + Number(input["CRCT_RTL_FEE"]) + Number(input["CRCT_RTL_FEE_STAX"]); //총합계
			    
			    
			    var arr = $("#MFC_BIZRNM").val().split(";");
				var arr2	= $("#MFC_BRCH_NM").val().split(";");
				var arr3 = $("#WHSDL_BIZRNM").val().split(";");
				var arr4	= $("#WHSDL_BRCH_NM").val().split(";");

				input["WHSDL_BIZRID"] 		= 	arr3[0];
				input["WHSDL_BIZRNO"] 		= 	arr3[1];
				input["WHSDL_BRCH_ID"] 	= 	arr4[0];
				input["WHSDL_BRCH_NO"] 	= 	arr4[1];
				input["MFC_BIZRID"] 		= 	arr[0];
				input["MFC_BIZRNO"] 		= 	arr[1];
				input["MFC_BRCH_ID"] 	= 	arr2[0];
				input["MFC_BRCH_NO"] 	= 	arr2[1];
			    
				input["CRCT_RTN_DT"] = $('#CRCT_RTN_DT').val();
				input["CRCT_WRHS_CFM_DT"] = $('#CRCT_WRHS_CFM_DT').val();
				
			    break;
			}
		}
		return input;
	};	
	
	function fn_ck(){
		//ctnrCdAll ="T";
		fn_upd2();
	}
	
	function fn_upd2(){
		fn_prps_cd();

		var collection = gridRoot2.getCollection();
		for(var i=0;i<collection.getLength(); i++){
		 		var tmpData 	= gridRoot2.getItemAt(i);
		 		var input ={}
				input["CTNR_SE"] 					=tmpData["CTNR_SE"]; 			
				input["PRPS_NM"] 					=tmpData["PRPS_NM"]; 			
				input["PRPS_CD"] 					=tmpData["PRPS_CD"]; 			
				input["CTNR_NM"] 					=tmpData["CTNR_NM"]; 			
				input["CTNR_CD"] 					=tmpData["CTNR_CD"]; 			
				input["CPCT_NM"] 					=tmpData["CPCT_NM"]; 			
				input["CRCT_QTY"] 					=tmpData["CRCT_QTY"]; 	
				input["RTN_QTY"]					=tmpData["RTN_QTY"]; 
				input["CRCT_DMGB_QTY"] 		=tmpData["CRCT_DMGB_QTY"]; 		
				input["CRCT_VRSB_QTY"] 		=tmpData["CRCT_VRSB_QTY"]; 		
				input["WHSDL_BIZRID"] 			=tmpData["WHSDL_BIZRID"]; 		
				input["WHSDL_BIZRNO"] 			=tmpData["WHSDL_BIZRNO"]; 		
				input["WHSDL_BRCH_ID"] 		=tmpData["WHSDL_BRCH_ID"]; 		
				input["WHSDL_BRCH_NO"] 		=tmpData["WHSDL_BRCH_NO"]; 		
				input["MFC_BIZRID"] 				=tmpData["MFC_BIZRID"];		
				input["MFC_BIZRNO"] 				=tmpData["MFC_BIZRNO"]; 		
				input["MFC_BRCH_ID"] 			=tmpData["MFC_BRCH_ID"]; 		
				input["MFC_BRCH_NO"] 			=tmpData["MFC_BRCH_NO"]; 		
				input["WRHS_DOC_NO"]			=tmpData["WRHS_DOC_NO"];		
				  for(var k=0; k<ctnr_nm_all.length; k++){
				    	if(ctnr_nm_all[k].CTNR_CD == tmpData["CTNR_CD"]) {
					 	    input["CRCT_GTN"] 					=tmpData["CRCT_QTY"] * ctnr_nm_all[k].STD_DPS;
						    input["CRCT_WHSL_FEE"]    		=tmpData["CRCT_QTY"] * ctnr_nm_all[k].WHSL_FEE;  	
						    input["CRCT_WHSL_FEE_STAX"]	=kora.common.truncate(parseInt(tmpData["CRCT_WHSL_FEE"],10)/10)
						    if(tmpData["RMK"] !="" && tmpData["RMK"] !=undefined){
						    	input["RMK"] 							=tmpData["RMK"]; 		
								input["RMK_C"]						=tmpData["RMK_C"];	
							    input["CRCT_RTL_FEE"]      		='0';		//소매수수료 합계	
							    input["CRCT_RTL_FEE_STAX"]  	='0.00';	//소매 부과세
						    } else{
						    	input["CRCT_RTL_FEE"]      		=tmpData["CRCT_QTY"] *ctnr_nm_all[k].RTL_FEE;    	
								input["CRCT_RTL_FEE_STAX"]  	=kora.common.truncate(parseInt(tmpData["CRCT_RTL_FEE"],10)/10)
						    }
						    input["CRCT_AMT"] 					=Number(tmpData["CRCT_QTY"])+ Number(tmpData["CRCT_WHSL_FEE"] )+ Number(tmpData["CRCT_WHSL_FEE_STAX"])+ Number(tmpData["CRCT_RTL_FEE_STAX"])+ Number(tmpData["CRCT_RTL_FEE_STAX"]); //총합계
						    break; 
				    	}
				    }
				  
				input["WRHS_CRCT_DOC_NO"]	= 	wrhsCrctDocNo; // 입고정정문서번호
				  
				// 해당 데이터의 이전 수정내역을 삭제
				gridRoot2.removeChangedData(gridRoot2.getItemAt(i));
				//해당 데이터 수정
				gridRoot2.setItemAt(input, i);
			
	    }//end of for(var i=0;i<collection.getLength(); i++)
	}	
	
	//등록
	function fn_reg(){
		 
		var data = {"list": ""};
		var row = new Array();
		var url = ""; 

		var crct_tot=0;
		var collection = gridRoot2.getCollection();
		var url = "/CE/EPCE47056312_09.do"
		
		for(var i=0;i<collection.getLength(); i++){
	 		var tmpData = gridRoot2.getItemAt(i);
			tmpData["WRHS_CRCT_STAT_CD"]	= "R";
			//tmpData["EXCA_STD_CD"]			= $("#EXCA_STD_CD_SE").val().split(";")[0];
 			row.push(tmpData);//행 데이터 넣기
	 	}
		
	 	data["list"] = JSON.stringify(row);
		ajaxPost(url, data, function(rtnData){
			if(rtnData != null && rtnData != ""){
					if(rtnData.RSLT_CD =="0000"){
						alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
					} else{
						alertMsg(rtnData.RSLT_MSG);
					}
			}else{
					alertMsg("error");
			}
		},false); 
	
	}
    
     //취소
  	function fn_cnl(){
  		kora.common.goPageB('', INQ_PARAMS);
     }
     
  //선택한 행 입력창에 값 넣기
	function fn_rowToInput (rowIndex){
		var item = gridRoot2.getItemAt(rowIndex);
		//빈용기구분 구병/신병 정보가 다를 경우에만 api호출
		if($("#CTNR_SE").val() != item["CTNR_SE"]  || $("#PRPS_CD").val() != item["PRPS_CD"]  ){
			fn_dataSet(item);
		}
		$("#CTNR_SE").val(item["CTNR_SE"]).prop("selected", true);   		//빈용기명 구분 구병 /신병
		$("#PRPS_CD").val(item["PRPS_CD"]).prop("selected", true);   		//빈용기명 구분 유흥/가정 / 직접
		$("#CTNR_CD").val(item["CTNR_CD"]).prop("selected", true);    	//빈용기명
		$("#DMGB_QTY").val(item["CRCT_DMGB_QTY"]);						//결병
		$("#VRSB_QTY")  .val(item["CRCT_VRSB_QTY"]);							//잡병
		$("#CFM_QTY")  .val(item["CRCT_QTY"]);									//확인수량
		
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
		var input						= {};
		var url 	 						= "/CE/EPCE4705631_19.do"; 
		input["CUST_BIZRID"] 		= item["WHSDL_BIZRID"];		//도매업자아이디
		input["CUST_BIZRNO"] 	= item["WHSDL_BIZRNO"];	//도매업자사업자번호
		input["CUST_BRCH_ID"] 	= item["WHSDL_BRCH_ID"];	//도매업자 지점 아이디
		input["CUST_BRCH_NO"] 	= item["WHSDL_BRCH_NO"];	//도매업자 지점 번호
		input["MFC_BIZRID"] 		= item["MFC_BIZRID"];			//생산자 아이디
		input["MFC_BIZRNO"] 		= item["MFC_BIZRNO"];		//생산자 사업자번호
		input["MFC_BRCH_ID"] 	= item["MFC_BRCH_ID"];		//생산자 직매장/공장 아이디
		input["MFC_BRCH_NO"] 	= item["MFC_BRCH_NO"];		//생산자 직매장/공장 번호
		input["CTNR_SE"] 			= item["CTNR_SE"];				//빈용기명 구분 구/신
		input["PRPS_CD"] 			= item["PRPS_CD"];				//빈용기명  유흥/가정/공병/직접 
		input["RTN_DT"]				= $("#CRCT_RTN_DT").val();		//반환일자 수수료 적용날짜
		ajaxPost(url, input, function(rtnData) {
  				if ("" != rtnData && null != rtnData) {   
				 	ctnr_nm	 = [];						//빈용기정보 초기화
  					ctnr_nm = rtnData.ctnr_nm
  					kora.common.setEtcCmBx2(ctnr_nm, "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');	//빈용기명
  				}else{
				alertMsg("error");
  				}
   		},false);
	}
     
	/****************************************** 그리드 셋팅 시작***************************************** */
	/**
	 * 그리드 관련 변수 선언
	 */
	var jsVars2 = "rMateOnLoadCallFunction=gridReadyHandler2";
	var gridApp2, gridRoot2, dataGrid2, layoutStr2, selectorColumn2;

	/**
	 * 그리드 셋팅
	 */
	 function fnSetGrid1(reDrawYn) {
			
			rMateGridH5.create("grid2", "gridHolder2", jsVars2, "100%", "100%");

			layoutStr2 = new Array();
			
			/* 입고정정내역 */
			layoutStr2.push('<rMateGrid>');
			layoutStr2.push('	<NumberFormatter id="numfmt" useThousandsSeparator="true"/>');
			layoutStr2.push('	<NumberFormatter id="numfmt1" precision="2" useThousandsSeparator="true"/>');
			layoutStr2.push('	<DateFormatter id="datefmt2" formatString="YYYY-MM-DD"/>');
			layoutStr2.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" horizontalScrollPolicy="on"  headerHeight="35">');
			layoutStr2.push('		<groupedColumns>');
			layoutStr2.push('			<DataGridColumn dataField="index" 			 headerText="'+ parent.fn_text('sn')+ '"  		 	width="40"	 	 textAlign="center"	itemRenderer="IndexNoItem"  />');						//순번
			layoutStr2.push('			<DataGridColumn dataField="PRPS_NM"  	 headerText="'+ parent.fn_text('prps_cd')+ '"		width="70" 	 textAlign="center"/>');																	//용도(유흥용/가정용)
			layoutStr2.push('			<DataGridColumn dataField="CTNR_NM"  	 headerText="'+ parent.fn_text('ctnr_nm')+ '"	width="230" 	 textAlign="left"/>');																	//빈용기명
			layoutStr2.push('			<DataGridColumn dataField="CTNR_CD" 	 headerText="'+ parent.fn_text('cd')+ '" 			width="60" 	 textAlign="center" />');																	//코드
			layoutStr2.push('			<DataGridColumn dataField="CPCT_NM"  	 headerText="'+ parent.fn_text('cpct_cd')+'(ml)'+'" 	width="120" 	 textAlign="center"/>');															//용량(ml)]
			layoutStr2.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cfm_data')+ '">');																																									//확인내역
			layoutStr2.push('				<DataGridColumn dataField="CRCT_DMGB_QTY" 	headerText="'+ parent.fn_text('dmgb')+ '"		width="50" formatter="{numfmt}" textAlign="right"  id="num2"/>');				//결병
			layoutStr2.push('				<DataGridColumn dataField="CRCT_VRSB_QTY" 	headerText="'+ parent.fn_text('vrsb')+ '"			width="70" formatter="{numfmt}" textAlign="right"  id="num3"/>');				//잡병
			layoutStr2.push('				<DataGridColumn dataField="CRCT_QTY" 	  		headerText="'+ parent.fn_text('cfm_qty2')+ '" 	width="70" formatter="{numfmt}" textAlign="right"  id="num4"/>');				//입고확인수량
			layoutStr2.push('			</DataGridColumnGroup>');
			layoutStr2.push('				<DataGridColumn dataField="CRCT_GTN"  			headerText="'+ parent.fn_text('cntr_dps2')+ '" 	width="120" formatter="{numfmt}" textAlign="right"  id="num5"/>');				//빈용기보증금
		 	layoutStr2.push('			<DataGridColumnGroup  headerText="'+ parent.fn_text('cntr')+' '+ parent.fn_text('std_fee')+'">');																																		//빈용기 취급수수료(원
			layoutStr2.push('				<DataGridColumn dataField="CRCT_WHSL_FEE"			headerText="'+ parent.fn_text('whsl_fee2')+ '" 	width="150" 	formatter="{numfmt1}" textAlign="right"  id="num6"/>'); 	//도매수수료
			layoutStr2.push('				<DataGridColumn dataField="CRCT_RTL_FEE" 				headerText="'+ parent.fn_text('rtl_fee2')+ '" 		width="150" 	formatter="{numfmt1}" textAlign="right"  id="num8"  />');//소매수수료
			layoutStr2.push('				<DataGridColumn dataField="CRCT_WHSL_FEE_STAX"	headerText="'+ parent.fn_text('stax')+ '"	width="150" 	formatter="{numfmt}" 	textAlign="right"  id="num7"  />');//도매부가세
			layoutStr2.push('				<DataGridColumn dataField="CRCT_RTL_FEE_STAX"   	headerText="'+ parent.fn_text('rtl_stax2')+ '"  visible="false"  	width="150" 	formatter="{numfmt}" 	textAlign="right"  id="num9"  />');//소매부가세
			layoutStr2.push('			</DataGridColumnGroup>');
			layoutStr2.push('			<DataGridColumn dataField="CRCT_AMT" 	headerText="'+ parent.fn_text('amt_tot')+ '" 		width="100"  	formatter="{numfmt}" 	textAlign="right"  id="num10"  />');//금액합계(원)
			layoutStr2.push('			<DataGridColumn dataField="RMK_C"			headerText="'+ parent.fn_text('rmk')+ '"		width="100" textAlign="center"  />');														//비고
			layoutStr2.push('			<DataGridColumn dataField="RMK"    		visible="false" />');
			layoutStr2.push('		</groupedColumns>');
	 		layoutStr2.push('		<footers>');
			layoutStr2.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr2.push('				<DataGridFooterColumn label="합계" textAlign="center"/>');
			layoutStr2.push('				<DataGridFooterColumn/>');  
			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	//결병
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	//잡병
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');	//최종입고수량
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num5}" formatter="{numfmt}" textAlign="right"/>');	//빈용기 보증금
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');	//도매수수료
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num8}" formatter="{numfmt}" textAlign="right"/>');	//도매부가세
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');	//소매수수료
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num9}" formatter="{numfmt}" textAlign="right"/>');	//소매부가세
			layoutStr2.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num10}" formatter="{numfmt}" textAlign="right"/>');	//금액합계
			layoutStr2.push('				<DataGridFooterColumn/>');
			layoutStr2.push('			</DataGridFooter>');
			layoutStr2.push('		</footers>'); 
			layoutStr2.push('	</DataGrid>');
			layoutStr2.push('</rMateGrid>');
			
		};

	/**
	 * 조회기준-생산자 그리드 이벤트 핸들러2
	 */
	function gridReadyHandler2(id) {
		gridApp2 = document.getElementById(id); // 그리드를 포함하는 div 객체
		gridRoot2 = gridApp2.getRoot(); // 데이터와 그리드를 포함하는 객체
		gridApp2.setLayout(layoutStr2.join("").toString());
		
		var layoutCompleteHandler2 = function(event) {
			dataGrid2 = gridRoot2.getDataGrid(); // 그리드 객체
			dataGrid2.addEventListener("change", selectionChangeHandler2);
			gridApp2.setData([]);
		}
		var dataCompleteHandler2 = function(event) {
			dataGrid2 = gridRoot2.getDataGrid(); // 그리드 객체
		}
		var selectionChangeHandler2 = function(event) {
			var rowIndex = event.rowIndex;
			var columnIndex = event.columnIndex;
			selectorColumn2 = gridRoot2.getObjectById("selector");
			rowIndexValue = rowIndex;
			fn_rowToInput(rowIndex);
		}
		gridRoot2.addEventListener("dataComplete", dataCompleteHandler2);
		gridRoot2.addEventListener("layoutComplete", layoutCompleteHandler2);
	}

	
	

/****************************************** 그리드 셋팅 끝***************************************** */


</script>

<style type="text/css">

.srcharea .row .col .tit{
width: 81px;
}
#btn_upd2 ,#btn_upd3{
margin-left: 10px;
}

</style>

</head>
<body>
    <div class="iframe_inner" id="" >
    
    		<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
    		<input type="hidden" id="ctnr_se_list" value="<c:out value='${ctnr_se_list}' />" />
    		<input type="hidden" id="ctnr_prps_list" value="<c:out value='${ctnr_prps_list}' />" />
    		<input type="hidden" id="rmk_list" value="<c:out value='${rmk_list}' />" />
    		<input type="hidden" id="std_mgnt_list" value="<c:out value='${std_mgnt_list}' />" />
    		<input type="hidden" id="mfc_bizrnmList" value="<c:out value='${mfc_bizrnmList}' />" />

			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
				<div class="btn" style="float:right" id="UR"><!--인쇄  -->
				</div>
			</div>
			
			
		<section class="secwrap"  id="params">
			<div class="srcharea" style="" id="divInput" > 
				<div class="row" >
					<div class="col"  >
						<div class="tit" id="exca_term"></div><!--정산기간-->
						<div class="box">
							<select  id=EXCA_STD_CD_SE style="width: 200px" class="i_notnull"></select>
						</div>
					</div>
					<div class="col" style="">
						<div class="tit" id="crct_rtn_dt"></div>	<!-- 정정반환일자 -->
						<div class="box">
							<div class="calendar">
								<input type="text" id="CRCT_RTN_DT" name="" style="width: 200px;" class="i_notnull">
							</div>
						</div> 
					</div>
					<div class="col" style="">
						<div class="tit" id="crct_wrhs_dt"></div>	<!-- 입고확인일자 -->
						<div class="box">
							<div class="calendar">
								<input type="text" id="CRCT_WRHS_CFM_DT" name="" style="width: 200px;" class="i_notnull">
							</div>
						</div> 
					</div>
				</div>
				<div class="row" >
					<div class="col" style="">
						<div class="tit" id="mfc_bizrnm"></div>
						<div class="box">
							<select id="MFC_BIZRNM" style="width: 200px" class="i_notnull" ></select>
						</div> 
					</div>
					<div class="col" style="">
						<div class="tit" id="mfc_brch_nm"></div>
						<div class="box">
							<select id="MFC_BRCH_NM" style="width: 200px" class="i_notnull" ></select>
						</div> 
					</div>
				</div>
				<div class="row" >
					<div class="col" style="">
						<div class="tit" id="whsdl"></div>
						<div class="box">
							<select id="WHSDL_BIZRNM" style="width: 200px"  ></select>
						</div> 
					</div>
					<div class="col" style="">
						<div class="tit" id="whsdl_brch"></div>
						<div class="box">
							<select id="WHSDL_BRCH_NM" style="width: 200px" class="i_notnull" ></select>
						</div> 
					</div>
				</div>
			
			</div><!-- end of srcharea -->
		</section>
		
		<section class="secwrap mt10">
				<div class="srcharea"  id="divInput2" > 
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
							<div class="box" style="" >
								<select id="CTNR_CD"  class="i_notnull" style="width: 200px;" ></select>
							</div>
						</div>
					</div> <!-- end of row -->
					<div class="row">
						<div class="col">
							<div class="tit"  style="width:120px" id="rtl_fee_aplc_yn"></div>  
							<div class="box" id="RMK_LIST" style="">   
								<label class="rdo"><input type="radio" id="select_rtl1" name="select_rtl" value="aplc"  checked="checked"><span id="">적용</span></label>
								<label class="rdo"><input type="radio" id="select_rtl2" name="select_rtl" value="ext"  ><span id="">제외</span></label>
							</div>
						</div>
						<div class="col" style="">
							<div class="tit" >비고</div>  <!-- 비고 -->
							<div class="box"  style="">
									<select id="RMK_SELECT" style="width: 40%"  disabled="disabled"></select>
									<input type="text"  id="RMK" style="width: 58%; max-width: 610px" maxByteLength="30"  disabled="disabled" />
							</div> 
						</div>
					</div> <!-- end of row -->
					<div class="row">
						<div class="col"  style="width:31%">
							<div class="tit" id="dmgb_qty"></div>  <!-- 결병 -->
							<div class="box">
								<input type="text" id="DMGB_QTY" style="" format="number"  maxlength="8" />
							</div>
						</div>
						<div class="col" style="width:31%">
							<div class="tit" id="vrsb_qty"></div>  <!-- 잡병 -->
							<div class="box">
								<input type="text" id="VRSB_QTY" style="" format="number" maxlength="8" />
							</div>
						</div>
						<div class="col" style="width:31%">
							<div class="tit" id="cfm_qty"></div>  <!-- 확인량 -->
							<div class="box">
								<input type="text" id="CFM_QTY" style="" format="number" maxlength="8" class="i_notnull"/>
							</div>
						</div>
						
					</div> <!-- end of row -->
					<div class="singleRow" style="float:right ">
						<div class="btn" id="CR"></div>
					</div>
					
				</div>  <!-- end of srcharea -->
			</section>	
			
			<div class="boxarea mt10">
				<div id="gridHolder2" style="height: 360px; background: #FFF;"></div>
			</div>	<!-- 그리드 셋팅 -->
			
		<section class="btnwrap" style="height: 50px; margin-top:10px" >
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR"></div>
		</section>
</div>

</body>
</html>