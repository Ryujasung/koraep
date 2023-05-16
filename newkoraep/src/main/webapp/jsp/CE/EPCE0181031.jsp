<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>도매업자 직매장/공장 저장</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />

<script type="text/javaScript" language="javascript" defer="defer">

	var INQ_PARAMS;
	var whsl_se_cdList;
    var area_cd_list;
    var aff_ogn_cd_list ;
    var acp_mgnt_yn_list;

	$(function(){
		
		INQ_PARAMS 		= jsonObject($('#INQ_PARAMS').val());
		whsl_se_cdList 	= jsonObject($('#whsl_se_cdList').val());
	    area_cd_list 		= jsonObject($('#area_cd_list').val());
	    aff_ogn_cd_list  	= jsonObject($('#aff_ogn_cd_list').val());
	    acp_mgnt_yn_list = jsonObject($('#acp_mgnt_yn_list').val());
		
		fn_btnSetting();

		//그룹여부 변경시
 		$('[name=GRP_YN]').change(function() { 
 			
 			//총괄지점 검색
 			if($("input:radio[name='GRP_YN']:checked").val() == 'N'){
 				
 				if($('#BIZRNM').val() == ''){
 					$(":radio[name='GRP_YN'][value='Y']").prop("checked", true);
 	 				alertMsg("먼저 도매업자를 선택하세요.");
 	 				return;
 	 			}
 				
 				var url = "/CE/EPCE0181031_19.do" 
				var input ={};
			    input["BIZRID_NO"] = $("#BIZRNM").val();

	       	    ajaxPost(url, input, function(rtnData) {
	   				if ("" != rtnData && null != rtnData) {   
	   					console.log(rtnData.grpList);
	   					kora.common.setEtcCmBx2(rtnData.grpList, "","", $("#GRP_BRCH_NO"), "BRCH_NO", "BRCH_NM", "N" ,'S');
	   				} else {
	   					alertMsg("error");
	   				}
	    		});
 				
	       	    $('.grpY').attr('style', '');
 			}else{
 				$('.grpY').attr('style', 'display:none');
 			}
 			
 			window.frameElement.style.height = $('.iframe_inner').height()+5+'px';
 		});
 		
 		//도매업자구분 변경시 업체명 조회
 	     function fn_bizr_tp_cd(){
 	    	var url = "/CE/EPCE0181001_193.do" 
 			var input ={};
 			$("#BIZRNM").select2("val","");
 			   if($("#BIZR_TP_CD").val()  !=""){ 	//도매업자 구분 변경시
 			 		  	input["BIZR_TP_CD"] =$("#BIZR_TP_CD").val();
 			 		  	ajaxPost(url, input, function(rtnData) {
 			   				if ("" != rtnData && null != rtnData) {  
 			   					 	kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'S');		 //업체명
 			   				}else{
 			   						 alertMsg("error");
 			   				}
 		   				},false);
 			 		  	
 			   }else{	//전체
 				   kora.common.setEtcCmBx2([], "","", $("#BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'S');					//도매업자
 				//   kora.common.setEtcCmBx2([], "","", $("#GRP_BRCH_NM"), "BRCH_NO", "BRCH_NM", "N" ,'T');					//총괄직매장
 	  			}
 	     } 
		
 	    /************************************
 		 * 도매업자 구분 변경 이벤트
 		 ***********************************/
 		$("#BIZR_TP_CD").change(function(){
 			fn_bizr_tp_cd();
 		});
 		
		//업체명 변경시
 		$('#BIZRNM').change(function() { 
 			$(":radio[name='GRP_YN'][value='Y']").prop("checked", true);
 			$('.grpY').attr('style', 'display:none');
 			$("#GRP_BRCH_NO").children().remove();
 		});
 		
 		//등록 버튼
		$("#btn_reg").click(function(){
			fn_reg();
		});
 		
		//취소
		$("#btn_cnl").click(function(){
			fn_cnl();
		});
		
		fn_init();
 		
		$('[name=ACP_MGNT_YN]').change(function(){
			if($("input:radio[name='ACP_MGNT_YN']:checked").val() == 'Y'){
				$('.payExecY').show();
			}else{
				$('.payExecY').hide();
			}
			window.frameElement.style.height = $('.iframe_inner').height()+'px';
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
		 * 우편번호검색 버튼 클릭 이벤트
		 */
		 var parent_item;
		$("#btnPopZip").click(function(){
			var pagedata = window.frameElement.name;
			window.parent.NrvPub.AjaxPopup('/SEARCH_ZIPCODE_POP.do', pagedata);
		});
		
		/**
		 * 은행, 계좌변경시 체크값 초기화
		 */
		$("#ACP_BANK_CD_SEL, #ACP_ACCT_NO").bind("change", function(){
			$(":checkbox[name='ACCT_CHECK_YN']").prop("checked", false);
			$("#ACP_ACCT_DPSTR_NM").val("");
		});
		
		/**
		  * 예금주 중복체크
		  */
		 $("#chk2").click(function(){
			 fn_acctCheck();
		 });	
		
	});
	
	/**
	 * 계좌인증 - 예금주확인
	 */
	function fn_acctCheck(){
		var bankCd  = $("#ACP_BANK_CD_SEL option:selected").val();
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
		
		/*
		var flag = true;
		if(location.href.indexOf("localhost") > -1 || location.href.indexOf("devreuse") > -1){
			$(":checkbox[name='ACCT_CHECK_YN']").prop("checked", true);
			$("#ACP_ACCT_DPSTR_NM").val($("#RPST_NM").val());
			flag = false;
			return;
		}
		*/
		
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
	
	//초기 셋팅
	function fn_init(){
		
		kora.common.setEtcCmBx2(whsl_se_cdList, "","", $("#BIZR_TP_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');			//도매업자구분 
	 	kora.common.setEtcCmBx2([], "","", $("#BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'S');									//도매업자
 		kora.common.setEtcCmBx2(area_cd_list, "","", $("#AREA_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');					//지역
 		kora.common.setEtcCmBx2(aff_ogn_cd_list, "","", $("#AFF_OGN_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');			//소속단체
 		kora.common.setEtcCmBx2(acp_mgnt_yn_list, "","", $("#ACP_MGNT_YN"), "ETC_CD", "ETC_CD_NM", "N" ,'S');	//수납여부
 		
 		var BankCdList = jsonObject($('#BankCdList').val());
		kora.common.setEtcCmBx2(BankCdList, "", "", $("#ACP_BANK_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "S");
 		
		kora.common.setMailArrCmBx("", $("#DOMAIN"));	//메일도메인
 		kora.common.setTelArrCmBx("", $("#RPST_TEL_NO1")); //전화번호 국번
 		$('#drct_input').text(parent.fn_text('drct_input'));
		$('#cho1').text(parent.fn_text('cho'));
		
 		$('#title_sub').text('<c:out value="${titleSub}" />');
		$('#whsl_se_cd').text(parent.fn_text('whsl_se_cd'));			//도매업자 구분
		$('#enp_nm').text(parent.fn_text('enp_nm'));					//업체명 (도매업자)
		
		//도매업자  autoComplete
 		 $("#BIZRNM").select2();
	}
	
	//취소
	function fn_cnl(){
		kora.common.goPageB('', INQ_PARAMS);
	}

	//저장
	function fn_reg(){

		if($('#BIZR_TP_CD').val() == ''){
			alertMsg('도매업자 구분을 확인하세요.');
			return;
		}
		if($('#BIZRNM').val() == ''){
			alertMsg('업체명을 확인하세요.');
			return;
		}
		
		if(!kora.common.cfrmDivChkValid("frmMenu")) {
			return;
		}
				
		if($(':radio[name=GRP_YN]:checked').val() == 'N'){
			if($('#GRP_BRCH_NO').val() == ''){
				alertMsg('관리지점을 선택하세요.');
				return;
			}
		}
		
		//수납관리
		if($("input:radio[name='ACP_MGNT_YN']:checked").val() == 'Y'){

			if($("#ACP_BANK_CD_SEL").val() == ""){
				alertMsg("수납 계좌번호 은행을 확인하세요.");
				return false;
			}
			if($("#ACP_ACCT_NO").val() == ""){
				alertMsg("수납 계좌번호를 확인하세요.");
				return false;
			}
			if($("#EMAIL1").val() == "" || $("#EMAIL2").val() == ""){
				alertMsg("대표 이메일을 확인하세요.");
				return false;
			}
			if($("#RPST_TEL_NO1").val() == "" || $("#RPST_TEL_NO2").val() == "" || $("#RPST_TEL_NO3").val() == ""){
				alertMsg("대표 전화번호를 확인하세요.");
				return false;
			}
			if($("#PNO").val() == "" || $("#ADDR1").val() == "" || $("#ADDR2").val() == ""){
				alertMsg("사업장주소를 확인하세요.");
				return false;
			}
			
			//사업자번호 체크
	 		if(!kora.common.gfn_bizNoCheck($("#BRCH_NO").val())){
	 			alertMsg("직매장/공장코드는 유효한 사업자번호를 입력해야 합니다.");
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
			
			//수납계좌 예금주 확인 여부 체크
			if(!$(":checkbox[name='ACCT_CHECK_YN']").prop("checked")){
				alertMsg("예금주 확인을 하지 않았습니다.");
				return false;
			}
			
		}		
		
		confirm('저장하시겠습니까?', 'fn_reg_exec');
	}
	
	function fn_reg_exec(){
		var sData = kora.common.gfn_formData("frmMenu");
	 	var url = "/CE/EPCE0181031_09.do";
	 	
	 	console.log(sData)
	 	
	 	ajaxPost(url, sData, function(rtnData){
	 		if ("" != rtnData && null != rtnData) {
 				if(rtnData.RSLT_CD == '0000'){
					alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
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

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="whsl_se_cdList" value="<c:out value='${whsl_se_cdList}' />"/>
<input type="hidden" id="area_cd_list" value="<c:out value='${area_cd_list}' />"/>
<input type="hidden" id="aff_ogn_cd_list" value="<c:out value='${aff_ogn_cd_list}' />"/>
<input type="hidden" id="acp_mgnt_yn_list" value="<c:out value='${acp_mgnt_yn_list}' />"/>
<input type="hidden" id="BankCdList" value="<c:out value='${BankCdList}' />"/>

	<div class="iframe_inner">
		<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
		</div>
		
		<section class="secwrap">
			<div class="write_area" id='div_input'>
				<form name="frmMenu" id="frmMenu" method="post" >
				<div class="write_tbl">
					<table>
						<colgroup>
							<col style="width: 8%;">
							<col style="width: 15%;">
							<col style="width: auto;">
						</colgroup>
						<tr >
							<th colspan="2">도매업자<span class="red">*</span></th>
							<td>
								<div class="row">
									    <div class="col">
											<div class="tit" id="whsl_se_cd"></div><!--   도매업자구분 -->
											<div class="box">
												<select id="BIZR_TP_CD" style="width: 179px" ></select>
											</div>
										</div> 
										<div class="col">
											<div class="tit" id="enp_nm"></div> <!--  도매업자업체명 -->
											<div class="box"  >
												  <select id="BIZRNM" name="BIZRNM" style="width: 200px"></select>
											</div>
										</div> 
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">지점구분<span class="red">*</span></th>
							<td>
								<div class="row" >
									<label class="rdo"><input type="radio" id="GRP_YN" name="GRP_YN" value="Y" checked="checked"><span>총괄지점</span></label>
									<label class="rdo"><input type="radio" id="GRP_YN" name="GRP_YN" value="N"><span>지점</span></label>
								</div>
							</td>
						</tr>
						<tr class="grpY" style="display:none">
							<th colspan="2">관리지점<span class="red">*</span></th>
							<td>
								<div class="row">
									<select id="GRP_BRCH_NO" name="GRP_BRCH_NO" style="width: 210px" ></select>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">지점명<span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="BRCH_NM" name="BRCH_NM" style="width: 330px;" class="i_notnull" alt="지점명" maxByteLength="90">
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">지점코드<span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="BRCH_NO" name="BRCH_NO" style="width: 330px;" class="i_notnull" alt="지점코드" maxlength="10" format="engNum">
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">지역<span class="red">*</span></th>
							<td>
								<div class="row">
									<select id="AREA_CD" name="AREA_CD" style="width: 210px" class="i_notnull" alt="지역" ></select>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">소속단체<span class="red">*</span></th>
							<td>
								<div class="row">
									<select id="AFF_OGN_CD" name="AFF_OGN_CD" style="width: 210px" class="i_notnull" alt="소속단체" ></select>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">수납관리구분<span class="red">*</span></th>
							<td>
								<div class="row" >
									<label class="rdo"><input type="radio" id="ACP_MGNT_YN" name="ACP_MGNT_YN" value="N" checked="checked"><span>본사관리</span></label>
									<label class="rdo"><input type="radio" id="ACP_MGNT_YN" name="ACP_MGNT_YN" value="Y"><span>수납관리</span></label>
								</div>
							</td>
						</tr>
						<tr class="payExecY" style="display:none">
							<th colspan="2">수납 계좌번호<span class="red" class="bizrSeCdH">*</span></th>
							<td>
								<div class="row">
									<select id="ACP_BANK_CD_SEL" name="ACP_BANK_CD_SEL" style="width: 100px;">
									</select>
									<input type="text" id="ACP_ACCT_NO" name="ACP_ACCT_NO" format="number" style="width: 179px;" maxlength="20" alt="수납계좌번호">
									<span class="notice">계좌번호는 '-'없이 숫자만 입력 가능합니다.</span>
								</div>
							</td>
						</tr>
						<tr class="payExecY" style="display:none">
							<th colspan="2">수납 계좌 예금주명<span class="red" class="bizrSeCdH">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="ACP_ACCT_DPSTR_NM" name="ACP_ACCT_DPSTR_NM" style="width: 179px;" readonly="readonly">
									<button type="button" id="chk2" class="btn34 c6" style="width: 92px;">예금주 확인</button>
									<div class="chkbox" style="padding-top:8px">
										<label class="chk">
											<input type="checkbox" id="ACCT_CHECK_YN" name="ACCT_CHECK_YN" disabled><span></span>
										</label>
									</div>
								</div>
							</td>
						</tr>
						<tr  class="payExecY" style="display:none">
							<th colspan="2">대표 이메일<span class="red" class="bizrSeCdH">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="EMAIL1" name="EMAIL1" style="width: 100px;" alt="이메일" maxlength="30">
									<div class="sign">@</div>
									<input type="text" id="EMAIL2" name="EMAIL2" style="width: 100px;" alt="이메일" maxlength="30">
									<select id="DOMAIN" name="DOMAIN" style="width: 130px;">
										<option id="drct_input" value=""></option>
									</select>
									<input type="hidden" id="EMAIL" name="EMAIL" style="width: 100px;">
								</div>
							</td>
						</tr>
						<tr class="payExecY" style="display:none">
							<th colspan="2">대표 전화번호<span class="red" class="bizrSeCdH">*</span></th>
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
						<tr class="payExecY" style="display:none">
							<th colspan="2" rowspan="2">사업장주소<span class="red" class="bizrSeCdH">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="PNO" name="PNO" style="width: 179px;" alt="우편번호" readonly="readonly">
									<button type="button" id="btnPopZip" class="btn34 c6" style="width: 122px;">우편번호 검색</button>
								</div>
							</td>
						</tr>
						<tr class="payExecY" style="display:none">
							<td>
								<div class="row">
									<input type="text" id="ADDR1" name="ADDR1" style="width: 330px;" maxByteLength="500" alt="사업장주소">
									<input type="text" id="ADDR2" name="ADDR2" style="width: 330px; margin-left: 5px !important;" placeholder="상세주소입력" maxByteLength="500" alt="사업장 상세주소">
								</div>
							</td>
						</tr>
					</table>
				</div>
				</form>
				
				
				
			</div>
			
		</section>
		
		<div class="btnwrap mt10">
			<div class="fl_r" id="BR">
			</div>
		</div>
		
	</div>



</body>
</html>