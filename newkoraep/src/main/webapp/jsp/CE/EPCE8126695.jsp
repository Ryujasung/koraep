<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%@include file="/jsp/include/common_page.jsp" %>


<script type="text/javaScript" language="javascript" defer="defer">

var askInfo;
var ansrInfo;
var jParams = {};
var userId = gfn_getCookie("USER_ID");
//var strMbrSeCd = gfn_getCookie("MBR_SE_CD");
//var strGrpCd   = gfn_getCookie("GRP_CD"); //메뉴권한그룹 추가

$(document).ready(function(){
	
	$('#title_sub').text('<c:out value="${titleSub}" />');
	
	//버튼 셋팅
    fn_btnSetting();
	
  	//언어관리
	$('#ask').text(parent.fn_text('ask'));
	$('#asnr').text(parent.fn_text('asnr'));
	$('#bf_doc').text(parent.fn_text('bf_doc'));
	$('#nx_doc').text(parent.fn_text('nx_doc'));
	
	
	//페이지이동 조회조건 파라메터 정보
	jParams = jsonObject($("#INQ_PARAMS").val());
	askInfo = jsonObject($("#askInfo").val());
	ansrInfo = jsonObject($("#ansrInfo").val());
	
	if("Q" == askInfo[0].CNTN_SE){
		document.getElementById("sbj").innerHTML = parent.fn_text('ask')+" : " + askInfo[0].SBJ;
		document.getElementById("cntnSe").innerHTML = parent.fn_text('ansr') + " : ";
		if("" != ansrInfo){
			document.getElementById("ansrCk").innerHTML = ansrInfo[0].SBJ;
		} else {
			document.getElementById("ansrCk").innerHTML = "등록된 답변이 없습니다.";
		}
	} else if("A" == askInfo[0].CNTN_SE){
		document.getElementById("sbj").innerHTML = parent.fn_text('ansr')+" : " + askInfo[0].SBJ;
		document.getElementById("cntnSe").innerHTML = parent.fn_text('ask');
		document.getElementById("ansrCk").innerHTML = ansrInfo[0].SBJ;
	}
	
	document.getElementById("dttm").innerHTML = askInfo[0].REG_DTTM;
	document.getElementById("regId").innerHTML = kora.common.null2void(askInfo[0].USER_NM);
	document.getElementById("cntn").innerHTML = askInfo[0].CNTN;
	
	/* //센터 관리자, 담당자, 시스템관리자 만 버튼보이도록 수정
	if("A" == strMbrSeCd && (strGrpCd == "A01" || strGrpCd == "A02" || strGrpCd == "Z01" || strGrpCd == "A11" || strGrpCd == "A12")){
		$("#btnAnsr").show();
	} else {
		$("#btnAnsr").hide();
	}
	
	if(("A" == strMbrSeCd && (strGrpCd == "A01" || strGrpCd == "A02" || strGrpCd == "Z01" || strGrpCd == "A11" || strGrpCd == "A12")) || userId == askInfo[0].RGST_PRSN_ID){
		$("#btnDel").show();
		$("#btnMod").show();
	} else {
		$("#btnDel").hide();
		$("#btnMod").hide();
	} */
	
	$("#btn_ansr_reg").click(function(){
		fn_ansr_reg();
	});
	
	$("#btn_upd").click(function(){
		fn_upd();
	});
	
	$("#btn_del").click(function(){
		fn_del();
	});
	
	$("#btn_lst").click(function(){
		fn_lst();
	});
	
	
});

//수정
function fn_upd(){ //이전 mod
	
	var sAction="/CE/EPCE8126642.do";
	
	//페이지이동
    var data = {"ASK_SEQ": askInfo[0].ASK_SEQ, "CNTN_SE" : askInfo[0].CNTN_SE, "REG_PRSN_ID" : askInfo[0].REG_PRSN_ID};
    kora.common.goPageD(sAction, data, jParams);
	
}

//삭제
function fn_del(){ //이전 del
	
	confirm("문의/답변을 삭제하시겠습니까?",'fn_del_exec')
	
}

function fn_del_exec(){
		
		var sData = {"ASK_SEQ" : askInfo[0].ASK_SEQ, "CNTN_SE" : askInfo[0].CNTN_SE};
		var url = "/CE/EPCE8126695_04.do";
		
		ajaxPost(url, sData, function(rtnData){
			
			if(rtnData != null && rtnData != ""){
				alertMsg("삭제되었습니다.",'fn_lst');
			} else {
				alertMsg("error");
			}
			
		});
		
}

	


//상세조회링크
function fn_dtl_sel_lk(ask_seq, cntnSe){ //이전 link
	
	var sAction="/CE/EPCE8126695.do";
	
	//페이지이동
    var data = {"ASK_SEQ": ask_seq, "CNTN_SE": cntnSe};
    kora.common.goPageD(sAction, data, jParams);
	
};

//목록
function fn_lst(){ //이전 rtnList
	
	var sAction="/CE/EPCE8126601.do";
	
	//페이지이동
    kora.common.goPageD(sAction, "", jParams);
	
}

//답변 등록
function fn_ansr_reg(){
	
	var sAction="/CE/EPCE8126696.do";
	
	//페이지이동
    var data = {"ASK_SEQ": askInfo[0].ASK_SEQ, "CNTN_SE" : "A", "REG_PRSN_ID" : askInfo[0].REG_PRSN_ID};
	
	kora.common.goPageD(sAction, data, jParams);
	
}

</script>


<div class="iframe_inner">

	<input type="hidden" id="askInfo" value="<c:out value='${askInfo}' />" />
	<input type="hidden" id="ansrInfo" value="<c:out value='${ansrInfo}' />" />
	<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />


	<div class="h3group">
		<h3 class="tit" id="title_sub"></h3>
	</div>
	<section class="secwrap">
		<div class="viewarea">
			<div class="view_head">
				<div class="tit"><p id="sbj"></p></div>
				<div class="day"><p class="date" id="dttm"></p></div>
				<div class="tit" style="float:right;"><p id="regId" style="margin-right: 25px;"></p></div>
			</div>
			
			<div class="view_body">
				<p id="cntn"></p>
			</div>
			<div class="view_navi">
				<div class="prev">
					<span id="cntnSe" style="margin-right: 12px;font-weight:bold"></span>
					<span id="ansrCk"></span>
				</div>
				
			</div>
			
		</div>
		
		<div class="btnwrap mt20">
			<div class="btn" style="float:right" >
			
					<c:if test="${empty ansrInfo}">
					<button type="button" class="btn36 c1" style="width: 100px;"
						id="btn_ansr_reg">답변등록</button>
					</c:if>	
					
					<c:if test="${askInfo[0].CNTN_SE eq 'A' }">
 					<c:if test="${userInfo.ATH_GRP_CD eq 'ATC002'or userInfo.ATH_GRP_CD eq 'ATH001' or userInfo.USER_ID eq askInfo[0].REG_ID}">
					<button type="button" class="btn36 c1" style="width: 100px;"
						id="btn_upd">수정</button>
					</c:if>
					</c:if>	
					<button type="button" class="btn36 c4" style="width: 100px;"
						id="btn_del">삭제</button>
					<button type="button" class="btn36 c5" style="width: 100px;"
						id="btn_lst">목록</button>
				</div>

			</div>
		</div>
		
	</section>
</div>