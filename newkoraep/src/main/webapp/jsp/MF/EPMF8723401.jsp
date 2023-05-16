<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
 /**
  * @Class Name : EPMNCNDP.jsp
  * @Description : EPMNCNDP List 화면
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
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>로그인</title>

<meta name="viewport" content="width=1100, user-scalable=no" />

<link rel="stylesheet" href="/common/css/common.css"/>


<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>

<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>
<script src="/js/jquery/jquery-ui.js"></script>
<script src="/js/jquery/jquery.ui.datepicker-ko.js"></script>

<script src="/common/js/jquery-1.11.1.min.js"></script>
<script src="/common/js/mobile-detect.min.js"></script>
<script src="/common/js/slick.js"></script>
<script src="/common/js/pub.plugin.js"></script>
<script src="/common/js/pub.common.js"></script>

<script src="/TouchEn/nxKey/js/TouchEnNxKey.js"></script>

<script src="/js/kora/kora_common.js"></script>

<script type="text/javaScript" language="javascript" defer="defer">

$(document).ready(function(){

	var msg = "${msg}";
	if(msg != ""){
		alertMsg(msg);
	}
	$("#USER_ID").focus();
	
	/******** session time out 시 로그인창 위치 처리 *************/
	var obj = top.$(".logo > a");
	if(obj != null && obj.length > 0){
		alert('cao ni ma');
		for(var i=0; i<obj.length; i++){
			if($(obj).eq(i).attr("id") == "main"){
				top.location.href = "/login.do";
				return;
			}
		}
		if(typeof(opener) != "undefined") {
			opener.location.href = "/login.do";
			self.close();
		}
	}
	/************************************************************/
	
	
	pub_ready();
	
	//팝업관리등록 - 팝업 리스트
	/*
	var popMngList = ${popMngList};
	for(var i=0; i<popMngList.length; i++){
		var popMap = popMngList[i];
		var popNm = "mngPop" + popMap.RGST_SEQ;
		var w = popMap.POP_WIDTH;
		var h = popMap.POP_HEIGHT;
		var top = popMap.VIEW_LC_TOP;
		var left = popMap.VIEW_LC_LFT;
		if(gfn_getCookie(popNm) != "done"){
			window.open("/jsp/mngPopup.jsp?RGST_SEQ=" + popMap.RGST_SEQ, popNm, 'width=' + w + ', height=' + h + ', left=' + left + ', top=' + top + ', resizable=1, location=0, toolbar=0');
		}
	}
	*/
	
	//키보드 보안에 의해 event.keyCode 방지
	/*
	$("#USER_ID, #USER_PWD").bind("keyup", function(){
		if(event.keyCode == 13) fn_login();
	});
	*/
	
	//kora.or.kr 팝업
	/*
	if(gfn_getCookie("koraPop") != "done"){
		window.open("/jsp/koraPopup.jsp",'koraPop','width=465, height=390, left=100, top=100, resizable=1, location=0, toolbar=0');
	}
	
	if(gfn_getCookie("dpPop") != "done"){
		window.open("/jsp/notiPopup2.jsp",'dpPop','width=550, height=650, left=300, top=100, resizable=1, location=0, toolbar=0');
	}
	*/
	/*
	if(gfn_getCookie("dpPop2") != "done"){
		window.open("/jsp/notiPopup.jsp",'dpPop2','width=550, height=315, left=100, top=100, resizable=1, location=0, toolbar=0');
	}
	 
	if(gfn_getCookie("dpPop3") != "done"){
		window.open("/jsp/notiPopup3.jsp",'dpPop3','width=550, height=265, left=200, top=200, resizable=1, location=0, toolbar=0');
	}
	 */
	/*
	if(gfn_getCookie("dpPopInfo") != "done"){
		window.open("/jsp/notiPopup4.jsp",'dpPopInfo','width=550, height=345, left=300, top=300, resizable=1, location=0, toolbar=0');
	}
	*/
	/*
	gfn_setCookie("MBR_SE_CD", "");
	gfn_setCookie("USER_SE_CD", "");
	gfn_setCookie("USER_NM", "");
	
	gfn_setCookie("CET_BROF_CD", "");	//센타구분
	gfn_setCookie("GRP_NM", "");	//메뉴그룹명
	gfn_setCookie("GRP_CD", "");	//메뉴그룹코드
	
	gfn_setCookie("BIZRNM", "");
	gfn_setCookie("LAST_LGN_DT", "");
	gfn_setCookie("CG_DTSS_NO", "");
	
	
	
	var userId = gfn_getCookie("SAVE_ID");
	$("input[name='USER_ID']").val(userId); 
     
    if($("input[name='USER_ID']").val() != ""){ // 그 전에 ID를 저장해서 처음 페이지 로딩 시, 입력 칸에 저장된 ID가 표시된 상태라면,
        $("#id_save").attr("checked", true); // ID 저장하기를 체크 상태로 두기.
    }
     
    $("#id_save").change(function(){ // 체크박스에 변화가 있다면,
        if($("#id_save").is(":checked")){ // ID 저장하기 체크했을 때,
            var userId = $("input[name='USER_ID']").val();
            gfn_setCookie("SAVE_ID", userId, 7); // 7일 동안 쿠키 보관
        }else{ // ID 저장하기 체크 해제 시,
        	gfn_setCookie("SAVE_ID", "");
        }
    });
     
    // ID 저장하기를 체크한 상태에서 ID를 입력하는 경우, 이럴 때도 쿠키 저장.
    $("input[name='USER_ID']").keyup(function(){ // ID 입력 칸에 ID를 입력할 때,
        if($("#id_save").is(":checked")){ // ID 저장하기를 체크한 상태라면,
            var userId = $("input[name='USER_ID']").val();
            gfn_setCookie("SAVE_ID", userId, 7); // 7일 동안 쿠키 보관
        }
    });
    
    
    kora.common.gfn_callView();
	*/
	
	if(!gfn_getBrowserType()){
    	var msg = "현재 사용하고 계시는 인터넷 익스플로어(IE)의 버전(10 이하)에서는 \n본 시스템의 지원이 원할하지 않으며, ";
    	msg = msg + "최신버전으로 업데이트 하거나, \n다른 브라우저(크롬, 파이어폭스, 오페라 등)를 설치 후 사용하시기 바랍니다.";
    	alertMsg(msg);
	}
	
});



//로그인
function fn_login() {
	$("#loginError").text("");
	
	if($("#USER_ID").val() == "") {
		alertMsg("아이디를 입력하세요");
		return;
	}else if($("#USER_PWD").val() == "") {
		console.log('sss');
		alertMsg("비밀번호를 입력하세요");
		return;
	}

	var sData = {"USER_ID":$("#USER_ID").val(), "USER_PWD":$("#USER_PWD").val(), "_csrf": $("#_csrf").val()};
	var url = "/j_spring_security_check";	//---"/USER_LOGIN_CHECK.do";
	ajaxPost(url, sData, function(data){
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
			alertMsg(data.msg);
// 			return;
		}else{
			kora.common.gfn_MoveUrl('/MAIN.do');
		}
	});
	
	/*
	var sData = {"USER_ID":$("#USER_ID").val(), "USER_PWD":$("#USER_PWD").val(), "_csrf": $("#_csrf").val()};
	var url = "/j_spring_security_check";	//"/USER_LOGIN_CHECK.do";
	ajaxPost(url, sData, function(data){
		if(data.msg != null && data.msg != ""){
			alertMsg(data.msg);
			return;
		}else{
			if(data.noti != null && data.noti != ""){	//패스워드 유효기간 만료 메세지
				alertMsg(data.noti);
			}
			gfn_setCookie("MBR_SE_CD", data.MBR_SE_CD);		//회원구분 - A:센터, B:제조사, C:도매상
			gfn_setCookie("USER_SE_CD", data.USER_SE_CD);	//사용자구분 - 1: 관리자, 2: 업무담당자
			gfn_setCookie("CET_BROF_CD", data.CET_BROF_CD);	//센타구분
			gfn_setCookie("USER_NM", data.USER_NM);
			gfn_setCookie("USER_ID", data.USER_ID);
			gfn_setCookie("GRP_NM", data.GRP_NM);	//메뉴그룹명
			gfn_setCookie("GRP_CD", data.GRP_CD);	//메뉴그룹코드
			
			gfn_setCookie("BIZRNM", data.BIZRNM);
			gfn_setCookie("LAST_LGN_DT", data.LAST_LGN_DT);
			gfn_setCookie("CG_DTSS_NO", data.CG_DTSS_NO);
			
			
			if($("#id_save").is(":checked")){ // ID 저장하기 체크했을 때,
				gfn_setCookie("SAVE_ID", data.USER_ID, 7); // 7일 동안 쿠키 보관
	        }else{ // ID 저장하기 체크 해제 시,
	        	gfn_setCookie("SAVE_ID", "");
	        }
			
			kora.common.gfn_MoveUrl('/MAIN.do');
		}
	});
	*/
}

//아이디 찾기
function fn_findId(){
	window.open("/EPMN/EPMNCNIF.do", "IDFIND", "width=380, height=300, left=100, top=30, menubar=no,status=no,toolbar=no, resizable=1");	
}

//비번변경 요청
function fn_reqPassChg(){
	
	window.open("/EPMN/EPMNCNPC.do", "PWDCHG", "width=370, height=350, left=100, top=30, menubar=no,status=no,toolbar=no, resizable=1");
	//패스워드변경 - 인증서체크 없애고 본인인증으로 대체 2015.12.10
	//window.open("/EPMN/VestCertInstall.do", "InstallVestCert", "width=800, height=500, menubar=no,status=no,toolbar=no, resizable=1");
}

/*
function fn_move(tf){
	if(!tf) return;
	window.open("/EPMN/EPMNCNPC.do", "PWDCHG", "width=370, height=320, left=100, top=30, menubar=no,status=no,toolbar=no, resizable=1");
}
*/

//회원가입
function fn_memReg(){
	location.href = "/EPMN/EPMNCNBM.do";
}

//회원가입안내(절차)
function fn_preView(){
	window.open("/EPMN/EPMNCNBF.do", "InstallVestCert", "width=800, height=655, menubar=no,status=no,toolbar=no,scrollbar=auto");	
}


function gfn_getBrowserType(){
    
    var _ua = navigator.userAgent;
    var rv = -1;
     
    //IE 11,10,9,8
    var trident = _ua.match(/Trident\/(\d.\d)/i);
    if( trident != null ){
    	/*
        if( trident[1] == "7.0" ) return rv = "IE" + 11;
        if( trident[1] == "6.0" ) return rv = "IE" + 10;
        if( trident[1] == "5.0" ) return rv = "IE" + 9;
        if( trident[1] == "4.0" ) return rv = "IE" + 8;
        */
    	if( trident[1] == "7.0" || trident[1] == "6.0" ) return true;
    	if( trident[1] == "5.0" || trident[1] == "4.0" ) return false;
    }
     
    //IE 7...
    //if( navigator.appName == 'Microsoft Internet Explorer' ) return rv = "IE" + 7;
    if( navigator.appName == 'Microsoft Internet Explorer' ) return false;

    return true;
    
    /*
    var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
    if(re.exec(_ua) != null) rv = parseFloat(RegExp.$1);
    if( rv == 7 ) return rv = "IE" + 7; 
    */
     /*
    //other
    var agt = _ua.toLowerCase();
    if (agt.indexOf("chrome") != -1) return 'Chrome';
    if (agt.indexOf("opera") != -1) return 'Opera'; 
    if (agt.indexOf("staroffice") != -1) return 'Star Office'; 
    if (agt.indexOf("webtv") != -1) return 'WebTV'; 
    if (agt.indexOf("beonex") != -1) return 'Beonex'; 
    if (agt.indexOf("chimera") != -1) return 'Chimera'; 
    if (agt.indexOf("netpositive") != -1) return 'NetPositive'; 
    if (agt.indexOf("phoenix") != -1) return 'Phoenix'; 
    if (agt.indexOf("firefox") != -1) return 'Firefox'; 
    if (agt.indexOf("safari") != -1) return 'Safari'; 
    if (agt.indexOf("skipstone") != -1) return 'SkipStone'; 
    if (agt.indexOf("netscape") != -1) return 'Netscape'; 
    if (agt.indexOf("mozilla/5.0") != -1) return 'Mozilla';
    */
}
</script>


</head>

<body onload="TK_Loading();"  class="mainbg">
<div id="wrap">
	
	<div id="container_main">
	
		<header class="mainLogo">
			<h1><a href="http://www.kora.or.kr" target="_new"><img src="/images/img_logo2.png" alt="KORA 한국순환자원유통지원센터" /></a></h1>
		</header>

		<form name="frmLogin" id="frmLogin" method="post" onsubmit="fn_login();return false;">
		<div class="content_mian">
			<div class="title">
				<p class="name"><img src="/images/txt_m_tit1.png" alt="한국순환자원유통지원센터" /></p>
				<p><img src="/images/txt_m_tit2.png" alt="빈용기보증금 및 취급수수료 지급관리시스템" /></p>
			</div>
			
			<fieldset>
				<legend>로그인</legend>
				<div class="loginBox">
					<p class="inputBox id">
						<input type="text"  placeholder="아이디" class="int_txt" id="USER_ID" name="USER_ID" maxlength="20" title="아이디 입력" value="" required />
					</p>
					<p class="inputBox pw">
						<input type="password" id="USER_PWD" name="USER_PWD"  class="int_txt" placeholder="비밀번호" maxlength="16" title="비밀번호 입력" value="" autocomplete="off" required />
					</p>
					<p class="btn_login">
						<input type="hidden" id="_csrf" name="${_csrf.parameterName}" value="${_csrf.token}" />
						<input type="submit" title="로그인" value="로그인" />
					</p>
					
					<div class="check_info">
						<span><input type="checkbox" name="id_save" id="id_save" /> <label for="id_save">ID저장</label></span>
						<span><a href="javascript:fn_findId();">ID찾기</a></span>
						<span><a href="javascript:fn_reqPassChg();">비밀번호변경</a></span>
					</div>
				</div>
				<div class="join_link">
					<span class="mb"><a href="javascript:fn_memReg();">회원가입</a></span>
					<span><a href="javascript:fn_preView();">회원가입 안내</a></span>
				</div>
			</fieldset>
		</div>
		</form>
		
		
	</div>
	
	<footer id="footer" class="main_footer">

	</footer>
</div>
</body>
</html>