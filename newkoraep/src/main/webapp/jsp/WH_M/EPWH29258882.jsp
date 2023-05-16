<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>회수증빙자료 다운로드</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=1100, user-scalable=yes">
<%@include file="/jsp/include/common_page_m.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">
    var parent_item;
    var toDay = kora.common.gfn_toDay();  // 현재 시간
    var file_flag = false;
    var INQ_PARAMS;
    var tmpData = {};

    $(document).ready(function(){

        INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
        parent_item = INQ_PARAMS["WHSDL"];
        
        fn_init();
         
        /************************************
         * 삭제 버튼 클릭 이벤트
         ***********************************/
        $("#btn_del").click(function(){
            fn_del_chk();
        });
      
        
        /************************************
         * 목록 클릭 이벤트
         ***********************************/
        $("#btn_lst").click(function(){
            fn_lst();
        });
    });
    
    function fn_init() {
	   var path = parent_item.FILE_PATH;
	   path = path.substr(path.indexOf("/data_file/"));
	   
	   $("#RTRVL_DT_C").text(kora.common.formatter.datetime(parent_item.RTRVL_DT,"yyyy-mm-dd"));
	   $("#photo_img").attr("src",path + "/" +parent_item.SAVE_FILE_NM);
	   //$("#photo_img").attr("src","/data_file/file_up/12345671/"+parent_item.SAVE_FILE_NM);

    }
    
    //취소
    function fn_lst() {
        kora.common.goPageB('', INQ_PARAMS);
    }

    function fn_del_chk() {
	
        if(!confirm("증빙파일을 삭제 하시겠습니까?")) {
            return;
        }
        
        fn_del();
    }
    
    //회수정보 삭제
    function fn_del(){
        var url             = "/WH/EPWH2925897_04.do"; 
        var input = {};
        
        input["WHSDL_BIZRID"] = parent_item.WHSDL_BIZRID;       
        input["WHSDL_BIZRNO"] = parent_item.WHSDL_BIZRNO;       
        input["RTRVL_DT"] = parent_item.RTRVL_DT;       
        input["DTL_SN"]   = parent_item.DTL_SN;
        
        ajaxPost(url, input, function(rtnData){
            
            if(rtnData.RSLT_CD == "0000"){
                alert(rtnData.RSLT_MSG);
                fn_lst();
            }else{
                alert(rtnData.RSLT_MSG);
            }
        });    
    }
</script>
</head>
<body>

    <input type="hidden" id="INQ_PARAMS" value="<c:out value='${INQ_PARAMS}' />" />
    <div id="wrap">
    
        <%@include file="/jsp/include/header_m.jsp" %>
        
        <%@include file="/jsp/include/aside_m.jsp" %>

        <div id="container">

            <div id="subvisual">
                <h2 class="tit" id="title"></h2>
                <button class="btn_back" id="btn_lst"><span class="hide">뒤로가기</span></button>
            </div><!-- id : subvisual -->

            <div id="contents">
                <div class="contbox bdn pb55">
                    <div class="tbl">
                        <table>
                            <colgroup>
                                <col style="width: 200px;">
                                <col style="width: auto;">
                            </colgroup>
                            <tbody>
                                <tr class="left">
                                    <th>회수일자</th>
                                    <td>
                                        <div class="calendar" id="RTRVL_DT_C"></div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <div class="row" id="RTRVL_PHOTO" style="text-align: center;">
                                        <img id="photo_img" style="max-width:610px">
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <div class="btn_wrap mt35" id="contentsBtm">
                    <div class="fl_c">
                        <button class="btn70 c1" style="width: 220px;" id="btn_del">첨부파일 삭제</button>
                    </div>
                </div>
                
            </div><!-- id : contents -->

        </div><!-- id : container -->

        <%@include file="/jsp/include/footer_m.jsp" %>

    </div><!-- id : wrap -->
</body>
</html>
