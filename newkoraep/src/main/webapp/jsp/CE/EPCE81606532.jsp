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
			//kora.common.goPageD("/CE/EPCE8160653.do", "", sData, "M");
			kora.common.goPageB('', jParams);
		});
		
		/************************************
		 * 엑셀다운로드 버튼 클릭 이벤트
		 ***********************************/
		 $("#btn_excel").click(function() {
			 fn_excel();
		 });
		
			//엑셀저장
			function fn_excel(){

				/*
				var collection = gridRoot.getCollection();
				if(collection.getLength() < 1){
					alertMsg("데이터가 없습니다.");
					return;
				}
				
				if(INQ_PARAMS["SEL_PARAMS"] == undefined){
					alertMsg("먼저 데이터를 조회해야 합니다.");
					return;
				}
				*/
							
				var now  = new Date(); 				     // 현재시간 가져오기
				var hour = new String(now.getHours());   // 시간 가져오기
				var min  = new String(now.getMinutes()); // 분 가져오기
				var sec  = new String(now.getSeconds()); // 초 가져오기
				var today = kora.common.gfn_toDay();
				var fileName = $('#title_sub').text() +"_" + today+hour+min+sec+".xlsx";
				
				//그리드 컬럼목록 저장
				var col = new Array();
				
				var headerText = ["답변일자", "사용자ID", "사용자명", "지역", "사업자명", "사업자번호", "EMAIL", "휴대전화번호", "전화번호", "사용자구분", "설문번호", "설문문항", "답변번호", "입력답변"];
				var dataField = ["AN_DT", "USER_ID", "USER_NM", "AREA_NM", "BIZRNM", "BIZRNO_DE", "EMAIL", "MBIL_NO", "TEL_NO", "USER_SE_NM", "SVY_ITEM_NO_NM", "ASK_CNTN", "OPT_CNTN", "ANSR_CNTN"];
				
				for(i=0; i<headerText.length; i++){
					var item = {};
					item['headerText'] = headerText[i];				
					item['dataField'] = dataField[i];
					item['textAlign'] = "left";
					item['id'] = "";
											
					col.push(item);
				}
				
				var input = jParams;
				input['fileName'] = fileName;
				input['columns'] = JSON.stringify(col);
				
				var url = "/CE/EPCE81606532_05.do";
				ajaxPost(url, input, function(rtnData){
					if(rtnData != null && rtnData != "" && rtnData.RSLT_CD != '0000'){
						alertMsg(rtnData.RSLT_MSG);
					}else{
						//파일다운로드
						frm.action = '/jsp/file_down.jsp' + "?_csrf=" + gtoken;
						frm.fileName.value = fileName;
						frm.submit();
					}
				});
			}		
		
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
		var url = "/CE/EPCE81606532_19.do";
		ajaxPost(url, sData, function(rtnData){
			var txt = $("#tit_vote_cnt").text();
			$("#tit_vote_cnt").text(txt + " : " + rtnData.totVoteCnt + "명");
			fn_setItemList(rtnData);
		});
	}
	
	//문항 세팅
	function fn_setItemList(list){
	    var cntn = list.searchCntn;
	    var list = list.searchList;
	    
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
			txt.push('</p></div></div>');
			
			var nm = "OPT_" + map.SVY_ITEM_NO;
			var optList = map.OPT_LIST;
			txt.push('<div class="view_body2" style="min-height:30px;padding-left:50px">');
			
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
		
		<form name="frm" action="/jsp/file_down.jsp" method="post">
			<input type="hidden" name="fileName" value="" />
			<input type="hidden" name="saveFileName" value="" />
			<input type="hidden" name="downDiv" value="excel" />
		</form>
	
		
	</div>	<!-- //iframe_inner -->
	