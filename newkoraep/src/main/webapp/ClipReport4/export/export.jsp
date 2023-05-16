<%@page import="com.clipsoft.clipreport.oof.OOFFile"%>
<%@page import="com.clipsoft.clipreport.oof.OOFDocument"%>
<%@page import="com.clipsoft.clipreport.server.service.ClipReportExport"%>
<%@page import="com.clipsoft.clipreport.export.option.*" %>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileOutputStream"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../Property.jsp"%>
<%
OOFDocument oof = OOFDocument.newOOF();
OOFFile file = oof.addFile("crf.root", "%root%/crf/CLIP.crf");

String[] fileNames  = new String[3];
fileNames[0] = "pdf입니다";
fileNames[1] = "pdf입니다1";
fileNames[2] = "pdfTestTest";


out.clear(); // where out is a JspWriter
out = pageContext.pushBody();

PDFOption option = new PDFOption(); 
ClipReportExport.createExportForPDF(request, response, propertyPath, oof.toString(), 100, "report", fileNames, option);
//ClipReportExport.createExportForPDF(request, response, propertyPath, oofString.toString());
%>