<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=1100, user-scalable=no">

<meta name="_csrf" content="<c:out value='${_csrf.token}' />" />
<meta name="_csrf_header" content="<c:out value='${_csrf.headerName}' />" />

<title>로그인</title>

<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>


<script type="text/javaScript" language="javascript" defer="defer">
var gheader = $("meta[name='_csrf_header']").attr("content");


//sso 로그인
function fn_ssoLogin(){
	var url = "/SSO_LOGIN_CHECK.do";
	ajaxPost(url, {"SSO_ID":""}, function(data){
	    
        //로그인후 갱신
        if(data._csrf != null && data._csrf != ""){
            $("meta[name='_csrf']").attr("content", data._csrf);
        }
	    
		if(data.msg != null && data.msg != ""){
			alert(data.msg);
			return;
		}
		else {
			if(data.noti != null && data.noti != ""){	//패스워드 유효기간 만료 메세지
				alert(data.noti);
			}

			try{
	            //fasoo 로그인
	            var logonID = newsso.SetUserInfo("LOGIN", "0100000000001428", data.USER_ID, "1111","","","","","","","","","","");
	        }catch(exception){
	            //설치가 안되어있을경우 예외처리
	        }
			
	        window.location.href = '/MAIN.do';
		}
	});
}

function ajaxPost(url, dataBody, func, pAsync){

	var async = true;
	if(pAsync != null && pAsync != "undefined") async = pAsync;
	
	
    $.ajax({
        url : url,
        type : 'POST',
        data : dataBody,
        dataType : 'json',
        cache : false,
        async : async,
        traditional : true,
        beforeSend: function(request) {
            request.setRequestHeader("AJAX", true);
            request.setRequestHeader(gheader, $("meta[name='_csrf']").attr("content"));
        },
        success : function(data) { 
            func(data);
        },
        error : function(c) {
            //console.log(c);
            if(c.status == 401 || c.status == 403){
                //alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
            }else if(c.responseText != null && c.responseText != ""){
                alert("처리중 오류가 발생하였습니다. \r\n다시 시도 하십시오.");  
            }
        }
    });
}

</script>

<OBJECT id=newsso style="LEFT: 0px; WIDTH: 100px; TOP: 0px; HEIGHT: 0px" classid=clsid:1CEB70FD-234E-40BD-A5CC-CFF6ACCAC133 name=newsso></object>
</head>

<body onload="fn_ssoLogin();" class="mainbg">
</body>
</html>