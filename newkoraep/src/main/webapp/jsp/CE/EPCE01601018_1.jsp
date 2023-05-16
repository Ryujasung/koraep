<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>사업자관리</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

var parent_item;

$(document).ready(function(){
	
	fn_btnSetting('EPCE01601018_1');
	parent_item = window.frames[$("#pagedata").val()].parent_item;
// 	console.log(parent_item);
	$('#title_sub').text('<c:out value="${titleSub}" />');
	
	kora.common.setHpArrCmBx("", $("#MBIL_NO1"));	//핸드폰 국번
	kora.common.setMailArrCmBx("", $("#EMAIL_DOMAIN"));	//메일도메인
	kora.common.setTelArrCmBx("", $("#TEL_NO1"));		//전화번호 국번
	$('#EMAIL1').attr('alt', parent.fn_text('email'));
	$('#EMAIL2').attr('alt', parent.fn_text('email'));
	$('#drct_input').text(parent.fn_text('drct_input'));
	$('#cho1').text(parent.fn_text('cho'));
	$('#cho2').text(parent.fn_text('cho'));
	
	/**
	 * 관리자아이디 등록버튼이벤트
	 */
	$("#btn_reg").click(function(){
		fn_reg();
	});
	
	/**
	 * 관리자아이디등록 취소버튼이벤트
	 */
	$("#btn_cncl").click(function(){
		fn_cncl();
	});
	
	/**
	 * 관리자아이디 중복체크
	 */
	 $("#chk").click(function(){
		 fn_dupleCheck();
	 });
	
	 /**
	  * 이메일 도메인 변경 이벤트
	  */
	 $("#EMAIL_DOMAIN").change(function(){
	 	
	 	$("#EMAIL2").val(kora.common.null2void($(this).val()));
	 	
	 	if(kora.common.null2void($(this).val()) != "") 
	 		$("#EMAIL2").attr("disabled",true);
	 	else
	 		$("#EMAIL2").attr("disabled",false);
	 });
});

// function fn_init(data) {
// 	var input = {};
// 	var url = "/CE/EPCE01601018_3.do";
// 	input["BIZRNO"] 	= data.BIZRNO;
// 	ajaxPost(url, input, function(rtnData){
// 		if(rtnData != null && rtnData != ""){
// 			$('#title_sub').text(rtnData.titleSub);
// 			$("#BIZRNO").val(rtnData.initList[0].BIZRNO);
// 		} 
// 		else {
// 			alertMsg("error");
// 		}
// 	});
// }

	/**
	 * 등록
	 */
	function fn_reg(){
		
		if(!kora.common.cfrmDivChkValid("frmMenu")) {
			return;
		 }
// 		var EMAIL2  = $("#EMAIL_DOMAIN option:selected").val(); 
		
		//이메일 유효성 체크
		var regExp = /[0-9a-zA-Z][_0-9a-zA-Z-]*@[_0-9a-zA-Z-]+(\.[_0-9a-zA-Z-]+){1,2}$/;
		var emailAddr = $.trim($("#EMAIL1").val()) +"@"+ $.trim($("#EMAIL2").val());
		if (!emailAddr.match(regExp)){
			alertMsg("이메일 형식에 맞지 않습니다.");
			return false;
		}
		
		$('#EMAIL').val(emailAddr);
		
		
		if($("#DUPLE_CHECK_YN").val() != "Y"){
			alertMsg("아이디 중복체크를 하지 않았습니다.");
			return false;
		}
		
		if($("#USE_ABLE_YN").val() != "Y"){
			alertMsg("사용할 수 없는 아이디 입니다.\n아이디 중복체크 후 사용 하시기 바랍니다.");
			return false;
		}
		
		confirm("저장하시겠습니까?", "fn_reg_exec");
	
	}
	
	function fn_reg_exec(){
		
// 		$("#EMAIL").val($.trim($("#EMAIL1").val()) +"@"+ $.trim($("#EMAIL2").val()));
		var sData = kora.common.gfn_formData("frmMenu");
		sData["BIZRID"] = parent_item.BIZRID;
		sData["BIZRNO"] = parent_item.BIZRNO_DE;
		sData["BIZRNO2"] = parent_item.BIZRNO;
		sData["BIZR_TP_CD"] = parent_item.BIZR_TP_CD;
		sData["USER_SE_CD"] = 'D';
	 	var url = "/CE/EPCE01601018_2.do";
	 	ajaxPost(url, sData, function(rtnData){
		 	if ("" != rtnData && null != rtnData) {
		 		if(rtnData.RSLT_CD == '0000'){
					alertMsg(rtnData.RSLT_MSG, 'fn_cncl');
				}else{
					alertMsg(rtnData.RSLT_MSG);
				}
			} else {	
				alertMsg("error");
			}
	 	});
	}

	/**
	 * 취소
	 */
	function fn_cncl(){
		$('[layer="close"]').trigger('click');
	}


/**
 * id중복 체크
 */
function fn_dupleCheck(){
	var USER_ID = $("#USER_ID").val();
	if(USER_ID == null || USER_ID == ""){
		alertMsg("관리자 아이디를 입력하세요");
		$("#USER_ID").focus();
		return;
	}
	
	if(!kora.common.gfn_idValidChk(USER_ID)){
		alertMsg("아이디는 영문자와 숫자를 조합하여 6자리 이상 16자리 이하로 입력하여야 합니다.");
		return;
	}
	
	if(!kora.common.gfn_idPwChkValid(USER_ID)) return;
	
	//DUPLE_CHECK_YN, USE_ABLE_YN
	var sData = {"USER_ID" : USER_ID};
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


</script>
</head>
<body>
<input type="hidden" id="pagedata"/>
<!-- <input type="hidden" id="BIZRNO" name="BIZRNO"> -->
<div class="layer_popup" style="width: 514px;">
	<div class="layer_head">
		<h1 class="layer_title" id="titleSub">관리자 아이디 등록</h1>
		<button type="button" class="layer_close" layer="close">팝업닫기</button>
	</div>
	<div class="layer_body">
		<div class="secwrap">
			<div class="write_area">
				<div class="write_tbl pop">
				<form name="frmMenu" id="frmMenu" method="post" >
					<table>
						<colgroup>
							<col style="width: 104px;">
							<col style="width: auto;">
						</colgroup>
						<tr>
							<th>관리자성명<span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="ADMIN_NM" name="ADMIN_NM" style="width: 179px;" class="i_notnull" maxByteLength="30" alt="관리자성명">
								</div>
							</td>
						</tr>
						<tr>
							<th>관리자 아이디<span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="USER_ID" name="USER_ID" style="width: 179px;" class="i_notnull" maxByteLength="30" alt="관리자아이디">
									<button type="button" id="chk" class="btn34 c6" style="width: 92px;">중복확인</button>
									<input type="hidden" name="DUPLE_CHECK_YN" id="DUPLE_CHECK_YN" value="" />
									<input type="hidden" name="USE_ABLE_YN" id="USE_ABLE_YN" value="" />
								</div>
							</td>
						</tr>
						<tr>
							<th>이메일<span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="EMAIL1" name="EMAIL1" style="width: 100px;" class="i_notnull" maxlength="30" alt="이메일">
									<div class="sign">@</div>
									<input type="text" id="EMAIL2" name="EMAIL2" style="width: 100px;" class="i_notnull" maxlength="30" alt="이메일">
									<select id="EMAIL_DOMAIN" style="width: 100px;">
										<option id="drct_input" value=""></option>
									</select>
									<input type="hidden" id="EMAIL" name="EMAIL" style="width: 100px;">
								</div>
							</td>
						</tr>
						<tr>
							<th>휴대전화번호<span class="red">*</span></th>
							<td>
								<div class="row">
									<select id="MBIL_NO1" name="MBIL_NO1" style="width:80px" class="i_notnull" alt="휴대전화번호">
										<option id="cho1" value=""></option>
									</select>
									<div class="dash">-</div>
									<input type="text" id="MBIL_NO2" name="MBIL_NO2" style="width: 100px;" class="i_notnull" maxlength="4" alt="휴대전화번호">
									<div class="dash">-</div>
									<input type="text" id="MBIL_NO3" name="MBIL_NO3" style="width: 100px;" class="i_notnull" maxlength="4" alt="휴대전화번호">
								</div>
							</td>
						</tr>
						<tr>
							<th>전화번호</th>
							<td>
								<div class="row">
									<select id="TEL_NO1" name="TEL_NO1" style="width:80px">
										<option id="cho2" value=""></option>
									</select>
									<div class="dash">-</div>
									<input type="text" id="TEL_NO2" name="TEL_NO2" style="width: 100px;" maxlength="4">
									<div class="dash">-</div>
									<input type="text" id="TEL_NO3" name="TEL_NO3" style="width: 100px;" maxlength="4">
								</div>
							</td>
						</tr>
					</table>
					<div class="btnwrap">
						<div class="fl_r">
							<button type="button" id="btn_cncl" class="btn36 c4" style="width: 100px;">취소</button>
							<button type="button" id="btn_reg" class="btn36 c2" style="width: 100px;">등록</button>
						</div>
					</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>

</body>
</html>