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
		$('#BIZRID').val(INQ_PARAMS.PARAMS.BIZRID);
		$('#BIZRNM').val(INQ_PARAMS.PARAMS.BIZRNM);
		$('#BIZRNO').val(INQ_PARAMS.PARAMS.BIZRNO);
		$('#BIZRNO1').val(INQ_PARAMS.PARAMS.BIZRNO1_CFM);
		$('#BIZRNO2').val(INQ_PARAMS.PARAMS.BIZRNO2_CFM);
		$('#BIZRNO3').val(INQ_PARAMS.PARAMS.BIZRNO3_CFM);
		
		$('#BIZR_TP_CD').val(INQ_PARAMS.PARAMS.BIZR_TP_CD);

		kora.common.setMailArrCmBx("", $("#DOMAIN"));	//메일도메인
		kora.common.setTelArrCmBx("", $("#TEL_NO1"));		//전화번호 국번
		kora.common.setHpArrCmBx("", $("#MBIL_NO1"));	//핸드폰 국번
		
		var brchList = jsonObject($('#brchList').val());
		kora.common.setEtcCmBx2(brchList, "", "", $("#BRCH"), "ETC_CD", "ETC_CD_NM", "N", "");
		$("#BRCH").prepend("<option value=''>선택</option>");
		$("#BRCH").val('');
		
		var bizrTpCd = INQ_PARAMS.PARAMS.BIZR_TP_CD;
		if(bizrTpCd == 'T1'){
			$('#brchTitle').html('센터지부<span class="red">*</span>');
			$('#BRCH').attr('alt', '센터지부');
		}else if(bizrTpCd== 'M1' || bizrTpCd== 'M2'){
			$('#brchTitle').html('직매장/공장<span class="red">*</span>');
			$('#BRCH').attr('alt', '직매장/공장');
		}else{
			$('#brchTitle').html('지점<span class="red">*</span>');
			$('#BRCH').attr('alt', '지점');
		}
		
		//반드시 실행..
		pub_ready();

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
		 * 아이디변경시 중복확인 초기화
		 */
		$("#ADMIN_ID").bind("change", function(){
			$("#USE_ABLE_YN").val("");
		});
		
	});
	
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
		if(!kora.common.cfrmDivChkValid("frm")) return false;
		
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
		
		if(!$(":checkbox[name='adminPhoneCert']").prop("checked")){
			alertMsg("담당자 휴대폰인증을 하지 않았습니다.");
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
			alertMsg("비밀번호는 숫자+영문자를 조합하여 최소 10자(특수문자 포함 8자)리 ~ 최대 16자리 까지만 입력이 가능합니다.");
			return;
		}else if(pass != passConf){
			alertMsg("비밀번호 및 확인 비밀번호가 일치하지 않습니다.");
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
		
		confirm('저장하시겠습니까?', 'fn_reg_exec');
	}
	
	function fn_reg_exec(){
		
		var sData = '';
		sData = kora.common.gfn_formData('frm');
		
	 	var url = "/EP/EPCE00852015_09.do";
	 	ajaxPost(url, sData, function(rtnData){
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
		
		if(!$(":checkbox[name='adminPhoneCert']").prop("checked")){
			alertMsg("담당자 휴대폰인증 후 진행해 주십시오.");
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
	}

	//휴대폰 인증결과 tf-성공여부, div-넘겨준 CERT_DIV, 이름, 전화번호
	function fn_kmcisResult(tf, div, name, phoneNum){
		var objNm = "adminPhoneCert";
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
		
		//if($(":checkbox[name='certEqualChk']").prop("checked")) fn_certEqualChk();
	}
		
</script>

</head>
<body >

	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
	<input type="hidden" id="brchList" value="<c:out value='${brchList}' />"/>

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
						<h3 class="tit">업무담당자 정보 등록</h3>
					</div>
					<div class="white_wrap pt25">
						<div class="write_tbl mm25 bdt1">
						
							<form name="frm" id="frm" method="post" onsubmit="return false">
							
							<input type="hidden" id="BIZRID" name="BIZRID" />
							<input type="hidden" id="CNTR_DT" name="CNTR_DT" />
							<input type="hidden" id="BIZR_TP_CD" name="BIZR_TP_CD" />
		
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
										<th colspan="2" id="brchTitle"><span class="red">*</span></th>
										<td>
											<div class="row">
												<select id="BRCH" name="BRCH" style="width:150px" class="i_notnull" ></select>
											</div>
										</td>
									</tr>
									<tr>
										<th colspan="2">성명<span class="red">*</span></th>
										<td>
											<div class="row">
												<input type="text" style="width: 330px;" id="ADMIN_NM" name="ADMIN_NM" maxByteLength="60" readonly="readonly" class="i_notnull" alt="성명" >
												<button  class="btn34 c6" style="width: 151px;" onclick="fn_phoneCert('ADMIN')">담당자 휴대폰 인증</button>
												<label class="chk ml10 disabled"><input type="checkbox" name="adminPhoneCert" disabled></label>
											</div>
										</td>
									</tr>
									<tr>
										<th colspan="2">아이디<span class="red">*</span></th>
										<td>
											<div class="row">
												<input type="text" style="width: 330px;" id="ADMIN_ID" name="ADMIN_ID" maxlength="20" class="i_notnull" alt="아이디" >
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
										<th rowspan="2">전화번호</th>
										<th class="bd_l">전화번호</th>
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
										<th class="bd_l">휴대전화번호<span class="red">*</span></th>
										<td>
											<div class="row">
												<input type="text" id="MBIL_NO1" name="MBIL_NO1" style="width: 90px;"  maxlength="4"  format="number" readonly="readonly">
												<div class="dash">-</div>
												<input type="text" id="MBIL_NO2" name="MBIL_NO2" style="width: 100px;"  maxlength="4" format="number" readonly="readonly">
												<div class="dash">-</div>
												<input type="text" id="MBIL_NO3" name="MBIL_NO3" style="width: 100px;"  maxlength="4" format="number" readonly="readonly">
											</div>
										</td>
									</tr>
								</tbody>
							</table>
							
							</form>
							
							<div class="join_ess_txt">
								<p><strong class="ess">*</strong>표시된 항목은 <span class="c_01">필수 입력 항목</span>입니다. </p>
								업무 담당자는 사업자 회원(사업자 관리자)의 가입 승인 이후 시스템 사용이 가능합니다
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
