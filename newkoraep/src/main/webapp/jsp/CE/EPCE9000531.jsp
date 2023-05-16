<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Insert title here</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<!-- 페이징 사용 등록 -->
<script src="/js/kora/paging_common.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />

<script type="text/javaScript" language="javascript" defer="defer">
    var INQ_PARAMS;//파라미터 데이터
    var toDay = kora.common.gfn_toDay();// 현재 시간
    var selList;
    //var urm_list;//도매업자 업체명 조회
    
    $(function() {
         
        INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
        var area_cd_list = jsonObject($("#area_cd_list").val());//지역
        var urm_list = jsonObject($("#urm_list").val());//소매점리스트
       // urm_list 		= jsonObject($("#urm_list").val());		//도매업자 업체명 조회
       kora.common.setEtcCmBx2(urm_list, "","", $("#old_URM_NM"), "URM_CODE_NO", "URM_NM", "N" ,'S');				//소매점리스트
       kora.common.setEtcCmBx2(area_cd_list, "","", $("#AREA_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');				//지역
		$('#drct_input').text(parent.fn_text('drct_input'));
		$("#old_URM_NM").select2();	
       kora.common.setMailArrCmBx("", $("#DOMAIN"));	//메일도메인 
       fn_init(); 
        //버튼 셋팅
        fn_btnSetting();
        //신규등록여부 
       $('#NEW_YN_SEL').change(function(){
    	   //선택한값
    	   var NEW_YN_SEL = $("input[type=radio][name=NEW_YN]:checked").val();
    	   
    	   console.log(NEW_YN_SEL);
    	   //신규등록
    	 if(NEW_YN_SEL == "Y"){
    		 $('#newY').attr('style', '');	 
    		 $('#newN').attr('style', 'display:none');
    		 $('#total_address1').attr('style', '');	
    		 $('#total_address2').attr('style', '');	
//     		 $('#AREA_CD').attr('style', '');	
    		
    	 }
    	 //기존거 사용
    	 else if(NEW_YN_SEL =="N"){
    		 
    		 $('#newY').attr('style', 'display:none');	 
    		 $('#newN').attr('style', '');	
    		 $('#total_address1').attr('style', 'display:none');	
    		 $('#total_address2').attr('style', 'display:none');	
//     		 $('#AREA_CD').attr('style', 'display:none');		
//     		 $('#ADDR').attr('style', 'display:none');		
//     		 $('#ADDR2').attr('style', 'display:none');		
    	 }
       });
       
       /**
		 * 이메일 도메인 변경 이벤트
		 */
		$("#DOMAIN").change(function(){
			
			$("#DOMAIN_TXT").val(kora.common.null2void($(this).val()));
			
			if(kora.common.null2void($(this).val()) != "") 
				$("#DOMAIN_TXT").attr("disabled",true);
			else
				$("#DOMAIN_TXT").attr("disabled",false);
		});
        
       $('#CHOICE_SEL').on("change",function(){
    	   var CHOICE_SEL =  $("input[type=radio][name=CHOICE_SEL]:checked").val();
  		 console.log(CHOICE_SEL);
  		
  		 if(CHOICE_SEL =="Y"){
  			 $('#choice1').attr('style', '');	 
      		 $('#choice2').attr('style', 'display:none');
  		 }else if(CHOICE_SEL=="N"){
  			 $('#choice1').attr('style', 'display:none');	 
      		 $('#choice2').attr('style', '');
  		 }
    	   
       });
       
       
       
       
        /************************************
         * 조회 클릭 이벤트
         ***********************************/
        $("#btn_reg").click(function(){
        	fn_reg();
        	
        });
        
        $("#btn_cncl").click(function(){
        	fn_cnl();
        });
        
        /**
		 * 우편번호검색 버튼 클릭 이벤트
		 */
		 var parent_item;
		$("#btnPopZip").click(function(){
			var pagedata = window.frameElement.name;
			window.parent.NrvPub.AjaxPopup('/SEARCH_ZIPCODE_POP.do', pagedata);
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
        $("#URM_DE_DT").change(function(){
            var start_dt = $("#URM_DE_DT").val();
            start_dt   =  start_dt.replace(/-/gi, "");
            if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
            $("#URM_DE_DT").val(start_dt) 
        });
        
       
        /************************************
         * 시작날짜  클릭시 - 추가 변경 이벤트
         ***********************************/
        $("#URM_USE_DT").change(function(){
            var start_dt = $("#URM_USE_DT").val();
            start_dt   =  start_dt.replace(/-/gi, "");
            if(start_dt.length == 8)  start_dt = kora.common.formatter.datetime(start_dt, "yyyy-mm-dd")
           
            var urmde_dt = $("#URM_DE_DT").val();
            urmde_dt = urmde_dt.replace(/-/gi, "");
            if(urmde_dt.length == 8)  urmde_dt = kora.common.getDate("yyyy-mm-dd", "D", +364, start_dt)
            console.log(urmde_dt);
            $("#URM_USE_DT").val(start_dt) 
            $("#URM_DE_DT").val(urmde_dt) 
        });
        var AreaCdList = jsonObject($('#AreaCdList').val());
        //kora.common.setEtcCmBx2(AreaCdList, "", "", $("#AreaCdList_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
        
        /**
         * 시리얼번호 중복체크
         */
       $("#noChk").click(function(){
           fn_noChk();
       });
        
       /**
        * 시리얼번호 중복체크
        */
      $("#nourmChk").click(function(){
          fn_nourmChk();
      });
       /**
        * 센터고유넘버 중복체크
        */
      $("#noChk2").click(function(){
          fn_noChk2();
      });
      //kora.common.setEtcCmBx2(urm_list, "","", $("#URM_NM"), "RTL_CUST_BIZRNO", "RTL_CUST_NM", "N" ,'S');		//도매업자 업체명
     // $("#URM_NM").select2();	 
    });
    
    /**
     * 시리얼번호 중복체크
     */
    function fn_noChk(){
        var acctNo  = $("#SERIAL_NO").val();
        
        if(acctNo == null || acctNo == ""){
            alertMsg("무인회수기 시리얼번호를 입력하세요.");
            $("#SERIAL_NO").focus();
            return;
        }
        
        var flag = true;
        
        var sData = {"SERIAL_NO":acctNo};
        var url = "/CE/SERIAL_NO_CHECK.do";
		ajaxPost(url, sData, function(data){
			$("#DUPLE_CHECK_YN2").val("Y");
			$("#USE_ABLE_YN").val(data.USE_ABLE_YN);
			if(data.USE_ABLE_YN == "Y"){
				alertMsg("등록 가능한 시리얼번호 입니다.");
				$("#SERIAL_NO").attr("disabled",true);
			}else{
				alertMsg("이미 등록된 시리얼번호  입니다.");
				return;
			}
		});
	}
    /**
     * 소매점코드 중복체크
     */
    function fn_nourmChk(){
    	var NEW_YN_SEL = $("input[type=radio][name=NEW_YN]:checked").val();
	 	var CHOICE_SEL =  $("input[type=radio][name=CHOICE_SEL]:checked").val();
    	
	 	if(NEW_YN_SEL =="Y"){
	 		  if(CHOICE_SEL=="Y"){
	 			 if(kora.common.format_noComma(kora.common.null2void($("#new_URM_NM2").val(),0))  < 1) {
		 	            alertMsg("소매점명을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
		 	            chkTarget = $("#URM_NM2");
		 	            return;
		 	        } 
	 			  if(kora.common.format_noComma(kora.common.null2void($("#PNO").val(),0))  < 1) {
			            alertMsg("우편번호을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
			            chkTarget = $("#PNO");           
			            return;
			        }
				 
				 if(kora.common.format_noComma(kora.common.null2void($("#AREA_CD").val(),0))  < 1) {
			            alertMsg("지역을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
			            chkTarget = $("#AREA_CD");           
			            return;
			        }
				 
		 	 	  
		 		   //직접입력
		 			
	 			 var urm_nm = $("#new_URM_NM1 option:selected").text()+' '+$("#new_URM_NM2").val();
	 			var urm_code_no = $("#AREA_CD option:selected").val()+$("#new_URM_NM1 option:selected").val()+$("#PNO").val();
	 	 	   }
	 		   //직접입력
	 		  else if(CHOICE_SEL=="N"){
	 			
		 		   //직접입력
		 			 if(kora.common.format_noComma(kora.common.null2void($("#new_URM_NM2_2").val(),0))  < 1) {
			 	            alertMsg("소매점명을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
			 	            chkTarget = $("#new_URM_NM2_2");
			 	            return;
			 	        } 
		 			  if(kora.common.format_noComma(kora.common.null2void($("#PNO").val(),0))  < 1) {
				            alertMsg("우편번호을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
				            chkTarget = $("#PNO");           
				            return;
				        }
					 
					 if(kora.common.format_noComma(kora.common.null2void($("#AREA_CD").val(),0))  < 1) {
				            alertMsg("지역을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
				            chkTarget = $("#AREA_CD");           
				            return;
				        }
	 			 var urm_nm = $("#new_URM_NM2_1").val() + $("#new_URM_NM2_2").val();
	 	 		  var urm_code_no = $("#AREA_CD option:selected").val()+"ETC"+$("#PNO").val();
	 	 	   }
	 	   }
	 	
//     	var urm_code_no = $("#AREA_CD option:selected").val()+$("#new_URM_NM1 option:selected").val()+$("#PNO").val();
        
       
        var flag = true;
        
        var sData = {"URM_CODE_NO":urm_code_no};
        var url = "/CE/URMCODE_NO_CHECK.do";
		ajaxPost(url, sData, function(data){
			$("#DUPLE_CHECK_YN2").val("Y");
			$("#USE_URM_CODE_YN").val(data.USE_URM_CODE_YN);
			if(data.USE_URM_CODE_YN == "Y"){
				alertMsg("등록 가능한 소매점입니다.");
				$("#new_URM_NM1").attr("disabled",true);
				$("#new_URM_NM2").attr("disabled",true);
				$("#new_URM_NM2_1").attr("disabled",true);
				$("#new_URM_NM2_2").attr("disabled",true);
				$("#AREA_CD").attr("disabled",true);
			}else{
				alertMsg("이미 등록된 소매점입니다. 관리자에게 문의해주세요.");
				return;
			}
		});
	}
    
    /**
     * 센터고유넘버 중복체크
     */
    function fn_noChk2(){
//         var acctNo  = $("#URM_CE_NO").val();
        
//         if(acctNo == null || acctNo == ""){
//             alertMsg("센터고유넘버를 입력하세요.");
//             $("#URM_CE_NO").focus();
//             return;
//         }
        
//         var flag = true;
        
        var sData = {"test":1};
        var url = "/CE/URM_CE_NO_CHECK.do";
		ajaxPost(url, sData, function(data){
			//$("#DUPLE_CHECK_YN2").val("Y");
			console.log(data.URM_CE_NO);
			
			$("#URM_CE_NO").val(data.URM_CE_NO);
// 			if(data.USE_ABLE_YN == "Y"){
// 				alertMsg("등록 가능한 센터고유넘버 입니다.");
// 			}else{
// 				alertMsg("이미 등록된 센터고유넘버 입니다.");
// 				return;
// 			}
		});
	}
    
    //셋팅
    function fn_init(){
         
        //날짜 셋팅
        $('#START_DT').YJcalendar({  
            toName : 'to',
            triggerBtn : true,
            dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
        });
        
        $('#URM_DE_DT').YJcalendar({  
            toName : '',
            triggerBtn : true,
            dateSetting : kora.common.getDate("yyyy-mm-dd", "D", +364, false).replaceAll('-','')
        });
        
       
        
        $('#URM_USE_DT').YJcalendar({  
            toName : '',
            triggerBtn : true,
            dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
        });
        
        $('#END_DT').YJcalendar({
            fromName : 'from',
            triggerBtn : true,
            dateSetting : kora.common.getDate("yyyy-mm-dd", "D", +364, false).replaceAll('-','')
        });
        
        //text 셋팅
        /* $('.row > .col > .tit').each(function(){
            $(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
        }); */
            
        //div필수값 alt
        $("#END_DT").attr('alt',parent.fn_text('sel_term'));
        
        //div필수값 alt
        $("#URM_USE_DT").attr('alt',parent.fn_text('sel_term'));
        $("#URM_DE_DT").attr('alt',parent.fn_text('sel_term'));
    }
 
  //등록
	function fn_reg(){
		var NEW_YN_SEL = $("input[type=radio][name=NEW_YN]:checked").val();
	 	var CHOICE_SEL =  $("input[type=radio][name=CHOICE_SEL]:checked").val();
	 	console.log(NEW_YN_SEL);
	 	console.log(CHOICE_SEL);
	 	if($("#USE_ABLE_YN").val() == 'N' || $("#USE_ABLE_YN").val() == '' || $("#USE_ABLE_YN").val() == null){
	 		alertMsg('무인회수기 시리얼번호 중복확인을 해주십시오.');
			  return;
		  }
	 	
		  
		 
	 	
	 		
			 
			 if(kora.common.format_noComma(kora.common.null2void($("#TELNO").val(),0))  < 1) {
		            alertMsg("담당자 연락처을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
		            chkTarget = $("#TELNO");           
		            return;
		        }
			 
			 if(kora.common.format_noComma(kora.common.null2void($("#EMAIL_TXT").val(),0))  < 1) {
		            alertMsg("E-MAIL을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
		            chkTarget = $("#EMAIL_TXT");           
		            return;
		        }
			
	 			
	 			
			//이메일 유효성 체크
				var regExp = /[0-9a-zA-Z][_0-9a-zA-Z-]*@[_0-9a-zA-Z-]+(\.[_0-9a-zA-Z-]+){1,2}$/;
				var emailAddr = $.trim($("#EMAIL_TXT").val()) +"@"+ $.trim($("#DOMAIN_TXT").val());
				if (!emailAddr.match(regExp)){
					alertMsg("이메일 형식에 맞지 않습니다.");
					return false;
				}
	  
	
		 
		var url = "/CE/EPCE9000531_09.do"; 
		var input = {};
		
 	   if(NEW_YN_SEL =="Y"){
 		  if($("#USE_URM_CODE_YN").val() == 'N' || $("#USE_URM_CODE_YN").val() == '' || $("#USE_URM_CODE_YN").val() == null){
 		 		alertMsg('소매점명을 중복확인을 해주십시오.');
 				  return;
 			  }
 		   //선택
 		  if(CHOICE_SEL=="Y"){
 			 if(kora.common.format_noComma(kora.common.null2void($("#new_URM_NM2").val(),0))  < 1) {
	 	            alertMsg("소매점명을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	 	            chkTarget = $("#URM_NM2");
	 	            return;
	 	        } 
 			  if(kora.common.format_noComma(kora.common.null2void($("#PNO").val(),0))  < 1) {
		            alertMsg("우편번호을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
		            chkTarget = $("#PNO");           
		            return;
		        }
			 
			 if(kora.common.format_noComma(kora.common.null2void($("#ADDR2").val(),0))  < 1) {
		            alertMsg("상세주소을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
		            chkTarget = $("#ADDR2");           
		            return;
		        }
			 if(kora.common.format_noComma(kora.common.null2void($("#AREA_CD").val(),0))  < 1) {
		            alertMsg("지역을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
		            chkTarget = $("#AREA_CD");           
		            return;
		        }
			 
	 	 	  
	 		   //직접입력
	 			
 			 var urm_nm = $("#new_URM_NM1 option:selected").text()+' '+$("#new_URM_NM2").val();
 			var urm_code_no = $("#AREA_CD option:selected").val()+$("#new_URM_NM1 option:selected").val()+$("#PNO").val();
 	 	   }
 		   //직접입력
 		  else if(CHOICE_SEL=="N"){
 			
	 		   //직접입력
	 			 if(kora.common.format_noComma(kora.common.null2void($("#new_URM_NM2_2").val(),0))  < 1) {
		 	            alertMsg("소매점명을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
		 	            chkTarget = $("#new_URM_NM2_2");
		 	            return;
		 	        } 
 			 var urm_nm = $("#new_URM_NM2_1").val()+' '+ $("#new_URM_NM2_2").val();
 	 		  var urm_code_no = $("#AREA_CD option:selected").val()+"ETC"+$("#PNO").val();
 	 	   }
 	   }else if(NEW_YN_SEL=="N"){
 		  if(kora.common.format_noComma(kora.common.null2void($("#old_URM_NM").val(),0))  < 1) {
	            alertMsg("소매점명을(를) 선택하십시오", "kora.common.cfrmDivChkValid_focus");
	            chkTarget = $("#old_URM_NM");
	            return;
	        } 
 		  var urm_nm = $("#old_URM_NM option:selected").text();
 		  var urm_code_no = $("#old_URM_NM option:selected").val();
 	   }
		$('#EMAIL').val($.trim($("#EMAIL_TXT").val()) +"@"+ $.trim($("#DOMAIN_TXT").val()));
		var URM_TYPE = $("#URM_TYPE  option:selected").val();
		if(URM_TYPE == "A"){
			input["USE_TOT"]=1140000;
		}else{
			input["USE_TOT"]=3500000;
		}
		input["NEW_YN"]=NEW_YN_SEL;
		input['URM_NM'] = urm_nm;
		input['URM_CODE_NO'] = urm_code_no;
		input['SERIAL_NO'] = $("#SERIAL_NO").val();
		input['URM_CE_NO'] = $("#URM_CE_NO").val();
		input['AREA_CD'] = $("#AREA_CD option:selected").val();
		input['PNO'] = $("#PNO").val();
		input["ADDR1"]    = $("#ADDR1").val();
		input["ADDR2"]    = $("#ADDR2").val();
		input['START_DT'] = $("#START_DT").val().replaceAll("-","");
// 		input['END_DT'] = $("#END_DT").val().replaceAll("-","");
		input['URM_TYPE'] = URM_TYPE;
		input['TELNO'] = $("#TELNO").val();
		input['EMAIL'] = $("#EMAIL").val();
// 		alert(input['EMAIL']);
		input['URM_USE_DT'] = $("#URM_USE_DT").val().replaceAll("-","");
		input['URM_DE_DT'] = $("#URM_DE_DT").val().replaceAll("-","");
		console.log(input);	 	
				//showLoadingBar();   
				ajaxPost(url, input, function(rtnData){
					if(rtnData != null && rtnData != ""){
							if(rtnData.RSLT_CD =="A003"){ // 중복일경우
								alertMsg(rtnData.ERR_CTNR_NM+"은 " +rtnData.RSLT_MSG);
							}else if(rtnData.RSLT_CD =="A021"){
								alertMsg(rtnData.RSLT_MSG);
							}else if(rtnData.RSLT_CD =="0000"){
								alertMsg(rtnData.RSLT_MSG);
			  					//fn_init(); //입력창 초기화
			  					fn_cnl();
							}else{
								alertMsg(rtnData.RSLT_MSG);
							}
					}else{
							alertMsg("error");
					}
					//hideLoadingBar();
				});//end of ajaxPost
		 
	}
	 //취소버튼 이전화면으로
    function fn_cnl(){
   	 kora.common.goPageB('/CE/EPCE9000501.do', INQ_PARAMS);
    }


    
    function clickFunction(code, label, data) {
        
        if(INQ_PARAMS.SEL_PARAM ==null) return; 
    
        var url = "/CE/EPCE6190101_19.do"
        var input = INQ_PARAMS["SEL_PARAM"];
        input["AREA_CD"] = code;
        
        document.body.style.cursor = "wait";
        ajaxPost(url, input, function(rtnData) {
            if ("" != rtnData && null != rtnData) {
                //selList = rtnData.selList;
                gridApp2.setData(rtnData.selList);
                
                var pieData  = new Array();
                
                $.each(rtnData.selList, function(i, v){
                    var pieDataLine = {};
                    pieDataLine["TITLE_IN"]  = v.BIZRNM + "(" + "입고" + ")";
                    pieDataLine["TITLE_OUT"] = v.BIZRNM + "(" + "출고" + ")";
                    pieDataLine["VAL_IN"]    = v.CFM_QTY;
                    pieDataLine["VAL_OUT"]   = v.DLIVY_QTY;
                 
                    pieData.push(pieDataLine);
                });

                chartApp.setData(pieData);
            }else{
                alertMsg("error");
            }
            document.body.style.cursor = "default";
        });
        
        $("#AREA_NM").text(label);
    }

    
    
    
    /****************************************** 그리드 셋팅 끝***************************************** */
</script>
<style type="text/css">
.srcharea .row .col .tit{
    width: 120px;
}
.srcharea .row .box > *{
    float:left;
    margin: 0 0 0 0px;
}

.fa-close:before, .fa-times:before {
    content: "X"; 
    font-weight: 550;
}
 
.ax5autocomplete-display-table >div>a>div{
    margin-top: 8px;
}
#s2id_old_URM_NM{
    width: 100%
}
</style>
</head>
<body>
<input type="hidden" id="AreaCdList" value="<c:out value='${AreaCdList}' />"/>
<div class="iframe_inner" >
        <input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
        <input type="hidden" id="urm_list" value="<c:out value='${urm_list}' />" />
        <input type="hidden" id="area_cd_list" value="<c:out value='${area_cd_list}' />" />
        <div class="h3group">
            <h3 class="tit" >무인회수기등록</h3>
            <div class="btn" style="float:right" id="UR">
            <!--btn_dwnd  -->
            <!--btn_excel  -->
            </div>
        </div>
        
        <form name="fileForm" id="fileForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
        
        <section class="secwrap"   id="params">
            <div class="srcharea mt10" > 
                <div class="row" >
                	<div class="col" id="newN" style="display:none">
                        <div class="tit" style="width: 150px">소매점명</div>    <!-- 조회기간 -->
                        <div class="box">
                        <select id="old_URM_NM" name="URM_NM" style="width: 250px"></select>
                        
                        </div>
                    </div>
                    <div class="col" id="newY" >
                        <div class="tit" style="width: 150px">소매점명</div>    <!-- 조회기간 -->
                        <div class="box">
                        <!-- <input type="text" id="URM_NM" name="URM_NM" style="width: 330px;" class="i_notnull" alt="소매점명"> -->
                        <!-- <select id="URM_NM" name="URM_NM"   style="width: 150px">
                        	<option value="홈플러스">홈플러스</option>
                        	<option value="롯데마트">롯데마트</option>
                        	<option value="이마트">이마트</option>
                        	<option value="롯데슈퍼">롯데슈퍼</option>
                        	<option value="롯데빅마켓">롯데빅마켓</option>
                        	<option value="농협하나로마트">농협하나로마트</option>
                        	<option value="GS수퍼마켓">GS수퍼마켓</option>
                        	<option value="하이웨이마트">하이웨이마트</option>
                        </select> -->
                        <div class="box" id="CHOICE_SEL" style="width:179px">
                            <label class="rdo"><input type="radio" id="selectUrm1" name="CHOICE_SEL" value="Y" checked="checked"/><span id="">선택</span></label>
                            <label class="rdo"><input type="radio" id="selectUrm2" name="CHOICE_SEL" value="N"/><span id="">직접입력</span></label>
                        </div>
                        <div class="col" id="choice1"  >
                        <select id="new_URM_NM1" name="URM_NM"   style="width: 150px">
                        	<option value="HP">홈플러스</option>
                        	<option value="LT">롯데마트</option>
                        	<option value="EM">이마트</option>
                        	<option value="LS">롯데슈퍼</option>
                        	<option value="LB">롯데빅마켓</option>
                        	<option value="NH">농협하나로마트</option>
                        	<option value="GS">GS수퍼마켓</option>
                        	<option value="HW">하이웨이마트</option>
                        	<option value="CT">센터</option>
                        </select>
                        <input type="text" id="new_URM_NM2" name="URM_NM2" style="width: 200px;" alt="소매점명">
                        </div>
                        <div class="col" id="choice2" style="display:none" >
                        <input type="text" id="new_URM_NM2_1" name="URM_NM" style="width: 150px" alt="소매점명">
                        <input type="text" id="new_URM_NM2_2" name="URM_NM2" style="width: 200px;" alt="소매점명">
                        </div>
                        <button type="button" id="nourmChk" class="btn34 c6" style="width: 92px;">중복확인</button>
						<input type="text" id="USE_URM_CODE_YN" name="USE_URM_CODE_YN" style="width: 30px;display: none;" class="i_notnull" alt=""  >
                        <span class="notice" style="color: RED;">예시) 이마트(선택) 부천점(지점명 직접입력) </span>
                        </div>
                    </div>
                </div>
                
                 <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">신규등록여부</div>    <!-- 조회기간 -->
                        <div class="box" id="NEW_YN_SEL">
							<label class="rdo"><input type="radio" id="NEW_YN1" name="NEW_YN" value="N"><span>추가등록</span></label>
							<label class="rdo"><input type="radio" id="NEW_YN2" name="NEW_YN" value="Y" checked="checked"><span>신규등록</span></label>
						 </div>
                    </div>
                </div> 
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">무인회수기 시리얼번호</div>    <!-- 조회기간 -->
                        <div class="box">
                        			<input type="text" id="SERIAL_NO" name="SERIAL_NO" style="width: 330px;" class="i_notnull" alt="무인회수기시리얼번호"  format="number"  maxByteLength="19">
									<button type="button" id="noChk" class="btn34 c6" style="width: 92px;">중복확인</button>
									<input type="text" id="USE_ABLE_YN" name="USE_ABLE_YN" style="width: 30px;display: none;" class="i_notnull" alt=""  >
                        </div>
                    </div>
                </div> <!-- end of row -->
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">센터고유넘버</div>    <!-- 조회기간 -->
                        <div class="box">
                        	<input type="text" id="URM_CE_NO" name="URM_CE_NO" style="width: 330px;" class="i_notnull" alt="센터고유넘버"   maxByteLength="9" readonly="readonly">
							<button type="button" id="noChk2" class="btn34 c6" style="width: 92px;">새로받기</button>
<!-- 							<input type="text" id="USE_ABLE_YN2" name="USE_ABLE_YN2"  style="width: 30px;display: none;" class="i_notnull" alt=""  > -->
                        </div>
                    </div>
                </div> <!-- end of row -->
<!--                 <div id="total_address" style="display:none"> -->
                <div class="row" id="total_address1">
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">지역</div>    <!-- 조회기간 -->
                        <div class="box">
                        	<select id="AREA_CD" name="AREA_CD" style="width: 179px" class="i_notnull" alt="지역" ></select>
                        </div>
                    </div>
                </div>
                <div class="row"  id="total_address2">
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">주소</div>    <!-- 조회기간 -->
                        <div class="box">
                        	<input type="text" class="i_notnull" id="PNO" name="PNO" style="width: 179px;" alt="우편번호" readonly="readonly">
							<button type="button" id="btnPopZip" class="btn34 c6" style="width: 122px;">우편번호 검색</button>
							<br>
							<input type="text" id="ADDR1" name="ADDR1" style="width: 330px;" maxByteLength="500" class="i_notnull" alt="사업장주소">
							<br>
							<input type="text" id="ADDR2" name="ADDR2" style="width: 330px;" placeholder="상세주소입력" maxByteLength="500" class="i_notnull" alt="사업장 상세주소">
                        </div>
                    </div>
                </div> <!-- end of row -->
<!--                 </div> -->
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">설치일자</div>    <!-- 조회기간 -->
                        <div class="box">
                        	<div class="calendar">
                                <input type="text" id="START_DT" name="URM_USE_DT" style="width: 179px;" class="i_notnull"><!--시작날짜  -->
                            </div>
                        		<%-- <input type="text" id="START_DT" name="from" value="<c:out value='${VIEW_ST_DATE}' />" style="width: 180px;" class="i_notnull" alt="시작날짜"> --%>
                        </div>
                    </div>
                </div> <!-- end of row -->
                <!-- <div class="row" >
                    <div class="col"  style="width: 100%;">
                        <div class="tit" style="width: 150px">철거일자</div>    조회기간
                        <div class="box">
                        	<input type="text" id="END_DT" name="URM_DE_DT" value="" style="width: 180px;" class="i_notnull" alt="시작날짜">
                        </div>
                    </div>
                </div> end of row -->
				<div class="row">
					<div class="col" style="width: 100%">
						<div class="tit" style="width: 150px">최초설치일자</div>
						<div class="box">
							<input type="text" id="URM_USE_DT" name="from" style="width: 179px;" class="i_notnull">
							<!--시작날짜  -->
						</div>
					</div>
				</div>
				<!-- end of row -->
				<div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">품질보증만료일자</div>  
							<div class="box">
                                <input type="text" id="URM_DE_DT" name="to" style="width: 179px;"    class="i_notnull"><!-- 끝날짜 -->
                            </div>
                        </div>
                </div> <!-- end of row -->
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">무인회수기 유형</div>    <!-- 조회기간 -->
                        <div class="box">
                       			<select id="URM_TYPE" style="width: 180px;">
								<option value="A">독립형</option>
								<option value="B">매립형</option>
								</select>
                        </div>
                    </div>
                </div> <!-- end of row -->
                <div class="row" >
                    <div class="col"  style="width: 100%">
                        <div class="tit" style="width: 150px">담당자연락처</div>    <!-- 조회기간 -->
                        <div class="box">
                        	<input type="text" id="TELNO" name="TELNO" style="width: 250px;" class="i_notnull" alt="" maxByteLength="30">
                        </div>
                    </div>
                </div> <!-- end of row -->
				<div class="row">
					<div class="col" style="width: 100%">
						<div class="tit" style="width: 150px">E-MAIL</div>
						<!-- 조회기간 -->
						<div class="box">
							<input type="text" id="EMAIL_TXT" name="EMAIL_TXT"
								style="width: 179px;" class="i_notnull" maxLength="20">
							<div class="sign">@</div>
							<input type="text" id="DOMAIN_TXT" name="DOMAIN_TXT"
								style="width: 179px;" class="i_notnull" maxLength="20">
							<select id="DOMAIN" name="DOMAIN" style="width: 179px;">
								<option id="drct_input" value=""></option>
							</select>
						</div>
					</div>
				</div>
			</div>  <!-- end of srcharea -->
			<input type="hidden" id="EMAIL" name="EMAIL"/>
        </section>
        </form>
		<section class="btnwrap mt20" >
		<div class="btnwrap">
			<div class="fl_r" id="BR">
 						<!-- <button type="button" class="btn36 c4" style="width: 100px;" id="btn_lst">취소</button> 
 						<button type="button" class="btn36 c2" style="width: 100px;" id="btn_reg">저장</button> -->
			</div>
		</div>
		</section>
     </div>
</body>
</html>