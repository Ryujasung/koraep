<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>회수증빙자료등록</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=1100, user-scalable=yes">
<%@include file="/jsp/include/common_page_m.jsp" %>

<script type="text/javaScript" language="javascript" defer="defer">
	var parent_item;
	var file_flag = false;
	var INQ_PARAMS;

	$(document).ready(function(){

	    INQ_PARAMS = jsonObject($("#INQ_PARAMS").val());
		parent_item = INQ_PARAMS["WHSDL"];
		
		fn_init();
		 
  	    //날짜 셋팅
  	    $('#RTRVL_DT_C').YJdatepicker({
  	        initDate : kora.common.getDate("yyyy-mm-dd", "D", 0, false).replaceAll('-','')
  	    });
  	    
        /************************************
         * 촬영 버튼 클릭 이벤트
         ***********************************/
        $("#btn_camera").click(function(){
            fn_callAppCamera();
        });
  	  
        /************************************
         * 사진첩 버튼 클릭 이벤트
         ***********************************/
        $("#btn_photo").click(function(){
            fn_callAppPhoto();
        });

        /************************************
         * 사진첩 테스트 버튼 클릭 이벤트
         ***********************************/
        $("#btn_test").click(function(){
            fn_calltest();
        });
		
        /************************************
	 	 * 취소 버튼 클릭 이벤트
	 	 ***********************************/
	 	$("#btn_cnl, #btn_lst2").click(function(){
	 		fn_cnl();
	 	});
	 	
	 	/************************************
	 	 * 저장 버튼 클릭 이벤트
	 	 ***********************************/
	 	$("#btn_reg").click(function(){
	 		fn_reg_chk();
	    });		
	});
	 
	function fn_init() {
	    var varUA = navigator.userAgent.toLowerCase(); //userAgent 값 얻기
	    var fileForm = new Array();
	    var fileBtn = new Array();
	    
	    console.log("varUA : " + varUA);
	    console.log("varUA : " + JSON.stringify(varUA));
	    
	    if ((varUA.match('android') != null) || (varUA.indexOf("iphone")>-1||varUA.indexOf("ipad")>-1||varUA.indexOf("ipod")>-1)) {
            //안드로이드, IOS 일때 처리
            fileForm = new Array();
            fileForm.push("<button class='btn70 c4' id='btn_camera' style='width: 120px;'>촬영</button>&nbsp;&nbsp;<button class='btn70 c3' id='btn_photo' style='width: 120px;'>사진첩</button>");

            fileBtn = new Array();
            fileBtn.push('<button class="btn70 c1" id="btn_cnl" style="width: 120px;">닫기</button>');
	    }
	    else {
		    fileForm = new Array();
    		fileForm.push('<FORM name="fileForm" id="fileForm" method="POST" enctype="MULTIPART/FORM-DATA">');
    		fileForm.push('<div class="btn_attach">');
    		fileForm.push('    <button type="button" class="btn56 c1" style="width: 135px;">파일첨부</button>');
    		fileForm.push('    <input type="file" id="fileUpload10000" name="fileUpload10000" class="btn_file" value="" onchange="fileNameOnChange(this);">');
    		fileForm.push('</div>');
    		fileForm.push('<div class="attach_area">');
    		fileForm.push('    <input type="text" id="attach_file" name="attach_file" class="attach_file" readonly="">');
    		fileForm.push('    <input type="hidden" name="WHSDL_BIZRID" id="WHSDL_BIZRID">');
    		fileForm.push('    <input type="hidden" name="WHSDL_BIZRNO" id="WHSDL_BIZRNO">');
    		fileForm.push('    <input type="hidden" name="RTRVL_DT" id="RTRVL_DT">');
    		fileForm.push('    <input type="hidden" name ="pagedata"  id="pagedata"/>');
    		fileForm.push('    <button type="button" class="btn_delete" onclick="javascript:document.getElementById(\'attach_file\').value=\'\';"></button>');
    		fileForm.push('</div>');
    		fileForm.push('</FORM>');
    		
    		fileBtn = new Array();
    		fileBtn.push('<button class="btn70 c1" id="btn_cnl" style="width: 120px;">취소</button>');
    		fileBtn.push('<button class="btn70 c2" style="width: 220px;" id="btn_reg">등록</button>');
	    }
	    
	    $("#file_upload").html(fileForm);
	    $("#file_btn"   ).html(fileBtn);
	}
	
	//모바일 네이티브 앱 호출 - 사진첩열기(_action_code:3001)
	fn_callAppPhoto = function(stdCntrCd){
	    var sData = {"_action_code":"3001","_action_data":""};
	    var aData = {};
	    
        aData["WHSDL_BIZRID"] = parent_item.WHSDL_BIZRID;
        aData["WHSDL_BIZRNO"] = parent_item.WHSDL_BIZRNO;
        aData["RTRVL_DT"    ] = $("#RTRVL_DT_C").val();  
	    sData["_action_data"] = aData;
	    //alert(JSON.stringify(sData));

	    if(navigator.userAgent.match(/Android/i)) {// 안드로이드
	        window.BrowserBridge.iWebAction(JSON.stringify(sData));
	    }else if(navigator.userAgent.match(/iPhone|iPad|iPod/i)){ // 아이폰
	        alert("iWebAction:" + JSON.stringify(sData));
	    }
	};

	//모바일 네이티브 앱 호출 - 카메라 호출(_action_code:3002)
	fn_callAppCamera = function(stdCntrCd){
	    var sData = {"_action_code":"3002","_action_data":""};
	    var aData = {};
        aData["WHSDL_BIZRID"] = parent_item.WHSDL_BIZRID;
        aData["WHSDL_BIZRNO"] = parent_item.WHSDL_BIZRNO;
        aData["RTRVL_DT"    ] = $("#RTRVL_DT_C").val();  
	    sData["_action_data"] = aData;
	    //alert(JSON.stringify(sData));

	    if(navigator.userAgent.match(/Android/i)) {// 안드로이드
	        window.BrowserBridge.iWebAction(JSON.stringify(sData));
	    }else if(navigator.userAgent.match(/iPhone|iPad|iPod/i)){ // 아이폰
	        alert("iWebAction:" + JSON.stringify(sData));
	    }
	};

    //모바일 네이티브 앱 호출 - 사진첩열기(_action_code:3001)
    fn_calltest = function(stdCntrCd){
        var url = "/MAIN/APP_IMG_SAVE.do";
        
        var aData = {};
        aData["WHSDL_BIZRID"] = parent_item.WHSDL_BIZRID;
        aData["WHSDL_BIZRNO"] = parent_item.WHSDL_BIZRNO;
        aData["RTRVL_DT"    ] = $("#RTRVL_DT_C").val();  

        ajaxPost(url, aData, function(rtnData){
            
            if(rtnData != null && rtnData != ""){
        	    alertMsg("ok");
            } 
            else {
                alertMsg("error");
            }
        });
    };
    
	//모바일 네이티브 앱 호출 후 실행함수
	uf_completeImgUpload = function(rtnData) {
	    //alert(rtnData);
	    
	    if(Object.prototype.toString.call(rtnData) == "[object String]") {
		    rtnData = JSON.parse(rtnData);
	    }

	    alert(rtnData.RSLT_MSG);
	    fn_cnl();
	}
	
	//취소
	function fn_cnl() {
	    kora.common.goPageB('', INQ_PARAMS);
	}
	
    function fn_reg_chk(){
	
	    var fileName = $("#attach_file").val();
	   
		if(fileName == null || fileName == "") {
		 	alert("첨부한 파일이 없습니다.");
		 	return false;
		}
		
		if(!confirm("첨부된 증빙파일을 등록하시겠습니까?")) {
		    return;
		}
		
		fn_reg();
	}
	 
	 //등록 이벤트
	 function fn_reg() {
	    var url ="/WH/EPWH2925888_09.do"
	    var input ="";
	    
	    $("#WHSDL_BIZRID").val(parent_item.WHSDL_BIZRID);
	    $("#WHSDL_BIZRNO").val(parent_item.WHSDL_BIZRNO);
	    $("#RTRVL_DT").val($("#RTRVL_DT_C").val());
	    
	    fileajaxPost(url, input, function(rtnData){
	 		if(rtnData != null && rtnData != ""){
		 		alert(rtnData.RSLT_MSG);
		 		fn_cnl();
	 		} 
	 		else {
	 			alert("error");
	 		}
		});
	 }

	 //업로드한 파일명 셋팅
	 fileNameOnChange = function(obj) {
	     
	     $("#attach_file").val(obj.value);
		 
	     file_flag = true;
	 	 var tmpN = ($(obj).attr("id")).replace("fileUpload","");
	 	 var filename = $("#fileUpload"+tmpN).val().split('/').pop().split('\\').pop();  // 파일명만 추출
	 	 var ext = filename.substring(filename.indexOf(".")+1, filename.length);
	 	 if(filename != '') {
	 		 $("#fileName"+tmpN).val(filename);
	 	     tmpN++;
	 	 }
	 };
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
                <button class="btn_back" id="btn_lst2"><span class="hide">뒤로가기</span></button>
            </div><!-- id : subvisual -->

            <div id="contents">
                <div class="contbox bdn pb55">
                    <div class="tbl">
                        <table>
                            <colgroup>
                                <col style="width: 165px;">
                                <col style="width: auto;">
                            </colgroup>
                            <tbody>
                                <tr class="left">
                                    <th>회수일자</th>
                                    <td>
                                        <div class="calendar">
                                            <input type="text" id="RTRVL_DT_C" style="width: 285px;" readonly><!-- 회수일자  -->
                                        </div>
                                    </td>
                                </tr>
                                <tr class="left">
                                    <th>파일선택</th>
                                    <td>
                                        <div class="row" id="file_upload">
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="btn_wrap mt35" id="contentsBtm">
                    <div class="fl_c" id="file_btn"></div>
                </div>
            </div><!-- id : contents -->

        </div><!-- id : container -->

        <%@include file="/jsp/include/footer_m.jsp" %>

    </div><!-- id : wrap -->
</body>
</html>