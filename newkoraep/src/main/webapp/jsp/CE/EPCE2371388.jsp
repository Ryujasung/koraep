<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<!-- 실행이력상세조회 -->
	<%@include file="/jsp/include/common_page.jsp" %>
	
	<script type="text/javaScript"  language="javascript" defer="defer">
	    
		$(function() {
			fn_btnSetting("EPCE3961264");
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
 	  	    var url = "/CE/EPCE2371302_191.do"
			input["CNL_REQ_SEQ"] = data.CNL_REQ_SEQ;
	    	ajaxPost(url,input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					//$('#reqRsn').text( rtnData.reqRsn )
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
			<h1 class="layer_title" id="title_sub">고지서발급취소요청조회 요청사유</h1>
			<button type="button" class="layer_close" layer="close">팝업닫기</button>
		</div>
		
		<div class="layer_body">
			<div class="secwrap" id="divInput">
				<div>
					<div id="reqRsn" style="width:550px; text-align: left; line-height: 21px;  word-break:break-all; "></div>
				</div>
			</div>
			 <section class="btnwrap mt20"  >
							<div class="btn" id="BL"></div>
							<div class="btn" style="float:right" id="BR"></div>
					</section>
			<input type="hidden" id="pagedata" />
		</div>
		
	</div>