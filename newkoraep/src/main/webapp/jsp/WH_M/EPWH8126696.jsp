<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>문의 등록</title>
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

<!-- 페이징 사용 등록 -->
	<script src="/js/kora/paging_common.js"></script>
	
	<script type="text/javaScript" language="javascript" defer="defer">
	
    var jParams = {};
    var rtnMsg = '${rtnMsg}';
    var askInfo = ${askInfo};
	
	$(document).ready(function(){

        //언어관리
        $('#sbj2').text(fn_text('sbj'));
        $('#cnts').text(fn_text('cnts'));
        
        //작성체크용
        $('#sbj').attr('alt', fn_text('sbj'));
        
        //페이지이동 조회조건 파라메터 정보
        jParams = ${INQ_PARAMS};
        
        if(rtnMsg != '') {
            alert(rtnMsg,'fn_lst');
        }
        
        if(askInfo.length != undefined && askInfo.length != 0){
            $("#sbj").val(askInfo[0].SBJ);
            $("#BBS_TEXT").text(askInfo[0].CNTN);
            if("A" == askInfo[0].CNTN_SE) {
        	    $("#text").attr('placeholder', '답변' );
            }
        }
        else {
            if('A' == '${CNTN_SE}'){
                $("#text").attr('placeholder', '답변' );
            }
        }
        
        $("#btn_lst").click(function(){
            fn_lst();
        });
        
        $("#btn_reg").click(function(){
            fn_reg();
        });
        
        /************************************
         * 취소버튼 클릭 이벤트
         ***********************************/
        $("#btn_cnl").click(function(){
            fn_lst();
        });
	});
	
    //저장
    function fn_reg(){
        
        if(!kora.common.cfrmDivChkValid("divInput")) {
            return;
        }
        
        if($('#BBS_TEXT').val().length < 1){
            alertMsg("내용을 입력해 주세요.");
            return; 
        }
        
        if(confirm("문의/답변을 등록하시겠습니까?")){
            fn_reg_exec();
        }
    }
    
    function fn_reg_exec(){
        if(askInfo.length != undefined && askInfo.length != 0){
            $("#ASK_SEQ").val(kora.common.null2void(askInfo[0].ASK_SEQ));
            $("#CNTN_SE").val(kora.common.null2void(askInfo[0].CNTN_SE));
        } else {
            if('A' == '${CNTN_SE}'){
                $("#ASK_SEQ").val(kora.common.null2void('${ASK_SEQ}'));
                $("#CNTN_SE").val(kora.common.null2void('${CNTN_SE}'));
            }
        }
        
        
        var str = $('#BBS_TEXT').val();

        str = str.replace(/(?:\r\n|\r|\n)/g, '<br/>');

        $('#CNTN2').val(str);
        
        var input = {};
        input["SBJ"]        = $("#SBJ").val();
        input["CNTN_SE"]    = $("#CNTN_SE").val();
        input["ASK_SEQ"]    = $("#ASK_SEQ").val();
        input["INQ_PARAMS"] = $("#INQ_PARAMS").val();
        input["CNTN2"]      = $("#CNTN2").val();

        var url = "/WH/EPWH8126696_09.do";
        ajaxPost(url, input, function(rtnData){
            if ("" != rtnData && null != rtnData) {
                alert(rtnData.RSLT_MSG);
                fn_lst();
            } else {
                alert("error");
            }
        });

    }
    
    //목록으로 돌아가기
    function fn_lst(){ //이전 rtnList
        kora.common.goPageB('', jParams);
    }
	</script>
</head>
<body>
	<div id="wrap">
	
		<%@include file="/jsp/include/header_m.jsp" %>
		
		<%@include file="/jsp/include/aside_m.jsp" %>

		<div id="container">

            <div id="subvisual">
				<h2 class="tit" id="title"></h2>
                <button class="btn_back" id="btn_cnl"><span class="hide">뒤로가기</span></button>
			</div><!-- id : subvisual -->

			<div id="contents">
                
                <div class="contbox pb50" id="divInput">
                    <div class="box_wrap" style="margin: -20px 0 0">
                        <div class="boxed v2">
                            <div class="sort" id="sbj2" style="width: 95px;"></div>
                            <div class="cont" style="width: 535px">
                                <input type="text" placeholder="문의" maxlength="150" name="SBJ" id="SBJ" class="i_notnull" alt="제목">
                            </div>
                        </div>
                    </div>
                    <div class="box_wrap">
                        <div class="boxed v2">
                            <div class="sort" id="cnts" style="width: 95px;"></div>
                            <div class="cont" style="width: 535px">
                                <textarea name="BBS_TEXT" id="BBS_TEXT" style="width:100%; height:600px"></textarea>
                            </div>
                            <input type="hidden" name="CNTN_SE" id="CNTN_SE">
                            <input type="hidden" name="ASK_SEQ" id="ASK_SEQ">
                            <input type="hidden" name="INQ_PARAMS" id="INQ_PARAMS">
                            <input type="hidden" name="CNTN2" id="CNTN2">
                        </div>
                    
                    </div>
                    <div class="btn_wrap mt10 line">
                        <div class="fl_c">
                            <button class="btnCircle c4" id="btn_lst">취소</button>
                            <button class="btnCircle c2" id="btn_reg">저장</button>
                        </div>
                    </div>
                </div>
			</div><!-- id : contents -->

		</div><!-- id : container -->

		<%@include file="/jsp/include/footer_m.jsp" %>
		
	</div><!-- id : wrap -->

</body>
</html>