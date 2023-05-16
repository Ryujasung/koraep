<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Insert title here</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script src="/js/kora/paging_common.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />

<script type="text/javaScript" language="javascript" defer="defer">
	var INQ_PARAMS;
	var BankCdList;
	 $('#part1').show();
     $('#part2').hide();
     
     var whsdlList;//도매업자 업체명 조회
	    var areaList;//지역
	    var toDay = kora.common.gfn_toDay();// 현재 시간
	    var selList;
	    
	$(function(){
		
		
		////////////////////////
	        areaList = jsonObject($("#areaList").val());//지역
	        whsdlList = jsonObject($("#whsdlList").val());//도매업자 업체명 조회
	        
	        fn_init(); 
	          
	        //버튼 셋팅
	        fn_btnSetting();
	         
	        /************************************
	         * 조회 클릭 이벤트
	         ***********************************/
	        $("#btn_sel").click(function(){
	            fn_sel();
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
	         * 시작날짜  클릭시 - 삭제 변경 이벤트
	         ***********************************/
	        $("#START_DT").click(function(){
	            var start_dt = $("#START_DT").val();
	            start_dt   =  start_dt.replace(/-/gi, "");
	            $("#START_DT").val(start_dt)
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
	        
		/////////////////////////////
		
		INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
		BankCdList = jsonObject($('#BankCdList').val());
		
		$('#title_sub').text('<c:out value="반환수집소정보등록" />');
// 		fn_btnSetting();
 		kora.common.setEtcCmBx2(BankCdList, "", "", $("#AcpBankCdList_SEL"), "ETC_CD", "ETC_CD_NM", "N", "S");
 		kora.common.setEtcCmBx2(whsdlList, "","", $("#WHSDL_BIZRNM"), "BIZRNO_DE", "CUST_BIZRNM", "N" ,'S');//도매업자 업체명
// 		kora.common.setMailArrCmBx("", $("#DOMAIN"));	//메일도메인
// 		kora.common.setMailArrCmBx("", $("#ASTN_EMAIL_DOMAIN"));	//보조메일도메인
// 		kora.common.setTelArrCmBx("", $("#TEL_NO1"));		//전화번호 국번
// 		kora.common.setTelArrCmBx("", $("#RPST_TEL_NO1"));	//전화번호 국번
// 		kora.common.setTelArrCmBx("", $("#FAX_NO1"));		//전화번호 국번
// 		kora.common.setHpArrCmBx("", $("#MBIL_NO1"));	//핸드폰 국번
// 		kora.common.setHpArrCmBx("", $("#RPST_MBIL_NO1"));	//핸드폰 국번
// 		$('#drct_input').text(parent.fn_text('drct_input'));
// 		$('#drct_input2').text(parent.fn_text('drct_input'));
// 		$('#cho1').text(parent.fn_text('cho'));
// 		$('#cho2').text(parent.fn_text('cho'));
// 		$('#cho3').text(parent.fn_text('cho'));
// 		$('#cho4').text(parent.fn_text('cho'));
// 		$('#cho5').text(parent.fn_text('cho'));

		
		/**
		 * 우편번호검색 버튼 클릭 이벤트
		 */
		 var parent_item;
		$("#btnPopZip").click(function(){
			var pagedata = window.frameElement.name;
			window.parent.NrvPub.AjaxPopup('/SEARCH_ZIPCODE_POP.do', pagedata);
		});
		
		/**
		 * 사업자번호 중복체크
		 */
		 $("#bizrnoChk").click(function(){
			 fn_bizrnoCheck();
		 });
		
		/**
		 * 관리자아이디 중복체크
		 */
		 $("#chk").click(function(){
			 fn_dupleCheck();
		 });
		
		 /**
		  * 예금주 중복체크
		  */
		 $("#chk2").click(function(){
			 fn_acctCheck();
		 });
		 
		 	
		/**
		 * 이메일 도메인 변경 이벤트
		 */
		$("#DOMAIN").change(function(){
			
			$("#EMAIL2").val(kora.common.null2void($(this).val()));
			
			if(kora.common.null2void($(this).val()) != "") 
				$("#EMAIL2").attr("disabled",true);
			else
				$("#EMAIL2").attr("disabled",false);
		});
		
		/**
		 * 보조이메일 도메인 변경 이벤트
		 */
		$("#ASTN_EMAIL_DOMAIN").change(function(){
			
			$("#ASTN_EMAIL2").val(kora.common.null2void($(this).val()));
			
			if(kora.common.null2void($(this).val()) != "") 
				$("#ASTN_EMAIL2").attr("disabled",true);
			else
				$("#ASTN_EMAIL2").attr("disabled",false);
		});
		
		/**
		 * 은행, 계좌변경시 체크값 초기화
		 */
		/* $("#AcpBankCdList_SEL, #ACP_ACCT_NO").bind("change", function(){
			$(":checkbox[name='ACCT_CHECK_YN']").prop("checked", false);
			$("#ACP_ACCT_DPSTR_NM").val("");
		}); */

		/**
		 * 아이디변경시 중복확인 초기화
		 */
		$("#ADMIN_ID").bind("change", function(){
			$("#USE_ABLE_YN").val("");
		});
		
		/**
		 * 취소버튼 클릭 이벤트
		 */
		$("#btn_cncl").click(function(){
			
			/* var tmp = $("#WHSDL_BIZRNM").val().split(';');
			alert(tmp[0]);			 */
			
			
			
			fn_cncl();
		});
		
		/**
		 * 저장버튼 클릭 이벤트
		 */
		$("#btn_reg").click(function(){
			fn_reg();
		});
		
		 $("[name=BIZR_SE_CD]").change(function() { 
		      var bizrSecd = $("input:radio[name='BIZR_SE_CD']:checked").val();
		      if(bizrSecd == 'H'){
		    	  $('#bizrSeCdH').attr('rowspan', '2');
		    	  
	    		  $('.bizrSeCdH').each(function(){
	    			  $(this).attr('style', 'display:none');
	    		  });
		      }else{
	    		  $('.bizrSeCdH').each(function(){
	    			  $(this).attr('style', '');
	    		  });
	    		  $('#bizrSeCdH').attr('rowspan', '4');
		      }
		      
		      window.frameElement.style.height = $('.iframe_inner').height()+5+'px';
		 }); 
		 
		 $("[name=BIZR_TP_CD]").change(function() { 
		      var bizrTpcd = $("input:radio[name='BIZR_TP_CD']:checked").val();
		      if(bizrTpcd == 'M1' || bizrTpcd == 'M2'){
	    		  $('.bizrTpCdM').each(function(){
	    			  $(this).attr('style', '');
	    		  });
		      }else{
	    		  $('.bizrTpCdM').each(function(){
	    			  $(this).attr('style', 'display:none');
	    		  });
		      }
		      
		      window.frameElement.style.height = $('.iframe_inner').height()+5+'px';
		 }); 
	});
	
	//저장
	function fn_reg(){

		if(kora.common.format_noComma(kora.common.null2void($("#RCS_NM").val(),0))  < 1) {
	    	alertMsg("반환수집소을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	        chkTarget = $("#RCS_NM");
	        return;
	        } 
		
		if(kora.common.format_noComma(kora.common.null2void($("#PNO").val(),0))  < 1) {
	    	alertMsg("우편번호을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	        chkTarget = $("#PNO");
	        return;
	        } 		
		
		/* if(kora.common.format_noComma(kora.common.null2void($("#ADDR2").val(),0))  < 1) {
	    	alertMsg("상세주소을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	        chkTarget = $("#ADDR2");
	        return;
	        } 		 */
		
		if(kora.common.format_noComma(kora.common.null2void($("#AreaCdList_SEL").val(),0))  < 1) {
	    	alertMsg("지역을(를) 선택하십시요.", "kora.common.cfrmDivChkValid_focus");
	        chkTarget = $("#AreaCdList_SEL");
	        return;
	        } 		
		
		if(kora.common.format_noComma(kora.common.null2void($("#WHSDL_BIZRNM").val(),0))  < 1) {
	    	alertMsg("관리업체을(를) 선택하십시요.", "kora.common.cfrmDivChkValid_focus");
	        chkTarget = $("#WHSDL_BIZRNM");
	        return;
	        } 
		
		/* if($("#FILE_NM").val() == null || $("#FILE_NM").val() == "" || $("#FILE_NM").val() == " "){
			alertMsg("계약서을(를) 첨부해주십시요.");
			return;
		} */
		
		
		if(kora.common.format_noComma(kora.common.null2void($("#MN_TEL").val(),0))  < 1) {
	    	alertMsg("업체 담당자명을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	        chkTarget = $("#MN_TEL");
	        return;
	        } 
		
		if(kora.common.format_noComma(kora.common.null2void($("#MN_HTEL").val(),0))  < 1) {
	    	alertMsg("업체 담당자 핸드폰을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	        chkTarget = $("#MN_HTEL");
	        return;
	        } 

		if(kora.common.format_noComma(kora.common.null2void($("#LOC_GOV").val(),0))  < 1) {
	    	alertMsg("관리 지자체을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	        chkTarget = $("#LOC_GOV");
	        return;
	        } 		

		if(kora.common.format_noComma(kora.common.null2void($("#LOC_NM").val(),0))  < 1) {
	    	alertMsg("담당자명을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	        chkTarget = $("#LOC_NM");
	        return;
	        } 		
		
		if(kora.common.format_noComma(kora.common.null2void($("#LOC_TEL").val(),0))  < 1) {
	    	alertMsg("담당자 연락처을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	        chkTarget = $("#LOC_TEL");
	        return;
	        } 		

		if(kora.common.format_noComma(kora.common.null2void($("#LOC_HTEL").val(),0))  < 1) {
	    	alertMsg("담당자 핸드폰을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	        chkTarget = $("#LOC_HTEL");
	        return;
	        } 
		
		if(kora.common.format_noComma(kora.common.null2void($("#LOC_EMAIL").val(),0))  < 1) {
	    	alertMsg("담당자 이메일을(를) 입력하십시요.", "kora.common.cfrmDivChkValid_focus");
	        chkTarget = $("#LOC_EMAIL");
	        return;
	        } 
		
		confirm('저장하시겠습니까?', 'fn_reg_exec');
	}
	
	//autoComplete 도매업자 멀티 SELECTBOX
    function fn_autoCompleteSelected(data){
    	acSelected = new Array();
    	if(data.length>0){
    		for(var i =0;i<data.length ;i++){
   				var input={};
			    input["WHSDL_BIZRID_NO"]	=data[i].value
				input["WHSDL_BIZRNM"] 		=data[i].text;
				acSelected.push(input);
    		}	 
    	}
    }
	
	function fn_reg_exec(){
		var sData = '';
	 	var url = "/CE/EPCE9000231_1.do";
	 	fileajaxPost(url, sData, function(rtnData){
	 		if ("" != rtnData && null != rtnData) {
				alertMsg(rtnData.RSLT_MSG, 'fn_cncl');
			} else {
				alertMsg("error");
			}
	 	});
	}
	
	/**
	 * 취소
	 */
	function fn_cncl(){
// 		if(!confirm("사업자관리 페이지로 이동하시겠습니까?")) return;
		
		kora.common.goPageB('/CE/EPCE9000201.do', INQ_PARAMS);
	}
	
	/**
	 * 계좌인증 - 예금주확인
	 */
	function fn_acctCheck(){
		var bankCd  = $("#AcpBankCdList_SEL option:selected").val();
		var acctNo  = $("#ACP_ACCT_NO").val();
		var dpstrNm = $("#ACP_ACCT_DPSTR_NM").val();
		if(bankCd == null || bankCd == ""){
			alertMsg("수납은행을 선택하세요.");
			return;
		}
		else if(acctNo == null || acctNo == ""){
			alertMsg("수납계좌번호를 입력하지 않았습니다.");
			return;
		}
		/* else if(dpstrNm == null || dpstrNm == ""){
			alertMsg("예금주명를 선택하지 않았습니다.");
			return;
		} */
		
		var flag = true;
		if(location.href.indexOf("localhost") > -1 || location.href.indexOf("devreuse") > -1){
			$(":checkbox[name='ACCT_CHECK_YN']").prop("checked", true);
			$("#ACP_ACCT_DPSTR_NM").val($("#RPST_NM").val());
			flag = false;
			return;
		}
		
		var sData = {"BANK_CD":bankCd, "SEARCH_ACCT_NO":acctNo};
		var url   = "/CE/ACCT_NM_CHECK.do";		//예금주명체크
		ajaxPost(url, sData, function(data){
			if(data.RSLT_CD != "0000"){
				alertMsg(data.RSLT_MSG);
				return;
			}
			else{
				$(data.RESP_DATA).each(function(key,obj){
					var str = obj.ACCT_NM;		//gfn_Convert2ByteChar(obj.ACCT_NM);	//전각을 반각처리
					$(":checkbox[name='ACCT_CHECK_YN']").prop("checked", true);
					$("#ACP_ACCT_DPSTR_NM").val(str);
// 					if(!flag || dpstrNm.substring(0, str.length) == str){//개발
// 						$(":checkbox[name='ACCT_CHECK_YN']").prop("checked", true);
// 						$("#ACP_ACCT_DPSTR_NM").val(str);
// 						alertMsg("예금주 정보가 확인되었습니다.");
// 						return;
// 					}
// 					else{
// 						alertMsg("예금주명이 일치하지 않습니다.");
// 					} 
				});
			}
		});
	}
	
	/**
	 * 저장 시 체크
	 */
	function fn_ChkBfSave(){
		
		//필수값 체크
		if(!kora.common.cfrmDivChkValid("div_input")) return false;
		
		var bizrTpcd = $("input:radio[name='BIZR_TP_CD']:checked").val();
		if(bizrTpcd == 'M1' || bizrTpcd == 'M2'){
			if($("#MFC_DPS_VACCT_NO").val() == ""){
				alertMsg("빈용기보증금 가상계좌를 확인하세요.");
				return false;
			}
			if($("#MFC_FEE_VACCT_NO").val() == ""){
				alertMsg("취급수수료 가상계좌를 확인하세요.");
				return false;
			}
		}

		var BIZRNO = $("#BIZRNO1").val() + "" + $("#BIZRNO2").val() + "" + $("#BIZRNO3").val();

		//사업자번호 체크
 		if(!kora.common.gfn_bizNoCheck(BIZRNO)){
 			alertMsg("유효하지 않은 사업자번호 입니다.");
 			return false;
		}
		
 		if($("#DUPLE_CHECK_YN2").val() != "Y"){
			alertMsg("사업자등록번호 중복체크를 하지 않았습니다.");
			return false;
		}
		
 		if($("#USE_ABLE_YN2").val() != "Y"){
			alertMsg("사용할 수 없는 사업자등록번호 입니다.\n중복체크 후 사용 하시기 바랍니다.");
			return false;
		}
		
		if($("#DUPLE_CHECK_YN").val() != "Y"){
			alertMsg("아이디 중복체크를 하지 않았습니다.");
			return false;
		}
		
		if($("#USE_ABLE_YN").val() != "Y"){
			alertMsg("사용할 수 없는 아이디 입니다.\n아이디 중복체크 후 사용 하시기 바랍니다.");
			return false;
		}

		//이메일 유효성 체크
		var regExp = /[0-9a-zA-Z][_0-9a-zA-Z-]*@[_0-9a-zA-Z-]+(\.[_0-9a-zA-Z-]+){1,2}$/;
		var emailAddr = $.trim($("#EMAIL1").val()) +"@"+ $.trim($("#EMAIL2").val());
		$('#EMAIL').val(emailAddr);
		if(emailAddr.lenght == 0){
			alertMsg("이메일은 필수 입력입니다.");
			return false;
		}
		if (!emailAddr.match(regExp)){
			alertMsg("이메일 형식에 맞지 않습니다.");
			return false;
		}
		if($.trim($("#ASTN_EMAIL1").val()) !="" || $.trim($("#ASTN_EMAIL2").val()) != ""){
			var assinEmailAddr = $.trim($("#ASTN_EMAIL1").val()) +"@"+ $.trim($("#ASTN_EMAIL2").val());
			$('#ASTN_EMAIL').val(assinEmailAddr);
			if (!assinEmailAddr.match(regExp)){
				alertMsg("보조 이메일이 형식에 맞지 않습니다.");
				return false;
			}
		}
		
		//도매업자/공병상 수납계좌 예금주 확인 여부 체크
		var flag = true;
		//if(location.href.indexOf("localhost") > -1 || location.href.indexOf("devreuse") > -1) flag = false;
		if(flag == true){
			//if($(":radio[name=BIZR_SE_CD]:checked").val() == "C" || $(":radio[name=BIZR_SE_CD]:checked").val() == "D"){
				if(!$(":checkbox[name='ACCT_CHECK_YN']").prop("checked")){
					alertMsg("예금주 확인을 하지 않았습니다.");
					return false;
				}
			//}
		}
		
		if($("#FILE_NM").val() == null || $("#FILE_NM").val() == "" || $("#FILE_NM").val() == " "){
			alertMsg("사업자 등록증 첨부는 필수입니다.");
			return;
		}
		
		if($("#RPST_MBIL_NO1").val() == "" || $("#RPST_MBIL_NO2").val() == "" || $("#RPST_MBIL_NO3").val() == ""){
			alertMsg("대표 휴대폰번호는 필수입니다.");
			return;
		}

		return true;
	}
	
	/**
	 * 저장 시 체크2
	 */
	function fn_ChkBfSave2(){
		
		if($("#BIZRNM").val() == '' ){
			alertMsg('사업자명을 확인하세요.');
			return;
		}
		
		if($("#BIZRNO1").val() == '' || $("#BIZRNO2").val() == '' || $("#BIZRNO3").val() == ''){
			alertMsg('사업자번등록번호를 확인하세요.');
			return;
		}
		
		var BIZRNO = $("#BIZRNO1").val() + "" + $("#BIZRNO2").val() + "" + $("#BIZRNO3").val();

		//사업자번호 체크
 		if(!kora.common.gfn_bizNoCheck(BIZRNO)){
 			alertMsg("유효하지 않은 사업자번호 입니다.");
 			return false;
		}
		
 		if($("#DUPLE_CHECK_YN2").val() != "Y"){
			alertMsg("사업자등록번호 중복체크를 하지 않았습니다.");
			return false;
		}
		
 		if($("#USE_ABLE_YN2").val() != "Y"){
			alertMsg("사용할 수 없는 사업자등록번호 입니다.\n중복체크 후 사용 하시기 바랍니다.");
			return false;
		}

		if($.trim($("#ASTN_EMAIL1").val()) !="" || $.trim($("#ASTN_EMAIL2").val()) != ""){
			var assinEmailAddr = $.trim($("#ASTN_EMAIL1").val()) +"@"+ $.trim($("#ASTN_EMAIL2").val());
			if (!assinEmailAddr.match(regExp)){
				alertMsg("보조 이메일이 형식에 맞지 않습니다.");
				return false;
			}
		}
		
		//도매업자/공병상 수납계좌 예금주 확인 여부 체크
		var flag = true;
		if(location.href.indexOf("localhost") > -1 || location.href.indexOf("devreuse") > -1) flag = false;
		if(flag == true){
			if($('#ACP_ACCT_NO').val() != '' || $('#AcpBankCdList_SEL').val() != ''){
				if(!$(":checkbox[name='ACCT_CHECK_YN']").prop("checked")){
					alertMsg("예금주 확인을 하지 않았습니다.");
					return false;
				}
			}
		}

		return true;
	}
	

	/**
	 * 사업자번호 중복 체크
	 */
	function fn_bizrnoCheck(){

		if($("#BIZRNO1").val() == null || $("#BIZRNO1").val() == ""){
			alertMsg("사업자번호를 입력하세요");
			$("#BIZRNO1").focus();
			return;
		}
		if($("#BIZRNO2").val() == null || $("#BIZRNO2").val() == ""){
			alertMsg("사업자번호를 입력하세요");
			$("#BIZRNO2").focus();
			return;
		}
		if($("#BIZRNO3").val() == null || $("#BIZRNO3").val() == ""){
			alertMsg("사업자번호를 입력하세요");
			$("#BIZRNO3").focus();
			return;
		}
		
		var BIZRNO = $("#BIZRNO1").val() + "" + $("#BIZRNO2").val() + "" + $("#BIZRNO3").val();

		//사업자번호 체크
 		if(!kora.common.gfn_bizNoCheck(BIZRNO)){
 			alertMsg("유효하지 않은 사업자번호 입니다.");
 			return false;
		}
		
		var sData = {"BIZRNO" : BIZRNO};
		var url = "/CE/EPCE0160131_3.do";
		ajaxPost(url, sData, function(data){
			$("#DUPLE_CHECK_YN2").val("Y");
			$("#USE_ABLE_YN2").val(data.USE_ABLE_YN);
			if(data.USE_ABLE_YN == "Y"){
				alertMsg("사용 가능한 사업자번호 입니다.");
			}else{
				alertMsg("이미 등록된 사업자번호  입니다.");
				return;
			}
		});
	}
	
	/**
	 * id중복 체크
	 */
	function fn_dupleCheck(){
		var ADMIN_ID = $("#ADMIN_ID").val();
		if(ADMIN_ID == null || ADMIN_ID == ""){
			alertMsg("관리자 아이디를 입력하세요");
			$("#ADMIN_ID").focus();
			return;
		}
		
		if(!kora.common.gfn_idValidChk(ADMIN_ID)){
			alertMsg("아이디는 영문자와 숫자를 조합하여 6자리 이상 16자리 이하로 입력하여야 합니다.");
			return;
		}
		
		if(!kora.common.gfn_idPwChkValid(ADMIN_ID)) return;
		
		//DUPLE_CHECK_YN, USE_ABLE_YN
		var sData = {"USER_ID" : ADMIN_ID};
		var url = "/CE/EPCE0160131_2.do";
		ajaxPost(url, sData, function(data){
			$("#DUPLE_CHECK_YN").val("Y");
			$("#USE_ABLE_YN").val(data.USE_ABLE_YN);
			if(data.USE_ABLE_YN == "Y"){
				alertMsg("사용 가능한 아이디 입니다.");
			}else{
				alertMsg("이미 사용중인 아이디 입니다. \n다른 아이디를 사용하시기 바랍니다.");
				return;
			}
		});
	}
	
	/**
	 * 파일첨부(사업자 등록 사본)
	 */
	function fn_fileCheck(str, gubn){
		if(str == null || str == "") return;
		var extArr = null;
		var errMsg = "";
		var sItem  = "";
		
		//계약서 등록
			extArr = new Array("pdf", "gif", "jpg", "jpeg", "png", "tif", "bmp");
			errMsg = "입력 가능한 파일(확장자)이 아닙니다. \n이미지(gif, jpg, png, tif, bmp) 또는 PDF(pdf)파일만 등록이 가능합니다.";
			sItem  = "FILE_NM";
		
		var tmpStr = str.split('/').pop().split('\\').pop();
		var ext = tmpStr.substring(tmpStr.lastIndexOf(".")+1, tmpStr.length).toLowerCase();
		if($.inArray(ext, extArr) < 0){
			alertMsg(errMsg);
			$("#"+sItem).val("");
			$("#"+sItem).replaceWith( $("#"+sItem).clone(true) );
		}
	}
	
	
	$(document).ready(function(){
		
		$(".YJcalendar-trigger").prop("disabled", true);
		 
	    // 라디오버튼 클릭시 이벤트 발생
	  /*   $("input:radio[name=radiochk]").click(function(){
	 
	        if($("input[name=radiochk]:checked").val() == "Y"){
	            $("#lo1").css("display", "");
	            $("#lo2").css("display", "");
	            $("#ma1").css("display", "none");
	            $("#ma2").css("display", "none");
	            $("#ma3").css("display", "none");
	            $("#ma4").css("display", "none");
	            $("#ma6").css("display", "none");
	            $("#ma7").css("display", "none");
	            $("#ma8").css("display", "none");
	            $("#ma10").css("display", "none");

	            // radio 버튼의 value 값이 1이라면 활성화
	 
	        }else if($("input[name=radiochk]:checked").val() == "N"){
	        		 $("#lo1").css("display", "none");
		            $("#lo2").css("display", "none");
		            $("#ma1").css("display", "");
		            $("#ma2").css("display", "");
		            $("#ma3").css("display", "");
		            $("#ma4").css("display", "");
		            $("#ma6").css("display", "");
		            $("#ma7").css("display", "");
		            $("#ma8").css("display", "");
		            $("#ma10").css("display", "");
	            // radio 버튼의 value 값이 0이라면 비활성화
	        }
	    }); */
	});
	
	
	    
	    //셋팅
	    function fn_init(){
	         
	        //날짜 셋팅
	        $('#START_DT').YJcalendar({  
	            toName : 'to',
	            triggerBtn : true,
	            dateSetting : kora.common.getDate("yyyy-mm-dd", "D", -7, false).replaceAll('-','')
	        });
	        
	        $('#END_DT').YJcalendar({
	            fromName : 'from',
	            triggerBtn : true,
	            dateSetting : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
	        });
	        
	        //text 셋팅
	        /*  $('.row > .col > .tit').each(function(){
	            $(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
	        }); */
	            
	        //div필수값 alt
	        $("#START_DT").attr('alt',parent.fn_text('sel_term'));
	        $("#END_DT").attr('alt',parent.fn_text('sel_term'));
	        
	      //도매업자  검색
	  		$("#WHSDL_BIZRNM").select2();
	    }
	    
	    function chageLangSelect(){
			console.log(kora.common.setDelim);
			$("#WHSDL_BIZRNO").val(kora.common.setDelim($("#WHSDL_BIZRNM").val(), "999-99-99999"));
	    	//$("#WHSDL_BIZRNO").val($("#WHSDL_BIZRNM").val());
			
	    	
	    }

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

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="BankCdList" value="<c:out value='${BankCdList}' />"/>
<input type="hidden" id="whsdlList" value="<c:out value='${whsdlList}' />" />

	<div class="iframe_inner">
		<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
		</div>
				<form name="fileForm" id="fileForm" method="post" enctype="multipart/form-data">   <!--  action="/CE/EPCE0160119_1.do"  -->
		
				<section class="secwrap"   id="params">
				
		            <div class="srcharea mt10" > 
     			
		               <!--  <div class="row" >
		                    <div class="col"  style="width: 100%">
		                        <div class="tit">업체유형</div>    
		                        <div class="box" style="margin-top: 8px">
		                        	<input type="radio"  name ="radiochk" value ="N" style="padding-right: 5px" checked="checked">	<span style="font-size: 11pt">&nbsp;관리업체&nbsp;&nbsp;&nbsp;</span>
									<input type="radio"  name="radiochk"  value="Y" >	<span  style="font-size: 11pt">&nbsp;지자체 </span>
		                        </div>
		                    </div>
		                </div>  -->
		                
		                <div class="row" >
		                    <div class="col"  style="width: 100%">
		                        <div class="tit">반환수집소명</div>  
		                        <div class="box">
		                        	<input type="text" id="RCS_NM" name="RCS_NM" style="width: 330px;" class="i_notnull" alt="반환수집소명">
									<span class="notice" style="color: RED;">예시) OOO시 OO읍 반환수집소 </span>
		                        </div>
		                    </div>
		                </div> <!-- end of row -->
		                
		                <div class="row"   id="ma1">
		                    <div class="col"  style="width: 100%">
		                        <div class="tit">반환수집소상태</div>  
		                        <div class="box">
		                        	<select id="RCS_BIZR_CD" name="RCS_BIZR_CD" style="width: 330px;"> 
										<option value="Y">운영</option>
										<option value="N">미운영</option>
									</select>
		                        </div>
		                    </div>
		                </div> <!-- end of row -->
		                
		                 <div class="row"   id="ma2">
		                    <div class="col"  style="width: 100%">
		                        <div class="tit">무인회수기여부</div>  
		                        <div class="box">
		                        	<select id="URM_YN" name="URM_YN" style="width: 330px;"> 
										<option value="Y">유</option>
										<option value="N">무</option>
									</select>
		                        </div>
		                    </div>
		                </div> <!-- end of row -->
		                <div class="row" >
		                    <div class="col"  style="width: 100%">
		                        <div class="tit">반환수집소 주소</div>  
		                        <div class="box">
		                        	<input type="text" class="i_notnull" id="PNO" name="PNO" style="width: 179px;" alt="우편번호" readonly="readonly">
									<button type="button" id="btnPopZip" class="btn34 c6" style="width: 122px;">우편번호 검색</button>
									<br>
									<input type="text" id="ADDR1" name="ADDR1" style="width: 330px;" maxByteLength="500" class="i_notnull" alt="사업장주소">
									<br>
									<input type="text" id="ADDR2" name="ADDR2" style="width: 330px; margin-left: 5px !important;" placeholder="상세주소입력" maxByteLength="500" class="i_notnull" alt="사업장 상세주소">
		                        </div>
		                    </div>
		                </div> <!-- end of row -->
		                <div class="row" >
		                    <div class="col"  style="width: 100%">
		                        <div class="tit">지역</div>    <!-- 조회기간 -->
		                        <div class="box">
		                        	<select id="AreaCdList_SEL" name="AreaCdList_SEL" style="width: 179px">
									<option value="">전체</option><option class="generated" value="A02">부산광역시</option><option class="generated" value="A03">대구광역시</option><option class="generated" value="A04">인천광역시</option><option class="generated" value="A05">대전광역시</option><option class="generated" value="A06">울산광역시</option><option class="generated" value="A07">광주광역시</option><option class="generated" value="B01">경기도</option><option class="generated" value="B02">강원도</option><option class="generated" value="B03">충청북도</option><option class="generated" value="B04">충청남도</option><option class="generated" value="B05">경상북도</option><option class="generated" value="B06">경상남도</option><option class="generated" value="B07">전라북도</option><option class="generated" value="A01">서울특별시</option><option class="generated" value="B08">전라남도</option><option class="generated" value="B10">세종시</option><option class="generated" value="B09">제주도</option>
									</select>
		                        </div>
		                    </div>
		                </div> <!-- end of row -->
		                <div  class="row"  style="width: 100%;font-size: 16pt; font-weight: bold;text-align:left;background-color: #f0f0f0;">관리업체 정보</div>
		                 <div class="row"   id="ma3">
		                    <div class="col"  style="width: 100%">
		                        <div class="tit">관리업체</div>  
		                        <div class="box">
		                        	<!-- <input type="text" id="WHSDL_BIZRNM" name="WHSDL_BIZRNM" style="width: 330px;" class="i_notnull"  > -->
		                        	<select id="WHSDL_BIZRNM" name="WHSDL_BIZRNM" style="width: 330px;" onchange="chageLangSelect()"></select>
		                        </div>
		                    </div>
		                </div> <!-- end of row -->
		                
		                <div class="row"   id="ma4">
		                    <div class="col"  style="width: 100%">
		                        <div class="tit">관리업체사업자번호</div>  
		                        <div class="box">
		                        	<input type="text" id="WHSDL_BIZRNO" name="WHSDL_BIZRNO" style="width: 330px;" readonly="readonly" class="i_notnull"  >
		                        </div>
		                    </div>
		                </div> <!-- end of row -->
		                
		                <!-- <div class="row"   id="ma4">
		                    <div class="col"  style="width: 100%">
		                        <div class="tit">관리업체계좌번호</div>  
		                        <div class="box">
		                        	<select id="AcpBankCdList_SEL" name="AcpBankCdList_SEL" style="width: 100px;">
									</select>
		                        	<input type="text" id="ACP_ACCT_NO" name="ACP_ACCT_NO" style="width: 330px;" class="i_notnull" >
		                        	<span class="notice">계좌번호는 '-'없이 숫자만 입력 가능합니다.</span>
		                        </div>
		                    </div>
		                </div> --> <!-- end of row -->
		                <div class="row" >
		                    <div class="col"  style="width: 100%">
		                        <div class="tit">계약서</div>  
		                        <div class="box">
		                        	<input type="file" name="FILE_NM" id="FILE_NM" style="width:305px;height:34px" onchange="fn_fileCheck(this.value, '1');" class="i_notnull" />
		                        </div>
		                    </div>
		                </div> <!-- end of row -->
		                
		                
		                
		                <div class="row"   >
		                    <div class="col"  style="width: 100%">
		                        <div class="tit" >계약(운영)기간</div>   
			                        <div class="box">
			                            <div class="calendar">
			                                <input type="text" id="START_DT" name="from" style="width: 179px;" class="i_notnull"><!--시작날짜  -->
			                            </div>
			                            <div class="obj">~</div>
			                            <div class="calendar">
			                                <input type="text" id="END_DT" name="to" style="width: 179px;"    class="i_notnull"><!-- 끝날짜 -->
			                            </div>
			                        </div>
		                    </div>
		                </div> <!-- end of row -->
		                
		                <div class="row"   id="ma6">
		                    <div class="col"  style="width: 100%">
		                        <div class="tit">업체 담당자명</div>  
		                        <div class="box">
		                        	<input type="text" id="MN_TEL" name="MN_TEL" style="width: 330px;" class="i_notnull"  >
		                        </div>
		                    </div>
		                </div> <!-- end of row -->
		                
		                <div class="row"   id="ma7">
		                    <div class="col"  style="width: 100%">
		                        <div class="tit">업체 담당자 핸드폰</div>  
		                        <div class="box">
		                        	<input type="text" id="MN_HTEL" name="MN_HTEL" style="width: 330px;" class="i_notnull"  >
		                        </div>
		                    </div>
		                </div> <!-- end of row -->
		                <div  class="row"  style="width: 100%;font-size: 16pt; font-weight: bold;text-align:left;background-color: #f0f0f0;">관리 지자체 정보</div>
		                
		                <div class="row"   id="lo1" style="">
		                    <div class="col"  style="width: 100%">
		                        <div class="tit">관리 지자체</div>   
		                        <div class="box">
		                        	<input type="text" id="LOC_GOV" name="LOC_GOV" style="width: 330px;" class="i_notnull" >
		                        </div>
		                    </div>
		                </div> <!-- end of row -->
		                
		                <div class="row"   id="lo2" style="">
		                    <div class="col"  style="width: 100%">
		                        <div class="tit">담당자명</div>  
		                        <div class="box">
		                        	<input type="text" id="LOC_NM" name="LOC_NM" style="width: 330px;" class="i_notnull"  >
		                        </div>
		                    </div>
		                </div> <!-- end of row -->
		                
		                <div class="row">
		                    <div class="col"  style="width: 100%">
		                        <div class="tit">담당자 연락처</div>  
		                        <div class="box">
		                        	<input type="text" id="LOC_TEL" name="LOC_TEL" style="width: 330px;" class="i_notnull"  >
		                        </div>
		                    </div>
		                </div> <!-- end of row -->
		                
		                <div class="row"  >
		                    <div class="col"  style="width: 100%">
		                        <div class="tit">담당자 핸드폰</div>  
		                        <div class="box">
		                        	<input type="text" id="LOC_HTEL" name="LOC_HTEL" style="width: 330px;" class="i_notnull"  >
		                        </div>
		                    </div>
		                </div> <!-- end of row -->
		                
		                 <div class="row"  >
		                    <div class="col"  style="width: 100%">
		                        <div class="tit">담당자 이메일</div>  
		                        <div class="box">
		                        	<input type="text" id="LOC_EMAIL" name="LOC_EMAIL" style="width: 330px;" class="i_notnull"  >
		                        </div>
		                    </div>
		                </div> <!-- end of row -->
                
					</div>  <!-- end of srcharea -->
					
					
       			</section>
       			
       			
		<section class="btnwrap mt20" >
		<div class="btnwrap">
			<div class="fl_r" id="BR">
<!-- 						<button type="button" class="btn36 c4" id="btn_cncl"style="width: 100px;">취소</button> -->
<!-- 						<button type="button" class="btn36 c2" id="btn_reg" style="width: 100px;">저장</button> -->
			</div>
		</div>
		</section>
</body>
</html>