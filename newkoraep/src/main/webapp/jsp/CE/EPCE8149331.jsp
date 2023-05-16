<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
	
	<script type="text/javaScript" language="javascript" defer="defer">
	
	var INQ_PARAMS; //파라미터 데이터
	
	var toDay = kora.common.gfn_toDay();  // 현재 시간
	var oEditors = [];
	var popWin;
	
	$(document).ready(function(){
		
		$('#title_sub').text('<c:out value="${titleSub}" />');
		
		INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
		
		//버튼 셋팅
	    fn_btnSetting();
		
	  	//언어관리
		$('#sbj2').text(parent.fn_text('sbj'));
		$('#cnts').text(parent.fn_text('cnts'));
		$('#pop_size').text(parent.fn_text('pop_size'));
		$('#wid1').text(parent.fn_text('wid'));
		$('#hgt1').text(parent.fn_text('hgt'));
		$('#wid2').text(parent.fn_text('wid'));
		$('#hgt2').text(parent.fn_text('hgt'));
		$('#pxl1').text("("+parent.fn_text('pxl')+")");
		$('#pxl2').text("("+parent.fn_text('pxl')+")");
		$('#pxl3').text("("+parent.fn_text('pxl')+")");
		$('#pxl4').text("("+parent.fn_text('pxl')+")");
		$('#view_lc').text(parent.fn_text('view_lc'));
		$('#view_term').text(parent.fn_text('view_term'));
		$('#use_yn2').text(parent.fn_text('use_yn'));
		$('#use_y').text(parent.fn_text('use_y'));
		$('#use_n').text(parent.fn_text('use_n'));
		
		$('#START_DT').YJcalendar({  
			toName : 'to',
			triggerBtn : true
			//dateSetting : toDay.replaceAll('-','')
		});
		$('#END_DT').YJcalendar({
			fromName : 'from',
			triggerBtn : true
			//dateSetting : toDay.replaceAll('-','')
		});

		//iframe 크기조절
		CKEDITOR.on('instanceReady',function(ev) {
		    ev.editor.on('resize',function(reEvent){
		    	window.frameElement.style.height = $('.iframe_inner').height()+'px';
		    });
		});
		
		var useYn = "<c:out value='${USE_YN}' />";
		if(useYn == null || useYn == "") useYn = "Y";
		$("#USE_YN").val(useYn);
		
		$("#POP_WID, #POP_HGT, #VIEW_LC_TOP, #VIEW_LC_LFT").css("text-align", "right");
		
		$("#btn_lst").click(function(){
			fn_lst();	//취소
		});
		
		$("#btn_reg").click(function(){
			fn_reg();	//등록
		});
		
		$("#btn_prvw").click(function(){
			fn_prvw();	//미리보기
		});

	});
	
	//취소
	function fn_lst(){		 
		//location.href = "/CE/EPCE8149301.do";		
		kora.common.goPageB('', INQ_PARAMS);
	}
	
	//저장
	function fn_reg(){
		var sbj = $("#SBJ").val();
		
		if($.trim(sbj).length < 3){
			alertMsg("팝업 제목을 3자 이상 입력하세요");
			$("#SBJ").focus();
			return;
		}
		$("#SBJ").val($.trim(sbj));
		
		var cntn = CKEDITOR.instances.CNTN.getData();
		
		//cntn = cntn.replaceAll("&nbsp;", "");

		if($.trim(cntn).length < 10){
			alertMsg("팝업 내용을 3자 이상 입력하세요");
			$("#CNTN").focus();
			return;
		}
		
		//팝업크기, 위치, 기간
		//$("#POP_WID, #POP_HGT, #VIEW_LC_TOP, #VIEW_LC_LFT").
		
		if($.trim($("#POP_WID").val()).length == 0){
			alertMsg("팝업 크기(가로)를 입력하세요");
			$("#POP_WID").focus();
			return;
		}
		
		if($.trim($("#POP_HGT").val()).length == 0){
			alertMsg("팝업 크기(세로)를 입력하세요");
			$("#POP_HGT").focus();
			return;
		}
		
		if($.trim($("#VIEW_LC_TOP").val()).length == 0){
			alertMsg("노출위치 위쪽 값을 입력하세요.");
			$("#VIEW_LC_TOP").focus();
			return;
		}
		
		if($.trim($("#VIEW_LC_LFT").val()).length == 0){
			alertMsg("노출위치 왼쪽 값을 입력하세요.");
			$("#VIEW_LC_LFT").focus();
			return;
		}
		
		var stDate = $("#START_DT").val();
		var endDate = $("#END_DT").val();
				
		if($.trim(stDate).length == 0 || !kora.common.gfn_isDate(stDate)){
			alertMsg("노출시작일이 올바른 날짜 형식이 아닙니다.");
			$("#START_DT").focus();
			return;
		}else if($.trim(endDate).length == 0 || !kora.common.gfn_isDate(endDate)){
			alertMsg("노출 종료일이 올바른 날짜 형식이 아닙니다.");
			$("#END_DT").focus();
			return;
		}
		
		confirm("저장하시겠습니까?",'fn_reg_exec')
		return;

	}
	
	function fn_reg_exec(){
		var sbj = $("#SBJ").val();
		var input ={};
		var url ="/CE/EPCE8149301_09.do";
		//var cntn = CKEDITOR.instances.CNTN.getData();
		//	cntn = cntn.replaceAll("&nbsp;", "");

		var stDate = $("#START_DT").val();
		var endDate = $("#END_DT").val();
		
		$('#CNTN2').val(CKEDITOR.instances.CNTN.getData());
		$('#VIEW_ST_DATE').val(stDate);
		$('#VIEW_END_DATE').val(endDate);
		
		/*
		input[ "POP_SEQ"]                =$("#POP_SEQ").val()   //일련번호
		input[ "SBJ"]           	 			=$("#SBJ").val()   //제목
		input[ "CNTN_SE"]            	=$("#CNTN_SE").val()   //내용구분 1
		input[ "CNTN_IMG_FILE_NM"]   =$("#CNTN_IMG_FILE_NM").val()   //내용이미지명
		input[ "CNTN"]           	 			=cntn   //내용
		input[ "POP_WID"]            =$("#POP_WID").val()   //팝업 가로크기
		input[ "POP_HGT"]            =$("#POP_HGT").val()   //팝업 세로크기
		input[ "VIEW_LC_TOP"]        =$("#VIEW_LC_TOP").val()   //노출위치 TOP
		input[ "VIEW_LC_LFT"]        =$("#VIEW_LC_LFT").val()   //노출위치 LEFT
		input[ "VIEW_ST_DATE"]       =$("#START_DT").val()   //노출 시작일
		input[ "VIEW_END_DATE"]      =$("#END_DT").val()   //노출 종료일
		input[ "LK_URL"]             =$("#LK_URL").val()   //링크URL
		input[ "USE_YN"]             =$("#USE_YN").val()   //사용여부
		*/
		
		//JSON 데이터로 보낼때 웹에디터 이미지정보가 잘리는 현상 발생함, 폼전송으로 변경함
		fileajaxPost(url, input, function(rtnData){
			if(rtnData != null && rtnData != ""){
				alertMsg(rtnData.RSLT_MSG, 'fn_lst');
			} else {
				alertMsg("error");
			}
		}, false); 
	}
	
	
	//미리보기
	function fn_prvw(){
		if(popWin) popWin.close();
		
		var cntn = CKEDITOR.instances.CNTN.getData();
		//cntn = cntn.replaceAll("&nbsp;", "");
		
		var w = $("#POP_WID").val();
		var h = $("#POP_HGT").val();
		var top = $("#VIEW_LC_TOP").val();
		var left = $("#VIEW_LC_LFT").val();
		
		if(w == null || w == "" || h == null || h == "" || top == null || top == "" || left == null || left == ""){
			alertMsg("팝업 크기(가로, 세로) 및 노출위치(위쪽, 왼쪽) 값을 정확히 입력 하세요");
			return;
		}
		
		popWin = window.open("/jsp/mngPopup.jsp", "popPreView", 'width=' + w + ', height=' + h + ', left=' + left + ', top=' + top + ', resizable=1, location=0, toolbar=0');
	}
	
	</script>
	
	<div class="iframe_inner">	
		<div class="h3group">
			<h3 class="tit" id="title_sub"></h3>
		</div>
		
		<form name="fileForm" id="fileForm" method="post" enctype="multipart/form-data" onsubmit="return false;">
		
			<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
			<input type="hidden" id="POP_SEQ" name="POP_SEQ"  value="<c:out value='${POP_SEQ}' />" />
			<input type="hidden" id="CNTN2" name="CNTN2" />
            <input type="hidden" id="VIEW_ST_DATE" name="VIEW_ST_DATE" />
            <input type="hidden" id="VIEW_END_DATE" name="VIEW_END_DATE" />
		
			<section class="secwrap">
				<div class="write_area">
					<div class="modify_tbl">
						<table>
							<colgroup>
								<col style="width: 10%;">
								<col style="width: auto;">
							</colgroup>
							<tbody>
								<tr>
									<th id="sbj2"></th>
									<td>
										<div class="row">
											<input type="text" name="SBJ" id="SBJ" value="<c:out value='${SBJ}' />" style="width:90%" maxlength="100" />
										</div>
									</td>
								</tr>
								<tr>
									<th id="cnts"></th>
									<td>
										<div>
											<input type="hidden" name="CNTN_SE" id="CNTN_SE" value="1" />
											<input type="hidden" name="CNTN_IMG_FILE_NM" id="CNTN_IMG_FILE_NM" value="<c:out value='${CNTN_IMG_FILE_NM}' />" />
										
											<textarea class="ckeditor"  id="CNTN" style="width:100%"><c:out value='${CNTN}' /></textarea>
										</div>
									</td>
								</tr>
								<tr>
									<th id="pop_size"></th>
									<td>
										<div class="row">
											<div class="box">
												<div id="wid1"></div><div class="txt">:</div>
												<input type="text" name="POP_WID" id="POP_WID" value="<c:out value='${POP_WID}' />" format="number" style="width: 100px;">
												<div class="unit" id="pxl1"></div>
											</div>
											<div class="box">
												<div id="hgt1"></div><div class="txt">:</div>
												<input type="text" name="POP_HGT" id="POP_HGT" value="<c:out value='${POP_HGT}' />" format="number"  style="width: 100px;">
												<div class="unit" id="pxl2"></div>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<th id="view_lc"></th>
									<td>
										<div class="row">
											<div class="box">
												<div id="wid2"></div><div class="txt">:</div>
												<input type="text" name="VIEW_LC_TOP" id="VIEW_LC_TOP" value="<c:out value='${VIEW_LC_TOP}' />" format="number" style="width: 100px;">
												<div class="unit" id="pxl3"></div>
											</div>
											<div class="box">
												<div id="hgt2"></div><div class="txt">:</div>
												<input type="text" name="VIEW_LC_LFT" id="VIEW_LC_LFT" value="<c:out value='${VIEW_LC_LFT}' />" format="number" style="width: 100px;">
												<div class="unit" id="pxl4"></div>
											</div>
										</div>
									</td>
								</tr>
								
								<tr>
									<th id="view_term"></th>
									<td>
										<div class="row">
											<div class="box">
												<div class="calendar">
													<input type="text" id="START_DT" name="from" value="<c:out value='${VIEW_ST_DATE}' />" style="width: 180px;" class="i_notnull" alt="시작날짜">
												</div>
												
												<div class="obj">~</div>
												<div class="calendar">
													<input type="text" id="END_DT" name="to" value="<c:out value='${VIEW_END_DATE}' />" style="width: 180px;" class="i_notnull" alt="끝 날짜">
												</div>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<th id="use_yn2"></th>
									<td>
										<input type="hidden" name="LK_URL" id="LK_URL" value="<c:out value='${LK_URL}' />" />
										<div class="row">
											<select name="USE_YN" id="USE_YN" style="width: 120px;">
												<option value="Y" id="use_y">사용</option>
												<option value="N" id="use_N">사용안함</option>
											</select>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					
					<input type="hidden" name="DEL_SEQ" id="DEL_SEQ">
					
				</div>
				
				<div class="btnwrap mt20" style="margin-bottom: 120px;">
					<div class="fl_r">
						<button type="button" class="btn36 c5" style="width: 100px;" id="btn_prvw">미리보기</button>
						<button type="button" class="btn36 c4" style="width: 100px;" id="btn_lst">취소</button>
						<button type="button" class="btn36 c2" style="width: 100px;" id="btn_reg">저장</button>
					</div>
				</div>
				
			</section>
			
		</form>
			
	</div>
