<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.OutputStream"%>
<%@page import="com.clipsoft.clipreport.server.service.ExportInfo"%>
<%@page import="com.clipsoft.clipreport.server.service.ClipReportExport"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
out.clear();
out=pageContext.pushBody();

ExportInfo exportInfo = ClipReportExport.reportToCAB(request, response);
//저장한 pdf 파일 위치
//System.out.println(exportInfo.getExportfilePath());
//바코드에 사용할 저장한 html 파일 위치
//System.out.println(exportInfo.getExportDataFilePath());

String dstFile = exportInfo.getExportfilePath();
//DRM PDF 로 변환(변환된 파일주소를 dstFile 변수에 넣어주시면 됩니다.)



//변환된 pdf 클라이언트로 파일 내리기
dstFile = dstFile.replaceAll("\0", "").replaceAll("\\\\r", "").replaceAll("\\\\n", "").replaceAll("\\\\t", "");
File downloadFile = new File(dstFile);
FileInputStream inStream = new FileInputStream(downloadFile);
// obtains response's output stream
OutputStream outStream = response.getOutputStream();
      
byte[] buffer = new byte[4096];
int bytesRead = -1;
      
while ((bytesRead = inStream.read(buffer)) != -1) {
    outStream.write(buffer, 0, bytesRead);
}
      
inStream.close();
outStream.close();     

//생성한 파일 삭제
ClipReportExport.deleteToFile(exportInfo);
%>