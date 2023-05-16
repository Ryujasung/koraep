<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>반환업무설정</title>
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
  
	 var INQ_PARAMS;	//파라미터 데이터

     var initList_w;										//도매업자
	 var initList_m										//생산자
	 
     $(function() {
    	 
    	INQ_PARAMS 	= jsonObject($("#INQ_PARAMS").val());	
    	initList_w 		= jsonObject($("#initList_w").val());		
    	initList_m		= jsonObject($("#initList_m").val());		
    	
    	//초기 셋팅
    	fn_init();
    	 
    	//버튼 셋팅
    	//fn_btnSetting();
		
		/************************************
		 * 설정 저장버튼 클릭 이벤트
		 ***********************************/
		$("#btn_reg").click(function(){
			fn_reg();
		});
		/************************************
		 * 거래처 추가버튼 클릭 이벤트
		 ***********************************/
		$("#btn_page").click(function(){
			fn_page();
		});
	
	});
     
	  //거래처 추가 시 도매업자 다시 조회
     function fn_sel(){
    	var url = "/RT/EPRT9017301_19.do";     
 		var input = {}
    	ajaxPost(url, input, function(rtnData){
 			if(rtnData != null && rtnData != ""){
 				initList_w =  rtnData.initList_w;
 			}else{
 				alert("error");
 			} 
    	 },false);
    	 fn_init();
     }
     
     //초기화
     function fn_init(){
    	 
    	$("#rtrvl_work_set_list").children().remove();  
    	
    	/*
    	var layoutTh = new Array();
    	layoutTh.push('<tr>');
    	layoutTh.push('	<th class="" >거래처구분</th>'); 
    	layoutTh.push('	<th class="" >거래처명</th>'); 
    	layoutTh.push('	<th class="" >사업자번호</th>'); 
    	layoutTh.push('	<th class="" >반환등록구분선택</th> ');
    	layoutTh.push('	<th class="" >수납방식선택</th>'); 
    	layoutTh.push('	<th class="" >생산자직접반환선택</th> ');
    	layoutTh.push('</tr>');
		$("#rtrvl_work_set_list").append(layoutTh.join("").toString());  
		*/
		
		$.each(initList_w, function(i, v){ //도매업자
			
			whsdl_table_set(v);
		
			//회수등록구분
			if(v.RTRVL_REG_SE =='M'){ //도매업자위임
				$("#"+v.WHSDL_BIZRID+"_1").prop('checked', true); 
			}else if(v.RTRVL_REG_SE =='P'){	//도매업자 대행
				$("#"+v.WHSDL_BIZRID+"_2").prop('checked', true); 
			}else{//D 직접등록
				$("#"+v.WHSDL_BIZRID+"_3").prop('checked', true); 
			}
			//직접지급구분
			if(v.DRCT_PAY_SE =='M'){// 도매업자위임
				$("#"+v.WHSDL_BIZRID+"_pay1").prop('checked', true); 
			}else if(v.DRCT_PAY_SE =='G'){	//보증금직접지급
				$("#"+v.WHSDL_BIZRID+"_pay2").prop('checked', true); 
			}else if(v.DRCT_PAY_SE =='F'){	//취급수수료직접지급
				$("#"+v.WHSDL_BIZRID+"_pay3").prop('checked', true); 
			}else{//R2 전체직접지급
				$("#"+v.WHSDL_BIZRID+"_pay4").prop('checked', true); 
			}
		},false);	
		$.each(initList_m, function(i, v){ //생산자
			
			mfc_table_set(v);
		
			//직접반환구분
			if(v.DRCT_RTN_SE =='M'){ // 생산자위임
				$("#"+v.MFC_BIZRID+"_1").prop('checked', true); 
			}else if(v.DRCT_RTN_SE =='P'){	//생산자대행
				$("#"+v.MFC_BIZRID+"_2").prop('checked', true); 
			}else if(v.DRCT_RTN_SE =='D'){	//직접반환 미사용
				$("#"+v.MFC_BIZRID+"_3").prop('checked', true); 
			}else{ //R2 전체직접지급
				$("#"+v.MFC_BIZRID+"_4").prop('checked', true); 
			}
		},false);	
		
    }
     
    //도매업자
    function whsdl_table_set(v){
    	var layoutTr = new Array();	
    	
    	layoutTr.push('<table class="txtTable">');
    	layoutTr.push('<colgroup><col style="width: 222px;"><col style="width: auto;"></colgroup>');
 		layoutTr.push('<tr>');
 		layoutTr.push('	<th>거래처구분</th>');
 		layoutTr.push('	<td>');
 		layoutTr.push('			<div  id="">'+v.BIZR_TP_NM+'</div>');//사업자유형
 		layoutTr.push('	</td>');
 		layoutTr.push('</tr>');
 		layoutTr.push('<tr>');
 		layoutTr.push('	<th>거래처명</th>');
 		layoutTr.push('	<td>');
 		layoutTr.push('			<div  id="">'+v.WHSDL_BIZRNM+'</div>');//사업자명
 		layoutTr.push('	</td>');
 		layoutTr.push('</tr>');
 		layoutTr.push('<tr>');
 		layoutTr.push('	<th>사업자번호</th>');
 		layoutTr.push('	<td>');			
 		layoutTr.push('			<div  id="">'+kora.common.setDelim(v.WHSDL_BIZRNO_DE, "999-99-99999")+'</div>');//사업자코드
 		layoutTr.push('	</td>');
 		layoutTr.push('</tr>');
 		layoutTr.push('<tr>');
 		layoutTr.push('	<th>반환등록구분<br>선택</th>');
 		layoutTr.push('	<td>');																	//회수등록구분 
 		layoutTr.push('			<label><input type="radio" id="'+v.WHSDL_BIZRID+'_1" name="'+v.WHSDL_BIZRID_NO+'" value="M" ><span id="">도매업자 위임 등록</span></label></br>');   
 		layoutTr.push('			<label><input type="radio" id="'+v.WHSDL_BIZRID+'_2" name="'+v.WHSDL_BIZRID_NO+'" value="P" ><span id="">도매업자 대행 등록</span></label></br>');
 		layoutTr.push('			<label><input type="radio" id="'+v.WHSDL_BIZRID+'_3" name="'+v.WHSDL_BIZRID_NO+'" value="D"><span id="">직접 등록</span></label>');
 		layoutTr.push('	</td>');
 		layoutTr.push('</tr>');
 		layoutTr.push('<tr>');
 		layoutTr.push('	<th>수납방식<br>선택</th>');
 		layoutTr.push('	<td>');																	//직접지급구분
 		layoutTr.push('			<label><input type="radio" id="'+v.WHSDL_BIZRID+'_pay1" name="'+v.WHSDL_BIZRID_NO+'_pay" value="M" ><span id="">도매업자 위임 지급 </span></label></br>');
 		layoutTr.push('			<label><input type="radio" id="'+v.WHSDL_BIZRID+'_pay2" name="'+v.WHSDL_BIZRID_NO+'_pay" value="G" ><span id="">보증금만 직접 수납</span></label></br>');
 		layoutTr.push('			<label><input type="radio" id="'+v.WHSDL_BIZRID+'_pay3" name="'+v.WHSDL_BIZRID_NO+'_pay" value="F"><span id="">취급수수료만 직접 수납</span></label></br>');
 		layoutTr.push('			<label><input type="radio" id="'+v.WHSDL_BIZRID+'_pay4" name="'+v.WHSDL_BIZRID_NO+'_pay" value="A" ><span id="">전체 직접 수납</span></label>');
 		layoutTr.push('	</td>');
 		layoutTr.push('</tr>');
 		layoutTr.push('</table><br>');
 		$("#rtrvl_work_set_list").append(layoutTr.join("").toString()); 
    }
     
   	//생산자
	function mfc_table_set(v){
	    var layoutTr = new Array();	
	    layoutTr.push('<table class="txtTable">');
	    layoutTr.push('<colgroup><col style="width: 222px;"><col style="width: auto;"></colgroup>');
		layoutTr.push('<tr>');
		layoutTr.push('	<th>거래처구분</th>');
		layoutTr.push('	<td>');
		layoutTr.push('			<div  id="">'+v.BIZR_TP_NM+'</div>');
		layoutTr.push('	</td>');
		layoutTr.push('</tr>');
 		layoutTr.push('<tr>');
 		layoutTr.push('	<th>거래처명</th>');
		layoutTr.push('	<td>');
		layoutTr.push('			<div  id="">'+v.MFC_BIZRNM+'</div>');
		layoutTr.push('	</td>');
		layoutTr.push('</tr>');
 		layoutTr.push('<tr>');
 		layoutTr.push('	<th>사업자번호</th>');
		layoutTr.push('	<td>');					
		layoutTr.push('			<div  id="">'+kora.common.setDelim(v.MFC_BIZRNO_DE, "999-99-99999")+'</div>');
		layoutTr.push('	</td>');
		layoutTr.push('</tr>');
 		layoutTr.push('<tr>');
 		layoutTr.push('	<th>생산자직접반환<br>선택</th>');
		layoutTr.push('	<td>');
		layoutTr.push('		<label><input type="radio" id="'+v.MFC_BIZRID+'_1" name="'+v.MFC_BIZRID_NO+'" value="M" ><span id="">생산자 위임 등록</span></label></br>');
		layoutTr.push('		<label><input type="radio" id="'+v.MFC_BIZRID+'_2" name="'+v.MFC_BIZRID_NO+'" value="P" ><span id="">생산자 대행 등록</span></label></br>');
		layoutTr.push('		<label><input type="radio" id="'+v.MFC_BIZRID+'_3" name="'+v.MFC_BIZRID_NO+'" value="D" ><span id="">직접 등록</span></label></br>');
		layoutTr.push('		<label><input type="radio" id="'+v.MFC_BIZRID+'_4" name="'+v.MFC_BIZRID_NO+'" value="N"  checked="checked"><span id="">직접 반환 미사용</span></label></br>');
		layoutTr.push('	</td>');
		layoutTr.push('</tr>');
		layoutTr.push('</table><br>');
		$("#rtrvl_work_set_list").append(layoutTr.join("").toString());  
   	}  
      
   	//설정저장
	function fn_reg(){
		var url = "/RT/EPRT9017301_09.do";     
		var data = {"list": ""};
		var row = new Array();
		if(initList_w.length !=0){
				$.each(initList_w, function(i, v){	  //도매업자
					var input={};
					input["BIZR_TP_CD"]				="W"
					input["WHSDL_BRCH_ID"]		=v.WHSDL_BRCH_ID;
					input["WHSDL_BRCH_NO"]	=v.WHSDL_BRCH_NO;
					input["WHSDL_BIZRID"]			=v.WHSDL_BIZRID;
					input["WHSDL_BIZRNO"]		=v.WHSDL_BIZRNO;
					input["RTRVL_REG_SE"]			= $("input[type=radio][name='"+v.WHSDL_BIZRID_NO+"']:checked").val();		//회수등록구분
					input["DRCT_PAY_SE"]			= $("input[type=radio][name='"+v.WHSDL_BIZRID_NO+"_pay']:checked").val();//직접지급구분
					row.push(input);
				},false);
		}
		if(initList_m.length !=0){
				$.each(initList_m, function(i, v){	  //생산자
					var input={};
					input["BIZR_TP_CD"]			="M"
					input["MFC_BRCH_ID"]		=v.MFC_BRCH_ID;
					input["MFC_BRCH_NO"]	=v.MFC_BRCH_NO;
					input["MFC_BIZRID"]			=v.MFC_BIZRID;
					input["MFC_BIZRNO"]		=v.MFC_BIZRNO;
					input["DRCT_RTN_SE"]		= $("input[type=radio][name='"+v.MFC_BIZRID_NO+"']:checked").val(); 	//직접반환구분
					row.push(input);
				},false);
		}//end of if length
		
		data["list"] =JSON.stringify(row);
		//console.log(data)
		ajaxPost(url, data, function(rtnData){
			if(rtnData != null && rtnData != ""){
					if(rtnData.RSLT_CD =="0000"){
						alert(rtnData.RSLT_MSG);
					}else{
						alert(rtnData.RSLT_MSG);	
		 			}
			}else{
					alert("error");
			}
		});//end of ajaxPost
		
   	}
   	
	//거래처추가  추가후 다시 조회해야함
	function fn_page(){

		INQ_PARAMS["FN_CALLBACK"] = "";
		INQ_PARAMS["URL_CALLBACK"] = "/RT/EPRT9017301.do";
		kora.common.goPage('/RT/EPRT9017331.do', INQ_PARAMS);
		
   	}
	 
</script>

</head>
<body>

	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
	<input type="hidden" id="initList_w" value="<c:out value='${initList_w}' />" />  
	<input type="hidden" id="initList_m" value="<c:out value='${initList_m}' />" />  

	<div id="wrap">
	
		<%@include file="/jsp/include/header_m.jsp" %>
		
		<%@include file="/jsp/include/aside_m.jsp" %>

		<div id="container">

			<div id="subvisual">
				<h2 class="tit" id="title"></h2>
			</div><!-- id : subvisual -->

			<div id="contents">
			
				<div class="contbox bdn pb40">
					<div class="tbl" id='rtrvl_work_set_list'>
						<table class="txtTable">
						</table>
					</div>
				</div>

				<div class="btn_wrap mt15">
					<div class="fl_c">
						<button class="btn70 c2" style="width: 220px;" id="btn_page">거래처 추가</button>
						<button class="btn70 c4" style="width: 220px;" id="btn_reg">설정 저장</button>
					</div>
				</div>

			</div><!-- id : contents -->

		</div><!-- id : container -->

		<%@include file="/jsp/include/footer_m.jsp" %>

	</div><!-- id : wrap -->

</body>
</html>