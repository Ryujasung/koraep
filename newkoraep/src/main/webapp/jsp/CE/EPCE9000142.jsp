<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>P-BOX정보등록</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />
<script type="text/javaScript" language="javascript" defer="defer">

	 var INQ_PARAMS;	//파라미터 데이터
     var toDay = kora.common.gfn_toDay();  // 현재 시간
	 var rowIndexValue =0;
     var whsdl_cd_list;								//도매업자
     var dps_fee_list;								//회수용기 보증금,취급수수료
     var whsdl_bizrnm_chk;
	 var stat_cd_list;   // pbox상태코드
	 var AreaCdList;
     $(function() {
    	 
    	INQ_PARAMS 		= jsonObject($("#INQ_PARAMS").val());	
    	whsdl_cd_list 		= jsonObject($("#whsdl_cd_list").val());		
    	rtc_dt_list 			= jsonObject($("#rtc_dt_list").val());			//등록일자제한설정	
    	stat_cd_list 			= jsonObject($("#stat_cd_list").val());			//pbox상태코드	
    	AreaCdList = jsonObject($('#AreaCdList').val());
    	//초기 셋팅
    	fn_init();
    	 
    	//버튼 셋팅
    	fn_btnSetting();
    	 
    	//그리드 셋팅
		fnSetGrid1();
		 
		//날짜 셋팅
  	    $('#RTRVL_DT').YJcalendar({  
 			triggerBtn : true,
 			dateSetting: INQ_PARAMS.RTRVL_DT
 		});
		
		/************************************
		 * 도매업자  변경 이벤트
		 ***********************************/
		$("#WHSDL_BIZRNM").change(function(){
			fn_whsdl_bizrnm();
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
		     var dt = $("#RTRVL_DT").val();
		     dt   =  dt.replace(/-/gi, "");
			 if(dt.length == 8)  dt = kora.common.formatter.datetime(dt, "yyyy-mm-dd")
	     	 $("#RTRVL_DT").val(dt) 
	     	 if($("#RTRVL_DT").val() !=flag_DT){ 		//클릭시 날짜 변경 할경우   기존날짜랑 현재날짜랑 다를 경우  데이터 초기화
			     	flag_DT = $("#RTRVL_DT").val();  	//변경시 날짜 
			     	//fn_rtrvl_dt();
	   		  } 
		});
		
		/************************************
		 * 회수량 변경시 - 소매수수료 계산
		 ***********************************/
// 		$("#RTRVL_QTY").change(function(){
			
// 			if($("#RTRVL_QTY").val() != '' && $("#RTRVL_CTNR_CD").val() != ''){
// 				for(var i=0; i<dps_fee_list.length; i++){
// 					if(dps_fee_list[i].RTRVL_CTNR_CD == $("#RTRVL_CTNR_CD").val() ) {
// 						var rtrvlFee = Number($("#RTRVL_QTY").val().replace(/\,/g,"")) * Number(dps_fee_list[i].RTRVL_FEE); // 소매수수료 자동계산
// 						$('#REG_RTRVL_FEE').val(kora.common.format_comma(rtrvlFee));
// 						break;		
// 					}
// 				}
// 			}
			
// 		});
		
		/************************************
		 * 빈용기명 변경 이벤트
		 ***********************************/
// 		 $("#RTRVL_CTNR_CD").change(function(){

// 			 if($("#RTRVL_CTNR_CD").val() != ''){
				 
// 				$("#RTRVL_QTY").trigger('change');
				 
// 				prpsCdCheck();
// 			}
// 		 });
		
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
			//fn_upd();
			fn_reg2();
		});
		/************************************
		 * 행 추가 클릭 이벤트
		 ***********************************/
		$("#btn_reg2").click(function(){
			fn_reg2();
		});
		
		/************************************
		 * 등록 클릭 이벤트
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
			
			if( $("#WHSDL_BIZRNM").val()=="" ){
				alertMsg("도매업자를  선택해 주세요.");
				return;
			}else if(  $("#WHSDL_BIZRNM").val() != ""  ) {
				$("#WHSDL_BIZRNM").prop("disabled",true);
				kora.common.gfn_excelUploadPop("fn_popExcel");
				whsdl_bizrnm_chk = $("#WHSDL_BIZRNM").val(); 
			}
			
		});
		
        /************************************
         * 회수처 선택 박스 변경 이벤트
         ***********************************/
         $("#CUST_SEL").change(function(){
            
            //회수처 입력 선택
            var CUST_SEL_CK = $("input[type=radio][name=selectCust]:checked").val();
            
            if(CUST_SEL_CK=="Y"){
                $("#RTL_CUST_BIZRNO").val(""); //판매처번호 빈값으로
                $("#RTL_CUST_BIZRNM").val("");  //판매처명 빈값으로
                  
                $('#cust_y').attr('style', '');
                $('#cust_n1').attr('style', 'display:none');
                $('#cust_n2').attr('style', 'display:none');
              }else if(CUST_SEL_CK=="N"){
                  $("#WHSDL").find("option:eq(0)").prop("selected", true); //도매업자 선택 초기상태로
                  
                  $("#RTL_CUST_BIZRNO").val(""); //판매처번호 빈값으로
                  $("#RTL_CUST_BIZRNM").val("");  //판매처명 빈값으로
                  
                  $('#cust_y').attr('style', 'display:none');
                  $('#cust_n1').attr('style', '');
                  $('#cust_n2').attr('style', '');
              }
         });
        
         /************************************
         * 회수처 변경 이벤트
         ***********************************/
        $("#WHSDL").change(function(){
            //console.log('dd = ' + $("#WHSDL").val())
            $("#RTL_CUST_BIZRNO").val( $("#WHSDL").val() );
            $("#RTL_CUST_BIZRNM").val( $("#WHSDL option:checked").text() );
        });		
	});
     

    // 소매업자 콤보박스
    function fn_bizrNm(){
        var url = "/CE/EPCE2925831_194.do" 
        var input = {};
        
        var arr = $("#WHSDL_BIZRNM").val().split(";"); //도매업자        
        input["WHSDL_BIZRID"]       =   arr[0];        //도매업자 사업자아이디
        input["WHSDL_BIZRNO"]       =   arr[1];        //도매업자 사업자 번호
        
        ajaxPost(url, input, function(rtnData) {
            if ("" != rtnData && null != rtnData) {
                kora.common.setEtcCmBx2(rtnData.selList, "","", $("#WHSDL"), "CUST_BIZRNO_DE", "WHSDL_BIZRNM", "N" , "S");
                //$("#WHSDL").find("option:eq(0)").prop("selected", true);
                //$("#WHSDL").select2('val', "");
                //$("#WHSDL").select2();
            }
            else{
                alertMsg("error");
            }
        }, false);
    }
     
     
//      function prpsCdCheck(){
//     	 for(var i=0; i<dps_fee_list.length; i++){ 
//  			if(dps_fee_list[i].RTRVL_CTNR_CD == $("#RTRVL_CTNR_CD").val() ) { 
//  				if(dps_fee_list[i].PRPS_CD == '0'){//유흥용일 경우 소매수수료 수정 불가
//  					$('#REG_RTRVL_FEE').attr('readonly', 'readonly');
//  				}else{
//  					$('#REG_RTRVL_FEE').attr('readonly', false);
//  				}
//  				break;		
//  			}
//  		}
//      }
     
     //초기화
     function fn_init(){
//     	    kora.common.setEtcCmBx2(stat_cd_list, "","", $("#RTRVL_STAT_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'T');							//상태
			kora.common.setEtcCmBx2(whsdl_cd_list, "","", $("#WHSDL_BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'S');	//도매업자
			kora.common.setEtcCmBx2([], "","", $("#RTRVL_CTNR_CD"), "RTRVL_CTNR_CD", "CTNR_NM", "N" ,'S');	//빈용기명(소매)
			kora.common.setEtcCmBx2([], "","", $("#WHSDL_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S');		//지점
			kora.common.setEtcCmBx2(AreaCdList, "", "", $("#AreaCdList_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			/* $("#RMG_QTY").val(0);
			$("#DLIVY_QTY").val(0);
			$("#RTN_QTY").val(0);
			$("#DLIVY_GTN").val(0);
			$("#RTN_GTN").val(0);
			$("#RMK").val(""); */
			//$('#RTRVL_DT').val(kora.common.formatter.datetime(toDay, "yyyy-mm-dd")); 
			flag_DT = $("#RTRVL_DT").val(); 
			 
			//text 셋팅
			$('.row > .col > .tit').each(function(){
				//$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			$('#title_sub').text('<c:out value="${titleSub}" />');						   //타이틀
			//div필수값 alt
 			//$("#RTRVL_DT").val(kora.common.formatter.datetime(INQ_PARAMS.RTRVL_DT, "yyyy-mm-dd"));
                
	  		$("#RTL_CUST_BIZRNM").val(INQ_PARAMS.CUST_BIZRNM);
	  		$("#RTL_CUST_BIZRNO").val(INQ_PARAMS.CUST_BIZRNO);
	  		$("#WHSDL_BIZRNM").val(INQ_PARAMS.WHSDL_BIZRNM);
	  		$("#WHSDL_BIZRNO").val(INQ_PARAMS.WHSDL_BIZRNO);
	  		$("#AreaCdList_SEL").val(INQ_PARAMS.AREA_CD).prop("selected", true);
	  		$("#DLIVY_QTY").val(INQ_PARAMS.DLIVY_QTY);
	  		$("#RTN_QTY").val(INQ_PARAMS.RTN_QTY);
	  		$("#DST_QTY").val(INQ_PARAMS.DST_QTY);
	  		$("#PBOX_LST_NO").val(INQ_PARAMS.PBOX_LST_NO);
	  		
	  		
			//select2
			//$("#WHSDL_BIZRNM").select2();
     }
   
     //도매업자 선택 변경시
     function fn_whsdl_bizrnm(){
  	 		var url = "/CE/EPCE2925831_19.do" 
  			var input ={};
  			var arr=[];
  			if($("#WHSDL_BIZRNM").val() !=""){
  					arr = $("#WHSDL_BIZRNM").val().split(";"); 
  					input["BIZRID"] 	= arr[0];
  					input["BIZRNO"] 	= arr[1];
  					input["RTRVL_DT"] 	= $("#RTRVL_DT").val();
  					ajaxPost(url, input, function(rtnData) {
	    				if ("" != rtnData && null != rtnData) {   
	    						dps_fee_list = rtnData.dps_fee_list;
	    						kora.common.setEtcCmBx2(rtnData.brch_nmList, "", "", $("#WHSDL_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S'); //지점
	    						
	    						//지점 본사 기본 선택
	    						$.each(rtnData.brch_nmList, function(i, v){
					 				if(v.BRCH_NO == '9999999999'){
					 					$("#WHSDL_BRCH_NM").val(v.BRCH_ID+';'+v.BRCH_NO);
					 					return;
					 				}
					 			});
	    						
// 	    						kora.common.setEtcCmBx2(rtnData.dps_fee_list, "", "", $("#RTRVL_CTNR_CD"), "RTRVL_CTNR_CD", "CTNR_NM", "N" ,'S');	//빈용기명(소매)
	    						
	    						for(var i=0 ; i <whsdl_cd_list.length ;i++){
	    							if(whsdl_cd_list[i].BIZRID_NO == $("#WHSDL_BIZRNM").val()  ){
	    								$("#WHSDL_BIZRNO").val(kora.common.setDelim(whsdl_cd_list[i].BIZRNO_DE, "999-99-99999"));
	    								break;
	    							}
	    						}
	    				
	    				}else{
	    					 alertMsg("error");
	    				}
	    				
	    				fn_bizrNm();
  					});
  			}else{
  					$("#WHSDL_BIZRNO").text("");
  					kora.common.setEtcCmBx2([], "","", $("#WHSDL_BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S');	 //지점
//   					kora.common.setEtcCmBx2([], "","", $("#RTRVL_CTNR_CD"), "RTRVL_CTNR_CD", "CTNR_NM", "N" ,'S'); //빈용기명(소매)
  			}
  	   
     }
 
   //회수일자 변경시
//    function fn_rtrvl_dt(){
// 		var url = "/CE/EPCE2925831_192.do"; 
// 		var input ={};
// 		input["RTRVL_DT"] = $("#RTRVL_DT").val();
//       	ajaxPost(url, input, function(rtnData) {
//    				if ("" != rtnData && null != rtnData) {   
//    					dps_fee_list = rtnData.dps_fee_list;
//    					kora.common.setEtcCmBx2(rtnData.dps_fee_list, "","", $("#RTRVL_CTNR_CD"), "RTRVL_CTNR_CD", "CTNR_NM", "N" ,'S');	//빈용기명(소매)
//    				}else{
// 					alertMsg("error");
//    				}
//    		});
//    }
	 
	 //행등록
	function fn_reg2(){
		if($("#WHSDL_BIZRNM").val() ==""){
			alertMsg("도매업자를 선택해주세요.");
			return;
// 		}else if(!kora.common.cfrmDivChkValid("divInput")) {
// 			alert("2");
// 			return;
// 		}else if(!kora.common.fn_validDate($("#RTRVL_DT").val())){
			
// 			alertMsg("올바른 날짜 형식이 아닙니다.");
// 			return;
// 		}else if(!kora.common.gfn_bizNoCheck($('#CUST_BIZRNO').val())){
// 			alertMsg("정상적인 사업자등록번호가 아닙니다.");
// 			$('#CUST_BIZRNO').focus();
// 			return;
		}else if( $("#WHSDL_BIZRNM").val() != "" ) {
			$("#WHSDL_BIZRNM").prop("disabled",true);
			whsdl_bizrnm_chk = $("#WHSDL_BIZRNM").val(); 
		}
		 
		 if(kora.common.format_noComma(kora.common.null2void($("#AreaCdList_SEL").val(),0))  < 1) {
	            alertMsg("지역을(를) 선택하십시요.", "kora.common.cfrmDivChkValid_focus");
	            chkTarget = $("#AreaCdList_SEL");
	            return;
	        } 	
		 
		 if(kora.common.format_noComma(kora.common.null2void($("#DLIVY_QTY").val(),0))  < 1) {
	            alertMsg("출고량을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	            chkTarget = $("#DLIVY_QTY");
	            return;
	        }
		 
		 if(kora.common.format_noComma(kora.common.null2void($("#RTN_QTY").val(),-1))  < 0) {
	            alertMsg("회수량을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	            chkTarget = $("#RTN_QTY");
	            return;
	        }
		 
		 if(kora.common.format_noComma(kora.common.null2void($("#DST_QTY").val(),-1))  < 0) {
	            alertMsg("파손(분실)량을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	            chkTarget = $("#DST_QTY");
	            return;
	        }
		 
		var input 	=	insRow("A");
// 		alert("3");
 		if(!input){
 			return;
 		}
		gridRoot.removeAll();
		gridRoot.addItemAt(input);
		dataGrid.setSelectedIndex(-1);			
	}
	 
	 //행 수정
	function fn_upd(){
		 
		 var idx = dataGrid.getSelectedIndex();
		 /*if(idx < 0) {
			alertMsg("변경할 행을 선택하시기 바랍니다.");
			return;
		} */
		/* else if(!kora.common.cfrmDivChkValid("divInput")) {	//필수값 체크
			return;
		}else if(!kora.common.gfn_bizNoCheck($('#CUST_BIZRNO').val())){
			alertMsg("정상적인 사업자등록번호가 아닙니다.");
			$('#CUST_BIZRNO').focus();
			return;
		}else if(!kora.common.fn_validDate($("#RTRVL_DT").val())){ 
			alertMsg("날짜를 확인해주세요.\n정상적인 날짜가 아닙니다."); 
			return; 
		} */
		
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
		gridRoot.removeItemAt(idx);
	}
	 
	 
	//행변경 및 행추가시 그리드 셋팅
	insRow = function(gbn) {
		
// 		if($("#RTRVL_QTY").val() == '0'){
// 			alert("회수량 입력은 필수입니다.");
// 			return false;
// 		}
		
			var input = {};
		   
		    if(!kora.common.fn_validDate_ck( "R", $("#RTRVL_DT").val())){ //등록일자제한 체크
				return;
			}
		    
		    var collection = gridRoot.getCollection();  //그리드 데이터
		    for(var i=0; i<collection.getLength(); i++) {
	 	    	var tmpData = gridRoot.getItemAt(i);
	 	    	
// 	 	    	if(tmpData["RTRVL_CTNR_CD"] == $("#RTRVL_CTNR_CD").val() &&  tmpData["RTL_CUST_BIZRNO"] == $("#RTL_CUST_BIZRNO").val()
// 			    		&&tmpData["RTRVL_DT"] == $("#RTRVL_DT").val()  &&tmpData["WHSDL_BRCH_NM_CD"] == $("#WHSDL_BRCH_NM").val()   ) { 
// 						if(gbn == "M") {
// 							if(rowIndexValue != i) {
// 					    		alertMsg("동일한 빈용기명이 있습니다.");
// 					    		return false;
// 					    	}
// 						} else {
// 				    		alertMsg("동일한 빈용기명이 있습니다..");
// 				    		return false;
// 						}
// 					}
		    }
		    
// 			for(var i=0; i<stat_cd_list.length; i++){
// 				if(stat_cd_list[i].ETC_CD == $("#RTRVL_STAT_CD").val() ) {
// 						input["BOX_SE_NM"] 					= 	$("#RTRVL_STAT_CD option:selected").text();	//빈용기명
// 					    input["BOX_SE_CD"] 			= 	$("#RTRVL_STAT_CD").val(); 							//빈용기 코드
// 						input["CPCT_NM"] 					= 	dps_fee_list[i].CPCT_NM;								//용량ml
// 						input["PRPS_NM"] 					= 	dps_fee_list[i].PRPS_NM;								//용도
// 					    input["RTN_QTY"] 				= 	$("#RTN_QTY").val().replace(/\,/g,"");									//회수량
// 					    input["RTN_GTN"] 				= 	$("#RTN_GTN").val(); 	//보증금(원) - 합계
// 					    input["DLIVY_QTY"] 				= 	$("#DLIVY_QTY").val().replace(/\,/g,"");									//회수량
// 					    input["DLIVY_GTN"] 				= 	$("#DLIVY_GTN").val; 	//보증금(원) - 합계
			
// 						break;		
// 				}
// 			}
			input["PBOX_LST_NO"]					= 	$("#PBOX_LST_NO").val();         
			input["RTRVL_DT"]					= 	$("#RTRVL_DT").val();                           			//회수일자
			var arr = $("#WHSDL_BIZRNM").val().split(";"); 													//도매업자
			input["WHSDL_BIZRID"] 			= arr[0];
			input["WHSDL_BIZRNO"] 			= $("#WHSDL_BIZRNO").val(); 
			input["WHSDL_BIZRNM"] 			= 	$("#WHSDL_BIZRNM").val();	// 도매업자명
			input["AREA_CD"] 					=	$("#AreaCdList_SEL option:selected").val();		
			    input["DLIVY_QTY"] 				= 	$("#DLIVY_QTY").val().replace(/\,/g,"");									//잔여량
			    input["RTN_QTY"] 				= 	$("#RTN_QTY").val().replace(/\,/g,"");									//회수량
			    input["DST_QTY"] 				= 	$("#DST_QTY").val().replace(/\,/g,""); 	//보증금(원) - 합계
		/* 	var arr2 = $("#WHSDL_BRCH_NM").val().split(";"); 												//도매업자 지점
			input["WHSDL_BRCH_ID"] 			= arr2[0];
			input["WHSDL_BRCH_NO"] 		= arr2[1];
			input["WHSDL_BRCH_NM"] 		= 	$("#WHSDL_BRCH_NM option:selected").text();	// 지점
			input["WHSDL_BRCH_NM_CD"] 	= 	$("#WHSDL_BRCH_NM").val();				 */		// 지점 ID+NO
			if($("#WHSDL option:selected").val() == "Y"){
				 input["CUST_BIZRNM"] 			= 	 $("#WHSDL option:selected").text();				//회수처
			     input["CUST_BIZRNO"] 		= 	$("#WHSDL option:selected").val();						//회수처사업자번호
			}else{
				input["CUST_BIZRNM"] 			= 	 $("#RTL_CUST_BIZRNM").val();  				//회수처
			    input["CUST_BIZRNO"] 		= 	$("#RTL_CUST_BIZRNO").val();  						//회수처사업자번호
			}
		    input["selectCust"] = $("input[type=radio][name=selectCust]:checked").val();
			if($("#RMK").val() ==""){
     			input["RMK"]					=	" ";												
     		}else{
     			input["RMK"]					=	$("#RMK").val();						
     		}
			input["SYS_SE"]						= 'W';															//시스템구분	
			return input;   
	};	
	
	//등록
	function fn_reg(){
		 
		var data = {"list": ""};
		var row = new Array();
		var url = "/CE/EPCE9000142_09.do"; 
		var collection = gridRoot.getCollection(); //그리드 데이터
		if(collection.getLength() <1){
				alertMsg("데이터를 입력해주세요")
				return;
		}else if(	whsdl_bizrnm_chk !=$("#WHSDL_BIZRNM").val() ){
				alertMsg("변조된데이터 입니다");
				return;
		}else if(0 != collection.getLength()){
				
			 	for(var i=0;i<collection.getLength(); i++){
			 		var tmpData = gridRoot.getItemAt(i);
			 		row.push(tmpData);//행 데이터 넣기
			 	}//end of for
			 	
				data["list"] = JSON.stringify(row);
				showLoadingBar();   
				ajaxPost(url, data, function(rtnData){
					if(rtnData != null && rtnData != ""){
							if(rtnData.RSLT_CD =="A003"){ // 중복일경우
								alertMsg(rtnData.ERR_CTNR_NM+"은 " +rtnData.RSLT_MSG);
							}else if(rtnData.RSLT_CD =="A021"){
								alertMsg(rtnData.RSLT_MSG);
							}else if(rtnData.RSLT_CD =="0000"){
								alertMsg(rtnData.RSLT_MSG);
			  					fn_init(); //입력창 초기화
			  					fn_cnl();
							}else{
								alertMsg(rtnData.RSLT_MSG);
							}
					}else{
							alertMsg("error");
					}
					hideLoadingBar();
				});//end of ajaxPost
		}else{
			alertMsg("등록할 자료가 없습니다.\n\n자료를 입력 후 행추가 버튼을 클릭하여 저장할 자료를 여러건 입력한 다음 등록 버튼을 클릭하세요.");
		}
		 
	}
	
	  //취소버튼 이전화면으로
    function fn_cnl(){
   	 kora.common.goPageB('/CE/EPCE9000101.do', INQ_PARAMS);
    }
    
	//선택한 행 입력창에 값 넣기 에러확인
	function fn_rowToInput (rowIndex){
		var item = gridRoot.getItemAt(rowIndex);
		//fn_dataSet(item);
// 		$("#BOX_SE_CD").val( item["RTRVL_STAT_CD"]).prop("selected", true); 				//회수용기
		$("#RTRVL_DT").val(item["RTRVL_DT"] );  																//회수일
		$("#AreaCdList_SEL").val( item["AREA_CD"]).prop("selected", true);	
		$("#DLIVY_QTY").val(item["DLIVY_QTY"]);													//출고보증금
		$("#RTN_QTY").val(item["RTN_QTY"]);													//회수보증금
		$("#DST_QTY").val( item["DST_QTY"]);   															//출고량
	
        if( item["selectCust"] == 'Y' ){
            $("#WHSDL").val( item["CUST_BIZRNO"] ).prop("selected", true);
            $("input:radio[name='selectCust']:radio[value='Y']").prop("checked", true);
            $("#RTL_CUST_BIZRNM").val("");  
            $("#RTL_CUST_BIZRNO").val(""); 
            $('#cust_y').attr('style', '');
            $('#cust_n1').attr('style', 'display:none');
            $('#cust_n2').attr('style', 'display:none');
        }else{
        	$("#RTL_CUST_BIZRNM").val( item["CUST_BIZRNM"]);   															//잔여(개)
    		$("#RTL_CUST_BIZRNO").val( item["CUST_BIZRNO"]);   
            $("input:radio[name='selectCust']:radio[value='N']").prop("checked", true);
            $("#WHSDL").val("").prop("selected", true); 
            
            $('#cust_y').attr('style', 'display:none');
            $('#cust_n1').attr('style', '');
            $('#cust_n2').attr('style', '');
        }
		
		//$("#RTRVL_CTNR_CD").trigger('change');
		//prpsCdCheck();
	}
	
	function fn_dataSet(item){
		var input	={};
		var url 	 	= "/CE/EPCE2925831_19.do"; 
		dps_fee_list=[];
		input["BIZRID"] 		= item["WHSDL_BIZRID"];	//도매업자아이디
		input["BIZRNO"] 		= item["WHSDL_BIZRNO"];//도매업자사업자번호
		input["RTRVL_DT"] 	= item["RTRVL_DT"];			//회수일자 

       	ajaxPost(url, input, function(rtnData) {
   				if ("" != rtnData && null != rtnData) {   
//    					dps_fee_list = rtnData.dps_fee_list
//    					kora.common.setEtcCmBx2(rtnData.dps_fee_list, "","", $("#RTRVL_CTNR_CD"), "RTRVL_CTNR_CD", "CTNR_NM", "N" ,'S');	//빈용기명(소매)
// 					kora.common.setEtcCmBx2(rtnData.brch_nmList, "","", $("#BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S');//지점
   				}else{
					alertMsg("error");
   				}
		},false);
	}
	  
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
	     	var url 		= "/CE/EPCE9000131_193.do";
	     	var flag 		= false;
	     	var dup_cnt 		= 0;		//동일한 용기코드 + 도매업자지점 + 회수사업자번호 가 있을경우
	    	var err_cnt 			= 0;		//잘못된 데이터로 디비 정보가 없을 경우
	    	var err_msg="";
	    	var err_msg2="";
	    	var megCheck =false;
	    //	var arr3 =new Array();		//나중에 필요할때 쓰자;;
	    //	var arr4 =new Array();		//나중에 필요할때 쓰자;;
			arr		=[];
			//arr 	= $("#WHSDL_BIZRNM").val().split(";"); 	//도매업자
	     	for(var i=0; i<rtnData.length ;i++) {
	     		if(	rtnData[i].출고회수일자 =="" &&
		    			rtnData[i].소매업체명 =="" &&
		    			rtnData[i].소매업체사업자번호 =="" &&
		    			rtnData[i].지역코드 =="" &&
		    			rtnData[i].출고량 =="" &&
		    			rtnData[i].회수량 =="" &&
		    			rtnData[i].파손량 =="" 	){ //행에 아무데이터가 없으면 패스
					continue;
	    		 }else if(	rtnData[i].출고회수일자 =="" ||
			    			rtnData[i].소매업체명 =="" ||	
			    			rtnData[i].소매업체사업자번호 =="" ||
			    			rtnData[i].지역코드 =="" ||
			    			rtnData[i].출고량 =="" ||
			    			rtnData[i].회수량 ==""||
			    			rtnData[i].파손량 =="" 	){
			    			alertMsg("필수입력값이 없습니다.");
			    			return;
		    		 }/* else if(!kora.common.gfn_bizNoCheck(rtnData[i].회수처사업자번호)){
		    			 	alertMsg(rtnData[i].소매업체사업자번호 + "가 정상적인 사업자등록번호가 아닙니다.");
		    				return;
		    		 }  */
	     			
	     			
		     		/* if(!kora.common.fn_validDate(rtnData[i].회수일자)){ 
		    			alertMsg(rtnData[i].출고회수일자 + "가 정상적인 정상적인 날짜가 아닙니다.");
		    			return; 
		    		} */
		     		
		     		flag= false
		     		input["WHSDL_BIZRNO"] 			= $("#WHSDL_BIZRNO").val().replace(/-/g,""); 
					input["WHSDL_BIZRNM"] 			= 	$("#WHSDL_BIZRNM option:selected").text();
		     		input["RTRVL_DT"]				=	rtnData[i].출고회수일자
		     		if(!kora.common.fn_validDate_ck( "R", input["RTRVL_DT"])){ 		//등록일자제한 체크
		    			return;
		    		} 
		     		input["CUST_BIZRNM"]			=	rtnData[i].소매업체명			
		     		input["CUST_BIZRNO"]	=	rtnData[i].소매업체사업자번호
		     		input["AREA_CD"]		=	rtnData[i].지역코드
		     		input["DLIVY_QTY"]				=	rtnData[i].출고량		
		     		input["RTN_QTY"]		=	rtnData[i].회수량	
		     		input["DST_QTY"]	=	rtnData[i].파손량
					ajaxPost(url, input, function(rtnData) {
						gridRoot.addItemAt(rtnData.selList[0]);	
		    				/* if ("" != rtnData && null != rtnData) {
			    					if(rtnData.selList != undefined && rtnData.selList != null && rtnData.selList.length !=0){	// 쿼리상 데이터가 있을경우에만
			    							var collection = gridRoot.getCollection();  //그리드 데이터
			    							for(var i=0; i<collection.getLength(); i++) {
			    					 	    	var tmpData = gridRoot.getItemAt(i);
			    					 	    	
// 			    					 	    	if(tmpData["RTRVL_CTNR_CD"] == rtnData.selList[0].RTRVL_CTNR_CD // 쿼리상 데이터는 있지만 동일한용기코드가 있을경우.
// 										    			&& tmpData["RTL_CUST_BIZRNO"] == rtnData.selList[0].RTL_CUST_BIZRNO 
// 										    			&& tmpData["RTRVL_DT"] ==  rtnData.selList[0].RTRVL_DT 
// 										    			&& tmpData["WHSDL_BIZRNO"] == rtnData.selList[0].WHSDL_BIZRNO   ) {
// 										    			flag =true;
// 										    		//	arr3[dup_cnt]=input["RTL_CUST_BIZRNO"]+input["RTRVL_DT"]+" ,"+input["RTRVL_CTNR_CD"];
// 										    			dup_cnt++;
// 												}
			    							}
										    
											if(!flag)gridRoot.addItemAt(rtnData.selList[0]);	
										    
			    					}else{// 쿼리상 데이터가 없을경우
			    					//	arr4[err_cnt]=input["RTL_CUST_BIZRNO"]+input["RTRVL_DT"]+" ,"+input["RTRVL_CTNR_CD"];
			    						err_cnt++;
			    					}
		    				}else{
								alertMsg("error");
		    				}
		    				 if(i == (rtnData.length - 1) ){
	    		    			 megCheck =true;
	    		              } */
	    			},false);  
	     	}//end of for(var i=0; i<rtnData.length ;i++) 
	     		
     		err_msg = dup_cnt+" 개의 동일한 정보를 제외하고 등록 하였습니다. \n"  ;
     		err_msg2 =err_cnt+" 개의 확인되지 않은 정보가 등록 제외되었습니다.\n" ;
     
	     	if(dup_cnt >0 && err_cnt >0){
	     		alertMsg(err_msg+"\n"+err_msg2+"\n등록 정보를 다시 확인해주시기 바랍니다.");
	        }else if(dup_cnt >0){
	        	alertMsg(err_msg+"\n등록 정보를 다시 확인해주시기 바랍니다.");
     		}else if(err_cnt >0){
     			alertMsg(err_msg2+"\n등록 정보를 다시 확인해주시기 바랍니다." );
     		}
			// $('body').toggleClass('');
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
			layoutStr.push('	<DataGrid headerColors="[#EFF6FC,#EFF6FC]" verticalAlign="middle" id="dg1" headerWordWrap="true" draggableColumns="true" horizontalScrollPolicy="on" sortableColumns="true"   headerHeight="35">');
			layoutStr.push('		<groupedColumns>');
			//layoutStr.push('			<DataGridColumn dataField="index" 				 	headerText="등록순번"						width="50" 	textAlign="center" 	  itemRenderer="IndexNoItem" />');			//순번
			layoutStr.push('			<DataGridColumn dataField="RTRVL_DT"			headerText="출고회수일자"  			width="120"  	textAlign="center"  	/>'); 													//회수일자
			layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNM" 	 	headerText="소매업체명"   	width="150"  	textAlign="center"	/>');														//회수처
			layoutStr.push('			<DataGridColumn dataField="CUST_BIZRNO" headerText="소매업체사업자번호"   width="150"  	textAlign="center"	 formatter="{maskfmt1}"/>');					//회수처 사업자번호
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRNM" 	 		headerText="도매업체명" 			width="120"  	textAlign="center"  	/>');		//회수보증금
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRNO" 			headerText="도매업체사업자번호" 	width="200"  	textAlign="center"  formatter="{maskfmt1}"  />');														//용도
			//layoutStr.push('			<DataGridColumn dataField="BOX_SE_CD"  		headerText="상태코드" 				width="120" 	textAlign="center" 		  />');		//회수량
 			layoutStr.push('			<DataGridColumn dataField="AREA_CD"  		headerText="지역" 				width="120" 	textAlign="center" 		  />');
			layoutStr.push('			<DataGridColumn dataField="DLIVY_QTY" 			headerText="출고량" 				width="200"  	textAlign="center"   formatter="{numfmt}" id="num1"	/>');														//용도
			layoutStr.push('			<DataGridColumn dataField="RTN_QTY" 	headerText="회수량"				width="120"  	textAlign="right"  formatter="{numfmt}" id="num2"  	 />');		//회수수수료
			layoutStr.push('			<DataGridColumn dataField="DST_QTY" 			headerText="파손(분실)량" 				width="200"  	textAlign="center"   formatter="{numfmt}" id="num6"	/>');														//용도
			//layoutStr.push('			<DataGridColumn dataField="KEEP_QTY" 	headerText="보관량"				width="120"  	textAlign="right"  formatter="{numfmt}" id="num7"  	 />');		//회수수수료
			//layoutStr.push('			<DataGridColumn dataField="PBOX_LST_NO"  		headerText="등록번호" 				width="120" 	textAlign="center" 		  />');
			layoutStr.push('			<DataGridColumn dataField="PBOX_LST_NO"  	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="BOX_SE_CD"	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="RTRVL_RTL_FEE"		visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRID"		visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BIZRNO"	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BRCH_ID"	visible="false" />');
			layoutStr.push('			<DataGridColumn dataField="WHSDL_BRCH_NO"	visible="false" />');
			layoutStr.push('		</groupedColumns>');
			layoutStr.push('		<footers>');
			layoutStr.push('			<DataGridFooter backgroundColor="#6E7376" color="#FFFFFF">');
			layoutStr.push('				<DataGridFooterColumn label="합계" textAlign="center"/>');
			//layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			
			//layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn/>');
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num1}" formatter="{numfmt}" textAlign="right"/>');	//회수량
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num2}" formatter="{numfmt}" textAlign="right"/>');	//회수보증금
			layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num6}" formatter="{numfmt}" textAlign="right"/>');	//회수수수료
			//layoutStr.push('				<DataGridFooterColumn summaryOperation="SUM" dataColumn="{num7}" formatter="{numfmt}" textAlign="right"/>');	//소계
			layoutStr.push('				<DataGridFooterColumn/>');
			//layoutStr.push('				<DataGridFooterColumn/>');
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
.srcharea .row .col .tit{
    width: 120px;
}

.fa-close:before, .fa-times:before {
    content: "X"; 
    font-weight: 550;
}
 
 
.ax5autocomplete-display-table >div>a>div{
    margin-top: 8px;
}
.srcharea .row .box  select, #s2id_WHSDL_BIZRNM{
    width: 100%
}
</style>

</head>
<body>
    <div class="iframe_inner"  >
			<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="whsdl_cd_list" value="<c:out value='${whsdl_cd_list}' />" />
			 <input type="hidden" id="rtc_dt_list" value="<c:out value='${rtc_dt_list}' />" />
			 <input type="hidden" id="stat_cd_list" value="<c:out value='${stat_cd_list}' />" />
			<input type="hidden" id="AreaCdList" value="<c:out value='${AreaCdList}' />"/>
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
				<div class="row">
						<div class="col">
							<div class="tit" id="">도매업자업체명</div>  <!-- 도매업자업체명 -->
							<div class="box">
								<!-- <select id="WHSDL_BIZRNM" style="width: 179px"></select> -->
								<input type="text" id="WHSDL_BIZRNM" style="width: 250px"  disabled="disabled"/>
							</div>
						</div>
					    <div class="col" >
							<div class="tit" id="" style="width: 119px;">도매업자 사업자번호</div>  <!-- 도매업자 사업자번호 -->
							<div class="box">
								<input type="text" id="WHSDL_BIZRNO" style="width: 250px"  disabled="disabled"/>
								<!-- <div class="txtbox" id="WHSDL_BIZRNO"></div> -->	
							</div>
						</div> 
						<div class="col" id="cust_n1" >
                               <div class="tit" id="" >소매업체명</div>  
                               <div class="box">
                                   <input type="text" id="RTL_CUST_BIZRNM"  maxByteLength="100" disabled="disabled" style="width: 250px"/>
                               </div>
                           </div>
                           <div class="col" id="cust_n2"  >
                               <div class="tit" id="" style="width: 119px">소매업체 사업자번호</div>   
                               <div class="box">
                                   <input type="text" id="RTL_CUST_BIZRNO" style="width: 250px" disabled="disabled"  maxlength="10"/>
                                   <input type="text" id="PBOX_LST_NO" style="display:none"/>
                               </div>
                           </div> 
					</div> <!-- end of row -->
				</div>
			</section>
			<section class="secwrap mt10" >
					<div class="srcharea"  id="divInput" > 
							<div class="row">
									<div class="col">
										<div class="tit" id="" style="width: 119px">출고회수일자</div>  <!-- 회수일자 -->
										<div class="box">
											<div class="calendar">
												<input type="text" id="RTRVL_DT"  style="width: 250px" class="i_notnull" /> <!--시작날짜  -->
											</div>
										</div>
									</div>
									<div class="col">
										<div class="tit" style="width: 119px">지역</div>  <!-- 반환대상 직매장/공장 -->
										<div class="box" style="">
											<select id="AreaCdList_SEL" name="AreaCdList_SEL"  style="width: 250px"  class="i_notnull" ></select>
										</div>
									</div>
									<div class="col" style="display:none">
                                        <div class="tit" id="" style="width: 119px">소매업체명</div>   <!-- 회수처 입력 선택-->
                                        <div class="box" id="CUST_SEL" style="width:150px">
                                            <label class="rdo"><input type="radio" id="selectCust1" name="selectCust" value="Y" /><span id="">선택</span></label>
                                            <label class="rdo"><input type="radio" id="selectCust2" name="selectCust" value="N" checked="checked"/><span id="">직접입력</span></label>
                                        </div>
                                    </div>
                                    <div class="col" id="cust_y" style="display:none">
                                        <!-- <div class="tit" id="" style="width: 119px">소매업체명</div>   -->
                                        <div class="box">
                                            <select id="WHSDL" style="width: 250px" ></select>
                                        </div>
                                    </div>
                                    
                                    
							</div> <!-- end of row -->
							<div class="row">
									
									<div class="col">
										<div class="tit" id="" style="width: 119px">출고량</div>  <!-- 회수량 -->
										<div class="box">
											<input type="text" id="DLIVY_QTY" style="text-align:right;width: 250px"  format="minus"   class="i_notnull"  maxlength="8"/>
										</div>
									</div>
									<div class="col">
										<div class="tit" id="" style="width: 119px">회수량</div>  <!-- 회수량 -->
										<div class="box">
											<input type="text" id="RTN_QTY" style="text-align:right;width: 250px"  format="minus"   class="i_notnull"  maxlength="8"/>
										</div>
									</div>
									<!-- <div class="col" style="">
										<div class="tit" id="" style="width: 119px">회수보증금</div>  소매수수료
										<div class="box" style="" >
											<input type="text" id="RTN_GTN" style="text-align:right;width: 179px" format="minus"   class="i_notnull"  />
										</div>
									</div> -->
									<div class="col">
										<div class="tit" id="" style="width: 119px">파손(분실)량</div>  <!-- 회수량 -->
										<div class="box">
											<input type="text" id="DST_QTY" style="text-align:right;width: 250px"  format="minus"   class="i_notnull"  maxlength="8"/>
										</div>
									</div>
									<!-- <div class="col" style="">
										<div class="tit" id="" style="width: 119px">파손(분실)보증금</div>  소매수수료
										<div class="box" style="" >
											<input type="text" id="DLIVY_GTN" style="text-align:right;width: 179px" format="minus"   class="i_notnull"  />
										</div>
									</div> -->
							</div> <!-- end of row -->
                           <!--  <div class="row">
                                    
                                    <div class="col" id="cust_n1" style="display:none">
                                        <div class="tit" id="" style="width: 109px">소매업체명</div>  회수처
                                        <div class="box">
                                            <input type="text" id="RTL_CUST_BIZRNM" class="i_notnull"  maxByteLength="100" style="width: 179px"/>
                                        </div>
                                    </div>
                                    <div class="col" id="cust_n2" style="display:none" >
                                        <div class="tit" id="" style="width: 120px">소매업체 사업자번호</div>  회수처 사업자번호
                                        <div class="box">
                                            <input type="text" id="RTL_CUST_BIZRNO" style="" class="i_notnull"  maxlength="10"/>
                                        </div>
                                    </div>
                            </div> end of row -->

							<div class="singleRow" style="float:right; margin-bottom: 10px; ">
									<div class="btn" id="CR"></div>
							</div>
					</div>  <!-- end of srcharea -->
					<!-- <div class="h4group" >
						<h5 class="tit"  style="font-size: 16px; margin-top: -40px" >
							&nbsp;&nbsp;※ 회수처 사업자번호에 하이폰(-) 없이 입력
						</h5>
					</div> -->
				</section>
					
				<div class="boxarea">
					<div id="gridHolder" style="height: 560px; background: #FFF;"></div>
				</div>	<!-- 그리드 셋팅 -->
				
				<section class="btnwrap mt10" >
						<div class="btn" id="BL"></div>
						<div class="btn" style="float:right" id="BR"></div>
				</section>
</div>

<form name="downForm" id="downForm" action="" method="post">
	<input type="hidden" name="fileName" value="PBOX_INFO_EXCEL_FORM.xlsx" />
	<input type="hidden" name="downDiv" value="" /> <!-- 공지사항 첨부 다운일경우 noti, 업로드 폴더인경우 up 로 넣어준다-->
</form>

</body>
</html>