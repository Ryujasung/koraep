<%@page import="org.apache.commons.io.IOUtils"%>
<%@page import="org.apache.commons.codec.binary.StringUtils"%>
<%@page import="org.apache.commons.codec.binary.Base64"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.io.File"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.FileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.io.*"%>
<%@page import="java.util.UUID"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String sFileInfo = "";
	String name = request.getHeader("file-name");
	name = name.replaceAll("\0", "").replaceAll("\\\\r", "").replaceAll("\\\\n", "").replaceAll("\\\\t", "");
	String ext = name.substring(name.lastIndexOf(".")+1);
	
	InputStream is = request.getInputStream();
	byte b[] = IOUtils.toByteArray(is);

	String base64DataString = Base64.encodeBase64String(b);
	
	base64DataString = "data:image/" + ext + ";base64," + base64DataString;
	
	if(is != null) {
	  is.close();
	}
	sFileInfo += "&bNewLine=true&sFileName="+ name+"&sFileURL="+ base64DataString;
	out.println(sFileInfo);

%>