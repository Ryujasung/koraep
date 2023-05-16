
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@page import="com.clipsoft.clipreport.oof.OOFFile"%>
<%@page import="com.clipsoft.clipreport.oof.OOFDocument"%>
<%@page import="java.io.File"%>
<%@page import="com.clipsoft.clipreport.server.service.ReportUtil"%>
<%@page import="com.clipsoft.org.apache.commons.lang.StringEscapeUtils"%>

<%@include file="Property.jsp"%>
<%

OOFDocument oof = OOFDocument.newOOF();
OOFFile file = oof.addFile("crf.root", "%root%/crf/dbtest.crf"); //modify 
file.addConnectionData("*", "oracle1"); //modify 
oof.addField("PMENUGRPCD", "TEST");


String resultKey =  ReportUtil.createReport(request, oof.toString(), "false", "false", "localhost", propertyPath);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="./css/clipreport.css">
<script type='text/javascript' src='./js/clipreport.js'></script>
<!-- 
<script type='text/javascript' src='./js/jquery-1.11.1.js'></script>
 -->
<script type='text/javascript' src='./js/UserConfig.js'></script>
<script type='text/javascript'>
var urlPath = document.location.protocol + "//" + document.location.host;
	
function html2xml(divPath){	
    var reportkey = "<%=resultKey%>";
	var report = createImportJSPReport(urlPath + "/ClipReport4/Clip.jsp", reportkey, document.getElementById(divPath));
	
    //실행
    report.setSlidePage(true);
    report.view();
}

</script>
</head>
<body onload="html2xml('targetDiv1');">
<div id='targetDiv1' style='position:absolute;top:50px;left:0px;height:1500px;width:100%;'>
</div>
</body>
</html>
