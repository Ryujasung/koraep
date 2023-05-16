<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>회수정보상세조회</title>
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

<script type="text/javaScript" language="javascript" defer="defer">
  
	var INQ_PARAMS; //파라미터 데이터
    var toDay = kora.common.gfn_toDay(); // 현재 시간
	var rowIndexValue =0;
    var initList;										//도매업자
    var dps_fee_list;									//회수용기 보증금,취급수수료
    var whsdl_bizrnm_chk;
	 
	$(function() {
    	 
    	INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());	
    	initList = jsonObject($("#initList").val());		
    	
    	 //초기 셋팅
    	fn_init();

    	//상세정보 셋팅
    	$.each(initList, function(i, v){
			
    		var row = '';
    		row += '<div class="contbox bdn pt30">';
    		row += '<div class="hgroup"><h3 class="tit">회수정보 '+(i+1)+'</h3></div>';
    		row += '<div class="tbl"><table>';
    		row += '<colgroup><col style="width: 210px;"><col style="width: auto;"></colgroup>';
    		row += '<tbody>';
    		row += '<tr class="left"><th>'+fn_text('rtrvl_dt2')+'</th><td>'+v.RTRVL_DT+'</td></tr>';
    		row += '<tr class="left"><th>'+fn_text('whsdl_brch')+'</th><td>'+v.WHSDL_BRCH_NM+'</td></tr>';
    		row += '<tr class="left"><th>'+fn_text('reg_cust_nm')+'</th><td>'+v.REG_CUST_NM+'</td></tr>';
    		row += '<tr class="left"><th>'+fn_text('reg_cust_bizrno_br')+'</th><td>'+kora.common.setDelim(v.RTL_CUST_BIZRNO, '999-99-99999')+'</td></tr>';
    		row += '<tr class="left"><th>'+fn_text('prps_cd')+'</th><td>'+v.PRPS_NM+'</td></tr>';
    		row += '<tr class="left"><th>'+fn_text('cpct')+'</th><td>'+v.CPCT_NM+'</td></tr>';
    		row += '<tr class="right"><th>'+fn_text('rtrvl_qty')+'</th><td>'+kora.common.format_comma(v.RTRVL_QTY)+'</td></tr>';
    		row += '<tr class="right"><th>'+fn_text('rtrvl_dps')+'</th><td>'+kora.common.format_comma(v.RTRVL_GTN)+'</td></tr>';
    		row += '<tr class="right"><th>'+fn_text('rtrvl_fee')+'</th><td>'+kora.common.format_comma(v.REG_RTRVL_FEE)+'</td></tr>';
    		row += '<tr class="right"><th class="red">'+fn_text('total')+'</th><td class="red">'+kora.common.format_comma(v.AMT_TOT)+'</td></tr>';
    		row += '<tr class="left"><th>'+fn_text('rmk')+'</th><td>'+kora.common.null2void(v.RMK)+'</td></tr>';
    		row += '</tbody></table></div></div>';
    		
    		$('#contentsBtm').before(row);

		});
    	
    	 
		/************************************
		 * 목록버튼 클릭 이벤트
		 ***********************************/
		$("#btn_lst, #btn_lst2").click(function(){
			fn_lst();
		});
		
		/************************************
		 * 변경버튼 클릭 이벤트
		 ***********************************/
		$("#btn_upd").click(function(){
			fn_upd();
		});
		
		/************************************
		 * 삭제버튼 클릭 이벤트
		 ***********************************/
		$("#btn_del").click(function(){
			fn_del();
		});
	
	});
     
     //초기화
     function fn_init(){
    	 
    		$("#WHSDL_BIZRNM").text(initList[0].WHSDL_BIZRNM);
    		$("#WHSDL_BIZRNO").text(kora.common.setDelim(initList[0].WHSDL_BIZRNO_DE, "999-99-99999"));
    		$("#RTL_CUST_BIZRNM").text(initList[0].REG_CUST_NM);
    		$("#RTL_CUST_BIZRNO").text(kora.common.setDelim(initList[0].RTL_CUST_BIZRNO, "999-99-99999"));
		
			$('#RTRVL_DT').val(kora.common.formatter.datetime(toDay, "yyyy-mm-dd")); 
			 
			//text 셋팅
			$('.txtTable tr th').each(function(){
				if($(this).attr('id') != ''){
					$(this).html(fn_text($(this).attr('id')) );
				}
			});
			
     }
     
     //삭제
     function fn_del(){
    	 
    	//회수등록 ,회수조정 상태인경우만 가능
		if(initList[0]["RTRVL_STAT_CD"] !="RG" && initList[0]["RTRVL_STAT_CD"] !="WG" && initList[0]["RTRVL_STAT_CD"] !="RJ" && initList[0]["RTRVL_STAT_CD"] !="WJ" && initList[0]["RTRVL_STAT_CD"] !="VC" ){
			alert("올바르지 않은 상태의 내역이 선택 되었습니다. \n\n 다시 한 번 확인하시기 바랍니다");
			return;
		}

		if(confirm("삭제하시겠습니까? 삭제 처리된 내역은 복원되지 않으며 재등록 하셔야 합니다.")){
			
			var url ="/WH/EPWH2925801_04.do"; 
	 		var input ={}
	 		input["RTRVL_DOC_NO"] = initList[0].RTRVL_DOC_NO;	//회수문서번호
	 	 	ajaxPost(url, input, function(rtnData){
	 			if(rtnData.RSLT_CD == "0000"){
	 				alert(rtnData.RSLT_MSG);
	 				fn_lst();
	 			}else{
	 				alert(rtnData.RSLT_MSG);
	 			}
	 		},false);  
			
		}
    	 
 	} 
     
    //회수정보변경 페이지 이동 
 	function fn_upd() {
 		var input = initList[0];
 		
 		if(input["RTRVL_STAT_CD"] !="RG" && input["RTRVL_STAT_CD"] !="WG" && input["RTRVL_STAT_CD"] !="RJ" && input["RTRVL_STAT_CD"] !="WJ" && input["RTRVL_STAT_CD"] !="VC" ){
 			alert("올바르지 않은 상태의 내역이 선택 되었습니다. \n\n 다시 한 번 확인하시기 바랍니다");
 			return;
 		}
 		
 		INQ_PARAMS["PARAMS"] = {}
 		INQ_PARAMS["PARAMS"] = input;
 		INQ_PARAMS["URL_CALLBACK"] = "/WH/EPWH2925864.do";
 		kora.common.goPage('/WH/EPWH2925842.do', INQ_PARAMS);
 	} 
     
	//취소버튼 이전화면으로
    function fn_lst(){
		kora.common.goPageB('/WH/EPWH2925801.do', INQ_PARAMS);
    }
    
</script>

</head>
<body>

	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
	<input type="hidden" id="initList" value="<c:out value='${initList}' />" />

	<div id="wrap">
	
	<%@include file="/jsp/include/header_m.jsp" %>
	
	<%@include file="/jsp/include/aside_m.jsp" %>

    	<div id="container">

			<div id="subvisual">
				<h2 class="tit" id="title"></h2>
				<button class="btn_back" id="btn_lst2"><span class="hide">뒤로가기</span></button>
			</div><!-- id : subvisual -->

			<div id="contents">
			
				<div class="contbox bdn pb40">
					<div class="tbl">
						<table class="txtTable">
							<colgroup>
								<col style="width: 177px;">
								<col style="width: auto;">
							</colgroup>
							<tbody>
								<tr>
									<th id="whsdl"></th>
									<td id="WHSDL_BIZRNM"></td>
								</tr>
								<tr>
									<th id="whsdl_bizrno_br"></th>
									<td id="WHSDL_BIZRNO"></td>
								</tr>
								<tr>
									<th id="reg_cust_nm"></th>
									<td id="RTL_CUST_BIZRNM"></td>
								</tr>
								<tr>
									<th id="reg_cust_bizrno_br"></th>
									<td id="RTL_CUST_BIZRNO"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
								
				<div class="btn_wrap mt35" id="contentsBtm">
					<div class="fl_c">
						<button class="btn70 c2" style="width: 220px;" id="btn_upd">회수정보 변경</button>
						<button class="btn70 c1" style="width: 220px;" id="btn_del">회수정보 삭제</button>
						<!-- <button class="btn70 c1 ml30" style="width: 220px;" id="btn_lst">목록</button> -->
					</div>
				</div>
				
			</div><!-- id : contents -->

		</div><!-- id : container -->
		
		<%@include file="/jsp/include/footer_m.jsp" %>

	</div><!-- id : wrap -->
		

</body>
</html>