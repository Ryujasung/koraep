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

<link rel="stylesheet" href="/common/css/slick.css"/>
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

	$(document).ready(function(){
	
		$('#CERT_YN').hide();
		$('#DAMD').hide();
		
		$("[name=BIZRNO]").bind("keyup", function(i){
			if($(this).attr("id") == "BIZRNO3" && event.keyCode == 13){
				fn_confirm();
			}else{
				var maxLen = Number($(this).attr("maxlength"));
				var id = $(this).attr("id");
				if(id == "BIZRNO1" && maxLen == $(this).val().length){
					$("#BIZRNO2").focus();
				}else if(id == "BIZRNO2" && maxLen == $(this).val().length){
					$("#BIZRNO3").focus();
				}
			}
		});
		
		$('#btn_cfm').click(function(){
			fn_cfm();
		});
		
		$('#btn_bizr').click(function(){
			fn_bizr();
		});
		
		$('#btn_damd').click(function(){
			fn_damd();
		});
		
		//반드시 실행..
		pub_ready();
		
		$("#btn_pop4").click(function(){	//회원가입절차
			fn_pop4();
		});

	});
	
	function fn_pop4(){
		NrvPub.AjaxPopup('/EP/EPCE00852886.do', '', '');
	}
	
	//사업자 회원가입
	function fn_bizr(){
		if(bizrCfm == ''){
			alertMsg("사업자 확인을 먼저 진행하셔야 합니다.");
			return false;
		}
		
		var CERT_YN = $(':radio[name="CERT_YN"]:checked').val();
		if(CERT_YN == null || CERT_YN == ""){
			alertMsg("기업용 범용인증서의 유무를 선택하십시오.");
			return;
		}
				
		if(CERT_YN == "Y"){	//전자서명 인스톨
			//location.href='/EP/VestCertInstall.do?_csrf=<c:out value='${_csrf.token}' />'; 
			window.open("/EP/EPCE0085288.do?_csrf=<c:out value='${_csrf.token}' />", "InstallVestCert", "width=800, height=500, menubar=no,status=no,toolbar=no, resizable=1");	
		}else{
			
			var input = kora.common.gfn_formData('frm');
			var INQ_PARAMS = {};
			INQ_PARAMS["PARAMS"] = input;
			INQ_PARAMS["FN_CALLBACK"] = "";
			INQ_PARAMS["URL_CALLBACK"] = "/EP/EPCE00852012.do";
			kora.common.goPage('/EP/EPCE00852014.do', INQ_PARAMS);
		}
	}
	
	//전자서명 팝업 후 실제이동
	function fn_move(tf){
		if(!tf) return;

		var input = kora.common.gfn_formData('frm');
		var INQ_PARAMS = {};
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK"] = "";
		INQ_PARAMS["URL_CALLBACK"] = "/EP/EPCE00852012.do";
		kora.common.goPage('/EP/EPCE00852013.do', INQ_PARAMS);
	}
	
	//업무담당자회원가입
	function fn_damd(){
		var input = kora.common.gfn_formData('frm');
		var INQ_PARAMS = {};
		INQ_PARAMS["PARAMS"] = input;
		INQ_PARAMS["FN_CALLBACK"] = "";
		INQ_PARAMS["URL_CALLBACK"] = "/EP/EPCE00852012.do";
		kora.common.goPage('/EP/EPCE00852015.do', INQ_PARAMS);
	}
	
	var bizrCfm = '';
	function fn_cfm(){
		
		var bsnmNm = $("#BSNM_NM").val(); 
		if(bsnmNm == null || bsnmNm == ""){
			alertMsg("사업자 명을 입력하세요");
			return;
		}
		
		var no1 = $("#BIZRNO1").val();
		var no2 = $("#BIZRNO2").val();
		var no3 = $("#BIZRNO3").val();
		var bizNo = no1 + "" + no2 + "" + no3;
		if($.trim(bizNo).length != 10){
			alertMsg("사업자 번호 10자리를 정확히 입력하세요");
			return;
		}
		
		if(!kora.common.gfn_bizNoCheck(bizNo)){
 			alertMsg("유효하지 않은 사업자번호 입니다.");
 			return false;
		}
		
		bizrCfm = '';
		var sData = {"BIZRNO":bizNo, "BSNM_NM":bsnmNm};
		var url = "/EP/EPCE00852012_19.do";

		ajaxPost(url, sData, function(data){
	
			if(data != null && data != ''){
				
				bizrCfm = "Y";
				
				if(data.bizrInfo.length == 0){
					alertMsg("등록되지 않은 사업자번호 입니다.\n사업자 회원가입을 진행하여 주십시오.");
					$("#CERT_YN").show();
					$("#DAMD").hide();
				}else if(data.bizrInfo[0].BIZR_STAT_CD == "Y"){
					alertMsg("사업자회원이 등록된 상태이며, 업무담당자 회원가입 진행이 가능합니다.");
					$("#CERT_YN").hide();
					$("#DAMD").show();
				}else if(data.bizrInfo[0].BIZR_STAT_CD != "Y"){
					alertMsg("비활동 사업자회원 상태이며, 사업자 회원 또는 업무담당자 회원가입이 불가능합니다. \n관리자에게 문의 하십시오.");
					$("#CERT_YN, #DAMD").hide();
				}
				
				$('#BIZRNO1_CFM').val(no1);
				$('#BIZRNO2_CFM').val(no2);
				$('#BIZRNO3_CFM').val(no3);
				
				if(data.bizrInfo.length > 0){
					$('#BIZRID').val(data.bizrInfo[0].BIZRID);
					$('#BIZRNM').val(data.bizrInfo[0].BIZRNM);
					$('#BIZR_TP_CD').val(data.bizrInfo[0].BIZR_TP_CD);
					$('#BIZRNO').val(data.bizrInfo[0].BIZRNO);
				}else{
					$('#BIZRID').val('');
					$('#BIZRNM').val(bsnmNm);
					$('#BIZRNO').val(bizNo);
				}
				
			}else{
				alertMsg('error');
			}
		});
		
	}
	
</script>

</head>
<body >
	<div id="wrap" style="padding:0 0 182px 40px">

		<div id="container" class="asideOpen">

			<div id="contents">
				<div class="conbody2">
					<div class="join_step">
						<ol>
							<li class="s1">약관동의</li>
							<li class="s2 on">사업자확인</li>
							<li class="s3">정보입력</li>
							<li class="s4">가입신청완료</li>
						</ol>
					</div>
					<div class="h3group">
						<h3 class="tit">사업자확인</h3>
					</div>
					<div class="white_wrap">
						<p class="mb15">사업자명, 사업자 등록번호를 입력해 주시기 바랍니다.</p>
						<div class="write_tbl mm25 bdt1">
							<table>
								<colgroup>
									<col style="width: 15%;">
									<col style="width: auto;">
								</colgroup>
								<tbody>
									<tr>
										<th>사업자명</th>
										<td>
											<div class="row">
												<input type="text" style="width: 330px;" maxByteLength="90" id="BSNM_NM">
												<span class="notice">사업자명은 30자까지 입력 가능합니다.</span>
											</div>
										</td>
									</tr>
									<tr>
										<th>사업자등록번호</th>
										<td>
											<div class="row">
												<input type="text" style="width: 100px;" maxlength=3 format=number id="BIZRNO1" name="BIZRNO">
												<div class="dash">-</div>
												<input type="text" style="width: 100px;" maxlength=2 format=number id="BIZRNO2" name="BIZRNO">
												<div class="dash">-</div>
												<input type="text" style="width: 100px;" maxlength=5 format=number id="BIZRNO3" name="BIZRNO">
												<button type="button" class="btn34 c6" style="width: 92px;" id="btn_cfm">확인</button>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<ul class="join2_dot_list">
							<li>· 사업자명은 사업자등록증 상에 등록된 사업자(법인)명으로 입력해 주시기 바랍니다.</li>
							<li>· 사업자명이 한글이 아닐 경우 사업자등록증 상에 명시된 이름으로 입력하셔야 합니다. (예 : SK -> 에스케이)</li>
							<li>· 타인의 사업자등록번호를 도용하여 재산상 이익을 취했을 경우, 사문서 위조 및 사기 등의 죄를 적용 받을 수 있습니다.</li>
							<li>· 빈용기보증금 및 취급수수료 지급관리시스템 이용을 위해서는 '<span class="orange">사업자 회원 가입</span>'을 하여야 합니다.</li>
							<li>· 사업자 회원 가입을 위해서는 기업용 공인 인증서가 필요합니다. (범용기업인증서)</li>
							<li>· 사업자 회원 가입 후, '<span class="orange">업무 담당자 회원 가입</span>'을 통하여 추가 사용자의 가입이 가능합니다.</li>
							<li>· 업무 담당자 회원 가입 시에는 사업자 회원(사업자 관리자)의 가입 승인 이후 시스템 사용이 가능합니다.</li>
							<div class="btnwrap mt20">
								<div class="fl_r">
									<button type="button" class="btn36 c4" style="width: 202px;" id="btn_pop4">회원가입 절차 미리 보기</button>
								</div>
							</div>
						</ul>


						<div class="write_tbl mt20" >
							<table style="width:700px;margin-left:350px">
								<tr>
									<td style="border:0px">
										<div class="row" id="CERT_YN" style="border:0px">
											<label class="rdo"><input type="radio" id="CERT_YN1" name="CERT_YN" value="Y" checked="checked"/><span>기업용 범용인증서가 있습니다.</span></label>
											<label class="rdo"><input type="radio" id="CERT_YN2" name="CERT_YN" value="N" /><span>기업용 범용인증서가 없습니다.</span></label>
											<button type="button" class="btn34 c6" style="width: 130px;" id="btn_bizr">사업자 회원가입</button>
										</div>
										<div class="row" id="DAMD" style="border:0px;padding-left:200px">
											<button type="button" class="btn34 c6" style="width: 150px;" id="btn_damd">업무 담당자 회원가입</button>
										</div>
									</td>
								</tr>
							</table>
						</div>
						
					</div>
				</div>
			</div>
		</div><!-- end : id : container -->

		<%@include file="/jsp/include/footer.jsp" %>

	</div>
	
	<form id="frm" name="frm">
		<input type='hidden' id="BIZRID" name="BIZRID" />
		<input type='hidden' id="BIZRNO" name="BIZRNO" />
		<input type='hidden' id="BIZRNO1_CFM" name="BIZRNO1_CFM" />
		<input type='hidden' id="BIZRNO2_CFM" name="BIZRNO2_CFM" />
		<input type='hidden' id="BIZRNO3_CFM" name="BIZRNO3_CFM" />
		<input type='hidden' id="BIZRNM" name="BIZRNM" />
		<input type='hidden' id="BIZR_TP_CD" name="BIZR_TP_CD" />
	</form>
	
</body>
</html>
