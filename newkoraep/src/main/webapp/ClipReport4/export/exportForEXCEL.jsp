<%@page import="com.clipsoft.clipreport.oof.OOFFile"%>
<%@page import="com.clipsoft.clipreport.oof.OOFDocument"%>
<%@page import="com.clipsoft.clipreport.export.option.ExcelOption"%>
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
//File localFileSave = new File("c:\\test.xls");
//OutputStream fileStream = new FileOutputStream(localFileSave);

//클라이언트로 파일을 내릴 때
String fileName = "report.xls";
response.setContentType("application/octet-stream; charset=UTF-8");
response.setHeader("Content-Disposition", "attachment; filename=" + fileName + ";");
OutputStream fileStream = response.getOutputStream();

//클라이언트 브라우져에서 바로 보는 방법(헤더 변경)
//response.setContentType("application/excel");
//OutputStream fileStream = response.getOutputStream();


//엑셀저장에 대한 옵션을 설정합니다.
ExcelOption excelOption = new ExcelOption();
/*  exportMethod {Integer} 
  0 = 페이지 마다 하나의 시트로 
  1 = 페이지를 연속 저장 
  2 = 섹션을 연속하여 저장 
  3 = 리포트마다 섹션을 연속하여 저장 */
 excelOption.setExportMethod(0);  
/* mergeCell {Boolean} 셀 합치기*/
excelOption.setMergeCell(true);
/* mergeEmptyCell {Boolean} 공백 셀일 경우 합치기*/
excelOption.setMergeEmptyCell(false);
/* splitCellAtPageSize {Boolean} 페이지 크기로 셀 분리*/
excelOption.setSplitCellAtPageSize(true);
/* rightToLeft {Boolean} 열이 오른쪽에서 왼쪽으로 진행*/
excelOption.setRightToLeft(false);
/* widthRate {Integer} 가로 비율*/
excelOption.setWidthRate(100);
/* heightRate {Integer} 세로 비율*/
excelOption.setHeightRate(100);
/* coordinateErrorLimit {Integer} 좌표 오차 범위*/
excelOption.setCoordinateErrorLimit(10);
/* processGerenalFormat {Integer}
  0 = 텍스트
  1 = 일반*/
excelOption.setProcessGeneralFormat(0);
/*  printingMagnification {Integer} 인쇄 확대/축소 비율*/
excelOption.setPrintingMagnification(100);
ClipReportExport.createExportForExcel(request, fileStream, propertyPath, oof.toString(), excelOption);
%>