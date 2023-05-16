<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
		
		var INQ_PARAMS = ${INQ_PARAMS}; //파라미터 데이터
		var searchDtl = ${searchDtl};	//상세 데이터

		$(document).ready(function(){
			
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
			
			$("#btn_upd2").click(function(){
				fn_upd2();
			});
			
			$("#btn_upd3").click(function(){
				fn_upd3();
			});
			
			$("#btn_pop").click(function(){
				fn_pop();
			});
			
			$("#btn_page").click(function(){
				fn_page();
			});
			
			fnSetDtlData(searchDtl);
			
		});
		
		//권한설정 팝업
		function fn_pop(){
			
			var pagedata = window.frameElement.name;
			window.parent.NrvPub.AjaxPopup('/WH/EPWH0140188.do', pagedata);
		}
		
		function fn_upd(){
			
			if(searchDtl.USER_STAT_CD != 'W'){
				alertMsg("승인 대상이 아닙니다. 다시 한 번 확인하시기 바랍니다.");
				return;
			}
			
			confirm("승인처리 하시겠습니까?","fn_upd_exec");
			
		}
		
		function fn_upd_exec(){
			
			var input = {};
			input["USER_ID"] = searchDtl.USER_ID;
			input["USER_STAT_CD"] = searchDtl.USER_STAT_CD;
			
		 	var url = "/WH/EPWH0140164_21.do";
		 	ajaxPost(url, input, function(rtnData){
			 	if ("" != rtnData && null != rtnData) {
			 		if(rtnData.RSLT_CD == '0000'){
						alertMsg(rtnData.RSLT_MSG, 'fn_pop'); //권한설정 팝업으로
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
				} else {
					alertMsg("error");
				}
		 	});
		}
		
		function fn_upd2(){
			
			confirm("회원 탈퇴를 하시면 더 이상 시스템을 이용하실 수 없습니다.\n계속 진행하시겠습니까?", "fn_upd2_exec");
		}
		
		function fn_upd2_exec(){
	
			var input = {};
			input["USER_ID"] = searchDtl.USER_ID;
			
		 	var url = "/WH/EPWH0140164_212.do";
		 	ajaxPost(url, input, function(rtnData){
			 	if ("" != rtnData && null != rtnData) {
			 		if(rtnData.RSLT_CD == '0000'){
			 			//회원탈퇴후 로그아웃 처리 필요?
						alertMsg(rtnData.RSLT_MSG, 'fn_page');
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
				} else {
					alertMsg("error");
				}
		 	});
		}
		
		//변경화면 이동
		function fn_upd3(){
			kora.common.goPage('/WH/EPWH0140142.do', INQ_PARAMS);
		}
		
		function fn_page(){
			kora.common.goPageB('', INQ_PARAMS);
		}
		
		/**
		  * 상세 데이터 셋팅
		  */
		 function fnSetDtlData(data){

		 	//화면상세
			$("#BIZRNM").text(kora.common.null2void(data.BIZRNM)+"\u00A0\u00A0\u00A0["+parent.fn_text('bizr_tp')+" : "+kora.common.null2void(data.BIZR_TP_NM)+"]");
		 	
			$("#BIZRNO").text(kora.common.setDelim(data.BIZRNO_DE, '999-99-99999'));
			
			if(data.BIZR_TP_CD == 'T1'){ //센터
				$("#BRCH_NM").text(kora.common.null2void(data.CET_BRCH_NM));
			}else{
				$("#BRCH_NM").text(kora.common.null2void(data.BRCH_NM));
			}
			
			$("#DEPT_NM").text(kora.common.null2void(data.DEPT_NM));
			$("#USER_NM").text(kora.common.null2void(data.USER_NM));
			$("#USER_ID").text(kora.common.null2void(data.USER_ID));
			$("#EMAIL").text(kora.common.null2void(data.EMAIL));
			$("#TEL_NO").text(kora.common.null2void(data.TEL_NO));
			$("#MBIL_NO").text(kora.common.null2void(data.MBIL_NO) + kora.common.null2void(data.MBIL_NO3));
			$("#ATH_GRP_NM").text(kora.common.null2void(data.ATH_GRP_NM));
			$("#USER_STAT_NM").text(kora.common.null2void(data.USER_STAT_NM));
			$("#USER_SE_CD").text(kora.common.null2void(data.USER_SE_CD));
			
		 }
		
		 /**
		 * 상세조회
		 */
		function fn_sel(){
			
			var url = "/WH/EPWH0140164_19.do";
			
			ajaxPost(url, INQ_PARAMS.PARAMS, function(rtnData){
				if(rtnData != null && rtnData != ""){
					fnSetDtlData(rtnData.searchDtl);
				}else {
					alertMsg("error");
				}
			});
		}
		
	</script>
	
</head>
<body>

<input type="hidden" id="USER_SE_CD" name="USER_SE_CD" />

	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
		</div>
		
		<section class="secwrap">
			<div class="write_area">
				<div class="write_tbl">

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
							<th colspan="2"><span id="brch"></span></th>
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
							<th colspan="2"><span id="user_nm"></span></th>
							<td>
								<div class="row">
									<div class="txtbox" id="USER_NM"></div>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="id"></span></th>
							<td>
								<div class="row">
									<div class="txtbox" id="USER_ID"></div>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="email"></span></th>
							<td>
								<div class="row">
									<div class="txtbox" id="EMAIL"></div>
								</div>
							</td>
						</tr>
						<tr>
							<th rowspan="2"><span id="tel_no"></span></th>
							<th class="bd_l"><span id="tel_no2"></span></th>
							<td>
								<div class="row">
									<div class="txtbox" id="TEL_NO"></div>
								</div>
							</td>
						</tr>
						<tr>
							<th class="bd_l"><span id="mbil_tel_no"></span></th>
							<td>
								<div class="row">
									<div class="txtbox" id="MBIL_NO"></div>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2"><span id="use_ath"></span></th>
							<td>
								<div class="row">
									<div class="txtbox" id="ATH_GRP_NM"></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th  colspan="2"><span id="user_stat"></span></th>
							<td>
								<div class="row">
									<div class="txtbox" id="USER_STAT_NM"></div>
								</div>
							</td>
						</tr>
					</table>

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
