<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">
		
		$(document).ready(function(){
			
			var ancSeList = jsonObject($("#ancSeList").val());
			var searchList = jsonObject($("#searchList").val());
			
			kora.common.setEtcCmBx2(ancSeList, "", "", $("#TRGT_SE"), "ETC_CD", "ETC_CD_NM", "N");

			$.each(searchList, function(idx, item){

				var check_y = '';
				var check_n = '';
				
				if(item.ANC_USE_YN == 'Y'){
					check_y = 'checked';
				}else{
					check_n = 'checked';
				}
				
				var row =
				'<tr>'+
				'	<td>'+
				'		<div class="row">'+
				'			<div class="txtbox">'+item.ANC_SE_NM+'</div>'+
				'		</div>'+
				'	</td>'+
				'	<td>'+
				'		<div class="row">'+
				'			<div class="txtbox">'+item.ATH_GRP_NM+'</div>'+
				'		</div>'+
				'	</td>'+
				'	<td>'+
				'		<div class="row">'+
				'			<div class="txtbox">'+
				'				<input type="radio" name="'+item.ANC_STD_CD+'" class="rdo" value="Y" '+check_y+'/><span>'+parent.fn_text('use_y')+'</span>'+
				'				<input type="radio" name="'+item.ANC_STD_CD+'" class="rdo" value="N" '+check_n+'/><span>'+parent.fn_text('use_n')+'</span>'+
				'			</div>'+
				'		</div>'+
				'	</td>'+
				'</tr>';
				
				$('#ancTbl').append(row);
			});
			
			fn_btnSetting(); 
			
			//text 셋팅
			$('.write_area .info_tbl table tr td.b').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			//text 셋팅
			$('.write_area .write_tbl table tr th.bd_l').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			//text 셋팅
			$('.tit').each(function(){
				$(this).text(parent.fn_text($(this).attr('id').substring(0, $(this).attr('id').lastIndexOf('_txt'))) );
			});
			
			//작성체크용
			$('#TRGT_SE').attr('alt', parent.fn_text('trgt_se'));
			$('#ANC_SBJ').attr('alt', parent.fn_text('sbj'));
			$('#ANC_MSG').attr('alt', parent.fn_text('cnts'));
			
			$("#btn_reg").click(function(){
				fn_reg();
			});
			
			$("#btn_reg2").click(function(){
				fn_reg2();
			});
			
			$("#btn_init").click(function(){
				fn_init();
			});
			
		});
	
		
		//저장
		function fn_reg(){
			confirm('저장하시겠습니까?', 'fn_reg_exec');
		}
		 
		function fn_reg_exec(){
			var sData = kora.common.gfn_formData("frmMenu");
		 	var url = "/CE/EPCE3989701_21.do";
		 	ajaxPost(url, sData, function(rtnData){
		 		if ("" != rtnData && null != rtnData) {
		 			alertMsg(rtnData.RSLT_MSG);
 				} else {
 					alertMsg("error");
 				}
		 	});
		}
		
		//저장
		function fn_reg2(){
			
			if(!kora.common.cfrmDivChkValid("chkDiv")) {
				return;
			 }
			
			confirm('등록하시겠습니까?', 'fn_reg2_exec');
		}
		 
		function fn_reg2_exec(){
			
			var input = {};
			input["TRGT_SE"] 	= $("#TRGT_SE option:selected").val();
			input["ANC_SBJ"] 	= $("#ANC_SBJ").val();
			input["ANC_MSG"] 	= $("#ANC_MSG").val();
			
		 	var url = "/CE/EPCE3989701_09.do";
		 	ajaxPost(url, input, function(rtnData){
		 		if ("" != rtnData && null != rtnData) {
		 			alertMsg(rtnData.RSLT_MSG, 'fn_init');
 				} else {
 					alertMsg("error");
 				}
		 	});
		}
		
		function fn_init(){
			$('#TRGT_SE').val('A');
			$('#ANC_SBJ').val('');
			$('#ANC_MSG').val('');
		}
		 
	</script>
			
</head>
<body>
	<div class="iframe_inner">
	
	    <input type="hidden" id="ancSeList" value="<c:out value='${ancSeList}' />" />
	    <input type="hidden" id="searchList" value="<c:out value='${searchList}' />" />
	    
		<div class="h3group">
			<h3 class="tit" id="title"></h3>
			<div class="btn_box">
			</div>
		</div>
		
		<section class="secwrap" style="display:none">
			<div class="write_area">
				<div class="info_tbl">
					<form name="frmMenu" id="frmMenu" method="post" >
					<table id="ancTbl">
						<colgroup>
							<col style="width: 30%;">
							<col style="width: 30%;">
							<col style="width: 40%;">
						</colgroup>
						<tbody>
							<tr>
								<td class="b" id="anc_se_txt" style="text-align:center"></td>
								<td class="b" id="trgt_se_txt" style="text-align:center"></td>
								<td class="b" id="use_yn_txt" style="text-align:center"></td>
							</tr>
						</tbody>
					</table>
					</form>
				</div>
			</div>
		</section>
		
		<section class="btnwrap mt20" style="display:none">
			<div class="fl_r" id="CR">
			</div>
		</section>
		
		
		<div class="h4group mt20">
			<h4 class="tit"  id='anc_msg_reg_txt'></h4>
		</div>
		
		<section class="secwrap">
			<div class="write_area">
		        <div class="write_tbl" id="chkDiv">
					<table>
						<colgroup>
							<col style="width: 15%;">
							<col style="width: 20%;">
							<col style="width: 15%;">
							<col style="width: 50%;">
						</colgroup>
						<tbody>
							<tr>
								<th class="bd_l" id="anc_trgt_txt" ></th>
								<td>
									<div class="row">
										<select id="TRGT_SE" name="TRGT_SE" style="width: 179px;" alt=""></select>
									</div>
								</td>
								<th class="bd_l" id="sbj_txt" ></th>
								<td>
									<div class="row">
										<input id="ANC_SBJ" name="ANC_SBJ" type="text" style="width: 95%;" class="i_notnull" alt=""  maxByteLength="30" >
									</div>
								</td>
							</tr>
							<tr>
								<th class="bd_l" id="cnts_txt" ></th>
								<td colspan="3">
									<div class="row">
										<input id="ANC_MSG" name="ANC_MSG" type="text" style="width: 97%;" class="i_notnull" alt=""  maxByteLength="120" >
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
		        
			</div>
		</section>
		
		<section class="btnwrap mt20" >
			<div class="fl_r" id="BR">
			</div>
		</section>

	</div>

</body>
</html>
