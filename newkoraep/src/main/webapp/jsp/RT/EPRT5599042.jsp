<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
		
		var INQ_PARAMS;
		var searchDtl;

		$(document).ready(function(){
			
			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val()); console.log(INQ_PARAMS);
			searchDtl = jsonObject($('#searchDtl').val());;	//상세 데이터
			
			fn_btnSetting();
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			$('#bizr_nm').text(parent.fn_text('bizr_nm'));
			$('#bizrno').text(kora.common.setDelim(parent.fn_text('bizrno'), '999-99-99999'));
			$('#brch').text(parent.fn_text('brch'));
			$('#dept').text(parent.fn_text('dept'));
			$('#user_nm').text(parent.fn_text('user_nm'));
			$('#id').text(parent.fn_text('id'));
			$('#pre_pwd').text(parent.fn_text('pre_pwd'));
			$('#alt_pwd').text(parent.fn_text('alt_pwd'));
			$('#alt_pwd_cfm').text(parent.fn_text('alt_pwd_cfm'));
			$('#email').text(parent.fn_text('email'));
			$('#tel_no').text(parent.fn_text('tel_no'));
			$('#tel_no2').text(parent.fn_text('tel_no'));
			$('#mbil_tel_no').text(parent.fn_text('mbil_tel_no'));
			
			//작성체크용

			$('#USER_NM').attr('alt', parent.fn_text('user_nm'));
			$('#PRE_PWD').attr('alt', parent.fn_text('pre_pwd'));
			$('#ALT_PWD').attr('alt', parent.fn_text('alt_pwd'));
			$('#ALT_PWD_CFM').attr('alt', parent.fn_text('alt_pwd_cfm'));
			$('#EMAIL_TXT').attr('alt', parent.fn_text('email'));
			$('#DOMAIN_TXT').attr('alt', parent.fn_text('email'));
			$('#MBIL_NO1').attr('alt', parent.fn_text('mbil_tel_no'));
			$('#MBIL_NO2').attr('alt', parent.fn_text('mbil_tel_no'));
			$('#MBIL_NO3').attr('alt', parent.fn_text('mbil_tel_no'));
			
			
			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
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
			
			/**
			 * 콤보박스 데이터 셋팅
			 */
			$('#drct_input').text(parent.fn_text('drct_input'));
			$('#cho1').text(parent.fn_text('cho'));
			$('#cho2').text(parent.fn_text('cho'));
			kora.common.setMailArrCmBx("", $("#DOMAIN"));	//메일도메인
			kora.common.setTelArrCmBx("", $("#TEL_NO1"));		//전화번호 국번
			kora.common.setHpArrCmBx("", $("#MBIL_NO1"));	//핸드폰 국번
			
			fnSetDtlData(searchDtl);
			
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
			
			if(!$(":checkbox[name='phoneCert']").prop("checked")){
				alertMsg("휴대폰인증을 하지 않았습니다.");
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
					if($("#PRE_PWD").val() == ""){
						alertMsg("비밀번호 변경을 위해서는 기존 비밀번호를 입력하셔야 합니다.");
						return false;
					}
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
		 	var url = "/RT/EPRT0140142_21.do";
		 	ajaxPost(url, sData, function(rtnData){
			 	if ("" != rtnData && null != rtnData) {
			 		if(rtnData.RSLT_CD == '0000'){
						alertMsg(rtnData.RSLT_MSG, 'fn_page');
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
				} else {
					alertMsg("error");
				}
		 	});
		}
		
		//저장 후 이동
		function fn_page(){
			kora.common.goPageB('', INQ_PARAMS);
		}
		
		/**
		  * 상세 데이터 셋팅
		  */
		 function fnSetDtlData(data){

		 	//화면상세
			$("#BIZRNM").text(kora.common.null2void(data.BIZRNM)+"\u00A0\u00A0\u00A0["+parent.fn_text('bizr_tp')+" : "+kora.common.null2void(data.BIZR_TP_NM)+"]");
		 	
			$("#BIZRNO").text( kora.common.setDelim(data.BIZRNO_DE, '999-99-99999')  );

			$("#BRCH_NM").text(kora.common.null2void(data.BRCH_NM));
			$("#DEPT_NM").text(kora.common.null2void(data.DEPT_NM));
			
			$("#USER_NM").val(kora.common.null2void(data.USER_NM));
			$("#USER_ID").val(kora.common.null2void(data.USER_ID));
			$("#USER_ID_TXT").text(kora.common.null2void(data.USER_ID));
			
			var email = kora.common.null2void(data.EMAIL).split("@");
			$("#EMAIL_TXT").val(email[0]);
			$("#DOMAIN_TXT").val(email[1]);
			
			$("#TEL_NO1").val(kora.common.null2void(data.TEL_NO1));
			$("#TEL_NO2").val(kora.common.null2void(data.TEL_NO2));
			$("#TEL_NO3").val(kora.common.null2void(data.TEL_NO3));
			$("#MBIL_NO1").val(kora.common.null2void(data.MBIL_NO1));
			$("#MBIL_NO2").val(kora.common.null2void(data.MBIL_NO2));
			$("#MBIL_NO3").val(kora.common.null2void(data.MBIL_NO3));
			
			$("#BIZR_TP_CD").val(kora.common.null2void(data.BIZR_TP_CD));
			
		 }
		
		//휴대폰 인증구분 임의정의 - 대표자인증 : REPSNT, 관리자 인증 : ADMIN, 패스워드변경 : CNPC  추가정보에서 사용
		function fn_phoneCert(div){
			window.open("/EP/EPCE00852883.do" + "?_csrf="+gtoken, "PCERT", "width=450, height=600, left=100, top=30, menubar=no,status=no,toolbar=no, resizable=1");
		}

		//휴대폰 인증결과 tf-성공여부, div-넘겨준 CERT_DIV, 이름, 전화번호
		function fn_kmcisResult(tf, div, name, phoneNum){
			var objNm = "phoneCert";
			
			$(":checkbox[name='" + objNm + "']").prop("checked", tf);
			if(!tf) return;
			
			var num = 6;
			if(phoneNum.length == 11) num = 7;

			$("#USER_NM").val(name);
			$("#MBIL_NO1").val(phoneNum.substring(0,3));
			$("#MBIL_NO2").val(phoneNum.substring(3,num));
			$("#MBIL_NO3").val(phoneNum.substring(num,phoneNum.length));
			
			//if($(":checkbox[name='certEqualChk']").prop("checked")) fn_certEqualChk();
		}
		
	</script>
	
</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="searchDtl" value="<c:out value='${searchDtl}' />"/>
	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
		</div>
		
		<section class="secwrap">
			<div class="write_area">
				<div class="write_tbl">
				<form name="frmMenu" id="frmMenu" method="post" onsubmit="return false;" >
					<input type="hidden" id="BIZR_TP_CD" name="BIZR_TP_CD"/>
					<input type="hidden" id="EMAIL" name="EMAIL"/>
					<input type="hidden" id="USER_ID" name="USER_ID"/>
					<table>
						<colgroup>
							<col style="width: 80px;">
							<col style="width: 120px;">
							<col style="width: auto;">
						</colgroup>
						<tr>
							<th colspan="2"><span id="bizr_nm"></span></th>
							<td>
								<div class="row">
									<div class="txtbox" id="BIZRNM"></div>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="bizrno"></span></th>
							<td>
								<div class="row">
									<div class="txtbox" id="BIZRNO"></div>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="brch"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<div class="txtbox" id="BRCH_NM"></div>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="dept"></span></th>
							<td>
								<div class="row">
									<div class="txtbox" id="DEPT_NM"></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="user_nm"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="USER_NM" name="USER_NM" style="width: 179px;" class="i_notnull" maxByteLength="60" readonly="readonly">
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="id"></span></th>
							<td>
								<div class="row">
									<div class="txtbox" id="USER_ID_TXT"></div>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="pre_pwd"></span></th>
							<td>
								<div class="row">
									<input type="password" id="PRE_PWD" name="PRE_PWD" style="width: 179px;"  maxLength="16">
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="alt_pwd"></span></th>
							<td>
								<div class="row">
									<input type="password" id="ALT_PWD" name="ALT_PWD" style="width: 179px;" maxLength="16">
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="alt_pwd_cfm"></span></th>
							<td>
								<div class="row">
									<input type="password" id="ALT_PWD_CFM" name="ALT_PWD_CFM" style="width: 179px;" maxLength="16">
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="email"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="EMAIL_TXT" name="EMAIL_TXT" style="width: 179px;" class="i_notnull" maxLength="20">
									<div class="sign">@</div>
									<input type="text" id="DOMAIN_TXT" name="DOMAIN_TXT" style="width: 179px;" class="i_notnull" maxLength="20">
									<select id="DOMAIN" name="DOMAIN" style="width: 179px;" >
										<option id="drct_input" value=""></option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<th rowspan="2"><span id="tel_no"></span></th>
							<th class="bd_l"><span id="tel_no2"></span></th>
							<td>
								<div class="row">
									<select id="TEL_NO1" name="TEL_NO1" style="width:80px">
										<option id="cho1" value=""></option>
									</select>
									<input type="text" id="TEL_NO2" name="TEL_NO2" style="width:80px" maxlength="4" format="number">
									<div class="sign"> - </div>
									<input type="text" id="TEL_NO3" name="TEL_NO3" style="width:80px" maxlength="4" format="number">
								</div>
							</td>
						</tr>
						<tr>
							<th class="bd_l"><span id="mbil_tel_no"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<!-- 
									<select id="MBIL_NO1" name="MBIL_NO1" style="width:80px" class="i_notnull" readonly="readonly">
										<option id="cho2" value=""></option>
									</select> -->
									<input type="text" id="MBIL_NO1" name="MBIL_NO1" style="width:80px" class="i_notnull" maxlength="4" format="number" readonly="readonly">
									<input type="text" id="MBIL_NO2" name="MBIL_NO2" style="width:80px" class="i_notnull" maxlength="4" format="number" readonly="readonly">
									<div class="sign"> - </div>
									<input type="text" id="MBIL_NO3" name="MBIL_NO3" style="width:80px" class="i_notnull" maxlength="4" format="number" readonly="readonly">
									
									<button  class="btn34 c6" style="width: 120px;" onclick="fn_phoneCert()">휴대폰 인증</button>
									<input type="checkbox" name="phoneCert" style="margin-top:8px;width:20px;height:20px" disabled/>
								</div>
								<div class="row">※ 성명 및 휴대전화번호 변경시, 성명 및 휴대전화번호 칸에 별도로 입력하지 않고 바로 휴대폰 인증 완료시 자동으로 변경됩니다.</div>
							</td>
						</tr>
					</table>
				</form>
				</div>
			</div>
		</section>
		
		<div class="btnwrap mt10">
			<div class="fl_l" id="BL">
			</div>
			<div class="fl_r" id="BR">
			</div>
		</div>

	</div>
	
</body>
</html>
