<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javaScript" language="javascript" defer="defer">

		var parent_item;
		var EXCA_STD_CD;
		var EXCA_STAT_CD;
		var STAT_CNT;
	
		$(document).ready(function(){
			
			fn_btnSetting('EPCE4791464');
			
			parent_item = window.frames[$("#pagedata").val()].parent_item;
			
			$('#title_sub').text('<c:out value="${titleSub}" />');
			
			$('#exca_term_nm_txt').text(parent.fn_text('exca_term_nm'));
			$('#exca_term').text(parent.fn_text('exca_term'));
            $('#crct_psbl_term').text(parent.fn_text('crct_psbl_term'));
            $('#crct_cfm_end_dt').text(parent.fn_text('crct_cfm_end_dt'));
			$('#stat').text(parent.fn_text('stat'));
			$('#cet_fyer_exca_yn').text(parent.fn_text('cet_fyer_exca_yn'));
			$('#exca_trgt').text(parent.fn_text('exca_trgt'));
	
			$("#btn_cnl").click(function(){
				fn_cnl();
			});
			
			//진행처리
			$("#btn_upd").click(function(){
				fn_upd();
			});
			
			//종료처리
			$("#btn_upd2").click(function(){
				fn_upd2();
			});
			
			//변경
			$("#btn_upd3").click(function(){
				fn_upd3();
			});
			
			var url = "/CE/EPCE4791464_19.do";

			ajaxPost(url, parent_item, function(rtnData){
				if(rtnData != null && rtnData != ""){
					
					EXCA_STD_CD = rtnData.searchDtl[0].EXCA_STD_CD;
					EXCA_STAT_CD = rtnData.searchDtl[0].EXCA_STAT_CD;
					STAT_CNT = rtnData.searchDtl[0].STAT_CNT;
					
					$('#EXCA_STD_NM').text(rtnData.searchDtl[0].EXCA_STD_NM);
					$('#EXCA_DT').text(rtnData.searchDtl[0].EXCA_DT);
					$('#CRCT_PSBL_DT').text(rtnData.searchDtl[0].CRCT_PSBL_DT);
					$('#CRCT_CFM_END_DT').text(rtnData.searchDtl[0].CRCT_CFM_END_DT);
					$('#EXCA_STAT_NM').text(rtnData.searchDtl[0].EXCA_STAT_NM);
					$('#CET_FYER_EXCA').text(rtnData.searchDtl[0].CET_FYER_EXCA);
					if(rtnData.searchDtl[0].EXCA_TRGT_SE == "W"){ //전체
						$('#MFC_LIST').text(parent.fn_text('whl'));
					}else{
						$('#MFC_LIST').text(rtnData.searchDtl[0].MFC_LIST);
					}
				} else {
					alertMsg("error");
				}
			}, false);
			
		});
		
		//진행처리  L   S   E    예정 진행 종료
		function fn_upd(){
			if(EXCA_STAT_CD != 'L'){
				alertMsg("예정 상태의 내역만 진행 처리 가능합니다");
				return;
			}
			
			if(STAT_CNT > 0){
				alertMsg("진행상태의 정산기간이 있습니다. 해당기간 종료처리 후 진행 가능합니다.");
				return;
			}
			
			confirm('진행 처리 이후에는 정정가능기간 이외의 항목은 변경이 불가능합니다. 계속 진행하시겠습니까?', 'fn_upd_exec');
			
		}
		
		function fn_upd_exec(){
		
			var data = {};
			data["EXCA_STD_CD"] = EXCA_STD_CD;
			data["EXCA_STAT_CD"] = 'S';
			
			var url  = "/CE/EPCE4791464_21.do";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
				} else {
					alertMsg("error");
				}
			});
			
		}
		
		//종료처리   L   S   E    예정 진행 종료
		function fn_upd2(){

			if(EXCA_STAT_CD != 'S'){
				alertMsg('진행 상태의 내역만 진행 처리 가능합니다');
				return;
			}

			confirm('종료 처리 이후에는 변경이 불가능합니다. 계속 진행하시겠습니까?', 'fn_upd2_exec');
			
		}
		
		function fn_upd2_exec(){
		
			var data = {};
			data["EXCA_STD_CD"] = EXCA_STD_CD;
			data["EXCA_STAT_CD"] = 'E';
			
			var url  = "/CE/EPCE4791464_21.do";
			ajaxPost(url, data, function(rtnData){
				if ("" != rtnData && null != rtnData) {
					alertMsg(rtnData.RSLT_MSG, 'fn_cnl');
				} else {
					alertMsg("error");
				}
			});
			
		}
		
		/**
		 * 변경화면 이동
		 */
		function fn_upd3(){
			
			if(EXCA_STAT_CD == 'E'){
				alertMsg("예정, 진행 상태의 내역만 변경 가능합니다");
				return;
			}

			window.frames[$("#pagedata").val()].fn_pop2();
			$(document).find('[layer="close"]').trigger('click');
		}
		
		function fn_cnl(){
			window.frames[$("#pagedata").val()].fn_sel();
			$('[layer="close"]').trigger('click');
		}
		
	</script>

</head>
<body>
	<div class="layer_popup" style="width:650px;">
	
		<input type="hidden" id="pagedata"/> 
		
			<div class="layer_head" >
				<h1 class="layer_title" id="title_sub"></h1>
				<button type="button" class="layer_close" layer="close"></button>
			</div>
			<div class="layer_body">
				<div class="secwrap" id="divInput_P">
					<div class="write_area">
						<div class="write_tbl">
							<table>
								<colgroup>
									<col style="width: 150px;">
									<col style="width: auto;">
								</colgroup>
								<tr>
									<th><span id="exca_term_nm_txt"></span></th>
									<td>
										<div class="row">
											<div class="txtbox" id="EXCA_STD_NM"></div>
										</div>
									</td>
								</tr>
								<tr>
									<th><span id="exca_term"></span></th>
									<td>
										<div class="row" >
											<div class="txtbox" id="EXCA_DT"></div>
										</div>
									</td>
								</tr>
								<tr>
									<th><span id="crct_psbl_term"></span></th>
									<td>
										<div class="row" >
											<div class="txtbox" id="CRCT_PSBL_DT"></div>
										</div>
									</td>
								</tr>
                                <tr>
                                    <th><span id="crct_cfm_end_dt"></span></th>
                                    <td>
                                        <div class="row" >
                                            <div class="txtbox" id="CRCT_CFM_END_DT"></div>
                                        </div>
                                    </td>
                                </tr>
								<tr>
									<th><span id="stat"></span></th>
									<td>
										<div class="row" >
											<div class="txtbox" id="EXCA_STAT_NM"></div>&nbsp;
										</div>
									</td>
								</tr>
								<tr>
									<th><span id="cet_fyer_exca_yn"></span></th>
									<td>
										<div class="row" >
											<div class="txtbox" id="CET_FYER_EXCA"></div>&nbsp;
										</div>
									</td>
								</tr>
								<tr>
									<th><span id="exca_trgt"></span></th>
									<td>
										<div class="row" >
											<div class="txtbox" id="MFC_LIST"></div>&nbsp;
										</div>
									</td>
								</tr>
							</table>
		
						</div>
						
					</div>
					
					<div class="btnwrap mt20">
						<div class="fl_l" id="BL">
						</div>
						<div class="fl_r" id="BR">
						</div>
					</div>
					
				</div>
				
			</div>
	
	</div>
</body>
</html>
