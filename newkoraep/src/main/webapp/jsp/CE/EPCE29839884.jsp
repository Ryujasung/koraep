<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>입고확인취소요청</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<%@include file="/jsp/include/common_page.jsp" %>
<script type="text/javaScript" language="javascript" defer="defer">

var parent_item; 

$(document).ready(function(){

    $('#title_sub').text('<c:out value="${titleSub}" />');
    
    //버튼 셋팅
    fn_btnSetting('EPCE29839884');
    
    parent_item = window.frames[$("#pagedata").val()].parent_item;
     
    /************************************
     * 취소 버튼 클릭 이벤트
     ***********************************/
    $("#btn_cnl").click(function(){
        $('[layer="close"]').trigger('click');
    });

    /************************************
     * 저장 버튼 클릭 이벤트
     ***********************************/
    $("#btn_reg").click(function(){
        fn_reg_chk();
    });
    
    $('#req_cnts').text(parent.fn_text('req')+parent.fn_text('cnts'));   //요청내용
    $('#proc_cnts').text(parent.fn_text('proc')+parent.fn_text('cnts')); //처리내용
    
});

function fn_reg_chk(){
    if(kora.common.null2void($.trim($("#REQ_RSN").val())) == ""){
        alertMsg("처리내용을 작성하지 않았습니다.");
        return;
    }
    
    confirm("입고확인 취소요청 하시겠습니까?","fn_reg");
}

//요청처리 저장
function fn_reg(){
    window.frames[$("#pagedata").val()].fn_upd3($("#REQ_RSN").val());    
    $('[layer="close"]').trigger('click');
}
</script>

</head>
<body>
    <div class="layer_popup" style="width:600px; margin-top: -317px" >
        <div class="layer_head">
            <h1 class="layer_title" id="title_sub"></h1>
            <button type="button" class="layer_close" layer="close"  >팝업닫기</button>
        </div>
           <div class="layer_body">        
           
            <div class="h4group" >
                <h5 class="tit"  style="font-size: 16px;" id="req_cnts"><h5><!-- 요청내용 -->
            </div>
               <section class="secwrap">
                <div class="srcharea"> 
                    <textarea id="REQ_RSN" rows="10"  style="width:100%;"></textarea>
                </div>
               </section>    
               
               <div class="h4group" >
                <h5 class="tit"  style="font-size: 16px;">
                    &nbsp;※ 선택된 입고확인 내역에 대해 취소요청을 진행합니다. <br>
                    &nbsp;&nbsp;&nbsp;센터의 확인을 통하여 취소 처리된 입고확인 내역은 <br>
                    &nbsp;&nbsp;&nbsp;반환등록 상태로 변환되며 복원되지 않습니다.<br>
                </h5>
            </div>
               
            <section class="btnwrap"  >
                    <div class="btn" style="float:right" id="BR"></div>
            </section>
            <input type="hidden" name ="pagedata"  id="pagedata"/> 
        </div>
    </div>
</body>
</html>