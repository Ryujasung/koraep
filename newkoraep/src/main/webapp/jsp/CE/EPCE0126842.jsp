<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>소매업자 직매장/공장 수정</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">

	var INQ_PARAMS ;
	var searchDtl 	;
	var area_cd_list 	;
    var aff_ogn_cd_list ;
    var acp_mgnt_yn_list;
	
	$(function(){
		
		var INQ_PARAMS 		= jsonObject($('#INQ_PARAMS').val());
		var searchDtl 				= jsonObject($('#searchDtl').val());
		var area_cd_list 			= jsonObject($('#area_cd_list').val());
	    var aff_ogn_cd_list  	= jsonObject($('#aff_ogn_cd_list').val());
	    var acp_mgnt_yn_list	= jsonObject($('#acp_mgnt_yn_list').val());
		
		fn_btnSetting();
		
 		$('[name=GRP_YN]').change(function() { 
 			
 			if($("input:radio[name='GRP_YN']:checked").val() == 'N'){

 				var url = "/CE/EPCE0126831_19.do" 
				var input ={};
			    input["BIZRID_NO"] = searchDtl[0].BIZRID + ';' + searchDtl[0].BIZRNO;

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
		
		kora.common.setEtcCmBx2(area_cd_list, "","", $("#AREA_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');					//지역
 		kora.common.setEtcCmBx2(aff_ogn_cd_list, "","", $("#AFF_OGN_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');			//소속단체
 		kora.common.setEtcCmBx2(acp_mgnt_yn_list, "","", $("#ACP_MGNT_YN"), "ETC_CD", "ETC_CD_NM", "N" ,'S');	//수납여부
 		
		if(searchDtl.length > 0){
			
			var grpYn = searchDtl[0].GRP_YN;						//그룹여부
			var acp_mgnt_yn = searchDtl[0].ACP_MGNT_YN;	//수납관리여부
			$(":radio[name='GRP_YN'][value='"+grpYn+"']").prop("checked", true);
			$(":radio[name='ACP_MGNT_YN'][value='"+acp_mgnt_yn+"']").prop("checked", true);
			
			if(grpYn == 'N'){
				
				var url = "/CE/EPCE0126831_19.do" 
				var input ={};
			    input["BIZRID_NO"] = searchDtl[0].BIZRID + ';' + searchDtl[0].BIZRNO;

	       	    ajaxPost(url, input, function(rtnData) {
	   				if ("" != rtnData && null != rtnData) {   
	   					console.log(rtnData.grpList);
	   					kora.common.setEtcCmBx2(rtnData.grpList, "","", $("#GRP_BRCH_NO"), "BRCH_NO", "BRCH_NM", "N" ,'S');
	   				} else {
	   					alertMsg("error");
	   				}
	    		}, false);
 				
	       	    $('.grpY').attr('style', '');
		       	$("#GRP_BRCH_NO").val(searchDtl[0].GRP_BRCH_NO);
				
			}
			$("#BIZR_TP_CD").text(searchDtl[0].BIZR_TP_CD);		//소매업자구분
			$('#BIZRNM').text(searchDtl[0].BIZRNM);					//업체명
			$('#BRCH_NM').val(searchDtl[0].BRCH_NM);				//지점명
			$('#BRCH_NO_TXT').text(searchDtl[0].BRCH_NO);		//지점코드
			$('#AREA_CD').val(searchDtl[0].AREA_CD);					//지역
			$("#AFF_OGN_CD").val(searchDtl[0].AFF_OGN_CD);		//소속단체
			$('#BIZRID').val(searchDtl[0].BIZRID);						
			$('#BIZRNO').val(searchDtl[0].BIZRNO);
			$('#BRCH_ID').val(searchDtl[0].BRCH_ID);
			$('#BRCH_NO').val(searchDtl[0].BRCH_NO);
		
		}
 		$('#title_sub').text('<c:out value="${titleSub}" />');
		$('#rtl_se_cd').text(parent.fn_text('rtl_se_cd')+" : ");				//소매업자 구분
		$('#enp_nm').text(parent.fn_text('enp_nm')+" : ");					//업체명 (소매업자)
		
	}
    
    
	kora.common.setEtcCmBx2(area_cd_list, "","", $("#AREA_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');				//지역
	
	//취소
	function fn_cnl(){
		console.log(INQ_PARAMS);
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
	 	var url = "/CE/EPCE0126842_09.do";
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
				
				<input type="hidden" id="BIZRID" name="BIZRID"/>
				<input type="hidden" id="BIZRNO" name="BIZRNO"/>
				<input type="hidden" id="BRCH_ID" name="BRCH_ID"/>
				<input type="hidden" id="BRCH_NO" name="BRCH_NO"/>
				
				<div class="write_tbl">
					<table>
						<colgroup>
							<col style="width: 8%;">
							<col style="width: 15%;">
							<col style="width: auto;">
						</colgroup>
						<tr>
							<th colspan="2">소매업자<span class="red">*</span></th>
							<td>
								<div class="row">
										<div class="col">
											<div class="tit" id="rtl_se_cd"></div><!--   소매업자구분 -->
											<div class="txtbox" id="BIZR_TP_CD" name="BIZR_TP_CD" style="width: 250px"></div>
										</div> 
										<div class="col">
											<div class="tit" id="enp_nm"></div> <!--  소매업자업체명 -->
											<div class="txtbox" id="BIZRNM" name="BIZRNM" style="width: 300px"></div>
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
									<div class="txtbox" id="BRCH_NO_TXT" name="BRCH_NO_TXT"></div>&nbsp;
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">지역<span class="red">*</span></th>
							<td>
								<div class="row">
									<select id="AREA_CD" name="AREA_CD" style="width: 210px" class="" alt="지역" ></select>
								</div>
							</td>
						</tr>
						<tr>
							<th colspan="2">소속단체<span class="red">*</span></th>
							<td>
								<div class="row">
									<select id="AFF_OGN_CD" name="AFF_OGN_CD" style="width: 210px" class="" alt="소속단체" ></select>
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