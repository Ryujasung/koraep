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
		var upDeptCdList;
	
		$(document).ready(function(){
			
			INQ_PARAMS = jsonObject($('#INQ_PARAMS').val());
			searchDtl = jsonObject($('#searchDtl').val());
			upDeptCdList = jsonObject($('#upDeptCdList').val());

			fn_btnSetting();
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			$('#std_yn').text(parent.fn_text('std_yn'));
			$('#std_y').text(parent.fn_text('std_y'));
			$('#std_n').text(parent.fn_text('std_n'));
			$('#bizr_tp').text(parent.fn_text('bizr_tp'));
			$('#bizr_nm').text(parent.fn_text('bizr_nm'));
			$('#dept_cd').text(parent.fn_text('dept_cd'));
			$('#dept_nm').text(parent.fn_text('dept_nm'));
			$('#up_dept').text(parent.fn_text('up_dept'));
			$('#dept_lvl').text(parent.fn_text('dept_lvl'));
						
			//작성체크용
			$('#DEPT_CD').attr('alt', parent.fn_text('dept_cd'));
			$('#DEPT_NM').attr('alt', parent.fn_text('dept_nm'));
			$('#UP_DEPT_CD').attr('alt', parent.fn_text('up_dept'));
			
			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			//상세데이터 셋팅
			fnSetDtlData(searchDtl);

			//부서레벨은 변경불가
			/*
			$('#DEPT_LVL').mousedown(function(){
				fn_upDeptCdSet();
			});
			$('#DEPT_LVL').keyup(function(){
				fn_upDeptCdSet();
			});
			$('#DEPT_LVL').blur(function(){
				fn_upDeptCdSet();
			});
			*/
			
		});
		
		/*
		function fn_upDeptCdSet(){
			
			var STD_YN = $(':radio[name=STD_YN]:checked').val();
			var BIZR_CD = $("#BIZRID").val()+";"+$("#BIZRNO").val();
			var DEPT_LVL = $("#DEPT_LVL").val();
			var DEPT_CD = $("#DEPT_CD").val();
			
			if(!$.isNumeric($('#DEPT_LVL').val())){
				return;
			}
			
			if(Number(DEPT_LVL) <= 1){
				$('#UP_DEPT_CD').children().remove();
			}else{
				var url = "/CE/EPCE0129831_192.do";
				var input = {};
				input['STD_YN'] = STD_YN;
				input['BIZR_CD'] = BIZR_CD;
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
		*/
		
		/**
		  * 상세 데이터 셋팅
		  */
		 function fnSetDtlData(data){

		 	//화면상세
		 	$("#BIZR_TP_NM").text(kora.common.null2void(data.BIZR_TP_NM));
			$("#BIZRNM").text(kora.common.null2void(data.BIZRNM));
			$("#BIZRID").val(kora.common.null2void(data.BIZRID));
			$("#BIZRNO").val(kora.common.null2void(data.BIZRNO));
			$("#DEPT_CD").val(kora.common.null2void(data.DEPT_CD));
			$("#DEPT_NM").val(kora.common.null2void(data.DEPT_NM));
			$("#DEPT_LVL").val(kora.common.null2void(data.DEPT_LVL));
			
			$(":radio[name='STD_YN'][value='"+kora.common.null2void(data.STD_YN)+"']").prop("checked", true);
			
			if(data.CE_YN == 'N'){
				$('#STD_TXT').text(parent.fn_text('std_n'));
				$('#STD_TXT').attr('style','');
				$('#STD').attr('style','display:none');
			}else{
				$('#STD_TXT').attr('style','display:none');
				$('#STD').attr('style','');
			}
			
			if(upDeptCdList != null){
				kora.common.setEtcCmBx2(upDeptCdList, "", "", $("#UP_DEPT_CD"), "DEPT_STD_CD", "DEPT_NM", "N", "");
			}
		 }
		
		function fn_cnl(){
			console.log(INQ_PARAMS);
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
		 	var url = "/CE/EPCE0129842_21.do";
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
<input type="hidden" id="searchDtl" value="<c:out value='${searchDtl}' />"/>
<input type="hidden" id="upDeptCdList" value="<c:out value='${upDeptCdList}' />"/>

	<!-- 메뉴관리 -->
	<div class="iframe_inner">
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
		</div>
		
		<section class="secwrap">
			<div class="write_area">
				<div class="write_tbl">
				<form name="frmMenu" id="frmMenu" method="post" >
				<input type="hidden" id="BIZRID" name="BIZRID"/>
				<input type="hidden" id="BIZRNO" name="BIZRNO"/>
					<table>
						<colgroup>
							<col style="width: 200px;">
							<col style="width: auto;">
						</colgroup>
						<tr>
							<th><span id="std_yn"></span><span class="red">*</span></th>
							<td>
								<div class="row" id="STD">
									<label class="rdo"><input type="radio" id="STD_YN" name="STD_YN" value="Y"/><span id="std_y"></span></label>
									<label class="rdo"><input type="radio" id="STD_YN" name="STD_YN" value="N"/><span id="std_n"></span></label>
								</div>
								<div class="row" id="STD_TXT">
								</div>
							</td>
						</tr>
						
						<tr>
							<th><span id="bizr_tp"></span></th>
							<td>
								<div class="row">
									<div class="txtbox" id="BIZR_TP_NM"></div>
								</div>
							</td>
						</tr>
						<tr>
							<th><span id="bizr_nm"></span></th>
							<td>
								<div class="row">
									<div class="txtbox" id="BIZRNM"></div>
								</div>
							</td>
						</tr>
						
						<tr>
							<th><span id="dept_cd"></span><span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="DEPT_CD" name="DEPT_CD" style="width: 330px;border:0px" readonly class="i_notnull" maxlength="20">
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
									<input type="text" id="DEPT_LVL" name="DEPT_LVL" style="width: 179px;border:0px" readonly class="i_notnull" maxLength="2" >
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
		</section>

		<div class="btnwrap mt10">
			<div class="fl_r" id="BR">
			</div>
		</div>

	</div>

</body>
</html>
