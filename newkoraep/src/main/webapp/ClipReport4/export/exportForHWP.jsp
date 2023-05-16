<%@page import="com.clipsoft.clipreport.oof.OOFFile"%>
<%@page import="com.clipsoft.clipreport.oof.OOFDocument"%>
<%@page import="com.clipsoft.clipreport.export.option.HWPOption"%>
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
File localFileSave = new File("c:\\test.hwp");
OutputStream fileStream = new FileOutputStream(localFileSave);

//클라이언트로 파일을 내릴 때
//String fileName = "report.hwp";
//response.setContentType("application/octet-stream; charset=UTF-8");
//response.setHeader("Content-Disposition", "attachment; filename=" + fileName + ";");
//OutputStream fileStream = response.getOutputStream();

//클라이언트 브라우져에서 바로 보는 방법(헤더 변경)
//response.setContentType("application/hwp");
//OutputStream fileStream = response.getOutputStream();


//한글저장에 대한 옵션을 설정합니다.
HWPOption hwpOption = new HWPOption();
/* fixSize {Boolean} 크기 고정*/
hwpOption.setFixSize(true);
/* allowOverlay {Boolean} 겹침 허용*/
hwpOption.setAllowOverlay(true);
/* setPageBottomMarginToZero {Boolean} 페이지 바닥 여백을 0으로 설정*/
hwpOption.setSetPageBottomMarginToZero(true);
/* outputLikeWord {Boolean} 글자처럼 출력*/
hwpOption.setOutputLikeWord(false);
/* tableSplitMethod {Integer}
 0 = 나눔 
 1 = 셀 단위로 나눔 
 2 = 나누지 않음 */
 hwpOption.setTableSplitMethod(1);
/* defaultCharGap {Integer} 기본 자간*/
hwpOption.setDefaultCharGap(-8);
/* charRatio {Integer} 자평*/
hwpOption.setCharRatio(100);
/* putCheckboxIntoCell (Boolean) 셀 안에 체크박스 넣기 */
hwpOption.setPutCheckboxIntoCell(false);

ClipReportExport.createExportForHWP(request, fileStream, propertyPath, oof.toString(), hwpOption);
%>