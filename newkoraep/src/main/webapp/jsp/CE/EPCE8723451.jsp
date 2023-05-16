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

<script src="/js/kora/kora_common.js"></script>

<script language="javascript" defer="defer">

	//로그인
	function fn_login() {
	
		var sData = ${param};
		var url = "/j_spring_security_check";
	
		ajaxPost(url, sData, function(data){
	
			//로그인후 갱신
			if(data._csrf != null && data._csrf != ""){
				$("meta[name='_csrf']").attr("content", data._csrf);
			}
			
			ajaxPost("/UPDATE_EPCN_MBL_USER_INFO.do", sData, function(data){}, false);
			
			if(data.msg != null && data.msg != ""){
				alertMsg(data.msg);
			}else{
				if($("#id_save").is(":checked")){ // ID 저장하기 체크했을 때,
		            gfn_setCookie("SAVE_ID", id, 7); // 7일 동안 쿠키 보관
		        }else{ // ID 저장하기 체크 해제 시,
		        	gfn_setCookie("SAVE_ID", "");
		        }
				
				if(data.noti != null && data.noti != ""){
					alertMsg(data.noti);
				}else{
					
				}
			}
		});
	}
</script>

