<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Insert title here</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">
	var INQ_PARAMS;
	var BankCdList;

	$(function(){
		
		INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
		BankCdList = jsonObject($('#BankCdList').val());
		
		$('#title_sub').text('<c:out value="${titleSub}" />');
		fn_btnSetting();
		kora.common.setEtcCmBx2(BankCdList, "", "", $("#AcpBankCdList_SEL"), "ETC_CD", "ETC_CD_NM", "N", "S");
		kora.common.setMailArrCmBx("", $("#DOMAIN"));	//메일도메인
		kora.common.setMailArrCmBx("", $("#ASTN_EMAIL_DOMAIN"));	//보조메일도메인
		kora.common.setTelArrCmBx("", $("#TEL_NO1"));		//전화번호 국번
		kora.common.setTelArrCmBx("", $("#RPST_TEL_NO1"));	//전화번호 국번
		kora.common.setTelArrCmBx("", $("#FAX_NO1"));		//전화번호 국번
		kora.common.setHpArrCmBx("", $("#MBIL_NO1"));	//핸드폰 국번
		kora.common.setHpArrCmBx("", $("#RPST_MBIL_NO1"));	//핸드폰 국번
		$('#drct_input').text(parent.fn_text('drct_input'));
		$('#drct_input2').text(parent.fn_text('drct_input'));
		$('#cho1').text(parent.fn_text('cho'));
		$('#cho2').text(parent.fn_text('cho'));
		$('#cho3').text(parent.fn_text('cho'));
		$('#cho4').text(parent.fn_text('cho'));
		$('#cho5').text(parent.fn_text('cho'));
		
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
		$("#AcpBankCdList_SEL, #ACP_ACCT_NO").bind("change", function(){
			$(":checkbox[name='ACCT_CHECK_YN']").prop("checked", false);
			$("#ACP_ACCT_DPSTR_NM").val("");
		});

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

		var bizrSecd = $("input:radio[name='BIZR_SE_CD']:checked").val();
		if(bizrSecd == 'H'){
			if(!fn_ChkBfSave2()) return;
		}else{
			if(!fn_ChkBfSave()) return;
		}

		confirm('저장하시겠습니까?', 'fn_reg_exec');
	}
	
	function fn_reg_exec(){
		var sData = '';
	 	var url = "/CE/EPCE0160131_1.do";
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
		
		kora.common.goPageB('/CE/EPCE0160101.do', INQ_PARAMS);
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
		
		//생산자계약서 등록
		if(gubn == "2"){
			extArr = new Array("pdf", "zip", "alz", "gif", "jpg", "jpeg", "png", "tif", "bmp");
			errMsg = "입력 가능한 파일(확장자)이 아닙니다. \n압축(zip, alz)파일, PDF(pdf)파일 또는\n이미지(gif, jpg, png, tif, bmp)파일만 등록이 가능합니다.";
			sItem  = "CTRT_FILE_NM";
		}
		//사업자등록증 등록
		else{
			extArr = new Array("pdf", "gif", "jpg", "jpeg", "png", "tif", "bmp");
			errMsg = "입력 가능한 파일(확장자)이 아닙니다. \n이미지(gif, jpg, png, tif, bmp) 또는 PDF(pdf)파일만 등록이 가능합니다.";
			sItem  = "FILE_NM";
		}
		
		var tmpStr = str.split('/').pop().split('\\').pop();
		var ext = tmpStr.substring(tmpStr.lastIndexOf(".")+1, tmpStr.length).toLowerCase();
		if($.inArray(ext, extArr) < 0){
			alertMsg(errMsg);
			$("#"+sItem).val("");
			$("#"+sItem).replaceWith( $("#"+sItem).clone(true) );
		}
	}
</script>
</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="BankCdList" value="<c:out value='${BankCdList}' />"/>

	<div class="iframe_inner">
		<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
		</div>
		<section class="secwrap">
			<div class="write_area" id='div_input'>
			<div class="write_tbl">
				<form name="fileForm" id="fileForm" method="post" enctype="multipart/form-data">   <!--  action="/CE/EPCE0160119_1.do"  -->
					<table>
						<colgroup>
							<col style="width: 8%;">
							<col style="width: 15%;">
							<col style="width: auto;">
						</colgroup>
						<tr>
							<th colspan="2">수기사업자여부<span class="red">*</span></th>
							<td>
								<div class="row" id="BIZR_SE_CD">
									<label class="rdo"><input type="radio" id="BIZR_SE_CD1" name="BIZR_SE_CD" value="S" checked="checked"><span>시스템사용</span></label>
									<label class="rdo"><input type="radio" id="BIZR_SE_CD2" name="BIZR_SE_CD" value="H"><span>수기관리</span></label>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">사업자유형<span class="red">*</span></th>
							<td>
								<div class="row" id="BIZR_TP_CD">
									<label class="rdo"><input type="radio" id="BIZR_TP_CD1" name="BIZR_TP_CD" value="W1" checked="checked"><span>도매업자</span></label>
									<label class="rdo"><input type="radio" id="BIZR_TP_CD2" name="BIZR_TP_CD" value="W2"><span>공병상</span></label>
									<label class="rdo"><input type="radio" id="BIZR_TP_CD4" name="BIZR_TP_CD" value="R1"><span>소매업자</span></label>
									<label class="rdo"><input type="radio" id="BIZR_TP_CD5" name="BIZR_TP_CD" value="M1"><span>주류생산자</span></label>
									<label class="rdo"><input type="radio" id="BIZR_TP_CD6" name="BIZR_TP_CD" value="M2"><span>음료생산자</span></label>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">사업자명<span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="BIZRNM" name="BIZRNM" style="width: 330px;" class="i_notnull" alt="사업자명">
									<span class="notice">사업자명은 30자까지 입력 가능합니다.</span>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">사업자등록번호<span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="BIZRNO1" name="BIZRNO1" style="width: 100px;" maxlength="3" class="i_notnull" alt="사업자등록번호" format="number">
									<div class="dash">-</div>
									<input type="text" id="BIZRNO2" name="BIZRNO2" style="width: 100px;" maxlength="2" class="i_notnull" alt="사업자등록번호" format="number">
									<div class="dash">-</div>
									<input type="text" id="BIZRNO3" name="BIZRNO3" style="width: 100px;" maxlength="5" class="i_notnull" alt="사업자등록번호" format="number">
									<button type="button" id="bizrnoChk" class="btn34 c6" style="width: 92px;">중복확인</button>
									<input type="hidden" name="DUPLE_CHECK_YN2" id="DUPLE_CHECK_YN2" value="" />
									<input type="hidden" name="USE_ABLE_YN2" id="USE_ABLE_YN2" value="" />
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">업종<span class="red" class="bizrSeCdH">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="TOB_NM" name="TOB_NM" style="width: 330px;" class="i_notnull" alt="업종" maxByteLength="30">
									<span class="notice">업종은 30자까지 입력 가능합니다.</span>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">업태<span class="red" class="bizrSeCdH">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="BCS_NM" name="BCS_NM" style="width: 330px;" class="i_notnull" alt="업태" maxByteLength="30">
									<span class="notice">업태는 30자까지 입력 가능합니다.</span>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">대표자명<span class="red" class="bizrSeCdH">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="RPST_NM" name="RPST_NM" style="width: 330px;" class="i_notnull" alt="대표자명" maxByteLength="30">
									<span class="notice">대표자명는 30자까지 입력 가능합니다.</span>
								</div>
							</td>
						</tr>
						<tr class="bizrSeCdH">
							<th colspan="2">관리자성명<span class="red" class="bizrSeCdH">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="ADMIN_NM" name="ADMIN_NM" style="width: 330px;" class="i_notnull" alt="관리자성명" maxByteLength="30">
									<span class="notice">관리자성명는 20자까지 입력 가능합니다.</span>
								</div>
							</td>
						</tr>
						<tr class="bizrSeCdH">
							<th colspan="2">관리자아이디<span class="red" class="bizrSeCdH">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="ADMIN_ID" name="ADMIN_ID" style="width: 330px;" class="i_notnull" alt="관리자아이디">
									<button type="button" id="chk" class="btn34 c6" style="width: 92px;">중복확인</button>
									<input type="hidden" name="DUPLE_CHECK_YN" id="DUPLE_CHECK_YN" value="" />
									<input type="hidden" name="USE_ABLE_YN" id="USE_ABLE_YN" value="" />
									<span class="notice">아이디는 영문+숫자를 조합하여 6자이상 16자 이하로 입력하셔야 합니다.</span>
								</div>
							</td>
						</tr>
						<tr class="bizrTpCdM" style="display:none">
							<th colspan="2">빈용기보증금 가상계좌<span class="red" class="bizrSeCdH">*</span></th>
							<td>
								<div class="row">
									<div class="txt" id="BANKCD1">신한은행</div>
									<input type="text" id="MFC_DPS_VACCT_NO" name="MFC_DPS_VACCT_NO" style="width: 179px;" maxlength="20" format="number" alt="빈용기보증금 가상계좌">
								</div>
							</td>
						</tr>
						<tr class="bizrTpCdM" style="display:none">
							<th colspan="2">취급수수료 가상계좌<span class="red" class="bizrSeCdH">*</span></th>
							<td>
								<div class="row">
									<div class="txt" id="BANKCD2">신한은행</div>
									<input type="text" id="MFC_FEE_VACCT_NO" name="MFC_FEE_VACCT_NO" style="width: 179px;" maxlength="20" format="number"  alt="취급수수료 가상계좌">
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">수납 계좌번호<span class="red" class="bizrSeCdH">*</span></th>
							<td>
								<div class="row">
									<select id="AcpBankCdList_SEL" name="AcpBankCdList_SEL" style="width: 100px;">
									</select>
									<input type="text" id="ACP_ACCT_NO" name="ACP_ACCT_NO" format="number" style="width: 179px;" maxlength="20" class="i_notnull" alt="수납계좌번호">
									<span class="notice">계좌번호는 '-'없이 숫자만 입력 가능합니다.</span>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">수납 계좌 예금주명<span class="red" class="bizrSeCdH">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="ACP_ACCT_DPSTR_NM" name="ACP_ACCT_DPSTR_NM" style="width: 179px;" readonly="readonly">
									<button type="button" id="chk2" class="btn34 c6" style="width: 92px;">예금주 확인</button>
									<div class="chkbox" style="padding-top:8px">
										<label class="chk" >
											<input type="checkbox" id="ACCT_CHECK_YN" name="ACCT_CHECK_YN" disabled><span></span>
										</label>
									</div>
								</div>
							</td>
						</tr>
						<tr class="bizrSeCdH">
							<th colspan="2">이메일<span class="red" class="bizrSeCdH">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="EMAIL1" name="EMAIL1" style="width: 100px;" class="i_notnull" alt="이메일" maxlength="30">
									<div class="sign">@</div>
									<input type="text" id="EMAIL2" name="EMAIL2" style="width: 100px;" class="i_notnull" alt="이메일" maxlength="30">
									<select id="DOMAIN" name="DOMAIN" style="width: 130px;">
										<option id="drct_input" value=""></option>
									</select>
									<input type="hidden" id="EMAIL" name="EMAIL" style="width: 100px;">
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">보조 이메일</th>
							<td>
								<div class="row">
									<input type="text" id="ASTN_EMAIL1" name="ASTN_EMAIL1" style="width: 100px;" maxlength="30">
									<div class="sign">@</div>
									<input type="text" id="ASTN_EMAIL2" name="ASTN_EMAIL2" style="width: 100px;" maxlength="30">
									<select id="ASTN_EMAIL_DOMAIN" name="ASTN_EMAIL_DOMAIN" style="width: 130px;">
										<option id="drct_input2" value=""></option>
									</select>
									<input type="hidden" id="ASTN_EMAIL" name="ASTN_EMAIL" style="width: 100px;">
								</div>
							</td>
						</tr>
						<tr>
							<th id="bizrSeCdH" rowspan="5">전화번호</th>
							<th class="bd_l">대표 전화번호</th>
							<td>
								<div class="row">
									<select id="RPST_TEL_NO1" name="RPST_TEL_NO1" style="width:80px">
										<option id="cho1" value=""></option>
									</select>
									<div class="dash">-</div>
									<input type="text" id="RPST_TEL_NO2" name="RPST_TEL_NO2" style="width: 100px;" maxlength="4" format="number">
									<div class="dash">-</div>
									<input type="text" id="RPST_TEL_NO3" name="RPST_TEL_NO3" style="width: 100px;" maxlength="4" format="number">
								</div>
							</td>
						</tr>
						<tr class="bizrSeCdH">
							<th class="bd_l">대표 휴대폰번호<span class="red" class="bizrSeCdH">*</span></th>
							<td>
								<div class="row">
									<select id="RPST_MBIL_NO1" name="RPST_MBIL_NO1" style="width:80px" >
										<option id="cho5" value=""></option>
									</select>
									<div class="dash">-</div>
									<input type="text" id="RPST_MBIL_NO2" name="RPST_MBIL_NO2" style="width: 100px;" maxlength="4" format="number">
									<div class="dash">-</div>
									<input type="text" id="RPST_MBIL_NO3" name="RPST_MBIL_NO3" style="width: 100px;" maxlength="4" format="number">
								</div>
							</td>
						</tr>
						<tr class="bizrSeCdH">
							<th class="bd_l">담당자 전화번호</th>
							<td>
								<div class="row">
									<select id="TEL_NO1" name="TEL_NO1" style="width:80px" >
										<option id="cho3" value=""></option>
									</select>
									<div class="dash">-</div>
									<input type="text" id="TEL_NO2" name="TEL_NO2" style="width: 100px;" maxlength="4" format="number">
									<div class="dash">-</div>
									<input type="text" id="TEL_NO3" name="TEL_NO3" style="width: 100px;" maxlength="4" format="number">
								</div>
							</td>
						</tr>
						<tr class="bizrSeCdH">
							<th class="bd_l">담당자 휴대전화번호<span class="red" class="bizrSeCdH">*</span></th>
							<td>
								<div class="row">
									<select id="MBIL_NO1" name="MBIL_NO1" style="width:80px" class="i_notnull" alt="담당자 휴대전화번호">
										<option id="cho2" value=""></option>
									</select>
									<div class="dash">-</div>
									<input type="text" id="MBIL_NO2" name="MBIL_NO2" style="width: 100px;" class="i_notnull" alt="담당자 휴대전화번호" maxlength="4" format="number">
									<div class="dash">-</div>
									<input type="text" id="MBIL_NO3" name="MBIL_NO3" style="width: 100px;" class="i_notnull" alt="담당자 휴대전화번호" maxlength="4" format="number">
								</div>
							</td>
						</tr>
						<tr>
							<th class="bd_l">FAX 전화번호</th>
							<td>
								<div class="row">
									<select id="FAX_NO1" name="FAX_NO1" style="width:80px">
										<option id="cho4" value=""></option>
									</select>
									<div class="dash">-</div>
									<input type="text" id="FAX_NO2" name="FAX_NO2" style="width: 100px;" maxlength="4" format="number">
									<div class="dash">-</div>
									<input type="text" id="FAX_NO3" name="FAX_NO3" style="width: 100px;" maxlength="4" format="number">
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2" rowspan="2">사업장주소<span class="red" class="bizrSeCdH">*</span></th>
							<td>
								<div class="row">
									<input type="text" class="i_notnull" id="PNO" name="PNO" style="width: 179px;" alt="우편번호" readonly="readonly">
									<button type="button" id="btnPopZip" class="btn34 c6" style="width: 122px;">우편번호 검색</button>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="row">
									<input type="text" id="ADDR1" name="ADDR1" style="width: 330px;" maxByteLength="500" class="i_notnull" alt="사업장주소">
									<input type="text" id="ADDR2" name="ADDR2" style="width: 330px; margin-left: 5px !important;" placeholder="상세주소입력" maxByteLength="500" class="i_notnull" alt="사업장 상세주소">
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">사업자등록증<span class="red" class="bizrSeCdH">*</span></th>
							<td>
								<div class="row">
									<div class="btn_box">
										<input type="file" name="FILE_NM" id="FILE_NM" style="width:305px;height:34px" onchange="fn_fileCheck(this.value, '1');" class="i_notnull" alt="사업자등록증"  />
									</div>
								</div>
							</td>
						</tr>
						<tr class="bizrTpCdM" style="display:none">
							<th colspan="2">생산자계약서</th>
							<td>
								<div class="row">
									<div class="btn_box">
<!-- 										<input type="text" id="fileName2" style="width: 330px;"> -->
<!-- 										<label class="btn34 c6" style="width: 92px;"><input type="file" id="CTRT_FILE_NM" onchange="fn_fileCheck(this.value, '2');">파일첨부</label> -->
										<input type="file"  name="CTRT_FILE_NM" id="CTRT_FILE_NM" style="width:305px;height:34px" onchange="fn_fileCheck(this.value, '2');" />
									
									</div>
								</div>
							</td>
						</tr>
					</table>
					</form>
				</div>
			</div>
		</section>
		<section class="btnwrap mt20" >
		<div class="btnwrap">
			<div class="fl_r" id="BR">
<!-- 						<button type="button" class="btn36 c4" id="btn_cncl"style="width: 100px;">취소</button> -->
<!-- 						<button type="button" class="btn36 c2" id="btn_reg" style="width: 100px;">저장</button> -->
			</div>
		</div>
		</section>
	</div>

</body>
</html>