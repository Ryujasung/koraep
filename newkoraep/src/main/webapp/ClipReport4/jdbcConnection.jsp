<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.naming.*, javax.sql.*" %>
<%@ page import="java.security.GeneralSecurityException" %>
<%@ page import="egovframework.common.AES256Util" %>

<%
	response.setContentType("text/html;charset=UTF-8");
	Connection conn = null;
	Statement stmt = null;
	
	/*
		ClassName
		
		SQL_Server 2000 - com.microsoft.jdbc.sqlserver.SQLServerDriver
		SQL_Server 2005, 2008, 2012 - com.microsoft.sqlserver.jdbc.SQLServerDriver
		MySQL - com.mysql.jdbc.Driver
		Oracle - oracle.jdbc.driver.OracleDriver
		Tibero - com.tmax.tibero.jdbc.TbDriver
		
		DB2(Universal JDBC Type 2, 4) - com.ibm.db2.jcc.DB2Driver
	*/
	/*
	String className = "oracle.jdbc.driver.OracleDriver";
	
	String url = "jdbc:oracle:thin:@175.115.52.202:11541:DEVKORA";
	String user = "dwjsC5gTzP38g0MF9RLEAQ==";
	String password = "ZfDHQhwMyXAP5bVTC4lDoA==";
	try {
		Class.forName(className);
		conn = DriverManager.getConnection(url, aes.decrypt(user), aes.decrypt(password));
		out.println("<h3>  JDBC Connection Success</h5>");
		out.println("<h5>- Product Name : " + conn.getMetaData().getDatabaseProductName() + "</h5>");
		out.println("<h5>- Product Version : " + conn.getMetaData().getDatabaseProductVersion() + "</h5>");
		out.println("<h5>- Driver Name : " + conn.getMetaData().getDriverName()+"</h5>");
		out.println("<h5>- Driver Version : " + conn.getMetaData().getDriverVersion()+"</h5>");
	}  catch (GeneralSecurityException e) {
		response.getWriter().append("<h5>GeneralSecurityException Message<h5><br>");
		//e.printStackTrace(response.getWriter());
	}catch (Exception e) {
		response.getWriter().append("<h5>Exception Message<h5><br>");
		//e.printStackTrace(response.getWriter());
	} 
	*/
	
%>