<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="/jsp/include/common_page.jsp" %>
	<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
	<script type="text/javaScript" language="javascript" defer="defer">
	
	var oEditors = [];
	var jParams = {};
	var rtnMsg = "<c:out value='${rtnMsg}' />";
	var askInfo;

	$(document).ready(function(){
		
		$('#title_sub').text('<c:out value="${titleSub}" />');
		
		//페이지이동 조회조건 파라메터 정보
		jParams = jsonObject($("#INQ_PARAMS").val());
		askInfo = jsonObject($("#askInfo").val());
		
		//버튼 셋팅
	    fn_btnSetting();
		
	  	//언어관리
		$('#sbj2').text(parent.fn_text('sbj'));
		$('#headTit').text(parent.fn_text('ask'));
		$('#cnts').text(parent.fn_text('cnts'));
		
		//작성체크용
		$('#sbj').attr('alt', parent.fn_text('sbj'));
		
		if(rtnMsg != '') {
			alertMsg(rtnMsg,'fn_lst');
		}
		
		if(askInfo.length != undefined && askInfo.length != 0){
			$("#sbj").val(askInfo[0].SBJ);
			$("#BBS_TEXT").text(askInfo[0].CNTN);
			if("A" == askInfo[0].CNTN_SE) $("#headTit").text("답변");
		} else {
			if("A" == "<c:out value='${CNTN_SE}' />"){
				$("#headTit").text("답변");
			}
		}
		
		$("#btn_lst").click(function(){
			fn_lst();
		});
		
		$("#btn_reg").click(function(){
			fn_reg();
		});
		
		//목록
		$("#btn_lst2").click(function(){
			location.href =   "/CE/EPCE8126601.do";
		});
		
		//iframe 크기조절
		CKEDITOR.on('instanceReady',function(ev) {
		    ev.editor.on('resize',function(reEvent){
		    	window.frameElement.style.height = $('.iframe_inner').height()+'px';
		    });
		});
		
	});

	//저장
	function fn_reg(){
		
		if(!kora.common.cfrmDivChkValid("divInput")) {
			return;
		}
		
		if(CKEDITOR.instances.BBS_TEXT.getData().length < 1){
			alertMsg("내용을 입력해 주세요.");
			return; 
		}
		
		confirm("문의/답변을 등록하시겠습니까?",'fn_reg_exec')
		return;
		
	}
	
	function fn_reg_exec(){
		if(askInfo.length != undefined && askInfo.length != 0){
			
			$("#UPD_YN").val("Y");
			$("#ASK_SEQ").val(kora.common.null2void(askInfo[0].ASK_SEQ));
			$("#CNTN_SE").val(kora.common.null2void(askInfo[0].CNTN_SE));
			$("#REG_PRSN_ID").val(kora.common.null2void(askInfo[0].REG_PRSN_ID));
		} else {
			if("A" == "<c:out value='${CNTN_SE}' />"){
				
				$("#UPD_YN").val("N");
				$("#ASK_SEQ").val(kora.common.null2void("<c:out value='${ASK_SEQ}' />"));
				$("#CNTN_SE").val(kora.common.null2void("<c:out value='${CNTN_SE}' />"));
				$("#REG_PRSN_ID").val(kora.common.null2void("<c:out value='${REG_PRSN_ID}' />"));
			}
		}
		
		$('#CNTN2').val(CKEDITOR.instances.BBS_TEXT.getData());
		
		var input = [];
		input = kora.common.gfn_formData("frm");
	 	console.log(input);

	 	var url = "/CE/EPCE8126696_09.do";
	 	ajaxPost(url, input, function(rtnData){
	 		if ("" != rtnData && null != rtnData) {
				alertMsg(rtnData.RSLT_MSG, 'fn_lst');
			} else {
				alertMsg("error");
			}
	 	});

	}
	
	//목록으로 돌아가기
	function fn_lst(){ //이전 rtnList
		
		var sAction="/CE/EPCE8126601.do";
		
		//페이지이동
	    kora.common.goPageD(sAction, "", jParams);
		
	}
	
	$("#btn_lst2").click(function(){
		location.href =   "/CE/EPCE8126601.do";
	});

	
	</script>
	
	<div class="iframe_inner">
		<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
		</div>
		<form name="frm" id="frm" method="post" action="/CE/EPCE8126696_09.do">
		
			<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="askInfo" value="<c:out value='${askInfo}' />" />
		
			<section class="secwrap">
				<div class="write_area" id="divInput">
					<div class="write_head">
						<div class="tit" id="sbj2"></div>
						<div class="box">
							<div class="tit" id="headTit" style="margin-left:50px; !important"></div>
							<input type="text" id="sbj" name="SBJ" style="width:78%; margin-left:50px;"  maxByteLength="150" class="i_notnull" alt="">
						</div>
					</div>	
									
					<div class="write_box">
						<div class="tit" id="cnts"></div>
						<div class="txt">
							<textarea class="ckeditor" name="BBS_TEXT" id="BBS_TEXT" style="width:100%"></textarea>
						</div>
					</div>
					
					<input type="hidden" name="CNTN_SE" id="CNTN_SE">
					<input type="hidden" name="ASK_SEQ" id="ASK_SEQ">
					<input type="hidden" name="UPD_YN" id="UPD_YN">
					<input type="hidden" name="REG_PRSN_ID" id="REG_PRSN_ID">
					<input type="hidden" name="INQ_PARAMS" id="INQ_PARAMS">
					<input type="hidden" name="CNTN2" id="CNTN2">
					
				</div>
				<div class="btnwrap mt20">
					<div class="btn" style="float:right" id="BR"></div>
				</div>
			</section>
		</form>
	</div>
	
	
	