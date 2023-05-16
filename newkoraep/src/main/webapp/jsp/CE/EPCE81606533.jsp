<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>설문조사</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">


<script type="text/javaScript" language="javascript" defer="defer">

var jParams;
var itemList = null;
var searchList;

$(document).ready(function(){

	
	jParams = jsonObject($("#INQ_PARAMS").val());
	searchList = jsonObject($("#searchList").val());
	
	$("#SVY_NO").val(searchList.SVY_NO);
	$("#SBJ").val(searchList.SBJ);
	$("#SVY_ST_DT").val(searchList.SVY_ST_DT);
	$("#SVY_END_DT").val(searchList.SVY_END_DT);

    fn_setItemList(searchList);
	
	init();	//날짜형태 변경
	
	$("#btn_vote").click(function(){
	    fn_vote_chk();	//설문저장
	});
	
});

//설문기간 날짜형태로변경
function init(){
	var stDt = $("#SVY_ST_DT").val();
	var endDt = $("#SVY_END_DT").val();
	
	stDt = stDt.substring(0,4) + "-" + stDt.substring(4,6) + "-" + stDt.substring(6);
	endDt = endDt.substring(0,4) + "-" + endDt.substring(4,6) + "-" + endDt.substring(6);
	$("#SVY_ST_DT").val(stDt);
	$("#SVY_END_DT").val(endDt);
}


//문항 세팅
function fn_setItemList(rtnData){
    var cntn = rtnData.searchCntn;
    var list = rtnData.searchList;

    itemList = rtnData.searchList;

	if(list == null || list.length == 0){
		$(".viewarea").html('<div class="view_head"><div class="tit"><p id="sbj">등록된 설문 문항이 존재하지 않습니다.</p></div></div>');
		$("#btn_vote").hide();
		return;
	}
	
	var cnt = 0;
	var txt = new Array();
	
    for(var i=0; i<cntn.length; i++){
        var map = cntn[i];
        txt.push('<div class="view_head2">');
        txt.push('<div>&nbsp;&nbsp;' + map.CNTN);
        txt.push('</div></div>');
    }           
	
	for(var i=0; i<list.length; i++){
		var map = list[i];
		txt.push('<div class="view_head2">');
		txt.push('<div class="tit"><p>' + map.SVY_ITEM_NO_NM + '.&nbsp;&nbsp;' + map.ASK_CNTN);
		txt.push('<input type="hidden" name="SVY_ITEM_NO" value="' + map.SVY_ITEM_NO + '" />');
		txt.push('</p></div></div>');
		
		var nm = "OPT_" + map.SVY_ITEM_NO;
		var optList = map.OPT_LIST;
		
		if(map.ANSR_SE_CD == "I" ){//입력형태
		    txt.push('<div class="view_body2" style="min-height:30px;padding-left:50px">');
			txt.push('<input type="text" name="' + nm + '" style="width:400px;padding-left:20px;" maxlength="150"/>');	
		}
		else if(map.ANSR_SE_CD == "C"|| map.ANSR_SE_CD == "R"){//체크박스 or 라디오
		    txt.push('<div class="view_body2" style="min-height:30px;padding-left:50px">');
			var type = "checkbox";
			if(map.ANSR_SE_CD == "R") type = "radio";
			
			for(var x=0; x<optList.length; x++){
				var optId = nm + "_" + x;
				txt.push('<input type="' + type + '" name="' + nm + '" value="' + optList[x].OPT_NO + '" id="' + optId + '" style="vertical-align: -webkit-baseline-middle"/>');
				if(optList[x].OPT_CNTN != null && optList[x].OPT_CNTN != ""){
					txt.push('<label for="' + optId + '" style="padding-right:10px; vertical-align: -webkit-baseline-middle"> ' + optList[x].OPT_CNTN + '</label>');	
				}
				
				if(optList[x].REFN_IMG != null && optList[x].REFN_IMG != ""){
					var imgSrc = optList[x].REFN_IMG;
					imgSrc = imgSrc.substring(imgSrc.indexOf("data_file")-1);
					txt.push('<img src="' + imgSrc  + '" />');
				}
			}
		}
		else {
		    txt.push('<div style="min-height:0px;padding-left:50px">');
		}
		txt.push('</div>');
	}
	
	$(".viewarea").html(txt.join("").toString());
}


function fn_vote_chk(){
    confirm("설문답변을 저장 합니다.\n저장 후 변경이 불가능합니다.\n계속진행하시겠습니까?","fn_vote");
}

//설문저장
function fn_vote(){
	var sData = {"SVY_NO":$("#SVY_NO").val()};
	var list = new Array();
	
	for(var i=0; i<itemList.length; i++){
		var map = itemList[i];
		var voteMap = {"SVY_ITEM_NO":map.SVY_ITEM_NO, "ANSR_SE_CD":map.ANSR_SE_CD, "ANSR_CNTN" : ""};
		
		var nm = "OPT_" + map.SVY_ITEM_NO;
		var str = new Array(); 
		
		if(map.ANSR_SE_CD == "I"){
			str.push($("input[name='" + nm + "']").val());
		}else if(map.ANSR_SE_CD == "C"){
			$('input:checkbox[name="' + nm + '"]').each(function(){
				if($(this).is(":checked")){
					str.push($(this).val());
				}
			});
		}else if(map.ANSR_SE_CD == "R"){
			str.push($('input:radio[name="' + nm + '"]:checked').val());
		}else if(map.ANSR_SE_CD == "X"){
		    str.push(" ");
		    console.log("str.join(",").toString() [" + str.join(",").toString() + "]");
		}
		
		if(str.length == 0 || str.join(",").toString() == ""){
			alertMsg("응답하지 않은 조사문항이 있습니다. \r모두 응답후 저장해 주십시오.");
			return;
		}
		voteMap["ANSR_CNTN"] = str.join(",").toString();
		list.push(voteMap);
	}
	
	sData["OPT_LIST"] = JSON.stringify(list);
	var url = "/CE/EPCE81606531_09.do";
	ajaxPost(url, sData, function(rtnData){
		//alert(rtnData.RSLT_MSG);
		alertMsg("설문이 완료되었습니다.");
		if(rtnData.RSLT_CD != "") return;
		
		$('[layer="close"]').trigger('click');
		
		//T1:센터, M1: 주류생산자, M2: 음료생산자, W1.도매업자, W2: 공병상, R1: 소매업자(가정용), R2: 소매업자(영업용)
		var BIZR_TP_CD = $("#BIZR_TP_CD").val().substring(0,1);
		var nextPageUrl = "/CE/EPCE81606532.do";
		var INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
		if( BIZR_TP_CD != 'T' ){// 센터는 해당 안됨.
			if( INQ_PARAMS.RST_TRGT_CD == 'A' ){// 모든사용자
			}else if( INQ_PARAMS.RST_TRGT_CD == 'N' ){// 확인불가
				nextPageUrl = '/CE/EPCE8160653.do';
			}else{
				if( INQ_PARAMS.RST_TRGT_CD != BIZR_TP_CD ){
					nextPageUrl = '/CE/EPCE8160653.do';
				}
			}
		}
		
		kora.common.goPage(nextPageUrl, jParams);	//결과페이지로 이동
	});
}

//20200323 설문 취소 시 로그인
function fn_login2() {
	
	$('[layer="close"]').trigger('click');
	
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
	var sData = {"USER_ID":id, "USER_PWD":$("#USER_PWD").val() };
	var url = "/USER_LOGIN_CHECK3.do";

	ajaxPost(url, sData, function(data){
	    
	    rtnData = data;

	    
		//로그인후 갱신
		if(data._csrf != null && data._csrf != ""){
			$("meta[name='_csrf']").attr("content", data._csrf);
		}
		
		try{
			//fasoo 로그인
			var logonID = newsso.SetUserInfo("LOGIN", "0100000000001428", id, "1111","","","","","","","","","","");
		}catch(exception){
			//설치가 안되어있을경우 예외처리
		}

		//ajaxPost("/UPDATE_EPCN_MBL_USER_INFO.do", sData, function(data){}, false);
		
		if(data.msg != null && data.msg != ""){
			if(data.msg == 'Invalid username and password'){ //.....
				data.msg = '아이디 혹은 비밀번호가 일치하지 않습니다.';
			}
			//alertMsg(data.msg);
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
						//alertMsg(data.svyMsg, 'mainNoti');
					}
				}
			    else {
				    mainNoti();
			    }
			}
		}
	});
}

</script>
</head>
<body>			
<form name="frmSvyVote" id="frmSvyVote" method="post" onsubmit="return false;">
<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}'/>" />
<input type="hidden" id="searchList" value="<c:out value='${searchList}'/>" />
<input type="hidden" name="SVY_NO" id="SVY_NO"/>
<input type="hidden" id="BIZR_TP_CD" value="<c:out value='${BIZR_TP_CD}'/>" />
	<div class="layer_popup" style="width:900px; height:600px; overflow-y: scroll; margin-top: -317px" >
		<div class="layer_head">
            <h1 class="layer_title">설문조사</h1>
			<button type="button" class="layer_close" layer="close2" onclick="fn_login2()">팝업닫기</button>
			<button type="button" class="layer_close" id="layer_close" layer="close" style="display: none;">팝업닫기</button>
		</div>
	   	<div class="layer_body">		
	   	
			<div class="h4group" >
				<h5 class="tit"  style="font-size: 16px;" id=""><h5>
			</div>

			<section class="secwrap">
				<div class="srcharea">
					<div class="row">
						<div class="col">
							<div class="tit" style="padding-right: 15px;" id="tit_svy_sbj">제목</div>
							<div class="box" >
								<input type="text" id="SBJ" name="SBJ" style="width: 400px;" disabled="true" />
							</div>
						</div>
						<div class="col" style="width: 400px">
							<div class="tit" style="padding-right: 15px;" id="tit_svy_term">기간</div>
							<div>
								<input type="text" id="SVY_ST_DT" name="SVY_ST_DT"  style="width: 100px;" disabled="true" />
								<b style="font-size:16pt;padding-top:2px;">~</b> <input type="text" id="SVY_END_DT" name="SVY_END_DT" style="width: 100px;" disabled="true" />
							</div>
						</div>
						<div class="btn" id="UR">
						</div>
					</div>
				</div>
			</section>
			
			<!-- 설문문항 리스트 -->
			<section class="secwrap">
				<div class="viewarea mt20" ></div>
			</section>
			
            <section class="btnwrap">
                <div class="btn" style="float:right">
                    <button type="button" class="btn36 c3" style="width: 100px;" id="btn_vote" >설문저장</button>
                </div>
            </section>			
		</div>
	</div>
</form>	
</body>
</html>