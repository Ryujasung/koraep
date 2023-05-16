<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="/jsp/include/common_page.jsp" %>
	
	<script type="text/javaScript"  language="javascript" defer="defer">
	    
		$(function() {
			$('#title_sub').text('<c:out value="${titleSub}" />');
			fn_btnSetting("EPCE23930882");
			var parent_item = window.frames[$("#pagedata").val()].parent_item;
			fn_sel(parent_item);

			/************************************
		 	 * 닫기 버튼 클릭 이벤트
		 	 ***********************************/
		 	$("#btn_cnl").click(function(){
				$('[layer="close"]').trigger('click');
		 	});
		});
		
	    function fn_sel(data){
	    	var input ={};
 	  	    var url = "/CE/EPCE23930882_19.do"
			input["CNL_REQ_SEQ"] = data.CNL_REQ_SEQ;
	    	ajaxPost(url,input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					$('#reqRsn').html(rtnData.reqRsn);
					$('#reqRsn').html($('#reqRsn').html().replaceAll('\\n', '<br>'));
				} else {
					alertMsg("error");
				}
			});
	    }
	    	    
	</script>
	
	<div class="layer_popup" style="width:696px; margin-top: -317px">
	
		<div class="layer_head">
			<h1 class="layer_title" id="title_sub"></h1>
			<button type="button" class="layer_close" layer="close">팝업닫기</button>
		</div>
		
		<div class="layer_body">
			<div class="secwrap" id="divInput">
				<div>
					<div id="reqRsn" style="width:550px; text-align: left; line-height: 21px; word-break: break-all;"></div>
				</div>
			</div>
			<section class="btnwrap mt20"  >
				<div class="btn" id="BL"></div>
				<div class="btn" style="float:right" id="BR">
					<button type="button" class="btn36 c1" style="width: 100px;" id="btn_cnl">닫기</button>
				</div>
			</section>
			<input type="hidden" id="pagedata" />
		</div>
		
	</div>
