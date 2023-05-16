<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="_csrf" content="<c:out value='${_csrf.token}' />" />
<meta name="_csrf_header" content="<c:out value='${_csrf.headerName}' />" />

<link rel="stylesheet" href="/common/css/common.css"/>

<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>
<script src="/js/jquery/jquery-ui.js"></script>
<script src="/js/jquery/jquery.ui.datepicker-ko.js"></script>

<script src="/common/js/jquery-1.11.1.min.js"></script>
<script src="/common/js/mobile-detect.min.js"></script>
<script src="/common/js/slick.js"></script>
<script src="/common/js/pub.plugin.js"></script>
<script src="/common/js/pub.common.js"></script>

<script src="/js/kora/kora_common.js"></script>

<script language="javascript" defer="defer">

	var INQ_PARAMS;

	$(document).ready(function(){
			
		INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());

		$('#CNTR_DT').val('<c:out value='${CNTR_DT}' />');
		$('#BIZRID').val(INQ_PARAMS['PARAMS'].BIZRID);
		$('#BIZRNM').val(INQ_PARAMS['PARAMS'].BIZRNM);
		$('#BIZRNO').val(INQ_PARAMS['PARAMS'].BIZRNO);
		$('#BIZRNO1').val(INQ_PARAMS['PARAMS'].BIZRNO1_CFM);
		$('#BIZRNO2').val(INQ_PARAMS['PARAMS'].BIZRNO2_CFM);
		$('#BIZRNO3').val(INQ_PARAMS['PARAMS'].BIZRNO3_CFM);
		
		var bankCdList = jsonObject($('#bankCdList').val());
		var areaList = jsonObject($('#areaList').val());
		kora.common.setEtcCmBx2(bankCdList, "", "", $("#ACP_BANK_CD"), "ETC_CD", "ETC_CD_NM", "N", "");
		kora.common.setEtcCmBx2(areaList, "", "", $("#AREA_CD"), "ETC_CD", "ETC_CD_NM", "N", "");
		$("#ACP_BANK_CD").prepend("<option value=''>은행선택</option>");
		$("#ACP_BANK_CD").val('');
		kora.common.setMailArrCmBx("", $("#DOMAIN"));	//메일도메인
		kora.common.setMailArrCmBx("", $("#ASTN_EMAIL_DOMAIN"));	//보조메일도메인
		kora.common.setTelArrCmBx("", $("#TEL_NO1"));		//전화번호 국번
		kora.common.setTelArrCmBx("", $("#RPST_TEL_NO1"));		//전화번호 국번
		kora.common.setTelArrCmBx("", $("#FAX_NO1"));		//전화번호 국번
		kora.common.setHpArrCmBx("", $("#MBIL_NO1"));	//핸드폰 국번
		
		//반드시 실행..
		pub_ready();
		
		//관리자와 동일 체크
		$("#certEqualChk").bind("click", function(){
			fn_certEqualChk();
		});
		
		/**
		 * 이메일 도메인 변경 이벤트
		 */
		$("#DOMAIN").change(function(){

			$("#EMAIL2").val(kora.common.null2void($(this).val()));
			
			if(kora.common.null2void($(this).val()) != ""){
				$("#EMAIL2").attr("disabled",true);
			}else{
				$("#EMAIL2").attr("disabled",false);
			}
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
		$("#ACP_BANK_CD, #ACP_ACCT_NO").bind("change", function(){
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
		 * 우편번호검색 버튼 클릭 이벤트
		 */
		 var parent_item;
		 $("#btnPopZip").click(function(){
			NrvPub.AjaxPopup('/EP/SEARCH_ZIPCODE_POP.do');
		 });
		
		 //사업자유형 변경 이벤트
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
		      
		      //window.frameElement.style.height = $('.iframe_inner').height()+5+'px';
		 }); 
	});
	
	function zipCdSet(pno, addr1){
		$('#PNO').val(pno);
		$('#ADDR1').val(addr1);
	}
	
	function fn_cnl(){
		confirm('메인페이지로 이동하시겠습니까?', 'fn_page');
	}
	
	function fn_page(){
		location.href = '/login.do';
	}
	
	function fn_page2(){
		location.href = '/EP/EPCE00852016.do';
	}
	
	//저장
	function fn_reg(){

		//필수값 체크
		if(!kora.common.cfrmDivChkValid("fileForm")) return false;
		
		var bizrnm = $("#BIZRNM").val();
		var bizrno = $("#BIZRNO1").val() + "" + $("#BIZRNO2").val() + "" + $("#BIZRNO3").val();
		if($.trim(bizrnm) == "" || $.trim(bizrno).length != 10){
			alertMsg("확인된 사업자 정보가 존재하지 않습니다. \n사업자 확인 단계부터 다시 진행하시기 바랍니다.");
			return;
		}
		
		//사업자번호 체크
 		if(!kora.common.gfn_bizNoCheck(bizrno)){
 			alertMsg("유효하지 않은 사업자번호 입니다.");
 			return false;
		}
		
 		if(!$(":checkbox[name='rpstPhoneCert']").prop("checked")){
			alertMsg("대표자 휴대폰인증을 하지 않았습니다.");
			return;
		}
		
		if(!$(":checkbox[name='adminPhoneCert']").prop("checked")){
			alertMsg("관리자 휴대폰인증을 하지 않았습니다.");
			return;
		}
		
		if($("#USE_ABLE_YN").val() == ""){
			alertMsg("휴대번호 및 아이디 중복체크를 하지 않았습니다.");
			return;
		}
		
		if($("#USE_ABLE_YN").val() != "Y"){
			alertMsg("사용할 수 없는 아이디 입니다.\n휴대번호 및 아이디 중복체크 후 사용 하시기 바랍니다.");
			return;
		}
		
		if($("#USE_ABLE_YN2").val() != "Y"){
			alertMsg("사용할 수 없는 휴대번호 입니다.\n휴대번호 및 아이디 중복체크 후 사용 하시기 바랍니다.");
			return;
		}

		
		var pass = $("#PWD").val();
		var passConf = $("#PWD_CFM").val();
		if($.trim(pass).length < 8 || $.trim(pass).length > 16 || !kora.common.gfn_pwValidChk(pass)){
			alertMsg("패스워드는 숫자+영문자를 조합하여 최소 10자(특수문자 포함 8자)리 ~ 최대 16자리 까지만 입력이 가능합니다.");
			return;
		}else if(pass != passConf){
			alertMsg("패스워드 및 확인 패스워드가 일치하지 않습니다.");
			return;
		}
		
		if(!kora.common.gfn_idPwChkValid(pass)) return;
		
		
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
		
		if($("#FILE_NM").val() == null || $("#FILE_NM").val() == "" || $("#FILE_NM").val() == " "){
			alertMsg("사업자 등록증 첨부는 필수입니다.");
			return;
		}
		
		confirm('저장하시겠습니까?', 'fn_reg_exec');
	}
	
	function fn_reg_exec(){
		var sData = '';
	 	var url = "/EP/EPCE00852013_09.do";
	 	fileajaxPost(url, sData, function(rtnData){
	 		if ("" != rtnData && null != rtnData) {
				if(rtnData.RSLT_CD == '0000'){
					alertMsg(rtnData.RSLT_MSG, 'fn_page2');
				}else{
					alertMsg(rtnData.RSLT_MSG);
				}
			} else {
				alertMsg("error");
			}
	 	});
	}
	
	/**
	 * id중복 체크
	 */
	function fn_dupleCheck(){
// 		alert('11');
// 		var token = $("meta[name='_csrf']").attr("content");
// 		var header = $("meta[name='_csrf_header']").attr("content");
// 		alert(token);
		if(!$(":checkbox[name='adminPhoneCert']").prop("checked")){
			alertMsg("관리자 휴대폰인증 후 진행해 주십시오.");
			return;
		}
		
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
		
		var sData = {"USER_ID" : ADMIN_ID, "MBIL_NO1" : $("#MBIL_NO1").val(), "MBIL_NO2" : $("#MBIL_NO2").val(), "MBIL_NO3" : $("#MBIL_NO3").val()};
		var url = "/EP/EPCE00852015_19.do";
		ajaxPost(url, sData, function(data){
// 			alert('22');
			$("#USE_ABLE_YN").val(data.USE_ABLE_YN);
			$("#USE_ABLE_YN2").val(data.USE_ABLE_YN2);
			if(data.USE_ABLE_YN == "Y" && data.USE_ABLE_YN2 == "Y"){
				alertMsg("사용 가능한 아이디 및 휴대번호 입니다.");
			}else if(data.USE_ABLE_YN != "Y"){
				alertMsg("이미 사용중인 아이디 입니다. \n다른 아이디를 사용하시기 바랍니다.");
				return;
			}else if(data.USE_ABLE_YN2 != "Y"){
				alertMsg("이미 사용중인 휴대번호 입니다. \n사용자 회원탈퇴 후 사용하시기 바랍니다.\n단, 2개 이상의 사업자를 관리하시는 경우, \n콜센터로 연락바랍니다.(1522-0082)");
				return;
			}
		});
	}
	
	//휴대폰 인증구분 임의정의 - 대표자인증 : REPSNT, 관리자 인증 : ADMIN, 패스워드변경 : CNPC  추가정보에서 사용
	function fn_phoneCert(div){
		$("#CERT_DIV").val(div);
		window.open("/EP/EPCE00852883.do"+ "?_csrf=<c:out value='${_csrf.token}' />", "PCERT", "width=450, height=600, left=100, top=30, menubar=no,status=no,toolbar=no, resizable=1");
// 		window.open("/EP/EPCE008528883.do"+ "?_csrf=<c:out value='${_csrf.token}' />&plusInfo="+div+"", "PCERT", "width=450, height=600, left=100, top=30, menubar=no,status=no,toolbar=no, resizable=1");
// 		window.open("/EP/EPCE00852883.do"+ "?plusInfo="+div+"", "PCERT", "width=450, height=600, left=100, top=30, menubar=no,status=no,toolbar=no, resizable=1");
// 		window.open("/EP/EPCE00852883.do"+ "?_csrf=<c:out value='${_csrf.token}' />&plusInfo="+div+"", "PCERT", "width=450, height=600, left=100, top=30, menubar=no,status=no,toolbar=no, resizable=1");
// 		window.open("/API/EPCE00852883.do"+ "?_csrf=<c:out value='${_csrf.token}' />&plusInfo="+div+"", "PCERT", "width=450, height=600, left=100, top=30, menubar=no,status=no,toolbar=no, resizable=1");
	}

	//휴대폰 인증결과 tf-성공여부, div-넘겨준 CERT_DIV, 이름, 전화번호
	function fn_kmcisResult(tf, div, name, phoneNum){
		var objNm = "adminPhoneCert";
// 		alert("3 : "+_csrf);
		
// 		if(_csrf != null && _csrf != ""){
// 			alert(_csrf);
// 			$("meta[name='_csrf']").attr("content", _csrf);
// 		}
		
// 		$("meta[name='_csrf']").attr("content", _csrf);
		if(div == "REPSNT") objNm = "rpstPhoneCert";
		
		$(":checkbox[name='" + objNm + "']").prop("checked", tf);
		if(!tf) return;
		
		var num = 6;
		if(phoneNum.length == 11) num = 7;
		if(div == "REPSNT"){
			$("#RPST_NM").val(name);
			$("#TMP_PHON1").val(phoneNum.substring(0,3));
			$("#TMP_PHON2").val(phoneNum.substring(3,num));
			$("#TMP_PHON3").val(phoneNum.substring(num,phoneNum.length));
		}else{
			$("#ADMIN_NM").val(name);
			$("#MBIL_NO1").val(phoneNum.substring(0,3));
			$("#MBIL_NO2").val(phoneNum.substring(3,num));
			$("#MBIL_NO3").val(phoneNum.substring(num,phoneNum.length));
		}
		
		if($(":checkbox[name='certEqualChk']").prop("checked")) fn_certEqualChk();
	}
	
	/**
	 * 계좌인증 - 예금주확인
	 */
	function fn_acctCheck(){
		var bankCd  = $("#ACP_BANK_CD option:selected").val();
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
		
		var sData = {"BANK_CD":bankCd, "SEARCH_ACCT_NO":acctNo};
		var url = "/EP/EPCE00852013_192.do";		//예금주명체크
		ajaxPost(url, sData, function(data){
			if(data.RSLT_CD != "0000"){
				alertMsg(data.RSLT_MSG);
				return;
			}else{
				$(data.RESP_DATA).each(function(key,obj){
					var str = obj.ACCT_NM;		//gfn_Convert2ByteChar(obj.ACCT_NM);	//전각을 반각처리
					$(":checkbox[name='ACCT_CHECK_YN']").prop("checked", true);
					$("#ACP_ACCT_DPSTR_NM").val(str);
				});
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
	
	function fn_certEqualChk(){
		if($(":checkbox[name='certEqualChk']").prop("checked")){
			if($(":checkbox[name='adminPhoneCert']").prop("checked")){
				$("#RPST_NM").val($("#ADMIN_NM").val());
				$(":checkbox[name='rpstPhoneCert']").prop("checked", true);
			}else if($(":checkbox[name='rpstPhoneCert']").prop("checked")){
				$("#ADMIN_NM").val($("#RPST_NM").val());
				$("#MBIL_NO1").val($("#TMP_PHON1").val());
				$("#MBIL_NO2").val($("#TMP_PHON2").val());
				$("#MBIL_NO3").val($("#TMP_PHON3").val());
				$(":checkbox[name='adminPhoneCert']").prop("checked", true);
			}
		}else{
			if($("#TMP_PHON1").val() != null && $("#TMP_PHON1").val() != ""){//대표자인증
				$(":checkbox[name='adminPhoneCert']").prop("checked", false);
				$("#ADMIN_NM").val("");
				$("#MBIL_NO1").val("");
				$("#MBIL_NO2").val("");
				$("#MBIL_NO3").val("");
			}else{
				$("#RPST_NM").val("");
				$(":checkbox[name='rpstPhoneCert']").prop("checked", false);
			}
		}
	}
	
</script>

</head>
<body >

	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
	<input type="hidden" id="bankCdList" value="<c:out value='${bankCdList}' />"/>
	<input type="hidden" id="areaList" value="<c:out value='${areaList}' />"/>

	<div id="wrap" style="padding:0 0 182px 40px">

		<div id="container" class="asideOpen">

			<div id="contents">
				<div class="conbody2">
					<div class="join_step">
						<ol>
							<li class="s1">약관동의</li>
							<li class="s2">사업자확인</li>
							<li class="s3 on">정보입력</li>
							<li class="s4">가입신청완료</li>
						</ol>
					</div>
					<div class="h3group">
						<h3 class="tit">사업자 정보 등록</h3>
					</div>
					<div class="white_wrap pt25">
						<div class="write_tbl mm25 bdt1">
						
							<form name="fileForm" id="fileForm" method="post" enctype="multipart/form-data" onsubmit="return false">
							
							<input type="hidden" id="BIZRID" name="BIZRID" />
							<input type="hidden" id="CNTR_DT" name="CNTR_DT" />
	
							<!-- 인증구분 임의정의 - 대표자인증 : REPSNT, 관리자 인증 : ADMIN, 패스워드변경 : CNPC  추가정보에서 사용  -->
							<input type="hidden" name="CERT_DIV" id="CERT_DIV" value="" />
							
							<table>
								<colgroup>
									<col style="width: 8%;">
									<col style="width: 15%;">
									<col style="width: auto;">
								</colgroup>
								<tbody>
									<tr>
										<th colspan="2">사업자유형<span class="red">*</span></th>
										<td>
											<div class="row" id="BIZR_TP_CD">
												<label class="rdo"><input type="radio" id="BIZR_TP_CD1" name="BIZR_TP_CD" value="W1" checked="checked"><span>도매업자</span></label>
												<label class="rdo"><input type="radio" id="BIZR_TP_CD2" name="BIZR_TP_CD" value="W2"><span>공병상</span></label>
												<!-- <label class="rdo"><input type="radio" id="BIZR_TP_CD3" name="BIZR_TP_CD" value="R1"><span>소매업자</span></label> -->
												<label class="rdo"><input type="radio" id="BIZR_TP_CD5" name="BIZR_TP_CD" value="M1"><span>주류생산자</span></label>
												<label class="rdo"><input type="radio" id="BIZR_TP_CD6" name="BIZR_TP_CD" value="M2"><span>음료생산자</span></label>
											</div>
										</td>
									</tr>
									<tr>
										<th colspan="2">사업자명<span class="red">*</span></th>
										<td>
											<div class="row">
												<input type="text" style="width: 330px;" id="BIZRNM" name="BIZRNM" readonly="readonly">
												<span class="notice2"></span>
											</div>
										</td>
									</tr>
									<tr>
										<th colspan="2">사업자등록번호<span class="red">*</span></th>
										<td>
											<div class="row">
												<input type="text" style="width: 100px;" id="BIZRNO1" name="BIZRNO1" readonly="readonly">
												<div class="dash">-</div>
												<input type="text" style="width: 100px;" id="BIZRNO2" name="BIZRNO2" readonly="readonly">
												<div class="dash">-</div>
												<input type="text" style="width: 100px;" id="BIZRNO3" name="BIZRNO3" readonly="readonly">
												<span class="notice"></span>
												<input type="hidden" style="width: 100px;" id="BIZRNO" name="BIZRNO">
											</div>
										</td>
									</tr>
									<tr>
										<th colspan="2">업태<span class="red">*</span></th>
										<td>
											<div class="row">
												<input type="text" style="width: 330px;" id="BCS_NM" name="BCS_NM" maxByteLength="90" class="i_notnull" alt="업태">
												<span class="notice">업태는 30자까지 입력 가능합니다.</span>
											</div>
										</td>
									</tr>
									<tr>
										<th colspan="2">업종<span class="red">*</span></th>
										<td>
											<div class="row">
												<input type="text" style="width: 330px;" id="TOB_NM" name="TOB_NM" maxByteLength="90" class="i_notnull" alt="업종">
												<span class="notice">업종은 30자까지 입력 가능합니다.</span>
											</div>
										</td>
									</tr>
									<tr>
										<th colspan="2">지역<span class="red">*</span></th>
										<td>
											<div class="row">
												<select style="width: 220px;" id="AREA_CD" name="AREA_CD" class="i_notnull" alt="지역"/>
											</div>
										</td>
									</tr>
									<tr>
										<th colspan="2">대표자명<span class="red">*</span></th>
										<td>
											<div class="row">
												<input type="text" style="width: 330px;" id="RPST_NM" name="RPST_NM" maxByteLength="90" readonly="readonly" class="i_notnull" alt="대표자명" >
												<button  class="btn34 c6" style="width: 151px;" onclick="fn_phoneCert('REPSNT')">대표자 휴대폰 인증</button>
												<div class="chkbox">
													<label class="chk" style="margin-top:7px">
														<input type="checkbox" name="rpstPhoneCert" disabled><span></span>
													</label>
												</div>
												<input type="hidden" id="TMP_PHON1" name="TMP_PHON1" />
												<input type="hidden" id="TMP_PHON2" name="TMP_PHON2" />
												<input type="hidden" id="TMP_PHON3" name="TMP_PHON3" />
												<label class="chk right"><input type="checkbox" id="certEqualChk" name="certEqualChk"><span>관리자와 동일</span></label>
											</div>
										</td>
									</tr>
									<tr>
										<th colspan="2">관리자성명<span class="red">*</span></th>
										<td>
											<div class="row">
												<input type="text" style="width: 330px;" id="ADMIN_NM" name="ADMIN_NM" maxByteLength="60" readonly="readonly" class="i_notnull" alt="관리자성명" >
												<button  class="btn34 c6" style="width: 151px;" onclick="fn_phoneCert('ADMIN')">관리자 휴대폰 인증</button>
												<label class="chk ml10 disabled"><input type="checkbox" name="adminPhoneCert" disabled></label>
											</div>
										</td>
									</tr>
									<tr>
										<th colspan="2">관리자아이디<span class="red">*</span></th>
										<td>
											<div class="row">
												<input type="text" style="width: 330px;" id="ADMIN_ID" name="ADMIN_ID" maxlength="20" class="i_notnull" alt="관리자아이디" >
												<button type="button" class="btn34 c6" style="width: 171px;" onclick="fn_dupleCheck()">휴대번호 및 ID중복확인</button>
												<span class="notice">아이디는 영문+숫자를 조합하여 6자이상 16자 이하로 입력하셔야 합니다.</span>
												<input type="hidden" id="USE_ABLE_YN" />
												<input type="hidden" id="USE_ABLE_YN2" />
											</div>
										</td>
									</tr>
									<tr>
										<th colspan="2">비밀번호<span class="red">*</span></th>
										<td>
											<div class="row">
												<input type="password" style="width: 330px;" id="PWD" name="PWD" maxlength="16" class="i_notnull" alt="비밀번호" >
												<span class="notice">비밀번호는 영문+숫자를 조합하여 10자(특수문자포함 8자, % 제외) 이상 16자 이하로 입력하셔야 합니다.</span>
											</div>
										</td>
									</tr>
									<tr>
										<th colspan="2">비밀번호 확인<span class="red">*</span></th>
										<td>
											<div class="row">
												<input type="password" style="width: 330px;" id="PWD_CFM" name="PWD_CFM" maxlength="16" class="i_notnull" alt="비밀번호 확인" >
												<span class="notice">비밀번호를 다시 한 번 입력합니다.</span>
											</div>
										</td>
									</tr>
									<tr>
										<th colspan="2">수납 계좌번호<span class="red">*</span></th>
										<td>
											<div class="row">
												<select id="ACP_BANK_CD" name="ACP_BANK_CD" style="width: 130px;" class="i_notnull" alt="수납 계좌번호" >
												</select>
												<input type="text" class="ml5" style="width: 179px;" id="ACP_ACCT_NO" name="ACP_ACCT_NO" maxlength="20" format="number" class="i_notnull" alt="수납 계좌번호">
												<span class="notice">계좌번호는 '-'없이 숫자만 입력 가능합니다.</span>
											</div>
										</td>
									</tr>
									<tr>
										<th colspan="2">수납 계좌 예금주명<span class="red">*</span></th>
										<td>
											<div class="row">
												<input type="text" style="width: 284px;" id="ACP_ACCT_DPSTR_NM" name="ACP_ACCT_DPSTR_NM" maxByteLength="60" readonly="readonly"  class="i_notnull" alt="수납 계좌 예금주명">
												<button  class="btn34 c6" style="width: 122px;" onclick="fn_acctCheck()">예금주 확인</button>
												<label class="chk disabled"><input type="checkbox" id="ACCT_CHECK_YN" name="ACCT_CHECK_YN" disabled><span>수수료 지급 시 필요한 정보입니다.</span></label>
											</div>
										</td>
									</tr>
									<tr>
										<th colspan="2">이메일<span class="red">*</span></th>
										<td>
											<div class="row">
												<input type="text" id="EMAIL1" name="EMAIL1" style="width: 100px;" class="i_notnull" alt="이메일" maxlength="30">
												<div class="sign">@</div>
												<input type="text" id="EMAIL2" name="EMAIL2" style="width: 100px;" class="i_notnull" alt="이메일" maxlength="30">
												<select id="DOMAIN" name="DOMAIN" style="width: 130px;">
													<option value="">직접입력</option>
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
													<option value="">직접입력</option>
												</select>
												<input type="hidden" id="ASTN_EMAIL" name="ASTN_EMAIL" style="width: 100px;">
											</div>
										</td>
									</tr>
									<tr>
										<th rowspan="4">전화번호</th>
										<th class="bd_l">대표 전화번호<span class="red">*</span></th>
										<td>
											<div class="row">
												<select id="RPST_TEL_NO1" name="RPST_TEL_NO1" style="width:90px" class="i_notnull" alt="대표 전화번호">
													<option value="">선택</option>
												</select>
												<div class="dash">-</div>
												<input type="text" id="RPST_TEL_NO2" name="RPST_TEL_NO2" style="width: 100px;" maxlength="4" class="i_notnull" alt="대표 전화번호" format="number">
												<div class="dash">-</div>
												<input type="text" id="RPST_TEL_NO3" name="RPST_TEL_NO3" style="width: 100px;" maxlength="4" class="i_notnull" alt="대표 전화번호" format="number">
											</div>
										</td>
									</tr>
									<tr>
										<th class="bd_l">담당자 전화번호</th>
										<td>
											<div class="row">
												<select id="TEL_NO1" name="TEL_NO1" style="width:90px" >
													<option value="">선택</option>
												</select>
												<div class="dash">-</div>
												<input type="text" id="TEL_NO2" name="TEL_NO2" style="width: 100px;" maxlength="4" format="number">
												<div class="dash">-</div>
												<input type="text" id="TEL_NO3" name="TEL_NO3" style="width: 100px;" maxlength="4" format="number">
											</div>
										</td>
									</tr>
									<tr>
										<th class="bd_l">담당자 휴대전화번호<span class="red">*</span></th>
										<td>
											<div class="row">
												<input type="text" id="MBIL_NO1" name="MBIL_NO1" style="width: 90px;"  maxlength="4" readonly="readonly" format="number">
												<div class="dash">-</div>
												<input type="text" id="MBIL_NO2" name="MBIL_NO2" style="width: 100px;"  maxlength="4" readonly="readonly" format="number">
												<div class="dash">-</div>
												<input type="text" id="MBIL_NO3" name="MBIL_NO3" style="width: 100px;"  maxlength="4" readonly="readonly" format="number">
											</div>
										</td>
									</tr>
									<tr>
										<th class="bd_l">FAX 전화번호</th>
										<td>
											<div class="row">
												<select id="FAX_NO1" name="FAX_NO1" style="width:90px">
													<option value="">선택</option>
												</select>
												<div class="dash">-</div>
												<input type="text" id="FAX_NO2" name="FAX_NO2" style="width: 100px;" maxlength="4" format="number">
												<div class="dash">-</div>
												<input type="text" id="FAX_NO3" name="FAX_NO3" style="width: 100px;" maxlength="4" format="number">
											</div>
										</td>
									</tr>
									<tr>
										<th colspan="2" rowspan="2">사업장주소<span class="red">*</span></th>
										<td class="pt5 pb5">
											<div class="row">
												<input type="text" id="PNO" name="PNO" style="width: 179px;" readonly="readonly" class="i_notnull" alt="우편번호">
												<button type="button" id="btnPopZip" class="btn34 c6" style="width: 122px;">우편번호 검색</button>
											</div>
										</td>
									</tr>
									<tr>
										<td class="pt5 pb5">
											<div class="row">
												<input type="text" id="ADDR1" name="ADDR1" style="width: 330px;" maxByteLength="500" class="i_notnull" alt="사업장주소">
												<input type="text" id="ADDR2" name="ADDR2" style="width: 330px; margin-left: 5px !important;" placeholder="상세주소입력" maxByteLength="500" class="i_notnull" alt="사업장 상세주소">
											</div>
										</td>
									</tr>
									<tr>
										<th colspan="2">사업자등록증<span class="red">*</span></th>
										<td>
											<div class="row">
												<div class="btn_box">
													<input type="file" name="FILE_NM" id="FILE_NM" style="width:305px;height:34px" onchange="fn_fileCheck(this.value, '1');" class="i_notnull" alt="사업자등록증"  />
												</div>
												<span class="notice">이미지는 최대 30MB크기 까지만 가능합니다.</span>
											</div>
										</td>
									</tr>
									
									<tr class="bizrTpCdM" style="display:none">
										<th colspan="2">생산자계약서</th>
										<td>
											<div class="row">
												<div class="btn_box">
													<input type="file"  name="CTRT_FILE_NM" id="CTRT_FILE_NM" style="width:305px;height:34px" onchange="fn_fileCheck(this.value, '2');" />
												</div>
											</div>
										</td>
									</tr>
									
								</tbody>
							</table>
							
							</form>
							
							<div class="join_ess_txt">
								<p><strong class="ess">*</strong>표시된 항목은 <span class="c_01">필수 입력 항목</span>입니다. </p>
							</div>
								
						</div>
						
						<div class="btnwrap mt20">
							<div class="fl_r">
								<button type="button" class="btn36 c4" style="width: 100px;" onclick="fn_cnl()">취소</button>
								<button type="button" class="btn36 c12" style="width: 100px;" onclick="fn_reg()">등록</button>
							</div>
						</div>
						
					</div>
					
					
					
				</div>
			</div>
		</div><!-- end : id : container -->

		<%@include file="/jsp/include/footer.jsp" %>
		
	</div>

	<!-- 전자서명을 위한폼 -->
	<form name="frmCert"  onsubmit="return false" method="post">
		<input type="hidden" name="ssn" id="ssn" />	<!-- 사업자번호 신원확인용 -->
		<input type="hidden" name="plainText" id="plainText" /> <!-- 전자서명값 원문 : 사업자번호 + | + 현재일자(yyyymmdd) -->
		<input type="hidden" name="signedText" id='signedText' /> <!-- 전자서명값 : 암호화된 값 -->
		<input type="hidden" name="certAttrstxt" id="certAttrstxt" value="" />	<!-- 추출한 인증서 정보 -->
	</form>
	<!-- //전자서명을 위한폼 -->

	<!-- 인증서용 -->
	<iframe name="ifrCerti" frameborder="0" width="0" height="0" />

</body>
</html>
