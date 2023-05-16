<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
			
		var INQ_PARAMS;
	
		$(document).ready(function(){
			
			INQ_PARAMS 			=  jsonObject($("#INQ_PARAMS").val());		//파라미터 데이터    
			var menuSetList		=  jsonObject($("#menuSetList").val());         //메뉴SET
		    var bizrTpList 		=  jsonObject($("#bizrTpList").val()); 			//사업자유형
		    var athSeList 			=  jsonObject($("#athSeList").val()); 			//권한구분
			
			fn_btnSetting();
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			$('#std_yn').text(parent.fn_text('std_yn'));
			$('#std_y').text(parent.fn_text('std_y'));
			$('#std_n').text(parent.fn_text('std_n'));
			$('#menu_set').text(parent.fn_text('menu_set'));
			$('#bizr_tp').text(parent.fn_text('bizr_tp'));
			$('#ath_grp_cd').text(parent.fn_text('ath_grp_cd'));
			$('#ath_grp_nm').text(parent.fn_text('ath_grp_nm'));
			$('#use_yn').text(parent.fn_text('use_yn'));
			$('#use_y').text(parent.fn_text('use_y'));
			$('#use_n').text(parent.fn_text('use_n'));
			$('#ath_se').text(parent.fn_text('ath_se'));
						
			//작성체크용
			$('#ATH_GRP_CD').attr('alt', parent.fn_text('ath_grp_cd'));
			$('#ATH_GRP_NM').attr('alt', parent.fn_text('ath_grp_nm'));
			$('#MENU_SET_CD').attr('alt', parent.fn_text('menu_set'));
			$('#BIZR_TP_CD').attr('alt', parent.fn_text('bizr_tp'));
			$('#ATH_SE_CD').attr('alt', parent.fn_text('ath_se'));
			
		
			kora.common.setEtcCmBx2(menuSetList, "", "", $("#MENU_SET_CD"), "ETC_CD", "ETC_CD_NM", "N", "S");
			kora.common.setEtcCmBx2(bizrTpList, "", "", $("#BIZR_TP_CD"), "ETC_CD", "ETC_CD_NM", "N", "S");
			kora.common.setEtcCmBx2(athSeList, "", "A", $("#ATH_SE_CD"), "ETC_CD", "ETC_CD_NM", "N", "S");
		
			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
		});
		
		function fn_cnl(){
			kora.common.goPageB('', INQ_PARAMS);
		}

		//저장
		function fn_reg(){

			 if(!kora.common.cfrmDivChkValid("frmMenu")) {
				return;
			 }
	
			confirm('저장하시겠습니까?', 'fn_reg_exec');
		}
		
		function fn_reg_exec(){
			var sData = kora.common.gfn_formData("frmMenu");
		 	var url = "/CE/EPCE393783109.do";
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
	<!-- 메뉴관리 -->
	<div class="iframe_inner">
	    <input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
		<input type="hidden" id="menuSetList" value="<c:out value='${menuSetList}' />" />
		<input type="hidden" id="bizrTpList" value="<c:out value='${bizrTpList}' />" />
		<input type="hidden" id="athSeList" value="<c:out value='${athSeList}' />" />
		
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
		</div>
		<section class="secwrap">
			<div class="write_area">
				<div class="write_tbl">
				<form name="frmMenu" id="frmMenu" method="post" >
					<table>
						<colgroup>
							<col style="width: 200px;">
							<col style="width: auto;">
						</colgroup>
						<tr>
							<th><span id="ath_grp_cd"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="ATH_GRP_CD" name="ATH_GRP_CD" style="width: 330px;" class="i_notnull" maxlength="8" >
								</div>
							</td>
						</tr>
						<tr>
							<th><span id="ath_grp_nm"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="ATH_GRP_NM" name="ATH_GRP_NM" style="width: 330px;" class="i_notnull" maxByteLength="90">
								</div>
							</td>
						</tr>
						<tr>
							<th><span id="std_yn"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<label class="rdo"><input type="radio" id="STD_YN" name="STD_YN" value="Y" checked="checked"/><span id="std_y"></span></label>
									<label class="rdo"><input type="radio" id="STD_YN" name="STD_YN" value="N"/><span id="std_n"></span></label>
								</div>
							</td>
						</tr>
						<tr>
							<th><span id="menu_set"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<select id="MENU_SET_CD" name="MENU_SET_CD" style="width: 179px;" class="i_notnull"></select>
								</div>
							</td>
						</tr>
						<tr>
							<th><span id="bizr_tp"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<select id="BIZR_TP_CD" name="BIZR_TP_CD" style="width: 179px;" class="i_notnull"></select>
								</div>
							</td>
						</tr>
						<tr>
							<th><span id="use_yn"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<label class="rdo"><input type="radio" id="USE_YN" name="USE_YN" value="Y" checked="checked"/><span id="use_y"></span></label>
									<label class="rdo"><input type="radio" id="USE_YN" name="USE_YN" value="N"/><span id="use_n"></span></label>
								</div>
							</td>
						</tr>
						<tr>
							<th><span id="ath_se"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<select id="ATH_SE_CD" name="ATH_SE_CD" style="width: 179px;" class="i_notnull"></select>
								</div>
							</td>
						</tr>
					</table>
				</form>
				</div>
				
			</div>
			
			<div class="btnwrap mt20">
				<div class="fl_r" id="BR">
				</div>
			</div>
			
		</section>

	</div>

</body>
</html>
