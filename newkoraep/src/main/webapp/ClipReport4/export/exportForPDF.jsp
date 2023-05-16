<%@page import="com.clipsoft.clipreport.export.option.PDFOption"%>
<%@page import="com.clipsoft.clipreport.oof.OOFFile"%>
<%@page import="com.clipsoft.clipreport.oof.OOFDocument"%>
<%@page import="com.clipsoft.clipreport.server.service.ClipReportExport"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileOutputStream"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../Property.jsp"%>
<%
OOFDocument oof = OOFDocument.newOOF();
OOFFile file = oof.addFile("crf.root", "%root%/crf/CLIP.crf");

out.clear(); // where out is a JspWriter
out = pageContext.pushBody();

//서버에 파일로 저장 할 때
//File localFileSave = new File("c:\\test.pdf");
//OutputStream fileStream = new FileOutputStream(localFileSave);

//클라이언트로 파일을 내릴 때
//String fileName = "report.pdf";
//response.setContentType("application/octet-stream; charset=UTF-8");
//response.setHeader("Content-Disposition", "attachment; filename=" + fileName + ";");
//OutputStream fileStream = response.getOutputStream();

//클라이언트 브라우져에서 바로 보는 방법(헤더 변경)
response.setContentType("application/pdf");
OutputStream fileStream = response.getOutputStream();

PDFOption option = null;
/*
option = new PDFOption();
option.setUserPassword("사용자(읽기) 암호");
option.setOwnerPassword("저자(쓰기) 암호");
option.setTextToImage(true); // 글자를 이미지로 처리 - unicode 처리시 사용
option.setNumCopies(1); // 프린팅 매수 미리 설정
option.setImportOriginImage(true); // 원본 이미지 삽입
*/


ClipReportExport.createExportForPDF(request, fileStream, propertyPath, oof.toString(), option);
%>