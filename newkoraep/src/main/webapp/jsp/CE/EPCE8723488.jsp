<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="/common/css/common.css"/>
<link rel="stylesheet" href="/common/css/slick.css">

</head>

<style type="text/css">

	.srcharea .row .col .tit{
	width: 117px;
	}

</style>

<script>

//취소
function fn_cncl(){
	$('[layer="close"]').trigger('click');
}

/**
 * 패스워드 체크 특수문자 포함 8~16자리 또는 특수문자 미포함 10~16자리
 * @param str
 * @returns {Boolean}
 */

gfn_pwValidChk = function(str) {
	var reg_id = /^.*(?=.{10,16})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;
    var reg_id2 = /^.*(?=.{8,16}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[~!@\#$%<>^&*\()\-=+_\']).*$/;
	
	if(reg_id.test(str) || reg_id2.test(str)){
		return true;
	}else{
		return false;
	}
	
}

 
//변경요청
function fn_confirm(){
	
	var USER_NM = $("#USER_NM_POP").val();
	if(USER_NM == null || $.trim(USER_NM) == ""){
		alertMsg("성명을 입력하세요.", "kora.common.focus_target('USER_NM_POP')");
		return;
	}
	
	var USER_ID = $("#USER_ID_POP").val();
	if(USER_ID == null || USER_ID == ""){
		alertMsg("아이디를 입력하세요", "kora.common.focus_target('USER_ID_POP')");
		return;
	}
	
	//var pass = $("#USER_PWD").val();
	var altPass = $("#ALT_REQ_PWD").val();
	var passConf = $("#ALT_REQ_PWD_CONFIRM").val();
	/*
	if($.trim(pass).length < 8 || $.trim(pass).length > 16){
		alertMsg("현재 비밀번호를 정확히 입력하세요.(8자리~16자리)");
		$("#USER_PWD").focus();
		return;
	}else
	*/ 
	if($.trim(altPass).length < 8 || $.trim(altPass).length > 16 || !gfn_pwValidChk(altPass)){
		alertMsg("비밀번호는 영문+숫자를 조합하여 10자(특수문자포함 8자, % 제외) 이상  16자 이하로 입력하셔야 합니다.", "kora.common.focus_target('ALT_REQ_PWD')");
		return;
	}else if(altPass != passConf){
		alertMsg("변경 비밀번호 및 확인 변경 비밀번호가 일치하지 않습니다.", "kora.common.focus_target('ALT_REQ_PWD')");
		return;
	}
	
	//var sData = {"USER_ID":USER_ID, "USER_NM":USER_NM, "USER_PWD":pass, "ALT_REQ_PWD":altPass};
	var sData = {"USER_ID":USER_ID, "USER_NM":USER_NM, "ALT_REQ_PWD":altPass};
	
	var url = "/EP/EPCE8723488_21.do";
	ajaxPost(url, sData, function(data){
		if(data.cd == "0000"){
			alertMsg(data.msg, 'fn_cncl');
		}else if(data.cd == "9999" && (data.USER_SE_CD == "D" || data.USER_SE_CD == "S")){// 휴대폰 본인인증 화면으로 이동
			$("#MBIL_PHON1").val(data.MBIL_PHON1);
			$("#MBIL_PHON2").val(data.MBIL_PHON2);
			$("#MBIL_PHON3").val(data.MBIL_PHON3);
			alertMsg(data.msg, 'fn_phoneCert');
		}else{
			alertMsg(data.msg);
		}
	});
}


//휴대폰 인증구분 임의정의 - 대표자인증 : REPSNT, 관리자 인증 : ADMIN, 패스워드변경 : CNPC  추가정보에서 사용
function fn_phoneCert(){
	window.open("/EP/EPCE00852883.do"+ "?_csrf=<c:out value='${_csrf.token}' />", "PCERT", "width=450, height=600, left=100, top=30, menubar=no,status=no,toolbar=no, resizable=1");
}

//휴대폰 인증결과 tf-성공여부, div-넘겨준 CERT_DIV, 이름, 전화번호
function fn_kmcisResult(tf, div, name, phoneNum){
	if(!tf) return;
	
	var USER_NM = $("#USER_NM_POP").val();
	var USER_ID = $("#USER_ID_POP").val();
	var altPass = $("#ALT_REQ_PWD").val();
	
	var tmpPhone = $("#MBIL_PHON1").val() + "" + $("#MBIL_PHON2").val() + "" + $("#MBIL_PHON3").val();
	if(phoneNum != tmpPhone || name != USER_NM){
		alertMsg("요청정보[" + USER_NM + " : " + tmpPhone + "]와 본인 인증정보[" + name + " : " + phoneNum + "]가 일치하지 않습니다.");
		return;
	}
	
	var sData = {"USER_ID":USER_ID, "USER_NM":USER_NM, "ALT_REQ_PWD":altPass};
	var url = "/EP/EPCE8723488_212.do";
	ajaxPost(url, sData, function(data){
		if(data.cd == "0000"){
			alertMsg(data.msg, 'fn_cncl');
		}else{
			alertMsg(data.msg);
		}
	});
}


</script>

	<body>
	
	<form name="frmMain" id="frmMain" method="post">
	
		<input type="hidden" name="MBIL_PHON1" id="MBIL_PHON1" value="" />
		<input type="hidden" name="MBIL_PHON2" id="MBIL_PHON2" value="" />
		<input type="hidden" name="MBIL_PHON3" id="MBIL_PHON3" value="" />
		
		<!-- 휴대폰 인증구분 임의정의 - 대표자인증 : REPSNT, 관리자 인증 : ADMIN, 패스워드변경 : CNPC  추가정보에서 사용 -->
		<input type="hidden" name="CERT_DIV" id="CERT_DIV" value="CNPC" />
	
		<div class="layer_popup" style="width:700px;">
			<div class="layer_head">
				<h1 class="layer_title">비밀번호 변경요청</h1>
				<button type="button" class="layer_close" layer="close">팝업닫기</button>
			</div>
			<div class="layer_body">
				<div class="secwrap" id="divInput_P">
					<div class="srcharea" >
						<div class="row">
							<div class="col">
								<div class="tit">성명</div>
								<div class="box" >
									<input type="text" name="USER_NM" id="USER_NM_POP" maxByteLength="60" style="width:200px" />
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col">
								<div class="tit">아이디</div>
								<div class="box">
									<input type="text" name="USER_ID" id="USER_ID_POP" maxByteLength="20" style="width:200px" />
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col">
								<div class="tit">변경비밀번호</div>
								<div class="box">
									<input type="password" name="ALT_REQ_PWD" id="ALT_REQ_PWD" maxlength="16" autocomplete="off" style="width:200px" />
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col">
								<div class="tit">변경비밀번호 확인</div>
								<div class="box">
									<input type="password" name="ALT_REQ_PWD_CONFIRM" id="ALT_REQ_PWD_CONFIRM" autocomplete="off" maxlength="16" style="width:200px" />
								</div>
							</div>
						</div>
					</div>
					
			</form>
					
					<section class="btnwrap">
						<div class="fl_l" >
							<div class="h4group" >
								<h5 class="tit"  style="font-size: 14px;text-align:left">
									※ 비밀번호는 영문+숫자를 조합하여 10자(특수문자포함 8자, % 제외) 이상  16자 이하로 입력하셔야 합니다.
			   	 					<br/>&nbsp;&nbsp;&nbsp;요청하신 비밀번호는 해당 사업자 관리자의 승인 후 적용됩니다.
                                    <br/>※ 사업장 관리자는 휴대폰 인증을 통하여 변경 가능합니다.
								</h5>
							</div>
						</div>
					</section>
					
					<section class="btnwrap">
						<div class="btn" style="float:right">
							<button type="button" class="btn36 c1" style="width: 100px;" onclick="fn_cncl()" >취소</button>
							<button type="button" class="btn36 c3" style="width: 100px;" onclick="fn_confirm()" >변경요청</button>
						</div>
					</section>
					
				</div>
			</div>
	</div>
</body>
</html>