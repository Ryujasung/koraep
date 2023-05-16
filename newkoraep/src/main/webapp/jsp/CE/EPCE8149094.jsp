<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="/jsp/include/common_page.jsp" %>

	<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
	
	<script type="text/javaScript" language="javascript" defer="defer">
	
	var oEditors = [];
	var jParams = {};
	var regSn = 10000;
	var delSeq = [];
	var rtnMsg = "<c:out value='${rtnMsg}' />";
	var notiInfo;
	var fileList;
	var bizrTpCd = "<c:out value="${BIZR_TP_CD}"/>";
	console.log('ss'+ bizrTpCd);
	
	$(document).ready(function(){
		
		$('#title_sub').text('<c:out value="${titleSub}" />');

		notiInfo = jsonObject($("#notiInfo").val());
		fileList = jsonObject($("#fileList_1").val());

		var ancSeList = jsonObject($("#ancSeList").val());
		kora.common.setEtcCmBx2(ancSeList, "", "", $("#TRGT_SE"), "ETC_CD", "ETC_CD_NM", "N");
		
		//버튼 셋팅
	    fn_btnSetting();
		
	  	//언어관리
		$('#sbj2').text(parent.fn_text('sbj'));
		$('#anc_aplc_yn').text(parent.fn_text('anc_aplc_yn'));
		$('#top_yn').text(parent.fn_text('top_yn'));
		$('#anc_aplc_trgt').text(parent.fn_text('anc_aplc_trgt'));
		$('#atch_file').text(parent.fn_text('atch_file'));
		$('#file_atch').text(parent.fn_text('file_atch'));
		$('#cnts').text(parent.fn_text('cnts'));
		$('#btn_file_atch').text(parent.fn_text('file_atch'));
		
		//작성체크용
		$('#sbj').attr('alt', parent.fn_text('sbj'));
		
		//페이지이동 조회조건 파라메터 정보
		jParams = jsonObject($("#INQ_PARAMS").val());
		
		if(rtnMsg != '') {
			alertMsg(rtnMsg, 'fn_lst');
		}
		
		if(notiInfo.length != undefined){
			$("#sbj").val(notiInfo[0].SBJ);
			$("#BBS_TEXT").text(notiInfo[0].CNTN);
			$("#NOTI_SEQ").val(notiInfo[0].NOTI_SEQ);
			if(fileList.length != 0){
				for(var i=0;i<fileList.length;i++){
					
					var row =
						"<li id=il_"+fileList[i].REG_SN+"><a href='#' class='file'>"+fileList[i].FILE_NM+"</a><a href='javascript:fn_atch_file_del("+fileList[i].REG_SN+")' class='delete'><img src='/images/util/flie_close.png' alt='삭제' style= 'margin-top: 6px; margin-left: 7px;'></a></li>";
					
					$("#fileList").append(row);
					regSn++;
				}
			}
		}
		
		
		$("#btn_lst").click(function(){
			fn_lst();
		});
		
		$("#btn_reg").click(function(){
			fn_reg();
		});
				
		$("#btn_file_atch").click(function(){
			fn_file_atch();
		});
		
		//목록
		$("#btn_lst2").click(function(){
			location.href =   "/CE/EPCE8149001.do";
		});
		
		$("[name=ANC_APLC_YN]").change(function() { 
		      var ancAplcYn = $("input:radio[name='ANC_APLC_YN']:checked").val();
		      if(ancAplcYn == 'Y' ){
	    		$('#ancTrgtDiv').attr('style', '');
		      }else{
	    		$('#ancTrgtDiv').attr('style', 'display:none');
		      }
		      
		      window.frameElement.style.height = $('.iframe_inner').height()+'px';
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
		
		confirm("등록하시겠습니까?", 'fn_reg_exec');
	}
	
	function fn_reg_exec(){
		
		var input = [];
		$('#CNTN2').val(CKEDITOR.instances.BBS_TEXT.getData());
	 	var url = "/CE/EPCE8149094_09.do";
	 	fileajaxPost(url, input, function(rtnData){
	 		if ("" != rtnData && null != rtnData) {
				alertMsg(rtnData.RSLT_MSG, 'fn_lst');
			} else {
				alertMsg("error");
			}
	 	});
	}
	
	
	//목록가기
	function fn_lst(){   //rtnlist
		
		var sAction="/CE/EPCE8149001.do";
		
		//페이지이동
	    kora.common.goPageD(sAction, "", jParams);
		
	}
	
	//첨부파일 삭제
	function fn_atch_file_del(row){ //이전 fileDel
		
		$("#fileForm").find("input[name='fileUpload_"+row+"']").remove();
	    $("#il_"+row).remove();
	    
	    if(row < 10000) {
	    	delSeq.push(row);
	    }
	    
	    $("#DEL_SEQ").val(delSeq);
	    
	    window.frameElement.style.height = $('.iframe_inner').height()+'px';
	}
	
	//파일첨부
	function fn_file_atch(){ //이전 uploadFile
		
		var inputs = $('#fileList').find('li').length;
		
		if(inputs > 4) {
			alertMsg("첨부파일은 최대 5개만 등록 가능합니다.");
			return;
		}
		
		var fileObj = 
			'<li id="il_'+regSn+'" style="margin-left:87px;background:#ffffff"><label for="fileUpload'+regSn+'"></label>'+
			//'<input id="fileName'+regSn+'" class="upload-name" value="파일선택" disabled="disabled">'+
			'<input type="file" id="fileUpload'+regSn+'" name="fileUpload'+regSn+'" value=" " onchange="fileNameOnChange(this)" >'+
			'<a href="javascript:fn_atch_file_del('+regSn+')" class="delete"><img src="/images/util/flie_close.png" alt="삭제" style="padding:6px"></a>'+
			'</li>';
		
		$("#fileList").append(fileObj);
		
		regSn++;
	    
		window.frameElement.style.height = $('.iframe_inner').height()+'px';
	}

	fileNameOnChange = function(obj) {
		
		var tmpN = ($(obj).attr("id")).replace("fileUpload","");
		
		var filename = $("#fileUpload"+tmpN).val().split('/').pop().split('\\').pop();  // 파일명만 추출
	    
		if(filename != '') {
			$("#fileName"+tmpN).val(filename);
		    tmpN++;
		}
	}
	
	</script>
	
	<input type="hidden" id="ancSeList" value="<c:out value='${ancSeList}' />" />
	
	<div class="iframe_inner" >
		<div class="h3group">
				<h3 class="tit" id="title_sub"></h3>
		</div>
		
		<section class="secwrap" >
			<div class="write_area" id="divInput">
			<form name="fileForm" id="fileForm" method="post" enctype="multipart/form-data" >
				<div class="write_head">
					<div class="tit" id="sbj2" style="width:87px"></div>
					<div class="box" style="padding-left:87px">
						<input type="hidden" id="notiInfo" value="<c:out value='${notiInfo}' />" />
						<input type="hidden" id="fileList_1" value="<c:out value='${fileList}' />" />
						<input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
						<input type="hidden" id="TOKEN" name="TOKEN" value="">
						<input type="text" id="sbj" name="SBJ" style="width: 100%;" maxByteLength="100" class="i_notnull" alt="">
					</div>
				</div>
				<div class="write_head">
					<div class="tit" id="anc_aplc_yn" style="width:87px"></div>
					<div class="box" style="padding-left:90px">
						<label class="rdo"><input type="radio" id="ANC_APLC_YN" name="ANC_APLC_YN" value="Y" style="width: ;"><span>적용</span></label>
						<label class="rdo"><input type="radio" id="ANC_APLC_YN" name="ANC_APLC_YN" value="N" style="width: ;" checked><span>미적용</span></label>
					</div>
				</div>
				<div class="write_head" id="ancTrgtDiv" style="display:none">
					<div class="tit" id="anc_aplc_trgt" style="width:87px"></div>
					<div class="box" style="padding-left:90px">
						<select id="TRGT_SE" name="TRGT_SE" style="width:179px"></select>
					</div>
				</div>
				<div class="write_head">
					<div class="tit" id="top_yn" style="width:87px"></div>
					<div class="box" style="padding-left:90px">
						<label class="rdo"><input type="radio" id="TOP_YN" name="TOP_YN" value="Y" style="width: ;"><span>고정</span></label>
						<label class="rdo"><input type="radio" id="TOP_YN" name="TOP_YN" value="N" style="width: ;" checked><span>고정안함</span></label>
					</div>
				</div>
				<div class="atch_box">
					<div class="titbox">
						<div class="tit" id="atch_file" style="width:87px"></div>
						<div class="btn_box">
							<label class="btn36 c6" style="width:90px;" id="btn_file_atch"></label>
						</div>							
					</div>
					<ul class="atch_list" id="fileList" >
					</ul>
				</div>
				<div class="write_box">
					<div class="tit" id="cnts" style="width:87px"></div>
					<div class="txt" style="padding-left:87px">
						<textarea class="ckeditor"  name="BBS_TEXT" id="BBS_TEXT" style="width:100%;"></textarea>
					</div>
				</div>
				
				<input type="hidden" name="DEL_SEQ" id="DEL_SEQ">
				<input type="hidden" name="NOTI_SEQ" id="NOTI_SEQ">
				<input type="hidden" name="CNTN2" id="CNTN2">
			</form>	
			</div>
			<div class="btnwrap mt20">
				<div class="btn" style="float:right" id="BR"></div>
			</div>
		</section>
		
		
	</div>