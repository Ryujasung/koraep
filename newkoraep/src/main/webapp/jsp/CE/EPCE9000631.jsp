<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>무인회수기내역작성</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script src="/js/kora/paging_common.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />
<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS;	//파라미터 데이터
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
	 var AreaCdList;
	 var urm_list; //소매점명 조회
	 var urm_list2; 
	 var rtrvl_cd_list;	//회수용기조회
	 var dps_fee_list;	
	 
     $(function() {
    	 
    	INQ_PARAMS 		= jsonObject($("#INQ_PARAMS").val());	//파라미터 데이터
    	rtc_dt_list 			= jsonObject($("#rtc_dt_list").val());			//등록일자제한설정	
    	urm_list 		= jsonObject($("#urm_list").val());	
    	urm_list2 		= jsonObject($("#urm_list2").val());	
   	   AreaCdList = jsonObject($('#AreaCdList').val());
   	rtrvl_cd_list = jsonObject($('#rtrvl_cd_list').val());
    	
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
		$('#rtn_gtn').text(parent.fn_text('rtn_gtn')); 			 														//반환량(개)
		
		//div필수값 alt
		 $("#RTRVL_DT").attr('alt',parent.fn_text('rtrvl_dt'));   
		 $("#MFC_BIZRNM").attr('alt',parent.fn_text('rtrvl_trgt')+parent.fn_text('mfc_bizrnm'));				//기준취습수수료
		 $("#MFC_BRCH_NM").attr('alt',parent.fn_text('rtrvl_trgt')+parent.fn_text('mfc_brch_nm'));   	//최저 기준취습수수료    
		 $("#PRPS_CD").attr('alt',parent.fn_text('ctnr_se'));   	
		 $("#CTNR_CD").attr('alt',parent.fn_text('ctnr_nm'));   	
		 $("#RTN_QTY").attr('alt',parent.fn_text('rtn_qty'));															//기준취습수수료
		 $("#BOX_QTY").attr('alt',parent.fn_text('box_qty'));															//상자
		 $("#CAR_NO").attr('alt',parent.fn_text('car_no'));   															//최저 기준취습수수료    
		 $("#RTN_GTN").attr('alt',parent.fn_text('rtn_gtn'));
		 
		/************************************
		 * 도매업자 구분 변경 이벤트
		 ***********************************/
		$("#WHSL_SE_CD").change(function(){
			fn_whsl_se_cd();
		});
		 
		/************************************
		 * 업체명  변경 이벤트
		 ***********************************/
		$("#URM_NM").change(function(){
			fn_urm_nm();
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
		$("#RTRVL_DT").click(function(){
			    var rtn_dt = $("#RTRVL_DT").val();
			    rtn_dt   =  rtn_dt.replace(/-/gi, "");
			     $("#RTRVL_DT").val(rtn_dt)
		});
		
		/************************************
		 * 시작날짜  클릭시 - 추가 변경 이벤트
		 ***********************************/
		$("#RTRVL_DT").change(function(){
			
		     var rtn_dt = $("#RTRVL_DT").val();
		     rtn_dt   =  rtn_dt.replace(/-/gi, "");
			if(rtn_dt.length == 8)  rtn_dt = kora.common.formatter.datetime(rtn_dt, "yyyy-mm-dd")
		     $("#RTRVL_DT").val(rtn_dt) 
		      if($("#RTRVL_DT").val() !=flag_DT){ //클릭시 날짜 변경 할경우   기존날짜랑 현재날짜랑 다를 경우  데이터 초기화
		     	 flag_DT = $("#RTRVL_DT").val();  //변경시 날짜 
		     	 fn_rtrvl_dt();	
		     } 
		});
		/************************************
		 * 회수량 변경시 - 소매수수료 계산
		 ***********************************/
		$("#URM_QTY").change(function(){
			
			if($("#URM_QTY").val() != '' && $("#RTRVL_CTNR_CD").val() != ''){
				for(var i=0; i<dps_fee_list.length; i++){
					if(dps_fee_list[i].RTRVL_CTNR_CD == $("#RTRVL_CTNR_CD").val() ) {
						var rtrvlFee = Number($("#URM_QTY").val().replace(/\,/g,"")) * Number(dps_fee_list[i].RTRVL_FEE); // 소매수수료 자동계산
						$('#RTRVL_RTL_FEE').val(kora.common.format_comma(rtrvlFee));
						break;		
					}
				}
			}
			
		});
		
		/************************************
		 * 빈용기명 변경 이벤트
		 ***********************************/
		 $("#RTRVL_CTNR_CD").change(function(){

			 if($("#RTRVL_CTNR_CD").val() != ''){
				 
				$("#URM_QTY").trigger('change');
				 
				
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
// 				$("#URM_NM").prop("disabled",true);
// 				$("#SERIAL_NO").prop("disabled",true);
				kora.common.gfn_excelUploadPop("fn_popExcel");
			//}
		});
		
  		fn_init();
    	$("#ENP_NM").select2();
    	$("#URM_NM").select2();	
	});
     
	 
     //초기화
     function fn_init(){
//     	if(regGbn){
// 	    	 kora.common.setEtcCmBx2([], "","", $("#ENP_NM"), "ETC_CD", "ETC_CD_NM", "N" ,'S');							//업체명
// 			 kora.common.setEtcCmBx2([], "","", $("#BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S');						//지점
//     	}
    	
    	//kora.common.setEtcCmBx2(whsl_se_cd, "","", $("#WHSL_SE_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');			//도매업자구분
    	kora.common.setEtcCmBx2(rtrvl_cd_list, "","", $("#RTRVL_CTNR_CD"), "RTRVL_CTNR_CD", "CTNR_NM", "N" ,'T');		
    	kora.common.setEtcCmBx2(AreaCdList, "", "", $("#AreaCdList_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
    	kora.common.setEtcCmBx2(urm_list, "","", $("#URM_NM"), "URM_CODE_NO", "URM_NM", "N" ,'T');		//도매업자 업체명
		//kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");							//빈용기구분
		kora.common.setEtcCmBx2(ctnr_seList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');				//빈용기구분 코드
		kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');							//빈용기명
		//kora.common.setEtcCmBx2(rmk_list, "","", $("#RMK_SELECT"), "ETC_CD", "ETC_CD_NM", "N" ,'S');					//비고
		$('#RTRVL_DT').val(kora.common.formatter.datetime(toDay, "yyyy-mm-dd"));
		$("#URM_NM").select2();	
		
		flag_DT = $("#RTRVL_DT").val(); 
		$("#URM_QTY").val("");
		$("#select_rtl1").prop("checked", true)
		//$("#RMK_SELECT").prop("disabled",true);
    	
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
   
   	//소매점명 변경시
   	function fn_urm_nm(){
 		var url = "/CE/EPCE9000601_19.do" 
		var input ={};
 		if($("#URM_NM").val() !=""){
 			arr=[];
		   	//arr = $("#ENP_NM").val().split(";"); 
		   	//input["BIZRID"] 	= arr[0];
		   	//input["BIZRNO"] 	= arr[1];
		   	input["URM_CODE_NO"] =$("#URM_NM").val();
		   	input["RTRVL_DT"] 	= $("#RTRVL_DT").val();
       	   	ajaxPost(url, input, function(rtnData) {
    				if ("" != rtnData && null != rtnData) { 
						dps_fee_list = rtnData.dps_fee_list;
						kora.common.setEtcCmBx2(rtnData.dps_fee_list, "", "", $("#RTRVL_CTNR_CD"), "RTRVL_CTNR_CD", "CTNR_NM", "N" ,'S');	//빈용기명(소매)
    					kora.common.setEtcCmBx2(rtnData.serialList, "","", $("#SERIAL_NO"), "SERIAL_NO", "URM_CE_NO", "N","S");//지점
    				}else{   
    						 alertMsg("error");   
    				}   
    		},false);
 		}else{
 			 kora.common.setEtcCmBx2([], "","", $("#SERIAL_NO"), "SERIAL_NO", "URM_CE_NO", "N" ,'S');	//지점 
 		}
 		
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
//-------------------------------------------------------------------------------------------------------------------------------------------------------------
	 
	 //행등록
	function fn_reg2(){
		
		var urm_receipt_nochk = $("#URM_RECEIPT_NO").val();
// 		console.log(urm_receipt_nochk); 
// 		console.log(kora.common.null2void(urm_receipt_nochk,0));
// 		console.log(urm_receipt_nochk.length);
		 if(kora.common.format_noComma(kora.common.null2void($("#URM_NM").val(),0))  < 1) {
            alertMsg("11");
            return;
        }
		 if(kora.common.format_noComma(kora.common.null2void($("#SERIAL_NO").val(),0))  < 1) {
	            alertMsg("22");
	            return;
	        }
		 if(kora.common.format_noComma(kora.common.null2void($("#RTRVL_CTNR_CD").val(),0))  < 1) {
            alertMsg("용량(신/구병)을(를) 선택하십시요.");
            return;
        }else if(kora.common.format_noComma(kora.common.null2void($("#URM_QTY").val(),0))  < 1) {
            alertMsg("회수량을(를) 입력하십시요.");
            return;
        }else if(!kora.common.fn_validDate($("#RTRVL_DT").val())){  	
			alertMsg("올바른 날짜 형식이 아닙니다.");
			return;
		}else if(kora.common.format_noComma(kora.common.null2void($("#URM_RECEIPT_NO").val(),0))  < 1) {
            alertMsg("영수증번호(를) 입력하십시요.");
            return;
		}else if(urm_receipt_nochk.length > 4 || urm_receipt_nochk.length < 4 ){
			alertMsg("영수증번호는 4자리입니다.(0000~9999)");
			return;
		}
		else if( $("#URM_NM").val() != "" ) {
// 			$("#URM_NM").prop("disabled",true);
// 			$("#SERIAL_NO").prop("disabled",true);
// 			$("#URM_RECEIPT_NO").prop("disabled",true);
		} 
           
		 
		regGbn 		=	false;
		var input 	=	insRow("A");
		if(!input){
			return;
		}
		console.log("A : "+ input);
		gridRoot.addItemAt(input);
		dataGrid.setSelectedIndex(-1);			  
	}
	 //행 수정
	function fn_upd(){
		var idx = dataGrid.getSelectedIndex();
		console.log("1");
		console.log(idx);
		if(idx < 0) {
			alertMsg("변경할 행을 선택하시기 바랍니다.");
			return;
		}
		 if(kora.common.format_noComma(kora.common.null2void($("#URM_NM").val(),0))  < 1) {
	            alertMsg("11");
	            return;
	        }
			 if(kora.common.format_noComma(kora.common.null2void($("#SERIAL_NO").val(),0))  < 1) {
		            alertMsg("22");
		            return;
		        }
		
		 
		 if(kora.common.format_noComma(kora.common.null2void($("#RTRVL_CTNR_CD").val(),0))  < 1) {
	            alertMsg("용량(신/구병)을(를) 선택하십시요.", "kora.common.cfrmDivChkValid_focus");
	            chkTarget = $("#RTRVL_CTNR_CD");
	            
	            return;
	        } 

		 if(kora.common.format_noComma(kora.common.null2void($("#URM_QTY").val(),0))  < 1) {
	            alertMsg("회수량을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	            chkTarget = $("#URM_QTY");
	            
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
		console.log("M : "+ item);
		// 해당 데이터의 이전 수정내역을 삭제
		gridRoot.removeChangedData(gridRoot.getItemAt(idx));
		//해당 데이터 수정
		gridRoot.setItemAt(item, idx);
		//dataGrid.setSelectedIndex(-1);			
		$("#SERIAL_NO").val("");
		$("#URM_NM").select2("val","");
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
		if($("#URM_QTY").val() == '0'){
			alert("회수량 입력은 필수입니다.");
			return false;
		}if($("#SERIAL_NO").val() == null){
			alert("무인회수기 선택해주세요.");
			return false;
		}
		if($("#URM_NM option:selected").text() == null){
			alert("소매점을 선택해주세요.");
			return false;
		}
		
			var input = {};
		   
		    if(!kora.common.fn_validDate_ck( "R", $("#RTRVL_DT").val())){ //등록일자제한 체크
				return;
			}
		    
		    var collection = gridRoot.getCollection();  //그리드 데이터
		    for(var i=0; i<collection.getLength(); i++) {
	 	    	var tmpData = gridRoot.getItemAt(i);
	 	    	
	 	    	/* if(tmpData["RTRVL_CTNR_CD"] == $("#RTRVL_CTNR_CD").val() && tmpData["RTRVL_DT"] == $("#RTRVL_DT").val() &&tmpData["URM_RECEIPT_NO"] == $("#URM_RECEIPT_NO").val() ) { 
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
	 	    	else  */
	 	    	if(tmpData["URM_RECEIPT_NO"] == $("#URM_RECEIPT_NO").val() && tmpData["SERIAL_NO"] == $("#SERIAL_NO").val() 
	 	    			&& tmpData["RTRVL_DT"] == $("#RTRVL_DT").val() && tmpData["RTRVL_CTNR_CD"] == $("#RTRVL_CTNR_CD").val() ) { 
	 	    		console.log(tmpData["RTRVL_CTNR_CD"]);
	 	    		console.log($("#RTRVL_CTNR_CD").val());
	 	    		
					if(gbn == "M") {
						if(rowIndexValue != i) {
				    		alertMsg("중복 데이터입니다.");
				    		return false;
				    	}
					} else {
			    		alertMsg("중복 데이터입니다.");
			    		return false;
					}
				}
	 	    	else if(tmpData["URM_RECEIPT_NO"] == $("#URM_RECEIPT_NO").val() && tmpData["SERIAL_NO"] == $("#SERIAL_NO").val() 
	 	    			&& tmpData["RTRVL_DT"] == $("#RTRVL_DT").val() && tmpData["RECEIPT_SN"] == $("#RECEIPT_SN").val()  ) { 
					if(gbn == "M") {
						if(rowIndexValue != i) {
				    		alertMsg("동일한 순번이 있습니다.");
				    		return false;
				    	}
					} else {
			    		alertMsg("동일한 순번이 있습니다..");
			    		return false;
					}
				}
	 	    	
	 		    
		    }
// 		    alert(collection.getLength());
			 if(gbn == "M") {
// 				alert("M");
// 				alert(collection.getLength());
				if(rowIndexValue != i) {
					if(collection.getLength() == 0 ) {
			    		console.log("여기여기");
				    	input["RECEIPT_SN"] 				= 	1;
				    }else{
				    	var sn = 1;
				    	
			    		for(var i=0; i<collection.getLength(); i++) {
			    			var tmpData = gridRoot.getItemAt(i);
// 			    			console.log(tmpData);
// 			    			console.log(tmpData["URM_RECEIPT_NO"]);
// 			    			console.log($("#URM_RECEIPT_NO").val());
// 			    			console.log(tmpData["SERIAL_NO"]);
// 			    			console.log($("#SERIAL_NO").val() );
// 			    			console.log(tmpData["RTRVL_DT"]);
// 			    			console.log($("#RTRVL_DT").val());
// 			    			console.log(tmpData["RECEIPT_SN"]);
// 			    			console.log($("#RECEIPT_SN").val());
					    	if(tmpData["URM_RECEIPT_NO"] == $("#URM_RECEIPT_NO").val() && tmpData["SERIAL_NO"] == $("#SERIAL_NO").val() 
					    			&& tmpData["RTRVL_DT"] == $("#RTRVL_DT").val()){
					    		if(tmpData["RECEIPT_SN"] != null){
					    			sn = tmpData["RECEIPT_SN"]+1
					    		}
					    		/* alert("tmpData"+tmpData);
						    	
						    	alert("#URM_RECEIPT_NO"+$("#URM_RECEIPT_NO").val());
				    			sn++;
				    			alert(sn); */
				    		}
				    		
				    	}
				    	input["RECEIPT_SN"] = sn;
				    }
				}
				
			} else {
// 				alert("n"); 
				if(collection.getLength() == 0 ) {
					console.log("여기여기");
			    	input["RECEIPT_SN"] 				= 	1;
			    }else{
			    	var sn = 1;
			    	
		    		for(var i=0; i<collection.getLength(); i++) {
		    			var tmpData = gridRoot.getItemAt(i);
// 		    			console.log(tmpData);
// 		    			console.log(tmpData["URM_RECEIPT_NO"]);
// 		    			console.log($("#URM_RECEIPT_NO").val());
// 		    			console.log(tmpData["SERIAL_NO"]);
// 		    			console.log($("#SERIAL_NO").val() );
// 		    			console.log(tmpData["RTRVL_DT"]);
// 		    			console.log($("#RTRVL_DT").val());
				    	if(tmpData["URM_RECEIPT_NO"] == $("#URM_RECEIPT_NO").val() && tmpData["SERIAL_NO"] == $("#SERIAL_NO").val() 
				    			&& tmpData["RTRVL_DT"] == $("#RTRVL_DT").val()){
// 				    		alert("tmpData"+tmpData);
					    	
// 					    	alert("#URM_RECEIPT_NO"+$("#URM_RECEIPT_NO").val());	
			    			sn++;
// 			    			alert(sn);
			    		}
			    		
			    	}
			    	input["RECEIPT_SN"] = sn;
			    }
			}
	    	
		    
		    
		//    for(var i = 0; i)
		    
			for(var i=0; i<dps_fee_list.length; i++){
				if(dps_fee_list[i].RTRVL_CTNR_CD == $("#RTRVL_CTNR_CD").val()) {
						input["CTNR_NM"] 					= 	$("#RTRVL_CTNR_CD option:selected").text();	//빈용기명
					    input["RTRVL_CTNR_CD"] 			= 	$("#RTRVL_CTNR_CD").val(); 							//빈용기 코드
					    input["PRPS_CD"] 					= 	dps_fee_list[i].PRPS_CD;
					    input["PRPS_NM"] 					= 	dps_fee_list[i].PRPS_NM;								//용도
					    input["URM_QTY"] 				= 	$("#URM_QTY").val().replace(/\,/g,"");									//회수량
					    input["URM_GTN"] 				= 	input["URM_QTY"] * dps_fee_list[i].RTRVL_DPS; 	//보증금(원) - 합계
					    input["RTRVL_RTL_FEE"]    		=	input["URM_QTY"] *dps_fee_list[i].RTRVL_FEE;		//회수소매수수료
					    input["AMT_TOT"] 					=	Number(input["URM_GTN"])+ Number(input["RTRVL_RTL_FEE"]);  //총합계
						break;		
				}
			}
			input["URM_NM"] = $("#URM_NM option:selected").text();
			input["URM_RECEIPT_NO"] 				= 	$("#URM_RECEIPT_NO").val();
// 			input["RECEIPT_SN"] 				= $("#RECEIPT_SN").val();
			input["URM_CODE_NO"] = $("#URM_NM").val();
			input["SERIAL_NO"] = $("#SERIAL_NO").val();
			input["RTRVL_DT"]					= 	$("#RTRVL_DT").val();                           			//회수일자
			input["URM_RECEIPT_NO"]					= 	$("#URM_RECEIPT_NO").val();                           			//회수일자
			
			input["SYS_SE"]						= 'W';//시스템구분
			console.log(input);
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
	
	//회수일자 변경시
	   function fn_rtrvl_dt(){
			var url = "/CE/EPCE9000631_19.do"; 
			var input ={};
			input["RTRVL_DT"] = $("#RTRVL_DT").val();
	      	ajaxPost(url, input, function(rtnData) {
	   				if ("" != rtnData && null != rtnData) {   
	   					dps_fee_list = rtnData.dps_fee_list;
	   					kora.common.setEtcCmBx2(rtnData.dps_fee_list, "","", $("#RTRVL_CTNR_CD"), "RTRVL_CTNR_CD", "CTNR_NM", "N" ,'S');	//빈용기명(소매)
	   				}else{
						alertMsg("error");
	   				}
	   		});
	   }
	
	function fn_reg_exec(){
		
		var data = {"list": ""};
		var row = new Array();
		var url = "/CE/EPCE9000631_09.do"; 
		var collection = gridRoot.getCollection();
		
	 	for(var i=0;i<collection.getLength(); i++){
	 		var tmpData = gridRoot.getItemAt(i);
	 		row.push(tmpData);//행 데이터 넣기
	 	}//end of for
		data["list"] = JSON.stringify(row);
		ajaxPost(url, data, function(rtnData){
			if(rtnData != null && rtnData != ""){
					if(rtnData.RSLT_CD =="A003"){ // 중복일경우
						alertMsg("시리얼번호 "+rtnData.ERR_CTNR_NM+"은 " +rtnData.RSLT_MSG);
					}else if(rtnData.RSLT_CD =="A030"){
						alertMsg("시리얼번호 "+rtnData.ERR_CTNR_NM+"은 " +rtnData.RSLT_MSG);
					}else if(rtnData.RSLT_CD =="B023"){
						alertMsg("회수용기코드 "+rtnData.ERR_CTNR_NM+"은 " +rtnData.RSLT_MSG);
					}else if(rtnData.RSLT_CD =="0000"){
						alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
					}else if(rtnData.RSLT_CD !="0000"){
					    alertMsg(rtnData.ERR_CTNR_NM);
					}else{
						alert('dd');
						alertMsg(rtnData.RSLT_MSG);
					}
			}else{
					alertMsg("error");
			}

		});//end of ajaxPost
		
	}
	
	  //취소버튼 이전화면으로
    function fn_cnl(){
   	 kora.common.goPageB('/CE/EPCE9000601.do', INQ_PARAMS);
    }
	
	//선택한 행 입력창에 값 넣기
	function fn_rowToInput (rowIndex){
		
		var item = gridRoot.getItemAt(rowIndex);
		fn_dataSet(item);
		console.log(item);
		$("#SERIAL_NO").val("");
		$("#URM_NM").select2("val","");
// 		$("#RTRVL_DT").val("");
		$("#RTRVL_DT").val(item["RTRVL_DT"]);
		
		$("#select2-chosen-2").val("");  	
		$("#URM_GTN").val(item["URM_GTN"]);
		$("#URM_QTY").val(item["URM_QTY"]);
		$("#URM_RECEIPT_NO").val(item["URM_RECEIPT_NO"]);
		$("#RTRVL_RTL_FEE").val(item["RTRVL_RTL_FEE"]);
		$("#RTRVL_CTNR_CD").val( item["RTRVL_CTNR_CD"]).prop("selected", true); 				//회수용기
		
// 		prpsCdCheck();
	
	};
	function fn_dataSet(item){
		var input	={};
		console.log(item);
		var url 	 	= "/CE/EPCE9000631_19.do"; 
		ctnr_nm=[];
		input["RTRVL_DT"] 				= item["RTRVL_DT"];			//반환일자 
       	ajaxPost(url, input, function(rtnData) {
    			if ("" != rtnData && null != rtnData) {   
    				dps_fee_list = rtnData.dps_fee_list
    				kora.common.setEtcCmBx2(rtnData.dps_fee_list, "","", $("#RTRVL_CTNR_CD"), "RTRVL_CTNR_CD", "CTNR_NM", "N" ,'S');	//빈용기명(소매)		
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
     	var url 		= "/CE/EPCE9000631_197.do";
     	var flag 		= false;
     	var dup_cnt 		= 0;		//동일한 용기코드 + 생산자 + 지사가 있을경우
    	var err_cnt 			= 0;		//잘못된 데이터로 디비 정보가 없을 경우
    	var err_msg="";
    	var err_msg2="";
    	var megCheck =false;
    	var arr3 =new Array();
    	var arr4 =new Array();
		arr		=[];
		//arr 	= $("#ENP_NM").val().split(";"); 
		arr2 	= [];
		//arr2	= $("#BRCH_NM").val().split(";");
    	 for(var i=0; i<rtnData.length ;i++) {
//     		 alert(rtnData[i].영수증번호.length);
    		 if(rtnData[i].영수증번호.length > 4 ){
    				alertMsg("영수증번호는 4자리입니다.(1~9999)");
    				return;
    		 }	
    		 if(rtnData[i].회수량 =="0"){
 				alertMsg("회수량에 0을 입력할 수 없습니다.");
 				return;
 			 }	
    		 if(	rtnData[i].무인회수기시리얼번호 =="" &&
		    			rtnData[i].회수일자   =="" &&
		    			rtnData[i].영수증번호 =="" &&
		    			rtnData[i].영수증순번 =="" &&
		    			rtnData[i].용량코드 =="" &&
		    			rtnData[i].보증금 =="" &&
		    			rtnData[i].회수량 =="" ){ //행에 아무데이터가 없으면 패스
					continue;
	    		 }else  if(	rtnData[i].무인회수기시리얼번호 =="" ||
    			rtnData[i].회수일자 =="" ||
    			rtnData[i].영수증번호 =="" ||	
    			rtnData[i].영수증순번 =="" ||	
    			rtnData[i].용량코드 =="" ||
    			rtnData[i].보증금 =="" ||
    			rtnData[i].회수량 =="" ){
    			alertMsg("필수입력값이 없습니다.")
    			return;
    		 } 
//     	 }
//      	 for(var i=0; i<rtnData.length ;i++) {
     		flag= false
     		input["SERIAL_NO"]		=	rtnData[i].무인회수기시리얼번호;											//도매업자 사업자아이디
     		input["RTRVL_DT"]		=	rtnData[i].회수일자;											//도매업자 사업자 번호
     		input["URM_RECEIPT_NO"]	=	rtnData[i].영수증번호
     		input["RECEIPT_SN"]	=	rtnData[i].영수증순번
     		input["RTRVL_CTNR_CD"]		=	rtnData[i].용량코드;			//생산자 사업자번호
     		input["URM_GTN"]	=	rtnData[i].보증금;				//생산자 직매장 번호
     		input["URM_QTY"]				=	rtnData[i].회수량;						//반환일자
     		//input["REG_SN"] = rtnData[i].등록순번;
     		arr3=input;
     		//gridRoot.addItemAt(input);
			//input["PARAM_BTN_CD"]	= 'btn_excel_reg';								//버튼 코드
     		ajaxPost(url, input, function(rtnData) {
//      			gridRoot.addItemAt(rtnData.selList[0]);	
    				  if ("" != rtnData && null != rtnData) {
//     					alert("@1");
	    					if(rtnData.selList != undefined && rtnData.selList != null && rtnData.selList.length !=0){	// 쿼리상 데이터가 있을경우에만
	    							var collection = gridRoot.getCollection();  //그리드 데이터
	    							for(var i=0; i<collection.getLength(); i++) {
	    								var tmpData = gridRoot.getItemAt(i);
// 	    								console.log(tmpData["RTRVL_CTNR_CD"]);
// 	    								console.log(tmpData["SERIAL_NO"]);
// 	    								console.log(tmpData["URM_RECEIPT_NO"]);
// 	    								console.log(tmpData["RTRVL_DT"]);
// 	    								console.log("=");
// 	    								console.log(rtnData.selList[0].RTRVL_CTNR_CD);
// 	    								console.log(rtnData.selList[0].SERIAL_NO );
// 	    								console.log(rtnData.selList[0].URM_RECEIPT_NO);
// 	    								console.log(rtnData.selList[0].RTRVL_DT);
// 	    								console.log("?");
								    	if(tmpData["RTRVL_CTNR_CD"] == rtnData.selList[0].RTRVL_CTNR_CD // 쿼리상 데이터는 있지만 동일한용기코드가 있을경우.
								    			&& tmpData["SERIAL_NO"] == rtnData.selList[0].SERIAL_NO 
								    			&& tmpData["URM_RECEIPT_NO"] == rtnData.selList[0].URM_RECEIPT_NO  
								    			&& tmpData["RTRVL_DT"] == rtnData.selList[0].RTRVL_DT 
								    	) {
								    			flag =true;
// 								    			arr3[dup_cnt]=input["SERIAL_NO"]+" ," +input["URM_RECEIPT_NO"]+" ,"+input["RTRVL_DT"]+" ,"+input["RTRVL_CTNR_CD"];
								    			dup_cnt++;
										}
								    }	//end of for
									if(!flag)gridRoot.addItemAt(rtnData.selList[0]);	
	    					}else{// 쿼리상 데이터가 없을경우
// 	    						arr4[err_cnt]=input["SERIAL_NO"]+" ," +input["URM_RECEIPT_NO"]+" ,"+input["RTRVL_DT"]+" ,"+input["RTRVL_CTNR_CD"];
	    						err_cnt++;
	    					}
	    					
    				}else{
						alertMsg("error");
    				}  
    				  if(i == (rtnData.length - 1) ){
 		    			 megCheck =true;
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
			layoutStr.push('			<DataGridColumn dataField="index" 				 	headerText="'+ parent.fn_text('sn')+ '"						width="50" 	textAlign="center" 	  itemRenderer="IndexNoItem" />');			//순번
			//layoutStr.push('			<DataGridSelectorColumn id="selector" width="40" textAlign="center" allowMultipleSelection="true" vertical-align="middle"  draggable="false"/>');//선택 
			//layoutStr.push('			<DataGridColumn dataField="REG_SQ" headerText="번호" textAlign="center" width="50" draggable="false"/>');//순번
			layoutStr.push('			<DataGridColumn dataField="URM_NM" headerText="소매점명" textAlign="center" width="200"/>');
			layoutStr.push('			<DataGridColumn dataField="SERIAL_NO" headerText="무인회수기시리얼번호"  textAlign="center" width="200"  />');//도매업자구분
			layoutStr.push('			<DataGridColumn dataField="RTRVL_DT" headerText="회수일자"  textAlign="center" width="170"  />');//반환문서번호
// 			layoutStr.push('			<DataGridColumn dataField="AREA_CD" visible="false" headerText="지역" textAlign="center" width="200" />');//상태
			layoutStr.push('			<DataGridColumn dataField="PRPS_NM" headerText="용도구분" textAlign="center" width="150" />');//지역
			layoutStr.push('			<DataGridColumn dataField="CTNR_NM" headerText="용량(신구병)" textAlign="center" width="250" />');
			layoutStr.push('			<DataGridColumn dataField="URM_RECEIPT_NO" headerText="영수증번호" textAlign="center" width="100" />');
			layoutStr.push('			<DataGridColumn dataField="RECEIPT_SN" headerText="순번" textAlign="center" width="100" />');
// 			layoutStr.push('			<DataGridColumn dataField="STAT_NM" headerText="상태" textAlign="center" width="200" />');
// 			layoutStr.push('			<DataGridColumn dataField="URM_RECEIPT_NO" headerText="영수증번호" width="150" formatter="{numfmt}" id="num1"  textAlign="right" />');//회수량
			layoutStr.push('			<DataGridColumn dataField="URM_QTY" headerText="회수량" width="150" formatter="{numfmt}" id="num1"  textAlign="right" />');//회수량
			layoutStr.push('			<DataGridColumn dataField="URM_GTN" headerText="보증금" width="150" formatter="{numfmt}" id="num2"  textAlign="right" />');//보증금
			layoutStr.push('			<DataGridColumn dataField="RTRVL_RTL_FEE" headerText="수수료" width="150" formatter="{numfmt}" id="num3"  textAlign="right" />');//회수수수료
			layoutStr.push('			<DataGridColumn dataField="AMT_TOT" headerText="소계" width="150" formatter="{numfmt}" id="num4"  textAlign="right" />');//소계
			layoutStr.push('			<DataGridColumn dataField="SYS_SE"  	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="RTRVL_CTNR_CD"	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="PRPS_CD"	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="URM_CODE_NO"	visible="false" />');
			//layoutStr.push('			<DataGridColumn dataField="RTRVL_FEE" headerText="취급수수료" width="150" formatter="{numfmt}" id="num6"  textAlign="right" />');//도매수수료
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="'+parent.fn_text('totalsum')+'"  textAlign="center"/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num3}" formatter="{numfmt}" textAlign="right"/>');	
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num4}" formatter="{numfmt}" textAlign="right"/>');
// 			layoutStr.push('				<DataGridFooterColumn/>');
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

 #s2id_URM_NM{
    width: 100%
}
</style>

</head>
<body>
    <div class="iframe_inner"  >
			<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="rmk_list" value="<c:out value='${rmk_list}' />" />
			<input type="hidden" id="rtc_dt_list" value="<c:out value='${rtc_dt_list}' />" />
			<input type="hidden" id="urm_list2" value="<c:out value='${urm_list2}' />" />
			<input type="hidden" id="urm_list" value="<c:out value='${urm_list}' />" />
			<input type="hidden" id="AreaCdList" value="<c:out value='${AreaCdList}' />"/>
			<input type="hidden" id="rtrvl_cd_list" value="<c:out value='${rtrvl_cd_list}' />" />
			<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
				<div class="singleRow">
				<div class="btn" id="UR"></div>
				</div>
				
				<!--btn_dwnd  -->
				<!--btn_excel  -->
			</div>
			   
			<section class="secwrap">
				<div class="srcharea" > 
				<div class="row" >
						<div class="col" >
							<div class="tit" style="width: 90px">소매점</div>  <!--도매업자 구분 -->
							<div class="box">
								<select id="URM_NM" name="URM_NM"  ></select>
							</div>
						</div>
						<div class="col" style="width: 50%">
							<div class="tit" id="serial_no" style="width: 90px;">시리얼번호</div>  <!-- 도매업자 사업자번호 -->
							<div class="box">
								<select id="SERIAL_NO" style="width: 300px" class="i_notnull"  ></select>
								<!-- <div class="txtbox" id="WHSDL_BIZRNO"></div> -->	
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
							<div class="tit" style="width: 90px">영수증번호</div>  반환대상 직매장/공장
							<div class="box" style="">
								<input type="text"  id="URM_RECEIPT_NO"  class="i_notnull" />
							</div>
						</div> -->
						<div class="col">
							<div class="tit">용량(신/구병)</div>  <!-- 빈용기구분 -->
							<div class="box">
								<!-- <select id="CPCT_CD"   class="i_notnull" ></select> -->
							<select id="RTRVL_CTNR_CD" style="width: 200px" class="i_notnull" ></select>
							</div>
						</div>
						
					</div> <!-- end of row -->
					<div class="row">
						<div class="col">
							<div class="tit" >회수량</div> 
							<div class="box" >
								<input type="text"  id="URM_QTY"  class="i_notnull" />
							</div>
						</div>
						<div class="col">
							<div class="tit">소매수수료</div>  <!-- 빈용기구분 -->
							<div class="box" style="" >
								<input type="text" id="RTRVL_RTL_FEE" style="text-align:right; format="minus"   class="i_notnull"  />
							</div>
						</div>
						<div class="col">
							<div class="tit" >영수증번호</div> 
							<div class="box" >
								<input type="number"  id="URM_RECEIPT_NO" maxlength="4" class="i_notnull" />
							</div>
						</div>
					</div>
					
					<!-- <div class="row">
						<div class="col">
							<div class="tit" >영수증번호</div> 
							<div class="box" >
								<input type="number"  id="URM_RECEIPT_NO" maxlength="4" class="i_notnull" />
							</div>
						</div>
						<div class="col">
							<div class="tit">순번</div>  빈용기구분
							<div class="box" style="" >
								<input type="text" id="RECEIPT_SN" style="text-align:right; format="minus"   class="i_notnull"  />
							</div>
						</div>
					</div> -->
					<div style="float:right ;margin-top: 10px" id="CR" ></div>
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
				<div class="btn" style="float:right; margin-top: 10px;" id="BR"></div>
		</section>
		
		
</div>

<form name="downForm" id="downForm" action="" method="post">
	<input type="hidden" name="fileName" value="URM_INFO_EXCEL_FORM.xlsx" />
	<input type="hidden" name="downDiv" value="" /> <!-- 공지사항 첨부 다운일경우 noti, 업로드 폴더인경우 up 로 넣어준다-->
</form>

</body>
</html>