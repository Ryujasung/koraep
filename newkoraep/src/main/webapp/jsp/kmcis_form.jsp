<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
 /**
  * @Class Name : kmcis_form.jsp
  * @Description : 본인인증요청 정보팝업
  * @Modification Information
  * 
  * @author kwonsy
  * @since 2015.09.09
  * @version 1.0
  * @see
  *  
  * Copyright (C) All right reserved.
  */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta content="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />
<title>본인인증</title>

<link rel="stylesheet" href="/common/css/basic.css" type="text/css">
<link rel="stylesheet" href="/common/css/pop.css" type="text/css">

<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>

<script type="text/javaScript" language="javascript" defer="defer">
//ajax 처리 세션체크용
// var gxhr = new XMLHttpRequest();
// var gtoken = $("meta[name='_csrf']").attr("content");
// var gheader = $("meta[name='_csrf_header']").attr("content");
// 	alert(gtoken);
// 	alert(gheader);
// $.ajaxSetup({
	
// 	beforeSend: function(gxhr) {
// 		gxhr.setRequestHeader("AJAX", true);
// 		gxhr.setRequestHeader("Content-type", "application/json");
// 		gxhr.setRequestHeader(gheader, gtoken);
//     }
    
// });


$(document).ready(function(){
	
	//urlCode - 개발:007001, 운영:008001
	if(location.href.indexOf("localhost") > -1 || location.href.indexOf("127.0.0.1") > -1 
			|| location.href.indexOf("175.115.52.202") > -1 || location.href.indexOf("devreuse2.cosmo.or.kr") > -1){
		$("input[name='urlCode']").val("011001"); //004004
	}else{
		$("input[name='urlCode']").val("001007");
	}
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	$(function(){
		$(document).ajaxSend(function(e,xhr,option){
// 			console.log("1",header);
// 			console.log("2",token);
			xhr.setRequestHeader(header,token);
		});
	});
	var plusInfo = $("#CERT_DIV", opener.document).val();
	$("#plusInfo").val(plusInfo);
// 	fn_getCertKey();
	openKMCISWindow();
// 	ajaxPostKKK()
});

function ajaxPostKKK(){
	console.log(url);
	console.log(dataBody);
	console.log(func);
	console.log(pAsync);
	var async = true;
	if(pAsync != null && pAsync != "undefined") async = pAsync;
	
	$.ajaxPrefilter('json', function(options, orig, jqXHR) { if (options.crossDomain && !$.support.cors) return 'jsonp' });
	
	$.ajax({
		url : url,
		type : 'POST',
		data : dataBody,
		crossDomain: true,
		dataType : 'json',
		cache : false,
		async : async,
		traditional : true,
		beforeSend: function(request) {
		    request.setRequestHeader("AJAX", true);
		    request.setRequestHeader($("meta[name='_csrf_header']").attr("content"), $("meta[name='_csrf']").attr("content"));
		},
		success : function(data) { 
			func(data);
		},
		error : function(c) {
			alert('a'+c.status);
			if(c.status == 401 || c.status == 403){
				alert("1세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
				window.parent.location.href = "MAIN.do";
			}else if(c.responseText != null && c.responseText != ""){
				alert("처리중 오류가 발생하였습니다. \r\n다시 시도 하십시오.");	
			}
		}
	});
}
//검증요청 데이타 생성 리턴
function fn_getCertKey(){
   var data = gfn_formData("reqForm");

//      data.csrf = gtoken;
     
//     	console.log(_csrf);
	var token = $("meta[name='_csrf']").attr("content");
   var url = "/EP/EPCE00852884.do"+ "?_csrf="+token;

   ajaxPostK(url, data, function(rtnData){
// 	   alert(rtnData);
// 	   alert($("input[name='tr_cert']").val());
      $("input[name='tr_cert']").val();
      $("input[name='tr_url']").val();
      openKMCISWindow();
   });
     
}


/* //검증요청 데이타 생성 리턴
function fn_getCertKey(){
	var data = gfn_formData("reqForm");

// 	var url = "/EP/EPCE00852884.do";

	ajaxPostK(url, data, function(rtnData){
		$("input[name='tr_cert']").val(rtnData.tr_cert);
		$("input[name='tr_url']").val(rtnData.tr_url);
		openKMCISWindow();
	});
	
	
} */

//검증호출
function openKMCISWindow(){
	
// 	var tr_cert = $("input[name='tr_cert']").val();
// 	var tr_url = $("input[name='tr_url']").val();
// 	var token = $("meta[name='_csrf']").attr("content");
// 	var header = $("meta[name='_csrf_header']").attr("content");
// 	var data = {}
// 	data[tr_cert] = tr_cert;
// 	data[tr_url] = tr_url;
// 	data[token] = token;
// 	data[header] = header;
	
// 	var xhr = new XMLHttpRequest();
// 	var data = {
// 	  tr_cert: tr_cert,
// 	  tr_url: tr_url,
// 	  token: token,
// 	  header: header,
// 	};
// 	console.log(data);
// 	xhr.onload = function() {
// 	  if (xhr.status === 200 || xhr.status === 201) {
// 	    console.log(xhr.responseText);
// 	  } else {
// 	    console.error(xhr.responseText);
// 	  }
// 	};
// 	xhr.open('GET', 'https://www.kmcert.com/kmcis/web/kmcisReq.jsp');
// 	xhr.setRequestHeader('Content-Type', 'application/json'); // 컨텐츠타입을 json으로
// 	xhr.send(JSON.stringify(data)); // 데이터를 stringify해서 보냄
// 	alert(token,header);
// 	alert(tr_cert);
// 	alert(tr_url);
// 	var xhr = new XMLHttpRequest();
// var data = gfn_formData("reqForm");
// console.log(data);
// var xhr = new XMLHttpRequest();
// // var xxurl = "https://devreuse2.cosmo.or.kr/api/recvJsonData.do";
// 	var url='https://www.kmcert.com/kmcis/web/kmcisReq.jsp';
// 	$.ajax({
// 		 url:'https://www.kmcert.com/kmcis/web/kmcisReq.jsp',
// // 		 url:xxurl,
// 		 type:'POST',
// 		 data:data,
// 		 contentType:'application/json;charset=UTF-8',
// 		 dataType:"json",
// 		 success : function(result){
// 			 console.log(result);
// 		 }
// 	 })

	document.forms["reqKMCISForm"].action = 'https://www.kmcert.com/kmcis/web/kmcisReq.jsp';
	console.log(document.forms["reqKMCISForm"]);
	document.forms["reqKMCISForm"].submit();
}


gfn_formData = function(formId){
	var data = $("#"+formId).serializeArray();
    var indexed_array = {};
    $.map(data, function(n, i){
        indexed_array[n['name']] = n['value'];
    });
    
    return indexed_array;
}

/**
 * jquery ajax execute
 * url, dataBody, func(실행함수)
 * */
function ajaxPostK(url,dataBody,func,pAsync){
	console.log(url);
	console.log(dataBody);
	console.log(func);
	console.log(pAsync);
	var async = true;
	if(pAsync != null && pAsync != "undefined") async = pAsync;
	
	$.ajaxPrefilter('json', function(options, orig, jqXHR) { if (options.crossDomain && !$.support.cors) return 'jsonp' });
	
	$.ajax({
		url : url,
		type : 'POST',
		data : dataBody,
		crossDomain: true,
		dataType : 'json',
		cache : false,
		async : async,
		traditional : true,
		beforeSend: function(request) {
		    request.setRequestHeader("AJAX", true);
		    request.setRequestHeader($("meta[name='_csrf_header']").attr("content"), $("meta[name='_csrf']").attr("content"));
		},
		success : function(data) { 
			func(data);
		},
		error : function(c) {
			alert('a'+c.status);
			if(c.status == 401 || c.status == 403){
				alert("1세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
				window.parent.location.href = "MAIN.do";
			}else if(c.responseText != null && c.responseText != ""){
				alert("처리중 오류가 발생하였습니다. \r\n다시 시도 하십시오.");	
			}
		}
	});
}

</script>


</head>

<body>
<div id="pop_wrap">
	<header>
		<h1>본인인증</h1>
	</header>
	
	
	
	<div id="pop_container">
		<div class="pop contents">
		
			<!-- seed 생성용 -->		
			<form name="reqForm" id="reqForm" method="post" onsubmit="return false;">
				<input type="hidden" name="cpId" size='41' maxlength ='10' value="COSM1001" />
	           	<input type="hidden" name="urlCode" size='41' maxlength ='6' value="01101" />	<!-- 개발:007001, 운영:008001 -->
				<input type="hidden" name="certMet" value="M" />	<!-- A:전체, M:휴대폰, C:신용카드, P:공인인증서 -->
				<input type="hidden" name="plusInfo" id="plusInfo"  size="41" maxlength ='320' value="" />
				<input type="hidden" name="phoneNo" maxlength="11" value="" />
				<input type="hidden" name="name" value="" />
				<input type="hidden" name="birthDay" value="" />
				<input type="hidden" name="gender" value="" />
				<input type="hidden" name="nation" value="" />
			</form>
	
			<!-- 전송용 -->
			<form name="reqKMCISForm" id="reqKMCISForm" method="post">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
			    <input type="hidden" name="tr_cert"   value = "${rtn.tr_cert }" />
			    <input type="hidden" name="tr_url"  value = "${rtn.tr_url }" />
			</form>
			
		</div>
	</div>
	
	
	
</div>

</body>
</html>
