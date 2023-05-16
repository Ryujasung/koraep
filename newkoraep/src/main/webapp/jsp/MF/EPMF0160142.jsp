<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Insert title here</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<!-- 전자인증 모듈 설정 //-->
<link rel="stylesheet" type="text/css" href="/CC_WSTD_home/unisignweb/rsrc/css/certcommon.css?v=1" />
<script type="text/javascript" src="/CC_WSTD_home/unisignweb/js/unisignwebclient.js?v=1"></script>
<script type="text/javascript" src="/ccc-sample-wstd/UniSignWeb_Multi_Init_Nim.js?v=1"></script>
<!-- 전자인증 모듈 설정 //-->

<script type="text/javaScript" language="javascript" defer="defer">
		
		var INQ_PARAMS;
		var searchDtl;
		var reFile;
		
		$(document).ready(function(){
			
			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			searchDtl = jsonObject($('#searchDtl').val());
			reFile = "N";
			
			 var parent_item;
			/**
			 * 우편번호검색 버튼 클릭 이벤트
			 */
			$("#btnPopZip").click(function(){
				var pagedata = window.frameElement.name;
				window.parent.NrvPub.AjaxPopup('/SEARCH_ZIPCODE_POP.do', pagedata);
			});
			
			fn_btnSetting();
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			$('#bizr_nm').text(parent.fn_text('bizr_nm'));
			$('#bizrno').text(parent.fn_text('bizrno'));
			$('#brch').text(parent.fn_text('brch'));
			$('#dept').text(parent.fn_text('dept'));
			$('#user_nm').text(parent.fn_text('user_nm'));
			$('#id').text(parent.fn_text('id'));
			$('#email').text(parent.fn_text('email'));
			$('#tel_no').text(parent.fn_text('tel_no'));
			$('#tel_no2').text(parent.fn_text('tel_no'));
			$('#mbil_tel_no').text(parent.fn_text('mbil_tel_no'));
			$('#use_ath').text(parent.fn_text('use_ath'));
			$('#user_stat').text(parent.fn_text('user_stat'));
			
			$('#BIZRNM').attr('alt', parent.fn_text('bizr_nm'));
			$('#PNO').attr('alt', parent.fn_text('pno'));
			$('#FILE_NM').attr('alt', parent.fn_text('bizr_license'));
			$('#CTRT_FILE_NM').attr('alt', parent.fn_text('mfc_bizr_contract'));
			
			$('#ASTN_EMAIL_TXT').attr('alt', parent.fn_text('email'));
			$('#ASTN_DOMAIN_TXT').attr('alt', parent.fn_text('email'));
			
			/**
			 * 저장버튼 클릭 이벤트
			 */
			$("#btn_reg").click(function(){
				
//		 		if(!confirm("사업자 정보를 등록하시겠습니까?")) return;
				//fn_reg();
				fn_reg_cnk();
// 				console.log($("#BIZRNO").val());
			});
			
			/**
			 * 취소버튼 클릭 이벤트
			 */
			$("#btn_cncl").click(function(){
				fn_cncl();
			});
			
			/**
			  * 예금주 중복체크
			  */
			 $("#chk2").click(function(){
				 fn_acctCheck();
			 });
			
			/**
			 * 은행, 계좌변경시 체크값 초기화
			 */
			$("#AcpBankCdList_SEL, #ACP_ACCT_NO").bind("change", function(){
				$(":checkbox[name='ACCT_CHECK_YN']").prop("checked", false);
				$("#ACP_ACCT_DPSTR_NM").val("");
			});
			
			/**
			 * 보조 이메일 도메인 변경 이벤트
			 */
			$("#ASTN_DOMAIN").change(function(){
				
				$("#ASTN_DOMAIN_TXT").val(kora.common.null2void($(this).val()));
				
				if(kora.common.null2void($(this).val()) != "") 
					$("#ASTN_DOMAIN_TXT").attr("disabled",true);
				else
					$("#ASTN_DOMAIN_TXT").attr("disabled",false);
			});
			
			//콤보박스 세팅
			kora.common.setMailArrCmBx("", $("#ASTN_DOMAIN"));	//보조메일도메인
			kora.common.setTelArrCmBx("", $("#RPST_TEL_NO1"));		//전화번호 국번
			kora.common.setTelArrCmBx("", $("#FAX_NO1"));	//핸드폰 국번
			$('#drct_input').text(parent.fn_text('drct_input'));
			$('#cho1').text(parent.fn_text('cho'));
			$('#cho2').text(parent.fn_text('cho'));
			
			fnSetDtlData(searchDtl);

		});
		
		/**
		 * 계좌인증 - 예금주확인
		 */
		function fn_acctCheck(){
			var bankCd  = $("#AcpBankCdList_SEL option:selected").val();
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
			
			var flag = true;
			/*
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
//	 					if(!flag || dpstrNm.substring(0, str.length) == str){//개발
//	 						$(":checkbox[name='ACCT_CHECK_YN']").prop("checked", true);
//	 						$("#ACP_ACCT_DPSTR_NM").val(str);
//	 						alertMsg("예금주 정보가 확인되었습니다.");
//	 						return;
//	 					}
//	 					else{
//	 						alertMsg("예금주명이 일치하지 않습니다.");
//	 					} 
					});
				}
			});
		}
		
		function fn_reg_cnk() {
	        fn_reg();
	    }
		
		//저장
		function fn_reg(){
			
			if(searchDtl.BIZR_SE_CD == 'S'){
				if(!kora.common.cfrmDivChkValid("fileForm")) {
					return;
				}
				
				if(searchDtl.BIZR_TP_CD == 'M1' || searchDtl.BIZR_TP_CD == 'M2'){
		    	    if($("#MFC_DPS_VACCT_NO").val() == ""){
						alertMsg("빈용기보증금 가상계좌를 확인하세요.");
						return false;
					}
					if($("#MFC_FEE_VACCT_NO").val() == ""){
						alertMsg("취급수수료 가상계좌를 확인하세요.");
						return false;
					}
		      }

				//도매업자/공병상 수납계좌 예금주 확인 여부 체크
				var flag = true;
				//if(location.href.indexOf("localhost") > -1 || location.href.indexOf("devreuse") > -1) flag = false;
				if(flag == true){
					//if($(":radio[name=BIZR_SE_CD]:checked").val() == "C" || $(":radio[name=BIZR_SE_CD]:checked").val() == "D"){
						if(!$(":checkbox[name='ACCT_CHECK_YN']").prop("checked")){
							alertMsg("예금주 확인을 하지 않았습니다.");
							return false;
						}
					//}
				}
				
				//사업자명, 업종, 업태, 대표자명, 주소 변경시
				if(
					$("#BIZRNM").val() != kora.common.null2void(searchDtl.BIZRNM) 
					|| $("#TOB_NM").val() != kora.common.null2void(searchDtl.TOB_NM)
					|| $("#BCS_NM").val() != kora.common.null2void(searchDtl.BCS_NM) 
					|| $("#RPST_NM").val() != kora.common.null2void(searchDtl.RPST_NM) 
					|| $("#PNO").val() != kora.common.null2void(searchDtl.PNO) 
					|| $("#ADDR1").val() != kora.common.null2void(searchDtl.ADDR1) 
					|| $("#ADDR2").val() != kora.common.null2void(searchDtl.ADDR2) 
				){
	                if(reFile != "Y" || $("#FILE_NM").val() == null || $("#FILE_NM").val() == "" || $("#FILE_NM").val() == " ") {
	                    alertMsg("사업자정보 변경시, 사업자 등록증 첨부는 필수입니다.");
	                    return;
	                }
				}
				
			}else{
				if($("#BIZRNM").val() == '' ){
					alertMsg('사업자명을 확인하세요.');
					return;
				}
			}
			
			if($.trim($("#ASTN_EMAIL_TXT").val()) !="" || $.trim($("#ASTN_DOMAIN_TXT").val()) != ""){
				//이메일 유효성 체크
				var regExp = /[0-9a-zA-Z][_0-9a-zA-Z-]*@[_0-9a-zA-Z-]+(\.[_0-9a-zA-Z-]+){1,2}$/;
				var emailAddr = $.trim($("#ASTN_EMAIL_TXT").val()) +"@"+ $.trim($("#ASTN_DOMAIN_TXT").val());
				if (!emailAddr.match(regExp)){
					alertMsg("이메일 형식에 맞지 않습니다.");
					return false;
				}
			}
			
			//범용인증서 인증
	        if($(":radio[name='SIGN_GUBN']:checked").val() == "1"){
	            fn_certiSubmit();
	        }
	        //휴대폰 인증
	        else{
	            fn_phoneCert();
	        }
			
		}
		
		function fn_reg_confirm(){
			confirm("저장하시겠습니까?", "fn_reg_exec");
		}
		
		function fn_reg_exec(){
			
			if($.trim($("#ASTN_EMAIL_TXT").val()) !="" && $.trim($("#ASTN_DOMAIN_TXT").val()) != ""){
				$('#ASTN_EMAIL').val($.trim($("#ASTN_EMAIL_TXT").val()) +"@"+ $.trim($("#ASTN_DOMAIN_TXT").val()));
			}
			
			//var sData = kora.common.gfn_formData("fileForm");
			var sData = ''; //폼데이터로 전송함

			if(searchDtl.BIZRNM != $("#BIZRNM").val()){// 사업자명 변경
				$('#BIZRNM_CHANGE_YN').val('Y');
			}
			
			if(searchDtl.RPST_NM != $("#RPST_NM").val()){// 대표자명 변경
	            $('#RPST_NM_CHANGE_YN').val('Y');
	        }
			
		 	var url = "/CE/EPCE0160142_21.do";
		 	fileajaxPost(url, sData, function(rtnData){
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
		
		function fn_cncl(){
			kora.common.goPageB('', INQ_PARAMS);
		}
		
		/**
		  * 상세 데이터 셋팅
		  */
		 function fnSetDtlData(data){
			
			 if(data.BIZR_TP_CD == 'M1' || data.BIZR_TP_CD == 'M2'){
	    		  $('.bizrTpCdM').each(function(){
	    			  $(this).attr('style', '');
	    		  });
		      }else{
	    		  $('.bizrTpCdM').each(function(){
	    			  $(this).attr('style', 'display:none');
	    		  });
		      }
			 
			 $("#BIZRID").val(kora.common.null2void(data.BIZRID));
			 $("#BIZRNO").val(kora.common.null2void(data.BIZRNO));
			 $("#BIZRNO_DE").val(kora.common.null2void(data.BIZRNO_DE));
			 
		 	//화면상세
			//$("#BIZRNM").text(kora.common.null2void(data.BIZRNM)+"\u00A0\u00A0\u00A0["+parent.fn_text('bizr_tp')+" : "+kora.common.null2void(data.BIZR_TP_NM)+"]");
		 	
			$("#BIZRNO_TXT").text(kora.common.setDelim(data.BIZRNO_DE,"999-99-99999"));
			
			var BankCdList = jsonObject($('#BankCdList').val());
			kora.common.setEtcCmBx2(BankCdList, "", "", $("#AcpBankCdList_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
			
			if(data.BIZR_TP_CD == 'T1'){ //센터
				$("#BRCH_NM").text(kora.common.null2void(data.CET_BRCH_NM));
			}else{
				$("#BRCH_NM").text(kora.common.null2void(data.BRCH_NM));
			}
			$("#BIZR_STAT_CD").text(kora.common.null2void(data.BIZR_STAT_NM));
			$("#BIZRNM").val(kora.common.null2void(data.BIZRNM));
			$("#BIZR_TP_CD").text(kora.common.null2void(data.BIZR_TP_NM));
			$("#BIZR_SE_CD").text(kora.common.null2void(data.BIZR_SE_NM));
			$("#TOB_NM").val(kora.common.null2void(data.TOB_NM));
			$("#BCS_NM").val(kora.common.null2void(data.BCS_NM));
			$("#RPST_NM").text(kora.common.null2void(data.RPST_NM));
			$("#RPST_NM").val(kora.common.null2void(data.RPST_NM));
			$("#ADMIN_NM").text(kora.common.null2void(data.USER_NM));
			$("#ADMIN_ID").text(kora.common.null2void(data.ADMIN_ID));
			
			$("#MFC_DPS_VACCT_NO").val(kora.common.null2void(data.MFC_DPS_VACCT_NO));
			$("#MFC_FEE_VACCT_NO").val(kora.common.null2void(data.MFC_FEE_VACCT_NO));
			$("#DEPT_NM").text(kora.common.null2void(data.DEPT_NM));
			$("#USER_NM").text(kora.common.null2void(data.USER_NM));
			$("#USER_ID").text(kora.common.null2void(data.USER_ID));
			//$("#EMAIL").text(kora.common.null2void(data.EMAIL));
			
			var astnEmail = kora.common.null2void(data.ASTN_EMAIL);
			var astnEmail2 = astnEmail.split('@');
			$("#ASTN_EMAIL_TXT").val(astnEmail2[0]);
			$("#ASTN_DOMAIN_TXT").val(astnEmail2[1]);
			
			$("#TEL_NO").text(kora.common.null2void(data.TEL_NO));
			$("#MBIL_NO").val(kora.common.null2void(data.MBIL_NO1)+kora.common.null2void(data.MBIL_NO2)+kora.common.null2void(data.MBIL_NO3));
			$("#ATH_GRP_NM").text(kora.common.null2void(data.ATH_GRP_NM));
			$("#USER_STAT_NM").text(kora.common.null2void(data.USER_STAT_NM));
			$("#CNTR_DT").val(kora.common.setDelim(data.CNTR_DT, '9999-99-99'));
			
			$("#PNO").val(kora.common.null2void(data.PNO));
			$("#ADDR1").val(kora.common.null2void(data.ADDR1));
			$("#ADDR2").val(kora.common.null2void(data.ADDR2));
			
			$("#AcpBankCdList_SEL").val(kora.common.null2void(data.ACP_BANK_CD));
			$("#ACP_ACCT_NO").val(kora.common.null2void(data.ACP_ACCT_NO));
			$("#ACP_ACCT_DPSTR_NM").val(kora.common.null2void(data.ACP_ACCT_DPSTR_NM));
			
			if($("#ACP_ACCT_DPSTR_NM").val() != ''){
				$(":checkbox[name='ACCT_CHECK_YN']").prop("checked", true);
			}
			
			$('#RPST_TEL_NO1').val(kora.common.null2void(data.RPST_TEL_NO1));
			$('#RPST_TEL_NO2').val(kora.common.null2void(data.RPST_TEL_NO2));
			$('#RPST_TEL_NO3').val(kora.common.null2void(data.RPST_TEL_NO3));
			$('#FAX_NO1').val(kora.common.null2void(data.FAX_NO1));
			$('#FAX_NO2').val(kora.common.null2void(data.FAX_NO2));
			$('#FAX_NO3').val(kora.common.null2void(data.FAX_NO3));
			
			$("#FILE_NM_V").val(kora.common.null2void(data.FILE_NM));
	        fnDrawAttFile(data, "1");
	        fnDrawAttFile(data, "2");
		 }
		
	    /**
	      * 첨부파일 다운로드 링크생성
	      */
	    function fnDrawAttFile(data, gubun){
	        if(gubun == "2"){
	            if(kora.common.null2void(data.CTRT_SAVE_FILE_NM) != ""){
	                $("#SPAN_CTRT_FILE_DOWN").html("<a href='javascript:fnFileDown(\""+data.CTRT_SAVE_FILE_NM+"\",\""+data.CTRT_FILE_NM+"\")'><span class='btn34 c6'>다운로드</span></a>");
	            }
	        }
	        else{
	            if(kora.common.null2void(data.SAVE_FILE_NM) != ""){
	                $("#SPAN_FILE_DOWN").html("<a href='javascript:fnFileDown(\""+data.SAVE_FILE_NM+"\",\""+data.FILE_NM+"\")'><span class='btn34 c6'>다운로드</span></a>");
	            }
	        }
	    }
	     
	     /**
	      * 첨부파일 다운로드
	      */
	    function fnFileDown(fileNm,saveFileNm){
	        frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
	        frm.fileName.value = fileNm;
	        frm.saveFileName.value = saveFileNm;
	        frm.submit();
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
		        else {
		            $("#"+sItem+"_V").val($("#"+sItem).val());
		            
		            if(gubn == "1") {
		                reFile = "Y";
		            }
		        }
			}
		 
			/**
		     * 인증서 제출
		     */
		    function fn_certiSubmit(){
		        ////////////// 전자서명 초기값세팅 /////////////////////////
		        var ssn = $("#BIZRNO_DE").val();
		        var plainText = ssn + "|" + $("#CNTR_DT").val();
		        $("#ssn").val(ssn);
		        $("#plainText").val(plainText);
		        /////////////////////////////////////////////////////////

		        //암호화된 전자서명 값 및 인증서 추출정보 받기
		        unisign.SignDataNVerifyVID( plainText, null, ssn, function(rv, signedText, certAttrs){
		            if(signedText == null || signedText == '' || false === rv){
		                unisign.GetLastError(function(errCode, errMsg){
		                    //alert('전자서명 실패 : ' + errMsg + '\nError code : ' + errCode );
		                    alertMsg('전자서명에 실패하였습니다. 올바른 사업자 인증서를 사용하십시오.\nError code : ' + errCode );
		                    return;
		                });
		            } else {
		                $("#signedText").val(signedText);
		                $("#certAttrstxt").val(certAttrs.subjectName);
		                fn_sendCert();
		            }
		        });
		    }
		    
		    /**
		     * 전자서명 검증
		     */
		    function fn_sendCert(){
		        if($("#signedText").val() == null || $("#signedText").val() == ""){
		            alertMsg("올바른 전자서명값이 없습니다.");
		            return;
		        }
		        
		        document.frmCert.target = "ifrCerti";
		        document.frmCert.action = "/EP/EPCE00852882.do" + "?_csrf=<c:out value='${_csrf.token}' />";
		        document.frmCert.submit();  //전자서명 검증
		    }
		    
		    /**
		     * 전자서명 인증서 검증결과
		     */
		    function fn_certiResult(cd, msg){
		        if(msg != ""){
		            alertMsg("[" + cd + "]" + msg);
		            return;
		        }
		        
		        fn_reg_confirm();
		    }
		    
		    /**
		     * 휴대폰 인증구분 임의정의
		     * - 대표자인증 : REPSNT, 관리자 인증 : ADMIN, 패스워드변경 : CNPC  추가정보에서 사용
		     */
		    function fn_phoneCert(div){
		        //$("#CERT_DIV").val("REPSNT");
		        window.open("/EP/EPCE00852883.do"+ "?_csrf=<c:out value='${_csrf.token}' />", "PCERT", "width=450, height=600, left=100, top=30, menubar=no,status=no,toolbar=no, resizable=1");
		    }

		    //휴대폰 인증결과 tf-성공여부, div-넘겨준 CERT_DIV, 이름, 전화번호
		    function fn_kmcisResult(tf, div, name, phoneNum){
			    
			    var mbilno  = $("#MBIL_NO").val();
			    var adminNm = $("#ADMIN_NM").text();
			   
			    if(adminNm != name || mbilno != phoneNum){
		            alertMsg("사업장 관리자와 인증결과값이 일치하지 않습니다.");
			        return;
			    }
			    
			    fn_reg_confirm();
		    }
		 
	</script>

</head>
<body>
<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="searchDtl" value="<c:out value='${searchDtl}' />"/>
<input type="hidden" id="BankCdList" value="<c:out value='${BankCdList}' />"/>
<input type="hidden" id="CNTR_DT" value=""/>
<input type="hidden" id="MBIL_NO" value=""/>

<div class="iframe_inner">
	<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
	</div>
	<section class="secwrap">
		<div class="write_area">
			<div class="write_tbl">
			<form name="fileForm" id="fileForm" method="post" >
				<input type="hidden" id="BIZRID" name="BIZRID"/>
				<input type="hidden" id="BIZRNO" name="BIZRNO"/>
				<input type="hidden" id="BIZRNO_DE" name="BIZRNO_DE"/>
				<input type="hidden" id="BIZRNM_CHANGE_YN" name="BIZRNM_CHANGE_YN"/>
				<input type="hidden" id="RPST_NM_CHANGE_YN" name="RPST_NM_CHANGE_YN"/>
				
				<table>
					<colgroup>
						<col style="width: 8%;">
						<col style="width: 15%;">
						<col style="width: auto;">
					</colgroup>
					<tr>
						<th colspan="2"><span id="bizr_stat_cd" name="bizr_stat_cd">상태</span></th>
						<td>
							<div class="row">
								<div class="txtbox" id="BIZR_STAT_CD" name="BIZR_STAT_CD">
<!-- 									<div class="emp">활동 / 비활동 / 수기 / (지급지점)</div> -->
								</div><p>/</p>
								<div class="txtbox" id="BIZR_SE_CD" name="BIZR_STAT_CD">
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="bizr_tp_cd" name="bizr_tp_cd">사업자유형</th>
						<td>
							<div class="row">
								<div class="txtbox" id="BIZR_TP_CD" name="BIZR_TP_CD"></div>    <!-- 도매업자 / 공병상 / 생산자 / 소매업자 -->
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="bizrnm" name="bizrnm">사업자명<span class="red" class="bizrSeCdH">*</span></th>
						<td>
							<div class="row">
								<input type="text" id="BIZRNM" name="BIZRNM" style="width: 330px;" class='i_notnull' maxByteLength="30"/>
								<span class="notice">사업자명은 30자까지 입력 가능합니다.</span>
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="bizr_no" name="bizr_no">사업자등록번호</th>
						<td>
							<div class="row">
								<div class="txtbox" id="BIZRNO_TXT" ></div>
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="tob_nm" name="tob_nm">업종<span class="red" class="bizrSeCdH">*</span></th>
						<td>
							<div class="row">
								<input type="text" id="TOB_NM" name="TOB_NM" style="width:330px;" class='i_notnull' maxByteLength="30" alt="업종"/>
								<span class="notice">업종명은 30자까지 입력 가능합니다.</span>
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="bcs_nm" name="bcs_nm">업태<span class="red" class="bizrSeCdH">*</span></th>
						<td>
							<div class="row">
								<input type="text" id="BCS_NM" name="BCS_NM" style="width:330px;" class='i_notnull' maxByteLength="30" alt="업태"/>
								<span class="notice">업태명은 30자까지 입력 가능합니다.</span>
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="rpst_nm" name="rpst_nm">대표자명<span class="red" class="bizrSeCdH">*</span></th>
						<td>
							<div class="row">
								<input type="text" id="RPST_NM" name="RPST_NM" style="width:330px;" class='i_notnull' maxByteLength="30" alt="대표자명"/>
								<span class="notice">대표자명은 20자까지 입력 가능합니다.</span>
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="admin_nm" name="admin_nm">관리자성명</th>
						<td>
							<div class="row">
								<div class="txtbox" id="ADMIN_NM" name="ADMIN_NM"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="admin_id" name="admin_id">관리자아이디</th>
						<td>
							<div class="row">
								<div class="txtbox" id="ADMIN_ID" name="ADMIN_ID"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr class="bizrTpCdM" style="">
						<th colspan="2">빈용기보증금 가상계좌<span class="red" class="bizrSeCdH">*</span></th>
						<td>
							<div class="row">
								<div class="txt" id="BANKCD1">신한은행</div>
								<input type="text" id="MFC_DPS_VACCT_NO" name="MFC_DPS_VACCT_NO" style="width: 179px;" maxlength="20" format="number" alt="빈용기보증금 가상계좌">
							</div>
						</td>
					</tr>
					<tr class="bizrTpCdM" style="">
						<th colspan="2">취급수수료 가상계좌<span class="red" class="bizrSeCdH">*</span></th>
						<td>
							<div class="row">
								<div class="txt" id="BANKCD2">신한은행</div>
								<input type="text" id="MFC_FEE_VACCT_NO" name="MFC_FEE_VACCT_NO" style="width: 179px;" maxlength="20" format="number"  alt="취급수수료 가상계좌">
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2">수납 계좌번호<span class="red" class="bizrSeCdH">*</span></th>
						<td>
							<div class="row">
								<select id="AcpBankCdList_SEL" name="AcpBankCdList_SEL" style="width: 100px;">
								</select>
								<input type="text" id="ACP_ACCT_NO" name="ACP_ACCT_NO" format="number" style="width: 179px;" maxlength="20" class="i_notnull" alt="수납계좌번호">
								<span class="notice">계좌번호는 '-'없이 숫자만 입력 가능합니다.</span>
							</div>
						</td>
					</tr>
					<tr>
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
					<tr>
						<th colspan="2" id="astn_email" name="astn_email">보조 이메일</th>
						<td>
							<div class="row">
								<input type="text" id="ASTN_EMAIL_TXT" name="ASTN_EMAIL_TXT" style="width: 100px;">
								<div class="sign">@</div>
								<input type="text" id="ASTN_DOMAIN_TXT" name="ASTN_DOMAIN_TXT" style="width: 100px;">
								<select id="ASTN_DOMAIN" name="ASTN_DOMAIN" style="width: 100px;">
									<option id="drct_input" value=""></option>
								</select>
								<input type="hidden" id="ASTN_EMAIL" name="ASTN_EMAIL" style="width: 100px;">
							</div>
						</td>
					</tr>
					<!-- 
					<tr>
						<th colspan="2" id="cntr_dt" name="cntr_dt">약정일자</th>
						<td>
							<div class="row">
								<div class="txtbox" id="CNTR_DT" name="CNTR_DT"></div>
							</div>
						</td>
					</tr>
					 -->
					<tr>
						<th rowspan="2" id="tel_no" name="tel_no">전화번호</th>
						<th class="bd_l" id="rpst_tel_no" name="rest_tel_no">대표 전화번호</th>
						<td>
							<div class="row">
								<select id="RPST_TEL_NO1" name="RPST_TEL_NO1" style="width:80px">
									<option id="cho1" value=""></option>
								</select>
								<div class="dash">-</div>
								<input type="text" id="RPST_TEL_NO2" name="RPST_TEL_NO2" style="width: 100px;">
								<div class="dash">-</div>
								<input type="text" id="RPST_TEL_NO3" name="RPST_TEL_NO3" style="width: 100px;">
							</div>
						</td>
					</tr>
					<tr>
						<th class="bd_l">FAX 전화번호</th>
						<td>
							<div class="row">
								<select id="FAX_NO1" name="FAX_NO1" style="width:80px">
									<option id="cho2" value=""></option>
								</select>
								<div class="dash">-</div>
								<input type="text" id="FAX_NO2" name="FAX_NO2" style="width: 100px;">
								<div class="dash">-</div>
								<input type="text" id="FAX_NO3" name="FAX_NO3" style="width: 100px;">
							</div>
						</td>
					</tr>
<!-- 					<tr> -->
<!-- 						<th colspan="2" id="bizr_issu_key" name="bizr_issu_key">회원발급키</th> -->
<!-- 						<td> -->
<!-- 							<div class="row"> -->
<!-- 								<div class="txtbox" id="BIZR_ISSU_KEY" name="BIZR_ISSU_KEY"></div> -->
<!-- 							</div> -->
<!-- 						</td> -->
<!-- 					</tr> -->
					<tr>
						<th colspan="2" rowspan="2" id="pno" name="pno">사업장주소<span class="red">*</span></th>
						<td>
							<div class="row">
								<input type="text" id="PNO" name="PNO" style="width: 179px; background:#f4f4f4" readonly="readonly" class="i_notnull" alt="우편번호">
								<button type="button" id="btnPopZip" name="btnPopZip" class="btn34 c6" style="width: 122px;">우편번호 검색</button>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div class="row">
								<input type="text" id="ADDR1" name="ADDR1" style="width: 330px;" class="i_notnull" alt="사업장주소">
								<input type="text" id="ADDR2" name="ADDR2" style="width: 330px; margin-left: 5px !important;" placeholder="상세주소입력" alt="사업장주소">
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2">사업자등록증<span class="red">*</span></th>
						<td>
							<div class="row">
                                <div class="btn_box">
<!--                                        <input type="text" id="fileName1" style="width: 330px;"> -->
<!--                                        <label class="btn34 c6" style="width: 92px;"><input type="file" id="FILE_NM" onchange="fn_fileCheck(this.value, '1');">파일첨부</label> -->
                                    <input type="text" class="i_notnull" fieldName="사업자등록증" id="FILE_NM_V" name="FILE_NM_V" background:#f4f4f4" readonly="readonly" style="width:220px">
                                    <label class="btn34 c6"><input type="file" name="FILE_NM" id="FILE_NM" onchange="fn_fileCheck(this.value, '1');">파일첨부</label>
                                    <!--  <input type="file" name="FILE_NM" id="FILE_NM" style="width:305px;" onchange="fn_fileCheck(this.value, '1');" />-->
                                    <span id="SPAN_FILE_DOWN"></span>
                                    <!-- <button type="button" class="btn34 c6" style="width: 92px;" id="FILE_DOWN">다운로드</button> -->
                                </div>
							</div>
						</td>
					</tr>
					<tr class="bizrTpCdM" style="display:none">
						<th colspan="2">생산자계약서</th>
						<td>
							<div class="row">
								<div class="btn_box">
<!-- 										<input type="text" id="fileName2" style="width: 330px;"> -->
<!-- 										<label class="btn34 c6" style="width: 92px;"><input type="file" id="CTRT_FILE_NM" onchange="fn_fileCheck(this.value, '2');">파일첨부</label> -->
									<input type="file" name="CTRT_FILE_NM" id="CTRT_FILE_NM" style="width:305px;" onchange="fn_fileCheck(this.value, '2');" />
                                    <span id="SPAN_CTRT_FILE_DOWN"></span>
									<!-- <button type="button" class="btn34 c6" style="width: 92px;" id="CTRT_FILE_DOWN">다운로드</button> -->
								</div>
							</div>
						</td>
					</tr>
					<tr>
                        <th colspan="2">인증구분<span class="red">*</span></th>
                        <td>
                            <div class="row">
                                <label class="rdo"><input type="radio" id="rdo1" name="SIGN_GUBN" value="1" checked="checked"/><span>범용인증서</span></label>
                                <label class="rdo"><input type="radio" id="rdo2" name="SIGN_GUBN" value="2" /><span>휴대폰인증 (관리자)</span></label>
                            </div>
                        </td>
                    </tr>
				</table>
				</form>
                <form name="frm" action="/jsp/file_down.jsp" method="post">
                    <input type="hidden" name="fileName" value="" />
                    <input type="hidden" name="saveFileName" value="" />
                    <input type="hidden" name="downDiv" value="bizlic" />
                </form>
			</div>
		</div>
	</section>
	<section class="btnwrap mt20" >
			<div class="btnwrap">
				<div class="fl_r" id="BR">
<!-- 					<button type="button" class="btn36 c2" id="btn_cncl" style="width: 178px;">취소</button> -->
<!-- 					<button type="button" class="btn36 c4" id="btn_reg" style="width: 178px;">저장</button> -->
				</div>
			</div>
	</section>
	</div>

    <!-- 전자서명을 위한폼 -->
    <form name="frmCert" onsubmit="return false" method="post">
        <input type="hidden" name="ssn" id="ssn" />                             <!-- 사업자번호 신원확인용 -->
        <input type="hidden" name="plainText" id="plainText" />                 <!-- 전자서명값 원문 : 사업자번호 + | + 현재일자(yyyymmdd) -->
        <input type="hidden" name="signedText" id='signedText' />               <!-- 전자서명값 : 암호화된 값 -->
        <input type="hidden" name="certAttrstxt" id="certAttrstxt" value="" />  <!-- 추출한 인증서 정보 -->
    </form>
    <!-- //전자서명을 위한폼 -->
        
    <!-- 인증서용 -->
    <iframe name="ifrCerti" frameborder="0" width="0" height="0" />

</body>
</html>