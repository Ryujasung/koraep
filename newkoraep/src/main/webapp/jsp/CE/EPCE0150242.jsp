<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">

	var INQ_PARAMS;
	var searchDtl;
	
	$(function(){
		
		INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
		searchDtl = jsonObject($('#searchDtl').val());
		
		$('#title_sub').text('<c:out value="${titleSub}" />');
		
		fn_btnSetting();

	    var area_cd_list 	= jsonObject($('#area_cd_list').val());
 		kora.common.setEtcCmBx2(area_cd_list, "","", $("#AREA_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');				//지역
		
 		//var BankCdList = jsonObject($('#BankCdList').val());
		//kora.common.setEtcCmBx2(BankCdList, "", "", $("#ACP_BANK_CD_SEL"), "ETC_CD", "ETC_CD_NM", "N", "S");
 		
 		kora.common.setMailArrCmBx("", $("#DOMAIN"));	//메일도메인
 		kora.common.setTelArrCmBx("", $("#RPST_TEL_NO1")); //전화번호 국번
 		$('#drct_input').text(parent.fn_text('drct_input'));
		$('#cho1').text(parent.fn_text('cho'));
		
 		$('[name=GRP_YN]').change(function() {

 			if($("input:radio[name='GRP_YN']:checked").val() == 'N'){

 				var url = "/CE/EPCE0150231_19.do" 
				var input ={};
			    input["BIZRID_NO"] = searchDtl.BIZRID + ';' + searchDtl.BIZRNO;

	       	    ajaxPost(url, input, function(rtnData) {
	   				if ("" != rtnData && null != rtnData) {   
	   					kora.common.setEtcCmBx2(rtnData.grpList, "","", $("#GRP_BRCH_NO"), "BRCH_NO", "BRCH_NM", "N" ,'S');
	   				} else {
	   					alertMsg("error");
	   				}
	    		}, false);
 				
                $('.grpY').attr('style', '');
            }
 			else{
                $('.grpY').attr('style', 'display:none');
            }
 			
            if(kora.common.null2void(searchDtl.BRCH_BIZRNO) == "") {
                if("M1" == searchDtl.BIZRID.substring(0,2)) {
                    $("#BIZRNO1").addClass('i_notnull');
                    $("#BIZRNO2").addClass('i_notnull');
                    $("#BIZRNO3").addClass('i_notnull');
                }
                else {
                    $("#BIZRNO1").removeClass('i_notnull');
                    $("#BIZRNO2").removeClass('i_notnull');
                    $("#BIZRNO3").removeClass('i_notnull');
                }
            }
            else {
                $("#BIZRNO1").removeClass('i_notnull');
                $("#BIZRNO2").removeClass('i_notnull');
                $("#BIZRNO3").removeClass('i_notnull');
    
                $("#bizrnoChk").attr('style', 'display:none');
                $("#DUPLE_CHECK_YN2").val("Y");
                $("#USE_ABLE_YN2").val("Y");
                
                $("#BIZRNO1").attr('readonly','readonly');
                $("#BIZRNO2").attr('readonly','readonly');
                $("#BIZRNO3").attr('readonly','readonly');
            }
 			
 			fn_bizrnm_change();
 			
 			window.frameElement.style.height = $('.iframe_inner').height()+5+'px';
 		});
 		
 		//등록 버튼
		$("#btn_reg").click(function(){
			fn_reg();
		});
 		
		//취소
		$("#btn_cnl").click(function(){
			fn_cnl();
		});
		
		if(searchDtl != null){
			
			$('#BIZRNM').text(searchDtl.BIZRNM);
			
			var grpYn = searchDtl.GRP_YN;
			
			$(":radio[name='GRP_YN'][value='"+grpYn+"']").prop("checked", true);

			$('[name=GRP_YN]').change();
			
			$("#GRP_BRCH_NO").val(searchDtl.GRP_BRCH_NO);
			$('#BRCH_NO_TXT').text(searchDtl.BRCH_NO);
			
			//데이터 셋팅
			var data = searchDtl;
			$('.row > input').each(function(){
				/* $(this).val(eval('data.'+$(this).attr('id'))); */
				    $(this).val(data[$(this).attr('id')]);
				//취약점점검 5823 기원우 
			});
			$('.row > select').each(function(){
				/* $(this).val(eval('data.'+$(this).attr('id'))); */
			    $(this).val(data[$(this).attr('id')]);
				//취약점점검 5824 기원우				
			});
			
			$(":radio[name='PAY_EXEC_YN'][value='"+searchDtl.PAY_EXEC_YN+"']").prop("checked", true);
			
			if(searchDtl.PAY_EXEC_YN == 'Y'){
				$('#ACCT_CHECK_YN').prop("checked", true);
			}else{
				$('.payExecY').hide();
			}
			
			$('#BIZRID').val(searchDtl.BIZRID);
			$('#BIZRNO').val(searchDtl.BIZRNO);
			$('#BRCH_ID').val(searchDtl.BRCH_ID);
			$('#BRCH_NO').val(searchDtl.BRCH_NO);
			$('#PAY_EXEC_BIZRID').val(searchDtl.PAY_EXEC_BIZRID);
			$('#PAY_EXEC_BIZRNO').val(searchDtl.PAY_EXEC_BIZRNO);
            $("#BIZRNO1").val(searchDtl.BIZRNO1);
            $("#BIZRNO2").val(searchDtl.BIZRNO2);
            $("#BIZRNO3").val(searchDtl.BIZRNO3);

		}
		
		$('[name=PAY_EXEC_YN]').change(function(){

			if($("input:radio[name='PAY_EXEC_YN']:checked").val() == 'Y'){
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

        /**
         * 사업자번호 중복체크
         */
         $("#bizrnoChk").click(function(){
             fn_bizrnoCheck();
         });
        
         fn_bizrnm_change();
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
        
        var sData = {};
        sData["BRCH_NO"] = BIZRNO;
        sData["BIZRID_NO"] = searchDtl.BIZRID + ';' + searchDtl.BIZRNO;
        
        var url = "/CE/EPCE0150231_3.do";
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
	
	//취소
	function fn_cnl(){
		kora.common.goPageB('', INQ_PARAMS);
	}

	//저장
	function fn_reg(){

		if(!kora.common.cfrmDivChkValid("frmMenu")) {
			return;
		}
				
		var BIZRNO = $("#BRCH_NO").val();
		
		if($(':radio[name=GRP_YN]:checked').val() == 'N'){
			if($('#GRP_BRCH_NO').val() == ''){
				alertMsg('관리직매장을 선택하세요.');
				return;
			}

            if("M1" == searchDtl.BIZRID.substring(0,2)) {
    
        	    BIZRNO = $("#BIZRNO1").val() + "" + $("#BIZRNO2").val() + "" + $("#BIZRNO3").val();
            	
        	    if(kora.common.null2void(searchDtl.BRCH_BIZRNO) == "") { 
                    if($("#BIZRNO1").val() == '' || $("#BIZRNO2").val() == '' || $("#BIZRNO3").val() == ''){
                        alertMsg('사업자번등록번호를 확인하세요.');
                        return;
                    }
                    //사업자번호 체크
                    if(!kora.common.gfn_bizNoCheck(BIZRNO)){
                        alertMsg("유효하지 않은 사업자번호 입니다.");
                        return false;
                    }
                    
                    if($("#DUPLE_CHECK_YN2").val() != "Y"){
                        alertMsg("사업자등록번호 중복체크를 하지 않았습니다.[" + $("#DUPLE_CHECK_YN2").val() + "]");
                        return false;
                    }
                    
                    if($("#USE_ABLE_YN2").val() != "Y"){
                        alertMsg("사용할 수 없는 사업자등록번호 입니다.\n중복체크 후 사용 하시기 바랍니다.");
                        return false;
                    }
            	}
            }
	    }
	        
        $("#BRCH_BIZRNO").val(BIZRNO);

		
		//지급실행
		if($("input:radio[name='PAY_EXEC_YN']:checked").val() == 'Y'){
			
			if($("#MFC_DPS_VACCT_NO").val() == ""){
				alertMsg("빈용기보증금 가상계좌를 확인하세요.");
				return false;
			}
			if($("#MFC_FEE_VACCT_NO").val() == ""){
				alertMsg("취급수수료 가상계좌를 확인하세요.");
				return false;
			}
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
			
			if(searchDtl.BRCH_NM != $('#BRCH_NM').val()){//명칭 변경
				$('#BRCH_NM_CHANGE_YN').val("Y");
			}
			
		}
		
		confirm('저장하시겠습니까?', 'fn_reg_exec');
	}
	
	function fn_reg_exec(){
		var sData = kora.common.gfn_formData("frmMenu");
	 	var url = "/CE/EPCE0150242_09.do";
	 	ajaxPost(url, sData, function(rtnData){
	 		if ("" != rtnData && null != rtnData) {
				alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
			} else {
				alertMsg("error");
			}
	 	});
	}

    function fn_bizrnm_change() {
        if("M1" == searchDtl.BIZRID.substring(0,2)) {
            $('.grpM1').attr('style', 'display:none');
            $('.grpM2').attr('style', '');
        }
        else {
            $('.grpM1').attr('style', '');
            $('.grpM2').attr('style', 'display:none');
        }
    }
</script>
</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="searchDtl" value="<c:out value='${searchDtl}' />"/>
<input type="hidden" id="area_cd_list" value="<c:out value='${area_cd_list}' />"/>
<input type="hidden" id="BankCdList" value="<c:out value='${BankCdList}' />"/>	    

	<div class="iframe_inner">
		<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
		</div>
		
		<section class="secwrap">
			<div class="write_area" id='div_input'>
				<form name="frmMenu" id="frmMenu" method="post" >
				
				<input type="hidden" id="BIZRID" name="BIZRID"/>
				<input type="hidden" id="BIZRNO" name="BIZRNO"/>
				<input type="hidden" id="BRCH_ID" name="BRCH_ID"/>
				<input type="hidden" id="BRCH_NO" name="BRCH_NO"/>
				<input type="hidden" id="BRCH_NM_CHANGE_YN" name="BRCH_NM_CHANGE_YN"/>
				
				<input type="hidden" id="PAY_EXEC_BIZRID" name="PAY_EXEC_BIZRID"/>
				<input type="hidden" id="PAY_EXEC_BIZRNO" name="PAY_EXEC_BIZRNO"/>
				
				<div class="write_tbl">
					<table>
						<colgroup>
							<col style="width: 8%;">
							<col style="width: 15%;">
							<col style="width: auto;">
						</colgroup>
						<tr>
							<th colspan="2">생산자명<span class="red">*</span></th>
							<td>
								<div class="row">
									<div class="txtbox" id="BIZRNM" name="BIZRNM"></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">직매장구분<span class="red">*</span></th>
							<td>
								<div class="row" >
									<label class="rdo"><input type="radio" id="GRP_YN" name="GRP_YN" value="Y"><span>총괄직매장</span></label>
									<label class="rdo"><input type="radio" id="GRP_YN" name="GRP_YN" value="N"><span>직매장/공장</span></label>
								</div>
							</td>
						</tr>
						<tr class="grpY" >
							<th colspan="2">관리직매장<span class="red">*</span></th>
							<td>
								<div class="row">
									<select id="GRP_BRCH_NO" name="GRP_BRCH_NO" style="width: 210px" ></select>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">직매장/공장명<span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="BRCH_NM" name="BRCH_NM" style="width: 330px;" class="i_notnull" alt="직매장/공장명" maxByteLength="90">
								</div>
							</td>
						</tr>
                        <tr class="grpM1">
                            <th colspan="2">직매장/공장코드<span class="red">*</span></th>
                            <td>
                                <div class="row">
                                    <div class="txtbox" id="BRCH_NO_TXT" name="BRCH_NO_TXT"></div>&nbsp;
                                </div>
                            </td>
                        </tr>
                        <tr class="grpM2">
                            <th colspan="2">사업자번호<span class="red">*</span></th>
                            <td>
                                <div class="row">
                                    <input type="text" id="BIZRNO1" name="BIZRNO1" style="width: 100px;" maxlength="3" class="i_notnull" alt="사업자등록번호" format="number">
                                    <div class="dash">-</div>
                                    <input type="text" id="BIZRNO2" name="BIZRNO2" style="width: 100px;" maxlength="2" class="i_notnull" alt="사업자등록번호" format="number">
                                    <div class="dash">-</div>
                                    <input type="text" id="BIZRNO3" name="BIZRNO3" style="width: 100px;" maxlength="5" class="i_notnull" alt="사업자등록번호" format="number">
                                    <button type="button" id="bizrnoChk" class="btn34 c6" style="width: 92px;">중복확인</button>
                                    <input type="hidden" name="DUPLE_CHECK_YN2" id="DUPLE_CHECK_YN2"/>
                                    <input type="hidden" name="USE_ABLE_YN2" id="USE_ABLE_YN2"/>
                                    <input type="hidden" name="BRCH_BIZRNO" id="BRCH_BIZRNO"/>
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
						<tr style="display:none">
							<th colspan="2">지급실행구분<span class="red">*</span></th>
							<td>
								<div class="row" >
									<label class="rdo"><input type="radio" id="PAY_EXEC_YN" name="PAY_EXEC_YN" value="N" checked="checked"><span>본사관리</span></label>
									<label class="rdo"><input type="radio" id="PAY_EXEC_YN" name="PAY_EXEC_YN" value="Y"><span>지급실행</span></label>
								</div>
							</td>
						</tr>
						<tr class="payExecY" >
							<th colspan="2">빈용기보증금 가상계좌<span class="red" class="bizrSeCdH">*</span></th>
							<td>
								<div class="row">
									<div class="txt" id="BANKCD1">신한은행</div>
									<input type="text" id="MFC_DPS_VACCT_NO" name="MFC_DPS_VACCT_NO" style="width: 179px;" maxlength="20" format="number" alt="빈용기보증금 가상계좌">
								</div>
							</td>
						</tr>
						<tr class="payExecY" >
							<th colspan="2">취급수수료 가상계좌<span class="red" class="bizrSeCdH">*</span></th>
							<td>
								<div class="row">
									<div class="txt" id="BANKCD2">신한은행</div>
									<input type="text" id="MFC_FEE_VACCT_NO" name="MFC_FEE_VACCT_NO" style="width: 179px;" maxlength="20" format="number"  alt="취급수수료 가상계좌">
								</div>
							</td>
						</tr>
						<tr class="payExecY" >
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
						<tr class="payExecY" >
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
						<tr  class="payExecY" >
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
						<tr class="payExecY" >
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
						<tr class="payExecY" >
							<th colspan="2" rowspan="2">사업장주소<span class="red" class="bizrSeCdH">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="PNO" name="PNO" style="width: 179px;" alt="우편번호" readonly="readonly">
									<button type="button" id="btnPopZip" class="btn34 c6" style="width: 122px;">우편번호 검색</button>
								</div>
							</td>
						</tr>
						<tr class="payExecY" >
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