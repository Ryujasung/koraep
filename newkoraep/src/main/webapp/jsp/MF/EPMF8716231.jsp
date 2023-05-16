<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">

		$(document).ready(function(){
			
			//fn_btnSetting();
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			$('#bizr_nm').text(parent.fn_text('bizr_nm'));
			$('#bizrno').text(parent.fn_text('bizrno'));
			$('#bcs').text(parent.fn_text('bcs'));
			$('#tob').text(parent.fn_text('tob'));
			$('#rpst_nm').text(parent.fn_text('rpst_nm'));
			$('#admin_nm').text(parent.fn_text('admin_nm'));
			$('#admin_id').text(parent.fn_text('admin_id'));
			$('#pwd').text(parent.fn_text('pwd'));
			$('#pwd_cfm').text(parent.fn_text('pwd_cfm'));
			
			$('#acp_acct_no').text(parent.fn_text('acp_acct_no'));
			$('#acp_acct_dpstr_nm').text(parent.fn_text('acp_acct_dpstr_nm'));
			
			$('#email').text(parent.fn_text('email'));
			$('#astn_email').text(parent.fn_text('astn_email'));
			$('#tel_no').text(parent.fn_text('tel_no'));
			$('#rpst_tel_no').text(parent.fn_text('rpst_tel_no'));
			$('#cg_tel_no').text(parent.fn_text('cg_tel_no'));
			$('#cg_mbil_no').text(parent.fn_text('cg_mbil_no'));
			$('#fax_no').text(parent.fn_text('fax_no'));
			
			$('#bizr_addr').text(parent.fn_text('bizr_addr'));
			$('#bizr_license').text(parent.fn_text('bizr_license'));
			
			//작성체크용
			$('#USER_PWD').attr('alt', parent.fn_text('pwd'));
			$('#USER_PWD_CFM').attr('alt', parent.fn_text('pwd_cfm'));
			$('#EMAIL_TXT').attr('alt', parent.fn_text('email'));
			$('#DOMAIN_TXT').attr('alt', parent.fn_text('email'));
			$('#MBIL_NO1').attr('alt', parent.fn_text('mbil_tel_no'));
			$('#MBIL_NO2').attr('alt', parent.fn_text('mbil_tel_no'));
			$('#MBIL_NO3').attr('alt', parent.fn_text('mbil_tel_no'));

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
			
			/**
			 * 콤보박스 데이터 셋팅
			 */
			$('#drct_input').text(parent.fn_text('drct_input'));
			$('#cho1').text(parent.fn_text('cho'));
			$('#cho2').text(parent.fn_text('cho'));
			kora.common.setMailArrCmBx("", $("#DOMAIN"));	//메일도메인
			kora.common.setTelArrCmBx("", $("#TEL_NO1"));		//전화번호 국번
			kora.common.setHpArrCmBx("", $("#MBIL_NO1"));	//핸드폰 국번
			
		});

		//취소
		function fn_cnl(){
			kora.common.goPageB('', INQ_PARAMS);
		}
		
		//저장
		function fn_reg(){
			
			if(!kora.common.cfrmDivChkValid("frmMenu")) {
				return;
			 }
			
			//이메일 유효성 체크
			var regExp = /[0-9a-zA-Z][_0-9a-zA-Z-]*@[_0-9a-zA-Z-]+(\.[_0-9a-zA-Z-]+){1,2}$/;
			var emailAddr = $.trim($("#EMAIL_TXT").val()) +"@"+ $.trim($("#DOMAIN_TXT").val());
			if (!emailAddr.match(regExp)){
				alertMsg("이메일 형식에 맞지 않습니다.");
				return false;
			}
			
			//비밀번호 입력 체크(변경비밀번호 입력 시 에만 체크)
			if($("#ALT_PWD").val() != ""){

				//센터 관리자그룹은 비밀번호 체크로직 제외.
				//if(gfn_getCookie("GRP_CD") != "A01"){
					//if($("#PRE_PWD").val() == ""){
					//	alertMsg("비밀번호 변경을 위해서는 기존 비밀번호를 입력하셔야 합니다.");
					//	return false;
					//}
				//}
				
				if($("#ALT_PWD").val() != $("#ALT_PWD_CFM").val()){
					alertMsg("비밀번호 확인 정보가 다릅니다.\n다시 한번 확인하시기 바랍니다.");
					return false;
				}
				
				//센터 관리자그룹은 비밀번호 체크로직 제외.
				//if(gfn_getCookie("GRP_CD") != "A01"){
					if($.trim($("#ALT_PWD").val()).length < 8 || $.trim($("#ALT_PWD").val()).length > 16 || !kora.common.gfn_pwValidChk($("#ALT_PWD").val())){
						alertMsg("패스워드는 숫자+영문자를 조합하여 최소 10자(특수문자 포함 8자) ~ 최대 16자 까지만 입력이 가능합니다.");
						$("#ALT_PWD").focus();
						return false;
					}
				//}
			}
			
			confirm("저장하시겠습니까?", "fn_reg_exec");
		}
		
		function fn_reg_exec(){
			
			$('#EMAIL').val($.trim($("#EMAIL_TXT").val()) +"@"+ $.trim($("#DOMAIN_TXT").val()));
			
			var sData = kora.common.gfn_formData("frmMenu");
		 	var url = "/MF/EPMF8716231_09.do";
		 	ajaxPost(url, sData, function(rtnData){
			 	if ("" != rtnData && null != rtnData) {
			 		if(rtnData.RSLT_CD == '0000'){
						alertMsg(rtnData.RSLT_MSG, '');
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
				} else {
					alertMsg("error");
				}
		 	});
		}
		
	</script>
	
</head>
<body>
	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
		</div>
		
		<section class="secwrap">
			<div class="write_area">
				<div class="write_tbl">
				<form name="frmMenu" id="frmMenu" method="post" >
					<input type="hidden" id="BIZR_TP_CD" name="BIZR_TP_CD"/>
					<input type="hidden" id="EMAIL" name="EMAIL"/>
					<input type="hidden" id="USER_ID" name="USER_ID"/>
					<table>
						<colgroup>
							<col style="width: 80px;">
							<col style="width: 140px;">
							<col style="width: auto;">
						</colgroup>
						<tr>
							<th colspan="2"><span id="bizr_nm"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<div class="txtbox" id="BIZRNM">&nbsp;</div>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="bizrno"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<div class="txtbox" id="BIZRNO">&nbsp;</div>
									<span class="notice">※ 인증서는 입력한 정보와 동일한 사업자 번호로 발급된 기업용 공인 인증서만 제출 가능합니다.</span>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="bcs"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="BCS_NM" name="BCS_NM" style="width: 379px;" class="i_notnull" maxByteLength="90">
									<span class="notice">업종은 30자까지 입력 가능합니다.</span>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="tob"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="TOB_NM" name="TOB_NM" style="width: 379px;" class="i_notnull" maxByteLength="90">
									<span class="notice">업태는 30자까지 입력 가능합니다.</span>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="rpst_nm"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="RPST_NM" name="RPST_NM" style="width: 200px;" class="i_notnull" maxByteLength="90">
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="admin_nm"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="ADMIN_NM" name="ADMIN_NM" style="width: 200px;" class="i_notnull" maxByteLength="90">
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="admin_id"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="ADMIN_ID" name="ADMIN_ID" style="width: 200px;" class="i_notnull" maxlength="16">
									<button type="button" class="btn34 c6" style="width: 92px;">중복확인</button>
									<span class="notice">아이디는 영문+숫자를 조합하여 6자이상 16자 이하로 입력하셔야 합니다.</span>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="pwd"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="password" id="USER_PWD" name="USER_PWD" style="width: 200px;" maxLength="16">
									<span class="notice">비밀번호는 영문+숫자를 조합하여 10자(특수문자포함 8자, % 제외) 이상 16자 이하로 입력하셔야 합니다.</span>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="pwd_cfm"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="password" id="USER_PWD_CFM" name="USER_PWD_CFM" style="width: 200px;" maxLength="16">
									<span class="notice">비밀번호를 다시 한 번 입력합니다.</span>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="acp_acct_no"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text"  id="ACP_ACCT_NO" name="ACP_ACCT_NO" style="width: 200px;" maxLength="20" format="number">
									<span class="notice">계좌번호는 '-' 없이 숫자만 입력 가능합니다. </span>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="acp_acct_dpstr_nm"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text"  id="ACP_ACCT_DPSTR_NM" name="ACP_ACCT_DPSTR_NM" style="width: 200px;" maxByteLength="90">
									<span class="notice">수수료 지급 시 필요한 정보입니다. </span>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="email"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="EMAIL_TXT" name="EMAIL_TXT" style="width: 200px;" class="i_notnull" maxLength="20">
									<div class="sign">@</div>
									<input type="text" id="DOMAIN_TXT" name="DOMAIN_TXT" style="width: 200px;" class="i_notnull" maxLength="20">
									<select id="DOMAIN" name="DOMAIN" style="width: 200px;" >
										<option id="drct_input" value=""></option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="astn_email"></span></th>
							<td>
								<div class="row">
									<input type="text" id="ASTN_EMAIL_TXT" name="ASTN_EMAIL_TXT" style="width: 200px;" class="i_notnull" maxLength="20">
									<div class="sign">@</div>
									<input type="text" id="ASTN_DOMAIN_TXT" name="ASTN_DOMAIN_TXT" style="width: 200px;" class="i_notnull" maxLength="20">
									<select id="ASTN_DOMAIN" name="ASTN_DOMAIN" style="width: 200px;" >
										<option id="drct_input" value=""></option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<th rowspan="4"><span id="tel_no"></span></th>
							<th class="bd_l"><span id="rpst_tel_no"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<select id="RPST_TEL_NO1" name="RPST_TEL_NO1" style="width:80px">
										<option id="cho1" value=""></option>
									</select>
									<input type="text" id="RPST_TEL_NO2" name="RPST_TEL_NO2" style="width:70px" maxlength="4" format="number">
									<div class="sign"> - </div>
									<input type="text" id="RPST_TEL_NO3" name="RPST_TEL_NO3" style="width:70px" maxlength="4" format="number">
								</div>
							</td>
						</tr>
						<tr>
							<th class="bd_l"><span id="cg_tel_no"></span></th>
							<td>
								<div class="row">
									<select id="CG_TEL_NO1" name="CG_TEL_NO1" style="width:80px">
										<option id="cho1" value=""></option>
									</select>
									<input type="text" id="CG_TEL_NO2" name="CG_TEL_NO2" style="width:70px" maxlength="4" format="number">
									<div class="sign"> - </div>
									<input type="text" id="CG_TEL_NO3" name="CG_TEL_NO3" style="width:70px" maxlength="4" format="number">
								</div>
							</td>
						</tr>
						<tr>
							<th class="bd_l"><span id="cg_mbil_no"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<select id="MBIL_NO1" name="MBIL_NO1" style="width:80px" class="i_notnull">
										<option id="cho2" value=""></option>
									</select>
									<input type="text" id="MBIL_NO2" name="MBIL_NO2" style="width:70px" class="i_notnull" maxlength="4" format="number">
									<div class="sign"> - </div>
									<input type="text" id="MBIL_NO3" name="MBIL_NO3" style="width:70px" class="i_notnull" maxlength="4" format="number">
								</div>
							</td>
						</tr>
						<tr>
							<th class="bd_l"><span id="fax_no"></span></th>
							<td>
								<div class="row">
									<select id="FAX_NO1" name="FAX_NO1" style="width:80px">
										<option id="cho1" value=""></option>
									</select>
									<input type="text" id="FAX_NO2" name="FAX_NO2" style="width:70px" maxlength="4" format="number">
									<div class="sign"> - </div>
									<input type="text" id="FAX_NO3" name="FAX_NO3" style="width:70px" maxlength="4" format="number">
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="bizr_addr"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text"  id="" name="" style="width: 200px;" maxByteLength="90">
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="bizr_license"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text"  id="" name="" style="width: 200px;" maxByteLength="90">
									<span class="notice">* 이미지는 최대 30MB크기 까지만 가능합니다.</span>
								</div>
							</td>
						</tr>
					</table>
				</form>
				</div>
				<div class="btnwrap">
					<div class="fl_l" id="BL">
					</div>
					<div class="fl_r" id="BR">
					</div>
				</div>
			</div>
		</section>

	</div>
	
</body>
</html>
