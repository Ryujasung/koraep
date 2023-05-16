<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>소매업자 직매장/공장 저장</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />

<script type="text/javaScript" language="javascript" defer="defer">

	var INQ_PARAMS ;
	var whsl_se_cdList 	;
    var area_cd_list ;
    var aff_ogn_cd_list ;
    var acp_mgnt_yn_list	;

	$(function(){
		
		var INQ_PARAMS 		= jsonObject($('#INQ_PARAMS').val());
		var whsl_se_cdList 		= jsonObject($('#whsl_se_cdList').val());
	    var area_cd_list 			= jsonObject($('#area_cd_list').val());
	    var aff_ogn_cd_list  	= jsonObject($('#aff_ogn_cd_list').val());
	    var acp_mgnt_yn_list	= jsonObject($('#acp_mgnt_yn_list').val());
		
		fn_btnSetting();

		//그룹여부 변경시
 		$('[name=GRP_YN]').change(function() { 
 			
 			//총괄지점 검색
 			if($("input:radio[name='GRP_YN']:checked").val() == 'N'){
 				
 				if($('#BIZRNM').val() == ''){
 					$(":radio[name='GRP_YN'][value='Y']").prop("checked", true);
 	 				alertMsg("먼저 소매업자를 선택하세요.");
 	 				return;
 	 			}
 				
 				var url = "/CE/EPCE0126831_19.do" 
				var input ={};
			    input["BIZRID_NO"] = $("#BIZRNM").val();

	       	    ajaxPost(url, input, function(rtnData) {
	   				if ("" != rtnData && null != rtnData) {   
	   					console.log(rtnData.grpList);
	   					kora.common.setEtcCmBx2(rtnData.grpList, "","", $("#GRP_BRCH_NO"), "BRCH_NO", "BRCH_NM", "N" ,'S');
	   				} else {
	   					alertMsg("error");
	   				}
	    		});
 				
	       	    $('.grpY').attr('style', '');
 			}else{
 				$('.grpY').attr('style', 'display:none');
 			}
 			
 			window.frameElement.style.height = $('.iframe_inner').height()+5+'px';
 		});
 		
 		//소매업자구분 변경시 업체명 조회
 	     function fn_bizr_tp_cd(){
 	    	var url = "/CE/EPCE0126801_193.do" 
 			var input ={};
 			$("#BIZRNM").select2("val","");
 			   if($("#BIZR_TP_CD").val()  !=""){ 	//소매업자 구분 변경시
 			 		  	input["BIZR_TP_CD"] =$("#BIZR_TP_CD").val();
 			 		  	ajaxPost(url, input, function(rtnData) {
 			   				if ("" != rtnData && null != rtnData) {  
 			   					 	kora.common.setEtcCmBx2(rtnData.whsdlList, "","", $("#BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'S');		 //업체명
 			   				}else{
 			   						 alertMsg("error");
 			   				}
 		   				},false);
 			 		  	
 			   }else{	//전체
 				   kora.common.setEtcCmBx2([], "","", $("#BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'S');					//소매업자
 				//   kora.common.setEtcCmBx2([], "","", $("#GRP_BRCH_NM"), "BRCH_NO", "BRCH_NM", "N" ,'T');					//총괄직매장
 	  			}
 	     } 
		
 	    /************************************
 		 * 소매업자 구분 변경 이벤트
 		 ***********************************/
 		$("#BIZR_TP_CD").change(function(){
 			fn_bizr_tp_cd();
 		});
 		
		//업체명 변경시
 		$('#BIZRNM').change(function() { 
 			$(":radio[name='GRP_YN'][value='Y']").prop("checked", true);
 			$('.grpY').attr('style', 'display:none');
 			$("#GRP_BRCH_NO").children().remove();
 		});
 		
 		//등록 버튼
		$("#btn_reg").click(function(){
			fn_reg();
		});
 		
		//취소
		$("#btn_cnl").click(function(){
			fn_cnl();
		});
		
		fn_init();
 		
	});
	//초기 셋팅
	function fn_init(){
		
		kora.common.setEtcCmBx2(whsl_se_cdList, "","", $("#BIZR_TP_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');			//소매업자구분 
	 	kora.common.setEtcCmBx2([], "","", $("#BIZRNM"), "BIZRID_NO", "BIZRNM", "N" ,'S');									//소매업자
 		kora.common.setEtcCmBx2(area_cd_list, "","", $("#AREA_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');					//지역
 		kora.common.setEtcCmBx2(aff_ogn_cd_list, "","", $("#AFF_OGN_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');			//소속단체
 		kora.common.setEtcCmBx2(acp_mgnt_yn_list, "","", $("#ACP_MGNT_YN"), "ETC_CD", "ETC_CD_NM", "N" ,'S');	//수납여부
 		
 		$('#title_sub').text('<c:out value="${titleSub}" />');
		$('#rtl_se_cd').text(parent.fn_text('rtl_se_cd'));					//소매업자 구분
		$('#enp_nm').text(parent.fn_text('enp_nm'));					//업체명 (소매업자)
		
		//소매업자  autoComplete
 		 $("#BIZRNM").select2();
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
				
		if($(':radio[name=GRP_YN]:checked').val() == 'N'){
			if($('#GRP_BRCH_NO').val() == ''){
				alertMsg('관리지점을 선택하세요.');
				return;
			}
		}
		
		confirm('저장하시겠습니까?', 'fn_reg_exec');
	}
	
	function fn_reg_exec(){
		var sData = kora.common.gfn_formData("frmMenu");
	 	var url = "/CE/EPCE0126831_09.do";
	 	
	 	console.log(sData)
	 	
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

<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />"/>
<input type="hidden" id="whsl_se_cdList" value="<c:out value='${whsl_se_cdList}' />"/>
<input type="hidden" id="area_cd_list" value="<c:out value='${area_cd_list}' />"/>
<input type="hidden" id="aff_ogn_cd_list" value="<c:out value='${aff_ogn_cd_list}' />"/>
<input type="hidden" id="acp_mgnt_yn_list" value="<c:out value='${acp_mgnt_yn_list}' />"/>

	<div class="iframe_inner">
		<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
		</div>
		
		<section class="secwrap">
			<div class="write_area" id='div_input'>
				<form name="frmMenu" id="frmMenu" method="post" >
				<div class="write_tbl">
					<table>
						<colgroup>
							<col style="width: 8%;">
							<col style="width: 15%;">
							<col style="width: auto;">
						</colgroup>
						<tr >
							<th colspan="2">소매업자<span class="red">*</span></th>
							<td>
								<div class="row">
									    <div class="col">
											<div class="tit" id="rtl_se_cd"></div><!--   소매업자구분 -->
											<div class="box">
												<select id="BIZR_TP_CD" style="width: 179px" ></select>
											</div>
										</div> 
										<div class="col">
											<div class="tit" id="enp_nm"></div> <!--  소매업자업체명 -->
											<div class="box"  >
												  <select id="BIZRNM" name="BIZRNM" style="width: 200px"></select>
											</div>
										</div> 
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">지점구분<span class="red">*</span></th>
							<td>
								<div class="row" >
									<label class="rdo"><input type="radio" id="GRP_YN" name="GRP_YN" value="Y" checked="checked"><span>총괄지점</span></label>
									<label class="rdo"><input type="radio" id="GRP_YN" name="GRP_YN" value="N"><span>지점</span></label>
								</div>
							</td>
						</tr>
						<tr class="grpY" style="display:none">
							<th colspan="2">관리지점<span class="red">*</span></th>
							<td>
								<div class="row">
									<select id="GRP_BRCH_NO" name="GRP_BRCH_NO" style="width: 210px" ></select>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">지점명<span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="BRCH_NM" name="BRCH_NM" style="width: 330px;" class="i_notnull" alt="지점명" maxByteLength="90">
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">지점코드<span class="red">*</span></th>
							<td>
								<div class="row">
									<input type="text" id="BRCH_NO" name="BRCH_NO" style="width: 330px;" class="i_notnull" alt="지점코드" maxlength="10" format="engNum">
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
						<tr>
							<th colspan="2">소속단체<span class="red">*</span></th>
							<td>
								<div class="row">
									<select id="AFF_OGN_CD" name="AFF_OGN_CD" style="width: 210px" class="i_notnull" alt="소속단체" ></select>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">수납관리구분<span class="red">*</span></th>
							<td>
								<div class="row" >
									<label class="rdo"><input type="radio" id="ACP_MGNT_YN" name="ACP_MGNT_YN" value="N" checked="checked"><span>본사관리</span></label>
									<label class="rdo"><input type="radio" id="ACP_MGNT_YN" name="ACP_MGNT_YN" value="Y"><span>수납관리</span></label>
								</div>
							</td>
						</tr>
					</table>
				</div>
				</form>
				
				<div class="btnwrap">
					<div class="fl_r" id="BR">
					</div>
				</div>
				
			</div>
			
		</section>
		
	</div>



</body>
</html>