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

$(document).ready(function(){
	$(".number").css("text-align", "center");
	$(".number").bind("keyup", function(i){
		/*
		if (!(event.keyCode >=37 && event.keyCode<=40)) {
            var inputVal = $(this).val();
            $(this).val(inputVal.replace(/[^0-9]/gi,''));
        }
		*/
		var maxLen = Number($(this).attr("maxlength"));
		var id = $(this).attr("id");
		if(id == "BIZRNO1" && maxLen == $(this).val().length){
			$("#BIZRNO2").focus();
		}else if(id == "BIZRNO2" && maxLen == $(this).val().length){
			$("#BIZRNO3").focus();
		}else if(id == "MBIL_PHON1" && maxLen == $(this).val().length){
			$("#MBIL_PHON2").focus();
		}else if(id == "MBIL_PHON2" && maxLen == $(this).val().length){
			$("#MBIL_PHON3").focus();
		}
	});
});

//취소
function fn_cncl(){
	$('[layer="close"]').trigger('click');
}

//휴대폰 인증구분 임의정의 - 대표자인증 : REPSNT, 관리자 인증 : ADMIN, 패스워드변경 : CNPC  추가정보에서 사용
function fn_phoneCert(){
    
    
    if(!kora.common.cfrmDivChkValid("divInput_P")) {
	   return;
    }
    
	window.open("/EP/EPCE00852883.do"+ "?_csrf=<c:out value='${_csrf.token}' />", "PCERT", "width=450, height=600, left=100, top=30, menubar=no,status=no,toolbar=no, resizable=1");
}

//휴대폰 인증결과 tf-성공여부, div-넘겨준 CERT_DIV, 이름, 전화번호
function fn_kmcisResult(tf, div, name, phoneNum){
	if(!tf) return;
	
	var bizNo = $("#BIZRNO1").val() + "" + $("#BIZRNO2").val() + "" + $("#BIZRNO3").val();
	var USER_NM = $("#USER_NM").val();
	var p1 = $("#MBIL_PHON1").val();
	var p2 = $("#MBIL_PHON2").val();
	var p3 = $("#MBIL_PHON3").val();
	
	var tmpPhone = p1 + "" + p2 + "" + p3;
	if(phoneNum != tmpPhone || name != USER_NM){
		alert("입력하신 정보[" + USER_NM + " : " + tmpPhone + "]와 본인 인증정보[" + name + " : " + phoneNum + "]가 일치하지 않습니다.");
		return;
	}

	var sData = {"BIZRNO":bizNo, "USER_NM":USER_NM, "MBIL_PHON1":p1, "MBIL_PHON2":p2, "MBIL_PHON3":p3};
	var url = "/EP/EPCE87234882_21.do";
	ajaxPost(url, sData, function(data){
		if(data.cd == "0000"){
			$("#rsltDiv").show();
			$("#rsltTxt").html(data.msg);
		}else{
			alertMsg(data.msg);
		}
	});
	
}

</script>

	<body>
		<!-- 휴대폰 인증구분 임의정의 - 대표자인증 : REPSNT, 관리자 인증 : ADMIN, 패스워드변경 : CNPC  추가정보에서 사용 -->
		<input type="hidden" name="CERT_DIV" id="CERT_DIV" value="CNPC" />
	
		<div class="layer_popup" style="width:700px;">
			<div class="layer_head">
				<h1 class="layer_title">ID찾기</h1>
				<button type="button" class="layer_close" layer="close">팝업닫기</button>
			</div>
			<div class="layer_body">
				<div class="secwrap" id="divInput_P">
					<div class="srcharea" >
						<div class="row">
							<div class="col">
								<div class="tit">사업자번호</div>
								<div class="box" >
									<input type="text" name="BIZRNO1" id="BIZRNO1" maxlength="3" class="number i_notnull" style="width:70px" format="number" alt="사업자번호"/>
									<div class="dash" style="margin-top:5px">-</div> <input type="text" name="BIZRNO2" id="BIZRNO2" maxlength="2" class="number i_notnull" style="width:60px" format="number"  alt="사업자번호"/>
									<div class="dash" style="margin-top:5px">-</div> <input type="text" name="BIZRNO3" id="BIZRNO3" maxlength="5" class="number i_notnull" style="width:80px" format="number"  alt="사업자번호"/>

								</div>
							</div>
						</div>
						<div class="row">
							<div class="col">
								<div class="tit">성명</div>
								<div class="box">
									<input type="text" name="USER_NM" id="USER_NM" maxByteLength="60"  style="width:200px" class="i_notnull"  alt="성명"/>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col">
								<div class="tit">휴대전화번호</div>
								<div class="box">
									<input type="text" name="MBIL_PHON1" id="MBIL_PHON1" maxlength="3" class="number i_notnull" style="width:60px;" format="number" alt="휴대전화번호"/>
									<div class="dash" style="margin-top:5px">-</div> <input type="text" name="MBIL_PHON2" id="MBIL_PHON2" maxlength="4" class="number i_notnull" style="width:70px;" format="number" alt="휴대전화번호"/>
									<div class="dash" style="margin-top:5px">-</div> <input type="text" name="MBIL_PHON3" id="MBIL_PHON3" maxlength="4" class="number i_notnull" style="width:70px;" format="number" alt="휴대전화번호"/>
								</div>
							</div>
						</div>
					</div>
					
					<div class="srcharea mt10" id="rsltDiv" style="display:none">
						<div class="row">
							<div class="col">
								<div class="tit">ID찾기결과</div>
								<div class="boxView" id="rsltTxt" >
								</div>
							</div>
						</div>
					</div>
										
					<section class="btnwrap mt10">
						<div class="btn" style="float:right">
							<button type="button" class="btn36 c1" style="width: 100px;" onclick="fn_cncl()" >취소</button>
							<button type="button" class="btn36 c3" style="width: 100px;" onclick="fn_phoneCert()" >ID찾기</button>
						</div>
					</section>
					
				</div>
			</div>
	</div>
</body>
</html>