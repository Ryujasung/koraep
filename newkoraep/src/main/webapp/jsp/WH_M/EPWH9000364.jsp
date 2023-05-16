<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>반환수집소상세정보</title>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=1100, user-scalable=yes">
<meta name="description" content="사이트설명">
<meta name="keywords" content="사이트검색키워드">
<meta name="author" content="Newriver">
<meta property="og:title" content="공유제목">
<meta property="og:description" content="공유설명">
<meta property="og:image" content="공유이미지 800x400">

<%@include file="/jsp/include/common_page_m.jsp" %>

<!--  
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css" />
<link rel="stylesheet" type="text/css" href="/select2/select2-bootstrap.css" />
-->
<script type="text/javaScript" language="javascript" defer="defer">
	 var INQ_PARAMS;	//파라미터 데이터
	 var rowIndexValue =0;
     var whsl_se_cd; 		//도매업자구분
     var ctnr_se;			//빈용기구분  구병 신병 
	 var whsdlList;//도매업자 업체명 조회
	 var rcsList;
     var toDay = kora.common.gfn_toDay();  // 현재 시간
     var mfc_bizrnmList=[];							//생산자
     var ctnr_seList = [];								//빈용기구분
     var ctnr_nm=[]; 									//빈용기
     var regGbn =true;
 	 var arr 	= new Array();
	 var arr2 = new Array();
	 var flag_DT = "";
	 var whsl_chk = {};  
	 var cpctCdList;        //용량코드
	 var AreaCdList;
	 var initList;

     $(function() {
    	 
    	INQ_PARAMS 		= jsonObject($("#INQ_PARAMS").val());	//파라미터 데이터
    	//console.log(INQ_PARAMS)
    	initList = jsonObject($("#initList").val());
    	//console.log(initList);
    	
    	//초기 셋팅
    	fn_init();

    	//상세정보 셋팅
    	$.each(initList, function(i, v){
			
    		var row = '';
    		row += '<div class="contbox bdn pt30">';
    		row += '<div class="hgroup"><h3 class="tit">회수정보 </h3></div>';
    		row += '<div class="tbl"><table>';
    		row += '<colgroup><col style="width: 210px;"><col style="width: auto;"></colgroup>';
    		row += '<tbody>';
    		row += '<tr class="left"><th>'+fn_text('rtrvl_dt2')+'</th><td>'+v.RTRVL_REG_DT+'</td></tr>';
    		row += '<tr class="left"><th>'+fn_text('cpct')+'</th><td>'+v.CPCT_NM+'</td></tr>';
    		row += '<tr class="left"><th>'+fn_text('prps_cd')+'</th><td>'+v.PRPS_NM+'</td></tr>';
    		row += '<tr class="right"><th>'+fn_text('rtrvl_qty')+'</th><td>'+kora.common.format_comma(v.RTN_QTY)+'</td></tr>';
    		row += '<tr class="right"><th>보증금</th><td>'+v.RTN_GTN+'</td></tr>';
    		row += '</tbody></table></div></div>';
    		
    		$('#contentsBtm').before(row);

		});


		 

		 
			/************************************
			 * 반환내역서 삭제 클릭 이벤트
			 ***********************************/
			$("#btn_del_2").click(function(){
				fn_del();
			});
		 

		 
		/************************************
		 * 반환대상생산자 구분 변경 이벤트
		 ***********************************/
		$("#MFC_BIZRNM").change(function(){
			fn_mfc_bizrnm();
		});
		/************************************
		 * 반환대상 직매장/공장  구분 변경 이벤트
		 ***********************************/
		$("#MFC_BRCH_NM").change(function(){
			fn_mfc_brch_nm();
		});
		/************************************
		 * 빈용기구분 구병 / 신병 변경시 
		 ***********************************/
		$("#CTNR_SE").change(function(){
			fn_prps_cd();
		});
		
		/************************************
		 * 빈용기 구분 변경 이벤트
		 ***********************************/
		$("#PRPS_CD").change(function(){
			fn_prps_cd();
		});
		
		/************************************
		 * 빈용기코드 변경 이벤트
		 ***********************************/
		$("#CTNR_CD").change(function(){
			fn_rmk();			
		});
		
		/************************************
		 * 소매수수료 적용여부 이벤트
		 ***********************************/
		$("#RMK_LIST").change(function(){  
			fn_rmk_list();     
		});
		
		/************************************
		 * 비고 변경 이벤트
		 ***********************************/
		$("#RMK_SELECT").change(function(){  
			fn_rmk_select();     
		});


		/************************************
		 * 취소버튼 클릭 이벤트
		 ***********************************/
		$("#btn_cnl").click(function(){
			fn_cnl();
		});

    	
	});
     //초기화
     function fn_init(){
    	 $("#WHSDL_BIZRNM").text(initList[0].WHSDL_BIZRNM);
    	 $("#WHSDL_BIZRNO").text(kora.common.setDelim(initList[0].WHSDL_BIZRNO, "999-99-99999"));
    	 $("#RCS_NM").text(initList[0].RCS_NM);
    	 $("#RCS_NO").text(initList[0].RCS_NO);
    	 $('#RTRVL_REG_DT').text(kora.common.setDelim(initList[0].RTRVL_REG_DT, "9999-99-99"));
			//text 셋팅
			$('.txtTable tr th').each(function(){
				if($(this).attr('id') != ''){
					$(this).html(fn_text($(this).attr('id')) );
				}
			});
		/*
    	if(regGbn){
	    	 kora.common.setEtcCmBx2([], "","", $("#ENP_NM"), "ETC_CD", "ETC_CD_NM", "N" ,'S');							//업체명
			 kora.common.setEtcCmBx2([], "","", $("#BRCH_NM"), "BRCH_ID_NO", "BRCH_NM", "N" ,'S');						//지점
    	}
    	kora.common.setEtcCmBx2(cpctCdList, "","", $("#CPCT_CD"), "ETC_CD", "ETC_CD_NM", "N","T");
    	kora.common.setEtcCmBx2(AreaCdList, "", "", $("#AreaCdList_SEL"), "ETC_CD", "ETC_CD_NM", "N", "T");
    	//kora.common.setEtcCmBx2(whsdlList, "","", $("#WHSDL_BIZRNM"), "CUST_BIZRID_NO", "CUST_BIZRNM", "N" ,'T');//도매업자 업체명
    	//kora.common.setEtcCmBx2(rcsList, "","", $("#RCS_NM"), "RCS_NO", "RCS_NM", "N" ,'S');
		//kora.common.setEtcCmBx2(mfc_bizrnmList, "","", $("#MFC_BIZRNM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'S');		//반환대상 생산자
		/* kora.common.setEtcCmBx2([], "","", $("#MFC_BRCH_NM"), "MFC_BIZRID_NO", "MFC_BIZRNM", "N" ,'S');	//반환대상 직매장/공장
		kora.common.setEtcCmBx2(ctnr_se, "","", $("#CTNR_SE"), "ETC_CD", "ETC_CD_NM", "N");							//빈용기구분
		kora.common.setEtcCmBx2(ctnr_seList, "","", $("#PRPS_CD"), "ETC_CD", "ETC_CD_NM", "N" ,'S');				//빈용기구분 코드
		kora.common.setEtcCmBx2([], "","", $("#CTNR_CD"), "CTNR_CD", "CTNR_NM", "N" ,'S');							//빈용기명
		kora.common.setEtcCmBx2(rmk_list, "","", $("#RMK_SELECT"), "ETC_CD", "ETC_CD_NM", "N" ,'S');					//비고 
		
		//$('#RTRVL_DT').val(kora.common.formatter.datetime(toDay, "yyyy-mm-dd"));
		flag_DT = $("#RTRVL_DT").val(); 
		$("#BOX_QTY").val("");
		$("#RTN_QTY").val("");
		$("#CAR_NO").val("");
    	$("#RMK").val("");
		$("#select_rtl1").prop("checked", true)
		$("#RMK_SELECT").prop("disabled",true);
    	$("#RMK").prop("disabled",true);
    	//도매업자  검색
  		//$("#WHSDL_BIZRNM").select2();
  		//$("#RCS_NM").select2();
  		$("#RTRVL_DT").val(INQ_PARAMS.RTRVL_DT);
  		$("#RCS_NM").val(INQ_PARAMS.RCS_NM);
  		$("#REG_SQ").val(INQ_PARAMS.REG_SQ);
  		$("#RTN_QTY").val(INQ_PARAMS.RTN_QTY);
  		$("#CPCT_CD").val(INQ_PARAMS.CPCT_CD);
  		$("#PRPS_CD").val(INQ_PARAMS.PRPS_CD);
  		$("#RTN_GTN").val(INQ_PARAMS.RTN_GTN);
  		//fn_reg2();
  		*/
     }
     

     

    
    //반환내역서 삭제
    function fn_del(){
    	if(confirm("삭제하시겠습니까? 삭제 처리된 내역은 복원되지 않으며 재등록 하셔야 합니다.")){
	 		var url ="/WH/EPWH9000301_042.do";
	 		var input = {};
		
	 		input["REG_SQ"] = initList[0].REG_SQ;
	 	 	ajaxPost(url, input, function(rtnData){
	 			if(rtnData.RSLT_CD == "0000"){
	 				alert(rtnData.RSLT_MSG);
	 				fn_cnl();
	 			}else{
	 				//fn_cnl();
	 				alert(rtnData.RSLT_MSG);
	 			}
	 		},false);    
    	}
 	   
    }
    
   
   
	
	  //취소버튼 이전화면으로
    function fn_cnl(){
   	 kora.common.goPageB('/WH/EPWH9000301.do', INQ_PARAMS);
    }
	
	


</script>

<style type="text/css">

.srcharea .row .box  select, #s2id_RCS_NM{
    width: 100%
}

.srcharea .row .col{
width: 31%;
} 
.srcharea .row .col .tit{
width: 90px;
}
.srcharea .row .box{
width: 61%
}
</style>

</head>
<body>
			<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<!-- 
			<input type="hidden" id="whsl_se_cd_list" value="<c:out value='${whsl_se_cd}' />" />
			<input type="hidden" id="ctnr_se_list" value="<c:out value='${ctnr_se}' />" />
			<input type="hidden" id="rmk_list" value="<c:out value='${rmk_list}' />" />
			<input type="hidden" id="rtc_dt_list" value="<c:out value='${rtc_dt_list}' />" />
			<input type="hidden" id="whsdlList" value="<c:out value='${whsdlList}' />" />
			<input type="hidden" id="rcsList" value="<c:out value='${rcsList}' />" />
			<input type="hidden" id="cpctCdList" value="<c:out value='${cpctCdList}' />" />
			<input type="hidden" id="AreaCdList" value="<c:out value='${AreaCdList}' />"/>
			 -->
			<input type="hidden" id="initList" value="<c:out value='${initList}' />" />
			
    <div id="wrap">
    	<%@include file="/jsp/include/header_m.jsp" %>
	
		<%@include file="/jsp/include/aside_m.jsp" %>
		
		<div id="container">
			<div id="subvisual">
				<h2 class="tit" >반환수집소상세조회</h2>
				<button class="btn_back" id="btn_cnl"><span class="hide">뒤로가기</span></button>
			</div>
				
				<div id="contents">
			   
			
				<div class="contbox bdn pb40"> 
				<div class="tbl">
						<table class="txtTable">
						<colgroup>
								<col style="width: 177px;">
								<col style="width: auto;">
							</colgroup>
							<tbody>
								<tr class="right">
									<th>도매업자</th>
									<td id="WHSDL_BIZRNM"></td>
								</tr>
								<tr class="right">
									<th id="whsdl_bizrno_br">도매업자    사업자번호</th>
									<td id="WHSDL_BIZRNO"></td>
								</tr>
								<tr class="right">
									<th>반환수집소</th>						
									<td id="RCS_NM"></td>	
								</tr>
								<tr class="right">
									<th>반환수집소 번호</th>
									<td id="RCS_NO"></td>
								</tr>
							</tbody>
						</table>
					</div>
					</div>
					<div class="btn_wrap mt35" id="contentsBtm">
					<div class="fl_c">
						<button class="btn70 c1" style="width: 220px;" id="btn_del_2">회수정보 삭제</button>
					</div>
					</div>

		
		</div><!-- id : contents -->
		</div><!-- id : container -->
		<%@include file="/jsp/include/footer_m.jsp" %>
</div><!-- id : wrap -->



</body>
</html>