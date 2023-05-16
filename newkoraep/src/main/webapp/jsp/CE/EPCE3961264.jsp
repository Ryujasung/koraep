<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<!-- 실행이력상세조회 -->
	<%@include file="/jsp/include/common_page.jsp" %>
	
	<script type="text/javaScript"  language="javascript" defer="defer">
	    
		$(function() {
			fn_btnSetting("EPCE3961264");
			var parent_item = window.frames[$("#pagedata").val()].parent_item;
			$("#title_sub").text(parent_item.MENU_NM+" > "+ parent_item.BTN_NM);
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
 	  	    var url = "/CE/EPCE3961201_194.do"
			input["REG_DTTM"] =  data.REG_DTTM;
	    	ajaxPost(url,input, function(rtnData){
				if(rtnData != null && rtnData != ""){
					execHistPram =rtnData.execHistPram
					$('#PRAM').text(execHistPram)
				} else {
					alertMsg("error");
				}
			});
	    }
	    
	    
	    function CopyToClipboard ( tagToCopy, textarea ){ 

	        textarea.parentNode.style.display = "block"; 

	        textToClipboard =$("#PRAM").text();
	        
	        if ( window.clipboardData ){ 
	                window.clipboardData.setData ( "Text", textToClipboard ); 
	                success = true; 
	        } 
	        else { 
	                textarea.value = textToClipboard; 

	                var rangeToSelect = document.createRange(); 

	                rangeToSelect.selectNodeContents( textarea ); 

	                var selection = window.getSelection(); 
	                selection.removeAllRanges(); 
	                selection.addRange( rangeToSelect ); 

	                success = true; 

	                try { 
	                    if ( window.netscape && (netscape.security && netscape.security.PrivilegeManager) ){ 
	                        netscape.security.PrivilegeManager.enablePrivilege( "UniversalXPConnect" ); 
	                    } 

	                    textarea.select(); 
	                    success = document.execCommand( "copy", false, null ); 
	                } 
	                catch ( error ){  success = false;  } 
	        } 

	        textarea.parentNode.style.display = "none"; 
	        textarea.value = ""; 

	        if ( success ){ alertMsg( ' 클립보드에 복사되었습니다.' ); } 
	        else {    alertMsg( " 복사하지 못했습니다. " );    }  

	        /* 
	        if ( success ){    alertMsg( ' The texts were copied to clipboard. \n\n Paste it, using "Ctrl + v". \n ' );    } 
	        else {    alertMsg( " It was failed to copy. \n " );    } 
	        */ 
	} 
	    
	</script>
	
   <style>
   </style>	

	<div class="layer_popup" style="width:696px; margin-top: -317px">
	
		<div class="layer_head">
			<h1 class="layer_title" id="title_sub">실행이력 상세조회</h1>
			<button type="button" class="layer_close" layer="close">팝업닫기</button>
		</div>
		
		<div class="layer_body">
			<div class="secwrap" id="divInput">
				<div>파라미터 &emsp;: &emsp;
					<div id="PRAM"style="width:550px; text-align: left;  word-break:break-all; float:right"></div>
				</div>
			</div>
			 <section class="btnwrap mt20"  >
							<div class="btn" id="BL"></div>
							<div class="btn" style="float:right" id="BR"></div>
					</section>
			<input type="hidden" id="pagedata" />
		</div>
		
	</div>
