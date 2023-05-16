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
			
			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val()); //console.log(INQ_PARAMS);
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

			
			$("#btn_upd2").click(function(){
				fn_upd2();
			});
			
			$("#btn_upd3").click(function(){
				fn_upd3();
			});
			
			fnSetDtlData(searchDtl);
			
		});
				
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
						alertMsg(rtnData.RSLT_MSG, 'fn_logout');
					}else{
						alertMsg(rtnData.RSLT_MSG);
					}
				} else {
					alertMsg("error");
				}
		 	});
		}
		
		function fn_logout(){
			window.parent.location.href = '/USER_LOGOUT.do';
		}
		
		//변경화면 이동
		function fn_upd3(){
			INQ_PARAMS["FN_CALLBACK" ] = "";
			INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH5599001.do";
			kora.common.goPage('/WH/EPWH5599042.do', INQ_PARAMS);
		}

		/**
		  * 상세 데이터 셋팅
		  */
		 function fnSetDtlData(data){

		 	//화면상세
			$("#BIZRNM").text(kora.common.null2void(data.BIZRNM)+"\u00A0\u00A0\u00A0["+parent.fn_text('bizr_tp')+" : "+kora.common.null2void(data.BIZR_TP_NM)+"]");
		 	
			$("#BIZRNO").text( kora.common.setDelim(data.BIZRNO_DE, '999-99-99999')  );
			
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

					<table>
						<colgroup>
							<col style="width: 100px;">
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
		
		<div class="btnwrap mt20">
			<div class="fl_l" id="BL">
			</div>
			<div class="fl_r" id="BR">
			</div>
		</div>

	</div>
	
</body>
</html>
