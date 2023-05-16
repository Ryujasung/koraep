<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.net.URLEncoder, java.net.URLDecoder" %>
<%@page import="com.clipsoft.clipreport.oof.OOFFile"%>
<%@page import="com.clipsoft.clipreport.oof.OOFDocument"%>
<%@page import="java.io.File"%>
<%@page import="com.clipsoft.clipreport.server.service.ReportUtil"%>
<%@page import="com.clipsoft.org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="egovframework.common.util"%>

<%@include file="Property.jsp"%>
<%
	request.setCharacterEncoding("UTF-8");
	String crf = "";	//리포트 파일명
	OOFDocument oof = OOFDocument.newOOF();
	String saveYn = "N";

	Enumeration en = request.getParameterNames();
	while (en.hasMoreElements()) {
	    String element = (String) en.nextElement();

        if(!element.startsWith("{")) {
            continue;   
        }
        
	    JSONObject jParams = JSONObject.fromObject(element);
        
        System.out.println("ddddddddddd : " + element);
	    
        HashMap<String, String> jmap = util.jsonToMap(jParams);
        
        
        Set set = jmap.keySet();

        Iterator iterator = set.iterator();

        while(iterator.hasNext()){

            String key = (String)iterator.next();
            String value = jmap.get(key);
            
            System.out.println("hashMap Key : " + key +", " + value);
            
            //String value = request.getParameter(key);
            
            value = value.replaceAll("\0", "").replaceAll("\\\\r", "").replaceAll("\\\\n", "").replaceAll("\\\\t", "");
            
            if(key.equals("CRF_NAME")){
                crf = value;
            }else if(key.equals("SAVE_YN")){
                saveYn = value;
            }else{
                oof.addField(key, URLDecoder.decode(value,"UTF-8"));
            }
        }
	}
	
	OOFFile file = oof.addFile("crf.root", "%root%/crf/" + crf); //modify 
	//file.addConnectionData("*", "oracle1"); // local
	file.addConnectionData("*", "oraclejndi"); // 운영, 개발

	String resultKey =  ReportUtil.createReport(request, oof.toString(), "false", "false", "localhost", propertyPath);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />
<link rel="stylesheet" type="text/css" href="./css/clipreport.css">
<script type='text/javascript' src='./js/clipreport.js'></script>
<script type='text/javascript' src='./js/UserConfig.js'></script>
<script src="/js/jquery/jquery-latest.js" charset="utf-8"></script>
<script src="/js/kora/kora_common.js" charset="utf-8"></script>
<script type='text/javascript'>
window.focus();

var urlPath = document.location.protocol + "//" + document.location.host;
var saveYn = "<%=saveYn%>";
var prntUrl = opener.gUrl;
$(document).ready(function(){
	html2xml('targetDiv1');	//리포트 뷰어 호출
	
});

//리포트 뷰어
function html2xml(divPath){	
    var reportkey = "<%=resultKey%>";
	//var report = createImportJSPReport(urlPath + "/ClipReport4/Clip.jsp?_csrf=" + gtoken, reportkey, document.getElementById(divPath));
	var report = createImportJSPReport(urlPath + "/ClipReport4/Clip.jsp", reportkey, document.getElementById(divPath));
	
    //실행
    report.setSlidePage(true);
    report.view();
    
    fn_setBtn();	//저장버튼 숨기기 기능
}

//저장버튼 숨기기 보이기(pdf만)
function fn_setBtn(){
	$(".report_menu_save_button").hide();
	if(saveYn != "Y"){
		$(".report_menu_pdf_button").hide();
	}else{
		$(".report_menu_pdf_button").bind("click", function(){//인쇄이력
			fn_setLog('F');	//pdf저장 이력
		});
	}
	
	$(".report_menu_excel_button").hide();
	$(".report_menu_hwp_button").hide();
	
	$(".report_menu_close_button").attr("onclick", "javascript:self.close();");	//닫기
	$(".report_menu_print_button").bind("click", function(){//인쇄이력
		$(".report_view_button").each(function(){
			if($(this).attr("title") == "인쇄"){
				$(this).bind("click", function(){
					fn_setLog('P');
				});
			}
		});
	});
	
}

//실행 이력 로그 남기기
function fn_setLog(div){
	if(prntUrl == null || prntUrl == "") return;
	if(prntUrl.indexOf("/") > -1) prntUrl = prntUrl.substring(prntUrl.lastIndexOf("/")+1, prntUrl.length);
	if(prntUrl.indexOf(".") > -1) prntUrl = prntUrl.substring(0, prntUrl.lastIndexOf("."));
	
	var CALL_URL = "/" + prntUrl.substring(0,4) + "/" + prntUrl + ".DO";
	var sData = {"CALL_URL":CALL_URL, "MENU_ID":prntUrl, "HIST_PRCS_SE":div};
	ajaxPost("/CALL_PRNT_LOG.do", sData, function(data){	});
}

</script>
</head>
<body>
<div id='targetDiv1' style='position:absolute;top:0px;left:0px;height:1500px;width:100%;'>
</div>
</body>
</html>
