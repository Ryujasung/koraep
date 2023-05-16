<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>설문조사 참여</title>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=1100, user-scalable=yes">
<meta name="description" content="사이트설명">
<meta name="keywords" content="사이트검색키워드">
<meta name="author" content="Newriver">
<meta property="og:title" content="공유제목">
<meta property="og:description" content="공유설명">
<meta property="og:image" content="공유이미지 800x400">

<%@include file="/jsp/include/common_page_m.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">
	var jParams;
	var itemList = null;
	
	$(document).ready(function(){

		$("#title_sub").text("<c:out value="${titleSub}" />");	//제목
		
		jParams = jsonObject($("#INQ_PARAMS").val());
		
		$(".row > .col> .tit").each(function(){
			if($(this).attr("id")) $(this).text(fn_text($(this).attr("id")));
		});
		
		$(".row > .col> .box").children().each(function(){
			if($(this).attr("alt")) $(this).attr("alt", fn_text($(this).attr("alt")));
		});
	
		if(Object.keys(jParams).length > 0){
			for(var key in jParams){
				$("#" + key).val(jParams[key]);
			}
			fn_search();
		}
		
		init();	//날짜형태 변경
		
		//목록보기
		$("#btn_svy_list").click(function(){
			var sData = {};
			sData["SEARCH_SBJ"] = jParams["SEARCH_SBJ"];
			kora.common.goPageD("/WH/EPWH8160653.do", "", sData, "M");
		});
		
		$("#btn_vote").click(function(){
		    fn_vote_chk();   //설문저장
		});
	});
	
	//설문기간 날짜형태로변경
	function init(){
		
		var stDt  = jParams.SVY_ST_DT;
		var endDt = jParams.SVY_END_DT;
		
		stDt  = stDt.substring(0,4) + "-" + stDt.substring(4,6) + "-" + stDt.substring(6);
		endDt = endDt.substring(0,4) + "-" + endDt.substring(4,6) + "-" + endDt.substring(6);

		$("#sbj").text(jParams.SBJ);
		$("#dttm").text(stDt + " ~ " + endDt);
	}
	
	//조회
	function fn_search(){
		var sData = {"SVY_NO" : $("#SVY_NO").val()};
		var url = "/WH/EPWH81606531_19.do";
		ajaxPost(url, sData, function(rtnData){
		    fn_setItemList(rtnData);
		});
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
            txt.push('<div>' + del_font(map.CNTN));
            txt.push('</div></div></br>');
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
                        txt.push('<label for="' + optId + '" style="padding-right:10px; vertical-align: -webkit-baseline-middle"> ' + optList[x].OPT_CNTN + '</label></br>');    
                    }
                    
                    if(optList[x].REFN_IMG != null && optList[x].REFN_IMG != ""){
                        var imgSrc = optList[x].REFN_IMG;
                        imgSrc = imgSrc.substring(imgSrc.indexOf("data_file")-1);
                        txt.push('<img src="' + imgSrc  + '" /></br>');
                    }
                }
            }
            else {
                txt.push('<div style="min-height:0px;padding-left:50px">');
            }
            txt.push('</div></br>');
        }
		
		$(".viewarea").html(txt.join("").toString());
	}
    
    function fn_vote_chk(){
        if(!confirm("설문답변을 저장 합니다.\n저장 후 변경이 불가능합니다.\n계속진행하시겠습니까?")) {
        	return;
        }
        
        fn_vote();
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
				alert("응답하지 않은 조사문항이 있습니다. \r모두 응답후 저장해 주십시오.");
				return;
			}
			voteMap["ANSR_CNTN"] = str.join(",").toString();
			list.push(voteMap);
		}
		
		sData["OPT_LIST"] = JSON.stringify(list);
		var url = "/WH/EPWH81606531_09.do";
		ajaxPost(url, sData, function(rtnData){
			alert(rtnData.RSLT_MSG);
			if(rtnData.RSLT_CD != "") return;
			
			//T1:센터, M1: 주류생산자, M2: 음료생산자, W1.도매업자, W2: 공병상, R1: 소매업자(가정용), R2: 소매업자(영업용)
			var BIZR_TP_CD = $("#BIZR_TP_CD").val().substring(0,1);
			var nextPageUrl = "/WH/EPWH81606532.do";
			var INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
			if( BIZR_TP_CD != 'T' ){// 센터는 해당 안됨.
				if( INQ_PARAMS.RST_TRGT_CD == 'A' ){// 모든사용자
				}else if( INQ_PARAMS.RST_TRGT_CD == 'N' ){// 확인불가
					nextPageUrl = '/WH/EPWH8160653.do';
				}else{
					if( INQ_PARAMS.RST_TRGT_CD != BIZR_TP_CD ){
						nextPageUrl = '/WH/EPWH8160653.do';
					}
				}
			}
			
			kora.common.goPage(nextPageUrl, jParams);	//결과페이지로 이동
		});
		
		
	}

	//span font 삭제
	function del_font(str) {
	    
	    var tmp = str.split("style=\"font-size:");
	    var rtn_str = "";
	    
	    for(var i=0; i<tmp.length; i++) {
		    if(tmp[i].indexOf("px") < 0) {
		        rtn_str += tmp[i];
		    }
		    else {
		        rtn_str += tmp[i].substring(tmp[i].indexOf("px")+3, tmp[i].length);
		    }
	    }
	    
	    return rtn_str;
	}
</script>
</head>
<div id="wrap">

	<%@include file="/jsp/include/header_m.jsp" %>
		
	<%@include file="/jsp/include/aside_m.jsp" %>

	<div id="container">

		<div id="subvisual">
			<h2 class="tit" id="title"></h2>
		</div><!-- id : subvisual -->

		<div id="contents">
			<div class="contbox pb55">
				<div class="board_head">
					<div class="tit" id="sbj"></div>
					<div class="info_wrap">
						<div class="date" id="dttm"></div>
					</div>
				</div>
				<div class="board_body">
				<form name="frmSvyVote" id="frmSvyVote" method="post" onsubmit="return false;">
					<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}'/>" />
					<input type="hidden" name="SVY_NO" id="SVY_NO" value="<c:out value='${INQ_PARAMS.SVY_NO}' />"/>
					<input type="hidden" id="BIZR_TP_CD" value="<c:out value='${BIZR_TP_CD}'/>" />

					<div class="viewarea mt20">
					</div>
				</form>
				</div>
				<div class="btn_wrap mt30">
					<div class="fl_c">
						<button class="btnCircle c2" id="btn_svy_list">목록</button>
						<button class="btnCircle c1" id="btn_vote">저장</button>
					</div>
				</div>
			</div>
		</div><!-- id : contents -->
	</div><!-- id : container -->

	<%@include file="/jsp/include/footer_m.jsp" %>
	
</div><!-- id : wrap -->
</body>
</html>
	