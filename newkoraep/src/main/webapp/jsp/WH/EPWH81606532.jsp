<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%@include file="/jsp/include/common_page.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">
	var jParams;

	$(document).ready(function(){
		fn_btnSetting();
		$("#title_sub").text("<c:out value="${titleSub}" />");	//제목
		
		jParams = jsonObject($("#INQ_PARAMS").val());
		
		$(".row > .col> .tit").each(function(){
			if($(this).attr("id")) $(this).text(parent.fn_text($(this).attr("id")));
		});
		
		$(".row > .col> .box").children().each(function(){
			if($(this).attr("alt")) $(this).attr("alt", parent.fn_text($(this).attr("alt")));
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

	
	//조회
	function fn_search(){
		var sData = {"SVY_NO" : jParams.SVY_NO};
		var url = "/WH/EPWH81606532_19.do";
		ajaxPost(url, sData, function(rtnData){
			var txt = $("#tit_vote_cnt").text();
			$("#tit_vote_cnt").text(txt + " : " + rtnData.totVoteCnt + "명");
			fn_setItemList(rtnData.searchList);
		});
	}
	
	//문항 세팅
	function fn_setItemList(list){
		if(list == null || list.length == 0){
			$(".viewarea").html('<div class="view_head"><div class="tit"><p id="sbj">등록된 설문 문항이 존재하지 않습니다.</p></div></div>');
			$("#btn_vote").hide();
			return;
		}
		
		var cnt = 0;
		var txt = new Array();
		for(var i=0; i<list.length; i++){
			var map = list[i];
			txt.push('<div class="view_head">');
			txt.push('<div class="tit"><p>' + (i+1) + '.&nbsp;&nbsp;' + map.ASK_CNTN);
			txt.push('</p></div></div>');
			
			var nm = "OPT_" + map.SVY_ITEM_NO;
			var optList = map.OPT_LIST;
			txt.push('<div class="view_body" style="min-height:30px;padding-left:50px">');
			
				for(var x=0; x<optList.length; x++){
					txt.push('<p>' + optList[x].OPT_CNTN + ' - ' + optList[x].CNT + '(' + optList[x].RATE + '%)' + '</p>');	
				}
			txt.push('</div>');
		}
		
		$(".viewarea").html(txt.join("").toString());
	}

</script>
	
	<div class="iframe_inner">
	
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>		
		</div>
	
		<form name="frmSvyVote" id="frmSvyVote" method="post" onsubmit="return false;">
			<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}'/>" />
			<section class="secwrap">
				<div class="srcharea">
					<div class="row">
						<div class="col">
							<div class="tit" style="padding-right: 15px;" id="tit_svy_sbj"></div>
							<div class="box" >
								<input type="text" id="SBJ" name="SBJ" style="width: 400px;" disabled="true" />
							</div>
						</div>
						<div class="col" style="width: 350px">
							<div class="tit" style="padding-right: 15px;" id="tit_svy_term"></div>
							<div>
								<input type="text" id="SVY_ST_DT" name="SVY_ST_DT" value="<c:out value='${INQ_PARAMS.SVY_ST_DT}' />" style="width: 100px;" disabled="true" />
								<b style="font-size:16pt;padding-top:2px;">~</b> <input type="text" id="SVY_END_DT" name="SVY_END_DT" value="<c:out value='${INQ_PARAMS.SVY_END_DT}' />" style="width: 100px;" disabled="true" />
							</div>
						</div>
						<div class="col">
							<div class="tit" style="padding-right: 15px;" id="tit_vote_cnt"></div>
						</div>
						<div class="btn" id="UR">
						</div>					
					</div>
				</div>
			</section>
			
			
			<!-- 설문문항 리스트 -->
			<section class="secwrap">
				<div class="viewarea mt20">
				</div>
			</section>
			
		</form>
		
		
		
	</div>	<!-- //iframe_inner -->
	