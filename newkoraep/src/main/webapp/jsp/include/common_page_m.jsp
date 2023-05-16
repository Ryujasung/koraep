<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />

<link rel="stylesheet" href="/common_m/css/font.css">
<link rel="stylesheet" href="/common_m/css/reset.css">
<link rel="stylesheet" href="/common_m/css/slick.css">
<link rel="stylesheet" href="/common_m/css/common.css">

<!-- 페이징 관련 스타일 -->
<style type="text/css">
	.gridPaging { text-align:center; font-weight: 700; font-size: 28px; width:100%; color: #222222; padding:15px 0px 15px 0px; }
	.gridPaging a { padding:3px 5px 3px 5px; }
	.gridPaging a:link { color:#222222;  }
	.gridPaging a:visited { color:#222222;  }
	.gridPaging a:active { }
	.gridPagingMove { font-weight:bold; }
	.gridPagingDisable { font-weight:bold; color:#cccccc; padding:3px 5px 3px 5px;}
	.gridPagingCurrent { font-weight:bold; background: #3c4258; color: #ffffff; padding:3px 5px 3px 5px;}
</style>

<link rel="stylesheet" type="text/css" href="/rMateGrid/rMateGridH5/Assets/rMateH5.css"/>
<script type="text/javascript" src="/rMateGrid/LicenseKey/rMateGridH5License.js"></script>	<!-- rMateGridH5 라이센스 -->
<script type="text/javascript" src="/rMateGrid/rMateGridH5/JS/rMateGridH5.js"></script>		<!-- rMateGridH5 라이브러리 -->
<script type="text/javascript" src="/rMateGrid/rMateGridH5/JS/jszip.min.js"></script>

<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>

<script src="/common_m/js/jquery-3.2.1.min.js"></script>
<script src="/common_m/js/jquery.cookie.js"></script>
<script src="/common_m/js/vue.min.js"></script>
<script src="/common_m/js/mobile-detect.min.js"></script>
<script src="/common_m/js/slick.js"></script>
<script src="/common_m/js/jquery.datepicker.js"></script>
<script src="/common_m/js/common.js"></script>

<script src="/js/kora/kora_common_m.js"></script>
<script src="/js/crypto/aes.js"></script>
<script src="/js/crypto/sha256.js"></script>

<script>
var ttObject;
var passphrase = "webcashkoraepse";

$(document).ready(function() {

    $('#title').text('<c:out value="${titleSub}" />');

    $('#aside .user_info .user_area .user .id').text("<c:out value='${userInfo}' />");

    ttObject = jsonObject($("#ttObject").val()); //파라미터 데이터
    var mmObject = jsonObject($("#mmObject").val()); //파라미터 데이터

    /* 죄측 메뉴셋팅 */
    var menuGrpCd = '';
    var gnbTxt = new Array();
    gnbTxt.push('<ul>');
    $.each(mmObject, function(i, v) {

        if (v.MENU_GRP_CD == 'EPWH55' || v.MENU_GRP_CD == 'EPRT55') { //마이페이지 제외..
            return true; // continue;
        }

        if (v.MENU_GRP_CD != menuGrpCd) { //2레벨 메뉴 시작

            if (menuGrpCd != '') { //첫 메뉴 다음부터 처리
                gnbTxt.push('</ul></div></li>');
            }

            gnbTxt.push('<li><a>' + v.MENU_GRP_NM + '</a><div class="depth2"><ul>');
            menuGrpCd = v.MENU_GRP_CD;
        }

        gnbTxt.push('<li><a href="' + v.MENU_URL + '">' + v.MENU_NM + '</a></li>');
        //gnbTxt.push('<li><a href="'+v.MENU_URL+'?_csrf='+$("meta[name='_csrf']").attr("content")+'">'+v.MENU_NM+'</a></li>');

    });
    gnbTxt.push('</ul></div></li></ul>');
    $("#gnb").html(gnbTxt.join("").toString());
    /* 죄측 메뉴셋팅 */


    $("#alarmCnt").click(function() {
        if (!$('#alarmDiv').is(':visible')) {
            $("#alarmDiv").show();
        } else {
            $("#alarmDiv").hide();
        }
    });
    //좌측메뉴 활성화
    newriver.init.onLoad();

    //알림처리
    anc_setting();
});

function alarmCntBtn_Click() {
    console.log("click");
    console.log($('#alarmCnt').is(':visible'));

    if (!$('#alarmCnt').is(':visible')) {
        alert("알람이 없습니다.");
    }
}

//알림처리 모바일
function anc_setting(gbn) {

    var url = "/SELECT_ANC_LIST_M.do";
    this.ajaxPost2(url, {}, function(ancList) {
        if (ancList.length > 0) {
        	console.log('ancList'+ancList);
            /* 알림 */
            var row = '<ul>';
            $.each(ancList, function(idx, item) {
                row +=
                    '<li id="' + item.ANC_KEY + '">' +
                    '   <a id="' + item.MENU_ID + '" href="javascript:anc_confirmOne_m(' + "\'" + item.MENU_URL + "\'" + ', ' + "\'" + item.ANC_KEY + "\'" + ');" pagetitle="' + item.PAGE_TITLE + '" >' + item.ANC_SBJ + '</a>' +
                    //' <span class="date">'+item.REG_DTTM+'</span>'+
                    '</li>';

                //7개 까지만 보임
                if (idx == 6) return false;
            });
            row += '</ul>';
            row += '<span onclick="anc_confirm_m()" style="cursor:pointer;padding:15px 9px 0px 0px;float:right;font-weight:bold">모두확인</span>';
            $('#alarmDiv').append(row);

            if (ancList.length > 0) {
                $('#alarmCnt').text(ancList.length);
                $(".alarmCntDiv").show();
            }
            /* 알림 */

        } else {
            $(".alarmCntDiv").hide();
        }
    });
}

//해당알림 읽음 처리후 페이지 이동
function anc_confirmOne_m(ancUrl, ancKey) {
    var input = {};
    input['ANC_KEY'] = ancKey;

    var url = "/CONFIRM_ANC.do";
    this.ajaxPost2(url, input, function(data) {
        location.href = ancUrl;
    });
}

//알람 일괄 확인 처리 모바일
function anc_confirm_m(ancKey) {
    var input = {};
    input['ANC_KEY'] = ancKey;

    var url = "/CONFIRM_ANC.do";
    this.ajaxPost2(url, input, function(data) {
        $("#alarmDiv").hide();
        $('#alarmCnt').html('');
        $('#alarmDiv').html('');

        anc_setting('R'); //알림 재조회
    });
}

//다국어
function fn_text(str) {
    return ttObject[str];
}

//버튼셋팅
function fn_btnSetting(val) {

    var menuCd;
    if (val != '' && val != undefined) {
        menuCd = val;
    } else {
        menuCd = gUrl;
    }

    ajaxPost("/SELECT_BTN_LIST.do", {"MENU_CD": menuCd}, function(data) {
        if (data.length > 0) {
            $.each(data, function(i, v) {
                $("[id='" + v['BTN_LC_SE'] + "']").append(v['EXEC_INFO']);

                if (v['BTN_CD'].indexOf('btn_excel_reg') > -1) {
                    $("[id='" + v['BTN_LC_SE'] + "']").children(":last").append('<span class="excel_register"></span>').children(":last").text(v['BTN_NM']);
                } else if (v['BTN_CD'].indexOf('btn_excel') > -1) {
                    $("[id='" + v['BTN_LC_SE'] + "']").children(":last").append('<span class="excel"></span>').children(":last").text(v['BTN_NM']);
                } else if (v['BTN_CD'].indexOf('btn_dwnd') > -1) {
                    $("[id='" + v['BTN_LC_SE'] + "']").children(":last").append('<span class="form"></span>').children(":last").text(v['BTN_NM']);
                } else {
                    $("[id='" + v['BTN_LC_SE'] + "']").children(":last").text(v['BTN_NM']);
                }

                $("[id='" + v['BTN_LC_SE'] + "']").children(":last").attr('id', v['BTN_CD']);
            });
        } else {}
    }, false);
}

/**
 * jquery ajax execute
 * url, dataBody, func(실행함수)      동기 호출
 * */
function ajaxPost2(url, dataBody, func, pAsync) {
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
    if (pAsync != null && pAsync != "undefined") async = pAsync;

    $.ajax({
        url: url,
        type: 'POST',
        data: dataBody,
        dataType: 'json',
        cache: false,
        async: async,
        success: func,
        beforeSend: function(request) {
            request.setRequestHeader("AJAX", true);
            request.setRequestHeader(gheader, $("meta[name='_csrf']").attr("content"));
        },
        error: function(c) {
            errorCheck = 'Y';
            if (c.status == 401 || c.status == 403) {
                //alert("세션이 만료가 되었습니다. 로그인 페이지로 이동합니다.");
                location.href = "/login.do";
            } else if (c.responseText != null && c.responseText != "") {
                alert("처리중 오류가 발생하였습니다. \r\n다시 시도 하십시오.");
            }
        }
    });
}

//파일다운로드
function fn_download(dDiv, fName, sName) {

    params = "downDiv="+dDiv + "&fileName=" + fName + "&saveFileName=" + sName; 
    
    //메시지 암호화
    var url = "https:/" + location.host + '/jsp/file_down_m.jsp?_csrf=' + gtoken;
    url += "&params=" + fn_encrypt(params);

    kora.common.iWebAction('5000', {_url: url});
}

//암호화
function fn_encrypt(str) {
    return CryptoJS.AES.encrypt(str, passphrase);
}

//복호화
function fn_decrypt(str) {
    return CryptoJS.AES.decrypt(str, passphrase);
}


function showMessage() {
    var messageBox = gridRoot.getObjectById("messageBox");
    messageBox.setVisible(true);
}
 
function hideMessage() {
    var messageBox = gridRoot.getObjectById("messageBox");
    messageBox.setVisible(false);
}
</script>

	<!-- 다국어 및 메뉴 -->
	<input type="hidden" id="ttObject" value="<c:out value='${ttObject}' />" />
	<input type="hidden" id="mmObject" value="<c:out value='${mmObject}' />" />

	