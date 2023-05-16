<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
			
		var INQ_PARAMS ;
	
		$(document).ready(function(){
			
			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());

			//버튼 셋팅
			fn_btnSetting();
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			$('#dept_cd').text(parent.fn_text('dept_cd'));
			$('#dept_nm').text(parent.fn_text('dept_nm'));
			$('#up_dept').text(parent.fn_text('up_dept'));
			$('#dept_lvl').text(parent.fn_text('dept_lvl'));
						
			//작성체크용
			$('#DEPT_CD').attr('alt', parent.fn_text('dept_cd'));
			$('#DEPT_NM').attr('alt', parent.fn_text('dept_nm'));
			$('#UP_DEPT_CD').attr('alt', parent.fn_text('up_dept'));
			$('#DEPT_LVL').attr('alt', parent.fn_text('dept_lvl'));

			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			$('#DEPT_LVL').mousedown(function(){
				fn_upDeptCdSet();
			});
			$('#DEPT_LVL').keyup(function(){
				fn_upDeptCdSet();
			});
			$('#DEPT_LVL').blur(function(){
				fn_upDeptCdSet();
			});
			
		});
		
		function fn_upDeptCdSet(){

			var DEPT_LVL = $("#DEPT_LVL").val();
			var DEPT_CD = $("#DEPT_CD").val();
			
			if(!$.isNumeric($('#DEPT_LVL').val())){
				return;
			}
			
			if(Number(DEPT_LVL) <= 1){
				$('#UP_DEPT_CD').children().remove();
			}else{
				var url = "/MF/EPMF0129831_192.do";
				var input = {};

				input['DEPT_LVL'] = DEPT_LVL;
				input['DEPT_CD'] = DEPT_CD;
				ajaxPost(url, input, function(rtnData){
					if(rtnData != null && rtnData != ""){
						kora.common.setEtcCmBx2(rtnData.searchList, "", "", $("#UP_DEPT_CD"), "DEPT_STD_CD", "DEPT_NM", "N", "");
					}else{
						alertMsg("error");
					}
				}, false);
			}
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
			 
			if(!$.isNumeric($('#DEPT_LVL').val())){
				alertMsg('숫자만 입력 가능합니다.');
				return;
			}

			if(Number($('#DEPT_LVL').val()) < 1){
				 alertMsg("부서레벨은 1 부터 작성 가능합니다.");
				 return;
			}
			
			//UP_DEPT_CD
			if(Number($('#DEPT_LVL').val()) > 1 && kora.common.null2void($('#UP_DEPT_CD option:selected').val()) == ''){
				alertMsg('부서레벨이 2 이상인 경우 상위부서 선택은 필수입니다.');
				return;
			}
			
			confirm('저장하시겠습니까?', 'fn_reg_exec');
		}
		
		function fn_reg_exec(){
			var sData = kora.common.gfn_formData("frmMenu");
		 	var url = "/MF/EPMF0129831_09.do";
		 	ajaxPost(url, sData, function(rtnData){
		 	if ("" != rtnData && null != rtnData) {
  					alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
  				} else {
  					alertMsg("error");
  				}
		 	});
		}
		

	</script>

</head>
<body>

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="bizrTpList" value="<c:out value='${bizrTpList}' />"/>

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
							<col style="width: 200px;">
							<col style="width: auto;">
						</colgroup>
												
						<tr>
							<th><span id="dept_cd"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="DEPT_CD" name="DEPT_CD" style="width: 330px;" class="i_notnull" maxlength="20">
								</div>
							</td>
						</tr>
						<tr>
							<th><span id="dept_nm"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="DEPT_NM" name="DEPT_NM" style="width: 330px;" class="i_notnull" maxByteLength="20">
								</div>
							</td>
						</tr>
						<tr>
							<th><span id="dept_lvl"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="DEPT_LVL" name="DEPT_LVL" style="width: 99px;" class="i_notnull" maxLength="2" format="number" value="1">
								</div>
							</td>
						</tr>
						<tr>
							<th><span id="up_dept"></span></th>
							<td>
								<div class="row">
									<select id="UP_DEPT_CD" name="UP_DEPT_CD" style="width: 179px;" >
									</select>
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
