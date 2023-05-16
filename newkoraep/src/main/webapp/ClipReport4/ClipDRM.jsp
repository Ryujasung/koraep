<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File"%>
<%@ page import="com.clipsoft.clipreport.server.service.*" %>
<%@ page import="com.clipsoft.clipreport.server.service.export.*" %>
<%@ page import="com.clipsoft.clipreport.server.service.export.save.SAVEReport" %>
<%@ page import="com.clipsoft.clipreport.server.service.html.PrintHTML" %>
<%@ page import="com.clipsoft.clipreport.server.service.reporteservice.*" %>
<%@include file="Property.jsp"%><%

out.clear();
out=pageContext.pushBody();

//크로스 도메인 설정
//response.setHeader("Access-Control-Allow-Origin", "*");

String passName = request.getParameter("ClipID");
if(null != passName){
	if("R01".equals(passName)){
		NewReport newReport = new NewReport();
		newReport.doPost(request, response, propertyPath);
	}
	else if("R02".equals(passName)){
		Page page1 = new Page();
		page1.doPost(request, response);
	}
	else if("R03".equals(passName)){
		PageCount pageCount = new PageCount();
		pageCount.doPost(request, response);
	}
	else if("R04".equals(passName)){
		DeleteReport deleteReport = new DeleteReport();
		deleteReport.doPost(request, response);
	}
	else if("R05".equals(passName)){
		EXCELReport excelReport = new EXCELReport();
		excelReport.doPost(request, response);
	}
	else if("R06".equals(passName)){
		HTMLReport htmlReport = new HTMLReport();
		htmlReport.doPost(request, response);
	}
	else if("R07".equals(passName)){
		HWPReport hwpReport = new HWPReport();
		hwpReport.doPost(request, response);
	}
	else if("R08".equals(passName)){
		//PDFReport pdfReport = new PDFReport();
		//pdfReport.doPost(request, response);
		
		//인쇄 제어하기 위한 jsp forward 사용 합니다.
		RequestDispatcher dispatcher = request.getRequestDispatcher("export/exportForPrintEncryption.jsp");
		dispatcher.forward(request, response);
	} 
	else if("R09".equals(passName)){
		SAVEReport saveReport = new SAVEReport();
		saveReport.doPost(request, response);
		
		//문서 암호화를 처리하기 위해서는 jsp forward 사용 합니다.
		//RequestDispatcher dispatcher = request.getRequestDispatcher("export/exportForEncryption.jsp");
		//dispatcher.forward(request, response);
		
	} 
	else if("R10".equals(passName)){
		PagePrint page1 = new PagePrint();
		page1.doPost(request, response);
	}
	else if("R11".equals(passName)){
		UpDatePage page1 = new UpDatePage();
		page1.doPost(request, response);
	}
	else if("R15".equals(passName)){
		PrintHTML printHTML = new PrintHTML();
		printHTML.doPost(request, response);
	}
	else if ("R16".equals(passName)) {
		FileDownLoadCheck fileCheck = new FileDownLoadCheck();
		fileCheck.doPost(request, response);
	}
	else if ("R50".equals(passName)) {
		PrintLicense printLicense = new PrintLicense();
		printLicense.doPost(request, response, propertyPath);
	}
	else if ("R51".equals(passName)) {
		UpdateLicense updateLicense = new UpdateLicense();
		updateLicense.doPost(request, response, propertyPath);
	}
	// Report
}
%>