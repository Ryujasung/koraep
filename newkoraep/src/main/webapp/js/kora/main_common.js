
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
	
	if(gUrl.indexOf("blank") > -1 || gUrl.indexOf("login") > -1 || gUrl.indexOf("logout") > -1) return;
	
	//메뉴조회 호출
	gfn_getUserMenuList(); 
	
	if(errorCheck == 'Y') return;
	
	//알림처리
	anc_setting();
	
	main_setting();
	
	//사이드 메뉴 링크 셋팅 (알림때문에 따로 실행함.)
	pub_ready();
	
});

function anc_setting(gbn){
	
	var url = "/SELECT_ANC_LIST.do";
	this.ajaxPost2(url, {}, function(ancList){
		if(ancList.length > 0){
			
			/* 알림 */
			var row = '<ul>';
			$.each(ancList, function(idx, item){
				row +=
				'<li id="'+item.ANC_KEY+'">'+
				'	<a id="'+item.MENU_ID+'" href="'+item.MENU_URL+'" pagetitle="'+item.PAGE_TITLE+'" >'+item.ANC_SBJ+'</a>'+
				'	<span class="date">'+item.REG_DTTM+'</span>'+
				'</li>';
				
				//7개 까지만 보임
				if(idx == 6) return false;
			});
			row += '</ul>';
			row += '<span onclick="anc_confirm()" style="cursor:pointer;padding:15px 9px 0px 0px;float:right;font-weight:bold">모두확인</span>';
			$('#alarmDiv').append(row);
			
			if(ancList.length > 0){
				$('#alarmCnt').append('<span class="val">'+ancList.length+'</span>');
			}
			/* 알림 */
			
			if(gbn != 'R'){ //최초 한번만 실행
				/* 알림 TOP */
				var rowTop = '<ul class="list">';
				var viewCnt = 0;
				$.each(ancList, function(idx, item){

					if(item.ANC_SE == 'C1'){ //공지사항
						rowTop +=
						'<li id="'+item.ANC_KEY+'">'+
						'	<div class="box">'+
						'		<div class="tit">'+item.ANC_SBJ+'</div>'+
						'		<div class="date">'+item.REG_DTTM+'</div>'+
						'	</div> <a class="more" id="'+item.MENU_ID+'" href="'+item.MENU_URL+'" pagetitle="'+item.PAGE_TITLE+'">more</a>'+
						'</li>';
						viewCnt++;
					}
					
					//2개 까지만 보임
					if(viewCnt == 2) return false;
				
				});
				rowTop += '</ul>';
				$('#alarmDivTop').append(rowTop);
				$('#alarmDivTop').append('<button type="button" class="close" onclick="$(\'#wrap\').addClass(\'topbannerClose\');"></button>');
	
				if(viewCnt > 0){
					$('#wrap').attr('class', ''); //탑배너 오픈
				}
				/* 알림 TOP */
			}

		}
	});
	
	if(gbn == 'R'){ //링크 셋팅 필요..
		NrvPub.IframePageAlarm();
	}
}

function emptyAppend(obj, length, colspanVal){
	//빈칸채우기
	if(length < 3){
		var cnt = 3 - length;
		for(i=0; i<cnt; i++){
			obj.append('<tr><td colspan="'+colspanVal+'"></td></tr>');
		}
	}
}

function main_setting(gbn){
	
	var url = "/MAIN_LIST.do";

	this.ajaxPost2(url, {}, function(rtnData){
		
		if(rtnData != null && rtnData != "") {
			
			if(bizrTpCd == 'M'){
				
				if(rtnData.cnt != null && rtnData.cnt != "") {
					$("#DLIVY_CNT").html(rtnData.cnt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
				}else{
					$("#DLIVY_CNT").html(0);	
				}
				
				if(rtnData.cnt2 != null && rtnData.cnt2 != "") {
					$("#CFM_CNT").html(rtnData.cnt2.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
				}else{
					$("#CFM_CNT").html(0);	
				}
				
				/* 입고관리 */
				if(rtnData.cfmList.length > 0){
					$.each(rtnData.cfmList, function(idx, item){
						$("#CFM_LIST").append(
								'<tr>'+
								'	<td><a id="EPMF29" href="MF/EPMF2983901.do'+item.PARAM+'" pagetitle="입고관리" style="text-decoration: underline">'+item.RTN_REG_DT+'</a></td>'+
								'	<td>'+item.BIZRNM+'</td>'+
								'	<td class="ta_r" style="padding-right:30px">'+format_comma(item.RTN_QTY_TOT)+'</td>'+
								'</tr>'
						);
					});
					emptyAppend($("#CFM_LIST"), rtnData.cfmList.length, 3);
				}else{
					$("#CFM_LIST").append(
							'<tr><td colspan="3"></td></tr><tr>'+
							'    <td colspan="3">해당사항 없음</td>' +
							'</tr><tr><td colspan="3"></td></tr>'
					);
				}
				
				/* 교환관리 */
				if(rtnData.exchList.length > 0){
					$.each(rtnData.exchList, function(idx, item){
						$("#EXCH_LIST").append(
								'<tr>'+
								'	<td><a id="EPMF66" href="MF/EPMF6624501.do'+item.PARAM+'" pagetitle="교환관리" style="text-decoration: underline">'+item.EXCH_REG_DT+'</a></td>'+
								'	<td>'+item.REQ_BIZRNM+'</td>'+
								'	<td class="ta_r" style="padding-right:30px">'+format_comma(item.EXCH_QTY_TOT)+'</td>'+
								'</tr>'
						);
					});
					emptyAppend($("#EXCH_LIST"), rtnData.exchList.length, 3);
				}else{
					$("#EXCH_LIST").append(
							'<tr><td colspan="3"></td></tr><tr>'+
							'    <td colspan="3">해당사항 없음</td>' +
							'</tr><tr><td colspan="3"></td></tr>'
					);
				}
				
				/* 공지사항 */
				if(rtnData.notiList.length > 0){
					$.each(rtnData.notiList, function(idx, item){
						$("#NOTI_LIST").append(
								'<tr>'+
								'	<td class="l"><a id="EPMF81" href="/MF/EPMF8149001.do'+item.PARAM+'" pagetitle="공지사항" >'+item.SBJ+'</a></td>'+
								'	<td><span class="date">'+item.REG_DTTM+'</span></td>'+
								'</tr>'
						);
					});
					emptyAppend($("#NOTI_LIST"), rtnData.notiList.length, 2);
				}else{
					$("#NOTI_LIST").append(
							'<tr><td colspan="2"></td></tr><tr>'+
							'    <td colspan="2">해당사항 없음</td>' +
							'</tr><tr><td colspan="2"></td></tr>'
					);
				}
				
			}
			else if(bizrTpCd == 'W'){
				
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
				if(rtnData.notiList.length > 0){
					
					$.each(rtnData.notiList, function(idx, item){
						$("#NOTI_LIST").append(
								'<tr>'+
								'	<td class="l"><a id="EPWH81" href="/WH/EPWH8149001.do'+item.PARAM+'" pagetitle="공지사항" >'+item.SBJ+'</a></td>'+
								'	<td><span class="date">'+item.REG_DTTM+'</span></td>'+
								'</tr>'
						);
					});
					emptyAppend($("#NOTI_LIST"), rtnData.notiList.length, 2);
				}
				else {
					$("#NOTI_LIST").append(
							'<tr><td colspan="2"></td></tr><tr>'+
							'    <td colspan="2">해당사항 없음</td>' +
							'</tr><tr><td colspan="2"></td></tr>'
					);
				}
				
				/* 알림내역 */
				if(rtnData.ancList.length > 0){
					$.each(rtnData.ancList, function(idx, item){
						$("#ANC_LIST").append(
								'<tr>'+
								'	<td class="l"><a id="'+item.MENU_ID+'" href="'+item.MENU_URL+'" pagetitle="'+item.PAGE_TITLE+'" >'+item.ANC_SBJ+'</a></td>'+
								'	<td><span class="date">'+item.REG_DTTM+'</span></td>'+
								'</tr>'
						);
					});
					emptyAppend($("#ANC_LIST"), rtnData.ancList.length, 2);
				}
				else {
					$("#ANC_LIST").append(
							'<tr><td colspan="2"></td></tr><tr>'+
							'    <td colspan="2">해당사항 없음</td>' +
							'</tr><tr><td colspan="2"></td></tr>'
					);
				}
				
				/* 입고정정확인 */
				if(rtnData.cfmCrctList.length > 0){
					$.each(rtnData.cfmCrctList, function(idx, item){
						$("#CFM_CRCT_LIST").append(
								'<tr>'+
								'	<td class="l"><a id="EPWH47" href="/WH/EPWH4704201.do'+item.PARAM+'" pagetitle="입고정정확인" >'+item.MFC_BIZRNM+'</a></td>'+
								'	<td>'+format_comma(item.CRCT_QTY_TOT)+'</td>'+
								'	<td>'+item.WRHS_CRCT_STAT_CD_NM+'</td>'+
								'</tr>'
						);
					});
					emptyAppend($("#CFM_CRCT_LIST"), rtnData.cfmCrctList.length, 3);
				}
				else {
					$("#CFM_CRCT_LIST").append(
							'<tr><td colspan="3"></td></tr><tr>'+
							'    <td colspan="3">해당사항 없음</td>' +
							'</tr><tr><td colspan="3"></td></tr>'
					);
				}
				
			}
			else if(bizrTpCd == 'T'){
				
				if(rtnData.cnt != null && rtnData.cnt != "") {
					$("#DLIVY_CNT").html(rtnData.cnt.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
				}
				else {
					$("#DLIVY_CNT").html(0);
				}
				
				if(rtnData.cnt2 != null && rtnData.cnt2 != "") {
					$("#CFM_CNT").html(rtnData.cnt2.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
				}
				else {
					$("#CFM_CNT").html(0);
				}
				
				/* 공지사항 */
				if(rtnData.notiList.length > 0){
					
					$.each(rtnData.notiList, function(idx, item){
						$("#NOTI_LIST").append(
								'<tr>'+
								'	<td class="l"><a id="EPCE81" href="/CE/EPCE8149001.do'+item.PARAM+'" pagetitle="공지사항" >'+item.SBJ+'</a></td>'+
								'	<td><span class="date">'+item.REG_DTTM+'</span></td>'+
								'</tr>'
						);
					});
					emptyAppend($("#NOTI_LIST"), rtnData.notiList.length, 2);
				}
				else {
					$("#NOTI_LIST").append(
							'<tr><td colspan="2"></td></tr><tr>'+
							'    <td colspan="2">해당사항 없음</td>' +
							'</tr><tr><td colspan="2"></td></tr>'
					);
				}
				

				/* 문의답변내역 */
				if(rtnData.askList.length > 0){
					$.each(rtnData.askList, function(idx, item){
						$("#ASK_LIST").append(
								'<tr>'+
								'	<td class="l"><a id="EPCE81" href="/CE/EPCE8126601.do'+item.PARAM+'" pagetitle="문의/답변" >'+item.SBJ+'</a></td>'+
								'	<td><span class="date">'+item.REG_DTTM+'</span></td>'+
								'</tr>'
						);
					});
					emptyAppend($("#ASK_LIST"), rtnData.askList.length, 2);
				}
				else {
					$("#ASK_LIST").append(
							'<tr><td colspan="2"></td></tr><tr>'+
							'    <td colspan="2">해당사항 없음</td>' +
							'</tr><tr><td colspan="2"></td></tr>'
					);
				}
			}			
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

function gfn_setUserMenuList(data){
	var selectedMenuId = gUrl;
		
		var menuGrpCd = "";
		var lnbTxtCheck = "";
		
		var gnbTxt = new Array();
		var lnbTxt = new Array();
		var gnbTitle = new Array();
		var adminTxt = '';
		var myTxt = '';

	  	gnbTxt.push('<ul>');

		for(var i=0; i<data.length; i++){
			
			var map = data[i];

			if(gUrl == map.MENU_CD && (map.TAB_MENU_YN == 'Y'|| map.MENU_LVL == '3')) selectedMenuId =  map.UP_MENU_CD;
			if(map.MENU_LVL != '2') continue;
			
			//사이드 상위메뉴
			if(!smObjectT.hasOwnProperty(map.MENU_GRP_CD) || i == data.length-1){
				smObjectT[map.MENU_GRP_CD] = '<h2 class="tit">' + map.MENU_GRP_NM + '</h2>';
			}

			//사이트 하위메뉴 
			//메뉴순서가 MENU_GRP_CD 별로 정렬되지 않으면 꼬임
			if(lnbTxtCheck == ""){
				lnbTxtCheck = map.MENU_GRP_CD;
			}else if(lnbTxtCheck != map.MENU_GRP_CD || i == data.length-1){

				if(i == data.length-1){//for문 마지막
					if(lnbTxtCheck != map.MENU_GRP_CD){
						smObject[lnbTxtCheck] = lnbTxt.join("").toString();
						lnbTxtCheck = map.MENU_GRP_CD;
						lnbTxt = [];
					}
					lnbTxt.push('<li><a href="' + map.MENU_URL + '" id="' + map.MENU_GRP_CD + '">' + map.MENU_NM + '</a></li>');
				}

				smObject[lnbTxtCheck] = lnbTxt.join("").toString();
				
				lnbTxtCheck = map.MENU_GRP_CD;
				lnbTxt = [];
			}
			lnbTxt.push('<li><a href="' + map.MENU_URL + '" id="' + map.MENU_GRP_CD + '">' + map.MENU_NM + '</a></li>');
			
			/*************상단메뉴 표시 안함***************/
			//관리자
			if(map.MENU_GRP_CD == "EPCE39") {
				if(adminTxt == ''){
					adminTxt = '<a href="' + map.MENU_URL + '" id="' + map.MENU_GRP_CD + '" pagetitle="'+map.MENU_NM+'">' + map.MENU_GRP_NM + '</a>';
				}
				continue;
			}
			
			//마이페이지
			if(map.MENU_GRP_CD == "EPCE55" || map.MENU_GRP_CD == "EPMF55" || map.MENU_GRP_CD == "EPWH55" || map.MENU_GRP_CD == "EPRT55") {
				if(myTxt == ''){
					myTxt = '<a href="' + map.MENU_URL + '" id="' + map.MENU_GRP_CD + '" pagetitle="'+map.MENU_NM+'">' + map.MENU_GRP_NM + '</a>';
				}
				continue;
			}
			/*************상단메뉴 표시 안함***************/
			
			if(map.MENU_GRP_CD != menuGrpCd){
				
				//상단 타이틀은 첫번째 메뉴 url로 설정
				gnbTxt.push('<li ><a href="' + map.MENU_URL + '" id="' + map.MENU_GRP_CD + '" pagetitle="'+map.MENU_NM+'">' + map.MENU_GRP_NM + '</a>');
				gnbTxt.push('<ul><li>')
				
				for(var s =0 ; s<data.length ; s++){
					if(data[i].MENU_GRP_NM == data[s].MENU_GRP_NM && data[s].MENU_LVL =='2' ){
						gnbTxt.push('<a href="' + data[s].MENU_URL + '" id="' + data[s].MENU_GRP_CD + '" pagetitle="'+data[s].MENU_NM+'">' + data[s].MENU_NM + '</a>');
					}
				}
				gnbTxt.push('</li></ul>')
			    gnbTxt.push('</li>')
				menuGrpCd = map.MENU_GRP_CD;
			}

		}// for
	    gnbTxt.push('</ul>');
		
	    $("#gnbNavi").html(gnbTxt.join("").toString());

		//사이드 타이틀
		//$(".hgroup").html('<h2 class="tit">MY메뉴</h2>');

		if(selectedMenuId != null && selectedMenuId != ""){
			$("#" + selectedMenuId).addClass("selected");
			gHelpUrl = selectedMenuId;
		}
		
		//관리자 링크 셋팅
		$("#adminLnk").html(adminTxt);
		
		//마이페이지 링크 셋팅
		$("#myLnk").html(myTxt);

} 


function gfn_getUserMenuList(){
	
	/*
	if(gUrl == null || gUrl == "" || gUrl == "blank" 
		|| gUrl.toUpperCase().indexOf("MAIN123") > -1  //임시수정
		|| gUrl.toUpperCase().indexOf("EPCE72") > -1 
		|| gUrl.toUpperCase().indexOf("EPCE87") > -1 || gUrl.toUpperCase().indexOf("POP") > -1 
		|| gUrl.toUpperCase().indexOf("SSO_LOGIN") > -1 ) return;
	*/
	
	var url = "/SELECT_USER_MENU_LIST.do";
	this.ajaxPost2(url, {}, function(data){
		if(data.length > 0){
			gfn_setUserMenuList(data);
		}
	});
	
} 

function gfn_getMyMenu(){
	
	var tmpMenuCd = "";
	
	var lnbTxt = new Array();
	lnbTxt.push('<ul>');
	tmpMenuCd = "EPMPSFMD";  //EP
	
	//주석처리  20171219
	lnbTxt.push('<li><a href="/CE/' + tmpMenuCd + '.do" id="' + tmpMenuCd + '">본인정보조회</a></li>');
	
}

//마이메뉴 클릭
function gfn_myMenu(){
	gfn_setCookie("myMenu", "1");
	//location.href = "/MAIN.do";
	
	if(document.getElementById("frmMoving") == null){
		var txt = new Array();
		txt.push('<form name="frmMoving" id="frmMoving" action="/MAIN.do" method="post">');
		txt.push('</form>');
		$(document.body).append(txt.join("").toString());
	}
	frmMoving.submit();
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
		/*return eval('(' + val + ')');*/
		return JSON.parse(val);
		//취약점점검 5858 기원우
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
