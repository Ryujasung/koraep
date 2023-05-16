<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>COSMO 자원순환보증금관리센터</title>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=100%, user-scalable=yes">
<meta name="description" content="사이트설명">
<meta name="keywords" content="사이트검색키워드">
<meta name="author" content="Newriver">
<meta property="og:title" content="공유제목">
<meta property="og:description" content="공유설명">
<meta property="og:image" content="공유이미지 800x400">

<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />

<link rel="stylesheet" href="/common_m/css/font.css">
<link rel="stylesheet" href="/common_m/css/reset.css">
<link rel="stylesheet" href="/common_m/css/slick.css">
<link rel="stylesheet" href="/common_m/css/common.css">
<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>
<script src="/js/kora/kora_common_m.js"></script>
<script src="/common/js/pub.plugin.js"></script>
<script src="/common/js/pub.common.js"></script>

<script type="text/javaScript" language="javascript" defer="defer">

var rtnData;

$(document).ready(function(){
	
	var userAgent = kora.common.getUserAgent();
	var userInfo = "${userInfo}";
	
	pub_ready();
	
/* 	if(null == userInfo || "" == userInfo) {
	    kora.common.iWebAction('2000');
	} */
	
	var toDay = kora.common.gfn_toDay();  // 현재 시간
	var mm = toDay.substring(4,6);
	$("#login").removeClass();	//class : spring, summer, fall, winter
	if(mm == "03" || mm == "04" || mm == "05"){
		$("#login").addClass("spring");	
	}else if(mm == "06" || mm == "07" || mm == "08"){
		$("#login").addClass("summer");	
	}else if(mm == "09" || mm == "10" || mm == "11"){
		$("#login").addClass("fall");	
	}else{
		$("#login").addClass("winter");
	}
	
	var userId = gfn_getCookie("SAVE_ID");
	if(userId != null && userId != "") $("input[name='USER_ID']").val(userId);
	$("#id_save").attr("checked", true); // ID 저장하기를 체크 상태로 두기.
	
	
	$("#btn_pop2").click(function() { //개인정보처리방침
		//NrvPub.AjaxPopup('/jsp/privacy.jsp');
		window.open('/jsp/privacy.jsp', '_popup');
	});
	
	
});


//로그인
function fn_login() {
	$("#loginError").text("");
	
	var id = $("#USER_ID").val();
	if(id == "") {
		alert("아이디를 입력하세요");
		return;
	}else if($("#USER_PWD").val() == "") {
		alert("비밀번호를 입력하세요");
		return;
	}

	//var sData = {"USER_ID":id, "USER_PWD":$("#USER_PWD").val(), "PUSH_TK":"1", "UUID":"2", "PUSH_TP":"3", "OS_VER":"4", "DEVICE_NM":"5"};
	//var url = "/MBL_LOGIN.do";
	var sData = {"USER_ID":id, "USER_PWD":$("#USER_PWD").val() };
	var url = "/j_spring_security_check";
	
	ajaxPost(url, sData, function(data){
		console.log(data.msg);
		//로그인후 갱신
		if(data._csrf != null && data._csrf != ""){
			$("meta[name='_csrf']").attr("content", data._csrf);
		}
		if(data.msg != null && data.msg != ""){
			console.log(data.msg);
			if (data.msg == 'password change') {
				data.msg = '비밀번호 변경요청에 대한 사업자 관리 승인 후, \n변경된 비밀번호로 로그인하실 수 있습니다.';
			} else if (data.msg == 'Invalid username and password') { //.....
				data.msg = '아이디 혹은 비밀번호가 일치하지 않습니다. 오류횟수 ('
						+ data.cnt + '/5)';
			} else if (data.msg == 'Invalid username and passwords') { //.....
				data.msg = '비밀번호 오류 회수(5회)가 초과 되었습니다. \n비밀번호 변경요청을 하시기 바랍니다';
			} else if (data.msg == 'no id') {
				data.msg = "아이디 혹은 비밀번호가 일치하지 않습니다."
			}
			alert(data.msg);
// 			return;
		}

		rtnData = data;

	    if($("#id_save").is(":checked")){ // ID 저장하기 체크했을 때,
            gfn_setCookie("SAVE_ID", id, 7); // 7일 동안 쿠키 보관
        }else{ // ID 저장하기 체크 해제 시,
            gfn_setCookie("SAVE_ID", "");
        }

	    mainMove();
	});
}

function mainMove(){
	kora.common.gfn_MoveUrl('/MAIN.do');
}
</script>

<OBJECT id=newsso style="LEFT: 0px; WIDTH: 100px; TOP: 0px; HEIGHT: 0px" classid=clsid:1CEB70FD-234E-40BD-A5CC-CFF6ACCAC133 name=newsso></object>
</head>

<!-- <body>  -->
<body>
    <input type="hidden" id="userInfo" value="${userInfo}" />
    <div id="wrap">
        <div id="container">
            <div id="login">
                <h1 class="logo"><img src="/images_m/common/logo_login.png" alt="KORA 한국순환자원유통지원센터"></h1>
                <h2 class="tit"><img src="/images_m/common/tit_login.png" alt="빈용기보증금 및 취급수수료 지급관리시스템"></h2>
                <div class="lobin_area">
                    <div class="login_box">
                        <form method="post" onsubmit="return false">
                        <div class="put_info"><input type="text" class="id_ipt" id="USER_ID" name="USER_ID" maxlength="20" title="아이디 입력" value="" placeholder="아이디" required /></div>
                        <div class="put_info mt10"><input type="password" class="pw_ipt"  id="USER_PWD" name="USER_PWD" placeholder="비밀번호" maxlength="16" title="비밀번호 입력" value="" autocomplete="off" placeholder="비밀번호" required /> </div>
                        </form>
                        <div class="btn_wrap mt20">
                            <button type="button" class="btn80 c1" onclick="fn_login()">로그인</button>
                        </div>
                        <div class="chk_wrap">
                            <label class="chk"><input type="checkbox"  name="id_save" id="id_save" /><span>ID 저장</span></label>
                        </div>
                    </div>
                </div>
                <a class="copyright2" id="btn_pop2" href="/jsp/CE_M/privacy.jsp" target="_blank" style="color: blue; cursor: pointer;">개인정보처리방침</a>
                <p class="copyright">COPYRIGHT 2021 COSMO.OR.KR ALL RIGHT RESERVED.</p>
            </div><!-- id : contents -->

        </div><!-- id : container -->

    </div><!-- id : wrap -->
</body>
</html>
