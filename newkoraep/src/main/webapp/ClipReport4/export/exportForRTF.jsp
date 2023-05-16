<%@page import="com.clipsoft.clipreport.export.option.RTFOption"%>
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
File localFileSave = new File("c:\\test.doc");
OutputStream fileStream = new FileOutputStream(localFileSave);

//클라이언트로 파일을 내릴 때
//String fileName = "report.doc";
//response.setContentType("application/octet-stream; charset=UTF-8");
//response.setHeader("Content-Disposition", "attachment; filename=" + fileName + ";");
//OutputStream fileStream = response.getOutputStream();

        
//DOC 저장에 대한 옵션을 설정합니다.
RTFOption rtfOption = new RTFOption();

//기본 자간
rtfOption.setDefaultCharSpace(-0.5f);
//균등 분할 처리 방법
//0=왼쪽 정렬
//1=오른쪽 정렬
//2=가운데 정렬
//3=양쪽 정렬
rtfOption.setProcessEqualAlign(3);
//이웃한 테이블과 병합할 것인지 여부
rtfOption.setMergeTable(true);
//리포트에 출력된 것 처럼 문자열을 여러줄로 잘라서 표현할지 여부
rtfOption.setSplitTextByLine(true);
//text을  유니코드로 처리할지 여부
rtfOption.setProcessAsUnicode(true);
//테이블을 감싸는 객체와 테이블의 아래쪽 간격
rtfOption.setTableWrapperBottomGap(0);


ClipReportExport.createExportForRTF(request, fileStream, propertyPath, oof.toString(), rtfOption);
%>