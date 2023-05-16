<%@page import="java.io.OutputStreamWriter"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="com.clipsoft.clipreport.oof.OOFFile"%>
<%@page import="com.clipsoft.clipreport.oof.OOFDocument"%>
<%@page import="com.clipsoft.clipreport.server.service.ClipReportExport"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileOutputStream"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../Property.jsp"%>
<%
out.clear(); // where out is a JspWriter
out = pageContext.pushBody();

//oof 문서 생성
OOFDocument oof = OOFDocument.newOOF();
OOFFile file = oof.addFile("crf.root", "%root%/crf/CLIP.crf");

//리포트 결과가 svg 파일배열로 반환합니다. 
File[] svgFileList = ClipReportExport.createExportForSVGFile(request, propertyPath, oof.toString());

//화면 구성 html 
response.setContentType("text/html");
response.setCharacterEncoding("UTF-8");
OutputStream fileStream = response.getOutputStream();
BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(fileStream, "UTF-8"));


writer.append("<!DOCTYPE html>");
writer.append("<html>");
writer.append("<head>");
writer.append("<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>");
writer.append("<script type='text/javascript'>");
writer.append("var page = 1;");
writer.append("var pageCount = " + svgFileList.length + ";");
writer.append("function selectBefore(){");
writer.append("	if(1 < page){");
writer.append("		document.getElementById('targetId' + page).style.visibility = 'hidden';");
writer.append("		document.getElementById('targetId' + (page-1)).style.visibility = 'visible';");
writer.append("		page--;	");
writer.append("	}");
writer.append("}");

writer.append("function selectNext(){");
writer.append("	if(pageCount > page){");
writer.append("		document.getElementById('targetId' + page).style.visibility = 'hidden';");
writer.append("		document.getElementById('targetId' + (page+1)).style.visibility = 'visible';");
writer.append("		page++;	");
writer.append("	}");
writer.append("}");
writer.append("</script>");
writer.append("</head>");
writer.append("<body>");
writer.append("<div style='position:absolute;left:0px;right:0px;height:40px;'>");
writer.append("<button style='position:absolute;left:10px;top:3px;' onclick='selectBefore()'>이전</button>");
writer.append("<button style='position:absolute;right:10px;top:3px;' onclick='selectNext()'>다음</button>");
writer.append("</div>");

//파일배열의 svg를 String 읽어서 html 로 구성합니다.
for(int i=0; i<svgFileList.length; i++){
	writer.append("<div id='targetId"+(i+1)+"'");
	writer.append("style='position:absolute;left:0px;top:40px;overflow:visible;");
	writer.append("visibility:" + (i==0 ? "visible" : "hidden"));
	writer.append("'>");
	BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(svgFileList[i]), "UTF-8"));
    String s;
    while ((s = in.readLine()) != null) {
    	writer.append(s);
    }
    in.close();
	writer.append("</div>");
}

writer.append("</body>");
writer.append("</html>");

writer.close();
fileStream.close();
//파일 배열 삭제

%>