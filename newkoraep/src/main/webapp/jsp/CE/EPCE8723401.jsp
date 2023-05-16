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

<title>COSMO 자원순환보증금관리센터</title>

<link rel="stylesheet" href="/common/css/slick.css"/>
<link rel="stylesheet" href="/common/css/common.css"/>

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

<script language="javascript" defer="defer">

var rtnData;

$(document).ready(function(){
	
	/*
	var userAgent = kora.common.getUserAgent();
	if( (userAgent == 'android' || userAgent == 'ios') && window.BrowserBridge != undefined ){	
		kora.common.iWebAction('2000');
	}
	*/
	
	pub_ready();
	
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
	
	$("#btn_pop1").click(function(){	//이용약관
		NrvPub.AjaxPopup('/jsp/terms.jsp');
	});
	
	$("#btn_pop2").click(function(){	//개인정보처리방침
		NrvPub.AjaxPopup('/jsp/privacy.jsp');
	});
	
	$("#btn_pop3").click(function(){	//문의하기
		//NrvPub.AjaxPopup('/jsp/CE/EPCE8149088.jsp');
		window.open("/EP/EPCE0098201.do?_csrf=${_csrf.token}", "InstallVestCert", "width=840, height=700, menubar=no,status=no,toolbar=no,resizable=1,scrollbars=1");
	});
	
	/*
	var msg = '<c:out value="${msg}" />';
	if(msg != ""){
		alertMsg(msg);
	}
	$("#USER_ID").focus();
	*/
	
	/******** session time out 시 로그인창 위치 처리 *************
	var obj = top.$(".logo > a");
	if(obj != null && obj.length > 0){
		for(var i=0; i<obj.length; i++){
			if($(obj).eq(i).attr("id") == "main"){
				top.location.href = "/login.do";
				return;
			}
		}
		if(opener != null && typeof(opener) != "undefined") {
			opener.location.href = "/login.do";
			self.close();
		}
	}
	/************************************************************/

	//iframe 안에서 세션종료등으로 로그인화면으로 넘어갈때..
	var isInIframe = window.frameElement && window.frameElement.nodeName == "IFRAME";
	//var isInIframe = (window.location != window.parent.location);
	if(isInIframe==true){
		window.parent.location = "/login.do";
	}
	
	
	if(!gfn_getBrowserType()){
    	var msg = "현재 사용하고 계시는 인터넷 익스플로러(IE)의 버전(10 이하)에서는 \n본 시스템의 지원이 원할하지 않으며, ";
    	msg = msg + "최신버전으로 업데이트 하거나, \n다른 브라우저(크롬, 파이어폭스, 오페라 등)를 설치 후 사용하시기 바랍니다.";
    	alertMsg(msg);
	}
	
	var userId = gfn_getCookie("SAVE_ID");
	if(userId != null && userId != "") $("input[name='USER_ID']").val(userId);
	$("#id_save").attr("checked", true); // ID 저장하기를 체크 상태로 두기.
	
	fn_popMng();
	//kora.common.gfn_callView();	//문의하기 버튼 보임/숨김
	
});

//팝업관리등록 - 팝업 리스트
function fn_popMng(){
	
	//팝업관리등록 - 팝업 리스트
	var popMngList = jsonObject($("#popMngList").val());
	for(var i=0; i<popMngList.length; i++){
		var popMap = popMngList[i];
		var popNm = "mngPop" + popMap.POP_SEQ;
		var w = popMap.POP_WID;
		var h = popMap.POP_HGT;
		var top = popMap.VIEW_LC_TOP;
		var left = popMap.VIEW_LC_LFT;
		if(gfn_getCookie(popNm) != "done"){
			window.open("/jsp/mngPopup.jsp?_csrf=<c:out value='${_csrf.token}'/>&POP_SEQ=" + popMap.POP_SEQ, popNm, 'width=' + w + ', height=' + h + ', left=' + left + ', top=' + top + ', resizable=1, location=0, toolbar=0');
		}
	}

	//키보드 보안에 의해 event.keyCode 방지
	$("#USER_ID, #USER_PWD").bind("keyup", function(){
		if(event.keyCode == 13) fn_login();
	});
	
	/*
	//kora.or.kr 팝업
	if(gfn_getCookie("koraPop") != "done"){
		window.open("/jsp/koraPopup.jsp",'koraPop','width=465, height=390, left=100, top=100, resizable=1, location=0, toolbar=0');
	}
	
	if(gfn_getCookie("dpPop") != "done"){
		window.open("/jsp/notiPopup2.jsp",'dpPop','width=550, height=650, left=300, top=100, resizable=1, location=0, toolbar=0');
	}
	
	if(gfn_getCookie("dpPop2") != "done"){
		window.open("/jsp/notiPopup.jsp",'dpPop2','width=550, height=315, left=100, top=100, resizable=1, location=0, toolbar=0');
	}
	 
	if(gfn_getCookie("dpPop3") != "done"){
		window.open("/jsp/notiPopup3.jsp",'dpPop3','width=550, height=265, left=200, top=200, resizable=1, location=0, toolbar=0');
	}
	
	if(gfn_getCookie("dpPopInfo") != "done"){
		window.open("/jsp/notiPopup4.jsp",'dpPopInfo','width=550, height=345, left=300, top=300, resizable=1, location=0, toolbar=0');
	}
	*/
}


//로그인
function fn_login() {
 	
	$("#loginError").text("");
	
	var id = $("#USER_ID").val();
	if(id == "") {
		alertMsg("아이디를 입력하세요");
		return;
	}else if($("#USER_PWD").val() == "") {
		alertMsg("비밀번호를 입력하세요");
		return;
	}

	//var sData = {"USER_ID":id, "USER_PWD":$("#USER_PWD").val(), "PUSH_TK":"1", "UUID":"2", "PUSH_TP":"3", "OS_VER":"4", "DEVICE_NM":"5"};
	//var url = "/MBL_LOGIN.do";
			var status = "LOGIN";
			var userid = id;
			var pwd = "1111"
			var clsid ="{1CEB70FD-234E-40BD-A5CC-CFF6ACCAC133}";
			var dsdcode = "0100000000001428";
			
 			var word = "";
 			word = word + "status@@EQUAL@@"+status+"@@DELIM@@";
 			word = word + "id@@EQUAL@@"+userid+"@@DELIM@@";
 			word = word + "pwd@@EQUAL@@"+pwd+"@@DELIM@@";
 			word = word + "clsid@@EQUAL@@"+clsid+"@@DELIM@@";
 			word = word + "dsdcode@@EQUAL@@"+dsdcode;
			//var word = status+userid+pwd+clsid+dsdcode ;
			var base64 = btoa(word);
			
			var urlEncoded = encodeURI(base64);
	var sData = {"USER_ID":id, "USER_PWD":$("#USER_PWD").val() };
	
	var url = "/j_spring_security_check";
			//console.log(url);
// 	var method ="post";
// 	var xmlHttp = new XMLHttpRequest();
// 	xmlHttp.open(method,url);
	ajaxPost(url, sData, function(data){
	    rtnData = data;
		//로그인후 갱신
		if(data._csrf != null && data._csrf != ""){
			$("meta[name='_csrf']").attr("content", data._csrf);
		}
		
		try{
 			
			if(data.BIZR_TP_CD == "T1"){
				console.log("if");
				location.href="fssoexcast://setuserinfo?msg="+urlEncoded;
			}else{
				console.log("else");
				var logonID = newsso.SetUserInfo("LOGIN", "0100000000001428", id, "1111","","","","","","","","","","");
			}
// 			location.href="fssoexcast://setuserinfo?msg="+urlEncoded;
			//fasoo 로그인
  			
		}catch(exception){
			//설치가 안되어있을경우 예외처리
		}
		//ajaxPost("/UPDATE_EPCN_MBL_USER_INFO.do", sData, function(data){}, false);
		if(data.msg != null && data.msg != ""){
			
			if(data.msg == 'password change'){ 
				data.msg = '비밀번호 변경요청에 대한 사업자 관리 승인 후, \n변경된 비밀번호로 로그인하실 수 있습니다.';
			}else if(data.msg == 'Invalid username and password'){ //.....
				data.msg = '아이디 혹은 비밀번호가 일치하지 않습니다. 오류횟수 ('+data.cnt+'/5)';
			}else if(data.msg == 'Invalid username and passwords'){ //.....
				data.msg = '비밀번호 오류 회수(5회)가 초과 되었습니다. \n비밀번호 변경요청을 하시기 바랍니다';
			}else if(data.msg =='no id'){
				data.msg ="아이디 혹은 비밀번호가 일치하지 않습니다."
			}
			alertMsg(data.msg);
		}else{
			
			if(data.PRSN_INFO_CHG_AGR_YN != null && data.PRSN_INFO_CHG_AGR_YN != "Y") {
			    chkAgreement();			    
			}
			else if( (data.BIZR_TP_CD == "W1" || data.BIZR_TP_CD == "W2") && data.AFF_OGN_CD == "") {
                chkAffOgnCd();             
			}else if( (data.BIZR_TP_CD == "W1" || data.BIZR_TP_CD == "W2") && data.ERP_CFM_YN == "N") {
                chkErpCd();
			}
			else {
				
			    if($("#id_save").is(":checked")){ // ID 저장하기 체크했을 때,
	                gfn_setCookie("SAVE_ID", id, 7); // 7일 동안 쿠키 보관
	            }else{ // ID 저장하기 체크 해제 시,
	                gfn_setCookie("SAVE_ID", "");
	            }
			    
				if(data.svyMsg != "") {
					if (data.popupYn == "Y") {
						chkSvyAnswer();
					} else {
						alertMsg(data.svyMsg, 'mainNoti');
					}
				}
			    else {
				    mainNoti();
			    }
			}
		}
	});
	
}

function chkAgreement() {
    NrvPub.AjaxPopup('/jsp/privacyAgreement.jsp', '', '');
}

function chkAffOgnCd() {
    NrvPub.AjaxPopup('/CE/EPCE01810883.do', '','');
}

function chkErpCd() {
    NrvPub.AjaxPopup('/CE/EPCE01810884.do', '','');
}

function chkSvyAnswer() {
    NrvPub.AjaxPopup('/CE/EPCE81606533.do', '', '');
}


function mainNoti() {
    if(rtnData.noti != null && rtnData.noti != ""){
        alertMsg(rtnData.noti, 'mainMove');
    }else{
        mainMove();
    }
}

function mainMove(){
	kora.common.gfn_MoveUrl('/MAIN.do');
}

//ID찾기
function fn_idFind(){
	NrvPub.AjaxPopup('/EP/EPCE87234882.do', '', '');
}

//비번변경 요청
function fn_reqPassChg(){
	NrvPub.AjaxPopup('/EP/EPCE8723488.do', '', '');
}

/*
function fn_move(tf){
	if(!tf) return;
	window.open("/EPMN/EPMNCNPC.do", "PWDCHG", "width=370, height=320, left=100, top=30, menubar=no,status=no,toolbar=no, resizable=1");
}
*/

//회원가입
		function fn_memReg() {
			var ment = "이 사이트는 빈병(소주, 맥주 등) 관련 사업자용입니다.\n 1회용 컵 관련 사업자는 아래 주소를 눌러주시기 바랍니다. \n  1회용 컵 시스템 주소 : "+"<a href='https://cupcms.cosmo.or.kr' target='_blank'><u>https://cupcms.cosmo.or.kr</u></a>"
			confirm(ment,'location_fnMemReg');
// 			NrvPub.AjaxPopup('/EP/EPCE872340188.do', '', '');
		}

		function location_fnMemReg() {
			location.href = "/EP/EPCE0085201.do" + "?_csrf="
					+ '<c:out value='${_csrf.token}' />';
		}

//회원가입안내(절차)
function fn_preView(){
	NrvPub.AjaxPopup('/EP/EPCE00852886.do', '', '');
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

function setAgreement() {
    
    var id = $("#USER_ID").val();
    
    var sData = {"USER_ID":id, "PRSN_INFO_CHG_AGR_YN":"Y" };
    var url = "/UPDATE_PRSN_INFO_CHG_AGR_YN.do";

    ajaxPost(url, sData, function(data){

        if(data.RSLT_CD != null && data.RSLT_CD != "0000"){
            alertMsg(data.RSLT_MSG);
        }
        else{
            if( (rtnData.BIZR_TP_CD == "W1" || rtnData.BIZR_TP_CD == "W2") && rtnData.AFF_OGN_CD == "") {
                chkAffOgnCd();
            }
            else {
                if($("#id_save").is(":checked")){ // ID 저장하기 체크했을 때,
                    gfn_setCookie("SAVE_ID", id, 7); // 7일 동안 쿠키 보관
                }else{ // ID 저장하기 체크 해제 시,
                    gfn_setCookie("SAVE_ID", "");
                }

                if(rtnData.noti != null && rtnData.noti != ""){
                    alertMsg(rtnData.noti, 'mainMove');
                }else{
                    mainMove();
                }
            }
        }
    });
}

function setAffOgnCd(cd) {
    mainMove();
}

</script>

<OBJECT id=newsso style="LEFT: 0px; WIDTH: 100px; TOP: 0px; HEIGHT: 0px" classid=clsid:1CEB70FD-234E-40BD-A5CC-CFF6ACCAC133 name=newsso></object>
</head>

<!-- <body>  -->
<body onload="TK_Loading();">

<div id="login" class="winter"><!-- class : spring, summer, fall, winter -->
	
	<input type="hidden" id="msg" value="<c:out value='${msg}'/>" />
	<input type="hidden" id="popMngList" value="<c:out value='${popMngList}'/>" />
			
	<div class="login_inner">
		<h1 class="logo"><a href="http://www.cosmo.or.kr" target="_new"><img src="/images/login/logo.png" alt="COSMO 자원순환보증금관리센터"></a></h1>
		<h2 class="log_title">빈용기보증금 및 취급수수료<br>지급관리시스템</h2>
		<div class="greet">
			<p class="txt1">We use, <strong>Reuse</strong></p>
			<p class="txt2">다~쓰고 다시쓰고</p>
			<p class="sub">여러분이 환경을 살리는 주역입니다.</p>
		</div>
		<div class="login_box">
			<div class="login_box_inner">
				<form method="post" onsubmit="return false">
					<input type="text" class="id_ipt" id="USER_ID" name="USER_ID" maxlength="20" title="아이디 입력" value="" required />
					<input type="password" class="pw_ipt"  id="USER_PWD" name="USER_PWD" placeholder="비밀번호" maxlength="16" title="비밀번호 입력" value="" autocomplete="off" required />
				</form>
					<button id="btn_login" title="로그인" class="log_submit" onclick="fn_login()">로그인</button>
					<div class="utils">
						<label class="chk"><input type="checkbox"  name="id_save" id="id_save" /><span>ID저장</span></label>
						<a href="javascript:fn_idFind();">ID찾기</a>
						<a href="javascript:fn_reqPassChg();">비밀번호 변경</a>
					</div>
			</div>
			<div class="join_menu">
				<a href="javascript:fn_memReg();">회원가입</a>
				<a href="javascript:fn_preView();">회원가입 안내</a>
			</div>
		</div>
	</div>
	
	<div class="login_footer">
		<div class="ft_inner">
			<ul class="ft_menu">
				<li><a class="" id="btn_pop1" style="cursor: pointer;">이용약관</a></li>
				<li><a class="" id="btn_pop2" style="color: blue;cursor: pointer;">개인정보처리방침</a></li>
			</ul>
			<address class="address">
				<span>03149 서울특별시 종로구 인사동7길 12, 자원순환보증금관리센터(백상빌딩 10층)</span>
				<span>TEL : 1522-0082</span>
				<span>FAX : 02-535-6464</span>
			</address>
			<p class="copyright">COPYRIGHT 2021 COSMO.OR.KR ALL RIGHT RESERVED.</p>
			<button type="button" id="btn_pop3" class="btn_inquiry"><span>문의하기 1522-0082</span></button>
		</div>
	</div>
		
	
</div>
</body>
</html>
