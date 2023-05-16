<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.clipsoft.org.apache.commons.codec.binary.Base64"%>
<%@ page import="com.clipsoft.org.apache.commons.io.output.ByteArrayOutputStream"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>

<%
request.setCharacterEncoding("UTF-8");
String fileName = (null == request.getParameter("fileName")) ? "" : request.getParameter("fileName");
fileName = fileName.replaceAll("\r","").replaceAll("\n","");


ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
ServletOutputStream out2 = null;
int j = 0;
try{
	while (true) {
		String data = request.getParameter("fileData"+j);
		//System.out.println("fileName : " + fileName +", "+ "data : " + data);
		
		if (data != null && data.length() > 0) {
			byte[] dataByte = Base64.decodeBase64(data.getBytes());
			outputStream.write(dataByte);
			j++;
		} else
			break;
	}
	
	
	if (outputStream.size() > 0) {
		response.reset();
		response.setContentType("application/vnd.ms-excel;charset=UTF-8");
		String client = request.getHeader("User-Agent");
		//취약점점검 3085 류제성
		String content_length = String.valueOf(outputStream.size());
		
		response.setHeader("Content-Disposition","attachment; filename=\"" + URLEncoder.encode(fileName,"UTF-8").replaceAll("\r", "").replaceAll("\n", "") + "\"");
		response.setHeader("Content-Transfer-Encoding", "binary");
		response.setHeader("Content-Length",content_length);
	
		
		out.clear();
		out = pageContext.pushBody();
		out2 = response.getOutputStream();
		String authYn = (String)session.getAttribute("EXCEL_AUTH_YN");
		if(session.getAttribute("userSession") != null && authYn != null && authYn.equals("Y")){
			out2.write(outputStream.toByteArray());	
		}
		out2.flush();
		out2.close();
	}else{
		return;
	}
}catch(Exception e){
	//	System.out.println("error !!!!");
	throw new Exception("error !!!!");
	//return;
}
finally{
	if(out2 != null) out2.close();
	if(outputStream != null) { 
		try { 
			outputStream.close(); 
		} catch(Exception e) {
			//System.out.println("workbook close error !!!!");
			throw new Exception("workbook close error !!!!");
			//return;
		} 
	}
}
%>