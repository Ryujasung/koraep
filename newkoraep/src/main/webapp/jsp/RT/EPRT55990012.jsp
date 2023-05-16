<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>사업자정보조회</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">
		
		var INQ_PARAMS;
		var searchDtl;
		
		$(document).ready(function(){
			
			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			searchDtl = jsonObject($('#searchDtl').val());
			
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
			
			$("#btn_upd").click(function(){
				fn_upd();
			});
			
			fnSetDtlData(searchDtl);
			
		});
		
		//변경화면 이동
		function fn_upd(){
			INQ_PARAMS["URL_CALLBACK"] = "/RT/EPRT55990012.do";
			kora.common.goPage('/RT/EPRT55990422.do', INQ_PARAMS);
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
			
		 	//화면상세
			$("#BIZRNM").text(kora.common.null2void(data.BIZRNM)+"\u00A0\u00A0\u00A0["+parent.fn_text('bizr_tp')+" : "+kora.common.null2void(data.BIZR_TP_NM)+"]");
		 	
			$("#BIZRNO").text(kora.common.setDelim(data.BIZRNO_DE,"999-99-99999"));
			
			if(data.BIZR_TP_CD == 'T1'){ //센터
				$("#BRCH_NM").text(kora.common.null2void(data.CET_BRCH_NM));
			}else{
				$("#BRCH_NM").text(kora.common.null2void(data.BRCH_NM));
			}
			$("#BIZR_STAT_CD").text(kora.common.null2void(data.BIZR_STAT_NM));
			$("#BIZR_TP_CD").text(kora.common.null2void(data.BIZR_TP_NM));
			$("#BIZRID").text(kora.common.null2void(data.BIZRID));
			$("#BIZR_SE_CD").text(kora.common.null2void(data.BIZR_SE_NM));
			$("#TOB_NM").text(kora.common.null2void(data.TOB_NM));
			$("#BCS_NM").text(kora.common.null2void(data.BCS_NM));
			$("#PNO").text(kora.common.null2void(data.PNO));
			$("#RPST_NM").text(kora.common.null2void(data.RPST_NM));
			$("#ADMIN_NM").text(kora.common.null2void(data.ADMIN_NM));
			$("#ADMIN_ID").text(kora.common.null2void(data.ADMIN_ID));
			$("#ACP_ACCT_NO").text(kora.common.null2void(data.ACP_ACCT_NO));
			$("#ACP_BANK_NM").text(kora.common.null2void(data.ACP_BANK_NM));
			$("#ACP_ACCT_DPSTR_NM").text(kora.common.null2void(data.ACP_ACCT_DPSTR_NM));
			$("#MFC_DPS_VACCT_NO").text(kora.common.null2void(data.MFC_DPS_VACCT_NO));
			$("#MFC_FEE_VACCT_NO").text(kora.common.null2void(data.MFC_FEE_VACCT_NO));
			$("#DEPT_NM").text(kora.common.null2void(data.DEPT_NM));
			$("#USER_NM").text(kora.common.null2void(data.USER_NM));
			$("#USER_ID").text(kora.common.null2void(data.USER_ID));
			$("#EMAIL").text(kora.common.null2void(data.EMAIL));
			$("#ASTN_EMAIL").text(kora.common.null2void(data.ASTN_EMAIL));
			$("#TEL_NO").text(kora.common.null2void(data.TEL_NO));
			$("#MBIL_NO").text(kora.common.null2void(data.MBIL_NO) + kora.common.null2void(data.MBIL_NO3));
			//$("#ATH_GRP_NM").text(kora.common.null2void(data.ATH_GRP_NM));
			$("#USER_STAT_NM").text(kora.common.null2void(data.USER_STAT_NM));
			$("#CNTR_DT").text(kora.common.setDelim(data.CNTR_DT, '9999-99-99'));
			$("#BIZR_ISSU_KEY").text(kora.common.null2void(data.BIZR_ISSU_KEY));
			$("#ADDR1").text(kora.common.null2void(data.ADDR1));
			$("#ADDR2").text(kora.common.null2void(data.ADDR2));
			//$("#SAVE_FILE_NM1").text(kora.common.null2void(data.FILE_NM));
			//$("#SAVE_FILE_NM2").text(kora.common.null2void(data.CTRT_FILE_NM));
			$("#ALT_REQ_STAT_NM").text(kora.common.null2void(data.ALT_REQ_STAT_NM));

			$("#SAVE_FILE_NM1").append("&nbsp;<a class='down' href='javascript:fn_dwnd(\""+kora.common.null2void(data.SAVE_FILE_NM)+"\", \""+kora.common.null2void(data.FILE_NM)+"\")'><span class='down_btn'></span>"+kora.common.null2void(data.FILE_NM)+"</a>");
			$("#SAVE_FILE_NM2").append("&nbsp;<a class='down' href='javascript:fn_dwnd(\""+kora.common.null2void(data.CTRT_SAVE_FILE_NM)+"\", \""+kora.common.null2void(data.CTRT_FILE_NM)+"\")'><span class='down_btn'></span>"+kora.common.null2void(data.CTRT_FILE_NM)+"</a>");

			$('#RPST_TEL_NO').text(kora.common.null2void(data.RPST_TEL_NO));
			$('#FAX_NO').text(kora.common.null2void(data.FAX_NO));
			
		 }
		 
		//파일다운로드
		function fn_dwnd(fName, sName){ //fn_down
			frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
			frm.fileName.value = fName;
			frm.saveFileName.value = sName;
			frm.submit();
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
			<form name="frmMenu" id="frmMenu" method="post" >
				<table>
					<colgroup>
						<col style="width: 8%;height:50px">
						<col style="width: 15%;height:50px">
						<col style="width: auto;height:50px">
					</colgroup>
					<tr>
						<th colspan="2"><span id="bizr_stat_cd">상태</span></th>
						<td>
							<div class="row">
								<div class="txtbox" id="BIZR_STAT_CD">
								</div><p>/</p>
								<div class="txtbox" id="BIZR_SE_CD">
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="bizr_tp_cd">사업자유형</th>
						<td>
							<div class="row">
								<div class="txtbox" id="BIZR_TP_CD"></div> &nbsp;   <!-- 도매업자 / 공병상 / 생산자 / 소매업자 -->
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="bizrnm">사업자명</th>
						<td>
							<div class="row">
								<div class="txtbox" id="BIZRNM"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="bizr_no">사업자등록번호</th>
						<td>
							<div class="row">
								<div class="txtbox" id="BIZRNO"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="tob_nm">업종</th>
						<td>
							<div class="row">
								<div class="txtbox" id="TOB_NM"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="bcs_nm">업태</th>
						<td>
							<div class="row">
								<div class="txtbox" id="BCS_NM"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="rpst_nm">대표자명</th>
						<td>
							<div class="row">
								<div class="txtbox" id="RPST_NM"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="admin_nm">관리자성명</th>
						<td>
							<div class="row">
								<div class="txtbox" id="USER_NM"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="admin_id">관리자아이디</th>
						<td>
							<div class="row">
								<div class="txtbox" id="ADMIN_ID"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr class="bizrTpCdM">
						<th colspan="2" id="mfc_dps_vacct_no">빈용기보증금 가상계좌</th>
						<td>
							<div class="row">
								<div class="txtbox" id="MFC_DPS_VACCT_NO"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr class="bizrTpCdM">
						<th colspan="2" id="">취급수수료 가상계좌</th>
						<td>
							<div class="row">
								<div class="txtbox" id="MFC_FEE_VACCT_NO"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="acp_acct_no">수납 은행명</th>
						<td>
							<div class="row">
								<div class="txtbox" id="ACP_BANK_NM"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="acp_acct_no">수납 계좌번호</th>
						<td>
							<div class="row">
								<div class="txtbox" id="ACP_ACCT_NO"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="acp_acct_dpstr_nm">수납 계좌 예금주명</th>
						<td>
							<div class="row">
								<div class="txtbox" id="ACP_ACCT_DPSTR_NM"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="astn_email">보조 이메일</th>
						<td>
							<div class="row">
								<div class="txtbox" id="ASTN_EMAIL"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="cntr_dt">약정일자</th>
						<td>
							<div class="row">
								<div class="txtbox" id="CNTR_DT"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th rowspan="2" id="tel_no">전화번호</th>
						<th class="bd_l" id="rpst_tel_no">대표 전화번호</th>
						<td>
							<div class="row">
								<div class="txtbox" id="RPST_TEL_NO"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th class="bd_l" id="fax_no">FAX 전화번호</th>
						<td>
							<div class="row">
								<div class="txtbox" id="FAX_NO"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="bizr_issu_key">회원발급키</th>
						<td>
							<div class="row">
								<div class="txtbox" id="BIZR_ISSU_KEY"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="pno">사업장주소</th>
						<td>
							<div class="row">
								<div class="txtbox" id="PNO"></div>
								<div class="txtbox" id="ADDR1"></div>
								<div class="txtbox" id="ADDR2"></div>&nbsp;
							</div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="save_file_nm1">사업자등록증</th>
						<td>
							<div class="row" id="SAVE_FILE_NM1"></div>
						</td>
					</tr>
					<tr class="bizrTpCdM" style="display:none">
						<th colspan="2" id="save_file_nm2">생산자계약서</th>
						<td>
							<div class="row" id="SAVE_FILE_NM2"></div>
						</td>
					</tr>
					<tr>
						<th colspan="2" id="alt_req_stat_cd">가입 / 변경요청 상태</th>
						<td>
							<div class="row">
								<div class="txtbox" id="ALT_REQ_STAT_NM"></div>
							</div>
						</td>
					</tr>
				</table>
				</form>
			</div>
		</div>
	</section>
	<section class="btnwrap mt20" >
	<div class="btnwrap">
		<div class="fl_l" id="BL">
		</div>
		<div class="fl_r" id="BR">
		</div>
	</div>
	</section>
	</div>
	
	<form name="frm" action="/jsp/file_down.jsp" method="post">
		<input type="hidden" name="fileName" value="" />
		<input type="hidden" name="saveFileName" value="" />
		<input type="hidden" name="downDiv" value="bizlic" />
	</form>
	
</body>
</html>