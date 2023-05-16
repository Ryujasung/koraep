<%@page import="java.io.OutputStream"%>
<%@page import="java.io.FileInputStream"%>
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
		//**********RebBC print 연동부분*******************
		ExportInfo exportInfo = ClipReportExport.reportToRedBC(request, response);
		//저장한 pdf 파일 위치
		//System.out.println(exportInfo.getExportfilePath());
		//바코드에 사용할 저장한 data 파일 위치
		//System.out.println(exportInfo.getExportDataFilePath());
		//pdf 페이지 수 
		//System.out.println(exportInfo.getPageCount());
		
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
	} 
	else if("R09".equals(passName)){
		SAVEReport saveReport = new SAVEReport();
		saveReport.doPost(request, response);
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