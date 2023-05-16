
var sideMenuList = new Array();
var smObject = new Object();
var smObjectT = new Object();
var errorCheck = '';

//ajax 처리 세션체크용
var gxhr = new XMLHttpRequest();
var gtoken = $("meta[name='_csrf']").attr("content");
var gheader = $("meta[name='_csrf_header']").attr("content");
/*
$.ajaxSetup({
	beforeSend: function(gxhr) {
		gxhr.setRequestHeader("AJAX", true);
		gxhr.setRequestHeader(gheader, gtoken);
    }
});
*/

var gUrl = location.href;
gUrl = gUrl.substring(gUrl.lastIndexOf("/")+1, gUrl.length);
if(gUrl.indexOf(".") > -1) gUrl = gUrl.substring(0, gUrl.lastIndexOf("."));

$(document).ready(function(){
	
	main_setting();
	
});

function main_setting(gbn){
	
	var url = "/MAIN_LIST.do";

	this.ajaxPost2(url, {}, function(rtnData){
		
		if(rtnData != null && rtnData != "") {
			
			if(rtnData.cnt != null && rtnData.cnt != "") {
				$("#RTRVL_CNT").html(rtnData.cnt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
			}
			else {
				$("#RTRVL_CNT").html(0);	
			}
			
			if(rtnData.amt != null && rtnData.amt != "") {
				$("#PAY_AMT").html(rtnData.amt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
			}
			else {
				$("#PAY_AMT").html(0);
			}
			
			/* 공지사항 */
			/*if(rtnData.notiList.length > 0){
				
				$.each(rtnData.notiList, function(idx, item){
					$("#NOTI_LIST").append(
							'<li>'+
							'	<div class="tit">'+
							'		<a id="EPWH81" href="/WH/EPWH8149001.do'+item.PARAM+'" pagetitle="공지사항" >'+item.SBJ+'</a>'+
							'	</div>'+
							'	<div class="date">'+item.REG_DTTM+'</div>'+
							'</li>'
					);
				});
				//emptyAppend($("#NOTI_LIST"), rtnData.notiList.length, 2);
			}else {
				$("#NOTI_LIST").append(
						'<li>'+
						'	<div class="tit">해당사항 없음</div>'+
						'	<div class="date"></div>'+
						'</li>'
				);
			}*/
			
		}
	});
}

function anc_confirm(ancKey){
	
	var input = {};
	input['ANC_KEY'] = ancKey;
	
	var url = "/CONFIRM_ANC.do";
	this.ajaxPost2(url, input, function(data){

		$('#alarmCnt').html('');
		$('#alarmDiv').html('');

		anc_setting('R'); //알림 재조회
	});
	
}


/**
 * jquery ajax execute
 * url, dataBody, func(실행함수)      동기 호출
 * */
function ajaxPost2(url, dataBody, func, pAsync){
	/*
	for (var key in dataBody){
		if (typeof dataBody[key] == "string"){
			if(dataBody[key] == undefined) continue;
			dataBody[key] = dataBody[key].replace(/\%/gi,"%25");
			dataBody[key] = dataBody[key].replace(/\+/gi,"%2B");
		}
		else if(typeof dataBody[key] == "object"){
			for(var i=0;i<dataBody[key].length;i++){
				if(dataBody[key][i] == undefined) continue;
				dataBody[key][i] = dataBody[key][i].replace(/\%/gi,"%25");
				dataBody[key][i] = dataBody[key][i].replace(/\+/gi,"%2B");
			}
		}
	}
	*/
	
	var async = false;
	if(pAsync != null && pAsync != "undefined") async = pAsync;
	
	$.ajax({
		url : url,
		type : 'POST',
		data : dataBody,
		dataType : 'json',
		cache : false,
		async : async,
		success : func,
		beforeSend: function(request) {
		    request.setRequestHeader("AJAX", true);
		    request.setRequestHeader(gheader, $("meta[name='_csrf']").attr("content"));
		},
		error : function(c) {
			errorCheck = 'Y';
			if(c.status == 401 || c.status == 403){
				//alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
				location.href = "/login.do";
			}else if(c.responseText != null && c.responseText != ""){
				alert("처리중 오류가 발생하였습니다. \r\n다시 시도 하십시오.");	
			}
		}
	});
}


/**
 * 쿠키값 가져오기
 * @param cookieNm
 * @returns
 */
function gfn_getCookie(cookieNm)
{
	var cookie = document.cookie;
	if(cookie.indexOf(";") > -1){
		var arr = cookie.split(";");
		for(var i=0; i<arr.length; i++){
			var tmpKey = arr[i].split("=");
			var key = $.trim(tmpKey[0]);
			var val = tmpKey[1];
			if(key == cookieNm)return unescape(val);
		}
		return "";
	}else{
		if(cookie.indexOf("=") > -1){
			var arr = cookie.split("=");
			var key = $.trim(arr[0]);
			var val = arr[1];
			if(key == cookieNm) return unescape(val);
			return "";
		}else{
			return "";
		}
	}
}

//오류 페이지 처리
function gfn_mobileCheck(){
	//모바일인경우
	if (navigator.userAgent.match(/iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson/i) != null || navigator.userAgent.match(/LG|SAMSUNG|Samsung/) != null) {
		return true;
  	}else{
  		return false;
  	}
}


/**
 * JSON 형태(object)로 리턴
 * 
 **/
function jsonObject(val){
	try{
		return eval('(' + val + ')');
	}
	catch(Exception){
		return null;
	}
}

/**************************************************************
 * 숫자에 3자리마다 콤마찍기(현금표시)
 *************************************************************/
function format_comma(val1, type){
  
	if(val1 == undefined || (val1+"") == "") return "";
	var newValue = val1+""; //숫자를 문자열로 변환
	var len = newValue.length;
	
	var minus = "";  
	var rate  = "";

	if( len > 1 ) {
		if( (type == null || type != "rate") && newValue.substring(0,1) == '0' ) 
			newValue = newValue.substring(1);

		len = newValue.length;

		if ( newValue.substring(0,1) == "-"  ) {
			minus = "-";
		}   
	}

	var ch="";
	var j=1;
	var formatValue="";

	// 콤마제거  
	newValue = newValue.replace(/\,/gi, '');
	newValue = newValue.replace(/\-/gi, '');

	// 소수점
	var rateVals = newValue.split(".");

	if(rateVals.length == 2){
		newValue = rateVals[0];
		rate = "."+rateVals[1];
	}

	// comma제거된 문자열 길이
	len = newValue.length;

	for(var i=len ; i>0 ; i--){
		ch = newValue.substring(i-1,i);
		formatValue = ch + formatValue;
		if ((j%3) == 0 && i>1 ){
			formatValue=","+formatValue;
		}
		j++;
	}

	formatValue = minus+formatValue+rate;

	return formatValue;
};
